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
824 // File: contracts/ERC721A.sol
825 
826 
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
837 
838 /**
839  * @dev Implementation of https://eips.ethereum.org/EIPS/eip-721[ERC721] Non-Fungible Token Standard, including
840  * the Metadata and Enumerable extension. Built to optimize for lower gas during batch mints.
841  *
842  * Assumes serials are sequentially minted starting at 0 (e.g. 0, 1, 2, 3..).
843  *
844  * Assumes the number of issuable tokens (collection size) is capped and fits in a uint128.
845  *
846  * Does not support burning tokens to address(0).
847  */
848 contract ERC721A is
849   Context,
850   ERC165,
851   IERC721,
852   IERC721Metadata,
853   IERC721Enumerable
854 {
855   using Address for address;
856   using Strings for uint256;
857 
858   struct TokenOwnership {
859     address addr;
860     uint64 startTimestamp;
861   }
862 
863   struct AddressData {
864     uint128 balance;
865     uint128 numberMinted;
866   }
867 
868   uint256 private currentIndex = 0;
869 
870   uint256 internal immutable collectionSize;
871   uint256 internal immutable maxBatchSize;
872 
873   // Token name
874   string private _name;
875 
876   // Token symbol
877   string private _symbol;
878 
879   // Mapping from token ID to ownership details
880   // An empty struct value does not necessarily mean the token is unowned. See ownershipOf implementation for details.
881   mapping(uint256 => TokenOwnership) private _ownerships;
882 
883   // Mapping owner address to address data
884   mapping(address => AddressData) private _addressData;
885 
886   // Mapping from token ID to approved address
887   mapping(uint256 => address) private _tokenApprovals;
888 
889   // Mapping from owner to operator approvals
890   mapping(address => mapping(address => bool)) private _operatorApprovals;
891 
892   /**
893    * @dev
894    * `maxBatchSize` refers to how much a minter can mint at a time.
895    * `collectionSize_` refers to how many tokens are in the collection.
896    */
897   constructor(
898     string memory name_,
899     string memory symbol_,
900     uint256 maxBatchSize_,
901     uint256 collectionSize_
902   ) {
903     require(
904       collectionSize_ > 0,
905       "ERC721A: collection must have a nonzero supply"
906     );
907     require(maxBatchSize_ > 0, "ERC721A: max batch size must be nonzero");
908     _name = name_;
909     _symbol = symbol_;
910     maxBatchSize = maxBatchSize_;
911     collectionSize = collectionSize_;
912   }
913 
914   /**
915    * @dev See {IERC721Enumerable-totalSupply}.
916    */
917   function totalSupply() public view override returns (uint256) {
918     return currentIndex;
919   }
920 
921   /**
922    * @dev See {IERC721Enumerable-tokenByIndex}.
923    */
924   function tokenByIndex(uint256 index) public view override returns (uint256) {
925     require(index < totalSupply(), "ERC721A: global index out of bounds");
926     return index;
927   }
928 
929   /**
930    * @dev See {IERC721Enumerable-tokenOfOwnerByIndex}.
931    * This read function is O(collectionSize). If calling from a separate contract, be sure to test gas first.
932    * It may also degrade with extremely large collection sizes (e.g >> 10000), test for your use case.
933    */
934   function tokenOfOwnerByIndex(address owner, uint256 index)
935     public
936     view
937     override
938     returns (uint256)
939   {
940     require(index < balanceOf(owner), "ERC721A: owner index out of bounds");
941     uint256 numMintedSoFar = totalSupply();
942     uint256 tokenIdsIdx = 0;
943     address currOwnershipAddr = address(0);
944     for (uint256 i = 0; i < numMintedSoFar; i++) {
945       TokenOwnership memory ownership = _ownerships[i];
946       if (ownership.addr != address(0)) {
947         currOwnershipAddr = ownership.addr;
948       }
949       if (currOwnershipAddr == owner) {
950         if (tokenIdsIdx == index) {
951           return i;
952         }
953         tokenIdsIdx++;
954       }
955     }
956     revert("ERC721A: unable to get token of owner by index");
957   }
958 
959   /**
960    * @dev See {IERC165-supportsInterface}.
961    */
962   function supportsInterface(bytes4 interfaceId)
963     public
964     view
965     virtual
966     override(ERC165, IERC165)
967     returns (bool)
968   {
969     return
970       interfaceId == type(IERC721).interfaceId ||
971       interfaceId == type(IERC721Metadata).interfaceId ||
972       interfaceId == type(IERC721Enumerable).interfaceId ||
973       super.supportsInterface(interfaceId);
974   }
975 
976   /**
977    * @dev See {IERC721-balanceOf}.
978    */
979   function balanceOf(address owner) public view override returns (uint256) {
980     require(owner != address(0), "ERC721A: balance query for the zero address");
981     return uint256(_addressData[owner].balance);
982   }
983 
984   function _numberMinted(address owner) internal view returns (uint256) {
985     require(
986       owner != address(0),
987       "ERC721A: number minted query for the zero address"
988     );
989     return uint256(_addressData[owner].numberMinted);
990   }
991 
992   function ownershipOf(uint256 tokenId)
993     internal
994     view
995     returns (TokenOwnership memory)
996   {
997     require(_exists(tokenId), "ERC721A: owner query for nonexistent token");
998 
999     uint256 lowestTokenToCheck;
1000     if (tokenId >= maxBatchSize) {
1001       lowestTokenToCheck = tokenId - maxBatchSize + 1;
1002     }
1003 
1004     for (uint256 curr = tokenId; curr >= lowestTokenToCheck; curr--) {
1005       TokenOwnership memory ownership = _ownerships[curr];
1006       if (ownership.addr != address(0)) {
1007         return ownership;
1008       }
1009     }
1010 
1011     revert("ERC721A: unable to determine the owner of token");
1012   }
1013 
1014   /**
1015    * @dev See {IERC721-ownerOf}.
1016    */
1017   function ownerOf(uint256 tokenId) public view override returns (address) {
1018     return ownershipOf(tokenId).addr;
1019   }
1020 
1021   /**
1022    * @dev See {IERC721Metadata-name}.
1023    */
1024   function name() public view virtual override returns (string memory) {
1025     return _name;
1026   }
1027 
1028   /**
1029    * @dev See {IERC721Metadata-symbol}.
1030    */
1031   function symbol() public view virtual override returns (string memory) {
1032     return _symbol;
1033   }
1034 
1035   /**
1036    * @dev See {IERC721Metadata-tokenURI}.
1037    */
1038   function tokenURI(uint256 tokenId)
1039     public
1040     view
1041     virtual
1042     override
1043     returns (string memory)
1044   {
1045     require(
1046       _exists(tokenId),
1047       "ERC721Metadata: URI query for nonexistent token"
1048     );
1049 
1050     string memory baseURI = _baseURI();
1051     return
1052       bytes(baseURI).length > 0
1053         ? string(abi.encodePacked(baseURI, tokenId.toString()))
1054         : "";
1055   }
1056 
1057   /**
1058    * @dev Base URI for computing {tokenURI}. If set, the resulting URI for each
1059    * token will be the concatenation of the `baseURI` and the `tokenId`. Empty
1060    * by default, can be overriden in child contracts.
1061    */
1062   function _baseURI() internal view virtual returns (string memory) {
1063     return "";
1064   }
1065 
1066   /**
1067    * @dev See {IERC721-approve}.
1068    */
1069   function approve(address to, uint256 tokenId) public override {
1070     address owner = ERC721A.ownerOf(tokenId);
1071     require(to != owner, "ERC721A: approval to current owner");
1072 
1073     require(
1074       _msgSender() == owner || isApprovedForAll(owner, _msgSender()),
1075       "ERC721A: approve caller is not owner nor approved for all"
1076     );
1077 
1078     _approve(to, tokenId, owner);
1079   }
1080 
1081   /**
1082    * @dev See {IERC721-getApproved}.
1083    */
1084   function getApproved(uint256 tokenId) public view override returns (address) {
1085     require(_exists(tokenId), "ERC721A: approved query for nonexistent token");
1086 
1087     return _tokenApprovals[tokenId];
1088   }
1089 
1090   /**
1091    * @dev See {IERC721-setApprovalForAll}.
1092    */
1093   function setApprovalForAll(address operator, bool approved) public override {
1094     require(operator != _msgSender(), "ERC721A: approve to caller");
1095 
1096     _operatorApprovals[_msgSender()][operator] = approved;
1097     emit ApprovalForAll(_msgSender(), operator, approved);
1098   }
1099 
1100   /**
1101    * @dev See {IERC721-isApprovedForAll}.
1102    */
1103   function isApprovedForAll(address owner, address operator)
1104     public
1105     view
1106     virtual
1107     override
1108     returns (bool)
1109   {
1110     return _operatorApprovals[owner][operator];
1111   }
1112 
1113   /**
1114    * @dev See {IERC721-transferFrom}.
1115    */
1116   function transferFrom(
1117     address from,
1118     address to,
1119     uint256 tokenId
1120   ) public override {
1121     _transfer(from, to, tokenId);
1122   }
1123 
1124   /**
1125    * @dev See {IERC721-safeTransferFrom}.
1126    */
1127   function safeTransferFrom(
1128     address from,
1129     address to,
1130     uint256 tokenId
1131   ) public override {
1132     safeTransferFrom(from, to, tokenId, "");
1133   }
1134 
1135   /**
1136    * @dev See {IERC721-safeTransferFrom}.
1137    */
1138   function safeTransferFrom(
1139     address from,
1140     address to,
1141     uint256 tokenId,
1142     bytes memory _data
1143   ) public override {
1144     _transfer(from, to, tokenId);
1145     require(
1146       _checkOnERC721Received(from, to, tokenId, _data),
1147       "ERC721A: transfer to non ERC721Receiver implementer"
1148     );
1149   }
1150 
1151   /**
1152    * @dev Returns whether `tokenId` exists.
1153    *
1154    * Tokens can be managed by their owner or approved accounts via {approve} or {setApprovalForAll}.
1155    *
1156    * Tokens start existing when they are minted (`_mint`),
1157    */
1158   function _exists(uint256 tokenId) internal view returns (bool) {
1159     return tokenId < currentIndex;
1160   }
1161 
1162   function _safeMint(address to, uint256 quantity) internal {
1163     _safeMint(to, quantity, "");
1164   }
1165 
1166   /**
1167    * @dev Mints `quantity` tokens and transfers them to `to`.
1168    *
1169    * Requirements:
1170    *
1171    * - there must be `quantity` tokens remaining unminted in the total collection.
1172    * - `to` cannot be the zero address.
1173    * - `quantity` cannot be larger than the max batch size.
1174    *
1175    * Emits a {Transfer} event.
1176    */
1177   function _safeMint(
1178     address to,
1179     uint256 quantity,
1180     bytes memory _data
1181   ) internal {
1182     uint256 startTokenId = currentIndex;
1183     require(to != address(0), "ERC721A: mint to the zero address");
1184     // We know if the first token in the batch doesn't exist, the other ones don't as well, because of serial ordering.
1185     require(!_exists(startTokenId), "ERC721A: token already minted");
1186     require(quantity <= maxBatchSize, "ERC721A: quantity to mint too high");
1187 
1188     _beforeTokenTransfers(address(0), to, startTokenId, quantity);
1189 
1190     AddressData memory addressData = _addressData[to];
1191     _addressData[to] = AddressData(
1192       addressData.balance + uint128(quantity),
1193       addressData.numberMinted + uint128(quantity)
1194     );
1195     _ownerships[startTokenId] = TokenOwnership(to, uint64(block.timestamp));
1196 
1197     uint256 updatedIndex = startTokenId;
1198 
1199     for (uint256 i = 0; i < quantity; i++) {
1200       emit Transfer(address(0), to, updatedIndex);
1201       require(
1202         _checkOnERC721Received(address(0), to, updatedIndex, _data),
1203         "ERC721A: transfer to non ERC721Receiver implementer"
1204       );
1205       updatedIndex++;
1206     }
1207 
1208     currentIndex = updatedIndex;
1209     _afterTokenTransfers(address(0), to, startTokenId, quantity);
1210   }
1211 
1212   /**
1213    * @dev Transfers `tokenId` from `from` to `to`.
1214    *
1215    * Requirements:
1216    *
1217    * - `to` cannot be the zero address.
1218    * - `tokenId` token must be owned by `from`.
1219    *
1220    * Emits a {Transfer} event.
1221    */
1222   function _transfer(
1223     address from,
1224     address to,
1225     uint256 tokenId
1226   ) private {
1227     TokenOwnership memory prevOwnership = ownershipOf(tokenId);
1228 
1229     bool isApprovedOrOwner = (_msgSender() == prevOwnership.addr ||
1230       getApproved(tokenId) == _msgSender() ||
1231       isApprovedForAll(prevOwnership.addr, _msgSender()));
1232 
1233     require(
1234       isApprovedOrOwner,
1235       "ERC721A: transfer caller is not owner nor approved"
1236     );
1237 
1238     require(
1239       prevOwnership.addr == from,
1240       "ERC721A: transfer from incorrect owner"
1241     );
1242     require(to != address(0), "ERC721A: transfer to the zero address");
1243 
1244     _beforeTokenTransfers(from, to, tokenId, 1);
1245 
1246     // Clear approvals from the previous owner
1247     _approve(address(0), tokenId, prevOwnership.addr);
1248 
1249     _addressData[from].balance -= 1;
1250     _addressData[to].balance += 1;
1251     _ownerships[tokenId] = TokenOwnership(to, uint64(block.timestamp));
1252 
1253     // If the ownership slot of tokenId+1 is not explicitly set, that means the transfer initiator owns it.
1254     // Set the slot of tokenId+1 explicitly in storage to maintain correctness for ownerOf(tokenId+1) calls.
1255     uint256 nextTokenId = tokenId + 1;
1256     if (_ownerships[nextTokenId].addr == address(0)) {
1257       if (_exists(nextTokenId)) {
1258         _ownerships[nextTokenId] = TokenOwnership(
1259           prevOwnership.addr,
1260           prevOwnership.startTimestamp
1261         );
1262       }
1263     }
1264 
1265     emit Transfer(from, to, tokenId);
1266     _afterTokenTransfers(from, to, tokenId, 1);
1267   }
1268 
1269   /**
1270    * @dev Approve `to` to operate on `tokenId`
1271    *
1272    * Emits a {Approval} event.
1273    */
1274   function _approve(
1275     address to,
1276     uint256 tokenId,
1277     address owner
1278   ) private {
1279     _tokenApprovals[tokenId] = to;
1280     emit Approval(owner, to, tokenId);
1281   }
1282 
1283   uint256 public nextOwnerToExplicitlySet = 0;
1284 
1285   /**
1286    * @dev Explicitly set `owners` to eliminate loops in future calls of ownerOf().
1287    */
1288   function _setOwnersExplicit(uint256 quantity) internal {
1289     uint256 oldNextOwnerToSet = nextOwnerToExplicitlySet;
1290     require(quantity > 0, "quantity must be nonzero");
1291     uint256 endIndex = oldNextOwnerToSet + quantity - 1;
1292     if (endIndex > collectionSize - 1) {
1293       endIndex = collectionSize - 1;
1294     }
1295     // We know if the last one in the group exists, all in the group exist, due to serial ordering.
1296     require(_exists(endIndex), "not enough minted yet for this cleanup");
1297     for (uint256 i = oldNextOwnerToSet; i <= endIndex; i++) {
1298       if (_ownerships[i].addr == address(0)) {
1299         TokenOwnership memory ownership = ownershipOf(i);
1300         _ownerships[i] = TokenOwnership(
1301           ownership.addr,
1302           ownership.startTimestamp
1303         );
1304       }
1305     }
1306     nextOwnerToExplicitlySet = endIndex + 1;
1307   }
1308 
1309   /**
1310    * @dev Internal function to invoke {IERC721Receiver-onERC721Received} on a target address.
1311    * The call is not executed if the target address is not a contract.
1312    *
1313    * @param from address representing the previous owner of the given token ID
1314    * @param to target address that will receive the tokens
1315    * @param tokenId uint256 ID of the token to be transferred
1316    * @param _data bytes optional data to send along with the call
1317    * @return bool whether the call correctly returned the expected magic value
1318    */
1319   function _checkOnERC721Received(
1320     address from,
1321     address to,
1322     uint256 tokenId,
1323     bytes memory _data
1324   ) private returns (bool) {
1325     if (to.isContract()) {
1326       try
1327         IERC721Receiver(to).onERC721Received(_msgSender(), from, tokenId, _data)
1328       returns (bytes4 retval) {
1329         return retval == IERC721Receiver(to).onERC721Received.selector;
1330       } catch (bytes memory reason) {
1331         if (reason.length == 0) {
1332           revert("ERC721A: transfer to non ERC721Receiver implementer");
1333         } else {
1334           assembly {
1335             revert(add(32, reason), mload(reason))
1336           }
1337         }
1338       }
1339     } else {
1340       return true;
1341     }
1342   }
1343 
1344   /**
1345    * @dev Hook that is called before a set of serially-ordered token ids are about to be transferred. This includes minting.
1346    *
1347    * startTokenId - the first token id to be transferred
1348    * quantity - the amount to be transferred
1349    *
1350    * Calling conditions:
1351    *
1352    * - When `from` and `to` are both non-zero, ``from``'s `tokenId` will be
1353    * transferred to `to`.
1354    * - When `from` is zero, `tokenId` will be minted for `to`.
1355    */
1356   function _beforeTokenTransfers(
1357     address from,
1358     address to,
1359     uint256 startTokenId,
1360     uint256 quantity
1361   ) internal virtual {}
1362 
1363   /**
1364    * @dev Hook that is called after a set of serially-ordered token ids have been transferred. This includes
1365    * minting.
1366    *
1367    * startTokenId - the first token id to be transferred
1368    * quantity - the amount to be transferred
1369    *
1370    * Calling conditions:
1371    *
1372    * - when `from` and `to` are both non-zero.
1373    * - `from` and `to` are never both zero.
1374    */
1375   function _afterTokenTransfers(
1376     address from,
1377     address to,
1378     uint256 startTokenId,
1379     uint256 quantity
1380   ) internal virtual {}
1381 }
1382 // File: contracts/Divergents.sol
1383 
1384 
1385 
1386 // WAGMI
1387 
1388 pragma solidity ^0.8.4;
1389 
1390 
1391 
1392 
1393 
1394 
1395 contract Divergents is ERC721A, Ownable, ReentrancyGuard {
1396 
1397 
1398     // metadata URI
1399     string private _baseTokenURI;
1400     string private _contractMetadataURI;
1401 
1402     //Tracked Variables
1403     bool public isPublicSaleOpen;
1404     bool public isWhitelistSaleOpen;
1405 
1406     // Approved Minters
1407     mapping(address => bool) public approvedTeamMinters;
1408     // mapping(address => uint) public approvedGuruMinters;
1409 
1410     // Whitelist Merkle
1411     bytes32 public merkleRoot;
1412 
1413     // payable wallet addresses
1414     address payable private _divergentsAddress;
1415     address payable private _devAddress;
1416 
1417     uint public discountedMints = 100;
1418     uint public discountedMintPrice = 80000000 gwei;
1419     uint public mintPrice = 100000000 gwei;
1420     uint private constant PAYMENT_GAS_LIMIT = 5000;
1421     uint private constant MAX_MINT = 2000; // Maximum that can be minted for sale (not including Guru mints)
1422     uint public constant MAX_PER_ORDER_SALE_MINT = 10;
1423     uint public constant MAX_PER_WALLET_WHITELIST_MINT = 3;
1424     mapping (address => uint) public totalMintedByAddress;
1425     uint public maxSupplyInSaleWave = 500;
1426 
1427 
1428 
1429     // Getter Functions
1430     function _baseURI() internal view virtual override returns (string memory) {
1431         return _baseTokenURI;
1432     }
1433 
1434     function numberMinted(address owner) public view returns (uint256) {
1435         return _numberMinted(owner);
1436     }
1437 
1438     function getOwnershipData(uint256 tokenId) public view returns (TokenOwnership memory) {
1439         return ownershipOf(tokenId);
1440     }
1441 
1442     function contractURI() public view returns (string memory) {
1443         return _contractMetadataURI;
1444     }
1445 
1446     function charactersRemaining() public view returns (uint16[10] memory) {
1447         return divergentCharacters;
1448     }
1449 
1450 
1451 
1452     // Setter functions (all must be onlyowner)
1453 
1454     function setBaseURI(string calldata baseURI) external onlyOwner {
1455         _baseTokenURI = baseURI;
1456     }
1457 
1458     function setContractMetadataURI(string memory contractMetadataURI) external onlyOwner {
1459         _contractMetadataURI = contractMetadataURI;
1460     }
1461 
1462     function setOwnersExplicit(uint256 quantity) external onlyOwner {
1463         _setOwnersExplicit(quantity);
1464     }
1465 
1466     function setIsPublicSaleOpen(bool locked) external onlyOwner {
1467         isPublicSaleOpen = locked;
1468     }
1469 
1470     function setIsWhitelistSaleOpen(bool locked) external onlyOwner {
1471         isWhitelistSaleOpen = locked;
1472     }
1473 
1474     function addToApprovedTeamMinters(address[] memory add) external onlyOwner {
1475         for (uint i = 0; i < add.length; i++) {
1476             approvedTeamMinters[add[i]] = true;
1477         }
1478     }
1479 
1480     function setMerkleRoot(bytes32 _merkleRoot) external onlyOwner {
1481         merkleRoot = _merkleRoot;
1482     }
1483 
1484     function setPayableAddresses(address payable divergentsAddress, address payable devAddress) external onlyOwner {
1485         _divergentsAddress = divergentsAddress;
1486         _devAddress = devAddress;
1487     }
1488 
1489     function setMintPrice (uint mintPriceInWei) external onlyOwner {
1490         mintPrice = mintPriceInWei;
1491     }
1492 
1493     function setDiscountedMintPrice (uint discMintPriceInWei) external onlyOwner {
1494         discountedMintPrice = discMintPriceInWei;
1495     }
1496 
1497     function setMaxSupplyInSaleWave (uint increaseWave) external onlyOwner {
1498         maxSupplyInSaleWave = increaseWave;
1499     }
1500 
1501 
1502 
1503     //Constructor
1504     constructor() ERC721A("TheDivergents", "DVRG", 25, 2022) {
1505         _baseTokenURI = "https://api.thedivergents.io/";
1506         _contractMetadataURI = "ipfs://QmUmQW3n8k79dEd4Wtjx1ujjdx1WB2dcoifnCDyu8v21hh";
1507 
1508     }
1509 
1510 
1511 
1512     // Characters Tracker
1513     uint16[10] public divergentCharacters = [200,200,200,200,200,200,200,200,200,200];
1514     uint public divergentGuru = 22;
1515     uint private reservedMint = 200;
1516 
1517 
1518     // Helper functions
1519     // Sum of arrays
1520     function sumOfArray (uint[10] memory array) internal pure returns (uint sum) { 
1521         for(uint i = 0; i < array.length; i++) {
1522             sum = sum + array[i];
1523         }
1524     }
1525 
1526     // Generate Merkle Leaf (to verify whitelisted address)
1527     function generateMerkleLeaf (address account) internal pure returns (bytes32) {
1528         return keccak256(abi.encodePacked(account));
1529     }
1530 
1531     // Calculate amount that needs to be paid
1532     function totalPaymentRequired (uint amountMinted) internal returns (uint) {
1533         uint discountedMintsRemaining = discountedMints;
1534         uint totalPrice;
1535         
1536         if(discountedMintsRemaining == 0) {
1537             totalPrice = amountMinted * mintPrice;
1538         } else if (discountedMintsRemaining >= amountMinted) { 
1539             totalPrice = amountMinted * discountedMintPrice;
1540             discountedMintsRemaining -= amountMinted; 
1541         } else {
1542             totalPrice = (discountedMintsRemaining * discountedMintPrice) + ((amountMinted-discountedMintsRemaining) * mintPrice);
1543             discountedMintsRemaining = 0;
1544         }
1545 
1546         discountedMints = discountedMintsRemaining;
1547         return totalPrice;
1548     }
1549 
1550     // Mint event - this is used to emit event indicating mint and what is minted
1551     event Minted (uint[10] charactersMinted, address receiver);
1552     event GuruMinted (uint totalGuruMinted, address receiver);
1553 
1554     // promoMultiMint - this mint is for marketing ,etc, minted directly to the wallet of the recepient
1555     // for each item, a random character is chosen and minted. Max inclusing team mint is 200 (tracking reserved mint)
1556     // only approved wallets
1557     function promoMultiMint (address receiver, uint quantity) public nonReentrant {
1558         require(approvedTeamMinters[msg.sender], "Minter not approved");
1559         require(reservedMint > 0, "No reserved mint remaining");
1560 
1561         uint16[10] memory characterTracker = divergentCharacters;
1562         uint[10] memory mintedCharacters;
1563 
1564         for (uint i= 0; i < quantity; i++ ){
1565             bytes32 newRandomSelection = keccak256(abi.encodePacked(block.difficulty, block.coinbase, i));
1566             uint pickCharacter = uint(newRandomSelection)%10;
1567             mintedCharacters[pickCharacter] += 1;
1568             characterTracker[pickCharacter] -= 1;
1569         }
1570 
1571         _safeMint(receiver, quantity);
1572 
1573         divergentCharacters = characterTracker;
1574 
1575         reservedMint -= quantity;
1576 
1577         emit Minted(mintedCharacters, receiver);
1578 
1579     }
1580 
1581     // promoMint
1582     function promoMint (address[] calldata receiver) public nonReentrant {
1583         require(approvedTeamMinters[msg.sender], "Minter not approved");
1584         require(reservedMint > 0, "No reserved mint remaining");
1585 
1586         uint16[10] memory characterTracker = divergentCharacters;
1587         
1588 
1589         for (uint i = 0; i < receiver.length; i++) {
1590             bytes32 newRandomSelection = keccak256(abi.encodePacked(block.difficulty, block.coinbase, i));
1591             uint pickCharacter = uint(newRandomSelection)%10;
1592             uint[10] memory mintedCharacters;
1593             mintedCharacters[pickCharacter] += 1;
1594             characterTracker[pickCharacter] -= 1;
1595 
1596             _safeMint(receiver[i], 1);
1597 
1598             emit Minted(mintedCharacters, receiver[i]);
1599         }
1600 
1601         divergentCharacters = characterTracker;
1602 
1603         reservedMint -= receiver.length;
1604 
1605     }
1606 
1607 
1608     //Guru minting
1609     function guruMint(address receiver, uint quantity) public nonReentrant {
1610         require(approvedTeamMinters[msg.sender], "Minter not approved");
1611         require(divergentGuru >= quantity, "Insufficient remaining Guru");
1612 
1613         // Mint
1614         _safeMint(msg.sender, quantity);
1615 
1616         // Net off against guruminted
1617         divergentGuru -= quantity;
1618 
1619         // emit event
1620         emit GuruMinted(quantity, receiver);
1621 
1622     }
1623 
1624 
1625     // whitelist mint
1626 
1627     function whitelistMint (uint[10] calldata mintList, bytes32[] calldata proof) public payable nonReentrant {
1628         require (isWhitelistSaleOpen, "WL sale not open");
1629         uint currentTotalSupply = totalSupply();
1630         require (currentTotalSupply < maxSupplyInSaleWave, "Sale wave filled");
1631         require (MerkleProof.verify(proof, merkleRoot, generateMerkleLeaf(msg.sender)), "User not in WL");
1632         uint totalRequested = sumOfArray(mintList);
1633         require ((totalMintedByAddress[msg.sender] + totalRequested) <= MAX_PER_WALLET_WHITELIST_MINT, "Insufficient WL allocation");
1634         require (msg.value >= (totalRequested * mintPrice), "Insufficient payment");
1635         require (currentTotalSupply < MAX_MINT, "Sold Out" );
1636 
1637         uint16[10] memory characterTracker = divergentCharacters;
1638         uint[10] memory mintedCharacters;
1639 
1640         for (uint i = 0; i < 10; i++) {
1641             
1642             if (mintList[i] != 0) {
1643                 if(characterTracker[i] != 0){
1644                     if (characterTracker[i] >= mintList[i]) {
1645                         mintedCharacters[i] += mintList[i];
1646                         characterTracker[i] -= uint16(mintList[i]);
1647 
1648                     } else { 
1649                         mintedCharacters[i] += uint(characterTracker[i]);
1650                         characterTracker[i] -= characterTracker[i];
1651                     }
1652 
1653                 }
1654             }
1655         }
1656 
1657         uint totalMinted = sumOfArray(mintedCharacters);
1658         require (totalMinted != 0, "No items to be minted");
1659 
1660         // Calculate how much to charge
1661         uint paymentRequired = totalPaymentRequired(totalMinted);
1662 
1663         _safeMint(msg.sender, totalMinted); // Only after all calculations
1664 
1665         // Pay
1666         // calculate amounts to transfer
1667         uint devAmount = (paymentRequired / 10000) * 1600;
1668         uint divergentsAmount = paymentRequired - devAmount;
1669         
1670         // transfer amounts to dev wallet
1671         (bool devSuccess, ) = _devAddress.call{ value:devAmount, gas: PAYMENT_GAS_LIMIT }("");
1672         require(devSuccess, "Dev payment failed");
1673         
1674         // transfer amounts to divergents wallet
1675         (bool divergentsSuccess, ) = _divergentsAddress.call{ value:divergentsAmount, gas: PAYMENT_GAS_LIMIT }("");
1676         require(divergentsSuccess, "Divergents payment failed");
1677 
1678         // Return any unneeded sum
1679         if (msg.value - paymentRequired > 0) {
1680             uint returnValue = msg.value - paymentRequired;
1681             (bool returnSuccess, ) = msg.sender.call{ value:returnValue, gas: PAYMENT_GAS_LIMIT }("");
1682             require(returnSuccess, "Return payment failed");
1683         }
1684 
1685         // Add to totalMintedByAddress
1686         totalMintedByAddress[msg.sender] += totalMinted;
1687 
1688         // Update divergentCharacters
1689         divergentCharacters = characterTracker;
1690 
1691         // Emit minted items
1692         emit Minted(mintedCharacters, msg.sender);
1693     }
1694 
1695     // Public Sale mint
1696     function saleMint (uint[10] calldata mintList) public payable nonReentrant {
1697         require(isPublicSaleOpen, "Public sale not open");
1698         uint currentTotalSupply = totalSupply();
1699         require (currentTotalSupply < maxSupplyInSaleWave, "Sale wave filled");
1700         uint totalRequested = sumOfArray(mintList);
1701         require(msg.value >= totalRequested * mintPrice, "Insufficient payment");
1702         require(totalRequested <= MAX_PER_ORDER_SALE_MINT, "Max purchase limit");
1703         require(currentTotalSupply < MAX_MINT, "Sold Out");
1704 
1705         uint16[10] memory characterTracker = divergentCharacters;
1706         uint[10] memory mintedCharacters;
1707 
1708         for (uint i = 0; i < 10; i++) {
1709             
1710             if (mintList[i] != 0) {
1711                 if(characterTracker[i] != 0){
1712                     if (characterTracker[i] >= mintList[i]) {
1713                         mintedCharacters[i] += mintList[i];
1714                         characterTracker[i] -= uint16(mintList[i]);
1715 
1716                     } else { 
1717                         mintedCharacters[i] += uint(characterTracker[i]);
1718                         characterTracker[i] -= characterTracker[i];
1719                     }
1720 
1721                 }
1722             }
1723         }
1724 
1725         uint totalMinted = sumOfArray(mintedCharacters);
1726         require (totalMinted != 0, "No items to be minted");
1727 
1728         // Calculate how much to charge
1729         uint paymentRequired = totalPaymentRequired(totalMinted);
1730 
1731         _safeMint(msg.sender, totalMinted); // Only after all calculations
1732 
1733         // Pay
1734         // calculate amounts to transfer
1735         uint devAmount = (paymentRequired / 10000) * 1600;
1736         uint divergentsAmount = paymentRequired - devAmount;
1737         
1738         // transfer amounts to dev wallet
1739         (bool devSuccess, ) = _devAddress.call{ value:devAmount, gas: PAYMENT_GAS_LIMIT }("");
1740         require(devSuccess, "Dev payment failed");
1741         
1742         // transfer amounts to divergents wallet
1743         (bool divergentsSuccess, ) = _divergentsAddress.call{ value:divergentsAmount, gas: PAYMENT_GAS_LIMIT }("");
1744         require(divergentsSuccess, "Divergents payment failed");
1745 
1746         // Return any unneeded sum
1747         if (msg.value - paymentRequired > 0) {
1748             uint returnValue = msg.value - paymentRequired;
1749             (bool returnSuccess, ) = msg.sender.call{ value:returnValue, gas: PAYMENT_GAS_LIMIT }("");
1750             require(returnSuccess, "Return payment failed");
1751         }
1752 
1753         // Add to totalMintedByAddress
1754         totalMintedByAddress[msg.sender] += totalMinted;
1755 
1756         // Update divergentCharacters
1757         divergentCharacters = characterTracker;
1758 
1759         // Emit minted items
1760         emit Minted(mintedCharacters, msg.sender);
1761 
1762     }
1763 
1764    
1765 
1766 }