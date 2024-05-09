1 // File: @openzeppelin/contracts/utils/Strings.sol
2 
3 
4 // OpenZeppelin Contracts v4.4.1 (utils/Strings.sol)
5 
6 pragma solidity ^0.8.0;
7 
8 /**
9  * @dev String operations.
10  */
11 library Strings {
12     bytes16 private constant _HEX_SYMBOLS = "0123456789abcdef";
13 
14     /**
15      * @dev Converts a `uint256` to its ASCII `string` decimal representation.
16      */
17     function toString(uint256 value) internal pure returns (string memory) {
18         // Inspired by OraclizeAPI's implementation - MIT licence
19         // https://github.com/oraclize/ethereum-api/blob/b42146b063c7d6ee1358846c198246239e9360e8/oraclizeAPI_0.4.25.sol
20 
21         if (value == 0) {
22             return "0";
23         }
24         uint256 temp = value;
25         uint256 digits;
26         while (temp != 0) {
27             digits++;
28             temp /= 10;
29         }
30         bytes memory buffer = new bytes(digits);
31         while (value != 0) {
32             digits -= 1;
33             buffer[digits] = bytes1(uint8(48 + uint256(value % 10)));
34             value /= 10;
35         }
36         return string(buffer);
37     }
38 
39     /**
40      * @dev Converts a `uint256` to its ASCII `string` hexadecimal representation.
41      */
42     function toHexString(uint256 value) internal pure returns (string memory) {
43         if (value == 0) {
44             return "0x00";
45         }
46         uint256 temp = value;
47         uint256 length = 0;
48         while (temp != 0) {
49             length++;
50             temp >>= 8;
51         }
52         return toHexString(value, length);
53     }
54 
55     /**
56      * @dev Converts a `uint256` to its ASCII `string` hexadecimal representation with fixed length.
57      */
58     function toHexString(uint256 value, uint256 length) internal pure returns (string memory) {
59         bytes memory buffer = new bytes(2 * length + 2);
60         buffer[0] = "0";
61         buffer[1] = "x";
62         for (uint256 i = 2 * length + 1; i > 1; --i) {
63             buffer[i] = _HEX_SYMBOLS[value & 0xf];
64             value >>= 4;
65         }
66         require(value == 0, "Strings: hex length insufficient");
67         return string(buffer);
68     }
69 }
70 
71 // File: @openzeppelin/contracts/utils/Address.sol
72 
73 
74 // OpenZeppelin Contracts v4.4.1 (utils/Address.sol)
75 
76 pragma solidity ^0.8.0;
77 
78 /**
79  * @dev Collection of functions related to the address type
80  */
81 library Address {
82     /**
83      * @dev Returns true if `account` is a contract.
84      *
85      * [IMPORTANT]
86      * ====
87      * It is unsafe to assume that an address for which this function returns
88      * false is an externally-owned account (EOA) and not a contract.
89      *
90      * Among others, `isContract` will return false for the following
91      * types of addresses:
92      *
93      *  - an externally-owned account
94      *  - a contract in construction
95      *  - an address where a contract will be created
96      *  - an address where a contract lived, but was destroyed
97      * ====
98      */
99     function isContract(address account) internal view returns (bool) {
100         // This method relies on extcodesize, which returns 0 for contracts in
101         // construction, since the code is only stored at the end of the
102         // constructor execution.
103 
104         uint256 size;
105         assembly {
106             size := extcodesize(account)
107         }
108         return size > 0;
109     }
110 
111     /**
112      * @dev Replacement for Solidity's `transfer`: sends `amount` wei to
113      * `recipient`, forwarding all available gas and reverting on errors.
114      *
115      * https://eips.ethereum.org/EIPS/eip-1884[EIP1884] increases the gas cost
116      * of certain opcodes, possibly making contracts go over the 2300 gas limit
117      * imposed by `transfer`, making them unable to receive funds via
118      * `transfer`. {sendValue} removes this limitation.
119      *
120      * https://diligence.consensys.net/posts/2019/09/stop-using-soliditys-transfer-now/[Learn more].
121      *
122      * IMPORTANT: because control is transferred to `recipient`, care must be
123      * taken to not create reentrancy vulnerabilities. Consider using
124      * {ReentrancyGuard} or the
125      * https://solidity.readthedocs.io/en/v0.5.11/security-considerations.html#use-the-checks-effects-interactions-pattern[checks-effects-interactions pattern].
126      */
127     function sendValue(address payable recipient, uint256 amount) internal {
128         require(address(this).balance >= amount, "Address: insufficient balance");
129 
130         (bool success, ) = recipient.call{value: amount}("");
131         require(success, "Address: unable to send value, recipient may have reverted");
132     }
133 
134     /**
135      * @dev Performs a Solidity function call using a low level `call`. A
136      * plain `call` is an unsafe replacement for a function call: use this
137      * function instead.
138      *
139      * If `target` reverts with a revert reason, it is bubbled up by this
140      * function (like regular Solidity function calls).
141      *
142      * Returns the raw returned data. To convert to the expected return value,
143      * use https://solidity.readthedocs.io/en/latest/units-and-global-variables.html?highlight=abi.decode#abi-encoding-and-decoding-functions[`abi.decode`].
144      *
145      * Requirements:
146      *
147      * - `target` must be a contract.
148      * - calling `target` with `data` must not revert.
149      *
150      * _Available since v3.1._
151      */
152     function functionCall(address target, bytes memory data) internal returns (bytes memory) {
153         return functionCall(target, data, "Address: low-level call failed");
154     }
155 
156     /**
157      * @dev Same as {xref-Address-functionCall-address-bytes-}[`functionCall`], but with
158      * `errorMessage` as a fallback revert reason when `target` reverts.
159      *
160      * _Available since v3.1._
161      */
162     function functionCall(
163         address target,
164         bytes memory data,
165         string memory errorMessage
166     ) internal returns (bytes memory) {
167         return functionCallWithValue(target, data, 0, errorMessage);
168     }
169 
170     /**
171      * @dev Same as {xref-Address-functionCall-address-bytes-}[`functionCall`],
172      * but also transferring `value` wei to `target`.
173      *
174      * Requirements:
175      *
176      * - the calling contract must have an ETH balance of at least `value`.
177      * - the called Solidity function must be `payable`.
178      *
179      * _Available since v3.1._
180      */
181     function functionCallWithValue(
182         address target,
183         bytes memory data,
184         uint256 value
185     ) internal returns (bytes memory) {
186         return functionCallWithValue(target, data, value, "Address: low-level call with value failed");
187     }
188 
189     /**
190      * @dev Same as {xref-Address-functionCallWithValue-address-bytes-uint256-}[`functionCallWithValue`], but
191      * with `errorMessage` as a fallback revert reason when `target` reverts.
192      *
193      * _Available since v3.1._
194      */
195     function functionCallWithValue(
196         address target,
197         bytes memory data,
198         uint256 value,
199         string memory errorMessage
200     ) internal returns (bytes memory) {
201         require(address(this).balance >= value, "Address: insufficient balance for call");
202         require(isContract(target), "Address: call to non-contract");
203 
204         (bool success, bytes memory returndata) = target.call{value: value}(data);
205         return verifyCallResult(success, returndata, errorMessage);
206     }
207 
208     /**
209      * @dev Same as {xref-Address-functionCall-address-bytes-}[`functionCall`],
210      * but performing a static call.
211      *
212      * _Available since v3.3._
213      */
214     function functionStaticCall(address target, bytes memory data) internal view returns (bytes memory) {
215         return functionStaticCall(target, data, "Address: low-level static call failed");
216     }
217 
218     /**
219      * @dev Same as {xref-Address-functionCall-address-bytes-string-}[`functionCall`],
220      * but performing a static call.
221      *
222      * _Available since v3.3._
223      */
224     function functionStaticCall(
225         address target,
226         bytes memory data,
227         string memory errorMessage
228     ) internal view returns (bytes memory) {
229         require(isContract(target), "Address: static call to non-contract");
230 
231         (bool success, bytes memory returndata) = target.staticcall(data);
232         return verifyCallResult(success, returndata, errorMessage);
233     }
234 
235     /**
236      * @dev Same as {xref-Address-functionCall-address-bytes-}[`functionCall`],
237      * but performing a delegate call.
238      *
239      * _Available since v3.4._
240      */
241     function functionDelegateCall(address target, bytes memory data) internal returns (bytes memory) {
242         return functionDelegateCall(target, data, "Address: low-level delegate call failed");
243     }
244 
245     /**
246      * @dev Same as {xref-Address-functionCall-address-bytes-string-}[`functionCall`],
247      * but performing a delegate call.
248      *
249      * _Available since v3.4._
250      */
251     function functionDelegateCall(
252         address target,
253         bytes memory data,
254         string memory errorMessage
255     ) internal returns (bytes memory) {
256         require(isContract(target), "Address: delegate call to non-contract");
257 
258         (bool success, bytes memory returndata) = target.delegatecall(data);
259         return verifyCallResult(success, returndata, errorMessage);
260     }
261 
262     /**
263      * @dev Tool to verifies that a low level call was successful, and revert if it wasn't, either by bubbling the
264      * revert reason using the provided one.
265      *
266      * _Available since v4.3._
267      */
268     function verifyCallResult(
269         bool success,
270         bytes memory returndata,
271         string memory errorMessage
272     ) internal pure returns (bytes memory) {
273         if (success) {
274             return returndata;
275         } else {
276             // Look for revert reason and bubble it up if present
277             if (returndata.length > 0) {
278                 // The easiest way to bubble the revert reason is using memory via assembly
279 
280                 assembly {
281                     let returndata_size := mload(returndata)
282                     revert(add(32, returndata), returndata_size)
283                 }
284             } else {
285                 revert(errorMessage);
286             }
287         }
288     }
289 }
290 
291 // File: @openzeppelin/contracts/token/ERC721/IERC721Receiver.sol
292 
293 
294 // OpenZeppelin Contracts v4.4.1 (token/ERC721/IERC721Receiver.sol)
295 
296 pragma solidity ^0.8.0;
297 
298 /**
299  * @title ERC721 token receiver interface
300  * @dev Interface for any contract that wants to support safeTransfers
301  * from ERC721 asset contracts.
302  */
303 interface IERC721Receiver {
304     /**
305      * @dev Whenever an {IERC721} `tokenId` token is transferred to this contract via {IERC721-safeTransferFrom}
306      * by `operator` from `from`, this function is called.
307      *
308      * It must return its Solidity selector to confirm the token transfer.
309      * If any other value is returned or the interface is not implemented by the recipient, the transfer will be reverted.
310      *
311      * The selector can be obtained in Solidity with `IERC721.onERC721Received.selector`.
312      */
313     function onERC721Received(
314         address operator,
315         address from,
316         uint256 tokenId,
317         bytes calldata data
318     ) external returns (bytes4);
319 }
320 
321 // File: @openzeppelin/contracts/utils/introspection/IERC165.sol
322 
323 
324 // OpenZeppelin Contracts v4.4.1 (utils/introspection/IERC165.sol)
325 
326 pragma solidity ^0.8.0;
327 
328 /**
329  * @dev Interface of the ERC165 standard, as defined in the
330  * https://eips.ethereum.org/EIPS/eip-165[EIP].
331  *
332  * Implementers can declare support of contract interfaces, which can then be
333  * queried by others ({ERC165Checker}).
334  *
335  * For an implementation, see {ERC165}.
336  */
337 interface IERC165 {
338     /**
339      * @dev Returns true if this contract implements the interface defined by
340      * `interfaceId`. See the corresponding
341      * https://eips.ethereum.org/EIPS/eip-165#how-interfaces-are-identified[EIP section]
342      * to learn more about how these ids are created.
343      *
344      * This function call must use less than 30 000 gas.
345      */
346     function supportsInterface(bytes4 interfaceId) external view returns (bool);
347 }
348 
349 // File: @openzeppelin/contracts/utils/introspection/ERC165.sol
350 
351 
352 // OpenZeppelin Contracts v4.4.1 (utils/introspection/ERC165.sol)
353 
354 pragma solidity ^0.8.0;
355 
356 
357 /**
358  * @dev Implementation of the {IERC165} interface.
359  *
360  * Contracts that want to implement ERC165 should inherit from this contract and override {supportsInterface} to check
361  * for the additional interface id that will be supported. For example:
362  *
363  * ```solidity
364  * function supportsInterface(bytes4 interfaceId) public view virtual override returns (bool) {
365  *     return interfaceId == type(MyInterface).interfaceId || super.supportsInterface(interfaceId);
366  * }
367  * ```
368  *
369  * Alternatively, {ERC165Storage} provides an easier to use but more expensive implementation.
370  */
371 abstract contract ERC165 is IERC165 {
372     /**
373      * @dev See {IERC165-supportsInterface}.
374      */
375     function supportsInterface(bytes4 interfaceId) public view virtual override returns (bool) {
376         return interfaceId == type(IERC165).interfaceId;
377     }
378 }
379 
380 // File: @openzeppelin/contracts/token/ERC721/IERC721.sol
381 
382 
383 // OpenZeppelin Contracts v4.4.1 (token/ERC721/IERC721.sol)
384 
385 pragma solidity ^0.8.0;
386 
387 
388 /**
389  * @dev Required interface of an ERC721 compliant contract.
390  */
391 interface IERC721 is IERC165 {
392     /**
393      * @dev Emitted when `tokenId` token is transferred from `from` to `to`.
394      */
395     event Transfer(address indexed from, address indexed to, uint256 indexed tokenId);
396 
397     /**
398      * @dev Emitted when `owner` enables `approved` to manage the `tokenId` token.
399      */
400     event Approval(address indexed owner, address indexed approved, uint256 indexed tokenId);
401 
402     /**
403      * @dev Emitted when `owner` enables or disables (`approved`) `operator` to manage all of its assets.
404      */
405     event ApprovalForAll(address indexed owner, address indexed operator, bool approved);
406 
407     /**
408      * @dev Returns the number of tokens in ``owner``'s account.
409      */
410     function balanceOf(address owner) external view returns (uint256 balance);
411 
412     /**
413      * @dev Returns the owner of the `tokenId` token.
414      *
415      * Requirements:
416      *
417      * - `tokenId` must exist.
418      */
419     function ownerOf(uint256 tokenId) external view returns (address owner);
420 
421     /**
422      * @dev Safely transfers `tokenId` token from `from` to `to`, checking first that contract recipients
423      * are aware of the ERC721 protocol to prevent tokens from being forever locked.
424      *
425      * Requirements:
426      *
427      * - `from` cannot be the zero address.
428      * - `to` cannot be the zero address.
429      * - `tokenId` token must exist and be owned by `from`.
430      * - If the caller is not `from`, it must be have been allowed to move this token by either {approve} or {setApprovalForAll}.
431      * - If `to` refers to a smart contract, it must implement {IERC721Receiver-onERC721Received}, which is called upon a safe transfer.
432      *
433      * Emits a {Transfer} event.
434      */
435     function safeTransferFrom(
436         address from,
437         address to,
438         uint256 tokenId
439     ) external;
440 
441     /**
442      * @dev Transfers `tokenId` token from `from` to `to`.
443      *
444      * WARNING: Usage of this method is discouraged, use {safeTransferFrom} whenever possible.
445      *
446      * Requirements:
447      *
448      * - `from` cannot be the zero address.
449      * - `to` cannot be the zero address.
450      * - `tokenId` token must be owned by `from`.
451      * - If the caller is not `from`, it must be approved to move this token by either {approve} or {setApprovalForAll}.
452      *
453      * Emits a {Transfer} event.
454      */
455     function transferFrom(
456         address from,
457         address to,
458         uint256 tokenId
459     ) external;
460 
461     /**
462      * @dev Gives permission to `to` to transfer `tokenId` token to another account.
463      * The approval is cleared when the token is transferred.
464      *
465      * Only a single account can be approved at a time, so approving the zero address clears previous approvals.
466      *
467      * Requirements:
468      *
469      * - The caller must own the token or be an approved operator.
470      * - `tokenId` must exist.
471      *
472      * Emits an {Approval} event.
473      */
474     function approve(address to, uint256 tokenId) external;
475 
476     /**
477      * @dev Returns the account approved for `tokenId` token.
478      *
479      * Requirements:
480      *
481      * - `tokenId` must exist.
482      */
483     function getApproved(uint256 tokenId) external view returns (address operator);
484 
485     /**
486      * @dev Approve or remove `operator` as an operator for the caller.
487      * Operators can call {transferFrom} or {safeTransferFrom} for any token owned by the caller.
488      *
489      * Requirements:
490      *
491      * - The `operator` cannot be the caller.
492      *
493      * Emits an {ApprovalForAll} event.
494      */
495     function setApprovalForAll(address operator, bool _approved) external;
496 
497     /**
498      * @dev Returns if the `operator` is allowed to manage all of the assets of `owner`.
499      *
500      * See {setApprovalForAll}
501      */
502     function isApprovedForAll(address owner, address operator) external view returns (bool);
503 
504     /**
505      * @dev Safely transfers `tokenId` token from `from` to `to`.
506      *
507      * Requirements:
508      *
509      * - `from` cannot be the zero address.
510      * - `to` cannot be the zero address.
511      * - `tokenId` token must exist and be owned by `from`.
512      * - If the caller is not `from`, it must be approved to move this token by either {approve} or {setApprovalForAll}.
513      * - If `to` refers to a smart contract, it must implement {IERC721Receiver-onERC721Received}, which is called upon a safe transfer.
514      *
515      * Emits a {Transfer} event.
516      */
517     function safeTransferFrom(
518         address from,
519         address to,
520         uint256 tokenId,
521         bytes calldata data
522     ) external;
523 }
524 
525 // File: @openzeppelin/contracts/token/ERC721/extensions/IERC721Enumerable.sol
526 
527 
528 // OpenZeppelin Contracts v4.4.1 (token/ERC721/extensions/IERC721Enumerable.sol)
529 
530 pragma solidity ^0.8.0;
531 
532 
533 /**
534  * @title ERC-721 Non-Fungible Token Standard, optional enumeration extension
535  * @dev See https://eips.ethereum.org/EIPS/eip-721
536  */
537 interface IERC721Enumerable is IERC721 {
538     /**
539      * @dev Returns the total amount of tokens stored by the contract.
540      */
541     function totalSupply() external view returns (uint256);
542 
543     /**
544      * @dev Returns a token ID owned by `owner` at a given `index` of its token list.
545      * Use along with {balanceOf} to enumerate all of ``owner``'s tokens.
546      */
547     function tokenOfOwnerByIndex(address owner, uint256 index) external view returns (uint256 tokenId);
548 
549     /**
550      * @dev Returns a token ID at a given `index` of all the tokens stored by the contract.
551      * Use along with {totalSupply} to enumerate all tokens.
552      */
553     function tokenByIndex(uint256 index) external view returns (uint256);
554 }
555 
556 // File: @openzeppelin/contracts/token/ERC721/extensions/IERC721Metadata.sol
557 
558 
559 // OpenZeppelin Contracts v4.4.1 (token/ERC721/extensions/IERC721Metadata.sol)
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
585 // File: @openzeppelin/contracts/utils/Context.sol
586 
587 
588 // OpenZeppelin Contracts v4.4.1 (utils/Context.sol)
589 
590 pragma solidity ^0.8.0;
591 
592 /**
593  * @dev Provides information about the current execution context, including the
594  * sender of the transaction and its data. While these are generally available
595  * via msg.sender and msg.data, they should not be accessed in such a direct
596  * manner, since when dealing with meta-transactions the account sending and
597  * paying for execution may not be the actual sender (as far as an application
598  * is concerned).
599  *
600  * This contract is only required for intermediate, library-like contracts.
601  */
602 abstract contract Context {
603     function _msgSender() internal view virtual returns (address) {
604         return msg.sender;
605     }
606 
607     function _msgData() internal view virtual returns (bytes calldata) {
608         return msg.data;
609     }
610 }
611 
612 // File: contracts/ERC721A.sol
613 
614 
615 // Creator: Chiru Labs
616 
617 pragma solidity ^0.8.0;
618 
619 
620 
621 
622 
623 
624 
625 
626 
627 /**
628  * @dev Implementation of https://eips.ethereum.org/EIPS/eip-721[ERC721] Non-Fungible Token Standard, including
629  * the Metadata and Enumerable extension. Built to optimize for lower gas during batch mints.
630  *
631  * Assumes serials are sequentially minted starting at 0 (e.g. 0, 1, 2, 3..).
632  *
633  * Does not support burning tokens to address(0).
634  *
635  * Assumes that an owner cannot have more than the 2**128 - 1 (max value of uint128) of supply
636  */
637 contract ERC721A is Context, ERC165, IERC721, IERC721Metadata, IERC721Enumerable {
638     using Address for address;
639     using Strings for uint256;
640 
641     struct TokenOwnership {
642         address addr;
643         uint64 startTimestamp;
644     }
645 
646     struct AddressData {
647         uint128 balance;
648         uint128 numberMinted;
649     }
650 
651     uint256 internal currentIndex;
652 
653     // Token name
654     string private _name;
655 
656     // Token symbol
657     string private _symbol;
658 
659     // Mapping from token ID to ownership details
660     // An empty struct value does not necessarily mean the token is unowned. See ownershipOf implementation for details.
661     mapping(uint256 => TokenOwnership) internal _ownerships;
662 
663     // Mapping owner address to address data
664     mapping(address => AddressData) private _addressData;
665 
666     // Mapping from token ID to approved address
667     mapping(uint256 => address) private _tokenApprovals;
668 
669     // Mapping from owner to operator approvals
670     mapping(address => mapping(address => bool)) private _operatorApprovals;
671 
672     constructor(string memory name_, string memory symbol_) {
673         _name = name_;
674         _symbol = symbol_;
675     }
676 
677     /**
678      * @dev See {IERC721Enumerable-totalSupply}.
679      */
680     function totalSupply() public view override returns (uint256) {
681         return currentIndex;
682     }
683 
684     /**
685      * @dev See {IERC721Enumerable-tokenByIndex}.
686      */
687     function tokenByIndex(uint256 index) public view override returns (uint256) {
688         require(index < totalSupply(), 'ERC721A: global index out of bounds');
689         return index;
690     }
691 
692     /**
693      * @dev See {IERC721Enumerable-tokenOfOwnerByIndex}.
694      * This read function is O(totalSupply). If calling from a separate contract, be sure to test gas first.
695      * It may also degrade with extremely large collection sizes (e.g >> 10000), test for your use case.
696      */
697     function tokenOfOwnerByIndex(address owner, uint256 index) public view override returns (uint256) {
698         require(index < balanceOf(owner), 'ERC721A: owner index out of bounds');
699         uint256 numMintedSoFar = totalSupply();
700         uint256 tokenIdsIdx;
701         address currOwnershipAddr;
702 
703         // Counter overflow is impossible as the loop breaks when uint256 i is equal to another uint256 numMintedSoFar.
704         unchecked {
705             for (uint256 i; i < numMintedSoFar; i++) {
706                 TokenOwnership memory ownership = _ownerships[i];
707                 if (ownership.addr != address(0)) {
708                     currOwnershipAddr = ownership.addr;
709                 }
710                 if (currOwnershipAddr == owner) {
711                     if (tokenIdsIdx == index) {
712                         return i;
713                     }
714                     tokenIdsIdx++;
715                 }
716             }
717         }
718 
719         revert('ERC721A: unable to get token of owner by index');
720     }
721 
722     /**
723      * @dev See {IERC165-supportsInterface}.
724      */
725     function supportsInterface(bytes4 interfaceId) public view virtual override(ERC165, IERC165) returns (bool) {
726         return
727             interfaceId == type(IERC721).interfaceId ||
728             interfaceId == type(IERC721Metadata).interfaceId ||
729             interfaceId == type(IERC721Enumerable).interfaceId ||
730             super.supportsInterface(interfaceId);
731     }
732 
733     /**
734      * @dev See {IERC721-balanceOf}.
735      */
736     function balanceOf(address owner) public view override returns (uint256) {
737         require(owner != address(0), 'ERC721A: balance query for the zero address');
738         return uint256(_addressData[owner].balance);
739     }
740 
741     function _numberMinted(address owner) internal view returns (uint256) {
742         require(owner != address(0), 'ERC721A: number minted query for the zero address');
743         return uint256(_addressData[owner].numberMinted);
744     }
745 
746     /**
747      * Gas spent here starts off proportional to the maximum mint batch size.
748      * It gradually moves to O(1) as tokens get transferred around in the collection over time.
749      */
750     function ownershipOf(uint256 tokenId) internal view returns (TokenOwnership memory) {
751         require(_exists(tokenId), 'ERC721A: owner query for nonexistent token');
752 
753         unchecked {
754             for (uint256 curr = tokenId; curr >= 0; curr--) {
755                 TokenOwnership memory ownership = _ownerships[curr];
756                 if (ownership.addr != address(0)) {
757                     return ownership;
758                 }
759             }
760         }
761 
762         revert('ERC721A: unable to determine the owner of token');
763     }
764 
765     /**
766      * @dev See {IERC721-ownerOf}.
767      */
768     function ownerOf(uint256 tokenId) public view override returns (address) {
769         return ownershipOf(tokenId).addr;
770     }
771 
772     /**
773      * @dev See {IERC721Metadata-name}.
774      */
775     function name() public view virtual override returns (string memory) {
776         return _name;
777     }
778 
779     /**
780      * @dev See {IERC721Metadata-symbol}.
781      */
782     function symbol() public view virtual override returns (string memory) {
783         return _symbol;
784     }
785 
786     /**
787      * @dev See {IERC721Metadata-tokenURI}.
788      */
789     function tokenURI(uint256 tokenId) public view virtual override returns (string memory) {
790         require(_exists(tokenId), 'ERC721Metadata: URI query for nonexistent token');
791 
792         string memory baseURI = _baseURI();
793         return bytes(baseURI).length != 0 ? string(abi.encodePacked(baseURI, tokenId.toString())) : '';
794     }
795 
796     /**
797      * @dev Base URI for computing {tokenURI}. If set, the resulting URI for each
798      * token will be the concatenation of the `baseURI` and the `tokenId`. Empty
799      * by default, can be overriden in child contracts.
800      */
801     function _baseURI() internal view virtual returns (string memory) {
802         return '';
803     }
804 
805     /**
806      * @dev See {IERC721-approve}.
807      */
808     function approve(address to, uint256 tokenId) public override {
809         address owner = ERC721A.ownerOf(tokenId);
810         require(to != owner, 'ERC721A: approval to current owner');
811 
812         require(
813             _msgSender() == owner || isApprovedForAll(owner, _msgSender()),
814             'ERC721A: approve caller is not owner nor approved for all'
815         );
816 
817         _approve(to, tokenId, owner);
818     }
819 
820     /**
821      * @dev See {IERC721-getApproved}.
822      */
823     function getApproved(uint256 tokenId) public view override returns (address) {
824         require(_exists(tokenId), 'ERC721A: approved query for nonexistent token');
825 
826         return _tokenApprovals[tokenId];
827     }
828 
829     /**
830      * @dev See {IERC721-setApprovalForAll}.
831      */
832     function setApprovalForAll(address operator, bool approved) public override {
833         require(operator != _msgSender(), 'ERC721A: approve to caller');
834 
835         _operatorApprovals[_msgSender()][operator] = approved;
836         emit ApprovalForAll(_msgSender(), operator, approved);
837     }
838 
839     /**
840      * @dev See {IERC721-isApprovedForAll}.
841      */
842     function isApprovedForAll(address owner, address operator) public view virtual override returns (bool) {
843         return _operatorApprovals[owner][operator];
844     }
845 
846     /**
847      * @dev See {IERC721-transferFrom}.
848      */
849     function transferFrom(
850         address from,
851         address to,
852         uint256 tokenId
853     ) public override {
854         _transfer(from, to, tokenId);
855     }
856 
857     /**
858      * @dev See {IERC721-safeTransferFrom}.
859      */
860     function safeTransferFrom(
861         address from,
862         address to,
863         uint256 tokenId
864     ) public override {
865         safeTransferFrom(from, to, tokenId, '');
866     }
867 
868     /**
869      * @dev See {IERC721-safeTransferFrom}.
870      */
871     function safeTransferFrom(
872         address from,
873         address to,
874         uint256 tokenId,
875         bytes memory _data
876     ) public override {
877         _transfer(from, to, tokenId);
878         require(
879             _checkOnERC721Received(from, to, tokenId, _data),
880             'ERC721A: transfer to non ERC721Receiver implementer'
881         );
882     }
883 
884     /**
885      * @dev Returns whether `tokenId` exists.
886      *
887      * Tokens can be managed by their owner or approved accounts via {approve} or {setApprovalForAll}.
888      *
889      * Tokens start existing when they are minted (`_mint`),
890      */
891     function _exists(uint256 tokenId) internal view returns (bool) {
892         return tokenId < currentIndex;
893     }
894 
895     function _safeMint(address to, uint256 quantity) internal {
896         _safeMint(to, quantity, '');
897     }
898 
899     /**
900      * @dev Safely mints `quantity` tokens and transfers them to `to`.
901      *
902      * Requirements:
903      *
904      * - If `to` refers to a smart contract, it must implement {IERC721Receiver-onERC721Received}, which is called for each safe transfer.
905      * - `quantity` must be greater than 0.
906      *
907      * Emits a {Transfer} event.
908      */
909     function _safeMint(
910         address to,
911         uint256 quantity,
912         bytes memory _data
913     ) internal {
914         _mint(to, quantity, _data, true);
915     }
916 
917     /**
918      * @dev Mints `quantity` tokens and transfers them to `to`.
919      *
920      * Requirements:
921      *
922      * - `to` cannot be the zero address.
923      * - `quantity` must be greater than 0.
924      *
925      * Emits a {Transfer} event.
926      */
927     function _mint(
928         address to,
929         uint256 quantity,
930         bytes memory _data,
931         bool safe
932     ) internal {
933         uint256 startTokenId = currentIndex;
934         require(to != address(0), 'ERC721A: mint to the zero address');
935         require(quantity != 0, 'ERC721A: quantity must be greater than 0');
936 
937         _beforeTokenTransfers(address(0), to, startTokenId, quantity);
938 
939         // Overflows are incredibly unrealistic.
940         // balance or numberMinted overflow if current value of either + quantity > 3.4e38 (2**128) - 1
941         // updatedIndex overflows if currentIndex + quantity > 1.56e77 (2**256) - 1
942         unchecked {
943             _addressData[to].balance += uint128(quantity);
944             _addressData[to].numberMinted += uint128(quantity);
945 
946             _ownerships[startTokenId].addr = to;
947             _ownerships[startTokenId].startTimestamp = uint64(block.timestamp);
948 
949             uint256 updatedIndex = startTokenId;
950 
951             for (uint256 i; i < quantity; i++) {
952                 emit Transfer(address(0), to, updatedIndex);
953                 if (safe) {
954                     require(
955                         _checkOnERC721Received(address(0), to, updatedIndex, _data),
956                         'ERC721A: transfer to non ERC721Receiver implementer'
957                     );
958                 }
959 
960                 updatedIndex++;
961             }
962 
963             currentIndex = updatedIndex;
964         }
965 
966         _afterTokenTransfers(address(0), to, startTokenId, quantity);
967     }
968 
969     /**
970      * @dev Transfers `tokenId` from `from` to `to`.
971      *
972      * Requirements:
973      *
974      * - `to` cannot be the zero address.
975      * - `tokenId` token must be owned by `from`.
976      *
977      * Emits a {Transfer} event.
978      */
979     function _transfer(
980         address from,
981         address to,
982         uint256 tokenId
983     ) private {
984         TokenOwnership memory prevOwnership = ownershipOf(tokenId);
985 
986         bool isApprovedOrOwner = (_msgSender() == prevOwnership.addr ||
987             getApproved(tokenId) == _msgSender() ||
988             isApprovedForAll(prevOwnership.addr, _msgSender()));
989 
990         require(isApprovedOrOwner, 'ERC721A: transfer caller is not owner nor approved');
991 
992         require(prevOwnership.addr == from, 'ERC721A: transfer from incorrect owner');
993         require(to != address(0), 'ERC721A: transfer to the zero address');
994 
995         _beforeTokenTransfers(from, to, tokenId, 1);
996 
997         // Clear approvals from the previous owner
998         _approve(address(0), tokenId, prevOwnership.addr);
999 
1000         // Underflow of the sender's balance is impossible because we check for
1001         // ownership above and the recipient's balance can't realistically overflow.
1002         // Counter overflow is incredibly unrealistic as tokenId would have to be 2**256.
1003         unchecked {
1004             _addressData[from].balance -= 1;
1005             _addressData[to].balance += 1;
1006 
1007             _ownerships[tokenId].addr = to;
1008             _ownerships[tokenId].startTimestamp = uint64(block.timestamp);
1009 
1010             // If the ownership slot of tokenId+1 is not explicitly set, that means the transfer initiator owns it.
1011             // Set the slot of tokenId+1 explicitly in storage to maintain correctness for ownerOf(tokenId+1) calls.
1012             uint256 nextTokenId = tokenId + 1;
1013             if (_ownerships[nextTokenId].addr == address(0)) {
1014                 if (_exists(nextTokenId)) {
1015                     _ownerships[nextTokenId].addr = prevOwnership.addr;
1016                     _ownerships[nextTokenId].startTimestamp = prevOwnership.startTimestamp;
1017                 }
1018             }
1019         }
1020 
1021         emit Transfer(from, to, tokenId);
1022         _afterTokenTransfers(from, to, tokenId, 1);
1023     }
1024 
1025     /**
1026      * @dev Approve `to` to operate on `tokenId`
1027      *
1028      * Emits a {Approval} event.
1029      */
1030     function _approve(
1031         address to,
1032         uint256 tokenId,
1033         address owner
1034     ) private {
1035         _tokenApprovals[tokenId] = to;
1036         emit Approval(owner, to, tokenId);
1037     }
1038 
1039     /**
1040      * @dev Internal function to invoke {IERC721Receiver-onERC721Received} on a target address.
1041      * The call is not executed if the target address is not a contract.
1042      *
1043      * @param from address representing the previous owner of the given token ID
1044      * @param to target address that will receive the tokens
1045      * @param tokenId uint256 ID of the token to be transferred
1046      * @param _data bytes optional data to send along with the call
1047      * @return bool whether the call correctly returned the expected magic value
1048      */
1049     function _checkOnERC721Received(
1050         address from,
1051         address to,
1052         uint256 tokenId,
1053         bytes memory _data
1054     ) private returns (bool) {
1055         if (to.isContract()) {
1056             try IERC721Receiver(to).onERC721Received(_msgSender(), from, tokenId, _data) returns (bytes4 retval) {
1057                 return retval == IERC721Receiver(to).onERC721Received.selector;
1058             } catch (bytes memory reason) {
1059                 if (reason.length == 0) {
1060                     revert('ERC721A: transfer to non ERC721Receiver implementer');
1061                 } else {
1062                     assembly {
1063                         revert(add(32, reason), mload(reason))
1064                     }
1065                 }
1066             }
1067         } else {
1068             return true;
1069         }
1070     }
1071 
1072     /**
1073      * @dev Hook that is called before a set of serially-ordered token ids are about to be transferred. This includes minting.
1074      *
1075      * startTokenId - the first token id to be transferred
1076      * quantity - the amount to be transferred
1077      *
1078      * Calling conditions:
1079      *
1080      * - When `from` and `to` are both non-zero, ``from``'s `tokenId` will be
1081      * transferred to `to`.
1082      * - When `from` is zero, `tokenId` will be minted for `to`.
1083      */
1084     function _beforeTokenTransfers(
1085         address from,
1086         address to,
1087         uint256 startTokenId,
1088         uint256 quantity
1089     ) internal virtual {}
1090 
1091     /**
1092      * @dev Hook that is called after a set of serially-ordered token ids have been transferred. This includes
1093      * minting.
1094      *
1095      * startTokenId - the first token id to be transferred
1096      * quantity - the amount to be transferred
1097      *
1098      * Calling conditions:
1099      *
1100      * - when `from` and `to` are both non-zero.
1101      * - `from` and `to` are never both zero.
1102      */
1103     function _afterTokenTransfers(
1104         address from,
1105         address to,
1106         uint256 startTokenId,
1107         uint256 quantity
1108     ) internal virtual {}
1109 }
1110 // File: @openzeppelin/contracts/access/Ownable.sol
1111 
1112 
1113 // OpenZeppelin Contracts v4.4.1 (access/Ownable.sol)
1114 
1115 pragma solidity ^0.8.0;
1116 
1117 
1118 /**
1119  * @dev Contract module which provides a basic access control mechanism, where
1120  * there is an account (an owner) that can be granted exclusive access to
1121  * specific functions.
1122  *
1123  * By default, the owner account will be the one that deploys the contract. This
1124  * can later be changed with {transferOwnership}.
1125  *
1126  * This module is used through inheritance. It will make available the modifier
1127  * `onlyOwner`, which can be applied to your functions to restrict their use to
1128  * the owner.
1129  */
1130 abstract contract Ownable is Context {
1131     address private _owner;
1132 
1133     event OwnershipTransferred(address indexed previousOwner, address indexed newOwner);
1134 
1135     /**
1136      * @dev Initializes the contract setting the deployer as the initial owner.
1137      */
1138     constructor() {
1139         _transferOwnership(_msgSender());
1140     }
1141 
1142     /**
1143      * @dev Returns the address of the current owner.
1144      */
1145     function owner() public view virtual returns (address) {
1146         return _owner;
1147     }
1148 
1149     /**
1150      * @dev Throws if called by any account other than the owner.
1151      */
1152     modifier onlyOwner() {
1153         require(owner() == _msgSender(), "Ownable: caller is not the owner");
1154         _;
1155     }
1156 
1157     /**
1158      * @dev Leaves the contract without owner. It will not be possible to call
1159      * `onlyOwner` functions anymore. Can only be called by the current owner.
1160      *
1161      * NOTE: Renouncing ownership will leave the contract without an owner,
1162      * thereby removing any functionality that is only available to the owner.
1163      */
1164     function renounceOwnership() public virtual onlyOwner {
1165         _transferOwnership(address(0));
1166     }
1167 
1168     /**
1169      * @dev Transfers ownership of the contract to a new account (`newOwner`).
1170      * Can only be called by the current owner.
1171      */
1172     function transferOwnership(address newOwner) public virtual onlyOwner {
1173         require(newOwner != address(0), "Ownable: new owner is the zero address");
1174         _transferOwnership(newOwner);
1175     }
1176 
1177     /**
1178      * @dev Transfers ownership of the contract to a new account (`newOwner`).
1179      * Internal function without access restriction.
1180      */
1181     function _transferOwnership(address newOwner) internal virtual {
1182         address oldOwner = _owner;
1183         _owner = newOwner;
1184         emit OwnershipTransferred(oldOwner, newOwner);
1185     }
1186 }
1187 
1188 // File: contracts/LarvaDeads.sol
1189 
1190 
1191 
1192 //██///////█████//██████//██////██//█████//////██████//███████//█████//██████//███████/
1193 //██//////██///██/██///██/██////██/██///██/////██///██/██//////██///██/██///██/██//////
1194 //██//////███████/██████//██////██/███████/////██///██/█████///███████/██///██/███████/
1195 //██//////██///██/██///██//██//██//██///██/////██///██/██//////██///██/██///██//////██/
1196 //███████/██///██/██///██///████///██///██/////██████//███████/██///██/██████//███████/
1197 
1198 pragma solidity ^0.8.0;
1199 
1200 
1201 
1202 contract LarvaDeads is ERC721A, Ownable {
1203 
1204     string private baseURI;
1205 
1206     uint256 public maxSupply = 6666;
1207     uint256 public constant free = 666;
1208     uint256 public price = 0.00666 ether;
1209 
1210     constructor(string memory baseURI_) ERC721A("Larva Deads", "LDEADS") {
1211         setBaseURI(baseURI_);
1212     }
1213 
1214     function setBaseURI(string memory baseURI_) public onlyOwner {
1215         baseURI = baseURI_;
1216     }
1217 
1218     function mint(uint256 amount) external payable {
1219         require(amount <= 10, "Max 10 per tx");
1220         uint256 minted = totalSupply();
1221         require(minted + amount <= maxSupply, "Above maximum supply!");
1222         if (minted >= free) {
1223             require(price * amount <= msg.value, "Insufficient amount of ether!");
1224         } else if (minted + amount > free) {
1225             require(price * (minted + amount - free) <= msg.value, "Insufficient amount of ether!");
1226         }
1227         _safeMint(_msgSender(), amount);
1228     }
1229 
1230     function setNewPrice(uint256 newPrice) external onlyOwner {
1231         price = newPrice;
1232     }
1233 
1234     function cutSupply(uint256 newSupply) external onlyOwner {
1235         require(newSupply < maxSupply, "New supply must be less than current supply");
1236         maxSupply = newSupply;
1237     }
1238 
1239     function withdrawAll() external onlyOwner {
1240         uint256 balance = address(this).balance;
1241         payable(owner()).transfer(balance);
1242     }
1243 
1244     function _baseURI() internal view override returns (string memory) {
1245         return baseURI;
1246     }
1247 }