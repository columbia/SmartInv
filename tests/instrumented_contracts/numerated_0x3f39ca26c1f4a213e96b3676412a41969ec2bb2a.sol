1 // SPDX-License-Identifier: MIT
2 pragma solidity 0.8.9;
3 
4 /// @title Digits Agents
5 /// @author André Costa @ DigitsBrands
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
731 interface IDigitsRedeemer {
732     /**
733      * @dev Returns if the `tokenId` has been staked and therefore blocking transfers.
734      */
735     function isStaked(uint tokenId) external view returns (bool);
736 }
737 
738 
739 error ApprovalCallerNotOwnerNorApproved();
740 error ApprovalQueryForNonexistentToken();
741 error ApproveToCaller();
742 error ApprovalToCurrentOwner();
743 error BalanceQueryForZeroAddress();
744 error MintToZeroAddress();
745 error MintZeroQuantity();
746 error OwnerQueryForNonexistentToken();
747 error TransferCallerNotOwnerNorApproved();
748 error TransferFromIncorrectOwner();
749 error TransferToNonERC721ReceiverImplementer();
750 error TransferToZeroAddress();
751 error URIQueryForNonexistentToken();
752 
753 pragma solidity ^0.8.9;
754 
755 /**
756  * @title ERC-721 Non-Fungible Token Standard, optional enumeration extension
757  * @dev See https://eips.ethereum.org/EIPS/eip-721
758  */
759 interface IERC721Enumerable is IERC721 {
760     /**
761      * @dev Returns the total amount of tokens stored by the contract.
762      */
763     function totalSupply() external view returns (uint256);
764 
765     /**
766      * @dev Returns a token ID owned by `owner` at a given `index` of its token list.
767      * Use along with {balanceOf} to enumerate all of ``owner``'s tokens.
768      */
769     function tokenOfOwnerByIndex(address owner, uint256 index) external view returns (uint256);
770 
771     /**
772      * @dev Returns a token ID at a given `index` of all the tokens stored by the contract.
773      * Use along with {totalSupply} to enumerate all tokens.
774      */
775     function tokenByIndex(uint256 index) external view returns (uint256);
776 }
777 
778 
779 // Creator: Chiru Labs
780 
781 pragma solidity ^0.8.9;
782 
783 /**
784  * @dev Implementation of https://eips.ethereum.org/EIPS/eip-721[ERC721] Non-Fungible Token Standard, including
785  * the Metadata and Enumerable extension. Built to optimize for lower gas during batch mints.
786  *
787  * Assumes serials are sequentially minted starting at 0 (e.g. 0, 1, 2, 3..).
788  *
789  * Does not support burning tokens to address(0).
790  *
791  * Assumes that an owner cannot have more than the 2**128 - 1 (max value of uint128) of supply
792  */
793 contract ERC721A is Ownable, ERC165, IERC721, IERC721Metadata, IERC721Enumerable {
794     using Address for address;
795     using Strings for uint256;
796 
797     struct TokenOwnership {
798         address addr;
799         uint64 startTimestamp;
800     }
801 
802     struct AddressData {
803         uint128 balance;
804         uint128 numberMinted;
805     }
806 
807     uint256 internal currentIndex;
808 
809     // Token name
810     string private _name;
811 
812     // Token symbol
813     string private _symbol;
814 
815     // Mapping from token ID to ownership details
816     // An empty struct value does not necessarily mean the token is unowned. See ownershipOf implementation for details.
817     mapping(uint256 => TokenOwnership) internal _ownerships;
818 
819     // Mapping owner address to address data
820     mapping(address => AddressData) private _addressData;
821 
822     // Mapping from token ID to approved address
823     mapping(uint256 => address) private _tokenApprovals;
824 
825     // Mapping from owner to operator approvals
826     mapping(address => mapping(address => bool)) private _operatorApprovals;
827 
828     //connects to the redeemer contract
829     IDigitsRedeemer public DigitsRedeemer;
830 
831     constructor(string memory name_, string memory symbol_) {
832         _name = name_;
833         _symbol = symbol_;
834     }
835 
836     /**
837         To set the address of the digits redeemer contract
838      */
839     function setDigitsRedeemer(address newRedeemer) public onlyOwner {
840         DigitsRedeemer = IDigitsRedeemer(newRedeemer);
841     }
842 
843     /**
844      * @dev See {IERC721Enumerable-totalSupply}.
845      */
846     function totalSupply() public view virtual override returns (uint256) {
847         return currentIndex;
848     }
849 
850     /**
851      * @dev See {IERC721Enumerable-tokenByIndex}.
852      */
853     function tokenByIndex(uint256 index) public view override returns (uint256) {
854         require(index < totalSupply(), 'ERC721A: global index out of bounds');
855         return index;
856     }
857 
858     /**
859      * @dev See {IERC721Enumerable-tokenOfOwnerByIndex}.
860      * This read function is O(totalSupply). If calling from a separate contract, be sure to test gas first.
861      * It may also degrade with extremely large collection sizes (e.g >> 10000), test for your use case.
862      */
863     function tokenOfOwnerByIndex(address owner, uint256 index) public view override returns (uint256) {
864         require(index < balanceOf(owner), 'ERC721A: owner index out of bounds');
865         uint256 numMintedSoFar = totalSupply();
866         uint256 tokenIdsIdx;
867         address currOwnershipAddr;
868 
869         // Counter overflow is impossible as the loop breaks when uint256 i is equal to another uint256 numMintedSoFar.
870         unchecked {
871             for (uint256 i; i < numMintedSoFar; i++) {
872                 TokenOwnership memory ownership = _ownerships[i];
873                 if (ownership.addr != address(0)) {
874                     currOwnershipAddr = ownership.addr;
875                 }
876                 if (currOwnershipAddr == owner) {
877                     if (tokenIdsIdx == index) {
878                         return i;
879                     }
880                     tokenIdsIdx++;
881                 }
882             }
883         }
884 
885         revert('ERC721A: unable to get token of owner by index');
886     }
887 
888     /**
889      * @dev See {IERC165-supportsInterface}.
890      */
891     function supportsInterface(bytes4 interfaceId) public view virtual override(ERC165, IERC165) returns (bool) {
892         return
893             interfaceId == type(IERC721).interfaceId ||
894             interfaceId == type(IERC721Metadata).interfaceId ||
895             interfaceId == type(IERC721Enumerable).interfaceId ||
896             super.supportsInterface(interfaceId);
897     }
898 
899     /**
900      * @dev See {IERC721-balanceOf}.
901      */
902     function balanceOf(address owner) public view override returns (uint256) {
903         require(owner != address(0), 'ERC721A: balance query for the zero address');
904         return uint256(_addressData[owner].balance);
905     }
906 
907     function _numberMinted(address owner) internal view returns (uint256) {
908         require(owner != address(0), 'ERC721A: number minted query for the zero address');
909         return uint256(_addressData[owner].numberMinted);
910     }
911 
912     /**
913      * Gas spent here starts off proportional to the maximum mint batch size.
914      * It gradually moves to O(1) as tokens get transferred around in the collection over time.
915      */
916     function ownershipOf(uint256 tokenId) internal view returns (TokenOwnership memory) {
917         require(_exists(tokenId), 'ERC721A: owner query for nonexistent token');
918 
919         unchecked {
920             for (uint256 curr = tokenId; curr >= 0; curr--) {
921                 TokenOwnership memory ownership = _ownerships[curr];
922                 if (ownership.addr != address(0)) {
923                     return ownership;
924                 }
925             }
926         }
927 
928         revert('ERC721A: unable to determine the owner of token');
929     }
930 
931     /**
932      * @dev See {IERC721-ownerOf}.
933      */
934     function ownerOf(uint256 tokenId) public view override returns (address) {
935         return ownershipOf(tokenId).addr;
936     }
937 
938     /**
939      * @dev See {IERC721Metadata-name}.
940      */
941     function name() public view virtual override returns (string memory) {
942         return _name;
943     }
944 
945     /**
946      * @dev See {IERC721Metadata-symbol}.
947      */
948     function symbol() public view virtual override returns (string memory) {
949         return _symbol;
950     }
951 
952     /**
953      * @dev See {IERC721Metadata-tokenURI}.
954      */
955     function tokenURI(uint256 tokenId) public view virtual override returns (string memory) {
956         require(_exists(tokenId), 'ERC721Metadata: URI query for nonexistent token');
957 
958         string memory baseURI = _baseURI();
959         return bytes(baseURI).length != 0 ? string(abi.encodePacked(baseURI, tokenId.toString())) : '';
960     }
961 
962     /**
963      * @dev Base URI for computing {tokenURI}. If set, the resulting URI for each
964      * token will be the concatenation of the `baseURI` and the `tokenId`. Empty
965      * by default, can be overriden in child contracts.
966      */
967     function _baseURI() internal view virtual returns (string memory) {
968         return '';
969     }
970 
971     /**
972      * @dev See {IERC721-approve}.
973      */
974     function approve(address to, uint256 tokenId) public override {
975         address owner = ERC721A.ownerOf(tokenId);
976         require(to != owner, 'ERC721A: approval to current owner');
977 
978         require(
979             _msgSender() == owner || isApprovedForAll(owner, _msgSender()),
980             'ERC721A: approve caller is not owner nor approved for all'
981         );
982 
983         _approve(to, tokenId, owner);
984     }
985 
986     /**
987      * @dev See {IERC721-getApproved}.
988      */
989     function getApproved(uint256 tokenId) public view override returns (address) {
990         require(_exists(tokenId), 'ERC721A: approved query for nonexistent token');
991 
992         return _tokenApprovals[tokenId];
993     }
994 
995     /**
996      * @dev See {IERC721-setApprovalForAll}.
997      */
998     function setApprovalForAll(address operator, bool approved) public override {
999         require(operator != _msgSender(), 'ERC721A: approve to caller');
1000 
1001         _operatorApprovals[_msgSender()][operator] = approved;
1002         emit ApprovalForAll(_msgSender(), operator, approved);
1003     }
1004 
1005     /**
1006      * @dev See {IERC721-isApprovedForAll}.
1007      */
1008     function isApprovedForAll(address owner, address operator) public view virtual override returns (bool) {
1009         return _operatorApprovals[owner][operator];
1010     }
1011 
1012     /**
1013      * @dev See {IERC721-transferFrom}.
1014      */
1015     function transferFrom(
1016         address from,
1017         address to,
1018         uint256 tokenId
1019     ) public virtual override {
1020         _transfer(from, to, tokenId);
1021     }
1022 
1023     /**
1024      * @dev See {IERC721-safeTransferFrom}.
1025      */
1026     function safeTransferFrom(
1027         address from,
1028         address to,
1029         uint256 tokenId
1030     ) public virtual override {
1031         safeTransferFrom(from, to, tokenId, '');
1032     }
1033 
1034     /**
1035      * @dev See {IERC721-safeTransferFrom}.
1036      */
1037     function safeTransferFrom(
1038         address from,
1039         address to,
1040         uint256 tokenId,
1041         bytes memory _data
1042     ) public override {
1043         _transfer(from, to, tokenId);
1044         require(
1045             _checkOnERC721Received(from, to, tokenId, _data),
1046             'ERC721A: transfer to non ERC721Receiver implementer'
1047         );
1048     }
1049 
1050     /**
1051      * @dev Returns whether `tokenId` exists.
1052      *
1053      * Tokens can be managed by their owner or approved accounts via {approve} or {setApprovalForAll}.
1054      *
1055      * Tokens start existing when they are minted (`_mint`),
1056      */
1057     function _exists(uint256 tokenId) internal view returns (bool) {
1058         return tokenId < currentIndex;
1059     }
1060 
1061     function _safeMint(address to, uint256 quantity) internal {
1062         _safeMint(to, quantity, '');
1063     }
1064 
1065     /**
1066      * @dev Safely mints `quantity` tokens and transfers them to `to`.
1067      *
1068      * Requirements:
1069      *
1070      * - If `to` refers to a smart contract, it must implement {IERC721Receiver-onERC721Received}, which is called for each safe transfer.
1071      * - `quantity` must be greater than 0.
1072      *
1073      * Emits a {Transfer} event.
1074      */
1075     function _safeMint(
1076         address to,
1077         uint256 quantity,
1078         bytes memory _data
1079     ) internal {
1080         _mint(to, quantity, _data, true);
1081     }
1082 
1083     /**
1084      * @dev Mints `quantity` tokens and transfers them to `to`.
1085      *
1086      * Requirements:
1087      *
1088      * - `to` cannot be the zero address.
1089      * - `quantity` must be greater than 0.
1090      *
1091      * Emits a {Transfer} event.
1092      */
1093     function _mint(
1094         address to,
1095         uint256 quantity,
1096         bytes memory _data,
1097         bool safe
1098     ) internal {
1099         uint256 startTokenId = currentIndex;
1100         require(to != address(0), 'ERC721A: mint to the zero address');
1101         require(quantity != 0, 'ERC721A: quantity must be greater than 0');
1102 
1103         _beforeTokenTransfers(address(0), to, startTokenId, quantity);
1104 
1105         // Overflows are incredibly unrealistic.
1106         // balance or numberMinted overflow if current value of either + quantity > 3.4e38 (2**128) - 1
1107         // updatedIndex overflows if currentIndex + quantity > 1.56e77 (2**256) - 1
1108         unchecked {
1109             _addressData[to].balance += uint128(quantity);
1110             _addressData[to].numberMinted += uint128(quantity);
1111 
1112             _ownerships[startTokenId].addr = to;
1113             _ownerships[startTokenId].startTimestamp = uint64(block.timestamp);
1114 
1115             uint256 updatedIndex = startTokenId;
1116 
1117             for (uint256 i; i < quantity; i++) {
1118                 emit Transfer(address(0), to, updatedIndex);
1119                 if (safe) {
1120                     require(
1121                         _checkOnERC721Received(address(0), to, updatedIndex, _data),
1122                         'ERC721A: transfer to non ERC721Receiver implementer'
1123                     );
1124                 }
1125 
1126                 updatedIndex++;
1127             }
1128 
1129             currentIndex = updatedIndex;
1130         }
1131 
1132         _afterTokenTransfers(address(0), to, startTokenId, quantity);
1133     }
1134 
1135     /**
1136      * @dev Transfers `tokenId` from `from` to `to`.
1137      *
1138      * Requirements:
1139      *
1140      * - `to` cannot be the zero address.
1141      * - `tokenId` token must be owned by `from`.
1142      *
1143      * Emits a {Transfer} event.
1144      */
1145     function _transfer(
1146         address from,
1147         address to,
1148         uint256 tokenId
1149     ) private {
1150         require(!DigitsRedeemer.isStaked(tokenId), "Token is Staked!");
1151         TokenOwnership memory prevOwnership = ownershipOf(tokenId);
1152 
1153         bool isApprovedOrOwner = (_msgSender() == prevOwnership.addr ||
1154             getApproved(tokenId) == _msgSender() ||
1155             isApprovedForAll(prevOwnership.addr, _msgSender()));
1156 
1157         require(isApprovedOrOwner, 'ERC721A: transfer caller is not owner nor approved');
1158 
1159         require(prevOwnership.addr == from, 'ERC721A: transfer from incorrect owner');
1160         require(to != address(0), 'ERC721A: transfer to the zero address');
1161 
1162         _beforeTokenTransfers(from, to, tokenId, 1);
1163 
1164         // Clear approvals from the previous owner
1165         _approve(address(0), tokenId, prevOwnership.addr);
1166 
1167         // Underflow of the sender's balance is impossible because we check for
1168         // ownership above and the recipient's balance can't realistically overflow.
1169         // Counter overflow is incredibly unrealistic as tokenId would have to be 2**256.
1170         unchecked {
1171             _addressData[from].balance -= 1;
1172             _addressData[to].balance += 1;
1173 
1174             _ownerships[tokenId].addr = to;
1175             _ownerships[tokenId].startTimestamp = uint64(block.timestamp);
1176 
1177             // If the ownership slot of tokenId+1 is not explicitly set, that means the transfer initiator owns it.
1178             // Set the slot of tokenId+1 explicitly in storage to maintain correctness for ownerOf(tokenId+1) calls.
1179             uint256 nextTokenId = tokenId + 1;
1180             if (_ownerships[nextTokenId].addr == address(0)) {
1181                 if (_exists(nextTokenId)) {
1182                     _ownerships[nextTokenId].addr = prevOwnership.addr;
1183                     _ownerships[nextTokenId].startTimestamp = prevOwnership.startTimestamp;
1184                 }
1185             }
1186         }
1187 
1188         emit Transfer(from, to, tokenId);
1189         _afterTokenTransfers(from, to, tokenId, 1);
1190     }
1191 
1192     /**
1193      * @dev Approve `to` to operate on `tokenId`
1194      *
1195      * Emits a {Approval} event.
1196      */
1197     function _approve(
1198         address to,
1199         uint256 tokenId,
1200         address owner
1201     ) private {
1202         _tokenApprovals[tokenId] = to;
1203         emit Approval(owner, to, tokenId);
1204     }
1205 
1206     /**
1207      * @dev Internal function to invoke {IERC721Receiver-onERC721Received} on a target address.
1208      * The call is not executed if the target address is not a contract.
1209      *
1210      * @param from address representing the previous owner of the given token ID
1211      * @param to target address that will receive the tokens
1212      * @param tokenId uint256 ID of the token to be transferred
1213      * @param _data bytes optional data to send along with the call
1214      * @return bool whether the call correctly returned the expected magic value
1215      */
1216     function _checkOnERC721Received(
1217         address from,
1218         address to,
1219         uint256 tokenId,
1220         bytes memory _data
1221     ) private returns (bool) {
1222         if (to.isContract()) {
1223             try IERC721Receiver(to).onERC721Received(_msgSender(), from, tokenId, _data) returns (bytes4 retval) {
1224                 return retval == IERC721Receiver(to).onERC721Received.selector;
1225             } catch (bytes memory reason) {
1226                 if (reason.length == 0) {
1227                     revert('ERC721A: transfer to non ERC721Receiver implementer');
1228                 } else {
1229                     assembly {
1230                         revert(add(32, reason), mload(reason))
1231                     }
1232                 }
1233             }
1234         } else {
1235             return true;
1236         }
1237     }
1238 
1239     /**
1240      * @dev Hook that is called before a set of serially-ordered token ids are about to be transferred. This includes minting.
1241      *
1242      * startTokenId - the first token id to be transferred
1243      * quantity - the amount to be transferred
1244      *
1245      * Calling conditions:
1246      *
1247      * - When `from` and `to` are both non-zero, ``from``'s `tokenId` will be
1248      * transferred to `to`.
1249      * - When `from` is zero, `tokenId` will be minted for `to`.
1250      */
1251     function _beforeTokenTransfers(
1252         address from,
1253         address to,
1254         uint256 startTokenId,
1255         uint256 quantity
1256     ) internal virtual {}
1257 
1258     /**
1259      * @dev Hook that is called after a set of serially-ordered token ids have been transferred. This includes
1260      * minting.
1261      *
1262      * startTokenId - the first token id to be transferred
1263      * quantity - the amount to be transferred
1264      *
1265      * Calling conditions:
1266      *
1267      * - when `from` and `to` are both non-zero.
1268      * - `from` and `to` are never both zero.
1269      */
1270     function _afterTokenTransfers(
1271         address from,
1272         address to,
1273         uint256 startTokenId,
1274         uint256 quantity
1275     ) internal virtual {}
1276 }
1277 
1278 contract DigitsAgents is ERC721A, ReentrancyGuard {
1279     using Strings for uint256;
1280 
1281     //NOTE Token values incremented for gas efficiency
1282     uint256 private maxSalePlusOne = 10000;
1283 
1284     uint public mintAllowancePlusOne = 4;
1285 
1286     enum ContractState {
1287         OFF,
1288         PRESALE,
1289         PUBLIC
1290     }
1291     ContractState public contractState;
1292 
1293     string public placeholderURI;
1294     string public baseURI;
1295 
1296     address public recipient;
1297 
1298     //sigmer address that we use to sign the mint transaction to make sure it is valid
1299     address private signer = 0x80E4929c869102140E69550BBECC20bEd61B080c;
1300 
1301     constructor() ERC721A("Digits Agents", "DA") {
1302         placeholderURI = "ipfs://QmfZY5nzyyFubPPXSdb8RBsxV66ZrN8CrdTW89r1jvxE9T";
1303     
1304     }
1305 
1306     //
1307     // Modifiers
1308     //
1309 
1310     /**
1311      * Do not allow calls from other contracts.
1312      */
1313     modifier noBots() {
1314         require(msg.sender == tx.origin, "No bots!");
1315         _;
1316     }
1317 
1318     /**
1319      * Ensure current state is correct for this method.
1320      */
1321     modifier isContractState(ContractState contractState_) {
1322         require(contractState == contractState_, "Invalid state");
1323         _;
1324     }
1325 
1326     /**
1327      * Ensure amount of tokens to mint is within the limit.
1328      */
1329     modifier withinMintLimit(uint256 quantity) {
1330         require((totalSupply() + quantity) < maxSalePlusOne, "Exceeds available tokens");
1331         _;
1332     }
1333 
1334     modifier onlyValidAccess(uint8 _v, bytes32 _r, bytes32 _s) {
1335         require( isValidAccessMessage(msg.sender,_v,_r,_s), 'Invalid Signature' );
1336         _;
1337     }
1338  
1339     /* 
1340     * @dev Verifies if message was signed by owner to give access to _add for this contract.
1341     *      Assumes Geth signature prefix.
1342     * @param _add Address of agent with access
1343     * @param _v ECDSA signature parameter v.
1344     * @param _r ECDSA signature parameters r.
1345     * @param _s ECDSA signature parameters s.
1346     * @return Validity of access message for a given address.
1347     */
1348     function isValidAccessMessage(address _add, uint8 _v, bytes32 _r, bytes32 _s) view public returns (bool) {
1349         bytes32 hash = keccak256(abi.encodePacked(address(this), _add));
1350         return signer == ecrecover(keccak256(abi.encodePacked("\x19Ethereum Signed Message:\n32", hash)), _v, _r, _s);
1351     }
1352 
1353     //
1354     // Mint
1355     //
1356 
1357     /**
1358      * Public mint.
1359      * @param quantity Amount of tokens to mint.
1360      */
1361     function mintPublic(uint256 quantity)
1362         external
1363         payable
1364         noBots
1365         isContractState(ContractState.PUBLIC)
1366         withinMintLimit(quantity)
1367     {
1368         require(_numberMinted(msg.sender) + quantity < mintAllowancePlusOne, "Maximum number of NFTs allowed to Mint reached!");
1369         _safeMint(msg.sender, quantity);
1370     }
1371 
1372     /**
1373      * Mint tokens during the presale.
1374      * @notice This function is only available to those on the allowlist.
1375      * @param quantity The number of tokens to mint.
1376      */
1377     function mintPresale(uint256 quantity, uint8 _v, bytes32 _r, bytes32 _s)
1378         external
1379         payable
1380         noBots
1381         isContractState(ContractState.PRESALE)
1382         withinMintLimit(quantity)
1383         onlyValidAccess(_v,  _r, _s)
1384     {
1385         require(_numberMinted(msg.sender) + quantity < mintAllowancePlusOne, "Maximum number of NFTs allowed to Mint reached!");
1386         _safeMint(msg.sender, quantity);
1387     }
1388 
1389     /**
1390      * Team reserved mint.
1391      * @param to Address to mint to.
1392      * @param quantity Amount of tokens to mint.
1393      */
1394     function mintReserved(address to, uint256 quantity) external onlyOwner withinMintLimit(quantity) {
1395         _safeMint(to, quantity);
1396     }
1397 
1398     //
1399     // Admin
1400     //
1401 
1402     /**
1403      * Set contract state.
1404      * @param contractState_ The new state of the contract.
1405      */
1406     function setContractState(uint contractState_) external onlyOwner {
1407         require(contractState_ < 3, "Invalid Contract State!");
1408         if (contractState_ == 0) {
1409             contractState = ContractState.OFF;
1410         }
1411         else if (contractState_ == 1) {
1412             contractState = ContractState.PRESALE;
1413         }
1414         else {
1415             contractState = ContractState.PUBLIC;
1416         }
1417         
1418     }
1419 
1420     //set signer public address
1421     function setSigner(address newSigner) external onlyOwner {
1422         signer = newSigner;
1423     }
1424 
1425     /**
1426      * Update maximum number of tokens for sale.
1427      * @param maxSale The maximum number of tokens available for sale.
1428      */
1429     function setMaxSale(uint256 maxSale) external onlyOwner {
1430         uint256 maxSalePlusOne_ = maxSale + 1;
1431         require(maxSalePlusOne_ < maxSalePlusOne, "Can only reduce supply");
1432         maxSalePlusOne = maxSalePlusOne_;
1433     }
1434 
1435     /**
1436      * Sets base URI.
1437      * @param baseURI_ The base URI
1438      */
1439     function setBaseURI(string memory baseURI_) external onlyOwner {
1440         baseURI = baseURI_;
1441     }
1442 
1443     /**
1444      * Sets placeholder URI.
1445      * @param placeholderURI_ The placeholder URI
1446      */
1447     function setPlaceholderURI(string memory placeholderURI_) external onlyOwner {
1448         placeholderURI = placeholderURI_;
1449     }
1450 
1451     /**
1452      * Update wallet that will recieve funds.
1453      * @param newRecipient The new address that will recieve funds
1454      */
1455     function setRecipient(address newRecipient) external onlyOwner {
1456         require(newRecipient != address(0), "Cannot be the 0 address!");
1457         recipient = newRecipient;
1458     }
1459 
1460     /**
1461      * Sets mint allowance.
1462      * @param newAllowance the new allowance
1463      */
1464     function setMintAllowance(uint newAllowance) external onlyOwner {
1465         mintAllowancePlusOne = newAllowance + 1;
1466     }
1467 
1468 
1469     //retrieve all funds recieved from minting
1470     function withdraw() public onlyOwner {
1471         uint256 balance = accountBalance();
1472         require(balance > 0, 'No Funds to withdraw, Balance is 0');
1473 
1474         _withdraw(payable(recipient), balance); 
1475     }
1476     
1477     //send the percentage of funds to a shareholder´s wallet
1478     function _withdraw(address payable account, uint256 amount) internal {
1479         (bool sent, ) = account.call{value: amount}("");
1480         require(sent, "Failed to send Ether");
1481     }
1482 
1483     //
1484     // Views
1485     //
1486 
1487     /**
1488      * The block.timestamp when this token was transferred to the current owner.
1489      * @param tokenId The token id to query
1490      */
1491     function ownedSince(uint256 tokenId) public view returns (uint256) {
1492         return _ownerships[tokenId].startTimestamp;
1493     }
1494 
1495     /**
1496      * @dev See {IERC721Metadata-tokenURI}.
1497      */
1498     function tokenURI(uint256 tokenId) public view virtual override returns (string memory) {
1499         require(_exists(uint16(tokenId)), "URI query for nonexistent token");
1500 
1501         return
1502             bytes(baseURI).length > 0 ? string(abi.encodePacked(baseURI, tokenId.toString(), ".json")) : placeholderURI;
1503     }
1504     /**
1505      * Get the current amount of Eth stored
1506      */
1507     function accountBalance() public view returns(uint) {
1508         return address(this).balance;
1509     }
1510 
1511     /**
1512      * See how many mints an address has executed in one of the sales
1513      * @param minter the address of the person that
1514      */
1515     function getMintsPerAddress(address minter) public view returns(uint) {
1516         return _numberMinted(minter);
1517     }
1518 }