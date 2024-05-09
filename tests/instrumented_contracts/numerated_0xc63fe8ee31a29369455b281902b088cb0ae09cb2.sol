1 // SPDX-License-Identifier: UNLICENSED
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
766 // File: @openzeppelin/contracts/token/ERC721/extensions/IERC721Metadata.sol
767 
768 
769 // OpenZeppelin Contracts v4.4.1 (token/ERC721/extensions/IERC721Metadata.sol)
770 
771 pragma solidity ^0.8.0;
772 
773 
774 /**
775  * @title ERC-721 Non-Fungible Token Standard, optional metadata extension
776  * @dev See https://eips.ethereum.org/EIPS/eip-721
777  */
778 interface IERC721Metadata is IERC721 {
779     /**
780      * @dev Returns the token collection name.
781      */
782     function name() external view returns (string memory);
783 
784     /**
785      * @dev Returns the token collection symbol.
786      */
787     function symbol() external view returns (string memory);
788 
789     /**
790      * @dev Returns the Uniform Resource Identifier (URI) for `tokenId` token.
791      */
792     function tokenURI(uint256 tokenId) external view returns (string memory);
793 }
794 
795 // File: erc721a/contracts/ERC721A.sol
796 
797 
798 // Creator: Chiru Labs
799 
800 pragma solidity ^0.8.4;
801 
802 
803 
804 
805 
806 
807 
808 
809 error ApprovalCallerNotOwnerNorApproved();
810 error ApprovalQueryForNonexistentToken();
811 error ApproveToCaller();
812 error ApprovalToCurrentOwner();
813 error BalanceQueryForZeroAddress();
814 error MintToZeroAddress();
815 error MintZeroQuantity();
816 error OwnerQueryForNonexistentToken();
817 error TransferCallerNotOwnerNorApproved();
818 error TransferFromIncorrectOwner();
819 error TransferToNonERC721ReceiverImplementer();
820 error TransferToZeroAddress();
821 error URIQueryForNonexistentToken();
822 
823 /**
824  * @dev Implementation of https://eips.ethereum.org/EIPS/eip-721[ERC721] Non-Fungible Token Standard, including
825  * the Metadata extension. Built to optimize for lower gas during batch mints.
826  *
827  * Assumes serials are sequentially minted starting at _startTokenId() (defaults to 0, e.g. 0, 1, 2, 3..).
828  *
829  * Assumes that an owner cannot have more than 2**64 - 1 (max value of uint64) of supply.
830  *
831  * Assumes that the maximum token id cannot exceed 2**256 - 1 (max value of uint256).
832  */
833 contract ERC721A is Context, ERC165, IERC721, IERC721Metadata {
834     using Address for address;
835     using Strings for uint256;
836 
837     // Compiler will pack this into a single 256bit word.
838     struct TokenOwnership {
839         // The address of the owner.
840         address addr;
841         // Keeps track of the start time of ownership with minimal overhead for tokenomics.
842         uint64 startTimestamp;
843         // Whether the token has been burned.
844         bool burned;
845     }
846 
847     // Compiler will pack this into a single 256bit word.
848     struct AddressData {
849         // Realistically, 2**64-1 is more than enough.
850         uint64 balance;
851         // Keeps track of mint count with minimal overhead for tokenomics.
852         uint64 numberMinted;
853         // Keeps track of burn count with minimal overhead for tokenomics.
854         uint64 numberBurned;
855         // For miscellaneous variable(s) pertaining to the address
856         // (e.g. number of whitelist mint slots used).
857         // If there are multiple variables, please pack them into a uint64.
858         uint64 aux;
859     }
860 
861     // The tokenId of the next token to be minted.
862     uint256 internal _currentIndex;
863 
864     // The number of tokens burned.
865     uint256 internal _burnCounter;
866 
867     // Token name
868     string private _name;
869 
870     // Token symbol
871     string private _symbol;
872 
873     // Mapping from token ID to ownership details
874     // An empty struct value does not necessarily mean the token is unowned. See _ownershipOf implementation for details.
875     mapping(uint256 => TokenOwnership) internal _ownerships;
876 
877     // Mapping owner address to address data
878     mapping(address => AddressData) private _addressData;
879 
880     // Mapping from token ID to approved address
881     mapping(uint256 => address) private _tokenApprovals;
882 
883     // Mapping from owner to operator approvals
884     mapping(address => mapping(address => bool)) private _operatorApprovals;
885 
886     constructor(string memory name_, string memory symbol_) {
887         _name = name_;
888         _symbol = symbol_;
889         _currentIndex = _startTokenId();
890     }
891 
892     /**
893      * To change the starting tokenId, please override this function.
894      */
895     function _startTokenId() internal view virtual returns (uint256) {
896         return 0;
897     }
898 
899     /**
900      * @dev Burned tokens are calculated here, use _totalMinted() if you want to count just minted tokens.
901      */
902     function totalSupply() public view returns (uint256) {
903         // Counter underflow is impossible as _burnCounter cannot be incremented
904         // more than _currentIndex - _startTokenId() times
905         unchecked {
906             return _currentIndex - _burnCounter - _startTokenId();
907         }
908     }
909 
910     /**
911      * Returns the total amount of tokens minted in the contract.
912      */
913     function _totalMinted() internal view returns (uint256) {
914         // Counter underflow is impossible as _currentIndex does not decrement,
915         // and it is initialized to _startTokenId()
916         unchecked {
917             return _currentIndex - _startTokenId();
918         }
919     }
920 
921     /**
922      * @dev See {IERC165-supportsInterface}.
923      */
924     function supportsInterface(bytes4 interfaceId) public view virtual override(ERC165, IERC165) returns (bool) {
925         return
926             interfaceId == type(IERC721).interfaceId ||
927             interfaceId == type(IERC721Metadata).interfaceId ||
928             super.supportsInterface(interfaceId);
929     }
930 
931     /**
932      * @dev See {IERC721-balanceOf}.
933      */
934     function balanceOf(address owner) public view override returns (uint256) {
935         if (owner == address(0)) revert BalanceQueryForZeroAddress();
936         return uint256(_addressData[owner].balance);
937     }
938 
939     /**
940      * Returns the number of tokens minted by `owner`.
941      */
942     function _numberMinted(address owner) internal view returns (uint256) {
943         return uint256(_addressData[owner].numberMinted);
944     }
945 
946     /**
947      * Returns the number of tokens burned by or on behalf of `owner`.
948      */
949     function _numberBurned(address owner) internal view returns (uint256) {
950         return uint256(_addressData[owner].numberBurned);
951     }
952 
953     /**
954      * Returns the auxillary data for `owner`. (e.g. number of whitelist mint slots used).
955      */
956     function _getAux(address owner) internal view returns (uint64) {
957         return _addressData[owner].aux;
958     }
959 
960     /**
961      * Sets the auxillary data for `owner`. (e.g. number of whitelist mint slots used).
962      * If there are multiple variables, please pack them into a uint64.
963      */
964     function _setAux(address owner, uint64 aux) internal {
965         _addressData[owner].aux = aux;
966     }
967 
968     /**
969      * Gas spent here starts off proportional to the maximum mint batch size.
970      * It gradually moves to O(1) as tokens get transferred around in the collection over time.
971      */
972     function _ownershipOf(uint256 tokenId) internal view returns (TokenOwnership memory) {
973         uint256 curr = tokenId;
974 
975         unchecked {
976             if (_startTokenId() <= curr && curr < _currentIndex) {
977                 TokenOwnership memory ownership = _ownerships[curr];
978                 if (!ownership.burned) {
979                     if (ownership.addr != address(0)) {
980                         return ownership;
981                     }
982                     // Invariant:
983                     // There will always be an ownership that has an address and is not burned
984                     // before an ownership that does not have an address and is not burned.
985                     // Hence, curr will not underflow.
986                     while (true) {
987                         curr--;
988                         ownership = _ownerships[curr];
989                         if (ownership.addr != address(0)) {
990                             return ownership;
991                         }
992                     }
993                 }
994             }
995         }
996         revert OwnerQueryForNonexistentToken();
997     }
998 
999     /**
1000      * @dev See {IERC721-ownerOf}.
1001      */
1002     function ownerOf(uint256 tokenId) public view override returns (address) {
1003         return _ownershipOf(tokenId).addr;
1004     }
1005 
1006     /**
1007      * @dev See {IERC721Metadata-name}.
1008      */
1009     function name() public view virtual override returns (string memory) {
1010         return _name;
1011     }
1012 
1013     /**
1014      * @dev See {IERC721Metadata-symbol}.
1015      */
1016     function symbol() public view virtual override returns (string memory) {
1017         return _symbol;
1018     }
1019 
1020     /**
1021      * @dev See {IERC721Metadata-tokenURI}.
1022      */
1023     function tokenURI(uint256 tokenId) public view virtual override returns (string memory) {
1024         if (!_exists(tokenId)) revert URIQueryForNonexistentToken();
1025 
1026         string memory baseURI = _baseURI();
1027         return bytes(baseURI).length != 0 ? string(abi.encodePacked(baseURI, tokenId.toString())) : '';
1028     }
1029 
1030     /**
1031      * @dev Base URI for computing {tokenURI}. If set, the resulting URI for each
1032      * token will be the concatenation of the `baseURI` and the `tokenId`. Empty
1033      * by default, can be overriden in child contracts.
1034      */
1035     function _baseURI() internal view virtual returns (string memory) {
1036         return '';
1037     }
1038 
1039     /**
1040      * @dev See {IERC721-approve}.
1041      */
1042     function approve(address to, uint256 tokenId) public override {
1043         address owner = ERC721A.ownerOf(tokenId);
1044         if (to == owner) revert ApprovalToCurrentOwner();
1045 
1046         if (_msgSender() != owner && !isApprovedForAll(owner, _msgSender())) {
1047             revert ApprovalCallerNotOwnerNorApproved();
1048         }
1049 
1050         _approve(to, tokenId, owner);
1051     }
1052 
1053     /**
1054      * @dev See {IERC721-getApproved}.
1055      */
1056     function getApproved(uint256 tokenId) public view override returns (address) {
1057         if (!_exists(tokenId)) revert ApprovalQueryForNonexistentToken();
1058 
1059         return _tokenApprovals[tokenId];
1060     }
1061 
1062     /**
1063      * @dev See {IERC721-setApprovalForAll}.
1064      */
1065     function setApprovalForAll(address operator, bool approved) public virtual override {
1066         if (operator == _msgSender()) revert ApproveToCaller();
1067 
1068         _operatorApprovals[_msgSender()][operator] = approved;
1069         emit ApprovalForAll(_msgSender(), operator, approved);
1070     }
1071 
1072     /**
1073      * @dev See {IERC721-isApprovedForAll}.
1074      */
1075     function isApprovedForAll(address owner, address operator) public view virtual override returns (bool) {
1076         return _operatorApprovals[owner][operator];
1077     }
1078 
1079     /**
1080      * @dev See {IERC721-transferFrom}.
1081      */
1082     function transferFrom(
1083         address from,
1084         address to,
1085         uint256 tokenId
1086     ) public virtual override {
1087         _transfer(from, to, tokenId);
1088     }
1089 
1090     /**
1091      * @dev See {IERC721-safeTransferFrom}.
1092      */
1093     function safeTransferFrom(
1094         address from,
1095         address to,
1096         uint256 tokenId
1097     ) public virtual override {
1098         safeTransferFrom(from, to, tokenId, '');
1099     }
1100 
1101     /**
1102      * @dev See {IERC721-safeTransferFrom}.
1103      */
1104     function safeTransferFrom(
1105         address from,
1106         address to,
1107         uint256 tokenId,
1108         bytes memory _data
1109     ) public virtual override {
1110         _transfer(from, to, tokenId);
1111         if (to.isContract() && !_checkContractOnERC721Received(from, to, tokenId, _data)) {
1112             revert TransferToNonERC721ReceiverImplementer();
1113         }
1114     }
1115 
1116     /**
1117      * @dev Returns whether `tokenId` exists.
1118      *
1119      * Tokens can be managed by their owner or approved accounts via {approve} or {setApprovalForAll}.
1120      *
1121      * Tokens start existing when they are minted (`_mint`),
1122      */
1123     function _exists(uint256 tokenId) internal view returns (bool) {
1124         return _startTokenId() <= tokenId && tokenId < _currentIndex && !_ownerships[tokenId].burned;
1125     }
1126 
1127     function _safeMint(address to, uint256 quantity) internal {
1128         _safeMint(to, quantity, '');
1129     }
1130 
1131     /**
1132      * @dev Safely mints `quantity` tokens and transfers them to `to`.
1133      *
1134      * Requirements:
1135      *
1136      * - If `to` refers to a smart contract, it must implement {IERC721Receiver-onERC721Received}, which is called for each safe transfer.
1137      * - `quantity` must be greater than 0.
1138      *
1139      * Emits a {Transfer} event.
1140      */
1141     function _safeMint(
1142         address to,
1143         uint256 quantity,
1144         bytes memory _data
1145     ) internal {
1146         _mint(to, quantity, _data, true);
1147     }
1148 
1149     /**
1150      * @dev Mints `quantity` tokens and transfers them to `to`.
1151      *
1152      * Requirements:
1153      *
1154      * - `to` cannot be the zero address.
1155      * - `quantity` must be greater than 0.
1156      *
1157      * Emits a {Transfer} event.
1158      */
1159     function _mint(
1160         address to,
1161         uint256 quantity,
1162         bytes memory _data,
1163         bool safe
1164     ) internal {
1165         uint256 startTokenId = _currentIndex;
1166         if (to == address(0)) revert MintToZeroAddress();
1167         if (quantity == 0) revert MintZeroQuantity();
1168 
1169         _beforeTokenTransfers(address(0), to, startTokenId, quantity);
1170 
1171         // Overflows are incredibly unrealistic.
1172         // balance or numberMinted overflow if current value of either + quantity > 1.8e19 (2**64) - 1
1173         // updatedIndex overflows if _currentIndex + quantity > 1.2e77 (2**256) - 1
1174         unchecked {
1175             _addressData[to].balance += uint64(quantity);
1176             _addressData[to].numberMinted += uint64(quantity);
1177 
1178             _ownerships[startTokenId].addr = to;
1179             _ownerships[startTokenId].startTimestamp = uint64(block.timestamp);
1180 
1181             uint256 updatedIndex = startTokenId;
1182             uint256 end = updatedIndex + quantity;
1183 
1184             if (safe && to.isContract()) {
1185                 do {
1186                     emit Transfer(address(0), to, updatedIndex);
1187                     if (!_checkContractOnERC721Received(address(0), to, updatedIndex++, _data)) {
1188                         revert TransferToNonERC721ReceiverImplementer();
1189                     }
1190                 } while (updatedIndex != end);
1191                 // Reentrancy protection
1192                 if (_currentIndex != startTokenId) revert();
1193             } else {
1194                 do {
1195                     emit Transfer(address(0), to, updatedIndex++);
1196                 } while (updatedIndex != end);
1197             }
1198             _currentIndex = updatedIndex;
1199         }
1200         _afterTokenTransfers(address(0), to, startTokenId, quantity);
1201     }
1202 
1203     /**
1204      * @dev Transfers `tokenId` from `from` to `to`.
1205      *
1206      * Requirements:
1207      *
1208      * - `to` cannot be the zero address.
1209      * - `tokenId` token must be owned by `from`.
1210      *
1211      * Emits a {Transfer} event.
1212      */
1213     function _transfer(
1214         address from,
1215         address to,
1216         uint256 tokenId
1217     ) private {
1218         TokenOwnership memory prevOwnership = _ownershipOf(tokenId);
1219 
1220         if (prevOwnership.addr != from) revert TransferFromIncorrectOwner();
1221 
1222         bool isApprovedOrOwner = (_msgSender() == from ||
1223             isApprovedForAll(from, _msgSender()) ||
1224             getApproved(tokenId) == _msgSender());
1225 
1226         if (!isApprovedOrOwner) revert TransferCallerNotOwnerNorApproved();
1227         if (to == address(0)) revert TransferToZeroAddress();
1228 
1229         _beforeTokenTransfers(from, to, tokenId, 1);
1230 
1231         // Clear approvals from the previous owner
1232         _approve(address(0), tokenId, from);
1233 
1234         // Underflow of the sender's balance is impossible because we check for
1235         // ownership above and the recipient's balance can't realistically overflow.
1236         // Counter overflow is incredibly unrealistic as tokenId would have to be 2**256.
1237         unchecked {
1238             _addressData[from].balance -= 1;
1239             _addressData[to].balance += 1;
1240 
1241             TokenOwnership storage currSlot = _ownerships[tokenId];
1242             currSlot.addr = to;
1243             currSlot.startTimestamp = uint64(block.timestamp);
1244 
1245             // If the ownership slot of tokenId+1 is not explicitly set, that means the transfer initiator owns it.
1246             // Set the slot of tokenId+1 explicitly in storage to maintain correctness for ownerOf(tokenId+1) calls.
1247             uint256 nextTokenId = tokenId + 1;
1248             TokenOwnership storage nextSlot = _ownerships[nextTokenId];
1249             if (nextSlot.addr == address(0)) {
1250                 // This will suffice for checking _exists(nextTokenId),
1251                 // as a burned slot cannot contain the zero address.
1252                 if (nextTokenId != _currentIndex) {
1253                     nextSlot.addr = from;
1254                     nextSlot.startTimestamp = prevOwnership.startTimestamp;
1255                 }
1256             }
1257         }
1258 
1259         emit Transfer(from, to, tokenId);
1260         _afterTokenTransfers(from, to, tokenId, 1);
1261     }
1262 
1263     /**
1264      * @dev This is equivalent to _burn(tokenId, false)
1265      */
1266     function _burn(uint256 tokenId) internal virtual {
1267         _burn(tokenId, false);
1268     }
1269 
1270     /**
1271      * @dev Destroys `tokenId`.
1272      * The approval is cleared when the token is burned.
1273      *
1274      * Requirements:
1275      *
1276      * - `tokenId` must exist.
1277      *
1278      * Emits a {Transfer} event.
1279      */
1280     function _burn(uint256 tokenId, bool approvalCheck) internal virtual {
1281         TokenOwnership memory prevOwnership = _ownershipOf(tokenId);
1282 
1283         address from = prevOwnership.addr;
1284 
1285         if (approvalCheck) {
1286             bool isApprovedOrOwner = (_msgSender() == from ||
1287                 isApprovedForAll(from, _msgSender()) ||
1288                 getApproved(tokenId) == _msgSender());
1289 
1290             if (!isApprovedOrOwner) revert TransferCallerNotOwnerNorApproved();
1291         }
1292 
1293         _beforeTokenTransfers(from, address(0), tokenId, 1);
1294 
1295         // Clear approvals from the previous owner
1296         _approve(address(0), tokenId, from);
1297 
1298         // Underflow of the sender's balance is impossible because we check for
1299         // ownership above and the recipient's balance can't realistically overflow.
1300         // Counter overflow is incredibly unrealistic as tokenId would have to be 2**256.
1301         unchecked {
1302             AddressData storage addressData = _addressData[from];
1303             addressData.balance -= 1;
1304             addressData.numberBurned += 1;
1305 
1306             // Keep track of who burned the token, and the timestamp of burning.
1307             TokenOwnership storage currSlot = _ownerships[tokenId];
1308             currSlot.addr = from;
1309             currSlot.startTimestamp = uint64(block.timestamp);
1310             currSlot.burned = true;
1311 
1312             // If the ownership slot of tokenId+1 is not explicitly set, that means the burn initiator owns it.
1313             // Set the slot of tokenId+1 explicitly in storage to maintain correctness for ownerOf(tokenId+1) calls.
1314             uint256 nextTokenId = tokenId + 1;
1315             TokenOwnership storage nextSlot = _ownerships[nextTokenId];
1316             if (nextSlot.addr == address(0)) {
1317                 // This will suffice for checking _exists(nextTokenId),
1318                 // as a burned slot cannot contain the zero address.
1319                 if (nextTokenId != _currentIndex) {
1320                     nextSlot.addr = from;
1321                     nextSlot.startTimestamp = prevOwnership.startTimestamp;
1322                 }
1323             }
1324         }
1325 
1326         emit Transfer(from, address(0), tokenId);
1327         _afterTokenTransfers(from, address(0), tokenId, 1);
1328 
1329         // Overflow not possible, as _burnCounter cannot be exceed _currentIndex times.
1330         unchecked {
1331             _burnCounter++;
1332         }
1333     }
1334 
1335     /**
1336      * @dev Approve `to` to operate on `tokenId`
1337      *
1338      * Emits a {Approval} event.
1339      */
1340     function _approve(
1341         address to,
1342         uint256 tokenId,
1343         address owner
1344     ) private {
1345         _tokenApprovals[tokenId] = to;
1346         emit Approval(owner, to, tokenId);
1347     }
1348 
1349     /**
1350      * @dev Internal function to invoke {IERC721Receiver-onERC721Received} on a target contract.
1351      *
1352      * @param from address representing the previous owner of the given token ID
1353      * @param to target address that will receive the tokens
1354      * @param tokenId uint256 ID of the token to be transferred
1355      * @param _data bytes optional data to send along with the call
1356      * @return bool whether the call correctly returned the expected magic value
1357      */
1358     function _checkContractOnERC721Received(
1359         address from,
1360         address to,
1361         uint256 tokenId,
1362         bytes memory _data
1363     ) private returns (bool) {
1364         try IERC721Receiver(to).onERC721Received(_msgSender(), from, tokenId, _data) returns (bytes4 retval) {
1365             return retval == IERC721Receiver(to).onERC721Received.selector;
1366         } catch (bytes memory reason) {
1367             if (reason.length == 0) {
1368                 revert TransferToNonERC721ReceiverImplementer();
1369             } else {
1370                 assembly {
1371                     revert(add(32, reason), mload(reason))
1372                 }
1373             }
1374         }
1375     }
1376 
1377     /**
1378      * @dev Hook that is called before a set of serially-ordered token ids are about to be transferred. This includes minting.
1379      * And also called before burning one token.
1380      *
1381      * startTokenId - the first token id to be transferred
1382      * quantity - the amount to be transferred
1383      *
1384      * Calling conditions:
1385      *
1386      * - When `from` and `to` are both non-zero, `from`'s `tokenId` will be
1387      * transferred to `to`.
1388      * - When `from` is zero, `tokenId` will be minted for `to`.
1389      * - When `to` is zero, `tokenId` will be burned by `from`.
1390      * - `from` and `to` are never both zero.
1391      */
1392     function _beforeTokenTransfers(
1393         address from,
1394         address to,
1395         uint256 startTokenId,
1396         uint256 quantity
1397     ) internal virtual {}
1398 
1399     /**
1400      * @dev Hook that is called after a set of serially-ordered token ids have been transferred. This includes
1401      * minting.
1402      * And also called after one token has been burned.
1403      *
1404      * startTokenId - the first token id to be transferred
1405      * quantity - the amount to be transferred
1406      *
1407      * Calling conditions:
1408      *
1409      * - When `from` and `to` are both non-zero, `from`'s `tokenId` has been
1410      * transferred to `to`.
1411      * - When `from` is zero, `tokenId` has been minted for `to`.
1412      * - When `to` is zero, `tokenId` has been burned by `from`.
1413      * - `from` and `to` are never both zero.
1414      */
1415     function _afterTokenTransfers(
1416         address from,
1417         address to,
1418         uint256 startTokenId,
1419         uint256 quantity
1420     ) internal virtual {}
1421 }
1422 
1423 // File: contracts/TutorialErc721A.sol
1424 
1425 
1426 
1427 
1428 
1429 pragma solidity >=0.8.9 <0.9.0;
1430 
1431 
1432 
1433 
1434 
1435 
1436 
1437 contract LiveInTheNowNFT is ERC721A, Ownable, ReentrancyGuard {
1438 
1439 
1440 
1441   using Strings for uint256;
1442 
1443 
1444 
1445   string public uriPrefix = '';
1446 
1447   string public uriSuffix = '.json';
1448 
1449   string public hiddenMetadataUri;
1450 
1451   
1452 
1453   uint256 public cost;
1454 
1455   uint256 public maxSupply;
1456 
1457   uint256 public maxMintAmountPerTx;
1458 
1459   uint256 public maxPerWallet;
1460 
1461 
1462 
1463   bool public paused = true;
1464 
1465   bool public revealed = false;
1466 
1467 
1468 
1469   constructor(
1470 
1471     string memory _tokenName,
1472 
1473     string memory _tokenSymbol,
1474 
1475     uint256 _cost,
1476 
1477     uint256 _maxSupply,
1478 
1479     uint256 _maxMintAmountPerTx,
1480     
1481     uint256 _maxPerWallet,
1482 
1483     string memory _hiddenMetadataUri
1484 
1485   ) ERC721A(_tokenName, _tokenSymbol) {
1486 
1487     setCost(_cost);
1488 
1489     setmaxSupply(_maxSupply);
1490 
1491     setMaxMintAmountPerTx(_maxMintAmountPerTx);
1492 
1493     setmaxPerWallet(_maxPerWallet);
1494 
1495     setHiddenMetadataUri(_hiddenMetadataUri);
1496 
1497   }
1498 
1499 
1500 
1501   modifier mintCompliance(uint256 _mintAmount) {
1502 
1503     require(_mintAmount > 0 && _mintAmount <= maxMintAmountPerTx, 'Invalid mint amount!');
1504 
1505     require(totalSupply() + _mintAmount <= maxSupply, 'Max supply exceeded!');
1506 
1507     require(balanceOf(msg.sender) + _mintAmount <= maxPerWallet, 'Per Wallet Limit Reached');
1508 
1509     _;
1510 
1511   }
1512 
1513 
1514 
1515   modifier mintPriceCompliance(uint256 _mintAmount) {
1516 
1517     require(msg.value >= cost * _mintAmount, 'Insufficient funds!');
1518 
1519     _;
1520 
1521   }
1522 
1523 
1524 
1525   function mint(uint256 _mintAmount) public payable mintCompliance(_mintAmount) mintPriceCompliance(_mintAmount) {
1526 
1527     require(!paused, 'The contract is paused!');
1528 
1529 
1530 
1531     _safeMint(_msgSender(), _mintAmount);
1532 
1533   }
1534 
1535   
1536 
1537   function ownerMint(uint256 _mintAmount, address _receiver) public mintCompliance(_mintAmount) onlyOwner {
1538 
1539     _safeMint(_receiver, _mintAmount);
1540 
1541   }
1542 
1543 
1544 
1545   function walletOfOwner(address _owner) public view returns (uint256[] memory) {
1546 
1547     uint256 ownerTokenCount = balanceOf(_owner);
1548 
1549     uint256[] memory ownedTokenIds = new uint256[](ownerTokenCount);
1550 
1551     uint256 currentTokenId = _startTokenId();
1552 
1553     uint256 ownedTokenIndex = 0;
1554 
1555     address latestOwnerAddress;
1556 
1557 
1558 
1559     while (ownedTokenIndex < ownerTokenCount && currentTokenId < _currentIndex) {
1560 
1561       TokenOwnership memory ownership = _ownerships[currentTokenId];
1562 
1563 
1564 
1565       if (!ownership.burned) {
1566 
1567         if (ownership.addr != address(0)) {
1568 
1569           latestOwnerAddress = ownership.addr;
1570 
1571         }
1572 
1573 
1574 
1575         if (latestOwnerAddress == _owner) {
1576 
1577           ownedTokenIds[ownedTokenIndex] = currentTokenId;
1578 
1579 
1580 
1581           ownedTokenIndex++;
1582 
1583         }
1584 
1585       }
1586 
1587 
1588 
1589       currentTokenId++;
1590 
1591     }
1592 
1593 
1594 
1595     return ownedTokenIds;
1596 
1597   }
1598 
1599 
1600 
1601   function _startTokenId() internal view virtual override returns (uint256) {
1602 
1603     return 1;
1604 
1605   }
1606 
1607 
1608 
1609   function tokenURI(uint256 _tokenId) public view virtual override returns (string memory) {
1610 
1611     require(_exists(_tokenId), 'ERC721Metadata: URI query for nonexistent token');
1612 
1613 
1614 
1615     if (revealed == false) {
1616 
1617       return hiddenMetadataUri;
1618 
1619     }
1620 
1621 
1622 
1623     string memory currentBaseURI = _baseURI();
1624 
1625     return bytes(currentBaseURI).length > 0
1626 
1627         ? string(abi.encodePacked(currentBaseURI, _tokenId.toString(), uriSuffix))
1628 
1629         : '';
1630 
1631   }
1632 
1633 
1634 
1635   function setRevealed(bool _state) public onlyOwner {
1636 
1637     revealed = _state;
1638 
1639   }
1640 
1641 
1642 
1643   function setCost(uint256 _cost) public onlyOwner {
1644 
1645     cost = _cost;
1646 
1647   }
1648 
1649 
1650 
1651   function setMaxMintAmountPerTx(uint256 _maxMintAmountPerTx) public onlyOwner {
1652 
1653     maxMintAmountPerTx = _maxMintAmountPerTx;
1654 
1655   }
1656 
1657 
1658  
1659   function setmaxSupply(uint256 _maxSupply) public onlyOwner {
1660 
1661     maxSupply = _maxSupply;
1662 
1663   }
1664 
1665 
1666 
1667    function setmaxPerWallet(uint256 _maxPerWallet) public onlyOwner {       
1668 
1669         maxPerWallet = _maxPerWallet;
1670 
1671   }
1672 
1673 
1674 
1675   function setHiddenMetadataUri(string memory _hiddenMetadataUri) public onlyOwner {
1676 
1677     hiddenMetadataUri = _hiddenMetadataUri;
1678 
1679   }
1680 
1681 
1682 
1683   function setUriPrefix(string memory _uriPrefix) public onlyOwner {
1684 
1685     uriPrefix = _uriPrefix;
1686 
1687   }
1688 
1689 
1690 
1691   function setUriSuffix(string memory _uriSuffix) public onlyOwner {
1692 
1693     uriSuffix = _uriSuffix;
1694 
1695   }
1696 
1697 
1698 
1699   function setPaused(bool _state) public onlyOwner {
1700 
1701     paused = _state;
1702 
1703   }
1704 
1705 
1706 
1707   function withdraw() public onlyOwner nonReentrant {
1708     // This will pay secondary wallets (team members) % of the initial sale.
1709     // // =============================================================================
1710     // (bool hs, ) = payable(0x2cb473fDdEBDe10c66BC2312b6b6109F594ef56d).call{value: address(this).balance * 20 / 100}('');
1711     // require(hs);
1712     // =============================================================================
1713 
1714     (bool os, ) = payable(owner()).call{value: address(this).balance}('');
1715     require(os);
1716     // =============================================================================
1717   }
1718 
1719 
1720 
1721   function _baseURI() internal view virtual override returns (string memory) {
1722 
1723     return uriPrefix;
1724 
1725   }
1726 
1727 }