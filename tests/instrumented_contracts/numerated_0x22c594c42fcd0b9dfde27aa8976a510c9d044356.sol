1 // SPDX-License-Identifier: MIT
2 // File: @openzeppelin/contracts/security/ReentrancyGuard.sol
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
69 // OpenZeppelin Contracts v4.4.1 (utils/cryptography/MerkleProof.sol)
70 
71 pragma solidity ^0.8.0;
72 
73 /**
74  * @dev These functions deal with verification of Merkle Trees proofs.
75  *
76  * The proofs can be generated using the JavaScript library
77  * https://github.com/miguelmota/merkletreejs[merkletreejs].
78  * Note: the hashing algorithm should be keccak256 and pair sorting should be enabled.
79  *
80  * See `test/utils/cryptography/MerkleProof.test.js` for some examples.
81  */
82 library MerkleProof {
83     /**
84      * @dev Returns true if a `leaf` can be proved to be a part of a Merkle tree
85      * defined by `root`. For this, a `proof` must be provided, containing
86      * sibling hashes on the branch from the leaf to the root of the tree. Each
87      * pair of leaves and each pair of pre-images are assumed to be sorted.
88      */
89     function verify(
90         bytes32[] memory proof,
91         bytes32 root,
92         bytes32 leaf
93     ) internal pure returns (bool) {
94         return processProof(proof, leaf) == root;
95     }
96 
97     /**
98      * @dev Returns the rebuilt hash obtained by traversing a Merklee tree up
99      * from `leaf` using `proof`. A `proof` is valid if and only if the rebuilt
100      * hash matches the root of the tree. When processing the proof, the pairs
101      * of leafs & pre-images are assumed to be sorted.
102      *
103      * _Available since v4.4._
104      */
105     function processProof(bytes32[] memory proof, bytes32 leaf)
106         internal
107         pure
108         returns (bytes32)
109     {
110         bytes32 computedHash = leaf;
111         for (uint256 i = 0; i < proof.length; i++) {
112             bytes32 proofElement = proof[i];
113             if (computedHash <= proofElement) {
114                 // Hash(current computed hash + current element of the proof)
115                 computedHash = keccak256(
116                     abi.encodePacked(computedHash, proofElement)
117                 );
118             } else {
119                 // Hash(current element of the proof + current computed hash)
120                 computedHash = keccak256(
121                     abi.encodePacked(proofElement, computedHash)
122                 );
123             }
124         }
125         return computedHash;
126     }
127 }
128 
129 // File: @openzeppelin/contracts/utils/Strings.sol
130 
131 // OpenZeppelin Contracts v4.4.1 (utils/Strings.sol)
132 
133 pragma solidity ^0.8.0;
134 
135 /**
136  * @dev String operations.
137  */
138 library Strings {
139     bytes16 private constant _HEX_SYMBOLS = "0123456789abcdef";
140 
141     /**
142      * @dev Converts a `uint256` to its ASCII `string` decimal representation.
143      */
144     function toString(uint256 value) internal pure returns (string memory) {
145         // Inspired by OraclizeAPI's implementation - MIT licence
146         // https://github.com/oraclize/ethereum-api/blob/b42146b063c7d6ee1358846c198246239e9360e8/oraclizeAPI_0.4.25.sol
147 
148         if (value == 0) {
149             return "0";
150         }
151         uint256 temp = value;
152         uint256 digits;
153         while (temp != 0) {
154             digits++;
155             temp /= 10;
156         }
157         bytes memory buffer = new bytes(digits);
158         while (value != 0) {
159             digits -= 1;
160             buffer[digits] = bytes1(uint8(48 + uint256(value % 10)));
161             value /= 10;
162         }
163         return string(buffer);
164     }
165 
166     /**
167      * @dev Converts a `uint256` to its ASCII `string` hexadecimal representation.
168      */
169     function toHexString(uint256 value) internal pure returns (string memory) {
170         if (value == 0) {
171             return "0x00";
172         }
173         uint256 temp = value;
174         uint256 length = 0;
175         while (temp != 0) {
176             length++;
177             temp >>= 8;
178         }
179         return toHexString(value, length);
180     }
181 
182     /**
183      * @dev Converts a `uint256` to its ASCII `string` hexadecimal representation with fixed length.
184      */
185     function toHexString(uint256 value, uint256 length)
186         internal
187         pure
188         returns (string memory)
189     {
190         bytes memory buffer = new bytes(2 * length + 2);
191         buffer[0] = "0";
192         buffer[1] = "x";
193         for (uint256 i = 2 * length + 1; i > 1; --i) {
194             buffer[i] = _HEX_SYMBOLS[value & 0xf];
195             value >>= 4;
196         }
197         require(value == 0, "Strings: hex length insufficient");
198         return string(buffer);
199     }
200 }
201 
202 // File: @openzeppelin/contracts/utils/Context.sol
203 
204 // OpenZeppelin Contracts v4.4.1 (utils/Context.sol)
205 
206 pragma solidity ^0.8.0;
207 
208 /**
209  * @dev Provides information about the current execution context, including the
210  * sender of the transaction and its data. While these are generally available
211  * via msg.sender and msg.data, they should not be accessed in such a direct
212  * manner, since when dealing with meta-transactions the account sending and
213  * paying for execution may not be the actual sender (as far as an application
214  * is concerned).
215  *
216  * This contract is only required for intermediate, library-like contracts.
217  */
218 abstract contract Context {
219     function _msgSender() internal view virtual returns (address) {
220         return msg.sender;
221     }
222 
223     function _msgData() internal view virtual returns (bytes calldata) {
224         return msg.data;
225     }
226 }
227 
228 // File: @openzeppelin/contracts/access/Ownable.sol
229 
230 // OpenZeppelin Contracts v4.4.1 (access/Ownable.sol)
231 
232 pragma solidity ^0.8.0;
233 
234 /**
235  * @dev Contract module which provides a basic access control mechanism, where
236  * there is an account (an owner) that can be granted exclusive access to
237  * specific functions.
238  *
239  * By default, the owner account will be the one that deploys the contract. This
240  * can later be changed with {transferOwnership}.
241  *
242  * This module is used through inheritance. It will make available the modifier
243  * `onlyOwner`, which can be applied to your functions to restrict their use to
244  * the owner.
245  */
246 abstract contract Ownable is Context {
247     address private _owner;
248 
249     event OwnershipTransferred(
250         address indexed previousOwner,
251         address indexed newOwner
252     );
253 
254     /**
255      * @dev Initializes the contract setting the deployer as the initial owner.
256      */
257     constructor() {
258         _transferOwnership(_msgSender());
259     }
260 
261     /**
262      * @dev Returns the address of the current owner.
263      */
264     function owner() public view virtual returns (address) {
265         return _owner;
266     }
267 
268     /**
269      * @dev Throws if called by any account other than the owner.
270      */
271     modifier onlyOwner() {
272         require(owner() == _msgSender(), "Ownable: caller is not the owner");
273         _;
274     }
275 
276     /**
277      * @dev Leaves the contract without owner. It will not be possible to call
278      * `onlyOwner` functions anymore. Can only be called by the current owner.
279      *
280      * NOTE: Renouncing ownership will leave the contract without an owner,
281      * thereby removing any functionality that is only available to the owner.
282      */
283     function renounceOwnership() public virtual onlyOwner {
284         _transferOwnership(address(0));
285     }
286 
287     /**
288      * @dev Transfers ownership of the contract to a new account (`newOwner`).
289      * Can only be called by the current owner.
290      */
291     function transferOwnership(address newOwner) public virtual onlyOwner {
292         require(
293             newOwner != address(0),
294             "Ownable: new owner is the zero address"
295         );
296         _transferOwnership(newOwner);
297     }
298 
299     /**
300      * @dev Transfers ownership of the contract to a new account (`newOwner`).
301      * Internal function without access restriction.
302      */
303     function _transferOwnership(address newOwner) internal virtual {
304         address oldOwner = _owner;
305         _owner = newOwner;
306         emit OwnershipTransferred(oldOwner, newOwner);
307     }
308 }
309 
310 // File: @openzeppelin/contracts/utils/Address.sol
311 
312 // OpenZeppelin Contracts v4.4.1 (utils/Address.sol)
313 
314 pragma solidity ^0.8.0;
315 
316 /**
317  * @dev Collection of functions related to the address type
318  */
319 library Address {
320     /**
321      * @dev Returns true if `account` is a contract.
322      *
323      * [IMPORTANT]
324      * ====
325      * It is unsafe to assume that an address for which this function returns
326      * false is an externally-owned account (EOA) and not a contract.
327      *
328      * Among others, `isContract` will return false for the following
329      * types of addresses:
330      *
331      *  - an externally-owned account
332      *  - a contract in construction
333      *  - an address where a contract will be created
334      *  - an address where a contract lived, but was destroyed
335      * ====
336      */
337     function isContract(address account) internal view returns (bool) {
338         // This method relies on extcodesize, which returns 0 for contracts in
339         // construction, since the code is only stored at the end of the
340         // constructor execution.
341 
342         uint256 size;
343         assembly {
344             size := extcodesize(account)
345         }
346         return size > 0;
347     }
348 
349     /**
350      * @dev Replacement for Solidity's `transfer`: sends `amount` wei to
351      * `recipient`, forwarding all available gas and reverting on errors.
352      *
353      * https://eips.ethereum.org/EIPS/eip-1884[EIP1884] increases the gas cost
354      * of certain opcodes, possibly making contracts go over the 2300 gas limit
355      * imposed by `transfer`, making them unable to receive funds via
356      * `transfer`. {sendValue} removes this limitation.
357      *
358      * https://diligence.consensys.net/posts/2019/09/stop-using-soliditys-transfer-now/[Learn more].
359      *
360      * IMPORTANT: because control is transferred to `recipient`, care must be
361      * taken to not create reentrancy vulnerabilities. Consider using
362      * {ReentrancyGuard} or the
363      * https://solidity.readthedocs.io/en/v0.5.11/security-considerations.html#use-the-checks-effects-interactions-pattern[checks-effects-interactions pattern].
364      */
365     function sendValue(address payable recipient, uint256 amount) internal {
366         require(
367             address(this).balance >= amount,
368             "Address: insufficient balance"
369         );
370 
371         (bool success, ) = recipient.call{value: amount}("");
372         require(
373             success,
374             "Address: unable to send value, recipient may have reverted"
375         );
376     }
377 
378     /**
379      * @dev Performs a Solidity function call using a low level `call`. A
380      * plain `call` is an unsafe replacement for a function call: use this
381      * function instead.
382      *
383      * If `target` reverts with a revert reason, it is bubbled up by this
384      * function (like regular Solidity function calls).
385      *
386      * Returns the raw returned data. To convert to the expected return value,
387      * use https://solidity.readthedocs.io/en/latest/units-and-global-variables.html?highlight=abi.decode#abi-encoding-and-decoding-functions[`abi.decode`].
388      *
389      * Requirements:
390      *
391      * - `target` must be a contract.
392      * - calling `target` with `data` must not revert.
393      *
394      * _Available since v3.1._
395      */
396     function functionCall(address target, bytes memory data)
397         internal
398         returns (bytes memory)
399     {
400         return functionCall(target, data, "Address: low-level call failed");
401     }
402 
403     /**
404      * @dev Same as {xref-Address-functionCall-address-bytes-}[`functionCall`], but with
405      * `errorMessage` as a fallback revert reason when `target` reverts.
406      *
407      * _Available since v3.1._
408      */
409     function functionCall(
410         address target,
411         bytes memory data,
412         string memory errorMessage
413     ) internal returns (bytes memory) {
414         return functionCallWithValue(target, data, 0, errorMessage);
415     }
416 
417     /**
418      * @dev Same as {xref-Address-functionCall-address-bytes-}[`functionCall`],
419      * but also transferring `value` wei to `target`.
420      *
421      * Requirements:
422      *
423      * - the calling contract must have an ETH balance of at least `value`.
424      * - the called Solidity function must be `payable`.
425      *
426      * _Available since v3.1._
427      */
428     function functionCallWithValue(
429         address target,
430         bytes memory data,
431         uint256 value
432     ) internal returns (bytes memory) {
433         return
434             functionCallWithValue(
435                 target,
436                 data,
437                 value,
438                 "Address: low-level call with value failed"
439             );
440     }
441 
442     /**
443      * @dev Same as {xref-Address-functionCallWithValue-address-bytes-uint256-}[`functionCallWithValue`], but
444      * with `errorMessage` as a fallback revert reason when `target` reverts.
445      *
446      * _Available since v3.1._
447      */
448     function functionCallWithValue(
449         address target,
450         bytes memory data,
451         uint256 value,
452         string memory errorMessage
453     ) internal returns (bytes memory) {
454         require(
455             address(this).balance >= value,
456             "Address: insufficient balance for call"
457         );
458         require(isContract(target), "Address: call to non-contract");
459 
460         (bool success, bytes memory returndata) = target.call{value: value}(
461             data
462         );
463         return verifyCallResult(success, returndata, errorMessage);
464     }
465 
466     /**
467      * @dev Same as {xref-Address-functionCall-address-bytes-}[`functionCall`],
468      * but performing a static call.
469      *
470      * _Available since v3.3._
471      */
472     function functionStaticCall(address target, bytes memory data)
473         internal
474         view
475         returns (bytes memory)
476     {
477         return
478             functionStaticCall(
479                 target,
480                 data,
481                 "Address: low-level static call failed"
482             );
483     }
484 
485     /**
486      * @dev Same as {xref-Address-functionCall-address-bytes-string-}[`functionCall`],
487      * but performing a static call.
488      *
489      * _Available since v3.3._
490      */
491     function functionStaticCall(
492         address target,
493         bytes memory data,
494         string memory errorMessage
495     ) internal view returns (bytes memory) {
496         require(isContract(target), "Address: static call to non-contract");
497 
498         (bool success, bytes memory returndata) = target.staticcall(data);
499         return verifyCallResult(success, returndata, errorMessage);
500     }
501 
502     /**
503      * @dev Same as {xref-Address-functionCall-address-bytes-}[`functionCall`],
504      * but performing a delegate call.
505      *
506      * _Available since v3.4._
507      */
508     function functionDelegateCall(address target, bytes memory data)
509         internal
510         returns (bytes memory)
511     {
512         return
513             functionDelegateCall(
514                 target,
515                 data,
516                 "Address: low-level delegate call failed"
517             );
518     }
519 
520     /**
521      * @dev Same as {xref-Address-functionCall-address-bytes-string-}[`functionCall`],
522      * but performing a delegate call.
523      *
524      * _Available since v3.4._
525      */
526     function functionDelegateCall(
527         address target,
528         bytes memory data,
529         string memory errorMessage
530     ) internal returns (bytes memory) {
531         require(isContract(target), "Address: delegate call to non-contract");
532 
533         (bool success, bytes memory returndata) = target.delegatecall(data);
534         return verifyCallResult(success, returndata, errorMessage);
535     }
536 
537     /**
538      * @dev Tool to verifies that a low level call was successful, and revert if it wasn't, either by bubbling the
539      * revert reason using the provided one.
540      *
541      * _Available since v4.3._
542      */
543     function verifyCallResult(
544         bool success,
545         bytes memory returndata,
546         string memory errorMessage
547     ) internal pure returns (bytes memory) {
548         if (success) {
549             return returndata;
550         } else {
551             // Look for revert reason and bubble it up if present
552             if (returndata.length > 0) {
553                 // The easiest way to bubble the revert reason is using memory via assembly
554 
555                 assembly {
556                     let returndata_size := mload(returndata)
557                     revert(add(32, returndata), returndata_size)
558                 }
559             } else {
560                 revert(errorMessage);
561             }
562         }
563     }
564 }
565 
566 // File: @openzeppelin/contracts/token/ERC721/IERC721Receiver.sol
567 
568 // OpenZeppelin Contracts v4.4.1 (token/ERC721/IERC721Receiver.sol)
569 
570 pragma solidity ^0.8.0;
571 
572 /**
573  * @title ERC721 token receiver interface
574  * @dev Interface for any contract that wants to support safeTransfers
575  * from ERC721 asset contracts.
576  */
577 interface IERC721Receiver {
578     /**
579      * @dev Whenever an {IERC721} `tokenId` token is transferred to this contract via {IERC721-safeTransferFrom}
580      * by `operator` from `from`, this function is called.
581      *
582      * It must return its Solidity selector to confirm the token transfer.
583      * If any other value is returned or the interface is not implemented by the recipient, the transfer will be reverted.
584      *
585      * The selector can be obtained in Solidity with `IERC721.onERC721Received.selector`.
586      */
587     function onERC721Received(
588         address operator,
589         address from,
590         uint256 tokenId,
591         bytes calldata data
592     ) external returns (bytes4);
593 }
594 
595 // File: @openzeppelin/contracts/utils/introspection/IERC165.sol
596 
597 // OpenZeppelin Contracts v4.4.1 (utils/introspection/IERC165.sol)
598 
599 pragma solidity ^0.8.0;
600 
601 /**
602  * @dev Interface of the ERC165 standard, as defined in the
603  * https://eips.ethereum.org/EIPS/eip-165[EIP].
604  *
605  * Implementers can declare support of contract interfaces, which can then be
606  * queried by others ({ERC165Checker}).
607  *
608  * For an implementation, see {ERC165}.
609  */
610 interface IERC165 {
611     /**
612      * @dev Returns true if this contract implements the interface defined by
613      * `interfaceId`. See the corresponding
614      * https://eips.ethereum.org/EIPS/eip-165#how-interfaces-are-identified[EIP section]
615      * to learn more about how these ids are created.
616      *
617      * This function call must use less than 30 000 gas.
618      */
619     function supportsInterface(bytes4 interfaceId) external view returns (bool);
620 }
621 
622 // File: @openzeppelin/contracts/utils/introspection/ERC165.sol
623 
624 // OpenZeppelin Contracts v4.4.1 (utils/introspection/ERC165.sol)
625 
626 pragma solidity ^0.8.0;
627 
628 /**
629  * @dev Implementation of the {IERC165} interface.
630  *
631  * Contracts that want to implement ERC165 should inherit from this contract and override {supportsInterface} to check
632  * for the additional interface id that will be supported. For example:
633  *
634  * ```solidity
635  * function supportsInterface(bytes4 interfaceId) public view virtual override returns (bool) {
636  *     return interfaceId == type(MyInterface).interfaceId || super.supportsInterface(interfaceId);
637  * }
638  * ```
639  *
640  * Alternatively, {ERC165Storage} provides an easier to use but more expensive implementation.
641  */
642 abstract contract ERC165 is IERC165 {
643     /**
644      * @dev See {IERC165-supportsInterface}.
645      */
646     function supportsInterface(bytes4 interfaceId)
647         public
648         view
649         virtual
650         override
651         returns (bool)
652     {
653         return interfaceId == type(IERC165).interfaceId;
654     }
655 }
656 
657 // File: @openzeppelin/contracts/token/ERC721/IERC721.sol
658 
659 // OpenZeppelin Contracts v4.4.1 (token/ERC721/IERC721.sol)
660 
661 pragma solidity ^0.8.0;
662 
663 /**
664  * @dev Required interface of an ERC721 compliant contract.
665  */
666 interface IERC721 is IERC165 {
667     /**
668      * @dev Emitted when `tokenId` token is transferred from `from` to `to`.
669      */
670     event Transfer(
671         address indexed from,
672         address indexed to,
673         uint256 indexed tokenId
674     );
675 
676     /**
677      * @dev Emitted when `owner` enables `approved` to manage the `tokenId` token.
678      */
679     event Approval(
680         address indexed owner,
681         address indexed approved,
682         uint256 indexed tokenId
683     );
684 
685     /**
686      * @dev Emitted when `owner` enables or disables (`approved`) `operator` to manage all of its assets.
687      */
688     event ApprovalForAll(
689         address indexed owner,
690         address indexed operator,
691         bool approved
692     );
693 
694     /**
695      * @dev Returns the number of tokens in ``owner``'s account.
696      */
697     function balanceOf(address owner) external view returns (uint256 balance);
698 
699     /**
700      * @dev Returns the owner of the `tokenId` token.
701      *
702      * Requirements:
703      *
704      * - `tokenId` must exist.
705      */
706     function ownerOf(uint256 tokenId) external view returns (address owner);
707 
708     /**
709      * @dev Safely transfers `tokenId` token from `from` to `to`, checking first that contract recipients
710      * are aware of the ERC721 protocol to prevent tokens from being forever locked.
711      *
712      * Requirements:
713      *
714      * - `from` cannot be the zero address.
715      * - `to` cannot be the zero address.
716      * - `tokenId` token must exist and be owned by `from`.
717      * - If the caller is not `from`, it must be have been allowed to move this token by either {approve} or {setApprovalForAll}.
718      * - If `to` refers to a smart contract, it must implement {IERC721Receiver-onERC721Received}, which is called upon a safe transfer.
719      *
720      * Emits a {Transfer} event.
721      */
722     function safeTransferFrom(
723         address from,
724         address to,
725         uint256 tokenId
726     ) external;
727 
728     /**
729      * @dev Transfers `tokenId` token from `from` to `to`.
730      *
731      * WARNING: Usage of this method is discouraged, use {safeTransferFrom} whenever possible.
732      *
733      * Requirements:
734      *
735      * - `from` cannot be the zero address.
736      * - `to` cannot be the zero address.
737      * - `tokenId` token must be owned by `from`.
738      * - If the caller is not `from`, it must be approved to move this token by either {approve} or {setApprovalForAll}.
739      *
740      * Emits a {Transfer} event.
741      */
742     function transferFrom(
743         address from,
744         address to,
745         uint256 tokenId
746     ) external;
747 
748     /**
749      * @dev Gives permission to `to` to transfer `tokenId` token to another account.
750      * The approval is cleared when the token is transferred.
751      *
752      * Only a single account can be approved at a time, so approving the zero address clears previous approvals.
753      *
754      * Requirements:
755      *
756      * - The caller must own the token or be an approved operator.
757      * - `tokenId` must exist.
758      *
759      * Emits an {Approval} event.
760      */
761     function approve(address to, uint256 tokenId) external;
762 
763     /**
764      * @dev Returns the account approved for `tokenId` token.
765      *
766      * Requirements:
767      *
768      * - `tokenId` must exist.
769      */
770     function getApproved(uint256 tokenId)
771         external
772         view
773         returns (address operator);
774 
775     /**
776      * @dev Approve or remove `operator` as an operator for the caller.
777      * Operators can call {transferFrom} or {safeTransferFrom} for any token owned by the caller.
778      *
779      * Requirements:
780      *
781      * - The `operator` cannot be the caller.
782      *
783      * Emits an {ApprovalForAll} event.
784      */
785     function setApprovalForAll(address operator, bool _approved) external;
786 
787     /**
788      * @dev Returns if the `operator` is allowed to manage all of the assets of `owner`.
789      *
790      * See {setApprovalForAll}
791      */
792     function isApprovedForAll(address owner, address operator)
793         external
794         view
795         returns (bool);
796 
797     /**
798      * @dev Safely transfers `tokenId` token from `from` to `to`.
799      *
800      * Requirements:
801      *
802      * - `from` cannot be the zero address.
803      * - `to` cannot be the zero address.
804      * - `tokenId` token must exist and be owned by `from`.
805      * - If the caller is not `from`, it must be approved to move this token by either {approve} or {setApprovalForAll}.
806      * - If `to` refers to a smart contract, it must implement {IERC721Receiver-onERC721Received}, which is called upon a safe transfer.
807      *
808      * Emits a {Transfer} event.
809      */
810     function safeTransferFrom(
811         address from,
812         address to,
813         uint256 tokenId,
814         bytes calldata data
815     ) external;
816 }
817 
818 // File: @openzeppelin/contracts/token/ERC721/extensions/IERC721Metadata.sol
819 
820 // OpenZeppelin Contracts v4.4.1 (token/ERC721/extensions/IERC721Metadata.sol)
821 
822 pragma solidity ^0.8.0;
823 
824 /**
825  * @title ERC-721 Non-Fungible Token Standard, optional metadata extension
826  * @dev See https://eips.ethereum.org/EIPS/eip-721
827  */
828 interface IERC721Metadata is IERC721 {
829     /**
830      * @dev Returns the token collection name.
831      */
832     function name() external view returns (string memory);
833 
834     /**
835      * @dev Returns the token collection symbol.
836      */
837     function symbol() external view returns (string memory);
838 
839     /**
840      * @dev Returns the Uniform Resource Identifier (URI) for `tokenId` token.
841      */
842     function tokenURI(uint256 tokenId) external view returns (string memory);
843 }
844 
845 // File: @openzeppelin/contracts/token/ERC721/ERC721.sol
846 
847 // OpenZeppelin Contracts v4.4.1 (token/ERC721/ERC721.sol)
848 
849 pragma solidity ^0.8.0;
850 
851 /**
852  * @dev Implementation of https://eips.ethereum.org/EIPS/eip-721[ERC721] Non-Fungible Token Standard, including
853  * the Metadata extension, but not including the Enumerable extension, which is available separately as
854  * {ERC721Enumerable}.
855  */
856 contract ERC721 is Context, ERC165, IERC721, IERC721Metadata {
857     using Address for address;
858     using Strings for uint256;
859 
860     // Token name
861     string private _name;
862 
863     // Token symbol
864     string private _symbol;
865 
866     // Mapping from token ID to owner address
867     mapping(uint256 => address) private _owners;
868 
869     // Mapping owner address to token count
870     mapping(address => uint256) private _balances;
871 
872     // Mapping from token ID to approved address
873     mapping(uint256 => address) private _tokenApprovals;
874 
875     // Mapping from owner to operator approvals
876     mapping(address => mapping(address => bool)) private _operatorApprovals;
877 
878     /**
879      * @dev Initializes the contract by setting a `name` and a `symbol` to the token collection.
880      */
881     constructor(string memory name_, string memory symbol_) {
882         _name = name_;
883         _symbol = symbol_;
884     }
885 
886     /**
887      * @dev See {IERC165-supportsInterface}.
888      */
889     function supportsInterface(bytes4 interfaceId)
890         public
891         view
892         virtual
893         override(ERC165, IERC165)
894         returns (bool)
895     {
896         return
897             interfaceId == type(IERC721).interfaceId ||
898             interfaceId == type(IERC721Metadata).interfaceId ||
899             super.supportsInterface(interfaceId);
900     }
901 
902     /**
903      * @dev See {IERC721-balanceOf}.
904      */
905     function balanceOf(address owner)
906         public
907         view
908         virtual
909         override
910         returns (uint256)
911     {
912         require(
913             owner != address(0),
914             "ERC721: balance query for the zero address"
915         );
916         return _balances[owner];
917     }
918 
919     /**
920      * @dev See {IERC721-ownerOf}.
921      */
922     function ownerOf(uint256 tokenId)
923         public
924         view
925         virtual
926         override
927         returns (address)
928     {
929         address owner = _owners[tokenId];
930         require(
931             owner != address(0),
932             "ERC721: owner query for nonexistent token"
933         );
934         return owner;
935     }
936 
937     /**
938      * @dev See {IERC721Metadata-name}.
939      */
940     function name() public view virtual override returns (string memory) {
941         return _name;
942     }
943 
944     /**
945      * @dev See {IERC721Metadata-symbol}.
946      */
947     function symbol() public view virtual override returns (string memory) {
948         return _symbol;
949     }
950 
951     /**
952      * @dev See {IERC721Metadata-tokenURI}.
953      */
954     function tokenURI(uint256 tokenId)
955         public
956         view
957         virtual
958         override
959         returns (string memory)
960     {
961         require(
962             _exists(tokenId),
963             "ERC721Metadata: URI query for nonexistent token"
964         );
965 
966         string memory baseURI = _baseURI();
967         return
968             bytes(baseURI).length > 0
969                 ? string(abi.encodePacked(baseURI, tokenId.toString()))
970                 : "";
971     }
972 
973     /**
974      * @dev Base URI for computing {tokenURI}. If set, the resulting URI for each
975      * token will be the concatenation of the `baseURI` and the `tokenId`. Empty
976      * by default, can be overriden in child contracts.
977      */
978     function _baseURI() internal view virtual returns (string memory) {
979         return "";
980     }
981 
982     /**
983      * @dev See {IERC721-approve}.
984      */
985     function approve(address to, uint256 tokenId) public virtual override {
986         address owner = ERC721.ownerOf(tokenId);
987         require(to != owner, "ERC721: approval to current owner");
988 
989         require(
990             _msgSender() == owner || isApprovedForAll(owner, _msgSender()),
991             "ERC721: approve caller is not owner nor approved for all"
992         );
993 
994         _approve(to, tokenId);
995     }
996 
997     /**
998      * @dev See {IERC721-getApproved}.
999      */
1000     function getApproved(uint256 tokenId)
1001         public
1002         view
1003         virtual
1004         override
1005         returns (address)
1006     {
1007         require(
1008             _exists(tokenId),
1009             "ERC721: approved query for nonexistent token"
1010         );
1011 
1012         return _tokenApprovals[tokenId];
1013     }
1014 
1015     /**
1016      * @dev See {IERC721-setApprovalForAll}.
1017      */
1018     function setApprovalForAll(address operator, bool approved)
1019         public
1020         virtual
1021         override
1022     {
1023         _setApprovalForAll(_msgSender(), operator, approved);
1024     }
1025 
1026     /**
1027      * @dev See {IERC721-isApprovedForAll}.
1028      */
1029     function isApprovedForAll(address owner, address operator)
1030         public
1031         view
1032         virtual
1033         override
1034         returns (bool)
1035     {
1036         return _operatorApprovals[owner][operator];
1037     }
1038 
1039     /**
1040      * @dev See {IERC721-transferFrom}.
1041      */
1042     function transferFrom(
1043         address from,
1044         address to,
1045         uint256 tokenId
1046     ) public virtual override {
1047         //solhint-disable-next-line max-line-length
1048         require(
1049             _isApprovedOrOwner(_msgSender(), tokenId),
1050             "ERC721: transfer caller is not owner nor approved"
1051         );
1052 
1053         _transfer(from, to, tokenId);
1054     }
1055 
1056     /**
1057      * @dev See {IERC721-safeTransferFrom}.
1058      */
1059     function safeTransferFrom(
1060         address from,
1061         address to,
1062         uint256 tokenId
1063     ) public virtual override {
1064         safeTransferFrom(from, to, tokenId, "");
1065     }
1066 
1067     /**
1068      * @dev See {IERC721-safeTransferFrom}.
1069      */
1070     function safeTransferFrom(
1071         address from,
1072         address to,
1073         uint256 tokenId,
1074         bytes memory _data
1075     ) public virtual override {
1076         require(
1077             _isApprovedOrOwner(_msgSender(), tokenId),
1078             "ERC721: transfer caller is not owner nor approved"
1079         );
1080         _safeTransfer(from, to, tokenId, _data);
1081     }
1082 
1083     /**
1084      * @dev Safely transfers `tokenId` token from `from` to `to`, checking first that contract recipients
1085      * are aware of the ERC721 protocol to prevent tokens from being forever locked.
1086      *
1087      * `_data` is additional data, it has no specified format and it is sent in call to `to`.
1088      *
1089      * This internal function is equivalent to {safeTransferFrom}, and can be used to e.g.
1090      * implement alternative mechanisms to perform token transfer, such as signature-based.
1091      *
1092      * Requirements:
1093      *
1094      * - `from` cannot be the zero address.
1095      * - `to` cannot be the zero address.
1096      * - `tokenId` token must exist and be owned by `from`.
1097      * - If `to` refers to a smart contract, it must implement {IERC721Receiver-onERC721Received}, which is called upon a safe transfer.
1098      *
1099      * Emits a {Transfer} event.
1100      */
1101     function _safeTransfer(
1102         address from,
1103         address to,
1104         uint256 tokenId,
1105         bytes memory _data
1106     ) internal virtual {
1107         _transfer(from, to, tokenId);
1108         require(
1109             _checkOnERC721Received(from, to, tokenId, _data),
1110             "ERC721: transfer to non ERC721Receiver implementer"
1111         );
1112     }
1113 
1114     /**
1115      * @dev Returns whether `tokenId` exists.
1116      *
1117      * Tokens can be managed by their owner or approved accounts via {approve} or {setApprovalForAll}.
1118      *
1119      * Tokens start existing when they are minted (`_mint`),
1120      * and stop existing when they are burned (`_burn`).
1121      */
1122     function _exists(uint256 tokenId) internal view virtual returns (bool) {
1123         return _owners[tokenId] != address(0);
1124     }
1125 
1126     /**
1127      * @dev Returns whether `spender` is allowed to manage `tokenId`.
1128      *
1129      * Requirements:
1130      *
1131      * - `tokenId` must exist.
1132      */
1133     function _isApprovedOrOwner(address spender, uint256 tokenId)
1134         internal
1135         view
1136         virtual
1137         returns (bool)
1138     {
1139         require(
1140             _exists(tokenId),
1141             "ERC721: operator query for nonexistent token"
1142         );
1143         address owner = ERC721.ownerOf(tokenId);
1144         return (spender == owner ||
1145             getApproved(tokenId) == spender ||
1146             isApprovedForAll(owner, spender));
1147     }
1148 
1149     /**
1150      * @dev Safely mints `tokenId` and transfers it to `to`.
1151      *
1152      * Requirements:
1153      *
1154      * - `tokenId` must not exist.
1155      * - If `to` refers to a smart contract, it must implement {IERC721Receiver-onERC721Received}, which is called upon a safe transfer.
1156      *
1157      * Emits a {Transfer} event.
1158      */
1159     function _safeMint(address to, uint256 tokenId) internal virtual {
1160         _safeMint(to, tokenId, "");
1161     }
1162 
1163     /**
1164      * @dev Same as {xref-ERC721-_safeMint-address-uint256-}[`_safeMint`], with an additional `data` parameter which is
1165      * forwarded in {IERC721Receiver-onERC721Received} to contract recipients.
1166      */
1167     function _safeMint(
1168         address to,
1169         uint256 tokenId,
1170         bytes memory _data
1171     ) internal virtual {
1172         _mint(to, tokenId);
1173         require(
1174             _checkOnERC721Received(address(0), to, tokenId, _data),
1175             "ERC721: transfer to non ERC721Receiver implementer"
1176         );
1177     }
1178 
1179     /**
1180      * @dev Mints `tokenId` and transfers it to `to`.
1181      *
1182      * WARNING: Usage of this method is discouraged, use {_safeMint} whenever possible
1183      *
1184      * Requirements:
1185      *
1186      * - `tokenId` must not exist.
1187      * - `to` cannot be the zero address.
1188      *
1189      * Emits a {Transfer} event.
1190      */
1191     function _mint(address to, uint256 tokenId) internal virtual {
1192         require(to != address(0), "ERC721: mint to the zero address");
1193         require(!_exists(tokenId), "ERC721: token already minted");
1194 
1195         _beforeTokenTransfer(address(0), to, tokenId);
1196 
1197         _balances[to] += 1;
1198         _owners[tokenId] = to;
1199 
1200         emit Transfer(address(0), to, tokenId);
1201     }
1202 
1203     /**
1204      * @dev Destroys `tokenId`.
1205      * The approval is cleared when the token is burned.
1206      *
1207      * Requirements:
1208      *
1209      * - `tokenId` must exist.
1210      *
1211      * Emits a {Transfer} event.
1212      */
1213     function _burn(uint256 tokenId) internal virtual {
1214         address owner = ERC721.ownerOf(tokenId);
1215 
1216         _beforeTokenTransfer(owner, address(0), tokenId);
1217 
1218         // Clear approvals
1219         _approve(address(0), tokenId);
1220 
1221         _balances[owner] -= 1;
1222         delete _owners[tokenId];
1223 
1224         emit Transfer(owner, address(0), tokenId);
1225     }
1226 
1227     /**
1228      * @dev Transfers `tokenId` from `from` to `to`.
1229      *  As opposed to {transferFrom}, this imposes no restrictions on msg.sender.
1230      *
1231      * Requirements:
1232      *
1233      * - `to` cannot be the zero address.
1234      * - `tokenId` token must be owned by `from`.
1235      *
1236      * Emits a {Transfer} event.
1237      */
1238     function _transfer(
1239         address from,
1240         address to,
1241         uint256 tokenId
1242     ) internal virtual {
1243         require(
1244             ERC721.ownerOf(tokenId) == from,
1245             "ERC721: transfer of token that is not own"
1246         );
1247         require(to != address(0), "ERC721: transfer to the zero address");
1248 
1249         _beforeTokenTransfer(from, to, tokenId);
1250 
1251         // Clear approvals from the previous owner
1252         _approve(address(0), tokenId);
1253 
1254         _balances[from] -= 1;
1255         _balances[to] += 1;
1256         _owners[tokenId] = to;
1257 
1258         emit Transfer(from, to, tokenId);
1259     }
1260 
1261     /**
1262      * @dev Approve `to` to operate on `tokenId`
1263      *
1264      * Emits a {Approval} event.
1265      */
1266     function _approve(address to, uint256 tokenId) internal virtual {
1267         _tokenApprovals[tokenId] = to;
1268         emit Approval(ERC721.ownerOf(tokenId), to, tokenId);
1269     }
1270 
1271     /**
1272      * @dev Approve `operator` to operate on all of `owner` tokens
1273      *
1274      * Emits a {ApprovalForAll} event.
1275      */
1276     function _setApprovalForAll(
1277         address owner,
1278         address operator,
1279         bool approved
1280     ) internal virtual {
1281         require(owner != operator, "ERC721: approve to caller");
1282         _operatorApprovals[owner][operator] = approved;
1283         emit ApprovalForAll(owner, operator, approved);
1284     }
1285 
1286     /**
1287      * @dev Internal function to invoke {IERC721Receiver-onERC721Received} on a target address.
1288      * The call is not executed if the target address is not a contract.
1289      *
1290      * @param from address representing the previous owner of the given token ID
1291      * @param to target address that will receive the tokens
1292      * @param tokenId uint256 ID of the token to be transferred
1293      * @param _data bytes optional data to send along with the call
1294      * @return bool whether the call correctly returned the expected magic value
1295      */
1296     function _checkOnERC721Received(
1297         address from,
1298         address to,
1299         uint256 tokenId,
1300         bytes memory _data
1301     ) private returns (bool) {
1302         if (to.isContract()) {
1303             try
1304                 IERC721Receiver(to).onERC721Received(
1305                     _msgSender(),
1306                     from,
1307                     tokenId,
1308                     _data
1309                 )
1310             returns (bytes4 retval) {
1311                 return retval == IERC721Receiver.onERC721Received.selector;
1312             } catch (bytes memory reason) {
1313                 if (reason.length == 0) {
1314                     revert(
1315                         "ERC721: transfer to non ERC721Receiver implementer"
1316                     );
1317                 } else {
1318                     assembly {
1319                         revert(add(32, reason), mload(reason))
1320                     }
1321                 }
1322             }
1323         } else {
1324             return true;
1325         }
1326     }
1327 
1328     /**
1329      * @dev Hook that is called before any token transfer. This includes minting
1330      * and burning.
1331      *
1332      * Calling conditions:
1333      *
1334      * - When `from` and `to` are both non-zero, ``from``'s `tokenId` will be
1335      * transferred to `to`.
1336      * - When `from` is zero, `tokenId` will be minted for `to`.
1337      * - When `to` is zero, ``from``'s `tokenId` will be burned.
1338      * - `from` and `to` are never both zero.
1339      *
1340      * To learn more about hooks, head to xref:ROOT:extending-contracts.adoc#using-hooks[Using Hooks].
1341      */
1342     function _beforeTokenTransfer(
1343         address from,
1344         address to,
1345         uint256 tokenId
1346     ) internal virtual {}
1347 }
1348 
1349 // File: CryptoBearWatchClub.sol
1350 
1351 pragma solidity 0.8.11;
1352 
1353 contract CryptoBearWatchClub is ERC721, Ownable, ReentrancyGuard {
1354     using MerkleProof for bytes32[];
1355 
1356     enum SALE_STATUS {
1357         OFF,
1358         PRIVATE_SALE,
1359         PRESALE,
1360         AUCTION
1361     }
1362 
1363     SALE_STATUS public saleStatus;
1364 
1365     string baseTokenURI;
1366 
1367     // To store total number of CBWC NFTs minted
1368     uint256 private mintCount;
1369 
1370     uint256 public constant MAX_CBWC = 10000;
1371     uint256 public constant PRESALE_PRICE = 500000000000000000; // 0.5 Ether
1372 
1373     // Dutch auction related
1374     uint256 public auctionStartAt; // Auction timer for public mint
1375     uint256 public constant PRICE_DEDUCTION_PERCENTAGE = 100000000000000000; // 0.1 Ether
1376     uint256 public constant STARTING_PRICE = 2000000000000000000; // 2 Ether
1377 
1378     bytes32 public merkleRoot;
1379 
1380     // To store CBWC address has minted in presale
1381     mapping(address => uint256) public preSaleMintCount;
1382 
1383     // To store how many NFTs address can mint in private sale
1384     mapping(address => uint256) public privateSaleMintCount;
1385 
1386     // To store last mint block of an address, it will prevent smart contracts to mint more than 20 in one go
1387     mapping(address => uint256) public lastMintBlock;
1388 
1389     event Minted(uint256 totalMinted);
1390 
1391     constructor(string memory baseURI)
1392         ERC721("Crypto Bear Watch Club", "CBWC")
1393     {
1394         setBaseURI(baseURI);
1395     }
1396 
1397     modifier onlyIfNotSoldOut(uint256 _count) {
1398         require(
1399             totalSupply() + _count <= MAX_CBWC,
1400             "Transaction will exceed maximum supply of CBWC"
1401         );
1402         _;
1403     }
1404 
1405     // Admin only functions
1406 
1407     // To update sale status
1408     function setSaleStatus(SALE_STATUS _status) external onlyOwner {
1409         saleStatus = _status;
1410     }
1411 
1412     function withdrawAll() external onlyOwner {
1413         uint256 balance = address(this).balance;
1414         require(balance > 0, "No funds");
1415         sendValue(
1416             0x1cE20812b08c2fcD5d595cf0667072B989666E98,
1417             (balance * 34) / 100
1418         );
1419         sendValue(
1420             0x9A69c32148FA4D0a1b0C3566e0bF35FE51430C4d,
1421             (balance * 33) / 100
1422         );
1423         sendValue(
1424             0xc6D37EfCCb2e07D94037704BB1508d816915E286,
1425             (balance * 33) / 100
1426         );
1427     }
1428 
1429     function setMerkleRoot(bytes32 _merkleRoot) external onlyOwner {
1430         merkleRoot = _merkleRoot;
1431     }
1432 
1433     // Set auction timer
1434     function startAuction() external onlyOwner {
1435         require(
1436             saleStatus == SALE_STATUS.AUCTION,
1437             "Sale status is not set to auction"
1438         );
1439         auctionStartAt = block.timestamp;
1440     }
1441 
1442     // Set some Crypto Bears aside
1443     function reserveBears(uint256 _count)
1444         external
1445         onlyOwner
1446         onlyIfNotSoldOut(_count)
1447     {
1448         uint256 supply = totalSupply();
1449         mintCount += _count;
1450         for (uint256 i = 0; i < _count; i++) {
1451             _mint(++supply);
1452         }
1453     }
1454 
1455     function setBaseURI(string memory baseURI) public onlyOwner {
1456         baseTokenURI = baseURI;
1457     }
1458 
1459     // To whitelist users to mint during private sale
1460     function privateSaleWhiteList(
1461         address[] calldata _whitelistAddresses,
1462         uint256[] calldata _allowedCount
1463     ) external onlyOwner {
1464         require(
1465             _whitelistAddresses.length == _allowedCount.length,
1466             "Input length mismatch"
1467         );
1468         for (uint256 i = 0; i < _whitelistAddresses.length; i++) {
1469             require(_allowedCount[i] > 0, "Invalid allowance amount");
1470             require(_whitelistAddresses[i] != address(0), "Zero Address");
1471             privateSaleMintCount[_whitelistAddresses[i]] = _allowedCount[i];
1472         }
1473     }
1474 
1475     // Getter functions
1476 
1477     // Returns current price of dutch auction
1478     function dutchAuction() public view returns (uint256 price) {
1479         if (auctionStartAt == 0) {
1480             return STARTING_PRICE;
1481         } else {
1482             uint256 timeElapsed = block.timestamp - auctionStartAt;
1483             uint256 timeElapsedMultiplier = timeElapsed / 300;
1484             uint256 priceDeduction = PRICE_DEDUCTION_PERCENTAGE *
1485                 timeElapsedMultiplier;
1486 
1487             // If deduction price is more than 1.5 ether than return 0.5 ether as floor price is 0.5 ether
1488             price = 1500000000000000000 >= priceDeduction
1489                 ? (STARTING_PRICE - priceDeduction)
1490                 : 500000000000000000;
1491         }
1492     }
1493 
1494     // Returns circulating supply of CBWC
1495     function totalSupply() public view returns (uint256) {
1496         return mintCount;
1497     }
1498 
1499     function _baseURI() internal view virtual override returns (string memory) {
1500         return baseTokenURI;
1501     }
1502 
1503     //Mint functions
1504 
1505     function privateSaleMint(uint256 _count) external onlyIfNotSoldOut(_count) {
1506         require(
1507             privateSaleMintCount[msg.sender] > 0,
1508             "Address not eligible for private sale mint"
1509         );
1510         require(_count > 0, "Zero mint count");
1511         require(
1512             _count <= privateSaleMintCount[msg.sender],
1513             "Transaction will exceed maximum NFTs allowed to mint in private sale"
1514         );
1515         require(
1516             saleStatus == SALE_STATUS.PRIVATE_SALE,
1517             "Private sale is not started"
1518         );
1519 
1520         uint256 supply = totalSupply();
1521         mintCount += _count;
1522         privateSaleMintCount[msg.sender] -= _count;
1523 
1524         for (uint256 i = 0; i < _count; i++) {
1525             _mint(++supply);
1526         }
1527     }
1528 
1529     /**
1530      * @dev '_allowedCount' represents number of NFTs caller is allowed to mint in presale, and,
1531      * '_count' indiciates number of NFTs caller wants to mint in the transaction
1532      */
1533     function presaleMint(
1534         bytes32[] calldata _proof,
1535         uint256 _allowedCount,
1536         uint256 _count
1537     ) external payable onlyIfNotSoldOut(_count) {
1538         require(
1539             merkleRoot != 0,
1540             "No address is eligible for presale minting yet"
1541         );
1542         require(
1543             saleStatus == SALE_STATUS.PRESALE,
1544             "Presale sale is not started"
1545         );
1546         require(
1547             MerkleProof.verify(
1548                 _proof,
1549                 merkleRoot,
1550                 keccak256(abi.encodePacked(msg.sender, _allowedCount))
1551             ),
1552             "Address not eligible for presale mint"
1553         );
1554 
1555         require(_count > 0 && _count <= _allowedCount, "Invalid mint count");
1556         require(
1557             _allowedCount >= preSaleMintCount[msg.sender] + _count,
1558             "Transaction will exceed maximum NFTs allowed to mint in presale"
1559         );
1560         require(
1561             msg.value >= PRESALE_PRICE * _count,
1562             "Incorrect ether sent with this transaction"
1563         );
1564 
1565         uint256 supply = totalSupply();
1566         mintCount += _count;
1567         preSaleMintCount[msg.sender] += _count;
1568 
1569         for (uint256 i = 0; i < _count; i++) {
1570             _mint(++supply);
1571         }
1572     }
1573 
1574     // Auction mint
1575 
1576     function auctionMint(uint256 _count)
1577         external
1578         payable
1579         nonReentrant
1580         onlyIfNotSoldOut(_count)
1581     {
1582         require(
1583             saleStatus == SALE_STATUS.AUCTION,
1584             "Auction mint is not started"
1585         );
1586         require(
1587             _count > 0 && _count < 21,
1588             "Minimum 0 & Maximum 20 CBWC can be minted per transaction"
1589         );
1590         require(
1591             lastMintBlock[msg.sender] != block.number,
1592             "Can only mint max 20 CBWC per block"
1593         );
1594 
1595         uint256 amountRequired = dutchAuction() * _count;
1596         require(
1597             msg.value >= amountRequired,
1598             "Incorrect ether sent with this transaction"
1599         );
1600 
1601         //to refund unused eth
1602         uint256 excess = msg.value - amountRequired;
1603 
1604         uint256 supply = totalSupply();
1605         mintCount += _count;
1606         lastMintBlock[msg.sender] = block.number;
1607 
1608         for (uint256 i = 0; i < _count; i++) {
1609             _mint(++supply);
1610         }
1611 
1612         //refunding excess eth to minter
1613         if (excess > 0) {
1614             sendValue(msg.sender, excess);
1615         }
1616     }
1617 
1618     function _mint(uint256 tokenId) private {
1619         _safeMint(msg.sender, tokenId);
1620         emit Minted(tokenId);
1621     }
1622 
1623     /**
1624      * @dev Called whenever eth is being transferred from the contract to the recipient.
1625      *
1626      * Called when owner wants to withdraw funds, and
1627      * to refund excess ether to the minter.
1628      */
1629     function sendValue(address recipient, uint256 amount) private {
1630         require(address(this).balance >= amount, "Insufficient Eth balance");
1631 
1632         // solhint-disable-next-line avoid-low-level-calls, avoid-call-value
1633         (bool success, ) = payable(recipient).call{value: amount}("");
1634         require(success, "Unable to send value, recipient may have reverted");
1635     }
1636 }