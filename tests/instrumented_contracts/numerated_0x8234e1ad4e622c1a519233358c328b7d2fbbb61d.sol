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
829 // Creator: Chiru Labs
830 
831 pragma solidity ^0.8.4;
832 
833 
834 
835 
836 
837 
838 
839 
840 
841 error ApprovalCallerNotOwnerNorApproved();
842 error ApprovalQueryForNonexistentToken();
843 error ApproveToCaller();
844 error ApprovalToCurrentOwner();
845 error BalanceQueryForZeroAddress();
846 error MintedQueryForZeroAddress();
847 error BurnedQueryForZeroAddress();
848 error AuxQueryForZeroAddress();
849 error MintToZeroAddress();
850 error MintZeroQuantity();
851 error OwnerIndexOutOfBounds();
852 error OwnerQueryForNonexistentToken();
853 error TokenIndexOutOfBounds();
854 error TransferCallerNotOwnerNorApproved();
855 error TransferFromIncorrectOwner();
856 error TransferToNonERC721ReceiverImplementer();
857 error TransferToZeroAddress();
858 error URIQueryForNonexistentToken();
859 
860 /**
861  * @dev Implementation of https://eips.ethereum.org/EIPS/eip-721[ERC721] Non-Fungible Token Standard, including
862  * the Metadata extension. Built to optimize for lower gas during batch mints.
863  *
864  * Assumes serials are sequentially minted starting at _startTokenId() (defaults to 0, e.g. 0, 1, 2, 3..).
865  *
866  * Assumes that an owner cannot have more than 2**64 - 1 (max value of uint64) of supply.
867  *
868  * Assumes that the maximum token id cannot exceed 2**256 - 1 (max value of uint256).
869  */
870 contract ERC721A is Context, ERC165, IERC721, IERC721Metadata {
871     using Address for address;
872     using Strings for uint256;
873 
874     // Compiler will pack this into a single 256bit word.
875     struct TokenOwnership {
876         // The address of the owner.
877         address addr;
878         // Keeps track of the start time of ownership with minimal overhead for tokenomics.
879         uint64 startTimestamp;
880         // Whether the token has been burned.
881         bool burned;
882     }
883 
884     // Compiler will pack this into a single 256bit word.
885     struct AddressData {
886         // Realistically, 2**64-1 is more than enough.
887         uint64 balance;
888         // Keeps track of mint count with minimal overhead for tokenomics.
889         uint64 numberMinted;
890         // Keeps track of burn count with minimal overhead for tokenomics.
891         uint64 numberBurned;
892         // For miscellaneous variable(s) pertaining to the address
893         // (e.g. number of whitelist mint slots used).
894         // If there are multiple variables, please pack them into a uint64.
895         uint64 aux;
896     }
897 
898     // The tokenId of the next token to be minted.
899     uint256 internal _currentIndex;
900 
901     // The number of tokens burned.
902     uint256 internal _burnCounter;
903 
904     // Token name
905     string private _name;
906 
907     // Token symbol
908     string private _symbol;
909 
910     // Mapping from token ID to ownership details
911     // An empty struct value does not necessarily mean the token is unowned. See ownershipOf implementation for details.
912     mapping(uint256 => TokenOwnership) internal _ownerships;
913 
914     // Mapping owner address to address data
915     mapping(address => AddressData) private _addressData;
916 
917     // Mapping from token ID to approved address
918     mapping(uint256 => address) private _tokenApprovals;
919 
920     // Mapping from owner to operator approvals
921     mapping(address => mapping(address => bool)) private _operatorApprovals;
922 
923     constructor(string memory name_, string memory symbol_) {
924         _name = name_;
925         _symbol = symbol_;
926         _currentIndex = _startTokenId();
927     }
928 
929     /**
930      * To change the starting tokenId, please override this function.
931      */
932     function _startTokenId() internal view virtual returns (uint256) {
933         return 0;
934     }
935 
936     /**
937      * @dev See {IERC721Enumerable-totalSupply}.
938      * @dev Burned tokens are calculated here, use _totalMinted() if you want to count just minted tokens.
939      */
940     function totalSupply() public view returns (uint256) {
941         // Counter underflow is impossible as _burnCounter cannot be incremented
942         // more than _currentIndex - _startTokenId() times
943         unchecked {
944             return _currentIndex - _burnCounter - _startTokenId();
945         }
946     }
947 
948     /**
949      * Returns the total amount of tokens minted in the contract.
950      */
951     function _totalMinted() internal view returns (uint256) {
952         // Counter underflow is impossible as _currentIndex does not decrement,
953         // and it is initialized to _startTokenId()
954         unchecked {
955             return _currentIndex - _startTokenId();
956         }
957     }
958 
959     /**
960      * @dev See {IERC165-supportsInterface}.
961      */
962     function supportsInterface(bytes4 interfaceId) public view virtual override(ERC165, IERC165) returns (bool) {
963         return
964             interfaceId == type(IERC721).interfaceId ||
965             interfaceId == type(IERC721Metadata).interfaceId ||
966             super.supportsInterface(interfaceId);
967     }
968 
969     /**
970      * @dev See {IERC721-balanceOf}.
971      */
972     function balanceOf(address owner) public view override returns (uint256) {
973         if (owner == address(0)) revert BalanceQueryForZeroAddress();
974         return uint256(_addressData[owner].balance);
975     }
976 
977     /**
978      * Returns the number of tokens minted by `owner`.
979      */
980     function _numberMinted(address owner) internal view returns (uint256) {
981         if (owner == address(0)) revert MintedQueryForZeroAddress();
982         return uint256(_addressData[owner].numberMinted);
983     }
984 
985     /**
986      * Returns the number of tokens burned by or on behalf of `owner`.
987      */
988     function _numberBurned(address owner) internal view returns (uint256) {
989         if (owner == address(0)) revert BurnedQueryForZeroAddress();
990         return uint256(_addressData[owner].numberBurned);
991     }
992 
993     /**
994      * Returns the auxillary data for `owner`. (e.g. number of whitelist mint slots used).
995      */
996     function _getAux(address owner) internal view returns (uint64) {
997         if (owner == address(0)) revert AuxQueryForZeroAddress();
998         return _addressData[owner].aux;
999     }
1000 
1001     /**
1002      * Sets the auxillary data for `owner`. (e.g. number of whitelist mint slots used).
1003      * If there are multiple variables, please pack them into a uint64.
1004      */
1005     function _setAux(address owner, uint64 aux) internal {
1006         if (owner == address(0)) revert AuxQueryForZeroAddress();
1007         _addressData[owner].aux = aux;
1008     }
1009 
1010     /**
1011      * Gas spent here starts off proportional to the maximum mint batch size.
1012      * It gradually moves to O(1) as tokens get transferred around in the collection over time.
1013      */
1014     function ownershipOf(uint256 tokenId) internal view returns (TokenOwnership memory) {
1015         uint256 curr = tokenId;
1016 
1017         unchecked {
1018             if (_startTokenId() <= curr && curr < _currentIndex) {
1019                 TokenOwnership memory ownership = _ownerships[curr];
1020                 if (!ownership.burned) {
1021                     if (ownership.addr != address(0)) {
1022                         return ownership;
1023                     }
1024                     // Invariant:
1025                     // There will always be an ownership that has an address and is not burned
1026                     // before an ownership that does not have an address and is not burned.
1027                     // Hence, curr will not underflow.
1028                     while (true) {
1029                         curr--;
1030                         ownership = _ownerships[curr];
1031                         if (ownership.addr != address(0)) {
1032                             return ownership;
1033                         }
1034                     }
1035                 }
1036             }
1037         }
1038         revert OwnerQueryForNonexistentToken();
1039     }
1040 
1041     /**
1042      * @dev See {IERC721-ownerOf}.
1043      */
1044     function ownerOf(uint256 tokenId) public view override returns (address) {
1045         return ownershipOf(tokenId).addr;
1046     }
1047 
1048     /**
1049      * @dev See {IERC721Metadata-name}.
1050      */
1051     function name() public view virtual override returns (string memory) {
1052         return _name;
1053     }
1054 
1055     /**
1056      * @dev See {IERC721Metadata-symbol}.
1057      */
1058     function symbol() public view virtual override returns (string memory) {
1059         return _symbol;
1060     }
1061 
1062     /**
1063      * @dev See {IERC721Metadata-tokenURI}.
1064      */
1065     function tokenURI(uint256 tokenId) public view virtual override returns (string memory) {
1066         if (!_exists(tokenId)) revert URIQueryForNonexistentToken();
1067 
1068         string memory baseURI = _baseURI();
1069         return bytes(baseURI).length != 0 ? string(abi.encodePacked(baseURI, tokenId.toString())) : '';
1070     }
1071 
1072     /**
1073      * @dev Base URI for computing {tokenURI}. If set, the resulting URI for each
1074      * token will be the concatenation of the `baseURI` and the `tokenId`. Empty
1075      * by default, can be overriden in child contracts.
1076      */
1077     function _baseURI() internal view virtual returns (string memory) {
1078         return '';
1079     }
1080 
1081     /**
1082      * @dev See {IERC721-approve}.
1083      */
1084     function approve(address to, uint256 tokenId) public override {
1085         address owner = ERC721A.ownerOf(tokenId);
1086         if (to == owner) revert ApprovalToCurrentOwner();
1087 
1088         if (_msgSender() != owner && !isApprovedForAll(owner, _msgSender())) {
1089             revert ApprovalCallerNotOwnerNorApproved();
1090         }
1091 
1092         _approve(to, tokenId, owner);
1093     }
1094 
1095     /**
1096      * @dev See {IERC721-getApproved}.
1097      */
1098     function getApproved(uint256 tokenId) public view override returns (address) {
1099         if (!_exists(tokenId)) revert ApprovalQueryForNonexistentToken();
1100 
1101         return _tokenApprovals[tokenId];
1102     }
1103 
1104     /**
1105      * @dev See {IERC721-setApprovalForAll}.
1106      */
1107     function setApprovalForAll(address operator, bool approved) public override {
1108         if (operator == _msgSender()) revert ApproveToCaller();
1109 
1110         _operatorApprovals[_msgSender()][operator] = approved;
1111         emit ApprovalForAll(_msgSender(), operator, approved);
1112     }
1113 
1114     /**
1115      * @dev See {IERC721-isApprovedForAll}.
1116      */
1117     function isApprovedForAll(address owner, address operator) public view virtual override returns (bool) {
1118         return _operatorApprovals[owner][operator];
1119     }
1120 
1121     /**
1122      * @dev See {IERC721-transferFrom}.
1123      */
1124     function transferFrom(
1125         address from,
1126         address to,
1127         uint256 tokenId
1128     ) public virtual override {
1129         _transfer(from, to, tokenId);
1130     }
1131 
1132     /**
1133      * @dev See {IERC721-safeTransferFrom}.
1134      */
1135     function safeTransferFrom(
1136         address from,
1137         address to,
1138         uint256 tokenId
1139     ) public virtual override {
1140         safeTransferFrom(from, to, tokenId, '');
1141     }
1142 
1143     /**
1144      * @dev See {IERC721-safeTransferFrom}.
1145      */
1146     function safeTransferFrom(
1147         address from,
1148         address to,
1149         uint256 tokenId,
1150         bytes memory _data
1151     ) public virtual override {
1152         _transfer(from, to, tokenId);
1153         if (to.isContract() && !_checkContractOnERC721Received(from, to, tokenId, _data)) {
1154             revert TransferToNonERC721ReceiverImplementer();
1155         }
1156     }
1157 
1158     /**
1159      * @dev Returns whether `tokenId` exists.
1160      *
1161      * Tokens can be managed by their owner or approved accounts via {approve} or {setApprovalForAll}.
1162      *
1163      * Tokens start existing when they are minted (`_mint`),
1164      */
1165     function _exists(uint256 tokenId) internal view returns (bool) {
1166         return _startTokenId() <= tokenId && tokenId < _currentIndex &&
1167             !_ownerships[tokenId].burned;
1168     }
1169 
1170     function _safeMint(address to, uint256 quantity) internal {
1171         _safeMint(to, quantity, '');
1172     }
1173 
1174     /**
1175      * @dev Safely mints `quantity` tokens and transfers them to `to`.
1176      *
1177      * Requirements:
1178      *
1179      * - If `to` refers to a smart contract, it must implement {IERC721Receiver-onERC721Received}, which is called for each safe transfer.
1180      * - `quantity` must be greater than 0.
1181      *
1182      * Emits a {Transfer} event.
1183      */
1184     function _safeMint(
1185         address to,
1186         uint256 quantity,
1187         bytes memory _data
1188     ) internal {
1189         _mint(to, quantity, _data, true);
1190     }
1191 
1192     /**
1193      * @dev Mints `quantity` tokens and transfers them to `to`.
1194      *
1195      * Requirements:
1196      *
1197      * - `to` cannot be the zero address.
1198      * - `quantity` must be greater than 0.
1199      *
1200      * Emits a {Transfer} event.
1201      */
1202     function _mint(
1203         address to,
1204         uint256 quantity,
1205         bytes memory _data,
1206         bool safe
1207     ) internal {
1208         uint256 startTokenId = _currentIndex;
1209         if (to == address(0)) revert MintToZeroAddress();
1210         if (quantity == 0) revert MintZeroQuantity();
1211 
1212         _beforeTokenTransfers(address(0), to, startTokenId, quantity);
1213 
1214         // Overflows are incredibly unrealistic.
1215         // balance or numberMinted overflow if current value of either + quantity > 1.8e19 (2**64) - 1
1216         // updatedIndex overflows if _currentIndex + quantity > 1.2e77 (2**256) - 1
1217         unchecked {
1218             _addressData[to].balance += uint64(quantity);
1219             _addressData[to].numberMinted += uint64(quantity);
1220 
1221             _ownerships[startTokenId].addr = to;
1222             _ownerships[startTokenId].startTimestamp = uint64(block.timestamp);
1223 
1224             uint256 updatedIndex = startTokenId;
1225             uint256 end = updatedIndex + quantity;
1226 
1227             if (safe && to.isContract()) {
1228                 do {
1229                     emit Transfer(address(0), to, updatedIndex);
1230                     if (!_checkContractOnERC721Received(address(0), to, updatedIndex++, _data)) {
1231                         revert TransferToNonERC721ReceiverImplementer();
1232                     }
1233                 } while (updatedIndex != end);
1234                 // Reentrancy protection
1235                 if (_currentIndex != startTokenId) revert();
1236             } else {
1237                 do {
1238                     emit Transfer(address(0), to, updatedIndex++);
1239                 } while (updatedIndex != end);
1240             }
1241             _currentIndex = updatedIndex;
1242         }
1243         _afterTokenTransfers(address(0), to, startTokenId, quantity);
1244     }
1245 
1246     /**
1247      * @dev Transfers `tokenId` from `from` to `to`.
1248      *
1249      * Requirements:
1250      *
1251      * - `to` cannot be the zero address.
1252      * - `tokenId` token must be owned by `from`.
1253      *
1254      * Emits a {Transfer} event.
1255      */
1256     function _transfer(
1257         address from,
1258         address to,
1259         uint256 tokenId
1260     ) private {
1261         TokenOwnership memory prevOwnership = ownershipOf(tokenId);
1262 
1263         bool isApprovedOrOwner = (_msgSender() == prevOwnership.addr ||
1264             isApprovedForAll(prevOwnership.addr, _msgSender()) ||
1265             getApproved(tokenId) == _msgSender());
1266 
1267         if (!isApprovedOrOwner) revert TransferCallerNotOwnerNorApproved();
1268         if (prevOwnership.addr != from) revert TransferFromIncorrectOwner();
1269         if (to == address(0)) revert TransferToZeroAddress();
1270 
1271         _beforeTokenTransfers(from, to, tokenId, 1);
1272 
1273         // Clear approvals from the previous owner
1274         _approve(address(0), tokenId, prevOwnership.addr);
1275 
1276         // Underflow of the sender's balance is impossible because we check for
1277         // ownership above and the recipient's balance can't realistically overflow.
1278         // Counter overflow is incredibly unrealistic as tokenId would have to be 2**256.
1279         unchecked {
1280             _addressData[from].balance -= 1;
1281             _addressData[to].balance += 1;
1282 
1283             _ownerships[tokenId].addr = to;
1284             _ownerships[tokenId].startTimestamp = uint64(block.timestamp);
1285 
1286             // If the ownership slot of tokenId+1 is not explicitly set, that means the transfer initiator owns it.
1287             // Set the slot of tokenId+1 explicitly in storage to maintain correctness for ownerOf(tokenId+1) calls.
1288             uint256 nextTokenId = tokenId + 1;
1289             if (_ownerships[nextTokenId].addr == address(0)) {
1290                 // This will suffice for checking _exists(nextTokenId),
1291                 // as a burned slot cannot contain the zero address.
1292                 if (nextTokenId < _currentIndex) {
1293                     _ownerships[nextTokenId].addr = prevOwnership.addr;
1294                     _ownerships[nextTokenId].startTimestamp = prevOwnership.startTimestamp;
1295                 }
1296             }
1297         }
1298 
1299         emit Transfer(from, to, tokenId);
1300         _afterTokenTransfers(from, to, tokenId, 1);
1301     }
1302 
1303     /**
1304      * @dev Destroys `tokenId`.
1305      * The approval is cleared when the token is burned.
1306      *
1307      * Requirements:
1308      *
1309      * - `tokenId` must exist.
1310      *
1311      * Emits a {Transfer} event.
1312      */
1313     function _burn(uint256 tokenId) internal virtual {
1314         TokenOwnership memory prevOwnership = ownershipOf(tokenId);
1315 
1316         _beforeTokenTransfers(prevOwnership.addr, address(0), tokenId, 1);
1317 
1318         // Clear approvals from the previous owner
1319         _approve(address(0), tokenId, prevOwnership.addr);
1320 
1321         // Underflow of the sender's balance is impossible because we check for
1322         // ownership above and the recipient's balance can't realistically overflow.
1323         // Counter overflow is incredibly unrealistic as tokenId would have to be 2**256.
1324         unchecked {
1325             _addressData[prevOwnership.addr].balance -= 1;
1326             _addressData[prevOwnership.addr].numberBurned += 1;
1327 
1328             // Keep track of who burned the token, and the timestamp of burning.
1329             _ownerships[tokenId].addr = prevOwnership.addr;
1330             _ownerships[tokenId].startTimestamp = uint64(block.timestamp);
1331             _ownerships[tokenId].burned = true;
1332 
1333             // If the ownership slot of tokenId+1 is not explicitly set, that means the burn initiator owns it.
1334             // Set the slot of tokenId+1 explicitly in storage to maintain correctness for ownerOf(tokenId+1) calls.
1335             uint256 nextTokenId = tokenId + 1;
1336             if (_ownerships[nextTokenId].addr == address(0)) {
1337                 // This will suffice for checking _exists(nextTokenId),
1338                 // as a burned slot cannot contain the zero address.
1339                 if (nextTokenId < _currentIndex) {
1340                     _ownerships[nextTokenId].addr = prevOwnership.addr;
1341                     _ownerships[nextTokenId].startTimestamp = prevOwnership.startTimestamp;
1342                 }
1343             }
1344         }
1345 
1346         emit Transfer(prevOwnership.addr, address(0), tokenId);
1347         _afterTokenTransfers(prevOwnership.addr, address(0), tokenId, 1);
1348 
1349         // Overflow not possible, as _burnCounter cannot be exceed _currentIndex times.
1350         unchecked {
1351             _burnCounter++;
1352         }
1353     }
1354 
1355     /**
1356      * @dev Approve `to` to operate on `tokenId`
1357      *
1358      * Emits a {Approval} event.
1359      */
1360     function _approve(
1361         address to,
1362         uint256 tokenId,
1363         address owner
1364     ) private {
1365         _tokenApprovals[tokenId] = to;
1366         emit Approval(owner, to, tokenId);
1367     }
1368 
1369     /**
1370      * @dev Internal function to invoke {IERC721Receiver-onERC721Received} on a target contract.
1371      *
1372      * @param from address representing the previous owner of the given token ID
1373      * @param to target address that will receive the tokens
1374      * @param tokenId uint256 ID of the token to be transferred
1375      * @param _data bytes optional data to send along with the call
1376      * @return bool whether the call correctly returned the expected magic value
1377      */
1378     function _checkContractOnERC721Received(
1379         address from,
1380         address to,
1381         uint256 tokenId,
1382         bytes memory _data
1383     ) private returns (bool) {
1384         try IERC721Receiver(to).onERC721Received(_msgSender(), from, tokenId, _data) returns (bytes4 retval) {
1385             return retval == IERC721Receiver(to).onERC721Received.selector;
1386         } catch (bytes memory reason) {
1387             if (reason.length == 0) {
1388                 revert TransferToNonERC721ReceiverImplementer();
1389             } else {
1390                 assembly {
1391                     revert(add(32, reason), mload(reason))
1392                 }
1393             }
1394         }
1395     }
1396 
1397     /**
1398      * @dev Hook that is called before a set of serially-ordered token ids are about to be transferred. This includes minting.
1399      * And also called before burning one token.
1400      *
1401      * startTokenId - the first token id to be transferred
1402      * quantity - the amount to be transferred
1403      *
1404      * Calling conditions:
1405      *
1406      * - When `from` and `to` are both non-zero, `from`'s `tokenId` will be
1407      * transferred to `to`.
1408      * - When `from` is zero, `tokenId` will be minted for `to`.
1409      * - When `to` is zero, `tokenId` will be burned by `from`.
1410      * - `from` and `to` are never both zero.
1411      */
1412     function _beforeTokenTransfers(
1413         address from,
1414         address to,
1415         uint256 startTokenId,
1416         uint256 quantity
1417     ) internal virtual {}
1418 
1419     /**
1420      * @dev Hook that is called after a set of serially-ordered token ids have been transferred. This includes
1421      * minting.
1422      * And also called after one token has been burned.
1423      *
1424      * startTokenId - the first token id to be transferred
1425      * quantity - the amount to be transferred
1426      *
1427      * Calling conditions:
1428      *
1429      * - When `from` and `to` are both non-zero, `from`'s `tokenId` has been
1430      * transferred to `to`.
1431      * - When `from` is zero, `tokenId` has been minted for `to`.
1432      * - When `to` is zero, `tokenId` has been burned by `from`.
1433      * - `from` and `to` are never both zero.
1434      */
1435     function _afterTokenTransfers(
1436         address from,
1437         address to,
1438         uint256 startTokenId,
1439         uint256 quantity
1440     ) internal virtual {}
1441 }
1442 
1443 // File: contracts/Kevindood.sol
1444 
1445 
1446 pragma solidity ^0.8.6;
1447 
1448 
1449 
1450 
1451 
1452 
1453 contract Telepunks is ERC721A, Ownable,ReentrancyGuard {
1454     using Strings for uint256;
1455 
1456     //Basic Configs
1457     uint256 public maxSupply = 7777;
1458     uint256 public _price = 0.005 ether;
1459     uint256 public regularMintMax = 20;
1460 
1461     //Reveal/NonReveal
1462     string public _baseTokenURI;
1463     string public _baseTokenEXT;
1464     string public notRevealedUri;
1465     bool public revealed = false;
1466     bool public _paused = false;
1467     //PRESALE MODES
1468     uint256 public whitelistMaxMint = 3;
1469     bytes32 public merkleRoot = 0x9d997719c0a5b5f6db9b8ac69a988be57cf324cb9fffd51dc2c37544bb520d65;
1470     bool public whitelistSale = false;
1471     uint256 public whitelistPrice = 0.01 ether;
1472 
1473     struct MintTracker{
1474         uint256 _regular;
1475         uint256 _whitelist;
1476     }
1477     mapping(address => MintTracker) public _totalMinted;
1478     
1479 
1480 
1481     constructor(string memory _initBaseURI,string memory _initBaseExt) ERC721A("TelePunks", "TP") {
1482        changeURLParams(_initBaseURI,_initBaseExt);
1483       
1484     }
1485 
1486     function mint(uint256 _mintAmount) public payable {
1487         require(!_paused, ": Contract Execution paused.");
1488         require(!whitelistSale, ": Contract paused.");
1489         require(_mintAmount > 0, ": Amount should be greater than 0.");
1490         require(msg.value >= _price * _mintAmount,"Insufficient FUnd");
1491         require(_mintAmount+_totalMinted[msg.sender]._regular <= regularMintMax ,"You cant mint more,Decrease MintAmount or Wait For Public Mint" );
1492         uint256 supply = totalSupply();
1493         require(supply + _mintAmount <= maxSupply , ": No more NFTs to mint, decrease the quantity or check out OpenSea.");
1494         _safeMint(msg.sender, _mintAmount);
1495         _totalMinted[msg.sender]._regular+=_mintAmount;
1496         
1497     }
1498     
1499     function WhiteListMint( uint256 _mintAmount,bytes32[] calldata _merkleProof) public payable {
1500         require(!_paused, ": Contract Execution paused.");
1501         require(whitelistSale, ": Whitelist is paused.");
1502         require(_mintAmount > 0, ": Amount should be greater than 0.");
1503         require(_mintAmount+_totalMinted[msg.sender]._whitelist <= whitelistMaxMint ,"You cant mint more,Decrease MintAmount or Wait For Public Mint" );
1504         require(msg.value >= whitelistPrice * _mintAmount,"Insufficient FUnd");
1505         bytes32 leaf = keccak256(abi.encodePacked(msg.sender));
1506         require(MerkleProof.verify(_merkleProof, merkleRoot, leaf), "You are Not whitelisted");
1507         uint256 supply = totalSupply();
1508         require(supply + _mintAmount <= maxSupply , ": No more NFTs to mint, decrease the quantity or check out OpenSea.");
1509         _safeMint(msg.sender, _mintAmount);
1510         _totalMinted[msg.sender]._whitelist+=_mintAmount;
1511 
1512     }
1513 
1514 
1515     function _baseURI() internal view virtual override returns (string memory) {
1516         return _baseTokenURI;
1517     }
1518 
1519 
1520     function tokenURI(uint256 tokenId) public view virtual override returns (string memory) {
1521         require(_exists(tokenId), "ERC721Metadata: URI query for nonexistent token");
1522         if (revealed == false) {
1523             return notRevealedUri;
1524         } else {
1525             string memory currentBaseURI = _baseURI();
1526             return bytes(currentBaseURI).length > 0 ? string(abi.encodePacked(currentBaseURI, tokenId.toString(),_baseTokenEXT)) : "";
1527         }
1528     }
1529 
1530     function setNotRevealedURI(string memory _notRevealedURI) public onlyOwner {
1531         notRevealedUri = _notRevealedURI;
1532     }
1533     function pause(bool val) public onlyOwner() {
1534         _paused = val;
1535     }
1536 
1537     function toogleWhiteList() public onlyOwner{
1538         whitelistSale = !whitelistSale;
1539 
1540     }
1541     function toogleReveal() public onlyOwner{
1542         revealed = !revealed;
1543 
1544     }
1545 
1546     function changeURLParams(string memory _nURL, string memory _nBaseExt) public onlyOwner {
1547         _baseTokenURI = _nURL;
1548         _baseTokenEXT = _nBaseExt;
1549     }
1550 
1551 
1552     function setPrice(uint256 newPrice) public onlyOwner() {
1553         _price = newPrice;
1554     }
1555 
1556     function setMerkleRoot(bytes32 merkleHash) public onlyOwner {
1557         merkleRoot = merkleHash;
1558     }
1559     
1560 
1561 
1562     function withdrawMoney() external onlyOwner nonReentrant {
1563         (bool success, ) = msg.sender.call{value: address(this).balance}("");
1564         require(success, "Transfer failed.");
1565     }
1566 
1567 
1568     
1569 }