1 // File: @openzeppelin/contracts/utils/cryptography/MerkleProof.sol
2 
3 
4 // OpenZeppelin Contracts v4.4.1 (utils/cryptography/MerkleProof.sol)
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
46                 computedHash = keccak256(abi.encodePacked(computedHash, proofElement));
47             } else {
48                 // Hash(current element of the proof + current computed hash)
49                 computedHash = keccak256(abi.encodePacked(proofElement, computedHash));
50             }
51         }
52         return computedHash;
53     }
54 }
55 
56 // File: @openzeppelin/contracts/utils/Counters.sol
57 
58 
59 
60 pragma solidity ^0.8.0;
61 
62 /**
63  * @title Counters
64  * @author Matt Condon (@shrugs)
65  * @dev Provides counters that can only be incremented, decremented or reset. This can be used e.g. to track the number
66  * of elements in a mapping, issuing ERC721 ids, or counting request ids.
67  *
68  * Include with `using Counters for Counters.Counter;`
69  */
70 library Counters {
71     struct Counter {
72         // This variable should never be directly accessed by users of the library: interactions must be restricted to
73         // the library's function. As of Solidity v0.5.2, this cannot be enforced, though there is a proposal to add
74         // this feature: see https://github.com/ethereum/solidity/issues/4637
75         uint256 _value; // default: 0
76     }
77 
78     function current(Counter storage counter) internal view returns (uint256) {
79         return counter._value;
80     }
81 
82     function increment(Counter storage counter) internal {
83         unchecked {
84             counter._value += 1;
85         }
86     }
87 
88     function decrement(Counter storage counter) internal {
89         uint256 value = counter._value;
90         require(value > 0, "Counter: decrement overflow");
91         unchecked {
92             counter._value = value - 1;
93         }
94     }
95 
96     function reset(Counter storage counter) internal {
97         counter._value = 0;
98     }
99 }
100 
101 // File: @openzeppelin/contracts/security/ReentrancyGuard.sol
102 
103 
104 // OpenZeppelin Contracts v4.4.1 (security/ReentrancyGuard.sol)
105 
106 pragma solidity ^0.8.0;
107 
108 /**
109  * @dev Contract module that helps prevent reentrant calls to a function.
110  *
111  * Inheriting from `ReentrancyGuard` will make the {nonReentrant} modifier
112  * available, which can be applied to functions to make sure there are no nested
113  * (reentrant) calls to them.
114  *
115  * Note that because there is a single `nonReentrant` guard, functions marked as
116  * `nonReentrant` may not call one another. This can be worked around by making
117  * those functions `private`, and then adding `external` `nonReentrant` entry
118  * points to them.
119  *
120  * TIP: If you would like to learn more about reentrancy and alternative ways
121  * to protect against it, check out our blog post
122  * https://blog.openzeppelin.com/reentrancy-after-istanbul/[Reentrancy After Istanbul].
123  */
124 abstract contract ReentrancyGuard {
125     // Booleans are more expensive than uint256 or any type that takes up a full
126     // word because each write operation emits an extra SLOAD to first read the
127     // slot's contents, replace the bits taken up by the boolean, and then write
128     // back. This is the compiler's defense against contract upgrades and
129     // pointer aliasing, and it cannot be disabled.
130 
131     // The values being non-zero value makes deployment a bit more expensive,
132     // but in exchange the refund on every call to nonReentrant will be lower in
133     // amount. Since refunds are capped to a percentage of the total
134     // transaction's gas, it is best to keep them low in cases like this one, to
135     // increase the likelihood of the full refund coming into effect.
136     uint256 private constant _NOT_ENTERED = 1;
137     uint256 private constant _ENTERED = 2;
138 
139     uint256 private _status;
140 
141     constructor() {
142         _status = _NOT_ENTERED;
143     }
144 
145     /**
146      * @dev Prevents a contract from calling itself, directly or indirectly.
147      * Calling a `nonReentrant` function from another `nonReentrant`
148      * function is not supported. It is possible to prevent this from happening
149      * by making the `nonReentrant` function external, and making it call a
150      * `private` function that does the actual work.
151      */
152     modifier nonReentrant() {
153         // On the first call to nonReentrant, _notEntered will be true
154         require(_status != _ENTERED, "ReentrancyGuard: reentrant call");
155 
156         // Any calls to nonReentrant after this point will fail
157         _status = _ENTERED;
158 
159         _;
160 
161         // By storing the original value once again, a refund is triggered (see
162         // https://eips.ethereum.org/EIPS/eip-2200)
163         _status = _NOT_ENTERED;
164     }
165 }
166 
167 // File: @openzeppelin/contracts/utils/Strings.sol
168 
169 
170 
171 pragma solidity ^0.8.0;
172 
173 /**
174  * @dev String operations.
175  */
176 library Strings {
177     bytes16 private constant _HEX_SYMBOLS = "0123456789abcdef";
178 
179     /**
180      * @dev Converts a `uint256` to its ASCII `string` decimal representation.
181      */
182     function toString(uint256 value) internal pure returns (string memory) {
183         // Inspired by OraclizeAPI's implementation - MIT licence
184         // https://github.com/oraclize/ethereum-api/blob/b42146b063c7d6ee1358846c198246239e9360e8/oraclizeAPI_0.4.25.sol
185 
186         if (value == 0) {
187             return "0";
188         }
189         uint256 temp = value;
190         uint256 digits;
191         while (temp != 0) {
192             digits++;
193             temp /= 10;
194         }
195         bytes memory buffer = new bytes(digits);
196         while (value != 0) {
197             digits -= 1;
198             buffer[digits] = bytes1(uint8(48 + uint256(value % 10)));
199             value /= 10;
200         }
201         return string(buffer);
202     }
203 
204     /**
205      * @dev Converts a `uint256` to its ASCII `string` hexadecimal representation.
206      */
207     function toHexString(uint256 value) internal pure returns (string memory) {
208         if (value == 0) {
209             return "0x00";
210         }
211         uint256 temp = value;
212         uint256 length = 0;
213         while (temp != 0) {
214             length++;
215             temp >>= 8;
216         }
217         return toHexString(value, length);
218     }
219 
220     /**
221      * @dev Converts a `uint256` to its ASCII `string` hexadecimal representation with fixed length.
222      */
223     function toHexString(uint256 value, uint256 length) internal pure returns (string memory) {
224         bytes memory buffer = new bytes(2 * length + 2);
225         buffer[0] = "0";
226         buffer[1] = "x";
227         for (uint256 i = 2 * length + 1; i > 1; --i) {
228             buffer[i] = _HEX_SYMBOLS[value & 0xf];
229             value >>= 4;
230         }
231         require(value == 0, "Strings: hex length insufficient");
232         return string(buffer);
233     }
234 }
235 
236 // File: @openzeppelin/contracts/utils/Context.sol
237 
238 
239 
240 pragma solidity ^0.8.0;
241 
242 /**
243  * @dev Provides information about the current execution context, including the
244  * sender of the transaction and its data. While these are generally available
245  * via msg.sender and msg.data, they should not be accessed in such a direct
246  * manner, since when dealing with meta-transactions the account sending and
247  * paying for execution may not be the actual sender (as far as an application
248  * is concerned).
249  *
250  * This contract is only required for intermediate, library-like contracts.
251  */
252 abstract contract Context {
253     function _msgSender() internal view virtual returns (address) {
254         return msg.sender;
255     }
256 
257     function _msgData() internal view virtual returns (bytes calldata) {
258         return msg.data;
259     }
260 }
261 
262 // File: @openzeppelin/contracts/access/Ownable.sol
263 
264 
265 
266 pragma solidity ^0.8.0;
267 
268 
269 /**
270  * @dev Contract module which provides a basic access control mechanism, where
271  * there is an account (an owner) that can be granted exclusive access to
272  * specific functions.
273  *
274  * By default, the owner account will be the one that deploys the contract. This
275  * can later be changed with {transferOwnership}.
276  *
277  * This module is used through inheritance. It will make available the modifier
278  * `onlyOwner`, which can be applied to your functions to restrict their use to
279  * the owner.
280  */
281 abstract contract Ownable is Context {
282     address private _owner;
283 
284     event OwnershipTransferred(address indexed previousOwner, address indexed newOwner);
285 
286     /**
287      * @dev Initializes the contract setting the deployer as the initial owner.
288      */
289     constructor() {
290         _setOwner(_msgSender());
291     }
292 
293     /**
294      * @dev Returns the address of the current owner.
295      */
296     function owner() public view virtual returns (address) {
297         return _owner;
298     }
299 
300     /**
301      * @dev Throws if called by any account other than the owner.
302      */
303     modifier onlyOwner() {
304         require(owner() == _msgSender(), "Ownable: caller is not the owner");
305         _;
306     }
307 
308     /**
309      * @dev Leaves the contract without owner. It will not be possible to call
310      * `onlyOwner` functions anymore. Can only be called by the current owner.
311      *
312      * NOTE: Renouncing ownership will leave the contract without an owner,
313      * thereby removing any functionality that is only available to the owner.
314      */
315     function renounceOwnership() public virtual onlyOwner {
316         _setOwner(address(0));
317     }
318 
319     /**
320      * @dev Transfers ownership of the contract to a new account (`newOwner`).
321      * Can only be called by the current owner.
322      */
323     function transferOwnership(address newOwner) public virtual onlyOwner {
324         require(newOwner != address(0), "Ownable: new owner is the zero address");
325         _setOwner(newOwner);
326     }
327 
328     function _setOwner(address newOwner) private {
329         address oldOwner = _owner;
330         _owner = newOwner;
331         emit OwnershipTransferred(oldOwner, newOwner);
332     }
333 }
334 
335 // File: @openzeppelin/contracts/utils/Address.sol
336 
337 
338 
339 pragma solidity ^0.8.0;
340 
341 /**
342  * @dev Collection of functions related to the address type
343  */
344 library Address {
345     /**
346      * @dev Returns true if `account` is a contract.
347      *
348      * [IMPORTANT]
349      * ====
350      * It is unsafe to assume that an address for which this function returns
351      * false is an externally-owned account (EOA) and not a contract.
352      *
353      * Among others, `isContract` will return false for the following
354      * types of addresses:
355      *
356      *  - an externally-owned account
357      *  - a contract in construction
358      *  - an address where a contract will be created
359      *  - an address where a contract lived, but was destroyed
360      * ====
361      */
362     function isContract(address account) internal view returns (bool) {
363         // This method relies on extcodesize, which returns 0 for contracts in
364         // construction, since the code is only stored at the end of the
365         // constructor execution.
366 
367         uint256 size;
368         assembly {
369             size := extcodesize(account)
370         }
371         return size > 0;
372     }
373 
374     /**
375      * @dev Replacement for Solidity's `transfer`: sends `amount` wei to
376      * `recipient`, forwarding all available gas and reverting on errors.
377      *
378      * https://eips.ethereum.org/EIPS/eip-1884[EIP1884] increases the gas cost
379      * of certain opcodes, possibly making contracts go over the 2300 gas limit
380      * imposed by `transfer`, making them unable to receive funds via
381      * `transfer`. {sendValue} removes this limitation.
382      *
383      * https://diligence.consensys.net/posts/2019/09/stop-using-soliditys-transfer-now/[Learn more].
384      *
385      * IMPORTANT: because control is transferred to `recipient`, care must be
386      * taken to not create reentrancy vulnerabilities. Consider using
387      * {ReentrancyGuard} or the
388      * https://solidity.readthedocs.io/en/v0.5.11/security-considerations.html#use-the-checks-effects-interactions-pattern[checks-effects-interactions pattern].
389      */
390     function sendValue(address payable recipient, uint256 amount) internal {
391         require(address(this).balance >= amount, "Address: insufficient balance");
392 
393         (bool success, ) = recipient.call{value: amount}("");
394         require(success, "Address: unable to send value, recipient may have reverted");
395     }
396 
397     /**
398      * @dev Performs a Solidity function call using a low level `call`. A
399      * plain `call` is an unsafe replacement for a function call: use this
400      * function instead.
401      *
402      * If `target` reverts with a revert reason, it is bubbled up by this
403      * function (like regular Solidity function calls).
404      *
405      * Returns the raw returned data. To convert to the expected return value,
406      * use https://solidity.readthedocs.io/en/latest/units-and-global-variables.html?highlight=abi.decode#abi-encoding-and-decoding-functions[`abi.decode`].
407      *
408      * Requirements:
409      *
410      * - `target` must be a contract.
411      * - calling `target` with `data` must not revert.
412      *
413      * _Available since v3.1._
414      */
415     function functionCall(address target, bytes memory data) internal returns (bytes memory) {
416         return functionCall(target, data, "Address: low-level call failed");
417     }
418 
419     /**
420      * @dev Same as {xref-Address-functionCall-address-bytes-}[`functionCall`], but with
421      * `errorMessage` as a fallback revert reason when `target` reverts.
422      *
423      * _Available since v3.1._
424      */
425     function functionCall(
426         address target,
427         bytes memory data,
428         string memory errorMessage
429     ) internal returns (bytes memory) {
430         return functionCallWithValue(target, data, 0, errorMessage);
431     }
432 
433     /**
434      * @dev Same as {xref-Address-functionCall-address-bytes-}[`functionCall`],
435      * but also transferring `value` wei to `target`.
436      *
437      * Requirements:
438      *
439      * - the calling contract must have an ETH balance of at least `value`.
440      * - the called Solidity function must be `payable`.
441      *
442      * _Available since v3.1._
443      */
444     function functionCallWithValue(
445         address target,
446         bytes memory data,
447         uint256 value
448     ) internal returns (bytes memory) {
449         return functionCallWithValue(target, data, value, "Address: low-level call with value failed");
450     }
451 
452     /**
453      * @dev Same as {xref-Address-functionCallWithValue-address-bytes-uint256-}[`functionCallWithValue`], but
454      * with `errorMessage` as a fallback revert reason when `target` reverts.
455      *
456      * _Available since v3.1._
457      */
458     function functionCallWithValue(
459         address target,
460         bytes memory data,
461         uint256 value,
462         string memory errorMessage
463     ) internal returns (bytes memory) {
464         require(address(this).balance >= value, "Address: insufficient balance for call");
465         require(isContract(target), "Address: call to non-contract");
466 
467         (bool success, bytes memory returndata) = target.call{value: value}(data);
468         return verifyCallResult(success, returndata, errorMessage);
469     }
470 
471     /**
472      * @dev Same as {xref-Address-functionCall-address-bytes-}[`functionCall`],
473      * but performing a static call.
474      *
475      * _Available since v3.3._
476      */
477     function functionStaticCall(address target, bytes memory data) internal view returns (bytes memory) {
478         return functionStaticCall(target, data, "Address: low-level static call failed");
479     }
480 
481     /**
482      * @dev Same as {xref-Address-functionCall-address-bytes-string-}[`functionCall`],
483      * but performing a static call.
484      *
485      * _Available since v3.3._
486      */
487     function functionStaticCall(
488         address target,
489         bytes memory data,
490         string memory errorMessage
491     ) internal view returns (bytes memory) {
492         require(isContract(target), "Address: static call to non-contract");
493 
494         (bool success, bytes memory returndata) = target.staticcall(data);
495         return verifyCallResult(success, returndata, errorMessage);
496     }
497 
498     /**
499      * @dev Same as {xref-Address-functionCall-address-bytes-}[`functionCall`],
500      * but performing a delegate call.
501      *
502      * _Available since v3.4._
503      */
504     function functionDelegateCall(address target, bytes memory data) internal returns (bytes memory) {
505         return functionDelegateCall(target, data, "Address: low-level delegate call failed");
506     }
507 
508     /**
509      * @dev Same as {xref-Address-functionCall-address-bytes-string-}[`functionCall`],
510      * but performing a delegate call.
511      *
512      * _Available since v3.4._
513      */
514     function functionDelegateCall(
515         address target,
516         bytes memory data,
517         string memory errorMessage
518     ) internal returns (bytes memory) {
519         require(isContract(target), "Address: delegate call to non-contract");
520 
521         (bool success, bytes memory returndata) = target.delegatecall(data);
522         return verifyCallResult(success, returndata, errorMessage);
523     }
524 
525     /**
526      * @dev Tool to verifies that a low level call was successful, and revert if it wasn't, either by bubbling the
527      * revert reason using the provided one.
528      *
529      * _Available since v4.3._
530      */
531     function verifyCallResult(
532         bool success,
533         bytes memory returndata,
534         string memory errorMessage
535     ) internal pure returns (bytes memory) {
536         if (success) {
537             return returndata;
538         } else {
539             // Look for revert reason and bubble it up if present
540             if (returndata.length > 0) {
541                 // The easiest way to bubble the revert reason is using memory via assembly
542 
543                 assembly {
544                     let returndata_size := mload(returndata)
545                     revert(add(32, returndata), returndata_size)
546                 }
547             } else {
548                 revert(errorMessage);
549             }
550         }
551     }
552 }
553 
554 // File: @openzeppelin/contracts/token/ERC721/IERC721Receiver.sol
555 
556 
557 
558 pragma solidity ^0.8.0;
559 
560 /**
561  * @title ERC721 token receiver interface
562  * @dev Interface for any contract that wants to support safeTransfers
563  * from ERC721 asset contracts.
564  */
565 interface IERC721Receiver {
566     /**
567      * @dev Whenever an {IERC721} `tokenId` token is transferred to this contract via {IERC721-safeTransferFrom}
568      * by `operator` from `from`, this function is called.
569      *
570      * It must return its Solidity selector to confirm the token transfer.
571      * If any other value is returned or the interface is not implemented by the recipient, the transfer will be reverted.
572      *
573      * The selector can be obtained in Solidity with `IERC721.onERC721Received.selector`.
574      */
575     function onERC721Received(
576         address operator,
577         address from,
578         uint256 tokenId,
579         bytes calldata data
580     ) external returns (bytes4);
581 }
582 
583 // File: @openzeppelin/contracts/utils/introspection/IERC165.sol
584 
585 
586 
587 pragma solidity ^0.8.0;
588 
589 /**
590  * @dev Interface of the ERC165 standard, as defined in the
591  * https://eips.ethereum.org/EIPS/eip-165[EIP].
592  *
593  * Implementers can declare support of contract interfaces, which can then be
594  * queried by others ({ERC165Checker}).
595  *
596  * For an implementation, see {ERC165}.
597  */
598 interface IERC165 {
599     /**
600      * @dev Returns true if this contract implements the interface defined by
601      * `interfaceId`. See the corresponding
602      * https://eips.ethereum.org/EIPS/eip-165#how-interfaces-are-identified[EIP section]
603      * to learn more about how these ids are created.
604      *
605      * This function call must use less than 30 000 gas.
606      */
607     function supportsInterface(bytes4 interfaceId) external view returns (bool);
608 }
609 
610 // File: @openzeppelin/contracts/utils/introspection/ERC165.sol
611 
612 
613 
614 pragma solidity ^0.8.0;
615 
616 
617 /**
618  * @dev Implementation of the {IERC165} interface.
619  *
620  * Contracts that want to implement ERC165 should inherit from this contract and override {supportsInterface} to check
621  * for the additional interface id that will be supported. For example:
622  *
623  * ```solidity
624  * function supportsInterface(bytes4 interfaceId) public view virtual override returns (bool) {
625  *     return interfaceId == type(MyInterface).interfaceId || super.supportsInterface(interfaceId);
626  * }
627  * ```
628  *
629  * Alternatively, {ERC165Storage} provides an easier to use but more expensive implementation.
630  */
631 abstract contract ERC165 is IERC165 {
632     /**
633      * @dev See {IERC165-supportsInterface}.
634      */
635     function supportsInterface(bytes4 interfaceId) public view virtual override returns (bool) {
636         return interfaceId == type(IERC165).interfaceId;
637     }
638 }
639 
640 // File: @openzeppelin/contracts/token/ERC721/IERC721.sol
641 
642 
643 
644 pragma solidity ^0.8.0;
645 
646 
647 /**
648  * @dev Required interface of an ERC721 compliant contract.
649  */
650 interface IERC721 is IERC165 {
651     /**
652      * @dev Emitted when `tokenId` token is transferred from `from` to `to`.
653      */
654     event Transfer(address indexed from, address indexed to, uint256 indexed tokenId);
655 
656     /**
657      * @dev Emitted when `owner` enables `approved` to manage the `tokenId` token.
658      */
659     event Approval(address indexed owner, address indexed approved, uint256 indexed tokenId);
660 
661     /**
662      * @dev Emitted when `owner` enables or disables (`approved`) `operator` to manage all of its assets.
663      */
664     event ApprovalForAll(address indexed owner, address indexed operator, bool approved);
665 
666     /**
667      * @dev Returns the number of tokens in ``owner``'s account.
668      */
669     function balanceOf(address owner) external view returns (uint256 balance);
670 
671     /**
672      * @dev Returns the owner of the `tokenId` token.
673      *
674      * Requirements:
675      *
676      * - `tokenId` must exist.
677      */
678     function ownerOf(uint256 tokenId) external view returns (address owner);
679 
680     /**
681      * @dev Safely transfers `tokenId` token from `from` to `to`, checking first that contract recipients
682      * are aware of the ERC721 protocol to prevent tokens from being forever locked.
683      *
684      * Requirements:
685      *
686      * - `from` cannot be the zero address.
687      * - `to` cannot be the zero address.
688      * - `tokenId` token must exist and be owned by `from`.
689      * - If the caller is not `from`, it must be have been allowed to move this token by either {approve} or {setApprovalForAll}.
690      * - If `to` refers to a smart contract, it must implement {IERC721Receiver-onERC721Received}, which is called upon a safe transfer.
691      *
692      * Emits a {Transfer} event.
693      */
694     function safeTransferFrom(
695         address from,
696         address to,
697         uint256 tokenId
698     ) external;
699 
700     /**
701      * @dev Transfers `tokenId` token from `from` to `to`.
702      *
703      * WARNING: Usage of this method is discouraged, use {safeTransferFrom} whenever possible.
704      *
705      * Requirements:
706      *
707      * - `from` cannot be the zero address.
708      * - `to` cannot be the zero address.
709      * - `tokenId` token must be owned by `from`.
710      * - If the caller is not `from`, it must be approved to move this token by either {approve} or {setApprovalForAll}.
711      *
712      * Emits a {Transfer} event.
713      */
714     function transferFrom(
715         address from,
716         address to,
717         uint256 tokenId
718     ) external;
719 
720     /**
721      * @dev Gives permission to `to` to transfer `tokenId` token to another account.
722      * The approval is cleared when the token is transferred.
723      *
724      * Only a single account can be approved at a time, so approving the zero address clears previous approvals.
725      *
726      * Requirements:
727      *
728      * - The caller must own the token or be an approved operator.
729      * - `tokenId` must exist.
730      *
731      * Emits an {Approval} event.
732      */
733     function approve(address to, uint256 tokenId) external;
734 
735     /**
736      * @dev Returns the account approved for `tokenId` token.
737      *
738      * Requirements:
739      *
740      * - `tokenId` must exist.
741      */
742     function getApproved(uint256 tokenId) external view returns (address operator);
743 
744     /**
745      * @dev Approve or remove `operator` as an operator for the caller.
746      * Operators can call {transferFrom} or {safeTransferFrom} for any token owned by the caller.
747      *
748      * Requirements:
749      *
750      * - The `operator` cannot be the caller.
751      *
752      * Emits an {ApprovalForAll} event.
753      */
754     function setApprovalForAll(address operator, bool _approved) external;
755 
756     /**
757      * @dev Returns if the `operator` is allowed to manage all of the assets of `owner`.
758      *
759      * See {setApprovalForAll}
760      */
761     function isApprovedForAll(address owner, address operator) external view returns (bool);
762 
763     /**
764      * @dev Safely transfers `tokenId` token from `from` to `to`.
765      *
766      * Requirements:
767      *
768      * - `from` cannot be the zero address.
769      * - `to` cannot be the zero address.
770      * - `tokenId` token must exist and be owned by `from`.
771      * - If the caller is not `from`, it must be approved to move this token by either {approve} or {setApprovalForAll}.
772      * - If `to` refers to a smart contract, it must implement {IERC721Receiver-onERC721Received}, which is called upon a safe transfer.
773      *
774      * Emits a {Transfer} event.
775      */
776     function safeTransferFrom(
777         address from,
778         address to,
779         uint256 tokenId,
780         bytes calldata data
781     ) external;
782 }
783 
784 // File: @openzeppelin/contracts/token/ERC721/extensions/IERC721Enumerable.sol
785 
786 
787 
788 pragma solidity ^0.8.0;
789 
790 
791 /**
792  * @title ERC-721 Non-Fungible Token Standard, optional enumeration extension
793  * @dev See https://eips.ethereum.org/EIPS/eip-721
794  */
795 interface IERC721Enumerable is IERC721 {
796     /**
797      * @dev Returns the total amount of tokens stored by the contract.
798      */
799     function totalSupply() external view returns (uint256);
800 
801     /**
802      * @dev Returns a token ID owned by `owner` at a given `index` of its token list.
803      * Use along with {balanceOf} to enumerate all of ``owner``'s tokens.
804      */
805     function tokenOfOwnerByIndex(address owner, uint256 index) external view returns (uint256 tokenId);
806 
807     /**
808      * @dev Returns a token ID at a given `index` of all the tokens stored by the contract.
809      * Use along with {totalSupply} to enumerate all tokens.
810      */
811     function tokenByIndex(uint256 index) external view returns (uint256);
812 }
813 
814 // File: @openzeppelin/contracts/token/ERC721/extensions/IERC721Metadata.sol
815 
816 
817 
818 pragma solidity ^0.8.0;
819 
820 
821 /**
822  * @title ERC-721 Non-Fungible Token Standard, optional metadata extension
823  * @dev See https://eips.ethereum.org/EIPS/eip-721
824  */
825 interface IERC721Metadata is IERC721 {
826     /**
827      * @dev Returns the token collection name.
828      */
829     function name() external view returns (string memory);
830 
831     /**
832      * @dev Returns the token collection symbol.
833      */
834     function symbol() external view returns (string memory);
835 
836     /**
837      * @dev Returns the Uniform Resource Identifier (URI) for `tokenId` token.
838      */
839     function tokenURI(uint256 tokenId) external view returns (string memory);
840 }
841 
842 // File: @openzeppelin/contracts/token/ERC721/ERC721.sol
843 
844 
845 
846 pragma solidity ^0.8.0;
847 
848 
849 
850 
851 
852 
853 
854 
855 /**
856  * @dev Implementation of https://eips.ethereum.org/EIPS/eip-721[ERC721] Non-Fungible Token Standard, including
857  * the Metadata extension, but not including the Enumerable extension, which is available separately as
858  * {ERC721Enumerable}.
859  */
860 contract ERC721 is Context, ERC165, IERC721, IERC721Metadata {
861     using Address for address;
862     using Strings for uint256;
863 
864     // Token name
865     string private _name;
866 
867     // Token symbol
868     string private _symbol;
869 
870     // Mapping from token ID to owner address
871     mapping(uint256 => address) private _owners;
872 
873     // Mapping owner address to token count
874     mapping(address => uint256) private _balances;
875 
876     // Mapping from token ID to approved address
877     mapping(uint256 => address) private _tokenApprovals;
878 
879     // Mapping from owner to operator approvals
880     mapping(address => mapping(address => bool)) private _operatorApprovals;
881 
882     /**
883      * @dev Initializes the contract by setting a `name` and a `symbol` to the token collection.
884      */
885     constructor(string memory name_, string memory symbol_) {
886         _name = name_;
887         _symbol = symbol_;
888     }
889 
890     /**
891      * @dev See {IERC165-supportsInterface}.
892      */
893     function supportsInterface(bytes4 interfaceId) public view virtual override(ERC165, IERC165) returns (bool) {
894         return
895             interfaceId == type(IERC721).interfaceId ||
896             interfaceId == type(IERC721Metadata).interfaceId ||
897             super.supportsInterface(interfaceId);
898     }
899 
900     /**
901      * @dev See {IERC721-balanceOf}.
902      */
903     function balanceOf(address owner) public view virtual override returns (uint256) {
904         require(owner != address(0), "ERC721: balance query for the zero address");
905         return _balances[owner];
906     }
907 
908     /**
909      * @dev See {IERC721-ownerOf}.
910      */
911     function ownerOf(uint256 tokenId) public view virtual override returns (address) {
912         address owner = _owners[tokenId];
913         require(owner != address(0), "ERC721: owner query for nonexistent token");
914         return owner;
915     }
916 
917     /**
918      * @dev See {IERC721Metadata-name}.
919      */
920     function name() public view virtual override returns (string memory) {
921         return _name;
922     }
923 
924     /**
925      * @dev See {IERC721Metadata-symbol}.
926      */
927     function symbol() public view virtual override returns (string memory) {
928         return _symbol;
929     }
930 
931     /**
932      * @dev See {IERC721Metadata-tokenURI}.
933      */
934     function tokenURI(uint256 tokenId) public view virtual override returns (string memory) {
935         require(_exists(tokenId), "ERC721Metadata: URI query for nonexistent token");
936 
937         string memory baseURI = _baseURI();
938         return bytes(baseURI).length > 0 ? string(abi.encodePacked(baseURI, tokenId.toString())) : "";
939     }
940 
941     /**
942      * @dev Base URI for computing {tokenURI}. If set, the resulting URI for each
943      * token will be the concatenation of the `baseURI` and the `tokenId`. Empty
944      * by default, can be overriden in child contracts.
945      */
946     function _baseURI() internal view virtual returns (string memory) {
947         return "";
948     }
949 
950     /**
951      * @dev See {IERC721-approve}.
952      */
953     function approve(address to, uint256 tokenId) public virtual override {
954         address owner = ERC721.ownerOf(tokenId);
955         require(to != owner, "ERC721: approval to current owner");
956 
957         require(
958             _msgSender() == owner || isApprovedForAll(owner, _msgSender()),
959             "ERC721: approve caller is not owner nor approved for all"
960         );
961 
962         _approve(to, tokenId);
963     }
964 
965     /**
966      * @dev See {IERC721-getApproved}.
967      */
968     function getApproved(uint256 tokenId) public view virtual override returns (address) {
969         require(_exists(tokenId), "ERC721: approved query for nonexistent token");
970 
971         return _tokenApprovals[tokenId];
972     }
973 
974     /**
975      * @dev See {IERC721-setApprovalForAll}.
976      */
977     function setApprovalForAll(address operator, bool approved) public virtual override {
978         require(operator != _msgSender(), "ERC721: approve to caller");
979 
980         _operatorApprovals[_msgSender()][operator] = approved;
981         emit ApprovalForAll(_msgSender(), operator, approved);
982     }
983 
984     /**
985      * @dev See {IERC721-isApprovedForAll}.
986      */
987     function isApprovedForAll(address owner, address operator) public view virtual override returns (bool) {
988         return _operatorApprovals[owner][operator];
989     }
990 
991     /**
992      * @dev See {IERC721-transferFrom}.
993      */
994     function transferFrom(
995         address from,
996         address to,
997         uint256 tokenId
998     ) public virtual override {
999         //solhint-disable-next-line max-line-length
1000         require(_isApprovedOrOwner(_msgSender(), tokenId), "ERC721: transfer caller is not owner nor approved");
1001 
1002         _transfer(from, to, tokenId);
1003     }
1004 
1005     /**
1006      * @dev See {IERC721-safeTransferFrom}.
1007      */
1008     function safeTransferFrom(
1009         address from,
1010         address to,
1011         uint256 tokenId
1012     ) public virtual override {
1013         safeTransferFrom(from, to, tokenId, "");
1014     }
1015 
1016     /**
1017      * @dev See {IERC721-safeTransferFrom}.
1018      */
1019     function safeTransferFrom(
1020         address from,
1021         address to,
1022         uint256 tokenId,
1023         bytes memory _data
1024     ) public virtual override {
1025         require(_isApprovedOrOwner(_msgSender(), tokenId), "ERC721: transfer caller is not owner nor approved");
1026         _safeTransfer(from, to, tokenId, _data);
1027     }
1028 
1029     /**
1030      * @dev Safely transfers `tokenId` token from `from` to `to`, checking first that contract recipients
1031      * are aware of the ERC721 protocol to prevent tokens from being forever locked.
1032      *
1033      * `_data` is additional data, it has no specified format and it is sent in call to `to`.
1034      *
1035      * This internal function is equivalent to {safeTransferFrom}, and can be used to e.g.
1036      * implement alternative mechanisms to perform token transfer, such as signature-based.
1037      *
1038      * Requirements:
1039      *
1040      * - `from` cannot be the zero address.
1041      * - `to` cannot be the zero address.
1042      * - `tokenId` token must exist and be owned by `from`.
1043      * - If `to` refers to a smart contract, it must implement {IERC721Receiver-onERC721Received}, which is called upon a safe transfer.
1044      *
1045      * Emits a {Transfer} event.
1046      */
1047     function _safeTransfer(
1048         address from,
1049         address to,
1050         uint256 tokenId,
1051         bytes memory _data
1052     ) internal virtual {
1053         _transfer(from, to, tokenId);
1054         require(_checkOnERC721Received(from, to, tokenId, _data), "ERC721: transfer to non ERC721Receiver implementer");
1055     }
1056 
1057     /**
1058      * @dev Returns whether `tokenId` exists.
1059      *
1060      * Tokens can be managed by their owner or approved accounts via {approve} or {setApprovalForAll}.
1061      *
1062      * Tokens start existing when they are minted (`_mint`),
1063      * and stop existing when they are burned (`_burn`).
1064      */
1065     function _exists(uint256 tokenId) internal view virtual returns (bool) {
1066         return _owners[tokenId] != address(0);
1067     }
1068 
1069     /**
1070      * @dev Returns whether `spender` is allowed to manage `tokenId`.
1071      *
1072      * Requirements:
1073      *
1074      * - `tokenId` must exist.
1075      */
1076     function _isApprovedOrOwner(address spender, uint256 tokenId) internal view virtual returns (bool) {
1077         require(_exists(tokenId), "ERC721: operator query for nonexistent token");
1078         address owner = ERC721.ownerOf(tokenId);
1079         return (spender == owner || getApproved(tokenId) == spender || isApprovedForAll(owner, spender));
1080     }
1081 
1082     /**
1083      * @dev Safely mints `tokenId` and transfers it to `to`.
1084      *
1085      * Requirements:
1086      *
1087      * - `tokenId` must not exist.
1088      * - If `to` refers to a smart contract, it must implement {IERC721Receiver-onERC721Received}, which is called upon a safe transfer.
1089      *
1090      * Emits a {Transfer} event.
1091      */
1092     function _safeMint(address to, uint256 tokenId) internal virtual {
1093         _safeMint(to, tokenId, "");
1094     }
1095 
1096     /**
1097      * @dev Same as {xref-ERC721-_safeMint-address-uint256-}[`_safeMint`], with an additional `data` parameter which is
1098      * forwarded in {IERC721Receiver-onERC721Received} to contract recipients.
1099      */
1100     function _safeMint(
1101         address to,
1102         uint256 tokenId,
1103         bytes memory _data
1104     ) internal virtual {
1105         _mint(to, tokenId);
1106         require(
1107             _checkOnERC721Received(address(0), to, tokenId, _data),
1108             "ERC721: transfer to non ERC721Receiver implementer"
1109         );
1110     }
1111 
1112     /**
1113      * @dev Mints `tokenId` and transfers it to `to`.
1114      *
1115      * WARNING: Usage of this method is discouraged, use {_safeMint} whenever possible
1116      *
1117      * Requirements:
1118      *
1119      * - `tokenId` must not exist.
1120      * - `to` cannot be the zero address.
1121      *
1122      * Emits a {Transfer} event.
1123      */
1124     function _mint(address to, uint256 tokenId) internal virtual {
1125         require(to != address(0), "ERC721: mint to the zero address");
1126         require(!_exists(tokenId), "ERC721: token already minted");
1127 
1128         _beforeTokenTransfer(address(0), to, tokenId);
1129 
1130         _balances[to] += 1;
1131         _owners[tokenId] = to;
1132 
1133         emit Transfer(address(0), to, tokenId);
1134     }
1135 
1136     /**
1137      * @dev Destroys `tokenId`.
1138      * The approval is cleared when the token is burned.
1139      *
1140      * Requirements:
1141      *
1142      * - `tokenId` must exist.
1143      *
1144      * Emits a {Transfer} event.
1145      */
1146     function _burn(uint256 tokenId) internal virtual {
1147         address owner = ERC721.ownerOf(tokenId);
1148 
1149         _beforeTokenTransfer(owner, address(0), tokenId);
1150 
1151         // Clear approvals
1152         _approve(address(0), tokenId);
1153 
1154         _balances[owner] -= 1;
1155         delete _owners[tokenId];
1156 
1157         emit Transfer(owner, address(0), tokenId);
1158     }
1159 
1160     /**
1161      * @dev Transfers `tokenId` from `from` to `to`.
1162      *  As opposed to {transferFrom}, this imposes no restrictions on msg.sender.
1163      *
1164      * Requirements:
1165      *
1166      * - `to` cannot be the zero address.
1167      * - `tokenId` token must be owned by `from`.
1168      *
1169      * Emits a {Transfer} event.
1170      */
1171     function _transfer(
1172         address from,
1173         address to,
1174         uint256 tokenId
1175     ) internal virtual {
1176         require(ERC721.ownerOf(tokenId) == from, "ERC721: transfer of token that is not own");
1177         require(to != address(0), "ERC721: transfer to the zero address");
1178 
1179         _beforeTokenTransfer(from, to, tokenId);
1180 
1181         // Clear approvals from the previous owner
1182         _approve(address(0), tokenId);
1183 
1184         _balances[from] -= 1;
1185         _balances[to] += 1;
1186         _owners[tokenId] = to;
1187 
1188         emit Transfer(from, to, tokenId);
1189     }
1190 
1191     /**
1192      * @dev Approve `to` to operate on `tokenId`
1193      *
1194      * Emits a {Approval} event.
1195      */
1196     function _approve(address to, uint256 tokenId) internal virtual {
1197         _tokenApprovals[tokenId] = to;
1198         emit Approval(ERC721.ownerOf(tokenId), to, tokenId);
1199     }
1200 
1201     /**
1202      * @dev Internal function to invoke {IERC721Receiver-onERC721Received} on a target address.
1203      * The call is not executed if the target address is not a contract.
1204      *
1205      * @param from address representing the previous owner of the given token ID
1206      * @param to target address that will receive the tokens
1207      * @param tokenId uint256 ID of the token to be transferred
1208      * @param _data bytes optional data to send along with the call
1209      * @return bool whether the call correctly returned the expected magic value
1210      */
1211     function _checkOnERC721Received(
1212         address from,
1213         address to,
1214         uint256 tokenId,
1215         bytes memory _data
1216     ) private returns (bool) {
1217         if (to.isContract()) {
1218             try IERC721Receiver(to).onERC721Received(_msgSender(), from, tokenId, _data) returns (bytes4 retval) {
1219                 return retval == IERC721Receiver.onERC721Received.selector;
1220             } catch (bytes memory reason) {
1221                 if (reason.length == 0) {
1222                     revert("ERC721: transfer to non ERC721Receiver implementer");
1223                 } else {
1224                     assembly {
1225                         revert(add(32, reason), mload(reason))
1226                     }
1227                 }
1228             }
1229         } else {
1230             return true;
1231         }
1232     }
1233 
1234     /**
1235      * @dev Hook that is called before any token transfer. This includes minting
1236      * and burning.
1237      *
1238      * Calling conditions:
1239      *
1240      * - When `from` and `to` are both non-zero, ``from``'s `tokenId` will be
1241      * transferred to `to`.
1242      * - When `from` is zero, `tokenId` will be minted for `to`.
1243      * - When `to` is zero, ``from``'s `tokenId` will be burned.
1244      * - `from` and `to` are never both zero.
1245      *
1246      * To learn more about hooks, head to xref:ROOT:extending-contracts.adoc#using-hooks[Using Hooks].
1247      */
1248     function _beforeTokenTransfer(
1249         address from,
1250         address to,
1251         uint256 tokenId
1252     ) internal virtual {}
1253 }
1254 
1255 // File: @openzeppelin/contracts/token/ERC721/extensions/ERC721Enumerable.sol
1256 
1257 
1258 
1259 pragma solidity ^0.8.0;
1260 
1261 
1262 
1263 /**
1264  * @dev This implements an optional extension of {ERC721} defined in the EIP that adds
1265  * enumerability of all the token ids in the contract as well as all token ids owned by each
1266  * account.
1267  */
1268 abstract contract ERC721Enumerable is ERC721, IERC721Enumerable {
1269     // Mapping from owner to list of owned token IDs
1270     mapping(address => mapping(uint256 => uint256)) private _ownedTokens;
1271 
1272     // Mapping from token ID to index of the owner tokens list
1273     mapping(uint256 => uint256) private _ownedTokensIndex;
1274 
1275     // Array with all token ids, used for enumeration
1276     uint256[] private _allTokens;
1277 
1278     // Mapping from token id to position in the allTokens array
1279     mapping(uint256 => uint256) private _allTokensIndex;
1280 
1281     /**
1282      * @dev See {IERC165-supportsInterface}.
1283      */
1284     function supportsInterface(bytes4 interfaceId) public view virtual override(IERC165, ERC721) returns (bool) {
1285         return interfaceId == type(IERC721Enumerable).interfaceId || super.supportsInterface(interfaceId);
1286     }
1287 
1288     /**
1289      * @dev See {IERC721Enumerable-tokenOfOwnerByIndex}.
1290      */
1291     function tokenOfOwnerByIndex(address owner, uint256 index) public view virtual override returns (uint256) {
1292         require(index < ERC721.balanceOf(owner), "ERC721Enumerable: owner index out of bounds");
1293         return _ownedTokens[owner][index];
1294     }
1295 
1296     /**
1297      * @dev See {IERC721Enumerable-totalSupply}.
1298      */
1299     function totalSupply() public view virtual override returns (uint256) {
1300         return _allTokens.length;
1301     }
1302 
1303     /**
1304      * @dev See {IERC721Enumerable-tokenByIndex}.
1305      */
1306     function tokenByIndex(uint256 index) public view virtual override returns (uint256) {
1307         require(index < ERC721Enumerable.totalSupply(), "ERC721Enumerable: global index out of bounds");
1308         return _allTokens[index];
1309     }
1310 
1311     /**
1312      * @dev Hook that is called before any token transfer. This includes minting
1313      * and burning.
1314      *
1315      * Calling conditions:
1316      *
1317      * - When `from` and `to` are both non-zero, ``from``'s `tokenId` will be
1318      * transferred to `to`.
1319      * - When `from` is zero, `tokenId` will be minted for `to`.
1320      * - When `to` is zero, ``from``'s `tokenId` will be burned.
1321      * - `from` cannot be the zero address.
1322      * - `to` cannot be the zero address.
1323      *
1324      * To learn more about hooks, head to xref:ROOT:extending-contracts.adoc#using-hooks[Using Hooks].
1325      */
1326     function _beforeTokenTransfer(
1327         address from,
1328         address to,
1329         uint256 tokenId
1330     ) internal virtual override {
1331         super._beforeTokenTransfer(from, to, tokenId);
1332 
1333         if (from == address(0)) {
1334             _addTokenToAllTokensEnumeration(tokenId);
1335         } else if (from != to) {
1336             _removeTokenFromOwnerEnumeration(from, tokenId);
1337         }
1338         if (to == address(0)) {
1339             _removeTokenFromAllTokensEnumeration(tokenId);
1340         } else if (to != from) {
1341             _addTokenToOwnerEnumeration(to, tokenId);
1342         }
1343     }
1344 
1345     /**
1346      * @dev Private function to add a token to this extension's ownership-tracking data structures.
1347      * @param to address representing the new owner of the given token ID
1348      * @param tokenId uint256 ID of the token to be added to the tokens list of the given address
1349      */
1350     function _addTokenToOwnerEnumeration(address to, uint256 tokenId) private {
1351         uint256 length = ERC721.balanceOf(to);
1352         _ownedTokens[to][length] = tokenId;
1353         _ownedTokensIndex[tokenId] = length;
1354     }
1355 
1356     /**
1357      * @dev Private function to add a token to this extension's token tracking data structures.
1358      * @param tokenId uint256 ID of the token to be added to the tokens list
1359      */
1360     function _addTokenToAllTokensEnumeration(uint256 tokenId) private {
1361         _allTokensIndex[tokenId] = _allTokens.length;
1362         _allTokens.push(tokenId);
1363     }
1364 
1365     /**
1366      * @dev Private function to remove a token from this extension's ownership-tracking data structures. Note that
1367      * while the token is not assigned a new owner, the `_ownedTokensIndex` mapping is _not_ updated: this allows for
1368      * gas optimizations e.g. when performing a transfer operation (avoiding double writes).
1369      * This has O(1) time complexity, but alters the order of the _ownedTokens array.
1370      * @param from address representing the previous owner of the given token ID
1371      * @param tokenId uint256 ID of the token to be removed from the tokens list of the given address
1372      */
1373     function _removeTokenFromOwnerEnumeration(address from, uint256 tokenId) private {
1374         // To prevent a gap in from's tokens array, we store the last token in the index of the token to delete, and
1375         // then delete the last slot (swap and pop).
1376 
1377         uint256 lastTokenIndex = ERC721.balanceOf(from) - 1;
1378         uint256 tokenIndex = _ownedTokensIndex[tokenId];
1379 
1380         // When the token to delete is the last token, the swap operation is unnecessary
1381         if (tokenIndex != lastTokenIndex) {
1382             uint256 lastTokenId = _ownedTokens[from][lastTokenIndex];
1383 
1384             _ownedTokens[from][tokenIndex] = lastTokenId; // Move the last token to the slot of the to-delete token
1385             _ownedTokensIndex[lastTokenId] = tokenIndex; // Update the moved token's index
1386         }
1387 
1388         // This also deletes the contents at the last position of the array
1389         delete _ownedTokensIndex[tokenId];
1390         delete _ownedTokens[from][lastTokenIndex];
1391     }
1392 
1393     /**
1394      * @dev Private function to remove a token from this extension's token tracking data structures.
1395      * This has O(1) time complexity, but alters the order of the _allTokens array.
1396      * @param tokenId uint256 ID of the token to be removed from the tokens list
1397      */
1398     function _removeTokenFromAllTokensEnumeration(uint256 tokenId) private {
1399         // To prevent a gap in the tokens array, we store the last token in the index of the token to delete, and
1400         // then delete the last slot (swap and pop).
1401 
1402         uint256 lastTokenIndex = _allTokens.length - 1;
1403         uint256 tokenIndex = _allTokensIndex[tokenId];
1404 
1405         // When the token to delete is the last token, the swap operation is unnecessary. However, since this occurs so
1406         // rarely (when the last minted token is burnt) that we still do the swap here to avoid the gas cost of adding
1407         // an 'if' statement (like in _removeTokenFromOwnerEnumeration)
1408         uint256 lastTokenId = _allTokens[lastTokenIndex];
1409 
1410         _allTokens[tokenIndex] = lastTokenId; // Move the last token to the slot of the to-delete token
1411         _allTokensIndex[lastTokenId] = tokenIndex; // Update the moved token's index
1412 
1413         // This also deletes the contents at the last position of the array
1414         delete _allTokensIndex[tokenId];
1415         _allTokens.pop();
1416     }
1417 }
1418 
1419 // File: @openzeppelin/contracts/token/ERC721/extensions/ERC721URIStorage.sol
1420 
1421 
1422 
1423 pragma solidity ^0.8.0;
1424 
1425 
1426 /**
1427  * @dev ERC721 token with storage based token URI management.
1428  */
1429 abstract contract ERC721URIStorage is ERC721 {
1430     using Strings for uint256;
1431 
1432     // Optional mapping for token URIs
1433     mapping(uint256 => string) private _tokenURIs;
1434 
1435     /**
1436      * @dev See {IERC721Metadata-tokenURI}.
1437      */
1438     function tokenURI(uint256 tokenId) public view virtual override returns (string memory) {
1439         require(_exists(tokenId), "ERC721URIStorage: URI query for nonexistent token");
1440 
1441         string memory _tokenURI = _tokenURIs[tokenId];
1442         string memory base = _baseURI();
1443 
1444         // If there is no base URI, return the token URI.
1445         if (bytes(base).length == 0) {
1446             return _tokenURI;
1447         }
1448         // If both are set, concatenate the baseURI and tokenURI (via abi.encodePacked).
1449         if (bytes(_tokenURI).length > 0) {
1450             return string(abi.encodePacked(base, _tokenURI));
1451         }
1452 
1453         return super.tokenURI(tokenId);
1454     }
1455 
1456     /**
1457      * @dev Sets `_tokenURI` as the tokenURI of `tokenId`.
1458      *
1459      * Requirements:
1460      *
1461      * - `tokenId` must exist.
1462      */
1463     function _setTokenURI(uint256 tokenId, string memory _tokenURI) internal virtual {
1464         require(_exists(tokenId), "ERC721URIStorage: URI set of nonexistent token");
1465         _tokenURIs[tokenId] = _tokenURI;
1466     }
1467 
1468     /**
1469      * @dev Destroys `tokenId`.
1470      * The approval is cleared when the token is burned.
1471      *
1472      * Requirements:
1473      *
1474      * - `tokenId` must exist.
1475      *
1476      * Emits a {Transfer} event.
1477      */
1478     function _burn(uint256 tokenId) internal virtual override {
1479         super._burn(tokenId);
1480 
1481         if (bytes(_tokenURIs[tokenId]).length != 0) {
1482             delete _tokenURIs[tokenId];
1483         }
1484     }
1485 }
1486 
1487 // File: PhatPandaz.sol
1488 
1489 
1490 pragma solidity ^0.8.2;
1491 
1492 
1493 
1494 
1495 
1496 
1497 
1498 
1499 contract PhatPandaz is ERC721, ERC721URIStorage, ERC721Enumerable, ReentrancyGuard, Ownable {
1500 
1501     using Counters for Counters.Counter;
1502 
1503     enum Status { Closed, GasPass, Whitelist, Public }
1504 
1505     Counters.Counter private _tokenIds;
1506     
1507     string private _baseURIextended;
1508     string public provenance = "ef112d8feddb2daf519bf41d13fe4ccf98518c1e933acdf2a34cdd525a591b95";
1509     uint constant private maxSupply = 9898;
1510     uint constant private publicStartPrice = 0.30 ether;
1511     uint constant private whitelistPrice = 0.14 ether;
1512     uint constant private gasPassPrice = 0.04 ether;
1513     bool public isActive = true;
1514     uint private gasPassStart = 1642806000; // 1642806000 == 1.21.2022 11PM UTC
1515     uint private whitelistStart = gasPassStart + 24 hours;
1516     uint private publicStart = gasPassStart + 48 hours;
1517     bytes32 private gasPassRoot;
1518     bytes32 private whitelistRoot;
1519     mapping(address => uint) public numMinted;
1520     mapping(address => bool) public gasPassClaimed;
1521     mapping(address => bool) public whitelistClaimed;
1522     mapping(uint => uint) public lastTransfer;
1523 
1524     constructor() ERC721("Phat Pandaz", "PANDAZ") {
1525         _baseURIextended = "ipfs://QmVpMQ8Cc794dRDJNbq9fKZzx7A5US3R1VphYp56N3ECQw/";
1526         teamMint(102);
1527     }
1528 
1529     modifier checkGasPass(address _to, uint _amount, bytes32[] calldata _merkleProof) {
1530         require(isActive, "Sale not active");
1531         require(getStatus() == Status.GasPass, "Status is not Gas Pass");
1532         require(!gasPassClaimed[_to], "Already minted in Gas Pass");
1533         bytes32 leaf = keccak256(abi.encodePacked(_to, _amount));
1534         require(MerkleProof.verify(_merkleProof, gasPassRoot, leaf), "Not Enough Gas Passes");
1535         require(msg.value >= (gasPassPrice * _amount), "Incorrect ether sent");
1536         _;
1537     }
1538 
1539     modifier checkWhitelist(address _to, uint _amount, bytes32[] calldata _merkleProof) {
1540         require(isActive, "Sale not active");
1541         require(getStatus() == Status.Whitelist, "Status is not Whitelist");
1542         require(!whitelistClaimed[_to], "Already minted in Whitelist");
1543         bytes32 leaf = keccak256(abi.encodePacked(_to, _amount));
1544         require(MerkleProof.verify(_merkleProof, whitelistRoot, leaf), "Not whitelisted or minting too many");
1545         require(msg.value >= (whitelistPrice * _amount), "Incorrect ether sent");
1546         _;
1547     }
1548 
1549     modifier checkPublic(address _to, uint _amount) {
1550         uint _totalSupply = totalSupply();
1551         require(isActive, "Sale not active");
1552         require(getStatus() == Status.Public, "Status is not Public");
1553         require(_totalSupply < maxSupply, "Sold out");
1554         require((_totalSupply + _amount) <= maxSupply, "Minting would exceed maximum supply");
1555         require(msg.value >= (getPrice() * _amount), "Incorrect ether sent");
1556         require((numMinted[_to] + _amount) <= 5, "Maximum is 5");
1557         _;
1558     }
1559 
1560     modifier checkUser() {
1561         require(tx.origin == msg.sender, "Caller is not user");
1562         _;
1563     }
1564 
1565     function getStatus() internal view returns (Status) {
1566         if(block.timestamp >= publicStart) {
1567             return Status.Public;
1568         } else if (block.timestamp >= whitelistStart) {
1569             return Status.Whitelist;
1570         } else if (block.timestamp >= gasPassStart) {
1571             return Status.GasPass;
1572         }
1573         return Status.Closed;
1574     }
1575 
1576     function checkStatus() external view returns (Status) {
1577         return getStatus();
1578     }
1579 
1580     function getPrice() internal view returns (uint) {
1581         require(block.timestamp > publicStart, "Public sale not started.");
1582         uint elapsed = (block.timestamp - publicStart) / (30 minutes);
1583         if (elapsed > 11) { elapsed = 11; }
1584         uint currentPrice = publicStartPrice - (elapsed * .01 ether);
1585         return currentPrice;
1586     }
1587 
1588     function checkPrice() external view returns (uint) {
1589         return getPrice();
1590     }
1591     
1592     function _baseURI() internal view virtual override returns (string memory) {
1593         return _baseURIextended;
1594     }
1595     
1596     function setGasPassRoot (bytes32 _gasPassRoot) external onlyOwner {
1597         gasPassRoot = _gasPassRoot;
1598     }
1599 
1600     function setWhitelistRoot (bytes32 _whitelistRoot) external onlyOwner {
1601         whitelistRoot = _whitelistRoot;
1602     }
1603 
1604     function setNewTime(uint _gasPassStart) external onlyOwner {
1605         gasPassStart = _gasPassStart;
1606         whitelistStart = _gasPassStart + 24 hours;
1607         publicStart = _gasPassStart + 48 hours;
1608     }
1609     
1610     function setBaseURI(string memory baseURI_) external onlyOwner {
1611         _baseURIextended = baseURI_;
1612     }
1613 
1614     function setProvenance(string memory _provenance) external onlyOwner {
1615         provenance = _provenance;
1616     }
1617 
1618     function setActive() external onlyOwner {
1619         isActive = !isActive;
1620     }
1621 
1622     function teamMint(uint _amount) internal onlyOwner {
1623         address _to = owner();
1624         for (uint i = 0; i < _amount; i++) {
1625             _tokenIds.increment();
1626             _safeMint(_to, _tokenIds.current());
1627         }
1628     }
1629     
1630     function mintGasPass(uint _amount, bytes32[] calldata _merkleProof) public payable checkGasPass(msg.sender, _amount, _merkleProof) checkUser {
1631         address _to = msg.sender;
1632         for (uint i = 0; i < _amount; i++) {
1633             _tokenIds.increment();
1634             _safeMint(_to, _tokenIds.current());
1635         }
1636         gasPassClaimed[_to] = true;
1637         numMinted[_to] += _amount;
1638     }
1639 
1640     function mintWhitelist(uint _amount, bytes32[] calldata _merkleProof) public payable checkWhitelist(msg.sender, _amount, _merkleProof) checkUser {
1641         address _to = msg.sender;
1642         for (uint i = 0; i < _amount; i++) {
1643             _tokenIds.increment();
1644             _safeMint(_to, _tokenIds.current());
1645         }
1646         whitelistClaimed[_to] = true;
1647         numMinted[_to] += _amount;
1648     }
1649 
1650     function mintPublic(uint _amount) public payable checkPublic(msg.sender, _amount) checkUser {
1651         address _to = msg.sender;
1652         for (uint i = 0; i < _amount; i++) {
1653             _tokenIds.increment();
1654             _safeMint(_to, _tokenIds.current());
1655         }
1656         numMinted[_to] += _amount;
1657     }
1658     
1659     function withdraw() external onlyOwner nonReentrant {
1660         payable(msg.sender).transfer(address(this).balance);
1661     }
1662 
1663     // The following functions are overrides required by Solidity.
1664 
1665     function _beforeTokenTransfer(address from, address to, uint256 tokenId) internal override(ERC721, ERC721Enumerable) {
1666         super._beforeTokenTransfer(from, to, tokenId);
1667         lastTransfer[tokenId] = block.timestamp;
1668     }
1669 
1670     function _burn(uint256 tokenId) internal override(ERC721, ERC721URIStorage) {
1671         super._burn(tokenId);
1672     }
1673 
1674     function tokenURI(uint256 tokenId) public view override(ERC721, ERC721URIStorage) returns (string memory) {
1675         return super.tokenURI(tokenId);
1676     }
1677 
1678     function supportsInterface(bytes4 interfaceId) public view override(ERC721, ERC721Enumerable) returns (bool) {
1679         return super.supportsInterface(interfaceId);
1680     }
1681 }