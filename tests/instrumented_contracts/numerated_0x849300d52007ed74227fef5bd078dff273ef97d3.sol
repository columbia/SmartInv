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
824 // File: ERC721A.sol
825 
826 
827 // Creator: Chiru Labs
828 
829 pragma solidity ^0.8.4;
830 
831 
832 
833 
834 
835 
836 
837 
838 
839 error ApprovalCallerNotOwnerNorApproved();
840 error ApprovalQueryForNonexistentToken();
841 error ApproveToCaller();
842 error ApprovalToCurrentOwner();
843 error BalanceQueryForZeroAddress();
844 error MintedQueryForZeroAddress();
845 error MintToZeroAddress();
846 error MintZeroQuantity();
847 error OwnerIndexOutOfBounds();
848 error OwnerQueryForNonexistentToken();
849 error TokenIndexOutOfBounds();
850 error TransferCallerNotOwnerNorApproved();
851 error TransferFromIncorrectOwner();
852 error TransferToNonERC721ReceiverImplementer();
853 error TransferToZeroAddress();
854 error UnableDetermineTokenOwner();
855 error URIQueryForNonexistentToken();
856 
857 /**
858  * @dev Implementation of https://eips.ethereum.org/EIPS/eip-721[ERC721] Non-Fungible Token Standard, including
859  * the Metadata and Enumerable extension. Built to optimize for lower gas during batch mints.
860  *
861  * Assumes serials are sequentially minted starting at 0 (e.g. 0, 1, 2, 3..).
862  *
863  * Does not support burning tokens to address(0).
864  *
865  * Assumes that an owner cannot have more than the 2**128 - 1 (max value of uint128) of supply
866  */
867 contract ERC721A is Context, ERC165, IERC721, IERC721Metadata, IERC721Enumerable {
868     using Address for address;
869     using Strings for uint256;
870 
871     struct TokenOwnership {
872         address addr;
873         uint64 startTimestamp;
874     }
875 
876     struct AddressData {
877         uint128 balance;
878         uint128 numberMinted;
879     }
880 
881     uint256 internal _currentIndex;
882 
883     // Token name
884     string private _name;
885 
886     // Token symbol
887     string private _symbol;
888 
889     // Mapping from token ID to ownership details
890     // An empty struct value does not necessarily mean the token is unowned. See ownershipOf implementation for details.
891     mapping(uint256 => TokenOwnership) internal _ownerships;
892 
893     // Mapping owner address to address data
894     mapping(address => AddressData) private _addressData;
895 
896     // Mapping from token ID to approved address
897     mapping(uint256 => address) private _tokenApprovals;
898 
899     // Mapping from owner to operator approvals
900     mapping(address => mapping(address => bool)) private _operatorApprovals;
901 
902     constructor(string memory name_, string memory symbol_) {
903         _name = name_;
904         _symbol = symbol_;
905     }
906 
907     /**
908      * @dev See {IERC721Enumerable-totalSupply}.
909      */
910     function totalSupply() public view override returns (uint256) {
911         return _currentIndex;
912     }
913 
914     /**
915      * @dev See {IERC721Enumerable-tokenByIndex}.
916      */
917     function tokenByIndex(uint256 index) public view override returns (uint256) {
918         if (index >= totalSupply()) revert TokenIndexOutOfBounds();
919         return index;
920     }
921 
922     /**
923      * @dev See {IERC721Enumerable-tokenOfOwnerByIndex}.
924      * This read function is O(totalSupply). If calling from a separate contract, be sure to test gas first.
925      * It may also degrade with extremely large collection sizes (e.g >> 10000), test for your use case.
926      */
927     function tokenOfOwnerByIndex(address owner, uint256 index) public view override returns (uint256) {
928         if (index >= balanceOf(owner)) revert OwnerIndexOutOfBounds();
929         uint256 numMintedSoFar = totalSupply();
930         uint256 tokenIdsIdx;
931         address currOwnershipAddr;
932 
933         // Counter overflow is impossible as the loop breaks when uint256 i is equal to another uint256 numMintedSoFar.
934         unchecked {
935             for (uint256 i; i < numMintedSoFar; i++) {
936                 TokenOwnership memory ownership = _ownerships[i];
937                 if (ownership.addr != address(0)) {
938                     currOwnershipAddr = ownership.addr;
939                 }
940                 if (currOwnershipAddr == owner) {
941                     if (tokenIdsIdx == index) {
942                         return i;
943                     }
944                     tokenIdsIdx++;
945                 }
946             }
947         }
948 
949         // Execution should never reach this point.
950         assert(false);
951     }
952 
953     /**
954      * @dev See {IERC165-supportsInterface}.
955      */
956     function supportsInterface(bytes4 interfaceId) public view virtual override(ERC165, IERC165) returns (bool) {
957         return
958             interfaceId == type(IERC721).interfaceId ||
959             interfaceId == type(IERC721Metadata).interfaceId ||
960             interfaceId == type(IERC721Enumerable).interfaceId ||
961             super.supportsInterface(interfaceId);
962     }
963 
964     /**
965      * @dev See {IERC721-balanceOf}.
966      */
967     function balanceOf(address owner) public view override returns (uint256) {
968         if (owner == address(0)) revert BalanceQueryForZeroAddress();
969         return uint256(_addressData[owner].balance);
970     }
971 
972     function _numberMinted(address owner) internal view returns (uint256) {
973         if (owner == address(0)) revert MintedQueryForZeroAddress();
974         return uint256(_addressData[owner].numberMinted);
975     }
976 
977     /**
978      * Gas spent here starts off proportional to the maximum mint batch size.
979      * It gradually moves to O(1) as tokens get transferred around in the collection over time.
980      */
981     function ownershipOf(uint256 tokenId) internal view returns (TokenOwnership memory) {
982         if (!_exists(tokenId)) revert OwnerQueryForNonexistentToken();
983 
984         unchecked {
985             for (uint256 curr = tokenId;; curr--) {
986                 TokenOwnership memory ownership = _ownerships[curr];
987                 if (ownership.addr != address(0)) {
988                     return ownership;
989                 }
990             }
991         }
992     }
993 
994     /**
995      * @dev See {IERC721-ownerOf}.
996      */
997     function ownerOf(uint256 tokenId) public view override returns (address) {
998         return ownershipOf(tokenId).addr;
999     }
1000 
1001     /**
1002      * @dev See {IERC721Metadata-name}.
1003      */
1004     function name() public view virtual override returns (string memory) {
1005         return _name;
1006     }
1007 
1008     /**
1009      * @dev See {IERC721Metadata-symbol}.
1010      */
1011     function symbol() public view virtual override returns (string memory) {
1012         return _symbol;
1013     }
1014 
1015     /**
1016      * @dev See {IERC721Metadata-tokenURI}.
1017      */
1018     function tokenURI(uint256 tokenId) public view virtual override returns (string memory) {
1019         if (!_exists(tokenId)) revert URIQueryForNonexistentToken();
1020 
1021         string memory baseURI = _baseURI();
1022         return bytes(baseURI).length != 0 ? string(abi.encodePacked(baseURI, tokenId.toString())) : '';
1023     }
1024 
1025     /**
1026      * @dev Base URI for computing {tokenURI}. If set, the resulting URI for each
1027      * token will be the concatenation of the `baseURI` and the `tokenId`. Empty
1028      * by default, can be overriden in child contracts.
1029      */
1030     function _baseURI() internal view virtual returns (string memory) {
1031         return '';
1032     }
1033 
1034     /**
1035      * @dev See {IERC721-approve}.
1036      */
1037     function approve(address to, uint256 tokenId) public override {
1038         address owner = ERC721A.ownerOf(tokenId);
1039         if (to == owner) revert ApprovalToCurrentOwner();
1040 
1041         if (_msgSender() != owner && !isApprovedForAll(owner, _msgSender())) revert ApprovalCallerNotOwnerNorApproved();
1042 
1043         _approve(to, tokenId, owner);
1044     }
1045 
1046     /**
1047      * @dev See {IERC721-getApproved}.
1048      */
1049     function getApproved(uint256 tokenId) public view override returns (address) {
1050         if (!_exists(tokenId)) revert ApprovalQueryForNonexistentToken();
1051 
1052         return _tokenApprovals[tokenId];
1053     }
1054 
1055     /**
1056      * @dev See {IERC721-setApprovalForAll}.
1057      */
1058     function setApprovalForAll(address operator, bool approved) public override {
1059         if (operator == _msgSender()) revert ApproveToCaller();
1060 
1061         _operatorApprovals[_msgSender()][operator] = approved;
1062         emit ApprovalForAll(_msgSender(), operator, approved);
1063     }
1064 
1065     /**
1066      * @dev See {IERC721-isApprovedForAll}.
1067      */
1068     function isApprovedForAll(address owner, address operator) public view virtual override returns (bool) {
1069         return _operatorApprovals[owner][operator];
1070     }
1071 
1072     /**
1073      * @dev See {IERC721-transferFrom}.
1074      */
1075     function transferFrom(
1076         address from,
1077         address to,
1078         uint256 tokenId
1079     ) public virtual override {
1080         _transfer(from, to, tokenId);
1081     }
1082 
1083     /**
1084      * @dev See {IERC721-safeTransferFrom}.
1085      */
1086     function safeTransferFrom(
1087         address from,
1088         address to,
1089         uint256 tokenId
1090     ) public virtual override {
1091         safeTransferFrom(from, to, tokenId, '');
1092     }
1093 
1094     /**
1095      * @dev See {IERC721-safeTransferFrom}.
1096      */
1097     function safeTransferFrom(
1098         address from,
1099         address to,
1100         uint256 tokenId,
1101         bytes memory _data
1102     ) public override {
1103         _transfer(from, to, tokenId);
1104         if (!_checkOnERC721Received(from, to, tokenId, _data)) revert TransferToNonERC721ReceiverImplementer();
1105     }
1106 
1107     /**
1108      * @dev Returns whether `tokenId` exists.
1109      *
1110      * Tokens can be managed by their owner or approved accounts via {approve} or {setApprovalForAll}.
1111      *
1112      * Tokens start existing when they are minted (`_mint`),
1113      */
1114     function _exists(uint256 tokenId) internal view returns (bool) {
1115         return tokenId < _currentIndex;
1116     }
1117 
1118     function _safeMint(address to, uint256 quantity) internal {
1119         _safeMint(to, quantity, '');
1120     }
1121 
1122     /**
1123      * @dev Safely mints `quantity` tokens and transfers them to `to`.
1124      *
1125      * Requirements:
1126      *
1127      * - If `to` refers to a smart contract, it must implement {IERC721Receiver-onERC721Received}, which is called for each safe transfer.
1128      * - `quantity` must be greater than 0.
1129      *
1130      * Emits a {Transfer} event.
1131      */
1132     function _safeMint(
1133         address to,
1134         uint256 quantity,
1135         bytes memory _data
1136     ) internal {
1137         _mint(to, quantity, _data, true);
1138     }
1139 
1140     /**
1141      * @dev Mints `quantity` tokens and transfers them to `to`.
1142      *
1143      * Requirements:
1144      *
1145      * - `to` cannot be the zero address.
1146      * - `quantity` must be greater than 0.
1147      *
1148      * Emits a {Transfer} event.
1149      */
1150     function _mint(
1151         address to,
1152         uint256 quantity,
1153         bytes memory _data,
1154         bool safe
1155     ) internal {
1156         uint256 startTokenId = _currentIndex;
1157         if (to == address(0)) revert MintToZeroAddress();
1158         if (quantity == 0) revert MintZeroQuantity();
1159 
1160         _beforeTokenTransfers(address(0), to, startTokenId, quantity);
1161 
1162         // Overflows are incredibly unrealistic.
1163         // balance or numberMinted overflow if current value of either + quantity > 3.4e38 (2**128) - 1
1164         // updatedIndex overflows if _currentIndex + quantity > 1.56e77 (2**256) - 1
1165         unchecked {
1166             _addressData[to].balance += uint128(quantity);
1167             _addressData[to].numberMinted += uint128(quantity);
1168 
1169             _ownerships[startTokenId].addr = to;
1170             _ownerships[startTokenId].startTimestamp = uint64(block.timestamp);
1171 
1172             uint256 updatedIndex = startTokenId;
1173 
1174             for (uint256 i; i < quantity; i++) {
1175                 emit Transfer(address(0), to, updatedIndex);
1176                 if (safe && !_checkOnERC721Received(address(0), to, updatedIndex, _data)) {
1177                     revert TransferToNonERC721ReceiverImplementer();
1178                 }
1179 
1180                 updatedIndex++;
1181             }
1182 
1183             _currentIndex = updatedIndex;
1184         }
1185 
1186         _afterTokenTransfers(address(0), to, startTokenId, quantity);
1187     }
1188 
1189     /**
1190      * @dev Transfers `tokenId` from `from` to `to`.
1191      *
1192      * Requirements:
1193      *
1194      * - `to` cannot be the zero address.
1195      * - `tokenId` token must be owned by `from`.
1196      *
1197      * Emits a {Transfer} event.
1198      */
1199     function _transfer(
1200         address from,
1201         address to,
1202         uint256 tokenId
1203     ) private {
1204         TokenOwnership memory prevOwnership = ownershipOf(tokenId);
1205 
1206         bool isApprovedOrOwner = (_msgSender() == prevOwnership.addr ||
1207             isApprovedForAll(prevOwnership.addr, _msgSender()) ||
1208             getApproved(tokenId) == _msgSender());
1209 
1210         if (!isApprovedOrOwner) revert TransferCallerNotOwnerNorApproved();
1211         if (prevOwnership.addr != from) revert TransferFromIncorrectOwner();
1212         if (to == address(0)) revert TransferToZeroAddress();
1213 
1214         _beforeTokenTransfers(from, to, tokenId, 1);
1215 
1216         // Clear approvals from the previous owner
1217         _approve(address(0), tokenId, prevOwnership.addr);
1218 
1219         // Underflow of the sender's balance is impossible because we check for
1220         // ownership above and the recipient's balance can't realistically overflow.
1221         // Counter overflow is incredibly unrealistic as tokenId would have to be 2**256.
1222         unchecked {
1223             _addressData[from].balance -= 1;
1224             _addressData[to].balance += 1;
1225 
1226             _ownerships[tokenId].addr = to;
1227             _ownerships[tokenId].startTimestamp = uint64(block.timestamp);
1228 
1229             // If the ownership slot of tokenId+1 is not explicitly set, that means the transfer initiator owns it.
1230             // Set the slot of tokenId+1 explicitly in storage to maintain correctness for ownerOf(tokenId+1) calls.
1231             uint256 nextTokenId = tokenId + 1;
1232             if (_ownerships[nextTokenId].addr == address(0)) {
1233                 if (_exists(nextTokenId)) {
1234                     _ownerships[nextTokenId].addr = prevOwnership.addr;
1235                     _ownerships[nextTokenId].startTimestamp = prevOwnership.startTimestamp;
1236                 }
1237             }
1238         }
1239 
1240         emit Transfer(from, to, tokenId);
1241         _afterTokenTransfers(from, to, tokenId, 1);
1242     }
1243 
1244     /**
1245      * @dev Approve `to` to operate on `tokenId`
1246      *
1247      * Emits a {Approval} event.
1248      */
1249     function _approve(
1250         address to,
1251         uint256 tokenId,
1252         address owner
1253     ) private {
1254         _tokenApprovals[tokenId] = to;
1255         emit Approval(owner, to, tokenId);
1256     }
1257 
1258     /**
1259      * @dev Internal function to invoke {IERC721Receiver-onERC721Received} on a target address.
1260      * The call is not executed if the target address is not a contract.
1261      *
1262      * @param from address representing the previous owner of the given token ID
1263      * @param to target address that will receive the tokens
1264      * @param tokenId uint256 ID of the token to be transferred
1265      * @param _data bytes optional data to send along with the call
1266      * @return bool whether the call correctly returned the expected magic value
1267      */
1268     function _checkOnERC721Received(
1269         address from,
1270         address to,
1271         uint256 tokenId,
1272         bytes memory _data
1273     ) private returns (bool) {
1274         if (to.isContract()) {
1275             try IERC721Receiver(to).onERC721Received(_msgSender(), from, tokenId, _data) returns (bytes4 retval) {
1276                 return retval == IERC721Receiver(to).onERC721Received.selector;
1277             } catch (bytes memory reason) {
1278                 if (reason.length == 0) revert TransferToNonERC721ReceiverImplementer();
1279                 else {
1280                     assembly {
1281                         revert(add(32, reason), mload(reason))
1282                     }
1283                 }
1284             }
1285         } else {
1286             return true;
1287         }
1288     }
1289 
1290     /**
1291      * @dev Hook that is called before a set of serially-ordered token ids are about to be transferred. This includes minting.
1292      *
1293      * startTokenId - the first token id to be transferred
1294      * quantity - the amount to be transferred
1295      *
1296      * Calling conditions:
1297      *
1298      * - When `from` and `to` are both non-zero, ``from``'s `tokenId` will be
1299      * transferred to `to`.
1300      * - When `from` is zero, `tokenId` will be minted for `to`.
1301      */
1302     function _beforeTokenTransfers(
1303         address from,
1304         address to,
1305         uint256 startTokenId,
1306         uint256 quantity
1307     ) internal virtual {}
1308 
1309     /**
1310      * @dev Hook that is called after a set of serially-ordered token ids have been transferred. This includes
1311      * minting.
1312      *
1313      * startTokenId - the first token id to be transferred
1314      * quantity - the amount to be transferred
1315      *
1316      * Calling conditions:
1317      *
1318      * - when `from` and `to` are both non-zero.
1319      * - `from` and `to` are never both zero.
1320      */
1321     function _afterTokenTransfers(
1322         address from,
1323         address to,
1324         uint256 startTokenId,
1325         uint256 quantity
1326     ) internal virtual {}
1327 }
1328 // File: Oozoids.sol
1329 
1330 
1331 pragma solidity 0.8.11;
1332 
1333 
1334 
1335 
1336 
1337 contract Oozoids is Ownable, ERC721A, ReentrancyGuard {
1338     uint256 public nftPrice = 0.05 ether;
1339 
1340     uint256 public nftLimit = 7777;
1341     uint256 public reserved = 150;
1342     uint256 public capWhitelist = 2;
1343     uint256 public capPublic = 5;
1344 
1345     bool public saleWhitelist = false;
1346     bool public salePublic = false;
1347 
1348     bytes32 public merkleRoot;
1349 
1350     string public baseURI = "";
1351 
1352     mapping(address => uint256) public whitelistAddresses;
1353 
1354     constructor(string memory _initURI, bytes32 _merkleRoot)
1355         ERC721A("Oozoids", "OOZD")
1356     {
1357         baseURI = _initURI;
1358         merkleRoot = _merkleRoot;
1359     }
1360 
1361     function mint(uint256 _amount) public payable nonReentrant {
1362         require(salePublic == true, "Oozoids: Not Started");
1363         require(_amount <= capPublic, "Oozoids: Amount Limit");
1364         _mint(_amount);
1365     }
1366 
1367     function mintWhitelist(uint256 _amount, bytes32[] calldata proof)
1368         public
1369         payable
1370         nonReentrant
1371     {
1372         require(saleWhitelist == true, "Oozoids: Not Started");
1373         require(
1374             MerkleProof.verify(
1375                 proof,
1376                 merkleRoot,
1377                 keccak256(abi.encodePacked(_msgSender()))
1378             ),
1379             "Oozoids: Not Whitelisted"
1380         );
1381         require(
1382             whitelistAddresses[_msgSender()] + _amount <= capWhitelist,
1383             "Oozoids: Amount Limit"
1384         );
1385         _mint(_amount);
1386         whitelistAddresses[_msgSender()] += _amount;
1387     }
1388 
1389     function _mint(uint256 _amount) internal {
1390         require(tx.origin == msg.sender, "Oozoids: Self Mint Only");
1391         require(
1392             totalSupply() + _amount <= (nftLimit - reserved),
1393             "Oozoids: Sold Out"
1394         );
1395         require(msg.value == nftPrice * _amount, "Oozoids: Incorrect Value");
1396         _safeMint(_msgSender(), _amount);
1397     }
1398 
1399     function reserve(address[] calldata _tos, uint256[] calldata _amounts)
1400         external
1401         onlyOwner
1402         nonReentrant
1403     {
1404         require(_tos.length == _amounts.length, "Oozoids: Length Mismatch");
1405         for (uint256 i = 0; i < _tos.length; i++) {
1406             require(
1407                 totalSupply() + _amounts[i] <= nftLimit,
1408                 "Oozoids: Sold Out"
1409             );
1410             _safeMint(_tos[i], _amounts[i]);
1411             if (reserved > 0) {
1412                 if (reserved >= _amounts[i]) {
1413                     reserved -= _amounts[i];
1414                 } else {
1415                     reserved = 0;
1416                 }
1417             }
1418         }
1419     }
1420 
1421     function tokensOfOwnerByIndex(address _owner, uint256 _index)
1422         public
1423         view
1424         returns (uint256)
1425     {
1426         return tokensOfOwner(_owner)[_index];
1427     }
1428 
1429     function tokensOfOwner(address _owner)
1430         public
1431         view
1432         returns (uint256[] memory)
1433     {
1434         uint256 _tokenCount = balanceOf(_owner);
1435         uint256[] memory _tokenIds = new uint256[](_tokenCount);
1436         uint256 _tokenIndex = 0;
1437         for (uint256 i = 0; i < totalSupply(); i++) {
1438             if (ownerOf(i) == _owner) {
1439                 _tokenIds[_tokenIndex] = i;
1440                 _tokenIndex++;
1441             }
1442         }
1443         return _tokenIds;
1444     }
1445 
1446     function withdraw() public payable onlyOwner {
1447         uint256 _balance = address(this).balance;
1448         address TEAM4 = 0x5bED62a0e6A0E65ec2e4Ac6cf9972653aE8F4725;
1449         address TEAM3 = 0x8CB9D8e1bEb509Fc5f92d1E3167E272d6304F934;
1450         address TEAM2 = 0x201D3B09AB5A24fB311cB91D026eADA31359791E;
1451         address TEAM1 = 0xF7279B51F4260C6003DC3cf615364AAf132A7934;
1452 
1453         (bool t4tx, ) = payable(TEAM4).call{value: (_balance * 27) / 100}("");
1454         require(t4tx, "Oozoids: Transfer 4 Failed");
1455 
1456         (bool t3tx, ) = payable(TEAM3).call{value: (_balance * 27) / 100}("");
1457         require(t3tx, "Oozoids: Transfer 3 Failed");
1458 
1459         (bool t2tx, ) = payable(TEAM2).call{value: (_balance * 27) / 100}("");
1460         require(t2tx, "Oozoids: Transfer 2 Failed");
1461 
1462         (bool t1tx, ) = payable(TEAM1).call{value: address(this).balance}("");
1463         require(t1tx, "Oozoids: Transfer 1 Failed");
1464     }
1465 
1466     function toggleSaleWhitelist() public onlyOwner {
1467         saleWhitelist = !saleWhitelist;
1468     }
1469 
1470     function toggleSalePublic() public onlyOwner {
1471         salePublic = !salePublic;
1472     }
1473 
1474     function setBaseURI(string memory _newBaseURI) public onlyOwner {
1475         baseURI = _newBaseURI;
1476     }
1477 
1478     function setNftPrice(uint256 _nftPrice) public onlyOwner {
1479         nftPrice = _nftPrice;
1480     }
1481 
1482     function setNftLimit(uint256 _nftLimit) public onlyOwner {
1483         nftLimit = _nftLimit;
1484     }
1485 
1486     function setMerkleRoot(bytes32 _merkleRoot) public onlyOwner {
1487         merkleRoot = _merkleRoot;
1488     }
1489 
1490     function _baseURI() internal view virtual override returns (string memory) {
1491         return baseURI;
1492     }
1493 
1494     function contractURI() public view returns (string memory) {
1495         return string(abi.encodePacked(baseURI, "contract"));
1496     }
1497 }