1 // SPDX-License-Identifier: MIT
2 
3 // File: @openzeppelin/contracts/utils/Counters.sol
4 
5 
6 // OpenZeppelin Contracts v4.4.1 (utils/Counters.sol)
7 
8 pragma solidity ^0.8.0;
9 
10 /**
11  * @title Counters
12  * @author Matt Condon (@shrugs)
13  * @dev Provides counters that can only be incremented, decremented or reset. This can be used e.g. to track the number
14  * of elements in a mapping, issuing ERC721 ids, or counting request ids.
15  *
16  * Include with `using Counters for Counters.Counter;`
17  */
18 library Counters {
19     struct Counter {
20         // This variable should never be directly accessed by users of the library: interactions must be restricted to
21         // the library's function. As of Solidity v0.5.2, this cannot be enforced, though there is a proposal to add
22         // this feature: see https://github.com/ethereum/solidity/issues/4637
23         uint256 _value; // default: 0
24     }
25 
26     function current(Counter storage counter) internal view returns (uint256) {
27         return counter._value;
28     }
29 
30     function increment(Counter storage counter) internal {
31         unchecked {
32             counter._value += 1;
33         }
34     }
35 
36     function decrement(Counter storage counter) internal {
37         uint256 value = counter._value;
38         require(value > 0, "Counter: decrement overflow");
39         unchecked {
40             counter._value = value - 1;
41         }
42     }
43 
44     function reset(Counter storage counter) internal {
45         counter._value = 0;
46     }
47 }
48 
49 // File: @openzeppelin/contracts/utils/cryptography/MerkleProof.sol
50 
51 
52 // OpenZeppelin Contracts (last updated v4.5.0) (utils/cryptography/MerkleProof.sol)
53 
54 pragma solidity ^0.8.0;
55 
56 /**
57  * @dev These functions deal with verification of Merkle Trees proofs.
58  *
59  * The proofs can be generated using the JavaScript library
60  * https://github.com/miguelmota/merkletreejs[merkletreejs].
61  * Note: the hashing algorithm should be keccak256 and pair sorting should be enabled.
62  *
63  * See `test/utils/cryptography/MerkleProof.test.js` for some examples.
64  */
65 library MerkleProof {
66     /**
67      * @dev Returns true if a `leaf` can be proved to be a part of a Merkle tree
68      * defined by `root`. For this, a `proof` must be provided, containing
69      * sibling hashes on the branch from the leaf to the root of the tree. Each
70      * pair of leaves and each pair of pre-images are assumed to be sorted.
71      */
72     function verify(
73         bytes32[] memory proof,
74         bytes32 root,
75         bytes32 leaf
76     ) internal pure returns (bool) {
77         return processProof(proof, leaf) == root;
78     }
79 
80     /**
81      * @dev Returns the rebuilt hash obtained by traversing a Merklee tree up
82      * from `leaf` using `proof`. A `proof` is valid if and only if the rebuilt
83      * hash matches the root of the tree. When processing the proof, the pairs
84      * of leafs & pre-images are assumed to be sorted.
85      *
86      * _Available since v4.4._
87      */
88     function processProof(bytes32[] memory proof, bytes32 leaf) internal pure returns (bytes32) {
89         bytes32 computedHash = leaf;
90         for (uint256 i = 0; i < proof.length; i++) {
91             bytes32 proofElement = proof[i];
92             if (computedHash <= proofElement) {
93                 // Hash(current computed hash + current element of the proof)
94                 computedHash = _efficientHash(computedHash, proofElement);
95             } else {
96                 // Hash(current element of the proof + current computed hash)
97                 computedHash = _efficientHash(proofElement, computedHash);
98             }
99         }
100         return computedHash;
101     }
102 
103     function _efficientHash(bytes32 a, bytes32 b) private pure returns (bytes32 value) {
104         assembly {
105             mstore(0x00, a)
106             mstore(0x20, b)
107             value := keccak256(0x00, 0x40)
108         }
109     }
110 }
111 
112 // File: @openzeppelin/contracts/security/ReentrancyGuard.sol
113 
114 
115 // OpenZeppelin Contracts v4.4.1 (security/ReentrancyGuard.sol)
116 
117 pragma solidity ^0.8.0;
118 
119 /**
120  * @dev Contract module that helps prevent reentrant calls to a function.
121  *
122  * Inheriting from `ReentrancyGuard` will make the {nonReentrant} modifier
123  * available, which can be applied to functions to make sure there are no nested
124  * (reentrant) calls to them.
125  *
126  * Note that because there is a single `nonReentrant` guard, functions marked as
127  * `nonReentrant` may not call one another. This can be worked around by making
128  * those functions `private`, and then adding `external` `nonReentrant` entry
129  * points to them.
130  *
131  * TIP: If you would like to learn more about reentrancy and alternative ways
132  * to protect against it, check out our blog post
133  * https://blog.openzeppelin.com/reentrancy-after-istanbul/[Reentrancy After Istanbul].
134  */
135 abstract contract ReentrancyGuard {
136     // Booleans are more expensive than uint256 or any type that takes up a full
137     // word because each write operation emits an extra SLOAD to first read the
138     // slot's contents, replace the bits taken up by the boolean, and then write
139     // back. This is the compiler's defense against contract upgrades and
140     // pointer aliasing, and it cannot be disabled.
141 
142     // The values being non-zero value makes deployment a bit more expensive,
143     // but in exchange the refund on every call to nonReentrant will be lower in
144     // amount. Since refunds are capped to a percentage of the total
145     // transaction's gas, it is best to keep them low in cases like this one, to
146     // increase the likelihood of the full refund coming into effect.
147     uint256 private constant _NOT_ENTERED = 1;
148     uint256 private constant _ENTERED = 2;
149 
150     uint256 private _status;
151 
152     constructor() {
153         _status = _NOT_ENTERED;
154     }
155 
156     /**
157      * @dev Prevents a contract from calling itself, directly or indirectly.
158      * Calling a `nonReentrant` function from another `nonReentrant`
159      * function is not supported. It is possible to prevent this from happening
160      * by making the `nonReentrant` function external, and making it call a
161      * `private` function that does the actual work.
162      */
163     modifier nonReentrant() {
164         // On the first call to nonReentrant, _notEntered will be true
165         require(_status != _ENTERED, "ReentrancyGuard: reentrant call");
166 
167         // Any calls to nonReentrant after this point will fail
168         _status = _ENTERED;
169 
170         _;
171 
172         // By storing the original value once again, a refund is triggered (see
173         // https://eips.ethereum.org/EIPS/eip-2200)
174         _status = _NOT_ENTERED;
175     }
176 }
177 
178 // File: @openzeppelin/contracts/utils/Context.sol
179 
180 
181 // OpenZeppelin Contracts v4.4.1 (utils/Context.sol)
182 
183 pragma solidity ^0.8.0;
184 
185 /**
186  * @dev Provides information about the current execution context, including the
187  * sender of the transaction and its data. While these are generally available
188  * via msg.sender and msg.data, they should not be accessed in such a direct
189  * manner, since when dealing with meta-transactions the account sending and
190  * paying for execution may not be the actual sender (as far as an application
191  * is concerned).
192  *
193  * This contract is only required for intermediate, library-like contracts.
194  */
195 abstract contract Context {
196     function _msgSender() internal view virtual returns (address) {
197         return msg.sender;
198     }
199 
200     function _msgData() internal view virtual returns (bytes calldata) {
201         return msg.data;
202     }
203 }
204 
205 // File: @openzeppelin/contracts/access/Ownable.sol
206 
207 
208 // OpenZeppelin Contracts v4.4.1 (access/Ownable.sol)
209 
210 pragma solidity ^0.8.0;
211 
212 
213 /**
214  * @dev Contract module which provides a basic access control mechanism, where
215  * there is an account (an owner) that can be granted exclusive access to
216  * specific functions.
217  *
218  * By default, the owner account will be the one that deploys the contract. This
219  * can later be changed with {transferOwnership}.
220  *
221  * This module is used through inheritance. It will make available the modifier
222  * `onlyOwner`, which can be applied to your functions to restrict their use to
223  * the owner.
224  */
225 abstract contract Ownable is Context {
226     address private _owner;
227 
228     event OwnershipTransferred(address indexed previousOwner, address indexed newOwner);
229 
230     /**
231      * @dev Initializes the contract setting the deployer as the initial owner.
232      */
233     constructor() {
234         _transferOwnership(_msgSender());
235     }
236 
237     /**
238      * @dev Returns the address of the current owner.
239      */
240     function owner() public view virtual returns (address) {
241         return _owner;
242     }
243 
244     /**
245      * @dev Throws if called by any account other than the owner.
246      */
247     modifier onlyOwner() {
248         require(owner() == _msgSender(), "Ownable: caller is not the owner");
249         _;
250     }
251 
252     /**
253      * @dev Leaves the contract without owner. It will not be possible to call
254      * `onlyOwner` functions anymore. Can only be called by the current owner.
255      *
256      * NOTE: Renouncing ownership will leave the contract without an owner,
257      * thereby removing any functionality that is only available to the owner.
258      */
259     function renounceOwnership() public virtual onlyOwner {
260         _transferOwnership(address(0));
261     }
262 
263     /**
264      * @dev Transfers ownership of the contract to a new account (`newOwner`).
265      * Can only be called by the current owner.
266      */
267     function transferOwnership(address newOwner) public virtual onlyOwner {
268         require(newOwner != address(0), "Ownable: new owner is the zero address");
269         _transferOwnership(newOwner);
270     }
271 
272     /**
273      * @dev Transfers ownership of the contract to a new account (`newOwner`).
274      * Internal function without access restriction.
275      */
276     function _transferOwnership(address newOwner) internal virtual {
277         address oldOwner = _owner;
278         _owner = newOwner;
279         emit OwnershipTransferred(oldOwner, newOwner);
280     }
281 }
282 
283 // File: @openzeppelin/contracts/utils/Address.sol
284 
285 
286 // OpenZeppelin Contracts (last updated v4.5.0) (utils/Address.sol)
287 
288 pragma solidity ^0.8.1;
289 
290 /**
291  * @dev Collection of functions related to the address type
292  */
293 library Address {
294     /**
295      * @dev Returns true if `account` is a contract.
296      *
297      * [IMPORTANT]
298      * ====
299      * It is unsafe to assume that an address for which this function returns
300      * false is an externally-owned account (EOA) and not a contract.
301      *
302      * Among others, `isContract` will return false for the following
303      * types of addresses:
304      *
305      *  - an externally-owned account
306      *  - a contract in construction
307      *  - an address where a contract will be created
308      *  - an address where a contract lived, but was destroyed
309      * ====
310      *
311      * [IMPORTANT]
312      * ====
313      * You shouldn't rely on `isContract` to protect against flash loan attacks!
314      *
315      * Preventing calls from contracts is highly discouraged. It breaks composability, breaks support for smart wallets
316      * like Gnosis Safe, and does not provide security since it can be circumvented by calling from a contract
317      * constructor.
318      * ====
319      */
320     function isContract(address account) internal view returns (bool) {
321         // This method relies on extcodesize/address.code.length, which returns 0
322         // for contracts in construction, since the code is only stored at the end
323         // of the constructor execution.
324 
325         return account.code.length > 0;
326     }
327 
328     /**
329      * @dev Replacement for Solidity's `transfer`: sends `amount` wei to
330      * `recipient`, forwarding all available gas and reverting on errors.
331      *
332      * https://eips.ethereum.org/EIPS/eip-1884[EIP1884] increases the gas cost
333      * of certain opcodes, possibly making contracts go over the 2300 gas limit
334      * imposed by `transfer`, making them unable to receive funds via
335      * `transfer`. {sendValue} removes this limitation.
336      *
337      * https://diligence.consensys.net/posts/2019/09/stop-using-soliditys-transfer-now/[Learn more].
338      *
339      * IMPORTANT: because control is transferred to `recipient`, care must be
340      * taken to not create reentrancy vulnerabilities. Consider using
341      * {ReentrancyGuard} or the
342      * https://solidity.readthedocs.io/en/v0.5.11/security-considerations.html#use-the-checks-effects-interactions-pattern[checks-effects-interactions pattern].
343      */
344     function sendValue(address payable recipient, uint256 amount) internal {
345         require(address(this).balance >= amount, "Address: insufficient balance");
346 
347         (bool success, ) = recipient.call{value: amount}("");
348         require(success, "Address: unable to send value, recipient may have reverted");
349     }
350 
351     /**
352      * @dev Performs a Solidity function call using a low level `call`. A
353      * plain `call` is an unsafe replacement for a function call: use this
354      * function instead.
355      *
356      * If `target` reverts with a revert reason, it is bubbled up by this
357      * function (like regular Solidity function calls).
358      *
359      * Returns the raw returned data. To convert to the expected return value,
360      * use https://solidity.readthedocs.io/en/latest/units-and-global-variables.html?highlight=abi.decode#abi-encoding-and-decoding-functions[`abi.decode`].
361      *
362      * Requirements:
363      *
364      * - `target` must be a contract.
365      * - calling `target` with `data` must not revert.
366      *
367      * _Available since v3.1._
368      */
369     function functionCall(address target, bytes memory data) internal returns (bytes memory) {
370         return functionCall(target, data, "Address: low-level call failed");
371     }
372 
373     /**
374      * @dev Same as {xref-Address-functionCall-address-bytes-}[`functionCall`], but with
375      * `errorMessage` as a fallback revert reason when `target` reverts.
376      *
377      * _Available since v3.1._
378      */
379     function functionCall(
380         address target,
381         bytes memory data,
382         string memory errorMessage
383     ) internal returns (bytes memory) {
384         return functionCallWithValue(target, data, 0, errorMessage);
385     }
386 
387     /**
388      * @dev Same as {xref-Address-functionCall-address-bytes-}[`functionCall`],
389      * but also transferring `value` wei to `target`.
390      *
391      * Requirements:
392      *
393      * - the calling contract must have an ETH balance of at least `value`.
394      * - the called Solidity function must be `payable`.
395      *
396      * _Available since v3.1._
397      */
398     function functionCallWithValue(
399         address target,
400         bytes memory data,
401         uint256 value
402     ) internal returns (bytes memory) {
403         return functionCallWithValue(target, data, value, "Address: low-level call with value failed");
404     }
405 
406     /**
407      * @dev Same as {xref-Address-functionCallWithValue-address-bytes-uint256-}[`functionCallWithValue`], but
408      * with `errorMessage` as a fallback revert reason when `target` reverts.
409      *
410      * _Available since v3.1._
411      */
412     function functionCallWithValue(
413         address target,
414         bytes memory data,
415         uint256 value,
416         string memory errorMessage
417     ) internal returns (bytes memory) {
418         require(address(this).balance >= value, "Address: insufficient balance for call");
419         require(isContract(target), "Address: call to non-contract");
420 
421         (bool success, bytes memory returndata) = target.call{value: value}(data);
422         return verifyCallResult(success, returndata, errorMessage);
423     }
424 
425     /**
426      * @dev Same as {xref-Address-functionCall-address-bytes-}[`functionCall`],
427      * but performing a static call.
428      *
429      * _Available since v3.3._
430      */
431     function functionStaticCall(address target, bytes memory data) internal view returns (bytes memory) {
432         return functionStaticCall(target, data, "Address: low-level static call failed");
433     }
434 
435     /**
436      * @dev Same as {xref-Address-functionCall-address-bytes-string-}[`functionCall`],
437      * but performing a static call.
438      *
439      * _Available since v3.3._
440      */
441     function functionStaticCall(
442         address target,
443         bytes memory data,
444         string memory errorMessage
445     ) internal view returns (bytes memory) {
446         require(isContract(target), "Address: static call to non-contract");
447 
448         (bool success, bytes memory returndata) = target.staticcall(data);
449         return verifyCallResult(success, returndata, errorMessage);
450     }
451 
452     /**
453      * @dev Same as {xref-Address-functionCall-address-bytes-}[`functionCall`],
454      * but performing a delegate call.
455      *
456      * _Available since v3.4._
457      */
458     function functionDelegateCall(address target, bytes memory data) internal returns (bytes memory) {
459         return functionDelegateCall(target, data, "Address: low-level delegate call failed");
460     }
461 
462     /**
463      * @dev Same as {xref-Address-functionCall-address-bytes-string-}[`functionCall`],
464      * but performing a delegate call.
465      *
466      * _Available since v3.4._
467      */
468     function functionDelegateCall(
469         address target,
470         bytes memory data,
471         string memory errorMessage
472     ) internal returns (bytes memory) {
473         require(isContract(target), "Address: delegate call to non-contract");
474 
475         (bool success, bytes memory returndata) = target.delegatecall(data);
476         return verifyCallResult(success, returndata, errorMessage);
477     }
478 
479     /**
480      * @dev Tool to verifies that a low level call was successful, and revert if it wasn't, either by bubbling the
481      * revert reason using the provided one.
482      *
483      * _Available since v4.3._
484      */
485     function verifyCallResult(
486         bool success,
487         bytes memory returndata,
488         string memory errorMessage
489     ) internal pure returns (bytes memory) {
490         if (success) {
491             return returndata;
492         } else {
493             // Look for revert reason and bubble it up if present
494             if (returndata.length > 0) {
495                 // The easiest way to bubble the revert reason is using memory via assembly
496 
497                 assembly {
498                     let returndata_size := mload(returndata)
499                     revert(add(32, returndata), returndata_size)
500                 }
501             } else {
502                 revert(errorMessage);
503             }
504         }
505     }
506 }
507 
508 // File: @openzeppelin/contracts/token/ERC721/IERC721Receiver.sol
509 
510 
511 // OpenZeppelin Contracts v4.4.1 (token/ERC721/IERC721Receiver.sol)
512 
513 pragma solidity ^0.8.0;
514 
515 /**
516  * @title ERC721 token receiver interface
517  * @dev Interface for any contract that wants to support safeTransfers
518  * from ERC721 asset contracts.
519  */
520 interface IERC721Receiver {
521     /**
522      * @dev Whenever an {IERC721} `tokenId` token is transferred to this contract via {IERC721-safeTransferFrom}
523      * by `operator` from `from`, this function is called.
524      *
525      * It must return its Solidity selector to confirm the token transfer.
526      * If any other value is returned or the interface is not implemented by the recipient, the transfer will be reverted.
527      *
528      * The selector can be obtained in Solidity with `IERC721.onERC721Received.selector`.
529      */
530     function onERC721Received(
531         address operator,
532         address from,
533         uint256 tokenId,
534         bytes calldata data
535     ) external returns (bytes4);
536 }
537 
538 // File: @openzeppelin/contracts/utils/introspection/IERC165.sol
539 
540 
541 // OpenZeppelin Contracts v4.4.1 (utils/introspection/IERC165.sol)
542 
543 pragma solidity ^0.8.0;
544 
545 /**
546  * @dev Interface of the ERC165 standard, as defined in the
547  * https://eips.ethereum.org/EIPS/eip-165[EIP].
548  *
549  * Implementers can declare support of contract interfaces, which can then be
550  * queried by others ({ERC165Checker}).
551  *
552  * For an implementation, see {ERC165}.
553  */
554 interface IERC165 {
555     /**
556      * @dev Returns true if this contract implements the interface defined by
557      * `interfaceId`. See the corresponding
558      * https://eips.ethereum.org/EIPS/eip-165#how-interfaces-are-identified[EIP section]
559      * to learn more about how these ids are created.
560      *
561      * This function call must use less than 30 000 gas.
562      */
563     function supportsInterface(bytes4 interfaceId) external view returns (bool);
564 }
565 
566 // File: @openzeppelin/contracts/utils/introspection/ERC165.sol
567 
568 
569 // OpenZeppelin Contracts v4.4.1 (utils/introspection/ERC165.sol)
570 
571 pragma solidity ^0.8.0;
572 
573 
574 /**
575  * @dev Implementation of the {IERC165} interface.
576  *
577  * Contracts that want to implement ERC165 should inherit from this contract and override {supportsInterface} to check
578  * for the additional interface id that will be supported. For example:
579  *
580  * ```solidity
581  * function supportsInterface(bytes4 interfaceId) public view virtual override returns (bool) {
582  *     return interfaceId == type(MyInterface).interfaceId || super.supportsInterface(interfaceId);
583  * }
584  * ```
585  *
586  * Alternatively, {ERC165Storage} provides an easier to use but more expensive implementation.
587  */
588 abstract contract ERC165 is IERC165 {
589     /**
590      * @dev See {IERC165-supportsInterface}.
591      */
592     function supportsInterface(bytes4 interfaceId) public view virtual override returns (bool) {
593         return interfaceId == type(IERC165).interfaceId;
594     }
595 }
596 
597 // File: @openzeppelin/contracts/token/ERC721/IERC721.sol
598 
599 
600 // OpenZeppelin Contracts v4.4.1 (token/ERC721/IERC721.sol)
601 
602 pragma solidity ^0.8.0;
603 
604 
605 /**
606  * @dev Required interface of an ERC721 compliant contract.
607  */
608 interface IERC721 is IERC165 {
609     /**
610      * @dev Emitted when `tokenId` token is transferred from `from` to `to`.
611      */
612     event Transfer(address indexed from, address indexed to, uint256 indexed tokenId);
613 
614     /**
615      * @dev Emitted when `owner` enables `approved` to manage the `tokenId` token.
616      */
617     event Approval(address indexed owner, address indexed approved, uint256 indexed tokenId);
618 
619     /**
620      * @dev Emitted when `owner` enables or disables (`approved`) `operator` to manage all of its assets.
621      */
622     event ApprovalForAll(address indexed owner, address indexed operator, bool approved);
623 
624     /**
625      * @dev Returns the number of tokens in ``owner``'s account.
626      */
627     function balanceOf(address owner) external view returns (uint256 balance);
628 
629     /**
630      * @dev Returns the owner of the `tokenId` token.
631      *
632      * Requirements:
633      *
634      * - `tokenId` must exist.
635      */
636     function ownerOf(uint256 tokenId) external view returns (address owner);
637 
638     /**
639      * @dev Safely transfers `tokenId` token from `from` to `to`, checking first that contract recipients
640      * are aware of the ERC721 protocol to prevent tokens from being forever locked.
641      *
642      * Requirements:
643      *
644      * - `from` cannot be the zero address.
645      * - `to` cannot be the zero address.
646      * - `tokenId` token must exist and be owned by `from`.
647      * - If the caller is not `from`, it must be have been allowed to move this token by either {approve} or {setApprovalForAll}.
648      * - If `to` refers to a smart contract, it must implement {IERC721Receiver-onERC721Received}, which is called upon a safe transfer.
649      *
650      * Emits a {Transfer} event.
651      */
652     function safeTransferFrom(
653         address from,
654         address to,
655         uint256 tokenId
656     ) external;
657 
658     /**
659      * @dev Transfers `tokenId` token from `from` to `to`.
660      *
661      * WARNING: Usage of this method is discouraged, use {safeTransferFrom} whenever possible.
662      *
663      * Requirements:
664      *
665      * - `from` cannot be the zero address.
666      * - `to` cannot be the zero address.
667      * - `tokenId` token must be owned by `from`.
668      * - If the caller is not `from`, it must be approved to move this token by either {approve} or {setApprovalForAll}.
669      *
670      * Emits a {Transfer} event.
671      */
672     function transferFrom(
673         address from,
674         address to,
675         uint256 tokenId
676     ) external;
677 
678     /**
679      * @dev Gives permission to `to` to transfer `tokenId` token to another account.
680      * The approval is cleared when the token is transferred.
681      *
682      * Only a single account can be approved at a time, so approving the zero address clears previous approvals.
683      *
684      * Requirements:
685      *
686      * - The caller must own the token or be an approved operator.
687      * - `tokenId` must exist.
688      *
689      * Emits an {Approval} event.
690      */
691     function approve(address to, uint256 tokenId) external;
692 
693     /**
694      * @dev Returns the account approved for `tokenId` token.
695      *
696      * Requirements:
697      *
698      * - `tokenId` must exist.
699      */
700     function getApproved(uint256 tokenId) external view returns (address operator);
701 
702     /**
703      * @dev Approve or remove `operator` as an operator for the caller.
704      * Operators can call {transferFrom} or {safeTransferFrom} for any token owned by the caller.
705      *
706      * Requirements:
707      *
708      * - The `operator` cannot be the caller.
709      *
710      * Emits an {ApprovalForAll} event.
711      */
712     function setApprovalForAll(address operator, bool _approved) external;
713 
714     /**
715      * @dev Returns if the `operator` is allowed to manage all of the assets of `owner`.
716      *
717      * See {setApprovalForAll}
718      */
719     function isApprovedForAll(address owner, address operator) external view returns (bool);
720 
721     /**
722      * @dev Safely transfers `tokenId` token from `from` to `to`.
723      *
724      * Requirements:
725      *
726      * - `from` cannot be the zero address.
727      * - `to` cannot be the zero address.
728      * - `tokenId` token must exist and be owned by `from`.
729      * - If the caller is not `from`, it must be approved to move this token by either {approve} or {setApprovalForAll}.
730      * - If `to` refers to a smart contract, it must implement {IERC721Receiver-onERC721Received}, which is called upon a safe transfer.
731      *
732      * Emits a {Transfer} event.
733      */
734     function safeTransferFrom(
735         address from,
736         address to,
737         uint256 tokenId,
738         bytes calldata data
739     ) external;
740 }
741 
742 // File: @openzeppelin/contracts/token/ERC721/extensions/IERC721Metadata.sol
743 
744 
745 // OpenZeppelin Contracts v4.4.1 (token/ERC721/extensions/IERC721Metadata.sol)
746 
747 pragma solidity ^0.8.0;
748 
749 
750 /**
751  * @title ERC-721 Non-Fungible Token Standard, optional metadata extension
752  * @dev See https://eips.ethereum.org/EIPS/eip-721
753  */
754 interface IERC721Metadata is IERC721 {
755     /**
756      * @dev Returns the token collection name.
757      */
758     function name() external view returns (string memory);
759 
760     /**
761      * @dev Returns the token collection symbol.
762      */
763     function symbol() external view returns (string memory);
764 
765     /**
766      * @dev Returns the Uniform Resource Identifier (URI) for `tokenId` token.
767      */
768     function tokenURI(uint256 tokenId) external view returns (string memory);
769 }
770 
771 // File: @openzeppelin/contracts/utils/Strings.sol
772 
773 
774 // OpenZeppelin Contracts v4.4.1 (utils/Strings.sol)
775 
776 pragma solidity ^0.8.0;
777 
778 /**
779  * @dev String operations.
780  */
781 library Strings {
782     bytes16 private constant _HEX_SYMBOLS = "0123456789abcdef";
783 
784     /**
785      * @dev Converts a `uint256` to its ASCII `string` decimal representation.
786      */
787     function toString(uint256 value) internal pure returns (string memory) {
788         // Inspired by OraclizeAPI's implementation - MIT licence
789         // https://github.com/oraclize/ethereum-api/blob/b42146b063c7d6ee1358846c198246239e9360e8/oraclizeAPI_0.4.25.sol
790 
791         if (value == 0) {
792             return "0";
793         }
794         uint256 temp = value;
795         uint256 digits;
796         while (temp != 0) {
797             digits++;
798             temp /= 10;
799         }
800         bytes memory buffer = new bytes(digits);
801         while (value != 0) {
802             digits -= 1;
803             buffer[digits] = bytes1(uint8(48 + uint256(value % 10)));
804             value /= 10;
805         }
806         return string(buffer);
807     }
808 
809     /**
810      * @dev Converts a `uint256` to its ASCII `string` hexadecimal representation.
811      */
812     function toHexString(uint256 value) internal pure returns (string memory) {
813         if (value == 0) {
814             return "0x00";
815         }
816         uint256 temp = value;
817         uint256 length = 0;
818         while (temp != 0) {
819             length++;
820             temp >>= 8;
821         }
822         return toHexString(value, length);
823     }
824 
825     /**
826      * @dev Converts a `uint256` to its ASCII `string` hexadecimal representation with fixed length.
827      */
828     function toHexString(uint256 value, uint256 length) internal pure returns (string memory) {
829         bytes memory buffer = new bytes(2 * length + 2);
830         buffer[0] = "0";
831         buffer[1] = "x";
832         for (uint256 i = 2 * length + 1; i > 1; --i) {
833             buffer[i] = _HEX_SYMBOLS[value & 0xf];
834             value >>= 4;
835         }
836         require(value == 0, "Strings: hex length insufficient");
837         return string(buffer);
838     }
839 }
840 
841 // File: @openzeppelin/contracts/token/ERC721/ERC721.sol
842 
843 
844 // OpenZeppelin Contracts (last updated v4.5.0) (token/ERC721/ERC721.sol)
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
978         _setApprovalForAll(_msgSender(), operator, approved);
979     }
980 
981     /**
982      * @dev See {IERC721-isApprovedForAll}.
983      */
984     function isApprovedForAll(address owner, address operator) public view virtual override returns (bool) {
985         return _operatorApprovals[owner][operator];
986     }
987 
988     /**
989      * @dev See {IERC721-transferFrom}.
990      */
991     function transferFrom(
992         address from,
993         address to,
994         uint256 tokenId
995     ) public virtual override {
996         //solhint-disable-next-line max-line-length
997         require(_isApprovedOrOwner(_msgSender(), tokenId), "ERC721: transfer caller is not owner nor approved");
998 
999         _transfer(from, to, tokenId);
1000     }
1001 
1002     /**
1003      * @dev See {IERC721-safeTransferFrom}.
1004      */
1005     function safeTransferFrom(
1006         address from,
1007         address to,
1008         uint256 tokenId
1009     ) public virtual override {
1010         safeTransferFrom(from, to, tokenId, "");
1011     }
1012 
1013     /**
1014      * @dev See {IERC721-safeTransferFrom}.
1015      */
1016     function safeTransferFrom(
1017         address from,
1018         address to,
1019         uint256 tokenId,
1020         bytes memory _data
1021     ) public virtual override {
1022         require(_isApprovedOrOwner(_msgSender(), tokenId), "ERC721: transfer caller is not owner nor approved");
1023         _safeTransfer(from, to, tokenId, _data);
1024     }
1025 
1026     /**
1027      * @dev Safely transfers `tokenId` token from `from` to `to`, checking first that contract recipients
1028      * are aware of the ERC721 protocol to prevent tokens from being forever locked.
1029      *
1030      * `_data` is additional data, it has no specified format and it is sent in call to `to`.
1031      *
1032      * This internal function is equivalent to {safeTransferFrom}, and can be used to e.g.
1033      * implement alternative mechanisms to perform token transfer, such as signature-based.
1034      *
1035      * Requirements:
1036      *
1037      * - `from` cannot be the zero address.
1038      * - `to` cannot be the zero address.
1039      * - `tokenId` token must exist and be owned by `from`.
1040      * - If `to` refers to a smart contract, it must implement {IERC721Receiver-onERC721Received}, which is called upon a safe transfer.
1041      *
1042      * Emits a {Transfer} event.
1043      */
1044     function _safeTransfer(
1045         address from,
1046         address to,
1047         uint256 tokenId,
1048         bytes memory _data
1049     ) internal virtual {
1050         _transfer(from, to, tokenId);
1051         require(_checkOnERC721Received(from, to, tokenId, _data), "ERC721: transfer to non ERC721Receiver implementer");
1052     }
1053 
1054     /**
1055      * @dev Returns whether `tokenId` exists.
1056      *
1057      * Tokens can be managed by their owner or approved accounts via {approve} or {setApprovalForAll}.
1058      *
1059      * Tokens start existing when they are minted (`_mint`),
1060      * and stop existing when they are burned (`_burn`).
1061      */
1062     function _exists(uint256 tokenId) internal view virtual returns (bool) {
1063         return _owners[tokenId] != address(0);
1064     }
1065 
1066     /**
1067      * @dev Returns whether `spender` is allowed to manage `tokenId`.
1068      *
1069      * Requirements:
1070      *
1071      * - `tokenId` must exist.
1072      */
1073     function _isApprovedOrOwner(address spender, uint256 tokenId) internal view virtual returns (bool) {
1074         require(_exists(tokenId), "ERC721: operator query for nonexistent token");
1075         address owner = ERC721.ownerOf(tokenId);
1076         return (spender == owner || getApproved(tokenId) == spender || isApprovedForAll(owner, spender));
1077     }
1078 
1079     /**
1080      * @dev Safely mints `tokenId` and transfers it to `to`.
1081      *
1082      * Requirements:
1083      *
1084      * - `tokenId` must not exist.
1085      * - If `to` refers to a smart contract, it must implement {IERC721Receiver-onERC721Received}, which is called upon a safe transfer.
1086      *
1087      * Emits a {Transfer} event.
1088      */
1089     function _safeMint(address to, uint256 tokenId) internal virtual {
1090         _safeMint(to, tokenId, "");
1091     }
1092 
1093     /**
1094      * @dev Same as {xref-ERC721-_safeMint-address-uint256-}[`_safeMint`], with an additional `data` parameter which is
1095      * forwarded in {IERC721Receiver-onERC721Received} to contract recipients.
1096      */
1097     function _safeMint(
1098         address to,
1099         uint256 tokenId,
1100         bytes memory _data
1101     ) internal virtual {
1102         _mint(to, tokenId);
1103         require(
1104             _checkOnERC721Received(address(0), to, tokenId, _data),
1105             "ERC721: transfer to non ERC721Receiver implementer"
1106         );
1107     }
1108 
1109     /**
1110      * @dev Mints `tokenId` and transfers it to `to`.
1111      *
1112      * WARNING: Usage of this method is discouraged, use {_safeMint} whenever possible
1113      *
1114      * Requirements:
1115      *
1116      * - `tokenId` must not exist.
1117      * - `to` cannot be the zero address.
1118      *
1119      * Emits a {Transfer} event.
1120      */
1121     function _mint(address to, uint256 tokenId) internal virtual {
1122         require(to != address(0), "ERC721: mint to the zero address");
1123         require(!_exists(tokenId), "ERC721: token already minted");
1124 
1125         _beforeTokenTransfer(address(0), to, tokenId);
1126 
1127         _balances[to] += 1;
1128         _owners[tokenId] = to;
1129 
1130         emit Transfer(address(0), to, tokenId);
1131 
1132         _afterTokenTransfer(address(0), to, tokenId);
1133     }
1134 
1135     /**
1136      * @dev Destroys `tokenId`.
1137      * The approval is cleared when the token is burned.
1138      *
1139      * Requirements:
1140      *
1141      * - `tokenId` must exist.
1142      *
1143      * Emits a {Transfer} event.
1144      */
1145     function _burn(uint256 tokenId) internal virtual {
1146         address owner = ERC721.ownerOf(tokenId);
1147 
1148         _beforeTokenTransfer(owner, address(0), tokenId);
1149 
1150         // Clear approvals
1151         _approve(address(0), tokenId);
1152 
1153         _balances[owner] -= 1;
1154         delete _owners[tokenId];
1155 
1156         emit Transfer(owner, address(0), tokenId);
1157 
1158         _afterTokenTransfer(owner, address(0), tokenId);
1159     }
1160 
1161     /**
1162      * @dev Transfers `tokenId` from `from` to `to`.
1163      *  As opposed to {transferFrom}, this imposes no restrictions on msg.sender.
1164      *
1165      * Requirements:
1166      *
1167      * - `to` cannot be the zero address.
1168      * - `tokenId` token must be owned by `from`.
1169      *
1170      * Emits a {Transfer} event.
1171      */
1172     function _transfer(
1173         address from,
1174         address to,
1175         uint256 tokenId
1176     ) internal virtual {
1177         require(ERC721.ownerOf(tokenId) == from, "ERC721: transfer from incorrect owner");
1178         require(to != address(0), "ERC721: transfer to the zero address");
1179 
1180         _beforeTokenTransfer(from, to, tokenId);
1181 
1182         // Clear approvals from the previous owner
1183         _approve(address(0), tokenId);
1184 
1185         _balances[from] -= 1;
1186         _balances[to] += 1;
1187         _owners[tokenId] = to;
1188 
1189         emit Transfer(from, to, tokenId);
1190 
1191         _afterTokenTransfer(from, to, tokenId);
1192     }
1193 
1194     /**
1195      * @dev Approve `to` to operate on `tokenId`
1196      *
1197      * Emits a {Approval} event.
1198      */
1199     function _approve(address to, uint256 tokenId) internal virtual {
1200         _tokenApprovals[tokenId] = to;
1201         emit Approval(ERC721.ownerOf(tokenId), to, tokenId);
1202     }
1203 
1204     /**
1205      * @dev Approve `operator` to operate on all of `owner` tokens
1206      *
1207      * Emits a {ApprovalForAll} event.
1208      */
1209     function _setApprovalForAll(
1210         address owner,
1211         address operator,
1212         bool approved
1213     ) internal virtual {
1214         require(owner != operator, "ERC721: approve to caller");
1215         _operatorApprovals[owner][operator] = approved;
1216         emit ApprovalForAll(owner, operator, approved);
1217     }
1218 
1219     /**
1220      * @dev Internal function to invoke {IERC721Receiver-onERC721Received} on a target address.
1221      * The call is not executed if the target address is not a contract.
1222      *
1223      * @param from address representing the previous owner of the given token ID
1224      * @param to target address that will receive the tokens
1225      * @param tokenId uint256 ID of the token to be transferred
1226      * @param _data bytes optional data to send along with the call
1227      * @return bool whether the call correctly returned the expected magic value
1228      */
1229     function _checkOnERC721Received(
1230         address from,
1231         address to,
1232         uint256 tokenId,
1233         bytes memory _data
1234     ) private returns (bool) {
1235         if (to.isContract()) {
1236             try IERC721Receiver(to).onERC721Received(_msgSender(), from, tokenId, _data) returns (bytes4 retval) {
1237                 return retval == IERC721Receiver.onERC721Received.selector;
1238             } catch (bytes memory reason) {
1239                 if (reason.length == 0) {
1240                     revert("ERC721: transfer to non ERC721Receiver implementer");
1241                 } else {
1242                     assembly {
1243                         revert(add(32, reason), mload(reason))
1244                     }
1245                 }
1246             }
1247         } else {
1248             return true;
1249         }
1250     }
1251 
1252     /**
1253      * @dev Hook that is called before any token transfer. This includes minting
1254      * and burning.
1255      *
1256      * Calling conditions:
1257      *
1258      * - When `from` and `to` are both non-zero, ``from``'s `tokenId` will be
1259      * transferred to `to`.
1260      * - When `from` is zero, `tokenId` will be minted for `to`.
1261      * - When `to` is zero, ``from``'s `tokenId` will be burned.
1262      * - `from` and `to` are never both zero.
1263      *
1264      * To learn more about hooks, head to xref:ROOT:extending-contracts.adoc#using-hooks[Using Hooks].
1265      */
1266     function _beforeTokenTransfer(
1267         address from,
1268         address to,
1269         uint256 tokenId
1270     ) internal virtual {}
1271 
1272     /**
1273      * @dev Hook that is called after any transfer of tokens. This includes
1274      * minting and burning.
1275      *
1276      * Calling conditions:
1277      *
1278      * - when `from` and `to` are both non-zero.
1279      * - `from` and `to` are never both zero.
1280      *
1281      * To learn more about hooks, head to xref:ROOT:extending-contracts.adoc#using-hooks[Using Hooks].
1282      */
1283     function _afterTokenTransfer(
1284         address from,
1285         address to,
1286         uint256 tokenId
1287     ) internal virtual {}
1288 }
1289 
1290 // File: contracts/Mems.sol
1291 
1292 
1293 
1294 pragma solidity ^0.8.0;
1295 
1296 
1297 
1298 
1299 
1300 
1301 
1302  /*
1303   _ __ ___   ___ _ __ ___  ___ 
1304  | '_ ` _ \ / _ \ '_ ` _ \/ __|
1305  | | | | | |  __/ | | | | \__ \
1306  |_| |_| |_|\___|_| |_| |_|___/
1307  */
1308 
1309 contract Mems is ERC721, Ownable, ReentrancyGuard {
1310     string public baseURI;
1311 
1312     uint256 public constant MAX_SUPPLY = 6000;
1313 
1314     uint256 public cost = 0.1 ether;
1315     uint256 public maxPerWallet = 1;
1316 
1317     // used to validate whitelists
1318     bytes32 public whitelistMerkleRoot;
1319 
1320     bool public isAllowListActive;
1321     bool public isMainSaleActive;
1322 
1323     mapping(address => uint256) internal walletCap;
1324 
1325     using Counters for Counters.Counter;
1326     Counters.Counter private _tokenSupply;
1327 
1328     constructor(string memory _baseURI) ERC721("mems", "MEMS") {
1329         baseURI = _baseURI;
1330         isAllowListActive = false;
1331         isMainSaleActive = false;
1332     }
1333 
1334     /**
1335      * @dev validates merkleProof
1336      */
1337     modifier isValidMerkleProof(bytes32[] calldata merkleProof, bytes32 root) {
1338         require(
1339             MerkleProof.verify(
1340                 merkleProof,
1341                 root,
1342                 keccak256(abi.encodePacked(msg.sender))
1343             ),
1344             "Address does not exist in list"
1345         );
1346         _;
1347     }
1348 
1349     modifier isCorrectPayment(uint256 price) {
1350         require(
1351             price == msg.value,
1352             "Incorrect ETH value sent"
1353         );
1354         _;
1355     }
1356 
1357     // ============ PUBLIC FUNCTIONS FOR MINTING ============
1358 
1359     /**
1360     * @dev mints 1 token per whitelisted address, does not charge a fee
1361     */
1362     function mintAllowlist(
1363         bytes32[] calldata merkleProof
1364     )
1365         public
1366         payable
1367         isValidMerkleProof(merkleProof, whitelistMerkleRoot)
1368         isCorrectPayment(cost)
1369         nonReentrant
1370     {
1371         require(isAllowListActive && !isMainSaleActive, "Whitelist must be active to mint tokens");
1372         require(walletCap[msg.sender] + 1 <= maxPerWallet, "Purchase would exceed max number of mints per wallet.");
1373         require(_tokenSupply.current() + 1 <= MAX_SUPPLY, "Purchase would exceed max number of tokens");
1374         
1375         _tokenSupply.increment();
1376         _mint(msg.sender, _tokenSupply.current());
1377         walletCap[msg.sender] += 1;
1378     }
1379 
1380     /**
1381     * @dev mints specified # of tokens to sender address
1382     */
1383     function mint()
1384         public
1385         payable
1386         isCorrectPayment(cost)
1387         nonReentrant
1388     {
1389         require(!isAllowListActive && isMainSaleActive, "Main sale must be active to mint.");
1390         require(walletCap[msg.sender] + 1 <= maxPerWallet, "Purchase would exceed max number of mints per wallet.");
1391         require(_tokenSupply.current() + 1 <= MAX_SUPPLY, "Purchase would exceed max number of tokens");
1392 
1393         _tokenSupply.increment();
1394         _mint(msg.sender, _tokenSupply.current());
1395         walletCap[msg.sender] += 1;
1396     }
1397 
1398     // ============ PUBLIC READ-ONLY FUNCTIONS ============
1399     function tokenURI(uint256 tokenId)
1400       public
1401       view
1402       virtual
1403       override
1404       returns (string memory)
1405     {
1406         require(_exists(tokenId), "ERC721Metadata: query for nonexistent token");
1407         return string(abi.encodePacked(baseURI, Strings.toString(tokenId), ".json"));
1408     }
1409 
1410     function totalSupply() public view returns (uint256) {
1411         return _tokenSupply.current();
1412     }
1413 
1414     // ============ OWNER-ONLY ADMIN FUNCTIONS ============
1415     // @dev Private mint function reserved for company.
1416     // @param _to The user receiving the tokens
1417     // @param _mintAmount The number of tokens to distribute
1418     function mintToAddress(address _to, uint256 _mintAmount) external onlyOwner {
1419         require(_mintAmount > 0, "You can only mint more than 0 tokens");
1420         require(_tokenSupply.current() + _mintAmount <= MAX_SUPPLY, "Can't mint more than max supply");
1421         for (uint256 i = 0; i < _mintAmount; i++) {
1422             _tokenSupply.increment();
1423             _mint(_to, _tokenSupply.current());
1424         }
1425     }
1426 
1427     function setBaseURI(string memory _baseURI) external onlyOwner {
1428         baseURI = _baseURI;
1429     }
1430 
1431     function setWhitelistMerkleRoot(bytes32 merkleRoot) external onlyOwner {
1432         whitelistMerkleRoot = merkleRoot;
1433     }
1434 
1435     function flipAllowListState() external onlyOwner {
1436         isAllowListActive = !isAllowListActive;
1437     }
1438 
1439     function flipMainSaleState() external onlyOwner {
1440         isMainSaleActive = !isMainSaleActive;
1441     }
1442 
1443     function setCost(uint256 _newCost) external onlyOwner {
1444         cost = _newCost;
1445     }
1446 
1447     /**
1448      * @dev withdraw funds for to specified account
1449      */
1450     function withdraw() public onlyOwner {
1451         uint256 balance = address(this).balance;
1452         payable(msg.sender).transfer(balance);
1453     }
1454 }