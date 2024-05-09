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
824 // File: erc721a/contracts/ERC721A.sol
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
845 error BurnedQueryForZeroAddress();
846 error AuxQueryForZeroAddress();
847 error MintToZeroAddress();
848 error MintZeroQuantity();
849 error OwnerIndexOutOfBounds();
850 error OwnerQueryForNonexistentToken();
851 error TokenIndexOutOfBounds();
852 error TransferCallerNotOwnerNorApproved();
853 error TransferFromIncorrectOwner();
854 error TransferToNonERC721ReceiverImplementer();
855 error TransferToZeroAddress();
856 error URIQueryForNonexistentToken();
857 
858 /**
859  * @dev Implementation of https://eips.ethereum.org/EIPS/eip-721[ERC721] Non-Fungible Token Standard, including
860  * the Metadata extension. Built to optimize for lower gas during batch mints.
861  *
862  * Assumes serials are sequentially minted starting at _startTokenId() (defaults to 0, e.g. 0, 1, 2, 3..).
863  *
864  * Assumes that an owner cannot have more than 2**64 - 1 (max value of uint64) of supply.
865  *
866  * Assumes that the maximum token id cannot exceed 2**256 - 1 (max value of uint256).
867  */
868 contract ERC721A is Context, ERC165, IERC721, IERC721Metadata {
869     using Address for address;
870     using Strings for uint256;
871 
872     // Compiler will pack this into a single 256bit word.
873     struct TokenOwnership {
874         // The address of the owner.
875         address addr;
876         // Keeps track of the start time of ownership with minimal overhead for tokenomics.
877         uint64 startTimestamp;
878         // Whether the token has been burned.
879         bool burned;
880     }
881 
882     // Compiler will pack this into a single 256bit word.
883     struct AddressData {
884         // Realistically, 2**64-1 is more than enough.
885         uint64 balance;
886         // Keeps track of mint count with minimal overhead for tokenomics.
887         uint64 numberMinted;
888         // Keeps track of burn count with minimal overhead for tokenomics.
889         uint64 numberBurned;
890         // For miscellaneous variable(s) pertaining to the address
891         // (e.g. number of whitelist mint slots used).
892         // If there are multiple variables, please pack them into a uint64.
893         uint64 aux;
894     }
895 
896     // The tokenId of the next token to be minted.
897     uint256 internal _currentIndex;
898 
899     // The number of tokens burned.
900     uint256 internal _burnCounter;
901 
902     // Token name
903     string private _name;
904 
905     // Token symbol
906     string private _symbol;
907 
908     // Mapping from token ID to ownership details
909     // An empty struct value does not necessarily mean the token is unowned. See ownershipOf implementation for details.
910     mapping(uint256 => TokenOwnership) internal _ownerships;
911 
912     // Mapping owner address to address data
913     mapping(address => AddressData) private _addressData;
914 
915     // Mapping from token ID to approved address
916     mapping(uint256 => address) private _tokenApprovals;
917 
918     // Mapping from owner to operator approvals
919     mapping(address => mapping(address => bool)) private _operatorApprovals;
920 
921     constructor(string memory name_, string memory symbol_) {
922         _name = name_;
923         _symbol = symbol_;
924         _currentIndex = _startTokenId();
925     }
926 
927     /**
928      * To change the starting tokenId, please override this function.
929      */
930     function _startTokenId() internal view virtual returns (uint256) {
931         return 0;
932     }
933 
934     /**
935      * @dev See {IERC721Enumerable-totalSupply}.
936      * @dev Burned tokens are calculated here, use _totalMinted() if you want to count just minted tokens.
937      */
938     function totalSupply() public view returns (uint256) {
939         // Counter underflow is impossible as _burnCounter cannot be incremented
940         // more than _currentIndex - _startTokenId() times
941         unchecked {
942             return _currentIndex - _burnCounter - _startTokenId();
943         }
944     }
945 
946     /**
947      * Returns the total amount of tokens minted in the contract.
948      */
949     function _totalMinted() internal view returns (uint256) {
950         // Counter underflow is impossible as _currentIndex does not decrement,
951         // and it is initialized to _startTokenId()
952         unchecked {
953             return _currentIndex - _startTokenId();
954         }
955     }
956 
957     /**
958      * @dev See {IERC165-supportsInterface}.
959      */
960     function supportsInterface(bytes4 interfaceId) public view virtual override(ERC165, IERC165) returns (bool) {
961         return
962             interfaceId == type(IERC721).interfaceId ||
963             interfaceId == type(IERC721Metadata).interfaceId ||
964             super.supportsInterface(interfaceId);
965     }
966 
967     /**
968      * @dev See {IERC721-balanceOf}.
969      */
970     function balanceOf(address owner) public view override returns (uint256) {
971         if (owner == address(0)) revert BalanceQueryForZeroAddress();
972         return uint256(_addressData[owner].balance);
973     }
974 
975     /**
976      * Returns the number of tokens minted by `owner`.
977      */
978     function _numberMinted(address owner) internal view returns (uint256) {
979         if (owner == address(0)) revert MintedQueryForZeroAddress();
980         return uint256(_addressData[owner].numberMinted);
981     }
982 
983     /**
984      * Returns the number of tokens burned by or on behalf of `owner`.
985      */
986     function _numberBurned(address owner) internal view returns (uint256) {
987         if (owner == address(0)) revert BurnedQueryForZeroAddress();
988         return uint256(_addressData[owner].numberBurned);
989     }
990 
991     /**
992      * Returns the auxillary data for `owner`. (e.g. number of whitelist mint slots used).
993      */
994     function _getAux(address owner) internal view returns (uint64) {
995         if (owner == address(0)) revert AuxQueryForZeroAddress();
996         return _addressData[owner].aux;
997     }
998 
999     /**
1000      * Sets the auxillary data for `owner`. (e.g. number of whitelist mint slots used).
1001      * If there are multiple variables, please pack them into a uint64.
1002      */
1003     function _setAux(address owner, uint64 aux) internal {
1004         if (owner == address(0)) revert AuxQueryForZeroAddress();
1005         _addressData[owner].aux = aux;
1006     }
1007 
1008     /**
1009      * Gas spent here starts off proportional to the maximum mint batch size.
1010      * It gradually moves to O(1) as tokens get transferred around in the collection over time.
1011      */
1012     function ownershipOf(uint256 tokenId) internal view returns (TokenOwnership memory) {
1013         uint256 curr = tokenId;
1014 
1015         unchecked {
1016             if (_startTokenId() <= curr && curr < _currentIndex) {
1017                 TokenOwnership memory ownership = _ownerships[curr];
1018                 if (!ownership.burned) {
1019                     if (ownership.addr != address(0)) {
1020                         return ownership;
1021                     }
1022                     // Invariant:
1023                     // There will always be an ownership that has an address and is not burned
1024                     // before an ownership that does not have an address and is not burned.
1025                     // Hence, curr will not underflow.
1026                     while (true) {
1027                         curr--;
1028                         ownership = _ownerships[curr];
1029                         if (ownership.addr != address(0)) {
1030                             return ownership;
1031                         }
1032                     }
1033                 }
1034             }
1035         }
1036         revert OwnerQueryForNonexistentToken();
1037     }
1038 
1039     /**
1040      * @dev See {IERC721-ownerOf}.
1041      */
1042     function ownerOf(uint256 tokenId) public view override returns (address) {
1043         return ownershipOf(tokenId).addr;
1044     }
1045 
1046     /**
1047      * @dev See {IERC721Metadata-name}.
1048      */
1049     function name() public view virtual override returns (string memory) {
1050         return _name;
1051     }
1052 
1053     /**
1054      * @dev See {IERC721Metadata-symbol}.
1055      */
1056     function symbol() public view virtual override returns (string memory) {
1057         return _symbol;
1058     }
1059 
1060     /**
1061      * @dev See {IERC721Metadata-tokenURI}.
1062      */
1063     function tokenURI(uint256 tokenId) public view virtual override returns (string memory) {
1064         if (!_exists(tokenId)) revert URIQueryForNonexistentToken();
1065 
1066         string memory baseURI = _baseURI();
1067         return bytes(baseURI).length != 0 ? string(abi.encodePacked(baseURI, tokenId.toString())) : '';
1068     }
1069 
1070     /**
1071      * @dev Base URI for computing {tokenURI}. If set, the resulting URI for each
1072      * token will be the concatenation of the `baseURI` and the `tokenId`. Empty
1073      * by default, can be overriden in child contracts.
1074      */
1075     function _baseURI() internal view virtual returns (string memory) {
1076         return '';
1077     }
1078 
1079     /**
1080      * @dev See {IERC721-approve}.
1081      */
1082     function approve(address to, uint256 tokenId) public override {
1083         address owner = ERC721A.ownerOf(tokenId);
1084         if (to == owner) revert ApprovalToCurrentOwner();
1085 
1086         if (_msgSender() != owner && !isApprovedForAll(owner, _msgSender())) {
1087             revert ApprovalCallerNotOwnerNorApproved();
1088         }
1089 
1090         _approve(to, tokenId, owner);
1091     }
1092 
1093     /**
1094      * @dev See {IERC721-getApproved}.
1095      */
1096     function getApproved(uint256 tokenId) public view override returns (address) {
1097         if (!_exists(tokenId)) revert ApprovalQueryForNonexistentToken();
1098 
1099         return _tokenApprovals[tokenId];
1100     }
1101 
1102     /**
1103      * @dev See {IERC721-setApprovalForAll}.
1104      */
1105     function setApprovalForAll(address operator, bool approved) public override {
1106         if (operator == _msgSender()) revert ApproveToCaller();
1107 
1108         _operatorApprovals[_msgSender()][operator] = approved;
1109         emit ApprovalForAll(_msgSender(), operator, approved);
1110     }
1111 
1112     /**
1113      * @dev See {IERC721-isApprovedForAll}.
1114      */
1115     function isApprovedForAll(address owner, address operator) public view virtual override returns (bool) {
1116         return _operatorApprovals[owner][operator];
1117     }
1118 
1119     /**
1120      * @dev See {IERC721-transferFrom}.
1121      */
1122     function transferFrom(
1123         address from,
1124         address to,
1125         uint256 tokenId
1126     ) public virtual override {
1127         _transfer(from, to, tokenId);
1128     }
1129 
1130     /**
1131      * @dev See {IERC721-safeTransferFrom}.
1132      */
1133     function safeTransferFrom(
1134         address from,
1135         address to,
1136         uint256 tokenId
1137     ) public virtual override {
1138         safeTransferFrom(from, to, tokenId, '');
1139     }
1140 
1141     /**
1142      * @dev See {IERC721-safeTransferFrom}.
1143      */
1144     function safeTransferFrom(
1145         address from,
1146         address to,
1147         uint256 tokenId,
1148         bytes memory _data
1149     ) public virtual override {
1150         _transfer(from, to, tokenId);
1151         if (to.isContract() && !_checkContractOnERC721Received(from, to, tokenId, _data)) {
1152             revert TransferToNonERC721ReceiverImplementer();
1153         }
1154     }
1155 
1156     /**
1157      * @dev Returns whether `tokenId` exists.
1158      *
1159      * Tokens can be managed by their owner or approved accounts via {approve} or {setApprovalForAll}.
1160      *
1161      * Tokens start existing when they are minted (`_mint`),
1162      */
1163     function _exists(uint256 tokenId) internal view returns (bool) {
1164         return _startTokenId() <= tokenId && tokenId < _currentIndex &&
1165             !_ownerships[tokenId].burned;
1166     }
1167 
1168     function _safeMint(address to, uint256 quantity) internal {
1169         _safeMint(to, quantity, '');
1170     }
1171 
1172     /**
1173      * @dev Safely mints `quantity` tokens and transfers them to `to`.
1174      *
1175      * Requirements:
1176      *
1177      * - If `to` refers to a smart contract, it must implement {IERC721Receiver-onERC721Received}, which is called for each safe transfer.
1178      * - `quantity` must be greater than 0.
1179      *
1180      * Emits a {Transfer} event.
1181      */
1182     function _safeMint(
1183         address to,
1184         uint256 quantity,
1185         bytes memory _data
1186     ) internal {
1187         _mint(to, quantity, _data, true);
1188     }
1189 
1190     /**
1191      * @dev Mints `quantity` tokens and transfers them to `to`.
1192      *
1193      * Requirements:
1194      *
1195      * - `to` cannot be the zero address.
1196      * - `quantity` must be greater than 0.
1197      *
1198      * Emits a {Transfer} event.
1199      */
1200     function _mint(
1201         address to,
1202         uint256 quantity,
1203         bytes memory _data,
1204         bool safe
1205     ) internal {
1206         uint256 startTokenId = _currentIndex;
1207         if (to == address(0)) revert MintToZeroAddress();
1208         if (quantity == 0) revert MintZeroQuantity();
1209 
1210         _beforeTokenTransfers(address(0), to, startTokenId, quantity);
1211 
1212         // Overflows are incredibly unrealistic.
1213         // balance or numberMinted overflow if current value of either + quantity > 1.8e19 (2**64) - 1
1214         // updatedIndex overflows if _currentIndex + quantity > 1.2e77 (2**256) - 1
1215         unchecked {
1216             _addressData[to].balance += uint64(quantity);
1217             _addressData[to].numberMinted += uint64(quantity);
1218 
1219             _ownerships[startTokenId].addr = to;
1220             _ownerships[startTokenId].startTimestamp = uint64(block.timestamp);
1221 
1222             uint256 updatedIndex = startTokenId;
1223             uint256 end = updatedIndex + quantity;
1224 
1225             if (safe && to.isContract()) {
1226                 do {
1227                     emit Transfer(address(0), to, updatedIndex);
1228                     if (!_checkContractOnERC721Received(address(0), to, updatedIndex++, _data)) {
1229                         revert TransferToNonERC721ReceiverImplementer();
1230                     }
1231                 } while (updatedIndex != end);
1232                 // Reentrancy protection
1233                 if (_currentIndex != startTokenId) revert();
1234             } else {
1235                 do {
1236                     emit Transfer(address(0), to, updatedIndex++);
1237                 } while (updatedIndex != end);
1238             }
1239             _currentIndex = updatedIndex;
1240         }
1241         _afterTokenTransfers(address(0), to, startTokenId, quantity);
1242     }
1243 
1244     /**
1245      * @dev Transfers `tokenId` from `from` to `to`.
1246      *
1247      * Requirements:
1248      *
1249      * - `to` cannot be the zero address.
1250      * - `tokenId` token must be owned by `from`.
1251      *
1252      * Emits a {Transfer} event.
1253      */
1254     function _transfer(
1255         address from,
1256         address to,
1257         uint256 tokenId
1258     ) private {
1259         TokenOwnership memory prevOwnership = ownershipOf(tokenId);
1260 
1261         bool isApprovedOrOwner = (_msgSender() == prevOwnership.addr ||
1262             isApprovedForAll(prevOwnership.addr, _msgSender()) ||
1263             getApproved(tokenId) == _msgSender());
1264 
1265         if (!isApprovedOrOwner) revert TransferCallerNotOwnerNorApproved();
1266         if (prevOwnership.addr != from) revert TransferFromIncorrectOwner();
1267         if (to == address(0)) revert TransferToZeroAddress();
1268 
1269         _beforeTokenTransfers(from, to, tokenId, 1);
1270 
1271         // Clear approvals from the previous owner
1272         _approve(address(0), tokenId, prevOwnership.addr);
1273 
1274         // Underflow of the sender's balance is impossible because we check for
1275         // ownership above and the recipient's balance can't realistically overflow.
1276         // Counter overflow is incredibly unrealistic as tokenId would have to be 2**256.
1277         unchecked {
1278             _addressData[from].balance -= 1;
1279             _addressData[to].balance += 1;
1280 
1281             _ownerships[tokenId].addr = to;
1282             _ownerships[tokenId].startTimestamp = uint64(block.timestamp);
1283 
1284             // If the ownership slot of tokenId+1 is not explicitly set, that means the transfer initiator owns it.
1285             // Set the slot of tokenId+1 explicitly in storage to maintain correctness for ownerOf(tokenId+1) calls.
1286             uint256 nextTokenId = tokenId + 1;
1287             if (_ownerships[nextTokenId].addr == address(0)) {
1288                 // This will suffice for checking _exists(nextTokenId),
1289                 // as a burned slot cannot contain the zero address.
1290                 if (nextTokenId < _currentIndex) {
1291                     _ownerships[nextTokenId].addr = prevOwnership.addr;
1292                     _ownerships[nextTokenId].startTimestamp = prevOwnership.startTimestamp;
1293                 }
1294             }
1295         }
1296 
1297         emit Transfer(from, to, tokenId);
1298         _afterTokenTransfers(from, to, tokenId, 1);
1299     }
1300 
1301     /**
1302      * @dev Destroys `tokenId`.
1303      * The approval is cleared when the token is burned.
1304      *
1305      * Requirements:
1306      *
1307      * - `tokenId` must exist.
1308      *
1309      * Emits a {Transfer} event.
1310      */
1311     function _burn(uint256 tokenId) internal virtual {
1312         TokenOwnership memory prevOwnership = ownershipOf(tokenId);
1313 
1314         _beforeTokenTransfers(prevOwnership.addr, address(0), tokenId, 1);
1315 
1316         // Clear approvals from the previous owner
1317         _approve(address(0), tokenId, prevOwnership.addr);
1318 
1319         // Underflow of the sender's balance is impossible because we check for
1320         // ownership above and the recipient's balance can't realistically overflow.
1321         // Counter overflow is incredibly unrealistic as tokenId would have to be 2**256.
1322         unchecked {
1323             _addressData[prevOwnership.addr].balance -= 1;
1324             _addressData[prevOwnership.addr].numberBurned += 1;
1325 
1326             // Keep track of who burned the token, and the timestamp of burning.
1327             _ownerships[tokenId].addr = prevOwnership.addr;
1328             _ownerships[tokenId].startTimestamp = uint64(block.timestamp);
1329             _ownerships[tokenId].burned = true;
1330 
1331             // If the ownership slot of tokenId+1 is not explicitly set, that means the burn initiator owns it.
1332             // Set the slot of tokenId+1 explicitly in storage to maintain correctness for ownerOf(tokenId+1) calls.
1333             uint256 nextTokenId = tokenId + 1;
1334             if (_ownerships[nextTokenId].addr == address(0)) {
1335                 // This will suffice for checking _exists(nextTokenId),
1336                 // as a burned slot cannot contain the zero address.
1337                 if (nextTokenId < _currentIndex) {
1338                     _ownerships[nextTokenId].addr = prevOwnership.addr;
1339                     _ownerships[nextTokenId].startTimestamp = prevOwnership.startTimestamp;
1340                 }
1341             }
1342         }
1343 
1344         emit Transfer(prevOwnership.addr, address(0), tokenId);
1345         _afterTokenTransfers(prevOwnership.addr, address(0), tokenId, 1);
1346 
1347         // Overflow not possible, as _burnCounter cannot be exceed _currentIndex times.
1348         unchecked {
1349             _burnCounter++;
1350         }
1351     }
1352 
1353     /**
1354      * @dev Approve `to` to operate on `tokenId`
1355      *
1356      * Emits a {Approval} event.
1357      */
1358     function _approve(
1359         address to,
1360         uint256 tokenId,
1361         address owner
1362     ) private {
1363         _tokenApprovals[tokenId] = to;
1364         emit Approval(owner, to, tokenId);
1365     }
1366 
1367     /**
1368      * @dev Internal function to invoke {IERC721Receiver-onERC721Received} on a target contract.
1369      *
1370      * @param from address representing the previous owner of the given token ID
1371      * @param to target address that will receive the tokens
1372      * @param tokenId uint256 ID of the token to be transferred
1373      * @param _data bytes optional data to send along with the call
1374      * @return bool whether the call correctly returned the expected magic value
1375      */
1376     function _checkContractOnERC721Received(
1377         address from,
1378         address to,
1379         uint256 tokenId,
1380         bytes memory _data
1381     ) private returns (bool) {
1382         try IERC721Receiver(to).onERC721Received(_msgSender(), from, tokenId, _data) returns (bytes4 retval) {
1383             return retval == IERC721Receiver(to).onERC721Received.selector;
1384         } catch (bytes memory reason) {
1385             if (reason.length == 0) {
1386                 revert TransferToNonERC721ReceiverImplementer();
1387             } else {
1388                 assembly {
1389                     revert(add(32, reason), mload(reason))
1390                 }
1391             }
1392         }
1393     }
1394 
1395     /**
1396      * @dev Hook that is called before a set of serially-ordered token ids are about to be transferred. This includes minting.
1397      * And also called before burning one token.
1398      *
1399      * startTokenId - the first token id to be transferred
1400      * quantity - the amount to be transferred
1401      *
1402      * Calling conditions:
1403      *
1404      * - When `from` and `to` are both non-zero, `from`'s `tokenId` will be
1405      * transferred to `to`.
1406      * - When `from` is zero, `tokenId` will be minted for `to`.
1407      * - When `to` is zero, `tokenId` will be burned by `from`.
1408      * - `from` and `to` are never both zero.
1409      */
1410     function _beforeTokenTransfers(
1411         address from,
1412         address to,
1413         uint256 startTokenId,
1414         uint256 quantity
1415     ) internal virtual {}
1416 
1417     /**
1418      * @dev Hook that is called after a set of serially-ordered token ids have been transferred. This includes
1419      * minting.
1420      * And also called after one token has been burned.
1421      *
1422      * startTokenId - the first token id to be transferred
1423      * quantity - the amount to be transferred
1424      *
1425      * Calling conditions:
1426      *
1427      * - When `from` and `to` are both non-zero, `from`'s `tokenId` has been
1428      * transferred to `to`.
1429      * - When `from` is zero, `tokenId` has been minted for `to`.
1430      * - When `to` is zero, `tokenId` has been burned by `from`.
1431      * - `from` and `to` are never both zero.
1432      */
1433     function _afterTokenTransfers(
1434         address from,
1435         address to,
1436         uint256 startTokenId,
1437         uint256 quantity
1438     ) internal virtual {}
1439 }
1440 
1441 // File: contracts/superordinaryvillains.sol
1442 
1443 
1444 
1445 pragma solidity >=0.8.9 <0.9.0;
1446 
1447 
1448 
1449 
1450 
1451 contract SuperOrdinaryVillains is ERC721A, Ownable, ReentrancyGuard {
1452 
1453   using Strings for uint256;
1454 
1455   mapping(address => uint256) public _whitelist; 
1456   mapping(address => bool) public whitelistClaimed;
1457 
1458   string public uriPrefix = '';
1459   string public uriSuffix = '.json';
1460   string public hiddenMetadataUri;
1461   
1462   uint256 public cost;
1463   uint256 public maxSupply;
1464   uint256 public maxMintAmountPerTx;
1465 
1466   bool public paused = true;
1467   bool public whitelistMintEnabled = false;
1468   bool public revealed = false;
1469   bool public teamMinted = false;
1470 
1471   constructor(
1472     string memory _tokenName,
1473     string memory _tokenSymbol,
1474     uint256 _cost,
1475     uint256 _maxSupply,
1476     uint256 _maxMintAmountPerTx,
1477     string memory _hiddenMetadataUri
1478   ) ERC721A(_tokenName, _tokenSymbol) {
1479     cost = _cost;
1480     maxSupply = _maxSupply;
1481     maxMintAmountPerTx = _maxMintAmountPerTx;
1482     setHiddenMetadataUri(_hiddenMetadataUri);
1483   }
1484 
1485   modifier mintCompliance(uint256 _mintAmount) {
1486     require(_mintAmount > 0 && _mintAmount <= maxMintAmountPerTx, 'Invalid mint amount!');
1487     require(totalSupply() + _mintAmount <= maxSupply, 'Max supply exceeded!');
1488     _;
1489   }
1490 
1491   modifier mintPriceCompliance(uint256 _mintAmount) {
1492     require(msg.value >= cost * _mintAmount, 'Insufficient funds!');
1493     _;
1494   }
1495 
1496   function whitelistMint(uint256 _mintAmount) public payable nonReentrant mintCompliance(_mintAmount) mintPriceCompliance(_mintAmount) {
1497     // Verify whitelist requirements
1498     require(whitelistMintEnabled, 'The whitelist sale is not enabled!');
1499     require(!whitelistClaimed[_msgSender()], 'Address already claimed!');
1500 
1501     _whitelist[_msgSender()] -= _mintAmount;
1502     _safeMint(_msgSender(), _mintAmount);
1503   }
1504 
1505 
1506   function mint(uint256 _mintAmount) public payable nonReentrant mintCompliance(_mintAmount) mintPriceCompliance(_mintAmount) {
1507     require(!paused, 'The contract is paused!');
1508 
1509     _safeMint(_msgSender(), _mintAmount);
1510   }
1511   
1512    function teamMint() external onlyOwner{
1513         require(!teamMinted, "team mint is complete");
1514         teamMinted = true;
1515         _safeMint(msg.sender, 155);
1516     }
1517 
1518   function walletOfOwner(address _owner) public view returns (uint256[] memory) {
1519     uint256 ownerTokenCount = balanceOf(_owner);
1520     uint256[] memory ownedTokenIds = new uint256[](ownerTokenCount);
1521     uint256 currentTokenId = _startTokenId();
1522     uint256 ownedTokenIndex = 0;
1523     address latestOwnerAddress;
1524 
1525     while (ownedTokenIndex < ownerTokenCount && currentTokenId <= maxSupply) {
1526       TokenOwnership memory ownership = _ownerships[currentTokenId];
1527 
1528       if (!ownership.burned && ownership.addr != address(0)) {
1529         latestOwnerAddress = ownership.addr;
1530       }
1531 
1532       if (latestOwnerAddress == _owner) {
1533         ownedTokenIds[ownedTokenIndex] = currentTokenId;
1534 
1535         ownedTokenIndex++;
1536       }
1537 
1538       currentTokenId++;
1539     }
1540 
1541     return ownedTokenIds;
1542   }
1543 
1544   function _startTokenId() internal view virtual override returns (uint256) {
1545         return 1;
1546     }
1547 
1548   function tokenURI(uint256 _tokenId) public view virtual override returns (string memory) {
1549     require(_exists(_tokenId), 'ERC721Metadata: URI query for nonexistent token');
1550 
1551     if (revealed == false) {
1552       return hiddenMetadataUri;
1553     }
1554 
1555     string memory currentBaseURI = _baseURI();
1556     return bytes(currentBaseURI).length > 0
1557         ? string(abi.encodePacked(currentBaseURI, _tokenId.toString(), uriSuffix))
1558         : '';
1559   }
1560 
1561   function setRevealed(bool _state) public onlyOwner {
1562     revealed = _state;
1563   }
1564 
1565   function setCost(uint256 _cost) public onlyOwner {
1566     cost = _cost;
1567   }
1568 
1569   function addWhitelist(address[] memory whitelist, uint256 credit) external onlyOwner {
1570       for (uint i = 0; i < whitelist.length; i++) {
1571           _whitelist[whitelist[i]] = credit;
1572         }
1573   }
1574 
1575   function setMaxMintAmountPerTx(uint256 _maxMintAmountPerTx) public onlyOwner {
1576     maxMintAmountPerTx = _maxMintAmountPerTx;
1577   }
1578 
1579   function setHiddenMetadataUri(string memory _hiddenMetadataUri) public onlyOwner {
1580     hiddenMetadataUri = _hiddenMetadataUri;
1581   }
1582 
1583   function setUriPrefix(string memory _uriPrefix) public onlyOwner {
1584     uriPrefix = _uriPrefix;
1585   }
1586 
1587   function setUriSuffix(string memory _uriSuffix) public onlyOwner {
1588     uriSuffix = _uriSuffix;
1589   }
1590 
1591   function setPaused(bool _state) public onlyOwner {
1592     paused = _state;
1593   }
1594 
1595   function setWhitelistMintEnabled(bool _state) public onlyOwner {
1596     whitelistMintEnabled = _state;
1597   }
1598 
1599   function withdrawMint() public onlyOwner nonReentrant {
1600     // distribution of mint 
1601         //2% withdrawal
1602         uint256 withdrawAmount_2 = address(this).balance * 2/100;
1603         //3% withdrawal
1604         uint256 withdrawAmount_3 = address(this).balance * 3/100;
1605         //.5% withdrawal
1606         uint256 withdrawAmount_point5 = address(this).balance * 5/1000;
1607         // 1.5% withdrawal
1608         uint256 withdrawAmount_1point5 = address(this).balance * 15/1000;
1609         payable(0x4a9C086f137B134b869A6C97E6B3819E9f3178B8).transfer(withdrawAmount_2);
1610         payable(0x5fd47bcCD17CAAB892367e280DB342e9Bb9272a4).transfer(withdrawAmount_3);
1611         payable(0x322Af0da66D00be980C7aa006377FCaaEee3BDFD).transfer(withdrawAmount_point5);
1612         payable(0x7809E1AdE5F9Be4081eD037DA009B70175e87BeF).transfer(withdrawAmount_1point5);
1613         payable(0x6F55361b9b364B623b4B69D05572BF786CC3fee7).transfer(address(this).balance);
1614   }
1615 
1616   function _baseURI() internal view virtual override returns (string memory) {
1617     return uriPrefix;
1618   }
1619 }