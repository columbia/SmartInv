1 // File: contracts/Tw.sol
2 
3 
4 pragma solidity ^0.8.6;
5 
6 abstract contract Tw {
7     function burnTWForAddress(uint256 typeId, address burnTokenAddress)
8         external
9         virtual;
10 
11     function balanceOf(address account, uint256 id)
12         public
13         view
14         virtual
15         returns (uint256);
16 }
17 // File: @openzeppelin/contracts/utils/Strings.sol
18 
19 
20 // OpenZeppelin Contracts v4.4.1 (utils/Strings.sol)
21 
22 pragma solidity ^0.8.0;
23 
24 /**
25  * @dev String operations.
26  */
27 library Strings {
28     bytes16 private constant _HEX_SYMBOLS = "0123456789abcdef";
29 
30     /**
31      * @dev Converts a `uint256` to its ASCII `string` decimal representation.
32      */
33     function toString(uint256 value) internal pure returns (string memory) {
34         // Inspired by OraclizeAPI's implementation - MIT licence
35         // https://github.com/oraclize/ethereum-api/blob/b42146b063c7d6ee1358846c198246239e9360e8/oraclizeAPI_0.4.25.sol
36 
37         if (value == 0) {
38             return "0";
39         }
40         uint256 temp = value;
41         uint256 digits;
42         while (temp != 0) {
43             digits++;
44             temp /= 10;
45         }
46         bytes memory buffer = new bytes(digits);
47         while (value != 0) {
48             digits -= 1;
49             buffer[digits] = bytes1(uint8(48 + uint256(value % 10)));
50             value /= 10;
51         }
52         return string(buffer);
53     }
54 
55     /**
56      * @dev Converts a `uint256` to its ASCII `string` hexadecimal representation.
57      */
58     function toHexString(uint256 value) internal pure returns (string memory) {
59         if (value == 0) {
60             return "0x00";
61         }
62         uint256 temp = value;
63         uint256 length = 0;
64         while (temp != 0) {
65             length++;
66             temp >>= 8;
67         }
68         return toHexString(value, length);
69     }
70 
71     /**
72      * @dev Converts a `uint256` to its ASCII `string` hexadecimal representation with fixed length.
73      */
74     function toHexString(uint256 value, uint256 length) internal pure returns (string memory) {
75         bytes memory buffer = new bytes(2 * length + 2);
76         buffer[0] = "0";
77         buffer[1] = "x";
78         for (uint256 i = 2 * length + 1; i > 1; --i) {
79             buffer[i] = _HEX_SYMBOLS[value & 0xf];
80             value >>= 4;
81         }
82         require(value == 0, "Strings: hex length insufficient");
83         return string(buffer);
84     }
85 }
86 
87 // File: @openzeppelin/contracts/utils/Address.sol
88 
89 
90 // OpenZeppelin Contracts v4.4.1 (utils/Address.sol)
91 
92 pragma solidity ^0.8.0;
93 
94 /**
95  * @dev Collection of functions related to the address type
96  */
97 library Address {
98     /**
99      * @dev Returns true if `account` is a contract.
100      *
101      * [IMPORTANT]
102      * ====
103      * It is unsafe to assume that an address for which this function returns
104      * false is an externally-owned account (EOA) and not a contract.
105      *
106      * Among others, `isContract` will return false for the following
107      * types of addresses:
108      *
109      *  - an externally-owned account
110      *  - a contract in construction
111      *  - an address where a contract will be created
112      *  - an address where a contract lived, but was destroyed
113      * ====
114      */
115     function isContract(address account) internal view returns (bool) {
116         // This method relies on extcodesize, which returns 0 for contracts in
117         // construction, since the code is only stored at the end of the
118         // constructor execution.
119 
120         uint256 size;
121         assembly {
122             size := extcodesize(account)
123         }
124         return size > 0;
125     }
126 
127     /**
128      * @dev Replacement for Solidity's `transfer`: sends `amount` wei to
129      * `recipient`, forwarding all available gas and reverting on errors.
130      *
131      * https://eips.ethereum.org/EIPS/eip-1884[EIP1884] increases the gas cost
132      * of certain opcodes, possibly making contracts go over the 2300 gas limit
133      * imposed by `transfer`, making them unable to receive funds via
134      * `transfer`. {sendValue} removes this limitation.
135      *
136      * https://diligence.consensys.net/posts/2019/09/stop-using-soliditys-transfer-now/[Learn more].
137      *
138      * IMPORTANT: because control is transferred to `recipient`, care must be
139      * taken to not create reentrancy vulnerabilities. Consider using
140      * {ReentrancyGuard} or the
141      * https://solidity.readthedocs.io/en/v0.5.11/security-considerations.html#use-the-checks-effects-interactions-pattern[checks-effects-interactions pattern].
142      */
143     function sendValue(address payable recipient, uint256 amount) internal {
144         require(address(this).balance >= amount, "Address: insufficient balance");
145 
146         (bool success, ) = recipient.call{value: amount}("");
147         require(success, "Address: unable to send value, recipient may have reverted");
148     }
149 
150     /**
151      * @dev Performs a Solidity function call using a low level `call`. A
152      * plain `call` is an unsafe replacement for a function call: use this
153      * function instead.
154      *
155      * If `target` reverts with a revert reason, it is bubbled up by this
156      * function (like regular Solidity function calls).
157      *
158      * Returns the raw returned data. To convert to the expected return value,
159      * use https://solidity.readthedocs.io/en/latest/units-and-global-variables.html?highlight=abi.decode#abi-encoding-and-decoding-functions[`abi.decode`].
160      *
161      * Requirements:
162      *
163      * - `target` must be a contract.
164      * - calling `target` with `data` must not revert.
165      *
166      * _Available since v3.1._
167      */
168     function functionCall(address target, bytes memory data) internal returns (bytes memory) {
169         return functionCall(target, data, "Address: low-level call failed");
170     }
171 
172     /**
173      * @dev Same as {xref-Address-functionCall-address-bytes-}[`functionCall`], but with
174      * `errorMessage` as a fallback revert reason when `target` reverts.
175      *
176      * _Available since v3.1._
177      */
178     function functionCall(
179         address target,
180         bytes memory data,
181         string memory errorMessage
182     ) internal returns (bytes memory) {
183         return functionCallWithValue(target, data, 0, errorMessage);
184     }
185 
186     /**
187      * @dev Same as {xref-Address-functionCall-address-bytes-}[`functionCall`],
188      * but also transferring `value` wei to `target`.
189      *
190      * Requirements:
191      *
192      * - the calling contract must have an ETH balance of at least `value`.
193      * - the called Solidity function must be `payable`.
194      *
195      * _Available since v3.1._
196      */
197     function functionCallWithValue(
198         address target,
199         bytes memory data,
200         uint256 value
201     ) internal returns (bytes memory) {
202         return functionCallWithValue(target, data, value, "Address: low-level call with value failed");
203     }
204 
205     /**
206      * @dev Same as {xref-Address-functionCallWithValue-address-bytes-uint256-}[`functionCallWithValue`], but
207      * with `errorMessage` as a fallback revert reason when `target` reverts.
208      *
209      * _Available since v3.1._
210      */
211     function functionCallWithValue(
212         address target,
213         bytes memory data,
214         uint256 value,
215         string memory errorMessage
216     ) internal returns (bytes memory) {
217         require(address(this).balance >= value, "Address: insufficient balance for call");
218         require(isContract(target), "Address: call to non-contract");
219 
220         (bool success, bytes memory returndata) = target.call{value: value}(data);
221         return verifyCallResult(success, returndata, errorMessage);
222     }
223 
224     /**
225      * @dev Same as {xref-Address-functionCall-address-bytes-}[`functionCall`],
226      * but performing a static call.
227      *
228      * _Available since v3.3._
229      */
230     function functionStaticCall(address target, bytes memory data) internal view returns (bytes memory) {
231         return functionStaticCall(target, data, "Address: low-level static call failed");
232     }
233 
234     /**
235      * @dev Same as {xref-Address-functionCall-address-bytes-string-}[`functionCall`],
236      * but performing a static call.
237      *
238      * _Available since v3.3._
239      */
240     function functionStaticCall(
241         address target,
242         bytes memory data,
243         string memory errorMessage
244     ) internal view returns (bytes memory) {
245         require(isContract(target), "Address: static call to non-contract");
246 
247         (bool success, bytes memory returndata) = target.staticcall(data);
248         return verifyCallResult(success, returndata, errorMessage);
249     }
250 
251     /**
252      * @dev Same as {xref-Address-functionCall-address-bytes-}[`functionCall`],
253      * but performing a delegate call.
254      *
255      * _Available since v3.4._
256      */
257     function functionDelegateCall(address target, bytes memory data) internal returns (bytes memory) {
258         return functionDelegateCall(target, data, "Address: low-level delegate call failed");
259     }
260 
261     /**
262      * @dev Same as {xref-Address-functionCall-address-bytes-string-}[`functionCall`],
263      * but performing a delegate call.
264      *
265      * _Available since v3.4._
266      */
267     function functionDelegateCall(
268         address target,
269         bytes memory data,
270         string memory errorMessage
271     ) internal returns (bytes memory) {
272         require(isContract(target), "Address: delegate call to non-contract");
273 
274         (bool success, bytes memory returndata) = target.delegatecall(data);
275         return verifyCallResult(success, returndata, errorMessage);
276     }
277 
278     /**
279      * @dev Tool to verifies that a low level call was successful, and revert if it wasn't, either by bubbling the
280      * revert reason using the provided one.
281      *
282      * _Available since v4.3._
283      */
284     function verifyCallResult(
285         bool success,
286         bytes memory returndata,
287         string memory errorMessage
288     ) internal pure returns (bytes memory) {
289         if (success) {
290             return returndata;
291         } else {
292             // Look for revert reason and bubble it up if present
293             if (returndata.length > 0) {
294                 // The easiest way to bubble the revert reason is using memory via assembly
295 
296                 assembly {
297                     let returndata_size := mload(returndata)
298                     revert(add(32, returndata), returndata_size)
299                 }
300             } else {
301                 revert(errorMessage);
302             }
303         }
304     }
305 }
306 
307 // File: @openzeppelin/contracts/token/ERC721/IERC721Receiver.sol
308 
309 
310 // OpenZeppelin Contracts v4.4.1 (token/ERC721/IERC721Receiver.sol)
311 
312 pragma solidity ^0.8.0;
313 
314 /**
315  * @title ERC721 token receiver interface
316  * @dev Interface for any contract that wants to support safeTransfers
317  * from ERC721 asset contracts.
318  */
319 interface IERC721Receiver {
320     /**
321      * @dev Whenever an {IERC721} `tokenId` token is transferred to this contract via {IERC721-safeTransferFrom}
322      * by `operator` from `from`, this function is called.
323      *
324      * It must return its Solidity selector to confirm the token transfer.
325      * If any other value is returned or the interface is not implemented by the recipient, the transfer will be reverted.
326      *
327      * The selector can be obtained in Solidity with `IERC721.onERC721Received.selector`.
328      */
329     function onERC721Received(
330         address operator,
331         address from,
332         uint256 tokenId,
333         bytes calldata data
334     ) external returns (bytes4);
335 }
336 
337 // File: @openzeppelin/contracts/utils/introspection/IERC165.sol
338 
339 
340 // OpenZeppelin Contracts v4.4.1 (utils/introspection/IERC165.sol)
341 
342 pragma solidity ^0.8.0;
343 
344 /**
345  * @dev Interface of the ERC165 standard, as defined in the
346  * https://eips.ethereum.org/EIPS/eip-165[EIP].
347  *
348  * Implementers can declare support of contract interfaces, which can then be
349  * queried by others ({ERC165Checker}).
350  *
351  * For an implementation, see {ERC165}.
352  */
353 interface IERC165 {
354     /**
355      * @dev Returns true if this contract implements the interface defined by
356      * `interfaceId`. See the corresponding
357      * https://eips.ethereum.org/EIPS/eip-165#how-interfaces-are-identified[EIP section]
358      * to learn more about how these ids are created.
359      *
360      * This function call must use less than 30 000 gas.
361      */
362     function supportsInterface(bytes4 interfaceId) external view returns (bool);
363 }
364 
365 // File: @openzeppelin/contracts/utils/introspection/ERC165.sol
366 
367 
368 // OpenZeppelin Contracts v4.4.1 (utils/introspection/ERC165.sol)
369 
370 pragma solidity ^0.8.0;
371 
372 
373 /**
374  * @dev Implementation of the {IERC165} interface.
375  *
376  * Contracts that want to implement ERC165 should inherit from this contract and override {supportsInterface} to check
377  * for the additional interface id that will be supported. For example:
378  *
379  * ```solidity
380  * function supportsInterface(bytes4 interfaceId) public view virtual override returns (bool) {
381  *     return interfaceId == type(MyInterface).interfaceId || super.supportsInterface(interfaceId);
382  * }
383  * ```
384  *
385  * Alternatively, {ERC165Storage} provides an easier to use but more expensive implementation.
386  */
387 abstract contract ERC165 is IERC165 {
388     /**
389      * @dev See {IERC165-supportsInterface}.
390      */
391     function supportsInterface(bytes4 interfaceId) public view virtual override returns (bool) {
392         return interfaceId == type(IERC165).interfaceId;
393     }
394 }
395 
396 // File: @openzeppelin/contracts/token/ERC721/IERC721.sol
397 
398 
399 // OpenZeppelin Contracts v4.4.1 (token/ERC721/IERC721.sol)
400 
401 pragma solidity ^0.8.0;
402 
403 
404 /**
405  * @dev Required interface of an ERC721 compliant contract.
406  */
407 interface IERC721 is IERC165 {
408     /**
409      * @dev Emitted when `tokenId` token is transferred from `from` to `to`.
410      */
411     event Transfer(address indexed from, address indexed to, uint256 indexed tokenId);
412 
413     /**
414      * @dev Emitted when `owner` enables `approved` to manage the `tokenId` token.
415      */
416     event Approval(address indexed owner, address indexed approved, uint256 indexed tokenId);
417 
418     /**
419      * @dev Emitted when `owner` enables or disables (`approved`) `operator` to manage all of its assets.
420      */
421     event ApprovalForAll(address indexed owner, address indexed operator, bool approved);
422 
423     /**
424      * @dev Returns the number of tokens in ``owner``'s account.
425      */
426     function balanceOf(address owner) external view returns (uint256 balance);
427 
428     /**
429      * @dev Returns the owner of the `tokenId` token.
430      *
431      * Requirements:
432      *
433      * - `tokenId` must exist.
434      */
435     function ownerOf(uint256 tokenId) external view returns (address owner);
436 
437     /**
438      * @dev Safely transfers `tokenId` token from `from` to `to`, checking first that contract recipients
439      * are aware of the ERC721 protocol to prevent tokens from being forever locked.
440      *
441      * Requirements:
442      *
443      * - `from` cannot be the zero address.
444      * - `to` cannot be the zero address.
445      * - `tokenId` token must exist and be owned by `from`.
446      * - If the caller is not `from`, it must be have been allowed to move this token by either {approve} or {setApprovalForAll}.
447      * - If `to` refers to a smart contract, it must implement {IERC721Receiver-onERC721Received}, which is called upon a safe transfer.
448      *
449      * Emits a {Transfer} event.
450      */
451     function safeTransferFrom(
452         address from,
453         address to,
454         uint256 tokenId
455     ) external;
456 
457     /**
458      * @dev Transfers `tokenId` token from `from` to `to`.
459      *
460      * WARNING: Usage of this method is discouraged, use {safeTransferFrom} whenever possible.
461      *
462      * Requirements:
463      *
464      * - `from` cannot be the zero address.
465      * - `to` cannot be the zero address.
466      * - `tokenId` token must be owned by `from`.
467      * - If the caller is not `from`, it must be approved to move this token by either {approve} or {setApprovalForAll}.
468      *
469      * Emits a {Transfer} event.
470      */
471     function transferFrom(
472         address from,
473         address to,
474         uint256 tokenId
475     ) external;
476 
477     /**
478      * @dev Gives permission to `to` to transfer `tokenId` token to another account.
479      * The approval is cleared when the token is transferred.
480      *
481      * Only a single account can be approved at a time, so approving the zero address clears previous approvals.
482      *
483      * Requirements:
484      *
485      * - The caller must own the token or be an approved operator.
486      * - `tokenId` must exist.
487      *
488      * Emits an {Approval} event.
489      */
490     function approve(address to, uint256 tokenId) external;
491 
492     /**
493      * @dev Returns the account approved for `tokenId` token.
494      *
495      * Requirements:
496      *
497      * - `tokenId` must exist.
498      */
499     function getApproved(uint256 tokenId) external view returns (address operator);
500 
501     /**
502      * @dev Approve or remove `operator` as an operator for the caller.
503      * Operators can call {transferFrom} or {safeTransferFrom} for any token owned by the caller.
504      *
505      * Requirements:
506      *
507      * - The `operator` cannot be the caller.
508      *
509      * Emits an {ApprovalForAll} event.
510      */
511     function setApprovalForAll(address operator, bool _approved) external;
512 
513     /**
514      * @dev Returns if the `operator` is allowed to manage all of the assets of `owner`.
515      *
516      * See {setApprovalForAll}
517      */
518     function isApprovedForAll(address owner, address operator) external view returns (bool);
519 
520     /**
521      * @dev Safely transfers `tokenId` token from `from` to `to`.
522      *
523      * Requirements:
524      *
525      * - `from` cannot be the zero address.
526      * - `to` cannot be the zero address.
527      * - `tokenId` token must exist and be owned by `from`.
528      * - If the caller is not `from`, it must be approved to move this token by either {approve} or {setApprovalForAll}.
529      * - If `to` refers to a smart contract, it must implement {IERC721Receiver-onERC721Received}, which is called upon a safe transfer.
530      *
531      * Emits a {Transfer} event.
532      */
533     function safeTransferFrom(
534         address from,
535         address to,
536         uint256 tokenId,
537         bytes calldata data
538     ) external;
539 }
540 
541 // File: @openzeppelin/contracts/token/ERC721/extensions/IERC721Enumerable.sol
542 
543 
544 // OpenZeppelin Contracts v4.4.1 (token/ERC721/extensions/IERC721Enumerable.sol)
545 
546 pragma solidity ^0.8.0;
547 
548 
549 /**
550  * @title ERC-721 Non-Fungible Token Standard, optional enumeration extension
551  * @dev See https://eips.ethereum.org/EIPS/eip-721
552  */
553 interface IERC721Enumerable is IERC721 {
554     /**
555      * @dev Returns the total amount of tokens stored by the contract.
556      */
557     function totalSupply() external view returns (uint256);
558 
559     /**
560      * @dev Returns a token ID owned by `owner` at a given `index` of its token list.
561      * Use along with {balanceOf} to enumerate all of ``owner``'s tokens.
562      */
563     function tokenOfOwnerByIndex(address owner, uint256 index) external view returns (uint256 tokenId);
564 
565     /**
566      * @dev Returns a token ID at a given `index` of all the tokens stored by the contract.
567      * Use along with {totalSupply} to enumerate all tokens.
568      */
569     function tokenByIndex(uint256 index) external view returns (uint256);
570 }
571 
572 // File: @openzeppelin/contracts/token/ERC721/extensions/IERC721Metadata.sol
573 
574 
575 // OpenZeppelin Contracts v4.4.1 (token/ERC721/extensions/IERC721Metadata.sol)
576 
577 pragma solidity ^0.8.0;
578 
579 
580 /**
581  * @title ERC-721 Non-Fungible Token Standard, optional metadata extension
582  * @dev See https://eips.ethereum.org/EIPS/eip-721
583  */
584 interface IERC721Metadata is IERC721 {
585     /**
586      * @dev Returns the token collection name.
587      */
588     function name() external view returns (string memory);
589 
590     /**
591      * @dev Returns the token collection symbol.
592      */
593     function symbol() external view returns (string memory);
594 
595     /**
596      * @dev Returns the Uniform Resource Identifier (URI) for `tokenId` token.
597      */
598     function tokenURI(uint256 tokenId) external view returns (string memory);
599 }
600 
601 // File: @openzeppelin/contracts/security/ReentrancyGuard.sol
602 
603 
604 // OpenZeppelin Contracts v4.4.1 (security/ReentrancyGuard.sol)
605 
606 pragma solidity ^0.8.0;
607 
608 /**
609  * @dev Contract module that helps prevent reentrant calls to a function.
610  *
611  * Inheriting from `ReentrancyGuard` will make the {nonReentrant} modifier
612  * available, which can be applied to functions to make sure there are no nested
613  * (reentrant) calls to them.
614  *
615  * Note that because there is a single `nonReentrant` guard, functions marked as
616  * `nonReentrant` may not call one another. This can be worked around by making
617  * those functions `private`, and then adding `external` `nonReentrant` entry
618  * points to them.
619  *
620  * TIP: If you would like to learn more about reentrancy and alternative ways
621  * to protect against it, check out our blog post
622  * https://blog.openzeppelin.com/reentrancy-after-istanbul/[Reentrancy After Istanbul].
623  */
624 abstract contract ReentrancyGuard {
625     // Booleans are more expensive than uint256 or any type that takes up a full
626     // word because each write operation emits an extra SLOAD to first read the
627     // slot's contents, replace the bits taken up by the boolean, and then write
628     // back. This is the compiler's defense against contract upgrades and
629     // pointer aliasing, and it cannot be disabled.
630 
631     // The values being non-zero value makes deployment a bit more expensive,
632     // but in exchange the refund on every call to nonReentrant will be lower in
633     // amount. Since refunds are capped to a percentage of the total
634     // transaction's gas, it is best to keep them low in cases like this one, to
635     // increase the likelihood of the full refund coming into effect.
636     uint256 private constant _NOT_ENTERED = 1;
637     uint256 private constant _ENTERED = 2;
638 
639     uint256 private _status;
640 
641     constructor() {
642         _status = _NOT_ENTERED;
643     }
644 
645     /**
646      * @dev Prevents a contract from calling itself, directly or indirectly.
647      * Calling a `nonReentrant` function from another `nonReentrant`
648      * function is not supported. It is possible to prevent this from happening
649      * by making the `nonReentrant` function external, and making it call a
650      * `private` function that does the actual work.
651      */
652     modifier nonReentrant() {
653         // On the first call to nonReentrant, _notEntered will be true
654         require(_status != _ENTERED, "ReentrancyGuard: reentrant call");
655 
656         // Any calls to nonReentrant after this point will fail
657         _status = _ENTERED;
658 
659         _;
660 
661         // By storing the original value once again, a refund is triggered (see
662         // https://eips.ethereum.org/EIPS/eip-2200)
663         _status = _NOT_ENTERED;
664     }
665 }
666 
667 // File: @openzeppelin/contracts/utils/Context.sol
668 
669 
670 // OpenZeppelin Contracts v4.4.1 (utils/Context.sol)
671 
672 pragma solidity ^0.8.0;
673 
674 /**
675  * @dev Provides information about the current execution context, including the
676  * sender of the transaction and its data. While these are generally available
677  * via msg.sender and msg.data, they should not be accessed in such a direct
678  * manner, since when dealing with meta-transactions the account sending and
679  * paying for execution may not be the actual sender (as far as an application
680  * is concerned).
681  *
682  * This contract is only required for intermediate, library-like contracts.
683  */
684 abstract contract Context {
685     function _msgSender() internal view virtual returns (address) {
686         return msg.sender;
687     }
688 
689     function _msgData() internal view virtual returns (bytes calldata) {
690         return msg.data;
691     }
692 }
693 
694 // File: contracts/ERC721A.sol
695 
696 
697 
698 pragma solidity ^0.8.0;
699 
700 
701 
702 
703 
704 
705 
706 
707 
708 /**
709  * @dev Implementation of https://eips.ethereum.org/EIPS/eip-721[ERC721] Non-Fungible Token Standard, including
710  * the Metadata and Enumerable extension. Built to optimize for lower gas during batch mints.
711  *
712  * Assumes serials are sequentially minted starting at 0 (e.g. 0, 1, 2, 3..).
713  *
714  * Assumes the number of issuable tokens (collection size) is capped and fits in a uint128.
715  *
716  * Does not support burning tokens to address(0).
717  */
718 contract ERC721A is
719   Context,
720   ERC165,
721   IERC721,
722   IERC721Metadata,
723   IERC721Enumerable
724 {
725   using Address for address;
726   using Strings for uint256;
727 
728   struct TokenOwnership {
729     address addr;
730     uint64 startTimestamp;
731   }
732 
733   struct AddressData {
734     uint128 balance;
735     uint128 numberMinted;
736   }
737 
738   uint256 private currentIndex = 0;
739 
740   uint256 internal immutable collectionSize;
741   uint256 internal immutable maxBatchSize;
742 
743   // Token name
744   string private _name;
745 
746   // Token symbol
747   string private _symbol;
748 
749   // Mapping from token ID to ownership details
750   // An empty struct value does not necessarily mean the token is unowned. See ownershipOf implementation for details.
751   mapping(uint256 => TokenOwnership) private _ownerships;
752 
753   // Mapping owner address to address data
754   mapping(address => AddressData) private _addressData;
755 
756   // Mapping from token ID to approved address
757   mapping(uint256 => address) private _tokenApprovals;
758 
759   // Mapping from owner to operator approvals
760   mapping(address => mapping(address => bool)) private _operatorApprovals;
761 
762   /**
763    * @dev
764    * `maxBatchSize` refers to how much a minter can mint at a time.
765    * `collectionSize_` refers to how many tokens are in the collection.
766    */
767   constructor(
768     string memory name_,
769     string memory symbol_,
770     uint256 maxBatchSize_,
771     uint256 collectionSize_
772   ) {
773     require(
774       collectionSize_ > 0,
775       "ERC721A: collection must have a nonzero supply"
776     );
777     require(maxBatchSize_ > 0, "ERC721A: max batch size must be nonzero");
778     _name = name_;
779     _symbol = symbol_;
780     maxBatchSize = maxBatchSize_;
781     collectionSize = collectionSize_;
782   }
783 
784   /**
785    * @dev See {IERC721Enumerable-totalSupply}.
786    */
787   function totalSupply() public view override returns (uint256) {
788     return currentIndex;
789   }
790 
791   /**
792    * @dev See {IERC721Enumerable-tokenByIndex}.
793    */
794   function tokenByIndex(uint256 index) public view override returns (uint256) {
795     require(index < totalSupply(), "ERC721A: global index out of bounds");
796     return index;
797   }
798 
799   /**
800    * @dev See {IERC721Enumerable-tokenOfOwnerByIndex}.
801    * This read function is O(collectionSize). If calling from a separate contract, be sure to test gas first.
802    * It may also degrade with extremely large collection sizes (e.g >> 10000), test for your use case.
803    */
804   function tokenOfOwnerByIndex(address owner, uint256 index)
805     public
806     view
807     override
808     returns (uint256)
809   {
810     require(index < balanceOf(owner), "ERC721A: owner index out of bounds");
811     uint256 numMintedSoFar = totalSupply();
812     uint256 tokenIdsIdx = 0;
813     address currOwnershipAddr = address(0);
814     for (uint256 i = 0; i < numMintedSoFar; i++) {
815       TokenOwnership memory ownership = _ownerships[i];
816       if (ownership.addr != address(0)) {
817         currOwnershipAddr = ownership.addr;
818       }
819       if (currOwnershipAddr == owner) {
820         if (tokenIdsIdx == index) {
821           return i;
822         }
823         tokenIdsIdx++;
824       }
825     }
826     revert("ERC721A: unable to get token of owner by index");
827   }
828 
829   /**
830    * @dev See {IERC165-supportsInterface}.
831    */
832   function supportsInterface(bytes4 interfaceId)
833     public
834     view
835     virtual
836     override(ERC165, IERC165)
837     returns (bool)
838   {
839     return
840       interfaceId == type(IERC721).interfaceId ||
841       interfaceId == type(IERC721Metadata).interfaceId ||
842       interfaceId == type(IERC721Enumerable).interfaceId ||
843       super.supportsInterface(interfaceId);
844   }
845 
846   /**
847    * @dev See {IERC721-balanceOf}.
848    */
849   function balanceOf(address owner) public view override returns (uint256) {
850     require(owner != address(0), "ERC721A: balance query for the zero address");
851     return uint256(_addressData[owner].balance);
852   }
853 
854   function _numberMinted(address owner) internal view returns (uint256) {
855     require(
856       owner != address(0),
857       "ERC721A: number minted query for the zero address"
858     );
859     return uint256(_addressData[owner].numberMinted);
860   }
861 
862   function ownershipOf(uint256 tokenId)
863     internal
864     view
865     returns (TokenOwnership memory)
866   {
867     require(_exists(tokenId), "ERC721A: owner query for nonexistent token");
868 
869     uint256 lowestTokenToCheck;
870     if (tokenId >= maxBatchSize) {
871       lowestTokenToCheck = tokenId - maxBatchSize + 1;
872     }
873 
874     for (uint256 curr = tokenId; curr >= lowestTokenToCheck; curr--) {
875       TokenOwnership memory ownership = _ownerships[curr];
876       if (ownership.addr != address(0)) {
877         return ownership;
878       }
879     }
880 
881     revert("ERC721A: unable to determine the owner of token");
882   }
883 
884   /**
885    * @dev See {IERC721-ownerOf}.
886    */
887   function ownerOf(uint256 tokenId) public view override returns (address) {
888     return ownershipOf(tokenId).addr;
889   }
890 
891   /**
892    * @dev See {IERC721Metadata-name}.
893    */
894   function name() public view virtual override returns (string memory) {
895     return _name;
896   }
897 
898   /**
899    * @dev See {IERC721Metadata-symbol}.
900    */
901   function symbol() public view virtual override returns (string memory) {
902     return _symbol;
903   }
904 
905   /**
906    * @dev See {IERC721Metadata-tokenURI}.
907    */
908   function tokenURI(uint256 tokenId)
909     public
910     view
911     virtual
912     override
913     returns (string memory)
914   {
915     require(
916       _exists(tokenId),
917       "ERC721Metadata: URI query for nonexistent token"
918     );
919 
920     string memory baseURI = _baseURI();
921     return
922       bytes(baseURI).length > 0
923         ? string(abi.encodePacked(baseURI, tokenId.toString()))
924         : "";
925   }
926 
927   /**
928    * @dev Base URI for computing {tokenURI}. If set, the resulting URI for each
929    * token will be the concatenation of the `baseURI` and the `tokenId`. Empty
930    * by default, can be overriden in child contracts.
931    */
932   function _baseURI() internal view virtual returns (string memory) {
933     return "";
934   }
935 
936   /**
937    * @dev See {IERC721-approve}.
938    */
939   function approve(address to, uint256 tokenId) public override {
940     address owner = ERC721A.ownerOf(tokenId);
941     require(to != owner, "ERC721A: approval to current owner");
942 
943     require(
944       _msgSender() == owner || isApprovedForAll(owner, _msgSender()),
945       "ERC721A: approve caller is not owner nor approved for all"
946     );
947 
948     _approve(to, tokenId, owner);
949   }
950 
951   /**
952    * @dev See {IERC721-getApproved}.
953    */
954   function getApproved(uint256 tokenId) public view override returns (address) {
955     require(_exists(tokenId), "ERC721A: approved query for nonexistent token");
956 
957     return _tokenApprovals[tokenId];
958   }
959 
960   /**
961    * @dev See {IERC721-setApprovalForAll}.
962    */
963   function setApprovalForAll(address operator, bool approved) public override {
964     require(operator != _msgSender(), "ERC721A: approve to caller");
965 
966     _operatorApprovals[_msgSender()][operator] = approved;
967     emit ApprovalForAll(_msgSender(), operator, approved);
968   }
969 
970   /**
971    * @dev See {IERC721-isApprovedForAll}.
972    */
973   function isApprovedForAll(address owner, address operator)
974     public
975     view
976     virtual
977     override
978     returns (bool)
979   {
980     return _operatorApprovals[owner][operator];
981   }
982 
983   /**
984    * @dev See {IERC721-transferFrom}.
985    */
986   function transferFrom(
987     address from,
988     address to,
989     uint256 tokenId
990   ) public override {
991     _transfer(from, to, tokenId);
992   }
993 
994   /**
995    * @dev See {IERC721-safeTransferFrom}.
996    */
997   function safeTransferFrom(
998     address from,
999     address to,
1000     uint256 tokenId
1001   ) public override {
1002     safeTransferFrom(from, to, tokenId, "");
1003   }
1004 
1005   /**
1006    * @dev See {IERC721-safeTransferFrom}.
1007    */
1008   function safeTransferFrom(
1009     address from,
1010     address to,
1011     uint256 tokenId,
1012     bytes memory _data
1013   ) public override {
1014     _transfer(from, to, tokenId);
1015     require(
1016       _checkOnERC721Received(from, to, tokenId, _data),
1017       "ERC721A: transfer to non ERC721Receiver implementer"
1018     );
1019   }
1020 
1021   /**
1022    * @dev Returns whether `tokenId` exists.
1023    *
1024    * Tokens can be managed by their owner or approved accounts via {approve} or {setApprovalForAll}.
1025    *
1026    * Tokens start existing when they are minted (`_mint`),
1027    */
1028   function _exists(uint256 tokenId) internal view returns (bool) {
1029     return tokenId < currentIndex;
1030   }
1031 
1032   function _safeMint(address to, uint256 quantity) internal {
1033     _safeMint(to, quantity, "");
1034   }
1035 
1036   /**
1037    * @dev Mints `quantity` tokens and transfers them to `to`.
1038    *
1039    * Requirements:
1040    *
1041    * - there must be `quantity` tokens remaining unminted in the total collection.
1042    * - `to` cannot be the zero address.
1043    * - `quantity` cannot be larger than the max batch size.
1044    *
1045    * Emits a {Transfer} event.
1046    */
1047   function _safeMint(
1048     address to,
1049     uint256 quantity,
1050     bytes memory _data
1051   ) internal {
1052     uint256 startTokenId = currentIndex;
1053     require(to != address(0), "ERC721A: mint to the zero address");
1054     // We know if the first token in the batch doesn't exist, the other ones don't as well, because of serial ordering.
1055     require(!_exists(startTokenId), "ERC721A: token already minted");
1056     require(quantity <= maxBatchSize, "ERC721A: quantity to mint too high");
1057 
1058     _beforeTokenTransfers(address(0), to, startTokenId, quantity);
1059 
1060     AddressData memory addressData = _addressData[to];
1061     _addressData[to] = AddressData(
1062       addressData.balance + uint128(quantity),
1063       addressData.numberMinted + uint128(quantity)
1064     );
1065     _ownerships[startTokenId] = TokenOwnership(to, uint64(block.timestamp));
1066 
1067     uint256 updatedIndex = startTokenId;
1068 
1069     for (uint256 i = 0; i < quantity; i++) {
1070       emit Transfer(address(0), to, updatedIndex);
1071       require(
1072         _checkOnERC721Received(address(0), to, updatedIndex, _data),
1073         "ERC721A: transfer to non ERC721Receiver implementer"
1074       );
1075       updatedIndex++;
1076     }
1077 
1078     currentIndex = updatedIndex;
1079     _afterTokenTransfers(address(0), to, startTokenId, quantity);
1080   }
1081 
1082   /**
1083    * @dev Transfers `tokenId` from `from` to `to`.
1084    *
1085    * Requirements:
1086    *
1087    * - `to` cannot be the zero address.
1088    * - `tokenId` token must be owned by `from`.
1089    *
1090    * Emits a {Transfer} event.
1091    */
1092   function _transfer(
1093     address from,
1094     address to,
1095     uint256 tokenId
1096   ) private {
1097     TokenOwnership memory prevOwnership = ownershipOf(tokenId);
1098 
1099     bool isApprovedOrOwner = (_msgSender() == prevOwnership.addr ||
1100       getApproved(tokenId) == _msgSender() ||
1101       isApprovedForAll(prevOwnership.addr, _msgSender()));
1102 
1103     require(
1104       isApprovedOrOwner,
1105       "ERC721A: transfer caller is not owner nor approved"
1106     );
1107 
1108     require(
1109       prevOwnership.addr == from,
1110       "ERC721A: transfer from incorrect owner"
1111     );
1112     require(to != address(0), "ERC721A: transfer to the zero address");
1113 
1114     _beforeTokenTransfers(from, to, tokenId, 1);
1115 
1116     // Clear approvals from the previous owner
1117     _approve(address(0), tokenId, prevOwnership.addr);
1118 
1119     _addressData[from].balance -= 1;
1120     _addressData[to].balance += 1;
1121     _ownerships[tokenId] = TokenOwnership(to, uint64(block.timestamp));
1122 
1123     // If the ownership slot of tokenId+1 is not explicitly set, that means the transfer initiator owns it.
1124     // Set the slot of tokenId+1 explicitly in storage to maintain correctness for ownerOf(tokenId+1) calls.
1125     uint256 nextTokenId = tokenId + 1;
1126     if (_ownerships[nextTokenId].addr == address(0)) {
1127       if (_exists(nextTokenId)) {
1128         _ownerships[nextTokenId] = TokenOwnership(
1129           prevOwnership.addr,
1130           prevOwnership.startTimestamp
1131         );
1132       }
1133     }
1134 
1135     emit Transfer(from, to, tokenId);
1136     _afterTokenTransfers(from, to, tokenId, 1);
1137   }
1138 
1139   /**
1140    * @dev Approve `to` to operate on `tokenId`
1141    *
1142    * Emits a {Approval} event.
1143    */
1144   function _approve(
1145     address to,
1146     uint256 tokenId,
1147     address owner
1148   ) private {
1149     _tokenApprovals[tokenId] = to;
1150     emit Approval(owner, to, tokenId);
1151   }
1152 
1153   uint256 public nextOwnerToExplicitlySet = 0;
1154 
1155   /**
1156    * @dev Explicitly set `owners` to eliminate loops in future calls of ownerOf().
1157    */
1158   function _setOwnersExplicit(uint256 quantity) internal {
1159     uint256 oldNextOwnerToSet = nextOwnerToExplicitlySet;
1160     require(quantity > 0, "quantity must be nonzero");
1161     uint256 endIndex = oldNextOwnerToSet + quantity - 1;
1162     if (endIndex > collectionSize - 1) {
1163       endIndex = collectionSize - 1;
1164     }
1165     // We know if the last one in the group exists, all in the group exist, due to serial ordering.
1166     require(_exists(endIndex), "not enough minted yet for this cleanup");
1167     for (uint256 i = oldNextOwnerToSet; i <= endIndex; i++) {
1168       if (_ownerships[i].addr == address(0)) {
1169         TokenOwnership memory ownership = ownershipOf(i);
1170         _ownerships[i] = TokenOwnership(
1171           ownership.addr,
1172           ownership.startTimestamp
1173         );
1174       }
1175     }
1176     nextOwnerToExplicitlySet = endIndex + 1;
1177   }
1178 
1179   /**
1180    * @dev Internal function to invoke {IERC721Receiver-onERC721Received} on a target address.
1181    * The call is not executed if the target address is not a contract.
1182    *
1183    * @param from address representing the previous owner of the given token ID
1184    * @param to target address that will receive the tokens
1185    * @param tokenId uint256 ID of the token to be transferred
1186    * @param _data bytes optional data to send along with the call
1187    * @return bool whether the call correctly returned the expected magic value
1188    */
1189   function _checkOnERC721Received(
1190     address from,
1191     address to,
1192     uint256 tokenId,
1193     bytes memory _data
1194   ) private returns (bool) {
1195     if (to.isContract()) {
1196       try
1197         IERC721Receiver(to).onERC721Received(_msgSender(), from, tokenId, _data)
1198       returns (bytes4 retval) {
1199         return retval == IERC721Receiver(to).onERC721Received.selector;
1200       } catch (bytes memory reason) {
1201         if (reason.length == 0) {
1202           revert("ERC721A: transfer to non ERC721Receiver implementer");
1203         } else {
1204           assembly {
1205             revert(add(32, reason), mload(reason))
1206           }
1207         }
1208       }
1209     } else {
1210       return true;
1211     }
1212   }
1213 
1214   /**
1215    * @dev Hook that is called before a set of serially-ordered token ids are about to be transferred. This includes minting.
1216    *
1217    * startTokenId - the first token id to be transferred
1218    * quantity - the amount to be transferred
1219    *
1220    * Calling conditions:
1221    *
1222    * - When `from` and `to` are both non-zero, ``from``'s `tokenId` will be
1223    * transferred to `to`.
1224    * - When `from` is zero, `tokenId` will be minted for `to`.
1225    */
1226   function _beforeTokenTransfers(
1227     address from,
1228     address to,
1229     uint256 startTokenId,
1230     uint256 quantity
1231   ) internal virtual {}
1232 
1233   /**
1234    * @dev Hook that is called after a set of serially-ordered token ids have been transferred. This includes
1235    * minting.
1236    *
1237    * startTokenId - the first token id to be transferred
1238    * quantity - the amount to be transferred
1239    *
1240    * Calling conditions:
1241    *
1242    * - when `from` and `to` are both non-zero.
1243    * - `from` and `to` are never both zero.
1244    */
1245   function _afterTokenTransfers(
1246     address from,
1247     address to,
1248     uint256 startTokenId,
1249     uint256 quantity
1250   ) internal virtual {}
1251 }
1252 // File: @openzeppelin/contracts/access/Ownable.sol
1253 
1254 
1255 // OpenZeppelin Contracts v4.4.1 (access/Ownable.sol)
1256 
1257 pragma solidity ^0.8.0;
1258 
1259 
1260 /**
1261  * @dev Contract module which provides a basic access control mechanism, where
1262  * there is an account (an owner) that can be granted exclusive access to
1263  * specific functions.
1264  *
1265  * By default, the owner account will be the one that deploys the contract. This
1266  * can later be changed with {transferOwnership}.
1267  *
1268  * This module is used through inheritance. It will make available the modifier
1269  * `onlyOwner`, which can be applied to your functions to restrict their use to
1270  * the owner.
1271  */
1272 abstract contract Ownable is Context {
1273     address private _owner;
1274 
1275     event OwnershipTransferred(address indexed previousOwner, address indexed newOwner);
1276 
1277     /**
1278      * @dev Initializes the contract setting the deployer as the initial owner.
1279      */
1280     constructor() {
1281         _transferOwnership(_msgSender());
1282     }
1283 
1284     /**
1285      * @dev Returns the address of the current owner.
1286      */
1287     function owner() public view virtual returns (address) {
1288         return _owner;
1289     }
1290 
1291     /**
1292      * @dev Throws if called by any account other than the owner.
1293      */
1294     modifier onlyOwner() {
1295         require(owner() == _msgSender(), "Ownable: caller is not the owner");
1296         _;
1297     }
1298 
1299     /**
1300      * @dev Leaves the contract without owner. It will not be possible to call
1301      * `onlyOwner` functions anymore. Can only be called by the current owner.
1302      *
1303      * NOTE: Renouncing ownership will leave the contract without an owner,
1304      * thereby removing any functionality that is only available to the owner.
1305      */
1306     function renounceOwnership() public virtual onlyOwner {
1307         _transferOwnership(address(0));
1308     }
1309 
1310     /**
1311      * @dev Transfers ownership of the contract to a new account (`newOwner`).
1312      * Can only be called by the current owner.
1313      */
1314     function transferOwnership(address newOwner) public virtual onlyOwner {
1315         require(newOwner != address(0), "Ownable: new owner is the zero address");
1316         _transferOwnership(newOwner);
1317     }
1318 
1319     /**
1320      * @dev Transfers ownership of the contract to a new account (`newOwner`).
1321      * Internal function without access restriction.
1322      */
1323     function _transferOwnership(address newOwner) internal virtual {
1324         address oldOwner = _owner;
1325         _owner = newOwner;
1326         emit OwnershipTransferred(oldOwner, newOwner);
1327     }
1328 }
1329 
1330 // File: contracts/CSHOX.sol
1331 
1332 // CSHOX by Echelon Cipher
1333 // Website: https://www.cshox.com/
1334 // Twitter: https://twitter.com/cshox_co
1335 // Discord: https://discord.gg/cshox
1336 
1337 
1338 pragma solidity ^0.8.0;
1339 
1340 
1341 
1342 
1343 
1344 
1345 contract CSHOX is Ownable, ERC721A, ReentrancyGuard {
1346     string public baseURI = "https://asset.echeloncipher.xyz/place/";
1347     string public PROVENANCE;
1348     bool public isSaleActive;
1349     bool public isTWActive;
1350     uint256 public itemPrice = 0.1 ether;    
1351     uint256 public immutable maxSupply = 3690;
1352     uint256 public immutable maxPerAddressDuringMint;
1353     Tw private immutable timewarp;
1354 
1355     constructor(
1356         uint256 maxBatchSize_,
1357         uint256 maxSupply_,
1358         address TimeWarpAddress
1359     ) ERC721A("CSHOX", "CSHOX", maxBatchSize_, maxSupply_) {
1360         maxPerAddressDuringMint = maxBatchSize_;
1361         timewarp = Tw(TimeWarpAddress);
1362     }
1363 
1364     // CHOX level
1365     mapping(uint => uint) public CSHOXLevel;
1366 
1367     event levelup(
1368         address from,
1369         uint tokenId,
1370         uint level
1371     );
1372     function levelupCSHOX(uint tokenId, uint8 TimeWarpTypes) 
1373         external        
1374     {
1375         require(isTWActive, "Time Warp is not active");
1376         require(
1377             ownerOf(tokenId) == msg.sender,
1378             "Must own the CSHOX you are attempting to level up"
1379         );
1380 
1381         if (CSHOXLevel[tokenId] >= 1){
1382             
1383             require(
1384                 timewarp.balanceOf(msg.sender, TimeWarpTypes) > 0,
1385                 "Must own at least one of the Time Warps to level up"
1386             );   
1387             timewarp.burnTWForAddress(TimeWarpTypes, msg.sender);
1388         }
1389         
1390         CSHOXLevel[tokenId] += 1;
1391         emit levelup(
1392             msg.sender,
1393             tokenId,
1394             CSHOXLevel[tokenId]
1395         );
1396     }        
1397 
1398     modifier callerIsUser() {
1399         require(tx.origin == msg.sender, "The caller is another contract");
1400         _;
1401     }
1402 
1403     //    FREEMINT    
1404     bool public isFREElistActive;
1405     mapping(address => bool) public onFREElist;
1406     mapping(address => uint256) public FREElistClaimedBy;
1407 
1408     function addToFREElist(address[] calldata addresses, bool _add)
1409         external
1410         onlyOwner
1411     {
1412         for (uint256 i = 0; i < addresses.length; i++)
1413             onFREElist[addresses[i]] = _add;
1414     }
1415 
1416     // Purchase multiple NFTs at once
1417     function purchaseFREEsaleTokens()
1418         external
1419         payable
1420         callerIsUser
1421         tokensAvailable(1)
1422     {
1423         require(isFREElistActive, "FREElist is not active");
1424         require(onFREElist[msg.sender], "You are not in FREElist");
1425         require(
1426             FREElistClaimedBy[msg.sender] + 1 <= 1,
1427             "Already given a free mint"
1428         );
1429 
1430         FREElistClaimedBy[msg.sender] += 1;
1431 
1432         _safeMint(msg.sender, 1);
1433         CSHOXLevel[totalSupply()] = 0;
1434     }
1435 
1436     function setIsFREElistActive(bool _isFREElistActive) external onlyOwner {
1437         isFREElistActive = _isFREElistActive;
1438     }
1439 
1440     //    OG SALE
1441     uint256 public itemPriceOGsale = 0.10 ether;
1442     bool public isOGlistActive;
1443     uint256 public OGlistMaxMint = 50;
1444     mapping(address => bool) public onOGlist;
1445     mapping(address => uint256) public OGlistClaimedBy;
1446 
1447     function addToOGlist(address[] calldata addresses, bool _add)
1448         external
1449         onlyOwner
1450     {
1451         for (uint256 i = 0; i < addresses.length; i++)
1452             onOGlist[addresses[i]] = _add;
1453     }
1454 
1455     // Purchase multiple NFTs at once
1456     function purchaseOGsaleTokens(uint256 _howMany)
1457         external
1458         payable
1459         callerIsUser
1460         tokensAvailable(_howMany)
1461     {
1462         require(isOGlistActive, "OGlist is not active");
1463         require(onOGlist[msg.sender], "You are not in OGlist");
1464         require(
1465             OGlistClaimedBy[msg.sender] + _howMany <= OGlistMaxMint,
1466             "Purchase exceeds max allowed"
1467         );
1468         require(_howMany > 0 && _howMany <= OGlistMaxMint, "Mint at least 1 token and not more than allowed.");
1469         require(
1470             msg.value >= _howMany * itemPriceOGsale,
1471             "Try to send more ETH"
1472         );
1473 
1474         OGlistClaimedBy[msg.sender] += _howMany;
1475 
1476         _safeMint(msg.sender, _howMany);
1477         CSHOXLevel[totalSupply()] = 0;
1478         refundIfOver(itemPriceOGsale * _howMany);
1479     }
1480 
1481     // set limit of OGlist
1482     function setOGlistMaxMint(uint256 _OGlistMaxMint) external onlyOwner {
1483         OGlistMaxMint = _OGlistMaxMint;
1484     }
1485 
1486     // Change presale price in case of ETH price changes too much
1487     function setPriceOGsale(uint256 _itemPriceOGsale) external onlyOwner {
1488         itemPriceOGsale = _itemPriceOGsale;
1489     }
1490 
1491     function setIsOGlistActive(bool _isOGlistActive) external onlyOwner {
1492         isOGlistActive = _isOGlistActive;
1493     }
1494 
1495     //    PRESALE
1496     uint256 public itemPricePresale = 0.08 ether;
1497     bool public isAllowlistActive;
1498     uint256 public allowlistMaxMint = 3;
1499     mapping(address => bool) public onAllowlist;
1500     mapping(address => uint256) public allowlistClaimedBy;
1501 
1502     function addToAllowlist(address[] calldata addresses, bool _add)
1503         external
1504         onlyOwner
1505     {
1506         for (uint256 i = 0; i < addresses.length; i++)
1507             onAllowlist[addresses[i]] = _add;
1508     }
1509 
1510     // Purchase multiple NFTs at once
1511     function purchasePresaleTokens(uint256 _howMany)
1512         external
1513         payable
1514         callerIsUser
1515         tokensAvailable(_howMany)
1516     {
1517         require(isAllowlistActive, "Allowlist is not active");
1518         require(onAllowlist[msg.sender], "You are not in allowlist");
1519         require(
1520             allowlistClaimedBy[msg.sender] + _howMany <= allowlistMaxMint,
1521             "Purchase exceeds max allowed"
1522         );
1523         require(_howMany > 0 && _howMany <= allowlistMaxMint, "Mint at least 1 token and not more than allowed.");
1524         require(
1525             msg.value >= _howMany * itemPricePresale,
1526             "Try to send more ETH"
1527         );
1528 
1529         allowlistClaimedBy[msg.sender] += _howMany;
1530 
1531         _safeMint(msg.sender, _howMany);
1532         CSHOXLevel[totalSupply()] = 0;
1533         refundIfOver(itemPricePresale * _howMany);
1534     }
1535 
1536     // set limit of allowlist
1537     function setAllowlistMaxMint(uint256 _allowlistMaxMint) external onlyOwner {
1538         allowlistMaxMint = _allowlistMaxMint;
1539     }
1540 
1541     // Change presale price in case of ETH price changes too much
1542     function setPricePresale(uint256 _itemPricePresale) external onlyOwner {
1543         itemPricePresale = _itemPricePresale;
1544     }
1545 
1546     function setIsAllowlistActive(bool _isAllowlistActive) external onlyOwner {
1547         isAllowlistActive = _isAllowlistActive;
1548     }
1549 
1550     //    PUBLIC SALE 
1551 
1552     // Purchase multiple NFTs at once
1553     function purchaseTokens(uint256 _howMany)
1554         external
1555         payable
1556         callerIsUser
1557         tokensAvailable(_howMany)
1558     {
1559         require(isSaleActive, "Sale is not active");
1560         require(_howMany > 0 && _howMany <= 10, "Mint min 1, max 10");
1561         require(msg.value >= _howMany * itemPrice, "Try to send more ETH");
1562         
1563         _safeMint(msg.sender, _howMany);
1564         CSHOXLevel[totalSupply()] = 0;
1565         refundIfOver(itemPrice * _howMany);
1566     }    
1567 
1568     // Change price in case of ETH price changes too much
1569     function setPrice(uint256 _newPrice) external onlyOwner {
1570         itemPrice = _newPrice;
1571     }
1572 
1573     function setSaleActive(bool _isSaleActive) external onlyOwner {
1574         isSaleActive = _isSaleActive;
1575     }
1576 
1577     function setTWActive(bool _isTWActive) external onlyOwner {
1578         isTWActive = _isTWActive;
1579     }
1580 
1581     function setBaseURI(string memory __baseURI) external onlyOwner {
1582         baseURI = __baseURI;
1583     }
1584 
1585     // Owner can withdraw from here
1586     function withdraw() external onlyOwner nonReentrant {
1587         (bool success, ) = msg.sender.call{value: address(this).balance}("");
1588         require(success, "Transfer failed.");
1589     }
1590 
1591     //       AIRDROP
1592 
1593     // Send NFTs to a list of addresses
1594     function giftNftToList(address[] calldata _sendNftsTo, uint256 _howMany)
1595         external
1596         onlyOwner
1597         tokensAvailable(_sendNftsTo.length)
1598     {
1599         for (uint256 i = 0; i < _sendNftsTo.length; i++){
1600             _safeMint(_sendNftsTo[i], _howMany);
1601             CSHOXLevel[totalSupply()] = 0;
1602         }
1603     }
1604 
1605     // Send NFTs to a single address
1606     function giftNftToAddress(address _sendNftsTo, uint256 _howMany)
1607         external
1608         onlyOwner
1609         tokensAvailable(_howMany)
1610     {
1611         _safeMint(_sendNftsTo, _howMany);
1612         CSHOXLevel[totalSupply()] = 0;
1613     }
1614 
1615     function tokensRemaining() public view returns (uint256) {
1616         return maxSupply - totalSupply(); 
1617     }
1618 
1619     function _baseURI() internal view override returns (string memory) {
1620         return baseURI;
1621     }
1622 
1623     function walletOfOwner(address _owner)
1624         public
1625         view
1626         returns (uint256[] memory)
1627     {
1628         uint256 ownerTokenCount = balanceOf(_owner);
1629         uint256[] memory tokenIds = new uint256[](ownerTokenCount);
1630         for (uint256 i; i < ownerTokenCount; i++)
1631             tokenIds[i] = tokenOfOwnerByIndex(_owner, i);
1632 
1633         return tokenIds;
1634     }
1635 
1636     modifier tokensAvailable(uint256 _howMany) {
1637         require(_howMany <= tokensRemaining(), "Try minting less tokens");
1638         _;
1639     }
1640 
1641     function refundIfOver(uint256 price) private {
1642         require(msg.value >= price, "Need to send more ETH.");
1643         if (msg.value > price) {
1644         payable(msg.sender).transfer(msg.value - price);
1645         }
1646     }
1647 
1648     function numberMinted(address owner) public view returns (uint256) {
1649         return _numberMinted(owner);
1650     }
1651 
1652     // WHITELISTING FOR STAKING 
1653 
1654     // tokenId => staked (yes or no)
1655     mapping(address => bool) public whitelisted;
1656 
1657     // add / remove from whitelist who can stake / unstake
1658     function addToWhitelist(address _address, bool _add) external onlyOwner {
1659         whitelisted[_address] = _add;
1660     }
1661 
1662     modifier onlyWhitelisted() {
1663         require(whitelisted[msg.sender], "Caller is not whitelisted");
1664         _;
1665     }
1666 
1667     // STAKING METHOD  
1668 
1669     mapping(uint256 => bool) public staked;
1670 
1671     function _beforeTokenTransfers(
1672         address,
1673         address,
1674         uint256 startTokenId,
1675         uint256 quantity
1676     ) internal view override {
1677         for (uint256 i = startTokenId; i < startTokenId + quantity; i++)
1678             require(!staked[i], "Unstake tokenId it to transfer");
1679     }
1680 
1681     // stake / unstake nfts
1682     function stakeNfts(uint256[] calldata _tokenIds, bool _stake)
1683         external
1684         onlyWhitelisted
1685     {
1686         for (uint256 i = 0; i < _tokenIds.length; i++)
1687             staked[_tokenIds[i]] = _stake;
1688     }
1689 
1690     function setProvenance(string memory provenance) public onlyOwner {
1691         PROVENANCE = provenance;
1692     }
1693 
1694 }