1 // SPDX-License-Identifier: GPL-3.0
2 
3 /**
4 
5     ╔╗╔╔═╗╔╦╗┌─┐┬─┐┬─┐┌─┐┬─┐┬┬ ┬┌┬┐
6     ║║║╠╣  ║ ├┤ ├┬┘├┬┘├─┤├┬┘││ ││││
7     ╝╚╝╚   ╩ └─┘┴└─┴└─┴ ┴┴└─┴└─┘┴ ┴
8     Contract by @texoid__
9 
10 */
11 
12 // OpenZeppelin Contracts (last updated v4.5.0) (utils/cryptography/MerkleProof.sol)
13 pragma solidity ^0.8.0;
14 /**
15  * @dev These functions deal with verification of Merkle Trees proofs.
16  *
17  * The proofs can be generated using the JavaScript library
18  * https://github.com/miguelmota/merkletreejs[merkletreejs].
19  * Note: the hashing algorithm should be keccak256 and pair sorting should be enabled.
20  *
21  * See `test/utils/cryptography/MerkleProof.test.js` for some examples.
22  */
23 library MerkleProof {
24     /**
25      * @dev Returns true if a `leaf` can be proved to be a part of a Merkle tree
26      * defined by `root`. For this, a `proof` must be provided, containing
27      * sibling hashes on the branch from the leaf to the root of the tree. Each
28      * pair of leaves and each pair of pre-images are assumed to be sorted.
29      */
30     function verify(
31         bytes32[] memory proof,
32         bytes32 root,
33         bytes32 leaf
34     ) internal pure returns (bool) {
35         return processProof(proof, leaf) == root;
36     }
37 
38     /**
39      * @dev Returns the rebuilt hash obtained by traversing a Merklee tree up
40      * from `leaf` using `proof`. A `proof` is valid if and only if the rebuilt
41      * hash matches the root of the tree. When processing the proof, the pairs
42      * of leafs & pre-images are assumed to be sorted.
43      *
44      * _Available since v4.4._
45      */
46     function processProof(bytes32[] memory proof, bytes32 leaf) internal pure returns (bytes32) {
47         bytes32 computedHash = leaf;
48         for (uint256 i = 0; i < proof.length; i++) {
49             bytes32 proofElement = proof[i];
50             if (computedHash <= proofElement) {
51                 // Hash(current computed hash + current element of the proof)
52                 computedHash = _efficientHash(computedHash, proofElement);
53             } else {
54                 // Hash(current element of the proof + current computed hash)
55                 computedHash = _efficientHash(proofElement, computedHash);
56             }
57         }
58         return computedHash;
59     }
60 
61     function _efficientHash(bytes32 a, bytes32 b) private pure returns (bytes32 value) {
62         assembly {
63             mstore(0x00, a)
64             mstore(0x20, b)
65             value := keccak256(0x00, 0x40)
66         }
67     }
68 }
69 
70 
71 
72 // OpenZeppelin Contracts v4.4.1 (utils/Strings.sol)
73 pragma solidity ^0.8.0;
74 /**
75  * @dev String operations.
76  */
77 library Strings {
78     bytes16 private constant _HEX_SYMBOLS = "0123456789abcdef";
79 
80     /**
81      * @dev Converts a `uint256` to its ASCII `string` decimal representation.
82      */
83     function toString(uint256 value) internal pure returns (string memory) {
84         // Inspired by OraclizeAPI's implementation - MIT licence
85         // https://github.com/oraclize/ethereum-api/blob/b42146b063c7d6ee1358846c198246239e9360e8/oraclizeAPI_0.4.25.sol
86 
87         if (value == 0) {
88             return "0";
89         }
90         uint256 temp = value;
91         uint256 digits;
92         while (temp != 0) {
93             digits++;
94             temp /= 10;
95         }
96         bytes memory buffer = new bytes(digits);
97         while (value != 0) {
98             digits -= 1;
99             buffer[digits] = bytes1(uint8(48 + uint256(value % 10)));
100             value /= 10;
101         }
102         return string(buffer);
103     }
104 
105     /**
106      * @dev Converts a `uint256` to its ASCII `string` hexadecimal representation.
107      */
108     function toHexString(uint256 value) internal pure returns (string memory) {
109         if (value == 0) {
110             return "0x00";
111         }
112         uint256 temp = value;
113         uint256 length = 0;
114         while (temp != 0) {
115             length++;
116             temp >>= 8;
117         }
118         return toHexString(value, length);
119     }
120 
121     /**
122      * @dev Converts a `uint256` to its ASCII `string` hexadecimal representation with fixed length.
123      */
124     function toHexString(uint256 value, uint256 length) internal pure returns (string memory) {
125         bytes memory buffer = new bytes(2 * length + 2);
126         buffer[0] = "0";
127         buffer[1] = "x";
128         for (uint256 i = 2 * length + 1; i > 1; --i) {
129             buffer[i] = _HEX_SYMBOLS[value & 0xf];
130             value >>= 4;
131         }
132         require(value == 0, "Strings: hex length insufficient");
133         return string(buffer);
134     }
135 }
136 
137 
138 // OpenZeppelin Contracts v4.4.1 (utils/Context.sol)
139 pragma solidity ^0.8.0;
140 /**
141  * @dev Provides information about the current execution context, including the
142  * sender of the transaction and its data. While these are generally available
143  * via msg.sender and msg.data, they should not be accessed in such a direct
144  * manner, since when dealing with meta-transactions the account sending and
145  * paying for execution may not be the actual sender (as far as an application
146  * is concerned).
147  *
148  * This contract is only required for intermediate, library-like contracts.
149  */
150 abstract contract Context {
151     function _msgSender() internal view virtual returns (address) {
152         return msg.sender;
153     }
154 
155     function _msgData() internal view virtual returns (bytes calldata) {
156         return msg.data;
157     }
158 }
159 
160 
161 // OpenZeppelin Contracts (last updated v4.5.0) (utils/Address.sol)
162 pragma solidity ^0.8.1;
163 /**
164  * @dev Collection of functions related to the address type
165  */
166 library Address {
167     /**
168      * @dev Returns true if `account` is a contract.
169      *
170      * [IMPORTANT]
171      * ====
172      * It is unsafe to assume that an address for which this function returns
173      * false is an externally-owned account (EOA) and not a contract.
174      *
175      * Among others, `isContract` will return false for the following
176      * types of addresses:
177      *
178      *  - an externally-owned account
179      *  - a contract in construction
180      *  - an address where a contract will be created
181      *  - an address where a contract lived, but was destroyed
182      * ====
183      *
184      * [IMPORTANT]
185      * ====
186      * You shouldn't rely on `isContract` to protect against flash loan attacks!
187      *
188      * Preventing calls from contracts is highly discouraged. It breaks composability, breaks support for smart wallets
189      * like Gnosis Safe, and does not provide security since it can be circumvented by calling from a contract
190      * constructor.
191      * ====
192      */
193     function isContract(address account) internal view returns (bool) {
194         // This method relies on extcodesize/address.code.length, which returns 0
195         // for contracts in construction, since the code is only stored at the end
196         // of the constructor execution.
197 
198         return account.code.length > 0;
199     }
200 
201     /**
202      * @dev Replacement for Solidity's `transfer`: sends `amount` wei to
203      * `recipient`, forwarding all available gas and reverting on errors.
204      *
205      * https://eips.ethereum.org/EIPS/eip-1884[EIP1884] increases the gas cost
206      * of certain opcodes, possibly making contracts go over the 2300 gas limit
207      * imposed by `transfer`, making them unable to receive funds via
208      * `transfer`. {sendValue} removes this limitation.
209      *
210      * https://diligence.consensys.net/posts/2019/09/stop-using-soliditys-transfer-now/[Learn more].
211      *
212      * IMPORTANT: because control is transferred to `recipient`, care must be
213      * taken to not create reentrancy vulnerabilities. Consider using
214      * {ReentrancyGuard} or the
215      * https://solidity.readthedocs.io/en/v0.5.11/security-considerations.html#use-the-checks-effects-interactions-pattern[checks-effects-interactions pattern].
216      */
217     function sendValue(address payable recipient, uint256 amount) internal {
218         require(address(this).balance >= amount, "Address: insufficient balance");
219 
220         (bool success, ) = recipient.call{value: amount}("");
221         require(success, "Address: unable to send value, recipient may have reverted");
222     }
223 
224     /**
225      * @dev Performs a Solidity function call using a low level `call`. A
226      * plain `call` is an unsafe replacement for a function call: use this
227      * function instead.
228      *
229      * If `target` reverts with a revert reason, it is bubbled up by this
230      * function (like regular Solidity function calls).
231      *
232      * Returns the raw returned data. To convert to the expected return value,
233      * use https://solidity.readthedocs.io/en/latest/units-and-global-variables.html?highlight=abi.decode#abi-encoding-and-decoding-functions[`abi.decode`].
234      *
235      * Requirements:
236      *
237      * - `target` must be a contract.
238      * - calling `target` with `data` must not revert.
239      *
240      * _Available since v3.1._
241      */
242     function functionCall(address target, bytes memory data) internal returns (bytes memory) {
243         return functionCall(target, data, "Address: low-level call failed");
244     }
245 
246     /**
247      * @dev Same as {xref-Address-functionCall-address-bytes-}[`functionCall`], but with
248      * `errorMessage` as a fallback revert reason when `target` reverts.
249      *
250      * _Available since v3.1._
251      */
252     function functionCall(
253         address target,
254         bytes memory data,
255         string memory errorMessage
256     ) internal returns (bytes memory) {
257         return functionCallWithValue(target, data, 0, errorMessage);
258     }
259 
260     /**
261      * @dev Same as {xref-Address-functionCall-address-bytes-}[`functionCall`],
262      * but also transferring `value` wei to `target`.
263      *
264      * Requirements:
265      *
266      * - the calling contract must have an ETH balance of at least `value`.
267      * - the called Solidity function must be `payable`.
268      *
269      * _Available since v3.1._
270      */
271     function functionCallWithValue(
272         address target,
273         bytes memory data,
274         uint256 value
275     ) internal returns (bytes memory) {
276         return functionCallWithValue(target, data, value, "Address: low-level call with value failed");
277     }
278 
279     /**
280      * @dev Same as {xref-Address-functionCallWithValue-address-bytes-uint256-}[`functionCallWithValue`], but
281      * with `errorMessage` as a fallback revert reason when `target` reverts.
282      *
283      * _Available since v3.1._
284      */
285     function functionCallWithValue(
286         address target,
287         bytes memory data,
288         uint256 value,
289         string memory errorMessage
290     ) internal returns (bytes memory) {
291         require(address(this).balance >= value, "Address: insufficient balance for call");
292         require(isContract(target), "Address: call to non-contract");
293 
294         (bool success, bytes memory returndata) = target.call{value: value}(data);
295         return verifyCallResult(success, returndata, errorMessage);
296     }
297 
298     /**
299      * @dev Same as {xref-Address-functionCall-address-bytes-}[`functionCall`],
300      * but performing a static call.
301      *
302      * _Available since v3.3._
303      */
304     function functionStaticCall(address target, bytes memory data) internal view returns (bytes memory) {
305         return functionStaticCall(target, data, "Address: low-level static call failed");
306     }
307 
308     /**
309      * @dev Same as {xref-Address-functionCall-address-bytes-string-}[`functionCall`],
310      * but performing a static call.
311      *
312      * _Available since v3.3._
313      */
314     function functionStaticCall(
315         address target,
316         bytes memory data,
317         string memory errorMessage
318     ) internal view returns (bytes memory) {
319         require(isContract(target), "Address: static call to non-contract");
320 
321         (bool success, bytes memory returndata) = target.staticcall(data);
322         return verifyCallResult(success, returndata, errorMessage);
323     }
324 
325     /**
326      * @dev Same as {xref-Address-functionCall-address-bytes-}[`functionCall`],
327      * but performing a delegate call.
328      *
329      * _Available since v3.4._
330      */
331     function functionDelegateCall(address target, bytes memory data) internal returns (bytes memory) {
332         return functionDelegateCall(target, data, "Address: low-level delegate call failed");
333     }
334 
335     /**
336      * @dev Same as {xref-Address-functionCall-address-bytes-string-}[`functionCall`],
337      * but performing a delegate call.
338      *
339      * _Available since v3.4._
340      */
341     function functionDelegateCall(
342         address target,
343         bytes memory data,
344         string memory errorMessage
345     ) internal returns (bytes memory) {
346         require(isContract(target), "Address: delegate call to non-contract");
347 
348         (bool success, bytes memory returndata) = target.delegatecall(data);
349         return verifyCallResult(success, returndata, errorMessage);
350     }
351 
352     /**
353      * @dev Tool to verifies that a low level call was successful, and revert if it wasn't, either by bubbling the
354      * revert reason using the provided one.
355      *
356      * _Available since v4.3._
357      */
358     function verifyCallResult(
359         bool success,
360         bytes memory returndata,
361         string memory errorMessage
362     ) internal pure returns (bytes memory) {
363         if (success) {
364             return returndata;
365         } else {
366             // Look for revert reason and bubble it up if present
367             if (returndata.length > 0) {
368                 // The easiest way to bubble the revert reason is using memory via assembly
369 
370                 assembly {
371                     let returndata_size := mload(returndata)
372                     revert(add(32, returndata), returndata_size)
373                 }
374             } else {
375                 revert(errorMessage);
376             }
377         }
378     }
379 }
380 
381 
382 // OpenZeppelin Contracts v4.4.1 (security/ReentrancyGuard.sol)
383 pragma solidity ^0.8.0;
384 /**
385  * @dev Contract module that helps prevent reentrant calls to a function.
386  *
387  * Inheriting from `ReentrancyGuard` will make the {nonReentrant} modifier
388  * available, which can be applied to functions to make sure there are no nested
389  * (reentrant) calls to them.
390  *
391  * Note that because there is a single `nonReentrant` guard, functions marked as
392  * `nonReentrant` may not call one another. This can be worked around by making
393  * those functions `private`, and then adding `external` `nonReentrant` entry
394  * points to them.
395  *
396  * TIP: If you would like to learn more about reentrancy and alternative ways
397  * to protect against it, check out our blog post
398  * https://blog.openzeppelin.com/reentrancy-after-istanbul/[Reentrancy After Istanbul].
399  */
400 abstract contract ReentrancyGuard {
401     // Booleans are more expensive than uint256 or any type that takes up a full
402     // word because each write operation emits an extra SLOAD to first read the
403     // slot's contents, replace the bits taken up by the boolean, and then write
404     // back. This is the compiler's defense against contract upgrades and
405     // pointer aliasing, and it cannot be disabled.
406 
407     // The values being non-zero value makes deployment a bit more expensive,
408     // but in exchange the refund on every call to nonReentrant will be lower in
409     // amount. Since refunds are capped to a percentage of the total
410     // transaction's gas, it is best to keep them low in cases like this one, to
411     // increase the likelihood of the full refund coming into effect.
412     uint256 private constant _NOT_ENTERED = 1;
413     uint256 private constant _ENTERED = 2;
414 
415     uint256 private _status;
416 
417     constructor() {
418         _status = _NOT_ENTERED;
419     }
420 
421     /**
422      * @dev Prevents a contract from calling itself, directly or indirectly.
423      * Calling a `nonReentrant` function from another `nonReentrant`
424      * function is not supported. It is possible to prevent this from happening
425      * by making the `nonReentrant` function external, and making it call a
426      * `private` function that does the actual work.
427      */
428     modifier nonReentrant() {
429         // On the first call to nonReentrant, _notEntered will be true
430         require(_status != _ENTERED, "ReentrancyGuard: reentrant call");
431 
432         // Any calls to nonReentrant after this point will fail
433         _status = _ENTERED;
434 
435         _;
436 
437         // By storing the original value once again, a refund is triggered (see
438         // https://eips.ethereum.org/EIPS/eip-2200)
439         _status = _NOT_ENTERED;
440     }
441 }
442 
443 
444 // OpenZeppelin Contracts v4.4.1 (access/Ownable.sol)
445 pragma solidity ^0.8.0;
446 /**
447  * @dev Contract module which provides a basic access control mechanism, where
448  * there is an account (an owner) that can be granted exclusive access to
449  * specific functions.
450  *
451  * By default, the owner account will be the one that deploys the contract. This
452  * can later be changed with {transferOwnership}.
453  *
454  * This module is used through inheritance. It will make available the modifier
455  * `onlyOwner`, which can be applied to your functions to restrict their use to
456  * the owner.
457  */
458 abstract contract Ownable is Context {
459     address private _owner;
460 
461     event OwnershipTransferred(address indexed previousOwner, address indexed newOwner);
462 
463     /**
464      * @dev Initializes the contract setting the deployer as the initial owner.
465      */
466     constructor() {
467         _transferOwnership(_msgSender());
468     }
469 
470     /**
471      * @dev Returns the address of the current owner.
472      */
473     function owner() public view virtual returns (address) {
474         return _owner;
475     }
476 
477     /**
478      * @dev Throws if called by any account other than the owner.
479      */
480     modifier onlyOwner() {
481         require(owner() == _msgSender(), "Ownable: caller is not the owner");
482         _;
483     }
484 
485     /**
486      * @dev Leaves the contract without owner. It will not be possible to call
487      * `onlyOwner` functions anymore. Can only be called by the current owner.
488      *
489      * NOTE: Renouncing ownership will leave the contract without an owner,
490      * thereby removing any functionality that is only available to the owner.
491      */
492     function renounceOwnership() public virtual onlyOwner {
493         _transferOwnership(address(0));
494     }
495 
496     /**
497      * @dev Transfers ownership of the contract to a new account (`newOwner`).
498      * Can only be called by the current owner.
499      */
500     function transferOwnership(address newOwner) public virtual onlyOwner {
501         require(newOwner != address(0), "Ownable: new owner is the zero address");
502         _transferOwnership(newOwner);
503     }
504 
505     /**
506      * @dev Transfers ownership of the contract to a new account (`newOwner`).
507      * Internal function without access restriction.
508      */
509     function _transferOwnership(address newOwner) internal virtual {
510         address oldOwner = _owner;
511         _owner = newOwner;
512         emit OwnershipTransferred(oldOwner, newOwner);
513     }
514 }
515 
516 
517 
518 // OpenZeppelin Contracts v4.4.1 (utils/introspection/IERC165.sol)
519 pragma solidity ^0.8.0;
520 /**
521  * @dev Interface of the ERC165 standard, as defined in the
522  * https://eips.ethereum.org/EIPS/eip-165[EIP].
523  *
524  * Implementers can declare support of contract interfaces, which can then be
525  * queried by others ({ERC165Checker}).
526  *
527  * For an implementation, see {ERC165}.
528  */
529 interface IERC165 {
530     /**
531      * @dev Returns true if this contract implements the interface defined by
532      * `interfaceId`. See the corresponding
533      * https://eips.ethereum.org/EIPS/eip-165#how-interfaces-are-identified[EIP section]
534      * to learn more about how these ids are created.
535      *
536      * This function call must use less than 30 000 gas.
537      */
538     function supportsInterface(bytes4 interfaceId) external view returns (bool);
539 }
540 
541 // OpenZeppelin Contracts v4.4.1 (token/ERC721/IERC721.sol)
542 pragma solidity ^0.8.0;
543 /**
544  * @dev Required interface of an ERC721 compliant contract.
545  */
546 interface IERC721 is IERC165 {
547     /**
548      * @dev Emitted when `tokenId` token is transferred from `from` to `to`.
549      */
550     event Transfer(address indexed from, address indexed to, uint256 indexed tokenId);
551 
552     /**
553      * @dev Emitted when `owner` enables `approved` to manage the `tokenId` token.
554      */
555     event Approval(address indexed owner, address indexed approved, uint256 indexed tokenId);
556 
557     /**
558      * @dev Emitted when `owner` enables or disables (`approved`) `operator` to manage all of its assets.
559      */
560     event ApprovalForAll(address indexed owner, address indexed operator, bool approved);
561 
562     /**
563      * @dev Returns the number of tokens in ``owner``'s account.
564      */
565     function balanceOf(address owner) external view returns (uint256 balance);
566 
567     /**
568      * @dev Returns the owner of the `tokenId` token.
569      *
570      * Requirements:
571      *
572      * - `tokenId` must exist.
573      */
574     function ownerOf(uint256 tokenId) external view returns (address owner);
575 
576     /**
577      * @dev Safely transfers `tokenId` token from `from` to `to`, checking first that contract recipients
578      * are aware of the ERC721 protocol to prevent tokens from being forever locked.
579      *
580      * Requirements:
581      *
582      * - `from` cannot be the zero address.
583      * - `to` cannot be the zero address.
584      * - `tokenId` token must exist and be owned by `from`.
585      * - If the caller is not `from`, it must be have been allowed to move this token by either {approve} or {setApprovalForAll}.
586      * - If `to` refers to a smart contract, it must implement {IERC721Receiver-onERC721Received}, which is called upon a safe transfer.
587      *
588      * Emits a {Transfer} event.
589      */
590     function safeTransferFrom(
591         address from,
592         address to,
593         uint256 tokenId
594     ) external;
595 
596     /**
597      * @dev Transfers `tokenId` token from `from` to `to`.
598      *
599      * WARNING: Usage of this method is discouraged, use {safeTransferFrom} whenever possible.
600      *
601      * Requirements:
602      *
603      * - `from` cannot be the zero address.
604      * - `to` cannot be the zero address.
605      * - `tokenId` token must be owned by `from`.
606      * - If the caller is not `from`, it must be approved to move this token by either {approve} or {setApprovalForAll}.
607      *
608      * Emits a {Transfer} event.
609      */
610     function transferFrom(
611         address from,
612         address to,
613         uint256 tokenId
614     ) external;
615 
616     /**
617      * @dev Gives permission to `to` to transfer `tokenId` token to another account.
618      * The approval is cleared when the token is transferred.
619      *
620      * Only a single account can be approved at a time, so approving the zero address clears previous approvals.
621      *
622      * Requirements:
623      *
624      * - The caller must own the token or be an approved operator.
625      * - `tokenId` must exist.
626      *
627      * Emits an {Approval} event.
628      */
629     function approve(address to, uint256 tokenId) external;
630 
631     /**
632      * @dev Returns the account approved for `tokenId` token.
633      *
634      * Requirements:
635      *
636      * - `tokenId` must exist.
637      */
638     function getApproved(uint256 tokenId) external view returns (address operator);
639 
640     /**
641      * @dev Approve or remove `operator` as an operator for the caller.
642      * Operators can call {transferFrom} or {safeTransferFrom} for any token owned by the caller.
643      *
644      * Requirements:
645      *
646      * - The `operator` cannot be the caller.
647      *
648      * Emits an {ApprovalForAll} event.
649      */
650     function setApprovalForAll(address operator, bool _approved) external;
651 
652     /**
653      * @dev Returns if the `operator` is allowed to manage all of the assets of `owner`.
654      *
655      * See {setApprovalForAll}
656      */
657     function isApprovedForAll(address owner, address operator) external view returns (bool);
658 
659     /**
660      * @dev Safely transfers `tokenId` token from `from` to `to`.
661      *
662      * Requirements:
663      *
664      * - `from` cannot be the zero address.
665      * - `to` cannot be the zero address.
666      * - `tokenId` token must exist and be owned by `from`.
667      * - If the caller is not `from`, it must be approved to move this token by either {approve} or {setApprovalForAll}.
668      * - If `to` refers to a smart contract, it must implement {IERC721Receiver-onERC721Received}, which is called upon a safe transfer.
669      *
670      * Emits a {Transfer} event.
671      */
672     function safeTransferFrom(
673         address from,
674         address to,
675         uint256 tokenId,
676         bytes calldata data
677     ) external;
678 }
679 
680 
681 // OpenZeppelin Contracts v4.4.1 (utils/introspection/ERC165.sol)
682 pragma solidity ^0.8.0;
683 /**
684  * @dev Implementation of the {IERC165} interface.
685  *
686  * Contracts that want to implement ERC165 should inherit from this contract and override {supportsInterface} to check
687  * for the additional interface id that will be supported. For example:
688  *
689  * ```solidity
690  * function supportsInterface(bytes4 interfaceId) public view virtual override returns (bool) {
691  *     return interfaceId == type(MyInterface).interfaceId || super.supportsInterface(interfaceId);
692  * }
693  * ```
694  *
695  * Alternatively, {ERC165Storage} provides an easier to use but more expensive implementation.
696  */
697 abstract contract ERC165 is IERC165 {
698     /**
699      * @dev See {IERC165-supportsInterface}.
700      */
701     function supportsInterface(bytes4 interfaceId) public view virtual override returns (bool) {
702         return interfaceId == type(IERC165).interfaceId;
703     }
704 }
705 
706 
707 // OpenZeppelin Contracts (last updated v4.5.0) (token/ERC721/extensions/IERC721Enumerable.sol)
708 pragma solidity ^0.8.0;
709 /**
710  * @title ERC-721 Non-Fungible Token Standard, optional enumeration extension
711  * @dev See https://eips.ethereum.org/EIPS/eip-721
712  */
713 interface IERC721Enumerable is IERC721 {
714     /**
715      * @dev Returns the total amount of tokens stored by the contract.
716      */
717     function totalSupply() external view returns (uint256);
718 
719     /**
720      * @dev Returns a token ID owned by `owner` at a given `index` of its token list.
721      * Use along with {balanceOf} to enumerate all of ``owner``'s tokens.
722      */
723     function tokenOfOwnerByIndex(address owner, uint256 index) external view returns (uint256);
724 
725     /**
726      * @dev Returns a token ID at a given `index` of all the tokens stored by the contract.
727      * Use along with {totalSupply} to enumerate all tokens.
728      */
729     function tokenByIndex(uint256 index) external view returns (uint256);
730 }
731 
732 
733 // OpenZeppelin Contracts v4.4.1 (token/ERC721/extensions/IERC721Metadata.sol)
734 pragma solidity ^0.8.0;
735 /**
736  * @title ERC-721 Non-Fungible Token Standard, optional metadata extension
737  * @dev See https://eips.ethereum.org/EIPS/eip-721
738  */
739 interface IERC721Metadata is IERC721 {
740     /**
741      * @dev Returns the token collection name.
742      */
743     function name() external view returns (string memory);
744 
745     /**
746      * @dev Returns the token collection symbol.
747      */
748     function symbol() external view returns (string memory);
749 
750     /**
751      * @dev Returns the Uniform Resource Identifier (URI) for `tokenId` token.
752      */
753     function tokenURI(uint256 tokenId) external view returns (string memory);
754 }
755 
756 
757 // OpenZeppelin Contracts v4.4.1 (token/ERC721/IERC721Receiver.sol)
758 pragma solidity ^0.8.0;
759 /**
760  * @title ERC721 token receiver interface
761  * @dev Interface for any contract that wants to support safeTransfers
762  * from ERC721 asset contracts.
763  */
764 interface IERC721Receiver {
765     /**
766      * @dev Whenever an {IERC721} `tokenId` token is transferred to this contract via {IERC721-safeTransferFrom}
767      * by `operator` from `from`, this function is called.
768      *
769      * It must return its Solidity selector to confirm the token transfer.
770      * If any other value is returned or the interface is not implemented by the recipient, the transfer will be reverted.
771      *
772      * The selector can be obtained in Solidity with `IERC721.onERC721Received.selector`.
773      */
774     function onERC721Received(
775         address operator,
776         address from,
777         uint256 tokenId,
778         bytes calldata data
779     ) external returns (bytes4);
780 }
781 
782 
783 // Creator: Chiru Labs
784 pragma solidity ^0.8.4;
785 
786 error ApprovalCallerNotOwnerNorApproved();
787 error ApprovalQueryForNonexistentToken();
788 error ApproveToCaller();
789 error ApprovalToCurrentOwner();
790 error BalanceQueryForZeroAddress();
791 error MintedQueryForZeroAddress();
792 error BurnedQueryForZeroAddress();
793 error AuxQueryForZeroAddress();
794 error MintToZeroAddress();
795 error MintZeroQuantity();
796 error OwnerIndexOutOfBounds();
797 error OwnerQueryForNonexistentToken();
798 error TokenIndexOutOfBounds();
799 error TransferCallerNotOwnerNorApproved();
800 error TransferFromIncorrectOwner();
801 error TransferToNonERC721ReceiverImplementer();
802 error TransferToZeroAddress();
803 error URIQueryForNonexistentToken();
804 
805 /**
806  * @dev Implementation of https://eips.ethereum.org/EIPS/eip-721[ERC721] Non-Fungible Token Standard, including
807  * the Metadata extension. Built to optimize for lower gas during batch mints.
808  *
809  * Assumes serials are sequentially minted starting at _startTokenId() (defaults to 0, e.g. 0, 1, 2, 3..).
810  *
811  * Assumes that an owner cannot have more than 2**64 - 1 (max value of uint64) of supply.
812  *
813  * Assumes that the maximum token id cannot exceed 2**256 - 1 (max value of uint256).
814  */
815 contract ERC721A is Context, ERC165, IERC721, IERC721Metadata {
816     using Address for address;
817     using Strings for uint256;
818 
819     // Compiler will pack this into a single 256bit word.
820     struct TokenOwnership {
821         // The address of the owner.
822         address addr;
823         // Keeps track of the start time of ownership with minimal overhead for tokenomics.
824         uint64 startTimestamp;
825         // Whether the token has been burned.
826         bool burned;
827     }
828 
829     // Compiler will pack this into a single 256bit word.
830     struct AddressData {
831         // Realistically, 2**64-1 is more than enough.
832         uint64 balance;
833         // Keeps track of mint count with minimal overhead for tokenomics.
834         uint64 numberMinted;
835         // Keeps track of burn count with minimal overhead for tokenomics.
836         uint64 numberBurned;
837         // For miscellaneous variable(s) pertaining to the address
838         // (e.g. number of whitelist mint slots used).
839         // If there are multiple variables, please pack them into a uint64.
840         uint64 aux;
841     }
842 
843     // The tokenId of the next token to be minted.
844     uint256 internal _currentIndex;
845 
846     // The number of tokens burned.
847     uint256 internal _burnCounter;
848 
849     // Token name
850     string private _name;
851 
852     // Token symbol
853     string private _symbol;
854 
855     // Mapping from token ID to ownership details
856     // An empty struct value does not necessarily mean the token is unowned. See ownershipOf implementation for details.
857     mapping(uint256 => TokenOwnership) internal _ownerships;
858 
859     // Mapping owner address to address data
860     mapping(address => AddressData) private _addressData;
861 
862     // Mapping from token ID to approved address
863     mapping(uint256 => address) private _tokenApprovals;
864 
865     // Mapping from owner to operator approvals
866     mapping(address => mapping(address => bool)) private _operatorApprovals;
867 
868     constructor(string memory name_, string memory symbol_) {
869         _name = name_;
870         _symbol = symbol_;
871         _currentIndex = _startTokenId();
872     }
873 
874     /**
875      * To change the starting tokenId, please override this function.
876      */
877     function _startTokenId() internal view virtual returns (uint256) {
878         return 0;
879     }
880 
881     /**
882      * @dev See {IERC721Enumerable-totalSupply}.
883      * @dev Burned tokens are calculated here, use _totalMinted() if you want to count just minted tokens.
884      */
885     function totalSupply() public view returns (uint256) {
886         // Counter underflow is impossible as _burnCounter cannot be incremented
887         // more than _currentIndex - _startTokenId() times
888         unchecked {
889             return _currentIndex - _burnCounter - _startTokenId();
890         }
891     }
892 
893     /**
894      * Returns the total amount of tokens minted in the contract.
895      */
896     function _totalMinted() internal view returns (uint256) {
897         // Counter underflow is impossible as _currentIndex does not decrement,
898         // and it is initialized to _startTokenId()
899         unchecked {
900             return _currentIndex - _startTokenId();
901         }
902     }
903 
904     /**
905      * @dev See {IERC165-supportsInterface}.
906      */
907     function supportsInterface(bytes4 interfaceId) public view virtual override(ERC165, IERC165) returns (bool) {
908         return
909             interfaceId == type(IERC721).interfaceId ||
910             interfaceId == type(IERC721Metadata).interfaceId ||
911             super.supportsInterface(interfaceId);
912     }
913 
914     /**
915      * @dev See {IERC721-balanceOf}.
916      */
917     function balanceOf(address owner) public view override returns (uint256) {
918         if (owner == address(0)) revert BalanceQueryForZeroAddress();
919         return uint256(_addressData[owner].balance);
920     }
921 
922     /**
923      * Returns the number of tokens minted by `owner`.
924      */
925     function _numberMinted(address owner) internal view returns (uint256) {
926         if (owner == address(0)) revert MintedQueryForZeroAddress();
927         return uint256(_addressData[owner].numberMinted);
928     }
929 
930     /**
931      * Returns the number of tokens burned by or on behalf of `owner`.
932      */
933     function _numberBurned(address owner) internal view returns (uint256) {
934         if (owner == address(0)) revert BurnedQueryForZeroAddress();
935         return uint256(_addressData[owner].numberBurned);
936     }
937 
938     /**
939      * Returns the auxillary data for `owner`. (e.g. number of whitelist mint slots used).
940      */
941     function _getAux(address owner) internal view returns (uint64) {
942         if (owner == address(0)) revert AuxQueryForZeroAddress();
943         return _addressData[owner].aux;
944     }
945 
946     /**
947      * Sets the auxillary data for `owner`. (e.g. number of whitelist mint slots used).
948      * If there are multiple variables, please pack them into a uint64.
949      */
950     function _setAux(address owner, uint64 aux) internal {
951         if (owner == address(0)) revert AuxQueryForZeroAddress();
952         _addressData[owner].aux = aux;
953     }
954 
955     /**
956      * Gas spent here starts off proportional to the maximum mint batch size.
957      * It gradually moves to O(1) as tokens get transferred around in the collection over time.
958      */
959     function ownershipOf(uint256 tokenId) internal view returns (TokenOwnership memory) {
960         uint256 curr = tokenId;
961 
962         unchecked {
963             if (_startTokenId() <= curr && curr < _currentIndex) {
964                 TokenOwnership memory ownership = _ownerships[curr];
965                 if (!ownership.burned) {
966                     if (ownership.addr != address(0)) {
967                         return ownership;
968                     }
969                     // Invariant:
970                     // There will always be an ownership that has an address and is not burned
971                     // before an ownership that does not have an address and is not burned.
972                     // Hence, curr will not underflow.
973                     while (true) {
974                         curr--;
975                         ownership = _ownerships[curr];
976                         if (ownership.addr != address(0)) {
977                             return ownership;
978                         }
979                     }
980                 }
981             }
982         }
983         revert OwnerQueryForNonexistentToken();
984     }
985 
986     /**
987      * @dev See {IERC721-ownerOf}.
988      */
989     function ownerOf(uint256 tokenId) public view override returns (address) {
990         return ownershipOf(tokenId).addr;
991     }
992 
993     /**
994      * @dev See {IERC721Metadata-name}.
995      */
996     function name() public view virtual override returns (string memory) {
997         return _name;
998     }
999 
1000     /**
1001      * @dev See {IERC721Metadata-symbol}.
1002      */
1003     function symbol() public view virtual override returns (string memory) {
1004         return _symbol;
1005     }
1006 
1007     /**
1008      * @dev See {IERC721Metadata-tokenURI}.
1009      */
1010     function tokenURI(uint256 tokenId) public view virtual override returns (string memory) {
1011         if (!_exists(tokenId)) revert URIQueryForNonexistentToken();
1012 
1013         string memory baseURI = _baseURI();
1014         return bytes(baseURI).length != 0 ? string(abi.encodePacked(baseURI, tokenId.toString())) : '';
1015     }
1016 
1017     /**
1018      * @dev Base URI for computing {tokenURI}. If set, the resulting URI for each
1019      * token will be the concatenation of the `baseURI` and the `tokenId`. Empty
1020      * by default, can be overriden in child contracts.
1021      */
1022     function _baseURI() internal view virtual returns (string memory) {
1023         return '';
1024     }
1025 
1026     /**
1027      * @dev See {IERC721-approve}.
1028      */
1029     function approve(address to, uint256 tokenId) public override {
1030         address owner = ERC721A.ownerOf(tokenId);
1031         if (to == owner) revert ApprovalToCurrentOwner();
1032 
1033         if (_msgSender() != owner && !isApprovedForAll(owner, _msgSender())) {
1034             revert ApprovalCallerNotOwnerNorApproved();
1035         }
1036 
1037         _approve(to, tokenId, owner);
1038     }
1039 
1040     /**
1041      * @dev See {IERC721-getApproved}.
1042      */
1043     function getApproved(uint256 tokenId) public view override returns (address) {
1044         if (!_exists(tokenId)) revert ApprovalQueryForNonexistentToken();
1045 
1046         return _tokenApprovals[tokenId];
1047     }
1048 
1049     /**
1050      * @dev See {IERC721-setApprovalForAll}.
1051      */
1052     function setApprovalForAll(address operator, bool approved) public override {
1053         if (operator == _msgSender()) revert ApproveToCaller();
1054 
1055         _operatorApprovals[_msgSender()][operator] = approved;
1056         emit ApprovalForAll(_msgSender(), operator, approved);
1057     }
1058 
1059     /**
1060      * @dev See {IERC721-isApprovedForAll}.
1061      */
1062     function isApprovedForAll(address owner, address operator) public view virtual override returns (bool) {
1063         return _operatorApprovals[owner][operator];
1064     }
1065 
1066     /**
1067      * @dev See {IERC721-transferFrom}.
1068      */
1069     function transferFrom(
1070         address from,
1071         address to,
1072         uint256 tokenId
1073     ) public virtual override {
1074         _transfer(from, to, tokenId);
1075     }
1076 
1077     /**
1078      * @dev See {IERC721-safeTransferFrom}.
1079      */
1080     function safeTransferFrom(
1081         address from,
1082         address to,
1083         uint256 tokenId
1084     ) public virtual override {
1085         safeTransferFrom(from, to, tokenId, '');
1086     }
1087 
1088     /**
1089      * @dev See {IERC721-safeTransferFrom}.
1090      */
1091     function safeTransferFrom(
1092         address from,
1093         address to,
1094         uint256 tokenId,
1095         bytes memory _data
1096     ) public virtual override {
1097         _transfer(from, to, tokenId);
1098         if (to.isContract() && !_checkContractOnERC721Received(from, to, tokenId, _data)) {
1099             revert TransferToNonERC721ReceiverImplementer();
1100         }
1101     }
1102 
1103     /**
1104      * @dev Returns whether `tokenId` exists.
1105      *
1106      * Tokens can be managed by their owner or approved accounts via {approve} or {setApprovalForAll}.
1107      *
1108      * Tokens start existing when they are minted (`_mint`),
1109      */
1110     function _exists(uint256 tokenId) internal view returns (bool) {
1111         return _startTokenId() <= tokenId && tokenId < _currentIndex &&
1112             !_ownerships[tokenId].burned;
1113     }
1114 
1115     function _safeMint(address to, uint256 quantity) internal {
1116         _safeMint(to, quantity, '');
1117     }
1118 
1119     /**
1120      * @dev Safely mints `quantity` tokens and transfers them to `to`.
1121      *
1122      * Requirements:
1123      *
1124      * - If `to` refers to a smart contract, it must implement {IERC721Receiver-onERC721Received}, which is called for each safe transfer.
1125      * - `quantity` must be greater than 0.
1126      *
1127      * Emits a {Transfer} event.
1128      */
1129     function _safeMint(
1130         address to,
1131         uint256 quantity,
1132         bytes memory _data
1133     ) internal {
1134         _mint(to, quantity, _data, true);
1135     }
1136 
1137     /**
1138      * @dev Mints `quantity` tokens and transfers them to `to`.
1139      *
1140      * Requirements:
1141      *
1142      * - `to` cannot be the zero address.
1143      * - `quantity` must be greater than 0.
1144      *
1145      * Emits a {Transfer} event.
1146      */
1147     function _mint(
1148         address to,
1149         uint256 quantity,
1150         bytes memory _data,
1151         bool safe
1152     ) internal {
1153         uint256 startTokenId = _currentIndex;
1154         if (to == address(0)) revert MintToZeroAddress();
1155         if (quantity == 0) revert MintZeroQuantity();
1156 
1157         _beforeTokenTransfers(address(0), to, startTokenId, quantity);
1158 
1159         // Overflows are incredibly unrealistic.
1160         // balance or numberMinted overflow if current value of either + quantity > 1.8e19 (2**64) - 1
1161         // updatedIndex overflows if _currentIndex + quantity > 1.2e77 (2**256) - 1
1162         unchecked {
1163             _addressData[to].balance += uint64(quantity);
1164             _addressData[to].numberMinted += uint64(quantity);
1165 
1166             _ownerships[startTokenId].addr = to;
1167             _ownerships[startTokenId].startTimestamp = uint64(block.timestamp);
1168 
1169             uint256 updatedIndex = startTokenId;
1170             uint256 end = updatedIndex + quantity;
1171 
1172             if (safe && to.isContract()) {
1173                 do {
1174                     emit Transfer(address(0), to, updatedIndex);
1175                     if (!_checkContractOnERC721Received(address(0), to, updatedIndex++, _data)) {
1176                         revert TransferToNonERC721ReceiverImplementer();
1177                     }
1178                 } while (updatedIndex != end);
1179                 // Reentrancy protection
1180                 if (_currentIndex != startTokenId) revert();
1181             } else {
1182                 do {
1183                     emit Transfer(address(0), to, updatedIndex++);
1184                 } while (updatedIndex != end);
1185             }
1186             _currentIndex = updatedIndex;
1187         }
1188         _afterTokenTransfers(address(0), to, startTokenId, quantity);
1189     }
1190 
1191     /**
1192      * @dev Transfers `tokenId` from `from` to `to`.
1193      *
1194      * Requirements:
1195      *
1196      * - `to` cannot be the zero address.
1197      * - `tokenId` token must be owned by `from`.
1198      *
1199      * Emits a {Transfer} event.
1200      */
1201     function _transfer(
1202         address from,
1203         address to,
1204         uint256 tokenId
1205     ) private {
1206         TokenOwnership memory prevOwnership = ownershipOf(tokenId);
1207 
1208         bool isApprovedOrOwner = (_msgSender() == prevOwnership.addr ||
1209             isApprovedForAll(prevOwnership.addr, _msgSender()) ||
1210             getApproved(tokenId) == _msgSender());
1211 
1212         if (!isApprovedOrOwner) revert TransferCallerNotOwnerNorApproved();
1213         if (prevOwnership.addr != from) revert TransferFromIncorrectOwner();
1214         if (to == address(0)) revert TransferToZeroAddress();
1215 
1216         _beforeTokenTransfers(from, to, tokenId, 1);
1217 
1218         // Clear approvals from the previous owner
1219         _approve(address(0), tokenId, prevOwnership.addr);
1220 
1221         // Underflow of the sender's balance is impossible because we check for
1222         // ownership above and the recipient's balance can't realistically overflow.
1223         // Counter overflow is incredibly unrealistic as tokenId would have to be 2**256.
1224         unchecked {
1225             _addressData[from].balance -= 1;
1226             _addressData[to].balance += 1;
1227 
1228             _ownerships[tokenId].addr = to;
1229             _ownerships[tokenId].startTimestamp = uint64(block.timestamp);
1230 
1231             // If the ownership slot of tokenId+1 is not explicitly set, that means the transfer initiator owns it.
1232             // Set the slot of tokenId+1 explicitly in storage to maintain correctness for ownerOf(tokenId+1) calls.
1233             uint256 nextTokenId = tokenId + 1;
1234             if (_ownerships[nextTokenId].addr == address(0)) {
1235                 // This will suffice for checking _exists(nextTokenId),
1236                 // as a burned slot cannot contain the zero address.
1237                 if (nextTokenId < _currentIndex) {
1238                     _ownerships[nextTokenId].addr = prevOwnership.addr;
1239                     _ownerships[nextTokenId].startTimestamp = prevOwnership.startTimestamp;
1240                 }
1241             }
1242         }
1243 
1244         emit Transfer(from, to, tokenId);
1245         _afterTokenTransfers(from, to, tokenId, 1);
1246     }
1247 
1248     /**
1249      * @dev Destroys `tokenId`.
1250      * The approval is cleared when the token is burned.
1251      *
1252      * Requirements:
1253      *
1254      * - `tokenId` must exist.
1255      *
1256      * Emits a {Transfer} event.
1257      */
1258     function _burn(uint256 tokenId) internal virtual {
1259         TokenOwnership memory prevOwnership = ownershipOf(tokenId);
1260 
1261         _beforeTokenTransfers(prevOwnership.addr, address(0), tokenId, 1);
1262 
1263         // Clear approvals from the previous owner
1264         _approve(address(0), tokenId, prevOwnership.addr);
1265 
1266         // Underflow of the sender's balance is impossible because we check for
1267         // ownership above and the recipient's balance can't realistically overflow.
1268         // Counter overflow is incredibly unrealistic as tokenId would have to be 2**256.
1269         unchecked {
1270             _addressData[prevOwnership.addr].balance -= 1;
1271             _addressData[prevOwnership.addr].numberBurned += 1;
1272 
1273             // Keep track of who burned the token, and the timestamp of burning.
1274             _ownerships[tokenId].addr = prevOwnership.addr;
1275             _ownerships[tokenId].startTimestamp = uint64(block.timestamp);
1276             _ownerships[tokenId].burned = true;
1277 
1278             // If the ownership slot of tokenId+1 is not explicitly set, that means the burn initiator owns it.
1279             // Set the slot of tokenId+1 explicitly in storage to maintain correctness for ownerOf(tokenId+1) calls.
1280             uint256 nextTokenId = tokenId + 1;
1281             if (_ownerships[nextTokenId].addr == address(0)) {
1282                 // This will suffice for checking _exists(nextTokenId),
1283                 // as a burned slot cannot contain the zero address.
1284                 if (nextTokenId < _currentIndex) {
1285                     _ownerships[nextTokenId].addr = prevOwnership.addr;
1286                     _ownerships[nextTokenId].startTimestamp = prevOwnership.startTimestamp;
1287                 }
1288             }
1289         }
1290 
1291         emit Transfer(prevOwnership.addr, address(0), tokenId);
1292         _afterTokenTransfers(prevOwnership.addr, address(0), tokenId, 1);
1293 
1294         // Overflow not possible, as _burnCounter cannot be exceed _currentIndex times.
1295         unchecked {
1296             _burnCounter++;
1297         }
1298     }
1299 
1300     /**
1301      * @dev Approve `to` to operate on `tokenId`
1302      *
1303      * Emits a {Approval} event.
1304      */
1305     function _approve(
1306         address to,
1307         uint256 tokenId,
1308         address owner
1309     ) private {
1310         _tokenApprovals[tokenId] = to;
1311         emit Approval(owner, to, tokenId);
1312     }
1313 
1314     /**
1315      * @dev Internal function to invoke {IERC721Receiver-onERC721Received} on a target contract.
1316      *
1317      * @param from address representing the previous owner of the given token ID
1318      * @param to target address that will receive the tokens
1319      * @param tokenId uint256 ID of the token to be transferred
1320      * @param _data bytes optional data to send along with the call
1321      * @return bool whether the call correctly returned the expected magic value
1322      */
1323     function _checkContractOnERC721Received(
1324         address from,
1325         address to,
1326         uint256 tokenId,
1327         bytes memory _data
1328     ) private returns (bool) {
1329         try IERC721Receiver(to).onERC721Received(_msgSender(), from, tokenId, _data) returns (bytes4 retval) {
1330             return retval == IERC721Receiver(to).onERC721Received.selector;
1331         } catch (bytes memory reason) {
1332             if (reason.length == 0) {
1333                 revert TransferToNonERC721ReceiverImplementer();
1334             } else {
1335                 assembly {
1336                     revert(add(32, reason), mload(reason))
1337                 }
1338             }
1339         }
1340     }
1341 
1342     /**
1343      * @dev Hook that is called before a set of serially-ordered token ids are about to be transferred. This includes minting.
1344      * And also called before burning one token.
1345      *
1346      * startTokenId - the first token id to be transferred
1347      * quantity - the amount to be transferred
1348      *
1349      * Calling conditions:
1350      *
1351      * - When `from` and `to` are both non-zero, `from`'s `tokenId` will be
1352      * transferred to `to`.
1353      * - When `from` is zero, `tokenId` will be minted for `to`.
1354      * - When `to` is zero, `tokenId` will be burned by `from`.
1355      * - `from` and `to` are never both zero.
1356      */
1357     function _beforeTokenTransfers(
1358         address from,
1359         address to,
1360         uint256 startTokenId,
1361         uint256 quantity
1362     ) internal virtual {}
1363 
1364     /**
1365      * @dev Hook that is called after a set of serially-ordered token ids have been transferred. This includes
1366      * minting.
1367      * And also called after one token has been burned.
1368      *
1369      * startTokenId - the first token id to be transferred
1370      * quantity - the amount to be transferred
1371      *
1372      * Calling conditions:
1373      *
1374      * - When `from` and `to` are both non-zero, `from`'s `tokenId` has been
1375      * transferred to `to`.
1376      * - When `from` is zero, `tokenId` has been minted for `to`.
1377      * - When `to` is zero, `tokenId` has been burned by `from`.
1378      * - `from` and `to` are never both zero.
1379      */
1380     function _afterTokenTransfers(
1381         address from,
1382         address to,
1383         uint256 startTokenId,
1384         uint256 quantity
1385     ) internal virtual {}
1386 }
1387 
1388 
1389 pragma solidity >=0.8.9 <0.9.0;
1390 
1391 contract NFTerrarium is ERC721A, Ownable, ReentrancyGuard {
1392   using Strings for uint256;
1393 
1394     //---------------[ Whitelist ]---------------\\
1395     bytes32 public merkleRoot;
1396     mapping(address => bool) public whitelistClaimed;
1397 
1398     //---------------[ Token URI ]---------------\\
1399     string public baseURI = '';
1400     string public uriSuffix = '.json';
1401 
1402     //---------------[ Cost & Supply ]---------------\\
1403     uint256 public maxSupply = 777;
1404     uint256 public maxAmountPerWallet;
1405     mapping(address => uint8) public amountClaimed;
1406 
1407     //---------------[ Setting Toggles ]---------------\\
1408     bool public paused = true;
1409     bool public whitelistMintEnabled = false;
1410     bool public revealed = false;
1411 
1412     //---------------[  ]---------------\\
1413     constructor(
1414         string memory _tokenName,
1415         string memory _tokenSymbol,
1416         uint256 _maxAmountPerWallet,
1417         string memory _initBaseURI
1418     ) ERC721A(_tokenName, _tokenSymbol) {
1419         maxAmountPerWallet = _maxAmountPerWallet;
1420         baseURI = _initBaseURI;
1421     }
1422 
1423     //---------------[ Modifiers ]---------------\\
1424     modifier mintCompliance(uint256 _mintAmount) {
1425         require(_mintAmount > 0 && _mintAmount <= maxAmountPerWallet, 'Invalid mint amount submitted');
1426         require(totalSupply() + _mintAmount <= maxSupply, 'Maximum NFT supply exceeded');
1427         require(amountClaimed[_msgSender()] + _mintAmount <= maxAmountPerWallet, 'Maximum wallet amount exceeded');
1428         _;
1429     }
1430 
1431     //---------------[ Mint Functions ]---------------\\
1432     function whitelistMint(uint256 _mintAmount, bytes32[] calldata _merkleProof) public payable mintCompliance(_mintAmount) nonReentrant {
1433 
1434         // Verify whitelist requirements
1435         require(whitelistMintEnabled, 'Whitelist sale is not active');
1436         require(!whitelistClaimed[_msgSender()], 'Address already claimed whitelist');
1437 
1438         // cheking merkle proof
1439         bytes32 leaf = keccak256(abi.encodePacked(_msgSender()));
1440         require(MerkleProof.verify(_merkleProof, merkleRoot, leaf), 'Invalid whitelist proof submitted');
1441 
1442         // minting
1443         whitelistClaimed[_msgSender()] = true;
1444         amountClaimed[_msgSender()] += uint8(_mintAmount);
1445         _safeMint(_msgSender(), _mintAmount);
1446     }
1447 
1448     function mint(uint256 _mintAmount) public payable mintCompliance(_mintAmount) nonReentrant {
1449         require(!paused, 'Minting is currently paused');
1450         amountClaimed[_msgSender()] += uint8(_mintAmount);
1451         _safeMint(_msgSender(), _mintAmount);
1452     }
1453 
1454     function airdrop(uint256 _mintAmount, address _receiver) public mintCompliance(_mintAmount) onlyOwner nonReentrant {
1455         _safeMint(_receiver, _mintAmount);
1456     }
1457 
1458     //---------------[ Public Functions ]---------------\\
1459     function walletOfOwner(address _owner) public view returns (uint256[] memory) {
1460         uint256 ownerTokenCount = balanceOf(_owner);
1461         uint256[] memory ownedTokenIds = new uint256[](ownerTokenCount);
1462         uint256 currentTokenId = _startTokenId();
1463         uint256 ownedTokenIndex = 0;
1464         address latestOwnerAddress;
1465 
1466         while (ownedTokenIndex < ownerTokenCount && currentTokenId <= maxSupply) {
1467             TokenOwnership memory ownership = _ownerships[currentTokenId];
1468 
1469             if (!ownership.burned && ownership.addr != address(0)) {
1470                 latestOwnerAddress = ownership.addr;
1471             }
1472 
1473             if (latestOwnerAddress == _owner) {
1474                 ownedTokenIds[ownedTokenIndex] = currentTokenId;
1475                 ownedTokenIndex++;
1476             }
1477 
1478             currentTokenId++;
1479         }
1480 
1481         return ownedTokenIds;
1482     }
1483 
1484     function tokenURI(uint256 _tokenId) public view virtual override returns (string memory) {
1485         require(_exists(_tokenId), 'ERC721Metadata: URI query for nonexistent token');
1486 
1487         string memory currentBaseURI = _baseURI();
1488         return bytes(currentBaseURI).length > 0
1489             ? string(abi.encodePacked(currentBaseURI, _tokenId.toString(), uriSuffix))
1490             : '';
1491     }
1492 
1493     //---------------[ Internal Functions ]---------------\\
1494     function _startTokenId() internal view virtual override returns (uint256) {
1495         return 1;
1496     }
1497 
1498     function _baseURI() internal view virtual override returns (string memory) {
1499         return baseURI;
1500     }
1501 
1502     //---------------[ onlyOwner Functions ]---------------\\
1503     function setmaxAmountPerWallet(uint256 _maxAmountPerWallet) public onlyOwner {
1504         maxAmountPerWallet = _maxAmountPerWallet;
1505     }
1506 
1507     function setBaseURI(string memory _newURI) public onlyOwner {
1508         baseURI = _newURI;
1509     }
1510 
1511     function setUriSuffix(string memory _uriSuffix) public onlyOwner {
1512         uriSuffix = _uriSuffix;
1513     }
1514 
1515     function flipPaused() public onlyOwner {
1516         paused = !paused;
1517     }
1518 
1519     function flipReveal() public onlyOwner {
1520         revealed = !revealed;
1521     }
1522 
1523     function flipWhitelistMint() public onlyOwner {
1524         whitelistMintEnabled = !whitelistMintEnabled;
1525     }
1526 
1527     function setMerkleRoot(bytes32 _merkleRoot) public onlyOwner {
1528         merkleRoot = _merkleRoot;
1529     }
1530 
1531     function withdraw() public onlyOwner nonReentrant {
1532         (bool success, ) = payable(msg.sender).call{value: address(this).balance}("");
1533         require(success);
1534     }
1535 
1536 }