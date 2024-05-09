1 // File: @openzeppelin/contracts/security/ReentrancyGuard.sol
2 
3 
4 // OpenZeppelin Contracts v4.4.1 (security/ReentrancyGuard.sol)
5 
6 pragma solidity ^0.8.0;
7 
8 /**
9  * @dev Contract module that helps prevent reentrant calls to a function.
10  *
11  * Inheriting from `ReentrancyGuard` will make the {nonReentrant} modifier
12  * available, which can be applied to functions to make sure there are no nested
13  * (reentrant) calls to them.
14  *
15  * Note that because there is a single `nonReentrant` guard, functions marked as
16  * `nonReentrant` may not call one another. This can be worked around by making
17  * those functions `private`, and then adding `external` `nonReentrant` entry
18  * points to them.
19  *
20  * TIP: If you would like to learn more about reentrancy and alternative ways
21  * to protect against it, check out our blog post
22  * https://blog.openzeppelin.com/reentrancy-after-istanbul/[Reentrancy After Istanbul].
23  */
24 abstract contract ReentrancyGuard {
25     // Booleans are more expensive than uint256 or any type that takes up a full
26     // word because each write operation emits an extra SLOAD to first read the
27     // slot's contents, replace the bits taken up by the boolean, and then write
28     // back. This is the compiler's defense against contract upgrades and
29     // pointer aliasing, and it cannot be disabled.
30 
31     // The values being non-zero value makes deployment a bit more expensive,
32     // but in exchange the refund on every call to nonReentrant will be lower in
33     // amount. Since refunds are capped to a percentage of the total
34     // transaction's gas, it is best to keep them low in cases like this one, to
35     // increase the likelihood of the full refund coming into effect.
36     uint256 private constant _NOT_ENTERED = 1;
37     uint256 private constant _ENTERED = 2;
38 
39     uint256 private _status;
40 
41     constructor() {
42         _status = _NOT_ENTERED;
43     }
44 
45     /**
46      * @dev Prevents a contract from calling itself, directly or indirectly.
47      * Calling a `nonReentrant` function from another `nonReentrant`
48      * function is not supported. It is possible to prevent this from happening
49      * by making the `nonReentrant` function external, and making it call a
50      * `private` function that does the actual work.
51      */
52     modifier nonReentrant() {
53         // On the first call to nonReentrant, _notEntered will be true
54         require(_status != _ENTERED, "ReentrancyGuard: reentrant call");
55 
56         // Any calls to nonReentrant after this point will fail
57         _status = _ENTERED;
58 
59         _;
60 
61         // By storing the original value once again, a refund is triggered (see
62         // https://eips.ethereum.org/EIPS/eip-2200)
63         _status = _NOT_ENTERED;
64     }
65 }
66 
67 // File: @openzeppelin/contracts/utils/cryptography/MerkleProof.sol
68 
69 
70 // OpenZeppelin Contracts (last updated v4.5.0) (utils/cryptography/MerkleProof.sol)
71 
72 pragma solidity ^0.8.0;
73 
74 /**
75  * @dev These functions deal with verification of Merkle Trees proofs.
76  *
77  * The proofs can be generated using the JavaScript library
78  * https://github.com/miguelmota/merkletreejs[merkletreejs].
79  * Note: the hashing algorithm should be keccak256 and pair sorting should be enabled.
80  *
81  * See `test/utils/cryptography/MerkleProof.test.js` for some examples.
82  */
83 library MerkleProof {
84     /**
85      * @dev Returns true if a `leaf` can be proved to be a part of a Merkle tree
86      * defined by `root`. For this, a `proof` must be provided, containing
87      * sibling hashes on the branch from the leaf to the root of the tree. Each
88      * pair of leaves and each pair of pre-images are assumed to be sorted.
89      */
90     function verify(
91         bytes32[] memory proof,
92         bytes32 root,
93         bytes32 leaf
94     ) internal pure returns (bool) {
95         return processProof(proof, leaf) == root;
96     }
97 
98     /**
99      * @dev Returns the rebuilt hash obtained by traversing a Merklee tree up
100      * from `leaf` using `proof`. A `proof` is valid if and only if the rebuilt
101      * hash matches the root of the tree. When processing the proof, the pairs
102      * of leafs & pre-images are assumed to be sorted.
103      *
104      * _Available since v4.4._
105      */
106     function processProof(bytes32[] memory proof, bytes32 leaf) internal pure returns (bytes32) {
107         bytes32 computedHash = leaf;
108         for (uint256 i = 0; i < proof.length; i++) {
109             bytes32 proofElement = proof[i];
110             if (computedHash <= proofElement) {
111                 // Hash(current computed hash + current element of the proof)
112                 computedHash = _efficientHash(computedHash, proofElement);
113             } else {
114                 // Hash(current element of the proof + current computed hash)
115                 computedHash = _efficientHash(proofElement, computedHash);
116             }
117         }
118         return computedHash;
119     }
120 
121     function _efficientHash(bytes32 a, bytes32 b) private pure returns (bytes32 value) {
122         assembly {
123             mstore(0x00, a)
124             mstore(0x20, b)
125             value := keccak256(0x00, 0x40)
126         }
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
764 // File: @openzeppelin/contracts/token/ERC721/extensions/IERC721Metadata.sol
765 
766 
767 // OpenZeppelin Contracts v4.4.1 (token/ERC721/extensions/IERC721Metadata.sol)
768 
769 pragma solidity ^0.8.0;
770 
771 
772 /**
773  * @title ERC-721 Non-Fungible Token Standard, optional metadata extension
774  * @dev See https://eips.ethereum.org/EIPS/eip-721
775  */
776 interface IERC721Metadata is IERC721 {
777     /**
778      * @dev Returns the token collection name.
779      */
780     function name() external view returns (string memory);
781 
782     /**
783      * @dev Returns the token collection symbol.
784      */
785     function symbol() external view returns (string memory);
786 
787     /**
788      * @dev Returns the Uniform Resource Identifier (URI) for `tokenId` token.
789      */
790     function tokenURI(uint256 tokenId) external view returns (string memory);
791 }
792 
793 // File: erc721a/contracts/ERC721A.sol
794 
795 
796 // Creator: Chiru Labs
797 
798 pragma solidity ^0.8.4;
799 
800 
801 
802 
803 
804 
805 
806 
807 error ApprovalCallerNotOwnerNorApproved();
808 error ApprovalQueryForNonexistentToken();
809 error ApproveToCaller();
810 error ApprovalToCurrentOwner();
811 error BalanceQueryForZeroAddress();
812 error MintToZeroAddress();
813 error MintZeroQuantity();
814 error OwnerQueryForNonexistentToken();
815 error TransferCallerNotOwnerNorApproved();
816 error TransferFromIncorrectOwner();
817 error TransferToNonERC721ReceiverImplementer();
818 error TransferToZeroAddress();
819 error URIQueryForNonexistentToken();
820 
821 /**
822  * @dev Implementation of https://eips.ethereum.org/EIPS/eip-721[ERC721] Non-Fungible Token Standard, including
823  * the Metadata extension. Built to optimize for lower gas during batch mints.
824  *
825  * Assumes serials are sequentially minted starting at _startTokenId() (defaults to 0, e.g. 0, 1, 2, 3..).
826  *
827  * Assumes that an owner cannot have more than 2**64 - 1 (max value of uint64) of supply.
828  *
829  * Assumes that the maximum token id cannot exceed 2**256 - 1 (max value of uint256).
830  */
831 contract ERC721A is Context, ERC165, IERC721, IERC721Metadata {
832     using Address for address;
833     using Strings for uint256;
834 
835     // Compiler will pack this into a single 256bit word.
836     struct TokenOwnership {
837         // The address of the owner.
838         address addr;
839         // Keeps track of the start time of ownership with minimal overhead for tokenomics.
840         uint64 startTimestamp;
841         // Whether the token has been burned.
842         bool burned;
843     }
844 
845     // Compiler will pack this into a single 256bit word.
846     struct AddressData {
847         // Realistically, 2**64-1 is more than enough.
848         uint64 balance;
849         // Keeps track of mint count with minimal overhead for tokenomics.
850         uint64 numberMinted;
851         // Keeps track of burn count with minimal overhead for tokenomics.
852         uint64 numberBurned;
853         // For miscellaneous variable(s) pertaining to the address
854         // (e.g. number of whitelist mint slots used).
855         // If there are multiple variables, please pack them into a uint64.
856         uint64 aux;
857     }
858 
859     // The tokenId of the next token to be minted.
860     uint256 internal _currentIndex;
861 
862     // The number of tokens burned.
863     uint256 internal _burnCounter;
864 
865     // Token name
866     string private _name;
867 
868     // Token symbol
869     string private _symbol;
870 
871     // Mapping from token ID to ownership details
872     // An empty struct value does not necessarily mean the token is unowned. See _ownershipOf implementation for details.
873     mapping(uint256 => TokenOwnership) internal _ownerships;
874 
875     // Mapping owner address to address data
876     mapping(address => AddressData) private _addressData;
877 
878     // Mapping from token ID to approved address
879     mapping(uint256 => address) private _tokenApprovals;
880 
881     // Mapping from owner to operator approvals
882     mapping(address => mapping(address => bool)) private _operatorApprovals;
883 
884     constructor(string memory name_, string memory symbol_) {
885         _name = name_;
886         _symbol = symbol_;
887         _currentIndex = _startTokenId();
888     }
889 
890     /**
891      * To change the starting tokenId, please override this function.
892      */
893     function _startTokenId() internal view virtual returns (uint256) {
894         return 0;
895     }
896 
897     /**
898      * @dev Burned tokens are calculated here, use _totalMinted() if you want to count just minted tokens.
899      */
900     function totalSupply() public view returns (uint256) {
901         // Counter underflow is impossible as _burnCounter cannot be incremented
902         // more than _currentIndex - _startTokenId() times
903         unchecked {
904             return _currentIndex - _burnCounter - _startTokenId();
905         }
906     }
907 
908     /**
909      * Returns the total amount of tokens minted in the contract.
910      */
911     function _totalMinted() internal view returns (uint256) {
912         // Counter underflow is impossible as _currentIndex does not decrement,
913         // and it is initialized to _startTokenId()
914         unchecked {
915             return _currentIndex - _startTokenId();
916         }
917     }
918 
919     /**
920      * @dev See {IERC165-supportsInterface}.
921      */
922     function supportsInterface(bytes4 interfaceId) public view virtual override(ERC165, IERC165) returns (bool) {
923         return
924             interfaceId == type(IERC721).interfaceId ||
925             interfaceId == type(IERC721Metadata).interfaceId ||
926             super.supportsInterface(interfaceId);
927     }
928 
929     /**
930      * @dev See {IERC721-balanceOf}.
931      */
932     function balanceOf(address owner) public view override returns (uint256) {
933         if (owner == address(0)) revert BalanceQueryForZeroAddress();
934         return uint256(_addressData[owner].balance);
935     }
936 
937     /**
938      * Returns the number of tokens minted by `owner`.
939      */
940     function _numberMinted(address owner) internal view returns (uint256) {
941         return uint256(_addressData[owner].numberMinted);
942     }
943 
944     /**
945      * Returns the number of tokens burned by or on behalf of `owner`.
946      */
947     function _numberBurned(address owner) internal view returns (uint256) {
948         return uint256(_addressData[owner].numberBurned);
949     }
950 
951     /**
952      * Returns the auxillary data for `owner`. (e.g. number of whitelist mint slots used).
953      */
954     function _getAux(address owner) internal view returns (uint64) {
955         return _addressData[owner].aux;
956     }
957 
958     /**
959      * Sets the auxillary data for `owner`. (e.g. number of whitelist mint slots used).
960      * If there are multiple variables, please pack them into a uint64.
961      */
962     function _setAux(address owner, uint64 aux) internal {
963         _addressData[owner].aux = aux;
964     }
965 
966     /**
967      * Gas spent here starts off proportional to the maximum mint batch size.
968      * It gradually moves to O(1) as tokens get transferred around in the collection over time.
969      */
970     function _ownershipOf(uint256 tokenId) internal view returns (TokenOwnership memory) {
971         uint256 curr = tokenId;
972 
973         unchecked {
974             if (_startTokenId() <= curr && curr < _currentIndex) {
975                 TokenOwnership memory ownership = _ownerships[curr];
976                 if (!ownership.burned) {
977                     if (ownership.addr != address(0)) {
978                         return ownership;
979                     }
980                     // Invariant:
981                     // There will always be an ownership that has an address and is not burned
982                     // before an ownership that does not have an address and is not burned.
983                     // Hence, curr will not underflow.
984                     while (true) {
985                         curr--;
986                         ownership = _ownerships[curr];
987                         if (ownership.addr != address(0)) {
988                             return ownership;
989                         }
990                     }
991                 }
992             }
993         }
994         revert OwnerQueryForNonexistentToken();
995     }
996 
997     /**
998      * @dev See {IERC721-ownerOf}.
999      */
1000     function ownerOf(uint256 tokenId) public view override returns (address) {
1001         return _ownershipOf(tokenId).addr;
1002     }
1003 
1004     /**
1005      * @dev See {IERC721Metadata-name}.
1006      */
1007     function name() public view virtual override returns (string memory) {
1008         return _name;
1009     }
1010 
1011     /**
1012      * @dev See {IERC721Metadata-symbol}.
1013      */
1014     function symbol() public view virtual override returns (string memory) {
1015         return _symbol;
1016     }
1017 
1018     /**
1019      * @dev See {IERC721Metadata-tokenURI}.
1020      */
1021     function tokenURI(uint256 tokenId) public view virtual override returns (string memory) {
1022         if (!_exists(tokenId)) revert URIQueryForNonexistentToken();
1023 
1024         string memory baseURI = _baseURI();
1025         return bytes(baseURI).length != 0 ? string(abi.encodePacked(baseURI, tokenId.toString())) : '';
1026     }
1027 
1028     /**
1029      * @dev Base URI for computing {tokenURI}. If set, the resulting URI for each
1030      * token will be the concatenation of the `baseURI` and the `tokenId`. Empty
1031      * by default, can be overriden in child contracts.
1032      */
1033     function _baseURI() internal view virtual returns (string memory) {
1034         return '';
1035     }
1036 
1037     /**
1038      * @dev See {IERC721-approve}.
1039      */
1040     function approve(address to, uint256 tokenId) public override {
1041         address owner = ERC721A.ownerOf(tokenId);
1042         if (to == owner) revert ApprovalToCurrentOwner();
1043 
1044         if (_msgSender() != owner && !isApprovedForAll(owner, _msgSender())) {
1045             revert ApprovalCallerNotOwnerNorApproved();
1046         }
1047 
1048         _approve(to, tokenId, owner);
1049     }
1050 
1051     /**
1052      * @dev See {IERC721-getApproved}.
1053      */
1054     function getApproved(uint256 tokenId) public view override returns (address) {
1055         if (!_exists(tokenId)) revert ApprovalQueryForNonexistentToken();
1056 
1057         return _tokenApprovals[tokenId];
1058     }
1059 
1060     /**
1061      * @dev See {IERC721-setApprovalForAll}.
1062      */
1063     function setApprovalForAll(address operator, bool approved) public virtual override {
1064         if (operator == _msgSender()) revert ApproveToCaller();
1065 
1066         _operatorApprovals[_msgSender()][operator] = approved;
1067         emit ApprovalForAll(_msgSender(), operator, approved);
1068     }
1069 
1070     /**
1071      * @dev See {IERC721-isApprovedForAll}.
1072      */
1073     function isApprovedForAll(address owner, address operator) public view virtual override returns (bool) {
1074         return _operatorApprovals[owner][operator];
1075     }
1076 
1077     /**
1078      * @dev See {IERC721-transferFrom}.
1079      */
1080     function transferFrom(
1081         address from,
1082         address to,
1083         uint256 tokenId
1084     ) public virtual override {
1085         _transfer(from, to, tokenId);
1086     }
1087 
1088     /**
1089      * @dev See {IERC721-safeTransferFrom}.
1090      */
1091     function safeTransferFrom(
1092         address from,
1093         address to,
1094         uint256 tokenId
1095     ) public virtual override {
1096         safeTransferFrom(from, to, tokenId, '');
1097     }
1098 
1099     /**
1100      * @dev See {IERC721-safeTransferFrom}.
1101      */
1102     function safeTransferFrom(
1103         address from,
1104         address to,
1105         uint256 tokenId,
1106         bytes memory _data
1107     ) public virtual override {
1108         _transfer(from, to, tokenId);
1109         if (to.isContract() && !_checkContractOnERC721Received(from, to, tokenId, _data)) {
1110             revert TransferToNonERC721ReceiverImplementer();
1111         }
1112     }
1113 
1114     /**
1115      * @dev Returns whether `tokenId` exists.
1116      *
1117      * Tokens can be managed by their owner or approved accounts via {approve} or {setApprovalForAll}.
1118      *
1119      * Tokens start existing when they are minted (`_mint`),
1120      */
1121     function _exists(uint256 tokenId) internal view returns (bool) {
1122         return _startTokenId() <= tokenId && tokenId < _currentIndex &&
1123             !_ownerships[tokenId].burned;
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
1422 // File: contracts/planetapes.sol
1423 
1424 
1425 pragma solidity ^0.8.4;
1426 
1427 
1428 
1429 
1430 
1431 error NormalSaleNotActive();
1432 error WhitelistNotActive();
1433 error ExceededLimit();
1434 error NotEnoughTokensLeft();
1435 error WrongEther();
1436 error InvalidMerkle();
1437 error WhitelistUsed();
1438 
1439 contract PlanetApes is ERC721A, Ownable, ReentrancyGuard {
1440     using Address for address;
1441     using Strings for uint256;
1442 
1443     uint256 public maxMints = 10;
1444     uint256 public maxSupply = 10000;
1445     uint256 public mintRate = 0.025 ether;
1446     string public notRevealedUri = 'ipfs://QmQ3zp283Dt7V3Hc2Jn4VRxfHdfEYDoRHy2qJ42dsCXgX4';
1447     string public baseExtension = '.json';
1448     string public baseURI = ''; // ipfs://ID/
1449     bool public revealed = false;
1450 
1451     constructor() ERC721A('PlanetApes', 'DARWIN') {}
1452 
1453     function mint(uint256 quantity) external payable nonReentrant {
1454         if (quantity + _numberMinted(msg.sender) > maxMints) {
1455             revert ExceededLimit();
1456         }
1457 
1458         if (totalSupply() + quantity > maxSupply) {
1459             revert NotEnoughTokensLeft();
1460         }
1461         if (mintRate * quantity != msg.value) {
1462             revert WrongEther();
1463         }
1464 
1465         _safeMint(msg.sender, quantity);
1466     }
1467 
1468     function leaf(address _account) internal pure returns (bytes32) {
1469         return keccak256(abi.encodePacked(_account));
1470     }
1471 
1472     function withdraw() external payable onlyOwner {
1473         payable(owner()).transfer(address(this).balance);
1474     }
1475 
1476     function tokenURI(uint256 tokenId) public view override returns (string memory) {
1477         require(_exists(tokenId), 'ERC721Metadata: URI query for nonexistent token');
1478 
1479         if (!revealed) {
1480             return notRevealedUri;
1481         }
1482 
1483         string memory currentBaseURI = _baseURI();
1484         return
1485             bytes(currentBaseURI).length > 0
1486                 ? string(abi.encodePacked(currentBaseURI, tokenId.toString(), baseExtension))
1487                 : '';
1488     }
1489 
1490     function _baseURI() internal view override returns (string memory) {
1491         return baseURI;
1492     }
1493 
1494     function setBaseURI(string memory _newBaseURI) public onlyOwner {
1495         baseURI = _newBaseURI;
1496     }
1497 
1498     function setNotRevealedURI(string memory _newURI) public onlyOwner {
1499         notRevealedUri = _newURI;
1500     }
1501 
1502     function setBaseExtension(string memory _newBaseExtension) public onlyOwner {
1503         baseExtension = _newBaseExtension;
1504     }
1505 
1506     function toggleReveal() public onlyOwner {
1507         revealed = !revealed;
1508     }
1509     
1510     function renounceOwnership() public override onlyOwner {}
1511 
1512     function setMintRate(uint256 _mintRate) public onlyOwner {
1513         mintRate = _mintRate;
1514     }
1515 
1516     function setMaxSupply(uint256 _newSupply) public onlyOwner {
1517         maxSupply = _newSupply;
1518     }
1519 
1520     function setMaxMints(uint256 _newMaxMints) public onlyOwner {
1521         maxMints = _newMaxMints;
1522     }
1523 }