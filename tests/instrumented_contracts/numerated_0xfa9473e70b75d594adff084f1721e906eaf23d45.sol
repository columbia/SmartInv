1 // SPDX-License-Identifier: GPL-3.0
2 
3 // File: @openzeppelin/contracts/utils/introspection/IERC165.sol
4 
5 // OpenZeppelin Contracts v4.4.1 (utils/introspection/IERC165.sol)
6 
7 pragma solidity ^0.8.0;
8 
9 /**
10  * @dev Interface of the ERC165 standard, as defined in the
11  * https://eips.ethereum.org/EIPS/eip-165[EIP].
12  *
13  * Implementers can declare support of contract interfaces, which can then be
14  * queried by others ({ERC165Checker}).
15  *
16  * For an implementation, see {ERC165}.
17  */
18 interface IERC165 {
19     /**
20      * @dev Returns true if this contract implements the interface defined by
21      * `interfaceId`. See the corresponding
22      * https://eips.ethereum.org/EIPS/eip-165#how-interfaces-are-identified[EIP section]
23      * to learn more about how these ids are created.
24      *
25      * This function call must use less than 30 000 gas.
26      */
27     function supportsInterface(bytes4 interfaceId) external view returns (bool);
28 }
29 
30 // File: @openzeppelin/contracts/token/ERC721/IERC721.sol
31 
32 
33 // OpenZeppelin Contracts (last updated v4.6.0) (token/ERC721/IERC721.sol)
34 
35 pragma solidity ^0.8.0;
36 
37 
38 /**
39  * @dev Required interface of an ERC721 compliant contract.
40  */
41 interface IERC721 is IERC165 {
42     /**
43      * @dev Emitted when `tokenId` token is transferred from `from` to `to`.
44      */
45     event Transfer(address indexed from, address indexed to, uint256 indexed tokenId);
46 
47     /**
48      * @dev Emitted when `owner` enables `approved` to manage the `tokenId` token.
49      */
50     event Approval(address indexed owner, address indexed approved, uint256 indexed tokenId);
51 
52     /**
53      * @dev Emitted when `owner` enables or disables (`approved`) `operator` to manage all of its assets.
54      */
55     event ApprovalForAll(address indexed owner, address indexed operator, bool approved);
56 
57     /**
58      * @dev Returns the number of tokens in ``owner``'s account.
59      */
60     function balanceOf(address owner) external view returns (uint256 balance);
61 
62     /**
63      * @dev Returns the owner of the `tokenId` token.
64      *
65      * Requirements:
66      *
67      * - `tokenId` must exist.
68      */
69     function ownerOf(uint256 tokenId) external view returns (address owner);
70 
71     /**
72      * @dev Safely transfers `tokenId` token from `from` to `to`.
73      *
74      * Requirements:
75      *
76      * - `from` cannot be the zero address.
77      * - `to` cannot be the zero address.
78      * - `tokenId` token must exist and be owned by `from`.
79      * - If the caller is not `from`, it must be approved to move this token by either {approve} or {setApprovalForAll}.
80      * - If `to` refers to a smart contract, it must implement {IERC721Receiver-onERC721Received}, which is called upon a safe transfer.
81      *
82      * Emits a {Transfer} event.
83      */
84     function safeTransferFrom(
85         address from,
86         address to,
87         uint256 tokenId,
88         bytes calldata data
89     ) external;
90 
91     /**
92      * @dev Safely transfers `tokenId` token from `from` to `to`, checking first that contract recipients
93      * are aware of the ERC721 protocol to prevent tokens from being forever locked.
94      *
95      * Requirements:
96      *
97      * - `from` cannot be the zero address.
98      * - `to` cannot be the zero address.
99      * - `tokenId` token must exist and be owned by `from`.
100      * - If the caller is not `from`, it must be have been allowed to move this token by either {approve} or {setApprovalForAll}.
101      * - If `to` refers to a smart contract, it must implement {IERC721Receiver-onERC721Received}, which is called upon a safe transfer.
102      *
103      * Emits a {Transfer} event.
104      */
105     function safeTransferFrom(
106         address from,
107         address to,
108         uint256 tokenId
109     ) external;
110 
111     /**
112      * @dev Transfers `tokenId` token from `from` to `to`.
113      *
114      * WARNING: Usage of this method is discouraged, use {safeTransferFrom} whenever possible.
115      *
116      * Requirements:
117      *
118      * - `from` cannot be the zero address.
119      * - `to` cannot be the zero address.
120      * - `tokenId` token must be owned by `from`.
121      * - If the caller is not `from`, it must be approved to move this token by either {approve} or {setApprovalForAll}.
122      *
123      * Emits a {Transfer} event.
124      */
125     function transferFrom(
126         address from,
127         address to,
128         uint256 tokenId
129     ) external;
130 
131     /**
132      * @dev Gives permission to `to` to transfer `tokenId` token to another account.
133      * The approval is cleared when the token is transferred.
134      *
135      * Only a single account can be approved at a time, so approving the zero address clears previous approvals.
136      *
137      * Requirements:
138      *
139      * - The caller must own the token or be an approved operator.
140      * - `tokenId` must exist.
141      *
142      * Emits an {Approval} event.
143      */
144     function approve(address to, uint256 tokenId) external;
145 
146     /**
147      * @dev Approve or remove `operator` as an operator for the caller.
148      * Operators can call {transferFrom} or {safeTransferFrom} for any token owned by the caller.
149      *
150      * Requirements:
151      *
152      * - The `operator` cannot be the caller.
153      *
154      * Emits an {ApprovalForAll} event.
155      */
156     function setApprovalForAll(address operator, bool _approved) external;
157 
158     /**
159      * @dev Returns the account approved for `tokenId` token.
160      *
161      * Requirements:
162      *
163      * - `tokenId` must exist.
164      */
165     function getApproved(uint256 tokenId) external view returns (address operator);
166 
167     /**
168      * @dev Returns if the `operator` is allowed to manage all of the assets of `owner`.
169      *
170      * See {setApprovalForAll}
171      */
172     function isApprovedForAll(address owner, address operator) external view returns (bool);
173 }
174 
175 // File: @openzeppelin/contracts/token/ERC721/extensions/IERC721Metadata.sol
176 
177 
178 // OpenZeppelin Contracts v4.4.1 (token/ERC721/extensions/IERC721Metadata.sol)
179 
180 pragma solidity ^0.8.0;
181 
182 
183 /**
184  * @title ERC-721 Non-Fungible Token Standard, optional metadata extension
185  * @dev See https://eips.ethereum.org/EIPS/eip-721
186  */
187 interface IERC721Metadata is IERC721 {
188     /**
189      * @dev Returns the token collection name.
190      */
191     function name() external view returns (string memory);
192 
193     /**
194      * @dev Returns the token collection symbol.
195      */
196     function symbol() external view returns (string memory);
197 
198     /**
199      * @dev Returns the Uniform Resource Identifier (URI) for `tokenId` token.
200      */
201     function tokenURI(uint256 tokenId) external view returns (string memory);
202 }
203 
204 // File: @openzeppelin/contracts/utils/introspection/ERC165.sol
205 
206 
207 // OpenZeppelin Contracts v4.4.1 (utils/introspection/ERC165.sol)
208 
209 pragma solidity ^0.8.0;
210 
211 
212 /**
213  * @dev Implementation of the {IERC165} interface.
214  *
215  * Contracts that want to implement ERC165 should inherit from this contract and override {supportsInterface} to check
216  * for the additional interface id that will be supported. For example:
217  *
218  * ```solidity
219  * function supportsInterface(bytes4 interfaceId) public view virtual override returns (bool) {
220  *     return interfaceId == type(MyInterface).interfaceId || super.supportsInterface(interfaceId);
221  * }
222  * ```
223  *
224  * Alternatively, {ERC165Storage} provides an easier to use but more expensive implementation.
225  */
226 abstract contract ERC165 is IERC165 {
227     /**
228      * @dev See {IERC165-supportsInterface}.
229      */
230     function supportsInterface(bytes4 interfaceId) public view virtual override returns (bool) {
231         return interfaceId == type(IERC165).interfaceId;
232     }
233 }
234 
235 // File: @openzeppelin/contracts/token/ERC721/IERC721Receiver.sol
236 
237 
238 // OpenZeppelin Contracts (last updated v4.6.0) (token/ERC721/IERC721Receiver.sol)
239 
240 pragma solidity ^0.8.0;
241 
242 /**
243  * @title ERC721 token receiver interface
244  * @dev Interface for any contract that wants to support safeTransfers
245  * from ERC721 asset contracts.
246  */
247 interface IERC721Receiver {
248     /**
249      * @dev Whenever an {IERC721} `tokenId` token is transferred to this contract via {IERC721-safeTransferFrom}
250      * by `operator` from `from`, this function is called.
251      *
252      * It must return its Solidity selector to confirm the token transfer.
253      * If any other value is returned or the interface is not implemented by the recipient, the transfer will be reverted.
254      *
255      * The selector can be obtained in Solidity with `IERC721Receiver.onERC721Received.selector`.
256      */
257     function onERC721Received(
258         address operator,
259         address from,
260         uint256 tokenId,
261         bytes calldata data
262     ) external returns (bytes4);
263 }
264 
265 // File: @openzeppelin/contracts/utils/Address.sol
266 
267 
268 // OpenZeppelin Contracts (last updated v4.5.0) (utils/Address.sol)
269 
270 pragma solidity ^0.8.1;
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
292      *
293      * [IMPORTANT]
294      * ====
295      * You shouldn't rely on `isContract` to protect against flash loan attacks!
296      *
297      * Preventing calls from contracts is highly discouraged. It breaks composability, breaks support for smart wallets
298      * like Gnosis Safe, and does not provide security since it can be circumvented by calling from a contract
299      * constructor.
300      * ====
301      */
302     function isContract(address account) internal view returns (bool) {
303         // This method relies on extcodesize/address.code.length, which returns 0
304         // for contracts in construction, since the code is only stored at the end
305         // of the constructor execution.
306 
307         return account.code.length > 0;
308     }
309 
310     /**
311      * @dev Replacement for Solidity's `transfer`: sends `amount` wei to
312      * `recipient`, forwarding all available gas and reverting on errors.
313      *
314      * https://eips.ethereum.org/EIPS/eip-1884[EIP1884] increases the gas cost
315      * of certain opcodes, possibly making contracts go over the 2300 gas limit
316      * imposed by `transfer`, making them unable to receive funds via
317      * `transfer`. {sendValue} removes this limitation.
318      *
319      * https://diligence.consensys.net/posts/2019/09/stop-using-soliditys-transfer-now/[Learn more].
320      *
321      * IMPORTANT: because control is transferred to `recipient`, care must be
322      * taken to not create reentrancy vulnerabilities. Consider using
323      * {ReentrancyGuard} or the
324      * https://solidity.readthedocs.io/en/v0.5.11/security-considerations.html#use-the-checks-effects-interactions-pattern[checks-effects-interactions pattern].
325      */
326     function sendValue(address payable recipient, uint256 amount) internal {
327         require(address(this).balance >= amount, "Address: insufficient balance");
328 
329         (bool success, ) = recipient.call{value: amount}("");
330         require(success, "Address: unable to send value, recipient may have reverted");
331     }
332 
333     /**
334      * @dev Performs a Solidity function call using a low level `call`. A
335      * plain `call` is an unsafe replacement for a function call: use this
336      * function instead.
337      *
338      * If `target` reverts with a revert reason, it is bubbled up by this
339      * function (like regular Solidity function calls).
340      *
341      * Returns the raw returned data. To convert to the expected return value,
342      * use https://solidity.readthedocs.io/en/latest/units-and-global-variables.html?highlight=abi.decode#abi-encoding-and-decoding-functions[`abi.decode`].
343      *
344      * Requirements:
345      *
346      * - `target` must be a contract.
347      * - calling `target` with `data` must not revert.
348      *
349      * _Available since v3.1._
350      */
351     function functionCall(address target, bytes memory data) internal returns (bytes memory) {
352         return functionCall(target, data, "Address: low-level call failed");
353     }
354 
355     /**
356      * @dev Same as {xref-Address-functionCall-address-bytes-}[`functionCall`], but with
357      * `errorMessage` as a fallback revert reason when `target` reverts.
358      *
359      * _Available since v3.1._
360      */
361     function functionCall(
362         address target,
363         bytes memory data,
364         string memory errorMessage
365     ) internal returns (bytes memory) {
366         return functionCallWithValue(target, data, 0, errorMessage);
367     }
368 
369     /**
370      * @dev Same as {xref-Address-functionCall-address-bytes-}[`functionCall`],
371      * but also transferring `value` wei to `target`.
372      *
373      * Requirements:
374      *
375      * - the calling contract must have an ETH balance of at least `value`.
376      * - the called Solidity function must be `payable`.
377      *
378      * _Available since v3.1._
379      */
380     function functionCallWithValue(
381         address target,
382         bytes memory data,
383         uint256 value
384     ) internal returns (bytes memory) {
385         return functionCallWithValue(target, data, value, "Address: low-level call with value failed");
386     }
387 
388     /**
389      * @dev Same as {xref-Address-functionCallWithValue-address-bytes-uint256-}[`functionCallWithValue`], but
390      * with `errorMessage` as a fallback revert reason when `target` reverts.
391      *
392      * _Available since v3.1._
393      */
394     function functionCallWithValue(
395         address target,
396         bytes memory data,
397         uint256 value,
398         string memory errorMessage
399     ) internal returns (bytes memory) {
400         require(address(this).balance >= value, "Address: insufficient balance for call");
401         require(isContract(target), "Address: call to non-contract");
402 
403         (bool success, bytes memory returndata) = target.call{value: value}(data);
404         return verifyCallResult(success, returndata, errorMessage);
405     }
406 
407     /**
408      * @dev Same as {xref-Address-functionCall-address-bytes-}[`functionCall`],
409      * but performing a static call.
410      *
411      * _Available since v3.3._
412      */
413     function functionStaticCall(address target, bytes memory data) internal view returns (bytes memory) {
414         return functionStaticCall(target, data, "Address: low-level static call failed");
415     }
416 
417     /**
418      * @dev Same as {xref-Address-functionCall-address-bytes-string-}[`functionCall`],
419      * but performing a static call.
420      *
421      * _Available since v3.3._
422      */
423     function functionStaticCall(
424         address target,
425         bytes memory data,
426         string memory errorMessage
427     ) internal view returns (bytes memory) {
428         require(isContract(target), "Address: static call to non-contract");
429 
430         (bool success, bytes memory returndata) = target.staticcall(data);
431         return verifyCallResult(success, returndata, errorMessage);
432     }
433 
434     /**
435      * @dev Same as {xref-Address-functionCall-address-bytes-}[`functionCall`],
436      * but performing a delegate call.
437      *
438      * _Available since v3.4._
439      */
440     function functionDelegateCall(address target, bytes memory data) internal returns (bytes memory) {
441         return functionDelegateCall(target, data, "Address: low-level delegate call failed");
442     }
443 
444     /**
445      * @dev Same as {xref-Address-functionCall-address-bytes-string-}[`functionCall`],
446      * but performing a delegate call.
447      *
448      * _Available since v3.4._
449      */
450     function functionDelegateCall(
451         address target,
452         bytes memory data,
453         string memory errorMessage
454     ) internal returns (bytes memory) {
455         require(isContract(target), "Address: delegate call to non-contract");
456 
457         (bool success, bytes memory returndata) = target.delegatecall(data);
458         return verifyCallResult(success, returndata, errorMessage);
459     }
460 
461     /**
462      * @dev Tool to verifies that a low level call was successful, and revert if it wasn't, either by bubbling the
463      * revert reason using the provided one.
464      *
465      * _Available since v4.3._
466      */
467     function verifyCallResult(
468         bool success,
469         bytes memory returndata,
470         string memory errorMessage
471     ) internal pure returns (bytes memory) {
472         if (success) {
473             return returndata;
474         } else {
475             // Look for revert reason and bubble it up if present
476             if (returndata.length > 0) {
477                 // The easiest way to bubble the revert reason is using memory via assembly
478 
479                 assembly {
480                     let returndata_size := mload(returndata)
481                     revert(add(32, returndata), returndata_size)
482                 }
483             } else {
484                 revert(errorMessage);
485             }
486         }
487     }
488 }
489 
490 // File: @openzeppelin/contracts/security/ReentrancyGuard.sol
491 
492 
493 // OpenZeppelin Contracts v4.4.1 (security/ReentrancyGuard.sol)
494 
495 pragma solidity ^0.8.0;
496 
497 /**
498  * @dev Contract module that helps prevent reentrant calls to a function.
499  *
500  * Inheriting from `ReentrancyGuard` will make the {nonReentrant} modifier
501  * available, which can be applied to functions to make sure there are no nested
502  * (reentrant) calls to them.
503  *
504  * Note that because there is a single `nonReentrant` guard, functions marked as
505  * `nonReentrant` may not call one another. This can be worked around by making
506  * those functions `private`, and then adding `external` `nonReentrant` entry
507  * points to them.
508  *
509  * TIP: If you would like to learn more about reentrancy and alternative ways
510  * to protect against it, check out our blog post
511  * https://blog.openzeppelin.com/reentrancy-after-istanbul/[Reentrancy After Istanbul].
512  */
513 abstract contract ReentrancyGuard {
514     // Booleans are more expensive than uint256 or any type that takes up a full
515     // word because each write operation emits an extra SLOAD to first read the
516     // slot's contents, replace the bits taken up by the boolean, and then write
517     // back. This is the compiler's defense against contract upgrades and
518     // pointer aliasing, and it cannot be disabled.
519 
520     // The values being non-zero value makes deployment a bit more expensive,
521     // but in exchange the refund on every call to nonReentrant will be lower in
522     // amount. Since refunds are capped to a percentage of the total
523     // transaction's gas, it is best to keep them low in cases like this one, to
524     // increase the likelihood of the full refund coming into effect.
525     uint256 private constant _NOT_ENTERED = 1;
526     uint256 private constant _ENTERED = 2;
527 
528     uint256 private _status;
529 
530     constructor() {
531         _status = _NOT_ENTERED;
532     }
533 
534     /**
535      * @dev Prevents a contract from calling itself, directly or indirectly.
536      * Calling a `nonReentrant` function from another `nonReentrant`
537      * function is not supported. It is possible to prevent this from happening
538      * by making the `nonReentrant` function external, and making it call a
539      * `private` function that does the actual work.
540      */
541     modifier nonReentrant() {
542         // On the first call to nonReentrant, _notEntered will be true
543         require(_status != _ENTERED, "ReentrancyGuard: reentrant call");
544 
545         // Any calls to nonReentrant after this point will fail
546         _status = _ENTERED;
547 
548         _;
549 
550         // By storing the original value once again, a refund is triggered (see
551         // https://eips.ethereum.org/EIPS/eip-2200)
552         _status = _NOT_ENTERED;
553     }
554 }
555 
556 // File: @openzeppelin/contracts/utils/Strings.sol
557 
558 
559 // OpenZeppelin Contracts v4.4.1 (utils/Strings.sol)
560 
561 pragma solidity ^0.8.0;
562 
563 /**
564  * @dev String operations.
565  */
566 library Strings {
567     bytes16 private constant _HEX_SYMBOLS = "0123456789abcdef";
568 
569     /**
570      * @dev Converts a `uint256` to its ASCII `string` decimal representation.
571      */
572     function toString(uint256 value) internal pure returns (string memory) {
573         // Inspired by OraclizeAPI's implementation - MIT licence
574         // https://github.com/oraclize/ethereum-api/blob/b42146b063c7d6ee1358846c198246239e9360e8/oraclizeAPI_0.4.25.sol
575 
576         if (value == 0) {
577             return "0";
578         }
579         uint256 temp = value;
580         uint256 digits;
581         while (temp != 0) {
582             digits++;
583             temp /= 10;
584         }
585         bytes memory buffer = new bytes(digits);
586         while (value != 0) {
587             digits -= 1;
588             buffer[digits] = bytes1(uint8(48 + uint256(value % 10)));
589             value /= 10;
590         }
591         return string(buffer);
592     }
593 
594     /**
595      * @dev Converts a `uint256` to its ASCII `string` hexadecimal representation.
596      */
597     function toHexString(uint256 value) internal pure returns (string memory) {
598         if (value == 0) {
599             return "0x00";
600         }
601         uint256 temp = value;
602         uint256 length = 0;
603         while (temp != 0) {
604             length++;
605             temp >>= 8;
606         }
607         return toHexString(value, length);
608     }
609 
610     /**
611      * @dev Converts a `uint256` to its ASCII `string` hexadecimal representation with fixed length.
612      */
613     function toHexString(uint256 value, uint256 length) internal pure returns (string memory) {
614         bytes memory buffer = new bytes(2 * length + 2);
615         buffer[0] = "0";
616         buffer[1] = "x";
617         for (uint256 i = 2 * length + 1; i > 1; --i) {
618             buffer[i] = _HEX_SYMBOLS[value & 0xf];
619             value >>= 4;
620         }
621         require(value == 0, "Strings: hex length insufficient");
622         return string(buffer);
623     }
624 }
625 
626 // File: @openzeppelin/contracts/utils/Context.sol
627 
628 
629 // OpenZeppelin Contracts v4.4.1 (utils/Context.sol)
630 
631 pragma solidity ^0.8.0;
632 
633 /**
634  * @dev Provides information about the current execution context, including the
635  * sender of the transaction and its data. While these are generally available
636  * via msg.sender and msg.data, they should not be accessed in such a direct
637  * manner, since when dealing with meta-transactions the account sending and
638  * paying for execution may not be the actual sender (as far as an application
639  * is concerned).
640  *
641  * This contract is only required for intermediate, library-like contracts.
642  */
643 abstract contract Context {
644     function _msgSender() internal view virtual returns (address) {
645         return msg.sender;
646     }
647 
648     function _msgData() internal view virtual returns (bytes calldata) {
649         return msg.data;
650     }
651 }
652 
653 // File: @openzeppelin/contracts/access/Ownable.sol
654 
655 
656 // OpenZeppelin Contracts v4.4.1 (access/Ownable.sol)
657 
658 pragma solidity ^0.8.0;
659 
660 
661 /**
662  * @dev Contract module which provides a basic access control mechanism, where
663  * there is an account (an owner) that can be granted exclusive access to
664  * specific functions.
665  *
666  * By default, the owner account will be the one that deploys the contract. This
667  * can later be changed with {transferOwnership}.
668  *
669  * This module is used through inheritance. It will make available the modifier
670  * `onlyOwner`, which can be applied to your functions to restrict their use to
671  * the owner.
672  */
673 abstract contract Ownable is Context {
674     address private _owner;
675 
676     event OwnershipTransferred(address indexed previousOwner, address indexed newOwner);
677 
678     /**
679      * @dev Initializes the contract setting the deployer as the initial owner.
680      */
681     constructor() {
682         _transferOwnership(_msgSender());
683     }
684 
685     /**
686      * @dev Returns the address of the current owner.
687      */
688     function owner() public view virtual returns (address) {
689         return _owner;
690     }
691 
692     /**
693      * @dev Throws if called by any account other than the owner.
694      */
695     modifier onlyOwner() {
696         require(owner() == _msgSender(), "Ownable: caller is not the owner");
697         _;
698     }
699 
700     /**
701      * @dev Leaves the contract without owner. It will not be possible to call
702      * `onlyOwner` functions anymore. Can only be called by the current owner.
703      *
704      * NOTE: Renouncing ownership will leave the contract without an owner,
705      * thereby removing any functionality that is only available to the owner.
706      */
707     function renounceOwnership() public virtual onlyOwner {
708         _transferOwnership(address(0));
709     }
710 
711     /**
712      * @dev Transfers ownership of the contract to a new account (`newOwner`).
713      * Can only be called by the current owner.
714      */
715     function transferOwnership(address newOwner) public virtual onlyOwner {
716         require(newOwner != address(0), "Ownable: new owner is the zero address");
717         _transferOwnership(newOwner);
718     }
719 
720     /**
721      * @dev Transfers ownership of the contract to a new account (`newOwner`).
722      * Internal function without access restriction.
723      */
724     function _transferOwnership(address newOwner) internal virtual {
725         address oldOwner = _owner;
726         _owner = newOwner;
727         emit OwnershipTransferred(oldOwner, newOwner);
728     }
729 }
730 
731 // File: erc721a/contracts/IERC721A.sol
732 
733 
734 // ERC721A Contracts v4.0.0
735 // Creator: Chiru Labs
736 
737 pragma solidity ^0.8.4;
738 
739 /**
740  * @dev Interface of an ERC721A compliant contract.
741  */
742 interface IERC721A {
743     /**
744      * The caller must own the token or be an approved operator.
745      */
746     error ApprovalCallerNotOwnerNorApproved();
747 
748     /**
749      * The token does not exist.
750      */
751     error ApprovalQueryForNonexistentToken();
752 
753     /**
754      * The caller cannot approve to their own address.
755      */
756     error ApproveToCaller();
757 
758     /**
759      * The caller cannot approve to the current owner.
760      */
761     error ApprovalToCurrentOwner();
762 
763     /**
764      * Cannot query the balance for the zero address.
765      */
766     error BalanceQueryForZeroAddress();
767 
768     /**
769      * Cannot mint to the zero address.
770      */
771     error MintToZeroAddress();
772 
773     /**
774      * The quantity of tokens minted must be more than zero.
775      */
776     error MintZeroQuantity();
777 
778     /**
779      * The token does not exist.
780      */
781     error OwnerQueryForNonexistentToken();
782 
783     /**
784      * The caller must own the token or be an approved operator.
785      */
786     error TransferCallerNotOwnerNorApproved();
787 
788     /**
789      * The token must be owned by `from`.
790      */
791     error TransferFromIncorrectOwner();
792 
793     /**
794      * Cannot safely transfer to a contract that does not implement the ERC721Receiver interface.
795      */
796     error TransferToNonERC721ReceiverImplementer();
797 
798     /**
799      * Cannot transfer to the zero address.
800      */
801     error TransferToZeroAddress();
802 
803     /**
804      * The token does not exist.
805      */
806     error URIQueryForNonexistentToken();
807 
808     struct TokenOwnership {
809         // The address of the owner.
810         address addr;
811         // Keeps track of the start time of ownership with minimal overhead for tokenomics.
812         uint64 startTimestamp;
813         // Whether the token has been burned.
814         bool burned;
815     }
816 
817     /**
818      * @dev Returns the total amount of tokens stored by the contract.
819      *
820      * Burned tokens are calculated here, use `_totalMinted()` if you want to count just minted tokens.
821      */
822     function totalSupply() external view returns (uint256);
823 
824     // ==============================
825     //            IERC165
826     // ==============================
827 
828     /**
829      * @dev Returns true if this contract implements the interface defined by
830      * `interfaceId`. See the corresponding
831      * https://eips.ethereum.org/EIPS/eip-165#how-interfaces-are-identified[EIP section]
832      * to learn more about how these ids are created.
833      *
834      * This function call must use less than 30 000 gas.
835      */
836     function supportsInterface(bytes4 interfaceId) external view returns (bool);
837 
838     // ==============================
839     //            IERC721
840     // ==============================
841 
842     /**
843      * @dev Emitted when `tokenId` token is transferred from `from` to `to`.
844      */
845     event Transfer(address indexed from, address indexed to, uint256 indexed tokenId);
846 
847     /**
848      * @dev Emitted when `owner` enables `approved` to manage the `tokenId` token.
849      */
850     event Approval(address indexed owner, address indexed approved, uint256 indexed tokenId);
851 
852     /**
853      * @dev Emitted when `owner` enables or disables (`approved`) `operator` to manage all of its assets.
854      */
855     event ApprovalForAll(address indexed owner, address indexed operator, bool approved);
856 
857     /**
858      * @dev Returns the number of tokens in ``owner``'s account.
859      */
860     function balanceOf(address owner) external view returns (uint256 balance);
861 
862     /**
863      * @dev Returns the owner of the `tokenId` token.
864      *
865      * Requirements:
866      *
867      * - `tokenId` must exist.
868      */
869     function ownerOf(uint256 tokenId) external view returns (address owner);
870 
871     /**
872      * @dev Safely transfers `tokenId` token from `from` to `to`.
873      *
874      * Requirements:
875      *
876      * - `from` cannot be the zero address.
877      * - `to` cannot be the zero address.
878      * - `tokenId` token must exist and be owned by `from`.
879      * - If the caller is not `from`, it must be approved to move this token by either {approve} or {setApprovalForAll}.
880      * - If `to` refers to a smart contract, it must implement {IERC721Receiver-onERC721Received}, which is called upon a safe transfer.
881      *
882      * Emits a {Transfer} event.
883      */
884     function safeTransferFrom(
885         address from,
886         address to,
887         uint256 tokenId,
888         bytes calldata data
889     ) external;
890 
891     /**
892      * @dev Safely transfers `tokenId` token from `from` to `to`, checking first that contract recipients
893      * are aware of the ERC721 protocol to prevent tokens from being forever locked.
894      *
895      * Requirements:
896      *
897      * - `from` cannot be the zero address.
898      * - `to` cannot be the zero address.
899      * - `tokenId` token must exist and be owned by `from`.
900      * - If the caller is not `from`, it must be have been allowed to move this token by either {approve} or {setApprovalForAll}.
901      * - If `to` refers to a smart contract, it must implement {IERC721Receiver-onERC721Received}, which is called upon a safe transfer.
902      *
903      * Emits a {Transfer} event.
904      */
905     function safeTransferFrom(
906         address from,
907         address to,
908         uint256 tokenId
909     ) external;
910 
911     /**
912      * @dev Transfers `tokenId` token from `from` to `to`.
913      *
914      * WARNING: Usage of this method is discouraged, use {safeTransferFrom} whenever possible.
915      *
916      * Requirements:
917      *
918      * - `from` cannot be the zero address.
919      * - `to` cannot be the zero address.
920      * - `tokenId` token must be owned by `from`.
921      * - If the caller is not `from`, it must be approved to move this token by either {approve} or {setApprovalForAll}.
922      *
923      * Emits a {Transfer} event.
924      */
925     function transferFrom(
926         address from,
927         address to,
928         uint256 tokenId
929     ) external;
930 
931     /**
932      * @dev Gives permission to `to` to transfer `tokenId` token to another account.
933      * The approval is cleared when the token is transferred.
934      *
935      * Only a single account can be approved at a time, so approving the zero address clears previous approvals.
936      *
937      * Requirements:
938      *
939      * - The caller must own the token or be an approved operator.
940      * - `tokenId` must exist.
941      *
942      * Emits an {Approval} event.
943      */
944     function approve(address to, uint256 tokenId) external;
945 
946     /**
947      * @dev Approve or remove `operator` as an operator for the caller.
948      * Operators can call {transferFrom} or {safeTransferFrom} for any token owned by the caller.
949      *
950      * Requirements:
951      *
952      * - The `operator` cannot be the caller.
953      *
954      * Emits an {ApprovalForAll} event.
955      */
956     function setApprovalForAll(address operator, bool _approved) external;
957 
958     /**
959      * @dev Returns the account approved for `tokenId` token.
960      *
961      * Requirements:
962      *
963      * - `tokenId` must exist.
964      */
965     function getApproved(uint256 tokenId) external view returns (address operator);
966 
967     /**
968      * @dev Returns if the `operator` is allowed to manage all of the assets of `owner`.
969      *
970      * See {setApprovalForAll}
971      */
972     function isApprovedForAll(address owner, address operator) external view returns (bool);
973 
974     // ==============================
975     //        IERC721Metadata
976     // ==============================
977 
978     /**
979      * @dev Returns the token collection name.
980      */
981     function name() external view returns (string memory);
982 
983     /**
984      * @dev Returns the token collection symbol.
985      */
986     function symbol() external view returns (string memory);
987 
988     /**
989      * @dev Returns the Uniform Resource Identifier (URI) for `tokenId` token.
990      */
991     function tokenURI(uint256 tokenId) external view returns (string memory);
992 }
993 
994 // File: erc721a/contracts/ERC721A.sol
995 
996 
997 // ERC721A Contracts v4.0.0
998 // Creator: Chiru Labs
999 
1000 pragma solidity ^0.8.4;
1001 
1002 
1003 /**
1004  * @dev ERC721 token receiver interface.
1005  */
1006 interface ERC721A__IERC721Receiver {
1007     function onERC721Received(
1008         address operator,
1009         address from,
1010         uint256 tokenId,
1011         bytes calldata data
1012     ) external returns (bytes4);
1013 }
1014 
1015 /**
1016  * @dev Implementation of https://eips.ethereum.org/EIPS/eip-721[ERC721] Non-Fungible Token Standard, including
1017  * the Metadata extension. Built to optimize for lower gas during batch mints.
1018  *
1019  * Assumes serials are sequentially minted starting at _startTokenId() (defaults to 0, e.g. 0, 1, 2, 3..).
1020  *
1021  * Assumes that an owner cannot have more than 2**64 - 1 (max value of uint64) of supply.
1022  *
1023  * Assumes that the maximum token id cannot exceed 2**256 - 1 (max value of uint256).
1024  */
1025 contract ERC721A is IERC721A {
1026     // Mask of an entry in packed address data.
1027     uint256 private constant BITMASK_ADDRESS_DATA_ENTRY = (1 << 64) - 1;
1028 
1029     // The bit position of `numberMinted` in packed address data.
1030     uint256 private constant BITPOS_NUMBER_MINTED = 64;
1031 
1032     // The bit position of `numberBurned` in packed address data.
1033     uint256 private constant BITPOS_NUMBER_BURNED = 128;
1034 
1035     // The bit position of `aux` in packed address data.
1036     uint256 private constant BITPOS_AUX = 192;
1037 
1038     // Mask of all 256 bits in packed address data except the 64 bits for `aux`.
1039     uint256 private constant BITMASK_AUX_COMPLEMENT = (1 << 192) - 1;
1040 
1041     // The bit position of `startTimestamp` in packed ownership.
1042     uint256 private constant BITPOS_START_TIMESTAMP = 160;
1043 
1044     // The bit mask of the `burned` bit in packed ownership.
1045     uint256 private constant BITMASK_BURNED = 1 << 224;
1046     
1047     // The bit position of the `nextInitialized` bit in packed ownership.
1048     uint256 private constant BITPOS_NEXT_INITIALIZED = 225;
1049 
1050     // The bit mask of the `nextInitialized` bit in packed ownership.
1051     uint256 private constant BITMASK_NEXT_INITIALIZED = 1 << 225;
1052 
1053     // The tokenId of the next token to be minted.
1054     uint256 private _currentIndex;
1055 
1056     // The number of tokens burned.
1057     uint256 private _burnCounter;
1058 
1059     // Token name
1060     string private _name;
1061 
1062     // Token symbol
1063     string private _symbol;
1064 
1065     // Mapping from token ID to ownership details
1066     // An empty struct value does not necessarily mean the token is unowned.
1067     // See `_packedOwnershipOf` implementation for details.
1068     //
1069     // Bits Layout:
1070     // - [0..159]   `addr`
1071     // - [160..223] `startTimestamp`
1072     // - [224]      `burned`
1073     // - [225]      `nextInitialized`
1074     mapping(uint256 => uint256) private _packedOwnerships;
1075 
1076     // Mapping owner address to address data.
1077     //
1078     // Bits Layout:
1079     // - [0..63]    `balance`
1080     // - [64..127]  `numberMinted`
1081     // - [128..191] `numberBurned`
1082     // - [192..255] `aux`
1083     mapping(address => uint256) private _packedAddressData;
1084 
1085     // Mapping from token ID to approved address.
1086     mapping(uint256 => address) private _tokenApprovals;
1087 
1088     // Mapping from owner to operator approvals
1089     mapping(address => mapping(address => bool)) private _operatorApprovals;
1090 
1091     constructor(string memory name_, string memory symbol_) {
1092         _name = name_;
1093         _symbol = symbol_;
1094         _currentIndex = _startTokenId();
1095     }
1096 
1097     /**
1098      * @dev Returns the starting token ID. 
1099      * To change the starting token ID, please override this function.
1100      */
1101     function _startTokenId() internal view virtual returns (uint256) {
1102         return 0;
1103     }
1104 
1105     /**
1106      * @dev Returns the next token ID to be minted.
1107      */
1108     function _nextTokenId() internal view returns (uint256) {
1109         return _currentIndex;
1110     }
1111 
1112     /**
1113      * @dev Returns the total number of tokens in existence.
1114      * Burned tokens will reduce the count. 
1115      * To get the total number of tokens minted, please see `_totalMinted`.
1116      */
1117     function totalSupply() public view override returns (uint256) {
1118         // Counter underflow is impossible as _burnCounter cannot be incremented
1119         // more than `_currentIndex - _startTokenId()` times.
1120         unchecked {
1121             return _currentIndex - _burnCounter - _startTokenId();
1122         }
1123     }
1124 
1125     /**
1126      * @dev Returns the total amount of tokens minted in the contract.
1127      */
1128     function _totalMinted() internal view returns (uint256) {
1129         // Counter underflow is impossible as _currentIndex does not decrement,
1130         // and it is initialized to `_startTokenId()`
1131         unchecked {
1132             return _currentIndex - _startTokenId();
1133         }
1134     }
1135 
1136     /**
1137      * @dev Returns the total number of tokens burned.
1138      */
1139     function _totalBurned() internal view returns (uint256) {
1140         return _burnCounter;
1141     }
1142 
1143     /**
1144      * @dev See {IERC165-supportsInterface}.
1145      */
1146     function supportsInterface(bytes4 interfaceId) public view virtual override returns (bool) {
1147         // The interface IDs are constants representing the first 4 bytes of the XOR of
1148         // all function selectors in the interface. See: https://eips.ethereum.org/EIPS/eip-165
1149         // e.g. `bytes4(i.functionA.selector ^ i.functionB.selector ^ ...)`
1150         return
1151             interfaceId == 0x01ffc9a7 || // ERC165 interface ID for ERC165.
1152             interfaceId == 0x80ac58cd || // ERC165 interface ID for ERC721.
1153             interfaceId == 0x5b5e139f; // ERC165 interface ID for ERC721Metadata.
1154     }
1155 
1156     /**
1157      * @dev See {IERC721-balanceOf}.
1158      */
1159     function balanceOf(address owner) public view override returns (uint256) {
1160         if (owner == address(0)) revert BalanceQueryForZeroAddress();
1161         return _packedAddressData[owner] & BITMASK_ADDRESS_DATA_ENTRY;
1162     }
1163 
1164     /**
1165      * Returns the number of tokens minted by `owner`.
1166      */
1167     function _numberMinted(address owner) internal view returns (uint256) {
1168         return (_packedAddressData[owner] >> BITPOS_NUMBER_MINTED) & BITMASK_ADDRESS_DATA_ENTRY;
1169     }
1170 
1171     /**
1172      * Returns the number of tokens burned by or on behalf of `owner`.
1173      */
1174     function _numberBurned(address owner) internal view returns (uint256) {
1175         return (_packedAddressData[owner] >> BITPOS_NUMBER_BURNED) & BITMASK_ADDRESS_DATA_ENTRY;
1176     }
1177 
1178     /**
1179      * Returns the auxillary data for `owner`. (e.g. number of whitelist mint slots used).
1180      */
1181     function _getAux(address owner) internal view returns (uint64) {
1182         return uint64(_packedAddressData[owner] >> BITPOS_AUX);
1183     }
1184 
1185     /**
1186      * Sets the auxillary data for `owner`. (e.g. number of whitelist mint slots used).
1187      * If there are multiple variables, please pack them into a uint64.
1188      */
1189     function _setAux(address owner, uint64 aux) internal {
1190         uint256 packed = _packedAddressData[owner];
1191         uint256 auxCasted;
1192         assembly { // Cast aux without masking.
1193             auxCasted := aux
1194         }
1195         packed = (packed & BITMASK_AUX_COMPLEMENT) | (auxCasted << BITPOS_AUX);
1196         _packedAddressData[owner] = packed;
1197     }
1198 
1199     /**
1200      * Returns the packed ownership data of `tokenId`.
1201      */
1202     function _packedOwnershipOf(uint256 tokenId) private view returns (uint256) {
1203         uint256 curr = tokenId;
1204 
1205         unchecked {
1206             if (_startTokenId() <= curr)
1207                 if (curr < _currentIndex) {
1208                     uint256 packed = _packedOwnerships[curr];
1209                     // If not burned.
1210                     if (packed & BITMASK_BURNED == 0) {
1211                         // Invariant:
1212                         // There will always be an ownership that has an address and is not burned
1213                         // before an ownership that does not have an address and is not burned.
1214                         // Hence, curr will not underflow.
1215                         //
1216                         // We can directly compare the packed value.
1217                         // If the address is zero, packed is zero.
1218                         while (packed == 0) {
1219                             packed = _packedOwnerships[--curr];
1220                         }
1221                         return packed;
1222                     }
1223                 }
1224         }
1225         revert OwnerQueryForNonexistentToken();
1226     }
1227 
1228     /**
1229      * Returns the unpacked `TokenOwnership` struct from `packed`.
1230      */
1231     function _unpackedOwnership(uint256 packed) private pure returns (TokenOwnership memory ownership) {
1232         ownership.addr = address(uint160(packed));
1233         ownership.startTimestamp = uint64(packed >> BITPOS_START_TIMESTAMP);
1234         ownership.burned = packed & BITMASK_BURNED != 0;
1235     }
1236 
1237     /**
1238      * Returns the unpacked `TokenOwnership` struct at `index`.
1239      */
1240     function _ownershipAt(uint256 index) internal view returns (TokenOwnership memory) {
1241         return _unpackedOwnership(_packedOwnerships[index]);
1242     }
1243 
1244     /**
1245      * @dev Initializes the ownership slot minted at `index` for efficiency purposes.
1246      */
1247     function _initializeOwnershipAt(uint256 index) internal {
1248         if (_packedOwnerships[index] == 0) {
1249             _packedOwnerships[index] = _packedOwnershipOf(index);
1250         }
1251     }
1252 
1253     /**
1254      * Gas spent here starts off proportional to the maximum mint batch size.
1255      * It gradually moves to O(1) as tokens get transferred around in the collection over time.
1256      */
1257     function _ownershipOf(uint256 tokenId) internal view returns (TokenOwnership memory) {
1258         return _unpackedOwnership(_packedOwnershipOf(tokenId));
1259     }
1260 
1261     /**
1262      * @dev See {IERC721-ownerOf}.
1263      */
1264     function ownerOf(uint256 tokenId) public view override returns (address) {
1265         return address(uint160(_packedOwnershipOf(tokenId)));
1266     }
1267 
1268     /**
1269      * @dev See {IERC721Metadata-name}.
1270      */
1271     function name() public view virtual override returns (string memory) {
1272         return _name;
1273     }
1274 
1275     /**
1276      * @dev See {IERC721Metadata-symbol}.
1277      */
1278     function symbol() public view virtual override returns (string memory) {
1279         return _symbol;
1280     }
1281 
1282     /**
1283      * @dev See {IERC721Metadata-tokenURI}.
1284      */
1285     function tokenURI(uint256 tokenId) public view virtual override returns (string memory) {
1286         if (!_exists(tokenId)) revert URIQueryForNonexistentToken();
1287 
1288         string memory baseURI = _baseURI();
1289         return bytes(baseURI).length != 0 ? string(abi.encodePacked(baseURI, _toString(tokenId))) : '';
1290     }
1291 
1292     /**
1293      * @dev Base URI for computing {tokenURI}. If set, the resulting URI for each
1294      * token will be the concatenation of the `baseURI` and the `tokenId`. Empty
1295      * by default, can be overriden in child contracts.
1296      */
1297     function _baseURI() internal view virtual returns (string memory) {
1298         return '';
1299     }
1300 
1301     /**
1302      * @dev Casts the address to uint256 without masking.
1303      */
1304     function _addressToUint256(address value) private pure returns (uint256 result) {
1305         assembly {
1306             result := value
1307         }
1308     }
1309 
1310     /**
1311      * @dev Casts the boolean to uint256 without branching.
1312      */
1313     function _boolToUint256(bool value) private pure returns (uint256 result) {
1314         assembly {
1315             result := value
1316         }
1317     }
1318 
1319     /**
1320      * @dev See {IERC721-approve}.
1321      */
1322     function approve(address to, uint256 tokenId) public override {
1323         address owner = address(uint160(_packedOwnershipOf(tokenId)));
1324         if (to == owner) revert ApprovalToCurrentOwner();
1325 
1326         if (_msgSenderERC721A() != owner)
1327             if (!isApprovedForAll(owner, _msgSenderERC721A())) {
1328                 revert ApprovalCallerNotOwnerNorApproved();
1329             }
1330 
1331         _tokenApprovals[tokenId] = to;
1332         emit Approval(owner, to, tokenId);
1333     }
1334 
1335     /**
1336      * @dev See {IERC721-getApproved}.
1337      */
1338     function getApproved(uint256 tokenId) public view override returns (address) {
1339         if (!_exists(tokenId)) revert ApprovalQueryForNonexistentToken();
1340 
1341         return _tokenApprovals[tokenId];
1342     }
1343 
1344     /**
1345      * @dev See {IERC721-setApprovalForAll}.
1346      */
1347     function setApprovalForAll(address operator, bool approved) public virtual override {
1348         if (operator == _msgSenderERC721A()) revert ApproveToCaller();
1349 
1350         _operatorApprovals[_msgSenderERC721A()][operator] = approved;
1351         emit ApprovalForAll(_msgSenderERC721A(), operator, approved);
1352     }
1353 
1354     /**
1355      * @dev See {IERC721-isApprovedForAll}.
1356      */
1357     function isApprovedForAll(address owner, address operator) public view virtual override returns (bool) {
1358         return _operatorApprovals[owner][operator];
1359     }
1360 
1361     /**
1362      * @dev See {IERC721-transferFrom}.
1363      */
1364     function transferFrom(
1365         address from,
1366         address to,
1367         uint256 tokenId
1368     ) public virtual override {
1369         _transfer(from, to, tokenId);
1370     }
1371 
1372     /**
1373      * @dev See {IERC721-safeTransferFrom}.
1374      */
1375     function safeTransferFrom(
1376         address from,
1377         address to,
1378         uint256 tokenId
1379     ) public virtual override {
1380         safeTransferFrom(from, to, tokenId, '');
1381     }
1382 
1383     /**
1384      * @dev See {IERC721-safeTransferFrom}.
1385      */
1386     function safeTransferFrom(
1387         address from,
1388         address to,
1389         uint256 tokenId,
1390         bytes memory _data
1391     ) public virtual override {
1392         _transfer(from, to, tokenId);
1393         if (to.code.length != 0)
1394             if (!_checkContractOnERC721Received(from, to, tokenId, _data)) {
1395                 revert TransferToNonERC721ReceiverImplementer();
1396             }
1397     }
1398 
1399     /**
1400      * @dev Returns whether `tokenId` exists.
1401      *
1402      * Tokens can be managed by their owner or approved accounts via {approve} or {setApprovalForAll}.
1403      *
1404      * Tokens start existing when they are minted (`_mint`),
1405      */
1406     function _exists(uint256 tokenId) internal view returns (bool) {
1407         return
1408             _startTokenId() <= tokenId &&
1409             tokenId < _currentIndex && // If within bounds,
1410             _packedOwnerships[tokenId] & BITMASK_BURNED == 0; // and not burned.
1411     }
1412 
1413     /**
1414      * @dev Equivalent to `_safeMint(to, quantity, '')`.
1415      */
1416     function _safeMint(address to, uint256 quantity) internal {
1417         _safeMint(to, quantity, '');
1418     }
1419 
1420     /**
1421      * @dev Safely mints `quantity` tokens and transfers them to `to`.
1422      *
1423      * Requirements:
1424      *
1425      * - If `to` refers to a smart contract, it must implement
1426      *   {IERC721Receiver-onERC721Received}, which is called for each safe transfer.
1427      * - `quantity` must be greater than 0.
1428      *
1429      * Emits a {Transfer} event.
1430      */
1431     function _safeMint(
1432         address to,
1433         uint256 quantity,
1434         bytes memory _data
1435     ) internal {
1436         uint256 startTokenId = _currentIndex;
1437         if (to == address(0)) revert MintToZeroAddress();
1438         if (quantity == 0) revert MintZeroQuantity();
1439 
1440         _beforeTokenTransfers(address(0), to, startTokenId, quantity);
1441 
1442         // Overflows are incredibly unrealistic.
1443         // balance or numberMinted overflow if current value of either + quantity > 1.8e19 (2**64) - 1
1444         // updatedIndex overflows if _currentIndex + quantity > 1.2e77 (2**256) - 1
1445         unchecked {
1446             // Updates:
1447             // - `balance += quantity`.
1448             // - `numberMinted += quantity`.
1449             //
1450             // We can directly add to the balance and number minted.
1451             _packedAddressData[to] += quantity * ((1 << BITPOS_NUMBER_MINTED) | 1);
1452 
1453             // Updates:
1454             // - `address` to the owner.
1455             // - `startTimestamp` to the timestamp of minting.
1456             // - `burned` to `false`.
1457             // - `nextInitialized` to `quantity == 1`.
1458             _packedOwnerships[startTokenId] =
1459                 _addressToUint256(to) |
1460                 (block.timestamp << BITPOS_START_TIMESTAMP) |
1461                 (_boolToUint256(quantity == 1) << BITPOS_NEXT_INITIALIZED);
1462 
1463             uint256 updatedIndex = startTokenId;
1464             uint256 end = updatedIndex + quantity;
1465 
1466             if (to.code.length != 0) {
1467                 do {
1468                     emit Transfer(address(0), to, updatedIndex);
1469                     if (!_checkContractOnERC721Received(address(0), to, updatedIndex++, _data)) {
1470                         revert TransferToNonERC721ReceiverImplementer();
1471                     }
1472                 } while (updatedIndex < end);
1473                 // Reentrancy protection
1474                 if (_currentIndex != startTokenId) revert();
1475             } else {
1476                 do {
1477                     emit Transfer(address(0), to, updatedIndex++);
1478                 } while (updatedIndex < end);
1479             }
1480             _currentIndex = updatedIndex;
1481         }
1482         _afterTokenTransfers(address(0), to, startTokenId, quantity);
1483     }
1484 
1485     /**
1486      * @dev Mints `quantity` tokens and transfers them to `to`.
1487      *
1488      * Requirements:
1489      *
1490      * - `to` cannot be the zero address.
1491      * - `quantity` must be greater than 0.
1492      *
1493      * Emits a {Transfer} event.
1494      */
1495     function _mint(address to, uint256 quantity) internal {
1496         uint256 startTokenId = _currentIndex;
1497         if (to == address(0)) revert MintToZeroAddress();
1498         if (quantity == 0) revert MintZeroQuantity();
1499 
1500         _beforeTokenTransfers(address(0), to, startTokenId, quantity);
1501 
1502         // Overflows are incredibly unrealistic.
1503         // balance or numberMinted overflow if current value of either + quantity > 1.8e19 (2**64) - 1
1504         // updatedIndex overflows if _currentIndex + quantity > 1.2e77 (2**256) - 1
1505         unchecked {
1506             // Updates:
1507             // - `balance += quantity`.
1508             // - `numberMinted += quantity`.
1509             //
1510             // We can directly add to the balance and number minted.
1511             _packedAddressData[to] += quantity * ((1 << BITPOS_NUMBER_MINTED) | 1);
1512 
1513             // Updates:
1514             // - `address` to the owner.
1515             // - `startTimestamp` to the timestamp of minting.
1516             // - `burned` to `false`.
1517             // - `nextInitialized` to `quantity == 1`.
1518             _packedOwnerships[startTokenId] =
1519                 _addressToUint256(to) |
1520                 (block.timestamp << BITPOS_START_TIMESTAMP) |
1521                 (_boolToUint256(quantity == 1) << BITPOS_NEXT_INITIALIZED);
1522 
1523             uint256 updatedIndex = startTokenId;
1524             uint256 end = updatedIndex + quantity;
1525 
1526             do {
1527                 emit Transfer(address(0), to, updatedIndex++);
1528             } while (updatedIndex < end);
1529 
1530             _currentIndex = updatedIndex;
1531         }
1532         _afterTokenTransfers(address(0), to, startTokenId, quantity);
1533     }
1534 
1535     /**
1536      * @dev Transfers `tokenId` from `from` to `to`.
1537      *
1538      * Requirements:
1539      *
1540      * - `to` cannot be the zero address.
1541      * - `tokenId` token must be owned by `from`.
1542      *
1543      * Emits a {Transfer} event.
1544      */
1545     function _transfer(
1546         address from,
1547         address to,
1548         uint256 tokenId
1549     ) private {
1550         uint256 prevOwnershipPacked = _packedOwnershipOf(tokenId);
1551 
1552         if (address(uint160(prevOwnershipPacked)) != from) revert TransferFromIncorrectOwner();
1553 
1554         bool isApprovedOrOwner = (_msgSenderERC721A() == from ||
1555             isApprovedForAll(from, _msgSenderERC721A()) ||
1556             getApproved(tokenId) == _msgSenderERC721A());
1557 
1558         if (!isApprovedOrOwner) revert TransferCallerNotOwnerNorApproved();
1559         if (to == address(0)) revert TransferToZeroAddress();
1560 
1561         _beforeTokenTransfers(from, to, tokenId, 1);
1562 
1563         // Clear approvals from the previous owner.
1564         delete _tokenApprovals[tokenId];
1565 
1566         // Underflow of the sender's balance is impossible because we check for
1567         // ownership above and the recipient's balance can't realistically overflow.
1568         // Counter overflow is incredibly unrealistic as tokenId would have to be 2**256.
1569         unchecked {
1570             // We can directly increment and decrement the balances.
1571             --_packedAddressData[from]; // Updates: `balance -= 1`.
1572             ++_packedAddressData[to]; // Updates: `balance += 1`.
1573 
1574             // Updates:
1575             // - `address` to the next owner.
1576             // - `startTimestamp` to the timestamp of transfering.
1577             // - `burned` to `false`.
1578             // - `nextInitialized` to `true`.
1579             _packedOwnerships[tokenId] =
1580                 _addressToUint256(to) |
1581                 (block.timestamp << BITPOS_START_TIMESTAMP) |
1582                 BITMASK_NEXT_INITIALIZED;
1583 
1584             // If the next slot may not have been initialized (i.e. `nextInitialized == false`) .
1585             if (prevOwnershipPacked & BITMASK_NEXT_INITIALIZED == 0) {
1586                 uint256 nextTokenId = tokenId + 1;
1587                 // If the next slot's address is zero and not burned (i.e. packed value is zero).
1588                 if (_packedOwnerships[nextTokenId] == 0) {
1589                     // If the next slot is within bounds.
1590                     if (nextTokenId != _currentIndex) {
1591                         // Initialize the next slot to maintain correctness for `ownerOf(tokenId + 1)`.
1592                         _packedOwnerships[nextTokenId] = prevOwnershipPacked;
1593                     }
1594                 }
1595             }
1596         }
1597 
1598         emit Transfer(from, to, tokenId);
1599         _afterTokenTransfers(from, to, tokenId, 1);
1600     }
1601 
1602     /**
1603      * @dev Equivalent to `_burn(tokenId, false)`.
1604      */
1605     function _burn(uint256 tokenId) internal virtual {
1606         _burn(tokenId, false);
1607     }
1608 
1609     /**
1610      * @dev Destroys `tokenId`.
1611      * The approval is cleared when the token is burned.
1612      *
1613      * Requirements:
1614      *
1615      * - `tokenId` must exist.
1616      *
1617      * Emits a {Transfer} event.
1618      */
1619     function _burn(uint256 tokenId, bool approvalCheck) internal virtual {
1620         uint256 prevOwnershipPacked = _packedOwnershipOf(tokenId);
1621 
1622         address from = address(uint160(prevOwnershipPacked));
1623 
1624         if (approvalCheck) {
1625             bool isApprovedOrOwner = (_msgSenderERC721A() == from ||
1626                 isApprovedForAll(from, _msgSenderERC721A()) ||
1627                 getApproved(tokenId) == _msgSenderERC721A());
1628 
1629             if (!isApprovedOrOwner) revert TransferCallerNotOwnerNorApproved();
1630         }
1631 
1632         _beforeTokenTransfers(from, address(0), tokenId, 1);
1633 
1634         // Clear approvals from the previous owner.
1635         delete _tokenApprovals[tokenId];
1636 
1637         // Underflow of the sender's balance is impossible because we check for
1638         // ownership above and the recipient's balance can't realistically overflow.
1639         // Counter overflow is incredibly unrealistic as tokenId would have to be 2**256.
1640         unchecked {
1641             // Updates:
1642             // - `balance -= 1`.
1643             // - `numberBurned += 1`.
1644             //
1645             // We can directly decrement the balance, and increment the number burned.
1646             // This is equivalent to `packed -= 1; packed += 1 << BITPOS_NUMBER_BURNED;`.
1647             _packedAddressData[from] += (1 << BITPOS_NUMBER_BURNED) - 1;
1648 
1649             // Updates:
1650             // - `address` to the last owner.
1651             // - `startTimestamp` to the timestamp of burning.
1652             // - `burned` to `true`.
1653             // - `nextInitialized` to `true`.
1654             _packedOwnerships[tokenId] =
1655                 _addressToUint256(from) |
1656                 (block.timestamp << BITPOS_START_TIMESTAMP) |
1657                 BITMASK_BURNED | 
1658                 BITMASK_NEXT_INITIALIZED;
1659 
1660             // If the next slot may not have been initialized (i.e. `nextInitialized == false`) .
1661             if (prevOwnershipPacked & BITMASK_NEXT_INITIALIZED == 0) {
1662                 uint256 nextTokenId = tokenId + 1;
1663                 // If the next slot's address is zero and not burned (i.e. packed value is zero).
1664                 if (_packedOwnerships[nextTokenId] == 0) {
1665                     // If the next slot is within bounds.
1666                     if (nextTokenId != _currentIndex) {
1667                         // Initialize the next slot to maintain correctness for `ownerOf(tokenId + 1)`.
1668                         _packedOwnerships[nextTokenId] = prevOwnershipPacked;
1669                     }
1670                 }
1671             }
1672         }
1673 
1674         emit Transfer(from, address(0), tokenId);
1675         _afterTokenTransfers(from, address(0), tokenId, 1);
1676 
1677         // Overflow not possible, as _burnCounter cannot be exceed _currentIndex times.
1678         unchecked {
1679             _burnCounter++;
1680         }
1681     }
1682 
1683     /**
1684      * @dev Internal function to invoke {IERC721Receiver-onERC721Received} on a target contract.
1685      *
1686      * @param from address representing the previous owner of the given token ID
1687      * @param to target address that will receive the tokens
1688      * @param tokenId uint256 ID of the token to be transferred
1689      * @param _data bytes optional data to send along with the call
1690      * @return bool whether the call correctly returned the expected magic value
1691      */
1692     function _checkContractOnERC721Received(
1693         address from,
1694         address to,
1695         uint256 tokenId,
1696         bytes memory _data
1697     ) private returns (bool) {
1698         try ERC721A__IERC721Receiver(to).onERC721Received(_msgSenderERC721A(), from, tokenId, _data) returns (
1699             bytes4 retval
1700         ) {
1701             return retval == ERC721A__IERC721Receiver(to).onERC721Received.selector;
1702         } catch (bytes memory reason) {
1703             if (reason.length == 0) {
1704                 revert TransferToNonERC721ReceiverImplementer();
1705             } else {
1706                 assembly {
1707                     revert(add(32, reason), mload(reason))
1708                 }
1709             }
1710         }
1711     }
1712 
1713     /**
1714      * @dev Hook that is called before a set of serially-ordered token ids are about to be transferred. This includes minting.
1715      * And also called before burning one token.
1716      *
1717      * startTokenId - the first token id to be transferred
1718      * quantity - the amount to be transferred
1719      *
1720      * Calling conditions:
1721      *
1722      * - When `from` and `to` are both non-zero, `from`'s `tokenId` will be
1723      * transferred to `to`.
1724      * - When `from` is zero, `tokenId` will be minted for `to`.
1725      * - When `to` is zero, `tokenId` will be burned by `from`.
1726      * - `from` and `to` are never both zero.
1727      */
1728     function _beforeTokenTransfers(
1729         address from,
1730         address to,
1731         uint256 startTokenId,
1732         uint256 quantity
1733     ) internal virtual {}
1734 
1735     /**
1736      * @dev Hook that is called after a set of serially-ordered token ids have been transferred. This includes
1737      * minting.
1738      * And also called after one token has been burned.
1739      *
1740      * startTokenId - the first token id to be transferred
1741      * quantity - the amount to be transferred
1742      *
1743      * Calling conditions:
1744      *
1745      * - When `from` and `to` are both non-zero, `from`'s `tokenId` has been
1746      * transferred to `to`.
1747      * - When `from` is zero, `tokenId` has been minted for `to`.
1748      * - When `to` is zero, `tokenId` has been burned by `from`.
1749      * - `from` and `to` are never both zero.
1750      */
1751     function _afterTokenTransfers(
1752         address from,
1753         address to,
1754         uint256 startTokenId,
1755         uint256 quantity
1756     ) internal virtual {}
1757 
1758     /**
1759      * @dev Returns the message sender (defaults to `msg.sender`).
1760      *
1761      * If you are writing GSN compatible contracts, you need to override this function.
1762      */
1763     function _msgSenderERC721A() internal view virtual returns (address) {
1764         return msg.sender;
1765     }
1766 
1767     /**
1768      * @dev Converts a `uint256` to its ASCII `string` decimal representation.
1769      */
1770     function _toString(uint256 value) internal pure returns (string memory ptr) {
1771         assembly {
1772             // The maximum value of a uint256 contains 78 digits (1 byte per digit), 
1773             // but we allocate 128 bytes to keep the free memory pointer 32-byte word aliged.
1774             // We will need 1 32-byte word to store the length, 
1775             // and 3 32-byte words to store a maximum of 78 digits. Total: 32 + 3 * 32 = 128.
1776             ptr := add(mload(0x40), 128)
1777             // Update the free memory pointer to allocate.
1778             mstore(0x40, ptr)
1779 
1780             // Cache the end of the memory to calculate the length later.
1781             let end := ptr
1782 
1783             // We write the string from the rightmost digit to the leftmost digit.
1784             // The following is essentially a do-while loop that also handles the zero case.
1785             // Costs a bit more than early returning for the zero case,
1786             // but cheaper in terms of deployment and overall runtime costs.
1787             for { 
1788                 // Initialize and perform the first pass without check.
1789                 let temp := value
1790                 // Move the pointer 1 byte leftwards to point to an empty character slot.
1791                 ptr := sub(ptr, 1)
1792                 // Write the character to the pointer. 48 is the ASCII index of '0'.
1793                 mstore8(ptr, add(48, mod(temp, 10)))
1794                 temp := div(temp, 10)
1795             } temp { 
1796                 // Keep dividing `temp` until zero.
1797                 temp := div(temp, 10)
1798             } { // Body of the for loop.
1799                 ptr := sub(ptr, 1)
1800                 mstore8(ptr, add(48, mod(temp, 10)))
1801             }
1802             
1803             let length := sub(end, ptr)
1804             // Move the pointer 32 bytes leftwards to make room for the length.
1805             ptr := sub(ptr, 32)
1806             // Store the length.
1807             mstore(ptr, length)
1808         }
1809     }
1810 }
1811 
1812 
1813 // File: contracts/Lardos.sol
1814 
1815 pragma solidity >=0.8.0 <0.9.0;
1816 
1817 contract Lardos is ERC721A, Ownable, ReentrancyGuard {
1818 
1819     using Strings for uint256;
1820     
1821     string public baseURI;
1822     string public notRevealedUri;
1823     string public uriSuffix = ".json";
1824   
1825     uint256 public cost = 0 ether;
1826     uint256 public maxSupply = 3333;
1827     uint256 public MaxperTx = 3;
1828     uint256 public nftPerAddressLimit = 3;
1829 
1830     mapping(address => uint256) public addressMintedBalance;
1831 
1832     bool public paused = false;
1833     bool public revealed = true;
1834 
1835     constructor() ERC721A("Lardos", "LARD") {
1836       setBaseURI("ipfs://QmbcNZ7snejByLMrccUwnL8VLUaL9fpcvod8eNvvZ8Qu8D/");
1837     }
1838 
1839 
1840     // Internal
1841     function _baseURI() internal view virtual override returns (string memory) {
1842       return baseURI;
1843     }
1844 
1845     function _startTokenId() internal view virtual override returns (uint256) {
1846       return 1;
1847     }
1848 
1849 
1850     // Public Mint
1851     function mint(uint256 _amount) external payable {
1852 
1853     address _caller = _msgSender();
1854     uint256 ownerMintedCount = addressMintedBalance[_caller];
1855 
1856     require(!paused, "Contract is paused.");
1857     require(ownerMintedCount + _amount <= nftPerAddressLimit, "Max mints per address limit exceeded.");
1858     require(_amount > 0, "Need to mint at least 1 NFT.");
1859     require(_amount <= MaxperTx, "Exceed max mint per tx.");
1860     require(totalSupply() + _amount <= maxSupply, "Max supply exceeded.");
1861     require(tx.origin == _caller, "Caller can't be another contract.");
1862 
1863     require(_amount * cost >= msg.value, "Invalid funds provided.");
1864 
1865     addressMintedBalance[_caller] += _amount;
1866     _safeMint(_caller, _amount);
1867     }
1868 
1869 
1870     // Only owner mint, used to mint tokens for other wallets
1871     function mintForAddress(uint256 _mintAmount, address _receiver) public onlyOwner {
1872 
1873         require(_mintAmount > 0, "Invalid mint amount!");
1874         require(totalSupply() + _mintAmount <= maxSupply, "Max supply exceeded!");
1875 
1876         addressMintedBalance[_receiver] += _mintAmount;
1877         _safeMint(_receiver, _mintAmount);
1878         }
1879 
1880 
1881     // TokenURI index
1882     function tokenURI(uint256 _tokenId) public view virtual override returns (string memory) {
1883       require(_exists(_tokenId),"ERC721Metadata: URI query for nonexistent token.");
1884     
1885       if (revealed == false) {
1886         return notRevealedUri;
1887       }
1888 
1889       string memory currentBaseURI = _baseURI();
1890       return bytes(currentBaseURI).length > 0
1891         ? string(abi.encodePacked(currentBaseURI, _tokenId.toString(), uriSuffix))
1892         : '';
1893     }
1894 
1895     function walletOfOwner(address _owner) public view returns (uint256[] memory) {
1896       uint256 ownerTokenCount = balanceOf(_owner);
1897       uint256[] memory ownedTokenIds = new uint256[](ownerTokenCount);
1898       uint256 currentTokenId = 1;
1899       uint256 ownedTokenIndex = 0;
1900 
1901       while (ownedTokenIndex < ownerTokenCount && currentTokenId <= maxSupply) {
1902         address currentTokenOwner = ownerOf(currentTokenId);
1903 
1904         if (currentTokenOwner == _owner) {
1905             ownedTokenIds[ownedTokenIndex] = currentTokenId;
1906 
1907             ownedTokenIndex++;
1908         }
1909         currentTokenId++;
1910       }
1911       return ownedTokenIds;
1912     }
1913 
1914     // Set Cost
1915     function setCost(uint256 _cost) public onlyOwner {
1916       cost = _cost;
1917     }
1918 
1919     // Sets the max amount of mints per transaction
1920     function setMaxperTx(uint256 _maxperTx) public onlyOwner {
1921       MaxperTx = _maxperTx;
1922     }
1923 
1924     // Sets the max amount of mints per transaction
1925     function setMaxPerAdd(uint256 _maxPerAddLimit) public onlyOwner {
1926       nftPerAddressLimit = _maxPerAddLimit;
1927     }
1928 
1929     // Returns the baseURI for metadata
1930     function setBaseURI(string memory _newBaseURI) public onlyOwner {
1931       baseURI = _newBaseURI;
1932     }
1933 
1934     // Internal function to set the hidden IPFS metadata
1935     function setNotRevealedUri(string memory _notRevealedUri) public onlyOwner {
1936       notRevealedUri = _notRevealedUri;
1937     }
1938 
1939     // Internal function to change contract revealed, true = revealed
1940     function setReveal(bool _state) public onlyOwner {
1941       revealed = _state;
1942     }
1943 
1944     // Internal function to change contract pause, true = paused
1945     function setPaused(bool _state) public onlyOwner {
1946       paused = _state;
1947     }
1948 
1949     // Do not remove this function or you will not be able to withdraw funds
1950     function withdraw() public onlyOwner nonReentrant {
1951       (bool os, ) = payable(owner()).call{value: address(this).balance}("");
1952       require(os);
1953     }
1954 }