1 // SPDX-License-Identifier: MIT
2 pragma solidity 0.8.9;
3 
4 /// @title Zodiac Project X TAS
5 /// @author André Costa @ Terratecc
6 
7 
8 // File: @openzeppelin/contracts/security/ReentrancyGuard.sol
9 
10 
11 // OpenZeppelin Contracts v4.4.1 (security/ReentrancyGuard.sol)
12 
13 pragma solidity ^0.8.0;
14 
15 /**
16  * @dev Contract module that helps prevent reentrant calls to a function.
17  *
18  * Inheriting from `ReentrancyGuard` will make the {nonReentrant} modifier
19  * available, which can be applied to functions to make sure there are no nested
20  * (reentrant) calls to them.
21  *
22  * Note that because there is a single `nonReentrant` guard, functions marked as
23  * `nonReentrant` may not call one another. This can be worked around by making
24  * those functions `private`, and then adding `external` `nonReentrant` entry
25  * points to them.
26  *
27  * TIP: If you would like to learn more about reentrancy and alternative ways
28  * to protect against it, check out our blog post
29  * https://blog.openzeppelin.com/reentrancy-after-istanbul/[Reentrancy After Istanbul].
30  */
31 abstract contract ReentrancyGuard {
32     // Booleans are more expensive than uint256 or any type that takes up a full
33     // word because each write operation emits an extra SLOAD to first read the
34     // slot's contents, replace the bits taken up by the boolean, and then write
35     // back. This is the compiler's defense against contract upgrades and
36     // pointer aliasing, and it cannot be disabled.
37 
38     // The values being non-zero value makes deployment a bit more expensive,
39     // but in exchange the refund on every call to nonReentrant will be lower in
40     // amount. Since refunds are capped to a percentage of the total
41     // transaction's gas, it is best to keep them low in cases like this one, to
42     // increase the likelihood of the full refund coming into effect.
43     uint256 private constant _NOT_ENTERED = 1;
44     uint256 private constant _ENTERED = 2;
45 
46     uint256 private _status;
47 
48     constructor() {
49         _status = _NOT_ENTERED;
50     }
51 
52     /**
53      * @dev Prevents a contract from calling itself, directly or indirectly.
54      * Calling a `nonReentrant` function from another `nonReentrant`
55      * function is not supported. It is possible to prevent this from happening
56      * by making the `nonReentrant` function external, and making it call a
57      * `private` function that does the actual work.
58      */
59     modifier nonReentrant() {
60         // On the first call to nonReentrant, _notEntered will be true
61         require(_status != _ENTERED, "ReentrancyGuard: reentrant call");
62 
63         // Any calls to nonReentrant after this point will fail
64         _status = _ENTERED;
65 
66         _;
67 
68         // By storing the original value once again, a refund is triggered (see
69         // https://eips.ethereum.org/EIPS/eip-2200)
70         _status = _NOT_ENTERED;
71     }
72 }
73 
74 // File: @openzeppelin/contracts/utils/Context.sol
75 
76 
77 // OpenZeppelin Contracts v4.4.0 (utils/Context.sol)
78 
79 pragma solidity ^0.8.0;
80 
81 /**
82  * @dev Provides information about the current execution context, including the
83  * sender of the transaction and its data. While these are generally available
84  * via msg.sender and msg.data, they should not be accessed in such a direct
85  * manner, since when dealing with meta-transactions the account sending and
86  * paying for execution may not be the actual sender (as far as an application
87  * is concerned).
88  *
89  * This contract is only required for intermediate, library-like contracts.
90  */
91 abstract contract Context {
92     function _msgSender() internal view virtual returns (address) {
93         return msg.sender;
94     }
95 
96     function _msgData() internal view virtual returns (bytes calldata) {
97         return msg.data;
98     }
99 }
100 
101 // File: @openzeppelin/contracts/access/Ownable.sol
102 
103 
104 // OpenZeppelin Contracts v4.4.0 (access/Ownable.sol)
105 
106 pragma solidity ^0.8.0;
107 
108 
109 /**
110  * @dev Contract module which provides a basic access control mechanism, where
111  * there is an account (an owner) that can be granted exclusive access to
112  * specific functions.
113  *
114  * By default, the owner account will be the one that deploys the contract. This
115  * can later be changed with {transferOwnership}.
116  *
117  * This module is used through inheritance. It will make available the modifier
118  * `onlyOwner`, which can be applied to your functions to restrict their use to
119  * the owner.
120  */
121 abstract contract Ownable is Context {
122     address private _owner;
123 
124     event OwnershipTransferred(address indexed previousOwner, address indexed newOwner);
125 
126     /**
127      * @dev Initializes the contract setting the deployer as the initial owner.
128      */
129     constructor() {
130         _transferOwnership(_msgSender());
131     }
132 
133     /**
134      * @dev Returns the address of the current owner.
135      */
136     function owner() public view virtual returns (address) {
137         return _owner;
138     }
139 
140     /**
141      * @dev Throws if called by any account other than the owner.
142      */
143     modifier onlyOwner() {
144         require(owner() == _msgSender(), "Ownable: caller is not the owner");
145         _;
146     }
147 
148     /**
149      * @dev Leaves the contract without owner. It will not be possible to call
150      * `onlyOwner` functions anymore. Can only be called by the current owner.
151      *
152      * NOTE: Renouncing ownership will leave the contract without an owner,
153      * thereby removing any functionality that is only available to the owner.
154      */
155     function renounceOwnership() public virtual onlyOwner {
156         _transferOwnership(address(0));
157     }
158 
159     /**
160      * @dev Transfers ownership of the contract to a new account (`newOwner`).
161      * Can only be called by the current owner.
162      */
163     function transferOwnership(address newOwner) public virtual onlyOwner {
164         require(newOwner != address(0), "Ownable: new owner is the zero address");
165         _transferOwnership(newOwner);
166     }
167 
168     /**
169      * @dev Transfers ownership of the contract to a new account (`newOwner`).
170      * Internal function without access restriction.
171      */
172     function _transferOwnership(address newOwner) internal virtual {
173         address oldOwner = _owner;
174         _owner = newOwner;
175         emit OwnershipTransferred(oldOwner, newOwner);
176     }
177 }
178 
179 // File: @openzeppelin/contracts/utils/Address.sol
180 
181 
182 // OpenZeppelin Contracts (last updated v4.5.0) (utils/Address.sol)
183 
184 pragma solidity ^0.8.1;
185 
186 /**
187  * @dev Collection of functions related to the address type
188  */
189 library Address {
190     /**
191      * @dev Returns true if `account` is a contract.
192      *
193      * [IMPORTANT]
194      * ====
195      * It is unsafe to assume that an address for which this function returns
196      * false is an externally-owned account (EOA) and not a contract.
197      *
198      * Among others, `isContract` will return false for the following
199      * types of addresses:
200      *
201      *  - an externally-owned account
202      *  - a contract in construction
203      *  - an address where a contract will be created
204      *  - an address where a contract lived, but was destroyed
205      * ====
206      *
207      * [IMPORTANT]
208      * ====
209      * You shouldn't rely on `isContract` to protect against flash loan attacks!
210      *
211      * Preventing calls from contracts is highly discouraged. It breaks composability, breaks support for smart wallets
212      * like Gnosis Safe, and does not provide security since it can be circumvented by calling from a contract
213      * constructor.
214      * ====
215      */
216     function isContract(address account) internal view returns (bool) {
217         // This method relies on extcodesize/address.code.length, which returns 0
218         // for contracts in construction, since the code is only stored at the end
219         // of the constructor execution.
220 
221         return account.code.length > 0;
222     }
223 
224     /**
225      * @dev Replacement for Solidity's `transfer`: sends `amount` wei to
226      * `recipient`, forwarding all available gas and reverting on errors.
227      *
228      * https://eips.ethereum.org/EIPS/eip-1884[EIP1884] increases the gas cost
229      * of certain opcodes, possibly making contracts go over the 2300 gas limit
230      * imposed by `transfer`, making them unable to receive funds via
231      * `transfer`. {sendValue} removes this limitation.
232      *
233      * https://diligence.consensys.net/posts/2019/09/stop-using-soliditys-transfer-now/[Learn more].
234      *
235      * IMPORTANT: because control is transferred to `recipient`, care must be
236      * taken to not create reentrancy vulnerabilities. Consider using
237      * {ReentrancyGuard} or the
238      * https://solidity.readthedocs.io/en/v0.5.11/security-considerations.html#use-the-checks-effects-interactions-pattern[checks-effects-interactions pattern].
239      */
240     function sendValue(address payable recipient, uint256 amount) internal {
241         require(address(this).balance >= amount, "Address: insufficient balance");
242 
243         (bool success, ) = recipient.call{value: amount}("");
244         require(success, "Address: unable to send value, recipient may have reverted");
245     }
246 
247     /**
248      * @dev Performs a Solidity function call using a low level `call`. A
249      * plain `call` is an unsafe replacement for a function call: use this
250      * function instead.
251      *
252      * If `target` reverts with a revert reason, it is bubbled up by this
253      * function (like regular Solidity function calls).
254      *
255      * Returns the raw returned data. To convert to the expected return value,
256      * use https://solidity.readthedocs.io/en/latest/units-and-global-variables.html?highlight=abi.decode#abi-encoding-and-decoding-functions[`abi.decode`].
257      *
258      * Requirements:
259      *
260      * - `target` must be a contract.
261      * - calling `target` with `data` must not revert.
262      *
263      * _Available since v3.1._
264      */
265     function functionCall(address target, bytes memory data) internal returns (bytes memory) {
266         return functionCall(target, data, "Address: low-level call failed");
267     }
268 
269     /**
270      * @dev Same as {xref-Address-functionCall-address-bytes-}[`functionCall`], but with
271      * `errorMessage` as a fallback revert reason when `target` reverts.
272      *
273      * _Available since v3.1._
274      */
275     function functionCall(
276         address target,
277         bytes memory data,
278         string memory errorMessage
279     ) internal returns (bytes memory) {
280         return functionCallWithValue(target, data, 0, errorMessage);
281     }
282 
283     /**
284      * @dev Same as {xref-Address-functionCall-address-bytes-}[`functionCall`],
285      * but also transferring `value` wei to `target`.
286      *
287      * Requirements:
288      *
289      * - the calling contract must have an ETH balance of at least `value`.
290      * - the called Solidity function must be `payable`.
291      *
292      * _Available since v3.1._
293      */
294     function functionCallWithValue(
295         address target,
296         bytes memory data,
297         uint256 value
298     ) internal returns (bytes memory) {
299         return functionCallWithValue(target, data, value, "Address: low-level call with value failed");
300     }
301 
302     /**
303      * @dev Same as {xref-Address-functionCallWithValue-address-bytes-uint256-}[`functionCallWithValue`], but
304      * with `errorMessage` as a fallback revert reason when `target` reverts.
305      *
306      * _Available since v3.1._
307      */
308     function functionCallWithValue(
309         address target,
310         bytes memory data,
311         uint256 value,
312         string memory errorMessage
313     ) internal returns (bytes memory) {
314         require(address(this).balance >= value, "Address: insufficient balance for call");
315         require(isContract(target), "Address: call to non-contract");
316 
317         (bool success, bytes memory returndata) = target.call{value: value}(data);
318         return verifyCallResult(success, returndata, errorMessage);
319     }
320 
321     /**
322      * @dev Same as {xref-Address-functionCall-address-bytes-}[`functionCall`],
323      * but performing a static call.
324      *
325      * _Available since v3.3._
326      */
327     function functionStaticCall(address target, bytes memory data) internal view returns (bytes memory) {
328         return functionStaticCall(target, data, "Address: low-level static call failed");
329     }
330 
331     /**
332      * @dev Same as {xref-Address-functionCall-address-bytes-string-}[`functionCall`],
333      * but performing a static call.
334      *
335      * _Available since v3.3._
336      */
337     function functionStaticCall(
338         address target,
339         bytes memory data,
340         string memory errorMessage
341     ) internal view returns (bytes memory) {
342         require(isContract(target), "Address: static call to non-contract");
343 
344         (bool success, bytes memory returndata) = target.staticcall(data);
345         return verifyCallResult(success, returndata, errorMessage);
346     }
347 
348     /**
349      * @dev Same as {xref-Address-functionCall-address-bytes-}[`functionCall`],
350      * but performing a delegate call.
351      *
352      * _Available since v3.4._
353      */
354     function functionDelegateCall(address target, bytes memory data) internal returns (bytes memory) {
355         return functionDelegateCall(target, data, "Address: low-level delegate call failed");
356     }
357 
358     /**
359      * @dev Same as {xref-Address-functionCall-address-bytes-string-}[`functionCall`],
360      * but performing a delegate call.
361      *
362      * _Available since v3.4._
363      */
364     function functionDelegateCall(
365         address target,
366         bytes memory data,
367         string memory errorMessage
368     ) internal returns (bytes memory) {
369         require(isContract(target), "Address: delegate call to non-contract");
370 
371         (bool success, bytes memory returndata) = target.delegatecall(data);
372         return verifyCallResult(success, returndata, errorMessage);
373     }
374 
375     /**
376      * @dev Tool to verifies that a low level call was successful, and revert if it wasn't, either by bubbling the
377      * revert reason using the provided one.
378      *
379      * _Available since v4.3._
380      */
381     function verifyCallResult(
382         bool success,
383         bytes memory returndata,
384         string memory errorMessage
385     ) internal pure returns (bytes memory) {
386         if (success) {
387             return returndata;
388         } else {
389             // Look for revert reason and bubble it up if present
390             if (returndata.length > 0) {
391                 // The easiest way to bubble the revert reason is using memory via assembly
392 
393                 assembly {
394                     let returndata_size := mload(returndata)
395                     revert(add(32, returndata), returndata_size)
396                 }
397             } else {
398                 revert(errorMessage);
399             }
400         }
401     }
402 }
403 
404 // File: @openzeppelin/contracts/token/ERC721/IERC721Receiver.sol
405 
406 
407 // OpenZeppelin Contracts v4.4.1 (token/ERC721/IERC721Receiver.sol)
408 
409 pragma solidity ^0.8.0;
410 
411 /**
412  * @title ERC721 token receiver interface
413  * @dev Interface for any contract that wants to support safeTransfers
414  * from ERC721 asset contracts.
415  */
416 interface IERC721Receiver {
417     /**
418      * @dev Whenever an {IERC721} `tokenId` token is transferred to this contract via {IERC721-safeTransferFrom}
419      * by `operator` from `from`, this function is called.
420      *
421      * It must return its Solidity selector to confirm the token transfer.
422      * If any other value is returned or the interface is not implemented by the recipient, the transfer will be reverted.
423      *
424      * The selector can be obtained in Solidity with `IERC721.onERC721Received.selector`.
425      */
426     function onERC721Received(
427         address operator,
428         address from,
429         uint256 tokenId,
430         bytes calldata data
431     ) external returns (bytes4);
432 }
433 
434 // File: @openzeppelin/contracts/utils/introspection/IERC165.sol
435 
436 
437 // OpenZeppelin Contracts v4.4.1 (utils/introspection/IERC165.sol)
438 
439 pragma solidity ^0.8.0;
440 
441 /**
442  * @dev Interface of the ERC165 standard, as defined in the
443  * https://eips.ethereum.org/EIPS/eip-165[EIP].
444  *
445  * Implementers can declare support of contract interfaces, which can then be
446  * queried by others ({ERC165Checker}).
447  *
448  * For an implementation, see {ERC165}.
449  */
450 interface IERC165 {
451     /**
452      * @dev Returns true if this contract implements the interface defined by
453      * `interfaceId`. See the corresponding
454      * https://eips.ethereum.org/EIPS/eip-165#how-interfaces-are-identified[EIP section]
455      * to learn more about how these ids are created.
456      *
457      * This function call must use less than 30 000 gas.
458      */
459     function supportsInterface(bytes4 interfaceId) external view returns (bool);
460 }
461 
462 // File: @openzeppelin/contracts/utils/introspection/ERC165.sol
463 
464 
465 // OpenZeppelin Contracts v4.4.1 (utils/introspection/ERC165.sol)
466 
467 pragma solidity ^0.8.0;
468 
469 
470 /**
471  * @dev Implementation of the {IERC165} interface.
472  *
473  * Contracts that want to implement ERC165 should inherit from this contract and override {supportsInterface} to check
474  * for the additional interface id that will be supported. For example:
475  *
476  * ```solidity
477  * function supportsInterface(bytes4 interfaceId) public view virtual override returns (bool) {
478  *     return interfaceId == type(MyInterface).interfaceId || super.supportsInterface(interfaceId);
479  * }
480  * ```
481  *
482  * Alternatively, {ERC165Storage} provides an easier to use but more expensive implementation.
483  */
484 abstract contract ERC165 is IERC165 {
485     /**
486      * @dev See {IERC165-supportsInterface}.
487      */
488     function supportsInterface(bytes4 interfaceId) public view virtual override returns (bool) {
489         return interfaceId == type(IERC165).interfaceId;
490     }
491 }
492 
493 // File: @openzeppelin/contracts/token/ERC721/IERC721.sol
494 
495 
496 // OpenZeppelin Contracts v4.4.1 (token/ERC721/IERC721.sol)
497 
498 pragma solidity ^0.8.0;
499 
500 
501 /**
502  * @dev Required interface of an ERC721 compliant contract.
503  */
504 interface IERC721 is IERC165 {
505     /**
506      * @dev Emitted when `tokenId` token is transferred from `from` to `to`.
507      */
508     event Transfer(address indexed from, address indexed to, uint256 indexed tokenId);
509 
510     /**
511      * @dev Emitted when `owner` enables `approved` to manage the `tokenId` token.
512      */
513     event Approval(address indexed owner, address indexed approved, uint256 indexed tokenId);
514 
515     /**
516      * @dev Emitted when `owner` enables or disables (`approved`) `operator` to manage all of its assets.
517      */
518     event ApprovalForAll(address indexed owner, address indexed operator, bool approved);
519 
520     /**
521      * @dev Returns the number of tokens in ``owner``'s account.
522      */
523     function balanceOf(address owner) external view returns (uint256 balance);
524 
525     /**
526      * @dev Returns the owner of the `tokenId` token.
527      *
528      * Requirements:
529      *
530      * - `tokenId` must exist.
531      */
532     function ownerOf(uint256 tokenId) external view returns (address owner);
533 
534     /**
535      * @dev Safely transfers `tokenId` token from `from` to `to`, checking first that contract recipients
536      * are aware of the ERC721 protocol to prevent tokens from being forever locked.
537      *
538      * Requirements:
539      *
540      * - `from` cannot be the zero address.
541      * - `to` cannot be the zero address.
542      * - `tokenId` token must exist and be owned by `from`.
543      * - If the caller is not `from`, it must be have been allowed to move this token by either {approve} or {setApprovalForAll}.
544      * - If `to` refers to a smart contract, it must implement {IERC721Receiver-onERC721Received}, which is called upon a safe transfer.
545      *
546      * Emits a {Transfer} event.
547      */
548     function safeTransferFrom(
549         address from,
550         address to,
551         uint256 tokenId
552     ) external;
553 
554     /**
555      * @dev Transfers `tokenId` token from `from` to `to`.
556      *
557      * WARNING: Usage of this method is discouraged, use {safeTransferFrom} whenever possible.
558      *
559      * Requirements:
560      *
561      * - `from` cannot be the zero address.
562      * - `to` cannot be the zero address.
563      * - `tokenId` token must be owned by `from`.
564      * - If the caller is not `from`, it must be approved to move this token by either {approve} or {setApprovalForAll}.
565      *
566      * Emits a {Transfer} event.
567      */
568     function transferFrom(
569         address from,
570         address to,
571         uint256 tokenId
572     ) external;
573 
574     /**
575      * @dev Gives permission to `to` to transfer `tokenId` token to another account.
576      * The approval is cleared when the token is transferred.
577      *
578      * Only a single account can be approved at a time, so approving the zero address clears previous approvals.
579      *
580      * Requirements:
581      *
582      * - The caller must own the token or be an approved operator.
583      * - `tokenId` must exist.
584      *
585      * Emits an {Approval} event.
586      */
587     function approve(address to, uint256 tokenId) external;
588 
589     /**
590      * @dev Returns the account approved for `tokenId` token.
591      *
592      * Requirements:
593      *
594      * - `tokenId` must exist.
595      */
596     function getApproved(uint256 tokenId) external view returns (address operator);
597 
598     /**
599      * @dev Approve or remove `operator` as an operator for the caller.
600      * Operators can call {transferFrom} or {safeTransferFrom} for any token owned by the caller.
601      *
602      * Requirements:
603      *
604      * - The `operator` cannot be the caller.
605      *
606      * Emits an {ApprovalForAll} event.
607      */
608     function setApprovalForAll(address operator, bool _approved) external;
609 
610     /**
611      * @dev Returns if the `operator` is allowed to manage all of the assets of `owner`.
612      *
613      * See {setApprovalForAll}
614      */
615     function isApprovedForAll(address owner, address operator) external view returns (bool);
616 
617     /**
618      * @dev Safely transfers `tokenId` token from `from` to `to`.
619      *
620      * Requirements:
621      *
622      * - `from` cannot be the zero address.
623      * - `to` cannot be the zero address.
624      * - `tokenId` token must exist and be owned by `from`.
625      * - If the caller is not `from`, it must be approved to move this token by either {approve} or {setApprovalForAll}.
626      * - If `to` refers to a smart contract, it must implement {IERC721Receiver-onERC721Received}, which is called upon a safe transfer.
627      *
628      * Emits a {Transfer} event.
629      */
630     function safeTransferFrom(
631         address from,
632         address to,
633         uint256 tokenId,
634         bytes calldata data
635     ) external;
636 }
637 
638 // File: @openzeppelin/contracts/token/ERC721/extensions/IERC721Metadata.sol
639 
640 
641 // OpenZeppelin Contracts v4.4.1 (token/ERC721/extensions/IERC721Metadata.sol)
642 
643 pragma solidity ^0.8.0;
644 
645 
646 /**
647  * @title ERC-721 Non-Fungible Token Standard, optional metadata extension
648  * @dev See https://eips.ethereum.org/EIPS/eip-721
649  */
650 interface IERC721Metadata is IERC721 {
651     /**
652      * @dev Returns the token collection name.
653      */
654     function name() external view returns (string memory);
655 
656     /**
657      * @dev Returns the token collection symbol.
658      */
659     function symbol() external view returns (string memory);
660 
661     /**
662      * @dev Returns the Uniform Resource Identifier (URI) for `tokenId` token.
663      */
664     function tokenURI(uint256 tokenId) external view returns (string memory);
665 }
666 
667 
668 /**
669  * @dev String operations.
670  */
671 library Strings {
672     bytes16 private constant _HEX_SYMBOLS = "0123456789abcdef";
673 
674     /**
675      * @dev Converts a `uint256` to its ASCII `string` decimal representation.
676      */
677     function toString(uint256 value) internal pure returns (string memory) {
678         // Inspired by OraclizeAPI's implementation - MIT licence
679         // https://github.com/oraclize/ethereum-api/blob/b42146b063c7d6ee1358846c198246239e9360e8/oraclizeAPI_0.4.25.sol
680 
681         if (value == 0) {
682             return "0";
683         }
684         uint256 temp = value;
685         uint256 digits;
686         while (temp != 0) {
687             digits++;
688             temp /= 10;
689         }
690         bytes memory buffer = new bytes(digits);
691         while (value != 0) {
692             digits -= 1;
693             buffer[digits] = bytes1(uint8(48 + uint256(value % 10)));
694             value /= 10;
695         }
696         return string(buffer);
697     }
698 
699     /**
700      * @dev Converts a `uint256` to its ASCII `string` hexadecimal representation.
701      */
702     function toHexString(uint256 value) internal pure returns (string memory) {
703         if (value == 0) {
704             return "0x00";
705         }
706         uint256 temp = value;
707         uint256 length = 0;
708         while (temp != 0) {
709             length++;
710             temp >>= 8;
711         }
712         return toHexString(value, length);
713     }
714 
715     /**
716      * @dev Converts a `uint256` to its ASCII `string` hexadecimal representation with fixed length.
717      */
718     function toHexString(uint256 value, uint256 length) internal pure returns (string memory) {
719         bytes memory buffer = new bytes(2 * length + 2);
720         buffer[0] = "0";
721         buffer[1] = "x";
722         for (uint256 i = 2 * length + 1; i > 1; --i) {
723             buffer[i] = _HEX_SYMBOLS[value & 0xf];
724             value >>= 4;
725         }
726         require(value == 0, "Strings: hex length insufficient");
727         return string(buffer);
728     }
729 }
730 
731 
732 /**
733  * @dev These functions deal with verification of Merkle Trees proofs.
734  *
735  * The proofs can be generated using the JavaScript library
736  * https://github.com/miguelmota/merkletreejs[merkletreejs].
737  * Note: the hashing algorithm should be keccak256 and pair sorting should be enabled.
738  *
739  * See `test/utils/cryptography/MerkleProof.test.js` for some examples.
740  */
741 library MerkleProof {
742     /**
743      * @dev Returns true if a `leaf` can be proved to be a part of a Merkle tree
744      * defined by `root`. For this, a `proof` must be provided, containing
745      * sibling hashes on the branch from the leaf to the root of the tree. Each
746      * pair of leaves and each pair of pre-images are assumed to be sorted.
747      */
748     function verify(
749         bytes32[] memory proof,
750         bytes32 root,
751         bytes32 leaf
752     ) internal pure returns (bool) {
753         return processProof(proof, leaf) == root;
754     }
755 
756     /**
757      * @dev Returns the rebuilt hash obtained by traversing a Merklee tree up
758      * from `leaf` using `proof`. A `proof` is valid if and only if the rebuilt
759      * hash matches the root of the tree. When processing the proof, the pairs
760      * of leafs & pre-images are assumed to be sorted.
761      *
762      * _Available since v4.4._
763      */
764     function processProof(bytes32[] memory proof, bytes32 leaf) internal pure returns (bytes32) {
765         bytes32 computedHash = leaf;
766         for (uint256 i = 0; i < proof.length; i++) {
767             bytes32 proofElement = proof[i];
768             if (computedHash <= proofElement) {
769                 // Hash(current computed hash + current element of the proof)
770                 computedHash = keccak256(abi.encodePacked(computedHash, proofElement));
771             } else {
772                 // Hash(current element of the proof + current computed hash)
773                 computedHash = keccak256(abi.encodePacked(proofElement, computedHash));
774             }
775         }
776         return computedHash;
777     }
778 }
779 
780 
781 error ApprovalCallerNotOwnerNorApproved();
782 error ApprovalQueryForNonexistentToken();
783 error ApproveToCaller();
784 error ApprovalToCurrentOwner();
785 error BalanceQueryForZeroAddress();
786 error MintToZeroAddress();
787 error MintZeroQuantity();
788 error OwnerQueryForNonexistentToken();
789 error TransferCallerNotOwnerNorApproved();
790 error TransferFromIncorrectOwner();
791 error TransferToNonERC721ReceiverImplementer();
792 error TransferToZeroAddress();
793 error URIQueryForNonexistentToken();
794 
795 /**
796  * @dev Implementation of https://eips.ethereum.org/EIPS/eip-721[ERC721] Non-Fungible Token Standard, including
797  * the Metadata extension. Built to optimize for lower gas during batch mints.
798  *
799  * Assumes serials are sequentially minted starting at _startTokenId() (defaults to 0, e.g. 0, 1, 2, 3..).
800  *
801  * Assumes that an owner cannot have more than 2**64 - 1 (max value of uint64) of supply.
802  *
803  * Assumes that the maximum token id cannot exceed 2**256 - 1 (max value of uint256).
804  */
805 contract ERC721A is Context, ERC165, IERC721, IERC721Metadata {
806     using Address for address;
807     using Strings for uint256;
808 
809     // Compiler will pack this into a single 256bit word.
810     struct TokenOwnership {
811         // The address of the owner.
812         address addr;
813         // Keeps track of the start time of ownership with minimal overhead for tokenomics.
814         uint64 startTimestamp;
815         // Whether the token has been burned.
816         bool burned;
817     }
818 
819     // Compiler will pack this into a single 256bit word.
820     struct AddressData {
821         // Realistically, 2**64-1 is more than enough.
822         uint64 balance;
823         // Keeps track of mint count with minimal overhead for tokenomics.
824         uint64 numberMinted;
825         // Keeps track of burn count with minimal overhead for tokenomics.
826         uint64 numberBurned;
827         // For miscellaneous variable(s) pertaining to the address
828         // (e.g. number of whitelist mint slots used).
829         // If there are multiple variables, please pack them into a uint64.
830         uint64 aux;
831     }
832 
833     // The tokenId of the next token to be minted.
834     uint256 internal _currentIndex;
835 
836     // The number of tokens burned.
837     uint256 internal _burnCounter;
838 
839     // Token name
840     string private _name;
841 
842     // Token symbol
843     string private _symbol;
844 
845     // Mapping from token ID to ownership details
846     // An empty struct value does not necessarily mean the token is unowned. See _ownershipOf implementation for details.
847     mapping(uint256 => TokenOwnership) internal _ownerships;
848 
849     // Mapping owner address to address data
850     mapping(address => AddressData) private _addressData;
851 
852     // Mapping from token ID to approved address
853     mapping(uint256 => address) private _tokenApprovals;
854 
855     // Mapping from owner to operator approvals
856     mapping(address => mapping(address => bool)) private _operatorApprovals;
857 
858     constructor(string memory name_, string memory symbol_) {
859         _name = name_;
860         _symbol = symbol_;
861         _currentIndex = _startTokenId();
862     }
863 
864     /**
865      * To change the starting tokenId, please override this function.
866      */
867     function _startTokenId() internal view virtual returns (uint256) {
868         return 0;
869     }
870 
871     /**
872      * @dev Burned tokens are calculated here, use _totalMinted() if you want to count just minted tokens.
873      */
874     function totalSupply() public view returns (uint256) {
875         // Counter underflow is impossible as _burnCounter cannot be incremented
876         // more than _currentIndex - _startTokenId() times
877         unchecked {
878             return _currentIndex - _burnCounter - _startTokenId();
879         }
880     }
881 
882     /**
883      * Returns the total amount of tokens minted in the contract.
884      */
885     function _totalMinted() internal view returns (uint256) {
886         // Counter underflow is impossible as _currentIndex does not decrement,
887         // and it is initialized to _startTokenId()
888         unchecked {
889             return _currentIndex - _startTokenId();
890         }
891     }
892 
893     /**
894      * @dev See {IERC165-supportsInterface}.
895      */
896     function supportsInterface(bytes4 interfaceId) public view virtual override(ERC165, IERC165) returns (bool) {
897         return
898             interfaceId == type(IERC721).interfaceId ||
899             interfaceId == type(IERC721Metadata).interfaceId ||
900             super.supportsInterface(interfaceId);
901     }
902 
903     /**
904      * @dev See {IERC721-balanceOf}.
905      */
906     function balanceOf(address owner) public view override returns (uint256) {
907         if (owner == address(0)) revert BalanceQueryForZeroAddress();
908         return uint256(_addressData[owner].balance);
909     }
910 
911     /**
912      * Returns the number of tokens minted by `owner`.
913      */
914     function _numberMinted(address owner) internal view returns (uint256) {
915         return uint256(_addressData[owner].numberMinted);
916     }
917 
918     /**
919      * Returns the number of tokens burned by or on behalf of `owner`.
920      */
921     function _numberBurned(address owner) internal view returns (uint256) {
922         return uint256(_addressData[owner].numberBurned);
923     }
924 
925     /**
926      * Returns the auxillary data for `owner`. (e.g. number of whitelist mint slots used).
927      */
928     function _getAux(address owner) internal view returns (uint64) {
929         return _addressData[owner].aux;
930     }
931 
932     /**
933      * Sets the auxillary data for `owner`. (e.g. number of whitelist mint slots used).
934      * If there are multiple variables, please pack them into a uint64.
935      */
936     function _setAux(address owner, uint64 aux) internal {
937         _addressData[owner].aux = aux;
938     }
939 
940     /**
941      * Gas spent here starts off proportional to the maximum mint batch size.
942      * It gradually moves to O(1) as tokens get transferred around in the collection over time.
943      */
944     function _ownershipOf(uint256 tokenId) internal view returns (TokenOwnership memory) {
945         uint256 curr = tokenId;
946 
947         unchecked {
948             if (_startTokenId() <= curr && curr < _currentIndex) {
949                 TokenOwnership memory ownership = _ownerships[curr];
950                 if (!ownership.burned) {
951                     if (ownership.addr != address(0)) {
952                         return ownership;
953                     }
954                     // Invariant:
955                     // There will always be an ownership that has an address and is not burned
956                     // before an ownership that does not have an address and is not burned.
957                     // Hence, curr will not underflow.
958                     while (true) {
959                         curr--;
960                         ownership = _ownerships[curr];
961                         if (ownership.addr != address(0)) {
962                             return ownership;
963                         }
964                     }
965                 }
966             }
967         }
968         revert OwnerQueryForNonexistentToken();
969     }
970 
971     /**
972      * @dev See {IERC721-ownerOf}.
973      */
974     function ownerOf(uint256 tokenId) public view override returns (address) {
975         return _ownershipOf(tokenId).addr;
976     }
977 
978     /**
979      * @dev See {IERC721Metadata-name}.
980      */
981     function name() public view virtual override returns (string memory) {
982         return _name;
983     }
984 
985     /**
986      * @dev See {IERC721Metadata-symbol}.
987      */
988     function symbol() public view virtual override returns (string memory) {
989         return _symbol;
990     }
991 
992     /**
993      * @dev See {IERC721Metadata-tokenURI}.
994      */
995     function tokenURI(uint256 tokenId) public view virtual override returns (string memory) {
996         if (!_exists(tokenId)) revert URIQueryForNonexistentToken();
997 
998         string memory baseURI = _baseURI();
999         return bytes(baseURI).length != 0 ? string(abi.encodePacked(baseURI, tokenId.toString())) : '';
1000     }
1001 
1002     /**
1003      * @dev Base URI for computing {tokenURI}. If set, the resulting URI for each
1004      * token will be the concatenation of the `baseURI` and the `tokenId`. Empty
1005      * by default, can be overriden in child contracts.
1006      */
1007     function _baseURI() internal view virtual returns (string memory) {
1008         return '';
1009     }
1010 
1011     /**
1012      * @dev See {IERC721-approve}.
1013      */
1014     function approve(address to, uint256 tokenId) public override {
1015         address owner = ERC721A.ownerOf(tokenId);
1016         if (to == owner) revert ApprovalToCurrentOwner();
1017 
1018         if (_msgSender() != owner && !isApprovedForAll(owner, _msgSender())) {
1019             revert ApprovalCallerNotOwnerNorApproved();
1020         }
1021 
1022         _approve(to, tokenId, owner);
1023     }
1024 
1025     /**
1026      * @dev See {IERC721-getApproved}.
1027      */
1028     function getApproved(uint256 tokenId) public view override returns (address) {
1029         if (!_exists(tokenId)) revert ApprovalQueryForNonexistentToken();
1030 
1031         return _tokenApprovals[tokenId];
1032     }
1033 
1034     /**
1035      * @dev See {IERC721-setApprovalForAll}.
1036      */
1037     function setApprovalForAll(address operator, bool approved) public virtual override {
1038         if (operator == _msgSender()) revert ApproveToCaller();
1039 
1040         _operatorApprovals[_msgSender()][operator] = approved;
1041         emit ApprovalForAll(_msgSender(), operator, approved);
1042     }
1043 
1044     /**
1045      * @dev See {IERC721-isApprovedForAll}.
1046      */
1047     function isApprovedForAll(address owner, address operator) public view virtual override returns (bool) {
1048         return _operatorApprovals[owner][operator];
1049     }
1050 
1051     /**
1052      * @dev See {IERC721-transferFrom}.
1053      */
1054     function transferFrom(
1055         address from,
1056         address to,
1057         uint256 tokenId
1058     ) public virtual override {
1059         _transfer(from, to, tokenId);
1060     }
1061 
1062     /**
1063      * @dev See {IERC721-safeTransferFrom}.
1064      */
1065     function safeTransferFrom(
1066         address from,
1067         address to,
1068         uint256 tokenId
1069     ) public virtual override {
1070         safeTransferFrom(from, to, tokenId, '');
1071     }
1072 
1073     /**
1074      * @dev See {IERC721-safeTransferFrom}.
1075      */
1076     function safeTransferFrom(
1077         address from,
1078         address to,
1079         uint256 tokenId,
1080         bytes memory _data
1081     ) public virtual override {
1082         _transfer(from, to, tokenId);
1083         if (to.isContract() && !_checkContractOnERC721Received(from, to, tokenId, _data)) {
1084             revert TransferToNonERC721ReceiverImplementer();
1085         }
1086     }
1087 
1088     /**
1089      * @dev Returns whether `tokenId` exists.
1090      *
1091      * Tokens can be managed by their owner or approved accounts via {approve} or {setApprovalForAll}.
1092      *
1093      * Tokens start existing when they are minted (`_mint`),
1094      */
1095     function _exists(uint256 tokenId) internal view returns (bool) {
1096         return _startTokenId() <= tokenId && tokenId < _currentIndex &&
1097             !_ownerships[tokenId].burned;
1098     }
1099 
1100     function _safeMint(address to, uint256 quantity) internal {
1101         _safeMint(to, quantity, '');
1102     }
1103 
1104     /**
1105      * @dev Safely mints `quantity` tokens and transfers them to `to`.
1106      *
1107      * Requirements:
1108      *
1109      * - If `to` refers to a smart contract, it must implement {IERC721Receiver-onERC721Received}, which is called for each safe transfer.
1110      * - `quantity` must be greater than 0.
1111      *
1112      * Emits a {Transfer} event.
1113      */
1114     function _safeMint(
1115         address to,
1116         uint256 quantity,
1117         bytes memory _data
1118     ) internal {
1119         _mint(to, quantity, _data, true);
1120     }
1121 
1122     /**
1123      * @dev Mints `quantity` tokens and transfers them to `to`.
1124      *
1125      * Requirements:
1126      *
1127      * - `to` cannot be the zero address.
1128      * - `quantity` must be greater than 0.
1129      *
1130      * Emits a {Transfer} event.
1131      */
1132     function _mint(
1133         address to,
1134         uint256 quantity,
1135         bytes memory _data,
1136         bool safe
1137     ) internal {
1138         uint256 startTokenId = _currentIndex;
1139         if (to == address(0)) revert MintToZeroAddress();
1140         if (quantity == 0) revert MintZeroQuantity();
1141 
1142         _beforeTokenTransfers(address(0), to, startTokenId, quantity);
1143 
1144         // Overflows are incredibly unrealistic.
1145         // balance or numberMinted overflow if current value of either + quantity > 1.8e19 (2**64) - 1
1146         // updatedIndex overflows if _currentIndex + quantity > 1.2e77 (2**256) - 1
1147         unchecked {
1148             _addressData[to].balance += uint64(quantity);
1149             _addressData[to].numberMinted += uint64(quantity);
1150 
1151             _ownerships[startTokenId].addr = to;
1152             _ownerships[startTokenId].startTimestamp = uint64(block.timestamp);
1153 
1154             uint256 updatedIndex = startTokenId;
1155             uint256 end = updatedIndex + quantity;
1156 
1157             if (safe && to.isContract()) {
1158                 do {
1159                     emit Transfer(address(0), to, updatedIndex);
1160                     if (!_checkContractOnERC721Received(address(0), to, updatedIndex++, _data)) {
1161                         revert TransferToNonERC721ReceiverImplementer();
1162                     }
1163                 } while (updatedIndex != end);
1164                 // Reentrancy protection
1165                 if (_currentIndex != startTokenId) revert();
1166             } else {
1167                 do {
1168                     emit Transfer(address(0), to, updatedIndex++);
1169                 } while (updatedIndex != end);
1170             }
1171             _currentIndex = updatedIndex;
1172         }
1173         _afterTokenTransfers(address(0), to, startTokenId, quantity);
1174     }
1175 
1176     /**
1177      * @dev Transfers `tokenId` from `from` to `to`.
1178      *
1179      * Requirements:
1180      *
1181      * - `to` cannot be the zero address.
1182      * - `tokenId` token must be owned by `from`.
1183      *
1184      * Emits a {Transfer} event.
1185      */
1186     function _transfer(
1187         address from,
1188         address to,
1189         uint256 tokenId
1190     ) private {
1191         TokenOwnership memory prevOwnership = _ownershipOf(tokenId);
1192 
1193         if (prevOwnership.addr != from) revert TransferFromIncorrectOwner();
1194 
1195         bool isApprovedOrOwner = (_msgSender() == from ||
1196             isApprovedForAll(from, _msgSender()) ||
1197             getApproved(tokenId) == _msgSender());
1198 
1199         if (!isApprovedOrOwner) revert TransferCallerNotOwnerNorApproved();
1200         if (to == address(0)) revert TransferToZeroAddress();
1201 
1202         _beforeTokenTransfers(from, to, tokenId, 1);
1203 
1204         // Clear approvals from the previous owner
1205         _approve(address(0), tokenId, from);
1206 
1207         // Underflow of the sender's balance is impossible because we check for
1208         // ownership above and the recipient's balance can't realistically overflow.
1209         // Counter overflow is incredibly unrealistic as tokenId would have to be 2**256.
1210         unchecked {
1211             _addressData[from].balance -= 1;
1212             _addressData[to].balance += 1;
1213 
1214             TokenOwnership storage currSlot = _ownerships[tokenId];
1215             currSlot.addr = to;
1216             currSlot.startTimestamp = uint64(block.timestamp);
1217 
1218             // If the ownership slot of tokenId+1 is not explicitly set, that means the transfer initiator owns it.
1219             // Set the slot of tokenId+1 explicitly in storage to maintain correctness for ownerOf(tokenId+1) calls.
1220             uint256 nextTokenId = tokenId + 1;
1221             TokenOwnership storage nextSlot = _ownerships[nextTokenId];
1222             if (nextSlot.addr == address(0)) {
1223                 // This will suffice for checking _exists(nextTokenId),
1224                 // as a burned slot cannot contain the zero address.
1225                 if (nextTokenId != _currentIndex) {
1226                     nextSlot.addr = from;
1227                     nextSlot.startTimestamp = prevOwnership.startTimestamp;
1228                 }
1229             }
1230         }
1231 
1232         emit Transfer(from, to, tokenId);
1233         _afterTokenTransfers(from, to, tokenId, 1);
1234     }
1235 
1236     /**
1237      * @dev This is equivalent to _burn(tokenId, false)
1238      */
1239     function _burn(uint256 tokenId) internal virtual {
1240         _burn(tokenId, false);
1241     }
1242 
1243     /**
1244      * @dev Destroys `tokenId`.
1245      * The approval is cleared when the token is burned.
1246      *
1247      * Requirements:
1248      *
1249      * - `tokenId` must exist.
1250      *
1251      * Emits a {Transfer} event.
1252      */
1253     function _burn(uint256 tokenId, bool approvalCheck) internal virtual {
1254         TokenOwnership memory prevOwnership = _ownershipOf(tokenId);
1255 
1256         address from = prevOwnership.addr;
1257 
1258         if (approvalCheck) {
1259             bool isApprovedOrOwner = (_msgSender() == from ||
1260                 isApprovedForAll(from, _msgSender()) ||
1261                 getApproved(tokenId) == _msgSender());
1262 
1263             if (!isApprovedOrOwner) revert TransferCallerNotOwnerNorApproved();
1264         }
1265 
1266         _beforeTokenTransfers(from, address(0), tokenId, 1);
1267 
1268         // Clear approvals from the previous owner
1269         _approve(address(0), tokenId, from);
1270 
1271         // Underflow of the sender's balance is impossible because we check for
1272         // ownership above and the recipient's balance can't realistically overflow.
1273         // Counter overflow is incredibly unrealistic as tokenId would have to be 2**256.
1274         unchecked {
1275             AddressData storage addressData = _addressData[from];
1276             addressData.balance -= 1;
1277             addressData.numberBurned += 1;
1278 
1279             // Keep track of who burned the token, and the timestamp of burning.
1280             TokenOwnership storage currSlot = _ownerships[tokenId];
1281             currSlot.addr = from;
1282             currSlot.startTimestamp = uint64(block.timestamp);
1283             currSlot.burned = true;
1284 
1285             // If the ownership slot of tokenId+1 is not explicitly set, that means the burn initiator owns it.
1286             // Set the slot of tokenId+1 explicitly in storage to maintain correctness for ownerOf(tokenId+1) calls.
1287             uint256 nextTokenId = tokenId + 1;
1288             TokenOwnership storage nextSlot = _ownerships[nextTokenId];
1289             if (nextSlot.addr == address(0)) {
1290                 // This will suffice for checking _exists(nextTokenId),
1291                 // as a burned slot cannot contain the zero address.
1292                 if (nextTokenId != _currentIndex) {
1293                     nextSlot.addr = from;
1294                     nextSlot.startTimestamp = prevOwnership.startTimestamp;
1295                 }
1296             }
1297         }
1298 
1299         emit Transfer(from, address(0), tokenId);
1300         _afterTokenTransfers(from, address(0), tokenId, 1);
1301 
1302         // Overflow not possible, as _burnCounter cannot be exceed _currentIndex times.
1303         unchecked {
1304             _burnCounter++;
1305         }
1306     }
1307 
1308     /**
1309      * @dev Approve `to` to operate on `tokenId`
1310      *
1311      * Emits a {Approval} event.
1312      */
1313     function _approve(
1314         address to,
1315         uint256 tokenId,
1316         address owner
1317     ) private {
1318         _tokenApprovals[tokenId] = to;
1319         emit Approval(owner, to, tokenId);
1320     }
1321 
1322     /**
1323      * @dev Internal function to invoke {IERC721Receiver-onERC721Received} on a target contract.
1324      *
1325      * @param from address representing the previous owner of the given token ID
1326      * @param to target address that will receive the tokens
1327      * @param tokenId uint256 ID of the token to be transferred
1328      * @param _data bytes optional data to send along with the call
1329      * @return bool whether the call correctly returned the expected magic value
1330      */
1331     function _checkContractOnERC721Received(
1332         address from,
1333         address to,
1334         uint256 tokenId,
1335         bytes memory _data
1336     ) private returns (bool) {
1337         try IERC721Receiver(to).onERC721Received(_msgSender(), from, tokenId, _data) returns (bytes4 retval) {
1338             return retval == IERC721Receiver(to).onERC721Received.selector;
1339         } catch (bytes memory reason) {
1340             if (reason.length == 0) {
1341                 revert TransferToNonERC721ReceiverImplementer();
1342             } else {
1343                 assembly {
1344                     revert(add(32, reason), mload(reason))
1345                 }
1346             }
1347         }
1348     }
1349 
1350     /**
1351      * @dev Hook that is called before a set of serially-ordered token ids are about to be transferred. This includes minting.
1352      * And also called before burning one token.
1353      *
1354      * startTokenId - the first token id to be transferred
1355      * quantity - the amount to be transferred
1356      *
1357      * Calling conditions:
1358      *
1359      * - When `from` and `to` are both non-zero, `from`'s `tokenId` will be
1360      * transferred to `to`.
1361      * - When `from` is zero, `tokenId` will be minted for `to`.
1362      * - When `to` is zero, `tokenId` will be burned by `from`.
1363      * - `from` and `to` are never both zero.
1364      */
1365     function _beforeTokenTransfers(
1366         address from,
1367         address to,
1368         uint256 startTokenId,
1369         uint256 quantity
1370     ) internal virtual {}
1371 
1372     /**
1373      * @dev Hook that is called after a set of serially-ordered token ids have been transferred. This includes
1374      * minting.
1375      * And also called after one token has been burned.
1376      *
1377      * startTokenId - the first token id to be transferred
1378      * quantity - the amount to be transferred
1379      *
1380      * Calling conditions:
1381      *
1382      * - When `from` and `to` are both non-zero, `from`'s `tokenId` has been
1383      * transferred to `to`.
1384      * - When `from` is zero, `tokenId` has been minted for `to`.
1385      * - When `to` is zero, `tokenId` has been burned by `from`.
1386      * - `from` and `to` are never both zero.
1387      */
1388     function _afterTokenTransfers(
1389         address from,
1390         address to,
1391         uint256 startTokenId,
1392         uint256 quantity
1393     ) internal virtual {}
1394 }
1395 
1396 contract Zodiac is ERC721A, Ownable, ReentrancyGuard {
1397     using Strings for uint256;
1398 
1399     //NOTE Token values incremented for gas efficiency
1400     uint256 private maxSalePlusOne = 3601;
1401 
1402     uint256 public presaleAllowancePlusOne = 2;
1403     uint256 public publicSaleAllowancePlusOne = 4;
1404 
1405     bytes32 public merkleRoot;
1406 
1407     //stores wallet addresses that have been approved and the amount of reserved mints they hold
1408     mapping(address => uint) public reservedMints;
1409 
1410     enum ContractState {
1411         OFF,
1412         PRESALE,
1413         PUBLIC
1414     }
1415     ContractState public contractState = ContractState.OFF;
1416 
1417     string public placeholderURI;
1418     string public baseURI;
1419 
1420     address public recipient;
1421 
1422     constructor() ERC721A("ZODIAC X TAS", "ZDC") {
1423         placeholderURI = "ipfs://QmdBxKai7C67qKjNKeq9mteeWjvVJpPrMDoy8mwxRgCC2w/";
1424 
1425         //address that will recieve mint funds
1426         recipient = msg.sender;
1427 
1428         //team mints
1429         _safeMint(0xBEf0197c5799d44f38D7c37c11a77a73EFc405CC, 20);
1430         _safeMint(0xcB94aE6a21a1852aD2aE8fD04B13c66DC915b4Cc, 20);
1431         _safeMint(0x1804361ca4860c4f17AaBb4fb8D43EcF45090C68, 10);
1432         _safeMint(0x96C42b8072Dfbb12B483cF59C1fA098c16300a2A, 10);
1433         _safeMint(0x086EeBF1729BaCc4E4266524490079C8a9Eb0E30, 60);
1434         _safeMint(0xA69DB2C1Ea4093F6E7d98EB1895FB6FA5437A340, 60);
1435         _safeMint(0x051d3C00aDfE65D38fA23cAECF5705893fFc9DC1, 120);
1436         _safeMint(0x6Fe5756CDb20958192b7B1ad3303349290aEd54b, 120);
1437         _safeMint(0xD2b9f766D937912D4500beAA3077B64Bdf291529, 30);
1438         _safeMint(0x56B47d4e14Ad835D2984e1449e78889fe0CA3C79, 10);
1439         _safeMint(0xD42585Db037f95480228581825b7E61bad7d85c4, 10);
1440         _safeMint(0x7082b2CD2A0A3d8264949Aa749431Ac804ba8534, 50);
1441 
1442     }
1443 
1444     //
1445     // Modifiers
1446     //
1447 
1448     /**
1449      * Do not allow calls from other contracts.
1450      */
1451     modifier noBots() {
1452         require(msg.sender == tx.origin, "No bots!");
1453         _;
1454     }
1455 
1456     /**
1457      * Ensure current state is correct for this method.
1458      */
1459     modifier isContractState(ContractState contractState_) {
1460         require(contractState == contractState_, "Invalid state");
1461         _;
1462     }
1463 
1464     /**
1465      * Ensure amount of tokens to mint is within the limit.
1466      */
1467     modifier withinMintLimit(uint256 quantity) {
1468         require((_totalMinted() + quantity) < maxSalePlusOne, "Exceeds available tokens");
1469         _;
1470     }
1471 
1472     //
1473     // Mint
1474     //
1475 
1476     /**
1477      * Public mint.
1478      * @param quantity Amount of tokens to mint.
1479      */
1480     function mintPublic(uint256 quantity)
1481         external
1482         noBots
1483         isContractState(ContractState.PUBLIC)
1484         withinMintLimit(quantity)
1485     {
1486         require(_numberMinted(msg.sender) + quantity < publicSaleAllowancePlusOne, "Exceeds allowance!");
1487         _safeMint(msg.sender, quantity);
1488     }
1489 
1490     /**
1491      * Mint tokens during the presale.
1492      * @notice This function is only available to those on the allowlist.
1493      * @param quantity The number of tokens to mint.
1494      * @param proof The Merkle proof used to validate the leaf is in the root.
1495      */
1496     function mintPresale(uint256 quantity, bytes32[] calldata proof, bytes32 leaf)
1497         external
1498         noBots
1499         isContractState(ContractState.PRESALE)
1500         withinMintLimit(quantity)
1501     {
1502         require(_numberMinted(msg.sender) + quantity < presaleAllowancePlusOne, "Exceeds allowance!");
1503         require(verify(merkleRoot, leaf, proof), "Not a valid proof!");
1504         _safeMint(msg.sender, quantity);
1505     }
1506 
1507 
1508     /**
1509      * Team reserved mint.
1510      * @param quantity Amount of tokens to mint.
1511      */
1512     function mintReserved(uint256 quantity) external withinMintLimit(quantity) {
1513         require(msg.sender == owner() || reservedMints[msg.sender] - quantity > 0, "Not Approved for this amount of Reserved Mints!");
1514         _safeMint(msg.sender, quantity);
1515         reservedMints[msg.sender] = reservedMints[msg.sender] - quantity;
1516     }
1517 
1518     /**
1519      * Add members to reserved mints list
1520      * @param memberList Addresses to reserve to.
1521      * @param quantityList Amounts of tokens to reserve.
1522      */
1523     function addReservedMints(address[] calldata memberList, uint[] calldata quantityList) public onlyOwner {
1524         require(memberList.length == quantityList.length, "Lists must be the same length!");
1525         for (uint i; i < memberList.length; i++) {
1526             reservedMints[memberList[i]] += quantityList[i];
1527         }
1528     }
1529 
1530     /**
1531      * Remove reserved mints from wallets
1532      * @param memberList Addresses to reserve to.
1533      * @param quantityList Amounts of tokens to reserve.
1534      */
1535     function removeReservedMints(address[] calldata memberList, uint[] calldata quantityList) public onlyOwner {
1536         require(memberList.length == quantityList.length, "Lists must be the same length!");
1537         for (uint i; i < memberList.length; i++) {
1538             require(reservedMints[memberList[i]] >= quantityList[i], "Removing more reserved mints than the address posseses!");
1539             reservedMints[memberList[i]] = reservedMints[memberList[i]] - quantityList[i];
1540         }
1541     }
1542 
1543     //
1544     // Admin
1545     //
1546 
1547     /**
1548      * Set contract state.
1549      * @param contractState_ The new state of the contract.
1550      */
1551     function setContractState(uint contractState_) external onlyOwner {
1552         require(contractState_ < 3, "Invalid Contract State!");
1553         if (contractState_ == 0) {
1554             contractState = ContractState.OFF;
1555         }
1556         else if (contractState_ == 1) {
1557             contractState = ContractState.PRESALE;
1558         }
1559         else {
1560             contractState = ContractState.PUBLIC;
1561         }
1562         
1563     }
1564 
1565     /**
1566      * Update maximum number of tokens for sale.
1567      * @param maxSale The maximum number of tokens available for sale.
1568      */
1569     function setMaxSale(uint256 maxSale) external onlyOwner {
1570         uint256 maxSalePlusOne_ = maxSale + 1;
1571         require(maxSalePlusOne_ < maxSalePlusOne, "Can only reduce supply");
1572         maxSalePlusOne = maxSalePlusOne_;
1573     }
1574 
1575     /**
1576      * Update presale allowance.
1577      * @param presaleAllowance The new presale allowance.
1578      */
1579     function setPresaleAllowance(uint256 presaleAllowance) external onlyOwner {
1580         presaleAllowancePlusOne = presaleAllowance + 1;
1581     }
1582 
1583     /**
1584      * Set the presale Merkle root.
1585      * @dev The Merkle root is calculated from [address, allowance] pairs.
1586      * @param merkleRoot_ The new merkle roo
1587      */
1588     function setMerkleRoot(bytes32 merkleRoot_) external onlyOwner {
1589         merkleRoot = merkleRoot_;
1590     }
1591 
1592     /**
1593      * Sets base URI.
1594      * @param baseURI_ The base URI
1595      */
1596     function setBaseURI(string memory baseURI_) external onlyOwner {
1597         baseURI = baseURI_;
1598     }
1599 
1600     /**
1601      * Sets placeholder URI.
1602      * @param placeholderURI_ The placeholder URI
1603      */
1604     function setPlaceholderURI(string memory placeholderURI_) external onlyOwner {
1605         placeholderURI = placeholderURI_;
1606     }
1607 
1608     /**
1609      * Update wallet that will recieve funds.
1610      * @param newRecipient The new address that will recieve funds
1611      */
1612     function setRecipient(address newRecipient) external onlyOwner {
1613         require(newRecipient != address(0), "Cannot be the 0 address!");
1614         recipient = newRecipient;
1615     }
1616 
1617 
1618     //retrieve all funds recieved from minting
1619     function withdraw() public onlyOwner {
1620         uint256 balance = accountBalance();
1621         require(balance > 0, 'No Funds to withdraw, Balance is 0');
1622 
1623         _withdraw(payable(recipient), balance); 
1624     }
1625     
1626     //send the percentage of funds to a shareholder´s wallet
1627     function _withdraw(address payable account, uint256 amount) internal {
1628         (bool sent, ) = account.call{value: amount}("");
1629         require(sent, "Failed to send Ether");
1630     }
1631 
1632     //
1633     // Views
1634     //
1635 
1636     /**
1637      * The block.timestamp when this token was transferred to the current owner.
1638      * @param tokenId The token id to query
1639      */
1640     function ownedSince(uint256 tokenId) public view returns (uint256) {
1641         return _ownershipOf(tokenId).startTimestamp;
1642     }
1643 
1644     /**
1645      * @dev See {IERC721Metadata-tokenURI}.
1646      */
1647     function tokenURI(uint256 tokenId) public view virtual override returns (string memory) {
1648         require(_exists(uint16(tokenId)), "URI query for nonexistent token");
1649 
1650         return
1651             bytes(baseURI).length > 0 ? string(abi.encodePacked(baseURI, tokenId.toString(), ".json")) : placeholderURI;
1652     }
1653 
1654     /// @inheritdoc IERC165
1655     function supportsInterface(bytes4 interfaceId) public view virtual override(ERC721A) returns (bool) {
1656         return ERC721A.supportsInterface(interfaceId);
1657     }
1658 
1659     /**
1660      * Verify the Merkle proof is valid.
1661      * @param root The Merkle root. Use the value stored in the contract
1662      * @param leaf The leaf. A [address, availableAmt] pair
1663      * @param proof The Merkle proof used to validate the leaf is in the root
1664      */
1665     function verify(
1666         bytes32 root,
1667         bytes32 leaf,
1668         bytes32[] memory proof
1669     ) public pure returns (bool) {
1670         return MerkleProof.verify(proof, root, leaf);
1671     }
1672 
1673     /**
1674      * Get the current amount of Eth stored
1675      */
1676     function accountBalance() public view returns(uint) {
1677         return address(this).balance;
1678     }
1679 }