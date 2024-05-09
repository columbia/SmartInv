1 // SPDX-License-Identifier: MIT
2 
3 // File: @openzeppelin/contracts/security/ReentrancyGuard.sol
4 
5 
6 // OpenZeppelin Contracts v4.4.1 (security/ReentrancyGuard.sol)
7 
8 pragma solidity ^0.8.0;
9 
10 /**
11  * @dev Contract module that helps prevent reentrant calls to a function.
12  *
13  * Inheriting from `ReentrancyGuard` will make the {nonReentrant} modifier
14  * available, which can be applied to functions to make sure there are no nested
15  * (reentrant) calls to them.
16  *
17  * Note that because there is a single `nonReentrant` guard, functions marked as
18  * `nonReentrant` may not call one another. This can be worked around by making
19  * those functions `private`, and then adding `external` `nonReentrant` entry
20  * points to them.
21  *
22  * TIP: If you would like to learn more about reentrancy and alternative ways
23  * to protect against it, check out our blog post
24  * https://blog.openzeppelin.com/reentrancy-after-istanbul/[Reentrancy After Istanbul].
25  */
26 abstract contract ReentrancyGuard {
27     // Booleans are more expensive than uint256 or any type that takes up a full
28     // word because each write operation emits an extra SLOAD to first read the
29     // slot's contents, replace the bits taken up by the boolean, and then write
30     // back. This is the compiler's defense against contract upgrades and
31     // pointer aliasing, and it cannot be disabled.
32 
33     // The values being non-zero value makes deployment a bit more expensive,
34     // but in exchange the refund on every call to nonReentrant will be lower in
35     // amount. Since refunds are capped to a percentage of the total
36     // transaction's gas, it is best to keep them low in cases like this one, to
37     // increase the likelihood of the full refund coming into effect.
38     uint256 private constant _NOT_ENTERED = 1;
39     uint256 private constant _ENTERED = 2;
40 
41     uint256 private _status;
42 
43     constructor() {
44         _status = _NOT_ENTERED;
45     }
46 
47     /**
48      * @dev Prevents a contract from calling itself, directly or indirectly.
49      * Calling a `nonReentrant` function from another `nonReentrant`
50      * function is not supported. It is possible to prevent this from happening
51      * by making the `nonReentrant` function external, and making it call a
52      * `private` function that does the actual work.
53      */
54     modifier nonReentrant() {
55         // On the first call to nonReentrant, _notEntered will be true
56         require(_status != _ENTERED, "ReentrancyGuard: reentrant call");
57 
58         // Any calls to nonReentrant after this point will fail
59         _status = _ENTERED;
60 
61         _;
62 
63         // By storing the original value once again, a refund is triggered (see
64         // https://eips.ethereum.org/EIPS/eip-2200)
65         _status = _NOT_ENTERED;
66     }
67 }
68 
69 // File: @openzeppelin/contracts/utils/cryptography/MerkleProof.sol
70 
71 
72 // OpenZeppelin Contracts (last updated v4.5.0) (utils/cryptography/MerkleProof.sol)
73 
74 pragma solidity ^0.8.0;
75 
76 /**
77  * @dev These functions deal with verification of Merkle Trees proofs.
78  *
79  * The proofs can be generated using the JavaScript library
80  * https://github.com/miguelmota/merkletreejs[merkletreejs].
81  * Note: the hashing algorithm should be keccak256 and pair sorting should be enabled.
82  *
83  * See `test/utils/cryptography/MerkleProof.test.js` for some examples.
84  */
85 library MerkleProof {
86     /**
87      * @dev Returns true if a `leaf` can be proved to be a part of a Merkle tree
88      * defined by `root`. For this, a `proof` must be provided, containing
89      * sibling hashes on the branch from the leaf to the root of the tree. Each
90      * pair of leaves and each pair of pre-images are assumed to be sorted.
91      */
92     function verify(
93         bytes32[] memory proof,
94         bytes32 root,
95         bytes32 leaf
96     ) internal pure returns (bool) {
97         return processProof(proof, leaf) == root;
98     }
99 
100     /**
101      * @dev Returns the rebuilt hash obtained by traversing a Merklee tree up
102      * from `leaf` using `proof`. A `proof` is valid if and only if the rebuilt
103      * hash matches the root of the tree. When processing the proof, the pairs
104      * of leafs & pre-images are assumed to be sorted.
105      *
106      * _Available since v4.4._
107      */
108     function processProof(bytes32[] memory proof, bytes32 leaf) internal pure returns (bytes32) {
109         bytes32 computedHash = leaf;
110         for (uint256 i = 0; i < proof.length; i++) {
111             bytes32 proofElement = proof[i];
112             if (computedHash <= proofElement) {
113                 // Hash(current computed hash + current element of the proof)
114                 computedHash = _efficientHash(computedHash, proofElement);
115             } else {
116                 // Hash(current element of the proof + current computed hash)
117                 computedHash = _efficientHash(proofElement, computedHash);
118             }
119         }
120         return computedHash;
121     }
122 
123     function _efficientHash(bytes32 a, bytes32 b) private pure returns (bytes32 value) {
124         assembly {
125             mstore(0x00, a)
126             mstore(0x20, b)
127             value := keccak256(0x00, 0x40)
128         }
129     }
130 }
131 
132 // File: @openzeppelin/contracts/utils/Strings.sol
133 
134 
135 // OpenZeppelin Contracts v4.4.1 (utils/Strings.sol)
136 
137 pragma solidity ^0.8.0;
138 
139 /**
140  * @dev String operations.
141  */
142 library Strings {
143     bytes16 private constant _HEX_SYMBOLS = "0123456789abcdef";
144 
145     /**
146      * @dev Converts a `uint256` to its ASCII `string` decimal representation.
147      */
148     function toString(uint256 value) internal pure returns (string memory) {
149         // Inspired by OraclizeAPI's implementation - MIT licence
150         // https://github.com/oraclize/ethereum-api/blob/b42146b063c7d6ee1358846c198246239e9360e8/oraclizeAPI_0.4.25.sol
151 
152         if (value == 0) {
153             return "0";
154         }
155         uint256 temp = value;
156         uint256 digits;
157         while (temp != 0) {
158             digits++;
159             temp /= 10;
160         }
161         bytes memory buffer = new bytes(digits);
162         while (value != 0) {
163             digits -= 1;
164             buffer[digits] = bytes1(uint8(48 + uint256(value % 10)));
165             value /= 10;
166         }
167         return string(buffer);
168     }
169 
170     /**
171      * @dev Converts a `uint256` to its ASCII `string` hexadecimal representation.
172      */
173     function toHexString(uint256 value) internal pure returns (string memory) {
174         if (value == 0) {
175             return "0x00";
176         }
177         uint256 temp = value;
178         uint256 length = 0;
179         while (temp != 0) {
180             length++;
181             temp >>= 8;
182         }
183         return toHexString(value, length);
184     }
185 
186     /**
187      * @dev Converts a `uint256` to its ASCII `string` hexadecimal representation with fixed length.
188      */
189     function toHexString(uint256 value, uint256 length) internal pure returns (string memory) {
190         bytes memory buffer = new bytes(2 * length + 2);
191         buffer[0] = "0";
192         buffer[1] = "x";
193         for (uint256 i = 2 * length + 1; i > 1; --i) {
194             buffer[i] = _HEX_SYMBOLS[value & 0xf];
195             value >>= 4;
196         }
197         require(value == 0, "Strings: hex length insufficient");
198         return string(buffer);
199     }
200 }
201 
202 // File: @openzeppelin/contracts/utils/Context.sol
203 
204 
205 // OpenZeppelin Contracts v4.4.1 (utils/Context.sol)
206 
207 pragma solidity ^0.8.0;
208 
209 /**
210  * @dev Provides information about the current execution context, including the
211  * sender of the transaction and its data. While these are generally available
212  * via msg.sender and msg.data, they should not be accessed in such a direct
213  * manner, since when dealing with meta-transactions the account sending and
214  * paying for execution may not be the actual sender (as far as an application
215  * is concerned).
216  *
217  * This contract is only required for intermediate, library-like contracts.
218  */
219 abstract contract Context {
220     function _msgSender() internal view virtual returns (address) {
221         return msg.sender;
222     }
223 
224     function _msgData() internal view virtual returns (bytes calldata) {
225         return msg.data;
226     }
227 }
228 
229 // File: @openzeppelin/contracts/access/Ownable.sol
230 
231 
232 // OpenZeppelin Contracts v4.4.1 (access/Ownable.sol)
233 
234 pragma solidity ^0.8.0;
235 
236 
237 /**
238  * @dev Contract module which provides a basic access control mechanism, where
239  * there is an account (an owner) that can be granted exclusive access to
240  * specific functions.
241  *
242  * By default, the owner account will be the one that deploys the contract. This
243  * can later be changed with {transferOwnership}.
244  *
245  * This module is used through inheritance. It will make available the modifier
246  * `onlyOwner`, which can be applied to your functions to restrict their use to
247  * the owner.
248  */
249 abstract contract Ownable is Context {
250     address private _owner;
251 
252     event OwnershipTransferred(address indexed previousOwner, address indexed newOwner);
253 
254     /**
255      * @dev Initializes the contract setting the deployer as the initial owner.
256      */
257     constructor() {
258         _transferOwnership(_msgSender());
259     }
260 
261     /**
262      * @dev Returns the address of the current owner.
263      */
264     function owner() public view virtual returns (address) {
265         return _owner;
266     }
267 
268     /**
269      * @dev Throws if called by any account other than the owner.
270      */
271     modifier onlyOwner() {
272         require(owner() == _msgSender(), "Ownable: caller is not the owner");
273         _;
274     }
275 
276     /**
277      * @dev Leaves the contract without owner. It will not be possible to call
278      * `onlyOwner` functions anymore. Can only be called by the current owner.
279      *
280      * NOTE: Renouncing ownership will leave the contract without an owner,
281      * thereby removing any functionality that is only available to the owner.
282      */
283     function renounceOwnership() public virtual onlyOwner {
284         _transferOwnership(address(0));
285     }
286 
287     /**
288      * @dev Transfers ownership of the contract to a new account (`newOwner`).
289      * Can only be called by the current owner.
290      */
291     function transferOwnership(address newOwner) public virtual onlyOwner {
292         require(newOwner != address(0), "Ownable: new owner is the zero address");
293         _transferOwnership(newOwner);
294     }
295 
296     /**
297      * @dev Transfers ownership of the contract to a new account (`newOwner`).
298      * Internal function without access restriction.
299      */
300     function _transferOwnership(address newOwner) internal virtual {
301         address oldOwner = _owner;
302         _owner = newOwner;
303         emit OwnershipTransferred(oldOwner, newOwner);
304     }
305 }
306 
307 // File: @openzeppelin/contracts/utils/Address.sol
308 
309 
310 // OpenZeppelin Contracts (last updated v4.5.0) (utils/Address.sol)
311 
312 pragma solidity ^0.8.1;
313 
314 /**
315  * @dev Collection of functions related to the address type
316  */
317 library Address {
318     /**
319      * @dev Returns true if `account` is a contract.
320      *
321      * [IMPORTANT]
322      * ====
323      * It is unsafe to assume that an address for which this function returns
324      * false is an externally-owned account (EOA) and not a contract.
325      *
326      * Among others, `isContract` will return false for the following
327      * types of addresses:
328      *
329      *  - an externally-owned account
330      *  - a contract in construction
331      *  - an address where a contract will be created
332      *  - an address where a contract lived, but was destroyed
333      * ====
334      *
335      * [IMPORTANT]
336      * ====
337      * You shouldn't rely on `isContract` to protect against flash loan attacks!
338      *
339      * Preventing calls from contracts is highly discouraged. It breaks composability, breaks support for smart wallets
340      * like Gnosis Safe, and does not provide security since it can be circumvented by calling from a contract
341      * constructor.
342      * ====
343      */
344     function isContract(address account) internal view returns (bool) {
345         // This method relies on extcodesize/address.code.length, which returns 0
346         // for contracts in construction, since the code is only stored at the end
347         // of the constructor execution.
348 
349         return account.code.length > 0;
350     }
351 
352     /**
353      * @dev Replacement for Solidity's `transfer`: sends `amount` wei to
354      * `recipient`, forwarding all available gas and reverting on errors.
355      *
356      * https://eips.ethereum.org/EIPS/eip-1884[EIP1884] increases the gas cost
357      * of certain opcodes, possibly making contracts go over the 2300 gas limit
358      * imposed by `transfer`, making them unable to receive funds via
359      * `transfer`. {sendValue} removes this limitation.
360      *
361      * https://diligence.consensys.net/posts/2019/09/stop-using-soliditys-transfer-now/[Learn more].
362      *
363      * IMPORTANT: because control is transferred to `recipient`, care must be
364      * taken to not create reentrancy vulnerabilities. Consider using
365      * {ReentrancyGuard} or the
366      * https://solidity.readthedocs.io/en/v0.5.11/security-considerations.html#use-the-checks-effects-interactions-pattern[checks-effects-interactions pattern].
367      */
368     function sendValue(address payable recipient, uint256 amount) internal {
369         require(address(this).balance >= amount, "Address: insufficient balance");
370 
371         (bool success, ) = recipient.call{value: amount}("");
372         require(success, "Address: unable to send value, recipient may have reverted");
373     }
374 
375     /**
376      * @dev Performs a Solidity function call using a low level `call`. A
377      * plain `call` is an unsafe replacement for a function call: use this
378      * function instead.
379      *
380      * If `target` reverts with a revert reason, it is bubbled up by this
381      * function (like regular Solidity function calls).
382      *
383      * Returns the raw returned data. To convert to the expected return value,
384      * use https://solidity.readthedocs.io/en/latest/units-and-global-variables.html?highlight=abi.decode#abi-encoding-and-decoding-functions[`abi.decode`].
385      *
386      * Requirements:
387      *
388      * - `target` must be a contract.
389      * - calling `target` with `data` must not revert.
390      *
391      * _Available since v3.1._
392      */
393     function functionCall(address target, bytes memory data) internal returns (bytes memory) {
394         return functionCall(target, data, "Address: low-level call failed");
395     }
396 
397     /**
398      * @dev Same as {xref-Address-functionCall-address-bytes-}[`functionCall`], but with
399      * `errorMessage` as a fallback revert reason when `target` reverts.
400      *
401      * _Available since v3.1._
402      */
403     function functionCall(
404         address target,
405         bytes memory data,
406         string memory errorMessage
407     ) internal returns (bytes memory) {
408         return functionCallWithValue(target, data, 0, errorMessage);
409     }
410 
411     /**
412      * @dev Same as {xref-Address-functionCall-address-bytes-}[`functionCall`],
413      * but also transferring `value` wei to `target`.
414      *
415      * Requirements:
416      *
417      * - the calling contract must have an ETH balance of at least `value`.
418      * - the called Solidity function must be `payable`.
419      *
420      * _Available since v3.1._
421      */
422     function functionCallWithValue(
423         address target,
424         bytes memory data,
425         uint256 value
426     ) internal returns (bytes memory) {
427         return functionCallWithValue(target, data, value, "Address: low-level call with value failed");
428     }
429 
430     /**
431      * @dev Same as {xref-Address-functionCallWithValue-address-bytes-uint256-}[`functionCallWithValue`], but
432      * with `errorMessage` as a fallback revert reason when `target` reverts.
433      *
434      * _Available since v3.1._
435      */
436     function functionCallWithValue(
437         address target,
438         bytes memory data,
439         uint256 value,
440         string memory errorMessage
441     ) internal returns (bytes memory) {
442         require(address(this).balance >= value, "Address: insufficient balance for call");
443         require(isContract(target), "Address: call to non-contract");
444 
445         (bool success, bytes memory returndata) = target.call{value: value}(data);
446         return verifyCallResult(success, returndata, errorMessage);
447     }
448 
449     /**
450      * @dev Same as {xref-Address-functionCall-address-bytes-}[`functionCall`],
451      * but performing a static call.
452      *
453      * _Available since v3.3._
454      */
455     function functionStaticCall(address target, bytes memory data) internal view returns (bytes memory) {
456         return functionStaticCall(target, data, "Address: low-level static call failed");
457     }
458 
459     /**
460      * @dev Same as {xref-Address-functionCall-address-bytes-string-}[`functionCall`],
461      * but performing a static call.
462      *
463      * _Available since v3.3._
464      */
465     function functionStaticCall(
466         address target,
467         bytes memory data,
468         string memory errorMessage
469     ) internal view returns (bytes memory) {
470         require(isContract(target), "Address: static call to non-contract");
471 
472         (bool success, bytes memory returndata) = target.staticcall(data);
473         return verifyCallResult(success, returndata, errorMessage);
474     }
475 
476     /**
477      * @dev Same as {xref-Address-functionCall-address-bytes-}[`functionCall`],
478      * but performing a delegate call.
479      *
480      * _Available since v3.4._
481      */
482     function functionDelegateCall(address target, bytes memory data) internal returns (bytes memory) {
483         return functionDelegateCall(target, data, "Address: low-level delegate call failed");
484     }
485 
486     /**
487      * @dev Same as {xref-Address-functionCall-address-bytes-string-}[`functionCall`],
488      * but performing a delegate call.
489      *
490      * _Available since v3.4._
491      */
492     function functionDelegateCall(
493         address target,
494         bytes memory data,
495         string memory errorMessage
496     ) internal returns (bytes memory) {
497         require(isContract(target), "Address: delegate call to non-contract");
498 
499         (bool success, bytes memory returndata) = target.delegatecall(data);
500         return verifyCallResult(success, returndata, errorMessage);
501     }
502 
503     /**
504      * @dev Tool to verifies that a low level call was successful, and revert if it wasn't, either by bubbling the
505      * revert reason using the provided one.
506      *
507      * _Available since v4.3._
508      */
509     function verifyCallResult(
510         bool success,
511         bytes memory returndata,
512         string memory errorMessage
513     ) internal pure returns (bytes memory) {
514         if (success) {
515             return returndata;
516         } else {
517             // Look for revert reason and bubble it up if present
518             if (returndata.length > 0) {
519                 // The easiest way to bubble the revert reason is using memory via assembly
520 
521                 assembly {
522                     let returndata_size := mload(returndata)
523                     revert(add(32, returndata), returndata_size)
524                 }
525             } else {
526                 revert(errorMessage);
527             }
528         }
529     }
530 }
531 
532 // File: @openzeppelin/contracts/token/ERC721/IERC721Receiver.sol
533 
534 
535 // OpenZeppelin Contracts v4.4.1 (token/ERC721/IERC721Receiver.sol)
536 
537 pragma solidity ^0.8.0;
538 
539 /**
540  * @title ERC721 token receiver interface
541  * @dev Interface for any contract that wants to support safeTransfers
542  * from ERC721 asset contracts.
543  */
544 interface IERC721Receiver {
545     /**
546      * @dev Whenever an {IERC721} `tokenId` token is transferred to this contract via {IERC721-safeTransferFrom}
547      * by `operator` from `from`, this function is called.
548      *
549      * It must return its Solidity selector to confirm the token transfer.
550      * If any other value is returned or the interface is not implemented by the recipient, the transfer will be reverted.
551      *
552      * The selector can be obtained in Solidity with `IERC721.onERC721Received.selector`.
553      */
554     function onERC721Received(
555         address operator,
556         address from,
557         uint256 tokenId,
558         bytes calldata data
559     ) external returns (bytes4);
560 }
561 
562 // File: @openzeppelin/contracts/utils/introspection/IERC165.sol
563 
564 
565 // OpenZeppelin Contracts v4.4.1 (utils/introspection/IERC165.sol)
566 
567 pragma solidity ^0.8.0;
568 
569 /**
570  * @dev Interface of the ERC165 standard, as defined in the
571  * https://eips.ethereum.org/EIPS/eip-165[EIP].
572  *
573  * Implementers can declare support of contract interfaces, which can then be
574  * queried by others ({ERC165Checker}).
575  *
576  * For an implementation, see {ERC165}.
577  */
578 interface IERC165 {
579     /**
580      * @dev Returns true if this contract implements the interface defined by
581      * `interfaceId`. See the corresponding
582      * https://eips.ethereum.org/EIPS/eip-165#how-interfaces-are-identified[EIP section]
583      * to learn more about how these ids are created.
584      *
585      * This function call must use less than 30 000 gas.
586      */
587     function supportsInterface(bytes4 interfaceId) external view returns (bool);
588 }
589 
590 // File: @openzeppelin/contracts/utils/introspection/ERC165.sol
591 
592 
593 // OpenZeppelin Contracts v4.4.1 (utils/introspection/ERC165.sol)
594 
595 pragma solidity ^0.8.0;
596 
597 
598 /**
599  * @dev Implementation of the {IERC165} interface.
600  *
601  * Contracts that want to implement ERC165 should inherit from this contract and override {supportsInterface} to check
602  * for the additional interface id that will be supported. For example:
603  *
604  * ```solidity
605  * function supportsInterface(bytes4 interfaceId) public view virtual override returns (bool) {
606  *     return interfaceId == type(MyInterface).interfaceId || super.supportsInterface(interfaceId);
607  * }
608  * ```
609  *
610  * Alternatively, {ERC165Storage} provides an easier to use but more expensive implementation.
611  */
612 abstract contract ERC165 is IERC165 {
613     /**
614      * @dev See {IERC165-supportsInterface}.
615      */
616     function supportsInterface(bytes4 interfaceId) public view virtual override returns (bool) {
617         return interfaceId == type(IERC165).interfaceId;
618     }
619 }
620 
621 // File: @openzeppelin/contracts/token/ERC721/IERC721.sol
622 
623 
624 // OpenZeppelin Contracts v4.4.1 (token/ERC721/IERC721.sol)
625 
626 pragma solidity ^0.8.0;
627 
628 
629 /**
630  * @dev Required interface of an ERC721 compliant contract.
631  */
632 interface IERC721 is IERC165 {
633     /**
634      * @dev Emitted when `tokenId` token is transferred from `from` to `to`.
635      */
636     event Transfer(address indexed from, address indexed to, uint256 indexed tokenId);
637 
638     /**
639      * @dev Emitted when `owner` enables `approved` to manage the `tokenId` token.
640      */
641     event Approval(address indexed owner, address indexed approved, uint256 indexed tokenId);
642 
643     /**
644      * @dev Emitted when `owner` enables or disables (`approved`) `operator` to manage all of its assets.
645      */
646     event ApprovalForAll(address indexed owner, address indexed operator, bool approved);
647 
648     /**
649      * @dev Returns the number of tokens in ``owner``'s account.
650      */
651     function balanceOf(address owner) external view returns (uint256 balance);
652 
653     /**
654      * @dev Returns the owner of the `tokenId` token.
655      *
656      * Requirements:
657      *
658      * - `tokenId` must exist.
659      */
660     function ownerOf(uint256 tokenId) external view returns (address owner);
661 
662     /**
663      * @dev Safely transfers `tokenId` token from `from` to `to`, checking first that contract recipients
664      * are aware of the ERC721 protocol to prevent tokens from being forever locked.
665      *
666      * Requirements:
667      *
668      * - `from` cannot be the zero address.
669      * - `to` cannot be the zero address.
670      * - `tokenId` token must exist and be owned by `from`.
671      * - If the caller is not `from`, it must be have been allowed to move this token by either {approve} or {setApprovalForAll}.
672      * - If `to` refers to a smart contract, it must implement {IERC721Receiver-onERC721Received}, which is called upon a safe transfer.
673      *
674      * Emits a {Transfer} event.
675      */
676     function safeTransferFrom(
677         address from,
678         address to,
679         uint256 tokenId
680     ) external;
681 
682     /**
683      * @dev Transfers `tokenId` token from `from` to `to`.
684      *
685      * WARNING: Usage of this method is discouraged, use {safeTransferFrom} whenever possible.
686      *
687      * Requirements:
688      *
689      * - `from` cannot be the zero address.
690      * - `to` cannot be the zero address.
691      * - `tokenId` token must be owned by `from`.
692      * - If the caller is not `from`, it must be approved to move this token by either {approve} or {setApprovalForAll}.
693      *
694      * Emits a {Transfer} event.
695      */
696     function transferFrom(
697         address from,
698         address to,
699         uint256 tokenId
700     ) external;
701 
702     /**
703      * @dev Gives permission to `to` to transfer `tokenId` token to another account.
704      * The approval is cleared when the token is transferred.
705      *
706      * Only a single account can be approved at a time, so approving the zero address clears previous approvals.
707      *
708      * Requirements:
709      *
710      * - The caller must own the token or be an approved operator.
711      * - `tokenId` must exist.
712      *
713      * Emits an {Approval} event.
714      */
715     function approve(address to, uint256 tokenId) external;
716 
717     /**
718      * @dev Returns the account approved for `tokenId` token.
719      *
720      * Requirements:
721      *
722      * - `tokenId` must exist.
723      */
724     function getApproved(uint256 tokenId) external view returns (address operator);
725 
726     /**
727      * @dev Approve or remove `operator` as an operator for the caller.
728      * Operators can call {transferFrom} or {safeTransferFrom} for any token owned by the caller.
729      *
730      * Requirements:
731      *
732      * - The `operator` cannot be the caller.
733      *
734      * Emits an {ApprovalForAll} event.
735      */
736     function setApprovalForAll(address operator, bool _approved) external;
737 
738     /**
739      * @dev Returns if the `operator` is allowed to manage all of the assets of `owner`.
740      *
741      * See {setApprovalForAll}
742      */
743     function isApprovedForAll(address owner, address operator) external view returns (bool);
744 
745     /**
746      * @dev Safely transfers `tokenId` token from `from` to `to`.
747      *
748      * Requirements:
749      *
750      * - `from` cannot be the zero address.
751      * - `to` cannot be the zero address.
752      * - `tokenId` token must exist and be owned by `from`.
753      * - If the caller is not `from`, it must be approved to move this token by either {approve} or {setApprovalForAll}.
754      * - If `to` refers to a smart contract, it must implement {IERC721Receiver-onERC721Received}, which is called upon a safe transfer.
755      *
756      * Emits a {Transfer} event.
757      */
758     function safeTransferFrom(
759         address from,
760         address to,
761         uint256 tokenId,
762         bytes calldata data
763     ) external;
764 }
765 
766 // File: @openzeppelin/contracts/token/ERC721/extensions/IERC721Enumerable.sol
767 
768 
769 // OpenZeppelin Contracts (last updated v4.5.0) (token/ERC721/extensions/IERC721Enumerable.sol)
770 
771 pragma solidity ^0.8.0;
772 
773 
774 /**
775  * @title ERC-721 Non-Fungible Token Standard, optional enumeration extension
776  * @dev See https://eips.ethereum.org/EIPS/eip-721
777  */
778 interface IERC721Enumerable is IERC721 {
779     /**
780      * @dev Returns the total amount of tokens stored by the contract.
781      */
782     function totalSupply() external view returns (uint256);
783 
784     /**
785      * @dev Returns a token ID owned by `owner` at a given `index` of its token list.
786      * Use along with {balanceOf} to enumerate all of ``owner``'s tokens.
787      */
788     function tokenOfOwnerByIndex(address owner, uint256 index) external view returns (uint256);
789 
790     /**
791      * @dev Returns a token ID at a given `index` of all the tokens stored by the contract.
792      * Use along with {totalSupply} to enumerate all tokens.
793      */
794     function tokenByIndex(uint256 index) external view returns (uint256);
795 }
796 
797 // File: @openzeppelin/contracts/token/ERC721/extensions/IERC721Metadata.sol
798 
799 
800 // OpenZeppelin Contracts v4.4.1 (token/ERC721/extensions/IERC721Metadata.sol)
801 
802 pragma solidity ^0.8.0;
803 
804 
805 /**
806  * @title ERC-721 Non-Fungible Token Standard, optional metadata extension
807  * @dev See https://eips.ethereum.org/EIPS/eip-721
808  */
809 interface IERC721Metadata is IERC721 {
810     /**
811      * @dev Returns the token collection name.
812      */
813     function name() external view returns (string memory);
814 
815     /**
816      * @dev Returns the token collection symbol.
817      */
818     function symbol() external view returns (string memory);
819 
820     /**
821      * @dev Returns the Uniform Resource Identifier (URI) for `tokenId` token.
822      */
823     function tokenURI(uint256 tokenId) external view returns (string memory);
824 }
825 
826 // File: erc721a/contracts/ERC721A.sol
827 
828 
829 pragma solidity ^0.8.4;
830 
831 
832 /**
833  * @dev Implementation of https://eips.ethereum.org/EIPS/eip-721[ERC721] Non-Fungible Token Standard, including
834  * the Metadata and Enumerable extension. Built to optimize for lower gas during batch mints.
835  *
836  * Assumes serials are sequentially minted starting at 0 (e.g. 0, 1, 2, 3..).
837  *
838  * Assumes the number of issuable tokens (collection size) is capped and fits in a uint128.
839  *
840  * Does not support burning tokens to address(0).
841  */
842 contract ERC721A is
843   Context,
844   ERC165,
845   IERC721,
846   IERC721Metadata,
847   IERC721Enumerable
848 {
849   using Address for address;
850   using Strings for uint256;
851 
852   struct TokenOwnership {
853     address addr;
854     uint64 startTimestamp;
855   }
856 
857   struct AddressData {
858     uint128 balance;
859     uint128 numberMinted;
860   }
861   // The tokenId of the next token to be minted.
862   uint256 private currentIndex = 0;
863 
864   // Token name
865   string private _name;
866 
867   // Token symbol
868   string private _symbol;
869 
870   // Mapping from token ID to ownership details
871   // An empty struct value does not necessarily mean the token is unowned. See ownershipOf implementation for details.
872   mapping(uint256 => TokenOwnership) private _ownerships;
873 
874   // Mapping owner address to address data
875   mapping(address => AddressData) private _addressData;
876 
877   // Mapping from token ID to approved address
878   mapping(uint256 => address) private _tokenApprovals;
879 
880   // Mapping from owner to operator approvals
881   mapping(address => mapping(address => bool)) private _operatorApprovals;
882 
883   /**
884    * @dev
885    * `maxBatchSize` refers to how much a minter can mint at a time.
886    * `collectionSize_` refers to how many tokens are in the collection.
887    */
888   constructor(string memory name_, string memory symbol_) {
889     _name = name_;
890     _symbol = symbol_;
891   }
892 
893    /**
894      * To change the starting tokenId, please override this function.
895      */
896     function _startTokenId() internal view virtual returns (uint256) {
897         return 0;
898     }
899 
900   /**
901    * @dev See {IERC721Enumerable-totalSupply}.
902    */
903   function totalSupply() public view override returns (uint256) {
904     return currentIndex;
905   }
906 
907   /**
908    * @dev See {IERC721Enumerable-tokenByIndex}.
909    */
910   function tokenByIndex(uint256 index) public view override returns (uint256) {
911     require(index < totalSupply(), "ERC721A: global index out of bounds");
912     return index;
913   }
914 
915   /**
916    * @dev See {IERC721Enumerable-tokenOfOwnerByIndex}.
917    * This read function is O(collectionSize). If calling from a separate contract, be sure to test gas first.
918    * It may also degrade with extremely large collection sizes (e.g >> 10000), test for your use case.
919    */
920   function tokenOfOwnerByIndex(address owner, uint256 index)
921     public
922     view
923     override
924     returns (uint256)
925   {
926     require(index < balanceOf(owner), "ERC721A: owner index out of bounds");
927     uint256 numMintedSoFar = totalSupply();
928     uint256 tokenIdsIdx = 0;
929     address currOwnershipAddr = address(0);
930     for (uint256 i = 0; i < numMintedSoFar; i++) {
931       TokenOwnership memory ownership = _ownerships[i];
932       if (ownership.addr != address(0)) {
933         currOwnershipAddr = ownership.addr;
934       }
935       if (currOwnershipAddr == owner) {
936         if (tokenIdsIdx == index) {
937           return i;
938         }
939         tokenIdsIdx++;
940       }
941     }
942     revert("ERC721A: unable to get token of owner by index");
943   }
944 
945   /**
946    * @dev See {IERC165-supportsInterface}.
947    */
948   function supportsInterface(bytes4 interfaceId)
949     public
950     view
951     virtual
952     override(ERC165, IERC165)
953     returns (bool)
954   {
955     return
956       interfaceId == type(IERC721).interfaceId ||
957       interfaceId == type(IERC721Metadata).interfaceId ||
958       interfaceId == type(IERC721Enumerable).interfaceId ||
959       super.supportsInterface(interfaceId);
960   }
961 
962   /**
963    * @dev See {IERC721-balanceOf}.
964    */
965   function balanceOf(address owner) public view override returns (uint256) {
966     require(owner != address(0), "ERC721A: balance query for the zero address");
967     return uint256(_addressData[owner].balance);
968   }
969 
970   function _numberMinted(address owner) internal view returns (uint256) {
971     require( owner != address(0), "ERC721A: number minted query for the zero address");
972     return uint256(_addressData[owner].numberMinted);
973   }
974 
975   function ownershipOf(uint256 tokenId) internal view returns (TokenOwnership memory) {
976     require(_exists(tokenId), "ERC721A: owner query for nonexistent token");
977     
978     unchecked {
979         for (uint256 curr = tokenId; curr >= 0; curr--) {
980             TokenOwnership memory ownership = _ownerships[curr];
981             if (ownership.addr != address(0)) {
982                 return ownership;
983             }
984         }
985     }
986 
987     revert("ERC721A: unable to determine the owner of token");
988   }
989 
990   /**
991    * @dev See {IERC721-ownerOf}.
992    */
993   function ownerOf(uint256 tokenId) public view override returns (address) {
994     return ownershipOf(tokenId).addr;
995   }
996 
997   /**
998    * @dev See {IERC721Metadata-name}.
999    */
1000   function name() public view virtual override returns (string memory) {
1001     return _name;
1002   }
1003 
1004   /**
1005    * @dev See {IERC721Metadata-symbol}.
1006    */
1007   function symbol() public view virtual override returns (string memory) {
1008     return _symbol;
1009   }
1010 
1011   /**
1012    * @dev See {IERC721Metadata-tokenURI}.
1013    */
1014   function tokenURI(uint256 tokenId)
1015     public
1016     view
1017     virtual
1018     override
1019     returns (string memory)
1020   {
1021     require(
1022       _exists(tokenId),
1023       "ERC721Metadata: URI query for nonexistent token"
1024     );
1025 
1026     string memory baseURI = _baseURI();
1027     return
1028       bytes(baseURI).length > 0
1029         ? string(abi.encodePacked(baseURI, tokenId.toString()))
1030         : "";
1031   }
1032 
1033   /**
1034    * @dev Base URI for computing {tokenURI}. If set, the resulting URI for each
1035    * token will be the concatenation of the `baseURI` and the `tokenId`. Empty
1036    * by default, can be overriden in child contracts.
1037    */
1038   function _baseURI() internal view virtual returns (string memory) {
1039     return "";
1040   }
1041 
1042   /**
1043    * @dev See {IERC721-approve}.
1044    */
1045   function approve(address to, uint256 tokenId) public override {
1046     address owner = ERC721A.ownerOf(tokenId);
1047     require(to != owner, "ERC721A: approval to current owner");
1048 
1049     require(
1050       _msgSender() == owner || isApprovedForAll(owner, _msgSender()),
1051       "ERC721A: approve caller is not owner nor approved for all"
1052     );
1053 
1054     _approve(to, tokenId, owner);
1055   }
1056 
1057   /**
1058    * @dev See {IERC721-getApproved}.
1059    */
1060   function getApproved(uint256 tokenId) public view override returns (address) {
1061     require(_exists(tokenId), "ERC721A: approved query for nonexistent token");
1062 
1063     return _tokenApprovals[tokenId];
1064   }
1065 
1066   /**
1067    * @dev See {IERC721-setApprovalForAll}.
1068    */
1069   function setApprovalForAll(address operator, bool approved) public override {
1070     require(operator != _msgSender(), "ERC721A: approve to caller");
1071 
1072     _operatorApprovals[_msgSender()][operator] = approved;
1073     emit ApprovalForAll(_msgSender(), operator, approved);
1074   }
1075 
1076   /**
1077    * @dev See {IERC721-isApprovedForAll}.
1078    */
1079   function isApprovedForAll(address owner, address operator)
1080     public
1081     view
1082     virtual
1083     override
1084     returns (bool)
1085   {
1086     return _operatorApprovals[owner][operator];
1087   }
1088 
1089   /**
1090    * @dev See {IERC721-transferFrom}.
1091    */
1092   function transferFrom(
1093     address from,
1094     address to,
1095     uint256 tokenId
1096   ) public override {
1097     _transfer(from, to, tokenId);
1098   }
1099 
1100   /**
1101    * @dev See {IERC721-safeTransferFrom}.
1102    */
1103   function safeTransferFrom(
1104     address from,
1105     address to,
1106     uint256 tokenId
1107   ) public override {
1108     safeTransferFrom(from, to, tokenId, "");
1109   }
1110 
1111   /**
1112    * @dev See {IERC721-safeTransferFrom}.
1113    */
1114   function safeTransferFrom(
1115     address from,
1116     address to,
1117     uint256 tokenId,
1118     bytes memory _data
1119   ) public override {
1120     _transfer(from, to, tokenId);
1121     require(
1122       _checkOnERC721Received(from, to, tokenId, _data),
1123       "ERC721A: transfer to non ERC721Receiver implementer"
1124     );
1125   }
1126 
1127   /**
1128    * @dev Returns whether `tokenId` exists.
1129    *
1130    * Tokens can be managed by their owner or approved accounts via {approve} or {setApprovalForAll}.
1131    *
1132    * Tokens start existing when they are minted (`_mint`),
1133    */
1134   function _exists(uint256 tokenId) internal view returns (bool) {
1135     return tokenId < currentIndex;
1136   }
1137 
1138   function _safeMint(address to, uint256 quantity) internal {
1139     _safeMint(to, quantity, "");
1140   }
1141 
1142   /**
1143    * @dev Mints `quantity` tokens and transfers them to `to`.
1144    *
1145    * Requirements:
1146    *
1147    * - there must be `quantity` tokens remaining unminted in the total collection.
1148    * - `to` cannot be the zero address.
1149    * - `quantity` cannot be larger than the max batch size.
1150    *
1151    * Emits a {Transfer} event.
1152    */
1153   function _safeMint(
1154     address to,
1155     uint256 quantity,
1156     bytes memory _data
1157   ) internal {
1158     uint256 startTokenId = currentIndex;
1159     require(to != address(0), "ERC721A: mint to the zero address");
1160     require(quantity != 0, "ERC721A: quantity must be greater than 0");
1161     // We know if the first token in the batch doesn't exist, the other ones don't as well, because of serial ordering.
1162     require(!_exists(startTokenId), "ERC721A: token already minted");
1163 
1164     _beforeTokenTransfers(address(0), to, startTokenId, quantity);
1165 
1166     unchecked {
1167       AddressData memory addressData = _addressData[to];
1168       _addressData[to] = AddressData(
1169         addressData.balance + uint128(quantity),
1170         addressData.numberMinted + uint128(quantity)
1171       );
1172       _ownerships[startTokenId] = TokenOwnership(to, uint64(block.timestamp));
1173 
1174       uint256 updatedIndex = startTokenId;
1175 
1176       for (uint256 i = 0; i < quantity; i++) {
1177         emit Transfer(address(0), to, updatedIndex);
1178         require(
1179           _checkOnERC721Received(address(0), to, updatedIndex, _data),
1180           "ERC721A: transfer to non ERC721Receiver implementer"
1181         );
1182         updatedIndex++;
1183       }
1184 
1185       currentIndex = updatedIndex;
1186     }
1187     _afterTokenTransfers(address(0), to, startTokenId, quantity);
1188   }
1189 
1190   /**
1191    * @dev Transfers `tokenId` from `from` to `to`.
1192    *
1193    * Requirements:
1194    *
1195    * - `to` cannot be the zero address.
1196    * - `tokenId` token must be owned by `from`.
1197    *
1198    * Emits a {Transfer} event.
1199    */
1200   function _transfer(
1201     address from,
1202     address to,
1203     uint256 tokenId
1204   ) private {
1205     TokenOwnership memory prevOwnership = ownershipOf(tokenId);
1206 
1207     bool isApprovedOrOwner = (_msgSender() == prevOwnership.addr ||
1208       getApproved(tokenId) == _msgSender() ||
1209       isApprovedForAll(prevOwnership.addr, _msgSender()));
1210 
1211     require(
1212       isApprovedOrOwner,
1213       "ERC721A: transfer caller is not owner nor approved"
1214     );
1215 
1216     require(
1217       prevOwnership.addr == from,
1218       "ERC721A: transfer from incorrect owner"
1219     );
1220     require(to != address(0), "ERC721A: transfer to the zero address");
1221 
1222     _beforeTokenTransfers(from, to, tokenId, 1);
1223 
1224     // Clear approvals from the previous owner
1225     _approve(address(0), tokenId, prevOwnership.addr);
1226 
1227     _addressData[from].balance -= 1;
1228     _addressData[to].balance += 1;
1229     _ownerships[tokenId] = TokenOwnership(to, uint64(block.timestamp));
1230 
1231     // If the ownership slot of tokenId+1 is not explicitly set, that means the transfer initiator owns it.
1232     // Set the slot of tokenId+1 explicitly in storage to maintain correctness for ownerOf(tokenId+1) calls.
1233     uint256 nextTokenId = tokenId + 1;
1234     if (_ownerships[nextTokenId].addr == address(0)) {
1235       if (_exists(nextTokenId)) {
1236         _ownerships[nextTokenId] = TokenOwnership(
1237           prevOwnership.addr,
1238           prevOwnership.startTimestamp
1239         );
1240       }
1241     }
1242 
1243     emit Transfer(from, to, tokenId);
1244     _afterTokenTransfers(from, to, tokenId, 1);
1245   }
1246 
1247   /**
1248    * @dev Approve `to` to operate on `tokenId`
1249    *
1250    * Emits a {Approval} event.
1251    */
1252   function _approve(
1253     address to,
1254     uint256 tokenId,
1255     address owner
1256   ) private {
1257     _tokenApprovals[tokenId] = to;
1258     emit Approval(owner, to, tokenId);
1259   }
1260 
1261   // uint256 public nextOwnerToExplicitlySet = 0;
1262 
1263   /**
1264    * @dev Explicitly set `owners` to eliminate loops in future calls of ownerOf().
1265    */
1266   // function _setOwnersExplicit(uint256 quantity) internal {
1267   //   uint256 oldNextOwnerToSet = nextOwnerToExplicitlySet;
1268   //   require(quantity > 0, "quantity must be nonzero");
1269   //   uint256 endIndex = oldNextOwnerToSet + quantity - 1;
1270   //   if (endIndex > collectionSize - 1) {
1271   //     endIndex = collectionSize - 1;
1272   //   }
1273   //   // We know if the last one in the group exists, all in the group exist, due to serial ordering.
1274   //   require(_exists(endIndex), "not enough minted yet for this cleanup");
1275   //   for (uint256 i = oldNextOwnerToSet; i <= endIndex; i++) {
1276   //     if (_ownerships[i].addr == address(0)) {
1277   //       TokenOwnership memory ownership = ownershipOf(i);
1278   //       _ownerships[i] = TokenOwnership(
1279   //         ownership.addr,
1280   //         ownership.startTimestamp
1281   //       );
1282   //     }
1283   //   }
1284   //   nextOwnerToExplicitlySet = endIndex + 1;
1285   // }
1286 
1287   /**
1288    * @dev Internal function to invoke {IERC721Receiver-onERC721Received} on a target address.
1289    * The call is not executed if the target address is not a contract.
1290    *
1291    * @param from address representing the previous owner of the given token ID
1292    * @param to target address that will receive the tokens
1293    * @param tokenId uint256 ID of the token to be transferred
1294    * @param _data bytes optional data to send along with the call
1295    * @return bool whether the call correctly returned the expected magic value
1296    */
1297   function _checkOnERC721Received(
1298     address from,
1299     address to,
1300     uint256 tokenId,
1301     bytes memory _data
1302   ) private returns (bool) {
1303     if (to.isContract()) {
1304       try
1305         IERC721Receiver(to).onERC721Received(_msgSender(), from, tokenId, _data)
1306       returns (bytes4 retval) {
1307         return retval == IERC721Receiver(to).onERC721Received.selector;
1308       } catch (bytes memory reason) {
1309         if (reason.length == 0) {
1310           revert("ERC721A: transfer to non ERC721Receiver implementer");
1311         } else {
1312           assembly {
1313             revert(add(32, reason), mload(reason))
1314           }
1315         }
1316       }
1317     } else {
1318       return true;
1319     }
1320   }
1321 
1322   /**
1323    * @dev Hook that is called before a set of serially-ordered token ids are about to be transferred. This includes minting.
1324    *
1325    * startTokenId - the first token id to be transferred
1326    * quantity - the amount to be transferred
1327    *
1328    * Calling conditions:
1329    *
1330    * - When `from` and `to` are both non-zero, ``from``'s `tokenId` will be
1331    * transferred to `to`.
1332    * - When `from` is zero, `tokenId` will be minted for `to`.
1333    */
1334   function _beforeTokenTransfers(
1335     address from,
1336     address to,
1337     uint256 startTokenId,
1338     uint256 quantity
1339   ) internal virtual {}
1340 
1341   /**
1342    * @dev Hook that is called after a set of serially-ordered token ids have been transferred. This includes
1343    * minting.
1344    *
1345    * startTokenId - the first token id to be transferred
1346    * quantity - the amount to be transferred
1347    *
1348    * Calling conditions:
1349    *
1350    * - when `from` and `to` are both non-zero.
1351    * - `from` and `to` are never both zero.
1352    */
1353   function _afterTokenTransfers(
1354     address from,
1355     address to,
1356     uint256 startTokenId,
1357     uint256 quantity
1358   ) internal virtual {}
1359 }
1360 
1361 
1362 pragma solidity ^0.8.6;
1363 
1364 
1365 
1366 contract FKN is ERC721A, Ownable,ReentrancyGuard {
1367     using Strings for uint256;
1368 
1369     //Basic Configs
1370     uint256 public maxSupply = 10000;
1371     uint256 public _price = 0.18 ether;
1372     uint256 public maxMintAmountPerTx = 5;
1373 
1374     //Reveal/NonReveal
1375     string public _baseTokenURI;
1376     string public _baseTokenEXT = ".json";
1377     string public notRevealedUri;
1378     bool public revealed = false;
1379     bool public _paused = false;
1380 
1381     //PRESALE MODES
1382     uint256 public whitelistMaxMint = 5;
1383     bytes32 public merkleRoot = 0x9d997719c0a5b5f6db9b8ac69a988be57cf324cb9fffd51dc2c37544bb520d65;
1384     bool public whitelistSale = false;
1385     uint256 public whitelistPrice = 0.01 ether;
1386 
1387     bool public vipSaleStarted = false;
1388 
1389     struct MintTracker{
1390         uint256 _regular;
1391         uint256 _whitelist;
1392     }
1393     mapping(address => MintTracker) public _totalMinted;
1394 
1395     // withdraw addresses
1396     address t1 = 0xB95dd339Eec8e688c91d305a88F5733D18f709E1;
1397     address t2 = 0xE02B033625D6917F0011245F3192dEeE73A3B40f;
1398     
1399 
1400     constructor(string memory _initBaseURI) ERC721A("Fkn Rich Sharks", "FKN") {
1401        changeURLParams(_initBaseURI);
1402       
1403     }
1404 
1405     modifier mintCompliance(uint256 _mintAmount) {
1406       require(_mintAmount > 0 && _mintAmount <= maxMintAmountPerTx, "Invalid mint amount!");
1407       uint256 supply = totalSupply();
1408       require(supply + _mintAmount <= maxSupply , ": No more NFTs to mint, decrease the quantity or check out OpenSea.");
1409     _;
1410     }
1411 
1412     function mintRegular(uint256 _mintAmount, address _receiver) private {
1413       _safeMint(_receiver, _mintAmount);
1414       _totalMinted[_receiver]._regular+=_mintAmount;
1415     }
1416 
1417     function mint(uint256 _mintAmount) public payable mintCompliance(_mintAmount) {
1418         require(!_paused, ": Contract Execution paused.");
1419         require(!whitelistSale, ": Contract paused.");
1420         require(_mintAmount > 0, ": Amount should be greater than 0.");
1421         require(msg.value >= _price * _mintAmount,"Insufficient FUnd");
1422         mintRegular(_mintAmount, msg.sender);   
1423     }
1424 
1425   
1426     function WhiteListMint( uint256 _mintAmount, bytes32[] calldata _merkleProof) public payable mintCompliance(_mintAmount) {
1427         require(!_paused, ": Contract Execution paused.");
1428         require(whitelistSale, ": Whitelist is paused.");
1429         require(_mintAmount > 0, ": Amount should be greater than 0.");
1430         require(msg.value >= whitelistPrice * _mintAmount,"Insufficient FUnd");
1431 
1432         bytes32 leaf = keccak256(abi.encodePacked(msg.sender));
1433         require(MerkleProof.verify(_merkleProof, merkleRoot, leaf), "You are Not whitelisted");
1434 
1435         _safeMint(msg.sender, _mintAmount);
1436         _totalMinted[msg.sender]._whitelist+=_mintAmount;
1437     }
1438 
1439     function mintForAddress(uint256 _mintAmount, address _receiver) public mintCompliance(_mintAmount) onlyOwner {
1440       mintRegular(_mintAmount, _receiver);
1441     }
1442 
1443     function _baseURI() internal view virtual override returns (string memory) {
1444         return _baseTokenURI;
1445     }
1446 
1447     function tokenURI(uint256 tokenId) public view virtual override returns (string memory) {
1448         require(_exists(tokenId), "ERC721Metadata: URI query for nonexistent token");
1449         if (revealed == false) {
1450             return notRevealedUri;
1451         } else {
1452             string memory currentBaseURI = _baseURI();
1453             return bytes(currentBaseURI).length > 0 ? string(abi.encodePacked(currentBaseURI, tokenId.toString(),_baseTokenEXT)) : "";
1454         }
1455     }
1456 
1457     function setNotRevealedURI(string memory _notRevealedURI) public onlyOwner {
1458         notRevealedUri = _notRevealedURI;
1459     }
1460 
1461     function pause(bool val) public onlyOwner() {
1462         _paused = val;
1463     }
1464 
1465     function toogleWhiteList() public onlyOwner{
1466         whitelistSale = !whitelistSale;
1467     }
1468 
1469     function toogleReveal() public onlyOwner{
1470         revealed = !revealed;
1471     }
1472 
1473     function changeURLParams(string memory _nURL) public onlyOwner {
1474         _baseTokenURI = _nURL;
1475     }
1476 
1477 
1478     function setPrice(uint256 newPrice) public onlyOwner() {
1479         _price = newPrice;
1480     }
1481 
1482     function setWhiteListPrice(uint256 newPrice) public onlyOwner() {
1483         whitelistPrice = newPrice;
1484     }
1485 
1486     function setMerkleRoot(bytes32 merkleHash) public onlyOwner {
1487         merkleRoot = merkleHash;
1488     }
1489     
1490     function withdrawMoney() external onlyOwner nonReentrant {
1491         (bool success, ) = msg.sender.call{value: address(this).balance}("");
1492         require(success, "Transfer failed.");
1493     }
1494 
1495     function withdrawAll() external payable onlyOwner {
1496         uint256 _each = address(this).balance / 2;
1497         require(payable(t1).send(_each));
1498         require(payable(t2).send(_each));
1499     }
1500 
1501 
1502     
1503 }