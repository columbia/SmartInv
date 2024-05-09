1 // SPDX-License-Identifier: Unlicense
2 
3 // https://www.fuglyfairies.xyz/
4 
5 // File: @openzeppelin/contracts/utils/Strings.sol
6 
7 
8 // OpenZeppelin Contracts v4.4.1 (utils/Strings.sol)
9 pragma solidity ^0.8.0;
10 
11 /**
12  * @dev String operations.
13  */
14 library Strings {
15     bytes16 private constant _HEX_SYMBOLS = "0123456789abcdef";
16 
17     /**
18      * @dev Converts a `uint256` to its ASCII `string` decimal representation.
19      */
20     function toString(uint256 value) internal pure returns (string memory) {
21         // Inspired by OraclizeAPI's implementation - MIT licence
22         // https://github.com/oraclize/ethereum-api/blob/b42146b063c7d6ee1358846c198246239e9360e8/oraclizeAPI_0.4.25.sol
23 
24         if (value == 0) {
25             return "0";
26         }
27         uint256 temp = value;
28         uint256 digits;
29         while (temp != 0) {
30             digits++;
31             temp /= 10;
32         }
33         bytes memory buffer = new bytes(digits);
34         while (value != 0) {
35             digits -= 1;
36             buffer[digits] = bytes1(uint8(48 + uint256(value % 10)));
37             value /= 10;
38         }
39         return string(buffer);
40     }
41 
42     /**
43      * @dev Converts a `uint256` to its ASCII `string` hexadecimal representation.
44      */
45     function toHexString(uint256 value) internal pure returns (string memory) {
46         if (value == 0) {
47             return "0x00";
48         }
49         uint256 temp = value;
50         uint256 length = 0;
51         while (temp != 0) {
52             length++;
53             temp >>= 8;
54         }
55         return toHexString(value, length);
56     }
57 
58     /**
59      * @dev Converts a `uint256` to its ASCII `string` hexadecimal representation with fixed length.
60      */
61     function toHexString(uint256 value, uint256 length) internal pure returns (string memory) {
62         bytes memory buffer = new bytes(2 * length + 2);
63         buffer[0] = "0";
64         buffer[1] = "x";
65         for (uint256 i = 2 * length + 1; i > 1; --i) {
66             buffer[i] = _HEX_SYMBOLS[value & 0xf];
67             value >>= 4;
68         }
69         require(value == 0, "Strings: hex length insufficient");
70         return string(buffer);
71     }
72 }
73 
74 // File: @openzeppelin/contracts/utils/Context.sol
75 
76 
77 // OpenZeppelin Contracts v4.4.1 (utils/Context.sol)
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
101 // File: @openzeppelin/contracts/utils/Address.sol
102 
103 
104 // OpenZeppelin Contracts (last updated v4.5.0) (utils/Address.sol)
105 
106 pragma solidity ^0.8.1;
107 
108 /**
109  * @dev Collection of functions related to the address type
110  */
111 library Address {
112     /**
113      * @dev Returns true if `account` is a contract.
114      *
115      * [IMPORTANT]
116      * ====
117      * It is unsafe to assume that an address for which this function returns
118      * false is an externally-owned account (EOA) and not a contract.
119      *
120      * Among others, `isContract` will return false for the following
121      * types of addresses:
122      *
123      *  - an externally-owned account
124      *  - a contract in construction
125      *  - an address where a contract will be created
126      *  - an address where a contract lived, but was destroyed
127      * ====
128      *
129      * [IMPORTANT]
130      * ====
131      * You shouldn't rely on `isContract` to protect against flash loan attacks!
132      *
133      * Preventing calls from contracts is highly discouraged. It breaks composability, breaks support for smart wallets
134      * like Gnosis Safe, and does not provide security since it can be circumvented by calling from a contract
135      * constructor.
136      * ====
137      */
138     function isContract(address account) internal view returns (bool) {
139         // This method relies on extcodesize/address.code.length, which returns 0
140         // for contracts in construction, since the code is only stored at the end
141         // of the constructor execution.
142 
143         return account.code.length > 0;
144     }
145 
146     /**
147      * @dev Replacement for Solidity's `transfer`: sends `amount` wei to
148      * `recipient`, forwarding all available gas and reverting on errors.
149      *
150      * https://eips.ethereum.org/EIPS/eip-1884[EIP1884] increases the gas cost
151      * of certain opcodes, possibly making contracts go over the 2300 gas limit
152      * imposed by `transfer`, making them unable to receive funds via
153      * `transfer`. {sendValue} removes this limitation.
154      *
155      * https://diligence.consensys.net/posts/2019/09/stop-using-soliditys-transfer-now/[Learn more].
156      *
157      * IMPORTANT: because control is transferred to `recipient`, care must be
158      * taken to not create reentrancy vulnerabilities. Consider using
159      * {ReentrancyGuard} or the
160      * https://solidity.readthedocs.io/en/v0.5.11/security-considerations.html#use-the-checks-effects-interactions-pattern[checks-effects-interactions pattern].
161      */
162     function sendValue(address payable recipient, uint256 amount) internal {
163         require(address(this).balance >= amount, "Address: insufficient balance");
164 
165         (bool success, ) = recipient.call{value: amount}("");
166         require(success, "Address: unable to send value, recipient may have reverted");
167     }
168 
169     /**
170      * @dev Performs a Solidity function call using a low level `call`. A
171      * plain `call` is an unsafe replacement for a function call: use this
172      * function instead.
173      *
174      * If `target` reverts with a revert reason, it is bubbled up by this
175      * function (like regular Solidity function calls).
176      *
177      * Returns the raw returned data. To convert to the expected return value,
178      * use https://solidity.readthedocs.io/en/latest/units-and-global-variables.html?highlight=abi.decode#abi-encoding-and-decoding-functions[`abi.decode`].
179      *
180      * Requirements:
181      *
182      * - `target` must be a contract.
183      * - calling `target` with `data` must not revert.
184      *
185      * _Available since v3.1._
186      */
187     function functionCall(address target, bytes memory data) internal returns (bytes memory) {
188         return functionCall(target, data, "Address: low-level call failed");
189     }
190 
191     /**
192      * @dev Same as {xref-Address-functionCall-address-bytes-}[`functionCall`], but with
193      * `errorMessage` as a fallback revert reason when `target` reverts.
194      *
195      * _Available since v3.1._
196      */
197     function functionCall(
198         address target,
199         bytes memory data,
200         string memory errorMessage
201     ) internal returns (bytes memory) {
202         return functionCallWithValue(target, data, 0, errorMessage);
203     }
204 
205     /**
206      * @dev Same as {xref-Address-functionCall-address-bytes-}[`functionCall`],
207      * but also transferring `value` wei to `target`.
208      *
209      * Requirements:
210      *
211      * - the calling contract must have an ETH balance of at least `value`.
212      * - the called Solidity function must be `payable`.
213      *
214      * _Available since v3.1._
215      */
216     function functionCallWithValue(
217         address target,
218         bytes memory data,
219         uint256 value
220     ) internal returns (bytes memory) {
221         return functionCallWithValue(target, data, value, "Address: low-level call with value failed");
222     }
223 
224     /**
225      * @dev Same as {xref-Address-functionCallWithValue-address-bytes-uint256-}[`functionCallWithValue`], but
226      * with `errorMessage` as a fallback revert reason when `target` reverts.
227      *
228      * _Available since v3.1._
229      */
230     function functionCallWithValue(
231         address target,
232         bytes memory data,
233         uint256 value,
234         string memory errorMessage
235     ) internal returns (bytes memory) {
236         require(address(this).balance >= value, "Address: insufficient balance for call");
237         require(isContract(target), "Address: call to non-contract");
238 
239         (bool success, bytes memory returndata) = target.call{value: value}(data);
240         return verifyCallResult(success, returndata, errorMessage);
241     }
242 
243     /**
244      * @dev Same as {xref-Address-functionCall-address-bytes-}[`functionCall`],
245      * but performing a static call.
246      *
247      * _Available since v3.3._
248      */
249     function functionStaticCall(address target, bytes memory data) internal view returns (bytes memory) {
250         return functionStaticCall(target, data, "Address: low-level static call failed");
251     }
252 
253     /**
254      * @dev Same as {xref-Address-functionCall-address-bytes-string-}[`functionCall`],
255      * but performing a static call.
256      *
257      * _Available since v3.3._
258      */
259     function functionStaticCall(
260         address target,
261         bytes memory data,
262         string memory errorMessage
263     ) internal view returns (bytes memory) {
264         require(isContract(target), "Address: static call to non-contract");
265 
266         (bool success, bytes memory returndata) = target.staticcall(data);
267         return verifyCallResult(success, returndata, errorMessage);
268     }
269 
270     /**
271      * @dev Same as {xref-Address-functionCall-address-bytes-}[`functionCall`],
272      * but performing a delegate call.
273      *
274      * _Available since v3.4._
275      */
276     function functionDelegateCall(address target, bytes memory data) internal returns (bytes memory) {
277         return functionDelegateCall(target, data, "Address: low-level delegate call failed");
278     }
279 
280     /**
281      * @dev Same as {xref-Address-functionCall-address-bytes-string-}[`functionCall`],
282      * but performing a delegate call.
283      *
284      * _Available since v3.4._
285      */
286     function functionDelegateCall(
287         address target,
288         bytes memory data,
289         string memory errorMessage
290     ) internal returns (bytes memory) {
291         require(isContract(target), "Address: delegate call to non-contract");
292 
293         (bool success, bytes memory returndata) = target.delegatecall(data);
294         return verifyCallResult(success, returndata, errorMessage);
295     }
296 
297     /**
298      * @dev Tool to verifies that a low level call was successful, and revert if it wasn't, either by bubbling the
299      * revert reason using the provided one.
300      *
301      * _Available since v4.3._
302      */
303     function verifyCallResult(
304         bool success,
305         bytes memory returndata,
306         string memory errorMessage
307     ) internal pure returns (bytes memory) {
308         if (success) {
309             return returndata;
310         } else {
311             // Look for revert reason and bubble it up if present
312             if (returndata.length > 0) {
313                 // The easiest way to bubble the revert reason is using memory via assembly
314 
315                 assembly {
316                     let returndata_size := mload(returndata)
317                     revert(add(32, returndata), returndata_size)
318                 }
319             } else {
320                 revert(errorMessage);
321             }
322         }
323     }
324 }
325 
326 // File: @openzeppelin/contracts/token/ERC721/IERC721Receiver.sol
327 
328 
329 // OpenZeppelin Contracts (last updated v4.6.0) (token/ERC721/IERC721Receiver.sol)
330 
331 pragma solidity ^0.8.0;
332 
333 /**
334  * @title ERC721 token receiver interface
335  * @dev Interface for any contract that wants to support safeTransfers
336  * from ERC721 asset contracts.
337  */
338 interface IERC721Receiver {
339     /**
340      * @dev Whenever an {IERC721} `tokenId` token is transferred to this contract via {IERC721-safeTransferFrom}
341      * by `operator` from `from`, this function is called.
342      *
343      * It must return its Solidity selector to confirm the token transfer.
344      * If any other value is returned or the interface is not implemented by the recipient, the transfer will be reverted.
345      *
346      * The selector can be obtained in Solidity with `IERC721Receiver.onERC721Received.selector`.
347      */
348     function onERC721Received(
349         address operator,
350         address from,
351         uint256 tokenId,
352         bytes calldata data
353     ) external returns (bytes4);
354 }
355 
356 // File: @openzeppelin/contracts/utils/introspection/IERC165.sol
357 
358 
359 // OpenZeppelin Contracts v4.4.1 (utils/introspection/IERC165.sol)
360 
361 pragma solidity ^0.8.0;
362 
363 /**
364  * @dev Interface of the ERC165 standard, as defined in the
365  * https://eips.ethereum.org/EIPS/eip-165[EIP].
366  *
367  * Implementers can declare support of contract interfaces, which can then be
368  * queried by others ({ERC165Checker}).
369  *
370  * For an implementation, see {ERC165}.
371  */
372 interface IERC165 {
373     /**
374      * @dev Returns true if this contract implements the interface defined by
375      * `interfaceId`. See the corresponding
376      * https://eips.ethereum.org/EIPS/eip-165#how-interfaces-are-identified[EIP section]
377      * to learn more about how these ids are created.
378      *
379      * This function call must use less than 30 000 gas.
380      */
381     function supportsInterface(bytes4 interfaceId) external view returns (bool);
382 }
383 
384 // File: @openzeppelin/contracts/utils/introspection/ERC165.sol
385 
386 
387 // OpenZeppelin Contracts v4.4.1 (utils/introspection/ERC165.sol)
388 
389 pragma solidity ^0.8.0;
390 
391 
392 /**
393  * @dev Implementation of the {IERC165} interface.
394  *
395  * Contracts that want to implement ERC165 should inherit from this contract and override {supportsInterface} to check
396  * for the additional interface id that will be supported. For example:
397  *
398  * ```solidity
399  * function supportsInterface(bytes4 interfaceId) public view virtual override returns (bool) {
400  *     return interfaceId == type(MyInterface).interfaceId || super.supportsInterface(interfaceId);
401  * }
402  * ```
403  *
404  * Alternatively, {ERC165Storage} provides an easier to use but more expensive implementation.
405  */
406 abstract contract ERC165 is IERC165 {
407     /**
408      * @dev See {IERC165-supportsInterface}.
409      */
410     function supportsInterface(bytes4 interfaceId) public view virtual override returns (bool) {
411         return interfaceId == type(IERC165).interfaceId;
412     }
413 }
414 
415 // File: @openzeppelin/contracts/token/ERC721/IERC721.sol
416 
417 
418 // OpenZeppelin Contracts (last updated v4.6.0) (token/ERC721/IERC721.sol)
419 
420 pragma solidity ^0.8.0;
421 
422 
423 /**
424  * @dev Required interface of an ERC721 compliant contract.
425  */
426 interface IERC721 is IERC165 {
427     /**
428      * @dev Emitted when `tokenId` token is transferred from `from` to `to`.
429      */
430     event Transfer(address indexed from, address indexed to, uint256 indexed tokenId);
431 
432     /**
433      * @dev Emitted when `owner` enables `approved` to manage the `tokenId` token.
434      */
435     event Approval(address indexed owner, address indexed approved, uint256 indexed tokenId);
436 
437     /**
438      * @dev Emitted when `owner` enables or disables (`approved`) `operator` to manage all of its assets.
439      */
440     event ApprovalForAll(address indexed owner, address indexed operator, bool approved);
441 
442     /**
443      * @dev Returns the number of tokens in ``owner``'s account.
444      */
445     function balanceOf(address owner) external view returns (uint256 balance);
446 
447     /**
448      * @dev Returns the owner of the `tokenId` token.
449      *
450      * Requirements:
451      *
452      * - `tokenId` must exist.
453      */
454     function ownerOf(uint256 tokenId) external view returns (address owner);
455 
456     /**
457      * @dev Safely transfers `tokenId` token from `from` to `to`.
458      *
459      * Requirements:
460      *
461      * - `from` cannot be the zero address.
462      * - `to` cannot be the zero address.
463      * - `tokenId` token must exist and be owned by `from`.
464      * - If the caller is not `from`, it must be approved to move this token by either {approve} or {setApprovalForAll}.
465      * - If `to` refers to a smart contract, it must implement {IERC721Receiver-onERC721Received}, which is called upon a safe transfer.
466      *
467      * Emits a {Transfer} event.
468      */
469     function safeTransferFrom(
470         address from,
471         address to,
472         uint256 tokenId,
473         bytes calldata data
474     ) external;
475 
476     /**
477      * @dev Safely transfers `tokenId` token from `from` to `to`, checking first that contract recipients
478      * are aware of the ERC721 protocol to prevent tokens from being forever locked.
479      *
480      * Requirements:
481      *
482      * - `from` cannot be the zero address.
483      * - `to` cannot be the zero address.
484      * - `tokenId` token must exist and be owned by `from`.
485      * - If the caller is not `from`, it must be have been allowed to move this token by either {approve} or {setApprovalForAll}.
486      * - If `to` refers to a smart contract, it must implement {IERC721Receiver-onERC721Received}, which is called upon a safe transfer.
487      *
488      * Emits a {Transfer} event.
489      */
490     function safeTransferFrom(
491         address from,
492         address to,
493         uint256 tokenId
494     ) external;
495 
496     /**
497      * @dev Transfers `tokenId` token from `from` to `to`.
498      *
499      * WARNING: Usage of this method is discouraged, use {safeTransferFrom} whenever possible.
500      *
501      * Requirements:
502      *
503      * - `from` cannot be the zero address.
504      * - `to` cannot be the zero address.
505      * - `tokenId` token must be owned by `from`.
506      * - If the caller is not `from`, it must be approved to move this token by either {approve} or {setApprovalForAll}.
507      *
508      * Emits a {Transfer} event.
509      */
510     function transferFrom(
511         address from,
512         address to,
513         uint256 tokenId
514     ) external;
515 
516     /**
517      * @dev Gives permission to `to` to transfer `tokenId` token to another account.
518      * The approval is cleared when the token is transferred.
519      *
520      * Only a single account can be approved at a time, so approving the zero address clears previous approvals.
521      *
522      * Requirements:
523      *
524      * - The caller must own the token or be an approved operator.
525      * - `tokenId` must exist.
526      *
527      * Emits an {Approval} event.
528      */
529     function approve(address to, uint256 tokenId) external;
530 
531     /**
532      * @dev Approve or remove `operator` as an operator for the caller.
533      * Operators can call {transferFrom} or {safeTransferFrom} for any token owned by the caller.
534      *
535      * Requirements:
536      *
537      * - The `operator` cannot be the caller.
538      *
539      * Emits an {ApprovalForAll} event.
540      */
541     function setApprovalForAll(address operator, bool _approved) external;
542 
543     /**
544      * @dev Returns the account approved for `tokenId` token.
545      *
546      * Requirements:
547      *
548      * - `tokenId` must exist.
549      */
550     function getApproved(uint256 tokenId) external view returns (address operator);
551 
552     /**
553      * @dev Returns if the `operator` is allowed to manage all of the assets of `owner`.
554      *
555      * See {setApprovalForAll}
556      */
557     function isApprovedForAll(address owner, address operator) external view returns (bool);
558 }
559 
560 // File: @openzeppelin/contracts/token/ERC721/extensions/IERC721Enumerable.sol
561 
562 
563 // OpenZeppelin Contracts (last updated v4.5.0) (token/ERC721/extensions/IERC721Enumerable.sol)
564 
565 pragma solidity ^0.8.0;
566 
567 
568 /**
569  * @title ERC-721 Non-Fungible Token Standard, optional enumeration extension
570  * @dev See https://eips.ethereum.org/EIPS/eip-721
571  */
572 interface IERC721Enumerable is IERC721 {
573     /**
574      * @dev Returns the total amount of tokens stored by the contract.
575      */
576     function totalSupply() external view returns (uint256);
577 
578     /**
579      * @dev Returns a token ID owned by `owner` at a given `index` of its token list.
580      * Use along with {balanceOf} to enumerate all of ``owner``'s tokens.
581      */
582     function tokenOfOwnerByIndex(address owner, uint256 index) external view returns (uint256);
583 
584     /**
585      * @dev Returns a token ID at a given `index` of all the tokens stored by the contract.
586      * Use along with {totalSupply} to enumerate all tokens.
587      */
588     function tokenByIndex(uint256 index) external view returns (uint256);
589 }
590 
591 // File: @openzeppelin/contracts/token/ERC721/extensions/IERC721Metadata.sol
592 
593 
594 // OpenZeppelin Contracts v4.4.1 (token/ERC721/extensions/IERC721Metadata.sol)
595 
596 pragma solidity ^0.8.0;
597 
598 
599 /**
600  * @title ERC-721 Non-Fungible Token Standard, optional metadata extension
601  * @dev See https://eips.ethereum.org/EIPS/eip-721
602  */
603 interface IERC721Metadata is IERC721 {
604     /**
605      * @dev Returns the token collection name.
606      */
607     function name() external view returns (string memory);
608 
609     /**
610      * @dev Returns the token collection symbol.
611      */
612     function symbol() external view returns (string memory);
613 
614     /**
615      * @dev Returns the Uniform Resource Identifier (URI) for `tokenId` token.
616      */
617     function tokenURI(uint256 tokenId) external view returns (string memory);
618 }
619 
620 // File: ERC721A.sol
621 
622 
623 // Creator: Chiru Labs
624 
625 pragma solidity ^0.8.0;
626 
627 
628 
629 /**
630  * @dev Implementation of https://eips.ethereum.org/EIPS/eip-721[ERC721] Non-Fungible Token Standard, including
631  * the Metadata and Enumerable extension. Built to optimize for lower gas during batch mints.
632  *
633  * Assumes serials are sequentially minted starting at 0 (e.g. 0, 1, 2, 3..).
634  *
635  * Does not support burning tokens to address(0).
636  *
637  * Assumes that an owner cannot have more than the 2**128 - 1 (max value of uint128) of supply
638  */
639 contract ERC721A is Context, ERC165, IERC721, IERC721Metadata, IERC721Enumerable {
640     using Address for address;
641     using Strings for uint256;
642 
643     struct TokenOwnership {
644         address addr;
645         uint64 startTimestamp;
646     }
647 
648     struct AddressData {
649         uint128 balance;
650         uint128 numberMinted;
651     }
652 
653     uint256 internal currentIndex = 1;
654 
655     // Token name
656     string private _name;
657 
658     // Token symbol
659     string private _symbol;
660 
661     // Mapping from token ID to ownership details
662     // An empty struct value does not necessarily mean the token is unowned. See ownershipOf implementation for details.
663     mapping(uint256 => TokenOwnership) internal _ownerships;
664 
665     // Mapping owner address to address data
666     mapping(address => AddressData) private _addressData;
667 
668     // Mapping from token ID to approved address
669     mapping(uint256 => address) private _tokenApprovals;
670 
671     // Mapping from owner to operator approvals
672     mapping(address => mapping(address => bool)) private _operatorApprovals;
673 
674     constructor(string memory name_, string memory symbol_) {
675         _name = name_;
676         _symbol = symbol_;
677     }
678 
679     /**
680      * @dev See {IERC721Enumerable-totalSupply}.
681      */
682     function totalSupply() public view override returns (uint256) {
683         return currentIndex;
684     }
685 
686     /**
687      * @dev See {IERC721Enumerable-tokenByIndex}.
688      */
689     function tokenByIndex(uint256 index) public view override returns (uint256) {
690         require(index < totalSupply(), 'ERC721A: global index out of bounds');
691         return index;
692     }
693 
694     /**
695      * @dev See {IERC721Enumerable-tokenOfOwnerByIndex}.
696      * This read function is O(totalSupply). If calling from a separate contract, be sure to test gas first.
697      * It may also degrade with extremely large collection sizes (e.g >> 10000), test for your use case.
698      */
699     function tokenOfOwnerByIndex(address owner, uint256 index) public view override returns (uint256) {
700         require(index < balanceOf(owner), 'ERC721A: owner index out of bounds');
701         uint256 numMintedSoFar = totalSupply();
702         uint256 tokenIdsIdx;
703         address currOwnershipAddr;
704 
705         // Counter overflow is impossible as the loop breaks when uint256 i is equal to another uint256 numMintedSoFar.
706         unchecked {
707             for (uint256 i; i < numMintedSoFar; i++) {
708                 TokenOwnership memory ownership = _ownerships[i];
709                 if (ownership.addr != address(0)) {
710                     currOwnershipAddr = ownership.addr;
711                 }
712                 if (currOwnershipAddr == owner) {
713                     if (tokenIdsIdx == index) {
714                         return i;
715                     }
716                     tokenIdsIdx++;
717                 }
718             }
719         }
720 
721         revert('ERC721A: unable to get token of owner by index');
722     }
723 
724     /**
725      * @dev See {IERC165-supportsInterface}.
726      */
727     function supportsInterface(bytes4 interfaceId) public view virtual override(ERC165, IERC165) returns (bool) {
728         return
729             interfaceId == type(IERC721).interfaceId ||
730             interfaceId == type(IERC721Metadata).interfaceId ||
731             interfaceId == type(IERC721Enumerable).interfaceId ||
732             super.supportsInterface(interfaceId);
733     }
734 
735     /**
736      * @dev See {IERC721-balanceOf}.
737      */
738     function balanceOf(address owner) public view override returns (uint256) {
739         require(owner != address(0), 'ERC721A: balance query for the zero address');
740         return uint256(_addressData[owner].balance);
741     }
742 
743     function _numberMinted(address owner) internal view returns (uint256) {
744         require(owner != address(0), 'ERC721A: number minted query for the zero address');
745         return uint256(_addressData[owner].numberMinted);
746     }
747 
748     /**
749      * Gas spent here starts off proportional to the maximum mint batch size.
750      * It gradually moves to O(1) as tokens get transferred around in the collection over time.
751      */
752     function ownershipOf(uint256 tokenId) internal view returns (TokenOwnership memory) {
753         require(_exists(tokenId), 'ERC721A: owner query for nonexistent token');
754 
755         unchecked {
756             for (uint256 curr = tokenId; curr >= 0; curr--) {
757                 TokenOwnership memory ownership = _ownerships[curr];
758                 if (ownership.addr != address(0)) {
759                     return ownership;
760                 }
761             }
762         }
763 
764         revert('ERC721A: unable to determine the owner of token');
765     }
766 
767     /**
768      * @dev See {IERC721-ownerOf}.
769      */
770     function ownerOf(uint256 tokenId) public view override returns (address) {
771         return ownershipOf(tokenId).addr;
772     }
773 
774     /**
775      * @dev See {IERC721Metadata-name}.
776      */
777     function name() public view virtual override returns (string memory) {
778         return _name;
779     }
780 
781     /**
782      * @dev See {IERC721Metadata-symbol}.
783      */
784     function symbol() public view virtual override returns (string memory) {
785         return _symbol;
786     }
787 
788     /**
789      * @dev See {IERC721Metadata-tokenURI}.
790      */
791     function tokenURI(uint256 tokenId) public view virtual override returns (string memory) {
792         require(_exists(tokenId), 'ERC721Metadata: URI query for nonexistent token');
793 
794         string memory baseURI = _baseURI();
795         return bytes(baseURI).length != 0 ? string(abi.encodePacked(baseURI, tokenId.toString())) : '';
796     }
797 
798     /**
799      * @dev Base URI for computing {tokenURI}. If set, the resulting URI for each
800      * token will be the concatenation of the `baseURI` and the `tokenId`. Empty
801      * by default, can be overriden in child contracts.
802      */
803     function _baseURI() internal view virtual returns (string memory) {
804         return '';
805     }
806 
807     /**
808      * @dev See {IERC721-approve}.
809      */
810     function approve(address to, uint256 tokenId) public override {
811         address owner = ERC721A.ownerOf(tokenId);
812         require(to != owner, 'ERC721A: approval to current owner');
813 
814         require(
815             _msgSender() == owner || isApprovedForAll(owner, _msgSender()),
816             'ERC721A: approve caller is not owner nor approved for all'
817         );
818 
819         _approve(to, tokenId, owner);
820     }
821 
822     /**
823      * @dev See {IERC721-getApproved}.
824      */
825     function getApproved(uint256 tokenId) public view override returns (address) {
826         require(_exists(tokenId), 'ERC721A: approved query for nonexistent token');
827 
828         return _tokenApprovals[tokenId];
829     }
830 
831     /**
832      * @dev See {IERC721-setApprovalForAll}.
833      */
834     function setApprovalForAll(address operator, bool approved) public override {
835         require(operator != _msgSender(), 'ERC721A: approve to caller');
836 
837         _operatorApprovals[_msgSender()][operator] = approved;
838         emit ApprovalForAll(_msgSender(), operator, approved);
839     }
840 
841     /**
842      * @dev See {IERC721-isApprovedForAll}.
843      */
844     function isApprovedForAll(address owner, address operator) public view virtual override returns (bool) {
845         return _operatorApprovals[owner][operator];
846     }
847 
848     /**
849      * @dev See {IERC721-transferFrom}.
850      */
851     function transferFrom(
852         address from,
853         address to,
854         uint256 tokenId
855     ) public override {
856         _transfer(from, to, tokenId);
857     }
858 
859     /**
860      * @dev See {IERC721-safeTransferFrom}.
861      */
862     function safeTransferFrom(
863         address from,
864         address to,
865         uint256 tokenId
866     ) public override {
867         safeTransferFrom(from, to, tokenId, '');
868     }
869 
870     /**
871      * @dev See {IERC721-safeTransferFrom}.
872      */
873     function safeTransferFrom(
874         address from,
875         address to,
876         uint256 tokenId,
877         bytes memory _data
878     ) public override {
879         _transfer(from, to, tokenId);
880         require(
881             _checkOnERC721Received(from, to, tokenId, _data),
882             'ERC721A: transfer to non ERC721Receiver implementer'
883         );
884     }
885 
886     /**
887      * @dev Returns whether `tokenId` exists.
888      *
889      * Tokens can be managed by their owner or approved accounts via {approve} or {setApprovalForAll}.
890      *
891      * Tokens start existing when they are minted (`_mint`),
892      */
893     function _exists(uint256 tokenId) internal view returns (bool) {
894         return tokenId < currentIndex;
895     }
896 
897     function _safeMint(address to, uint256 quantity) internal {
898         _safeMint(to, quantity, '');
899     }
900 
901     /**
902      * @dev Safely mints `quantity` tokens and transfers them to `to`.
903      *
904      * Requirements:
905      *
906      * - If `to` refers to a smart contract, it must implement {IERC721Receiver-onERC721Received}, which is called for each safe transfer.
907      * - `quantity` must be greater than 0.
908      *
909      * Emits a {Transfer} event.
910      */
911     function _safeMint(
912         address to,
913         uint256 quantity,
914         bytes memory _data
915     ) internal {
916         _mint(to, quantity, _data, true);
917     }
918 
919     /**
920      * @dev Mints `quantity` tokens and transfers them to `to`.
921      *
922      * Requirements:
923      *
924      * - `to` cannot be the zero address.
925      * - `quantity` must be greater than 0.
926      *
927      * Emits a {Transfer} event.
928      */
929     function _mint(
930         address to,
931         uint256 quantity,
932         bytes memory _data,
933         bool safe
934     ) internal {
935         uint256 startTokenId = currentIndex;
936         require(to != address(0), 'ERC721A: mint to the zero address');
937         require(quantity != 0, 'ERC721A: quantity must be greater than 0');
938 
939         _beforeTokenTransfers(address(0), to, startTokenId, quantity);
940 
941         // Overflows are incredibly unrealistic.
942         // balance or numberMinted overflow if current value of either + quantity > 3.4e38 (2**128) - 1
943         // updatedIndex overflows if currentIndex + quantity > 1.56e77 (2**256) - 1
944         unchecked {
945             _addressData[to].balance += uint128(quantity);
946             _addressData[to].numberMinted += uint128(quantity);
947 
948             _ownerships[startTokenId].addr = to;
949             _ownerships[startTokenId].startTimestamp = uint64(block.timestamp);
950 
951             uint256 updatedIndex = startTokenId;
952 
953             for (uint256 i; i < quantity; i++) {
954                 emit Transfer(address(0), to, updatedIndex);
955                 if (safe) {
956                     require(
957                         _checkOnERC721Received(address(0), to, updatedIndex, _data),
958                         'ERC721A: transfer to non ERC721Receiver implementer'
959                     );
960                 }
961 
962                 updatedIndex++;
963             }
964 
965             currentIndex = updatedIndex;
966         }
967 
968         _afterTokenTransfers(address(0), to, startTokenId, quantity);
969     }
970 
971     /**
972      * @dev Transfers `tokenId` from `from` to `to`.
973      *
974      * Requirements:
975      *
976      * - `to` cannot be the zero address.
977      * - `tokenId` token must be owned by `from`.
978      *
979      * Emits a {Transfer} event.
980      */
981     function _transfer(
982         address from,
983         address to,
984         uint256 tokenId
985     ) private {
986         TokenOwnership memory prevOwnership = ownershipOf(tokenId);
987 
988         bool isApprovedOrOwner = (_msgSender() == prevOwnership.addr ||
989             getApproved(tokenId) == _msgSender() ||
990             isApprovedForAll(prevOwnership.addr, _msgSender()));
991 
992         require(isApprovedOrOwner, 'ERC721A: transfer caller is not owner nor approved');
993 
994         require(prevOwnership.addr == from, 'ERC721A: transfer from incorrect owner');
995         require(to != address(0), 'ERC721A: transfer to the zero address');
996 
997         _beforeTokenTransfers(from, to, tokenId, 1);
998 
999         // Clear approvals from the previous owner
1000         _approve(address(0), tokenId, prevOwnership.addr);
1001 
1002         // Underflow of the sender's balance is impossible because we check for
1003         // ownership above and the recipient's balance can't realistically overflow.
1004         // Counter overflow is incredibly unrealistic as tokenId would have to be 2**256.
1005         unchecked {
1006             _addressData[from].balance -= 1;
1007             _addressData[to].balance += 1;
1008 
1009             _ownerships[tokenId].addr = to;
1010             _ownerships[tokenId].startTimestamp = uint64(block.timestamp);
1011 
1012             // If the ownership slot of tokenId+1 is not explicitly set, that means the transfer initiator owns it.
1013             // Set the slot of tokenId+1 explicitly in storage to maintain correctness for ownerOf(tokenId+1) calls.
1014             uint256 nextTokenId = tokenId + 1;
1015             if (_ownerships[nextTokenId].addr == address(0)) {
1016                 if (_exists(nextTokenId)) {
1017                     _ownerships[nextTokenId].addr = prevOwnership.addr;
1018                     _ownerships[nextTokenId].startTimestamp = prevOwnership.startTimestamp;
1019                 }
1020             }
1021         }
1022 
1023         emit Transfer(from, to, tokenId);
1024         _afterTokenTransfers(from, to, tokenId, 1);
1025     }
1026 
1027     /**
1028      * @dev Approve `to` to operate on `tokenId`
1029      *
1030      * Emits a {Approval} event.
1031      */
1032     function _approve(
1033         address to,
1034         uint256 tokenId,
1035         address owner
1036     ) private {
1037         _tokenApprovals[tokenId] = to;
1038         emit Approval(owner, to, tokenId);
1039     }
1040 
1041     /**
1042      * @dev Internal function to invoke {IERC721Receiver-onERC721Received} on a target address.
1043      * The call is not executed if the target address is not a contract.
1044      *
1045      * @param from address representing the previous owner of the given token ID
1046      * @param to target address that will receive the tokens
1047      * @param tokenId uint256 ID of the token to be transferred
1048      * @param _data bytes optional data to send along with the call
1049      * @return bool whether the call correctly returned the expected magic value
1050      */
1051     function _checkOnERC721Received(
1052         address from,
1053         address to,
1054         uint256 tokenId,
1055         bytes memory _data
1056     ) private returns (bool) {
1057         if (to.isContract()) {
1058             try IERC721Receiver(to).onERC721Received(_msgSender(), from, tokenId, _data) returns (bytes4 retval) {
1059                 return retval == IERC721Receiver(to).onERC721Received.selector;
1060             } catch (bytes memory reason) {
1061                 if (reason.length == 0) {
1062                     revert('ERC721A: transfer to non ERC721Receiver implementer');
1063                 } else {
1064                     assembly {
1065                         revert(add(32, reason), mload(reason))
1066                     }
1067                 }
1068             }
1069         } else {
1070             return true;
1071         }
1072     }
1073 
1074     /**
1075      * @dev Hook that is called before a set of serially-ordered token ids are about to be transferred. This includes minting.
1076      *
1077      * startTokenId - the first token id to be transferred
1078      * quantity - the amount to be transferred
1079      *
1080      * Calling conditions:
1081      *
1082      * - When `from` and `to` are both non-zero, ``from``'s `tokenId` will be
1083      * transferred to `to`.
1084      * - When `from` is zero, `tokenId` will be minted for `to`.
1085      */
1086     function _beforeTokenTransfers(
1087         address from,
1088         address to,
1089         uint256 startTokenId,
1090         uint256 quantity
1091     ) internal virtual {}
1092 
1093     /**
1094      * @dev Hook that is called after a set of serially-ordered token ids have been transferred. This includes
1095      * minting.
1096      *
1097      * startTokenId - the first token id to be transferred
1098      * quantity - the amount to be transferred
1099      *
1100      * Calling conditions:
1101      *
1102      * - when `from` and `to` are both non-zero.
1103      * - `from` and `to` are never both zero.
1104      */
1105     function _afterTokenTransfers(
1106         address from,
1107         address to,
1108         uint256 startTokenId,
1109         uint256 quantity
1110     ) internal virtual {}
1111 }
1112 
1113 
1114 // Ownable.sol
1115 
1116 pragma solidity ^0.8.0;
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
1133     event OwnershipTransferred(
1134         address indexed previousOwner,
1135         address indexed newOwner
1136     );
1137 
1138     /**
1139      * @dev Initializes the contract setting the deployer as the initial owner.
1140      */
1141     constructor() {
1142         _setOwner(_msgSender());
1143     }
1144 
1145     /**
1146      * @dev Returns the address of the current owner.
1147      */
1148     function owner() public view virtual returns (address) {
1149         return _owner;
1150     }
1151 
1152     /**
1153      * @dev Throws if called by any account other than the owner.
1154      */
1155     modifier onlyOwner() {
1156         require(owner() == _msgSender(), "Ownable: caller is not the owner");
1157         _;
1158     }
1159 
1160     /**
1161      * @dev Leaves the contract without owner. It will not be possible to call
1162      * `onlyOwner` functions anymore. Can only be called by the current owner.
1163      *
1164      * NOTE: Renouncing ownership will leave the contract without an owner,
1165      * thereby removing any functionality that is only available to the owner.
1166      */
1167     function renounceOwnership() public virtual onlyOwner {
1168         _setOwner(address(0));
1169     }
1170 
1171     /**
1172      * @dev Transfers ownership of the contract to a new account (`newOwner`).
1173      * Can only be called by the current owner.
1174      */
1175     function transferOwnership(address newOwner) public virtual onlyOwner {
1176         require(
1177             newOwner != address(0),
1178             "Ownable: new owner is the zero address"
1179         );
1180         _setOwner(newOwner);
1181     }
1182 
1183     function _setOwner(address newOwner) private {
1184         address oldOwner = _owner;
1185         _owner = newOwner;
1186         emit OwnershipTransferred(oldOwner, newOwner);
1187     }
1188 }
1189 
1190 pragma solidity ^0.8.0;
1191 
1192 /**
1193  * @dev Contract module that helps prevent reentrant calls to a function.
1194  *
1195  * Inheriting from `ReentrancyGuard` will make the {nonReentrant} modifier
1196  * available, which can be applied to functions to make sure there are no nested
1197  * (reentrant) calls to them.
1198  *
1199  * Note that because there is a single `nonReentrant` guard, functions marked as
1200  * `nonReentrant` may not call one another. This can be worked around by making
1201  * those functions `private`, and then adding `external` `nonReentrant` entry
1202  * points to them.
1203  *
1204  * TIP: If you would like to learn more about reentrancy and alternative ways
1205  * to protect against it, check out our blog post
1206  * https://blog.openzeppelin.com/reentrancy-after-istanbul/[Reentrancy After Istanbul].
1207  */
1208 abstract contract ReentrancyGuard {
1209     // Booleans are more expensive than uint256 or any type that takes up a full
1210     // word because each write operation emits an extra SLOAD to first read the
1211     // slot's contents, replace the bits taken up by the boolean, and then write
1212     // back. This is the compiler's defense against contract upgrades and
1213     // pointer aliasing, and it cannot be disabled.
1214 
1215     // The values being non-zero value makes deployment a bit more expensive,
1216     // but in exchange the refund on every call to nonReentrant will be lower in
1217     // amount. Since refunds are capped to a percentage of the total
1218     // transaction's gas, it is best to keep them low in cases like this one, to
1219     // increase the likelihood of the full refund coming into effect.
1220     uint256 private constant _NOT_ENTERED = 1;
1221     uint256 private constant _ENTERED = 2;
1222 
1223     uint256 private _status;
1224 
1225     constructor() {
1226         _status = _NOT_ENTERED;
1227     }
1228 
1229     /**
1230      * @dev Prevents a contract from calling itself, directly or indirectly.
1231      * Calling a `nonReentrant` function from another `nonReentrant`
1232      * function is not supported. It is possible to prevent this from happening
1233      * by making the `nonReentrant` function external, and make it call a
1234      * `private` function that does the actual work.
1235      */
1236     modifier nonReentrant() {
1237         // On the first call to nonReentrant, _notEntered will be true
1238         require(_status != _ENTERED, "ReentrancyGuard: reentrant call");
1239 
1240         // Any calls to nonReentrant after this point will fail
1241         _status = _ENTERED;
1242 
1243         _;
1244 
1245         // By storing the original value once again, a refund is triggered (see
1246         // https://eips.ethereum.org/EIPS/eip-2200)
1247         _status = _NOT_ENTERED;
1248     }
1249 }
1250 
1251 //FuglyFairies.sol
1252 
1253 pragma solidity ^0.8.0;
1254 
1255 
1256 contract FuglyFairies is ERC721A, Ownable, ReentrancyGuard {
1257     using Strings for uint256;
1258     string public baseURI;
1259     uint256 public cost = 0.002 ether;
1260     uint256 public maxSupply = 5555;
1261     uint256 public maxFree = 1555;
1262     uint256 public maxperAddressFreeLimit = 2;
1263     uint256 public maxperAddressMint = 10;
1264 
1265     mapping(address => uint256) public addressFreeMintedBalance;
1266 
1267     constructor() ERC721A("FuglyFairies", "FUGLY") {
1268         setBaseURI("https://fuglyfairies.s3.amazonaws.com/metadata/");
1269 
1270     }
1271 
1272     function _baseURI() internal view virtual override returns (string memory) {
1273         return baseURI;
1274     }
1275 
1276     function mintFree(uint256 _mintAmount) public payable nonReentrant{
1277 		uint256 s = totalSupply();
1278         uint256 addressFreeMintedCount = addressFreeMintedBalance[msg.sender];
1279         require(addressFreeMintedCount + _mintAmount <= maxperAddressFreeLimit, "Max Fugly Fairies per address exceeded");
1280 		require(_mintAmount > 0, "Cannot mint 0 Fugly Fairies" );
1281 		require(s + _mintAmount <= maxFree, "Cannot exceed Fugly Fairies supply" );
1282 		for (uint256 i = 0; i < _mintAmount; ++i) {
1283             addressFreeMintedBalance[msg.sender]++;
1284 
1285 		}
1286         _safeMint(msg.sender, _mintAmount);
1287 		delete s;
1288         delete addressFreeMintedCount;
1289 	}
1290 
1291 
1292     function mint(uint256 _mintAmount) public payable nonReentrant {
1293         uint256 s = totalSupply();
1294         require(_mintAmount > 0, "Cannot mint 0 Fugly Fairies");
1295         require(_mintAmount <= maxperAddressMint, "Cannot mint more Fugly Fairies" );
1296         require(s + _mintAmount <= maxSupply, "Cannot exceed Fugly Fairies supply");
1297         require(msg.value >= cost * _mintAmount);
1298         _safeMint(msg.sender, _mintAmount);
1299         delete s;
1300     }
1301 
1302     function gift(uint256[] calldata quantity, address[] calldata recipient)
1303         external
1304         onlyOwner{
1305         require(
1306             quantity.length == recipient.length,
1307             "Provide quantities and recipients"
1308         );
1309         uint256 totalQuantity = 0;
1310         uint256 s = totalSupply();
1311         for (uint256 i = 0; i < quantity.length; ++i) {
1312             totalQuantity += quantity[i];
1313         }
1314         require(s + totalQuantity <= maxSupply, "Too many Fugly Fairies");
1315         delete totalQuantity;
1316         for (uint256 i = 0; i < recipient.length; ++i) {
1317             _safeMint(recipient[i], quantity[i]);
1318         }
1319         delete s;
1320     }
1321 
1322     function tokenURI(uint256 tokenId)
1323         public view virtual override returns (string memory){
1324         require(_exists(tokenId), "ERC721Metadata: Nonexistent token");
1325         string memory currentBaseURI = _baseURI();
1326         return
1327             bytes(currentBaseURI).length > 0
1328                 ? string(abi.encodePacked(currentBaseURI, tokenId.toString(), ".json"))
1329                 : "";
1330     }
1331 
1332 
1333     function setCost(uint256 _newCost) public onlyOwner {
1334         cost = _newCost;
1335     }
1336 
1337     function setmaxSupply(uint256 _newMaxSupply) public onlyOwner {
1338         maxSupply = _newMaxSupply;
1339     }
1340 
1341     function setmaxFreeSupply(uint256 _newMaxFreeSupply) public onlyOwner {
1342         maxFree = _newMaxFreeSupply;
1343     }
1344 
1345     function setBaseURI(string memory _newBaseURI) public onlyOwner {
1346         baseURI = _newBaseURI;
1347     }
1348 
1349     function setMaxperAddressMint(uint256 _amount) public onlyOwner {
1350         maxperAddressMint = _amount;
1351     }
1352 
1353     function setMaxperAddressFreeMint(uint256 _amount) public onlyOwner{
1354         maxperAddressFreeLimit = _amount;
1355     }
1356     function withdraw() public payable onlyOwner {
1357         (bool success, ) = payable(msg.sender).call{
1358             value: address(this).balance
1359         }("");
1360         require(success);
1361     }
1362 
1363 }