1 // SPDX-License-Identifier: MIT
2 /**
3 
4 https://majpo.com
5 
6 yoSDaq ghoS vIQoy'chu'moH. DeSvel vIghoSbe' jIH. yInmeH jIghoS yInmeH, veqlargh DaneHchugh
7 
8 .___  ___.      ___            __     .______     ______
9 |   \/   |     /   \          |  |    |   _  \   /  __  \
10 |  \  /  |    /  ^  \         |  |    |  |_)  | |  |  |  |
11 |  |\/|  |   /  /_\  \  .--.  |  |    |   ___/  |  |  |  |
12 |  |  |  |  /  _____  \ |  `--'  |    |  |      |  `--'  |
13 |__|  |__| /__/     \__\ \______/     | _|       \______/
14 
15 
16 */
17 
18 // File: contracts/Strings.sol
19 pragma solidity ^0.8.0;
20 
21 /**
22  * @dev String operations.
23  */
24 library Strings {
25     bytes16 private constant _HEX_SYMBOLS = "0123456789abcdef";
26 
27     /**
28      * @dev Converts a `uint256` to its ASCII `string` decimal representation.
29      */
30     function toString(uint256 value) internal pure returns (string memory) {
31         // Inspired by OraclizeAPI's implementation - MIT licence
32         // https://github.com/oraclize/ethereum-api/blob/b42146b063c7d6ee1358846c198246239e9360e8/oraclizeAPI_0.4.25.sol
33 
34         if (value == 0) {
35             return "0";
36         }
37         uint256 temp = value;
38         uint256 digits;
39         while (temp != 0) {
40             digits++;
41             temp /= 10;
42         }
43         bytes memory buffer = new bytes(digits);
44         while (value != 0) {
45             digits -= 1;
46             buffer[digits] = bytes1(uint8(48 + uint256(value % 10)));
47             value /= 10;
48         }
49         return string(buffer);
50     }
51 
52     /**
53      * @dev Converts a `uint256` to its ASCII `string` hexadecimal representation.
54      */
55     function toHexString(uint256 value) internal pure returns (string memory) {
56         if (value == 0) {
57             return "0x00";
58         }
59         uint256 temp = value;
60         uint256 length = 0;
61         while (temp != 0) {
62             length++;
63             temp >>= 8;
64         }
65         return toHexString(value, length);
66     }
67 
68     /**
69      * @dev Converts a `uint256` to its ASCII `string` hexadecimal representation with fixed length.
70      */
71     function toHexString(uint256 value, uint256 length) internal pure returns (string memory) {
72         bytes memory buffer = new bytes(2 * length + 2);
73         buffer[0] = "0";
74         buffer[1] = "x";
75         for (uint256 i = 2 * length + 1; i > 1; --i) {
76             buffer[i] = _HEX_SYMBOLS[value & 0xf];
77             value >>= 4;
78         }
79         require(value == 0, "Strings: hex length insufficient");
80         return string(buffer);
81     }
82 }
83 
84 // File: contracts/Address.sol
85 
86 
87 
88 pragma solidity ^0.8.0;
89 
90 /**
91  * @dev Collection of functions related to the address type
92  */
93 library Address {
94     /**
95      * @dev Returns true if `account` is a contract.
96      *
97      * [IMPORTANT]
98      * ====
99      * It is unsafe to assume that an address for which this function returns
100      * false is an externally-owned account (EOA) and not a contract.
101      *
102      * Among others, `isContract` will return false for the following
103      * types of addresses:
104      *
105      *  - an externally-owned account
106      *  - a contract in construction
107      *  - an address where a contract will be created
108      *  - an address where a contract lived, but was destroyed
109      * ====
110      */
111     function isContract(address account) internal view returns (bool) {
112         // This method relies on extcodesize, which returns 0 for contracts in
113         // construction, since the code is only stored at the end of the
114         // constructor execution.
115 
116         uint256 size;
117         assembly {
118             size := extcodesize(account)
119         }
120         return size > 0;
121     }
122 
123     /**
124      * @dev Replacement for Solidity's `transfer`: sends `amount` wei to
125      * `recipient`, forwarding all available gas and reverting on errors.
126      *
127      * https://eips.ethereum.org/EIPS/eip-1884[EIP1884] increases the gas cost
128      * of certain opcodes, possibly making contracts go over the 2300 gas limit
129      * imposed by `transfer`, making them unable to receive funds via
130      * `transfer`. {sendValue} removes this limitation.
131      *
132      * https://diligence.consensys.net/posts/2019/09/stop-using-soliditys-transfer-now/[Learn more].
133      *
134      * IMPORTANT: because control is transferred to `recipient`, care must be
135      * taken to not create reentrancy vulnerabilities. Consider using
136      * {ReentrancyGuard} or the
137      * https://solidity.readthedocs.io/en/v0.5.11/security-considerations.html#use-the-checks-effects-interactions-pattern[checks-effects-interactions pattern].
138      */
139     function sendValue(address payable recipient, uint256 amount) internal {
140         require(address(this).balance >= amount, "Address: insufficient balance");
141 
142         (bool success, ) = recipient.call{value: amount}("");
143         require(success, "Address: unable to send value, recipient may have reverted");
144     }
145 
146     /**
147      * @dev Performs a Solidity function call using a low level `call`. A
148      * plain `call` is an unsafe replacement for a function call: use this
149      * function instead.
150      *
151      * If `target` reverts with a revert reason, it is bubbled up by this
152      * function (like regular Solidity function calls).
153      *
154      * Returns the raw returned data. To convert to the expected return value,
155      * use https://solidity.readthedocs.io/en/latest/units-and-global-variables.html?highlight=abi.decode#abi-encoding-and-decoding-functions[`abi.decode`].
156      *
157      * Requirements:
158      *
159      * - `target` must be a contract.
160      * - calling `target` with `data` must not revert.
161      *
162      * _Available since v3.1._
163      */
164     function functionCall(address target, bytes memory data) internal returns (bytes memory) {
165         return functionCall(target, data, "Address: low-level call failed");
166     }
167 
168     /**
169      * @dev Same as {xref-Address-functionCall-address-bytes-}[`functionCall`], but with
170      * `errorMessage` as a fallback revert reason when `target` reverts.
171      *
172      * _Available since v3.1._
173      */
174     function functionCall(
175         address target,
176         bytes memory data,
177         string memory errorMessage
178     ) internal returns (bytes memory) {
179         return functionCallWithValue(target, data, 0, errorMessage);
180     }
181 
182     /**
183      * @dev Same as {xref-Address-functionCall-address-bytes-}[`functionCall`],
184      * but also transferring `value` wei to `target`.
185      *
186      * Requirements:
187      *
188      * - the calling contract must have an ETH balance of at least `value`.
189      * - the called Solidity function must be `payable`.
190      *
191      * _Available since v3.1._
192      */
193     function functionCallWithValue(
194         address target,
195         bytes memory data,
196         uint256 value
197     ) internal returns (bytes memory) {
198         return functionCallWithValue(target, data, value, "Address: low-level call with value failed");
199     }
200 
201     /**
202      * @dev Same as {xref-Address-functionCallWithValue-address-bytes-uint256-}[`functionCallWithValue`], but
203      * with `errorMessage` as a fallback revert reason when `target` reverts.
204      *
205      * _Available since v3.1._
206      */
207     function functionCallWithValue(
208         address target,
209         bytes memory data,
210         uint256 value,
211         string memory errorMessage
212     ) internal returns (bytes memory) {
213         require(address(this).balance >= value, "Address: insufficient balance for call");
214         require(isContract(target), "Address: call to non-contract");
215 
216         (bool success, bytes memory returndata) = target.call{value: value}(data);
217         return _verifyCallResult(success, returndata, errorMessage);
218     }
219 
220     /**
221      * @dev Same as {xref-Address-functionCall-address-bytes-}[`functionCall`],
222      * but performing a static call.
223      *
224      * _Available since v3.3._
225      */
226     function functionStaticCall(address target, bytes memory data) internal view returns (bytes memory) {
227         return functionStaticCall(target, data, "Address: low-level static call failed");
228     }
229 
230     /**
231      * @dev Same as {xref-Address-functionCall-address-bytes-string-}[`functionCall`],
232      * but performing a static call.
233      *
234      * _Available since v3.3._
235      */
236     function functionStaticCall(
237         address target,
238         bytes memory data,
239         string memory errorMessage
240     ) internal view returns (bytes memory) {
241         require(isContract(target), "Address: static call to non-contract");
242 
243         (bool success, bytes memory returndata) = target.staticcall(data);
244         return _verifyCallResult(success, returndata, errorMessage);
245     }
246 
247     /**
248      * @dev Same as {xref-Address-functionCall-address-bytes-}[`functionCall`],
249      * but performing a delegate call.
250      *
251      * _Available since v3.4._
252      */
253     function functionDelegateCall(address target, bytes memory data) internal returns (bytes memory) {
254         return functionDelegateCall(target, data, "Address: low-level delegate call failed");
255     }
256 
257     /**
258      * @dev Same as {xref-Address-functionCall-address-bytes-string-}[`functionCall`],
259      * but performing a delegate call.
260      *
261      * _Available since v3.4._
262      */
263     function functionDelegateCall(
264         address target,
265         bytes memory data,
266         string memory errorMessage
267     ) internal returns (bytes memory) {
268         require(isContract(target), "Address: delegate call to non-contract");
269 
270         (bool success, bytes memory returndata) = target.delegatecall(data);
271         return _verifyCallResult(success, returndata, errorMessage);
272     }
273 
274     function _verifyCallResult(
275         bool success,
276         bytes memory returndata,
277         string memory errorMessage
278     ) private pure returns (bytes memory) {
279         if (success) {
280             return returndata;
281         } else {
282             // Look for revert reason and bubble it up if present
283             if (returndata.length > 0) {
284                 // The easiest way to bubble the revert reason is using memory via assembly
285 
286                 assembly {
287                     let returndata_size := mload(returndata)
288                     revert(add(32, returndata), returndata_size)
289                 }
290             } else {
291                 revert(errorMessage);
292             }
293         }
294     }
295 }
296 
297 // File: contracts/IERC721Receiver.sol
298 
299 
300 
301 pragma solidity ^0.8.0;
302 
303 /**
304  * @title ERC721 token receiver interface
305  * @dev Interface for any contract that wants to support safeTransfers
306  * from ERC721 asset contracts.
307  */
308 interface IERC721Receiver {
309     /**
310      * @dev Whenever an {IERC721} `tokenId` token is transferred to this contract via {IERC721-safeTransferFrom}
311      * by `operator` from `from`, this function is called.
312      *
313      * It must return its Solidity selector to confirm the token transfer.
314      * If any other value is returned or the interface is not implemented by the recipient, the transfer will be reverted.
315      *
316      * The selector can be obtained in Solidity with `IERC721.onERC721Received.selector`.
317      */
318     function onERC721Received(
319         address operator,
320         address from,
321         uint256 tokenId,
322         bytes calldata data
323     ) external returns (bytes4);
324 }
325 
326 // File: contracts/IERC165.sol
327 
328 
329 
330 pragma solidity ^0.8.0;
331 
332 /**
333  * @dev Interface of the ERC165 standard, as defined in the
334  * https://eips.ethereum.org/EIPS/eip-165[EIP].
335  *
336  * Implementers can declare support of contract interfaces, which can then be
337  * queried by others ({ERC165Checker}).
338  *
339  * For an implementation, see {ERC165}.
340  */
341 interface IERC165 {
342     /**
343      * @dev Returns true if this contract implements the interface defined by
344      * `interfaceId`. See the corresponding
345      * https://eips.ethereum.org/EIPS/eip-165#how-interfaces-are-identified[EIP section]
346      * to learn more about how these ids are created.
347      *
348      * This function call must use less than 30 000 gas.
349      */
350     function supportsInterface(bytes4 interfaceId) external view returns (bool);
351 }
352 
353 // File: contracts/ERC165.sol
354 
355 
356 
357 pragma solidity ^0.8.0;
358 
359 
360 /**
361  * @dev Implementation of the {IERC165} interface.
362  *
363  * Contracts that want to implement ERC165 should inherit from this contract and override {supportsInterface} to check
364  * for the additional interface id that will be supported. For example:
365  *
366  * ```solidity
367  * function supportsInterface(bytes4 interfaceId) public view virtual override returns (bool) {
368  *     return interfaceId == type(MyInterface).interfaceId || super.supportsInterface(interfaceId);
369  * }
370  * ```
371  *
372  * Alternatively, {ERC165Storage} provides an easier to use but more expensive implementation.
373  */
374 abstract contract ERC165 is IERC165 {
375     /**
376      * @dev See {IERC165-supportsInterface}.
377      */
378     function supportsInterface(bytes4 interfaceId) public view virtual override returns (bool) {
379         return interfaceId == type(IERC165).interfaceId;
380     }
381 }
382 
383 // File: contracts/IERC721.sol
384 
385 
386 
387 pragma solidity ^0.8.0;
388 
389 
390 /**
391  * @dev Required interface of an ERC721 compliant contract.
392  */
393 interface IERC721 is IERC165 {
394     /**
395      * @dev Emitted when `tokenId` token is transferred from `from` to `to`.
396      */
397     event Transfer(address indexed from, address indexed to, uint256 indexed tokenId);
398 
399     /**
400      * @dev Emitted when `owner` enables `approved` to manage the `tokenId` token.
401      */
402     event Approval(address indexed owner, address indexed approved, uint256 indexed tokenId);
403 
404     /**
405      * @dev Emitted when `owner` enables or disables (`approved`) `operator` to manage all of its assets.
406      */
407     event ApprovalForAll(address indexed owner, address indexed operator, bool approved);
408 
409     /**
410      * @dev Returns the number of tokens in ``owner``'s account.
411      */
412     function balanceOf(address owner) external view returns (uint256 balance);
413 
414     /**
415      * @dev Returns the owner of the `tokenId` token.
416      *
417      * Requirements:
418      *
419      * - `tokenId` must exist.
420      */
421     function ownerOf(uint256 tokenId) external view returns (address owner);
422 
423     /**
424      * @dev Safely transfers `tokenId` token from `from` to `to`, checking first that contract recipients
425      * are aware of the ERC721 protocol to prevent tokens from being forever locked.
426      *
427      * Requirements:
428      *
429      * - `from` cannot be the zero address.
430      * - `to` cannot be the zero address.
431      * - `tokenId` token must exist and be owned by `from`.
432      * - If the caller is not `from`, it must be have been allowed to move this token by either {approve} or {setApprovalForAll}.
433      * - If `to` refers to a smart contract, it must implement {IERC721Receiver-onERC721Received}, which is called upon a safe transfer.
434      *
435      * Emits a {Transfer} event.
436      */
437     function safeTransferFrom(
438         address from,
439         address to,
440         uint256 tokenId
441     ) external;
442 
443     /**
444      * @dev Transfers `tokenId` token from `from` to `to`.
445      *
446      * WARNING: Usage of this method is discouraged, use {safeTransferFrom} whenever possible.
447      *
448      * Requirements:
449      *
450      * - `from` cannot be the zero address.
451      * - `to` cannot be the zero address.
452      * - `tokenId` token must be owned by `from`.
453      * - If the caller is not `from`, it must be approved to move this token by either {approve} or {setApprovalForAll}.
454      *
455      * Emits a {Transfer} event.
456      */
457     function transferFrom(
458         address from,
459         address to,
460         uint256 tokenId
461     ) external;
462 
463     /**
464      * @dev Gives permission to `to` to transfer `tokenId` token to another account.
465      * The approval is cleared when the token is transferred.
466      *
467      * Only a single account can be approved at a time, so approving the zero address clears previous approvals.
468      *
469      * Requirements:
470      *
471      * - The caller must own the token or be an approved operator.
472      * - `tokenId` must exist.
473      *
474      * Emits an {Approval} event.
475      */
476     function approve(address to, uint256 tokenId) external;
477 
478     /**
479      * @dev Returns the account approved for `tokenId` token.
480      *
481      * Requirements:
482      *
483      * - `tokenId` must exist.
484      */
485     function getApproved(uint256 tokenId) external view returns (address operator);
486 
487     /**
488      * @dev Approve or remove `operator` as an operator for the caller.
489      * Operators can call {transferFrom} or {safeTransferFrom} for any token owned by the caller.
490      *
491      * Requirements:
492      *
493      * - The `operator` cannot be the caller.
494      *
495      * Emits an {ApprovalForAll} event.
496      */
497     function setApprovalForAll(address operator, bool _approved) external;
498 
499     /**
500      * @dev Returns if the `operator` is allowed to manage all of the assets of `owner`.
501      *
502      * See {setApprovalForAll}
503      */
504     function isApprovedForAll(address owner, address operator) external view returns (bool);
505 
506     /**
507      * @dev Safely transfers `tokenId` token from `from` to `to`.
508      *
509      * Requirements:
510      *
511      * - `from` cannot be the zero address.
512      * - `to` cannot be the zero address.
513      * - `tokenId` token must exist and be owned by `from`.
514      * - If the caller is not `from`, it must be approved to move this token by either {approve} or {setApprovalForAll}.
515      * - If `to` refers to a smart contract, it must implement {IERC721Receiver-onERC721Received}, which is called upon a safe transfer.
516      *
517      * Emits a {Transfer} event.
518      */
519     function safeTransferFrom(
520         address from,
521         address to,
522         uint256 tokenId,
523         bytes calldata data
524     ) external;
525 }
526 
527 // File: contracts/IERC721Enumerable.sol
528 
529 
530 
531 pragma solidity ^0.8.0;
532 
533 
534 /**
535  * @title ERC-721 Non-Fungible Token Standard, optional enumeration extension
536  * @dev See https://eips.ethereum.org/EIPS/eip-721
537  */
538 interface IERC721Enumerable is IERC721 {
539     /**
540      * @dev Returns the total amount of tokens stored by the contract.
541      */
542     function totalSupply() external view returns (uint256);
543 
544     /**
545      * @dev Returns a token ID owned by `owner` at a given `index` of its token list.
546      * Use along with {balanceOf} to enumerate all of ``owner``'s tokens.
547      */
548     function tokenOfOwnerByIndex(address owner, uint256 index) external view returns (uint256 tokenId);
549 
550     /**
551      * @dev Returns a token ID at a given `index` of all the tokens stored by the contract.
552      * Use along with {totalSupply} to enumerate all tokens.
553      */
554     function tokenByIndex(uint256 index) external view returns (uint256);
555 }
556 
557 // File: contracts/IERC721Metadata.sol
558 
559 
560 
561 pragma solidity ^0.8.0;
562 
563 
564 /**
565  * @title ERC-721 Non-Fungible Token Standard, optional metadata extension
566  * @dev See https://eips.ethereum.org/EIPS/eip-721
567  */
568 interface IERC721Metadata is IERC721 {
569     /**
570      * @dev Returns the token collection name.
571      */
572     function name() external view returns (string memory);
573 
574     /**
575      * @dev Returns the token collection symbol.
576      */
577     function symbol() external view returns (string memory);
578 
579     /**
580      * @dev Returns the Uniform Resource Identifier (URI) for `tokenId` token.
581      */
582     function tokenURI(uint256 tokenId) external view returns (string memory);
583 }
584 
585 // File: contracts/ReentrancyGuard.sol
586 
587 
588 
589 pragma solidity ^0.8.0;
590 
591 /**
592  * @dev Contract module that helps prevent reentrant calls to a function.
593  *
594  * Inheriting from `ReentrancyGuard` will make the {nonReentrant} modifier
595  * available, which can be applied to functions to make sure there are no nested
596  * (reentrant) calls to them.
597  *
598  * Note that because there is a single `nonReentrant` guard, functions marked as
599  * `nonReentrant` may not call one another. This can be worked around by making
600  * those functions `private`, and then adding `external` `nonReentrant` entry
601  * points to them.
602  *
603  * TIP: If you would like to learn more about reentrancy and alternative ways
604  * to protect against it, check out our blog post
605  * https://blog.openzeppelin.com/reentrancy-after-istanbul/[Reentrancy After Istanbul].
606  */
607 abstract contract ReentrancyGuard {
608     // Booleans are more expensive than uint256 or any type that takes up a full
609     // word because each write operation emits an extra SLOAD to first read the
610     // slot's contents, replace the bits taken up by the boolean, and then write
611     // back. This is the compiler's defense against contract upgrades and
612     // pointer aliasing, and it cannot be disabled.
613 
614     // The values being non-zero value makes deployment a bit more expensive,
615     // but in exchange the refund on every call to nonReentrant will be lower in
616     // amount. Since refunds are capped to a percentage of the total
617     // transaction's gas, it is best to keep them low in cases like this one, to
618     // increase the likelihood of the full refund coming into effect.
619     uint256 private constant _NOT_ENTERED = 1;
620     uint256 private constant _ENTERED = 2;
621 
622     uint256 private _status;
623 
624     constructor() {
625         _status = _NOT_ENTERED;
626     }
627 
628     /**
629      * @dev Prevents a contract from calling itself, directly or indirectly.
630      * Calling a `nonReentrant` function from another `nonReentrant`
631      * function is not supported. It is possible to prevent this from happening
632      * by making the `nonReentrant` function external, and make it call a
633      * `private` function that does the actual work.
634      */
635     modifier nonReentrant() {
636         // On the first call to nonReentrant, _notEntered will be true
637         require(_status != _ENTERED, "ReentrancyGuard: reentrant call");
638 
639         // Any calls to nonReentrant after this point will fail
640         _status = _ENTERED;
641 
642         _;
643 
644         // By storing the original value once again, a refund is triggered (see
645         // https://eips.ethereum.org/EIPS/eip-2200)
646         _status = _NOT_ENTERED;
647     }
648 }
649 
650 // File: contracts/Context.sol
651 
652 
653 
654 pragma solidity ^0.8.0;
655 
656 /*
657  * @dev Provides information about the current execution context, including the
658  * sender of the transaction and its data. While these are generally available
659  * via msg.sender and msg.data, they should not be accessed in such a direct
660  * manner, since when dealing with meta-transactions the account sending and
661  * paying for execution may not be the actual sender (as far as an application
662  * is concerned).
663  *
664  * This contract is only required for intermediate, library-like contracts.
665  */
666 abstract contract Context {
667     function _msgSender() internal view virtual returns (address) {
668         return msg.sender;
669     }
670 
671     function _msgData() internal view virtual returns (bytes calldata) {
672         return msg.data;
673     }
674 }
675 
676 // File: contracts/ERC721A.sol
677 
678 
679 
680 pragma solidity ^0.8.0;
681 
682 
683 
684 
685 
686 
687 
688 
689 
690 /**
691  * @dev Implementation of https://eips.ethereum.org/EIPS/eip-721[ERC721] Non-Fungible Token Standard, including
692  * the Metadata and Enumerable extension. Built to optimize for lower gas during batch mints.
693  *
694  * Assumes serials are sequentially minted starting at 0 (e.g. 0, 1, 2, 3..).
695  *
696  * Assumes the number of issuable tokens (collection size) is capped and fits in a uint128.
697  *
698  * Does not support burning tokens to address(0).
699  */
700 contract ERC721A is
701   Context,
702   ERC165,
703   IERC721,
704   IERC721Metadata,
705   IERC721Enumerable
706 {
707   using Address for address;
708   using Strings for uint256;
709 
710   struct TokenOwnership {
711     address addr;
712     uint64 startTimestamp;
713   }
714 
715   struct AddressData {
716     uint128 balance;
717     uint128 numberMinted;
718   }
719 
720   uint256 private currentIndex = 0;
721 
722   uint256 internal immutable collectionSize;
723   uint256 internal immutable maxBatchSize;
724 
725   // Token name
726   string private _name;
727 
728   // Token symbol
729   string private _symbol;
730 
731   // Mapping from token ID to ownership details
732   // An empty struct value does not necessarily mean the token is unowned. See ownershipOf implementation for details.
733   mapping(uint256 => TokenOwnership) private _ownerships;
734 
735   // Mapping owner address to address data
736   mapping(address => AddressData) private _addressData;
737 
738   // Mapping from token ID to approved address
739   mapping(uint256 => address) private _tokenApprovals;
740 
741   // Mapping from owner to operator approvals
742   mapping(address => mapping(address => bool)) private _operatorApprovals;
743 
744   /**
745    * @dev
746    * `maxBatchSize` refers to how much a minter can mint at a time.
747    * `collectionSize_` refers to how many tokens are in the collection.
748    */
749   constructor(
750     string memory name_,
751     string memory symbol_,
752     uint256 maxBatchSize_,
753     uint256 collectionSize_
754   ) {
755     require(
756       collectionSize_ > 0,
757       "ERC721A: collection must have a nonzero supply"
758     );
759     require(maxBatchSize_ > 0, "ERC721A: max batch size must be nonzero");
760     _name = name_;
761     _symbol = symbol_;
762     maxBatchSize = maxBatchSize_;
763     collectionSize = collectionSize_;
764   }
765 
766   /**
767    * @dev See {IERC721Enumerable-totalSupply}.
768    */
769   function totalSupply() public view override returns (uint256) {
770     return currentIndex;
771   }
772 
773   /**
774    * @dev See {IERC721Enumerable-tokenByIndex}.
775    */
776   function tokenByIndex(uint256 index) public view override returns (uint256) {
777     require(index < totalSupply(), "ERC721A: global index out of bounds");
778     return index;
779   }
780 
781   /**
782    * @dev See {IERC721Enumerable-tokenOfOwnerByIndex}.
783    * This read function is O(collectionSize). If calling from a separate contract, be sure to test gas first.
784    * It may also degrade with extremely large collection sizes (e.g >> 10000), test for your use case.
785    */
786   function tokenOfOwnerByIndex(address owner, uint256 index)
787     public
788     view
789     override
790     returns (uint256)
791   {
792     require(index < balanceOf(owner), "ERC721A: owner index out of bounds");
793     uint256 numMintedSoFar = totalSupply();
794     uint256 tokenIdsIdx = 0;
795     address currOwnershipAddr = address(0);
796     for (uint256 i = 0; i < numMintedSoFar; i++) {
797       TokenOwnership memory ownership = _ownerships[i];
798       if (ownership.addr != address(0)) {
799         currOwnershipAddr = ownership.addr;
800       }
801       if (currOwnershipAddr == owner) {
802         if (tokenIdsIdx == index) {
803           return i;
804         }
805         tokenIdsIdx++;
806       }
807     }
808     revert("ERC721A: unable to get token of owner by index");
809   }
810 
811   /**
812    * @dev See {IERC165-supportsInterface}.
813    */
814   function supportsInterface(bytes4 interfaceId)
815     public
816     view
817     virtual
818     override(ERC165, IERC165)
819     returns (bool)
820   {
821     return
822       interfaceId == type(IERC721).interfaceId ||
823       interfaceId == type(IERC721Metadata).interfaceId ||
824       interfaceId == type(IERC721Enumerable).interfaceId ||
825       super.supportsInterface(interfaceId);
826   }
827 
828   /**
829    * @dev See {IERC721-balanceOf}.
830    */
831   function balanceOf(address owner) public view override returns (uint256) {
832     require(owner != address(0), "ERC721A: balance query for the zero address");
833     return uint256(_addressData[owner].balance);
834   }
835 
836   function _numberMinted(address owner) internal view returns (uint256) {
837     require(
838       owner != address(0),
839       "ERC721A: number minted query for the zero address"
840     );
841     return uint256(_addressData[owner].numberMinted);
842   }
843 
844   function ownershipOf(uint256 tokenId)
845     internal
846     view
847     returns (TokenOwnership memory)
848   {
849     require(_exists(tokenId), "ERC721A: owner query for nonexistent token");
850 
851     uint256 lowestTokenToCheck;
852     if (tokenId >= maxBatchSize) {
853       lowestTokenToCheck = tokenId - maxBatchSize + 1;
854     }
855 
856     for (uint256 curr = tokenId; curr >= lowestTokenToCheck; curr--) {
857       TokenOwnership memory ownership = _ownerships[curr];
858       if (ownership.addr != address(0)) {
859         return ownership;
860       }
861     }
862 
863     revert("ERC721A: unable to determine the owner of token");
864   }
865 
866   /**
867    * @dev See {IERC721-ownerOf}.
868    */
869   function ownerOf(uint256 tokenId) public view override returns (address) {
870     return ownershipOf(tokenId).addr;
871   }
872 
873   /**
874    * @dev See {IERC721Metadata-name}.
875    */
876   function name() public view virtual override returns (string memory) {
877     return _name;
878   }
879 
880   /**
881    * @dev See {IERC721Metadata-symbol}.
882    */
883   function symbol() public view virtual override returns (string memory) {
884     return _symbol;
885   }
886 
887   /**
888    * @dev See {IERC721Metadata-tokenURI}.
889    */
890   function tokenURI(uint256 tokenId)
891     public
892     view
893     virtual
894     override
895     returns (string memory)
896   {
897     require(
898       _exists(tokenId),
899       "ERC721Metadata: URI query for nonexistent token"
900     );
901 
902     string memory baseURI = _baseURI();
903     return
904       bytes(baseURI).length > 0
905         ? string(abi.encodePacked(baseURI, tokenId.toString()))
906         : "";
907   }
908 
909   /**
910    * @dev Base URI for computing {tokenURI}. If set, the resulting URI for each
911    * token will be the concatenation of the `baseURI` and the `tokenId`. Empty
912    * by default, can be overriden in child contracts.
913    */
914   function _baseURI() internal view virtual returns (string memory) {
915     return "";
916   }
917 
918   /**
919    * @dev See {IERC721-approve}.
920    */
921   function approve(address to, uint256 tokenId) public override {
922     address owner = ERC721A.ownerOf(tokenId);
923     require(to != owner, "ERC721A: approval to current owner");
924 
925     require(
926       _msgSender() == owner || isApprovedForAll(owner, _msgSender()),
927       "ERC721A: approve caller is not owner nor approved for all"
928     );
929 
930     _approve(to, tokenId, owner);
931   }
932 
933   /**
934    * @dev See {IERC721-getApproved}.
935    */
936   function getApproved(uint256 tokenId) public view override returns (address) {
937     require(_exists(tokenId), "ERC721A: approved query for nonexistent token");
938 
939     return _tokenApprovals[tokenId];
940   }
941 
942   /**
943    * @dev See {IERC721-setApprovalForAll}.
944    */
945   function setApprovalForAll(address operator, bool approved) public override {
946     require(operator != _msgSender(), "ERC721A: approve to caller");
947 
948     _operatorApprovals[_msgSender()][operator] = approved;
949     emit ApprovalForAll(_msgSender(), operator, approved);
950   }
951 
952   /**
953    * @dev See {IERC721-isApprovedForAll}.
954    */
955   function isApprovedForAll(address owner, address operator)
956     public
957     view
958     virtual
959     override
960     returns (bool)
961   {
962     return _operatorApprovals[owner][operator];
963   }
964 
965   /**
966    * @dev See {IERC721-transferFrom}.
967    */
968   function transferFrom(
969     address from,
970     address to,
971     uint256 tokenId
972   ) public override {
973     _transfer(from, to, tokenId);
974   }
975 
976   /**
977    * @dev See {IERC721-safeTransferFrom}.
978    */
979   function safeTransferFrom(
980     address from,
981     address to,
982     uint256 tokenId
983   ) public override {
984     safeTransferFrom(from, to, tokenId, "");
985   }
986 
987   /**
988    * @dev See {IERC721-safeTransferFrom}.
989    */
990   function safeTransferFrom(
991     address from,
992     address to,
993     uint256 tokenId,
994     bytes memory _data
995   ) public override {
996     _transfer(from, to, tokenId);
997     require(
998       _checkOnERC721Received(from, to, tokenId, _data),
999       "ERC721A: transfer to non ERC721Receiver implementer"
1000     );
1001   }
1002 
1003   /**
1004    * @dev Returns whether `tokenId` exists.
1005    *
1006    * Tokens can be managed by their owner or approved accounts via {approve} or {setApprovalForAll}.
1007    *
1008    * Tokens start existing when they are minted (`_mint`),
1009    */
1010   function _exists(uint256 tokenId) internal view returns (bool) {
1011     return tokenId < currentIndex;
1012   }
1013 
1014   function _safeMint(address to, uint256 quantity) internal {
1015     _safeMint(to, quantity, "");
1016   }
1017 
1018   /**
1019    * @dev Mints `quantity` tokens and transfers them to `to`.
1020    *
1021    * Requirements:
1022    *
1023    * - there must be `quantity` tokens remaining unminted in the total collection.
1024    * - `to` cannot be the zero address.
1025    * - `quantity` cannot be larger than the max batch size.
1026    *
1027    * Emits a {Transfer} event.
1028    */
1029   function _safeMint(
1030     address to,
1031     uint256 quantity,
1032     bytes memory _data
1033   ) internal {
1034     uint256 startTokenId = currentIndex;
1035     require(to != address(0), "ERC721A: mint to the zero address");
1036     // We know if the first token in the batch doesn't exist, the other ones don't as well, because of serial ordering.
1037     require(!_exists(startTokenId), "ERC721A: token already minted");
1038     require(quantity <= maxBatchSize, "ERC721A: quantity to mint too high");
1039 
1040     _beforeTokenTransfers(address(0), to, startTokenId, quantity);
1041 
1042     AddressData memory addressData = _addressData[to];
1043     _addressData[to] = AddressData(
1044       addressData.balance + uint128(quantity),
1045       addressData.numberMinted + uint128(quantity)
1046     );
1047     _ownerships[startTokenId] = TokenOwnership(to, uint64(block.timestamp));
1048 
1049     uint256 updatedIndex = startTokenId;
1050 
1051     for (uint256 i = 0; i < quantity; i++) {
1052       emit Transfer(address(0), to, updatedIndex);
1053       require(
1054         _checkOnERC721Received(address(0), to, updatedIndex, _data),
1055         "ERC721A: transfer to non ERC721Receiver implementer"
1056       );
1057       updatedIndex++;
1058     }
1059 
1060     currentIndex = updatedIndex;
1061     _afterTokenTransfers(address(0), to, startTokenId, quantity);
1062   }
1063 
1064   /**
1065    * @dev Transfers `tokenId` from `from` to `to`.
1066    *
1067    * Requirements:
1068    *
1069    * - `to` cannot be the zero address.
1070    * - `tokenId` token must be owned by `from`.
1071    *
1072    * Emits a {Transfer} event.
1073    */
1074   function _transfer(
1075     address from,
1076     address to,
1077     uint256 tokenId
1078   ) private {
1079     TokenOwnership memory prevOwnership = ownershipOf(tokenId);
1080 
1081     bool isApprovedOrOwner = (_msgSender() == prevOwnership.addr ||
1082       getApproved(tokenId) == _msgSender() ||
1083       isApprovedForAll(prevOwnership.addr, _msgSender()));
1084 
1085     require(
1086       isApprovedOrOwner,
1087       "ERC721A: transfer caller is not owner nor approved"
1088     );
1089 
1090     require(
1091       prevOwnership.addr == from,
1092       "ERC721A: transfer from incorrect owner"
1093     );
1094     require(to != address(0), "ERC721A: transfer to the zero address");
1095 
1096     _beforeTokenTransfers(from, to, tokenId, 1);
1097 
1098     // Clear approvals from the previous owner
1099     _approve(address(0), tokenId, prevOwnership.addr);
1100 
1101     _addressData[from].balance -= 1;
1102     _addressData[to].balance += 1;
1103     _ownerships[tokenId] = TokenOwnership(to, uint64(block.timestamp));
1104 
1105     // If the ownership slot of tokenId+1 is not explicitly set, that means the transfer initiator owns it.
1106     // Set the slot of tokenId+1 explicitly in storage to maintain correctness for ownerOf(tokenId+1) calls.
1107     uint256 nextTokenId = tokenId + 1;
1108     if (_ownerships[nextTokenId].addr == address(0)) {
1109       if (_exists(nextTokenId)) {
1110         _ownerships[nextTokenId] = TokenOwnership(
1111           prevOwnership.addr,
1112           prevOwnership.startTimestamp
1113         );
1114       }
1115     }
1116 
1117     emit Transfer(from, to, tokenId);
1118     _afterTokenTransfers(from, to, tokenId, 1);
1119   }
1120 
1121   /**
1122    * @dev Approve `to` to operate on `tokenId`
1123    *
1124    * Emits a {Approval} event.
1125    */
1126   function _approve(
1127     address to,
1128     uint256 tokenId,
1129     address owner
1130   ) private {
1131     _tokenApprovals[tokenId] = to;
1132     emit Approval(owner, to, tokenId);
1133   }
1134 
1135   uint256 public nextOwnerToExplicitlySet = 0;
1136 
1137   /**
1138    * @dev Explicitly set `owners` to eliminate loops in future calls of ownerOf().
1139    */
1140   function _setOwnersExplicit(uint256 quantity) internal {
1141     uint256 oldNextOwnerToSet = nextOwnerToExplicitlySet;
1142     require(quantity > 0, "quantity must be nonzero");
1143     uint256 endIndex = oldNextOwnerToSet + quantity - 1;
1144     if (endIndex > collectionSize - 1) {
1145       endIndex = collectionSize - 1;
1146     }
1147     // We know if the last one in the group exists, all in the group exist, due to serial ordering.
1148     require(_exists(endIndex), "not enough minted yet for this cleanup");
1149     for (uint256 i = oldNextOwnerToSet; i <= endIndex; i++) {
1150       if (_ownerships[i].addr == address(0)) {
1151         TokenOwnership memory ownership = ownershipOf(i);
1152         _ownerships[i] = TokenOwnership(
1153           ownership.addr,
1154           ownership.startTimestamp
1155         );
1156       }
1157     }
1158     nextOwnerToExplicitlySet = endIndex + 1;
1159   }
1160 
1161   /**
1162    * @dev Internal function to invoke {IERC721Receiver-onERC721Received} on a target address.
1163    * The call is not executed if the target address is not a contract.
1164    *
1165    * @param from address representing the previous owner of the given token ID
1166    * @param to target address that will receive the tokens
1167    * @param tokenId uint256 ID of the token to be transferred
1168    * @param _data bytes optional data to send along with the call
1169    * @return bool whether the call correctly returned the expected magic value
1170    */
1171   function _checkOnERC721Received(
1172     address from,
1173     address to,
1174     uint256 tokenId,
1175     bytes memory _data
1176   ) private returns (bool) {
1177     if (to.isContract()) {
1178       try
1179         IERC721Receiver(to).onERC721Received(_msgSender(), from, tokenId, _data)
1180       returns (bytes4 retval) {
1181         return retval == IERC721Receiver(to).onERC721Received.selector;
1182       } catch (bytes memory reason) {
1183         if (reason.length == 0) {
1184           revert("ERC721A: transfer to non ERC721Receiver implementer");
1185         } else {
1186           assembly {
1187             revert(add(32, reason), mload(reason))
1188           }
1189         }
1190       }
1191     } else {
1192       return true;
1193     }
1194   }
1195 
1196   /**
1197    * @dev Hook that is called before a set of serially-ordered token ids are about to be transferred. This includes minting.
1198    *
1199    * startTokenId - the first token id to be transferred
1200    * quantity - the amount to be transferred
1201    *
1202    * Calling conditions:
1203    *
1204    * - When `from` and `to` are both non-zero, ``from``'s `tokenId` will be
1205    * transferred to `to`.
1206    * - When `from` is zero, `tokenId` will be minted for `to`.
1207    */
1208   function _beforeTokenTransfers(
1209     address from,
1210     address to,
1211     uint256 startTokenId,
1212     uint256 quantity
1213   ) internal virtual {}
1214 
1215   /**
1216    * @dev Hook that is called after a set of serially-ordered token ids have been transferred. This includes
1217    * minting.
1218    *
1219    * startTokenId - the first token id to be transferred
1220    * quantity - the amount to be transferred
1221    *
1222    * Calling conditions:
1223    *
1224    * - when `from` and `to` are both non-zero.
1225    * - `from` and `to` are never both zero.
1226    */
1227   function _afterTokenTransfers(
1228     address from,
1229     address to,
1230     uint256 startTokenId,
1231     uint256 quantity
1232   ) internal virtual {}
1233 }
1234 
1235 // File: contracts/Ownable.sol
1236 
1237 
1238 
1239 pragma solidity ^0.8.0;
1240 
1241 
1242 /**
1243  * @dev Contract module which provides a basic access control mechanism, where
1244  * there is an account (an owner) that can be granted exclusive access to
1245  * specific functions.
1246  *
1247  * By default, the owner account will be the one that deploys the contract. This
1248  * can later be changed with {transferOwnership}.
1249  *
1250  * This module is used through inheritance. It will make available the modifier
1251  * `onlyOwner`, which can be applied to your functions to restrict their use to
1252  * the owner.
1253  */
1254 abstract contract Ownable is Context {
1255     address private _owner;
1256 
1257     event OwnershipTransferred(address indexed previousOwner, address indexed newOwner);
1258 
1259     /**
1260      * @dev Initializes the contract setting the deployer as the initial owner.
1261      */
1262     constructor() {
1263         _setOwner(_msgSender());
1264     }
1265 
1266     /**
1267      * @dev Returns the address of the current owner.
1268      */
1269     function owner() public view virtual returns (address) {
1270         return _owner;
1271     }
1272 
1273     /**
1274      * @dev Throws if called by any account other than the owner.
1275      */
1276     modifier onlyOwner() {
1277         require(owner() == _msgSender(), "Ownable: caller is not the owner");
1278         _;
1279     }
1280 
1281     /**
1282      * @dev Leaves the contract without owner. It will not be possible to call
1283      * `onlyOwner` functions anymore. Can only be called by the current owner.
1284      *
1285      * NOTE: Renouncing ownership will leave the contract without an owner,
1286      * thereby removing any functionality that is only available to the owner.
1287      */
1288     function renounceOwnership() public virtual onlyOwner {
1289         _setOwner(address(0));
1290     }
1291 
1292     /**
1293      * @dev Transfers ownership of the contract to a new account (`newOwner`).
1294      * Can only be called by the current owner.
1295      */
1296     function transferOwnership(address newOwner) public virtual onlyOwner {
1297         require(newOwner != address(0), "Ownable: new owner is the zero address");
1298         _setOwner(newOwner);
1299     }
1300 
1301     function _setOwner(address newOwner) private {
1302         address oldOwner = _owner;
1303         _owner = newOwner;
1304         emit OwnershipTransferred(oldOwner, newOwner);
1305     }
1306 }
1307 
1308 // File: contracts/MajPo.sol
1309 
1310 
1311 
1312 pragma solidity ^0.8.0;
1313 
1314 
1315 
1316 
1317 
1318 contract MajPo is Ownable, ERC721A, ReentrancyGuard {
1319   uint256 public immutable maxPerAddressDuringMint;
1320   uint256 public immutable amountForDevs;
1321   uint256 public immutable amountForFree;
1322   uint256 public mintPrice = 0; //0.05 ETH
1323   uint256 public listPrice = 0; //0.05 ETH
1324 
1325   mapping(address => uint256) public allowlist;
1326 
1327   constructor(
1328     uint256 maxBatchSize_,
1329     uint256 collectionSize_,
1330     uint256 amountForDevs_,
1331     uint256 amountForFree_
1332   ) ERC721A("Maj Po", "MAJPO", maxBatchSize_, collectionSize_) {
1333     maxPerAddressDuringMint = maxBatchSize_;
1334     amountForDevs = amountForDevs_;
1335     amountForFree = amountForFree_;
1336   }
1337 
1338   modifier callerIsUser() {
1339     require(tx.origin == msg.sender, "The caller is another contract");
1340     _;
1341   }
1342 
1343   function freeMint(uint256 quantity) external callerIsUser {
1344 
1345     require(totalSupply() + quantity <= amountForFree, "reached max supply");
1346     require(
1347       numberMinted(msg.sender) + quantity <= maxPerAddressDuringMint,
1348       "can not mint this many"
1349     );
1350     _safeMint(msg.sender, quantity);
1351   }
1352 
1353   function paidMint(uint256 quantity)
1354     external
1355     payable
1356     callerIsUser
1357   {
1358     uint256 publicPrice = mintPrice;
1359 
1360     require(
1361       isPublicSaleOn(publicPrice),
1362       "public sale has not begun yet"
1363     );
1364     require(totalSupply() + quantity <= collectionSize, "reached max supply");
1365     require(
1366       numberMinted(msg.sender) + quantity <= maxPerAddressDuringMint,
1367       "can not mint this many"
1368     );
1369     _safeMint(msg.sender, quantity);
1370     refundIfOver(publicPrice * quantity);
1371   }
1372 
1373   function refundIfOver(uint256 price) private {
1374     require(msg.value >= price, "Need to send more ETH.");
1375     if (msg.value > price) {
1376       payable(msg.sender).transfer(msg.value - price);
1377     }
1378   }
1379 
1380   function isPublicSaleOn(
1381     uint256 publicPriceWei
1382   ) public view returns (bool) {
1383     return
1384       publicPriceWei != 0 ;
1385   }
1386 
1387 
1388   function seedAllowlist(address[] memory addresses, uint256[] memory numSlots)
1389     external
1390     onlyOwner
1391   {
1392     require(
1393       addresses.length == numSlots.length,
1394       "addresses does not match numSlots length"
1395     );
1396     for (uint256 i = 0; i < addresses.length; i++) {
1397       allowlist[addresses[i]] = numSlots[i];
1398     }
1399   }
1400 
1401   // For marketing etc.
1402   function devMint(uint256 quantity) external onlyOwner {
1403     require(
1404       totalSupply() + quantity <= amountForDevs,
1405       "too many already minted before dev mint"
1406     );
1407     require(
1408       quantity % maxBatchSize == 0,
1409       "can only mint a multiple of the maxBatchSize"
1410     );
1411     uint256 numChunks = quantity / maxBatchSize;
1412     for (uint256 i = 0; i < numChunks; i++) {
1413       _safeMint(msg.sender, maxBatchSize);
1414     }
1415   }
1416 
1417   // // metadata URI
1418   string private _baseTokenURI;
1419 
1420   function _baseURI() internal view virtual override returns (string memory) {
1421     return _baseTokenURI;
1422   }
1423 
1424   function setBaseURI(string calldata baseURI) external onlyOwner {
1425     _baseTokenURI = baseURI;
1426   }
1427 
1428   function withdrawMoney() external onlyOwner nonReentrant {
1429     (bool success, ) = msg.sender.call{value: address(this).balance}("");
1430     require(success, "Transfer failed.");
1431   }
1432 
1433   function setOwnersExplicit(uint256 quantity) external onlyOwner nonReentrant {
1434     _setOwnersExplicit(quantity);
1435   }
1436 
1437   function numberMinted(address owner) public view returns (uint256) {
1438     return _numberMinted(owner);
1439   }
1440 
1441   function getOwnershipData(uint256 tokenId)
1442     external
1443     view
1444     returns (TokenOwnership memory)
1445   {
1446     return ownershipOf(tokenId);
1447   }
1448 
1449   function setListPrice(uint256 newPrice) public onlyOwner {
1450       listPrice = newPrice;
1451   }
1452 
1453   function setMintPrice(uint256 newPrice) public onlyOwner {
1454       mintPrice = newPrice;
1455   }
1456 }