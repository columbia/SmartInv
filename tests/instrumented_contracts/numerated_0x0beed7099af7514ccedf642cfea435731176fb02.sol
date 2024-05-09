1 // SPDX-License-Identifier: MIT
2 // OpenZeppelin Contracts v4.4.0 (utils/introspection/IERC165.sol)
3 
4 pragma solidity ^0.8.0;
5 
6 /**
7  * @dev Interface of the ERC165 standard, as defined in the
8  * https://eips.ethereum.org/EIPS/eip-165[EIP].
9  *
10  * Implementers can declare support of contract interfaces, which can then be
11  * queried by others ({ERC165Checker}).
12  *
13  * For an implementation, see {ERC165}.
14  */
15 interface IERC165 {
16     /**
17      * @dev Returns true if this contract implements the interface defined by
18      * `interfaceId`. See the corresponding
19      * https://eips.ethereum.org/EIPS/eip-165#how-interfaces-are-identified[EIP section]
20      * to learn more about how these ids are created.
21      *
22      * This function call must use less than 30 000 gas.
23      */
24     function supportsInterface(bytes4 interfaceId) external view returns (bool);
25 }
26 
27 // OpenZeppelin Contracts v4.4.0 (token/ERC721/IERC721.sol)
28 
29 
30 
31 
32 
33 /**
34  * @dev Required interface of an ERC721 compliant contract.
35  */
36 interface IERC721 is IERC165 {
37     /**
38      * @dev Emitted when `tokenId` token is transferred from `from` to `to`.
39      */
40     event Transfer(address indexed from, address indexed to, uint256 indexed tokenId);
41 
42     /**
43      * @dev Emitted when `owner` enables `approved` to manage the `tokenId` token.
44      */
45     event Approval(address indexed owner, address indexed approved, uint256 indexed tokenId);
46 
47     /**
48      * @dev Emitted when `owner` enables or disables (`approved`) `operator` to manage all of its assets.
49      */
50     event ApprovalForAll(address indexed owner, address indexed operator, bool approved);
51 
52     /**
53      * @dev Returns the number of tokens in ``owner``'s account.
54      */
55     function balanceOf(address owner) external view returns (uint256 balance);
56 
57     /**
58      * @dev Returns the owner of the `tokenId` token.
59      *
60      * Requirements:
61      *
62      * - `tokenId` must exist.
63      */
64     function ownerOf(uint256 tokenId) external view returns (address owner);
65 
66     /**
67      * @dev Safely transfers `tokenId` token from `from` to `to`, checking first that contract recipients
68      * are aware of the ERC721 protocol to prevent tokens from being forever locked.
69      *
70      * Requirements:
71      *
72      * - `from` cannot be the zero address.
73      * - `to` cannot be the zero address.
74      * - `tokenId` token must exist and be owned by `from`.
75      * - If the caller is not `from`, it must be have been allowed to move this token by either {approve} or {setApprovalForAll}.
76      * - If `to` refers to a smart contract, it must implement {IERC721Receiver-onERC721Received}, which is called upon a safe transfer.
77      *
78      * Emits a {Transfer} event.
79      */
80     function safeTransferFrom(
81         address from,
82         address to,
83         uint256 tokenId
84     ) external;
85 
86     /**
87      * @dev Transfers `tokenId` token from `from` to `to`.
88      *
89      * WARNING: Usage of this method is discouraged, use {safeTransferFrom} whenever possible.
90      *
91      * Requirements:
92      *
93      * - `from` cannot be the zero address.
94      * - `to` cannot be the zero address.
95      * - `tokenId` token must be owned by `from`.
96      * - If the caller is not `from`, it must be approved to move this token by either {approve} or {setApprovalForAll}.
97      *
98      * Emits a {Transfer} event.
99      */
100     function transferFrom(
101         address from,
102         address to,
103         uint256 tokenId
104     ) external;
105 
106     /**
107      * @dev Gives permission to `to` to transfer `tokenId` token to another account.
108      * The approval is cleared when the token is transferred.
109      *
110      * Only a single account can be approved at a time, so approving the zero address clears previous approvals.
111      *
112      * Requirements:
113      *
114      * - The caller must own the token or be an approved operator.
115      * - `tokenId` must exist.
116      *
117      * Emits an {Approval} event.
118      */
119     function approve(address to, uint256 tokenId) external;
120 
121     /**
122      * @dev Returns the account approved for `tokenId` token.
123      *
124      * Requirements:
125      *
126      * - `tokenId` must exist.
127      */
128     function getApproved(uint256 tokenId) external view returns (address operator);
129 
130     /**
131      * @dev Approve or remove `operator` as an operator for the caller.
132      * Operators can call {transferFrom} or {safeTransferFrom} for any token owned by the caller.
133      *
134      * Requirements:
135      *
136      * - The `operator` cannot be the caller.
137      *
138      * Emits an {ApprovalForAll} event.
139      */
140     function setApprovalForAll(address operator, bool _approved) external;
141 
142     /**
143      * @dev Returns if the `operator` is allowed to manage all of the assets of `owner`.
144      *
145      * See {setApprovalForAll}
146      */
147     function isApprovedForAll(address owner, address operator) external view returns (bool);
148 
149     /**
150      * @dev Safely transfers `tokenId` token from `from` to `to`.
151      *
152      * Requirements:
153      *
154      * - `from` cannot be the zero address.
155      * - `to` cannot be the zero address.
156      * - `tokenId` token must exist and be owned by `from`.
157      * - If the caller is not `from`, it must be approved to move this token by either {approve} or {setApprovalForAll}.
158      * - If `to` refers to a smart contract, it must implement {IERC721Receiver-onERC721Received}, which is called upon a safe transfer.
159      *
160      * Emits a {Transfer} event.
161      */
162     function safeTransferFrom(
163         address from,
164         address to,
165         uint256 tokenId,
166         bytes calldata data
167     ) external;
168 }
169 
170 // OpenZeppelin Contracts v4.4.0 (utils/Strings.sol)
171 
172 
173 
174 /**
175  * @dev String operations.
176  */
177 library Strings {
178     bytes16 private constant _HEX_SYMBOLS = "0123456789abcdef";
179 
180     /**
181      * @dev Converts a `uint256` to its ASCII `string` decimal representation.
182      */
183     function toString(uint256 value) internal pure returns (string memory) {
184         // Inspired by OraclizeAPI's implementation - MIT licence
185         // https://github.com/oraclize/ethereum-api/blob/b42146b063c7d6ee1358846c198246239e9360e8/oraclizeAPI_0.4.25.sol
186 
187         if (value == 0) {
188             return "0";
189         }
190         uint256 temp = value;
191         uint256 digits;
192         while (temp != 0) {
193             digits++;
194             temp /= 10;
195         }
196         bytes memory buffer = new bytes(digits);
197         while (value != 0) {
198             digits -= 1;
199             buffer[digits] = bytes1(uint8(48 + uint256(value % 10)));
200             value /= 10;
201         }
202         return string(buffer);
203     }
204 
205     /**
206      * @dev Converts a `uint256` to its ASCII `string` hexadecimal representation.
207      */
208     function toHexString(uint256 value) internal pure returns (string memory) {
209         if (value == 0) {
210             return "0x00";
211         }
212         uint256 temp = value;
213         uint256 length = 0;
214         while (temp != 0) {
215             length++;
216             temp >>= 8;
217         }
218         return toHexString(value, length);
219     }
220 
221     /**
222      * @dev Converts a `uint256` to its ASCII `string` hexadecimal representation with fixed length.
223      */
224     function toHexString(uint256 value, uint256 length) internal pure returns (string memory) {
225         bytes memory buffer = new bytes(2 * length + 2);
226         buffer[0] = "0";
227         buffer[1] = "x";
228         for (uint256 i = 2 * length + 1; i > 1; --i) {
229             buffer[i] = _HEX_SYMBOLS[value & 0xf];
230             value >>= 4;
231         }
232         require(value == 0, "Strings: hex length insufficient");
233         return string(buffer);
234     }
235 }
236 
237 // OpenZeppelin Contracts v4.4.0 (utils/Context.sol)
238 
239 
240 
241 /**
242  * @dev Provides information about the current execution context, including the
243  * sender of the transaction and its data. While these are generally available
244  * via msg.sender and msg.data, they should not be accessed in such a direct
245  * manner, since when dealing with meta-transactions the account sending and
246  * paying for execution may not be the actual sender (as far as an application
247  * is concerned).
248  *
249  * This contract is only required for intermediate, library-like contracts.
250  */
251 abstract contract Context {
252     function _msgSender() internal view virtual returns (address) {
253         return msg.sender;
254     }
255 
256     function _msgData() internal view virtual returns (bytes calldata) {
257         return msg.data;
258     }
259 }
260 
261 
262 
263 
264 
265 // OpenZeppelin Contracts v4.4.0 (token/ERC721/extensions/ERC721Enumerable.sol)
266 
267 
268 
269 
270 // OpenZeppelin Contracts v4.4.0 (token/ERC721/ERC721.sol)
271 
272 
273 
274 
275 
276 // OpenZeppelin Contracts v4.4.0 (token/ERC721/IERC721Receiver.sol)
277 
278 
279 
280 /**
281  * @title ERC721 token receiver interface
282  * @dev Interface for any contract that wants to support safeTransfers
283  * from ERC721 asset contracts.
284  */
285 interface IERC721Receiver {
286     /**
287      * @dev Whenever an {IERC721} `tokenId` token is transferred to this contract via {IERC721-safeTransferFrom}
288      * by `operator` from `from`, this function is called.
289      *
290      * It must return its Solidity selector to confirm the token transfer.
291      * If any other value is returned or the interface is not implemented by the recipient, the transfer will be reverted.
292      *
293      * The selector can be obtained in Solidity with `IERC721.onERC721Received.selector`.
294      */
295     function onERC721Received(
296         address operator,
297         address from,
298         uint256 tokenId,
299         bytes calldata data
300     ) external returns (bytes4);
301 }
302 
303 
304 // OpenZeppelin Contracts v4.4.0 (token/ERC721/extensions/IERC721Metadata.sol)
305 
306 
307 
308 
309 
310 /**
311  * @title ERC-721 Non-Fungible Token Standard, optional metadata extension
312  * @dev See https://eips.ethereum.org/EIPS/eip-721
313  */
314 interface IERC721Metadata is IERC721 {
315     /**
316      * @dev Returns the token collection name.
317      */
318     function name() external view returns (string memory);
319 
320     /**
321      * @dev Returns the token collection symbol.
322      */
323     function symbol() external view returns (string memory);
324 
325     /**
326      * @dev Returns the Uniform Resource Identifier (URI) for `tokenId` token.
327      */
328     function tokenURI(uint256 tokenId) external view returns (string memory);
329 }
330 
331 
332 // OpenZeppelin Contracts v4.4.0 (utils/Address.sol)
333 
334 
335 
336 /**
337  * @dev Collection of functions related to the address type
338  */
339 library Address {
340     /**
341      * @dev Returns true if `account` is a contract.
342      *
343      * [IMPORTANT]
344      * ====
345      * It is unsafe to assume that an address for which this function returns
346      * false is an externally-owned account (EOA) and not a contract.
347      *
348      * Among others, `isContract` will return false for the following
349      * types of addresses:
350      *
351      *  - an externally-owned account
352      *  - a contract in construction
353      *  - an address where a contract will be created
354      *  - an address where a contract lived, but was destroyed
355      * ====
356      */
357     function isContract(address account) internal view returns (bool) {
358         // This method relies on extcodesize, which returns 0 for contracts in
359         // construction, since the code is only stored at the end of the
360         // constructor execution.
361 
362         uint256 size;
363         assembly {
364             size := extcodesize(account)
365         }
366         return size > 0;
367     }
368 
369     /**
370      * @dev Replacement for Solidity's `transfer`: sends `amount` wei to
371      * `recipient`, forwarding all available gas and reverting on errors.
372      *
373      * https://eips.ethereum.org/EIPS/eip-1884[EIP1884] increases the gas cost
374      * of certain opcodes, possibly making contracts go over the 2300 gas limit
375      * imposed by `transfer`, making them unable to receive funds via
376      * `transfer`. {sendValue} removes this limitation.
377      *
378      * https://diligence.consensys.net/posts/2019/09/stop-using-soliditys-transfer-now/[Learn more].
379      *
380      * IMPORTANT: because control is transferred to `recipient`, care must be
381      * taken to not create reentrancy vulnerabilities. Consider using
382      * {ReentrancyGuard} or the
383      * https://solidity.readthedocs.io/en/v0.5.11/security-considerations.html#use-the-checks-effects-interactions-pattern[checks-effects-interactions pattern].
384      */
385     function sendValue(address payable recipient, uint256 amount) internal {
386         require(address(this).balance >= amount, "Address: insufficient balance");
387 
388         (bool success, ) = recipient.call{value: amount}("");
389         require(success, "Address: unable to send value, recipient may have reverted");
390     }
391 
392     /**
393      * @dev Performs a Solidity function call using a low level `call`. A
394      * plain `call` is an unsafe replacement for a function call: use this
395      * function instead.
396      *
397      * If `target` reverts with a revert reason, it is bubbled up by this
398      * function (like regular Solidity function calls).
399      *
400      * Returns the raw returned data. To convert to the expected return value,
401      * use https://solidity.readthedocs.io/en/latest/units-and-global-variables.html?highlight=abi.decode#abi-encoding-and-decoding-functions[`abi.decode`].
402      *
403      * Requirements:
404      *
405      * - `target` must be a contract.
406      * - calling `target` with `data` must not revert.
407      *
408      * _Available since v3.1._
409      */
410     function functionCall(address target, bytes memory data) internal returns (bytes memory) {
411         return functionCall(target, data, "Address: low-level call failed");
412     }
413 
414     /**
415      * @dev Same as {xref-Address-functionCall-address-bytes-}[`functionCall`], but with
416      * `errorMessage` as a fallback revert reason when `target` reverts.
417      *
418      * _Available since v3.1._
419      */
420     function functionCall(
421         address target,
422         bytes memory data,
423         string memory errorMessage
424     ) internal returns (bytes memory) {
425         return functionCallWithValue(target, data, 0, errorMessage);
426     }
427 
428     /**
429      * @dev Same as {xref-Address-functionCall-address-bytes-}[`functionCall`],
430      * but also transferring `value` wei to `target`.
431      *
432      * Requirements:
433      *
434      * - the calling contract must have an ETH balance of at least `value`.
435      * - the called Solidity function must be `payable`.
436      *
437      * _Available since v3.1._
438      */
439     function functionCallWithValue(
440         address target,
441         bytes memory data,
442         uint256 value
443     ) internal returns (bytes memory) {
444         return functionCallWithValue(target, data, value, "Address: low-level call with value failed");
445     }
446 
447     /**
448      * @dev Same as {xref-Address-functionCallWithValue-address-bytes-uint256-}[`functionCallWithValue`], but
449      * with `errorMessage` as a fallback revert reason when `target` reverts.
450      *
451      * _Available since v3.1._
452      */
453     function functionCallWithValue(
454         address target,
455         bytes memory data,
456         uint256 value,
457         string memory errorMessage
458     ) internal returns (bytes memory) {
459         require(address(this).balance >= value, "Address: insufficient balance for call");
460         require(isContract(target), "Address: call to non-contract");
461 
462         (bool success, bytes memory returndata) = target.call{value: value}(data);
463         return verifyCallResult(success, returndata, errorMessage);
464     }
465 
466     /**
467      * @dev Same as {xref-Address-functionCall-address-bytes-}[`functionCall`],
468      * but performing a static call.
469      *
470      * _Available since v3.3._
471      */
472     function functionStaticCall(address target, bytes memory data) internal view returns (bytes memory) {
473         return functionStaticCall(target, data, "Address: low-level static call failed");
474     }
475 
476     /**
477      * @dev Same as {xref-Address-functionCall-address-bytes-string-}[`functionCall`],
478      * but performing a static call.
479      *
480      * _Available since v3.3._
481      */
482     function functionStaticCall(
483         address target,
484         bytes memory data,
485         string memory errorMessage
486     ) internal view returns (bytes memory) {
487         require(isContract(target), "Address: static call to non-contract");
488 
489         (bool success, bytes memory returndata) = target.staticcall(data);
490         return verifyCallResult(success, returndata, errorMessage);
491     }
492 
493     /**
494      * @dev Same as {xref-Address-functionCall-address-bytes-}[`functionCall`],
495      * but performing a delegate call.
496      *
497      * _Available since v3.4._
498      */
499     function functionDelegateCall(address target, bytes memory data) internal returns (bytes memory) {
500         return functionDelegateCall(target, data, "Address: low-level delegate call failed");
501     }
502 
503     /**
504      * @dev Same as {xref-Address-functionCall-address-bytes-string-}[`functionCall`],
505      * but performing a delegate call.
506      *
507      * _Available since v3.4._
508      */
509     function functionDelegateCall(
510         address target,
511         bytes memory data,
512         string memory errorMessage
513     ) internal returns (bytes memory) {
514         require(isContract(target), "Address: delegate call to non-contract");
515 
516         (bool success, bytes memory returndata) = target.delegatecall(data);
517         return verifyCallResult(success, returndata, errorMessage);
518     }
519 
520     /**
521      * @dev Tool to verifies that a low level call was successful, and revert if it wasn't, either by bubbling the
522      * revert reason using the provided one.
523      *
524      * _Available since v4.3._
525      */
526     function verifyCallResult(
527         bool success,
528         bytes memory returndata,
529         string memory errorMessage
530     ) internal pure returns (bytes memory) {
531         if (success) {
532             return returndata;
533         } else {
534             // Look for revert reason and bubble it up if present
535             if (returndata.length > 0) {
536                 // The easiest way to bubble the revert reason is using memory via assembly
537 
538                 assembly {
539                     let returndata_size := mload(returndata)
540                     revert(add(32, returndata), returndata_size)
541                 }
542             } else {
543                 revert(errorMessage);
544             }
545         }
546     }
547 }
548 
549 
550 
551 
552 // OpenZeppelin Contracts v4.4.0 (utils/introspection/ERC165.sol)
553 
554 
555 
556 
557 
558 /**
559  * @dev Implementation of the {IERC165} interface.
560  *
561  * Contracts that want to implement ERC165 should inherit from this contract and override {supportsInterface} to check
562  * for the additional interface id that will be supported. For example:
563  *
564  * ```solidity
565  * function supportsInterface(bytes4 interfaceId) public view virtual override returns (bool) {
566  *     return interfaceId == type(MyInterface).interfaceId || super.supportsInterface(interfaceId);
567  * }
568  * ```
569  *
570  * Alternatively, {ERC165Storage} provides an easier to use but more expensive implementation.
571  */
572 abstract contract ERC165 is IERC165 {
573     /**
574      * @dev See {IERC165-supportsInterface}.
575      */
576     function supportsInterface(bytes4 interfaceId) public view virtual override returns (bool) {
577         return interfaceId == type(IERC165).interfaceId;
578     }
579 }
580 
581 
582 /**
583  * @dev Implementation of https://eips.ethereum.org/EIPS/eip-721[ERC721] Non-Fungible Token Standard, including
584  * the Metadata extension, but not including the Enumerable extension, which is available separately as
585  * {ERC721Enumerable}.
586  */
587 contract ERC721 is Context, ERC165, IERC721, IERC721Metadata {
588     using Address for address;
589     using Strings for uint256;
590 
591     // Token name
592     string private _name;
593 
594     // Token symbol
595     string private _symbol;
596 
597     // Mapping from token ID to owner address
598     mapping(uint256 => address) private _owners;
599 
600     // Mapping owner address to token count
601     mapping(address => uint256) private _balances;
602 
603     // Mapping from token ID to approved address
604     mapping(uint256 => address) private _tokenApprovals;
605 
606     // Mapping from owner to operator approvals
607     mapping(address => mapping(address => bool)) private _operatorApprovals;
608 
609     /**
610      * @dev Initializes the contract by setting a `name` and a `symbol` to the token collection.
611      */
612     constructor(string memory name_, string memory symbol_) {
613         _name = name_;
614         _symbol = symbol_;
615     }
616 
617     /**
618      * @dev See {IERC165-supportsInterface}.
619      */
620     function supportsInterface(bytes4 interfaceId) public view virtual override(ERC165, IERC165) returns (bool) {
621         return
622             interfaceId == type(IERC721).interfaceId ||
623             interfaceId == type(IERC721Metadata).interfaceId ||
624             super.supportsInterface(interfaceId);
625     }
626 
627     /**
628      * @dev See {IERC721-balanceOf}.
629      */
630     function balanceOf(address owner) public view virtual override returns (uint256) {
631         require(owner != address(0), "ERC721: balance query for the zero address");
632         return _balances[owner];
633     }
634 
635     /**
636      * @dev See {IERC721-ownerOf}.
637      */
638     function ownerOf(uint256 tokenId) public view virtual override returns (address) {
639         address owner = _owners[tokenId];
640         require(owner != address(0), "ERC721: owner query for nonexistent token");
641         return owner;
642     }
643 
644     /**
645      * @dev See {IERC721Metadata-name}.
646      */
647     function name() public view virtual override returns (string memory) {
648         return _name;
649     }
650 
651     /**
652      * @dev See {IERC721Metadata-symbol}.
653      */
654     function symbol() public view virtual override returns (string memory) {
655         return _symbol;
656     }
657 
658     /**
659      * @dev See {IERC721Metadata-tokenURI}.
660      */
661     function tokenURI(uint256 tokenId) public view virtual override returns (string memory) {
662         require(_exists(tokenId), "ERC721Metadata: URI query for nonexistent token");
663 
664         string memory baseURI = _baseURI();
665         return bytes(baseURI).length > 0 ? string(abi.encodePacked(baseURI, tokenId.toString())) : "";
666     }
667 
668     /**
669      * @dev Base URI for computing {tokenURI}. If set, the resulting URI for each
670      * token will be the concatenation of the `baseURI` and the `tokenId`. Empty
671      * by default, can be overriden in child contracts.
672      */
673     function _baseURI() internal view virtual returns (string memory) {
674         return "";
675     }
676 
677     /**
678      * @dev See {IERC721-approve}.
679      */
680     function approve(address to, uint256 tokenId) public virtual override {
681         address owner = ERC721.ownerOf(tokenId);
682         require(to != owner, "ERC721: approval to current owner");
683 
684         require(
685             _msgSender() == owner || isApprovedForAll(owner, _msgSender()),
686             "ERC721: approve caller is not owner nor approved for all"
687         );
688 
689         _approve(to, tokenId);
690     }
691 
692     /**
693      * @dev See {IERC721-getApproved}.
694      */
695     function getApproved(uint256 tokenId) public view virtual override returns (address) {
696         require(_exists(tokenId), "ERC721: approved query for nonexistent token");
697 
698         return _tokenApprovals[tokenId];
699     }
700 
701     /**
702      * @dev See {IERC721-setApprovalForAll}.
703      */
704     function setApprovalForAll(address operator, bool approved) public virtual override {
705         _setApprovalForAll(_msgSender(), operator, approved);
706     }
707 
708     /**
709      * @dev See {IERC721-isApprovedForAll}.
710      */
711     function isApprovedForAll(address owner, address operator) public view virtual override returns (bool) {
712         return _operatorApprovals[owner][operator];
713     }
714 
715     /**
716      * @dev See {IERC721-transferFrom}.
717      */
718     function transferFrom(
719         address from,
720         address to,
721         uint256 tokenId
722     ) public virtual override {
723         //solhint-disable-next-line max-line-length
724         require(_isApprovedOrOwner(_msgSender(), tokenId), "ERC721: transfer caller is not owner nor approved");
725 
726         _transfer(from, to, tokenId);
727     }
728 
729     /**
730      * @dev See {IERC721-safeTransferFrom}.
731      */
732     function safeTransferFrom(
733         address from,
734         address to,
735         uint256 tokenId
736     ) public virtual override {
737         safeTransferFrom(from, to, tokenId, "");
738     }
739 
740     /**
741      * @dev See {IERC721-safeTransferFrom}.
742      */
743     function safeTransferFrom(
744         address from,
745         address to,
746         uint256 tokenId,
747         bytes memory _data
748     ) public virtual override {
749         require(_isApprovedOrOwner(_msgSender(), tokenId), "ERC721: transfer caller is not owner nor approved");
750         _safeTransfer(from, to, tokenId, _data);
751     }
752 
753     /**
754      * @dev Safely transfers `tokenId` token from `from` to `to`, checking first that contract recipients
755      * are aware of the ERC721 protocol to prevent tokens from being forever locked.
756      *
757      * `_data` is additional data, it has no specified format and it is sent in call to `to`.
758      *
759      * This internal function is equivalent to {safeTransferFrom}, and can be used to e.g.
760      * implement alternative mechanisms to perform token transfer, such as signature-based.
761      *
762      * Requirements:
763      *
764      * - `from` cannot be the zero address.
765      * - `to` cannot be the zero address.
766      * - `tokenId` token must exist and be owned by `from`.
767      * - If `to` refers to a smart contract, it must implement {IERC721Receiver-onERC721Received}, which is called upon a safe transfer.
768      *
769      * Emits a {Transfer} event.
770      */
771     function _safeTransfer(
772         address from,
773         address to,
774         uint256 tokenId,
775         bytes memory _data
776     ) internal virtual {
777         _transfer(from, to, tokenId);
778         require(_checkOnERC721Received(from, to, tokenId, _data), "ERC721: transfer to non ERC721Receiver implementer");
779     }
780 
781     /**
782      * @dev Returns whether `tokenId` exists.
783      *
784      * Tokens can be managed by their owner or approved accounts via {approve} or {setApprovalForAll}.
785      *
786      * Tokens start existing when they are minted (`_mint`),
787      * and stop existing when they are burned (`_burn`).
788      */
789     function _exists(uint256 tokenId) internal view virtual returns (bool) {
790         return _owners[tokenId] != address(0);
791     }
792 
793     /**
794      * @dev Returns whether `spender` is allowed to manage `tokenId`.
795      *
796      * Requirements:
797      *
798      * - `tokenId` must exist.
799      */
800     function _isApprovedOrOwner(address spender, uint256 tokenId) internal view virtual returns (bool) {
801         require(_exists(tokenId), "ERC721: operator query for nonexistent token");
802         address owner = ERC721.ownerOf(tokenId);
803         return (spender == owner || getApproved(tokenId) == spender || isApprovedForAll(owner, spender));
804     }
805 
806     /**
807      * @dev Safely mints `tokenId` and transfers it to `to`.
808      *
809      * Requirements:
810      *
811      * - `tokenId` must not exist.
812      * - If `to` refers to a smart contract, it must implement {IERC721Receiver-onERC721Received}, which is called upon a safe transfer.
813      *
814      * Emits a {Transfer} event.
815      */
816     function _safeMint(address to, uint256 tokenId) internal virtual {
817         _safeMint(to, tokenId, "");
818     }
819 
820     /**
821      * @dev Same as {xref-ERC721-_safeMint-address-uint256-}[`_safeMint`], with an additional `data` parameter which is
822      * forwarded in {IERC721Receiver-onERC721Received} to contract recipients.
823      */
824     function _safeMint(
825         address to,
826         uint256 tokenId,
827         bytes memory _data
828     ) internal virtual {
829         _mint(to, tokenId);
830         require(
831             _checkOnERC721Received(address(0), to, tokenId, _data),
832             "ERC721: transfer to non ERC721Receiver implementer"
833         );
834     }
835 
836     /**
837      * @dev Mints `tokenId` and transfers it to `to`.
838      *
839      * WARNING: Usage of this method is discouraged, use {_safeMint} whenever possible
840      *
841      * Requirements:
842      *
843      * - `tokenId` must not exist.
844      * - `to` cannot be the zero address.
845      *
846      * Emits a {Transfer} event.
847      */
848     function _mint(address to, uint256 tokenId) internal virtual {
849         require(to != address(0), "ERC721: mint to the zero address");
850         require(!_exists(tokenId), "ERC721: token already minted");
851 
852         _beforeTokenTransfer(address(0), to, tokenId);
853 
854         _balances[to] += 1;
855         _owners[tokenId] = to;
856 
857         emit Transfer(address(0), to, tokenId);
858     }
859 
860     /**
861      * @dev Destroys `tokenId`.
862      * The approval is cleared when the token is burned.
863      *
864      * Requirements:
865      *
866      * - `tokenId` must exist.
867      *
868      * Emits a {Transfer} event.
869      */
870     function _burn(uint256 tokenId) internal virtual {
871         address owner = ERC721.ownerOf(tokenId);
872 
873         _beforeTokenTransfer(owner, address(0), tokenId);
874 
875         // Clear approvals
876         _approve(address(0), tokenId);
877 
878         _balances[owner] -= 1;
879         delete _owners[tokenId];
880 
881         emit Transfer(owner, address(0), tokenId);
882     }
883 
884     /**
885      * @dev Transfers `tokenId` from `from` to `to`.
886      *  As opposed to {transferFrom}, this imposes no restrictions on msg.sender.
887      *
888      * Requirements:
889      *
890      * - `to` cannot be the zero address.
891      * - `tokenId` token must be owned by `from`.
892      *
893      * Emits a {Transfer} event.
894      */
895     function _transfer(
896         address from,
897         address to,
898         uint256 tokenId
899     ) internal virtual {
900         require(ERC721.ownerOf(tokenId) == from, "ERC721: transfer of token that is not own");
901         require(to != address(0), "ERC721: transfer to the zero address");
902 
903         _beforeTokenTransfer(from, to, tokenId);
904 
905         // Clear approvals from the previous owner
906         _approve(address(0), tokenId);
907 
908         _balances[from] -= 1;
909         _balances[to] += 1;
910         _owners[tokenId] = to;
911 
912         emit Transfer(from, to, tokenId);
913     }
914 
915     /**
916      * @dev Approve `to` to operate on `tokenId`
917      *
918      * Emits a {Approval} event.
919      */
920     function _approve(address to, uint256 tokenId) internal virtual {
921         _tokenApprovals[tokenId] = to;
922         emit Approval(ERC721.ownerOf(tokenId), to, tokenId);
923     }
924 
925     /**
926      * @dev Approve `operator` to operate on all of `owner` tokens
927      *
928      * Emits a {ApprovalForAll} event.
929      */
930     function _setApprovalForAll(
931         address owner,
932         address operator,
933         bool approved
934     ) internal virtual {
935         require(owner != operator, "ERC721: approve to caller");
936         _operatorApprovals[owner][operator] = approved;
937         emit ApprovalForAll(owner, operator, approved);
938     }
939 
940     /**
941      * @dev Internal function to invoke {IERC721Receiver-onERC721Received} on a target address.
942      * The call is not executed if the target address is not a contract.
943      *
944      * @param from address representing the previous owner of the given token ID
945      * @param to target address that will receive the tokens
946      * @param tokenId uint256 ID of the token to be transferred
947      * @param _data bytes optional data to send along with the call
948      * @return bool whether the call correctly returned the expected magic value
949      */
950     function _checkOnERC721Received(
951         address from,
952         address to,
953         uint256 tokenId,
954         bytes memory _data
955     ) private returns (bool) {
956         if (to.isContract()) {
957             try IERC721Receiver(to).onERC721Received(_msgSender(), from, tokenId, _data) returns (bytes4 retval) {
958                 return retval == IERC721Receiver.onERC721Received.selector;
959             } catch (bytes memory reason) {
960                 if (reason.length == 0) {
961                     revert("ERC721: transfer to non ERC721Receiver implementer");
962                 } else {
963                     assembly {
964                         revert(add(32, reason), mload(reason))
965                     }
966                 }
967             }
968         } else {
969             return true;
970         }
971     }
972 
973     /**
974      * @dev Hook that is called before any token transfer. This includes minting
975      * and burning.
976      *
977      * Calling conditions:
978      *
979      * - When `from` and `to` are both non-zero, ``from``'s `tokenId` will be
980      * transferred to `to`.
981      * - When `from` is zero, `tokenId` will be minted for `to`.
982      * - When `to` is zero, ``from``'s `tokenId` will be burned.
983      * - `from` and `to` are never both zero.
984      *
985      * To learn more about hooks, head to xref:ROOT:extending-contracts.adoc#using-hooks[Using Hooks].
986      */
987     function _beforeTokenTransfer(
988         address from,
989         address to,
990         uint256 tokenId
991     ) internal virtual {}
992 }
993 
994 
995 // OpenZeppelin Contracts v4.4.0 (token/ERC721/extensions/IERC721Enumerable.sol)
996 
997 
998 
999 
1000 
1001 /**
1002  * @title ERC-721 Non-Fungible Token Standard, optional enumeration extension
1003  * @dev See https://eips.ethereum.org/EIPS/eip-721
1004  */
1005 interface IERC721Enumerable is IERC721 {
1006     /**
1007      * @dev Returns the total amount of tokens stored by the contract.
1008      */
1009     function totalSupply() external view returns (uint256);
1010 
1011     /**
1012      * @dev Returns a token ID owned by `owner` at a given `index` of its token list.
1013      * Use along with {balanceOf} to enumerate all of ``owner``'s tokens.
1014      */
1015     function tokenOfOwnerByIndex(address owner, uint256 index) external view returns (uint256 tokenId);
1016 
1017     /**
1018      * @dev Returns a token ID at a given `index` of all the tokens stored by the contract.
1019      * Use along with {totalSupply} to enumerate all tokens.
1020      */
1021     function tokenByIndex(uint256 index) external view returns (uint256);
1022 }
1023 
1024 
1025 /**
1026  * @dev This implements an optional extension of {ERC721} defined in the EIP that adds
1027  * enumerability of all the token ids in the contract as well as all token ids owned by each
1028  * account.
1029  */
1030 abstract contract ERC721Enumerable is ERC721, IERC721Enumerable {
1031     // Mapping from owner to list of owned token IDs
1032     mapping(address => mapping(uint256 => uint256)) private _ownedTokens;
1033 
1034     // Mapping from token ID to index of the owner tokens list
1035     mapping(uint256 => uint256) private _ownedTokensIndex;
1036 
1037     // Array with all token ids, used for enumeration
1038     uint256[] private _allTokens;
1039 
1040     // Mapping from token id to position in the allTokens array
1041     mapping(uint256 => uint256) private _allTokensIndex;
1042 
1043     /**
1044      * @dev See {IERC165-supportsInterface}.
1045      */
1046     function supportsInterface(bytes4 interfaceId) public view virtual override(IERC165, ERC721) returns (bool) {
1047         return interfaceId == type(IERC721Enumerable).interfaceId || super.supportsInterface(interfaceId);
1048     }
1049 
1050     /**
1051      * @dev See {IERC721Enumerable-tokenOfOwnerByIndex}.
1052      */
1053     function tokenOfOwnerByIndex(address owner, uint256 index) public view virtual override returns (uint256) {
1054         require(index < ERC721.balanceOf(owner), "ERC721Enumerable: owner index out of bounds");
1055         return _ownedTokens[owner][index];
1056     }
1057 
1058     /**
1059      * @dev See {IERC721Enumerable-totalSupply}.
1060      */
1061     function totalSupply() public view virtual override returns (uint256) {
1062         return _allTokens.length;
1063     }
1064 
1065     /**
1066      * @dev See {IERC721Enumerable-tokenByIndex}.
1067      */
1068     function tokenByIndex(uint256 index) public view virtual override returns (uint256) {
1069         require(index < ERC721Enumerable.totalSupply(), "ERC721Enumerable: global index out of bounds");
1070         return _allTokens[index];
1071     }
1072 
1073     /**
1074      * @dev Hook that is called before any token transfer. This includes minting
1075      * and burning.
1076      *
1077      * Calling conditions:
1078      *
1079      * - When `from` and `to` are both non-zero, ``from``'s `tokenId` will be
1080      * transferred to `to`.
1081      * - When `from` is zero, `tokenId` will be minted for `to`.
1082      * - When `to` is zero, ``from``'s `tokenId` will be burned.
1083      * - `from` cannot be the zero address.
1084      * - `to` cannot be the zero address.
1085      *
1086      * To learn more about hooks, head to xref:ROOT:extending-contracts.adoc#using-hooks[Using Hooks].
1087      */
1088     function _beforeTokenTransfer(
1089         address from,
1090         address to,
1091         uint256 tokenId
1092     ) internal virtual override {
1093         super._beforeTokenTransfer(from, to, tokenId);
1094 
1095         if (from == address(0)) {
1096             _addTokenToAllTokensEnumeration(tokenId);
1097         } else if (from != to) {
1098             _removeTokenFromOwnerEnumeration(from, tokenId);
1099         }
1100         if (to == address(0)) {
1101             _removeTokenFromAllTokensEnumeration(tokenId);
1102         } else if (to != from) {
1103             _addTokenToOwnerEnumeration(to, tokenId);
1104         }
1105     }
1106 
1107     /**
1108      * @dev Private function to add a token to this extension's ownership-tracking data structures.
1109      * @param to address representing the new owner of the given token ID
1110      * @param tokenId uint256 ID of the token to be added to the tokens list of the given address
1111      */
1112     function _addTokenToOwnerEnumeration(address to, uint256 tokenId) private {
1113         uint256 length = ERC721.balanceOf(to);
1114         _ownedTokens[to][length] = tokenId;
1115         _ownedTokensIndex[tokenId] = length;
1116     }
1117 
1118     /**
1119      * @dev Private function to add a token to this extension's token tracking data structures.
1120      * @param tokenId uint256 ID of the token to be added to the tokens list
1121      */
1122     function _addTokenToAllTokensEnumeration(uint256 tokenId) private {
1123         _allTokensIndex[tokenId] = _allTokens.length;
1124         _allTokens.push(tokenId);
1125     }
1126 
1127     /**
1128      * @dev Private function to remove a token from this extension's ownership-tracking data structures. Note that
1129      * while the token is not assigned a new owner, the `_ownedTokensIndex` mapping is _not_ updated: this allows for
1130      * gas optimizations e.g. when performing a transfer operation (avoiding double writes).
1131      * This has O(1) time complexity, but alters the order of the _ownedTokens array.
1132      * @param from address representing the previous owner of the given token ID
1133      * @param tokenId uint256 ID of the token to be removed from the tokens list of the given address
1134      */
1135     function _removeTokenFromOwnerEnumeration(address from, uint256 tokenId) private {
1136         // To prevent a gap in from's tokens array, we store the last token in the index of the token to delete, and
1137         // then delete the last slot (swap and pop).
1138 
1139         uint256 lastTokenIndex = ERC721.balanceOf(from) - 1;
1140         uint256 tokenIndex = _ownedTokensIndex[tokenId];
1141 
1142         // When the token to delete is the last token, the swap operation is unnecessary
1143         if (tokenIndex != lastTokenIndex) {
1144             uint256 lastTokenId = _ownedTokens[from][lastTokenIndex];
1145 
1146             _ownedTokens[from][tokenIndex] = lastTokenId; // Move the last token to the slot of the to-delete token
1147             _ownedTokensIndex[lastTokenId] = tokenIndex; // Update the moved token's index
1148         }
1149 
1150         // This also deletes the contents at the last position of the array
1151         delete _ownedTokensIndex[tokenId];
1152         delete _ownedTokens[from][lastTokenIndex];
1153     }
1154 
1155     /**
1156      * @dev Private function to remove a token from this extension's token tracking data structures.
1157      * This has O(1) time complexity, but alters the order of the _allTokens array.
1158      * @param tokenId uint256 ID of the token to be removed from the tokens list
1159      */
1160     function _removeTokenFromAllTokensEnumeration(uint256 tokenId) private {
1161         // To prevent a gap in the tokens array, we store the last token in the index of the token to delete, and
1162         // then delete the last slot (swap and pop).
1163 
1164         uint256 lastTokenIndex = _allTokens.length - 1;
1165         uint256 tokenIndex = _allTokensIndex[tokenId];
1166 
1167         // When the token to delete is the last token, the swap operation is unnecessary. However, since this occurs so
1168         // rarely (when the last minted token is burnt) that we still do the swap here to avoid the gas cost of adding
1169         // an 'if' statement (like in _removeTokenFromOwnerEnumeration)
1170         uint256 lastTokenId = _allTokens[lastTokenIndex];
1171 
1172         _allTokens[tokenIndex] = lastTokenId; // Move the last token to the slot of the to-delete token
1173         _allTokensIndex[lastTokenId] = tokenIndex; // Update the moved token's index
1174 
1175         // This also deletes the contents at the last position of the array
1176         delete _allTokensIndex[tokenId];
1177         _allTokens.pop();
1178     }
1179 }
1180 
1181 
1182 // OpenZeppelin Contracts v4.4.0 (access/Ownable.sol)
1183 
1184 
1185 
1186 
1187 
1188 /**
1189  * @dev Contract module which provides a basic access control mechanism, where
1190  * there is an account (an owner) that can be granted exclusive access to
1191  * specific functions.
1192  *
1193  * By default, the owner account will be the one that deploys the contract. This
1194  * can later be changed with {transferOwnership}.
1195  *
1196  * This module is used through inheritance. It will make available the modifier
1197  * `onlyOwner`, which can be applied to your functions to restrict their use to
1198  * the owner.
1199  */
1200 abstract contract Ownable is Context {
1201     address private _owner;
1202 
1203     event OwnershipTransferred(address indexed previousOwner, address indexed newOwner);
1204 
1205     /**
1206      * @dev Initializes the contract setting the deployer as the initial owner.
1207      */
1208     constructor() {
1209         _transferOwnership(_msgSender());
1210     }
1211 
1212     /**
1213      * @dev Returns the address of the current owner.
1214      */
1215     function owner() public view virtual returns (address) {
1216         return _owner;
1217     }
1218 
1219     /**
1220      * @dev Throws if called by any account other than the owner.
1221      */
1222     modifier onlyOwner() {
1223         require(owner() == _msgSender(), "Ownable: caller is not the owner");
1224         _;
1225     }
1226 
1227     /**
1228      * @dev Leaves the contract without owner. It will not be possible to call
1229      * `onlyOwner` functions anymore. Can only be called by the current owner.
1230      *
1231      * NOTE: Renouncing ownership will leave the contract without an owner,
1232      * thereby removing any functionality that is only available to the owner.
1233      */
1234     function renounceOwnership() public virtual onlyOwner {
1235         _transferOwnership(address(0));
1236     }
1237 
1238     /**
1239      * @dev Transfers ownership of the contract to a new account (`newOwner`).
1240      * Can only be called by the current owner.
1241      */
1242     function transferOwnership(address newOwner) public virtual onlyOwner {
1243         require(newOwner != address(0), "Ownable: new owner is the zero address");
1244         _transferOwnership(newOwner);
1245     }
1246 
1247     /**
1248      * @dev Transfers ownership of the contract to a new account (`newOwner`).
1249      * Internal function without access restriction.
1250      */
1251     function _transferOwnership(address newOwner) internal virtual {
1252         address oldOwner = _owner;
1253         _owner = newOwner;
1254         emit OwnershipTransferred(oldOwner, newOwner);
1255     }
1256 }
1257 
1258 
1259 // OpenZeppelin Contracts v4.4.0 (utils/Counters.sol)
1260 
1261 
1262 
1263 /**
1264  * @title Counters
1265  * @author Matt Condon (@shrugs)
1266  * @dev Provides counters that can only be incremented, decremented or reset. This can be used e.g. to track the number
1267  * of elements in a mapping, issuing ERC721 ids, or counting request ids.
1268  *
1269  * Include with `using Counters for Counters.Counter;`
1270  */
1271 library Counters {
1272     struct Counter {
1273         // This variable should never be directly accessed by users of the library: interactions must be restricted to
1274         // the library's function. As of Solidity v0.5.2, this cannot be enforced, though there is a proposal to add
1275         // this feature: see https://github.com/ethereum/solidity/issues/4637
1276         uint256 _value; // default: 0
1277     }
1278 
1279     function current(Counter storage counter) internal view returns (uint256) {
1280         return counter._value;
1281     }
1282 
1283     function increment(Counter storage counter) internal {
1284         unchecked {
1285             counter._value += 1;
1286         }
1287     }
1288 
1289     function decrement(Counter storage counter) internal {
1290         uint256 value = counter._value;
1291         require(value > 0, "Counter: decrement overflow");
1292         unchecked {
1293             counter._value = value - 1;
1294         }
1295     }
1296 
1297     function reset(Counter storage counter) internal {
1298         counter._value = 0;
1299     }
1300 }
1301 
1302 
1303 
1304 // OpenZeppelin Contracts v4.4.0 (utils/math/SafeMath.sol)
1305 
1306 
1307 
1308 // CAUTION
1309 // This version of SafeMath should only be used with Solidity 0.8 or later,
1310 // because it relies on the compiler's built in overflow checks.
1311 
1312 /**
1313  * @dev Wrappers over Solidity's arithmetic operations.
1314  *
1315  * NOTE: `SafeMath` is generally not needed starting with Solidity 0.8, since the compiler
1316  * now has built in overflow checking.
1317  */
1318 library SafeMath {
1319     /**
1320      * @dev Returns the addition of two unsigned integers, with an overflow flag.
1321      *
1322      * _Available since v3.4._
1323      */
1324     function tryAdd(uint256 a, uint256 b) internal pure returns (bool, uint256) {
1325         unchecked {
1326             uint256 c = a + b;
1327             if (c < a) return (false, 0);
1328             return (true, c);
1329         }
1330     }
1331 
1332     /**
1333      * @dev Returns the substraction of two unsigned integers, with an overflow flag.
1334      *
1335      * _Available since v3.4._
1336      */
1337     function trySub(uint256 a, uint256 b) internal pure returns (bool, uint256) {
1338         unchecked {
1339             if (b > a) return (false, 0);
1340             return (true, a - b);
1341         }
1342     }
1343 
1344     /**
1345      * @dev Returns the multiplication of two unsigned integers, with an overflow flag.
1346      *
1347      * _Available since v3.4._
1348      */
1349     function tryMul(uint256 a, uint256 b) internal pure returns (bool, uint256) {
1350         unchecked {
1351             // Gas optimization: this is cheaper than requiring 'a' not being zero, but the
1352             // benefit is lost if 'b' is also tested.
1353             // See: https://github.com/OpenZeppelin/openzeppelin-contracts/pull/522
1354             if (a == 0) return (true, 0);
1355             uint256 c = a * b;
1356             if (c / a != b) return (false, 0);
1357             return (true, c);
1358         }
1359     }
1360 
1361     /**
1362      * @dev Returns the division of two unsigned integers, with a division by zero flag.
1363      *
1364      * _Available since v3.4._
1365      */
1366     function tryDiv(uint256 a, uint256 b) internal pure returns (bool, uint256) {
1367         unchecked {
1368             if (b == 0) return (false, 0);
1369             return (true, a / b);
1370         }
1371     }
1372 
1373     /**
1374      * @dev Returns the remainder of dividing two unsigned integers, with a division by zero flag.
1375      *
1376      * _Available since v3.4._
1377      */
1378     function tryMod(uint256 a, uint256 b) internal pure returns (bool, uint256) {
1379         unchecked {
1380             if (b == 0) return (false, 0);
1381             return (true, a % b);
1382         }
1383     }
1384 
1385     /**
1386      * @dev Returns the addition of two unsigned integers, reverting on
1387      * overflow.
1388      *
1389      * Counterpart to Solidity's `+` operator.
1390      *
1391      * Requirements:
1392      *
1393      * - Addition cannot overflow.
1394      */
1395     function add(uint256 a, uint256 b) internal pure returns (uint256) {
1396         return a + b;
1397     }
1398 
1399     /**
1400      * @dev Returns the subtraction of two unsigned integers, reverting on
1401      * overflow (when the result is negative).
1402      *
1403      * Counterpart to Solidity's `-` operator.
1404      *
1405      * Requirements:
1406      *
1407      * - Subtraction cannot overflow.
1408      */
1409     function sub(uint256 a, uint256 b) internal pure returns (uint256) {
1410         return a - b;
1411     }
1412 
1413     /**
1414      * @dev Returns the multiplication of two unsigned integers, reverting on
1415      * overflow.
1416      *
1417      * Counterpart to Solidity's `*` operator.
1418      *
1419      * Requirements:
1420      *
1421      * - Multiplication cannot overflow.
1422      */
1423     function mul(uint256 a, uint256 b) internal pure returns (uint256) {
1424         return a * b;
1425     }
1426 
1427     /**
1428      * @dev Returns the integer division of two unsigned integers, reverting on
1429      * division by zero. The result is rounded towards zero.
1430      *
1431      * Counterpart to Solidity's `/` operator.
1432      *
1433      * Requirements:
1434      *
1435      * - The divisor cannot be zero.
1436      */
1437     function div(uint256 a, uint256 b) internal pure returns (uint256) {
1438         return a / b;
1439     }
1440 
1441     /**
1442      * @dev Returns the remainder of dividing two unsigned integers. (unsigned integer modulo),
1443      * reverting when dividing by zero.
1444      *
1445      * Counterpart to Solidity's `%` operator. This function uses a `revert`
1446      * opcode (which leaves remaining gas untouched) while Solidity uses an
1447      * invalid opcode to revert (consuming all remaining gas).
1448      *
1449      * Requirements:
1450      *
1451      * - The divisor cannot be zero.
1452      */
1453     function mod(uint256 a, uint256 b) internal pure returns (uint256) {
1454         return a % b;
1455     }
1456 
1457     /**
1458      * @dev Returns the subtraction of two unsigned integers, reverting with custom message on
1459      * overflow (when the result is negative).
1460      *
1461      * CAUTION: This function is deprecated because it requires allocating memory for the error
1462      * message unnecessarily. For custom revert reasons use {trySub}.
1463      *
1464      * Counterpart to Solidity's `-` operator.
1465      *
1466      * Requirements:
1467      *
1468      * - Subtraction cannot overflow.
1469      */
1470     function sub(
1471         uint256 a,
1472         uint256 b,
1473         string memory errorMessage
1474     ) internal pure returns (uint256) {
1475         unchecked {
1476             require(b <= a, errorMessage);
1477             return a - b;
1478         }
1479     }
1480 
1481     /**
1482      * @dev Returns the integer division of two unsigned integers, reverting with custom message on
1483      * division by zero. The result is rounded towards zero.
1484      *
1485      * Counterpart to Solidity's `/` operator. Note: this function uses a
1486      * `revert` opcode (which leaves remaining gas untouched) while Solidity
1487      * uses an invalid opcode to revert (consuming all remaining gas).
1488      *
1489      * Requirements:
1490      *
1491      * - The divisor cannot be zero.
1492      */
1493     function div(
1494         uint256 a,
1495         uint256 b,
1496         string memory errorMessage
1497     ) internal pure returns (uint256) {
1498         unchecked {
1499             require(b > 0, errorMessage);
1500             return a / b;
1501         }
1502     }
1503 
1504     /**
1505      * @dev Returns the remainder of dividing two unsigned integers. (unsigned integer modulo),
1506      * reverting with custom message when dividing by zero.
1507      *
1508      * CAUTION: This function is deprecated because it requires allocating memory for the error
1509      * message unnecessarily. For custom revert reasons use {tryMod}.
1510      *
1511      * Counterpart to Solidity's `%` operator. This function uses a `revert`
1512      * opcode (which leaves remaining gas untouched) while Solidity uses an
1513      * invalid opcode to revert (consuming all remaining gas).
1514      *
1515      * Requirements:
1516      *
1517      * - The divisor cannot be zero.
1518      */
1519     function mod(
1520         uint256 a,
1521         uint256 b,
1522         string memory errorMessage
1523     ) internal pure returns (uint256) {
1524         unchecked {
1525             require(b > 0, errorMessage);
1526             return a % b;
1527         }
1528     }
1529 }
1530 
1531 
1532 // OpenZeppelin Contracts v4.4.0 (security/ReentrancyGuard.sol)
1533 
1534 
1535 
1536 /**
1537  * @dev Contract module that helps prevent reentrant calls to a function.
1538  *
1539  * Inheriting from `ReentrancyGuard` will make the {nonReentrant} modifier
1540  * available, which can be applied to functions to make sure there are no nested
1541  * (reentrant) calls to them.
1542  *
1543  * Note that because there is a single `nonReentrant` guard, functions marked as
1544  * `nonReentrant` may not call one another. This can be worked around by making
1545  * those functions `private`, and then adding `external` `nonReentrant` entry
1546  * points to them.
1547  *
1548  * TIP: If you would like to learn more about reentrancy and alternative ways
1549  * to protect against it, check out our blog post
1550  * https://blog.openzeppelin.com/reentrancy-after-istanbul/[Reentrancy After Istanbul].
1551  */
1552 abstract contract ReentrancyGuard {
1553     // Booleans are more expensive than uint256 or any type that takes up a full
1554     // word because each write operation emits an extra SLOAD to first read the
1555     // slot's contents, replace the bits taken up by the boolean, and then write
1556     // back. This is the compiler's defense against contract upgrades and
1557     // pointer aliasing, and it cannot be disabled.
1558 
1559     // The values being non-zero value makes deployment a bit more expensive,
1560     // but in exchange the refund on every call to nonReentrant will be lower in
1561     // amount. Since refunds are capped to a percentage of the total
1562     // transaction's gas, it is best to keep them low in cases like this one, to
1563     // increase the likelihood of the full refund coming into effect.
1564     uint256 private constant _NOT_ENTERED = 1;
1565     uint256 private constant _ENTERED = 2;
1566 
1567     uint256 private _status;
1568 
1569     constructor() {
1570         _status = _NOT_ENTERED;
1571     }
1572 
1573     /**
1574      * @dev Prevents a contract from calling itself, directly or indirectly.
1575      * Calling a `nonReentrant` function from another `nonReentrant`
1576      * function is not supported. It is possible to prevent this from happening
1577      * by making the `nonReentrant` function external, and making it call a
1578      * `private` function that does the actual work.
1579      */
1580     modifier nonReentrant() {
1581         // On the first call to nonReentrant, _notEntered will be true
1582         require(_status != _ENTERED, "ReentrancyGuard: reentrant call");
1583 
1584         // Any calls to nonReentrant after this point will fail
1585         _status = _ENTERED;
1586 
1587         _;
1588 
1589         // By storing the original value once again, a refund is triggered (see
1590         // https://eips.ethereum.org/EIPS/eip-2200)
1591         _status = _NOT_ENTERED;
1592     }
1593 }
1594 
1595 
1596 contract DuskBreakers is ERC721Enumerable, Ownable, ReentrancyGuard {
1597     using Strings for string;
1598     using SafeMath for uint256;
1599     using Counters for Counters.Counter;
1600 
1601     /*
1602     * Enforce the existence of only 10 Breakers.
1603     */
1604     uint256 public constant BREAKER_SUPPLY = 10000;
1605     uint256 public constant breakerPrice = 0.06 ether;
1606     string public baseTokenURI;
1607     bool private PAUSE = true;
1608     bool private fcfsMint = false;
1609     
1610     // Ensure Fairness
1611     string public BREAKER_PROVENANCE = "";
1612     uint256 public startingIndexBlock;
1613     uint256 public startingIndex;
1614 
1615     // tokenID storage
1616     Counters.Counter private _tokenIdCounter;
1617 
1618     // Presale, Play2Mint
1619     PresaleConfig public presaleConfig;
1620     Play2MintConfig public play2MintConfig;
1621 
1622     // Presales and Play2Mints mappings
1623     mapping(address => uint256) private _presaleList;
1624     mapping(address => uint256) private _play2MintList;
1625     
1626     // Presale and Play2Mint Structs
1627     struct PresaleConfig {
1628         uint256 mintMax;
1629     }
1630     struct Play2MintConfig {
1631         uint256 mintMax;
1632     }
1633     
1634     // Breaker Contract Events
1635     event ChangePresaleConfig(
1636         uint256 _mintMax
1637     );
1638     
1639     event ChangePlay2MintConfig(
1640         uint256 _mintMax
1641     );
1642     
1643     // Events
1644     event PauseEvent(bool pause);
1645     //event welcomeToTheDusk(uint256 indexed id);
1646     
1647     // Safety Modifiers
1648     function isUnpausedAndSupplied() public view returns (bool){
1649         return (hasSupply(1)) && (!PAUSE);
1650     }
1651     
1652     modifier saleIsOpen {
1653         require(hasSupply(1), "Breakers Sold Out!");
1654         require(!PAUSE, "Sales not open");
1655         _;
1656     }
1657 
1658     function setPause(bool _pause) public onlyOwner{
1659         PAUSE = _pause;
1660         emit PauseEvent(PAUSE);
1661     }
1662     
1663     // Open Floodgates for FCFS
1664     event FCFSEvent(bool pause);
1665     function setFCFS(bool _fcfsMint) public onlyOwner{
1666         fcfsMint = _fcfsMint;
1667         emit FCFSEvent(fcfsMint);
1668     }
1669     
1670     // Token URI overrides
1671     function _baseURI() internal view virtual override returns (string memory) {
1672         return baseTokenURI;
1673     }
1674 
1675     function setBaseURI(string memory baseURI) public onlyOwner {
1676         baseTokenURI = baseURI;
1677     }
1678 
1679     // token counters
1680     function nextToken() public view returns (uint256) {
1681         return _tokenIdCounter.current();
1682     }
1683 
1684     constructor(string memory name, string memory symbol) ERC721(name, symbol){
1685         
1686         // First we allow presales to mint during Play2Mint
1687         // Then, we allow Play2Mint 1 day
1688         // Finally we open for anyone to mint
1689         
1690         //preseale starts on contract creation
1691         uint256 _mintMax = 2;
1692         
1693         presaleConfig = PresaleConfig(_mintMax);
1694         emit ChangePresaleConfig(_mintMax);
1695         // Play2Mint allow minting config
1696         uint256 _p2MmintMax = 3;
1697 
1698         play2MintConfig = Play2MintConfig(_p2MmintMax);
1699         emit ChangePlay2MintConfig(_p2MmintMax);
1700         
1701         setBaseURI("https://duskbreakers.gg/api/breakers/");
1702         
1703     }
1704     
1705     /*
1706     * Fairness Section....
1707     * Pre mint, we set the provenance hash to the hash of hashes of the sha256
1708     * in order of original image generation
1709     * We then have an offest based on the last block sold, modulo the total supply
1710     * Thus you know we genereated them in the order we said and anyone including us had no way
1711     * to know what the starting index will be
1712     */
1713     function setProvenanceHash(string memory provenanceHash) public onlyOwner {
1714         BREAKER_PROVENANCE = provenanceHash;
1715     }
1716 
1717     // It has gone wrong and the presale didn't fully mint so this allows us to reveal
1718     function emergencySetStartingIndexBlock() public onlyOwner {
1719         require(startingIndex == 0, "Starting index is already set");
1720         startingIndexBlock = block.number;
1721     }
1722 
1723     function setStartingIndex() public {
1724         require(startingIndex == 0, "Starting index is already set");
1725         require(startingIndexBlock != 0, "Starting index block must be set");
1726 
1727         startingIndex = uint(blockhash(startingIndexBlock)) % BREAKER_SUPPLY;
1728         // Just a sanity case in the worst case if this function is called late (EVM only stores last 256 block hashes)
1729         if (block.number.sub(startingIndexBlock) > 255) {
1730             startingIndex = uint(blockhash(block.number - 1)) % BREAKER_SUPPLY;
1731         }
1732         // Prevent default sequence
1733         if (startingIndex == 0) {
1734             startingIndex = startingIndex.add(1);
1735         }
1736     }
1737     // 
1738     function addTreasury(address _address)
1739     external
1740     onlyOwner     
1741     {
1742         require(
1743             _address != address(0),
1744             "Breaker Treasury: Can't add a zero address"
1745         );
1746         if (_presaleList[_address] == 0) {
1747             _presaleList[_address] = 420; // It seems appropriate
1748         }
1749     }
1750     
1751     // Presale and Play2Mint whitelists
1752     function addToPresaleList(address[] calldata _addresses)
1753     external
1754     onlyOwner
1755     {
1756             for (uint256 ind = 0; ind < _addresses.length; ind++) {
1757             require(
1758                 _addresses[ind] != address(0),
1759                 "Breaker Presale: Can't add a zero address"
1760             );
1761             if (_presaleList[_addresses[ind]] == 0) {
1762                 _presaleList[_addresses[ind]] = presaleConfig.mintMax;
1763             }
1764         }
1765     }
1766     
1767     function addToPlay2Mint(address[] calldata _addresses)
1768     external
1769     onlyOwner
1770     {
1771           for (uint256 ind = 0; ind < _addresses.length; ind++) {
1772             require(
1773                 _addresses[ind] != address(0),
1774                 "DuskBreaker P2M: Can't add a zero address"
1775             );
1776             if (_play2MintList[_addresses[ind]] == 0) {
1777                 _play2MintList[_addresses[ind]] = play2MintConfig.mintMax;
1778             }
1779         }
1780     }
1781 
1782     function mintBreaker(uint256 numberOfTokens) public payable saleIsOpen nonReentrant() {
1783  
1784         require(hasSupply(numberOfTokens), "Purchase exceeds max total Breakers");
1785         require(canMint(numberOfTokens), "Mint Access Not Granted");
1786         require(breakerPrice.mul(numberOfTokens) <= msg.value, "ETH sent in transaction too low");
1787         
1788         for(uint i = 0; i < numberOfTokens; i++) {
1789             uint mintIndex = nextToken();
1790             if (mintIndex < BREAKER_SUPPLY) {
1791                 _safeMint(msg.sender, mintIndex);
1792                 //emit welcomeToTheDusk(mintIndex);
1793                 _tokenIdCounter.increment();
1794                 // remove presales sales first then play2mint sales next
1795                 if (_presaleList[msg.sender] > 0) {
1796                     _presaleList[msg.sender] = _presaleList[msg.sender].sub(1);
1797                 } else if (_play2MintList[msg.sender] > 0) {
1798                     _play2MintList[msg.sender] = _play2MintList[msg.sender].sub(1);
1799                 }
1800             }
1801         }
1802         
1803         // Did we mint the last block? If so, ready the starting index based on this block number
1804         if (startingIndexBlock == 0 && (nextToken() == BREAKER_SUPPLY)) {
1805             startingIndexBlock = block.number;
1806         }
1807     }
1808     
1809     // Safeguards
1810 
1811     function hasSupply(uint256 numberOfTokens) public view returns (bool) {
1812         uint256 creatureSupply = nextToken();
1813         return creatureSupply.add(numberOfTokens) <= BREAKER_SUPPLY;
1814     }
1815     
1816     function canMint(uint256 numberOfTokens) public view returns (bool) {    
1817         // skip guard so web3 has easy time
1818         if(! isUnpausedAndSupplied()) {
1819             return false;
1820         }
1821         // Presales can mint their max
1822         if(_presaleList[msg.sender] > 0 &&
1823             numberOfTokens <= _presaleList[msg.sender] 
1824         ) {
1825             return true;
1826         }
1827         // same for play2mint people, but if you are both whitelist and p2m, you can mint the sum
1828         if(_play2MintList[msg.sender] > 0 &&
1829             numberOfTokens <= _play2MintList[msg.sender]
1830         ) {
1831             return true;
1832         }
1833         // after Play2Mint, anyone can mint
1834         if(fcfsMint) {
1835             return true;
1836         }
1837         
1838         return false;
1839     }
1840     
1841     // Web3 Economics
1842     function withdrawAll() public onlyOwner {
1843         uint256 balance = address(this).balance;
1844         require(balance > 0);
1845         _widthdraw(msg.sender, address(this).balance);
1846     }
1847 
1848     function _widthdraw(address _address, uint256 _amount) private {
1849         (bool success, ) = _address.call{value: _amount}("");
1850         require(success, "Transfer failed.");
1851     }
1852 }