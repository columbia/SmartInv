1 // File: @openzeppelin/contracts/utils/Counters.sol
2 
3 
4 // OpenZeppelin Contracts v4.4.1 (utils/Counters.sol)
5 
6 pragma solidity ^0.8.0;
7 
8 /**
9  * @title Counters
10  * @author Matt Condon (@shrugs)
11  * @dev Provides counters that can only be incremented, decremented or reset. This can be used e.g. to track the number
12  * of elements in a mapping, issuing ERC721 ids, or counting request ids.
13  *
14  * Include with `using Counters for Counters.Counter;`
15  */
16 library Counters {
17     struct Counter {
18         // This variable should never be directly accessed by users of the library: interactions must be restricted to
19         // the library's function. As of Solidity v0.5.2, this cannot be enforced, though there is a proposal to add
20         // this feature: see https://github.com/ethereum/solidity/issues/4637
21         uint256 _value; // default: 0
22     }
23 
24     function current(Counter storage counter) internal view returns (uint256) {
25         return counter._value;
26     }
27 
28     function increment(Counter storage counter) internal {
29         unchecked {
30             counter._value += 1;
31         }
32     }
33 
34     function decrement(Counter storage counter) internal {
35         uint256 value = counter._value;
36         require(value > 0, "Counter: decrement overflow");
37         unchecked {
38             counter._value = value - 1;
39         }
40     }
41 
42     function reset(Counter storage counter) internal {
43         counter._value = 0;
44     }
45 }
46 
47 // File: @openzeppelin/contracts/utils/cryptography/MerkleProof.sol
48 
49 
50 // OpenZeppelin Contracts v4.4.1 (utils/cryptography/MerkleProof.sol)
51 
52 pragma solidity ^0.8.0;
53 
54 /**
55  * @dev These functions deal with verification of Merkle Trees proofs.
56  *
57  * The proofs can be generated using the JavaScript library
58  * https://github.com/miguelmota/merkletreejs[merkletreejs].
59  * Note: the hashing algorithm should be keccak256 and pair sorting should be enabled.
60  *
61  * See `test/utils/cryptography/MerkleProof.test.js` for some examples.
62  */
63 library MerkleProof {
64     /**
65      * @dev Returns true if a `leaf` can be proved to be a part of a Merkle tree
66      * defined by `root`. For this, a `proof` must be provided, containing
67      * sibling hashes on the branch from the leaf to the root of the tree. Each
68      * pair of leaves and each pair of pre-images are assumed to be sorted.
69      */
70     function verify(
71         bytes32[] memory proof,
72         bytes32 root,
73         bytes32 leaf
74     ) internal pure returns (bool) {
75         return processProof(proof, leaf) == root;
76     }
77 
78     /**
79      * @dev Returns the rebuilt hash obtained by traversing a Merklee tree up
80      * from `leaf` using `proof`. A `proof` is valid if and only if the rebuilt
81      * hash matches the root of the tree. When processing the proof, the pairs
82      * of leafs & pre-images are assumed to be sorted.
83      *
84      * _Available since v4.4._
85      */
86     function processProof(bytes32[] memory proof, bytes32 leaf) internal pure returns (bytes32) {
87         bytes32 computedHash = leaf;
88         for (uint256 i = 0; i < proof.length; i++) {
89             bytes32 proofElement = proof[i];
90             if (computedHash <= proofElement) {
91                 // Hash(current computed hash + current element of the proof)
92                 computedHash = keccak256(abi.encodePacked(computedHash, proofElement));
93             } else {
94                 // Hash(current element of the proof + current computed hash)
95                 computedHash = keccak256(abi.encodePacked(proofElement, computedHash));
96             }
97         }
98         return computedHash;
99     }
100 }
101 
102 // File: @openzeppelin/contracts/security/ReentrancyGuard.sol
103 
104 
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
149      * by making the `nonReentrant` function external, and make it call a
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
167 // File: @openzeppelin/contracts/utils/Context.sol
168 
169 
170 
171 pragma solidity ^0.8.0;
172 
173 /**
174  * @dev Provides information about the current execution context, including the
175  * sender of the transaction and its data. While these are generally available
176  * via msg.sender and msg.data, they should not be accessed in such a direct
177  * manner, since when dealing with meta-transactions the account sending and
178  * paying for execution may not be the actual sender (as far as an application
179  * is concerned).
180  *
181  * This contract is only required for intermediate, library-like contracts.
182  */
183 abstract contract Context {
184     function _msgSender() internal view virtual returns (address) {
185         return msg.sender;
186     }
187 
188     function _msgData() internal view virtual returns (bytes calldata) {
189         return msg.data;
190     }
191 }
192 
193 // File: @openzeppelin/contracts/access/Ownable.sol
194 
195 
196 
197 pragma solidity ^0.8.0;
198 
199 
200 /**
201  * @dev Contract module which provides a basic access control mechanism, where
202  * there is an account (an owner) that can be granted exclusive access to
203  * specific functions.
204  *
205  * By default, the owner account will be the one that deploys the contract. This
206  * can later be changed with {transferOwnership}.
207  *
208  * This module is used through inheritance. It will make available the modifier
209  * `onlyOwner`, which can be applied to your functions to restrict their use to
210  * the owner.
211  */
212 abstract contract Ownable is Context {
213     address private _owner;
214 
215     event OwnershipTransferred(address indexed previousOwner, address indexed newOwner);
216 
217     /**
218      * @dev Initializes the contract setting the deployer as the initial owner.
219      */
220     constructor() {
221         _setOwner(_msgSender());
222     }
223 
224     /**
225      * @dev Returns the address of the current owner.
226      */
227     function owner() public view virtual returns (address) {
228         return _owner;
229     }
230 
231     /**
232      * @dev Throws if called by any account other than the owner.
233      */
234     modifier onlyOwner() {
235         require(owner() == _msgSender(), "Ownable: caller is not the owner");
236         _;
237     }
238 
239     /**
240      * @dev Leaves the contract without owner. It will not be possible to call
241      * `onlyOwner` functions anymore. Can only be called by the current owner.
242      *
243      * NOTE: Renouncing ownership will leave the contract without an owner,
244      * thereby removing any functionality that is only available to the owner.
245      */
246     function renounceOwnership() public virtual onlyOwner {
247         _setOwner(address(0));
248     }
249 
250     /**
251      * @dev Transfers ownership of the contract to a new account (`newOwner`).
252      * Can only be called by the current owner.
253      */
254     function transferOwnership(address newOwner) public virtual onlyOwner {
255         require(newOwner != address(0), "Ownable: new owner is the zero address");
256         _setOwner(newOwner);
257     }
258 
259     function _setOwner(address newOwner) private {
260         address oldOwner = _owner;
261         _owner = newOwner;
262         emit OwnershipTransferred(oldOwner, newOwner);
263     }
264 }
265 
266 // File: @openzeppelin/contracts/utils/Address.sol
267 
268 
269 
270 pragma solidity ^0.8.0;
271 
272 /**
273  * @dev Collection of functions related to the address type
274  */
275 library Address {
276     /**
277      * @dev Returns true if `account` is a contract.
278      *
279      * [IMPORTANT]
280      * ====
281      * It is unsafe to assume that an address for which this function returns
282      * false is an externally-owned account (EOA) and not a contract.
283      *
284      * Among others, `isContract` will return false for the following
285      * types of addresses:
286      *
287      *  - an externally-owned account
288      *  - a contract in construction
289      *  - an address where a contract will be created
290      *  - an address where a contract lived, but was destroyed
291      * ====
292      */
293     function isContract(address account) internal view returns (bool) {
294         // This method relies on extcodesize, which returns 0 for contracts in
295         // construction, since the code is only stored at the end of the
296         // constructor execution.
297 
298         uint256 size;
299         assembly {
300             size := extcodesize(account)
301         }
302         return size > 0;
303     }
304 
305     /**
306      * @dev Replacement for Solidity's `transfer`: sends `amount` wei to
307      * `recipient`, forwarding all available gas and reverting on errors.
308      *
309      * https://eips.ethereum.org/EIPS/eip-1884[EIP1884] increases the gas cost
310      * of certain opcodes, possibly making contracts go over the 2300 gas limit
311      * imposed by `transfer`, making them unable to receive funds via
312      * `transfer`. {sendValue} removes this limitation.
313      *
314      * https://diligence.consensys.net/posts/2019/09/stop-using-soliditys-transfer-now/[Learn more].
315      *
316      * IMPORTANT: because control is transferred to `recipient`, care must be
317      * taken to not create reentrancy vulnerabilities. Consider using
318      * {ReentrancyGuard} or the
319      * https://solidity.readthedocs.io/en/v0.5.11/security-considerations.html#use-the-checks-effects-interactions-pattern[checks-effects-interactions pattern].
320      */
321     function sendValue(address payable recipient, uint256 amount) internal {
322         require(address(this).balance >= amount, "Address: insufficient balance");
323 
324         (bool success, ) = recipient.call{value: amount}("");
325         require(success, "Address: unable to send value, recipient may have reverted");
326     }
327 
328     /**
329      * @dev Performs a Solidity function call using a low level `call`. A
330      * plain `call` is an unsafe replacement for a function call: use this
331      * function instead.
332      *
333      * If `target` reverts with a revert reason, it is bubbled up by this
334      * function (like regular Solidity function calls).
335      *
336      * Returns the raw returned data. To convert to the expected return value,
337      * use https://solidity.readthedocs.io/en/latest/units-and-global-variables.html?highlight=abi.decode#abi-encoding-and-decoding-functions[`abi.decode`].
338      *
339      * Requirements:
340      *
341      * - `target` must be a contract.
342      * - calling `target` with `data` must not revert.
343      *
344      * _Available since v3.1._
345      */
346     function functionCall(address target, bytes memory data) internal returns (bytes memory) {
347         return functionCall(target, data, "Address: low-level call failed");
348     }
349 
350     /**
351      * @dev Same as {xref-Address-functionCall-address-bytes-}[`functionCall`], but with
352      * `errorMessage` as a fallback revert reason when `target` reverts.
353      *
354      * _Available since v3.1._
355      */
356     function functionCall(
357         address target,
358         bytes memory data,
359         string memory errorMessage
360     ) internal returns (bytes memory) {
361         return functionCallWithValue(target, data, 0, errorMessage);
362     }
363 
364     /**
365      * @dev Same as {xref-Address-functionCall-address-bytes-}[`functionCall`],
366      * but also transferring `value` wei to `target`.
367      *
368      * Requirements:
369      *
370      * - the calling contract must have an ETH balance of at least `value`.
371      * - the called Solidity function must be `payable`.
372      *
373      * _Available since v3.1._
374      */
375     function functionCallWithValue(
376         address target,
377         bytes memory data,
378         uint256 value
379     ) internal returns (bytes memory) {
380         return functionCallWithValue(target, data, value, "Address: low-level call with value failed");
381     }
382 
383     /**
384      * @dev Same as {xref-Address-functionCallWithValue-address-bytes-uint256-}[`functionCallWithValue`], but
385      * with `errorMessage` as a fallback revert reason when `target` reverts.
386      *
387      * _Available since v3.1._
388      */
389     function functionCallWithValue(
390         address target,
391         bytes memory data,
392         uint256 value,
393         string memory errorMessage
394     ) internal returns (bytes memory) {
395         require(address(this).balance >= value, "Address: insufficient balance for call");
396         require(isContract(target), "Address: call to non-contract");
397 
398         (bool success, bytes memory returndata) = target.call{value: value}(data);
399         return verifyCallResult(success, returndata, errorMessage);
400     }
401 
402     /**
403      * @dev Same as {xref-Address-functionCall-address-bytes-}[`functionCall`],
404      * but performing a static call.
405      *
406      * _Available since v3.3._
407      */
408     function functionStaticCall(address target, bytes memory data) internal view returns (bytes memory) {
409         return functionStaticCall(target, data, "Address: low-level static call failed");
410     }
411 
412     /**
413      * @dev Same as {xref-Address-functionCall-address-bytes-string-}[`functionCall`],
414      * but performing a static call.
415      *
416      * _Available since v3.3._
417      */
418     function functionStaticCall(
419         address target,
420         bytes memory data,
421         string memory errorMessage
422     ) internal view returns (bytes memory) {
423         require(isContract(target), "Address: static call to non-contract");
424 
425         (bool success, bytes memory returndata) = target.staticcall(data);
426         return verifyCallResult(success, returndata, errorMessage);
427     }
428 
429     /**
430      * @dev Same as {xref-Address-functionCall-address-bytes-}[`functionCall`],
431      * but performing a delegate call.
432      *
433      * _Available since v3.4._
434      */
435     function functionDelegateCall(address target, bytes memory data) internal returns (bytes memory) {
436         return functionDelegateCall(target, data, "Address: low-level delegate call failed");
437     }
438 
439     /**
440      * @dev Same as {xref-Address-functionCall-address-bytes-string-}[`functionCall`],
441      * but performing a delegate call.
442      *
443      * _Available since v3.4._
444      */
445     function functionDelegateCall(
446         address target,
447         bytes memory data,
448         string memory errorMessage
449     ) internal returns (bytes memory) {
450         require(isContract(target), "Address: delegate call to non-contract");
451 
452         (bool success, bytes memory returndata) = target.delegatecall(data);
453         return verifyCallResult(success, returndata, errorMessage);
454     }
455 
456     /**
457      * @dev Tool to verifies that a low level call was successful, and revert if it wasn't, either by bubbling the
458      * revert reason using the provided one.
459      *
460      * _Available since v4.3._
461      */
462     function verifyCallResult(
463         bool success,
464         bytes memory returndata,
465         string memory errorMessage
466     ) internal pure returns (bytes memory) {
467         if (success) {
468             return returndata;
469         } else {
470             // Look for revert reason and bubble it up if present
471             if (returndata.length > 0) {
472                 // The easiest way to bubble the revert reason is using memory via assembly
473 
474                 assembly {
475                     let returndata_size := mload(returndata)
476                     revert(add(32, returndata), returndata_size)
477                 }
478             } else {
479                 revert(errorMessage);
480             }
481         }
482     }
483 }
484 
485 // File: @openzeppelin/contracts/token/ERC721/IERC721Receiver.sol
486 
487 
488 
489 pragma solidity ^0.8.0;
490 
491 /**
492  * @title ERC721 token receiver interface
493  * @dev Interface for any contract that wants to support safeTransfers
494  * from ERC721 asset contracts.
495  */
496 interface IERC721Receiver {
497     /**
498      * @dev Whenever an {IERC721} `tokenId` token is transferred to this contract via {IERC721-safeTransferFrom}
499      * by `operator` from `from`, this function is called.
500      *
501      * It must return its Solidity selector to confirm the token transfer.
502      * If any other value is returned or the interface is not implemented by the recipient, the transfer will be reverted.
503      *
504      * The selector can be obtained in Solidity with `IERC721.onERC721Received.selector`.
505      */
506     function onERC721Received(
507         address operator,
508         address from,
509         uint256 tokenId,
510         bytes calldata data
511     ) external returns (bytes4);
512 }
513 
514 // File: @openzeppelin/contracts/utils/introspection/IERC165.sol
515 
516 
517 
518 pragma solidity ^0.8.0;
519 
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
541 // File: @openzeppelin/contracts/utils/introspection/ERC165.sol
542 
543 
544 
545 pragma solidity ^0.8.0;
546 
547 
548 /**
549  * @dev Implementation of the {IERC165} interface.
550  *
551  * Contracts that want to implement ERC165 should inherit from this contract and override {supportsInterface} to check
552  * for the additional interface id that will be supported. For example:
553  *
554  * ```solidity
555  * function supportsInterface(bytes4 interfaceId) public view virtual override returns (bool) {
556  *     return interfaceId == type(MyInterface).interfaceId || super.supportsInterface(interfaceId);
557  * }
558  * ```
559  *
560  * Alternatively, {ERC165Storage} provides an easier to use but more expensive implementation.
561  */
562 abstract contract ERC165 is IERC165 {
563     /**
564      * @dev See {IERC165-supportsInterface}.
565      */
566     function supportsInterface(bytes4 interfaceId) public view virtual override returns (bool) {
567         return interfaceId == type(IERC165).interfaceId;
568     }
569 }
570 
571 // File: @openzeppelin/contracts/token/ERC721/IERC721.sol
572 
573 
574 
575 pragma solidity ^0.8.0;
576 
577 
578 /**
579  * @dev Required interface of an ERC721 compliant contract.
580  */
581 interface IERC721 is IERC165 {
582     /**
583      * @dev Emitted when `tokenId` token is transferred from `from` to `to`.
584      */
585     event Transfer(address indexed from, address indexed to, uint256 indexed tokenId);
586 
587     /**
588      * @dev Emitted when `owner` enables `approved` to manage the `tokenId` token.
589      */
590     event Approval(address indexed owner, address indexed approved, uint256 indexed tokenId);
591 
592     /**
593      * @dev Emitted when `owner` enables or disables (`approved`) `operator` to manage all of its assets.
594      */
595     event ApprovalForAll(address indexed owner, address indexed operator, bool approved);
596 
597     /**
598      * @dev Returns the number of tokens in ``owner``'s account.
599      */
600     function balanceOf(address owner) external view returns (uint256 balance);
601 
602     /**
603      * @dev Returns the owner of the `tokenId` token.
604      *
605      * Requirements:
606      *
607      * - `tokenId` must exist.
608      */
609     function ownerOf(uint256 tokenId) external view returns (address owner);
610 
611     /**
612      * @dev Safely transfers `tokenId` token from `from` to `to`, checking first that contract recipients
613      * are aware of the ERC721 protocol to prevent tokens from being forever locked.
614      *
615      * Requirements:
616      *
617      * - `from` cannot be the zero address.
618      * - `to` cannot be the zero address.
619      * - `tokenId` token must exist and be owned by `from`.
620      * - If the caller is not `from`, it must be have been allowed to move this token by either {approve} or {setApprovalForAll}.
621      * - If `to` refers to a smart contract, it must implement {IERC721Receiver-onERC721Received}, which is called upon a safe transfer.
622      *
623      * Emits a {Transfer} event.
624      */
625     function safeTransferFrom(
626         address from,
627         address to,
628         uint256 tokenId
629     ) external;
630 
631     /**
632      * @dev Transfers `tokenId` token from `from` to `to`.
633      *
634      * WARNING: Usage of this method is discouraged, use {safeTransferFrom} whenever possible.
635      *
636      * Requirements:
637      *
638      * - `from` cannot be the zero address.
639      * - `to` cannot be the zero address.
640      * - `tokenId` token must be owned by `from`.
641      * - If the caller is not `from`, it must be approved to move this token by either {approve} or {setApprovalForAll}.
642      *
643      * Emits a {Transfer} event.
644      */
645     function transferFrom(
646         address from,
647         address to,
648         uint256 tokenId
649     ) external;
650 
651     /**
652      * @dev Gives permission to `to` to transfer `tokenId` token to another account.
653      * The approval is cleared when the token is transferred.
654      *
655      * Only a single account can be approved at a time, so approving the zero address clears previous approvals.
656      *
657      * Requirements:
658      *
659      * - The caller must own the token or be an approved operator.
660      * - `tokenId` must exist.
661      *
662      * Emits an {Approval} event.
663      */
664     function approve(address to, uint256 tokenId) external;
665 
666     /**
667      * @dev Returns the account approved for `tokenId` token.
668      *
669      * Requirements:
670      *
671      * - `tokenId` must exist.
672      */
673     function getApproved(uint256 tokenId) external view returns (address operator);
674 
675     /**
676      * @dev Approve or remove `operator` as an operator for the caller.
677      * Operators can call {transferFrom} or {safeTransferFrom} for any token owned by the caller.
678      *
679      * Requirements:
680      *
681      * - The `operator` cannot be the caller.
682      *
683      * Emits an {ApprovalForAll} event.
684      */
685     function setApprovalForAll(address operator, bool _approved) external;
686 
687     /**
688      * @dev Returns if the `operator` is allowed to manage all of the assets of `owner`.
689      *
690      * See {setApprovalForAll}
691      */
692     function isApprovedForAll(address owner, address operator) external view returns (bool);
693 
694     /**
695      * @dev Safely transfers `tokenId` token from `from` to `to`.
696      *
697      * Requirements:
698      *
699      * - `from` cannot be the zero address.
700      * - `to` cannot be the zero address.
701      * - `tokenId` token must exist and be owned by `from`.
702      * - If the caller is not `from`, it must be approved to move this token by either {approve} or {setApprovalForAll}.
703      * - If `to` refers to a smart contract, it must implement {IERC721Receiver-onERC721Received}, which is called upon a safe transfer.
704      *
705      * Emits a {Transfer} event.
706      */
707     function safeTransferFrom(
708         address from,
709         address to,
710         uint256 tokenId,
711         bytes calldata data
712     ) external;
713 }
714 
715 // File: @openzeppelin/contracts/token/ERC721/extensions/IERC721Metadata.sol
716 
717 
718 
719 pragma solidity ^0.8.0;
720 
721 
722 /**
723  * @title ERC-721 Non-Fungible Token Standard, optional metadata extension
724  * @dev See https://eips.ethereum.org/EIPS/eip-721
725  */
726 interface IERC721Metadata is IERC721 {
727     /**
728      * @dev Returns the token collection name.
729      */
730     function name() external view returns (string memory);
731 
732     /**
733      * @dev Returns the token collection symbol.
734      */
735     function symbol() external view returns (string memory);
736 
737     /**
738      * @dev Returns the Uniform Resource Identifier (URI) for `tokenId` token.
739      */
740     function tokenURI(uint256 tokenId) external view returns (string memory);
741 }
742 
743 // File: @openzeppelin/contracts/utils/Strings.sol
744 
745 
746 
747 pragma solidity ^0.8.0;
748 
749 /**
750  * @dev String operations.
751  */
752 library Strings {
753     bytes16 private constant _HEX_SYMBOLS = "0123456789abcdef";
754 
755     /**
756      * @dev Converts a `uint256` to its ASCII `string` decimal representation.
757      */
758     function toString(uint256 value) internal pure returns (string memory) {
759         // Inspired by OraclizeAPI's implementation - MIT licence
760         // https://github.com/oraclize/ethereum-api/blob/b42146b063c7d6ee1358846c198246239e9360e8/oraclizeAPI_0.4.25.sol
761 
762         if (value == 0) {
763             return "0";
764         }
765         uint256 temp = value;
766         uint256 digits;
767         while (temp != 0) {
768             digits++;
769             temp /= 10;
770         }
771         bytes memory buffer = new bytes(digits);
772         while (value != 0) {
773             digits -= 1;
774             buffer[digits] = bytes1(uint8(48 + uint256(value % 10)));
775             value /= 10;
776         }
777         return string(buffer);
778     }
779 
780     /**
781      * @dev Converts a `uint256` to its ASCII `string` hexadecimal representation.
782      */
783     function toHexString(uint256 value) internal pure returns (string memory) {
784         if (value == 0) {
785             return "0x00";
786         }
787         uint256 temp = value;
788         uint256 length = 0;
789         while (temp != 0) {
790             length++;
791             temp >>= 8;
792         }
793         return toHexString(value, length);
794     }
795 
796     /**
797      * @dev Converts a `uint256` to its ASCII `string` hexadecimal representation with fixed length.
798      */
799     function toHexString(uint256 value, uint256 length) internal pure returns (string memory) {
800         bytes memory buffer = new bytes(2 * length + 2);
801         buffer[0] = "0";
802         buffer[1] = "x";
803         for (uint256 i = 2 * length + 1; i > 1; --i) {
804             buffer[i] = _HEX_SYMBOLS[value & 0xf];
805             value >>= 4;
806         }
807         require(value == 0, "Strings: hex length insufficient");
808         return string(buffer);
809     }
810 }
811 
812 // File: @openzeppelin/contracts/token/ERC721/ERC721.sol
813 
814 
815 
816 pragma solidity ^0.8.0;
817 
818 
819 
820 
821 
822 
823 
824 
825 /**
826  * @dev Implementation of https://eips.ethereum.org/EIPS/eip-721[ERC721] Non-Fungible Token Standard, including
827  * the Metadata extension, but not including the Enumerable extension, which is available separately as
828  * {ERC721Enumerable}.
829  */
830 contract ERC721 is Context, ERC165, IERC721, IERC721Metadata {
831     using Address for address;
832     using Strings for uint256;
833 
834     // Token name
835     string private _name;
836 
837     // Token symbol
838     string private _symbol;
839 
840     // Mapping from token ID to owner address
841     mapping(uint256 => address) private _owners;
842 
843     // Mapping owner address to token count
844     mapping(address => uint256) private _balances;
845 
846     // Mapping from token ID to approved address
847     mapping(uint256 => address) private _tokenApprovals;
848 
849     // Mapping from owner to operator approvals
850     mapping(address => mapping(address => bool)) private _operatorApprovals;
851 
852     /**
853      * @dev Initializes the contract by setting a `name` and a `symbol` to the token collection.
854      */
855     constructor(string memory name_, string memory symbol_) {
856         _name = name_;
857         _symbol = symbol_;
858     }
859 
860     /**
861      * @dev See {IERC165-supportsInterface}.
862      */
863     function supportsInterface(bytes4 interfaceId) public view virtual override(ERC165, IERC165) returns (bool) {
864         return
865             interfaceId == type(IERC721).interfaceId ||
866             interfaceId == type(IERC721Metadata).interfaceId ||
867             super.supportsInterface(interfaceId);
868     }
869 
870     /**
871      * @dev See {IERC721-balanceOf}.
872      */
873     function balanceOf(address owner) public view virtual override returns (uint256) {
874         require(owner != address(0), "ERC721: balance query for the zero address");
875         return _balances[owner];
876     }
877 
878     /**
879      * @dev See {IERC721-ownerOf}.
880      */
881     function ownerOf(uint256 tokenId) public view virtual override returns (address) {
882         address owner = _owners[tokenId];
883         require(owner != address(0), "ERC721: owner query for nonexistent token");
884         return owner;
885     }
886 
887     /**
888      * @dev See {IERC721Metadata-name}.
889      */
890     function name() public view virtual override returns (string memory) {
891         return _name;
892     }
893 
894     /**
895      * @dev See {IERC721Metadata-symbol}.
896      */
897     function symbol() public view virtual override returns (string memory) {
898         return _symbol;
899     }
900 
901     /**
902      * @dev See {IERC721Metadata-tokenURI}.
903      */
904     function tokenURI(uint256 tokenId) public view virtual override returns (string memory) {
905         require(_exists(tokenId), "ERC721Metadata: URI query for nonexistent token");
906 
907         string memory baseURI = _baseURI();
908         return bytes(baseURI).length > 0 ? string(abi.encodePacked(baseURI, tokenId.toString())) : "";
909     }
910 
911     /**
912      * @dev Base URI for computing {tokenURI}. If set, the resulting URI for each
913      * token will be the concatenation of the `baseURI` and the `tokenId`. Empty
914      * by default, can be overriden in child contracts.
915      */
916     function _baseURI() internal view virtual returns (string memory) {
917         return "";
918     }
919 
920     /**
921      * @dev See {IERC721-approve}.
922      */
923     function approve(address to, uint256 tokenId) public virtual override {
924         address owner = ERC721.ownerOf(tokenId);
925         require(to != owner, "ERC721: approval to current owner");
926 
927         require(
928             _msgSender() == owner || isApprovedForAll(owner, _msgSender()),
929             "ERC721: approve caller is not owner nor approved for all"
930         );
931 
932         _approve(to, tokenId);
933     }
934 
935     /**
936      * @dev See {IERC721-getApproved}.
937      */
938     function getApproved(uint256 tokenId) public view virtual override returns (address) {
939         require(_exists(tokenId), "ERC721: approved query for nonexistent token");
940 
941         return _tokenApprovals[tokenId];
942     }
943 
944     /**
945      * @dev See {IERC721-setApprovalForAll}.
946      */
947     function setApprovalForAll(address operator, bool approved) public virtual override {
948         require(operator != _msgSender(), "ERC721: approve to caller");
949 
950         _operatorApprovals[_msgSender()][operator] = approved;
951         emit ApprovalForAll(_msgSender(), operator, approved);
952     }
953 
954     /**
955      * @dev See {IERC721-isApprovedForAll}.
956      */
957     function isApprovedForAll(address owner, address operator) public view virtual override returns (bool) {
958         return _operatorApprovals[owner][operator];
959     }
960 
961     /**
962      * @dev See {IERC721-transferFrom}.
963      */
964     function transferFrom(
965         address from,
966         address to,
967         uint256 tokenId
968     ) public virtual override {
969         //solhint-disable-next-line max-line-length
970         require(_isApprovedOrOwner(_msgSender(), tokenId), "ERC721: transfer caller is not owner nor approved");
971 
972         _transfer(from, to, tokenId);
973     }
974 
975     /**
976      * @dev See {IERC721-safeTransferFrom}.
977      */
978     function safeTransferFrom(
979         address from,
980         address to,
981         uint256 tokenId
982     ) public virtual override {
983         safeTransferFrom(from, to, tokenId, "");
984     }
985 
986     /**
987      * @dev See {IERC721-safeTransferFrom}.
988      */
989     function safeTransferFrom(
990         address from,
991         address to,
992         uint256 tokenId,
993         bytes memory _data
994     ) public virtual override {
995         require(_isApprovedOrOwner(_msgSender(), tokenId), "ERC721: transfer caller is not owner nor approved");
996         _safeTransfer(from, to, tokenId, _data);
997     }
998 
999     /**
1000      * @dev Safely transfers `tokenId` token from `from` to `to`, checking first that contract recipients
1001      * are aware of the ERC721 protocol to prevent tokens from being forever locked.
1002      *
1003      * `_data` is additional data, it has no specified format and it is sent in call to `to`.
1004      *
1005      * This internal function is equivalent to {safeTransferFrom}, and can be used to e.g.
1006      * implement alternative mechanisms to perform token transfer, such as signature-based.
1007      *
1008      * Requirements:
1009      *
1010      * - `from` cannot be the zero address.
1011      * - `to` cannot be the zero address.
1012      * - `tokenId` token must exist and be owned by `from`.
1013      * - If `to` refers to a smart contract, it must implement {IERC721Receiver-onERC721Received}, which is called upon a safe transfer.
1014      *
1015      * Emits a {Transfer} event.
1016      */
1017     function _safeTransfer(
1018         address from,
1019         address to,
1020         uint256 tokenId,
1021         bytes memory _data
1022     ) internal virtual {
1023         _transfer(from, to, tokenId);
1024         require(_checkOnERC721Received(from, to, tokenId, _data), "ERC721: transfer to non ERC721Receiver implementer");
1025     }
1026 
1027     /**
1028      * @dev Returns whether `tokenId` exists.
1029      *
1030      * Tokens can be managed by their owner or approved accounts via {approve} or {setApprovalForAll}.
1031      *
1032      * Tokens start existing when they are minted (`_mint`),
1033      * and stop existing when they are burned (`_burn`).
1034      */
1035     function _exists(uint256 tokenId) internal view virtual returns (bool) {
1036         return _owners[tokenId] != address(0);
1037     }
1038 
1039     /**
1040      * @dev Returns whether `spender` is allowed to manage `tokenId`.
1041      *
1042      * Requirements:
1043      *
1044      * - `tokenId` must exist.
1045      */
1046     function _isApprovedOrOwner(address spender, uint256 tokenId) internal view virtual returns (bool) {
1047         require(_exists(tokenId), "ERC721: operator query for nonexistent token");
1048         address owner = ERC721.ownerOf(tokenId);
1049         return (spender == owner || getApproved(tokenId) == spender || isApprovedForAll(owner, spender));
1050     }
1051 
1052     /**
1053      * @dev Safely mints `tokenId` and transfers it to `to`.
1054      *
1055      * Requirements:
1056      *
1057      * - `tokenId` must not exist.
1058      * - If `to` refers to a smart contract, it must implement {IERC721Receiver-onERC721Received}, which is called upon a safe transfer.
1059      *
1060      * Emits a {Transfer} event.
1061      */
1062     function _safeMint(address to, uint256 tokenId) internal virtual {
1063         _safeMint(to, tokenId, "");
1064     }
1065 
1066     /**
1067      * @dev Same as {xref-ERC721-_safeMint-address-uint256-}[`_safeMint`], with an additional `data` parameter which is
1068      * forwarded in {IERC721Receiver-onERC721Received} to contract recipients.
1069      */
1070     function _safeMint(
1071         address to,
1072         uint256 tokenId,
1073         bytes memory _data
1074     ) internal virtual {
1075         _mint(to, tokenId);
1076         require(
1077             _checkOnERC721Received(address(0), to, tokenId, _data),
1078             "ERC721: transfer to non ERC721Receiver implementer"
1079         );
1080     }
1081 
1082     /**
1083      * @dev Mints `tokenId` and transfers it to `to`.
1084      *
1085      * WARNING: Usage of this method is discouraged, use {_safeMint} whenever possible
1086      *
1087      * Requirements:
1088      *
1089      * - `tokenId` must not exist.
1090      * - `to` cannot be the zero address.
1091      *
1092      * Emits a {Transfer} event.
1093      */
1094     function _mint(address to, uint256 tokenId) internal virtual {
1095         require(to != address(0), "ERC721: mint to the zero address");
1096         require(!_exists(tokenId), "ERC721: token already minted");
1097 
1098         _beforeTokenTransfer(address(0), to, tokenId);
1099 
1100         _balances[to] += 1;
1101         _owners[tokenId] = to;
1102 
1103         emit Transfer(address(0), to, tokenId);
1104     }
1105 
1106     /**
1107      * @dev Destroys `tokenId`.
1108      * The approval is cleared when the token is burned.
1109      *
1110      * Requirements:
1111      *
1112      * - `tokenId` must exist.
1113      *
1114      * Emits a {Transfer} event.
1115      */
1116     function _burn(uint256 tokenId) internal virtual {
1117         address owner = ERC721.ownerOf(tokenId);
1118 
1119         _beforeTokenTransfer(owner, address(0), tokenId);
1120 
1121         // Clear approvals
1122         _approve(address(0), tokenId);
1123 
1124         _balances[owner] -= 1;
1125         delete _owners[tokenId];
1126 
1127         emit Transfer(owner, address(0), tokenId);
1128     }
1129 
1130     /**
1131      * @dev Transfers `tokenId` from `from` to `to`.
1132      *  As opposed to {transferFrom}, this imposes no restrictions on msg.sender.
1133      *
1134      * Requirements:
1135      *
1136      * - `to` cannot be the zero address.
1137      * - `tokenId` token must be owned by `from`.
1138      *
1139      * Emits a {Transfer} event.
1140      */
1141     function _transfer(
1142         address from,
1143         address to,
1144         uint256 tokenId
1145     ) internal virtual {
1146         require(ERC721.ownerOf(tokenId) == from, "ERC721: transfer of token that is not own");
1147         require(to != address(0), "ERC721: transfer to the zero address");
1148 
1149         _beforeTokenTransfer(from, to, tokenId);
1150 
1151         // Clear approvals from the previous owner
1152         _approve(address(0), tokenId);
1153 
1154         _balances[from] -= 1;
1155         _balances[to] += 1;
1156         _owners[tokenId] = to;
1157 
1158         emit Transfer(from, to, tokenId);
1159     }
1160 
1161     /**
1162      * @dev Approve `to` to operate on `tokenId`
1163      *
1164      * Emits a {Approval} event.
1165      */
1166     function _approve(address to, uint256 tokenId) internal virtual {
1167         _tokenApprovals[tokenId] = to;
1168         emit Approval(ERC721.ownerOf(tokenId), to, tokenId);
1169     }
1170 
1171     /**
1172      * @dev Internal function to invoke {IERC721Receiver-onERC721Received} on a target address.
1173      * The call is not executed if the target address is not a contract.
1174      *
1175      * @param from address representing the previous owner of the given token ID
1176      * @param to target address that will receive the tokens
1177      * @param tokenId uint256 ID of the token to be transferred
1178      * @param _data bytes optional data to send along with the call
1179      * @return bool whether the call correctly returned the expected magic value
1180      */
1181     function _checkOnERC721Received(
1182         address from,
1183         address to,
1184         uint256 tokenId,
1185         bytes memory _data
1186     ) private returns (bool) {
1187         if (to.isContract()) {
1188             try IERC721Receiver(to).onERC721Received(_msgSender(), from, tokenId, _data) returns (bytes4 retval) {
1189                 return retval == IERC721Receiver.onERC721Received.selector;
1190             } catch (bytes memory reason) {
1191                 if (reason.length == 0) {
1192                     revert("ERC721: transfer to non ERC721Receiver implementer");
1193                 } else {
1194                     assembly {
1195                         revert(add(32, reason), mload(reason))
1196                     }
1197                 }
1198             }
1199         } else {
1200             return true;
1201         }
1202     }
1203 
1204     /**
1205      * @dev Hook that is called before any token transfer. This includes minting
1206      * and burning.
1207      *
1208      * Calling conditions:
1209      *
1210      * - When `from` and `to` are both non-zero, ``from``'s `tokenId` will be
1211      * transferred to `to`.
1212      * - When `from` is zero, `tokenId` will be minted for `to`.
1213      * - When `to` is zero, ``from``'s `tokenId` will be burned.
1214      * - `from` and `to` are never both zero.
1215      *
1216      * To learn more about hooks, head to xref:ROOT:extending-contracts.adoc#using-hooks[Using Hooks].
1217      */
1218     function _beforeTokenTransfer(
1219         address from,
1220         address to,
1221         uint256 tokenId
1222     ) internal virtual {}
1223 }
1224 
1225 // File: contracts/FULLSENDxAlienFrens.sol
1226 
1227 
1228 
1229 pragma solidity ^0.8.0;
1230 
1231 
1232 
1233 
1234 
1235 
1236 
1237 contract FULLSENDxAlienFrens is ERC721, Ownable, ReentrancyGuard {
1238     string public baseURI;
1239 
1240     uint256 public constant MAX_SUPPLY = 1001;
1241 
1242     uint256 public cost = 0 ether;
1243     uint256 public maxPerWallet = 1;
1244 
1245     // used to validate whitelists
1246     bytes32 public whitelistMerkleRoot;
1247 
1248     bool public isPresaleActive;
1249     bool public isMainSaleActive;
1250 
1251     mapping(uint256 => string) internal tokenUris;
1252     mapping(address => uint256) internal walletCap;
1253 
1254     using Counters for Counters.Counter;
1255     Counters.Counter private _tokenSupply;
1256 
1257     constructor(string memory _baseURI) ERC721("FULL SEND X Alien Frens", "FSAF") {
1258         baseURI = _baseURI;
1259         isPresaleActive = false;
1260         isMainSaleActive = false;
1261     }
1262 
1263     /**
1264      * @dev validates merkleProof
1265      */
1266     modifier isValidMerkleProof(bytes32[] calldata merkleProof, bytes32 root) {
1267         require(
1268             MerkleProof.verify(
1269                 merkleProof,
1270                 root,
1271                 keccak256(abi.encodePacked(msg.sender))
1272             ),
1273             "Address does not exist in list"
1274         );
1275         _;
1276     }
1277 
1278     modifier isCorrectPayment(uint256 price) {
1279         require(
1280             price == msg.value,
1281             "Incorrect ETH value sent"
1282         );
1283         _;
1284     }
1285 
1286     // ============ PUBLIC FUNCTIONS FOR MINTING ============
1287 
1288     /**
1289     * @dev mints 1 token per whitelisted address, does not charge a fee
1290     */
1291     function mintWhitelist(
1292         bytes32[] calldata merkleProof
1293     )
1294         public
1295         payable
1296         isValidMerkleProof(merkleProof, whitelistMerkleRoot)
1297         isCorrectPayment(cost)
1298         nonReentrant
1299     {
1300         require(isPresaleActive && !isMainSaleActive, "Whitelist must be active to mint tokens");
1301         require(walletCap[msg.sender] + 1 <= maxPerWallet, "Purchase would exceed max number of mints per wallet.");
1302         require(_tokenSupply.current() + 1 <= MAX_SUPPLY, "Purchase would exceed max number of tokens");
1303         
1304         _tokenSupply.increment();
1305         _mint(msg.sender, _tokenSupply.current());
1306         walletCap[msg.sender] += 1;
1307     }
1308 
1309     /**
1310     * @dev mints specified # of tokens to sender address
1311     */
1312     function mint()
1313         public
1314         payable
1315         isCorrectPayment(cost)
1316         nonReentrant
1317     {
1318         require(!isPresaleActive && isMainSaleActive, "Main sale must be active to mint.");
1319         require(walletCap[msg.sender] + 1 <= maxPerWallet, "Purchase would exceed max number of mints per wallet.");
1320         require(_tokenSupply.current() + 1 <= MAX_SUPPLY, "Purchase would exceed max number of tokens");
1321 
1322         _tokenSupply.increment();
1323         _mint(msg.sender, _tokenSupply.current());
1324         walletCap[msg.sender] += 1;
1325     }
1326 
1327     // ============ PUBLIC READ-ONLY FUNCTIONS ============
1328     function tokenURI(uint256 tokenId)
1329       public
1330       view
1331       virtual
1332       override
1333       returns (string memory)
1334     {
1335         require(_exists(tokenId), "ERC721Metadata: query for nonexistent token");
1336         return string(abi.encodePacked(baseURI, Strings.toString(tokenId), ".json"));
1337     }
1338 
1339     function totalSupply() public view returns (uint256) {
1340         return _tokenSupply.current();
1341     }
1342 
1343     // ============ OWNER-ONLY ADMIN FUNCTIONS ============
1344     // @dev Private mint function reserved for company.
1345     // @param _to The user receiving the tokens
1346     // @param _mintAmount The number of tokens to distribute
1347     function mintToAddress(address _to, uint256 _mintAmount) external onlyOwner {
1348         require(_mintAmount > 0, "You can only mint more than 0 tokens");
1349         require(_tokenSupply.current() + _mintAmount <= MAX_SUPPLY, "Can't mint more than max supply");
1350         for (uint256 i = 0; i < _mintAmount; i++) {
1351             _tokenSupply.increment();
1352             _mint(_to, _tokenSupply.current());
1353         }
1354     }
1355 
1356     function setBaseURI(string memory _baseURI) external onlyOwner {
1357         baseURI = _baseURI;
1358     }
1359 
1360     function setWhitelistMerkleRoot(bytes32 merkleRoot) external onlyOwner {
1361         whitelistMerkleRoot = merkleRoot;
1362     }
1363 
1364     function flipPresaleState() external onlyOwner {
1365         isPresaleActive = !isPresaleActive;
1366     }
1367 
1368     function flipMainSaleState() external onlyOwner {
1369         isMainSaleActive = !isMainSaleActive;
1370     }
1371 
1372     function setCost(uint256 _newCost) external onlyOwner {
1373         cost = _newCost;
1374     }
1375 
1376     /**
1377      * @dev withdraw funds for to specified account
1378      */
1379     function withdraw() public onlyOwner {
1380         uint256 balance = address(this).balance;
1381         payable(msg.sender).transfer(balance);
1382     }
1383 }