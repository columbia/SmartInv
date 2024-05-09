1 // https://saudigoblins.wtf
2 
3 // 8b        d8    db         88           88                  db         88        88  
4 //  Y8,    ,8P    d88b        88           88                 d88b        88        88  
5 //   Y8,  ,8P    d8'`8b       88           88                d8'`8b       88        88  
6 //    "8aa8"    d8'  `8b      88           88               d8'  `8b      88aaaaaaaa88  
7 //     `88'    d8YaaaaY8b     88           88              d8YaaaaY8b     88""""""""88  
8 //      88    d8""""""""8b    88           88             d8""""""""8b    88        88  
9 //      88   d8'        `8b   88           88            d8'        `8b   88        88  
10 //      88  d8'          `8b  88888888888  88888888888  d8'          `8b  88        88  
11                                                                                      
12                                                                  
13 // SPDX-License-Identifier: Unlicense
14 // File: @openzeppelin/contracts/utils/Strings.sol
15 
16 
17 // OpenZeppelin Contracts v4.4.1 (utils/Strings.sol)
18 
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
84 // File: @openzeppelin/contracts/utils/Context.sol
85 
86 
87 // OpenZeppelin Contracts v4.4.1 (utils/Context.sol)
88 
89 pragma solidity ^0.8.0;
90 
91 /**
92  * @dev Provides information about the current execution context, including the
93  * sender of the transaction and its data. While these are generally available
94  * via msg.sender and msg.data, they should not be accessed in such a direct
95  * manner, since when dealing with meta-transactions the account sending and
96  * paying for execution may not be the actual sender (as far as an application
97  * is concerned).
98  *
99  * This contract is only required for intermediate, library-like contracts.
100  */
101 abstract contract Context {
102     function _msgSender() internal view virtual returns (address) {
103         return msg.sender;
104     }
105 
106     function _msgData() internal view virtual returns (bytes calldata) {
107         return msg.data;
108     }
109 }
110 
111 // File: @openzeppelin/contracts/utils/Address.sol
112 
113 
114 // OpenZeppelin Contracts (last updated v4.5.0) (utils/Address.sol)
115 
116 pragma solidity ^0.8.1;
117 
118 /**
119  * @dev Collection of functions related to the address type
120  */
121 library Address {
122     /**
123      * @dev Returns true if `account` is a contract.
124      *
125      * [IMPORTANT]
126      * ====
127      * It is unsafe to assume that an address for which this function returns
128      * false is an externally-owned account (EOA) and not a contract.
129      *
130      * Among others, `isContract` will return false for the following
131      * types of addresses:
132      *
133      *  - an externally-owned account
134      *  - a contract in construction
135      *  - an address where a contract will be created
136      *  - an address where a contract lived, but was destroyed
137      * ====
138      *
139      * [IMPORTANT]
140      * ====
141      * You shouldn't rely on `isContract` to protect against flash loan attacks!
142      *
143      * Preventing calls from contracts is highly discouraged. It breaks composability, breaks support for smart wallets
144      * like Gnosis Safe, and does not provide security since it can be circumvented by calling from a contract
145      * constructor.
146      * ====
147      */
148     function isContract(address account) internal view returns (bool) {
149         // This method relies on extcodesize/address.code.length, which returns 0
150         // for contracts in construction, since the code is only stored at the end
151         // of the constructor execution.
152 
153         return account.code.length > 0;
154     }
155 
156     /**
157      * @dev Replacement for Solidity's `transfer`: sends `amount` wei to
158      * `recipient`, forwarding all available gas and reverting on errors.
159      *
160      * https://eips.ethereum.org/EIPS/eip-1884[EIP1884] increases the gas cost
161      * of certain opcodes, possibly making contracts go over the 2300 gas limit
162      * imposed by `transfer`, making them unable to receive funds via
163      * `transfer`. {sendValue} removes this limitation.
164      *
165      * https://diligence.consensys.net/posts/2019/09/stop-using-soliditys-transfer-now/[Learn more].
166      *
167      * IMPORTANT: because control is transferred to `recipient`, care must be
168      * taken to not create reentrancy vulnerabilities. Consider using
169      * {ReentrancyGuard} or the
170      * https://solidity.readthedocs.io/en/v0.5.11/security-considerations.html#use-the-checks-effects-interactions-pattern[checks-effects-interactions pattern].
171      */
172     function sendValue(address payable recipient, uint256 amount) internal {
173         require(address(this).balance >= amount, "Address: insufficient balance");
174 
175         (bool success, ) = recipient.call{value: amount}("");
176         require(success, "Address: unable to send value, recipient may have reverted");
177     }
178 
179     /**
180      * @dev Performs a Solidity function call using a low level `call`. A
181      * plain `call` is an unsafe replacement for a function call: use this
182      * function instead.
183      *
184      * If `target` reverts with a revert reason, it is bubbled up by this
185      * function (like regular Solidity function calls).
186      *
187      * Returns the raw returned data. To convert to the expected return value,
188      * use https://solidity.readthedocs.io/en/latest/units-and-global-variables.html?highlight=abi.decode#abi-encoding-and-decoding-functions[`abi.decode`].
189      *
190      * Requirements:
191      *
192      * - `target` must be a contract.
193      * - calling `target` with `data` must not revert.
194      *
195      * _Available since v3.1._
196      */
197     function functionCall(address target, bytes memory data) internal returns (bytes memory) {
198         return functionCall(target, data, "Address: low-level call failed");
199     }
200 
201     /**
202      * @dev Same as {xref-Address-functionCall-address-bytes-}[`functionCall`], but with
203      * `errorMessage` as a fallback revert reason when `target` reverts.
204      *
205      * _Available since v3.1._
206      */
207     function functionCall(
208         address target,
209         bytes memory data,
210         string memory errorMessage
211     ) internal returns (bytes memory) {
212         return functionCallWithValue(target, data, 0, errorMessage);
213     }
214 
215     /**
216      * @dev Same as {xref-Address-functionCall-address-bytes-}[`functionCall`],
217      * but also transferring `value` wei to `target`.
218      *
219      * Requirements:
220      *
221      * - the calling contract must have an ETH balance of at least `value`.
222      * - the called Solidity function must be `payable`.
223      *
224      * _Available since v3.1._
225      */
226     function functionCallWithValue(
227         address target,
228         bytes memory data,
229         uint256 value
230     ) internal returns (bytes memory) {
231         return functionCallWithValue(target, data, value, "Address: low-level call with value failed");
232     }
233 
234     /**
235      * @dev Same as {xref-Address-functionCallWithValue-address-bytes-uint256-}[`functionCallWithValue`], but
236      * with `errorMessage` as a fallback revert reason when `target` reverts.
237      *
238      * _Available since v3.1._
239      */
240     function functionCallWithValue(
241         address target,
242         bytes memory data,
243         uint256 value,
244         string memory errorMessage
245     ) internal returns (bytes memory) {
246         require(address(this).balance >= value, "Address: insufficient balance for call");
247         require(isContract(target), "Address: call to non-contract");
248 
249         (bool success, bytes memory returndata) = target.call{value: value}(data);
250         return verifyCallResult(success, returndata, errorMessage);
251     }
252 
253     /**
254      * @dev Same as {xref-Address-functionCall-address-bytes-}[`functionCall`],
255      * but performing a static call.
256      *
257      * _Available since v3.3._
258      */
259     function functionStaticCall(address target, bytes memory data) internal view returns (bytes memory) {
260         return functionStaticCall(target, data, "Address: low-level static call failed");
261     }
262 
263     /**
264      * @dev Same as {xref-Address-functionCall-address-bytes-string-}[`functionCall`],
265      * but performing a static call.
266      *
267      * _Available since v3.3._
268      */
269     function functionStaticCall(
270         address target,
271         bytes memory data,
272         string memory errorMessage
273     ) internal view returns (bytes memory) {
274         require(isContract(target), "Address: static call to non-contract");
275 
276         (bool success, bytes memory returndata) = target.staticcall(data);
277         return verifyCallResult(success, returndata, errorMessage);
278     }
279 
280     /**
281      * @dev Same as {xref-Address-functionCall-address-bytes-}[`functionCall`],
282      * but performing a delegate call.
283      *
284      * _Available since v3.4._
285      */
286     function functionDelegateCall(address target, bytes memory data) internal returns (bytes memory) {
287         return functionDelegateCall(target, data, "Address: low-level delegate call failed");
288     }
289 
290     /**
291      * @dev Same as {xref-Address-functionCall-address-bytes-string-}[`functionCall`],
292      * but performing a delegate call.
293      *
294      * _Available since v3.4._
295      */
296     function functionDelegateCall(
297         address target,
298         bytes memory data,
299         string memory errorMessage
300     ) internal returns (bytes memory) {
301         require(isContract(target), "Address: delegate call to non-contract");
302 
303         (bool success, bytes memory returndata) = target.delegatecall(data);
304         return verifyCallResult(success, returndata, errorMessage);
305     }
306 
307     /**
308      * @dev Tool to verifies that a low level call was successful, and revert if it wasn't, either by bubbling the
309      * revert reason using the provided one.
310      *
311      * _Available since v4.3._
312      */
313     function verifyCallResult(
314         bool success,
315         bytes memory returndata,
316         string memory errorMessage
317     ) internal pure returns (bytes memory) {
318         if (success) {
319             return returndata;
320         } else {
321             // Look for revert reason and bubble it up if present
322             if (returndata.length > 0) {
323                 // The easiest way to bubble the revert reason is using memory via assembly
324 
325                 assembly {
326                     let returndata_size := mload(returndata)
327                     revert(add(32, returndata), returndata_size)
328                 }
329             } else {
330                 revert(errorMessage);
331             }
332         }
333     }
334 }
335 
336 // File: @openzeppelin/contracts/token/ERC721/IERC721Receiver.sol
337 
338 
339 // OpenZeppelin Contracts (last updated v4.6.0) (token/ERC721/IERC721Receiver.sol)
340 
341 pragma solidity ^0.8.0;
342 
343 /**
344  * @title ERC721 token receiver interface
345  * @dev Interface for any contract that wants to support safeTransfers
346  * from ERC721 asset contracts.
347  */
348 interface IERC721Receiver {
349     /**
350      * @dev Whenever an {IERC721} `tokenId` token is transferred to this contract via {IERC721-safeTransferFrom}
351      * by `operator` from `from`, this function is called.
352      *
353      * It must return its Solidity selector to confirm the token transfer.
354      * If any other value is returned or the interface is not implemented by the recipient, the transfer will be reverted.
355      *
356      * The selector can be obtained in Solidity with `IERC721Receiver.onERC721Received.selector`.
357      */
358     function onERC721Received(
359         address operator,
360         address from,
361         uint256 tokenId,
362         bytes calldata data
363     ) external returns (bytes4);
364 }
365 
366 // File: @openzeppelin/contracts/utils/introspection/IERC165.sol
367 
368 
369 // OpenZeppelin Contracts v4.4.1 (utils/introspection/IERC165.sol)
370 
371 pragma solidity ^0.8.0;
372 
373 /**
374  * @dev Interface of the ERC165 standard, as defined in the
375  * https://eips.ethereum.org/EIPS/eip-165[EIP].
376  *
377  * Implementers can declare support of contract interfaces, which can then be
378  * queried by others ({ERC165Checker}).
379  *
380  * For an implementation, see {ERC165}.
381  */
382 interface IERC165 {
383     /**
384      * @dev Returns true if this contract implements the interface defined by
385      * `interfaceId`. See the corresponding
386      * https://eips.ethereum.org/EIPS/eip-165#how-interfaces-are-identified[EIP section]
387      * to learn more about how these ids are created.
388      *
389      * This function call must use less than 30 000 gas.
390      */
391     function supportsInterface(bytes4 interfaceId) external view returns (bool);
392 }
393 
394 // File: @openzeppelin/contracts/utils/introspection/ERC165.sol
395 
396 
397 // OpenZeppelin Contracts v4.4.1 (utils/introspection/ERC165.sol)
398 
399 pragma solidity ^0.8.0;
400 
401 
402 /**
403  * @dev Implementation of the {IERC165} interface.
404  *
405  * Contracts that want to implement ERC165 should inherit from this contract and override {supportsInterface} to check
406  * for the additional interface id that will be supported. For example:
407  *
408  * ```solidity
409  * function supportsInterface(bytes4 interfaceId) public view virtual override returns (bool) {
410  *     return interfaceId == type(MyInterface).interfaceId || super.supportsInterface(interfaceId);
411  * }
412  * ```
413  *
414  * Alternatively, {ERC165Storage} provides an easier to use but more expensive implementation.
415  */
416 abstract contract ERC165 is IERC165 {
417     /**
418      * @dev See {IERC165-supportsInterface}.
419      */
420     function supportsInterface(bytes4 interfaceId) public view virtual override returns (bool) {
421         return interfaceId == type(IERC165).interfaceId;
422     }
423 }
424 
425 // File: @openzeppelin/contracts/token/ERC721/IERC721.sol
426 
427 
428 // OpenZeppelin Contracts (last updated v4.6.0) (token/ERC721/IERC721.sol)
429 
430 pragma solidity ^0.8.0;
431 
432 
433 /**
434  * @dev Required interface of an ERC721 compliant contract.
435  */
436 interface IERC721 is IERC165 {
437     /**
438      * @dev Emitted when `tokenId` token is transferred from `from` to `to`.
439      */
440     event Transfer(address indexed from, address indexed to, uint256 indexed tokenId);
441 
442     /**
443      * @dev Emitted when `owner` enables `approved` to manage the `tokenId` token.
444      */
445     event Approval(address indexed owner, address indexed approved, uint256 indexed tokenId);
446 
447     /**
448      * @dev Emitted when `owner` enables or disables (`approved`) `operator` to manage all of its assets.
449      */
450     event ApprovalForAll(address indexed owner, address indexed operator, bool approved);
451 
452     /**
453      * @dev Returns the number of tokens in ``owner``'s account.
454      */
455     function balanceOf(address owner) external view returns (uint256 balance);
456 
457     /**
458      * @dev Returns the owner of the `tokenId` token.
459      *
460      * Requirements:
461      *
462      * - `tokenId` must exist.
463      */
464     function ownerOf(uint256 tokenId) external view returns (address owner);
465 
466     /**
467      * @dev Safely transfers `tokenId` token from `from` to `to`.
468      *
469      * Requirements:
470      *
471      * - `from` cannot be the zero address.
472      * - `to` cannot be the zero address.
473      * - `tokenId` token must exist and be owned by `from`.
474      * - If the caller is not `from`, it must be approved to move this token by either {approve} or {setApprovalForAll}.
475      * - If `to` refers to a smart contract, it must implement {IERC721Receiver-onERC721Received}, which is called upon a safe transfer.
476      *
477      * Emits a {Transfer} event.
478      */
479     function safeTransferFrom(
480         address from,
481         address to,
482         uint256 tokenId,
483         bytes calldata data
484     ) external;
485 
486     /**
487      * @dev Safely transfers `tokenId` token from `from` to `to`, checking first that contract recipients
488      * are aware of the ERC721 protocol to prevent tokens from being forever locked.
489      *
490      * Requirements:
491      *
492      * - `from` cannot be the zero address.
493      * - `to` cannot be the zero address.
494      * - `tokenId` token must exist and be owned by `from`.
495      * - If the caller is not `from`, it must be have been allowed to move this token by either {approve} or {setApprovalForAll}.
496      * - If `to` refers to a smart contract, it must implement {IERC721Receiver-onERC721Received}, which is called upon a safe transfer.
497      *
498      * Emits a {Transfer} event.
499      */
500     function safeTransferFrom(
501         address from,
502         address to,
503         uint256 tokenId
504     ) external;
505 
506     /**
507      * @dev Transfers `tokenId` token from `from` to `to`.
508      *
509      * WARNING: Usage of this method is discouraged, use {safeTransferFrom} whenever possible.
510      *
511      * Requirements:
512      *
513      * - `from` cannot be the zero address.
514      * - `to` cannot be the zero address.
515      * - `tokenId` token must be owned by `from`.
516      * - If the caller is not `from`, it must be approved to move this token by either {approve} or {setApprovalForAll}.
517      *
518      * Emits a {Transfer} event.
519      */
520     function transferFrom(
521         address from,
522         address to,
523         uint256 tokenId
524     ) external;
525 
526     /**
527      * @dev Gives permission to `to` to transfer `tokenId` token to another account.
528      * The approval is cleared when the token is transferred.
529      *
530      * Only a single account can be approved at a time, so approving the zero address clears previous approvals.
531      *
532      * Requirements:
533      *
534      * - The caller must own the token or be an approved operator.
535      * - `tokenId` must exist.
536      *
537      * Emits an {Approval} event.
538      */
539     function approve(address to, uint256 tokenId) external;
540 
541     /**
542      * @dev Approve or remove `operator` as an operator for the caller.
543      * Operators can call {transferFrom} or {safeTransferFrom} for any token owned by the caller.
544      *
545      * Requirements:
546      *
547      * - The `operator` cannot be the caller.
548      *
549      * Emits an {ApprovalForAll} event.
550      */
551     function setApprovalForAll(address operator, bool _approved) external;
552 
553     /**
554      * @dev Returns the account approved for `tokenId` token.
555      *
556      * Requirements:
557      *
558      * - `tokenId` must exist.
559      */
560     function getApproved(uint256 tokenId) external view returns (address operator);
561 
562     /**
563      * @dev Returns if the `operator` is allowed to manage all of the assets of `owner`.
564      *
565      * See {setApprovalForAll}
566      */
567     function isApprovedForAll(address owner, address operator) external view returns (bool);
568 }
569 
570 // File: @openzeppelin/contracts/token/ERC721/extensions/IERC721Enumerable.sol
571 
572 
573 // OpenZeppelin Contracts (last updated v4.5.0) (token/ERC721/extensions/IERC721Enumerable.sol)
574 
575 pragma solidity ^0.8.0;
576 
577 
578 /**
579  * @title ERC-721 Non-Fungible Token Standard, optional enumeration extension
580  * @dev See https://eips.ethereum.org/EIPS/eip-721
581  */
582 interface IERC721Enumerable is IERC721 {
583     /**
584      * @dev Returns the total amount of tokens stored by the contract.
585      */
586     function totalSupply() external view returns (uint256);
587 
588     /**
589      * @dev Returns a token ID owned by `owner` at a given `index` of its token list.
590      * Use along with {balanceOf} to enumerate all of ``owner``'s tokens.
591      */
592     function tokenOfOwnerByIndex(address owner, uint256 index) external view returns (uint256);
593 
594     /**
595      * @dev Returns a token ID at a given `index` of all the tokens stored by the contract.
596      * Use along with {totalSupply} to enumerate all tokens.
597      */
598     function tokenByIndex(uint256 index) external view returns (uint256);
599 }
600 
601 // File: @openzeppelin/contracts/token/ERC721/extensions/IERC721Metadata.sol
602 
603 
604 // OpenZeppelin Contracts v4.4.1 (token/ERC721/extensions/IERC721Metadata.sol)
605 
606 pragma solidity ^0.8.0;
607 
608 
609 /**
610  * @title ERC-721 Non-Fungible Token Standard, optional metadata extension
611  * @dev See https://eips.ethereum.org/EIPS/eip-721
612  */
613 interface IERC721Metadata is IERC721 {
614     /**
615      * @dev Returns the token collection name.
616      */
617     function name() external view returns (string memory);
618 
619     /**
620      * @dev Returns the token collection symbol.
621      */
622     function symbol() external view returns (string memory);
623 
624     /**
625      * @dev Returns the Uniform Resource Identifier (URI) for `tokenId` token.
626      */
627     function tokenURI(uint256 tokenId) external view returns (string memory);
628 }
629 
630 // File: ERC721A.sol
631 
632 
633 // Creator: Chiru Labs
634 
635 pragma solidity ^0.8.0;
636 
637 
638 
639 /**
640  * @dev Implementation of https://eips.ethereum.org/EIPS/eip-721[ERC721] Non-Fungible Token Standard, including
641  * the Metadata and Enumerable extension. Built to optimize for lower gas during batch mints.
642  *
643  * Assumes serials are sequentially minted starting at 0 (e.g. 0, 1, 2, 3..).
644  *
645  * Does not support burning tokens to address(0).
646  *
647  * Assumes that an owner cannot have more than the 2**128 - 1 (max value of uint128) of supply
648  */
649 contract ERC721A is Context, ERC165, IERC721, IERC721Metadata, IERC721Enumerable {
650     using Address for address;
651     using Strings for uint256;
652 
653     struct TokenOwnership {
654         address addr;
655         uint64 startTimestamp;
656     }
657 
658     struct AddressData {
659         uint128 balance;
660         uint128 numberMinted;
661     }
662 
663     uint256 internal currentIndex = 1;
664 
665     // Token name
666     string private _name;
667 
668     // Token symbol
669     string private _symbol;
670 
671     // Mapping from token ID to ownership details
672     // An empty struct value does not necessarily mean the token is unowned. See ownershipOf implementation for details.
673     mapping(uint256 => TokenOwnership) internal _ownerships;
674 
675     // Mapping owner address to address data
676     mapping(address => AddressData) private _addressData;
677 
678     // Mapping from token ID to approved address
679     mapping(uint256 => address) private _tokenApprovals;
680 
681     // Mapping from owner to operator approvals
682     mapping(address => mapping(address => bool)) private _operatorApprovals;
683 
684     constructor(string memory name_, string memory symbol_) {
685         _name = name_;
686         _symbol = symbol_;
687     }
688 
689     /**
690      * @dev See {IERC721Enumerable-totalSupply}.
691      */
692     function totalSupply() public view override returns (uint256) {
693         return currentIndex;
694     }
695 
696     /**
697      * @dev See {IERC721Enumerable-tokenByIndex}.
698      */
699     function tokenByIndex(uint256 index) public view override returns (uint256) {
700         require(index < totalSupply(), 'ERC721A: global index out of bounds');
701         return index;
702     }
703 
704     /**
705      * @dev See {IERC721Enumerable-tokenOfOwnerByIndex}.
706      * This read function is O(totalSupply). If calling from a separate contract, be sure to test gas first.
707      * It may also degrade with extremely large collection sizes (e.g >> 10000), test for your use case.
708      */
709     function tokenOfOwnerByIndex(address owner, uint256 index) public view override returns (uint256) {
710         require(index < balanceOf(owner), 'ERC721A: owner index out of bounds');
711         uint256 numMintedSoFar = totalSupply();
712         uint256 tokenIdsIdx;
713         address currOwnershipAddr;
714 
715         // Counter overflow is impossible as the loop breaks when uint256 i is equal to another uint256 numMintedSoFar.
716         unchecked {
717             for (uint256 i; i < numMintedSoFar; i++) {
718                 TokenOwnership memory ownership = _ownerships[i];
719                 if (ownership.addr != address(0)) {
720                     currOwnershipAddr = ownership.addr;
721                 }
722                 if (currOwnershipAddr == owner) {
723                     if (tokenIdsIdx == index) {
724                         return i;
725                     }
726                     tokenIdsIdx++;
727                 }
728             }
729         }
730 
731         revert('ERC721A: unable to get token of owner by index');
732     }
733 
734     /**
735      * @dev See {IERC165-supportsInterface}.
736      */
737     function supportsInterface(bytes4 interfaceId) public view virtual override(ERC165, IERC165) returns (bool) {
738         return
739             interfaceId == type(IERC721).interfaceId ||
740             interfaceId == type(IERC721Metadata).interfaceId ||
741             interfaceId == type(IERC721Enumerable).interfaceId ||
742             super.supportsInterface(interfaceId);
743     }
744 
745     /**
746      * @dev See {IERC721-balanceOf}.
747      */
748     function balanceOf(address owner) public view override returns (uint256) {
749         require(owner != address(0), 'ERC721A: balance query for the zero address');
750         return uint256(_addressData[owner].balance);
751     }
752 
753     function _numberMinted(address owner) internal view returns (uint256) {
754         require(owner != address(0), 'ERC721A: number minted query for the zero address');
755         return uint256(_addressData[owner].numberMinted);
756     }
757 
758     /**
759      * Gas spent here starts off proportional to the maximum mint batch size.
760      * It gradually moves to O(1) as tokens get transferred around in the collection over time.
761      */
762     function ownershipOf(uint256 tokenId) internal view returns (TokenOwnership memory) {
763         require(_exists(tokenId), 'ERC721A: owner query for nonexistent token');
764 
765         unchecked {
766             for (uint256 curr = tokenId; curr >= 0; curr--) {
767                 TokenOwnership memory ownership = _ownerships[curr];
768                 if (ownership.addr != address(0)) {
769                     return ownership;
770                 }
771             }
772         }
773 
774         revert('ERC721A: unable to determine the owner of token');
775     }
776 
777     /**
778      * @dev See {IERC721-ownerOf}.
779      */
780     function ownerOf(uint256 tokenId) public view override returns (address) {
781         return ownershipOf(tokenId).addr;
782     }
783 
784     /**
785      * @dev See {IERC721Metadata-name}.
786      */
787     function name() public view virtual override returns (string memory) {
788         return _name;
789     }
790 
791     /**
792      * @dev See {IERC721Metadata-symbol}.
793      */
794     function symbol() public view virtual override returns (string memory) {
795         return _symbol;
796     }
797 
798     /**
799      * @dev See {IERC721Metadata-tokenURI}.
800      */
801     function tokenURI(uint256 tokenId) public view virtual override returns (string memory) {
802         require(_exists(tokenId), 'ERC721Metadata: URI query for nonexistent token');
803 
804         string memory baseURI = _baseURI();
805         return bytes(baseURI).length != 0 ? string(abi.encodePacked(baseURI, tokenId.toString())) : '';
806     }
807 
808     /**
809      * @dev Base URI for computing {tokenURI}. If set, the resulting URI for each
810      * token will be the concatenation of the `baseURI` and the `tokenId`. Empty
811      * by default, can be overriden in child contracts.
812      */
813     function _baseURI() internal view virtual returns (string memory) {
814         return '';
815     }
816 
817     /**
818      * @dev See {IERC721-approve}.
819      */
820     function approve(address to, uint256 tokenId) public override {
821         address owner = ERC721A.ownerOf(tokenId);
822         require(to != owner, 'ERC721A: approval to current owner');
823 
824         require(
825             _msgSender() == owner || isApprovedForAll(owner, _msgSender()),
826             'ERC721A: approve caller is not owner nor approved for all'
827         );
828 
829         _approve(to, tokenId, owner);
830     }
831 
832     /**
833      * @dev See {IERC721-getApproved}.
834      */
835     function getApproved(uint256 tokenId) public view override returns (address) {
836         require(_exists(tokenId), 'ERC721A: approved query for nonexistent token');
837 
838         return _tokenApprovals[tokenId];
839     }
840 
841     /**
842      * @dev See {IERC721-setApprovalForAll}.
843      */
844     function setApprovalForAll(address operator, bool approved) public override {
845         require(operator != _msgSender(), 'ERC721A: approve to caller');
846 
847         _operatorApprovals[_msgSender()][operator] = approved;
848         emit ApprovalForAll(_msgSender(), operator, approved);
849     }
850 
851     /**
852      * @dev See {IERC721-isApprovedForAll}.
853      */
854     function isApprovedForAll(address owner, address operator) public view virtual override returns (bool) {
855         return _operatorApprovals[owner][operator];
856     }
857 
858     /**
859      * @dev See {IERC721-transferFrom}.
860      */
861     function transferFrom(
862         address from,
863         address to,
864         uint256 tokenId
865     ) public override {
866         _transfer(from, to, tokenId);
867     }
868 
869     /**
870      * @dev See {IERC721-safeTransferFrom}.
871      */
872     function safeTransferFrom(
873         address from,
874         address to,
875         uint256 tokenId
876     ) public override {
877         safeTransferFrom(from, to, tokenId, '');
878     }
879 
880     /**
881      * @dev See {IERC721-safeTransferFrom}.
882      */
883     function safeTransferFrom(
884         address from,
885         address to,
886         uint256 tokenId,
887         bytes memory _data
888     ) public override {
889         _transfer(from, to, tokenId);
890         require(
891             _checkOnERC721Received(from, to, tokenId, _data),
892             'ERC721A: transfer to non ERC721Receiver implementer'
893         );
894     }
895 
896     /**
897      * @dev Returns whether `tokenId` exists.
898      *
899      * Tokens can be managed by their owner or approved accounts via {approve} or {setApprovalForAll}.
900      *
901      * Tokens start existing when they are minted (`_mint`),
902      */
903     function _exists(uint256 tokenId) internal view returns (bool) {
904         return tokenId < currentIndex;
905     }
906 
907     function _safeMint(address to, uint256 quantity) internal {
908         _safeMint(to, quantity, '');
909     }
910 
911     /**
912      * @dev Safely mints `quantity` tokens and transfers them to `to`.
913      *
914      * Requirements:
915      *
916      * - If `to` refers to a smart contract, it must implement {IERC721Receiver-onERC721Received}, which is called for each safe transfer.
917      * - `quantity` must be greater than 0.
918      *
919      * Emits a {Transfer} event.
920      */
921     function _safeMint(
922         address to,
923         uint256 quantity,
924         bytes memory _data
925     ) internal {
926         _mint(to, quantity, _data, true);
927     }
928 
929     /**
930      * @dev Mints `quantity` tokens and transfers them to `to`.
931      *
932      * Requirements:
933      *
934      * - `to` cannot be the zero address.
935      * - `quantity` must be greater than 0.
936      *
937      * Emits a {Transfer} event.
938      */
939     function _mint(
940         address to,
941         uint256 quantity,
942         bytes memory _data,
943         bool safe
944     ) internal {
945         uint256 startTokenId = currentIndex;
946         require(to != address(0), 'ERC721A: mint to the zero address');
947         require(quantity != 0, 'ERC721A: quantity must be greater than 0');
948 
949         _beforeTokenTransfers(address(0), to, startTokenId, quantity);
950 
951         // Overflows are incredibly unrealistic.
952         // balance or numberMinted overflow if current value of either + quantity > 3.4e38 (2**128) - 1
953         // updatedIndex overflows if currentIndex + quantity > 1.56e77 (2**256) - 1
954         unchecked {
955             _addressData[to].balance += uint128(quantity);
956             _addressData[to].numberMinted += uint128(quantity);
957 
958             _ownerships[startTokenId].addr = to;
959             _ownerships[startTokenId].startTimestamp = uint64(block.timestamp);
960 
961             uint256 updatedIndex = startTokenId;
962 
963             for (uint256 i; i < quantity; i++) {
964                 emit Transfer(address(0), to, updatedIndex);
965                 if (safe) {
966                     require(
967                         _checkOnERC721Received(address(0), to, updatedIndex, _data),
968                         'ERC721A: transfer to non ERC721Receiver implementer'
969                     );
970                 }
971 
972                 updatedIndex++;
973             }
974 
975             currentIndex = updatedIndex;
976         }
977 
978         _afterTokenTransfers(address(0), to, startTokenId, quantity);
979     }
980 
981     /**
982      * @dev Transfers `tokenId` from `from` to `to`.
983      *
984      * Requirements:
985      *
986      * - `to` cannot be the zero address.
987      * - `tokenId` token must be owned by `from`.
988      *
989      * Emits a {Transfer} event.
990      */
991     function _transfer(
992         address from,
993         address to,
994         uint256 tokenId
995     ) private {
996         TokenOwnership memory prevOwnership = ownershipOf(tokenId);
997 
998         bool isApprovedOrOwner = (_msgSender() == prevOwnership.addr ||
999             getApproved(tokenId) == _msgSender() ||
1000             isApprovedForAll(prevOwnership.addr, _msgSender()));
1001 
1002         require(isApprovedOrOwner, 'ERC721A: transfer caller is not owner nor approved');
1003 
1004         require(prevOwnership.addr == from, 'ERC721A: transfer from incorrect owner');
1005         require(to != address(0), 'ERC721A: transfer to the zero address');
1006 
1007         _beforeTokenTransfers(from, to, tokenId, 1);
1008 
1009         // Clear approvals from the previous owner
1010         _approve(address(0), tokenId, prevOwnership.addr);
1011 
1012         // Underflow of the sender's balance is impossible because we check for
1013         // ownership above and the recipient's balance can't realistically overflow.
1014         // Counter overflow is incredibly unrealistic as tokenId would have to be 2**256.
1015         unchecked {
1016             _addressData[from].balance -= 1;
1017             _addressData[to].balance += 1;
1018 
1019             _ownerships[tokenId].addr = to;
1020             _ownerships[tokenId].startTimestamp = uint64(block.timestamp);
1021 
1022             // If the ownership slot of tokenId+1 is not explicitly set, that means the transfer initiator owns it.
1023             // Set the slot of tokenId+1 explicitly in storage to maintain correctness for ownerOf(tokenId+1) calls.
1024             uint256 nextTokenId = tokenId + 1;
1025             if (_ownerships[nextTokenId].addr == address(0)) {
1026                 if (_exists(nextTokenId)) {
1027                     _ownerships[nextTokenId].addr = prevOwnership.addr;
1028                     _ownerships[nextTokenId].startTimestamp = prevOwnership.startTimestamp;
1029                 }
1030             }
1031         }
1032 
1033         emit Transfer(from, to, tokenId);
1034         _afterTokenTransfers(from, to, tokenId, 1);
1035     }
1036 
1037     /**
1038      * @dev Approve `to` to operate on `tokenId`
1039      *
1040      * Emits a {Approval} event.
1041      */
1042     function _approve(
1043         address to,
1044         uint256 tokenId,
1045         address owner
1046     ) private {
1047         _tokenApprovals[tokenId] = to;
1048         emit Approval(owner, to, tokenId);
1049     }
1050 
1051     /**
1052      * @dev Internal function to invoke {IERC721Receiver-onERC721Received} on a target address.
1053      * The call is not executed if the target address is not a contract.
1054      *
1055      * @param from address representing the previous owner of the given token ID
1056      * @param to target address that will receive the tokens
1057      * @param tokenId uint256 ID of the token to be transferred
1058      * @param _data bytes optional data to send along with the call
1059      * @return bool whether the call correctly returned the expected magic value
1060      */
1061     function _checkOnERC721Received(
1062         address from,
1063         address to,
1064         uint256 tokenId,
1065         bytes memory _data
1066     ) private returns (bool) {
1067         if (to.isContract()) {
1068             try IERC721Receiver(to).onERC721Received(_msgSender(), from, tokenId, _data) returns (bytes4 retval) {
1069                 return retval == IERC721Receiver(to).onERC721Received.selector;
1070             } catch (bytes memory reason) {
1071                 if (reason.length == 0) {
1072                     revert('ERC721A: transfer to non ERC721Receiver implementer');
1073                 } else {
1074                     assembly {
1075                         revert(add(32, reason), mload(reason))
1076                     }
1077                 }
1078             }
1079         } else {
1080             return true;
1081         }
1082     }
1083 
1084     /**
1085      * @dev Hook that is called before a set of serially-ordered token ids are about to be transferred. This includes minting.
1086      *
1087      * startTokenId - the first token id to be transferred
1088      * quantity - the amount to be transferred
1089      *
1090      * Calling conditions:
1091      *
1092      * - When `from` and `to` are both non-zero, ``from``'s `tokenId` will be
1093      * transferred to `to`.
1094      * - When `from` is zero, `tokenId` will be minted for `to`.
1095      */
1096     function _beforeTokenTransfers(
1097         address from,
1098         address to,
1099         uint256 startTokenId,
1100         uint256 quantity
1101     ) internal virtual {}
1102 
1103     /**
1104      * @dev Hook that is called after a set of serially-ordered token ids have been transferred. This includes
1105      * minting.
1106      *
1107      * startTokenId - the first token id to be transferred
1108      * quantity - the amount to be transferred
1109      *
1110      * Calling conditions:
1111      *
1112      * - when `from` and `to` are both non-zero.
1113      * - `from` and `to` are never both zero.
1114      */
1115     function _afterTokenTransfers(
1116         address from,
1117         address to,
1118         uint256 startTokenId,
1119         uint256 quantity
1120     ) internal virtual {}
1121 }
1122 
1123 
1124 // Ownable.sol
1125 
1126 pragma solidity ^0.8.0;
1127 
1128 /**
1129  * @dev Contract module which provides a basic access control mechanism, where
1130  * there is an account (an owner) that can be granted exclusive access to
1131  * specific functions.
1132  *
1133  * By default, the owner account will be the one that deploys the contract. This
1134  * can later be changed with {transferOwnership}.
1135  *
1136  * This module is used through inheritance. It will make available the modifier
1137  * `onlyOwner`, which can be applied to your functions to restrict their use to
1138  * the owner.
1139  */
1140 abstract contract Ownable is Context {
1141     address private _owner;
1142 
1143     event OwnershipTransferred(
1144         address indexed previousOwner,
1145         address indexed newOwner
1146     );
1147 
1148     /**
1149      * @dev Initializes the contract setting the deployer as the initial owner.
1150      */
1151     constructor() {
1152         _setOwner(_msgSender());
1153     }
1154 
1155     /**
1156      * @dev Returns the address of the current owner.
1157      */
1158     function owner() public view virtual returns (address) {
1159         return _owner;
1160     }
1161 
1162     /**
1163      * @dev Throws if called by any account other than the owner.
1164      */
1165     modifier onlyOwner() {
1166         require(owner() == _msgSender(), "Ownable: caller is not the owner");
1167         _;
1168     }
1169 
1170     /**
1171      * @dev Leaves the contract without owner. It will not be possible to call
1172      * `onlyOwner` functions anymore. Can only be called by the current owner.
1173      *
1174      * NOTE: Renouncing ownership will leave the contract without an owner,
1175      * thereby removing any functionality that is only available to the owner.
1176      */
1177     function renounceOwnership() public virtual onlyOwner {
1178         _setOwner(address(0));
1179     }
1180 
1181     /**
1182      * @dev Transfers ownership of the contract to a new account (`newOwner`).
1183      * Can only be called by the current owner.
1184      */
1185     function transferOwnership(address newOwner) public virtual onlyOwner {
1186         require(
1187             newOwner != address(0),
1188             "Ownable: new owner is the zero address"
1189         );
1190         _setOwner(newOwner);
1191     }
1192 
1193     function _setOwner(address newOwner) private {
1194         address oldOwner = _owner;
1195         _owner = newOwner;
1196         emit OwnershipTransferred(oldOwner, newOwner);
1197     }
1198 }
1199 
1200 pragma solidity ^0.8.0;
1201 
1202 /**
1203  * @dev Contract module that helps prevent reentrant calls to a function.
1204  *
1205  * Inheriting from `ReentrancyGuard` will make the {nonReentrant} modifier
1206  * available, which can be applied to functions to make sure there are no nested
1207  * (reentrant) calls to them.
1208  *
1209  * Note that because there is a single `nonReentrant` guard, functions marked as
1210  * `nonReentrant` may not call one another. This can be worked around by making
1211  * those functions `private`, and then adding `external` `nonReentrant` entry
1212  * points to them.
1213  *
1214  * TIP: If you would like to learn more about reentrancy and alternative ways
1215  * to protect against it, check out our blog post
1216  * https://blog.openzeppelin.com/reentrancy-after-istanbul/[Reentrancy After Istanbul].
1217  */
1218 abstract contract ReentrancyGuard {
1219     // Booleans are more expensive than uint256 or any type that takes up a full
1220     // word because each write operation emits an extra SLOAD to first read the
1221     // slot's contents, replace the bits taken up by the boolean, and then write
1222     // back. This is the compiler's defense against contract upgrades and
1223     // pointer aliasing, and it cannot be disabled.
1224 
1225     // The values being non-zero value makes deployment a bit more expensive,
1226     // but in exchange the refund on every call to nonReentrant will be lower in
1227     // amount. Since refunds are capped to a percentage of the total
1228     // transaction's gas, it is best to keep them low in cases like this one, to
1229     // increase the likelihood of the full refund coming into effect.
1230     uint256 private constant _NOT_ENTERED = 1;
1231     uint256 private constant _ENTERED = 2;
1232 
1233     uint256 private _status;
1234 
1235     constructor() {
1236         _status = _NOT_ENTERED;
1237     }
1238 
1239     /**
1240      * @dev Prevents a contract from calling itself, directly or indirectly.
1241      * Calling a `nonReentrant` function from another `nonReentrant`
1242      * function is not supported. It is possible to prevent this from happening
1243      * by making the `nonReentrant` function external, and make it call a
1244      * `private` function that does the actual work.
1245      */
1246     modifier nonReentrant() {
1247         // On the first call to nonReentrant, _notEntered will be true
1248         require(_status != _ENTERED, "ReentrancyGuard: reentrant call");
1249 
1250         // Any calls to nonReentrant after this point will fail
1251         _status = _ENTERED;
1252 
1253         _;
1254 
1255         // By storing the original value once again, a refund is triggered (see
1256         // https://eips.ethereum.org/EIPS/eip-2200)
1257         _status = _NOT_ENTERED;
1258     }
1259 }
1260 
1261 //saudigoblinswtf.sol
1262 pragma solidity ^0.8.0;
1263 
1264 
1265 contract saudigoblinswtf is ERC721A, Ownable, ReentrancyGuard {
1266     using Strings for uint256;
1267     string public baseURI;
1268     uint256 public cost = 0 ether;
1269     uint256 public maxSupply = 5555;
1270     uint256 public maxperAddress = 5;
1271 
1272     mapping(address => uint256) public addressMintedBalance;
1273 
1274     constructor() ERC721A("saudigoblinswtf", "saudigoblins.wtf") {
1275         setBaseURI("https://saudigoblins.s3.amazonaws.com/metadata/");
1276 
1277     }
1278 
1279     function _baseURI() internal view virtual override returns (string memory) {
1280         return baseURI;
1281     }
1282 
1283     function mint(uint256 _mintAmount) public payable nonReentrant{
1284 		uint256 s = totalSupply();
1285         uint256 addressMintedCount = addressMintedBalance[msg.sender];
1286         require(addressMintedCount + _mintAmount <= maxperAddress, "YOU'VE MINTED ENOUGH" );
1287 		require(_mintAmount > 0, "MINT AT LEAST ONE 1, DUMDUM" );
1288 		require(s + _mintAmount <= maxSupply, "SOLD OUT" );
1289         require(msg.value >= cost * _mintAmount, "DONT BE GREEDY" );
1290 		for (uint256 i = 0; i < _mintAmount; ++i) {
1291             addressMintedBalance[msg.sender]++;
1292 
1293 		}
1294         _safeMint(msg.sender, _mintAmount);
1295 		delete s;
1296         delete addressMintedCount;
1297 	}
1298 
1299     function gift(uint256[] calldata quantity, address[] calldata recipient)
1300         external onlyOwner {
1301         require(
1302             quantity.length == recipient.length,
1303             "PROVIDE QUANTITIES AND RECIPIENTS"
1304         );
1305         uint256 totalQuantity = 0;
1306         uint256 s = totalSupply();
1307         for (uint256 i = 0; i < quantity.length; ++i) {
1308             totalQuantity += quantity[i];
1309         }
1310         require(s + totalQuantity <= maxSupply, "TOO MANY");
1311         delete totalQuantity;
1312         for (uint256 i = 0; i < recipient.length; ++i) {
1313             _safeMint(recipient[i], quantity[i]);
1314         }
1315         delete s;
1316     }
1317 
1318     function tokenURI(uint256 tokenId)
1319         public view virtual override returns (string memory) {
1320         require(_exists(tokenId), "ERC721Metadata: Nonexistent token");
1321         string memory currentBaseURI = _baseURI();
1322         return
1323             bytes(currentBaseURI).length > 0
1324                 ? string(abi.encodePacked(currentBaseURI, tokenId.toString(), ".json"))
1325                 : "";
1326     }
1327 
1328     function setCost(uint256 _newCost) public onlyOwner {
1329         cost = _newCost;
1330     }
1331 
1332     function setmaxSupply(uint256 _newMaxSupply) public onlyOwner {
1333         require(_newMaxSupply <= maxSupply, "CANNOT INCREASE SUPPLY");
1334         maxSupply = _newMaxSupply;
1335     }
1336 
1337     function setBaseURI(string memory _newBaseURI) public onlyOwner {
1338         baseURI = _newBaseURI;
1339     }
1340 
1341     function setmaxperAddress(uint256 _amount) public onlyOwner {
1342         maxperAddress = _amount;
1343     }
1344 
1345     function withdraw() public payable onlyOwner {
1346         (bool success, ) = payable(msg.sender).call{
1347             value: address(this).balance
1348         }("");
1349         require(success);
1350     }
1351 
1352 }