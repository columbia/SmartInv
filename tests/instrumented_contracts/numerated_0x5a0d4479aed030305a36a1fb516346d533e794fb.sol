1 // SPDX-License-Identifier: MIT
2 // File: @openzeppelin/contracts/utils/cryptography/MerkleProof.sol
3 
4 
5 // OpenZeppelin Contracts v4.4.1 (utils/cryptography/MerkleProof.sol)
6 
7 pragma solidity ^0.8.11;
8 
9 /**
10  * @dev These functions deal with verification of Merkle Trees proofs.
11  *
12  * The proofs can be generated using the JavaScript library
13  * https://github.com/miguelmota/merkletreejs[merkletreejs].
14  * Note: the hashing algorithm should be keccak256 and pair sorting should be enabled.
15  *
16  * See `test/utils/cryptography/MerkleProof.test.js` for some examples.
17  */
18 library MerkleProof {
19     /**
20      * @dev Returns true if a `leaf` can be proved to be a part of a Merkle tree
21      * defined by `root`. For this, a `proof` must be provided, containing
22      * sibling hashes on the branch from the leaf to the root of the tree. Each
23      * pair of leaves and each pair of pre-images are assumed to be sorted.
24      */
25     function verify(
26         bytes32[] memory proof,
27         bytes32 root,
28         bytes32 leaf
29     ) internal pure returns (bool) {
30         return processProof(proof, leaf) == root;
31     }
32 
33     /**
34      * @dev Returns the rebuilt hash obtained by traversing a Merklee tree up
35      * from `leaf` using `proof`. A `proof` is valid if and only if the rebuilt
36      * hash matches the root of the tree. When processing the proof, the pairs
37      * of leafs & pre-images are assumed to be sorted.
38      *
39      * _Available since v4.4._
40      */
41     function processProof(bytes32[] memory proof, bytes32 leaf) internal pure returns (bytes32) {
42         bytes32 computedHash = leaf;
43         for (uint256 i = 0; i < proof.length; i++) {
44             bytes32 proofElement = proof[i];
45             if (computedHash <= proofElement) {
46                 // Hash(current computed hash + current element of the proof)
47                 computedHash = keccak256(abi.encodePacked(computedHash, proofElement));
48             } else {
49                 // Hash(current element of the proof + current computed hash)
50                 computedHash = keccak256(abi.encodePacked(proofElement, computedHash));
51             }
52         }
53         return computedHash;
54     }
55 }
56 
57 // File: @openzeppelin/contracts/security/ReentrancyGuard.sol
58 
59 
60 // OpenZeppelin Contracts v4.4.1 (security/ReentrancyGuard.sol)
61 
62 pragma solidity ^0.8.11;
63 
64 /**
65  * @dev Contract module that helps prevent reentrant calls to a function.
66  *
67  * Inheriting from `ReentrancyGuard` will make the {nonReentrant} modifier
68  * available, which can be applied to functions to make sure there are no nested
69  * (reentrant) calls to them.
70  *
71  * Note that because there is a single `nonReentrant` guard, functions marked as
72  * `nonReentrant` may not call one another. This can be worked around by making
73  * those functions `private`, and then adding `external` `nonReentrant` entry
74  * points to them.
75  *
76  * TIP: If you would like to learn more about reentrancy and alternative ways
77  * to protect against it, check out our blog post
78  * https://blog.openzeppelin.com/reentrancy-after-istanbul/[Reentrancy After Istanbul].
79  */
80 abstract contract ReentrancyGuard {
81     // Booleans are more expensive than uint256 or any type that takes up a full
82     // word because each write operation emits an extra SLOAD to first read the
83     // slot's contents, replace the bits taken up by the boolean, and then write
84     // back. This is the compiler's defense against contract upgrades and
85     // pointer aliasing, and it cannot be disabled.
86 
87     // The values being non-zero value makes deployment a bit more expensive,
88     // but in exchange the refund on every call to nonReentrant will be lower in
89     // amount. Since refunds are capped to a percentage of the total
90     // transaction's gas, it is best to keep them low in cases like this one, to
91     // increase the likelihood of the full refund coming into effect.
92     uint256 private constant _NOT_ENTERED = 1;
93     uint256 private constant _ENTERED = 2;
94 
95     uint256 private _status;
96 
97     constructor() {
98         _status = _NOT_ENTERED;
99     }
100 
101     /**
102      * @dev Prevents a contract from calling itself, directly or indirectly.
103      * Calling a `nonReentrant` function from another `nonReentrant`
104      * function is not supported. It is possible to prevent this from happening
105      * by making the `nonReentrant` function external, and making it call a
106      * `private` function that does the actual work.
107      */
108     modifier nonReentrant() {
109         // On the first call to nonReentrant, _notEntered will be true
110         require(_status != _ENTERED, "ReentrancyGuard: reentrant call");
111 
112         // Any calls to nonReentrant after this point will fail
113         _status = _ENTERED;
114 
115         _;
116 
117         // By storing the original value once again, a refund is triggered (see
118         // https://eips.ethereum.org/EIPS/eip-2200)
119         _status = _NOT_ENTERED;
120     }
121 }
122 
123 // File: @openzeppelin/contracts/utils/Strings.sol
124 
125 
126 // OpenZeppelin Contracts v4.4.1 (utils/Strings.sol)
127 
128 pragma solidity ^0.8.11;
129 
130 /**
131  * @dev String operations.
132  */
133 library Strings {
134     bytes16 private constant _HEX_SYMBOLS = "0123456789abcdef";
135 
136     /**
137      * @dev Converts a `uint256` to its ASCII `string` decimal representation.
138      */
139     function toString(uint256 value) internal pure returns (string memory) {
140         // Inspired by OraclizeAPI's implementation - MIT licence
141         // https://github.com/oraclize/ethereum-api/blob/b42146b063c7d6ee1358846c198246239e9360e8/oraclizeAPI_0.4.25.sol
142 
143         if (value == 0) {
144             return "0";
145         }
146         uint256 temp = value;
147         uint256 digits;
148         while (temp != 0) {
149             digits++;
150             temp /= 10;
151         }
152         bytes memory buffer = new bytes(digits);
153         while (value != 0) {
154             digits -= 1;
155             buffer[digits] = bytes1(uint8(48 + uint256(value % 10)));
156             value /= 10;
157         }
158         return string(buffer);
159     }
160 
161     /**
162      * @dev Converts a `uint256` to its ASCII `string` hexadecimal representation.
163      */
164     function toHexString(uint256 value) internal pure returns (string memory) {
165         if (value == 0) {
166             return "0x00";
167         }
168         uint256 temp = value;
169         uint256 length = 0;
170         while (temp != 0) {
171             length++;
172             temp >>= 8;
173         }
174         return toHexString(value, length);
175     }
176 
177     /**
178      * @dev Converts a `uint256` to its ASCII `string` hexadecimal representation with fixed length.
179      */
180     function toHexString(uint256 value, uint256 length) internal pure returns (string memory) {
181         bytes memory buffer = new bytes(2 * length + 2);
182         buffer[0] = "0";
183         buffer[1] = "x";
184         for (uint256 i = 2 * length + 1; i > 1; --i) {
185             buffer[i] = _HEX_SYMBOLS[value & 0xf];
186             value >>= 4;
187         }
188         require(value == 0, "Strings: hex length insufficient");
189         return string(buffer);
190     }
191 }
192 
193 // File: @openzeppelin/contracts/utils/Context.sol
194 
195 
196 // OpenZeppelin Contracts v4.4.1 (utils/Context.sol)
197 
198 pragma solidity ^0.8.11;
199 
200 /**
201  * @dev Provides information about the current execution context, including the
202  * sender of the transaction and its data. While these are generally available
203  * via msg.sender and msg.data, they should not be accessed in such a direct
204  * manner, since when dealing with meta-transactions the account sending and
205  * paying for execution may not be the actual sender (as far as an application
206  * is concerned).
207  *
208  * This contract is only required for intermediate, library-like contracts.
209  */
210 abstract contract Context {
211     function _msgSender() internal view virtual returns (address) {
212         return msg.sender;
213     }
214 
215     function _msgData() internal view virtual returns (bytes calldata) {
216         return msg.data;
217     }
218 }
219 
220 // File: @openzeppelin/contracts/access/Ownable.sol
221 
222 
223 // OpenZeppelin Contracts v4.4.1 (access/Ownable.sol)
224 
225 pragma solidity ^0.8.11;
226 
227 
228 /**
229  * @dev Contract module which provides a basic access control mechanism, where
230  * there is an account (an owner) that can be granted exclusive access to
231  * specific functions.
232  *
233  * By default, the owner account will be the one that deploys the contract. This
234  * can later be changed with {transferOwnership}.
235  *
236  * This module is used through inheritance. It will make available the modifier
237  * `onlyOwner`, which can be applied to your functions to restrict their use to
238  * the owner.
239  */
240 abstract contract Ownable is Context {
241     address private _owner;
242 
243     event OwnershipTransferred(address indexed previousOwner, address indexed newOwner);
244 
245     /**
246      * @dev Initializes the contract setting the deployer as the initial owner.
247      */
248     constructor() {
249         _transferOwnership(_msgSender());
250     }
251 
252     /**
253      * @dev Returns the address of the current owner.
254      */
255     function owner() public view virtual returns (address) {
256         return _owner;
257     }
258 
259     /**
260      * @dev Throws if called by any account other than the owner.
261      */
262     modifier onlyOwner() {
263         require(owner() == _msgSender(), "Ownable: caller is not the owner");
264         _;
265     }
266 
267     /**
268      * @dev Leaves the contract without owner. It will not be possible to call
269      * `onlyOwner` functions anymore. Can only be called by the current owner.
270      *
271      * NOTE: Renouncing ownership will leave the contract without an owner,
272      * thereby removing any functionality that is only available to the owner.
273      */
274     function renounceOwnership() public virtual onlyOwner {
275         _transferOwnership(address(0));
276     }
277 
278     /**
279      * @dev Transfers ownership of the contract to a new account (`newOwner`).
280      * Can only be called by the current owner.
281      */
282     function transferOwnership(address newOwner) public virtual onlyOwner {
283         require(newOwner != address(0), "Ownable: new owner is the zero address");
284         _transferOwnership(newOwner);
285     }
286 
287     /**
288      * @dev Transfers ownership of the contract to a new account (`newOwner`).
289      * Internal function without access restriction.
290      */
291     function _transferOwnership(address newOwner) internal virtual {
292         address oldOwner = _owner;
293         _owner = newOwner;
294         emit OwnershipTransferred(oldOwner, newOwner);
295     }
296 }
297 
298 // File: @openzeppelin/contracts/utils/Address.sol
299 
300 
301 // OpenZeppelin Contracts v4.4.1 (utils/Address.sol)
302 
303 pragma solidity ^0.8.11;
304 
305 /**
306  * @dev Collection of functions related to the address type
307  */
308 library Address {
309     /**
310      * @dev Returns true if `account` is a contract.
311      *
312      * [IMPORTANT]
313      * ====
314      * It is unsafe to assume that an address for which this function returns
315      * false is an externally-owned account (EOA) and not a contract.
316      *
317      * Among others, `isContract` will return false for the following
318      * types of addresses:
319      *
320      *  - an externally-owned account
321      *  - a contract in construction
322      *  - an address where a contract will be created
323      *  - an address where a contract lived, but was destroyed
324      * ====
325      */
326     function isContract(address account) internal view returns (bool) {
327         // This method relies on extcodesize, which returns 0 for contracts in
328         // construction, since the code is only stored at the end of the
329         // constructor execution.
330 
331         uint256 size;
332         assembly {
333             size := extcodesize(account)
334         }
335         return size > 0;
336     }
337 
338     /**
339      * @dev Replacement for Solidity's `transfer`: sends `amount` wei to
340      * `recipient`, forwarding all available gas and reverting on errors.
341      *
342      * https://eips.ethereum.org/EIPS/eip-1884[EIP1884] increases the gas cost
343      * of certain opcodes, possibly making contracts go over the 2300 gas limit
344      * imposed by `transfer`, making them unable to receive funds via
345      * `transfer`. {sendValue} removes this limitation.
346      *
347      * https://diligence.consensys.net/posts/2019/09/stop-using-soliditys-transfer-now/[Learn more].
348      *
349      * IMPORTANT: because control is transferred to `recipient`, care must be
350      * taken to not create reentrancy vulnerabilities. Consider using
351      * {ReentrancyGuard} or the
352      * https://solidity.readthedocs.io/en/v0.5.11/security-considerations.html#use-the-checks-effects-interactions-pattern[checks-effects-interactions pattern].
353      */
354     function sendValue(address payable recipient, uint256 amount) internal {
355         require(address(this).balance >= amount, "Address: insufficient balance");
356 
357         (bool success, ) = recipient.call{value: amount}("");
358         require(success, "Address: unable to send value, recipient may have reverted");
359     }
360 
361     /**
362      * @dev Performs a Solidity function call using a low level `call`. A
363      * plain `call` is an unsafe replacement for a function call: use this
364      * function instead.
365      *
366      * If `target` reverts with a revert reason, it is bubbled up by this
367      * function (like regular Solidity function calls).
368      *
369      * Returns the raw returned data. To convert to the expected return value,
370      * use https://solidity.readthedocs.io/en/latest/units-and-global-variables.html?highlight=abi.decode#abi-encoding-and-decoding-functions[`abi.decode`].
371      *
372      * Requirements:
373      *
374      * - `target` must be a contract.
375      * - calling `target` with `data` must not revert.
376      *
377      * _Available since v3.1._
378      */
379     function functionCall(address target, bytes memory data) internal returns (bytes memory) {
380         return functionCall(target, data, "Address: low-level call failed");
381     }
382 
383     /**
384      * @dev Same as {xref-Address-functionCall-address-bytes-}[`functionCall`], but with
385      * `errorMessage` as a fallback revert reason when `target` reverts.
386      *
387      * _Available since v3.1._
388      */
389     function functionCall(
390         address target,
391         bytes memory data,
392         string memory errorMessage
393     ) internal returns (bytes memory) {
394         return functionCallWithValue(target, data, 0, errorMessage);
395     }
396 
397     /**
398      * @dev Same as {xref-Address-functionCall-address-bytes-}[`functionCall`],
399      * but also transferring `value` wei to `target`.
400      *
401      * Requirements:
402      *
403      * - the calling contract must have an ETH balance of at least `value`.
404      * - the called Solidity function must be `payable`.
405      *
406      * _Available since v3.1._
407      */
408     function functionCallWithValue(
409         address target,
410         bytes memory data,
411         uint256 value
412     ) internal returns (bytes memory) {
413         return functionCallWithValue(target, data, value, "Address: low-level call with value failed");
414     }
415 
416     /**
417      * @dev Same as {xref-Address-functionCallWithValue-address-bytes-uint256-}[`functionCallWithValue`], but
418      * with `errorMessage` as a fallback revert reason when `target` reverts.
419      *
420      * _Available since v3.1._
421      */
422     function functionCallWithValue(
423         address target,
424         bytes memory data,
425         uint256 value,
426         string memory errorMessage
427     ) internal returns (bytes memory) {
428         require(address(this).balance >= value, "Address: insufficient balance for call");
429         require(isContract(target), "Address: call to non-contract");
430 
431         (bool success, bytes memory returndata) = target.call{value: value}(data);
432         return verifyCallResult(success, returndata, errorMessage);
433     }
434 
435     /**
436      * @dev Same as {xref-Address-functionCall-address-bytes-}[`functionCall`],
437      * but performing a static call.
438      *
439      * _Available since v3.3._
440      */
441     function functionStaticCall(address target, bytes memory data) internal view returns (bytes memory) {
442         return functionStaticCall(target, data, "Address: low-level static call failed");
443     }
444 
445     /**
446      * @dev Same as {xref-Address-functionCall-address-bytes-string-}[`functionCall`],
447      * but performing a static call.
448      *
449      * _Available since v3.3._
450      */
451     function functionStaticCall(
452         address target,
453         bytes memory data,
454         string memory errorMessage
455     ) internal view returns (bytes memory) {
456         require(isContract(target), "Address: static call to non-contract");
457 
458         (bool success, bytes memory returndata) = target.staticcall(data);
459         return verifyCallResult(success, returndata, errorMessage);
460     }
461 
462     /**
463      * @dev Same as {xref-Address-functionCall-address-bytes-}[`functionCall`],
464      * but performing a delegate call.
465      *
466      * _Available since v3.4._
467      */
468     function functionDelegateCall(address target, bytes memory data) internal returns (bytes memory) {
469         return functionDelegateCall(target, data, "Address: low-level delegate call failed");
470     }
471 
472     /**
473      * @dev Same as {xref-Address-functionCall-address-bytes-string-}[`functionCall`],
474      * but performing a delegate call.
475      *
476      * _Available since v3.4._
477      */
478     function functionDelegateCall(
479         address target,
480         bytes memory data,
481         string memory errorMessage
482     ) internal returns (bytes memory) {
483         require(isContract(target), "Address: delegate call to non-contract");
484 
485         (bool success, bytes memory returndata) = target.delegatecall(data);
486         return verifyCallResult(success, returndata, errorMessage);
487     }
488 
489     /**
490      * @dev Tool to verifies that a low level call was successful, and revert if it wasn't, either by bubbling the
491      * revert reason using the provided one.
492      *
493      * _Available since v4.3._
494      */
495     function verifyCallResult(
496         bool success,
497         bytes memory returndata,
498         string memory errorMessage
499     ) internal pure returns (bytes memory) {
500         if (success) {
501             return returndata;
502         } else {
503             // Look for revert reason and bubble it up if present
504             if (returndata.length > 0) {
505                 // The easiest way to bubble the revert reason is using memory via assembly
506 
507                 assembly {
508                     let returndata_size := mload(returndata)
509                     revert(add(32, returndata), returndata_size)
510                 }
511             } else {
512                 revert(errorMessage);
513             }
514         }
515     }
516 }
517 
518 // File: @openzeppelin/contracts/token/ERC721/IERC721Receiver.sol
519 
520 
521 // OpenZeppelin Contracts v4.4.1 (token/ERC721/IERC721Receiver.sol)
522 
523 pragma solidity ^0.8.11;
524 
525 /**
526  * @title ERC721 token receiver interface
527  * @dev Interface for any contract that wants to support safeTransfers
528  * from ERC721 asset contracts.
529  */
530 interface IERC721Receiver {
531     /**
532      * @dev Whenever an {IERC721} `tokenId` token is transferred to this contract via {IERC721-safeTransferFrom}
533      * by `operator` from `from`, this function is called.
534      *
535      * It must return its Solidity selector to confirm the token transfer.
536      * If any other value is returned or the interface is not implemented by the recipient, the transfer will be reverted.
537      *
538      * The selector can be obtained in Solidity with `IERC721.onERC721Received.selector`.
539      */
540     function onERC721Received(
541         address operator,
542         address from,
543         uint256 tokenId,
544         bytes calldata data
545     ) external returns (bytes4);
546 }
547 
548 // File: @openzeppelin/contracts/utils/introspection/IERC165.sol
549 
550 
551 // OpenZeppelin Contracts v4.4.1 (utils/introspection/IERC165.sol)
552 
553 pragma solidity ^0.8.11;
554 
555 /**
556  * @dev Interface of the ERC165 standard, as defined in the
557  * https://eips.ethereum.org/EIPS/eip-165[EIP].
558  *
559  * Implementers can declare support of contract interfaces, which can then be
560  * queried by others ({ERC165Checker}).
561  *
562  * For an implementation, see {ERC165}.
563  */
564 interface IERC165 {
565     /**
566      * @dev Returns true if this contract implements the interface defined by
567      * `interfaceId`. See the corresponding
568      * https://eips.ethereum.org/EIPS/eip-165#how-interfaces-are-identified[EIP section]
569      * to learn more about how these ids are created.
570      *
571      * This function call must use less than 30 000 gas.
572      */
573     function supportsInterface(bytes4 interfaceId) external view returns (bool);
574 }
575 
576 // File: @openzeppelin/contracts/utils/introspection/ERC165.sol
577 
578 
579 // OpenZeppelin Contracts v4.4.1 (utils/introspection/ERC165.sol)
580 
581 pragma solidity ^0.8.11;
582 
583 
584 /**
585  * @dev Implementation of the {IERC165} interface.
586  *
587  * Contracts that want to implement ERC165 should inherit from this contract and override {supportsInterface} to check
588  * for the additional interface id that will be supported. For example:
589  *
590  * ```solidity
591  * function supportsInterface(bytes4 interfaceId) public view virtual override returns (bool) {
592  *     return interfaceId == type(MyInterface).interfaceId || super.supportsInterface(interfaceId);
593  * }
594  * ```
595  *
596  * Alternatively, {ERC165Storage} provides an easier to use but more expensive implementation.
597  */
598 abstract contract ERC165 is IERC165 {
599     /**
600      * @dev See {IERC165-supportsInterface}.
601      */
602     function supportsInterface(bytes4 interfaceId) public view virtual override returns (bool) {
603         return interfaceId == type(IERC165).interfaceId;
604     }
605 }
606 
607 // File: @openzeppelin/contracts/token/ERC721/IERC721.sol
608 
609 
610 // OpenZeppelin Contracts v4.4.1 (token/ERC721/IERC721.sol)
611 
612 pragma solidity ^0.8.11;
613 
614 
615 /**
616  * @dev Required interface of an ERC721 compliant contract.
617  */
618 interface IERC721 is IERC165 {
619     /**
620      * @dev Emitted when `tokenId` token is transferred from `from` to `to`.
621      */
622     event Transfer(address indexed from, address indexed to, uint256 indexed tokenId);
623 
624     /**
625      * @dev Emitted when `owner` enables `approved` to manage the `tokenId` token.
626      */
627     event Approval(address indexed owner, address indexed approved, uint256 indexed tokenId);
628 
629     /**
630      * @dev Emitted when `owner` enables or disables (`approved`) `operator` to manage all of its assets.
631      */
632     event ApprovalForAll(address indexed owner, address indexed operator, bool approved);
633 
634     /**
635      * @dev Returns the number of tokens in ``owner``'s account.
636      */
637     function balanceOf(address owner) external view returns (uint256 balance);
638 
639     /**
640      * @dev Returns the owner of the `tokenId` token.
641      *
642      * Requirements:
643      *
644      * - `tokenId` must exist.
645      */
646     function ownerOf(uint256 tokenId) external view returns (address owner);
647 
648     /**
649      * @dev Safely transfers `tokenId` token from `from` to `to`, checking first that contract recipients
650      * are aware of the ERC721 protocol to prevent tokens from being forever locked.
651      *
652      * Requirements:
653      *
654      * - `from` cannot be the zero address.
655      * - `to` cannot be the zero address.
656      * - `tokenId` token must exist and be owned by `from`.
657      * - If the caller is not `from`, it must be have been allowed to move this token by either {approve} or {setApprovalForAll}.
658      * - If `to` refers to a smart contract, it must implement {IERC721Receiver-onERC721Received}, which is called upon a safe transfer.
659      *
660      * Emits a {Transfer} event.
661      */
662     function safeTransferFrom(
663         address from,
664         address to,
665         uint256 tokenId
666     ) external;
667 
668     /**
669      * @dev Transfers `tokenId` token from `from` to `to`.
670      *
671      * WARNING: Usage of this method is discouraged, use {safeTransferFrom} whenever possible.
672      *
673      * Requirements:
674      *
675      * - `from` cannot be the zero address.
676      * - `to` cannot be the zero address.
677      * - `tokenId` token must be owned by `from`.
678      * - If the caller is not `from`, it must be approved to move this token by either {approve} or {setApprovalForAll}.
679      *
680      * Emits a {Transfer} event.
681      */
682     function transferFrom(
683         address from,
684         address to,
685         uint256 tokenId
686     ) external;
687 
688     /**
689      * @dev Gives permission to `to` to transfer `tokenId` token to another account.
690      * The approval is cleared when the token is transferred.
691      *
692      * Only a single account can be approved at a time, so approving the zero address clears previous approvals.
693      *
694      * Requirements:
695      *
696      * - The caller must own the token or be an approved operator.
697      * - `tokenId` must exist.
698      *
699      * Emits an {Approval} event.
700      */
701     function approve(address to, uint256 tokenId) external;
702 
703     /**
704      * @dev Returns the account approved for `tokenId` token.
705      *
706      * Requirements:
707      *
708      * - `tokenId` must exist.
709      */
710     function getApproved(uint256 tokenId) external view returns (address operator);
711 
712     /**
713      * @dev Approve or remove `operator` as an operator for the caller.
714      * Operators can call {transferFrom} or {safeTransferFrom} for any token owned by the caller.
715      *
716      * Requirements:
717      *
718      * - The `operator` cannot be the caller.
719      *
720      * Emits an {ApprovalForAll} event.
721      */
722     function setApprovalForAll(address operator, bool _approved) external;
723 
724     /**
725      * @dev Returns if the `operator` is allowed to manage all of the assets of `owner`.
726      *
727      * See {setApprovalForAll}
728      */
729     function isApprovedForAll(address owner, address operator) external view returns (bool);
730 
731     /**
732      * @dev Safely transfers `tokenId` token from `from` to `to`.
733      *
734      * Requirements:
735      *
736      * - `from` cannot be the zero address.
737      * - `to` cannot be the zero address.
738      * - `tokenId` token must exist and be owned by `from`.
739      * - If the caller is not `from`, it must be approved to move this token by either {approve} or {setApprovalForAll}.
740      * - If `to` refers to a smart contract, it must implement {IERC721Receiver-onERC721Received}, which is called upon a safe transfer.
741      *
742      * Emits a {Transfer} event.
743      */
744     function safeTransferFrom(
745         address from,
746         address to,
747         uint256 tokenId,
748         bytes calldata data
749     ) external;
750 }
751 
752 // File: @openzeppelin/contracts/token/ERC721/extensions/IERC721Enumerable.sol
753 
754 
755 // OpenZeppelin Contracts v4.4.1 (token/ERC721/extensions/IERC721Enumerable.sol)
756 
757 pragma solidity ^0.8.11;
758 
759 
760 /**
761  * @title ERC-721 Non-Fungible Token Standard, optional enumeration extension
762  * @dev See https://eips.ethereum.org/EIPS/eip-721
763  */
764 interface IERC721Enumerable is IERC721 {
765     /**
766      * @dev Returns the total amount of tokens stored by the contract.
767      */
768     function totalSupply() external view returns (uint256);
769 
770     /**
771      * @dev Returns a token ID owned by `owner` at a given `index` of its token list.
772      * Use along with {balanceOf} to enumerate all of ``owner``'s tokens.
773      */
774     function tokenOfOwnerByIndex(address owner, uint256 index) external view returns (uint256 tokenId);
775 
776     /**
777      * @dev Returns a token ID at a given `index` of all the tokens stored by the contract.
778      * Use along with {totalSupply} to enumerate all tokens.
779      */
780     function tokenByIndex(uint256 index) external view returns (uint256);
781 }
782 
783 // File: @openzeppelin/contracts/token/ERC721/extensions/IERC721Metadata.sol
784 
785 
786 // OpenZeppelin Contracts v4.4.1 (token/ERC721/extensions/IERC721Metadata.sol)
787 
788 pragma solidity ^0.8.11;
789 
790 
791 /**
792  * @title ERC-721 Non-Fungible Token Standard, optional metadata extension
793  * @dev See https://eips.ethereum.org/EIPS/eip-721
794  */
795 interface IERC721Metadata is IERC721 {
796     /**
797      * @dev Returns the token collection name.
798      */
799     function name() external view returns (string memory);
800 
801     /**
802      * @dev Returns the token collection symbol.
803      */
804     function symbol() external view returns (string memory);
805 
806     /**
807      * @dev Returns the Uniform Resource Identifier (URI) for `tokenId` token.
808      */
809     function tokenURI(uint256 tokenId) external view returns (string memory);
810 }
811 
812 // File: contracts/Mochi/ERC721P.sol
813 
814 
815 pragma solidity ^0.8.10;
816 
817 abstract contract ERC721P is Context, ERC165, IERC721, IERC721Metadata {
818     using Address for address;
819     string private _name;
820     string private _symbol;
821     address[] internal _owners;
822     mapping(uint256 => address) private _tokenApprovals;
823     mapping(address => mapping(address => bool)) private _operatorApprovals;     
824     constructor(string memory name_, string memory symbol_) {
825         _name = name_;
826         _symbol = symbol_;
827     }     
828     function supportsInterface(bytes4 interfaceId) public view virtual override(ERC165, IERC165) returns (bool) {
829         return
830             interfaceId == type(IERC721).interfaceId ||
831             interfaceId == type(IERC721Metadata).interfaceId ||
832             super.supportsInterface(interfaceId);
833     }
834     function balanceOf(address owner) public view virtual override returns (uint256) {
835         require(owner != address(0), "ERC721: balance query for the zero address");
836         uint count = 0;
837         uint length = _owners.length;
838         for( uint i = 0; i < length; ++i ){
839           if( owner == _owners[i] ){
840             ++count;
841           }
842         }
843         delete length;
844         return count;
845     }
846     function ownerOf(uint256 tokenId) public view virtual override returns (address) {
847         address owner = _owners[tokenId];
848         require(owner != address(0), "ERC721: owner query for nonexistent token");
849         return owner;
850     }
851     function name() public view virtual override returns (string memory) {
852         return _name;
853     }
854     function symbol() public view virtual override returns (string memory) {
855         return _symbol;
856     }
857     function approve(address to, uint256 tokenId) public virtual override {
858         address owner = ERC721P.ownerOf(tokenId);
859         require(to != owner, "ERC721: approval to current owner");
860 
861         require(
862             _msgSender() == owner || isApprovedForAll(owner, _msgSender()),
863             "ERC721: approve caller is not owner nor approved for all"
864         );
865 
866         _approve(to, tokenId);
867     }
868     function getApproved(uint256 tokenId) public view virtual override returns (address) {
869         require(_exists(tokenId), "ERC721: approved query for nonexistent token");
870 
871         return _tokenApprovals[tokenId];
872     }
873     function setApprovalForAll(address operator, bool approved) public virtual override {
874         require(operator != _msgSender(), "ERC721: approve to caller");
875 
876         _operatorApprovals[_msgSender()][operator] = approved;
877         emit ApprovalForAll(_msgSender(), operator, approved);
878     }
879     function isApprovedForAll(address owner, address operator) public view virtual override returns (bool) {
880         return _operatorApprovals[owner][operator];
881     }
882     function transferFrom(
883         address from,
884         address to,
885         uint256 tokenId
886     ) public virtual override {
887         //solhint-disable-next-line max-line-length
888         require(_isApprovedOrOwner(_msgSender(), tokenId), "ERC721: transfer caller is not owner nor approved");
889 
890         _transfer(from, to, tokenId);
891     }
892     function safeTransferFrom(
893         address from,
894         address to,
895         uint256 tokenId
896     ) public virtual override {
897         safeTransferFrom(from, to, tokenId, "");
898     }
899     function safeTransferFrom(
900         address from,
901         address to,
902         uint256 tokenId,
903         bytes memory _data
904     ) public virtual override {
905         require(_isApprovedOrOwner(_msgSender(), tokenId), "ERC721: transfer caller is not owner nor approved");
906         _safeTransfer(from, to, tokenId, _data);
907     }     
908     function _safeTransfer(
909         address from,
910         address to,
911         uint256 tokenId,
912         bytes memory _data
913     ) internal virtual {
914         _transfer(from, to, tokenId);
915         require(_checkOnERC721Received(from, to, tokenId, _data), "ERC721: transfer to non ERC721Receiver implementer");
916     }
917 	function _exists(uint256 tokenId) internal view virtual returns (bool) {
918         return tokenId < _owners.length && _owners[tokenId] != address(0);
919     }
920 	function _isApprovedOrOwner(address spender, uint256 tokenId) internal view virtual returns (bool) {
921         require(_exists(tokenId), "ERC721: operator query for nonexistent token");
922         address owner = ERC721P.ownerOf(tokenId);
923         return (spender == owner || getApproved(tokenId) == spender || isApprovedForAll(owner, spender));
924     }
925 	function _safeMint(address to, uint256 tokenId) internal virtual {
926         _safeMint(to, tokenId, "");
927     }
928 	function _safeMint(
929         address to,
930         uint256 tokenId,
931         bytes memory _data
932     ) internal virtual {
933         _mint(to, tokenId);
934         require(
935             _checkOnERC721Received(address(0), to, tokenId, _data),
936             "ERC721: transfer to non ERC721Receiver implementer"
937         );
938     }
939 	function _mint(address to, uint256 tokenId) internal virtual {
940         require(to != address(0), "ERC721: mint to the zero address");
941         require(!_exists(tokenId), "ERC721: token already minted");
942 
943         _beforeTokenTransfer(address(0), to, tokenId);
944         _owners.push(to);
945 
946         emit Transfer(address(0), to, tokenId);
947     }
948 	function _burn(uint256 tokenId) internal virtual {
949         address owner = ERC721P.ownerOf(tokenId);
950 
951         _beforeTokenTransfer(owner, address(0), tokenId);
952 
953         // Clear approvals
954         _approve(address(0), tokenId);
955         _owners[tokenId] = address(0);
956 
957         emit Transfer(owner, address(0), tokenId);
958     }
959 	function _transfer(
960         address from,
961         address to,
962         uint256 tokenId
963     ) internal virtual {
964         require(ERC721P.ownerOf(tokenId) == from, "ERC721: transfer of token that is not own");
965         require(to != address(0), "ERC721: transfer to the zero address");
966 
967         _beforeTokenTransfer(from, to, tokenId);
968 
969         // Clear approvals from the previous owner
970         _approve(address(0), tokenId);
971         _owners[tokenId] = to;
972 
973         emit Transfer(from, to, tokenId);
974     }
975 	function _approve(address to, uint256 tokenId) internal virtual {
976         _tokenApprovals[tokenId] = to;
977         emit Approval(ERC721P.ownerOf(tokenId), to, tokenId);
978     }
979 	function _checkOnERC721Received(
980         address from,
981         address to,
982         uint256 tokenId,
983         bytes memory _data
984     ) private returns (bool) {
985         if (to.isContract()) {
986             try IERC721Receiver(to).onERC721Received(_msgSender(), from, tokenId, _data) returns (bytes4 retval) {
987                 return retval == IERC721Receiver.onERC721Received.selector;
988             } catch (bytes memory reason) {
989                 if (reason.length == 0) {
990                     revert("ERC721: transfer to non ERC721Receiver implementer");
991                 } else {
992                     assembly {
993                         revert(add(32, reason), mload(reason))
994                     }
995                 }
996             }
997         } else {
998             return true;
999         }
1000     }
1001 	function _beforeTokenTransfer(
1002         address from,
1003         address to,
1004         uint256 tokenId
1005     ) internal virtual {}
1006 }
1007 // File: contracts/Mochi/ERC721Enum.sol
1008 
1009 
1010 pragma solidity ^0.8.10;
1011 
1012 
1013 abstract contract ERC721Enum is ERC721P, IERC721Enumerable {
1014     function supportsInterface(bytes4 interfaceId) public view virtual override(IERC165, ERC721P) returns (bool) {
1015         return interfaceId == type(IERC721Enumerable).interfaceId || super.supportsInterface(interfaceId);
1016     }
1017     function tokenOfOwnerByIndex(address owner, uint256 index) public view override returns (uint256 tokenId) {
1018         require(index < ERC721P.balanceOf(owner), "ERC721Enum: owner ioob");
1019         uint count;
1020         for( uint i; i < _owners.length; ++i ){
1021             if( owner == _owners[i] ){
1022                 if( count == index )
1023                     return i;
1024                 else
1025                     ++count;
1026             }
1027         }
1028         require(false, "ERC721Enum: owner ioob");
1029     }
1030     function tokensOfOwner(address owner) public view returns (uint256[] memory) {
1031         require(0 < ERC721P.balanceOf(owner), "ERC721Enum: owner ioob");
1032         uint256 tokenCount = balanceOf(owner);
1033         uint256[] memory tokenIds = new uint256[](tokenCount);
1034         for (uint256 i = 0; i < tokenCount; i++) {
1035             tokenIds[i] = tokenOfOwnerByIndex(owner, i);
1036         }
1037         return tokenIds;
1038     }
1039     function totalSupply() public view virtual override returns (uint256) {
1040         return _owners.length;
1041     }
1042     function tokenByIndex(uint256 index) public view virtual override returns (uint256) {
1043         require(index < ERC721Enum.totalSupply(), "ERC721Enum: global ioob");
1044         return index;
1045     }
1046 }
1047 // File: contracts/moshimochi.sol
1048 
1049 
1050 pragma solidity ^0.8.11;
1051 
1052 
1053 contract MoshiMochi is ERC721Enum, Ownable, ReentrancyGuard {
1054 	using Strings for uint256;
1055 	string private baseURI;
1056 	bool public revealed = false;
1057 	string public baseExtension =".json";
1058     string public notRevealedUri;
1059 	uint256 public reserved = 80;
1060 	
1061 	//Sale Settings
1062 	uint256 public cost = 0.035 ether;
1063 	uint256 public maxSupply = 8000;
1064 	uint256 public maxMint = 10;
1065 	bool public publicSaleOpen = false; // Sale is not active
1066     bool public preSaleIsActive = false; // Presale is not active
1067 
1068 	// Whitelist Sale Settings
1069 	bytes32 public merkleRoot = ""; // Construct this from (address, amount) tuple elements
1070 	mapping(address => uint) public whitelistRemaining; // // Maps user address to their remaining mints if they have minted some but not all of their allocation
1071 	mapping(address => bool) public whitelistClaimed; // Maps user address to bool, true if user has minted
1072 	uint256 public constant maxMintAmount = 5; //Reserved for WLs 5 Per TX
1073 	
1074 
1075 	event Mint(address indexed owner, uint indexed tokenId);
1076 
1077 	constructor(
1078 	string memory _initBaseURI,
1079     string memory _initNotRevealedUri) 
1080     ERC721P("Moshi Mochi", "MOSHI") {
1081         setBaseURI(_initBaseURI);
1082         setNotRevealedURI(_initNotRevealedUri);
1083     }
1084 
1085 	function _baseURI() internal view virtual returns (string memory) {
1086 	return baseURI;
1087 	}
1088 
1089     // Sale active/inactive
1090 
1091 	function setPublicSale(bool val) public onlyOwner {
1092         publicSaleOpen = val;
1093     }
1094 
1095     function setPreSale(bool val) public onlyOwner {
1096         preSaleIsActive = val;
1097     }
1098 
1099 	// Minting Functionalities -- Public Sale & Sale Reservations for the Project
1100 
1101 	function mint(uint256 amount) public payable nonReentrant{
1102 	require(publicSaleOpen, "Sale is not Active" );
1103 	uint256 s = totalSupply();
1104 	require(amount > 0, "need to mint at least 1" );
1105 	require(amount <= maxMint, "max mint amount per session exceeded");
1106 	require(s + amount <= maxSupply, "max NFT limit exceeded" );
1107 	require(msg.value >= cost * amount, "Value is over or under price.");
1108 	for (uint256 i = 0; i < amount; ++i) {
1109 	_safeMint(msg.sender, s + i, "");
1110 	}
1111 	}
1112 
1113 	function mintReserved(uint256 _amount) public onlyOwner {
1114         // Limited to a publicly set amount
1115         require( _amount <= reserved, "Can't reserve more than set amount" );
1116         reserved -= _amount;
1117         uint256 s = totalSupply();
1118         for(uint256 i; i < _amount; i++){
1119             _safeMint( msg.sender, s + i );
1120         }
1121         delete s;
1122 	}
1123     
1124 
1125     function whitelistMint(uint amount, bytes32 leaf, bytes32[] memory proof) external payable {
1126         require(preSaleIsActive, "Sale is not Active" );
1127     // Verify that (msg.sender, amount) correspond to Merkle leaf
1128     require(keccak256(abi.encodePacked(msg.sender)) == leaf, "Sender and amount don't match Merkle leaf");
1129 
1130      // Verify that (leaf, proof) matches the Merkle root
1131      require(verify(merkleRoot, leaf, proof), "Not a valid leaf in the Merkle tree");
1132 
1133 
1134     uint256 s = totalSupply();
1135     require(s + amount <= maxSupply, "Sold out");
1136     require(amount <= maxMintAmount, "Surpasses maxMintAmount");
1137 
1138     // Require nonzero amount
1139     require(amount > 0, "Can't mint zero");
1140 
1141     // Check proper amount sent
1142     require(msg.value == amount * cost, "Send proper ETH amount");
1143 
1144     require(whitelistRemaining[msg.sender] + amount <= maxMintAmount, "Can't mint more than remaining allocation");
1145 
1146     whitelistRemaining[msg.sender] += amount;
1147 
1148     for (uint256 i = 0; i < amount; ++i) {
1149     _safeMint(msg.sender, s + i, "");
1150     }
1151 	}
1152 
1153 	function verify(bytes32 _merkleRoot, bytes32 leaf, bytes32[] memory proof) public pure returns (bool) {
1154         return MerkleProof.verify(proof, _merkleRoot, leaf);
1155     }
1156 
1157     // baseURIs
1158 
1159 	function reveal() public onlyOwner() {
1160       revealed = true;
1161 	  }
1162 	  
1163 	  function tokenURI(uint256 tokenId)
1164     public
1165     view
1166     virtual
1167     override
1168     returns (string memory)
1169   {
1170     require(
1171       _exists(tokenId),
1172       "ERC721Metadata: URI query for nonexistent token"
1173     );
1174     
1175     if(revealed == false) {
1176         return notRevealedUri;
1177     }
1178 
1179     string memory currentBaseURI = _baseURI();
1180     return bytes(currentBaseURI).length > 0
1181         ? string(abi.encodePacked(currentBaseURI, tokenId.toString(), baseExtension))
1182         : "";
1183   }
1184 
1185 	function setNotRevealedURI(string memory _notRevealedURI) public onlyOwner {
1186     notRevealedUri = _notRevealedURI;
1187   }
1188 
1189     function setBaseURI(string memory _newBaseURI) public onlyOwner {
1190 	baseURI = _newBaseURI;
1191 	}
1192 
1193 	//General
1194 
1195 	function setCost(uint256 _newCost) public onlyOwner {
1196 	cost = _newCost;
1197 	}
1198 
1199 	function setMaxMintAmount(uint256 _newMaxMintAmount) public onlyOwner {
1200 	maxMint = _newMaxMintAmount;
1201 	}
1202 
1203 	function setmaxSupply(uint256 _newMaxSupply) public onlyOwner {
1204 	maxSupply = _newMaxSupply;
1205 	}
1206 
1207 	function setMerkleRoot(bytes32 _merkleRoot) public onlyOwner {
1208         merkleRoot = _merkleRoot;
1209     }
1210 
1211 	function withdraw() public payable onlyOwner {
1212     (bool mm, ) = payable(owner()).call{value: address(this).balance}("");
1213     require(mm);
1214   }
1215 }