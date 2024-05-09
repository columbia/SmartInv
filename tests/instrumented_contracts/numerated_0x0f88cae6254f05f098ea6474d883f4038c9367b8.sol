1 // File: @openzeppelin/contracts/utils/cryptography/MerkleProof.sol
2 
3 
4 // OpenZeppelin Contracts (last updated v4.5.0) (utils/cryptography/MerkleProof.sol)
5 
6 pragma solidity ^0.8.0;
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
46                 computedHash = _efficientHash(computedHash, proofElement);
47             } else {
48                 // Hash(current element of the proof + current computed hash)
49                 computedHash = _efficientHash(proofElement, computedHash);
50             }
51         }
52         return computedHash;
53     }
54 
55     function _efficientHash(bytes32 a, bytes32 b) private pure returns (bytes32 value) {
56         assembly {
57             mstore(0x00, a)
58             mstore(0x20, b)
59             value := keccak256(0x00, 0x40)
60         }
61     }
62 }
63 
64 // File: @openzeppelin/contracts/security/ReentrancyGuard.sol
65 
66 
67 // OpenZeppelin Contracts v4.4.1 (security/ReentrancyGuard.sol)
68 
69 pragma solidity ^0.8.0;
70 
71 /**
72  * @dev Contract module that helps prevent reentrant calls to a function.
73  *
74  * Inheriting from `ReentrancyGuard` will make the {nonReentrant} modifier
75  * available, which can be applied to functions to make sure there are no nested
76  * (reentrant) calls to them.
77  *
78  * Note that because there is a single `nonReentrant` guard, functions marked as
79  * `nonReentrant` may not call one another. This can be worked around by making
80  * those functions `private`, and then adding `external` `nonReentrant` entry
81  * points to them.
82  *
83  * TIP: If you would like to learn more about reentrancy and alternative ways
84  * to protect against it, check out our blog post
85  * https://blog.openzeppelin.com/reentrancy-after-istanbul/[Reentrancy After Istanbul].
86  */
87 abstract contract ReentrancyGuard {
88     // Booleans are more expensive than uint256 or any type that takes up a full
89     // word because each write operation emits an extra SLOAD to first read the
90     // slot's contents, replace the bits taken up by the boolean, and then write
91     // back. This is the compiler's defense against contract upgrades and
92     // pointer aliasing, and it cannot be disabled.
93 
94     // The values being non-zero value makes deployment a bit more expensive,
95     // but in exchange the refund on every call to nonReentrant will be lower in
96     // amount. Since refunds are capped to a percentage of the total
97     // transaction's gas, it is best to keep them low in cases like this one, to
98     // increase the likelihood of the full refund coming into effect.
99     uint256 private constant _NOT_ENTERED = 1;
100     uint256 private constant _ENTERED = 2;
101 
102     uint256 private _status;
103 
104     constructor() {
105         _status = _NOT_ENTERED;
106     }
107 
108     /**
109      * @dev Prevents a contract from calling itself, directly or indirectly.
110      * Calling a `nonReentrant` function from another `nonReentrant`
111      * function is not supported. It is possible to prevent this from happening
112      * by making the `nonReentrant` function external, and making it call a
113      * `private` function that does the actual work.
114      */
115     modifier nonReentrant() {
116         // On the first call to nonReentrant, _notEntered will be true
117         require(_status != _ENTERED, "ReentrancyGuard: reentrant call");
118 
119         // Any calls to nonReentrant after this point will fail
120         _status = _ENTERED;
121 
122         _;
123 
124         // By storing the original value once again, a refund is triggered (see
125         // https://eips.ethereum.org/EIPS/eip-2200)
126         _status = _NOT_ENTERED;
127     }
128 }
129 
130 // File: @openzeppelin/contracts/utils/Strings.sol
131 
132 
133 // OpenZeppelin Contracts v4.4.1 (utils/Strings.sol)
134 
135 pragma solidity ^0.8.0;
136 
137 /**
138  * @dev String operations.
139  */
140 library Strings {
141     bytes16 private constant _HEX_SYMBOLS = "0123456789abcdef";
142 
143     /**
144      * @dev Converts a `uint256` to its ASCII `string` decimal representation.
145      */
146     function toString(uint256 value) internal pure returns (string memory) {
147         // Inspired by OraclizeAPI's implementation - MIT licence
148         // https://github.com/oraclize/ethereum-api/blob/b42146b063c7d6ee1358846c198246239e9360e8/oraclizeAPI_0.4.25.sol
149 
150         if (value == 0) {
151             return "0";
152         }
153         uint256 temp = value;
154         uint256 digits;
155         while (temp != 0) {
156             digits++;
157             temp /= 10;
158         }
159         bytes memory buffer = new bytes(digits);
160         while (value != 0) {
161             digits -= 1;
162             buffer[digits] = bytes1(uint8(48 + uint256(value % 10)));
163             value /= 10;
164         }
165         return string(buffer);
166     }
167 
168     /**
169      * @dev Converts a `uint256` to its ASCII `string` hexadecimal representation.
170      */
171     function toHexString(uint256 value) internal pure returns (string memory) {
172         if (value == 0) {
173             return "0x00";
174         }
175         uint256 temp = value;
176         uint256 length = 0;
177         while (temp != 0) {
178             length++;
179             temp >>= 8;
180         }
181         return toHexString(value, length);
182     }
183 
184     /**
185      * @dev Converts a `uint256` to its ASCII `string` hexadecimal representation with fixed length.
186      */
187     function toHexString(uint256 value, uint256 length) internal pure returns (string memory) {
188         bytes memory buffer = new bytes(2 * length + 2);
189         buffer[0] = "0";
190         buffer[1] = "x";
191         for (uint256 i = 2 * length + 1; i > 1; --i) {
192             buffer[i] = _HEX_SYMBOLS[value & 0xf];
193             value >>= 4;
194         }
195         require(value == 0, "Strings: hex length insufficient");
196         return string(buffer);
197     }
198 }
199 
200 // File: @openzeppelin/contracts/utils/Context.sol
201 
202 
203 // OpenZeppelin Contracts v4.4.1 (utils/Context.sol)
204 
205 pragma solidity ^0.8.0;
206 
207 /**
208  * @dev Provides information about the current execution context, including the
209  * sender of the transaction and its data. While these are generally available
210  * via msg.sender and msg.data, they should not be accessed in such a direct
211  * manner, since when dealing with meta-transactions the account sending and
212  * paying for execution may not be the actual sender (as far as an application
213  * is concerned).
214  *
215  * This contract is only required for intermediate, library-like contracts.
216  */
217 abstract contract Context {
218     function _msgSender() internal view virtual returns (address) {
219         return msg.sender;
220     }
221 
222     function _msgData() internal view virtual returns (bytes calldata) {
223         return msg.data;
224     }
225 }
226 
227 // File: @openzeppelin/contracts/access/Ownable.sol
228 
229 
230 // OpenZeppelin Contracts v4.4.1 (access/Ownable.sol)
231 
232 pragma solidity ^0.8.0;
233 
234 
235 /**
236  * @dev Contract module which provides a basic access control mechanism, where
237  * there is an account (an owner) that can be granted exclusive access to
238  * specific functions.
239  *
240  * By default, the owner account will be the one that deploys the contract. This
241  * can later be changed with {transferOwnership}.
242  *
243  * This module is used through inheritance. It will make available the modifier
244  * `onlyOwner`, which can be applied to your functions to restrict their use to
245  * the owner.
246  */
247 abstract contract Ownable is Context {
248     address private _owner;
249 
250     event OwnershipTransferred(address indexed previousOwner, address indexed newOwner);
251 
252     /**
253      * @dev Initializes the contract setting the deployer as the initial owner.
254      */
255     constructor() {
256         _transferOwnership(_msgSender());
257     }
258 
259     /**
260      * @dev Returns the address of the current owner.
261      */
262     function owner() public view virtual returns (address) {
263         return _owner;
264     }
265 
266     /**
267      * @dev Throws if called by any account other than the owner.
268      */
269     modifier onlyOwner() {
270         require(owner() == _msgSender(), "Ownable: caller is not the owner");
271         _;
272     }
273 
274     /**
275      * @dev Leaves the contract without owner. It will not be possible to call
276      * `onlyOwner` functions anymore. Can only be called by the current owner.
277      *
278      * NOTE: Renouncing ownership will leave the contract without an owner,
279      * thereby removing any functionality that is only available to the owner.
280      */
281     function renounceOwnership() public virtual onlyOwner {
282         _transferOwnership(address(0));
283     }
284 
285     /**
286      * @dev Transfers ownership of the contract to a new account (`newOwner`).
287      * Can only be called by the current owner.
288      */
289     function transferOwnership(address newOwner) public virtual onlyOwner {
290         require(newOwner != address(0), "Ownable: new owner is the zero address");
291         _transferOwnership(newOwner);
292     }
293 
294     /**
295      * @dev Transfers ownership of the contract to a new account (`newOwner`).
296      * Internal function without access restriction.
297      */
298     function _transferOwnership(address newOwner) internal virtual {
299         address oldOwner = _owner;
300         _owner = newOwner;
301         emit OwnershipTransferred(oldOwner, newOwner);
302     }
303 }
304 
305 // File: @openzeppelin/contracts/utils/Address.sol
306 
307 
308 // OpenZeppelin Contracts (last updated v4.5.0) (utils/Address.sol)
309 
310 pragma solidity ^0.8.1;
311 
312 /**
313  * @dev Collection of functions related to the address type
314  */
315 library Address {
316     /**
317      * @dev Returns true if `account` is a contract.
318      *
319      * [IMPORTANT]
320      * ====
321      * It is unsafe to assume that an address for which this function returns
322      * false is an externally-owned account (EOA) and not a contract.
323      *
324      * Among others, `isContract` will return false for the following
325      * types of addresses:
326      *
327      *  - an externally-owned account
328      *  - a contract in construction
329      *  - an address where a contract will be created
330      *  - an address where a contract lived, but was destroyed
331      * ====
332      *
333      * [IMPORTANT]
334      * ====
335      * You shouldn't rely on `isContract` to protect against flash loan attacks!
336      *
337      * Preventing calls from contracts is highly discouraged. It breaks composability, breaks support for smart wallets
338      * like Gnosis Safe, and does not provide security since it can be circumvented by calling from a contract
339      * constructor.
340      * ====
341      */
342     function isContract(address account) internal view returns (bool) {
343         // This method relies on extcodesize/address.code.length, which returns 0
344         // for contracts in construction, since the code is only stored at the end
345         // of the constructor execution.
346 
347         return account.code.length > 0;
348     }
349 
350     /**
351      * @dev Replacement for Solidity's `transfer`: sends `amount` wei to
352      * `recipient`, forwarding all available gas and reverting on errors.
353      *
354      * https://eips.ethereum.org/EIPS/eip-1884[EIP1884] increases the gas cost
355      * of certain opcodes, possibly making contracts go over the 2300 gas limit
356      * imposed by `transfer`, making them unable to receive funds via
357      * `transfer`. {sendValue} removes this limitation.
358      *
359      * https://diligence.consensys.net/posts/2019/09/stop-using-soliditys-transfer-now/[Learn more].
360      *
361      * IMPORTANT: because control is transferred to `recipient`, care must be
362      * taken to not create reentrancy vulnerabilities. Consider using
363      * {ReentrancyGuard} or the
364      * https://solidity.readthedocs.io/en/v0.5.11/security-considerations.html#use-the-checks-effects-interactions-pattern[checks-effects-interactions pattern].
365      */
366     function sendValue(address payable recipient, uint256 amount) internal {
367         require(address(this).balance >= amount, "Address: insufficient balance");
368 
369         (bool success, ) = recipient.call{value: amount}("");
370         require(success, "Address: unable to send value, recipient may have reverted");
371     }
372 
373     /**
374      * @dev Performs a Solidity function call using a low level `call`. A
375      * plain `call` is an unsafe replacement for a function call: use this
376      * function instead.
377      *
378      * If `target` reverts with a revert reason, it is bubbled up by this
379      * function (like regular Solidity function calls).
380      *
381      * Returns the raw returned data. To convert to the expected return value,
382      * use https://solidity.readthedocs.io/en/latest/units-and-global-variables.html?highlight=abi.decode#abi-encoding-and-decoding-functions[`abi.decode`].
383      *
384      * Requirements:
385      *
386      * - `target` must be a contract.
387      * - calling `target` with `data` must not revert.
388      *
389      * _Available since v3.1._
390      */
391     function functionCall(address target, bytes memory data) internal returns (bytes memory) {
392         return functionCall(target, data, "Address: low-level call failed");
393     }
394 
395     /**
396      * @dev Same as {xref-Address-functionCall-address-bytes-}[`functionCall`], but with
397      * `errorMessage` as a fallback revert reason when `target` reverts.
398      *
399      * _Available since v3.1._
400      */
401     function functionCall(
402         address target,
403         bytes memory data,
404         string memory errorMessage
405     ) internal returns (bytes memory) {
406         return functionCallWithValue(target, data, 0, errorMessage);
407     }
408 
409     /**
410      * @dev Same as {xref-Address-functionCall-address-bytes-}[`functionCall`],
411      * but also transferring `value` wei to `target`.
412      *
413      * Requirements:
414      *
415      * - the calling contract must have an ETH balance of at least `value`.
416      * - the called Solidity function must be `payable`.
417      *
418      * _Available since v3.1._
419      */
420     function functionCallWithValue(
421         address target,
422         bytes memory data,
423         uint256 value
424     ) internal returns (bytes memory) {
425         return functionCallWithValue(target, data, value, "Address: low-level call with value failed");
426     }
427 
428     /**
429      * @dev Same as {xref-Address-functionCallWithValue-address-bytes-uint256-}[`functionCallWithValue`], but
430      * with `errorMessage` as a fallback revert reason when `target` reverts.
431      *
432      * _Available since v3.1._
433      */
434     function functionCallWithValue(
435         address target,
436         bytes memory data,
437         uint256 value,
438         string memory errorMessage
439     ) internal returns (bytes memory) {
440         require(address(this).balance >= value, "Address: insufficient balance for call");
441         require(isContract(target), "Address: call to non-contract");
442 
443         (bool success, bytes memory returndata) = target.call{value: value}(data);
444         return verifyCallResult(success, returndata, errorMessage);
445     }
446 
447     /**
448      * @dev Same as {xref-Address-functionCall-address-bytes-}[`functionCall`],
449      * but performing a static call.
450      *
451      * _Available since v3.3._
452      */
453     function functionStaticCall(address target, bytes memory data) internal view returns (bytes memory) {
454         return functionStaticCall(target, data, "Address: low-level static call failed");
455     }
456 
457     /**
458      * @dev Same as {xref-Address-functionCall-address-bytes-string-}[`functionCall`],
459      * but performing a static call.
460      *
461      * _Available since v3.3._
462      */
463     function functionStaticCall(
464         address target,
465         bytes memory data,
466         string memory errorMessage
467     ) internal view returns (bytes memory) {
468         require(isContract(target), "Address: static call to non-contract");
469 
470         (bool success, bytes memory returndata) = target.staticcall(data);
471         return verifyCallResult(success, returndata, errorMessage);
472     }
473 
474     /**
475      * @dev Same as {xref-Address-functionCall-address-bytes-}[`functionCall`],
476      * but performing a delegate call.
477      *
478      * _Available since v3.4._
479      */
480     function functionDelegateCall(address target, bytes memory data) internal returns (bytes memory) {
481         return functionDelegateCall(target, data, "Address: low-level delegate call failed");
482     }
483 
484     /**
485      * @dev Same as {xref-Address-functionCall-address-bytes-string-}[`functionCall`],
486      * but performing a delegate call.
487      *
488      * _Available since v3.4._
489      */
490     function functionDelegateCall(
491         address target,
492         bytes memory data,
493         string memory errorMessage
494     ) internal returns (bytes memory) {
495         require(isContract(target), "Address: delegate call to non-contract");
496 
497         (bool success, bytes memory returndata) = target.delegatecall(data);
498         return verifyCallResult(success, returndata, errorMessage);
499     }
500 
501     /**
502      * @dev Tool to verifies that a low level call was successful, and revert if it wasn't, either by bubbling the
503      * revert reason using the provided one.
504      *
505      * _Available since v4.3._
506      */
507     function verifyCallResult(
508         bool success,
509         bytes memory returndata,
510         string memory errorMessage
511     ) internal pure returns (bytes memory) {
512         if (success) {
513             return returndata;
514         } else {
515             // Look for revert reason and bubble it up if present
516             if (returndata.length > 0) {
517                 // The easiest way to bubble the revert reason is using memory via assembly
518 
519                 assembly {
520                     let returndata_size := mload(returndata)
521                     revert(add(32, returndata), returndata_size)
522                 }
523             } else {
524                 revert(errorMessage);
525             }
526         }
527     }
528 }
529 
530 // File: @openzeppelin/contracts/token/ERC721/IERC721Receiver.sol
531 
532 
533 // OpenZeppelin Contracts v4.4.1 (token/ERC721/IERC721Receiver.sol)
534 
535 pragma solidity ^0.8.0;
536 
537 /**
538  * @title ERC721 token receiver interface
539  * @dev Interface for any contract that wants to support safeTransfers
540  * from ERC721 asset contracts.
541  */
542 interface IERC721Receiver {
543     /**
544      * @dev Whenever an {IERC721} `tokenId` token is transferred to this contract via {IERC721-safeTransferFrom}
545      * by `operator` from `from`, this function is called.
546      *
547      * It must return its Solidity selector to confirm the token transfer.
548      * If any other value is returned or the interface is not implemented by the recipient, the transfer will be reverted.
549      *
550      * The selector can be obtained in Solidity with `IERC721.onERC721Received.selector`.
551      */
552     function onERC721Received(
553         address operator,
554         address from,
555         uint256 tokenId,
556         bytes calldata data
557     ) external returns (bytes4);
558 }
559 
560 // File: @openzeppelin/contracts/utils/introspection/IERC165.sol
561 
562 
563 // OpenZeppelin Contracts v4.4.1 (utils/introspection/IERC165.sol)
564 
565 pragma solidity ^0.8.0;
566 
567 /**
568  * @dev Interface of the ERC165 standard, as defined in the
569  * https://eips.ethereum.org/EIPS/eip-165[EIP].
570  *
571  * Implementers can declare support of contract interfaces, which can then be
572  * queried by others ({ERC165Checker}).
573  *
574  * For an implementation, see {ERC165}.
575  */
576 interface IERC165 {
577     /**
578      * @dev Returns true if this contract implements the interface defined by
579      * `interfaceId`. See the corresponding
580      * https://eips.ethereum.org/EIPS/eip-165#how-interfaces-are-identified[EIP section]
581      * to learn more about how these ids are created.
582      *
583      * This function call must use less than 30 000 gas.
584      */
585     function supportsInterface(bytes4 interfaceId) external view returns (bool);
586 }
587 
588 // File: @openzeppelin/contracts/utils/introspection/ERC165.sol
589 
590 
591 // OpenZeppelin Contracts v4.4.1 (utils/introspection/ERC165.sol)
592 
593 pragma solidity ^0.8.0;
594 
595 
596 /**
597  * @dev Implementation of the {IERC165} interface.
598  *
599  * Contracts that want to implement ERC165 should inherit from this contract and override {supportsInterface} to check
600  * for the additional interface id that will be supported. For example:
601  *
602  * ```solidity
603  * function supportsInterface(bytes4 interfaceId) public view virtual override returns (bool) {
604  *     return interfaceId == type(MyInterface).interfaceId || super.supportsInterface(interfaceId);
605  * }
606  * ```
607  *
608  * Alternatively, {ERC165Storage} provides an easier to use but more expensive implementation.
609  */
610 abstract contract ERC165 is IERC165 {
611     /**
612      * @dev See {IERC165-supportsInterface}.
613      */
614     function supportsInterface(bytes4 interfaceId) public view virtual override returns (bool) {
615         return interfaceId == type(IERC165).interfaceId;
616     }
617 }
618 
619 // File: @openzeppelin/contracts/token/ERC721/IERC721.sol
620 
621 
622 // OpenZeppelin Contracts v4.4.1 (token/ERC721/IERC721.sol)
623 
624 pragma solidity ^0.8.0;
625 
626 
627 /**
628  * @dev Required interface of an ERC721 compliant contract.
629  */
630 interface IERC721 is IERC165 {
631     /**
632      * @dev Emitted when `tokenId` token is transferred from `from` to `to`.
633      */
634     event Transfer(address indexed from, address indexed to, uint256 indexed tokenId);
635 
636     /**
637      * @dev Emitted when `owner` enables `approved` to manage the `tokenId` token.
638      */
639     event Approval(address indexed owner, address indexed approved, uint256 indexed tokenId);
640 
641     /**
642      * @dev Emitted when `owner` enables or disables (`approved`) `operator` to manage all of its assets.
643      */
644     event ApprovalForAll(address indexed owner, address indexed operator, bool approved);
645 
646     /**
647      * @dev Returns the number of tokens in ``owner``'s account.
648      */
649     function balanceOf(address owner) external view returns (uint256 balance);
650 
651     /**
652      * @dev Returns the owner of the `tokenId` token.
653      *
654      * Requirements:
655      *
656      * - `tokenId` must exist.
657      */
658     function ownerOf(uint256 tokenId) external view returns (address owner);
659 
660     /**
661      * @dev Safely transfers `tokenId` token from `from` to `to`, checking first that contract recipients
662      * are aware of the ERC721 protocol to prevent tokens from being forever locked.
663      *
664      * Requirements:
665      *
666      * - `from` cannot be the zero address.
667      * - `to` cannot be the zero address.
668      * - `tokenId` token must exist and be owned by `from`.
669      * - If the caller is not `from`, it must be have been allowed to move this token by either {approve} or {setApprovalForAll}.
670      * - If `to` refers to a smart contract, it must implement {IERC721Receiver-onERC721Received}, which is called upon a safe transfer.
671      *
672      * Emits a {Transfer} event.
673      */
674     function safeTransferFrom(
675         address from,
676         address to,
677         uint256 tokenId
678     ) external;
679 
680     /**
681      * @dev Transfers `tokenId` token from `from` to `to`.
682      *
683      * WARNING: Usage of this method is discouraged, use {safeTransferFrom} whenever possible.
684      *
685      * Requirements:
686      *
687      * - `from` cannot be the zero address.
688      * - `to` cannot be the zero address.
689      * - `tokenId` token must be owned by `from`.
690      * - If the caller is not `from`, it must be approved to move this token by either {approve} or {setApprovalForAll}.
691      *
692      * Emits a {Transfer} event.
693      */
694     function transferFrom(
695         address from,
696         address to,
697         uint256 tokenId
698     ) external;
699 
700     /**
701      * @dev Gives permission to `to` to transfer `tokenId` token to another account.
702      * The approval is cleared when the token is transferred.
703      *
704      * Only a single account can be approved at a time, so approving the zero address clears previous approvals.
705      *
706      * Requirements:
707      *
708      * - The caller must own the token or be an approved operator.
709      * - `tokenId` must exist.
710      *
711      * Emits an {Approval} event.
712      */
713     function approve(address to, uint256 tokenId) external;
714 
715     /**
716      * @dev Returns the account approved for `tokenId` token.
717      *
718      * Requirements:
719      *
720      * - `tokenId` must exist.
721      */
722     function getApproved(uint256 tokenId) external view returns (address operator);
723 
724     /**
725      * @dev Approve or remove `operator` as an operator for the caller.
726      * Operators can call {transferFrom} or {safeTransferFrom} for any token owned by the caller.
727      *
728      * Requirements:
729      *
730      * - The `operator` cannot be the caller.
731      *
732      * Emits an {ApprovalForAll} event.
733      */
734     function setApprovalForAll(address operator, bool _approved) external;
735 
736     /**
737      * @dev Returns if the `operator` is allowed to manage all of the assets of `owner`.
738      *
739      * See {setApprovalForAll}
740      */
741     function isApprovedForAll(address owner, address operator) external view returns (bool);
742 
743     /**
744      * @dev Safely transfers `tokenId` token from `from` to `to`.
745      *
746      * Requirements:
747      *
748      * - `from` cannot be the zero address.
749      * - `to` cannot be the zero address.
750      * - `tokenId` token must exist and be owned by `from`.
751      * - If the caller is not `from`, it must be approved to move this token by either {approve} or {setApprovalForAll}.
752      * - If `to` refers to a smart contract, it must implement {IERC721Receiver-onERC721Received}, which is called upon a safe transfer.
753      *
754      * Emits a {Transfer} event.
755      */
756     function safeTransferFrom(
757         address from,
758         address to,
759         uint256 tokenId,
760         bytes calldata data
761     ) external;
762 }
763 
764 // File: @openzeppelin/contracts/token/ERC721/extensions/IERC721Enumerable.sol
765 
766 
767 // OpenZeppelin Contracts (last updated v4.5.0) (token/ERC721/extensions/IERC721Enumerable.sol)
768 
769 pragma solidity ^0.8.0;
770 
771 
772 /**
773  * @title ERC-721 Non-Fungible Token Standard, optional enumeration extension
774  * @dev See https://eips.ethereum.org/EIPS/eip-721
775  */
776 interface IERC721Enumerable is IERC721 {
777     /**
778      * @dev Returns the total amount of tokens stored by the contract.
779      */
780     function totalSupply() external view returns (uint256);
781 
782     /**
783      * @dev Returns a token ID owned by `owner` at a given `index` of its token list.
784      * Use along with {balanceOf} to enumerate all of ``owner``'s tokens.
785      */
786     function tokenOfOwnerByIndex(address owner, uint256 index) external view returns (uint256);
787 
788     /**
789      * @dev Returns a token ID at a given `index` of all the tokens stored by the contract.
790      * Use along with {totalSupply} to enumerate all tokens.
791      */
792     function tokenByIndex(uint256 index) external view returns (uint256);
793 }
794 
795 // File: @openzeppelin/contracts/token/ERC721/extensions/IERC721Metadata.sol
796 
797 
798 // OpenZeppelin Contracts v4.4.1 (token/ERC721/extensions/IERC721Metadata.sol)
799 
800 pragma solidity ^0.8.0;
801 
802 
803 /**
804  * @title ERC-721 Non-Fungible Token Standard, optional metadata extension
805  * @dev See https://eips.ethereum.org/EIPS/eip-721
806  */
807 interface IERC721Metadata is IERC721 {
808     /**
809      * @dev Returns the token collection name.
810      */
811     function name() external view returns (string memory);
812 
813     /**
814      * @dev Returns the token collection symbol.
815      */
816     function symbol() external view returns (string memory);
817 
818     /**
819      * @dev Returns the Uniform Resource Identifier (URI) for `tokenId` token.
820      */
821     function tokenURI(uint256 tokenId) external view returns (string memory);
822 }
823 
824 // File: contracts/nft.sol
825 
826 
827 
828 pragma solidity ^0.8.7;
829 
830 
831 
832 
833 
834 
835 
836 
837 
838 
839 
840 
841 
842 /**
843  * @dev Implementation of https://eips.ethereum.org/EIPS/eip-721[ERC721] Non-Fungible Token Standard, including
844  * the Metadata and Enumerable extension. Built to optimize for lower gas during batch mints.
845  *
846  * Assumes serials are sequentially minted starting at 0 (e.g. 0, 1, 2, 3..).
847  *
848  * Assumes the number of issuable tokens (collection size) is capped and fits in a uint128.
849  *
850  * Does not support burning tokens to address(0).
851  */
852 contract ERC721A is
853     Context,
854     ERC165,
855     IERC721,
856     IERC721Metadata,
857     IERC721Enumerable
858 {
859     using Address for address;
860     using Strings for uint256;
861 
862     struct TokenOwnership {
863         address addr;
864         uint64 startTimestamp;
865     }
866 
867     struct AddressData {
868         uint128 balance;
869         uint128 numberMinted;
870     }
871 
872     uint256 private currentIndex = 0;
873 
874     uint256 internal immutable collectionSize;
875     uint256 internal immutable maxBatchSize;
876 
877     // Token name
878     string private _name;
879 
880     // Token symbol
881     string private _symbol;
882 
883     // Mapping from token ID to ownership details
884     // An empty struct value does not necessarily mean the token is unowned. See ownershipOf implementation for details.
885     mapping(uint256 => TokenOwnership) private _ownerships;
886 
887     // Mapping owner address to address data
888     mapping(address => AddressData) private _addressData;
889 
890     // Mapping from token ID to approved address
891     mapping(uint256 => address) private _tokenApprovals;
892 
893     // Mapping from owner to operator approvals
894     mapping(address => mapping(address => bool)) private _operatorApprovals;
895 
896     //Mapping to check staking status
897     mapping(uint256 => uint256) private stakingData;
898 
899     /**
900      * @dev
901      * `maxBatchSize` refers to how much a minter can mint at a time.
902      * `collectionSize_` refers to how many tokens are in the collection.
903      */
904     constructor(
905         string memory name_,
906         string memory symbol_,
907         uint256 maxBatchSize_,
908         uint256 collectionSize_
909     ) {
910         require(
911             collectionSize_ > 0,
912             "ERC721A: collection must have a nonzero supply"
913         );
914         require(maxBatchSize_ > 0, "ERC721A: max batch size must be nonzero");
915         _name = name_;
916         _symbol = symbol_;
917         maxBatchSize = maxBatchSize_;
918         collectionSize = collectionSize_;
919     }
920 
921     /**
922      * @dev See {IERC721Enumerable-totalSupply}.
923      */
924     function totalSupply() public view override returns (uint256) {
925         return currentIndex;
926     }
927 
928     /**
929      * @dev See {IERC721Enumerable-tokenByIndex}.
930      */
931     function tokenByIndex(uint256 index)
932         public
933         view
934         override
935         returns (uint256)
936     {
937         require(index < totalSupply(), "ERC721A: global index out of bounds");
938         return index;
939     }
940 
941     /**
942      * @dev See {IERC721Enumerable-tokenOfOwnerByIndex}.
943      * This read function is O(collectionSize). If calling from a separate contract, be sure to test gas first.
944      * It may also degrade with extremely large collection sizes (e.g >> 10000), test for your use case.
945      */
946     function tokenOfOwnerByIndex(address owner, uint256 index)
947         public
948         view
949         override
950         returns (uint256)
951     {
952         require(index < balanceOf(owner), "ERC721A: owner index out of bounds");
953         uint256 numMintedSoFar = totalSupply();
954         uint256 tokenIdsIdx = 0;
955         address currOwnershipAddr = address(0);
956         for (uint256 i = 0; i < numMintedSoFar; i++) {
957             TokenOwnership memory ownership = _ownerships[i];
958             if (ownership.addr != address(0)) {
959                 currOwnershipAddr = ownership.addr;
960             }
961             if (currOwnershipAddr == owner) {
962                 if (tokenIdsIdx == index) {
963                     return i;
964                 }
965                 tokenIdsIdx++;
966             }
967         }
968         revert("ERC721A: unable to get token of owner by index");
969     }
970 
971     /**
972      * @dev See {IERC165-supportsInterface}.
973      */
974     function supportsInterface(bytes4 interfaceId)
975         public
976         view
977         virtual
978         override(ERC165, IERC165)
979         returns (bool)
980     {
981         return
982             interfaceId == type(IERC721).interfaceId ||
983             interfaceId == type(IERC721Metadata).interfaceId ||
984             interfaceId == type(IERC721Enumerable).interfaceId ||
985             super.supportsInterface(interfaceId);
986     }
987 
988     /**
989      * @dev See {IERC721-balanceOf}.
990      */
991     function balanceOf(address owner) public view override returns (uint256) {
992         require(
993             owner != address(0),
994             "ERC721A: balance query for the zero address"
995         );
996         return uint256(_addressData[owner].balance);
997     }
998 
999     function _numberMinted(address owner) internal view returns (uint256) {
1000         require(
1001             owner != address(0),
1002             "ERC721A: number minted query for the zero address"
1003         );
1004         return uint256(_addressData[owner].numberMinted);
1005     }
1006 
1007     function ownershipOf(uint256 tokenId)
1008         internal
1009         view
1010         returns (TokenOwnership memory)
1011     {
1012         require(_exists(tokenId), "ERC721A: owner query for nonexistent token");
1013 
1014         uint256 lowestTokenToCheck;
1015         if (tokenId >= maxBatchSize) {
1016             lowestTokenToCheck = tokenId - maxBatchSize + 1;
1017         }
1018 
1019         for (uint256 curr = tokenId; curr >= lowestTokenToCheck; curr--) {
1020             TokenOwnership memory ownership = _ownerships[curr];
1021             if (ownership.addr != address(0)) {
1022                 return ownership;
1023             }
1024         }
1025 
1026         revert("ERC721A: unable to determine the owner of token");
1027     }
1028 
1029     /**
1030      * @dev See {IERC721-ownerOf}.
1031      */
1032     function ownerOf(uint256 tokenId) public view override returns (address) {
1033         return ownershipOf(tokenId).addr;
1034     }
1035 
1036     /**
1037      * @dev See {IERC721Metadata-name}.
1038      */
1039     function name() public view virtual override returns (string memory) {
1040         return _name;
1041     }
1042 
1043     /**
1044      * @dev See {IERC721Metadata-symbol}.
1045      */
1046     function symbol() public view virtual override returns (string memory) {
1047         return _symbol;
1048     }
1049 
1050     /**
1051      * @dev See {IERC721Metadata-tokenURI}.
1052      */
1053     function tokenURI(uint256 tokenId)
1054         public
1055         view
1056         virtual
1057         override
1058         returns (string memory)
1059     {
1060         require(
1061             _exists(tokenId),
1062             "ERC721Metadata: URI query for nonexistent token"
1063         );
1064 
1065         string memory baseURI = _baseURI();
1066         return
1067             bytes(baseURI).length > 0
1068                 ? string(abi.encodePacked(baseURI, tokenId.toString()))
1069                 : "";
1070     }
1071 
1072     /**
1073      * @dev Base URI for computing {tokenURI}. If set, the resulting URI for each
1074      * token will be the concatenation of the `baseURI` and the `tokenId`. Empty
1075      * by default, can be overriden in child contracts.
1076      */
1077     function _baseURI() internal view virtual returns (string memory) {
1078         return "";
1079     }
1080 
1081     /**
1082      * @dev See {IERC721-approve}.
1083      */
1084     function approve(address to, uint256 tokenId) public override {
1085         address owner = ERC721A.ownerOf(tokenId);
1086         require(to != owner, "ERC721A: approval to current owner");
1087 
1088         require(
1089             _msgSender() == owner || isApprovedForAll(owner, _msgSender()),
1090             "ERC721A: approve caller is not owner nor approved for all"
1091         );
1092 
1093         _approve(to, tokenId, owner);
1094     }
1095 
1096     /**
1097      * @dev See {IERC721-getApproved}.
1098      */
1099     function getApproved(uint256 tokenId)
1100         public
1101         view
1102         override
1103         returns (address)
1104     {
1105         require(
1106             _exists(tokenId),
1107             "ERC721A: approved query for nonexistent token"
1108         );
1109 
1110         return _tokenApprovals[tokenId];
1111     }
1112 
1113     /**
1114      * @dev See {IERC721-setApprovalForAll}.
1115      */
1116     function setApprovalForAll(address operator, bool approved)
1117         public
1118         override
1119     {
1120         require(operator != _msgSender(), "ERC721A: approve to caller");
1121 
1122         _operatorApprovals[_msgSender()][operator] = approved;
1123         emit ApprovalForAll(_msgSender(), operator, approved);
1124     }
1125 
1126     /**
1127      * @dev See {IERC721-isApprovedForAll}.
1128      */
1129     function isApprovedForAll(address owner, address operator)
1130         public
1131         view
1132         virtual
1133         override
1134         returns (bool)
1135     {
1136         return _operatorApprovals[owner][operator];
1137     }
1138 
1139     /**
1140      * @dev See {IERC721-transferFrom}.
1141      */
1142     function transferFrom(
1143         address from,
1144         address to,
1145         uint256 tokenId
1146     ) public override {
1147         _transfer(from, to, tokenId);
1148     }
1149 
1150     /**
1151      * @dev See {IERC721-safeTransferFrom}.
1152      */
1153     function safeTransferFrom(
1154         address from,
1155         address to,
1156         uint256 tokenId
1157     ) public override {
1158         safeTransferFrom(from, to, tokenId, "");
1159     }
1160 
1161     /**
1162      * @dev See {IERC721-safeTransferFrom}.
1163      */
1164     function safeTransferFrom(
1165         address from,
1166         address to,
1167         uint256 tokenId,
1168         bytes memory _data
1169     ) public override {
1170         _transfer(from, to, tokenId);
1171         require(
1172             _checkOnERC721Received(from, to, tokenId, _data),
1173             "ERC721A: transfer to non ERC721Receiver implementer"
1174         );
1175     }
1176 
1177     /**
1178      * @dev Returns whether `tokenId` exists.
1179      *
1180      * Tokens can be managed by their owner or approved accounts via {approve} or {setApprovalForAll}.
1181      *
1182      * Tokens start existing when they are minted (`_mint`),
1183      */
1184     function _exists(uint256 tokenId) internal view returns (bool) {
1185         return tokenId < currentIndex;
1186     }
1187 
1188     function _safeMint(address to, uint256 quantity) internal {
1189         _safeMint(to, quantity, "");
1190     }
1191 
1192     event stakingEnabled(address _owner, uint256[] _tokenID);
1193     event unstaked(address _owner, uint256[] _tokenID);
1194     event claimed(address _owner, uint256[] _tokenID);
1195 
1196     // Start staking
1197     function enableMultiStaking(uint256[] calldata tokenIds)
1198         external
1199         returns (bool)
1200     {
1201         uint256 tokenId = 0;
1202         for (uint256 i = 0; i < tokenIds.length; i++) {
1203             tokenId = tokenIds[i];
1204             require(msg.sender == ownerOf(tokenId), "Not the owner of nft");
1205             require(stakingData[tokenId] == 0, "Staking Already Enabled");
1206             stakingData[tokenId] = block.timestamp;
1207         }
1208         emit stakingEnabled(ownershipOf(tokenId).addr, tokenIds);
1209         return true;
1210     }
1211 
1212     //Function to claim and optional unstake multiple nfts
1213     function multiUpdateStaking(uint256[] calldata tokenIds, bool unStake)
1214         external
1215         returns (uint256[] memory stakedTime)
1216     {
1217         uint256[] memory stakedTimes = new uint256[](tokenIds.length);
1218         for (uint256 i = 0; i < tokenIds.length; i++) {
1219             uint256 tokenId = tokenIds[i];
1220             bool isApprovedOrOwner = (_msgSender() ==
1221                 ownershipOf(tokenId).addr ||
1222                 getApproved(tokenId) == _msgSender() ||
1223                 isApprovedForAll(ownershipOf(tokenId).addr, _msgSender()));
1224             require(isApprovedOrOwner, "Sender is not owner or approved");
1225             uint256 stakingStartTime = stakingData[tokenId];
1226             require(stakingStartTime > 0, "NFT not staked"); // Make Sure call is only for staked NFTs
1227             stakedTimes[i] = block.timestamp - stakingStartTime; //  Storing Time NFT was staked for
1228             if (unStake) {
1229                 stakingData[tokenId] = 0;
1230             } else {
1231                 stakingData[tokenId] = block.timestamp; // Setting Current time as staking start time
1232             }
1233         }
1234         if (unStake) {
1235             emit unstaked(_msgSender(), tokenIds);
1236         } else {
1237             emit claimed(_msgSender(), tokenIds);
1238         }
1239         return stakedTimes;
1240     }
1241 
1242     // Unstake the NFT
1243     //   function disableStaking(uint256 tokenId) external returns(bool){
1244 
1245     //     bool isApprovedOrOwner = (_msgSender() == ownershipOf(tokenId).addr ||
1246     //       getApproved(tokenId) == _msgSender() ||
1247     //       isApprovedForAll(ownershipOf(tokenId).addr, _msgSender()));
1248     //     uint256 stakingStartTime = stakingData[tokenId];
1249     //     require(stakingStartTime != 0, "NFT not staked");
1250     //     // require(stakingStartTime < block.timestamp, "Staking not started");
1251     //     require(isApprovedOrOwner, "Sender is not owner or approved");
1252     //     // uint256 stakedTime = block.timestamp - stakingStartTime;
1253     //     stakingData[tokenId] = 0;
1254     //     emit unstaked(ownershipOf(tokenId).addr,tokenId);
1255     //     return true;
1256     //   }
1257 
1258     function getStakingTime(uint256 tokenId) external view returns (uint256) {
1259         uint256 stakingStartTime = stakingData[tokenId];
1260         return stakingStartTime;
1261     }
1262 
1263     /**
1264      * @dev Mints `quantity` tokens and transfers them to `to`.
1265      *
1266      * Requirements:
1267      *
1268      * - there must be `quantity` tokens remaining unminted in the total collection.
1269      * - `to` cannot be the zero address.
1270      * - `quantity` cannot be larger than the max batch size.
1271      *
1272      * Emits a {Transfer} event.
1273      */
1274     function _safeMint(
1275         address to,
1276         uint256 quantity,
1277         bytes memory _data
1278     ) internal {
1279         uint256 startTokenId = currentIndex;
1280         require(to != address(0), "ERC721A: mint to the zero address");
1281         // We know if the first token in the batch doesn't exist, the other ones don't as well, because of serial ordering.
1282         require(!_exists(startTokenId), "ERC721A: token already minted");
1283         require(quantity <= maxBatchSize, "ERC721A: quantity to mint too high");
1284 
1285         _beforeTokenTransfers(address(0), to, startTokenId, quantity);
1286 
1287         AddressData memory addressData = _addressData[to];
1288         _addressData[to] = AddressData(
1289             addressData.balance + uint64(quantity),
1290             addressData.numberMinted + uint64(quantity)
1291         );
1292         _ownerships[startTokenId] = TokenOwnership(to, uint64(block.timestamp));
1293 
1294         uint256 updatedIndex = startTokenId;
1295 
1296         for (uint256 i = 0; i < quantity; i++) {
1297             emit Transfer(address(0), to, updatedIndex);
1298             require(
1299                 _checkOnERC721Received(address(0), to, updatedIndex, _data),
1300                 "ERC721A: transfer to non ERC721Receiver implementer"
1301             );
1302             updatedIndex++;
1303         }
1304 
1305         currentIndex = updatedIndex;
1306         _afterTokenTransfers(address(0), to, startTokenId, quantity);
1307     }
1308 
1309     function resetMintCountForWhiteList(address _addr) internal {
1310         _addressData[_addr].numberMinted = 0;
1311     }
1312 
1313     /**
1314      * @dev Transfers `tokenId` from `from` to `to`.
1315      *
1316      * Requirements:
1317      *
1318      * - `to` cannot be the zero address.
1319      * - `tokenId` token must be owned by `from`.
1320      *
1321      * Emits a {Transfer} event.
1322      */
1323     function _transfer(
1324         address from,
1325         address to,
1326         uint256 tokenId
1327     ) private {
1328         require(
1329             stakingData[tokenId] == 0,
1330             "Staking enabled, Disable staking to transfer"
1331         );
1332         TokenOwnership memory prevOwnership = ownershipOf(tokenId);
1333 
1334         bool isApprovedOrOwner = (_msgSender() == prevOwnership.addr ||
1335             getApproved(tokenId) == _msgSender() ||
1336             isApprovedForAll(prevOwnership.addr, _msgSender()));
1337 
1338         require(
1339             isApprovedOrOwner,
1340             "ERC721A: transfer caller is not owner nor approved"
1341         );
1342 
1343         require(
1344             prevOwnership.addr == from,
1345             "ERC721A: transfer from incorrect owner"
1346         );
1347         require(to != address(0), "ERC721A: transfer to the zero address");
1348 
1349         _beforeTokenTransfers(from, to, tokenId, 1);
1350 
1351         // Clear approvals from the previous owner
1352         _approve(address(0), tokenId, prevOwnership.addr);
1353 
1354         _addressData[from].balance -= 1;
1355         _addressData[to].balance += 1;
1356         _ownerships[tokenId] = TokenOwnership(to, uint64(block.timestamp));
1357 
1358         // If the ownership slot of tokenId+1 is not explicitly set, that means the transfer initiator owns it.
1359         // Set the slot of tokenId+1 explicitly in storage to maintain correctness for ownerOf(tokenId+1) calls.
1360         uint256 nextTokenId = tokenId + 1;
1361         if (_ownerships[nextTokenId].addr == address(0)) {
1362             if (_exists(nextTokenId)) {
1363                 _ownerships[nextTokenId] = TokenOwnership(
1364                     prevOwnership.addr,
1365                     prevOwnership.startTimestamp
1366                 );
1367             }
1368         }
1369 
1370         emit Transfer(from, to, tokenId);
1371         _afterTokenTransfers(from, to, tokenId, 1);
1372     }
1373 
1374     /**
1375      * @dev Approve `to` to operate on `tokenId`
1376      *
1377      * Emits a {Approval} event.
1378      */
1379     function _approve(
1380         address to,
1381         uint256 tokenId,
1382         address owner
1383     ) private {
1384         _tokenApprovals[tokenId] = to;
1385         emit Approval(owner, to, tokenId);
1386     }
1387 
1388     uint256 public nextOwnerToExplicitlySet = 0;
1389 
1390     /**
1391      * @dev Explicitly set `owners` to eliminate loops in future calls of ownerOf().
1392      */
1393     function _setOwnersExplicit(uint256 quantity) internal {
1394         uint256 oldNextOwnerToSet = nextOwnerToExplicitlySet;
1395         require(quantity > 0, "quantity must be nonzero");
1396         uint256 endIndex = oldNextOwnerToSet + quantity - 1;
1397         if (endIndex > collectionSize - 1) {
1398             endIndex = collectionSize - 1;
1399         }
1400         // We know if the last one in the group exists, all in the group exist, due to serial ordering.
1401         require(_exists(endIndex), "not enough minted yet for this cleanup");
1402         for (uint256 i = oldNextOwnerToSet; i <= endIndex; i++) {
1403             if (_ownerships[i].addr == address(0)) {
1404                 TokenOwnership memory ownership = ownershipOf(i);
1405                 _ownerships[i] = TokenOwnership(
1406                     ownership.addr,
1407                     ownership.startTimestamp
1408                 );
1409             }
1410         }
1411         nextOwnerToExplicitlySet = endIndex + 1;
1412     }
1413 
1414     /**
1415      * @dev Internal function to invoke {IERC721Receiver-onERC721Received} on a target address.
1416      * The call is not executed if the target address is not a contract.
1417      *
1418      * @param from address representing the previous owner of the given token ID
1419      * @param to target address that will receive the tokens
1420      * @param tokenId uint256 ID of the token to be transferred
1421      * @param _data bytes optional data to send along with the call
1422      * @return bool whether the call correctly returned the expected magic value
1423      */
1424     function _checkOnERC721Received(
1425         address from,
1426         address to,
1427         uint256 tokenId,
1428         bytes memory _data
1429     ) private returns (bool) {
1430         if (to.isContract()) {
1431             try
1432                 IERC721Receiver(to).onERC721Received(
1433                     _msgSender(),
1434                     from,
1435                     tokenId,
1436                     _data
1437                 )
1438             returns (bytes4 retval) {
1439                 return retval == IERC721Receiver(to).onERC721Received.selector;
1440             } catch (bytes memory reason) {
1441                 if (reason.length == 0) {
1442                     revert(
1443                         "ERC721A: transfer to non ERC721Receiver implementer"
1444                     );
1445                 } else {
1446                     assembly {
1447                         revert(add(32, reason), mload(reason))
1448                     }
1449                 }
1450             }
1451         } else {
1452             return true;
1453         }
1454     }
1455 
1456     /**
1457      * @dev Hook that is called before a set of serially-ordered token ids are about to be transferred. This includes minting.
1458      *
1459      * startTokenId - the first token id to be transferred
1460      * quantity - the amount to be transferred
1461      *
1462      * Calling conditions:
1463      *
1464      * - When `from` and `to` are both non-zero, ``from``'s `tokenId` will be
1465      * transferred to `to`.
1466      * - When `from` is zero, `tokenId` will be minted for `to`.
1467      */
1468     function _beforeTokenTransfers(
1469         address from,
1470         address to,
1471         uint256 startTokenId,
1472         uint256 quantity
1473     ) internal virtual {}
1474 
1475     /**
1476      * @dev Hook that is called after a set of serially-ordered token ids have been transferred. This includes
1477      * minting.
1478      *
1479      * startTokenId - the first token id to be transferred
1480      * quantity - the amount to be transferred
1481      *
1482      * Calling conditions:
1483      *
1484      * - when `from` and `to` are both non-zero.
1485      * - `from` and `to` are never both zero.
1486      */
1487     function _afterTokenTransfers(
1488         address from,
1489         address to,
1490         uint256 startTokenId,
1491         uint256 quantity
1492     ) internal virtual {}
1493 }
1494 
1495 pragma solidity ^0.8.0;
1496 
1497 //Pubic Mint: price, max supply
1498 //Private Mint: max amount for team
1499 //Whitelist Mint: merkle tree
1500 
1501 contract Kawakami is Ownable, ERC721A, ReentrancyGuard {
1502     uint256 public immutable maxPerAddressDuringMint;
1503     uint256 public immutable amountForDevs;
1504     uint256 public immutable whitelistMaxPerAddress;
1505 
1506     //Root for merkel tree whitelisting
1507     bytes32 private root;
1508 
1509     struct SaleConfig {
1510         uint32 publicSaleStartTime;
1511         uint64 whitelistPrice;
1512         uint64 publicPrice;
1513     }
1514 
1515     SaleConfig private saleConfig;
1516 
1517     mapping(address => uint256) private whitelistMintCount;
1518 
1519     constructor(
1520         uint256 maxBatchSize_,
1521         uint256 collectionSize_,
1522         uint256 amountForDevs_,
1523         uint256 whitelistSize_
1524     ) ERC721A("Kawakami", "Kawakami", maxBatchSize_, collectionSize_) {
1525         maxPerAddressDuringMint = maxBatchSize_;
1526         amountForDevs = amountForDevs_;
1527         whitelistMaxPerAddress = whitelistSize_;
1528     }
1529 
1530     //test public mint
1531     function publicMint(uint256 quantity) external payable {
1532         uint256 publicPrice = uint256(saleConfig.publicPrice);
1533         uint256 publicSaleStartTime = uint256(saleConfig.publicSaleStartTime);
1534         require(
1535             totalSupply() + quantity <= collectionSize,
1536             "reached max supply"
1537         ); //Can't mint more than collectionSize
1538         require(
1539             isPublicSaleOn(publicPrice, publicSaleStartTime),
1540             "Public sale has not begun yet"
1541         );
1542         require(
1543             numberMinted(msg.sender) + quantity <= maxPerAddressDuringMint,
1544             "can not mint this many"
1545         );
1546         require(msg.value == publicPrice * quantity, "Check Ether amount sent");
1547 
1548         _safeMint(msg.sender, quantity);
1549     }
1550 
1551     //whitelistMint
1552     function whitelistMint(bytes32[] calldata _proof, uint256 quantity)
1553         external
1554         payable
1555     {
1556         uint256 price = uint256(saleConfig.whitelistPrice);
1557         require(price != 0, "Whitelist sale has not begun yet");
1558         require(
1559             block.timestamp < saleConfig.publicSaleStartTime,
1560             "Public Mint started, Whitelisted Mint Closed"
1561         );
1562         require(msg.value == (price * quantity), "Incorrect eth amount");
1563         bytes32 leaf = keccak256(abi.encodePacked(msg.sender));
1564         require(MerkleProof.verify(_proof, root, leaf), "Incorrect proof");
1565         require(
1566             whitelistMintCount[msg.sender] + quantity <= whitelistMaxPerAddress,
1567             "Whitelist Limit Exceeded"
1568         );
1569 
1570         whitelistMintCount[msg.sender] =
1571             whitelistMintCount[msg.sender] +
1572             quantity;
1573         _safeMint(msg.sender, quantity);
1574         resetMintCountForWhiteList(msg.sender);
1575     }
1576 
1577     function checkValidity(bytes32[] calldata _merkleProof)
1578         public
1579         view
1580         returns (bool)
1581     {
1582         bytes32 leaf = keccak256(abi.encodePacked(msg.sender));
1583         require(
1584             MerkleProof.verify(_merkleProof, root, leaf),
1585             "Incorrect proof"
1586         );
1587         return true; // Or you can mint tokens here
1588     }
1589 
1590     function setRoot(bytes32 _root) external onlyOwner {
1591         root = _root;
1592     }
1593 
1594     function refundIfOver(uint256 price) private {
1595         require(msg.value >= price, "Need to send more ETH.");
1596         if (msg.value > price) {
1597             payable(msg.sender).transfer(msg.value - price);
1598         }
1599     }
1600 
1601     function isPublicSaleOn(uint256 publicPriceWei, uint256 publicSaleStartTime)
1602         public
1603         view
1604         returns (bool)
1605     {
1606         return publicPriceWei != 0 && block.timestamp >= publicSaleStartTime;
1607     }
1608 
1609     function getWhiteistMintCount(address _address) public view returns(uint256){
1610         return whitelistMintCount[_address];
1611     } 
1612 
1613     function getSaleConfig() public view returns(SaleConfig memory){
1614         return saleConfig;
1615     }
1616 
1617     function setPublicMintInfo(
1618         uint64 whitelistPriceWei,
1619         uint64 publicPriceWei,
1620         uint32 publicSaleStartTime
1621     ) external onlyOwner {
1622         saleConfig = SaleConfig(
1623             publicSaleStartTime,
1624             whitelistPriceWei,
1625             publicPriceWei
1626         );
1627     }
1628 
1629     // For marketing etc.
1630     function devMint(uint256 quantity) external onlyOwner {
1631         require(
1632             totalSupply() + quantity <= amountForDevs,
1633             "too many already minted before dev mint"
1634         );
1635         require(
1636             quantity % maxBatchSize == 0,
1637             "can only mint a multiple of the maxBatchSize"
1638         );
1639         uint256 numChunks = quantity / maxBatchSize;
1640         for (uint256 i = 0; i < numChunks; i++) {
1641             _safeMint(msg.sender, maxBatchSize);
1642         }
1643     }
1644 
1645     // // metadata URI
1646     string private _baseTokenURI;
1647 
1648     function _baseURI() internal view virtual override returns (string memory) {
1649         return _baseTokenURI;
1650     }
1651 
1652     function setBaseURI(string calldata baseURI) external onlyOwner {
1653         _baseTokenURI = baseURI;
1654     }
1655 
1656     function withdrawMoney() external onlyOwner nonReentrant {
1657         (bool success, ) = msg.sender.call{value: address(this).balance}("");
1658         require(success, "Transfer failed.");
1659     }
1660 
1661     function setOwnersExplicit(uint256 quantity)
1662         external
1663         onlyOwner
1664         nonReentrant
1665     {
1666         _setOwnersExplicit(quantity);
1667     }
1668 
1669     function numberMinted(address owner) public view returns (uint256) {
1670         return _numberMinted(owner);
1671     }
1672 
1673     function getOwnershipData(uint256 tokenId)
1674         external
1675         view
1676         returns (TokenOwnership memory)
1677     {
1678         return ownershipOf(tokenId);
1679     }
1680 
1681     function renounceOwnership() public virtual override onlyOwner {
1682         require(false, "Can't renounceOwnership");
1683     }
1684 }