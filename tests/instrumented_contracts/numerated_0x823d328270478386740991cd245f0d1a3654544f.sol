1 /**
2  *Submitted for verification at Etherscan.io on 2022-06-07
3 */
4 
5 // SPDX-License-Identifier: MIT
6 // OpenZeppelin Contracts v4.4.1 (utils/Context.sol)
7 
8 pragma solidity ^0.8.0;
9 
10 /**
11  * @dev Provides information about the current execution context, including the
12  * sender of the transaction and its data. While these are generally available
13  * via msg.sender and msg.data, they should not be accessed in such a direct
14  * manner, since when dealing with meta-transactions the account sending and
15  * paying for execution may not be the actual sender (as far as an application
16  * is concerned).
17  *
18  * This contract is only required for intermediate, library-like contracts.
19  */
20 abstract contract Context {
21     function _msgSender() internal view virtual returns (address) {
22         return msg.sender;
23     }
24 
25     function _msgData() internal view virtual returns (bytes calldata) {
26         return msg.data;
27     }
28 }
29 
30 
31 // File @openzeppelin/contracts/access/Ownable.sol@v4.6.0
32 
33 
34 // OpenZeppelin Contracts v4.4.1 (access/Ownable.sol)
35 
36 pragma solidity ^0.8.0;
37 
38 /**
39  * @dev Contract module which provides a basic access control mechanism, where
40  * there is an account (an owner) that can be granted exclusive access to
41  * specific functions.
42  *
43  * By default, the owner account will be the one that deploys the contract. This
44  * can later be changed with {transferOwnership}.
45  *
46  * This module is used through inheritance. It will make available the modifier
47  * `onlyOwner`, which can be applied to your functions to restrict their use to
48  * the owner.
49  */
50 abstract contract Ownable is Context {
51     address private _owner;
52 
53     event OwnershipTransferred(address indexed previousOwner, address indexed newOwner);
54 
55     /**
56      * @dev Initializes the contract setting the deployer as the initial owner.
57      */
58     constructor() {
59         _transferOwnership(_msgSender());
60     }
61 
62     /**
63      * @dev Returns the address of the current owner.
64      */
65     function owner() public view virtual returns (address) {
66         return _owner;
67     }
68 
69     /**
70      * @dev Throws if called by any account other than the owner.
71      */
72     modifier onlyOwner() {
73         require(owner() == _msgSender(), "Ownable: caller is not the owner");
74         _;
75     }
76 
77     /**
78      * @dev Leaves the contract without owner. It will not be possible to call
79      * `onlyOwner` functions anymore. Can only be called by the current owner.
80      *
81      * NOTE: Renouncing ownership will leave the contract without an owner,
82      * thereby removing any functionality that is only available to the owner.
83      */
84     function renounceOwnership() public virtual onlyOwner {
85         _transferOwnership(address(0));
86     }
87 
88     /**
89      * @dev Transfers ownership of the contract to a new account (`newOwner`).
90      * Can only be called by the current owner.
91      */
92     function transferOwnership(address newOwner) public virtual onlyOwner {
93         require(newOwner != address(0), "Ownable: new owner is the zero address");
94         _transferOwnership(newOwner);
95     }
96 
97     /**
98      * @dev Transfers ownership of the contract to a new account (`newOwner`).
99      * Internal function without access restriction.
100      */
101     function _transferOwnership(address newOwner) internal virtual {
102         address oldOwner = _owner;
103         _owner = newOwner;
104         emit OwnershipTransferred(oldOwner, newOwner);
105     }
106 }
107 
108 
109 
110 // File @openzeppelin/contracts/utils/introspection/IERC165.sol@v4.6.0
111 
112 
113 // OpenZeppelin Contracts v4.4.1 (utils/introspection/IERC165.sol)
114 
115 pragma solidity ^0.8.0;
116 
117 /**
118  * @dev Interface of the ERC165 standard, as defined in the
119  * https://eips.ethereum.org/EIPS/eip-165[EIP].
120  *
121  * Implementers can declare support of contract interfaces, which can then be
122  * queried by others ({ERC165Checker}).
123  *
124  * For an implementation, see {ERC165}.
125  */
126 interface IERC165 {
127     /**
128      * @dev Returns true if this contract implements the interface defined by
129      * `interfaceId`. See the corresponding
130      * https://eips.ethereum.org/EIPS/eip-165#how-interfaces-are-identified[EIP section]
131      * to learn more about how these ids are created.
132      *
133      * This function call must use less than 30 000 gas.
134      */
135     function supportsInterface(bytes4 interfaceId) external view returns (bool);
136 }
137 
138 
139 // File @openzeppelin/contracts/token/ERC721/IERC721.sol@v4.6.0
140 
141 
142 // OpenZeppelin Contracts (last updated v4.6.0) (token/ERC721/IERC721.sol)
143 
144 pragma solidity ^0.8.0;
145 
146 /**
147  * @dev Required interface of an ERC721 compliant contract.
148  */
149 interface IERC721 is IERC165 {
150     /**
151      * @dev Emitted when `tokenId` token is transferred from `from` to `to`.
152      */
153     event Transfer(address indexed from, address indexed to, uint256 indexed tokenId);
154 
155     /**
156      * @dev Emitted when `owner` enables `approved` to manage the `tokenId` token.
157      */
158     event Approval(address indexed owner, address indexed approved, uint256 indexed tokenId);
159 
160     /**
161      * @dev Emitted when `owner` enables or disables (`approved`) `operator` to manage all of its assets.
162      */
163     event ApprovalForAll(address indexed owner, address indexed operator, bool approved);
164 
165     /**
166      * @dev Returns the number of tokens in ``owner``'s account.
167      */
168     function balanceOf(address owner) external view returns (uint256 balance);
169 
170     /**
171      * @dev Returns the owner of the `tokenId` token.
172      *
173      * Requirements:
174      *
175      * - `tokenId` must exist.
176      */
177     function ownerOf(uint256 tokenId) external view returns (address owner);
178 
179     /**
180      * @dev Safely transfers `tokenId` token from `from` to `to`.
181      *
182      * Requirements:
183      *
184      * - `from` cannot be the zero address.
185      * - `to` cannot be the zero address.
186      * - `tokenId` token must exist and be owned by `from`.
187      * - If the caller is not `from`, it must be approved to move this token by either {approve} or {setApprovalForAll}.
188      * - If `to` refers to a smart contract, it must implement {IERC721Receiver-onERC721Received}, which is called upon a safe transfer.
189      *
190      * Emits a {Transfer} event.
191      */
192     function safeTransferFrom(
193         address from,
194         address to,
195         uint256 tokenId,
196         bytes calldata data
197     ) external;
198 
199     /**
200      * @dev Safely transfers `tokenId` token from `from` to `to`, checking first that contract recipients
201      * are aware of the ERC721 protocol to prevent tokens from being forever locked.
202      *
203      * Requirements:
204      *
205      * - `from` cannot be the zero address.
206      * - `to` cannot be the zero address.
207      * - `tokenId` token must exist and be owned by `from`.
208      * - If the caller is not `from`, it must be have been allowed to move this token by either {approve} or {setApprovalForAll}.
209      * - If `to` refers to a smart contract, it must implement {IERC721Receiver-onERC721Received}, which is called upon a safe transfer.
210      *
211      * Emits a {Transfer} event.
212      */
213     function safeTransferFrom(
214         address from,
215         address to,
216         uint256 tokenId
217     ) external;
218 
219     /**
220      * @dev Transfers `tokenId` token from `from` to `to`.
221      *
222      * WARNING: Usage of this method is discouraged, use {safeTransferFrom} whenever possible.
223      *
224      * Requirements:
225      *
226      * - `from` cannot be the zero address.
227      * - `to` cannot be the zero address.
228      * - `tokenId` token must be owned by `from`.
229      * - If the caller is not `from`, it must be approved to move this token by either {approve} or {setApprovalForAll}.
230      *
231      * Emits a {Transfer} event.
232      */
233     function transferFrom(
234         address from,
235         address to,
236         uint256 tokenId
237     ) external;
238 
239     /**
240      * @dev Gives permission to `to` to transfer `tokenId` token to another account.
241      * The approval is cleared when the token is transferred.
242      *
243      * Only a single account can be approved at a time, so approving the zero address clears previous approvals.
244      *
245      * Requirements:
246      *
247      * - The caller must own the token or be an approved operator.
248      * - `tokenId` must exist.
249      *
250      * Emits an {Approval} event.
251      */
252     function approve(address to, uint256 tokenId) external;
253 
254     /**
255      * @dev Approve or remove `operator` as an operator for the caller.
256      * Operators can call {transferFrom} or {safeTransferFrom} for any token owned by the caller.
257      *
258      * Requirements:
259      *
260      * - The `operator` cannot be the caller.
261      *
262      * Emits an {ApprovalForAll} event.
263      */
264     function setApprovalForAll(address operator, bool _approved) external;
265 
266     /**
267      * @dev Returns the account approved for `tokenId` token.
268      *
269      * Requirements:
270      *
271      * - `tokenId` must exist.
272      */
273     function getApproved(uint256 tokenId) external view returns (address operator);
274 
275     /**
276      * @dev Returns if the `operator` is allowed to manage all of the assets of `owner`.
277      *
278      * See {setApprovalForAll}
279      */
280     function isApprovedForAll(address owner, address operator) external view returns (bool);
281 }
282 
283 
284 // File @openzeppelin/contracts/security/ReentrancyGuard.sol@v4.6.0
285 
286 
287 // OpenZeppelin Contracts v4.4.1 (security/ReentrancyGuard.sol)
288 
289 pragma solidity ^0.8.0;
290 
291 /**
292  * @dev Contract module that helps prevent reentrant calls to a function.
293  *
294  * Inheriting from `ReentrancyGuard` will make the {nonReentrant} modifier
295  * available, which can be applied to functions to make sure there are no nested
296  * (reentrant) calls to them.
297  *
298  * Note that because there is a single `nonReentrant` guard, functions marked as
299  * `nonReentrant` may not call one another. This can be worked around by making
300  * those functions `private`, and then adding `external` `nonReentrant` entry
301  * points to them.
302  *
303  * TIP: If you would like to learn more about reentrancy and alternative ways
304  * to protect against it, check out our blog post
305  * https://blog.openzeppelin.com/reentrancy-after-istanbul/[Reentrancy After Istanbul].
306  */
307 abstract contract ReentrancyGuard {
308     // Booleans are more expensive than uint256 or any type that takes up a full
309     // word because each write operation emits an extra SLOAD to first read the
310     // slot's contents, replace the bits taken up by the boolean, and then write
311     // back. This is the compiler's defense against contract upgrades and
312     // pointer aliasing, and it cannot be disabled.
313 
314     // The values being non-zero value makes deployment a bit more expensive,
315     // but in exchange the refund on every call to nonReentrant will be lower in
316     // amount. Since refunds are capped to a percentage of the total
317     // transaction's gas, it is best to keep them low in cases like this one, to
318     // increase the likelihood of the full refund coming into effect.
319     uint256 private constant _NOT_ENTERED = 1;
320     uint256 private constant _ENTERED = 2;
321 
322     uint256 private _status;
323 
324     constructor() {
325         _status = _NOT_ENTERED;
326     }
327 
328     /**
329      * @dev Prevents a contract from calling itself, directly or indirectly.
330      * Calling a `nonReentrant` function from another `nonReentrant`
331      * function is not supported. It is possible to prevent this from happening
332      * by making the `nonReentrant` function external, and making it call a
333      * `private` function that does the actual work.
334      */
335     modifier nonReentrant() {
336         // On the first call to nonReentrant, _notEntered will be true
337         require(_status != _ENTERED, "ReentrancyGuard: reentrant call");
338 
339         // Any calls to nonReentrant after this point will fail
340         _status = _ENTERED;
341 
342         _;
343 
344         // By storing the original value once again, a refund is triggered (see
345         // https://eips.ethereum.org/EIPS/eip-2200)
346         _status = _NOT_ENTERED;
347     }
348 }
349 
350 
351 // File @openzeppelin/contracts/token/ERC721/IERC721Receiver.sol@v4.6.0
352 
353 
354 // OpenZeppelin Contracts (last updated v4.6.0) (token/ERC721/IERC721Receiver.sol)
355 
356 pragma solidity ^0.8.0;
357 
358 /**
359  * @title ERC721 token receiver interface
360  * @dev Interface for any contract that wants to support safeTransfers
361  * from ERC721 asset contracts.
362  */
363 interface IERC721Receiver {
364     /**
365      * @dev Whenever an {IERC721} `tokenId` token is transferred to this contract via {IERC721-safeTransferFrom}
366      * by `operator` from `from`, this function is called.
367      *
368      * It must return its Solidity selector to confirm the token transfer.
369      * If any other value is returned or the interface is not implemented by the recipient, the transfer will be reverted.
370      *
371      * The selector can be obtained in Solidity with `IERC721Receiver.onERC721Received.selector`.
372      */
373     function onERC721Received(
374         address operator,
375         address from,
376         uint256 tokenId,
377         bytes calldata data
378     ) external returns (bytes4);
379 }
380 
381 
382 // File @openzeppelin/contracts/token/ERC721/extensions/IERC721Metadata.sol@v4.6.0
383 
384 
385 // OpenZeppelin Contracts v4.4.1 (token/ERC721/extensions/IERC721Metadata.sol)
386 
387 pragma solidity ^0.8.0;
388 
389 /**
390  * @title ERC-721 Non-Fungible Token Standard, optional metadata extension
391  * @dev See https://eips.ethereum.org/EIPS/eip-721
392  */
393 interface IERC721Metadata is IERC721 {
394     /**
395      * @dev Returns the token collection name.
396      */
397     function name() external view returns (string memory);
398 
399     /**
400      * @dev Returns the token collection symbol.
401      */
402     function symbol() external view returns (string memory);
403 
404     /**
405      * @dev Returns the Uniform Resource Identifier (URI) for `tokenId` token.
406      */
407     function tokenURI(uint256 tokenId) external view returns (string memory);
408 }
409 
410 
411 // File @openzeppelin/contracts/utils/Address.sol@v4.6.0
412 
413 
414 // OpenZeppelin Contracts (last updated v4.5.0) (utils/Address.sol)
415 
416 pragma solidity ^0.8.1;
417 
418 /**
419  * @dev Collection of functions related to the address type
420  */
421 library Address {
422     /**
423      * @dev Returns true if `account` is a contract.
424      *
425      * [IMPORTANT]
426      * ====
427      * It is unsafe to assume that an address for which this function returns
428      * false is an externally-owned account (EOA) and not a contract.
429      *
430      * Among others, `isContract` will return false for the following
431      * types of addresses:
432      *
433      *  - an externally-owned account
434      *  - a contract in construction
435      *  - an address where a contract will be created
436      *  - an address where a contract lived, but was destroyed
437      * ====
438      *
439      * [IMPORTANT]
440      * ====
441      * You shouldn't rely on `isContract` to protect against flash loan attacks!
442      *
443      * Preventing calls from contracts is highly discouraged. It breaks composability, breaks support for smart wallets
444      * like Gnosis Safe, and does not provide security since it can be circumvented by calling from a contract
445      * constructor.
446      * ====
447      */
448     function isContract(address account) internal view returns (bool) {
449         // This method relies on extcodesize/address.code.length, which returns 0
450         // for contracts in construction, since the code is only stored at the end
451         // of the constructor execution.
452 
453         return account.code.length > 0;
454     }
455 
456     /**
457      * @dev Replacement for Solidity's `transfer`: sends `amount` wei to
458      * `recipient`, forwarding all available gas and reverting on errors.
459      *
460      * https://eips.ethereum.org/EIPS/eip-1884[EIP1884] increases the gas cost
461      * of certain opcodes, possibly making contracts go over the 2300 gas limit
462      * imposed by `transfer`, making them unable to receive funds via
463      * `transfer`. {sendValue} removes this limitation.
464      *
465      * https://diligence.consensys.net/posts/2019/09/stop-using-soliditys-transfer-now/[Learn more].
466      *
467      * IMPORTANT: because control is transferred to `recipient`, care must be
468      * taken to not create reentrancy vulnerabilities. Consider using
469      * {ReentrancyGuard} or the
470      * https://solidity.readthedocs.io/en/v0.5.11/security-considerations.html#use-the-checks-effects-interactions-pattern[checks-effects-interactions pattern].
471      */
472     function sendValue(address payable recipient, uint256 amount) internal {
473         require(address(this).balance >= amount, "Address: insufficient balance");
474 
475         (bool success, ) = recipient.call{value: amount}("");
476         require(success, "Address: unable to send value, recipient may have reverted");
477     }
478 
479     /**
480      * @dev Performs a Solidity function call using a low level `call`. A
481      * plain `call` is an unsafe replacement for a function call: use this
482      * function instead.
483      *
484      * If `target` reverts with a revert reason, it is bubbled up by this
485      * function (like regular Solidity function calls).
486      *
487      * Returns the raw returned data. To convert to the expected return value,
488      * use https://solidity.readthedocs.io/en/latest/units-and-global-variables.html?highlight=abi.decode#abi-encoding-and-decoding-functions[`abi.decode`].
489      *
490      * Requirements:
491      *
492      * - `target` must be a contract.
493      * - calling `target` with `data` must not revert.
494      *
495      * _Available since v3.1._
496      */
497     function functionCall(address target, bytes memory data) internal returns (bytes memory) {
498         return functionCall(target, data, "Address: low-level call failed");
499     }
500 
501     /**
502      * @dev Same as {xref-Address-functionCall-address-bytes-}[`functionCall`], but with
503      * `errorMessage` as a fallback revert reason when `target` reverts.
504      *
505      * _Available since v3.1._
506      */
507     function functionCall(
508         address target,
509         bytes memory data,
510         string memory errorMessage
511     ) internal returns (bytes memory) {
512         return functionCallWithValue(target, data, 0, errorMessage);
513     }
514 
515     /**
516      * @dev Same as {xref-Address-functionCall-address-bytes-}[`functionCall`],
517      * but also transferring `value` wei to `target`.
518      *
519      * Requirements:
520      *
521      * - the calling contract must have an ETH balance of at least `value`.
522      * - the called Solidity function must be `payable`.
523      *
524      * _Available since v3.1._
525      */
526     function functionCallWithValue(
527         address target,
528         bytes memory data,
529         uint256 value
530     ) internal returns (bytes memory) {
531         return functionCallWithValue(target, data, value, "Address: low-level call with value failed");
532     }
533 
534     /**
535      * @dev Same as {xref-Address-functionCallWithValue-address-bytes-uint256-}[`functionCallWithValue`], but
536      * with `errorMessage` as a fallback revert reason when `target` reverts.
537      *
538      * _Available since v3.1._
539      */
540     function functionCallWithValue(
541         address target,
542         bytes memory data,
543         uint256 value,
544         string memory errorMessage
545     ) internal returns (bytes memory) {
546         require(address(this).balance >= value, "Address: insufficient balance for call");
547         require(isContract(target), "Address: call to non-contract");
548 
549         (bool success, bytes memory returndata) = target.call{value: value}(data);
550         return verifyCallResult(success, returndata, errorMessage);
551     }
552 
553     /**
554      * @dev Same as {xref-Address-functionCall-address-bytes-}[`functionCall`],
555      * but performing a static call.
556      *
557      * _Available since v3.3._
558      */
559     function functionStaticCall(address target, bytes memory data) internal view returns (bytes memory) {
560         return functionStaticCall(target, data, "Address: low-level static call failed");
561     }
562 
563     /**
564      * @dev Same as {xref-Address-functionCall-address-bytes-string-}[`functionCall`],
565      * but performing a static call.
566      *
567      * _Available since v3.3._
568      */
569     function functionStaticCall(
570         address target,
571         bytes memory data,
572         string memory errorMessage
573     ) internal view returns (bytes memory) {
574         require(isContract(target), "Address: static call to non-contract");
575 
576         (bool success, bytes memory returndata) = target.staticcall(data);
577         return verifyCallResult(success, returndata, errorMessage);
578     }
579 
580     /**
581      * @dev Same as {xref-Address-functionCall-address-bytes-}[`functionCall`],
582      * but performing a delegate call.
583      *
584      * _Available since v3.4._
585      */
586     function functionDelegateCall(address target, bytes memory data) internal returns (bytes memory) {
587         return functionDelegateCall(target, data, "Address: low-level delegate call failed");
588     }
589 
590     /**
591      * @dev Same as {xref-Address-functionCall-address-bytes-string-}[`functionCall`],
592      * but performing a delegate call.
593      *
594      * _Available since v3.4._
595      */
596     function functionDelegateCall(
597         address target,
598         bytes memory data,
599         string memory errorMessage
600     ) internal returns (bytes memory) {
601         require(isContract(target), "Address: delegate call to non-contract");
602 
603         (bool success, bytes memory returndata) = target.delegatecall(data);
604         return verifyCallResult(success, returndata, errorMessage);
605     }
606 
607     /**
608      * @dev Tool to verifies that a low level call was successful, and revert if it wasn't, either by bubbling the
609      * revert reason using the provided one.
610      *
611      * _Available since v4.3._
612      */
613     function verifyCallResult(
614         bool success,
615         bytes memory returndata,
616         string memory errorMessage
617     ) internal pure returns (bytes memory) {
618         if (success) {
619             return returndata;
620         } else {
621             // Look for revert reason and bubble it up if present
622             if (returndata.length > 0) {
623                 // The easiest way to bubble the revert reason is using memory via assembly
624 
625                 assembly {
626                     let returndata_size := mload(returndata)
627                     revert(add(32, returndata), returndata_size)
628                 }
629             } else {
630                 revert(errorMessage);
631             }
632         }
633     }
634 }
635 
636 
637 // File @openzeppelin/contracts/utils/Strings.sol@v4.6.0
638 
639 
640 // OpenZeppelin Contracts v4.4.1 (utils/Strings.sol)
641 
642 pragma solidity ^0.8.0;
643 
644 /**
645  * @dev String operations.
646  */
647 library Strings {
648     bytes16 private constant _HEX_SYMBOLS = "0123456789abcdef";
649 
650     /**
651      * @dev Converts a `uint256` to its ASCII `string` decimal representation.
652      */
653     function toString(uint256 value) internal pure returns (string memory) {
654         // Inspired by OraclizeAPI's implementation - MIT licence
655         // https://github.com/oraclize/ethereum-api/blob/b42146b063c7d6ee1358846c198246239e9360e8/oraclizeAPI_0.4.25.sol
656 
657         if (value == 0) {
658             return "0";
659         }
660         uint256 temp = value;
661         uint256 digits;
662         while (temp != 0) {
663             digits++;
664             temp /= 10;
665         }
666         bytes memory buffer = new bytes(digits);
667         while (value != 0) {
668             digits -= 1;
669             buffer[digits] = bytes1(uint8(48 + uint256(value % 10)));
670             value /= 10;
671         }
672         return string(buffer);
673     }
674 
675     /**
676      * @dev Converts a `uint256` to its ASCII `string` hexadecimal representation.
677      */
678     function toHexString(uint256 value) internal pure returns (string memory) {
679         if (value == 0) {
680             return "0x00";
681         }
682         uint256 temp = value;
683         uint256 length = 0;
684         while (temp != 0) {
685             length++;
686             temp >>= 8;
687         }
688         return toHexString(value, length);
689     }
690 
691     /**
692      * @dev Converts a `uint256` to its ASCII `string` hexadecimal representation with fixed length.
693      */
694     function toHexString(uint256 value, uint256 length) internal pure returns (string memory) {
695         bytes memory buffer = new bytes(2 * length + 2);
696         buffer[0] = "0";
697         buffer[1] = "x";
698         for (uint256 i = 2 * length + 1; i > 1; --i) {
699             buffer[i] = _HEX_SYMBOLS[value & 0xf];
700             value >>= 4;
701         }
702         require(value == 0, "Strings: hex length insufficient");
703         return string(buffer);
704     }
705 }
706 
707 
708 // File @openzeppelin/contracts/utils/introspection/ERC165.sol@v4.6.0
709 
710 
711 // OpenZeppelin Contracts v4.4.1 (utils/introspection/ERC165.sol)
712 
713 pragma solidity ^0.8.0;
714 
715 /**
716  * @dev Implementation of the {IERC165} interface.
717  *
718  * Contracts that want to implement ERC165 should inherit from this contract and override {supportsInterface} to check
719  * for the additional interface id that will be supported. For example:
720  *
721  * ```solidity
722  * function supportsInterface(bytes4 interfaceId) public view virtual override returns (bool) {
723  *     return interfaceId == type(MyInterface).interfaceId || super.supportsInterface(interfaceId);
724  * }
725  * ```
726  *
727  * Alternatively, {ERC165Storage} provides an easier to use but more expensive implementation.
728  */
729 abstract contract ERC165 is IERC165 {
730     /**
731      * @dev See {IERC165-supportsInterface}.
732      */
733     function supportsInterface(bytes4 interfaceId) public view virtual override returns (bool) {
734         return interfaceId == type(IERC165).interfaceId;
735     }
736 }
737 
738 
739 // File contracts/ERC721A.sol
740 
741 
742 // Creator: Chiru Labs
743 
744 pragma solidity ^0.8.0;
745 /**
746  * @dev Implementation of https://eips.ethereum.org/EIPS/eip-721[ERC721] Non-Fungible Token Standard, including
747  * the Metadata extension. Built to optimize for lower gas during batch mints.
748  *
749  * Assumes serials are sequentially minted starting at 0 (e.g. 0, 1, 2, 3..).
750  *
751  * Does not support burning tokens to address(0).
752  *
753  * Assumes that an owner cannot have more than the 2**128 - 1 (max value of uint128) of supply
754  */
755 contract ERC721A is Context, ERC165, IERC721, IERC721Metadata {
756     using Address for address;
757     using Strings for uint256;
758 
759     struct TokenOwnership {
760         address addr;
761         uint64 startTimestamp;
762     }
763 
764     struct AddressData {
765         uint128 balance;
766         uint128 numberMinted;
767     }
768 
769     uint256 internal currentIndex;
770 
771     // Token name
772     string private _name;
773 
774     // Token symbol
775     string private _symbol;
776 
777     // Mapping from token ID to ownership details
778     // An empty struct value does not necessarily mean the token is unowned. See ownershipOf implementation for details.
779     mapping(uint256 => TokenOwnership) internal _ownerships;
780 
781     // Mapping owner address to address data
782     mapping(address => AddressData) private _addressData;
783 
784     // Mapping from token ID to approved address
785     mapping(uint256 => address) private _tokenApprovals;
786 
787     // Mapping from owner to operator approvals
788     mapping(address => mapping(address => bool)) private _operatorApprovals;
789 
790     constructor(string memory name_, string memory symbol_) {
791         _name = name_;
792         _symbol = symbol_;
793     }
794 
795     function totalSupply() public view returns (uint256) {
796         return currentIndex;
797     }
798 
799     /**
800      * @dev See {IERC165-supportsInterface}.
801      */
802     function supportsInterface(bytes4 interfaceId) public view virtual override(ERC165, IERC165) returns (bool) {
803         return
804         interfaceId == type(IERC721).interfaceId ||
805         interfaceId == type(IERC721Metadata).interfaceId ||
806         super.supportsInterface(interfaceId);
807     }
808 
809     /**
810      * @dev See {IERC721-balanceOf}.
811      */
812     function balanceOf(address owner) public view override returns (uint256) {
813         require(owner != address(0), 'ERC721A: balance query for the zero address');
814         return uint256(_addressData[owner].balance);
815     }
816 
817     function _numberMinted(address owner) internal view returns (uint256) {
818         require(owner != address(0), 'ERC721A: number minted query for the zero address');
819         return uint256(_addressData[owner].numberMinted);
820     }
821 
822     /**
823      * Gas spent here starts off proportional to the maximum mint batch size.
824      * It gradually moves to O(1) as tokens get transferred around in the collection over time.
825      */
826     function ownershipOf(uint256 tokenId) internal view returns (TokenOwnership memory) {
827         require(_exists(tokenId), 'ERC721A: owner query for nonexistent token');
828 
829     unchecked {
830         for (uint256 curr = tokenId; curr >= 0; curr--) {
831             TokenOwnership memory ownership = _ownerships[curr];
832             if (ownership.addr != address(0)) {
833                 return ownership;
834             }
835         }
836     }
837 
838         revert('ERC721A: unable to determine the owner of token');
839     }
840 
841     /**
842      * @dev See {IERC721-ownerOf}.
843      */
844     function ownerOf(uint256 tokenId) public view override returns (address) {
845         return ownershipOf(tokenId).addr;
846     }
847 
848     /**
849      * @dev See {IERC721Metadata-name}.
850      */
851     function name() public view virtual override returns (string memory) {
852         return _name;
853     }
854 
855     /**
856      * @dev See {IERC721Metadata-symbol}.
857      */
858     function symbol() public view virtual override returns (string memory) {
859         return _symbol;
860     }
861 
862     /**
863      * @dev See {IERC721Metadata-tokenURI}.
864      */
865     function tokenURI(uint256 tokenId) public view virtual override returns (string memory) {
866         require(_exists(tokenId), 'ERC721Metadata: URI query for nonexistent token');
867 
868         string memory baseURI = _baseURI();
869         return bytes(baseURI).length != 0 ? string(abi.encodePacked(baseURI, tokenId.toString())) : '';
870     }
871 
872     /**
873      * @dev Base URI for computing {tokenURI}. If set, the resulting URI for each
874      * token will be the concatenation of the `baseURI` and the `tokenId`. Empty
875      * by default, can be overriden in child contracts.
876      */
877     function _baseURI() internal view virtual returns (string memory) {
878         return '';
879     }
880 
881     /**
882      * @dev See {IERC721-approve}.
883      */
884     function approve(address to, uint256 tokenId) public override {
885         address owner = ERC721A.ownerOf(tokenId);
886         require(to != owner, 'ERC721A: approval to current owner');
887 
888         require(
889             _msgSender() == owner || isApprovedForAll(owner, _msgSender()),
890             'ERC721A: approve caller is not owner nor approved for all'
891         );
892 
893         _approve(to, tokenId, owner);
894     }
895 
896     /**
897      * @dev See {IERC721-getApproved}.
898      */
899     function getApproved(uint256 tokenId) public view override returns (address) {
900         require(_exists(tokenId), 'ERC721A: approved query for nonexistent token');
901 
902         return _tokenApprovals[tokenId];
903     }
904 
905     /**
906      * @dev See {IERC721-setApprovalForAll}.
907      */
908     function setApprovalForAll(address operator, bool approved) public override {
909         require(operator != _msgSender(), 'ERC721A: approve to caller');
910 
911         _operatorApprovals[_msgSender()][operator] = approved;
912         emit ApprovalForAll(_msgSender(), operator, approved);
913     }
914 
915     /**
916      * @dev See {IERC721-isApprovedForAll}.
917      */
918     function isApprovedForAll(address owner, address operator) public view virtual override returns (bool) {
919         return _operatorApprovals[owner][operator];
920     }
921 
922     /**
923      * @dev See {IERC721-transferFrom}.
924      */
925     function transferFrom(
926         address from,
927         address to,
928         uint256 tokenId
929     ) public override {
930         _transfer(from, to, tokenId);
931     }
932 
933     /**
934      * @dev See {IERC721-safeTransferFrom}.
935      */
936     function safeTransferFrom(
937         address from,
938         address to,
939         uint256 tokenId
940     ) public override {
941         safeTransferFrom(from, to, tokenId, '');
942     }
943 
944     /**
945      * @dev See {IERC721-safeTransferFrom}.
946      */
947     function safeTransferFrom(
948         address from,
949         address to,
950         uint256 tokenId,
951         bytes memory _data
952     ) public override {
953         _transfer(from, to, tokenId);
954         require(
955             _checkOnERC721Received(from, to, tokenId, _data),
956             'ERC721A: transfer to non ERC721Receiver implementer'
957         );
958     }
959 
960     /**
961      * @dev Returns whether `tokenId` exists.
962      *
963      * Tokens can be managed by their owner or approved accounts via {approve} or {setApprovalForAll}.
964      *
965      * Tokens start existing when they are minted (`_mint`),
966      */
967     function _exists(uint256 tokenId) internal view returns (bool) {
968         return tokenId < currentIndex;
969     }
970 
971     function _safeMint(address to, uint256 quantity) internal {
972         _safeMint(to, quantity, '');
973     }
974 
975     /**
976      * @dev Safely mints `quantity` tokens and transfers them to `to`.
977      *
978      * Requirements:
979      *
980      * - If `to` refers to a smart contract, it must implement {IERC721Receiver-onERC721Received}, which is called for each safe transfer.
981      * - `quantity` must be greater than 0.
982      *
983      * Emits a {Transfer} event.
984      */
985     function _safeMint(
986         address to,
987         uint256 quantity,
988         bytes memory _data
989     ) internal {
990         _mint(to, quantity, _data, true);
991     }
992 
993     /**
994      * @dev Mints `quantity` tokens and transfers them to `to`.
995      *
996      * Requirements:
997      *
998      * - `to` cannot be the zero address.
999      * - `quantity` must be greater than 0.
1000      *
1001      * Emits a {Transfer} event.
1002      */
1003     function _mint(
1004         address to,
1005         uint256 quantity,
1006         bytes memory _data,
1007         bool safe
1008     ) internal {
1009         uint256 startTokenId = currentIndex;
1010         require(to != address(0), 'ERC721A: mint to the zero address');
1011         require(quantity != 0, 'ERC721A: quantity must be greater than 0');
1012 
1013         _beforeTokenTransfers(address(0), to, startTokenId, quantity);
1014 
1015         // Overflows are incredibly unrealistic.
1016         // balance or numberMinted overflow if current value of either + quantity > 3.4e38 (2**128) - 1
1017         // updatedIndex overflows if currentIndex + quantity > 1.56e77 (2**256) - 1
1018     unchecked {
1019         _addressData[to].balance += uint128(quantity);
1020         _addressData[to].numberMinted += uint128(quantity);
1021 
1022         _ownerships[startTokenId].addr = to;
1023         _ownerships[startTokenId].startTimestamp = uint64(block.timestamp);
1024 
1025         uint256 updatedIndex = startTokenId;
1026 
1027         for (uint256 i; i < quantity; i++) {
1028             emit Transfer(address(0), to, updatedIndex);
1029             if (safe) {
1030                 require(
1031                     _checkOnERC721Received(address(0), to, updatedIndex, _data),
1032                     'ERC721A: transfer to non ERC721Receiver implementer'
1033                 );
1034             }
1035 
1036             updatedIndex++;
1037         }
1038 
1039         currentIndex = updatedIndex;
1040     }
1041 
1042         _afterTokenTransfers(address(0), to, startTokenId, quantity);
1043     }
1044 
1045     /**
1046      * @dev Transfers `tokenId` from `from` to `to`.
1047      *
1048      * Requirements:
1049      *
1050      * - `to` cannot be the zero address.
1051      * - `tokenId` token must be owned by `from`.
1052      *
1053      * Emits a {Transfer} event.
1054      */
1055     function _transfer(
1056         address from,
1057         address to,
1058         uint256 tokenId
1059     ) private {
1060         TokenOwnership memory prevOwnership = ownershipOf(tokenId);
1061 
1062         bool isApprovedOrOwner = (_msgSender() == prevOwnership.addr ||
1063         getApproved(tokenId) == _msgSender() ||
1064         isApprovedForAll(prevOwnership.addr, _msgSender()));
1065 
1066         require(isApprovedOrOwner, 'ERC721A: transfer caller is not owner nor approved');
1067 
1068         require(prevOwnership.addr == from, 'ERC721A: transfer from incorrect owner');
1069         require(to != address(0), 'ERC721A: transfer to the zero address');
1070 
1071         _beforeTokenTransfers(from, to, tokenId, 1);
1072 
1073         // Clear approvals from the previous owner
1074         _approve(address(0), tokenId, prevOwnership.addr);
1075 
1076         // Underflow of the sender's balance is impossible because we check for
1077         // ownership above and the recipient's balance can't realistically overflow.
1078         // Counter overflow is incredibly unrealistic as tokenId would have to be 2**256.
1079     unchecked {
1080         _addressData[from].balance -= 1;
1081         _addressData[to].balance += 1;
1082 
1083         _ownerships[tokenId].addr = to;
1084         _ownerships[tokenId].startTimestamp = uint64(block.timestamp);
1085 
1086         // If the ownership slot of tokenId+1 is not explicitly set, that means the transfer initiator owns it.
1087         // Set the slot of tokenId+1 explicitly in storage to maintain correctness for ownerOf(tokenId+1) calls.
1088         uint256 nextTokenId = tokenId + 1;
1089         if (_ownerships[nextTokenId].addr == address(0)) {
1090             if (_exists(nextTokenId)) {
1091                 _ownerships[nextTokenId].addr = prevOwnership.addr;
1092                 _ownerships[nextTokenId].startTimestamp = prevOwnership.startTimestamp;
1093             }
1094         }
1095     }
1096 
1097         emit Transfer(from, to, tokenId);
1098         _afterTokenTransfers(from, to, tokenId, 1);
1099     }
1100 
1101     /**
1102      * @dev Approve `to` to operate on `tokenId`
1103      *
1104      * Emits a {Approval} event.
1105      */
1106     function _approve(
1107         address to,
1108         uint256 tokenId,
1109         address owner
1110     ) private {
1111         _tokenApprovals[tokenId] = to;
1112         emit Approval(owner, to, tokenId);
1113     }
1114 
1115     /**
1116      * @dev Internal function to invoke {IERC721Receiver-onERC721Received} on a target address.
1117      * The call is not executed if the target address is not a contract.
1118      *
1119      * @param from address representing the previous owner of the given token ID
1120      * @param to target address that will receive the tokens
1121      * @param tokenId uint256 ID of the token to be transferred
1122      * @param _data bytes optional data to send along with the call
1123      * @return bool whether the call correctly returned the expected magic value
1124      */
1125     function _checkOnERC721Received(
1126         address from,
1127         address to,
1128         uint256 tokenId,
1129         bytes memory _data
1130     ) private returns (bool) {
1131         if (to.isContract()) {
1132             try IERC721Receiver(to).onERC721Received(_msgSender(), from, tokenId, _data) returns (bytes4 retval) {
1133                 return retval == IERC721Receiver(to).onERC721Received.selector;
1134             } catch (bytes memory reason) {
1135                 if (reason.length == 0) {
1136                     revert('ERC721A: transfer to non ERC721Receiver implementer');
1137                 } else {
1138                     assembly {
1139                         revert(add(32, reason), mload(reason))
1140                     }
1141                 }
1142             }
1143         } else {
1144             return true;
1145         }
1146     }
1147 
1148     /**
1149      * @dev Hook that is called before a set of serially-ordered token ids are about to be transferred. This includes minting.
1150      *
1151      * startTokenId - the first token id to be transferred
1152      * quantity - the amount to be transferred
1153      *
1154      * Calling conditions:
1155      *
1156      * - When `from` and `to` are both non-zero, ``from``'s `tokenId` will be
1157      * transferred to `to`.
1158      * - When `from` is zero, `tokenId` will be minted for `to`.
1159      */
1160     function _beforeTokenTransfers(
1161         address from,
1162         address to,
1163         uint256 startTokenId,
1164         uint256 quantity
1165     ) internal virtual {}
1166 
1167     /**
1168      * @dev Hook that is called after a set of serially-ordered token ids have been transferred. This includes
1169      * minting.
1170      *
1171      * startTokenId - the first token id to be transferred
1172      * quantity - the amount to be transferred
1173      *
1174      * Calling conditions:
1175      *
1176      * - when `from` and `to` are both non-zero.
1177      * - `from` and `to` are never both zero.
1178      */
1179     function _afterTokenTransfers(
1180         address from,
1181         address to,
1182         uint256 startTokenId,
1183         uint256 quantity
1184     ) internal virtual {}
1185 }
1186 
1187 pragma solidity ^0.8.0;
1188 
1189 contract TheDingalings is Ownable, ERC721A, ReentrancyGuard {
1190     string public baseURI = "";
1191 	uint256 public constant PRICE = 0.0033 ether;
1192 	uint256 public constant MAX_SUPPLY = 10000;
1193 	uint256 public maxPerTx = 20;
1194 	uint256 public maxPerWallet = 60;
1195 	uint256 public maxFreePerWallet = 2;
1196 	uint256 public totalFree = 1000;
1197 	uint256 public freeMinted = 0;
1198 	bool public mintEnabled = false;
1199 
1200 	mapping(address => uint256) private freeMintedByAddress;
1201 
1202     constructor() ERC721A("The Dingalings", "DNGLNGS") {}
1203 
1204 	/******************************************************************
1205 	 * Modifier to validate whether someone can mint a certain amount.
1206 	 ******************************************************************/
1207 
1208 	modifier validate(uint256 amt) {
1209 		require(mintEnabled, "Minting hasn't been enabled yet.");
1210 		require(msg.sender == tx.origin, "Sneaky sneak, ser,");
1211 		require(totalSupply() + amt < MAX_SUPPLY + 1, "We've minted all Dingalings.");
1212 		require(amt > 0, "Amount must be greater than 0.");
1213 		
1214 		_;
1215 	}
1216 
1217 	/************************
1218 	 * Our minting functions
1219 	 ************************/
1220 
1221 	function mint(uint256 amt) external payable validate(amt) nonReentrant {
1222 		require(msg.value == amt * PRICE, "Please send the exact amount of eth.");
1223 		require(numberMinted(msg.sender) + amt < maxPerWallet + 1, "Your wallet owns the max. amount of Dingalings.");
1224 		require(amt < maxPerTx + 1, "You tried to mint too many Dingalings in one transaction.");
1225 
1226 		_safeMint(msg.sender, amt);
1227 	}
1228 
1229 	function mintFree(uint256 amt) external validate(amt) nonReentrant {
1230 		require(freeMinted + amt < totalFree + 1, "We've given out all of our free Dingalings.");
1231 		require(freeMintedByAddress[msg.sender] + amt < maxFreePerWallet + 1, "You've already minted the max. amount of free Dingalings.");
1232 
1233 		freeMinted += amt;
1234 		freeMintedByAddress[msg.sender] += amt;
1235 
1236 		_safeMint(msg.sender, amt);
1237 	}
1238 
1239 	function mintForAddresses(address[] calldata _addresses, uint256 _quantity) public onlyOwner {
1240 		uint256 addressLength = _addresses.length;
1241 		uint256 amt = addressLength * _quantity;
1242 
1243 		require(totalSupply() + amt < MAX_SUPPLY + 1, "We've minted all Dingalings.");
1244 
1245 		for (uint i = 0; i < addressLength; i++) {
1246 			_safeMint(_addresses[i], _quantity);
1247 		}
1248 	}
1249 
1250 	/**********************************************************************
1251 	 * Overwrite some functions to return the proper baseURI and tokenURI.
1252 	 **********************************************************************/
1253 	
1254 	function _baseURI() internal view virtual override returns (string memory) {
1255         return baseURI;
1256     }
1257 
1258 	function tokenURI(uint256 tokenId) public view virtual override returns (string memory) {
1259         string memory uri = super.tokenURI(tokenId);
1260 
1261         return bytes(uri).length > 0 ? string(abi.encodePacked(uri, ".json")) : "";
1262     }
1263 
1264 	/**********************************************
1265 	 * Extract some information from our Contract.
1266 	 **********************************************/
1267 
1268 	function getContractBalance() external view onlyOwner returns (uint256) {
1269 		return address(this).balance;
1270 	}
1271 
1272 	function numberMinted(address owner) public view returns (uint256) {
1273 		return _numberMinted(owner);
1274 	}
1275 
1276     /********************************************************
1277 	 * Change some of our Contract's variables if necessary.
1278 	 ********************************************************/
1279 
1280 	function toggleMinting() external onlyOwner {
1281 		mintEnabled = !mintEnabled;
1282 	}
1283 
1284 	function setBaseURI(string calldata _uri) external onlyOwner {
1285 		baseURI = _uri;
1286 	}
1287 
1288 	function setTotalFree(uint256 _totalFree) external onlyOwner {
1289 		totalFree = _totalFree;
1290 	}
1291 
1292 	function setMaxPerTx(uint256 _maxPerTx) external onlyOwner {
1293 		maxPerTx = _maxPerTx;
1294 	}
1295 
1296 	function setMaxPerWallet(uint256 _maxPerWallet) external onlyOwner {
1297 		maxPerWallet = _maxPerWallet;
1298 	}
1299 
1300 	function setMaxFreePerWallet(uint256 _maxFreePerWallet) external onlyOwner {
1301 		maxFreePerWallet = _maxFreePerWallet;
1302 	}
1303 
1304 	/************************************
1305 	 * Withdraw funds from the Contract.
1306 	 ************************************/
1307 
1308 	function withdraw() external onlyOwner nonReentrant {
1309 		(bool success, ) = msg.sender.call{value: address(this).balance}("");
1310 		require(success, "Transfer failed.");
1311 	}
1312 }