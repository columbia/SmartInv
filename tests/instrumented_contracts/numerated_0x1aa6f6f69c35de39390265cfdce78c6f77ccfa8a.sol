1 // SPDX-License-Identifier: MIT
2 // OpenZeppelin Contracts v4.4.1 (utils/introspection/IERC165.sol)
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
27 // OpenZeppelin Contracts v4.4.1 (utils/Context.sol)
28 
29 
30 
31 /**
32  * @dev Provides information about the current execution context, including the
33  * sender of the transaction and its data. While these are generally available
34  * via msg.sender and msg.data, they should not be accessed in such a direct
35  * manner, since when dealing with meta-transactions the account sending and
36  * paying for execution may not be the actual sender (as far as an application
37  * is concerned).
38  *
39  * This contract is only required for intermediate, library-like contracts.
40  */
41 abstract contract Context {
42     function _msgSender() internal view virtual returns (address) {
43         return msg.sender;
44     }
45 
46     function _msgData() internal view virtual returns (bytes calldata) {
47         return msg.data;
48     }
49 }
50 
51 // OpenZeppelin Contracts v4.4.1 (utils/Strings.sol)
52 
53 
54 
55 /**
56  * @dev String operations.
57  */
58 library Strings {
59     bytes16 private constant _HEX_SYMBOLS = "0123456789abcdef";
60 
61     /**
62      * @dev Converts a `uint256` to its ASCII `string` decimal representation.
63      */
64     function toString(uint256 value) internal pure returns (string memory) {
65         // Inspired by OraclizeAPI's implementation - MIT licence
66         // https://github.com/oraclize/ethereum-api/blob/b42146b063c7d6ee1358846c198246239e9360e8/oraclizeAPI_0.4.25.sol
67 
68         if (value == 0) {
69             return "0";
70         }
71         uint256 temp = value;
72         uint256 digits;
73         while (temp != 0) {
74             digits++;
75             temp /= 10;
76         }
77         bytes memory buffer = new bytes(digits);
78         while (value != 0) {
79             digits -= 1;
80             buffer[digits] = bytes1(uint8(48 + uint256(value % 10)));
81             value /= 10;
82         }
83         return string(buffer);
84     }
85 
86     /**
87      * @dev Converts a `uint256` to its ASCII `string` hexadecimal representation.
88      */
89     function toHexString(uint256 value) internal pure returns (string memory) {
90         if (value == 0) {
91             return "0x00";
92         }
93         uint256 temp = value;
94         uint256 length = 0;
95         while (temp != 0) {
96             length++;
97             temp >>= 8;
98         }
99         return toHexString(value, length);
100     }
101 
102     /**
103      * @dev Converts a `uint256` to its ASCII `string` hexadecimal representation with fixed length.
104      */
105     function toHexString(uint256 value, uint256 length) internal pure returns (string memory) {
106         bytes memory buffer = new bytes(2 * length + 2);
107         buffer[0] = "0";
108         buffer[1] = "x";
109         for (uint256 i = 2 * length + 1; i > 1; --i) {
110             buffer[i] = _HEX_SYMBOLS[value & 0xf];
111             value >>= 4;
112         }
113         require(value == 0, "Strings: hex length insufficient");
114         return string(buffer);
115     }
116 }
117 
118 
119 
120 
121 // OpenZeppelin Contracts (last updated v4.5.0) (token/ERC721/ERC721.sol)
122 
123 
124 
125 
126 // OpenZeppelin Contracts v4.4.1 (token/ERC721/IERC721.sol)
127 
128 
129 
130 
131 
132 /**
133  * @dev Required interface of an ERC721 compliant contract.
134  */
135 interface IERC721 is IERC165 {
136     /**
137      * @dev Emitted when `tokenId` token is transferred from `from` to `to`.
138      */
139     event Transfer(address indexed from, address indexed to, uint256 indexed tokenId);
140 
141     /**
142      * @dev Emitted when `owner` enables `approved` to manage the `tokenId` token.
143      */
144     event Approval(address indexed owner, address indexed approved, uint256 indexed tokenId);
145 
146     /**
147      * @dev Emitted when `owner` enables or disables (`approved`) `operator` to manage all of its assets.
148      */
149     event ApprovalForAll(address indexed owner, address indexed operator, bool approved);
150 
151     /**
152      * @dev Returns the number of tokens in ``owner``'s account.
153      */
154     function balanceOf(address owner) external view returns (uint256 balance);
155 
156     /**
157      * @dev Returns the owner of the `tokenId` token.
158      *
159      * Requirements:
160      *
161      * - `tokenId` must exist.
162      */
163     function ownerOf(uint256 tokenId) external view returns (address owner);
164 
165     /**
166      * @dev Safely transfers `tokenId` token from `from` to `to`, checking first that contract recipients
167      * are aware of the ERC721 protocol to prevent tokens from being forever locked.
168      *
169      * Requirements:
170      *
171      * - `from` cannot be the zero address.
172      * - `to` cannot be the zero address.
173      * - `tokenId` token must exist and be owned by `from`.
174      * - If the caller is not `from`, it must be have been allowed to move this token by either {approve} or {setApprovalForAll}.
175      * - If `to` refers to a smart contract, it must implement {IERC721Receiver-onERC721Received}, which is called upon a safe transfer.
176      *
177      * Emits a {Transfer} event.
178      */
179     function safeTransferFrom(
180         address from,
181         address to,
182         uint256 tokenId
183     ) external;
184 
185     /**
186      * @dev Transfers `tokenId` token from `from` to `to`.
187      *
188      * WARNING: Usage of this method is discouraged, use {safeTransferFrom} whenever possible.
189      *
190      * Requirements:
191      *
192      * - `from` cannot be the zero address.
193      * - `to` cannot be the zero address.
194      * - `tokenId` token must be owned by `from`.
195      * - If the caller is not `from`, it must be approved to move this token by either {approve} or {setApprovalForAll}.
196      *
197      * Emits a {Transfer} event.
198      */
199     function transferFrom(
200         address from,
201         address to,
202         uint256 tokenId
203     ) external;
204 
205     /**
206      * @dev Gives permission to `to` to transfer `tokenId` token to another account.
207      * The approval is cleared when the token is transferred.
208      *
209      * Only a single account can be approved at a time, so approving the zero address clears previous approvals.
210      *
211      * Requirements:
212      *
213      * - The caller must own the token or be an approved operator.
214      * - `tokenId` must exist.
215      *
216      * Emits an {Approval} event.
217      */
218     function approve(address to, uint256 tokenId) external;
219 
220     /**
221      * @dev Returns the account approved for `tokenId` token.
222      *
223      * Requirements:
224      *
225      * - `tokenId` must exist.
226      */
227     function getApproved(uint256 tokenId) external view returns (address operator);
228 
229     /**
230      * @dev Approve or remove `operator` as an operator for the caller.
231      * Operators can call {transferFrom} or {safeTransferFrom} for any token owned by the caller.
232      *
233      * Requirements:
234      *
235      * - The `operator` cannot be the caller.
236      *
237      * Emits an {ApprovalForAll} event.
238      */
239     function setApprovalForAll(address operator, bool _approved) external;
240 
241     /**
242      * @dev Returns if the `operator` is allowed to manage all of the assets of `owner`.
243      *
244      * See {setApprovalForAll}
245      */
246     function isApprovedForAll(address owner, address operator) external view returns (bool);
247 
248     /**
249      * @dev Safely transfers `tokenId` token from `from` to `to`.
250      *
251      * Requirements:
252      *
253      * - `from` cannot be the zero address.
254      * - `to` cannot be the zero address.
255      * - `tokenId` token must exist and be owned by `from`.
256      * - If the caller is not `from`, it must be approved to move this token by either {approve} or {setApprovalForAll}.
257      * - If `to` refers to a smart contract, it must implement {IERC721Receiver-onERC721Received}, which is called upon a safe transfer.
258      *
259      * Emits a {Transfer} event.
260      */
261     function safeTransferFrom(
262         address from,
263         address to,
264         uint256 tokenId,
265         bytes calldata data
266     ) external;
267 }
268 
269 
270 // OpenZeppelin Contracts v4.4.1 (token/ERC721/IERC721Receiver.sol)
271 
272 
273 
274 /**
275  * @title ERC721 token receiver interface
276  * @dev Interface for any contract that wants to support safeTransfers
277  * from ERC721 asset contracts.
278  */
279 interface IERC721Receiver {
280     /**
281      * @dev Whenever an {IERC721} `tokenId` token is transferred to this contract via {IERC721-safeTransferFrom}
282      * by `operator` from `from`, this function is called.
283      *
284      * It must return its Solidity selector to confirm the token transfer.
285      * If any other value is returned or the interface is not implemented by the recipient, the transfer will be reverted.
286      *
287      * The selector can be obtained in Solidity with `IERC721.onERC721Received.selector`.
288      */
289     function onERC721Received(
290         address operator,
291         address from,
292         uint256 tokenId,
293         bytes calldata data
294     ) external returns (bytes4);
295 }
296 
297 
298 // OpenZeppelin Contracts v4.4.1 (token/ERC721/extensions/IERC721Metadata.sol)
299 
300 
301 
302 
303 
304 /**
305  * @title ERC-721 Non-Fungible Token Standard, optional metadata extension
306  * @dev See https://eips.ethereum.org/EIPS/eip-721
307  */
308 interface IERC721Metadata is IERC721 {
309     /**
310      * @dev Returns the token collection name.
311      */
312     function name() external view returns (string memory);
313 
314     /**
315      * @dev Returns the token collection symbol.
316      */
317     function symbol() external view returns (string memory);
318 
319     /**
320      * @dev Returns the Uniform Resource Identifier (URI) for `tokenId` token.
321      */
322     function tokenURI(uint256 tokenId) external view returns (string memory);
323 }
324 
325 
326 // OpenZeppelin Contracts (last updated v4.5.0) (utils/Address.sol)
327 
328 
329 
330 /**
331  * @dev Collection of functions related to the address type
332  */
333 library Address {
334     /**
335      * @dev Returns true if `account` is a contract.
336      *
337      * [IMPORTANT]
338      * ====
339      * It is unsafe to assume that an address for which this function returns
340      * false is an externally-owned account (EOA) and not a contract.
341      *
342      * Among others, `isContract` will return false for the following
343      * types of addresses:
344      *
345      *  - an externally-owned account
346      *  - a contract in construction
347      *  - an address where a contract will be created
348      *  - an address where a contract lived, but was destroyed
349      * ====
350      *
351      * [IMPORTANT]
352      * ====
353      * You shouldn't rely on `isContract` to protect against flash loan attacks!
354      *
355      * Preventing calls from contracts is highly discouraged. It breaks composability, breaks support for smart wallets
356      * like Gnosis Safe, and does not provide security since it can be circumvented by calling from a contract
357      * constructor.
358      * ====
359      */
360     function isContract(address account) internal view returns (bool) {
361         // This method relies on extcodesize/address.code.length, which returns 0
362         // for contracts in construction, since the code is only stored at the end
363         // of the constructor execution.
364 
365         return account.code.length > 0;
366     }
367 
368     /**
369      * @dev Replacement for Solidity's `transfer`: sends `amount` wei to
370      * `recipient`, forwarding all available gas and reverting on errors.
371      *
372      * https://eips.ethereum.org/EIPS/eip-1884[EIP1884] increases the gas cost
373      * of certain opcodes, possibly making contracts go over the 2300 gas limit
374      * imposed by `transfer`, making them unable to receive funds via
375      * `transfer`. {sendValue} removes this limitation.
376      *
377      * https://diligence.consensys.net/posts/2019/09/stop-using-soliditys-transfer-now/[Learn more].
378      *
379      * IMPORTANT: because control is transferred to `recipient`, care must be
380      * taken to not create reentrancy vulnerabilities. Consider using
381      * {ReentrancyGuard} or the
382      * https://solidity.readthedocs.io/en/v0.5.11/security-considerations.html#use-the-checks-effects-interactions-pattern[checks-effects-interactions pattern].
383      */
384     function sendValue(address payable recipient, uint256 amount) internal {
385         require(address(this).balance >= amount, "Address: insufficient balance");
386 
387         (bool success, ) = recipient.call{value: amount}("");
388         require(success, "Address: unable to send value, recipient may have reverted");
389     }
390 
391     /**
392      * @dev Performs a Solidity function call using a low level `call`. A
393      * plain `call` is an unsafe replacement for a function call: use this
394      * function instead.
395      *
396      * If `target` reverts with a revert reason, it is bubbled up by this
397      * function (like regular Solidity function calls).
398      *
399      * Returns the raw returned data. To convert to the expected return value,
400      * use https://solidity.readthedocs.io/en/latest/units-and-global-variables.html?highlight=abi.decode#abi-encoding-and-decoding-functions[`abi.decode`].
401      *
402      * Requirements:
403      *
404      * - `target` must be a contract.
405      * - calling `target` with `data` must not revert.
406      *
407      * _Available since v3.1._
408      */
409     function functionCall(address target, bytes memory data) internal returns (bytes memory) {
410         return functionCall(target, data, "Address: low-level call failed");
411     }
412 
413     /**
414      * @dev Same as {xref-Address-functionCall-address-bytes-}[`functionCall`], but with
415      * `errorMessage` as a fallback revert reason when `target` reverts.
416      *
417      * _Available since v3.1._
418      */
419     function functionCall(
420         address target,
421         bytes memory data,
422         string memory errorMessage
423     ) internal returns (bytes memory) {
424         return functionCallWithValue(target, data, 0, errorMessage);
425     }
426 
427     /**
428      * @dev Same as {xref-Address-functionCall-address-bytes-}[`functionCall`],
429      * but also transferring `value` wei to `target`.
430      *
431      * Requirements:
432      *
433      * - the calling contract must have an ETH balance of at least `value`.
434      * - the called Solidity function must be `payable`.
435      *
436      * _Available since v3.1._
437      */
438     function functionCallWithValue(
439         address target,
440         bytes memory data,
441         uint256 value
442     ) internal returns (bytes memory) {
443         return functionCallWithValue(target, data, value, "Address: low-level call with value failed");
444     }
445 
446     /**
447      * @dev Same as {xref-Address-functionCallWithValue-address-bytes-uint256-}[`functionCallWithValue`], but
448      * with `errorMessage` as a fallback revert reason when `target` reverts.
449      *
450      * _Available since v3.1._
451      */
452     function functionCallWithValue(
453         address target,
454         bytes memory data,
455         uint256 value,
456         string memory errorMessage
457     ) internal returns (bytes memory) {
458         require(address(this).balance >= value, "Address: insufficient balance for call");
459         require(isContract(target), "Address: call to non-contract");
460 
461         (bool success, bytes memory returndata) = target.call{value: value}(data);
462         return verifyCallResult(success, returndata, errorMessage);
463     }
464 
465     /**
466      * @dev Same as {xref-Address-functionCall-address-bytes-}[`functionCall`],
467      * but performing a static call.
468      *
469      * _Available since v3.3._
470      */
471     function functionStaticCall(address target, bytes memory data) internal view returns (bytes memory) {
472         return functionStaticCall(target, data, "Address: low-level static call failed");
473     }
474 
475     /**
476      * @dev Same as {xref-Address-functionCall-address-bytes-string-}[`functionCall`],
477      * but performing a static call.
478      *
479      * _Available since v3.3._
480      */
481     function functionStaticCall(
482         address target,
483         bytes memory data,
484         string memory errorMessage
485     ) internal view returns (bytes memory) {
486         require(isContract(target), "Address: static call to non-contract");
487 
488         (bool success, bytes memory returndata) = target.staticcall(data);
489         return verifyCallResult(success, returndata, errorMessage);
490     }
491 
492     /**
493      * @dev Same as {xref-Address-functionCall-address-bytes-}[`functionCall`],
494      * but performing a delegate call.
495      *
496      * _Available since v3.4._
497      */
498     function functionDelegateCall(address target, bytes memory data) internal returns (bytes memory) {
499         return functionDelegateCall(target, data, "Address: low-level delegate call failed");
500     }
501 
502     /**
503      * @dev Same as {xref-Address-functionCall-address-bytes-string-}[`functionCall`],
504      * but performing a delegate call.
505      *
506      * _Available since v3.4._
507      */
508     function functionDelegateCall(
509         address target,
510         bytes memory data,
511         string memory errorMessage
512     ) internal returns (bytes memory) {
513         require(isContract(target), "Address: delegate call to non-contract");
514 
515         (bool success, bytes memory returndata) = target.delegatecall(data);
516         return verifyCallResult(success, returndata, errorMessage);
517     }
518 
519     /**
520      * @dev Tool to verifies that a low level call was successful, and revert if it wasn't, either by bubbling the
521      * revert reason using the provided one.
522      *
523      * _Available since v4.3._
524      */
525     function verifyCallResult(
526         bool success,
527         bytes memory returndata,
528         string memory errorMessage
529     ) internal pure returns (bytes memory) {
530         if (success) {
531             return returndata;
532         } else {
533             // Look for revert reason and bubble it up if present
534             if (returndata.length > 0) {
535                 // The easiest way to bubble the revert reason is using memory via assembly
536 
537                 assembly {
538                     let returndata_size := mload(returndata)
539                     revert(add(32, returndata), returndata_size)
540                 }
541             } else {
542                 revert(errorMessage);
543             }
544         }
545     }
546 }
547 
548 
549 
550 
551 // OpenZeppelin Contracts v4.4.1 (utils/introspection/ERC165.sol)
552 
553 
554 
555 
556 
557 /**
558  * @dev Implementation of the {IERC165} interface.
559  *
560  * Contracts that want to implement ERC165 should inherit from this contract and override {supportsInterface} to check
561  * for the additional interface id that will be supported. For example:
562  *
563  * ```solidity
564  * function supportsInterface(bytes4 interfaceId) public view virtual override returns (bool) {
565  *     return interfaceId == type(MyInterface).interfaceId || super.supportsInterface(interfaceId);
566  * }
567  * ```
568  *
569  * Alternatively, {ERC165Storage} provides an easier to use but more expensive implementation.
570  */
571 abstract contract ERC165 is IERC165 {
572     /**
573      * @dev See {IERC165-supportsInterface}.
574      */
575     function supportsInterface(bytes4 interfaceId) public view virtual override returns (bool) {
576         return interfaceId == type(IERC165).interfaceId;
577     }
578 }
579 
580 
581 /**
582  * @dev Implementation of https://eips.ethereum.org/EIPS/eip-721[ERC721] Non-Fungible Token Standard, including
583  * the Metadata extension, but not including the Enumerable extension, which is available separately as
584  * {ERC721Enumerable}.
585  */
586 contract ERC721 is Context, ERC165, IERC721, IERC721Metadata {
587     using Address for address;
588     using Strings for uint256;
589 
590     // Token name
591     string private _name;
592 
593     // Token symbol
594     string private _symbol;
595 
596     // Mapping from token ID to owner address
597     mapping(uint256 => address) private _owners;
598 
599     // Mapping owner address to token count
600     mapping(address => uint256) private _balances;
601 
602     // Mapping from token ID to approved address
603     mapping(uint256 => address) private _tokenApprovals;
604 
605     // Mapping from owner to operator approvals
606     mapping(address => mapping(address => bool)) private _operatorApprovals;
607 
608     /**
609      * @dev Initializes the contract by setting a `name` and a `symbol` to the token collection.
610      */
611     constructor(string memory name_, string memory symbol_) {
612         _name = name_;
613         _symbol = symbol_;
614     }
615 
616     /**
617      * @dev See {IERC165-supportsInterface}.
618      */
619     function supportsInterface(bytes4 interfaceId) public view virtual override(ERC165, IERC165) returns (bool) {
620         return
621             interfaceId == type(IERC721).interfaceId ||
622             interfaceId == type(IERC721Metadata).interfaceId ||
623             super.supportsInterface(interfaceId);
624     }
625 
626     /**
627      * @dev See {IERC721-balanceOf}.
628      */
629     function balanceOf(address owner) public view virtual override returns (uint256) {
630         require(owner != address(0), "ERC721: balance query for the zero address");
631         return _balances[owner];
632     }
633 
634     /**
635      * @dev See {IERC721-ownerOf}.
636      */
637     function ownerOf(uint256 tokenId) public view virtual override returns (address) {
638         address owner = _owners[tokenId];
639         require(owner != address(0), "ERC721: owner query for nonexistent token");
640         return owner;
641     }
642 
643     /**
644      * @dev See {IERC721Metadata-name}.
645      */
646     function name() public view virtual override returns (string memory) {
647         return _name;
648     }
649 
650     /**
651      * @dev See {IERC721Metadata-symbol}.
652      */
653     function symbol() public view virtual override returns (string memory) {
654         return _symbol;
655     }
656 
657     /**
658      * @dev See {IERC721Metadata-tokenURI}.
659      */
660     function tokenURI(uint256 tokenId) public view virtual override returns (string memory) {
661         require(_exists(tokenId), "ERC721Metadata: URI query for nonexistent token");
662 
663         string memory baseURI = _baseURI();
664         return bytes(baseURI).length > 0 ? string(abi.encodePacked(baseURI, tokenId.toString())) : "";
665     }
666 
667     /**
668      * @dev Base URI for computing {tokenURI}. If set, the resulting URI for each
669      * token will be the concatenation of the `baseURI` and the `tokenId`. Empty
670      * by default, can be overriden in child contracts.
671      */
672     function _baseURI() internal view virtual returns (string memory) {
673         return "";
674     }
675 
676     /**
677      * @dev See {IERC721-approve}.
678      */
679     function approve(address to, uint256 tokenId) public virtual override {
680         address owner = ERC721.ownerOf(tokenId);
681         require(to != owner, "ERC721: approval to current owner");
682 
683         require(
684             _msgSender() == owner || isApprovedForAll(owner, _msgSender()),
685             "ERC721: approve caller is not owner nor approved for all"
686         );
687 
688         _approve(to, tokenId);
689     }
690 
691     /**
692      * @dev See {IERC721-getApproved}.
693      */
694     function getApproved(uint256 tokenId) public view virtual override returns (address) {
695         require(_exists(tokenId), "ERC721: approved query for nonexistent token");
696 
697         return _tokenApprovals[tokenId];
698     }
699 
700     /**
701      * @dev See {IERC721-setApprovalForAll}.
702      */
703     function setApprovalForAll(address operator, bool approved) public virtual override {
704         _setApprovalForAll(_msgSender(), operator, approved);
705     }
706 
707     /**
708      * @dev See {IERC721-isApprovedForAll}.
709      */
710     function isApprovedForAll(address owner, address operator) public view virtual override returns (bool) {
711         return _operatorApprovals[owner][operator];
712     }
713 
714     /**
715      * @dev See {IERC721-transferFrom}.
716      */
717     function transferFrom(
718         address from,
719         address to,
720         uint256 tokenId
721     ) public virtual override {
722         //solhint-disable-next-line max-line-length
723         require(_isApprovedOrOwner(_msgSender(), tokenId), "ERC721: transfer caller is not owner nor approved");
724 
725         _transfer(from, to, tokenId);
726     }
727 
728     /**
729      * @dev See {IERC721-safeTransferFrom}.
730      */
731     function safeTransferFrom(
732         address from,
733         address to,
734         uint256 tokenId
735     ) public virtual override {
736         safeTransferFrom(from, to, tokenId, "");
737     }
738 
739     /**
740      * @dev See {IERC721-safeTransferFrom}.
741      */
742     function safeTransferFrom(
743         address from,
744         address to,
745         uint256 tokenId,
746         bytes memory _data
747     ) public virtual override {
748         require(_isApprovedOrOwner(_msgSender(), tokenId), "ERC721: transfer caller is not owner nor approved");
749         _safeTransfer(from, to, tokenId, _data);
750     }
751 
752     /**
753      * @dev Safely transfers `tokenId` token from `from` to `to`, checking first that contract recipients
754      * are aware of the ERC721 protocol to prevent tokens from being forever locked.
755      *
756      * `_data` is additional data, it has no specified format and it is sent in call to `to`.
757      *
758      * This internal function is equivalent to {safeTransferFrom}, and can be used to e.g.
759      * implement alternative mechanisms to perform token transfer, such as signature-based.
760      *
761      * Requirements:
762      *
763      * - `from` cannot be the zero address.
764      * - `to` cannot be the zero address.
765      * - `tokenId` token must exist and be owned by `from`.
766      * - If `to` refers to a smart contract, it must implement {IERC721Receiver-onERC721Received}, which is called upon a safe transfer.
767      *
768      * Emits a {Transfer} event.
769      */
770     function _safeTransfer(
771         address from,
772         address to,
773         uint256 tokenId,
774         bytes memory _data
775     ) internal virtual {
776         _transfer(from, to, tokenId);
777         require(_checkOnERC721Received(from, to, tokenId, _data), "ERC721: transfer to non ERC721Receiver implementer");
778     }
779 
780     /**
781      * @dev Returns whether `tokenId` exists.
782      *
783      * Tokens can be managed by their owner or approved accounts via {approve} or {setApprovalForAll}.
784      *
785      * Tokens start existing when they are minted (`_mint`),
786      * and stop existing when they are burned (`_burn`).
787      */
788     function _exists(uint256 tokenId) internal view virtual returns (bool) {
789         return _owners[tokenId] != address(0);
790     }
791 
792     /**
793      * @dev Returns whether `spender` is allowed to manage `tokenId`.
794      *
795      * Requirements:
796      *
797      * - `tokenId` must exist.
798      */
799     function _isApprovedOrOwner(address spender, uint256 tokenId) internal view virtual returns (bool) {
800         require(_exists(tokenId), "ERC721: operator query for nonexistent token");
801         address owner = ERC721.ownerOf(tokenId);
802         return (spender == owner || getApproved(tokenId) == spender || isApprovedForAll(owner, spender));
803     }
804 
805     /**
806      * @dev Safely mints `tokenId` and transfers it to `to`.
807      *
808      * Requirements:
809      *
810      * - `tokenId` must not exist.
811      * - If `to` refers to a smart contract, it must implement {IERC721Receiver-onERC721Received}, which is called upon a safe transfer.
812      *
813      * Emits a {Transfer} event.
814      */
815     function _safeMint(address to, uint256 tokenId) internal virtual {
816         _safeMint(to, tokenId, "");
817     }
818 
819     /**
820      * @dev Same as {xref-ERC721-_safeMint-address-uint256-}[`_safeMint`], with an additional `data` parameter which is
821      * forwarded in {IERC721Receiver-onERC721Received} to contract recipients.
822      */
823     function _safeMint(
824         address to,
825         uint256 tokenId,
826         bytes memory _data
827     ) internal virtual {
828         _mint(to, tokenId);
829         require(
830             _checkOnERC721Received(address(0), to, tokenId, _data),
831             "ERC721: transfer to non ERC721Receiver implementer"
832         );
833     }
834 
835     /**
836      * @dev Mints `tokenId` and transfers it to `to`.
837      *
838      * WARNING: Usage of this method is discouraged, use {_safeMint} whenever possible
839      *
840      * Requirements:
841      *
842      * - `tokenId` must not exist.
843      * - `to` cannot be the zero address.
844      *
845      * Emits a {Transfer} event.
846      */
847     function _mint(address to, uint256 tokenId) internal virtual {
848         require(to != address(0), "ERC721: mint to the zero address");
849         require(!_exists(tokenId), "ERC721: token already minted");
850 
851         _beforeTokenTransfer(address(0), to, tokenId);
852 
853         _balances[to] += 1;
854         _owners[tokenId] = to;
855 
856         emit Transfer(address(0), to, tokenId);
857 
858         _afterTokenTransfer(address(0), to, tokenId);
859     }
860 
861     /**
862      * @dev Destroys `tokenId`.
863      * The approval is cleared when the token is burned.
864      *
865      * Requirements:
866      *
867      * - `tokenId` must exist.
868      *
869      * Emits a {Transfer} event.
870      */
871     function _burn(uint256 tokenId) internal virtual {
872         address owner = ERC721.ownerOf(tokenId);
873 
874         _beforeTokenTransfer(owner, address(0), tokenId);
875 
876         // Clear approvals
877         _approve(address(0), tokenId);
878 
879         _balances[owner] -= 1;
880         delete _owners[tokenId];
881 
882         emit Transfer(owner, address(0), tokenId);
883 
884         _afterTokenTransfer(owner, address(0), tokenId);
885     }
886 
887     /**
888      * @dev Transfers `tokenId` from `from` to `to`.
889      *  As opposed to {transferFrom}, this imposes no restrictions on msg.sender.
890      *
891      * Requirements:
892      *
893      * - `to` cannot be the zero address.
894      * - `tokenId` token must be owned by `from`.
895      *
896      * Emits a {Transfer} event.
897      */
898     function _transfer(
899         address from,
900         address to,
901         uint256 tokenId
902     ) internal virtual {
903         require(ERC721.ownerOf(tokenId) == from, "ERC721: transfer from incorrect owner");
904         require(to != address(0), "ERC721: transfer to the zero address");
905 
906         _beforeTokenTransfer(from, to, tokenId);
907 
908         // Clear approvals from the previous owner
909         _approve(address(0), tokenId);
910 
911         _balances[from] -= 1;
912         _balances[to] += 1;
913         _owners[tokenId] = to;
914 
915         emit Transfer(from, to, tokenId);
916 
917         _afterTokenTransfer(from, to, tokenId);
918     }
919 
920     /**
921      * @dev Approve `to` to operate on `tokenId`
922      *
923      * Emits a {Approval} event.
924      */
925     function _approve(address to, uint256 tokenId) internal virtual {
926         _tokenApprovals[tokenId] = to;
927         emit Approval(ERC721.ownerOf(tokenId), to, tokenId);
928     }
929 
930     /**
931      * @dev Approve `operator` to operate on all of `owner` tokens
932      *
933      * Emits a {ApprovalForAll} event.
934      */
935     function _setApprovalForAll(
936         address owner,
937         address operator,
938         bool approved
939     ) internal virtual {
940         require(owner != operator, "ERC721: approve to caller");
941         _operatorApprovals[owner][operator] = approved;
942         emit ApprovalForAll(owner, operator, approved);
943     }
944 
945     /**
946      * @dev Internal function to invoke {IERC721Receiver-onERC721Received} on a target address.
947      * The call is not executed if the target address is not a contract.
948      *
949      * @param from address representing the previous owner of the given token ID
950      * @param to target address that will receive the tokens
951      * @param tokenId uint256 ID of the token to be transferred
952      * @param _data bytes optional data to send along with the call
953      * @return bool whether the call correctly returned the expected magic value
954      */
955     function _checkOnERC721Received(
956         address from,
957         address to,
958         uint256 tokenId,
959         bytes memory _data
960     ) private returns (bool) {
961         if (to.isContract()) {
962             try IERC721Receiver(to).onERC721Received(_msgSender(), from, tokenId, _data) returns (bytes4 retval) {
963                 return retval == IERC721Receiver.onERC721Received.selector;
964             } catch (bytes memory reason) {
965                 if (reason.length == 0) {
966                     revert("ERC721: transfer to non ERC721Receiver implementer");
967                 } else {
968                     assembly {
969                         revert(add(32, reason), mload(reason))
970                     }
971                 }
972             }
973         } else {
974             return true;
975         }
976     }
977 
978     /**
979      * @dev Hook that is called before any token transfer. This includes minting
980      * and burning.
981      *
982      * Calling conditions:
983      *
984      * - When `from` and `to` are both non-zero, ``from``'s `tokenId` will be
985      * transferred to `to`.
986      * - When `from` is zero, `tokenId` will be minted for `to`.
987      * - When `to` is zero, ``from``'s `tokenId` will be burned.
988      * - `from` and `to` are never both zero.
989      *
990      * To learn more about hooks, head to xref:ROOT:extending-contracts.adoc#using-hooks[Using Hooks].
991      */
992     function _beforeTokenTransfer(
993         address from,
994         address to,
995         uint256 tokenId
996     ) internal virtual {}
997 
998     /**
999      * @dev Hook that is called after any transfer of tokens. This includes
1000      * minting and burning.
1001      *
1002      * Calling conditions:
1003      *
1004      * - when `from` and `to` are both non-zero.
1005      * - `from` and `to` are never both zero.
1006      *
1007      * To learn more about hooks, head to xref:ROOT:extending-contracts.adoc#using-hooks[Using Hooks].
1008      */
1009     function _afterTokenTransfer(
1010         address from,
1011         address to,
1012         uint256 tokenId
1013     ) internal virtual {}
1014 }
1015 
1016 
1017 // OpenZeppelin Contracts v4.4.1 (utils/Counters.sol)
1018 
1019 
1020 
1021 /**
1022  * @title Counters
1023  * @author Matt Condon (@shrugs)
1024  * @dev Provides counters that can only be incremented, decremented or reset. This can be used e.g. to track the number
1025  * of elements in a mapping, issuing ERC721 ids, or counting request ids.
1026  *
1027  * Include with `using Counters for Counters.Counter;`
1028  */
1029 library Counters {
1030     struct Counter {
1031         // This variable should never be directly accessed by users of the library: interactions must be restricted to
1032         // the library's function. As of Solidity v0.5.2, this cannot be enforced, though there is a proposal to add
1033         // this feature: see https://github.com/ethereum/solidity/issues/4637
1034         uint256 _value; // default: 0
1035     }
1036 
1037     function current(Counter storage counter) internal view returns (uint256) {
1038         return counter._value;
1039     }
1040 
1041     function increment(Counter storage counter) internal {
1042         unchecked {
1043             counter._value += 1;
1044         }
1045     }
1046 
1047     function decrement(Counter storage counter) internal {
1048         uint256 value = counter._value;
1049         require(value > 0, "Counter: decrement overflow");
1050         unchecked {
1051             counter._value = value - 1;
1052         }
1053     }
1054 
1055     function reset(Counter storage counter) internal {
1056         counter._value = 0;
1057     }
1058 }
1059 
1060 
1061 // OpenZeppelin Contracts v4.4.1 (access/Ownable.sol)
1062 
1063 
1064 
1065 
1066 
1067 /**
1068  * @dev Contract module which provides a basic access control mechanism, where
1069  * there is an account (an owner) that can be granted exclusive access to
1070  * specific functions.
1071  *
1072  * By default, the owner account will be the one that deploys the contract. This
1073  * can later be changed with {transferOwnership}.
1074  *
1075  * This module is used through inheritance. It will make available the modifier
1076  * `onlyOwner`, which can be applied to your functions to restrict their use to
1077  * the owner.
1078  */
1079 abstract contract Ownable is Context {
1080     address private _owner;
1081 
1082     event OwnershipTransferred(address indexed previousOwner, address indexed newOwner);
1083 
1084     /**
1085      * @dev Initializes the contract setting the deployer as the initial owner.
1086      */
1087     constructor() {
1088         _transferOwnership(_msgSender());
1089     }
1090 
1091     /**
1092      * @dev Returns the address of the current owner.
1093      */
1094     function owner() public view virtual returns (address) {
1095         return _owner;
1096     }
1097 
1098     /**
1099      * @dev Throws if called by any account other than the owner.
1100      */
1101     modifier onlyOwner() {
1102         require(owner() == _msgSender(), "Ownable: caller is not the owner");
1103         _;
1104     }
1105 
1106     /**
1107      * @dev Leaves the contract without owner. It will not be possible to call
1108      * `onlyOwner` functions anymore. Can only be called by the current owner.
1109      *
1110      * NOTE: Renouncing ownership will leave the contract without an owner,
1111      * thereby removing any functionality that is only available to the owner.
1112      */
1113     function renounceOwnership() public virtual onlyOwner {
1114         _transferOwnership(address(0));
1115     }
1116 
1117     /**
1118      * @dev Transfers ownership of the contract to a new account (`newOwner`).
1119      * Can only be called by the current owner.
1120      */
1121     function transferOwnership(address newOwner) public virtual onlyOwner {
1122         require(newOwner != address(0), "Ownable: new owner is the zero address");
1123         _transferOwnership(newOwner);
1124     }
1125 
1126     /**
1127      * @dev Transfers ownership of the contract to a new account (`newOwner`).
1128      * Internal function without access restriction.
1129      */
1130     function _transferOwnership(address newOwner) internal virtual {
1131         address oldOwner = _owner;
1132         _owner = newOwner;
1133         emit OwnershipTransferred(oldOwner, newOwner);
1134     }
1135 }
1136 
1137 
1138 contract DragoonzNFT is ERC721, Ownable {
1139 	using Strings for uint256;
1140 	using Counters for Counters.Counter;
1141 
1142 	Counters.Counter private population;
1143 
1144 	string public uriPrefix = "";
1145 	string public uriSuffix = ".json";
1146 	string public hiddenMetadataUri; 
1147 
1148 	uint256 public maxSupply = 2222;
1149 	uint256 public whitelistMaxPerTx = 20;
1150 
1151 	bool public paused = false;
1152 	bool public revealed = false;
1153 	bool public onlyWhitelisted = true;
1154 
1155 	uint256 private low_cost = 0.088 ether;
1156 	uint256 private high_cost = 0.10 ether;
1157 
1158 	Counters.Counter private whitelist_generation;
1159 	mapping(uint256=>mapping(address=>bool)) whitelist;
1160 
1161 	constructor(string memory hidden_ipfs_addr) ERC721("DragoonzNFT", "DN") {
1162 		setHiddenMetadataUri(hidden_ipfs_addr);
1163 	}
1164 
1165 	modifier mintCompliance(uint256 _mintAmount) {
1166 		require(_mintAmount > 0, "Invalid mint amount!");
1167 		require(population.current() + _mintAmount <= maxSupply, "Max supply exceeded!");
1168 		_;
1169 	}
1170 
1171 	function supply() public view returns (uint256){
1172 		return population.current();
1173 	}
1174 
1175 	function needToUpdateCost(uint256 _supply) internal view returns (uint256 _cost){
1176 		if(_supply < 222){
1177 		  return 0.0 ether;
1178 		}
1179 		if(_supply < 522){
1180 		  return low_cost;
1181 		}
1182 		if(_supply <= maxSupply){
1183 		  return high_cost;
1184 		}
1185 
1186 		revert("price unavailable; over maximum population");
1187 	}
1188 
1189 	// Get the price for minting the requested amount of tokens (assuming no other tokens are minted by other accounts in the intrim)
1190 	function getCurrentPrice(uint256 _mintAmount) public view returns (uint256 total) {
1191 		uint256 currentSupply = population.current(); 
1192 		for (uint256 i = 1 ; i <= _mintAmount ; i++){
1193 			total += needToUpdateCost(i+currentSupply);
1194 		}
1195 		return total;
1196 	}
1197 
1198 	function mint(uint256 _mintAmount) public payable mintCompliance(_mintAmount) {
1199 		require(!paused, "The contract is paused!");
1200 
1201 		if (msg.sender != owner()) {
1202 			require(msg.value >= getCurrentPrice(_mintAmount), "insufficient funds");
1203 			require(_mintAmount <= whitelistMaxPerTx, "max NFT per address exceeded");
1204 			
1205 			if(onlyWhitelisted == true) {
1206 				require(isWhitelisted(msg.sender), "user is not whitelisted");
1207 			}
1208 		}
1209 
1210 		_mintLoop(msg.sender, _mintAmount);
1211 	}
1212 
1213 	function isWhitelisted(address _user) public view returns (bool) {
1214 		// Since you can't delete a mapping; a generation index is used
1215 		return whitelist[whitelist_generation.current()][_user];
1216 	}
1217 
1218 	function walletOfOwner(address _owner)
1219 		public
1220 		view
1221 		returns (uint256[] memory)
1222 	{
1223 		uint256 ownerTokenCount = balanceOf(_owner);
1224 		uint256[] memory ownedTokenIds = new uint256[](ownerTokenCount);
1225 		uint256 currentTokenId = 1;
1226 		uint256 ownedTokenIndex = 0;
1227 
1228 		while (ownedTokenIndex < ownerTokenCount && currentTokenId <= maxSupply) {
1229 			address currentTokenOwner = ownerOf(currentTokenId);
1230 
1231 			if (currentTokenOwner == _owner) {
1232 				ownedTokenIds[ownedTokenIndex] = currentTokenId;
1233 
1234 				ownedTokenIndex++;
1235 			}
1236 
1237 			currentTokenId++;
1238 		}
1239 
1240 		return ownedTokenIds;
1241 	}
1242 
1243 	function tokenURI(uint256 _tokenId)
1244 		public
1245 		view
1246 		virtual
1247 		override
1248 		returns (string memory)
1249 	{
1250 		require(
1251 			_exists(_tokenId),
1252 			"ERC721Metadata: URI query for nonexistent token"
1253 		);
1254 
1255 		if (revealed == false) {
1256 			return hiddenMetadataUri;
1257 		}
1258 
1259 		string memory currentBaseURI = _baseURI();
1260 		return bytes(currentBaseURI).length > 0
1261 			? string(abi.encodePacked(currentBaseURI, _tokenId.toString(), uriSuffix))
1262 			: "";
1263 	}
1264 
1265 	function setRevealed(bool _state) public onlyOwner {
1266 		revealed = _state;
1267 	}
1268 
1269 	function setPrices(uint256 low, uint256 high) public onlyOwner {
1270 		low_cost = low;
1271 		high_cost = high;
1272 	}
1273 
1274 	function setWhitelistMaxPerTransaction(uint256 _whitelistMaxPerTx) public onlyOwner {
1275 		whitelistMaxPerTx = _whitelistMaxPerTx;
1276 	}
1277 
1278 	function setHiddenMetadataUri(string memory _hiddenMetadataUri) public onlyOwner {
1279 		hiddenMetadataUri = _hiddenMetadataUri;
1280 	}
1281 
1282 	function setUriPrefix(string memory _uriPrefix) public onlyOwner {
1283 		uriPrefix = _uriPrefix;
1284 	}
1285 
1286 	function setUriSuffix(string memory _uriSuffix) public onlyOwner {
1287 		uriSuffix = _uriSuffix;
1288 	}
1289 
1290 	function setPaused(bool _state) public onlyOwner {
1291 		paused = _state;
1292 	}
1293 
1294 	function setOnlyWhitelisted(bool _state) public onlyOwner {
1295 		onlyWhitelisted = _state;
1296 	}
1297 
1298 	function whitelistUsers(address[] calldata _users) public onlyOwner {
1299 		whitelist_generation.increment();
1300 		for (uint256 i = 0 ; i < _users.length ; i++){
1301 			whitelist[whitelist_generation.current()][_users[i]] = true;
1302 		}
1303 	}
1304 	
1305 	function addToWhitelist(address user) public onlyOwner {
1306 		whitelist[whitelist_generation.current()][user] = true;
1307 	}
1308 
1309 	function withdraw() public onlyOwner {
1310 		// This will transfer the remaining contract balance to the owner.
1311 		// Do not remove this otherwise you will not be able to withdraw the funds.
1312 		// =============================================================================
1313 		(bool os, ) = payable(owner()).call{value: address(this).balance}("");
1314 		require(os);
1315 		// =============================================================================
1316 	}
1317 
1318 	function _mintLoop(address _receiver, uint256 _mintAmount) internal {
1319 		for (uint256 i = 0; i < _mintAmount; i++) {
1320 			population.increment();
1321 			_safeMint(_receiver, population.current());
1322 		}
1323 	}
1324 
1325 	function _baseURI() internal view virtual override returns (string memory) {
1326 		return uriPrefix;
1327 	}
1328 }