1 // SPDX-License-Identifier: MIT
2 pragma solidity 0.8.11;
3 
4 // Creator: Chiru Labs
5 
6 
7 
8 // OpenZeppelin Contracts v4.4.1 (token/ERC721/IERC721.sol)
9 
10 
11 
12 // OpenZeppelin Contracts v4.4.1 (utils/introspection/IERC165.sol)
13 
14 
15 
16 /**
17  * @dev Interface of the ERC165 standard, as defined in the
18  * https://eips.ethereum.org/EIPS/eip-165[EIP].
19  *
20  * Implementers can declare support of contract interfaces, which can then be
21  * queried by others ({ERC165Checker}).
22  *
23  * For an implementation, see {ERC165}.
24  */
25 interface IERC165 {
26     /**
27      * @dev Returns true if this contract implements the interface defined by
28      * `interfaceId`. See the corresponding
29      * https://eips.ethereum.org/EIPS/eip-165#how-interfaces-are-identified[EIP section]
30      * to learn more about how these ids are created.
31      *
32      * This function call must use less than 30 000 gas.
33      */
34     function supportsInterface(bytes4 interfaceId) external view returns (bool);
35 }
36 
37 /**
38  * @dev Required interface of an ERC721 compliant contract.
39  */
40 interface IERC721 is IERC165 {
41     /**
42      * @dev Emitted when `tokenId` token is transferred from `from` to `to`.
43      */
44     event Transfer(address indexed from, address indexed to, uint256 indexed tokenId);
45 
46     /**
47      * @dev Emitted when `owner` enables `approved` to manage the `tokenId` token.
48      */
49     event Approval(address indexed owner, address indexed approved, uint256 indexed tokenId);
50 
51     /**
52      * @dev Emitted when `owner` enables or disables (`approved`) `operator` to manage all of its assets.
53      */
54     event ApprovalForAll(address indexed owner, address indexed operator, bool approved);
55 
56     /**
57      * @dev Returns the number of tokens in ``owner``'s account.
58      */
59     function balanceOf(address owner) external view returns (uint256 balance);
60 
61     /**
62      * @dev Returns the owner of the `tokenId` token.
63      *
64      * Requirements:
65      *
66      * - `tokenId` must exist.
67      */
68     function ownerOf(uint256 tokenId) external view returns (address owner);
69 
70     /**
71      * @dev Safely transfers `tokenId` token from `from` to `to`, checking first that contract recipients
72      * are aware of the ERC721 protocol to prevent tokens from being forever locked.
73      *
74      * Requirements:
75      *
76      * - `from` cannot be the zero address.
77      * - `to` cannot be the zero address.
78      * - `tokenId` token must exist and be owned by `from`.
79      * - If the caller is not `from`, it must be have been allowed to move this token by either {approve} or {setApprovalForAll}.
80      * - If `to` refers to a smart contract, it must implement {IERC721Receiver-onERC721Received}, which is called upon a safe transfer.
81      *
82      * Emits a {Transfer} event.
83      */
84     function safeTransferFrom(
85         address from,
86         address to,
87         uint256 tokenId
88     ) external;
89 
90     /**
91      * @dev Transfers `tokenId` token from `from` to `to`.
92      *
93      * WARNING: Usage of this method is discouraged, use {safeTransferFrom} whenever possible.
94      *
95      * Requirements:
96      *
97      * - `from` cannot be the zero address.
98      * - `to` cannot be the zero address.
99      * - `tokenId` token must be owned by `from`.
100      * - If the caller is not `from`, it must be approved to move this token by either {approve} or {setApprovalForAll}.
101      *
102      * Emits a {Transfer} event.
103      */
104     function transferFrom(
105         address from,
106         address to,
107         uint256 tokenId
108     ) external;
109 
110     /**
111      * @dev Gives permission to `to` to transfer `tokenId` token to another account.
112      * The approval is cleared when the token is transferred.
113      *
114      * Only a single account can be approved at a time, so approving the zero address clears previous approvals.
115      *
116      * Requirements:
117      *
118      * - The caller must own the token or be an approved operator.
119      * - `tokenId` must exist.
120      *
121      * Emits an {Approval} event.
122      */
123     function approve(address to, uint256 tokenId) external;
124 
125     /**
126      * @dev Returns the account approved for `tokenId` token.
127      *
128      * Requirements:
129      *
130      * - `tokenId` must exist.
131      */
132     function getApproved(uint256 tokenId) external view returns (address operator);
133 
134     /**
135      * @dev Approve or remove `operator` as an operator for the caller.
136      * Operators can call {transferFrom} or {safeTransferFrom} for any token owned by the caller.
137      *
138      * Requirements:
139      *
140      * - The `operator` cannot be the caller.
141      *
142      * Emits an {ApprovalForAll} event.
143      */
144     function setApprovalForAll(address operator, bool _approved) external;
145 
146     /**
147      * @dev Returns if the `operator` is allowed to manage all of the assets of `owner`.
148      *
149      * See {setApprovalForAll}
150      */
151     function isApprovedForAll(address owner, address operator) external view returns (bool);
152 
153     /**
154      * @dev Safely transfers `tokenId` token from `from` to `to`.
155      *
156      * Requirements:
157      *
158      * - `from` cannot be the zero address.
159      * - `to` cannot be the zero address.
160      * - `tokenId` token must exist and be owned by `from`.
161      * - If the caller is not `from`, it must be approved to move this token by either {approve} or {setApprovalForAll}.
162      * - If `to` refers to a smart contract, it must implement {IERC721Receiver-onERC721Received}, which is called upon a safe transfer.
163      *
164      * Emits a {Transfer} event.
165      */
166     function safeTransferFrom(
167         address from,
168         address to,
169         uint256 tokenId,
170         bytes calldata data
171     ) external;
172 }
173 // OpenZeppelin Contracts v4.4.1 (token/ERC721/IERC721Receiver.sol)
174 
175 
176 
177 /**
178  * @title ERC721 token receiver interface
179  * @dev Interface for any contract that wants to support safeTransfers
180  * from ERC721 asset contracts.
181  */
182 interface IERC721Receiver {
183     /**
184      * @dev Whenever an {IERC721} `tokenId` token is transferred to this contract via {IERC721-safeTransferFrom}
185      * by `operator` from `from`, this function is called.
186      *
187      * It must return its Solidity selector to confirm the token transfer.
188      * If any other value is returned or the interface is not implemented by the recipient, the transfer will be reverted.
189      *
190      * The selector can be obtained in Solidity with `IERC721Receiver.onERC721Received.selector`.
191      */
192     function onERC721Received(
193         address operator,
194         address from,
195         uint256 tokenId,
196         bytes calldata data
197     ) external returns (bytes4);
198 }
199 // OpenZeppelin Contracts v4.4.1 (token/ERC721/extensions/IERC721Metadata.sol)
200 
201 
202 
203 
204 
205 /**
206  * @title ERC-721 Non-Fungible Token Standard, optional metadata extension
207  * @dev See https://eips.ethereum.org/EIPS/eip-721
208  */
209 interface IERC721Metadata is IERC721 {
210     /**
211      * @dev Returns the token collection name.
212      */
213     function name() external view returns (string memory);
214 
215     /**
216      * @dev Returns the token collection symbol.
217      */
218     function symbol() external view returns (string memory);
219 
220     /**
221      * @dev Returns the Uniform Resource Identifier (URI) for `tokenId` token.
222      */
223     function tokenURI(uint256 tokenId) external view returns (string memory);
224 }
225 // OpenZeppelin Contracts (last updated v4.5.0) (token/ERC721/extensions/IERC721Enumerable.sol)
226 
227 
228 
229 
230 
231 /**
232  * @title ERC-721 Non-Fungible Token Standard, optional enumeration extension
233  * @dev See https://eips.ethereum.org/EIPS/eip-721
234  */
235 interface IERC721Enumerable is IERC721 {
236     /**
237      * @dev Returns the total amount of tokens stored by the contract.
238      */
239     function totalSupply() external view returns (uint256);
240 
241     /**
242      * @dev Returns a token ID owned by `owner` at a given `index` of its token list.
243      * Use along with {balanceOf} to enumerate all of ``owner``'s tokens.
244      */
245     function tokenOfOwnerByIndex(address owner, uint256 index) external view returns (uint256);
246 
247     /**
248      * @dev Returns a token ID at a given `index` of all the tokens stored by the contract.
249      * Use along with {totalSupply} to enumerate all tokens.
250      */
251     function tokenByIndex(uint256 index) external view returns (uint256);
252 }
253 // OpenZeppelin Contracts (last updated v4.5.0) (utils/Address.sol)
254 
255 
256 
257 /**
258  * @dev Collection of functions related to the address type
259  */
260 library Address {
261     /**
262      * @dev Returns true if `account` is a contract.
263      *
264      * [IMPORTANT]
265      * ====
266      * It is unsafe to assume that an address for which this function returns
267      * false is an externally-owned account (EOA) and not a contract.
268      *
269      * Among others, `isContract` will return false for the following
270      * types of addresses:
271      *
272      *  - an externally-owned account
273      *  - a contract in construction
274      *  - an address where a contract will be created
275      *  - an address where a contract lived, but was destroyed
276      * ====
277      *
278      * [IMPORTANT]
279      * ====
280      * You shouldn't rely on `isContract` to protect against flash loan attacks!
281      *
282      * Preventing calls from contracts is highly discouraged. It breaks composability, breaks support for smart wallets
283      * like Gnosis Safe, and does not provide security since it can be circumvented by calling from a contract
284      * constructor.
285      * ====
286      */
287     function isContract(address account) internal view returns (bool) {
288         // This method relies on extcodesize/address.code.length, which returns 0
289         // for contracts in construction, since the code is only stored at the end
290         // of the constructor execution.
291 
292         return account.code.length > 0;
293     }
294 
295     /**
296      * @dev Replacement for Solidity's `transfer`: sends `amount` wei to
297      * `recipient`, forwarding all available gas and reverting on errors.
298      *
299      * https://eips.ethereum.org/EIPS/eip-1884[EIP1884] increases the gas cost
300      * of certain opcodes, possibly making contracts go over the 2300 gas limit
301      * imposed by `transfer`, making them unable to receive funds via
302      * `transfer`. {sendValue} removes this limitation.
303      *
304      * https://diligence.consensys.net/posts/2019/09/stop-using-soliditys-transfer-now/[Learn more].
305      *
306      * IMPORTANT: because control is transferred to `recipient`, care must be
307      * taken to not create reentrancy vulnerabilities. Consider using
308      * {ReentrancyGuard} or the
309      * https://solidity.readthedocs.io/en/v0.5.11/security-considerations.html#use-the-checks-effects-interactions-pattern[checks-effects-interactions pattern].
310      */
311     function sendValue(address payable recipient, uint256 amount) internal {
312         require(address(this).balance >= amount, "Address: insufficient balance");
313 
314         (bool success, ) = recipient.call{value: amount}("");
315         require(success, "Address: unable to send value, recipient may have reverted");
316     }
317 
318     /**
319      * @dev Performs a Solidity function call using a low level `call`. A
320      * plain `call` is an unsafe replacement for a function call: use this
321      * function instead.
322      *
323      * If `target` reverts with a revert reason, it is bubbled up by this
324      * function (like regular Solidity function calls).
325      *
326      * Returns the raw returned data. To convert to the expected return value,
327      * use https://solidity.readthedocs.io/en/latest/units-and-global-variables.html?highlight=abi.decode#abi-encoding-and-decoding-functions[`abi.decode`].
328      *
329      * Requirements:
330      *
331      * - `target` must be a contract.
332      * - calling `target` with `data` must not revert.
333      *
334      * _Available since v3.1._
335      */
336     function functionCall(address target, bytes memory data) internal returns (bytes memory) {
337         return functionCall(target, data, "Address: low-level call failed");
338     }
339 
340     /**
341      * @dev Same as {xref-Address-functionCall-address-bytes-}[`functionCall`], but with
342      * `errorMessage` as a fallback revert reason when `target` reverts.
343      *
344      * _Available since v3.1._
345      */
346     function functionCall(
347         address target,
348         bytes memory data,
349         string memory errorMessage
350     ) internal returns (bytes memory) {
351         return functionCallWithValue(target, data, 0, errorMessage);
352     }
353 
354     /**
355      * @dev Same as {xref-Address-functionCall-address-bytes-}[`functionCall`],
356      * but also transferring `value` wei to `target`.
357      *
358      * Requirements:
359      *
360      * - the calling contract must have an ETH balance of at least `value`.
361      * - the called Solidity function must be `payable`.
362      *
363      * _Available since v3.1._
364      */
365     function functionCallWithValue(
366         address target,
367         bytes memory data,
368         uint256 value
369     ) internal returns (bytes memory) {
370         return functionCallWithValue(target, data, value, "Address: low-level call with value failed");
371     }
372 
373     /**
374      * @dev Same as {xref-Address-functionCallWithValue-address-bytes-uint256-}[`functionCallWithValue`], but
375      * with `errorMessage` as a fallback revert reason when `target` reverts.
376      *
377      * _Available since v3.1._
378      */
379     function functionCallWithValue(
380         address target,
381         bytes memory data,
382         uint256 value,
383         string memory errorMessage
384     ) internal returns (bytes memory) {
385         require(address(this).balance >= value, "Address: insufficient balance for call");
386         require(isContract(target), "Address: call to non-contract");
387 
388         (bool success, bytes memory returndata) = target.call{value: value}(data);
389         return verifyCallResult(success, returndata, errorMessage);
390     }
391 
392     /**
393      * @dev Same as {xref-Address-functionCall-address-bytes-}[`functionCall`],
394      * but performing a static call.
395      *
396      * _Available since v3.3._
397      */
398     function functionStaticCall(address target, bytes memory data) internal view returns (bytes memory) {
399         return functionStaticCall(target, data, "Address: low-level static call failed");
400     }
401 
402     /**
403      * @dev Same as {xref-Address-functionCall-address-bytes-string-}[`functionCall`],
404      * but performing a static call.
405      *
406      * _Available since v3.3._
407      */
408     function functionStaticCall(
409         address target,
410         bytes memory data,
411         string memory errorMessage
412     ) internal view returns (bytes memory) {
413         require(isContract(target), "Address: static call to non-contract");
414 
415         (bool success, bytes memory returndata) = target.staticcall(data);
416         return verifyCallResult(success, returndata, errorMessage);
417     }
418 
419     /**
420      * @dev Same as {xref-Address-functionCall-address-bytes-}[`functionCall`],
421      * but performing a delegate call.
422      *
423      * _Available since v3.4._
424      */
425     function functionDelegateCall(address target, bytes memory data) internal returns (bytes memory) {
426         return functionDelegateCall(target, data, "Address: low-level delegate call failed");
427     }
428 
429     /**
430      * @dev Same as {xref-Address-functionCall-address-bytes-string-}[`functionCall`],
431      * but performing a delegate call.
432      *
433      * _Available since v3.4._
434      */
435     function functionDelegateCall(
436         address target,
437         bytes memory data,
438         string memory errorMessage
439     ) internal returns (bytes memory) {
440         require(isContract(target), "Address: delegate call to non-contract");
441 
442         (bool success, bytes memory returndata) = target.delegatecall(data);
443         return verifyCallResult(success, returndata, errorMessage);
444     }
445 
446     /**
447      * @dev Tool to verifies that a low level call was successful, and revert if it wasn't, either by bubbling the
448      * revert reason using the provided one.
449      *
450      * _Available since v4.3._
451      */
452     function verifyCallResult(
453         bool success,
454         bytes memory returndata,
455         string memory errorMessage
456     ) internal pure returns (bytes memory) {
457         if (success) {
458             return returndata;
459         } else {
460             // Look for revert reason and bubble it up if present
461             if (returndata.length > 0) {
462                 // The easiest way to bubble the revert reason is using memory via assembly
463 
464                 assembly {
465                     let returndata_size := mload(returndata)
466                     revert(add(32, returndata), returndata_size)
467                 }
468             } else {
469                 revert(errorMessage);
470             }
471         }
472     }
473 }
474 // OpenZeppelin Contracts v4.4.1 (utils/Context.sol)
475 
476 
477 
478 /**
479  * @dev Provides information about the current execution context, including the
480  * sender of the transaction and its data. While these are generally available
481  * via msg.sender and msg.data, they should not be accessed in such a direct
482  * manner, since when dealing with meta-transactions the account sending and
483  * paying for execution may not be the actual sender (as far as an application
484  * is concerned).
485  *
486  * This contract is only required for intermediate, library-like contracts.
487  */
488 abstract contract Context {
489     function _msgSender() internal view virtual returns (address) {
490         return msg.sender;
491     }
492 
493     function _msgData() internal view virtual returns (bytes calldata) {
494         return msg.data;
495     }
496 }
497 // OpenZeppelin Contracts v4.4.1 (utils/Strings.sol)
498 
499 
500 
501 /**
502  * @dev String operations.
503  */
504 library Strings {
505     bytes16 private constant _HEX_SYMBOLS = "0123456789abcdef";
506 
507     /**
508      * @dev Converts a `uint256` to its ASCII `string` decimal representation.
509      */
510     function toString(uint256 value) internal pure returns (string memory) {
511         // Inspired by OraclizeAPI's implementation - MIT licence
512         // https://github.com/oraclize/ethereum-api/blob/b42146b063c7d6ee1358846c198246239e9360e8/oraclizeAPI_0.4.25.sol
513 
514         if (value == 0) {
515             return "0";
516         }
517         uint256 temp = value;
518         uint256 digits;
519         while (temp != 0) {
520             digits++;
521             temp /= 10;
522         }
523         bytes memory buffer = new bytes(digits);
524         while (value != 0) {
525             digits -= 1;
526             buffer[digits] = bytes1(uint8(48 + uint256(value % 10)));
527             value /= 10;
528         }
529         return string(buffer);
530     }
531 
532     /**
533      * @dev Converts a `uint256` to its ASCII `string` hexadecimal representation.
534      */
535     function toHexString(uint256 value) internal pure returns (string memory) {
536         if (value == 0) {
537             return "0x00";
538         }
539         uint256 temp = value;
540         uint256 length = 0;
541         while (temp != 0) {
542             length++;
543             temp >>= 8;
544         }
545         return toHexString(value, length);
546     }
547 
548     /**
549      * @dev Converts a `uint256` to its ASCII `string` hexadecimal representation with fixed length.
550      */
551     function toHexString(uint256 value, uint256 length) internal pure returns (string memory) {
552         bytes memory buffer = new bytes(2 * length + 2);
553         buffer[0] = "0";
554         buffer[1] = "x";
555         for (uint256 i = 2 * length + 1; i > 1; --i) {
556             buffer[i] = _HEX_SYMBOLS[value & 0xf];
557             value >>= 4;
558         }
559         require(value == 0, "Strings: hex length insufficient");
560         return string(buffer);
561     }
562 }
563 // OpenZeppelin Contracts v4.4.1 (utils/introspection/ERC165.sol)
564 
565 
566 
567 
568 
569 /**
570  * @dev Implementation of the {IERC165} interface.
571  *
572  * Contracts that want to implement ERC165 should inherit from this contract and override {supportsInterface} to check
573  * for the additional interface id that will be supported. For example:
574  *
575  * ```solidity
576  * function supportsInterface(bytes4 interfaceId) public view virtual override returns (bool) {
577  *     return interfaceId == type(MyInterface).interfaceId || super.supportsInterface(interfaceId);
578  * }
579  * ```
580  *
581  * Alternatively, {ERC165Storage} provides an easier to use but more expensive implementation.
582  */
583 abstract contract ERC165 is IERC165 {
584     /**
585      * @dev See {IERC165-supportsInterface}.
586      */
587     function supportsInterface(bytes4 interfaceId) public view virtual override returns (bool) {
588         return interfaceId == type(IERC165).interfaceId;
589     }
590 }
591 
592 /**
593  * @dev Implementation of https://eips.ethereum.org/EIPS/eip-721[ERC721] Non-Fungible Token Standard, including
594  * the Metadata and Enumerable extension. Built to optimize for lower gas during batch mints.
595  *
596  * Assumes serials are sequentially minted starting at 0 (e.g. 0, 1, 2, 3..).
597  *
598  * Does not support burning tokens to address(0).
599  *
600  * Assumes that an owner cannot have more than the 2**128 - 1 (max value of uint128) of supply
601  */
602 contract ERC721A is
603     Context,
604     ERC165,
605     IERC721,
606     IERC721Metadata,
607     IERC721Enumerable
608 {
609     using Address for address;
610     using Strings for uint256;
611 
612     struct TokenOwnership {
613         address addr;
614         uint64 startTimestamp;
615     }
616 
617     struct AddressData {
618         uint128 balance;
619         uint128 numberMinted;
620     }
621 
622     uint256 internal currentIndex;
623 
624     // Token name
625     string private _name;
626 
627     // Token symbol
628     string private _symbol;
629 
630     // Mapping from token ID to ownership details
631     // An empty struct value does not necessarily mean the token is unowned. See ownershipOf implementation for details.
632     mapping(uint256 => TokenOwnership) internal _ownerships;
633 
634     // Mapping owner address to address data
635     mapping(address => AddressData) private _addressData;
636 
637     // Mapping from token ID to approved address
638     mapping(uint256 => address) private _tokenApprovals;
639 
640     // Mapping from owner to operator approvals
641     mapping(address => mapping(address => bool)) private _operatorApprovals;
642 
643     constructor(string memory name_, string memory symbol_) {
644         _name = name_;
645         _symbol = symbol_;
646     }
647 
648     /**
649      * @dev See {IERC721Enumerable-totalSupply}.
650      */
651     function totalSupply() public view override returns (uint256) {
652         return currentIndex;
653     }
654 
655     /**
656      * @dev See {IERC721Enumerable-tokenByIndex}.
657      */
658     function tokenByIndex(uint256 index)
659         public
660         view
661         override
662         returns (uint256)
663     {
664         require(index < totalSupply(), "ERC721A: global index out of bounds");
665         return index;
666     }
667 
668     /**
669      * @dev See {IERC721Enumerable-tokenOfOwnerByIndex}.
670      * This read function is O(totalSupply). If calling from a separate contract, be sure to test gas first.
671      * It may also degrade with extremely large collection sizes (e.g >> 10000), test for your use case.
672      */
673     function tokenOfOwnerByIndex(address owner, uint256 index)
674         public
675         view
676         override
677         returns (uint256)
678     {
679         require(index < balanceOf(owner), "ERC721A: owner index out of bounds");
680         uint256 numMintedSoFar = totalSupply();
681         uint256 tokenIdsIdx;
682         address currOwnershipAddr;
683 
684         // Counter overflow is impossible as the loop breaks when uint256 i is equal to another uint256 numMintedSoFar.
685         unchecked {
686             for (uint256 i; i < numMintedSoFar; i++) {
687                 TokenOwnership memory ownership = _ownerships[i];
688                 if (ownership.addr != address(0)) {
689                     currOwnershipAddr = ownership.addr;
690                 }
691                 if (currOwnershipAddr == owner) {
692                     if (tokenIdsIdx == index) {
693                         return i;
694                     }
695                     tokenIdsIdx++;
696                 }
697             }
698         }
699 
700         revert("ERC721A: unable to get token of owner by index");
701     }
702 
703     /**
704      * @dev See {IERC165-supportsInterface}.
705      */
706     function supportsInterface(bytes4 interfaceId)
707         public
708         view
709         virtual
710         override(ERC165, IERC165)
711         returns (bool)
712     {
713         return
714             interfaceId == type(IERC721).interfaceId ||
715             interfaceId == type(IERC721Metadata).interfaceId ||
716             interfaceId == type(IERC721Enumerable).interfaceId ||
717             super.supportsInterface(interfaceId);
718     }
719 
720     /**
721      * @dev See {IERC721-balanceOf}.
722      */
723     function balanceOf(address owner) public view override returns (uint256) {
724         require(
725             owner != address(0),
726             "ERC721A: balance query for the zero address"
727         );
728         return uint256(_addressData[owner].balance);
729     }
730 
731     function _numberMinted(address owner) internal view returns (uint256) {
732         require(
733             owner != address(0),
734             "ERC721A: number minted query for the zero address"
735         );
736         return uint256(_addressData[owner].numberMinted);
737     }
738 
739     /**
740      * Gas spent here starts off proportional to the maximum mint batch size.
741      * It gradually moves to O(1) as tokens get transferred around in the collection over time.
742      */
743     function ownershipOf(uint256 tokenId)
744         internal
745         view
746         returns (TokenOwnership memory)
747     {
748         require(_exists(tokenId), "ERC721A: owner query for nonexistent token");
749 
750         unchecked {
751             for (uint256 curr = tokenId; curr >= 0; curr--) {
752                 TokenOwnership memory ownership = _ownerships[curr];
753                 if (ownership.addr != address(0)) {
754                     return ownership;
755                 }
756             }
757         }
758 
759         revert("ERC721A: unable to determine the owner of token");
760     }
761 
762     /**
763      * @dev See {IERC721-ownerOf}.
764      */
765     function ownerOf(uint256 tokenId) public view override returns (address) {
766         return ownershipOf(tokenId).addr;
767     }
768 
769     /**
770      * @dev See {IERC721Metadata-name}.
771      */
772     function name() public view virtual override returns (string memory) {
773         return _name;
774     }
775 
776     /**
777      * @dev See {IERC721Metadata-symbol}.
778      */
779     function symbol() public view virtual override returns (string memory) {
780         return _symbol;
781     }
782 
783     /**
784      * @dev See {IERC721Metadata-tokenURI}.
785      */
786     function tokenURI(uint256 tokenId)
787         public
788         view
789         virtual
790         override
791         returns (string memory)
792     {
793         require(
794             _exists(tokenId),
795             "ERC721Metadata: URI query for nonexistent token"
796         );
797 
798         string memory baseURI = _baseURI();
799         return
800             bytes(baseURI).length != 0
801                 ? string(abi.encodePacked(baseURI, tokenId.toString()))
802                 : "";
803     }
804 
805     /**
806      * @dev Base URI for computing {tokenURI}. If set, the resulting URI for each
807      * token will be the concatenation of the `baseURI` and the `tokenId`. Empty
808      * by default, can be overriden in child contracts.
809      */
810     function _baseURI() internal view virtual returns (string memory) {
811         return "";
812     }
813 
814     /**
815      * @dev See {IERC721-approve}.
816      */
817     function approve(address to, uint256 tokenId) public override {
818         address owner = ERC721A.ownerOf(tokenId);
819         require(to != owner, "ERC721A: approval to current owner");
820 
821         require(
822             _msgSender() == owner || isApprovedForAll(owner, _msgSender()),
823             "ERC721A: approve caller is not owner nor approved for all"
824         );
825 
826         _approve(to, tokenId, owner);
827     }
828 
829     /**
830      * @dev See {IERC721-getApproved}.
831      */
832     function getApproved(uint256 tokenId)
833         public
834         view
835         override
836         returns (address)
837     {
838         require(
839             _exists(tokenId),
840             "ERC721A: approved query for nonexistent token"
841         );
842 
843         return _tokenApprovals[tokenId];
844     }
845 
846     /**
847      * @dev See {IERC721-setApprovalForAll}.
848      */
849     function setApprovalForAll(address operator, bool approved)
850         public
851         override
852     {
853         require(operator != _msgSender(), "ERC721A: approve to caller");
854 
855         _operatorApprovals[_msgSender()][operator] = approved;
856         emit ApprovalForAll(_msgSender(), operator, approved);
857     }
858 
859     /**
860      * @dev See {IERC721-isApprovedForAll}.
861      */
862     function isApprovedForAll(address owner, address operator)
863         public
864         view
865         virtual
866         override
867         returns (bool)
868     {
869         return _operatorApprovals[owner][operator];
870     }
871 
872     /**
873      * @dev See {IERC721-transferFrom}.
874      */
875     function transferFrom(
876         address from,
877         address to,
878         uint256 tokenId
879     ) public virtual override {
880         _transfer(from, to, tokenId);
881     }
882 
883     /**
884      * @dev See {IERC721-safeTransferFrom}.
885      */
886     function safeTransferFrom(
887         address from,
888         address to,
889         uint256 tokenId
890     ) public virtual override {
891         safeTransferFrom(from, to, tokenId, "");
892     }
893 
894     /**
895      * @dev See {IERC721-safeTransferFrom}.
896      */
897     function safeTransferFrom(
898         address from,
899         address to,
900         uint256 tokenId,
901         bytes memory _data
902     ) public override {
903         _transfer(from, to, tokenId);
904         require(
905             _checkOnERC721Received(from, to, tokenId, _data),
906             "ERC721A: transfer to non ERC721Receiver implementer"
907         );
908     }
909 
910     /**
911      * @dev Returns whether `tokenId` exists.
912      *
913      * Tokens can be managed by their owner or approved accounts via {approve} or {setApprovalForAll}.
914      *
915      * Tokens start existing when they are minted (`_mint`),
916      */
917     function _exists(uint256 tokenId) internal view returns (bool) {
918         return tokenId < currentIndex;
919     }
920 
921     function _safeMint(address to, uint256 quantity) internal {
922         _safeMint(to, quantity, "");
923     }
924 
925     /**
926      * @dev Safely mints `quantity` tokens and transfers them to `to`.
927      *
928      * Requirements:
929      *
930      * - If `to` refers to a smart contract, it must implement {IERC721Receiver-onERC721Received}, which is called for each safe transfer.
931      * - `quantity` must be greater than 0.
932      *
933      * Emits a {Transfer} event.
934      */
935     function _safeMint(
936         address to,
937         uint256 quantity,
938         bytes memory _data
939     ) internal {
940         _mint(to, quantity, _data, true);
941     }
942 
943     /**
944      * @dev Mints `quantity` tokens and transfers them to `to`.
945      *
946      * Requirements:
947      *
948      * - `to` cannot be the zero address.
949      * - `quantity` must be greater than 0.
950      *
951      * Emits a {Transfer} event.
952      */
953     function _mint(
954         address to,
955         uint256 quantity,
956         bytes memory _data,
957         bool safe
958     ) internal {
959         uint256 startTokenId = currentIndex;
960         require(to != address(0), "ERC721A: mint to the zero address");
961         require(quantity != 0, "ERC721A: quantity must be greater than 0");
962 
963         _beforeTokenTransfers(address(0), to, startTokenId, quantity);
964 
965         // Overflows are incredibly unrealistic.
966         // balance or numberMinted overflow if current value of either + quantity > 3.4e38 (2**128) - 1
967         // updatedIndex overflows if currentIndex + quantity > 1.56e77 (2**256) - 1
968         unchecked {
969             _addressData[to].balance += uint128(quantity);
970             _addressData[to].numberMinted += uint128(quantity);
971 
972             _ownerships[startTokenId].addr = to;
973             _ownerships[startTokenId].startTimestamp = uint64(block.timestamp);
974 
975             uint256 updatedIndex = startTokenId;
976 
977             for (uint256 i; i < quantity; i++) {
978                 emit Transfer(address(0), to, updatedIndex);
979                 if (safe) {
980                     require(
981                         _checkOnERC721Received(
982                             address(0),
983                             to,
984                             updatedIndex,
985                             _data
986                         ),
987                         "ERC721A: transfer to non ERC721Receiver implementer"
988                     );
989                 }
990 
991                 updatedIndex++;
992             }
993 
994             currentIndex = updatedIndex;
995         }
996 
997         _afterTokenTransfers(address(0), to, startTokenId, quantity);
998     }
999 
1000     /**
1001      * @dev Transfers `tokenId` from `from` to `to`.
1002      *
1003      * Requirements:
1004      *
1005      * - `to` cannot be the zero address.
1006      * - `tokenId` token must be owned by `from`.
1007      *
1008      * Emits a {Transfer} event.
1009      */
1010     function _transfer(
1011         address from,
1012         address to,
1013         uint256 tokenId
1014     ) private {
1015         TokenOwnership memory prevOwnership = ownershipOf(tokenId);
1016 
1017         bool isApprovedOrOwner = (_msgSender() == prevOwnership.addr ||
1018             getApproved(tokenId) == _msgSender() ||
1019             isApprovedForAll(prevOwnership.addr, _msgSender()));
1020 
1021         require(
1022             isApprovedOrOwner,
1023             "ERC721A: transfer caller is not owner nor approved"
1024         );
1025 
1026         require(
1027             prevOwnership.addr == from,
1028             "ERC721A: transfer from incorrect owner"
1029         );
1030         require(to != address(0), "ERC721A: transfer to the zero address");
1031 
1032         _beforeTokenTransfers(from, to, tokenId, 1);
1033 
1034         // Clear approvals from the previous owner
1035         _approve(address(0), tokenId, prevOwnership.addr);
1036 
1037         // Underflow of the sender's balance is impossible because we check for
1038         // ownership above and the recipient's balance can't realistically overflow.
1039         // Counter overflow is incredibly unrealistic as tokenId would have to be 2**256.
1040         unchecked {
1041             _addressData[from].balance -= 1;
1042             _addressData[to].balance += 1;
1043 
1044             _ownerships[tokenId].addr = to;
1045             _ownerships[tokenId].startTimestamp = uint64(block.timestamp);
1046 
1047             // If the ownership slot of tokenId+1 is not explicitly set, that means the transfer initiator owns it.
1048             // Set the slot of tokenId+1 explicitly in storage to maintain correctness for ownerOf(tokenId+1) calls.
1049             uint256 nextTokenId = tokenId + 1;
1050             if (_ownerships[nextTokenId].addr == address(0)) {
1051                 if (_exists(nextTokenId)) {
1052                     _ownerships[nextTokenId].addr = prevOwnership.addr;
1053                     _ownerships[nextTokenId].startTimestamp = prevOwnership
1054                         .startTimestamp;
1055                 }
1056             }
1057         }
1058 
1059         emit Transfer(from, to, tokenId);
1060         _afterTokenTransfers(from, to, tokenId, 1);
1061     }
1062 
1063     /**
1064      * @dev Approve `to` to operate on `tokenId`
1065      *
1066      * Emits a {Approval} event.
1067      */
1068     function _approve(
1069         address to,
1070         uint256 tokenId,
1071         address owner
1072     ) private {
1073         _tokenApprovals[tokenId] = to;
1074         emit Approval(owner, to, tokenId);
1075     }
1076 
1077     /**
1078      * @dev Internal function to invoke {IERC721Receiver-onERC721Received} on a target address.
1079      * The call is not executed if the target address is not a contract.
1080      *
1081      * @param from address representing the previous owner of the given token ID
1082      * @param to target address that will receive the tokens
1083      * @param tokenId uint256 ID of the token to be transferred
1084      * @param _data bytes optional data to send along with the call
1085      * @return bool whether the call correctly returned the expected magic value
1086      */
1087     function _checkOnERC721Received(
1088         address from,
1089         address to,
1090         uint256 tokenId,
1091         bytes memory _data
1092     ) private returns (bool) {
1093         if (to.isContract()) {
1094             try
1095                 IERC721Receiver(to).onERC721Received(
1096                     _msgSender(),
1097                     from,
1098                     tokenId,
1099                     _data
1100                 )
1101             returns (bytes4 retval) {
1102                 return retval == IERC721Receiver(to).onERC721Received.selector;
1103             } catch (bytes memory reason) {
1104                 if (reason.length == 0) {
1105                     revert(
1106                         "ERC721A: transfer to non ERC721Receiver implementer"
1107                     );
1108                 } else {
1109                     assembly {
1110                         revert(add(32, reason), mload(reason))
1111                     }
1112                 }
1113             }
1114         } else {
1115             return true;
1116         }
1117     }
1118 
1119     /**
1120      * @dev Hook that is called before a set of serially-ordered token ids are about to be transferred. This includes minting.
1121      *
1122      * startTokenId - the first token id to be transferred
1123      * quantity - the amount to be transferred
1124      *
1125      * Calling conditions:
1126      *
1127      * - When `from` and `to` are both non-zero, ``from``'s `tokenId` will be
1128      * transferred to `to`.
1129      * - When `from` is zero, `tokenId` will be minted for `to`.
1130      */
1131     function _beforeTokenTransfers(
1132         address from,
1133         address to,
1134         uint256 startTokenId,
1135         uint256 quantity
1136     ) internal virtual {}
1137 
1138     /**
1139      * @dev Hook that is called after a set of serially-ordered token ids have been transferred. This includes
1140      * minting.
1141      *
1142      * startTokenId - the first token id to be transferred
1143      * quantity - the amount to be transferred
1144      *
1145      * Calling conditions:
1146      *
1147      * - when `from` and `to` are both non-zero.
1148      * - `from` and `to` are never both zero.
1149      */
1150     function _afterTokenTransfers(
1151         address from,
1152         address to,
1153         uint256 startTokenId,
1154         uint256 quantity
1155     ) internal virtual {}
1156 }
1157 
1158 // OpenZeppelin Contracts v4.4.1 (access/Ownable.sol)
1159 
1160 
1161 
1162 
1163 
1164 /**
1165  * @dev Contract module which provides a basic access control mechanism, where
1166  * there is an account (an owner) that can be granted exclusive access to
1167  * specific functions.
1168  *
1169  * By default, the owner account will be the one that deploys the contract. This
1170  * can later be changed with {transferOwnership}.
1171  *
1172  * This module is used through inheritance. It will make available the modifier
1173  * `onlyOwner`, which can be applied to your functions to restrict their use to
1174  * the owner.
1175  */
1176 abstract contract Ownable is Context {
1177     address private _owner;
1178 
1179     event OwnershipTransferred(address indexed previousOwner, address indexed newOwner);
1180 
1181     /**
1182      * @dev Initializes the contract setting the deployer as the initial owner.
1183      */
1184     constructor() {
1185         _transferOwnership(_msgSender());
1186     }
1187 
1188     /**
1189      * @dev Returns the address of the current owner.
1190      */
1191     function owner() public view virtual returns (address) {
1192         return _owner;
1193     }
1194 
1195     /**
1196      * @dev Throws if called by any account other than the owner.
1197      */
1198     modifier onlyOwner() {
1199         require(owner() == _msgSender(), "Ownable: caller is not the owner");
1200         _;
1201     }
1202 
1203     /**
1204      * @dev Leaves the contract without owner. It will not be possible to call
1205      * `onlyOwner` functions anymore. Can only be called by the current owner.
1206      *
1207      * NOTE: Renouncing ownership will leave the contract without an owner,
1208      * thereby removing any functionality that is only available to the owner.
1209      */
1210     function renounceOwnership() public virtual onlyOwner {
1211         _transferOwnership(address(0));
1212     }
1213 
1214     /**
1215      * @dev Transfers ownership of the contract to a new account (`newOwner`).
1216      * Can only be called by the current owner.
1217      */
1218     function transferOwnership(address newOwner) public virtual onlyOwner {
1219         require(newOwner != address(0), "Ownable: new owner is the zero address");
1220         _transferOwnership(newOwner);
1221     }
1222 
1223     /**
1224      * @dev Transfers ownership of the contract to a new account (`newOwner`).
1225      * Internal function without access restriction.
1226      */
1227     function _transferOwnership(address newOwner) internal virtual {
1228         address oldOwner = _owner;
1229         _owner = newOwner;
1230         emit OwnershipTransferred(oldOwner, newOwner);
1231     }
1232 }
1233 // OpenZeppelin Contracts v4.4.1 (security/ReentrancyGuard.sol)
1234 
1235 
1236 
1237 /**
1238  * @dev Contract module that helps prevent reentrant calls to a function.
1239  *
1240  * Inheriting from `ReentrancyGuard` will make the {nonReentrant} modifier
1241  * available, which can be applied to functions to make sure there are no nested
1242  * (reentrant) calls to them.
1243  *
1244  * Note that because there is a single `nonReentrant` guard, functions marked as
1245  * `nonReentrant` may not call one another. This can be worked around by making
1246  * those functions `private`, and then adding `external` `nonReentrant` entry
1247  * points to them.
1248  *
1249  * TIP: If you would like to learn more about reentrancy and alternative ways
1250  * to protect against it, check out our blog post
1251  * https://blog.openzeppelin.com/reentrancy-after-istanbul/[Reentrancy After Istanbul].
1252  */
1253 abstract contract ReentrancyGuard {
1254     // Booleans are more expensive than uint256 or any type that takes up a full
1255     // word because each write operation emits an extra SLOAD to first read the
1256     // slot's contents, replace the bits taken up by the boolean, and then write
1257     // back. This is the compiler's defense against contract upgrades and
1258     // pointer aliasing, and it cannot be disabled.
1259 
1260     // The values being non-zero value makes deployment a bit more expensive,
1261     // but in exchange the refund on every call to nonReentrant will be lower in
1262     // amount. Since refunds are capped to a percentage of the total
1263     // transaction's gas, it is best to keep them low in cases like this one, to
1264     // increase the likelihood of the full refund coming into effect.
1265     uint256 private constant _NOT_ENTERED = 1;
1266     uint256 private constant _ENTERED = 2;
1267 
1268     uint256 private _status;
1269 
1270     constructor() {
1271         _status = _NOT_ENTERED;
1272     }
1273 
1274     /**
1275      * @dev Prevents a contract from calling itself, directly or indirectly.
1276      * Calling a `nonReentrant` function from another `nonReentrant`
1277      * function is not supported. It is possible to prevent this from happening
1278      * by making the `nonReentrant` function external, and making it call a
1279      * `private` function that does the actual work.
1280      */
1281     modifier nonReentrant() {
1282         // On the first call to nonReentrant, _notEntered will be true
1283         require(_status != _ENTERED, "ReentrancyGuard: reentrant call");
1284 
1285         // Any calls to nonReentrant after this point will fail
1286         _status = _ENTERED;
1287 
1288         _;
1289 
1290         // By storing the original value once again, a refund is triggered (see
1291         // https://eips.ethereum.org/EIPS/eip-2200)
1292         _status = _NOT_ENTERED;
1293     }
1294 }
1295 // OpenZeppelin Contracts (last updated v4.5.0) (utils/cryptography/MerkleProof.sol)
1296 
1297 
1298 
1299 /**
1300  * @dev These functions deal with verification of Merkle Trees proofs.
1301  *
1302  * The proofs can be generated using the JavaScript library
1303  * https://github.com/miguelmota/merkletreejs[merkletreejs].
1304  * Note: the hashing algorithm should be keccak256 and pair sorting should be enabled.
1305  *
1306  * See `test/utils/cryptography/MerkleProof.test.js` for some examples.
1307  *
1308  * WARNING: You should avoid using leaf values that are 64 bytes long prior to
1309  * hashing, or use a hash function other than keccak256 for hashing leaves.
1310  * This is because the concatenation of a sorted pair of internal nodes in
1311  * the merkle tree could be reinterpreted as a leaf value.
1312  */
1313 library MerkleProof {
1314     /**
1315      * @dev Returns true if a `leaf` can be proved to be a part of a Merkle tree
1316      * defined by `root`. For this, a `proof` must be provided, containing
1317      * sibling hashes on the branch from the leaf to the root of the tree. Each
1318      * pair of leaves and each pair of pre-images are assumed to be sorted.
1319      */
1320     function verify(
1321         bytes32[] memory proof,
1322         bytes32 root,
1323         bytes32 leaf
1324     ) internal pure returns (bool) {
1325         return processProof(proof, leaf) == root;
1326     }
1327 
1328     /**
1329      * @dev Returns the rebuilt hash obtained by traversing a Merkle tree up
1330      * from `leaf` using `proof`. A `proof` is valid if and only if the rebuilt
1331      * hash matches the root of the tree. When processing the proof, the pairs
1332      * of leafs & pre-images are assumed to be sorted.
1333      *
1334      * _Available since v4.4._
1335      */
1336     function processProof(bytes32[] memory proof, bytes32 leaf) internal pure returns (bytes32) {
1337         bytes32 computedHash = leaf;
1338         for (uint256 i = 0; i < proof.length; i++) {
1339             bytes32 proofElement = proof[i];
1340             if (computedHash <= proofElement) {
1341                 // Hash(current computed hash + current element of the proof)
1342                 computedHash = _efficientHash(computedHash, proofElement);
1343             } else {
1344                 // Hash(current element of the proof + current computed hash)
1345                 computedHash = _efficientHash(proofElement, computedHash);
1346             }
1347         }
1348         return computedHash;
1349     }
1350 
1351     function _efficientHash(bytes32 a, bytes32 b) private pure returns (bytes32 value) {
1352         assembly {
1353             mstore(0x00, a)
1354             mstore(0x20, b)
1355             value := keccak256(0x00, 0x40)
1356         }
1357     }
1358 }
1359 
1360 /// @title Hot Dougs
1361 contract HotDougs is Ownable, ReentrancyGuard, ERC721A("Hot Dougs", "DOUGS") {
1362     using Strings for uint256;
1363     using MerkleProof for bytes32[];
1364 
1365     /// @notice Max total supply.
1366     uint256 public dougsMax = 6969;
1367 
1368     /// @notice Max transaction amount.
1369     uint256 public constant dougsPerTx = 10;
1370 
1371     /// @notice Max Dougs per wallet in pre-sale
1372     uint256 public constant dougsMintPerWalletPresale = 3;
1373 
1374     /// @notice Total Dougs available in pre-sale
1375     uint256 public constant maxPreSaleDougs = 3000;
1376 
1377     /// @notice Dougs price.
1378     uint256 public constant dougsPrice = 0.05 ether;
1379 
1380     /// @notice 0 = closed, 1 = pre-sale, 2 = public
1381     uint256 public saleState;
1382 
1383     /// @notice Metadata baseURI.
1384     string public baseURI;
1385 
1386     /// @notice Metadata unrevealed uri.
1387     string public unrevealedURI;
1388 
1389     /// @notice Metadata baseURI extension.
1390     string public baseExtension;
1391 
1392     /// @notice OpenSea proxy registry.
1393     address public opensea = 0xa5409ec958C83C3f309868babACA7c86DCB077c1;
1394 
1395     /// @notice LooksRare marketplace transfer manager.
1396     address public looksrare = 0xf42aa99F011A1fA7CDA90E5E98b277E306BcA83e;
1397 
1398     /// @notice Check if marketplaces pre-approve is enabled.
1399     bool public marketplacesApproved = true;
1400 
1401     /// @notice Free mint merkle root.
1402     bytes32 public freeMintRoot;
1403 
1404     /// @notice Pre-sale merkle root.
1405     bytes32 public preMintRoot;
1406 
1407     /// @notice Amount minted by address on free mint.
1408     mapping(address => uint256) public freeMintCount;
1409 
1410     /// @notice Amount minted by address on pre access.
1411     mapping(address => uint256) public preMintCount;
1412 
1413     /// @notice Authorized callers mapping.
1414     mapping(address => bool) public auth;
1415 
1416     modifier canMintDougs(uint256 numberOfTokens) {
1417         require(
1418             totalSupply() + numberOfTokens <= dougsMax,
1419             "Not enough Dougs remaining to mint"
1420         );
1421         _;
1422     }
1423 
1424     modifier preSaleActive() {
1425         require(saleState == 1, "Pre sale is not open");
1426         _;
1427     }
1428 
1429     modifier publicSaleActive() {
1430         require(saleState == 2, "Public sale is not open");
1431         _;
1432     }
1433 
1434     modifier isValidMerkleProof(bytes32[] calldata merkleProof, bytes32 root) {
1435         require(
1436             MerkleProof.verify(
1437                 merkleProof,
1438                 root,
1439                 keccak256(abi.encodePacked(msg.sender))
1440             ),
1441             "Address does not exist in list"
1442         );
1443         _;
1444     }
1445 
1446     modifier isCorrectPayment(uint256 price, uint256 numberOfTokens) {
1447         require(
1448             price * numberOfTokens == msg.value,
1449             "Incorrect ETH value sent"
1450         );
1451         _;
1452     }
1453 
1454     modifier maxDougsPerTransaction(uint256 numberOfTokens) {
1455         require(
1456             numberOfTokens <= dougsPerTx,
1457             "Max Dougs to mint per transaction is 10"
1458         );
1459         _;
1460     }
1461 
1462     constructor(string memory newUnrevealedURI) {
1463         unrevealedURI = newUnrevealedURI;
1464     }
1465 
1466     /// @notice Mint one free token and up to 3 pre-sale tokens.
1467     function mintFree(uint256 numberOfTokens, bytes32[] calldata merkleProof)
1468         external
1469         payable
1470         nonReentrant
1471         preSaleActive
1472         isCorrectPayment(dougsPrice, numberOfTokens - 1)
1473         isValidMerkleProof(merkleProof, freeMintRoot)
1474     {
1475         if (msg.sender != owner()) {
1476             require(
1477                 freeMintCount[msg.sender] == 0,
1478                 "User already minted a free token"
1479             );
1480             uint256 numAlreadyMinted = preMintCount[msg.sender];
1481 
1482             require(
1483                 numAlreadyMinted + numberOfTokens - 1 <=
1484                     dougsMintPerWalletPresale,
1485                 "Max Dougs to mint in pre-sale is three"
1486             );
1487 
1488             require(
1489                 totalSupply() + numberOfTokens <= maxPreSaleDougs,
1490                 "Not enough Dougs remaining in pre-sale"
1491             );
1492 
1493             preMintCount[msg.sender] = numAlreadyMinted + numberOfTokens;
1494 
1495             freeMintCount[msg.sender]++;
1496         }
1497         _safeMint(msg.sender, numberOfTokens);
1498     }
1499 
1500     /// @notice Mint one or more tokens for address on pre-sale list.
1501     function mintPreDoug(uint256 numberOfTokens, bytes32[] calldata merkleProof)
1502         external
1503         payable
1504         nonReentrant
1505         preSaleActive
1506         isCorrectPayment(dougsPrice, numberOfTokens)
1507         isValidMerkleProof(merkleProof, preMintRoot)
1508     {
1509         uint256 numAlreadyMinted = preMintCount[msg.sender];
1510 
1511         require(
1512             numAlreadyMinted + numberOfTokens <= dougsMintPerWalletPresale,
1513             "Max Dougs to mint in pre-sale is three"
1514         );
1515 
1516         require(
1517             totalSupply() + numberOfTokens <= maxPreSaleDougs,
1518             "Not enough Dougs remaining in pre-sale"
1519         );
1520 
1521         preMintCount[msg.sender] += numberOfTokens;
1522 
1523         _safeMint(msg.sender, numberOfTokens);
1524     }
1525 
1526     /// @notice Mint one or more tokens.
1527     function mintDoug(uint256 numberOfTokens)
1528         external
1529         payable
1530         nonReentrant
1531         publicSaleActive
1532         isCorrectPayment(dougsPrice, numberOfTokens)
1533         canMintDougs(numberOfTokens)
1534         maxDougsPerTransaction(numberOfTokens)
1535     {
1536         _safeMint(msg.sender, numberOfTokens);
1537     }
1538 
1539     /// @notice Allow contract owner to mint tokens.
1540     function ownerMint(uint256 numberOfTokens)
1541         external
1542         onlyOwner
1543         canMintDougs(numberOfTokens)
1544     {
1545         _safeMint(msg.sender, numberOfTokens);
1546     }
1547 
1548     /// @notice See {IERC721-tokenURI}.
1549     function tokenURI(uint256 tokenId)
1550         public
1551         view
1552         override
1553         returns (string memory)
1554     {
1555         require(
1556             _exists(tokenId),
1557             "ERC721Metadata: URI query for nonexistent token"
1558         );
1559         if (bytes(unrevealedURI).length > 0) return unrevealedURI;
1560         return
1561             string(
1562                 abi.encodePacked(baseURI, tokenId.toString(), baseExtension)
1563             );
1564     }
1565 
1566     /// @notice Set baseURI to `newBaseURI`, baseExtension to `newBaseExtension` and deletes unrevealedURI, triggering a reveal.
1567     function setBaseURI(
1568         string memory newBaseURI,
1569         string memory newBaseExtension
1570     ) external onlyOwner {
1571         baseURI = newBaseURI;
1572         baseExtension = newBaseExtension;
1573         delete unrevealedURI;
1574     }
1575 
1576     /// @notice Set unrevealedURI to `newUnrevealedURI`.
1577     function setUnrevealedURI(string memory newUnrevealedURI)
1578         external
1579         onlyOwner
1580     {
1581         unrevealedURI = newUnrevealedURI;
1582     }
1583 
1584     /// @notice Set sale state. 0 = closed 1 = pre-sale 2 = public.
1585     function setSaleState(uint256 newSaleState) external onlyOwner {
1586         saleState = newSaleState;
1587     }
1588 
1589     /// @notice Set freeMintRoot to `newMerkleRoot`.
1590     function setFreeMintRoot(bytes32 newMerkleRoot) external onlyOwner {
1591         freeMintRoot = newMerkleRoot;
1592     }
1593 
1594     /// @notice Set preMintRoot to `newMerkleRoot`.
1595     function setPreMintRoot(bytes32 newMerkleRoot) external onlyOwner {
1596         preMintRoot = newMerkleRoot;
1597     }
1598 
1599     /// @notice Update Total Supply
1600     function setMaxDougs(uint256 _supply) external onlyOwner {
1601         dougsMax = _supply;
1602     }
1603 
1604     /// @notice Toggle marketplaces pre-approve feature.
1605     function toggleMarketplacesApproved() external onlyOwner {
1606         marketplacesApproved = !marketplacesApproved;
1607     }
1608 
1609     /// @notice Withdraw balance to Owner
1610     function withdrawMoney() external onlyOwner nonReentrant {
1611         (bool success, ) = msg.sender.call{value: address(this).balance}("");
1612         require(success, "Transfer failed.");
1613     }
1614 
1615     /// @notice See {ERC721-isApprovedForAll}.
1616     function isApprovedForAll(address owner, address operator)
1617         public
1618         view
1619         override
1620         returns (bool)
1621     {
1622         if (!marketplacesApproved)
1623             return auth[operator] || super.isApprovedForAll(owner, operator);
1624         return
1625             auth[operator] ||
1626             operator == address(ProxyRegistry(opensea).proxies(owner)) ||
1627             operator == looksrare ||
1628             super.isApprovedForAll(owner, operator);
1629     }
1630 }
1631 
1632 contract OwnableDelegateProxy {}
1633 
1634 contract ProxyRegistry {
1635     mapping(address => OwnableDelegateProxy) public proxies;
1636 }
1637 /**
1638  * @dev ERC-721 interface for accepting safe transfers.
1639  * See https://github.com/ethereum/EIPs/blob/master/EIPS/eip-721.md.
1640  */
1641 interface ERC721TokenReceiver {
1642     /**
1643      * @notice The contract address is always the message sender. A wallet/broker/auction application
1644      * MUST implement the wallet interface if it will accept safe transfers.
1645      * @dev Handle the receipt of a NFT. The ERC721 smart contract calls this function on the
1646      * recipient after a `transfer`. This function MAY throw to revert and reject the transfer. Return
1647      * of other than the magic value MUST result in the transaction being reverted.
1648      * Returns `bytes4(keccak256("onERC721Received(address,address,uint256,bytes)"))` unless throwing.
1649      * @param _operator The address which called `safeTransferFrom` function.
1650      * @param _from The address which previously owned the token.
1651      * @param _tokenId The NFT identifier which is being transferred.
1652      * @param _data Additional data with no specified format.
1653      * @return Returns `bytes4(keccak256("onERC721Received(address,address,uint256,bytes)"))`.
1654      */
1655     function onERC721Received(
1656         address _operator,
1657         address _from,
1658         uint256 _tokenId,
1659         bytes calldata _data
1660     ) external returns (bytes4);
1661 }
1662 
1663 
1664 
1665 contract HotDougsMinter is Ownable, ReentrancyGuard, ERC721TokenReceiver {
1666     event Received();
1667 
1668     // mapping from dougTokenId to claim status. 0 = available, 1 = claimed
1669     mapping(uint256 => uint256) public claimedDougs;
1670 
1671     /// @notice Max Dougs per transaction
1672     uint256 public constant paidDougsPerTx = 10;
1673 
1674     /// @notice price of Hot Dougs minted through Minter contract
1675     uint256 public hotDougPrice = .025 ether;
1676 
1677     /// @notice original HotDougs Contract Address
1678     address public dougContractAddress;
1679 
1680     /// @notice 0 = closed, 1 = pre-sale, 2 = public
1681     uint256 public saleState;
1682 
1683     /// @notice Update newDougPrice
1684     function setNewDougPrice(uint256 newDougPrice) external onlyOwner {
1685         hotDougPrice = newDougPrice;
1686     }
1687 
1688     /// @notice Max total supply.
1689     uint256 public maxHotDougs = 6969;
1690 
1691     /// @notice only allow free dougs until a specified tokenId
1692     uint256 public lastFreeHotDougTokenId;
1693 
1694     modifier maxDougsPerTransaction(uint256 numberOfTokens) {
1695         require(
1696             numberOfTokens <= paidDougsPerTx,
1697             "Max Dougs per transaction is 10"
1698         );
1699         _;
1700     }
1701 
1702     modifier publicSaleActive() {
1703         require(saleState == 2, "Public sale is not open");
1704         _;
1705     }
1706 
1707     modifier canMintDougs(uint256 numberOfTokens) {
1708         require(
1709             dougTotalSupply() + numberOfTokens <= maxHotDougs,
1710             "Not enough Dougs left"
1711         );
1712         _;
1713     }
1714 
1715     modifier isCorrectPayment(uint256 price, uint256 numberOfTokens) {
1716         require(
1717             price * numberOfTokens == msg.value,
1718             "Incorrect ETH value sent"
1719         );
1720         _;
1721     }
1722 
1723     function dougTotalSupply() public view returns (uint256) {
1724         HotDougs _hotDougs = HotDougs(dougContractAddress);
1725         return _hotDougs.totalSupply();
1726     }
1727 
1728     function setDougContractAddress(address originalHotDougAddress)
1729         external
1730         onlyOwner
1731     {
1732         dougContractAddress = originalHotDougAddress;
1733     }
1734 
1735     /// ----- Mint Doug Utils -----
1736 
1737     /// @notice gets TokenIds for Dougs an address owns
1738     function _getTokenIds(address _owner)
1739         internal
1740         view
1741         returns (uint256[] memory)
1742     {
1743         HotDougs _hotDougs = HotDougs(dougContractAddress);
1744         uint256 tokenBalance = _hotDougs.balanceOf(_owner);
1745 
1746         require(tokenBalance > 1, "No Tokens! per _getTokenIds");
1747         uint256[] memory _tokensOfOwner = new uint256[](tokenBalance);
1748 
1749         for (uint256 i = 0; i < tokenBalance; i++) {
1750             _tokensOfOwner[i] = _hotDougs.tokenOfOwnerByIndex(_owner, i);
1751         }
1752         return (_tokensOfOwner);
1753     }
1754 
1755     /// @notice Get the free dougs eligible by an address
1756     function getFreeDougArray(address _address)
1757         external
1758         view
1759         returns (uint256[] memory)
1760     {
1761         uint256[] memory addressTokenIds = _getTokenIds(_address);
1762         uint256 length = addressTokenIds.length;
1763 
1764         uint256[] memory claimableDougs = new uint256[](length);
1765         uint256 j = 0;
1766         for (uint256 i = 0; i < length; i++) {
1767             // check if the token is claimable for a free Doug
1768             if (
1769                 claimedDougs[addressTokenIds[i]] == 0 &&
1770                 addressTokenIds[i] <= lastFreeHotDougTokenId
1771             ) {
1772                 // if it is claimable add to the claimable array
1773                 claimableDougs[j] = addressTokenIds[i];
1774                 j++;
1775             } else {
1776                 // remove ineligible Dougs from the claimable array
1777                 assembly {
1778                     mstore(claimableDougs, sub(mload(claimableDougs), 1))
1779                 }
1780             }
1781         }
1782         return claimableDougs;
1783     }
1784 
1785     /// @notice check if an address has any Dougs that are claim eligible
1786     function checkForFreeDougs(address _address) public view returns (bool) {
1787         HotDougs _hotDougs = HotDougs(dougContractAddress);
1788         uint256 tokenBalance = _hotDougs.balanceOf(_address);
1789 
1790         bool claimableDougs;
1791 
1792         if (tokenBalance < 1) {
1793             claimableDougs = false;
1794         } else {
1795             uint256[] memory addressTokenIds = _getTokenIds(_address);
1796             uint256 length = addressTokenIds.length;
1797             for (uint256 i = 0; i < length; i++) {
1798                 // check if the token is claimable for a free Doug
1799                 if (
1800                     claimedDougs[addressTokenIds[i]] == 0 &&
1801                     addressTokenIds[i] <= lastFreeHotDougTokenId
1802                 ) {
1803                     // if it is claimable return true if not, keep going to see if any are claimable.
1804                     claimableDougs = true;
1805                     // leave the loop if any tokens are claimable
1806                     break;
1807                 } else {
1808                     claimableDougs = false;
1809                 }
1810             }
1811         }
1812         return claimableDougs;
1813     }
1814 
1815     function _mintAndTransferDoug(uint256 _numberOfTokens)
1816         internal
1817         canMintDougs(_numberOfTokens)
1818     {
1819         HotDougs _hotDougs = HotDougs(dougContractAddress);
1820 
1821         // get the current number of minted Dougs
1822         uint256 currentTotal = _hotDougs.totalSupply();
1823 
1824         // mint the token(s) to this contract
1825         _hotDougs.ownerMint(_numberOfTokens);
1826 
1827         // transfer the newly minted Dougs to the minter
1828         for (
1829             uint256 i = currentTotal;
1830             i <= _numberOfTokens + currentTotal - 1;
1831             i++
1832         ) {
1833             _hotDougs.transferFrom(address(this), tx.origin, i);
1834         }
1835     }
1836 
1837     /// @notice only used in case a token gets "stuck" in the minting contract
1838     function manualTransferContractOwnedDoug(address _to, uint256 _tokenId)
1839         external
1840         onlyOwner
1841     {
1842         HotDougs _hotDougs = HotDougs(dougContractAddress);
1843         _hotDougs.transferFrom(address(this), _to, _tokenId);
1844     }
1845 
1846     function onERC721Received(
1847         address _operator,
1848         address _from,
1849         uint256 _tokenId,
1850         bytes calldata _data
1851     ) external override returns (bytes4) {
1852         _operator;
1853         _from;
1854         _tokenId;
1855         _data;
1856         emit Received();
1857         return 0x150b7a02;
1858     }
1859 
1860     /// @notice Set original Hot Doug contract sale state
1861     function setHotDougSaleState(uint256 newSaleState) external onlyOwner {
1862         HotDougs _hotDougs = HotDougs(dougContractAddress);
1863         _hotDougs.setSaleState(newSaleState);
1864     }
1865 
1866     /// @notice Set original Hot Doug BaseURI
1867     function setHotDougBaseURI(
1868         string memory newBaseURI,
1869         string memory newBaseExtension
1870     ) external onlyOwner {
1871         HotDougs _hotDougs = HotDougs(dougContractAddress);
1872         _hotDougs.setBaseURI(newBaseURI, newBaseExtension);
1873     }
1874 
1875     /// @notice Set max Dougs on original Hot Dougs contract
1876     function setHotDougMaxDougs(uint256 newMaxDougs) external onlyOwner {
1877         HotDougs _hotDougs = HotDougs(dougContractAddress);
1878         _hotDougs.setMaxDougs(newMaxDougs);
1879     }
1880 
1881     /// @notice Set max Dougs on Hot Dougs Minter contract
1882     function setHotDougMinterMaxDougs(uint256 newMaxDougs) external onlyOwner {
1883         maxHotDougs = newMaxDougs;
1884     }
1885 
1886     /// @notice Set sale state. 0 = closed 1 = pre-sale 2 = public.
1887     function setSaleState(uint256 newSaleState) external onlyOwner {
1888         saleState = newSaleState;
1889     }
1890 
1891     /// @notice allow the owner to update the maximum tokenId redeemable for a free Doug
1892     function setLastFreeHotDougTokenId(uint256 _tokenId) external onlyOwner {
1893         lastFreeHotDougTokenId = _tokenId;
1894     }
1895 
1896     /// --- Money Moves ---
1897 
1898     /// @notice moves money from original Hot Dougs contract to Minter contract
1899     function withdrawToMinterContract() external onlyOwner {
1900         HotDougs _hotDougs = HotDougs(dougContractAddress);
1901         _hotDougs.withdrawMoney();
1902     }
1903 
1904     /// @notice moves money to owner of this contract
1905     function withdrawToOwner() external onlyOwner {
1906         (bool success, ) = payable(owner()).call{value: address(this).balance}(
1907             ""
1908         );
1909         require(success, "TRANSFER_FAILED");
1910     }
1911 
1912     /// ---- Functions to Mint ----
1913 
1914     /// @notice Mint a Doug
1915     function mintDougs(uint256 numberToMint)
1916         external
1917         payable
1918         publicSaleActive
1919         isCorrectPayment(hotDougPrice, numberToMint)
1920         canMintDougs(numberToMint)
1921         maxDougsPerTransaction(numberToMint)
1922         nonReentrant
1923     {
1924         _mintAndTransferDoug(numberToMint);
1925     }
1926 
1927     /// @notice send a free doug per tokenId to the transaction originator
1928     function sendFreeDougs(uint256[] memory freeDougArray) external {
1929         HotDougs _hotDougs = HotDougs(dougContractAddress);
1930         require(freeDougArray.length > 0);
1931 
1932         uint256[] memory addressTokenIds = freeDougArray;
1933         uint256 length = addressTokenIds.length;
1934         require(
1935             dougTotalSupply() + length <= maxHotDougs,
1936             "Not enough Dougs left"
1937         );
1938 
1939         // only allow claiming of up to 10 free Dougs at a time
1940         for (uint256 i = 0; i < length && i < 10; i++) {
1941             if (
1942                 claimedDougs[addressTokenIds[i]] == 0 &&
1943                 addressTokenIds[i] <= lastFreeHotDougTokenId &&
1944                 _hotDougs.ownerOf(addressTokenIds[i]) == tx.origin
1945             ) {
1946                 // add tokenId to list of claimedDougs
1947                 claimedDougs[addressTokenIds[i]] = 1;
1948                 // mint Doug and transfer to the tx.origin
1949                 _mintAndTransferDoug(1);
1950             }
1951         }
1952     }
1953 
1954     /// @notice allow the owner of this contract to mint
1955     function ownerMint(uint256 numberOfTokens)
1956         external
1957         onlyOwner
1958         canMintDougs(numberOfTokens)
1959     {
1960         _mintAndTransferDoug(numberOfTokens);
1961     }
1962 
1963     /// @notice Transfer the original Hot Doug contract ownership
1964     function transferHotDougOwnership(address newOwner) external onlyOwner {
1965         HotDougs _hotDougs = HotDougs(dougContractAddress);
1966         _hotDougs.transferOwnership(newOwner);
1967     }
1968 
1969     /// ###### USED WITH DEBUGGING #######
1970     function getBalance() public view returns (uint256) {
1971         return address(this).balance;
1972     }
1973 
1974     receive() external payable {}
1975 }
