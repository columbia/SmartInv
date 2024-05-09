1 // SPDX-License-Identifier: MIT
2 
3 // File: @openzeppelin/contracts/utils/cryptography/MerkleProof.sol
4 
5 
6 // OpenZeppelin Contracts v4.4.1 (utils/cryptography/MerkleProof.sol)
7 
8 pragma solidity ^0.8.0;
9 
10 /**
11  * @dev These functions deal with verification of Merkle Trees proofs.
12  *
13  * The proofs can be generated using the JavaScript library
14  * https://github.com/miguelmota/merkletreejs[merkletreejs].
15  * Note: the hashing algorithm should be keccak256 and pair sorting should be enabled.
16  *
17  * See `test/utils/cryptography/MerkleProof.test.js` for some examples.
18  */
19 library MerkleProof {
20     /**
21      * @dev Returns true if a `leaf` can be proved to be a part of a Merkle tree
22      * defined by `root`. For this, a `proof` must be provided, containing
23      * sibling hashes on the branch from the leaf to the root of the tree. Each
24      * pair of leaves and each pair of pre-images are assumed to be sorted.
25      */
26     function verify(
27         bytes32[] memory proof,
28         bytes32 root,
29         bytes32 leaf
30     ) internal pure returns (bool) {
31         return processProof(proof, leaf) == root;
32     }
33 
34     /**
35      * @dev Returns the rebuilt hash obtained by traversing a Merklee tree up
36      * from `leaf` using `proof`. A `proof` is valid if and only if the rebuilt
37      * hash matches the root of the tree. When processing the proof, the pairs
38      * of leafs & pre-images are assumed to be sorted.
39      *
40      * _Available since v4.4._
41      */
42     function processProof(bytes32[] memory proof, bytes32 leaf) internal pure returns (bytes32) {
43         bytes32 computedHash = leaf;
44         for (uint256 i = 0; i < proof.length; i++) {
45             bytes32 proofElement = proof[i];
46             if (computedHash <= proofElement) {
47                 // Hash(current computed hash + current element of the proof)
48                 computedHash = keccak256(abi.encodePacked(computedHash, proofElement));
49             } else {
50                 // Hash(current element of the proof + current computed hash)
51                 computedHash = keccak256(abi.encodePacked(proofElement, computedHash));
52             }
53         }
54         return computedHash;
55     }
56 }
57 
58 // File: @openzeppelin/contracts/security/ReentrancyGuard.sol
59 
60 
61 // OpenZeppelin Contracts v4.4.1 (security/ReentrancyGuard.sol)
62 
63 pragma solidity ^0.8.0;
64 
65 /**
66  * @dev Contract module that helps prevent reentrant calls to a function.
67  *
68  * Inheriting from `ReentrancyGuard` will make the {nonReentrant} modifier
69  * available, which can be applied to functions to make sure there are no nested
70  * (reentrant) calls to them.
71  *
72  * Note that because there is a single `nonReentrant` guard, functions marked as
73  * `nonReentrant` may not call one another. This can be worked around by making
74  * those functions `private`, and then adding `external` `nonReentrant` entry
75  * points to them.
76  *
77  * TIP: If you would like to learn more about reentrancy and alternative ways
78  * to protect against it, check out our blog post
79  * https://blog.openzeppelin.com/reentrancy-after-istanbul/[Reentrancy After Istanbul].
80  */
81 abstract contract ReentrancyGuard {
82     // Booleans are more expensive than uint256 or any type that takes up a full
83     // word because each write operation emits an extra SLOAD to first read the
84     // slot's contents, replace the bits taken up by the boolean, and then write
85     // back. This is the compiler's defense against contract upgrades and
86     // pointer aliasing, and it cannot be disabled.
87 
88     // The values being non-zero value makes deployment a bit more expensive,
89     // but in exchange the refund on every call to nonReentrant will be lower in
90     // amount. Since refunds are capped to a percentage of the total
91     // transaction's gas, it is best to keep them low in cases like this one, to
92     // increase the likelihood of the full refund coming into effect.
93     uint256 private constant _NOT_ENTERED = 1;
94     uint256 private constant _ENTERED = 2;
95 
96     uint256 private _status;
97 
98     constructor() {
99         _status = _NOT_ENTERED;
100     }
101 
102     /**
103      * @dev Prevents a contract from calling itself, directly or indirectly.
104      * Calling a `nonReentrant` function from another `nonReentrant`
105      * function is not supported. It is possible to prevent this from happening
106      * by making the `nonReentrant` function external, and making it call a
107      * `private` function that does the actual work.
108      */
109     modifier nonReentrant() {
110         // On the first call to nonReentrant, _notEntered will be true
111         require(_status != _ENTERED, "ReentrancyGuard: reentrant call");
112 
113         // Any calls to nonReentrant after this point will fail
114         _status = _ENTERED;
115 
116         _;
117 
118         // By storing the original value once again, a refund is triggered (see
119         // https://eips.ethereum.org/EIPS/eip-2200)
120         _status = _NOT_ENTERED;
121     }
122 }
123 
124 // File: @openzeppelin/contracts/utils/Counters.sol
125 
126 
127 // OpenZeppelin Contracts v4.4.1 (utils/Counters.sol)
128 
129 pragma solidity ^0.8.0;
130 
131 /**
132  * @title Counters
133  * @author Matt Condon (@shrugs)
134  * @dev Provides counters that can only be incremented, decremented or reset. This can be used e.g. to track the number
135  * of elements in a mapping, issuing ERC721 ids, or counting request ids.
136  *
137  * Include with `using Counters for Counters.Counter;`
138  */
139 library Counters {
140     struct Counter {
141         // This variable should never be directly accessed by users of the library: interactions must be restricted to
142         // the library's function. As of Solidity v0.5.2, this cannot be enforced, though there is a proposal to add
143         // this feature: see https://github.com/ethereum/solidity/issues/4637
144         uint256 _value; // default: 0
145     }
146 
147     function current(Counter storage counter) internal view returns (uint256) {
148         return counter._value;
149     }
150 
151     function increment(Counter storage counter) internal {
152         unchecked {
153             counter._value += 1;
154         }
155     }
156 
157     function decrement(Counter storage counter) internal {
158         uint256 value = counter._value;
159         require(value > 0, "Counter: decrement overflow");
160         unchecked {
161             counter._value = value - 1;
162         }
163     }
164 
165     function reset(Counter storage counter) internal {
166         counter._value = 0;
167     }
168 }
169 
170 // File: @openzeppelin/contracts/utils/Strings.sol
171 
172 
173 
174 pragma solidity ^0.8.0;
175 
176 /**
177  * @dev String operations.
178  */
179 library Strings {
180     bytes16 private constant _HEX_SYMBOLS = "0123456789abcdef";
181 
182     /**
183      * @dev Converts a `uint256` to its ASCII `string` decimal representation.
184      */
185     function toString(uint256 value) internal pure returns (string memory) {
186         // Inspired by OraclizeAPI's implementation - MIT licence
187         // https://github.com/oraclize/ethereum-api/blob/b42146b063c7d6ee1358846c198246239e9360e8/oraclizeAPI_0.4.25.sol
188 
189         if (value == 0) {
190             return "0";
191         }
192         uint256 temp = value;
193         uint256 digits;
194         while (temp != 0) {
195             digits++;
196             temp /= 10;
197         }
198         bytes memory buffer = new bytes(digits);
199         while (value != 0) {
200             digits -= 1;
201             buffer[digits] = bytes1(uint8(48 + uint256(value % 10)));
202             value /= 10;
203         }
204         return string(buffer);
205     }
206 
207     /**
208      * @dev Converts a `uint256` to its ASCII `string` hexadecimal representation.
209      */
210     function toHexString(uint256 value) internal pure returns (string memory) {
211         if (value == 0) {
212             return "0x00";
213         }
214         uint256 temp = value;
215         uint256 length = 0;
216         while (temp != 0) {
217             length++;
218             temp >>= 8;
219         }
220         return toHexString(value, length);
221     }
222 
223     /**
224      * @dev Converts a `uint256` to its ASCII `string` hexadecimal representation with fixed length.
225      */
226     function toHexString(uint256 value, uint256 length) internal pure returns (string memory) {
227         bytes memory buffer = new bytes(2 * length + 2);
228         buffer[0] = "0";
229         buffer[1] = "x";
230         for (uint256 i = 2 * length + 1; i > 1; --i) {
231             buffer[i] = _HEX_SYMBOLS[value & 0xf];
232             value >>= 4;
233         }
234         require(value == 0, "Strings: hex length insufficient");
235         return string(buffer);
236     }
237 }
238 
239 // File: @openzeppelin/contracts/utils/Context.sol
240 
241 
242 
243 pragma solidity ^0.8.0;
244 
245 /**
246  * @dev Provides information about the current execution context, including the
247  * sender of the transaction and its data. While these are generally available
248  * via msg.sender and msg.data, they should not be accessed in such a direct
249  * manner, since when dealing with meta-transactions the account sending and
250  * paying for execution may not be the actual sender (as far as an application
251  * is concerned).
252  *
253  * This contract is only required for intermediate, library-like contracts.
254  */
255 abstract contract Context {
256     function _msgSender() internal view virtual returns (address) {
257         return msg.sender;
258     }
259 
260     function _msgData() internal view virtual returns (bytes calldata) {
261         return msg.data;
262     }
263 }
264 
265 // File: @openzeppelin/contracts/access/Ownable.sol
266 
267 
268 
269 pragma solidity ^0.8.0;
270 
271 
272 /**
273  * @dev Contract module which provides a basic access control mechanism, where
274  * there is an account (an owner) that can be granted exclusive access to
275  * specific functions.
276  *
277  * By default, the owner account will be the one that deploys the contract. This
278  * can later be changed with {transferOwnership}.
279  *
280  * This module is used through inheritance. It will make available the modifier
281  * `onlyOwner`, which can be applied to your functions to restrict their use to
282  * the owner.
283  */
284 abstract contract Ownable is Context {
285     address private _owner;
286 
287     event OwnershipTransferred(address indexed previousOwner, address indexed newOwner);
288 
289     /**
290      * @dev Initializes the contract setting the deployer as the initial owner.
291      */
292     constructor() {
293         _setOwner(_msgSender());
294     }
295 
296     /**
297      * @dev Returns the address of the current owner.
298      */
299     function owner() public view virtual returns (address) {
300         return _owner;
301     }
302 
303     /**
304      * @dev Throws if called by any account other than the owner.
305      */
306     modifier onlyOwner() {
307         require(owner() == _msgSender(), "Ownable: caller is not the owner");
308         _;
309     }
310 
311     /**
312      * @dev Leaves the contract without owner. It will not be possible to call
313      * `onlyOwner` functions anymore. Can only be called by the current owner.
314      *
315      * NOTE: Renouncing ownership will leave the contract without an owner,
316      * thereby removing any functionality that is only available to the owner.
317      */
318     function renounceOwnership() public virtual onlyOwner {
319         _setOwner(address(0));
320     }
321 
322     /**
323      * @dev Transfers ownership of the contract to a new account (`newOwner`).
324      * Can only be called by the current owner.
325      */
326     function transferOwnership(address newOwner) public virtual onlyOwner {
327         require(newOwner != address(0), "Ownable: new owner is the zero address");
328         _setOwner(newOwner);
329     }
330 
331     function _setOwner(address newOwner) private {
332         address oldOwner = _owner;
333         _owner = newOwner;
334         emit OwnershipTransferred(oldOwner, newOwner);
335     }
336 }
337 
338 // File: @openzeppelin/contracts/utils/Address.sol
339 
340 
341 
342 pragma solidity ^0.8.0;
343 
344 /**
345  * @dev Collection of functions related to the address type
346  */
347 library Address {
348     /**
349      * @dev Returns true if `account` is a contract.
350      *
351      * [IMPORTANT]
352      * ====
353      * It is unsafe to assume that an address for which this function returns
354      * false is an externally-owned account (EOA) and not a contract.
355      *
356      * Among others, `isContract` will return false for the following
357      * types of addresses:
358      *
359      *  - an externally-owned account
360      *  - a contract in construction
361      *  - an address where a contract will be created
362      *  - an address where a contract lived, but was destroyed
363      * ====
364      */
365     function isContract(address account) internal view returns (bool) {
366         // This method relies on extcodesize, which returns 0 for contracts in
367         // construction, since the code is only stored at the end of the
368         // constructor execution.
369 
370         uint256 size;
371         assembly {
372             size := extcodesize(account)
373         }
374         return size > 0;
375     }
376 
377     /**
378      * @dev Replacement for Solidity's `transfer`: sends `amount` wei to
379      * `recipient`, forwarding all available gas and reverting on errors.
380      *
381      * https://eips.ethereum.org/EIPS/eip-1884[EIP1884] increases the gas cost
382      * of certain opcodes, possibly making contracts go over the 2300 gas limit
383      * imposed by `transfer`, making them unable to receive funds via
384      * `transfer`. {sendValue} removes this limitation.
385      *
386      * https://diligence.consensys.net/posts/2019/09/stop-using-soliditys-transfer-now/[Learn more].
387      *
388      * IMPORTANT: because control is transferred to `recipient`, care must be
389      * taken to not create reentrancy vulnerabilities. Consider using
390      * {ReentrancyGuard} or the
391      * https://solidity.readthedocs.io/en/v0.5.11/security-considerations.html#use-the-checks-effects-interactions-pattern[checks-effects-interactions pattern].
392      */
393     function sendValue(address payable recipient, uint256 amount) internal {
394         require(address(this).balance >= amount, "Address: insufficient balance");
395 
396         (bool success, ) = recipient.call{value: amount}("");
397         require(success, "Address: unable to send value, recipient may have reverted");
398     }
399 
400     /**
401      * @dev Performs a Solidity function call using a low level `call`. A
402      * plain `call` is an unsafe replacement for a function call: use this
403      * function instead.
404      *
405      * If `target` reverts with a revert reason, it is bubbled up by this
406      * function (like regular Solidity function calls).
407      *
408      * Returns the raw returned data. To convert to the expected return value,
409      * use https://solidity.readthedocs.io/en/latest/units-and-global-variables.html?highlight=abi.decode#abi-encoding-and-decoding-functions[`abi.decode`].
410      *
411      * Requirements:
412      *
413      * - `target` must be a contract.
414      * - calling `target` with `data` must not revert.
415      *
416      * _Available since v3.1._
417      */
418     function functionCall(address target, bytes memory data) internal returns (bytes memory) {
419         return functionCall(target, data, "Address: low-level call failed");
420     }
421 
422     /**
423      * @dev Same as {xref-Address-functionCall-address-bytes-}[`functionCall`], but with
424      * `errorMessage` as a fallback revert reason when `target` reverts.
425      *
426      * _Available since v3.1._
427      */
428     function functionCall(
429         address target,
430         bytes memory data,
431         string memory errorMessage
432     ) internal returns (bytes memory) {
433         return functionCallWithValue(target, data, 0, errorMessage);
434     }
435 
436     /**
437      * @dev Same as {xref-Address-functionCall-address-bytes-}[`functionCall`],
438      * but also transferring `value` wei to `target`.
439      *
440      * Requirements:
441      *
442      * - the calling contract must have an ETH balance of at least `value`.
443      * - the called Solidity function must be `payable`.
444      *
445      * _Available since v3.1._
446      */
447     function functionCallWithValue(
448         address target,
449         bytes memory data,
450         uint256 value
451     ) internal returns (bytes memory) {
452         return functionCallWithValue(target, data, value, "Address: low-level call with value failed");
453     }
454 
455     /**
456      * @dev Same as {xref-Address-functionCallWithValue-address-bytes-uint256-}[`functionCallWithValue`], but
457      * with `errorMessage` as a fallback revert reason when `target` reverts.
458      *
459      * _Available since v3.1._
460      */
461     function functionCallWithValue(
462         address target,
463         bytes memory data,
464         uint256 value,
465         string memory errorMessage
466     ) internal returns (bytes memory) {
467         require(address(this).balance >= value, "Address: insufficient balance for call");
468         require(isContract(target), "Address: call to non-contract");
469 
470         (bool success, bytes memory returndata) = target.call{value: value}(data);
471         return verifyCallResult(success, returndata, errorMessage);
472     }
473 
474     /**
475      * @dev Same as {xref-Address-functionCall-address-bytes-}[`functionCall`],
476      * but performing a static call.
477      *
478      * _Available since v3.3._
479      */
480     function functionStaticCall(address target, bytes memory data) internal view returns (bytes memory) {
481         return functionStaticCall(target, data, "Address: low-level static call failed");
482     }
483 
484     /**
485      * @dev Same as {xref-Address-functionCall-address-bytes-string-}[`functionCall`],
486      * but performing a static call.
487      *
488      * _Available since v3.3._
489      */
490     function functionStaticCall(
491         address target,
492         bytes memory data,
493         string memory errorMessage
494     ) internal view returns (bytes memory) {
495         require(isContract(target), "Address: static call to non-contract");
496 
497         (bool success, bytes memory returndata) = target.staticcall(data);
498         return verifyCallResult(success, returndata, errorMessage);
499     }
500 
501     /**
502      * @dev Same as {xref-Address-functionCall-address-bytes-}[`functionCall`],
503      * but performing a delegate call.
504      *
505      * _Available since v3.4._
506      */
507     function functionDelegateCall(address target, bytes memory data) internal returns (bytes memory) {
508         return functionDelegateCall(target, data, "Address: low-level delegate call failed");
509     }
510 
511     /**
512      * @dev Same as {xref-Address-functionCall-address-bytes-string-}[`functionCall`],
513      * but performing a delegate call.
514      *
515      * _Available since v3.4._
516      */
517     function functionDelegateCall(
518         address target,
519         bytes memory data,
520         string memory errorMessage
521     ) internal returns (bytes memory) {
522         require(isContract(target), "Address: delegate call to non-contract");
523 
524         (bool success, bytes memory returndata) = target.delegatecall(data);
525         return verifyCallResult(success, returndata, errorMessage);
526     }
527 
528     /**
529      * @dev Tool to verifies that a low level call was successful, and revert if it wasn't, either by bubbling the
530      * revert reason using the provided one.
531      *
532      * _Available since v4.3._
533      */
534     function verifyCallResult(
535         bool success,
536         bytes memory returndata,
537         string memory errorMessage
538     ) internal pure returns (bytes memory) {
539         if (success) {
540             return returndata;
541         } else {
542             // Look for revert reason and bubble it up if present
543             if (returndata.length > 0) {
544                 // The easiest way to bubble the revert reason is using memory via assembly
545 
546                 assembly {
547                     let returndata_size := mload(returndata)
548                     revert(add(32, returndata), returndata_size)
549                 }
550             } else {
551                 revert(errorMessage);
552             }
553         }
554     }
555 }
556 
557 // File: @openzeppelin/contracts/token/ERC721/IERC721Receiver.sol
558 
559 
560 
561 pragma solidity ^0.8.0;
562 
563 /**
564  * @title ERC721 token receiver interface
565  * @dev Interface for any contract that wants to support safeTransfers
566  * from ERC721 asset contracts.
567  */
568 interface IERC721Receiver {
569     /**
570      * @dev Whenever an {IERC721} `tokenId` token is transferred to this contract via {IERC721-safeTransferFrom}
571      * by `operator` from `from`, this function is called.
572      *
573      * It must return its Solidity selector to confirm the token transfer.
574      * If any other value is returned or the interface is not implemented by the recipient, the transfer will be reverted.
575      *
576      * The selector can be obtained in Solidity with `IERC721.onERC721Received.selector`.
577      */
578     function onERC721Received(
579         address operator,
580         address from,
581         uint256 tokenId,
582         bytes calldata data
583     ) external returns (bytes4);
584 }
585 
586 // File: @openzeppelin/contracts/utils/introspection/IERC165.sol
587 
588 
589 
590 pragma solidity ^0.8.0;
591 
592 /**
593  * @dev Interface of the ERC165 standard, as defined in the
594  * https://eips.ethereum.org/EIPS/eip-165[EIP].
595  *
596  * Implementers can declare support of contract interfaces, which can then be
597  * queried by others ({ERC165Checker}).
598  *
599  * For an implementation, see {ERC165}.
600  */
601 interface IERC165 {
602     /**
603      * @dev Returns true if this contract implements the interface defined by
604      * `interfaceId`. See the corresponding
605      * https://eips.ethereum.org/EIPS/eip-165#how-interfaces-are-identified[EIP section]
606      * to learn more about how these ids are created.
607      *
608      * This function call must use less than 30 000 gas.
609      */
610     function supportsInterface(bytes4 interfaceId) external view returns (bool);
611 }
612 
613 // File: @openzeppelin/contracts/utils/introspection/ERC165.sol
614 
615 
616 
617 pragma solidity ^0.8.0;
618 
619 
620 /**
621  * @dev Implementation of the {IERC165} interface.
622  *
623  * Contracts that want to implement ERC165 should inherit from this contract and override {supportsInterface} to check
624  * for the additional interface id that will be supported. For example:
625  *
626  * ```solidity
627  * function supportsInterface(bytes4 interfaceId) public view virtual override returns (bool) {
628  *     return interfaceId == type(MyInterface).interfaceId || super.supportsInterface(interfaceId);
629  * }
630  * ```
631  *
632  * Alternatively, {ERC165Storage} provides an easier to use but more expensive implementation.
633  */
634 abstract contract ERC165 is IERC165 {
635     /**
636      * @dev See {IERC165-supportsInterface}.
637      */
638     function supportsInterface(bytes4 interfaceId) public view virtual override returns (bool) {
639         return interfaceId == type(IERC165).interfaceId;
640     }
641 }
642 
643 // File: @openzeppelin/contracts/token/ERC721/IERC721.sol
644 
645 
646 
647 pragma solidity ^0.8.0;
648 
649 
650 /**
651  * @dev Required interface of an ERC721 compliant contract.
652  */
653 interface IERC721 is IERC165 {
654     /**
655      * @dev Emitted when `tokenId` token is transferred from `from` to `to`.
656      */
657     event Transfer(address indexed from, address indexed to, uint256 indexed tokenId);
658 
659     /**
660      * @dev Emitted when `owner` enables `approved` to manage the `tokenId` token.
661      */
662     event Approval(address indexed owner, address indexed approved, uint256 indexed tokenId);
663 
664     /**
665      * @dev Emitted when `owner` enables or disables (`approved`) `operator` to manage all of its assets.
666      */
667     event ApprovalForAll(address indexed owner, address indexed operator, bool approved);
668 
669     /**
670      * @dev Returns the number of tokens in ``owner``'s account.
671      */
672     function balanceOf(address owner) external view returns (uint256 balance);
673 
674     /**
675      * @dev Returns the owner of the `tokenId` token.
676      *
677      * Requirements:
678      *
679      * - `tokenId` must exist.
680      */
681     function ownerOf(uint256 tokenId) external view returns (address owner);
682 
683     /**
684      * @dev Safely transfers `tokenId` token from `from` to `to`, checking first that contract recipients
685      * are aware of the ERC721 protocol to prevent tokens from being forever locked.
686      *
687      * Requirements:
688      *
689      * - `from` cannot be the zero address.
690      * - `to` cannot be the zero address.
691      * - `tokenId` token must exist and be owned by `from`.
692      * - If the caller is not `from`, it must be have been allowed to move this token by either {approve} or {setApprovalForAll}.
693      * - If `to` refers to a smart contract, it must implement {IERC721Receiver-onERC721Received}, which is called upon a safe transfer.
694      *
695      * Emits a {Transfer} event.
696      */
697     function safeTransferFrom(
698         address from,
699         address to,
700         uint256 tokenId
701     ) external;
702 
703     /**
704      * @dev Transfers `tokenId` token from `from` to `to`.
705      *
706      * WARNING: Usage of this method is discouraged, use {safeTransferFrom} whenever possible.
707      *
708      * Requirements:
709      *
710      * - `from` cannot be the zero address.
711      * - `to` cannot be the zero address.
712      * - `tokenId` token must be owned by `from`.
713      * - If the caller is not `from`, it must be approved to move this token by either {approve} or {setApprovalForAll}.
714      *
715      * Emits a {Transfer} event.
716      */
717     function transferFrom(
718         address from,
719         address to,
720         uint256 tokenId
721     ) external;
722 
723     /**
724      * @dev Gives permission to `to` to transfer `tokenId` token to another account.
725      * The approval is cleared when the token is transferred.
726      *
727      * Only a single account can be approved at a time, so approving the zero address clears previous approvals.
728      *
729      * Requirements:
730      *
731      * - The caller must own the token or be an approved operator.
732      * - `tokenId` must exist.
733      *
734      * Emits an {Approval} event.
735      */
736     function approve(address to, uint256 tokenId) external;
737 
738     /**
739      * @dev Returns the account approved for `tokenId` token.
740      *
741      * Requirements:
742      *
743      * - `tokenId` must exist.
744      */
745     function getApproved(uint256 tokenId) external view returns (address operator);
746 
747     /**
748      * @dev Approve or remove `operator` as an operator for the caller.
749      * Operators can call {transferFrom} or {safeTransferFrom} for any token owned by the caller.
750      *
751      * Requirements:
752      *
753      * - The `operator` cannot be the caller.
754      *
755      * Emits an {ApprovalForAll} event.
756      */
757     function setApprovalForAll(address operator, bool _approved) external;
758 
759     /**
760      * @dev Returns if the `operator` is allowed to manage all of the assets of `owner`.
761      *
762      * See {setApprovalForAll}
763      */
764     function isApprovedForAll(address owner, address operator) external view returns (bool);
765 
766     /**
767      * @dev Safely transfers `tokenId` token from `from` to `to`.
768      *
769      * Requirements:
770      *
771      * - `from` cannot be the zero address.
772      * - `to` cannot be the zero address.
773      * - `tokenId` token must exist and be owned by `from`.
774      * - If the caller is not `from`, it must be approved to move this token by either {approve} or {setApprovalForAll}.
775      * - If `to` refers to a smart contract, it must implement {IERC721Receiver-onERC721Received}, which is called upon a safe transfer.
776      *
777      * Emits a {Transfer} event.
778      */
779     function safeTransferFrom(
780         address from,
781         address to,
782         uint256 tokenId,
783         bytes calldata data
784     ) external;
785 }
786 
787 // File: @openzeppelin/contracts/token/ERC721/extensions/IERC721Metadata.sol
788 
789 
790 
791 pragma solidity ^0.8.0;
792 
793 
794 /**
795  * @title ERC-721 Non-Fungible Token Standard, optional metadata extension
796  * @dev See https://eips.ethereum.org/EIPS/eip-721
797  */
798 interface IERC721Metadata is IERC721 {
799     /**
800      * @dev Returns the token collection name.
801      */
802     function name() external view returns (string memory);
803 
804     /**
805      * @dev Returns the token collection symbol.
806      */
807     function symbol() external view returns (string memory);
808 
809     /**
810      * @dev Returns the Uniform Resource Identifier (URI) for `tokenId` token.
811      */
812     function tokenURI(uint256 tokenId) external view returns (string memory);
813 }
814 
815 // File: @openzeppelin/contracts/token/ERC721/ERC721.sol
816 
817 
818 
819 pragma solidity ^0.8.0;
820 
821 
822 
823 
824 
825 
826 
827 
828 /**
829  * @dev Implementation of https://eips.ethereum.org/EIPS/eip-721[ERC721] Non-Fungible Token Standard, including
830  * the Metadata extension, but not including the Enumerable extension, which is available separately as
831  * {ERC721Enumerable}.
832  */
833 contract ERC721 is Context, ERC165, IERC721, IERC721Metadata {
834     using Address for address;
835     using Strings for uint256;
836 
837     // Token name
838     string private _name;
839 
840     // Token symbol
841     string private _symbol;
842 
843     // Mapping from token ID to owner address
844     mapping(uint256 => address) private _owners;
845 
846     // Mapping owner address to token count
847     mapping(address => uint256) private _balances;
848 
849     // Mapping from token ID to approved address
850     mapping(uint256 => address) private _tokenApprovals;
851 
852     // Mapping from owner to operator approvals
853     mapping(address => mapping(address => bool)) private _operatorApprovals;
854 
855     /**
856      * @dev Initializes the contract by setting a `name` and a `symbol` to the token collection.
857      */
858     constructor(string memory name_, string memory symbol_) {
859         _name = name_;
860         _symbol = symbol_;
861     }
862 
863     /**
864      * @dev See {IERC165-supportsInterface}.
865      */
866     function supportsInterface(bytes4 interfaceId) public view virtual override(ERC165, IERC165) returns (bool) {
867         return
868             interfaceId == type(IERC721).interfaceId ||
869             interfaceId == type(IERC721Metadata).interfaceId ||
870             super.supportsInterface(interfaceId);
871     }
872 
873     /**
874      * @dev See {IERC721-balanceOf}.
875      */
876     function balanceOf(address owner) public view virtual override returns (uint256) {
877         require(owner != address(0), "ERC721: balance query for the zero address");
878         return _balances[owner];
879     }
880 
881     /**
882      * @dev See {IERC721-ownerOf}.
883      */
884     function ownerOf(uint256 tokenId) public view virtual override returns (address) {
885         address owner = _owners[tokenId];
886         require(owner != address(0), "ERC721: owner query for nonexistent token");
887         return owner;
888     }
889 
890     /**
891      * @dev See {IERC721Metadata-name}.
892      */
893     function name() public view virtual override returns (string memory) {
894         return _name;
895     }
896 
897     /**
898      * @dev See {IERC721Metadata-symbol}.
899      */
900     function symbol() public view virtual override returns (string memory) {
901         return _symbol;
902     }
903 
904     /**
905      * @dev See {IERC721Metadata-tokenURI}.
906      */
907     function tokenURI(uint256 tokenId) public view virtual override returns (string memory) {
908         require(_exists(tokenId), "ERC721Metadata: URI query for nonexistent token");
909 
910         string memory baseURI = _baseURI();
911         return bytes(baseURI).length > 0 ? string(abi.encodePacked(baseURI, tokenId.toString())) : "";
912     }
913 
914     /**
915      * @dev Base URI for computing {tokenURI}. If set, the resulting URI for each
916      * token will be the concatenation of the `baseURI` and the `tokenId`. Empty
917      * by default, can be overriden in child contracts.
918      */
919     function _baseURI() internal view virtual returns (string memory) {
920         return "";
921     }
922 
923     /**
924      * @dev See {IERC721-approve}.
925      */
926     function approve(address to, uint256 tokenId) public virtual override {
927         address owner = ERC721.ownerOf(tokenId);
928         require(to != owner, "ERC721: approval to current owner");
929 
930         require(
931             _msgSender() == owner || isApprovedForAll(owner, _msgSender()),
932             "ERC721: approve caller is not owner nor approved for all"
933         );
934 
935         _approve(to, tokenId);
936     }
937 
938     /**
939      * @dev See {IERC721-getApproved}.
940      */
941     function getApproved(uint256 tokenId) public view virtual override returns (address) {
942         require(_exists(tokenId), "ERC721: approved query for nonexistent token");
943 
944         return _tokenApprovals[tokenId];
945     }
946 
947     /**
948      * @dev See {IERC721-setApprovalForAll}.
949      */
950     function setApprovalForAll(address operator, bool approved) public virtual override {
951         require(operator != _msgSender(), "ERC721: approve to caller");
952 
953         _operatorApprovals[_msgSender()][operator] = approved;
954         emit ApprovalForAll(_msgSender(), operator, approved);
955     }
956 
957     /**
958      * @dev See {IERC721-isApprovedForAll}.
959      */
960     function isApprovedForAll(address owner, address operator) public view virtual override returns (bool) {
961         return _operatorApprovals[owner][operator];
962     }
963 
964     /**
965      * @dev See {IERC721-transferFrom}.
966      */
967     function transferFrom(
968         address from,
969         address to,
970         uint256 tokenId
971     ) public virtual override {
972         //solhint-disable-next-line max-line-length
973         require(_isApprovedOrOwner(_msgSender(), tokenId), "ERC721: transfer caller is not owner nor approved");
974 
975         _transfer(from, to, tokenId);
976     }
977 
978     /**
979      * @dev See {IERC721-safeTransferFrom}.
980      */
981     function safeTransferFrom(
982         address from,
983         address to,
984         uint256 tokenId
985     ) public virtual override {
986         safeTransferFrom(from, to, tokenId, "");
987     }
988 
989     /**
990      * @dev See {IERC721-safeTransferFrom}.
991      */
992     function safeTransferFrom(
993         address from,
994         address to,
995         uint256 tokenId,
996         bytes memory _data
997     ) public virtual override {
998         require(_isApprovedOrOwner(_msgSender(), tokenId), "ERC721: transfer caller is not owner nor approved");
999         _safeTransfer(from, to, tokenId, _data);
1000     }
1001 
1002     /**
1003      * @dev Safely transfers `tokenId` token from `from` to `to`, checking first that contract recipients
1004      * are aware of the ERC721 protocol to prevent tokens from being forever locked.
1005      *
1006      * `_data` is additional data, it has no specified format and it is sent in call to `to`.
1007      *
1008      * This internal function is equivalent to {safeTransferFrom}, and can be used to e.g.
1009      * implement alternative mechanisms to perform token transfer, such as signature-based.
1010      *
1011      * Requirements:
1012      *
1013      * - `from` cannot be the zero address.
1014      * - `to` cannot be the zero address.
1015      * - `tokenId` token must exist and be owned by `from`.
1016      * - If `to` refers to a smart contract, it must implement {IERC721Receiver-onERC721Received}, which is called upon a safe transfer.
1017      *
1018      * Emits a {Transfer} event.
1019      */
1020     function _safeTransfer(
1021         address from,
1022         address to,
1023         uint256 tokenId,
1024         bytes memory _data
1025     ) internal virtual {
1026         _transfer(from, to, tokenId);
1027         require(_checkOnERC721Received(from, to, tokenId, _data), "ERC721: transfer to non ERC721Receiver implementer");
1028     }
1029 
1030     /**
1031      * @dev Returns whether `tokenId` exists.
1032      *
1033      * Tokens can be managed by their owner or approved accounts via {approve} or {setApprovalForAll}.
1034      *
1035      * Tokens start existing when they are minted (`_mint`),
1036      * and stop existing when they are burned (`_burn`).
1037      */
1038     function _exists(uint256 tokenId) internal view virtual returns (bool) {
1039         return _owners[tokenId] != address(0);
1040     }
1041 
1042     /**
1043      * @dev Returns whether `spender` is allowed to manage `tokenId`.
1044      *
1045      * Requirements:
1046      *
1047      * - `tokenId` must exist.
1048      */
1049     function _isApprovedOrOwner(address spender, uint256 tokenId) internal view virtual returns (bool) {
1050         require(_exists(tokenId), "ERC721: operator query for nonexistent token");
1051         address owner = ERC721.ownerOf(tokenId);
1052         return (spender == owner || getApproved(tokenId) == spender || isApprovedForAll(owner, spender));
1053     }
1054 
1055     /**
1056      * @dev Safely mints `tokenId` and transfers it to `to`.
1057      *
1058      * Requirements:
1059      *
1060      * - `tokenId` must not exist.
1061      * - If `to` refers to a smart contract, it must implement {IERC721Receiver-onERC721Received}, which is called upon a safe transfer.
1062      *
1063      * Emits a {Transfer} event.
1064      */
1065     function _safeMint(address to, uint256 tokenId) internal virtual {
1066         _safeMint(to, tokenId, "");
1067     }
1068 
1069     /**
1070      * @dev Same as {xref-ERC721-_safeMint-address-uint256-}[`_safeMint`], with an additional `data` parameter which is
1071      * forwarded in {IERC721Receiver-onERC721Received} to contract recipients.
1072      */
1073     function _safeMint(
1074         address to,
1075         uint256 tokenId,
1076         bytes memory _data
1077     ) internal virtual {
1078         _mint(to, tokenId);
1079         require(
1080             _checkOnERC721Received(address(0), to, tokenId, _data),
1081             "ERC721: transfer to non ERC721Receiver implementer"
1082         );
1083     }
1084 
1085     /**
1086      * @dev Mints `tokenId` and transfers it to `to`.
1087      *
1088      * WARNING: Usage of this method is discouraged, use {_safeMint} whenever possible
1089      *
1090      * Requirements:
1091      *
1092      * - `tokenId` must not exist.
1093      * - `to` cannot be the zero address.
1094      *
1095      * Emits a {Transfer} event.
1096      */
1097     function _mint(address to, uint256 tokenId) internal virtual {
1098         require(to != address(0), "ERC721: mint to the zero address");
1099         require(!_exists(tokenId), "ERC721: token already minted");
1100 
1101         _beforeTokenTransfer(address(0), to, tokenId);
1102 
1103         _balances[to] += 1;
1104         _owners[tokenId] = to;
1105 
1106         emit Transfer(address(0), to, tokenId);
1107     }
1108 
1109     /**
1110      * @dev Destroys `tokenId`.
1111      * The approval is cleared when the token is burned.
1112      *
1113      * Requirements:
1114      *
1115      * - `tokenId` must exist.
1116      *
1117      * Emits a {Transfer} event.
1118      */
1119     function _burn(uint256 tokenId) internal virtual {
1120         address owner = ERC721.ownerOf(tokenId);
1121 
1122         _beforeTokenTransfer(owner, address(0), tokenId);
1123 
1124         // Clear approvals
1125         _approve(address(0), tokenId);
1126 
1127         _balances[owner] -= 1;
1128         delete _owners[tokenId];
1129 
1130         emit Transfer(owner, address(0), tokenId);
1131     }
1132 
1133     /**
1134      * @dev Transfers `tokenId` from `from` to `to`.
1135      *  As opposed to {transferFrom}, this imposes no restrictions on msg.sender.
1136      *
1137      * Requirements:
1138      *
1139      * - `to` cannot be the zero address.
1140      * - `tokenId` token must be owned by `from`.
1141      *
1142      * Emits a {Transfer} event.
1143      */
1144     function _transfer(
1145         address from,
1146         address to,
1147         uint256 tokenId
1148     ) internal virtual {
1149         require(ERC721.ownerOf(tokenId) == from, "ERC721: transfer of token that is not own");
1150         require(to != address(0), "ERC721: transfer to the zero address");
1151 
1152         _beforeTokenTransfer(from, to, tokenId);
1153 
1154         // Clear approvals from the previous owner
1155         _approve(address(0), tokenId);
1156 
1157         _balances[from] -= 1;
1158         _balances[to] += 1;
1159         _owners[tokenId] = to;
1160 
1161         emit Transfer(from, to, tokenId);
1162     }
1163 
1164     /**
1165      * @dev Approve `to` to operate on `tokenId`
1166      *
1167      * Emits a {Approval} event.
1168      */
1169     function _approve(address to, uint256 tokenId) internal virtual {
1170         _tokenApprovals[tokenId] = to;
1171         emit Approval(ERC721.ownerOf(tokenId), to, tokenId);
1172     }
1173 
1174     /**
1175      * @dev Internal function to invoke {IERC721Receiver-onERC721Received} on a target address.
1176      * The call is not executed if the target address is not a contract.
1177      *
1178      * @param from address representing the previous owner of the given token ID
1179      * @param to target address that will receive the tokens
1180      * @param tokenId uint256 ID of the token to be transferred
1181      * @param _data bytes optional data to send along with the call
1182      * @return bool whether the call correctly returned the expected magic value
1183      */
1184     function _checkOnERC721Received(
1185         address from,
1186         address to,
1187         uint256 tokenId,
1188         bytes memory _data
1189     ) private returns (bool) {
1190         if (to.isContract()) {
1191             try IERC721Receiver(to).onERC721Received(_msgSender(), from, tokenId, _data) returns (bytes4 retval) {
1192                 return retval == IERC721Receiver.onERC721Received.selector;
1193             } catch (bytes memory reason) {
1194                 if (reason.length == 0) {
1195                     revert("ERC721: transfer to non ERC721Receiver implementer");
1196                 } else {
1197                     assembly {
1198                         revert(add(32, reason), mload(reason))
1199                     }
1200                 }
1201             }
1202         } else {
1203             return true;
1204         }
1205     }
1206 
1207     /**
1208      * @dev Hook that is called before any token transfer. This includes minting
1209      * and burning.
1210      *
1211      * Calling conditions:
1212      *
1213      * - When `from` and `to` are both non-zero, ``from``'s `tokenId` will be
1214      * transferred to `to`.
1215      * - When `from` is zero, `tokenId` will be minted for `to`.
1216      * - When `to` is zero, ``from``'s `tokenId` will be burned.
1217      * - `from` and `to` are never both zero.
1218      *
1219      * To learn more about hooks, head to xref:ROOT:extending-contracts.adoc#using-hooks[Using Hooks].
1220      */
1221     function _beforeTokenTransfer(
1222         address from,
1223         address to,
1224         uint256 tokenId
1225     ) internal virtual {}
1226 }
1227 
1228 // File: Aotaverse/Aotaverse.sol
1229 
1230 
1231 pragma solidity >=0.7.0 <0.9.0;
1232 
1233 contract Aotaverse is ERC721, Ownable, ReentrancyGuard {
1234     using Strings for uint256;
1235     using Counters for Counters.Counter;
1236 
1237     Counters.Counter private supply;
1238 
1239     string public uriPrefix = ""; 
1240     string public hiddenMetadataUri;
1241 
1242     uint256 private cost = 0.12 ether; 
1243     uint256 public maxSupply = 6666;         
1244     uint256 public softCap = 6397;         
1245     uint256 public constant maxMintAmountPerTx = 2;
1246     uint256 private mode = 1; 
1247 
1248     bool public paused = true; 
1249     bool public revealed = false;
1250 
1251     bytes32 public merkleRoot = 0x450a513e792e43fa592f74169e2a79a1ce5a08272c26f7f494e27e2d56d18d7d;
1252 
1253     mapping(address => uint256) public ClaimedWhitelist;
1254     mapping(address => uint256) public ClaimedMeka;
1255 
1256     address public immutable proxyRegistryAddress = address(0xa5409ec958C83C3f309868babACA7c86DCB077c1); 
1257     //Opensea Proxy Address: 0xa5409ec958C83C3f309868babACA7c86DCB077c1
1258 
1259     address private constant withdrawTo = 0xFe5c087fD87891cA23AB98904d65A92D15A07D45;
1260 
1261     constructor() ERC721("Aotaverse", "AOTA") ReentrancyGuard() {
1262         setHiddenMetadataUri("ipfs://Qmar3nffS1aMs1nsTg7J225WKVkenqfwYNLPF3MEEbUbxR/blind.json"); 
1263         supply.increment();
1264         _safeMint(msg.sender, supply.current()); 
1265     }
1266 
1267     //MODIFIERS
1268     modifier mintCompliance(uint256 _mintAmount) {
1269         require(_mintAmount > 0 && _mintAmount < maxMintAmountPerTx+1, "Invalid mint amount");
1270         require(supply.current() + _mintAmount < softCap+1, "Exceeds Soft Cap");
1271         _;
1272     }
1273 
1274     //MINT
1275     function mint(bytes32[] memory proof, uint256 _mintAmount) external payable mintCompliance(_mintAmount) nonReentrant {
1276         require(!paused, "The contract is paused!");
1277         require(msg.value > cost * _mintAmount - 1, "Insufficient funds");
1278         require(mode != 4, "Mode is post-sale");
1279         
1280         if(mode == 1) {
1281             require(ClaimedMeka[msg.sender] + _mintAmount < 3, "Exceeds meka allowance");
1282         }
1283         else if(mode == 2) {
1284             require(ClaimedWhitelist[msg.sender] + _mintAmount < 3, "Exceeds whitelist allowance");
1285         }
1286 
1287         if(mode != 3) {
1288             bytes32 leaf = keccak256(abi.encodePacked(msg.sender));
1289             require(MerkleProof.verify(proof, merkleRoot, leaf), "Verification failed");
1290         }  
1291 
1292         if (mode == 1) {
1293             ClaimedMeka[msg.sender] += _mintAmount;
1294         }
1295         else if(mode == 2) {
1296             ClaimedWhitelist[msg.sender] += _mintAmount;
1297         }
1298 
1299         _mintLoop(msg.sender, _mintAmount); 
1300     }
1301 
1302     function mintForAddress(uint256 _mintAmount, address _receiver) external onlyOwner nonReentrant { 
1303         require(mode == 4, "Mode is not post-sale");
1304         require(supply.current() + _mintAmount < maxSupply + 1);
1305         _mintLoop(_receiver, _mintAmount);
1306     }
1307 
1308     //VIEWS
1309     function walletOfOwner(address _owner) external view returns (uint256[] memory) { 
1310         uint256 ownerTokenCount = balanceOf(_owner);
1311         uint256[] memory ownedTokenIds = new uint256[](ownerTokenCount);
1312         uint256 currentTokenId = 1;
1313         uint256 ownedTokenIndex = 0;
1314 
1315         while (ownedTokenIndex < ownerTokenCount && currentTokenId <= maxSupply) {
1316             address currentTokenOwner = ownerOf(currentTokenId);
1317 
1318             if (currentTokenOwner == _owner) {
1319                 ownedTokenIds[ownedTokenIndex] = currentTokenId;
1320                 ownedTokenIndex++;
1321             }
1322             currentTokenId++;
1323         }
1324         return ownedTokenIds;
1325     }
1326 
1327     function tokenURI(uint256 _tokenId) public view virtual override returns (string memory) { 
1328         require(_exists(_tokenId), "ERC721Metadata: URI query for nonexistent token");
1329 
1330         if (revealed == false) {
1331             return hiddenMetadataUri;
1332         }
1333 
1334         return bytes(uriPrefix).length > 0
1335             ? string(abi.encodePacked(uriPrefix, _tokenId.toString(), ".json"))
1336             : "";
1337     }
1338 
1339     function totalSupply() external view returns (uint256) { 
1340         return supply.current();
1341     }
1342 
1343     function getMode() external view returns (uint256) { 
1344         return mode;
1345     }
1346 
1347     function getCost() external view returns (uint256) { 
1348         return cost;
1349     }
1350 
1351     //ONLY OWNER SET
1352     function setMaxSupply(uint256 _MS) external onlyOwner { 
1353         require(_MS > maxSupply, "New MS below previous MS");
1354         maxSupply = _MS;
1355     }
1356 
1357     function setSoftCap(uint256 _SC) external onlyOwner {
1358         require(_SC > softCap, "New SC below previous SC");
1359         softCap = _SC;
1360     }
1361 
1362     function togglemode() external onlyOwner { 
1363         if(mode == 1) {
1364             mode = 2;
1365             cost = 0.15 ether;
1366             merkleRoot = 0x9cda0a83c7fb86bd9c2b6808e91d8320854e7951a44376f6351087a304d4851b;
1367         }
1368         else if(mode == 2) {
1369             mode = 3;
1370             cost = 0.2 ether;
1371             merkleRoot = bytes32(0x00);
1372         }
1373         else if (mode == 3) {
1374             mode = 4; 
1375             cost = 0 ether;
1376         }
1377         else {
1378             mode = 1;
1379             cost = 0.12 ether;
1380         }
1381     }
1382     
1383     function setRevealed(bool _state) external onlyOwner { 
1384         revealed = _state;
1385     }
1386 
1387     function setCost(uint256 _newCost) external onlyOwner { 
1388         require(_newCost > 0);
1389         cost = _newCost;
1390     }
1391 
1392     function setHiddenMetadataUri(string memory _hiddenMetadataUri) public onlyOwner {
1393         hiddenMetadataUri = _hiddenMetadataUri;
1394     }
1395 
1396     function setUriPrefix(string memory _uriPrefix) external onlyOwner { 
1397         uriPrefix = _uriPrefix;
1398     }
1399 
1400     function setPaused(bool _state) external onlyOwner { 
1401         paused = _state;
1402     }
1403 
1404     function _mintLoop(address _receiver, uint256 _mintAmount) internal { 
1405         for (uint256 i = 0; i < _mintAmount; i++) {
1406             supply.increment();
1407             _safeMint(_receiver, supply.current());
1408         }
1409     }
1410 
1411     function withdraw() external payable onlyOwner { 
1412         (bool os, ) = payable(withdrawTo).call{value: address(this).balance}("");
1413         require(os);
1414     }
1415 
1416     function isApprovedForAll(address _owner, address operator) public view override returns (bool) {
1417         OpenSeaProxyRegistry proxyRegistry = OpenSeaProxyRegistry(proxyRegistryAddress);
1418         if(address(proxyRegistry.proxies(_owner)) == operator) {
1419             return true;
1420         }
1421         return super.isApprovedForAll(_owner, operator);
1422     }
1423 
1424 }
1425 
1426 contract OwnableDelegateProxy {}
1427 contract OpenSeaProxyRegistry {
1428     mapping(address => OwnableDelegateProxy) public proxies;
1429 }