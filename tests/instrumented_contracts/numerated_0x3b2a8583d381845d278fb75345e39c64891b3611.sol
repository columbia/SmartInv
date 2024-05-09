1 /**
2  *Submitted for verification at Etherscan.io on 2022-07-03
3 */
4 
5 // File: @openzeppelin/contracts/utils/Strings.sol
6 
7 
8 // OpenZeppelin Contracts v4.4.1 (utils/Strings.sol)
9 
10 pragma solidity ^0.8.0;
11 
12 /**
13  * @dev String operations.
14  */
15 library Strings {
16     bytes16 private constant _HEX_SYMBOLS = "0123456789abcdef";
17 
18     /**
19      * @dev Converts a `uint256` to its ASCII `string` decimal representation.
20      */
21     function toString(uint256 value) internal pure returns (string memory) {
22         // Inspired by OraclizeAPI's implementation - MIT licence
23         // https://github.com/oraclize/ethereum-api/blob/b42146b063c7d6ee1358846c198246239e9360e8/oraclizeAPI_0.4.25.sol
24 
25         if (value == 0) {
26             return "0";
27         }
28         uint256 temp = value;
29         uint256 digits;
30         while (temp != 0) {
31             digits++;
32             temp /= 10;
33         }
34         bytes memory buffer = new bytes(digits);
35         while (value != 0) {
36             digits -= 1;
37             buffer[digits] = bytes1(uint8(48 + uint256(value % 10)));
38             value /= 10;
39         }
40         return string(buffer);
41     }
42 
43     /**
44      * @dev Converts a `uint256` to its ASCII `string` hexadecimal representation.
45      */
46     function toHexString(uint256 value) internal pure returns (string memory) {
47         if (value == 0) {
48             return "0x00";
49         }
50         uint256 temp = value;
51         uint256 length = 0;
52         while (temp != 0) {
53             length++;
54             temp >>= 8;
55         }
56         return toHexString(value, length);
57     }
58 
59     /**
60      * @dev Converts a `uint256` to its ASCII `string` hexadecimal representation with fixed length.
61      */
62     function toHexString(uint256 value, uint256 length) internal pure returns (string memory) {
63         bytes memory buffer = new bytes(2 * length + 2);
64         buffer[0] = "0";
65         buffer[1] = "x";
66         for (uint256 i = 2 * length + 1; i > 1; --i) {
67             buffer[i] = _HEX_SYMBOLS[value & 0xf];
68             value >>= 4;
69         }
70         require(value == 0, "Strings: hex length insufficient");
71         return string(buffer);
72     }
73 }
74 
75 // File: @openzeppelin/contracts/utils/Context.sol
76 
77 
78 // OpenZeppelin Contracts v4.4.1 (utils/Context.sol)
79 
80 pragma solidity ^0.8.0;
81 
82 /**
83  * @dev Provides information about the current execution context, including the
84  * sender of the transaction and its data. While these are generally available
85  * via msg.sender and msg.data, they should not be accessed in such a direct
86  * manner, since when dealing with meta-transactions the account sending and
87  * paying for execution may not be the actual sender (as far as an application
88  * is concerned).
89  *
90  * This contract is only required for intermediate, library-like contracts.
91  */
92 abstract contract Context {
93     function _msgSender() internal view virtual returns (address) {
94         return msg.sender;
95     }
96 
97     function _msgData() internal view virtual returns (bytes calldata) {
98         return msg.data;
99     }
100 }
101 
102 // File: @openzeppelin/contracts/utils/Address.sol
103 
104 
105 // OpenZeppelin Contracts (last updated v4.5.0) (utils/Address.sol)
106 
107 pragma solidity ^0.8.1;
108 
109 /**
110  * @dev Collection of functions related to the address type
111  */
112 library Address {
113     /**
114      * @dev Returns true if `account` is a contract.
115      *
116      * [IMPORTANT]
117      * ====
118      * It is unsafe to assume that an address for which this function returns
119      * false is an externally-owned account (EOA) and not a contract.
120      *
121      * Among others, `isContract` will return false for the following
122      * types of addresses:
123      *
124      *  - an externally-owned account
125      *  - a contract in construction
126      *  - an address where a contract will be created
127      *  - an address where a contract lived, but was destroyed
128      * ====
129      *
130      * [IMPORTANT]
131      * ====
132      * You shouldn't rely on `isContract` to protect against flash loan attacks!
133      *
134      * Preventing calls from contracts is highly discouraged. It breaks composability, breaks support for smart wallets
135      * like Gnosis Safe, and does not provide security since it can be circumvented by calling from a contract
136      * constructor.
137      * ====
138      */
139     function isContract(address account) internal view returns (bool) {
140         // This method relies on extcodesize/address.code.length, which returns 0
141         // for contracts in construction, since the code is only stored at the end
142         // of the constructor execution.
143 
144         return account.code.length > 0;
145     }
146 
147     /**
148      * @dev Replacement for Solidity's `transfer`: sends `amount` wei to
149      * `recipient`, forwarding all available gas and reverting on errors.
150      *
151      * https://eips.ethereum.org/EIPS/eip-1884[EIP1884] increases the gas cost
152      * of certain opcodes, possibly making contracts go over the 2300 gas limit
153      * imposed by `transfer`, making them unable to receive funds via
154      * `transfer`. {sendValue} removes this limitation.
155      *
156      * https://diligence.consensys.net/posts/2019/09/stop-using-soliditys-transfer-now/[Learn more].
157      *
158      * IMPORTANT: because control is transferred to `recipient`, care must be
159      * taken to not create reentrancy vulnerabilities. Consider using
160      * {ReentrancyGuard} or the
161      * https://solidity.readthedocs.io/en/v0.5.11/security-considerations.html#use-the-checks-effects-interactions-pattern[checks-effects-interactions pattern].
162      */
163     function sendValue(address payable recipient, uint256 amount) internal {
164         require(address(this).balance >= amount, "Address: insufficient balance");
165 
166         (bool success, ) = recipient.call{value: amount}("");
167         require(success, "Address: unable to send value, recipient may have reverted");
168     }
169 
170     /**
171      * @dev Performs a Solidity function call using a low level `call`. A
172      * plain `call` is an unsafe replacement for a function call: use this
173      * function instead.
174      *
175      * If `target` reverts with a revert reason, it is bubbled up by this
176      * function (like regular Solidity function calls).
177      *
178      * Returns the raw returned data. To convert to the expected return value,
179      * use https://solidity.readthedocs.io/en/latest/units-and-global-variables.html?highlight=abi.decode#abi-encoding-and-decoding-functions[`abi.decode`].
180      *
181      * Requirements:
182      *
183      * - `target` must be a contract.
184      * - calling `target` with `data` must not revert.
185      *
186      * _Available since v3.1._
187      */
188     function functionCall(address target, bytes memory data) internal returns (bytes memory) {
189         return functionCall(target, data, "Address: low-level call failed");
190     }
191 
192     /**
193      * @dev Same as {xref-Address-functionCall-address-bytes-}[`functionCall`], but with
194      * `errorMessage` as a fallback revert reason when `target` reverts.
195      *
196      * _Available since v3.1._
197      */
198     function functionCall(
199         address target,
200         bytes memory data,
201         string memory errorMessage
202     ) internal returns (bytes memory) {
203         return functionCallWithValue(target, data, 0, errorMessage);
204     }
205 
206     /**
207      * @dev Same as {xref-Address-functionCall-address-bytes-}[`functionCall`],
208      * but also transferring `value` wei to `target`.
209      *
210      * Requirements:
211      *
212      * - the calling contract must have an ETH balance of at least `value`.
213      * - the called Solidity function must be `payable`.
214      *
215      * _Available since v3.1._
216      */
217     function functionCallWithValue(
218         address target,
219         bytes memory data,
220         uint256 value
221     ) internal returns (bytes memory) {
222         return functionCallWithValue(target, data, value, "Address: low-level call with value failed");
223     }
224 
225     /**
226      * @dev Same as {xref-Address-functionCallWithValue-address-bytes-uint256-}[`functionCallWithValue`], but
227      * with `errorMessage` as a fallback revert reason when `target` reverts.
228      *
229      * _Available since v3.1._
230      */
231     function functionCallWithValue(
232         address target,
233         bytes memory data,
234         uint256 value,
235         string memory errorMessage
236     ) internal returns (bytes memory) {
237         require(address(this).balance >= value, "Address: insufficient balance for call");
238         require(isContract(target), "Address: call to non-contract");
239 
240         (bool success, bytes memory returndata) = target.call{value: value}(data);
241         return verifyCallResult(success, returndata, errorMessage);
242     }
243 
244     /**
245      * @dev Same as {xref-Address-functionCall-address-bytes-}[`functionCall`],
246      * but performing a static call.
247      *
248      * _Available since v3.3._
249      */
250     function functionStaticCall(address target, bytes memory data) internal view returns (bytes memory) {
251         return functionStaticCall(target, data, "Address: low-level static call failed");
252     }
253 
254     /**
255      * @dev Same as {xref-Address-functionCall-address-bytes-string-}[`functionCall`],
256      * but performing a static call.
257      *
258      * _Available since v3.3._
259      */
260     function functionStaticCall(
261         address target,
262         bytes memory data,
263         string memory errorMessage
264     ) internal view returns (bytes memory) {
265         require(isContract(target), "Address: static call to non-contract");
266 
267         (bool success, bytes memory returndata) = target.staticcall(data);
268         return verifyCallResult(success, returndata, errorMessage);
269     }
270 
271     /**
272      * @dev Same as {xref-Address-functionCall-address-bytes-}[`functionCall`],
273      * but performing a delegate call.
274      *
275      * _Available since v3.4._
276      */
277     function functionDelegateCall(address target, bytes memory data) internal returns (bytes memory) {
278         return functionDelegateCall(target, data, "Address: low-level delegate call failed");
279     }
280 
281     /**
282      * @dev Same as {xref-Address-functionCall-address-bytes-string-}[`functionCall`],
283      * but performing a delegate call.
284      *
285      * _Available since v3.4._
286      */
287     function functionDelegateCall(
288         address target,
289         bytes memory data,
290         string memory errorMessage
291     ) internal returns (bytes memory) {
292         require(isContract(target), "Address: delegate call to non-contract");
293 
294         (bool success, bytes memory returndata) = target.delegatecall(data);
295         return verifyCallResult(success, returndata, errorMessage);
296     }
297 
298     /**
299      * @dev Tool to verifies that a low level call was successful, and revert if it wasn't, either by bubbling the
300      * revert reason using the provided one.
301      *
302      * _Available since v4.3._
303      */
304     function verifyCallResult(
305         bool success,
306         bytes memory returndata,
307         string memory errorMessage
308     ) internal pure returns (bytes memory) {
309         if (success) {
310             return returndata;
311         } else {
312             // Look for revert reason and bubble it up if present
313             if (returndata.length > 0) {
314                 // The easiest way to bubble the revert reason is using memory via assembly
315 
316                 assembly {
317                     let returndata_size := mload(returndata)
318                     revert(add(32, returndata), returndata_size)
319                 }
320             } else {
321                 revert(errorMessage);
322             }
323         }
324     }
325 }
326 
327 // File: @openzeppelin/contracts/token/ERC721/IERC721Receiver.sol
328 
329 
330 // OpenZeppelin Contracts (last updated v4.6.0) (token/ERC721/IERC721Receiver.sol)
331 
332 pragma solidity ^0.8.0;
333 
334 /**
335  * @title ERC721 token receiver interface
336  * @dev Interface for any contract that wants to support safeTransfers
337  * from ERC721 asset contracts.
338  */
339 interface IERC721Receiver {
340     /**
341      * @dev Whenever an {IERC721} `tokenId` token is transferred to this contract via {IERC721-safeTransferFrom}
342      * by `operator` from `from`, this function is called.
343      *
344      * It must return its Solidity selector to confirm the token transfer.
345      * If any other value is returned or the interface is not implemented by the recipient, the transfer will be reverted.
346      *
347      * The selector can be obtained in Solidity with `IERC721Receiver.onERC721Received.selector`.
348      */
349     function onERC721Received(
350         address operator,
351         address from,
352         uint256 tokenId,
353         bytes calldata data
354     ) external returns (bytes4);
355 }
356 
357 // File: @openzeppelin/contracts/utils/introspection/IERC165.sol
358 
359 
360 // OpenZeppelin Contracts v4.4.1 (utils/introspection/IERC165.sol)
361 
362 pragma solidity ^0.8.0;
363 
364 /**
365  * @dev Interface of the ERC165 standard, as defined in the
366  * https://eips.ethereum.org/EIPS/eip-165[EIP].
367  *
368  * Implementers can declare support of contract interfaces, which can then be
369  * queried by others ({ERC165Checker}).
370  *
371  * For an implementation, see {ERC165}.
372  */
373 interface IERC165 {
374     /**
375      * @dev Returns true if this contract implements the interface defined by
376      * `interfaceId`. See the corresponding
377      * https://eips.ethereum.org/EIPS/eip-165#how-interfaces-are-identified[EIP section]
378      * to learn more about how these ids are created.
379      *
380      * This function call must use less than 30 000 gas.
381      */
382     function supportsInterface(bytes4 interfaceId) external view returns (bool);
383 }
384 
385 // File: @openzeppelin/contracts/utils/introspection/ERC165.sol
386 
387 
388 // OpenZeppelin Contracts v4.4.1 (utils/introspection/ERC165.sol)
389 
390 pragma solidity ^0.8.0;
391 
392 
393 /**
394  * @dev Implementation of the {IERC165} interface.
395  *
396  * Contracts that want to implement ERC165 should inherit from this contract and override {supportsInterface} to check
397  * for the additional interface id that will be supported. For example:
398  *
399  * ```solidity
400  * function supportsInterface(bytes4 interfaceId) public view virtual override returns (bool) {
401  *     return interfaceId == type(MyInterface).interfaceId || super.supportsInterface(interfaceId);
402  * }
403  * ```
404  *
405  * Alternatively, {ERC165Storage} provides an easier to use but more expensive implementation.
406  */
407 abstract contract ERC165 is IERC165 {
408     /**
409      * @dev See {IERC165-supportsInterface}.
410      */
411     function supportsInterface(bytes4 interfaceId) public view virtual override returns (bool) {
412         return interfaceId == type(IERC165).interfaceId;
413     }
414 }
415 
416 // File: @openzeppelin/contracts/token/ERC721/IERC721.sol
417 
418 
419 // OpenZeppelin Contracts (last updated v4.6.0) (token/ERC721/IERC721.sol)
420 
421 pragma solidity ^0.8.0;
422 
423 
424 /**
425  * @dev Required interface of an ERC721 compliant contract.
426  */
427 interface IERC721 is IERC165 {
428     /**
429      * @dev Emitted when `tokenId` token is transferred from `from` to `to`.
430      */
431     event Transfer(address indexed from, address indexed to, uint256 indexed tokenId);
432 
433     /**
434      * @dev Emitted when `owner` enables `approved` to manage the `tokenId` token.
435      */
436     event Approval(address indexed owner, address indexed approved, uint256 indexed tokenId);
437 
438     /**
439      * @dev Emitted when `owner` enables or disables (`approved`) `operator` to manage all of its assets.
440      */
441     event ApprovalForAll(address indexed owner, address indexed operator, bool approved);
442 
443     /**
444      * @dev Returns the number of tokens in ``owner``'s account.
445      */
446     function balanceOf(address owner) external view returns (uint256 balance);
447 
448     /**
449      * @dev Returns the owner of the `tokenId` token.
450      *
451      * Requirements:
452      *
453      * - `tokenId` must exist.
454      */
455     function ownerOf(uint256 tokenId) external view returns (address owner);
456 
457     /**
458      * @dev Safely transfers `tokenId` token from `from` to `to`.
459      *
460      * Requirements:
461      *
462      * - `from` cannot be the zero address.
463      * - `to` cannot be the zero address.
464      * - `tokenId` token must exist and be owned by `from`.
465      * - If the caller is not `from`, it must be approved to move this token by either {approve} or {setApprovalForAll}.
466      * - If `to` refers to a smart contract, it must implement {IERC721Receiver-onERC721Received}, which is called upon a safe transfer.
467      *
468      * Emits a {Transfer} event.
469      */
470     function safeTransferFrom(
471         address from,
472         address to,
473         uint256 tokenId,
474         bytes calldata data
475     ) external;
476 
477     /**
478      * @dev Safely transfers `tokenId` token from `from` to `to`, checking first that contract recipients
479      * are aware of the ERC721 protocol to prevent tokens from being forever locked.
480      *
481      * Requirements:
482      *
483      * - `from` cannot be the zero address.
484      * - `to` cannot be the zero address.
485      * - `tokenId` token must exist and be owned by `from`.
486      * - If the caller is not `from`, it must be have been allowed to move this token by either {approve} or {setApprovalForAll}.
487      * - If `to` refers to a smart contract, it must implement {IERC721Receiver-onERC721Received}, which is called upon a safe transfer.
488      *
489      * Emits a {Transfer} event.
490      */
491     function safeTransferFrom(
492         address from,
493         address to,
494         uint256 tokenId
495     ) external;
496 
497     /**
498      * @dev Transfers `tokenId` token from `from` to `to`.
499      *
500      * WARNING: Usage of this method is discouraged, use {safeTransferFrom} whenever possible.
501      *
502      * Requirements:
503      *
504      * - `from` cannot be the zero address.
505      * - `to` cannot be the zero address.
506      * - `tokenId` token must be owned by `from`.
507      * - If the caller is not `from`, it must be approved to move this token by either {approve} or {setApprovalForAll}.
508      *
509      * Emits a {Transfer} event.
510      */
511     function transferFrom(
512         address from,
513         address to,
514         uint256 tokenId
515     ) external;
516 
517     /**
518      * @dev Gives permission to `to` to transfer `tokenId` token to another account.
519      * The approval is cleared when the token is transferred.
520      *
521      * Only a single account can be approved at a time, so approving the zero address clears previous approvals.
522      *
523      * Requirements:
524      *
525      * - The caller must own the token or be an approved operator.
526      * - `tokenId` must exist.
527      *
528      * Emits an {Approval} event.
529      */
530     function approve(address to, uint256 tokenId) external;
531 
532     /**
533      * @dev Approve or remove `operator` as an operator for the caller.
534      * Operators can call {transferFrom} or {safeTransferFrom} for any token owned by the caller.
535      *
536      * Requirements:
537      *
538      * - The `operator` cannot be the caller.
539      *
540      * Emits an {ApprovalForAll} event.
541      */
542     function setApprovalForAll(address operator, bool _approved) external;
543 
544     /**
545      * @dev Returns the account approved for `tokenId` token.
546      *
547      * Requirements:
548      *
549      * - `tokenId` must exist.
550      */
551     function getApproved(uint256 tokenId) external view returns (address operator);
552 
553     /**
554      * @dev Returns if the `operator` is allowed to manage all of the assets of `owner`.
555      *
556      * See {setApprovalForAll}
557      */
558     function isApprovedForAll(address owner, address operator) external view returns (bool);
559 }
560 
561 // File: @openzeppelin/contracts/token/ERC721/extensions/IERC721Enumerable.sol
562 
563 
564 // OpenZeppelin Contracts (last updated v4.5.0) (token/ERC721/extensions/IERC721Enumerable.sol)
565 
566 pragma solidity ^0.8.0;
567 
568 
569 /**
570  * @title ERC-721 Non-Fungible Token Standard, optional enumeration extension
571  * @dev See https://eips.ethereum.org/EIPS/eip-721
572  */
573 interface IERC721Enumerable is IERC721 {
574     /**
575      * @dev Returns the total amount of tokens stored by the contract.
576      */
577     function totalSupply() external view returns (uint256);
578 
579     /**
580      * @dev Returns a token ID owned by `owner` at a given `index` of its token list.
581      * Use along with {balanceOf} to enumerate all of ``owner``'s tokens.
582      */
583     function tokenOfOwnerByIndex(address owner, uint256 index) external view returns (uint256);
584 
585     /**
586      * @dev Returns a token ID at a given `index` of all the tokens stored by the contract.
587      * Use along with {totalSupply} to enumerate all tokens.
588      */
589     function tokenByIndex(uint256 index) external view returns (uint256);
590 }
591 
592 // File: @openzeppelin/contracts/token/ERC721/extensions/IERC721Metadata.sol
593 
594 
595 // OpenZeppelin Contracts v4.4.1 (token/ERC721/extensions/IERC721Metadata.sol)
596 
597 pragma solidity ^0.8.0;
598 
599 
600 /**
601  * @title ERC-721 Non-Fungible Token Standard, optional metadata extension
602  * @dev See https://eips.ethereum.org/EIPS/eip-721
603  */
604 interface IERC721Metadata is IERC721 {
605     /**
606      * @dev Returns the token collection name.
607      */
608     function name() external view returns (string memory);
609 
610     /**
611      * @dev Returns the token collection symbol.
612      */
613     function symbol() external view returns (string memory);
614 
615     /**
616      * @dev Returns the Uniform Resource Identifier (URI) for `tokenId` token.
617      */
618     function tokenURI(uint256 tokenId) external view returns (string memory);
619 }
620 
621 // File: ERC721A.sol
622 
623 
624 // Creator: Chiru Labs
625 
626 pragma solidity ^0.8.0;
627 
628 
629 
630 
631 
632 
633 
634 
635 
636 /**
637  * @dev Implementation of https://eips.ethereum.org/EIPS/eip-721[ERC721] Non-Fungible Token Standard, including
638  * the Metadata and Enumerable extension. Built to optimize for lower gas during batch mints.
639  *
640  * Assumes serials are sequentially minted starting at 0 (e.g. 0, 1, 2, 3..).
641  *
642  * Does not support burning tokens to address(0).
643  *
644  * Assumes that an owner cannot have more than the 2**128 - 1 (max value of uint128) of supply
645  */
646 contract ERC721A is Context, ERC165, IERC721, IERC721Metadata, IERC721Enumerable {
647     using Address for address;
648     using Strings for uint256;
649 
650     struct TokenOwnership {
651         address addr;
652         uint64 startTimestamp;
653     }
654 
655     struct AddressData {
656         uint128 balance;
657         uint128 numberMinted;
658     }
659 
660     uint256 internal currentIndex;
661 
662     // Token name
663     string private _name;
664 
665     // Token symbol
666     string private _symbol;
667 
668     // Mapping from token ID to ownership details
669     // An empty struct value does not necessarily mean the token is unowned. See ownershipOf implementation for details.
670     mapping(uint256 => TokenOwnership) internal _ownerships;
671 
672     // Mapping owner address to address data
673     mapping(address => AddressData) private _addressData;
674 
675     // Mapping from token ID to approved address
676     mapping(uint256 => address) private _tokenApprovals;
677 
678     // Mapping from owner to operator approvals
679     mapping(address => mapping(address => bool)) private _operatorApprovals;
680 
681     constructor(string memory name_, string memory symbol_) {
682         _name = name_;
683         _symbol = symbol_;
684     }
685 
686     /**
687      * @dev See {IERC721Enumerable-totalSupply}.
688      */
689     function totalSupply() public view override returns (uint256) {
690         return currentIndex;
691     }
692 
693     /**
694      * @dev See {IERC721Enumerable-tokenByIndex}.
695      */
696     function tokenByIndex(uint256 index) public view override returns (uint256) {
697         require(index < totalSupply(), 'ERC721A: global index out of bounds');
698         return index;
699     }
700 
701     /**
702      * @dev See {IERC721Enumerable-tokenOfOwnerByIndex}.
703      * This read function is O(totalSupply). If calling from a separate contract, be sure to test gas first.
704      * It may also degrade with extremely large collection sizes (e.g >> 10000), test for your use case.
705      */
706     function tokenOfOwnerByIndex(address owner, uint256 index) public view override returns (uint256) {
707         require(index < balanceOf(owner), 'ERC721A: owner index out of bounds');
708         uint256 numMintedSoFar = totalSupply();
709         uint256 tokenIdsIdx;
710         address currOwnershipAddr;
711 
712         // Counter overflow is impossible as the loop breaks when uint256 i is equal to another uint256 numMintedSoFar.
713         unchecked {
714             for (uint256 i; i < numMintedSoFar; i++) {
715                 TokenOwnership memory ownership = _ownerships[i];
716                 if (ownership.addr != address(0)) {
717                     currOwnershipAddr = ownership.addr;
718                 }
719                 if (currOwnershipAddr == owner) {
720                     if (tokenIdsIdx == index) {
721                         return i;
722                     }
723                     tokenIdsIdx++;
724                 }
725             }
726         }
727 
728         revert('ERC721A: unable to get token of owner by index');
729     }
730 
731     /**
732      * @dev See {IERC165-supportsInterface}.
733      */
734     function supportsInterface(bytes4 interfaceId) public view virtual override(ERC165, IERC165) returns (bool) {
735         return
736             interfaceId == type(IERC721).interfaceId ||
737             interfaceId == type(IERC721Metadata).interfaceId ||
738             interfaceId == type(IERC721Enumerable).interfaceId ||
739             super.supportsInterface(interfaceId);
740     }
741 
742     /**
743      * @dev See {IERC721-balanceOf}.
744      */
745     function balanceOf(address owner) public view override returns (uint256) {
746         require(owner != address(0), 'ERC721A: balance query for the zero address');
747         return uint256(_addressData[owner].balance);
748     }
749 
750     function _numberMinted(address owner) internal view returns (uint256) {
751         require(owner != address(0), 'ERC721A: number minted query for the zero address');
752         return uint256(_addressData[owner].numberMinted);
753     }
754 
755     /**
756      * Gas spent here starts off proportional to the maximum mint batch size.
757      * It gradually moves to O(1) as tokens get transferred around in the collection over time.
758      */
759     function ownershipOf(uint256 tokenId) internal view returns (TokenOwnership memory) {
760         require(_exists(tokenId), 'ERC721A: owner query for nonexistent token');
761 
762         unchecked {
763             for (uint256 curr = tokenId; curr >= 0; curr--) {
764                 TokenOwnership memory ownership = _ownerships[curr];
765                 if (ownership.addr != address(0)) {
766                     return ownership;
767                 }
768             }
769         }
770 
771         revert('ERC721A: unable to determine the owner of token');
772     }
773 
774     /**
775      * @dev See {IERC721-ownerOf}.
776      */
777     function ownerOf(uint256 tokenId) public view override returns (address) {
778         return ownershipOf(tokenId).addr;
779     }
780 
781     /**
782      * @dev See {IERC721Metadata-name}.
783      */
784     function name() public view virtual override returns (string memory) {
785         return _name;
786     }
787 
788     /**
789      * @dev See {IERC721Metadata-symbol}.
790      */
791     function symbol() public view virtual override returns (string memory) {
792         return _symbol;
793     }
794 
795     /**
796      * @dev See {IERC721Metadata-tokenURI}.
797      */
798     function tokenURI(uint256 tokenId) public view virtual override returns (string memory) {
799         require(_exists(tokenId), 'ERC721Metadata: URI query for nonexistent token');
800 
801         string memory baseURI = _baseURI();
802         return bytes(baseURI).length != 0 ? string(abi.encodePacked(baseURI, tokenId.toString())) : '';
803     }
804 
805     /**
806      * @dev Base URI for computing {tokenURI}. If set, the resulting URI for each
807      * token will be the concatenation of the `baseURI` and the `tokenId`. Empty
808      * by default, can be overriden in child contracts.
809      */
810     function _baseURI() internal view virtual returns (string memory) {
811         return '';
812     }
813 
814     /**
815      * @dev See {IERC721-approve}.
816      */
817     function approve(address to, uint256 tokenId) public override {
818         address owner = ERC721A.ownerOf(tokenId);
819         require(to != owner, 'ERC721A: approval to current owner');
820 
821         require(
822             _msgSender() == owner || isApprovedForAll(owner, _msgSender()),
823             'ERC721A: approve caller is not owner nor approved for all'
824         );
825 
826         _approve(to, tokenId, owner);
827     }
828 
829     /**
830      * @dev See {IERC721-getApproved}.
831      */
832     function getApproved(uint256 tokenId) public view override returns (address) {
833         require(_exists(tokenId), 'ERC721A: approved query for nonexistent token');
834 
835         return _tokenApprovals[tokenId];
836     }
837 
838     /**
839      * @dev See {IERC721-setApprovalForAll}.
840      */
841     function setApprovalForAll(address operator, bool approved) public override {
842         require(operator != _msgSender(), 'ERC721A: approve to caller');
843 
844         _operatorApprovals[_msgSender()][operator] = approved;
845         emit ApprovalForAll(_msgSender(), operator, approved);
846     }
847 
848     /**
849      * @dev See {IERC721-isApprovedForAll}.
850      */
851     function isApprovedForAll(address owner, address operator) public view virtual override returns (bool) {
852         return _operatorApprovals[owner][operator];
853     }
854 
855     /**
856      * @dev See {IERC721-transferFrom}.
857      */
858     function transferFrom(
859         address from,
860         address to,
861         uint256 tokenId
862     ) public override {
863         _transfer(from, to, tokenId);
864     }
865 
866     /**
867      * @dev See {IERC721-safeTransferFrom}.
868      */
869     function safeTransferFrom(
870         address from,
871         address to,
872         uint256 tokenId
873     ) public override {
874         safeTransferFrom(from, to, tokenId, '');
875     }
876 
877     /**
878      * @dev See {IERC721-safeTransferFrom}.
879      */
880     function safeTransferFrom(
881         address from,
882         address to,
883         uint256 tokenId,
884         bytes memory _data
885     ) public override {
886         _transfer(from, to, tokenId);
887         require(
888             _checkOnERC721Received(from, to, tokenId, _data),
889             'ERC721A: transfer to non ERC721Receiver implementer'
890         );
891     }
892 
893     /**
894      * @dev Returns whether `tokenId` exists.
895      *
896      * Tokens can be managed by their owner or approved accounts via {approve} or {setApprovalForAll}.
897      *
898      * Tokens start existing when they are minted (`_mint`),
899      */
900     function _exists(uint256 tokenId) internal view returns (bool) {
901         return tokenId < currentIndex;
902     }
903 
904     function _safeMint(address to, uint256 quantity) internal {
905         _safeMint(to, quantity, '');
906     }
907 
908     /**
909      * @dev Safely mints `quantity` tokens and transfers them to `to`.
910      *
911      * Requirements:
912      *
913      * - If `to` refers to a smart contract, it must implement {IERC721Receiver-onERC721Received}, which is called for each safe transfer.
914      * - `quantity` must be greater than 0.
915      *
916      * Emits a {Transfer} event.
917      */
918     function _safeMint(
919         address to,
920         uint256 quantity,
921         bytes memory _data
922     ) internal {
923         _mint(to, quantity, _data, true);
924     }
925 
926     /**
927      * @dev Mints `quantity` tokens and transfers them to `to`.
928      *
929      * Requirements:
930      *
931      * - `to` cannot be the zero address.
932      * - `quantity` must be greater than 0.
933      *
934      * Emits a {Transfer} event.
935      */
936     function _mint(
937         address to,
938         uint256 quantity,
939         bytes memory _data,
940         bool safe
941     ) internal {
942         uint256 startTokenId = currentIndex;
943         require(to != address(0), 'ERC721A: mint to the zero address');
944         require(quantity != 0, 'ERC721A: quantity must be greater than 0');
945 
946         _beforeTokenTransfers(address(0), to, startTokenId, quantity);
947 
948         // Overflows are incredibly unrealistic.
949         // balance or numberMinted overflow if current value of either + quantity > 3.4e38 (2**128) - 1
950         // updatedIndex overflows if currentIndex + quantity > 1.56e77 (2**256) - 1
951         unchecked {
952             _addressData[to].balance += uint128(quantity);
953             _addressData[to].numberMinted += uint128(quantity);
954 
955             _ownerships[startTokenId].addr = to;
956             _ownerships[startTokenId].startTimestamp = uint64(block.timestamp);
957 
958             uint256 updatedIndex = startTokenId;
959 
960             for (uint256 i; i < quantity; i++) {
961                 emit Transfer(address(0), to, updatedIndex);
962                 if (safe) {
963                     require(
964                         _checkOnERC721Received(address(0), to, updatedIndex, _data),
965                         'ERC721A: transfer to non ERC721Receiver implementer'
966                     );
967                 }
968 
969                 updatedIndex++;
970             }
971 
972             currentIndex = updatedIndex;
973         }
974 
975         _afterTokenTransfers(address(0), to, startTokenId, quantity);
976     }
977 
978     /**
979      * @dev Transfers `tokenId` from `from` to `to`.
980      *
981      * Requirements:
982      *
983      * - `to` cannot be the zero address.
984      * - `tokenId` token must be owned by `from`.
985      *
986      * Emits a {Transfer} event.
987      */
988     function _transfer(
989         address from,
990         address to,
991         uint256 tokenId
992     ) private {
993         TokenOwnership memory prevOwnership = ownershipOf(tokenId);
994 
995         bool isApprovedOrOwner = (_msgSender() == prevOwnership.addr ||
996             getApproved(tokenId) == _msgSender() ||
997             isApprovedForAll(prevOwnership.addr, _msgSender()));
998 
999         require(isApprovedOrOwner, 'ERC721A: transfer caller is not owner nor approved');
1000 
1001         require(prevOwnership.addr == from, 'ERC721A: transfer from incorrect owner');
1002         require(to != address(0), 'ERC721A: transfer to the zero address');
1003 
1004         _beforeTokenTransfers(from, to, tokenId, 1);
1005 
1006         // Clear approvals from the previous owner
1007         _approve(address(0), tokenId, prevOwnership.addr);
1008 
1009         // Underflow of the sender's balance is impossible because we check for
1010         // ownership above and the recipient's balance can't realistically overflow.
1011         // Counter overflow is incredibly unrealistic as tokenId would have to be 2**256.
1012         unchecked {
1013             _addressData[from].balance -= 1;
1014             _addressData[to].balance += 1;
1015 
1016             _ownerships[tokenId].addr = to;
1017             _ownerships[tokenId].startTimestamp = uint64(block.timestamp);
1018 
1019             // If the ownership slot of tokenId+1 is not explicitly set, that means the transfer initiator owns it.
1020             // Set the slot of tokenId+1 explicitly in storage to maintain correctness for ownerOf(tokenId+1) calls.
1021             uint256 nextTokenId = tokenId + 1;
1022             if (_ownerships[nextTokenId].addr == address(0)) {
1023                 if (_exists(nextTokenId)) {
1024                     _ownerships[nextTokenId].addr = prevOwnership.addr;
1025                     _ownerships[nextTokenId].startTimestamp = prevOwnership.startTimestamp;
1026                 }
1027             }
1028         }
1029 
1030         emit Transfer(from, to, tokenId);
1031         _afterTokenTransfers(from, to, tokenId, 1);
1032     }
1033 
1034     /**
1035      * @dev Approve `to` to operate on `tokenId`
1036      *
1037      * Emits a {Approval} event.
1038      */
1039     function _approve(
1040         address to,
1041         uint256 tokenId,
1042         address owner
1043     ) private {
1044         _tokenApprovals[tokenId] = to;
1045         emit Approval(owner, to, tokenId);
1046     }
1047 
1048     /**
1049      * @dev Internal function to invoke {IERC721Receiver-onERC721Received} on a target address.
1050      * The call is not executed if the target address is not a contract.
1051      *
1052      * @param from address representing the previous owner of the given token ID
1053      * @param to target address that will receive the tokens
1054      * @param tokenId uint256 ID of the token to be transferred
1055      * @param _data bytes optional data to send along with the call
1056      * @return bool whether the call correctly returned the expected magic value
1057      */
1058     function _checkOnERC721Received(
1059         address from,
1060         address to,
1061         uint256 tokenId,
1062         bytes memory _data
1063     ) private returns (bool) {
1064         if (to.isContract()) {
1065             try IERC721Receiver(to).onERC721Received(_msgSender(), from, tokenId, _data) returns (bytes4 retval) {
1066                 return retval == IERC721Receiver(to).onERC721Received.selector;
1067             } catch (bytes memory reason) {
1068                 if (reason.length == 0) {
1069                     revert('ERC721A: transfer to non ERC721Receiver implementer');
1070                 } else {
1071                     assembly {
1072                         revert(add(32, reason), mload(reason))
1073                     }
1074                 }
1075             }
1076         } else {
1077             return true;
1078         }
1079     }
1080 
1081     /**
1082      * @dev Hook that is called before a set of serially-ordered token ids are about to be transferred. This includes minting.
1083      *
1084      * startTokenId - the first token id to be transferred
1085      * quantity - the amount to be transferred
1086      *
1087      * Calling conditions:
1088      *
1089      * - When `from` and `to` are both non-zero, ``from``'s `tokenId` will be
1090      * transferred to `to`.
1091      * - When `from` is zero, `tokenId` will be minted for `to`.
1092      */
1093     function _beforeTokenTransfers(
1094         address from,
1095         address to,
1096         uint256 startTokenId,
1097         uint256 quantity
1098     ) internal virtual {}
1099 
1100     /**
1101      * @dev Hook that is called after a set of serially-ordered token ids have been transferred. This includes
1102      * minting.
1103      *
1104      * startTokenId - the first token id to be transferred
1105      * quantity - the amount to be transferred
1106      *
1107      * Calling conditions:
1108      *
1109      * - when `from` and `to` are both non-zero.
1110      * - `from` and `to` are never both zero.
1111      */
1112     function _afterTokenTransfers(
1113         address from,
1114         address to,
1115         uint256 startTokenId,
1116         uint256 quantity
1117     ) internal virtual {}
1118 }
1119 // File: MutantAIYachtClub.sol
1120 
1121 
1122 
1123 pragma solidity ^0.8.0;
1124 
1125 /**
1126  * @dev Contract module which allows children to implement an emergency stop
1127  * mechanism that can be triggered by an authorized account.
1128  *
1129  * This module is used through inheritance. It will make available the
1130  * modifiers `whenNotPaused` and `whenPaused`, which can be applied to
1131  * the functions of your contract. Note that they will not be pausable by
1132  * simply including this module, only once the modifiers are put in place.
1133  */
1134 abstract contract Pausable is Context {
1135     /**
1136      * @dev Emitted when the pause is triggered by `account`.
1137      */
1138     event Paused(address account);
1139 
1140     /**
1141      * @dev Emitted when the pause is lifted by `account`.
1142      */
1143     event Unpaused(address account);
1144 
1145     bool private _paused;
1146 
1147     /**
1148      * @dev Initializes the contract in unpaused state.
1149      */
1150     constructor() {
1151         _paused = false;
1152     }
1153 
1154     /**
1155      * @dev Returns true if the contract is paused, and false otherwise.
1156      */
1157     function paused() public view virtual returns (bool) {
1158         return _paused;
1159     }
1160 
1161     /**
1162      * @dev Modifier to make a function callable only when the contract is not paused.
1163      *
1164      * Requirements:
1165      *
1166      * - The contract must not be paused.
1167      */
1168     modifier whenNotPaused() {
1169         require(!paused(), "Pausable: paused");
1170         _;
1171     }
1172 
1173     /**
1174      * @dev Modifier to make a function callable only when the contract is paused.
1175      *
1176      * Requirements:
1177      *
1178      * - The contract must be paused.
1179      */
1180     modifier whenPaused() {
1181         require(paused(), "Pausable: not paused");
1182         _;
1183     }
1184 
1185     /**
1186      * @dev Triggers stopped state.
1187      *
1188      * Requirements:
1189      *
1190      * - The contract must not be paused.
1191      */
1192     function _pause() internal virtual whenNotPaused {
1193         _paused = true;
1194         emit Paused(_msgSender());
1195     }
1196 
1197     /**
1198      * @dev Returns to normal state.
1199      *
1200      * Requirements:
1201      *
1202      * - The contract must be paused.
1203      */
1204     function _unpause() internal virtual whenPaused {
1205         _paused = false;
1206         emit Unpaused(_msgSender());
1207     }
1208 }
1209 
1210 // Ownable.sol
1211 
1212 pragma solidity ^0.8.0;
1213 
1214 /**
1215  * @dev Contract module which provides a basic access control mechanism, where
1216  * there is an account (an owner) that can be granted exclusive access to
1217  * specific functions.
1218  *
1219  * By default, the owner account will be the one that deploys the contract. This
1220  * can later be changed with {transferOwnership}.
1221  *
1222  * This module is used through inheritance. It will make available the modifier
1223  * `onlyOwner`, which can be applied to your functions to restrict their use to
1224  * the owner.
1225  */
1226 abstract contract Ownable is Context {
1227     address private _owner;
1228 
1229     event OwnershipTransferred(
1230         address indexed previousOwner,
1231         address indexed newOwner
1232     );
1233 
1234     /**
1235      * @dev Initializes the contract setting the deployer as the initial owner.
1236      */
1237     constructor() {
1238         _setOwner(_msgSender());
1239     }
1240 
1241     /**
1242      * @dev Returns the address of the current owner.
1243      */
1244     function owner() public view virtual returns (address) {
1245         return _owner;
1246     }
1247 
1248     /**
1249      * @dev Throws if called by any account other than the owner.
1250      */
1251     modifier onlyOwner() {
1252         require(owner() == _msgSender(), "Ownable: caller is not the owner");
1253         _;
1254     }
1255 
1256     /**
1257      * @dev Leaves the contract without owner. It will not be possible to call
1258      * `onlyOwner` functions anymore. Can only be called by the current owner.
1259      *
1260      * NOTE: Renouncing ownership will leave the contract without an owner,
1261      * thereby removing any functionality that is only available to the owner.
1262      */
1263     function renounceOwnership() public virtual onlyOwner {
1264         _setOwner(address(0));
1265     }
1266 
1267     /**
1268      * @dev Transfers ownership of the contract to a new account (`newOwner`).
1269      * Can only be called by the current owner.
1270      */
1271     function transferOwnership(address newOwner) public virtual onlyOwner {
1272         require(
1273             newOwner != address(0),
1274             "Ownable: new owner is the zero address"
1275         );
1276         _setOwner(newOwner);
1277     }
1278 
1279     function _setOwner(address newOwner) private {
1280         address oldOwner = _owner;
1281         _owner = newOwner;
1282         emit OwnershipTransferred(oldOwner, newOwner);
1283     }
1284 }
1285 
1286 pragma solidity ^0.8.0;
1287 
1288 /**
1289  * @dev Contract module that helps prevent reentrant calls to a function.
1290  *
1291  * Inheriting from `ReentrancyGuard` will make the {nonReentrant} modifier
1292  * available, which can be applied to functions to make sure there are no nested
1293  * (reentrant) calls to them.
1294  *
1295  * Note that because there is a single `nonReentrant` guard, functions marked as
1296  * `nonReentrant` may not call one another. This can be worked around by making
1297  * those functions `private`, and then adding `external` `nonReentrant` entry
1298  * points to them.
1299  *
1300  * TIP: If you would like to learn more about reentrancy and alternative ways
1301  * to protect against it, check out our blog post
1302  * https://blog.openzeppelin.com/reentrancy-after-istanbul/[Reentrancy After Istanbul].
1303  */
1304 abstract contract ReentrancyGuard {
1305     // Booleans are more expensive than uint256 or any type that takes up a full
1306     // word because each write operation emits an extra SLOAD to first read the
1307     // slot's contents, replace the bits taken up by the boolean, and then write
1308     // back. This is the compiler's defense against contract upgrades and
1309     // pointer aliasing, and it cannot be disabled.
1310 
1311     // The values being non-zero value makes deployment a bit more expensive,
1312     // but in exchange the refund on every call to nonReentrant will be lower in
1313     // amount. Since refunds are capped to a percentage of the total
1314     // transaction's gas, it is best to keep them low in cases like this one, to
1315     // increase the likelihood of the full refund coming into effect.
1316     uint256 private constant _NOT_ENTERED = 1;
1317     uint256 private constant _ENTERED = 2;
1318 
1319     uint256 private _status;
1320 
1321     constructor() {
1322         _status = _NOT_ENTERED;
1323     }
1324 
1325     /**
1326      * @dev Prevents a contract from calling itself, directly or indirectly.
1327      * Calling a `nonReentrant` function from another `nonReentrant`
1328      * function is not supported. It is possible to prevent this from happening
1329      * by making the `nonReentrant` function external, and make it call a
1330      * `private` function that does the actual work.
1331      */
1332     modifier nonReentrant() {
1333         // On the first call to nonReentrant, _notEntered will be true
1334         require(_status != _ENTERED, "ReentrancyGuard: reentrant call");
1335 
1336         // Any calls to nonReentrant after this point will fail
1337         _status = _ENTERED;
1338 
1339         _;
1340 
1341         // By storing the original value once again, a refund is triggered (see
1342         // https://eips.ethereum.org/EIPS/eip-2200)
1343         _status = _NOT_ENTERED;
1344     }
1345 }
1346 
1347 //newerc.sol
1348 pragma solidity ^0.8.0;
1349 
1350 
1351 contract PickleHatesNFTs is ERC721A, Ownable, Pausable, ReentrancyGuard {
1352     using Strings for uint256;
1353     string public baseURI;
1354     uint256 public cost = 0.003 ether;
1355     uint256 public maxSupply = 6969;
1356     uint256 public maxFree = 1969;
1357     uint256 public maxperAddressFreeLimit = 2;
1358     uint256 public maxperAddressPublicMint = 50;
1359 
1360     mapping(address => uint256) public addressFreeMintedBalance;
1361 
1362     constructor() ERC721A("PickleHatesNFTs", "PickleHatesNFTs") {
1363         setBaseURI("ipfs://QmP9WjcuJXA3EtfCqBkVDgQk8h3CSPPvaxuoWWsmAtb7ju/");
1364 
1365     }
1366 
1367     function _baseURI() internal view virtual override returns (string memory) {
1368         return baseURI;
1369     }
1370 
1371     function MintFree(uint256 _mintAmount) public payable nonReentrant{
1372 		uint256 s = totalSupply();
1373         uint256 addressFreeMintedCount = addressFreeMintedBalance[msg.sender];
1374         require(addressFreeMintedCount + _mintAmount <= maxperAddressFreeLimit, "max NFT per address exceeded");
1375 		require(_mintAmount > 0, "Cant mint 0" );
1376 		require(s + _mintAmount <= maxFree, "Cant go over supply" );
1377 		for (uint256 i = 0; i < _mintAmount; ++i) {
1378             addressFreeMintedBalance[msg.sender]++;
1379 
1380 		}
1381         _safeMint(msg.sender, _mintAmount);
1382 		delete s;
1383         delete addressFreeMintedCount;
1384 	}
1385 
1386 
1387     function mint(uint256 _mintAmount) public payable nonReentrant {
1388         uint256 s = totalSupply();
1389         require(_mintAmount > 0, "Cant mint 0");
1390         require(_mintAmount <= maxperAddressPublicMint, "Cant mint more then maxmint" );
1391         require(s + _mintAmount <= maxSupply, "Cant go over supply");
1392         require(msg.value >= cost * _mintAmount);
1393         _safeMint(msg.sender, _mintAmount);
1394         delete s;
1395     }
1396 
1397     function gift(uint256[] calldata quantity, address[] calldata recipient)
1398         external
1399         onlyOwner
1400     {
1401         require(
1402             quantity.length == recipient.length,
1403             "Provide quantities and recipients"
1404         );
1405         uint256 totalQuantity = 0;
1406         uint256 s = totalSupply();
1407         for (uint256 i = 0; i < quantity.length; ++i) {
1408             totalQuantity += quantity[i];
1409         }
1410         require(s + totalQuantity <= maxSupply, "Too many");
1411         delete totalQuantity;
1412         for (uint256 i = 0; i < recipient.length; ++i) {
1413             _safeMint(recipient[i], quantity[i]);
1414         }
1415         delete s;
1416     }
1417 
1418     function tokenURI(uint256 tokenId)
1419         public
1420         view
1421         virtual
1422         override
1423         returns (string memory)
1424     {
1425         require(_exists(tokenId), "ERC721Metadata: Nonexistent token");
1426         string memory currentBaseURI = _baseURI();
1427         return
1428             bytes(currentBaseURI).length > 0
1429                 ? string(abi.encodePacked(currentBaseURI, tokenId.toString(), ".json"))
1430                 : "";
1431     }
1432 
1433 
1434 
1435     function setCost(uint256 _newCost) public onlyOwner {
1436         cost = _newCost;
1437     }
1438 
1439     function setmaxSupply(uint256 _newMaxSupply) public onlyOwner {
1440         require(_newMaxSupply <= maxSupply, "Cannot increase max supply");
1441         maxSupply = _newMaxSupply;
1442     }
1443      function setmaxFreeSupply(uint256 _newMaxFreeSupply) public onlyOwner {
1444                maxFree = _newMaxFreeSupply;
1445     }
1446 
1447     function setBaseURI(string memory _newBaseURI) public onlyOwner {
1448         baseURI = _newBaseURI;
1449     }
1450 
1451     function setMaxperAddressPublicMint(uint256 _amount) public onlyOwner {
1452         maxperAddressPublicMint = _amount;
1453     }
1454 
1455     function setMaxperAddressFreeMint(uint256 _amount) public onlyOwner{
1456         maxperAddressFreeLimit = _amount;
1457     }
1458     function withdraw() public payable onlyOwner {
1459         (bool success, ) = payable(msg.sender).call{
1460             value: address(this).balance
1461         }("");
1462         require(success);
1463     }
1464 
1465     function withdrawAny(uint256 _amount) public payable onlyOwner {
1466         (bool success, ) = payable(msg.sender).call{value: _amount}("");
1467         require(success);
1468     }
1469 }