1 // File: contracts\interfaces\IERC165.sol
2 /**
3  * @dev Interface of the ERC165 standard, as defined in the
4  * https://eips.ethereum.org/EIPS/eip-165[EIP].
5  *
6  * Implementers can declare support of contract interfaces, which can then be
7  * queried by others ({ERC165Checker}).
8  *
9  * For an implementation, see {ERC165}.
10  */
11 interface IERC165 {
12     /**
13      * @dev Returns true if this contract implements the interface defined by
14      * `interfaceId`. See the corresponding
15      * https://eips.ethereum.org/EIPS/eip-165#how-interfaces-are-identified[EIP section]
16      * to learn more about how these ids are created.
17      *
18      * This function call must use less than 30 000 gas.
19      */
20     function supportsInterface(bytes4 interfaceId) external view returns (bool);
21 }
22 // File: contracts\interfaces\IERC721.sol
23 /**
24  * @dev Required interface of an ERC721 compliant contract.
25  */
26 interface IERC721 is IERC165 {
27     /**
28      * @dev Emitted when `tokenId` token is transferred from `from` to `to`.
29      */
30     event Transfer(address indexed from, address indexed to, uint256 indexed tokenId);
31     /**
32      * @dev Emitted when `owner` enables `approved` to manage the `tokenId` token.
33      */
34     event Approval(address indexed owner, address indexed approved, uint256 indexed tokenId);
35     /**
36      * @dev Emitted when `owner` enables or disables (`approved`) `operator` to manage all of its assets.
37      */
38     event ApprovalForAll(address indexed owner, address indexed operator, bool approved);
39     /**
40      * @dev Returns the number of tokens in ``owner``'s account.
41      */
42     function balanceOf(address owner) external view returns (uint256 balance);
43     /**
44      * @dev Returns the owner of the `tokenId` token.
45      *
46      * Requirements:
47      *
48      * - `tokenId` must exist.
49      */
50     function ownerOf(uint256 tokenId) external view returns (address owner);
51     /**
52      * @dev Safely transfers `tokenId` token from `from` to `to`, checking first that contract recipients
53      * are aware of the ERC721 protocol to prevent tokens from being forever locked.
54      *
55      * Requirements:
56      *
57      * - `from` cannot be the zero address.
58      * - `to` cannot be the zero address.
59      * - `tokenId` token must exist and be owned by `from`.
60      * - If the caller is not `from`, it must be have been allowed to move this token by either {approve} or {setApprovalForAll}.
61      * - If `to` refers to a smart contract, it must implement {IERC721Receiver-onERC721Received}, which is called upon a safe transfer.
62      *
63      * Emits a {Transfer} event.
64      */
65     function safeTransferFrom(
66         address from,
67         address to,
68         uint256 tokenId
69     ) external;
70     /**
71      * @dev Transfers `tokenId` token from `from` to `to`.
72      *
73      * WARNING: Usage of this method is discouraged, use {safeTransferFrom} whenever possible.
74      *
75      * Requirements:
76      *
77      * - `from` cannot be the zero address.
78      * - `to` cannot be the zero address.
79      * - `tokenId` token must be owned by `from`.
80      * - If the caller is not `from`, it must be approved to move this token by either {approve} or {setApprovalForAll}.
81      *
82      * Emits a {Transfer} event.
83      */
84     function transferFrom(
85         address from,
86         address to,
87         uint256 tokenId
88     ) external;
89     /**
90      * @dev Gives permission to `to` to transfer `tokenId` token to another account.
91      * The approval is cleared when the token is transferred.
92      *
93      * Only a single account can be approved at a time, so approving the zero address clears previous approvals.
94      *
95      * Requirements:
96      *
97      * - The caller must own the token or be an approved operator.
98      * - `tokenId` must exist.
99      *
100      * Emits an {Approval} event.
101      */
102     function approve(address to, uint256 tokenId) external;
103     /**
104      * @dev Returns the account approved for `tokenId` token.
105      *
106      * Requirements:
107      *
108      * - `tokenId` must exist.
109      */
110     function getApproved(uint256 tokenId) external view returns (address operator);
111     /**
112      * @dev Approve or remove `operator` as an operator for the caller.
113      * Operators can call {transferFrom} or {safeTransferFrom} for any token owned by the caller.
114      *
115      * Requirements:
116      *
117      * - The `operator` cannot be the caller.
118      *
119      * Emits an {ApprovalForAll} event.
120      */
121     function setApprovalForAll(address operator, bool _approved) external;
122     /**
123      * @dev Returns if the `operator` is allowed to manage all of the assets of `owner`.
124      *
125      * See {setApprovalForAll}
126      */
127     function isApprovedForAll(address owner, address operator) external view returns (bool);
128     /**
129      * @dev Safely transfers `tokenId` token from `from` to `to`.
130      *
131      * Requirements:
132      *
133      * - `from` cannot be the zero address.
134      * - `to` cannot be the zero address.
135      * - `tokenId` token must exist and be owned by `from`.
136      * - If the caller is not `from`, it must be approved to move this token by either {approve} or {setApprovalForAll}.
137      * - If `to` refers to a smart contract, it must implement {IERC721Receiver-onERC721Received}, which is called upon a safe transfer.
138      *
139      * Emits a {Transfer} event.
140      */
141     function safeTransferFrom(
142         address from,
143         address to,
144         uint256 tokenId,
145         bytes calldata data
146     ) external;
147 }
148 // File: contracts\interfaces\IERC721Receiver.sol
149 /**
150  * @title ERC721 token receiver interface
151  * @dev Interface for any contract that wants to support safeTransfers
152  * from ERC721 asset contracts.
153  */
154 interface IERC721Receiver {
155     /**
156      * @dev Whenever an {IERC721} `tokenId` token is transferred to this contract via {IERC721-safeTransferFrom}
157      * by `operator` from `from`, this function is called.
158      *
159      * It must return its Solidity selector to confirm the token transfer.
160      * If any other value is returned or the interface is not implemented by the recipient, the transfer will be reverted.
161      *
162      * The selector can be obtained in Solidity with `IERC721.onERC721Received.selector`.
163      */
164     function onERC721Received(
165         address operator,
166         address from,
167         uint256 tokenId,
168         bytes calldata data
169     ) external returns (bytes4);
170 }
171 // File: contracts\interfaces\IERC721Metadata.sol
172 /**
173  * @title ERC-721 Non-Fungible Token Standard, optional metadata extension
174  * @dev See https://eips.ethereum.org/EIPS/eip-721
175  */
176 interface IERC721Metadata is IERC721 {
177     /**
178      * @dev Returns the token collection name.
179      */
180     function name() external view returns (string memory);
181     /**
182      * @dev Returns the token collection symbol.
183      */
184     function symbol() external view returns (string memory);
185     /**
186      * @dev Returns the Uniform Resource Identifier (URI) for `tokenId` token.
187      */
188     function tokenURI(uint256 tokenId) external view returns (string memory);
189 }
190 // File: contracts\libs\Address.sol
191 /**
192  * @dev Collection of functions related to the address type
193  */
194 library Address {
195     /**
196      * @dev Returns true if `account` is a contract.
197      *
198      * [IMPORTANT]
199      * ====
200      * It is unsafe to assume that an address for which this function returns
201      * false is an externally-owned account (EOA) and not a contract.
202      *
203      * Among others, `isContract` will return false for the following
204      * types of addresses:
205      *
206      *  - an externally-owned account
207      *  - a contract in construction
208      *  - an address where a contract will be created
209      *  - an address where a contract lived, but was destroyed
210      * ====
211      */
212     function isContract(address account) internal view returns (bool) {
213         // This method relies on extcodesize, which returns 0 for contracts in
214         // construction, since the code is only stored at the end of the
215         // constructor execution.
216         uint256 size;
217         assembly {
218             size := extcodesize(account)
219         }
220         return size > 0;
221     }
222     /**
223      * @dev Replacement for Solidity's `transfer`: sends `amount` wei to
224      * `recipient`, forwarding all available gas and reverting on errors.
225      *
226      * https://eips.ethereum.org/EIPS/eip-1884[EIP1884] increases the gas cost
227      * of certain opcodes, possibly making contracts go over the 2300 gas limit
228      * imposed by `transfer`, making them unable to receive funds via
229      * `transfer`. {sendValue} removes this limitation.
230      *
231      * https://diligence.consensys.net/posts/2019/09/stop-using-soliditys-transfer-now/[Learn more].
232      *
233      * IMPORTANT: because control is transferred to `recipient`, care must be
234      * taken to not create reentrancy vulnerabilities. Consider using
235      * {ReentrancyGuard} or the
236      * https://solidity.readthedocs.io/en/v0.5.11/security-considerations.html#use-the-checks-effects-interactions-pattern[checks-effects-interactions pattern].
237      */
238     function sendValue(address payable recipient, uint256 amount) internal {
239         require(address(this).balance >= amount, "Address: insufficient balance");
240         (bool success, ) = recipient.call{value: amount}("");
241         require(success, "Address: unable to send value, recipient may have reverted");
242     }
243     /**
244      * @dev Performs a Solidity function call using a low level `call`. A
245      * plain `call` is an unsafe replacement for a function call: use this
246      * function instead.
247      *
248      * If `target` reverts with a revert reason, it is bubbled up by this
249      * function (like regular Solidity function calls).
250      *
251      * Returns the raw returned data. To convert to the expected return value,
252      * use https://solidity.readthedocs.io/en/latest/units-and-global-variables.html?highlight=abi.decode#abi-encoding-and-decoding-functions[`abi.decode`].
253      *
254      * Requirements:
255      *
256      * - `target` must be a contract.
257      * - calling `target` with `data` must not revert.
258      *
259      * _Available since v3.1._
260      */
261     function functionCall(address target, bytes memory data) internal returns (bytes memory) {
262         return functionCall(target, data, "Address: low-level call failed");
263     }
264     /**
265      * @dev Same as {xref-Address-functionCall-address-bytes-}[`functionCall`], but with
266      * `errorMessage` as a fallback revert reason when `target` reverts.
267      *
268      * _Available since v3.1._
269      */
270     function functionCall(
271         address target,
272         bytes memory data,
273         string memory errorMessage
274     ) internal returns (bytes memory) {
275         return functionCallWithValue(target, data, 0, errorMessage);
276     }
277     /**
278      * @dev Same as {xref-Address-functionCall-address-bytes-}[`functionCall`],
279      * but also transferring `value` wei to `target`.
280      *
281      * Requirements:
282      *
283      * - the calling contract must have an ETH balance of at least `value`.
284      * - the called Solidity function must be `payable`.
285      *
286      * _Available since v3.1._
287      */
288     function functionCallWithValue(
289         address target,
290         bytes memory data,
291         uint256 value
292     ) internal returns (bytes memory) {
293         return functionCallWithValue(target, data, value, "Address: low-level call with value failed");
294     }
295     /**
296      * @dev Same as {xref-Address-functionCallWithValue-address-bytes-uint256-}[`functionCallWithValue`], but
297      * with `errorMessage` as a fallback revert reason when `target` reverts.
298      *
299      * _Available since v3.1._
300      */
301     function functionCallWithValue(
302         address target,
303         bytes memory data,
304         uint256 value,
305         string memory errorMessage
306     ) internal returns (bytes memory) {
307         require(address(this).balance >= value, "Address: insufficient balance for call");
308         require(isContract(target), "Address: call to non-contract");
309         (bool success, bytes memory returndata) = target.call{value: value}(data);
310         return _verifyCallResult(success, returndata, errorMessage);
311     }
312     /**
313      * @dev Same as {xref-Address-functionCall-address-bytes-}[`functionCall`],
314      * but performing a static call.
315      *
316      * _Available since v3.3._
317      */
318     function functionStaticCall(address target, bytes memory data) internal view returns (bytes memory) {
319         return functionStaticCall(target, data, "Address: low-level static call failed");
320     }
321     /**
322      * @dev Same as {xref-Address-functionCall-address-bytes-string-}[`functionCall`],
323      * but performing a static call.
324      *
325      * _Available since v3.3._
326      */
327     function functionStaticCall(
328         address target,
329         bytes memory data,
330         string memory errorMessage
331     ) internal view returns (bytes memory) {
332         require(isContract(target), "Address: static call to non-contract");
333         (bool success, bytes memory returndata) = target.staticcall(data);
334         return _verifyCallResult(success, returndata, errorMessage);
335     }
336     /**
337      * @dev Same as {xref-Address-functionCall-address-bytes-}[`functionCall`],
338      * but performing a delegate call.
339      *
340      * _Available since v3.4._
341      */
342     function functionDelegateCall(address target, bytes memory data) internal returns (bytes memory) {
343         return functionDelegateCall(target, data, "Address: low-level delegate call failed");
344     }
345     /**
346      * @dev Same as {xref-Address-functionCall-address-bytes-string-}[`functionCall`],
347      * but performing a delegate call.
348      *
349      * _Available since v3.4._
350      */
351     function functionDelegateCall(
352         address target,
353         bytes memory data,
354         string memory errorMessage
355     ) internal returns (bytes memory) {
356         require(isContract(target), "Address: delegate call to non-contract");
357         (bool success, bytes memory returndata) = target.delegatecall(data);
358         return _verifyCallResult(success, returndata, errorMessage);
359     }
360     function _verifyCallResult(
361         bool success,
362         bytes memory returndata,
363         string memory errorMessage
364     ) private pure returns (bytes memory) {
365         if (success) {
366             return returndata;
367         } else {
368             // Look for revert reason and bubble it up if present
369             if (returndata.length > 0) {
370                 // The easiest way to bubble the revert reason is using memory via assembly
371                 assembly {
372                     let returndata_size := mload(returndata)
373                     revert(add(32, returndata), returndata_size)
374                 }
375             } else {
376                 revert(errorMessage);
377             }
378         }
379     }
380 }
381 // File: contracts\utils\Context.sol
382 /*
383  * @dev Provides information about the current execution context, including the
384  * sender of the transaction and its data. While these are generally available
385  * via msg.sender and msg.data, they should not be accessed in such a direct
386  * manner, since when dealing with meta-transactions the account sending and
387  * paying for execution may not be the actual sender (as far as an application
388  * is concerned).
389  *
390  * This contract is only required for intermediate, library-like contracts.
391  */
392 abstract contract Context {
393     function _msgSender() internal view virtual returns (address) {
394         return msg.sender;
395     }
396     function _msgData() internal view virtual returns (bytes calldata) {
397         return msg.data;
398     }
399 }
400 // File: contracts\libs\Strings.sol
401 /**
402  * @dev String operations.
403  */
404 library Strings {
405     bytes16 private constant _HEX_SYMBOLS = "0123456789abcdef";
406     /**
407      * @dev Converts a `uint256` to its ASCII `string` decimal representation.
408      */
409     function toString(uint256 value) internal pure returns (string memory) {
410         // Inspired by OraclizeAPI's implementation - MIT licence
411         // https://github.com/oraclize/ethereum-api/blob/b42146b063c7d6ee1358846c198246239e9360e8/oraclizeAPI_0.4.25.sol
412         if (value == 0) {
413             return "0";
414         }
415         uint256 temp = value;
416         uint256 digits;
417         while (temp != 0) {
418             digits++;
419             temp /= 10;
420         }
421         bytes memory buffer = new bytes(digits);
422         while (value != 0) {
423             digits -= 1;
424             buffer[digits] = bytes1(uint8(48 + uint256(value % 10)));
425             value /= 10;
426         }
427         return string(buffer);
428     }
429     /**
430      * @dev Converts a `uint256` to its ASCII `string` hexadecimal representation.
431      */
432     function toHexString(uint256 value) internal pure returns (string memory) {
433         if (value == 0) {
434             return "0x00";
435         }
436         uint256 temp = value;
437         uint256 length = 0;
438         while (temp != 0) {
439             length++;
440             temp >>= 8;
441         }
442         return toHexString(value, length);
443     }
444     /**
445      * @dev Converts a `uint256` to its ASCII `string` hexadecimal representation with fixed length.
446      */
447     function toHexString(uint256 value, uint256 length) internal pure returns (string memory) {
448         bytes memory buffer = new bytes(2 * length + 2);
449         buffer[0] = "0";
450         buffer[1] = "x";
451         for (uint256 i = 2 * length + 1; i > 1; --i) {
452             buffer[i] = _HEX_SYMBOLS[value & 0xf];
453             value >>= 4;
454         }
455         require(value == 0, "Strings: hex length insufficient");
456         return string(buffer);
457     }
458 }
459 // File: contracts\ERC165.sol
460 /**
461  * @dev Implementation of the {IERC165} interface.
462  *
463  * Contracts that want to implement ERC165 should inherit from this contract and override {supportsInterface} to check
464  * for the additional interface id that will be supported. For example:
465  *
466  * ```solidity
467  * function supportsInterface(bytes4 interfaceId) public view virtual override returns (bool) {
468  *     return interfaceId == type(MyInterface).interfaceId || super.supportsInterface(interfaceId);
469  * }
470  * ```
471  *
472  * Alternatively, {ERC165Storage} provides an easier to use but more expensive implementation.
473  */
474 abstract contract ERC165 is IERC165 {
475     /**
476      * @dev See {IERC165-supportsInterface}.
477      */
478     function supportsInterface(bytes4 interfaceId) public view virtual override returns (bool) {
479         return interfaceId == type(IERC165).interfaceId;
480     }
481 }
482 // File: contracts\ERC721.sol
483 /**
484  * @dev Implementation of https://eips.ethereum.org/EIPS/eip-721[ERC721] Non-Fungible Token Standard, including
485  * the Metadata extension, but not including the Enumerable extension, which is available separately as
486  * {ERC721Enumerable}.
487  */
488 contract ERC721 is Context, ERC165, IERC721, IERC721Metadata {
489     using Address for address;
490     using Strings for uint256;
491     // Token name
492     string private _name;
493     // Token symbol
494     string private _symbol;
495     // Mapping from token ID to owner address
496     mapping(uint256 => address) private _owners;
497     // Mapping owner address to token count
498     mapping(address => uint256) private _balances;
499     // Mapping from token ID to approved address
500     mapping(uint256 => address) private _tokenApprovals;
501     // Mapping from owner to operator approvals
502     mapping(address => mapping(address => bool)) private _operatorApprovals;
503     /**
504      * @dev Initializes the contract by setting a `name` and a `symbol` to the token collection.
505      */
506     constructor(string memory name_, string memory symbol_) {
507         _name = name_;
508         _symbol = symbol_;
509     }
510     /**
511      * @dev See {IERC165-supportsInterface}.
512      */
513     function supportsInterface(bytes4 interfaceId) public view virtual override(ERC165, IERC165) returns (bool) {
514         return
515             interfaceId == type(IERC721).interfaceId ||
516             interfaceId == type(IERC721Metadata).interfaceId ||
517             super.supportsInterface(interfaceId);
518     }
519     /**
520      * @dev See {IERC721-balanceOf}.
521      */
522     function balanceOf(address owner) public view virtual override returns (uint256) {
523         require(owner != address(0), "ERC721: balance query for the zero address");
524         return _balances[owner];
525     }
526     /**
527      * @dev See {IERC721-ownerOf}.
528      */
529     function ownerOf(uint256 tokenId) public view virtual override returns (address) {
530         address owner = _owners[tokenId];
531         require(owner != address(0), "ERC721: owner query for nonexistent token");
532         return owner;
533     }
534     /**
535      * @dev See {IERC721Metadata-name}.
536      */
537     function name() public view virtual override returns (string memory) {
538         return _name;
539     }
540     /**
541      * @dev See {IERC721Metadata-symbol}.
542      */
543     function symbol() public view virtual override returns (string memory) {
544         return _symbol;
545     }
546     /**
547      * @dev See {IERC721Metadata-tokenURI}.
548      */
549     function tokenURI(uint256 tokenId) public view virtual override returns (string memory) {
550         require(_exists(tokenId), "ERC721Metadata: URI query for nonexistent token");
551         string memory baseURI = _baseURI();
552         return bytes(baseURI).length > 0 ? string(abi.encodePacked(baseURI, tokenId.toString())) : "";
553     }
554     /**
555      * @dev Base URI for computing {tokenURI}. If set, the resulting URI for each
556      * token will be the concatenation of the `baseURI` and the `tokenId`. Empty
557      * by default, can be overriden in child contracts.
558      */
559     function _baseURI() internal view virtual returns (string memory) {
560         return "";
561     }
562     /**
563      * @dev See {IERC721-approve}.
564      */
565     function approve(address to, uint256 tokenId) public virtual override {
566         address owner = ERC721.ownerOf(tokenId);
567         require(to != owner, "ERC721: approval to current owner");
568         require(
569             _msgSender() == owner || isApprovedForAll(owner, _msgSender()),
570             "ERC721: approve caller is not owner nor approved for all"
571         );
572         _approve(to, tokenId);
573     }
574     /**
575      * @dev See {IERC721-getApproved}.
576      */
577     function getApproved(uint256 tokenId) public view virtual override returns (address) {
578         require(_exists(tokenId), "ERC721: approved query for nonexistent token");
579         return _tokenApprovals[tokenId];
580     }
581     /**
582      * @dev See {IERC721-setApprovalForAll}.
583      */
584     function setApprovalForAll(address operator, bool approved) public virtual override {
585         require(operator != _msgSender(), "ERC721: approve to caller");
586         _operatorApprovals[_msgSender()][operator] = approved;
587         emit ApprovalForAll(_msgSender(), operator, approved);
588     }
589     /**
590      * @dev See {IERC721-isApprovedForAll}.
591      */
592     function isApprovedForAll(address owner, address operator) public view virtual override returns (bool) {
593         return _operatorApprovals[owner][operator];
594     }
595     /**
596      * @dev See {IERC721-transferFrom}.
597      */
598     function transferFrom(
599         address from,
600         address to,
601         uint256 tokenId
602     ) public virtual override {
603         //solhint-disable-next-line max-line-length
604         require(_isApprovedOrOwner(_msgSender(), tokenId), "ERC721: transfer caller is not owner nor approved");
605         _transfer(from, to, tokenId);
606     }
607     /**
608      * @dev See {IERC721-safeTransferFrom}.
609      */
610     function safeTransferFrom(
611         address from,
612         address to,
613         uint256 tokenId
614     ) public virtual override {
615         safeTransferFrom(from, to, tokenId, "");
616     }
617     /**
618      * @dev See {IERC721-safeTransferFrom}.
619      */
620     function safeTransferFrom(
621         address from,
622         address to,
623         uint256 tokenId,
624         bytes memory _data
625     ) public virtual override {
626         require(_isApprovedOrOwner(_msgSender(), tokenId), "ERC721: transfer caller is not owner nor approved");
627         _safeTransfer(from, to, tokenId, _data);
628     }
629     /**
630      * @dev Safely transfers `tokenId` token from `from` to `to`, checking first that contract recipients
631      * are aware of the ERC721 protocol to prevent tokens from being forever locked.
632      *
633      * `_data` is additional data, it has no specified format and it is sent in call to `to`.
634      *
635      * This internal function is equivalent to {safeTransferFrom}, and can be used to e.g.
636      * implement alternative mechanisms to perform token transfer, such as signature-based.
637      *
638      * Requirements:
639      *
640      * - `from` cannot be the zero address.
641      * - `to` cannot be the zero address.
642      * - `tokenId` token must exist and be owned by `from`.
643      * - If `to` refers to a smart contract, it must implement {IERC721Receiver-onERC721Received}, which is called upon a safe transfer.
644      *
645      * Emits a {Transfer} event.
646      */
647     function _safeTransfer(
648         address from,
649         address to,
650         uint256 tokenId,
651         bytes memory _data
652     ) internal virtual {
653         _transfer(from, to, tokenId);
654         require(_checkOnERC721Received(from, to, tokenId, _data), "ERC721: transfer to non ERC721Receiver implementer");
655     }
656     /**
657      * @dev Returns whether `tokenId` exists.
658      *
659      * Tokens can be managed by their owner or approved accounts via {approve} or {setApprovalForAll}.
660      *
661      * Tokens start existing when they are minted (`_mint`),
662      * and stop existing when they are burned (`_burn`).
663      */
664     function _exists(uint256 tokenId) internal view virtual returns (bool) {
665         return _owners[tokenId] != address(0);
666     }
667     /**
668      * @dev Returns whether `spender` is allowed to manage `tokenId`.
669      *
670      * Requirements:
671      *
672      * - `tokenId` must exist.
673      */
674     function _isApprovedOrOwner(address spender, uint256 tokenId) internal view virtual returns (bool) {
675         require(_exists(tokenId), "ERC721: operator query for nonexistent token");
676         address owner = ERC721.ownerOf(tokenId);
677         return (spender == owner || getApproved(tokenId) == spender || isApprovedForAll(owner, spender));
678     }
679     /**
680      * @dev Safely mints `tokenId` and transfers it to `to`.
681      *
682      * Requirements:
683      *
684      * - `tokenId` must not exist.
685      * - If `to` refers to a smart contract, it must implement {IERC721Receiver-onERC721Received}, which is called upon a safe transfer.
686      *
687      * Emits a {Transfer} event.
688      */
689     function _safeMint(address to, uint256 tokenId) internal virtual {
690         _safeMint(to, tokenId, "");
691     }
692     /**
693      * @dev Same as {xref-ERC721-_safeMint-address-uint256-}[`_safeMint`], with an additional `data` parameter which is
694      * forwarded in {IERC721Receiver-onERC721Received} to contract recipients.
695      */
696     function _safeMint(
697         address to,
698         uint256 tokenId,
699         bytes memory _data
700     ) internal virtual {
701         _mint(to, tokenId);
702         require(
703             _checkOnERC721Received(address(0), to, tokenId, _data),
704             "ERC721: transfer to non ERC721Receiver implementer"
705         );
706     }
707     /**
708      * @dev Mints `tokenId` and transfers it to `to`.
709      *
710      * WARNING: Usage of this method is discouraged, use {_safeMint} whenever possible
711      *
712      * Requirements:
713      *
714      * - `tokenId` must not exist.
715      * - `to` cannot be the zero address.
716      *
717      * Emits a {Transfer} event.
718      */
719     function _mint(address to, uint256 tokenId) internal virtual {
720         require(to != address(0), "ERC721: mint to the zero address");
721         require(!_exists(tokenId), "ERC721: token already minted");
722         _beforeTokenTransfer(address(0), to, tokenId);
723         _balances[to] += 1;
724         _owners[tokenId] = to;
725         emit Transfer(address(0), to, tokenId);
726     }
727     /**
728      * @dev Destroys `tokenId`.
729      * The approval is cleared when the token is burned.
730      *
731      * Requirements:
732      *
733      * - `tokenId` must exist.
734      *
735      * Emits a {Transfer} event.
736      */
737     function _burn(uint256 tokenId) internal virtual {
738         address owner = ERC721.ownerOf(tokenId);
739         _beforeTokenTransfer(owner, address(0), tokenId);
740         // Clear approvals
741         _approve(address(0), tokenId);
742         _balances[owner] -= 1;
743         delete _owners[tokenId];
744         emit Transfer(owner, address(0), tokenId);
745     }
746     /**
747      * @dev Transfers `tokenId` from `from` to `to`.
748      *  As opposed to {transferFrom}, this imposes no restrictions on msg.sender.
749      *
750      * Requirements:
751      *
752      * - `to` cannot be the zero address.
753      * - `tokenId` token must be owned by `from`.
754      *
755      * Emits a {Transfer} event.
756      */
757     function _transfer(
758         address from,
759         address to,
760         uint256 tokenId
761     ) internal virtual {
762         require(ERC721.ownerOf(tokenId) == from, "ERC721: transfer of token that is not own");
763         require(to != address(0), "ERC721: transfer to the zero address");
764         _beforeTokenTransfer(from, to, tokenId);
765         // Clear approvals from the previous owner
766         _approve(address(0), tokenId);
767         _balances[from] -= 1;
768         _balances[to] += 1;
769         _owners[tokenId] = to;
770         emit Transfer(from, to, tokenId);
771     }
772     /**
773      * @dev Approve `to` to operate on `tokenId`
774      *
775      * Emits a {Approval} event.
776      */
777     function _approve(address to, uint256 tokenId) internal virtual {
778         _tokenApprovals[tokenId] = to;
779         emit Approval(ERC721.ownerOf(tokenId), to, tokenId);
780     }
781     /**
782      * @dev Internal function to invoke {IERC721Receiver-onERC721Received} on a target address.
783      * The call is not executed if the target address is not a contract.
784      *
785      * @param from address representing the previous owner of the given token ID
786      * @param to target address that will receive the tokens
787      * @param tokenId uint256 ID of the token to be transferred
788      * @param _data bytes optional data to send along with the call
789      * @return bool whether the call correctly returned the expected magic value
790      */
791     function _checkOnERC721Received(
792         address from,
793         address to,
794         uint256 tokenId,
795         bytes memory _data
796     ) private returns (bool) {
797         if (to.isContract()) {
798             try IERC721Receiver(to).onERC721Received(_msgSender(), from, tokenId, _data) returns (bytes4 retval) {
799                 return retval == IERC721Receiver(to).onERC721Received.selector;
800             } catch (bytes memory reason) {
801                 if (reason.length == 0) {
802                     revert("ERC721: transfer to non ERC721Receiver implementer");
803                 } else {
804                     assembly {
805                         revert(add(32, reason), mload(reason))
806                     }
807                 }
808             }
809         } else {
810             return true;
811         }
812     }
813     /**
814      * @dev Hook that is called before any token transfer. This includes minting
815      * and burning.
816      *
817      * Calling conditions:
818      *
819      * - When `from` and `to` are both non-zero, ``from``'s `tokenId` will be
820      * transferred to `to`.
821      * - When `from` is zero, `tokenId` will be minted for `to`.
822      * - When `to` is zero, ``from``'s `tokenId` will be burned.
823      * - `from` and `to` are never both zero.
824      *
825      * To learn more about hooks, head to xref:ROOT:extending-contracts.adoc#using-hooks[Using Hooks].
826      */
827     function _beforeTokenTransfer(
828         address from,
829         address to,
830         uint256 tokenId
831     ) internal virtual {}
832 }
833 // File: contracts\utils\Ownable.sol
834 /**
835  * @dev Contract module which provides a basic access control mechanism, where
836  * there is an account (an owner) that can be granted exclusive access to
837  * specific functions.
838  *
839  * By default, the owner account will be the one that deploys the contract. This
840  * can later be changed with {transferOwnership}.
841  *
842  * This module is used through inheritance. It will make available the modifier
843  * `onlyOwner`, which can be applied to your functions to restrict their use to
844  * the owner.
845  */
846 abstract contract Ownable is Context {
847     address private _owner;
848     event OwnershipTransferred(address indexed previousOwner, address indexed newOwner);
849     /**
850      * @dev Initializes the contract setting the deployer as the initial owner.
851      */
852     constructor() {
853         _setOwner(_msgSender());
854     }
855     /**
856      * @dev Returns the address of the current owner.
857      */
858     function owner() public view virtual returns (address) {
859         return _owner;
860     }
861     /**
862      * @dev Throws if called by any account other than the owner.
863      */
864     modifier onlyOwner() {
865         require(owner() == _msgSender(), "Ownable: caller is not the owner");
866         _;
867     }
868     /**
869      * @dev Leaves the contract without owner. It will not be possible to call
870      * `onlyOwner` functions anymore. Can only be called by the current owner.
871      *
872      * NOTE: Renouncing ownership will leave the contract without an owner,
873      * thereby removing any functionality that is only available to the owner.
874      */
875     function renounceOwnership() public virtual onlyOwner {
876         _setOwner(address(0));
877     }
878     /**
879      * @dev Transfers ownership of the contract to a new account (`newOwner`).
880      * Can only be called by the current owner.
881      */
882     function transferOwnership(address newOwner) public virtual onlyOwner {
883         require(newOwner != address(0), "Ownable: new owner is the zero address");
884         _setOwner(newOwner);
885     }
886     function _setOwner(address newOwner) private {
887         address oldOwner = _owner;
888         _owner = newOwner;
889         emit OwnershipTransferred(oldOwner, newOwner);
890     }
891 }
892 // File: contracts\interfaces\IERC721Enumerable.sol
893 /**
894  * @title ERC-721 Non-Fungible Token Standard, optional enumeration extension
895  * @dev See https://eips.ethereum.org/EIPS/eip-721
896  */
897 interface IERC721Enumerable is IERC721 {
898     /**
899      * @dev Returns the total amount of tokens stored by the contract.
900      */
901     function totalSupply() external view returns (uint256);
902     /**
903      * @dev Returns a token ID owned by `owner` at a given `index` of its token list.
904      * Use along with {balanceOf} to enumerate all of ``owner``'s tokens.
905      */
906     function tokenOfOwnerByIndex(address owner, uint256 index) external view returns (uint256 tokenId);
907     /**
908      * @dev Returns a token ID at a given `index` of all the tokens stored by the contract.
909      * Use along with {totalSupply} to enumerate all tokens.
910      */
911     function tokenByIndex(uint256 index) external view returns (uint256);
912 }
913 // File: contracts\ERC721Enumerable.sol
914 /**
915  * @dev This implements an optional extension of {ERC721} defined in the EIP that adds
916  * enumerability of all the token ids in the contract as well as all token ids owned by each
917  * account.
918  */
919 abstract contract ERC721Enumerable is ERC721, IERC721Enumerable {
920     // Mapping from owner to list of owned token IDs
921     mapping(address => mapping(uint256 => uint256)) private _ownedTokens;
922     // Mapping from token ID to index of the owner tokens list
923     mapping(uint256 => uint256) private _ownedTokensIndex;
924     // Array with all token ids, used for enumeration
925     uint256[] private _allTokens;
926     // Mapping from token id to position in the allTokens array
927     mapping(uint256 => uint256) private _allTokensIndex;
928     /**
929      * @dev See {IERC165-supportsInterface}.
930      */
931     function supportsInterface(bytes4 interfaceId) public view virtual override(IERC165, ERC721) returns (bool) {
932         return interfaceId == type(IERC721Enumerable).interfaceId || super.supportsInterface(interfaceId);
933     }
934     /**
935      * @dev See {IERC721Enumerable-tokenOfOwnerByIndex}.
936      */
937     function tokenOfOwnerByIndex(address owner, uint256 index) public view virtual override returns (uint256) {
938         require(index < ERC721.balanceOf(owner), "ERC721Enumerable: owner index out of bounds");
939         return _ownedTokens[owner][index];
940     }
941     /**
942      * @dev See {IERC721Enumerable-totalSupply}.
943      */
944     function totalSupply() public view virtual override returns (uint256) {
945         return _allTokens.length;
946     }
947     /**
948      * @dev See {IERC721Enumerable-tokenByIndex}.
949      */
950     function tokenByIndex(uint256 index) public view virtual override returns (uint256) {
951         require(index < ERC721Enumerable.totalSupply(), "ERC721Enumerable: global index out of bounds");
952         return _allTokens[index];
953     }
954     /**
955      * @dev Hook that is called before any token transfer. This includes minting
956      * and burning.
957      *
958      * Calling conditions:
959      *
960      * - When `from` and `to` are both non-zero, ``from``'s `tokenId` will be
961      * transferred to `to`.
962      * - When `from` is zero, `tokenId` will be minted for `to`.
963      * - When `to` is zero, ``from``'s `tokenId` will be burned.
964      * - `from` cannot be the zero address.
965      * - `to` cannot be the zero address.
966      *
967      * To learn more about hooks, head to xref:ROOT:extending-contracts.adoc#using-hooks[Using Hooks].
968      */
969     function _beforeTokenTransfer(
970         address from,
971         address to,
972         uint256 tokenId
973     ) internal virtual override {
974         super._beforeTokenTransfer(from, to, tokenId);
975         if (from == address(0)) {
976             _addTokenToAllTokensEnumeration(tokenId);
977         } else if (from != to) {
978             _removeTokenFromOwnerEnumeration(from, tokenId);
979         }
980         if (to == address(0)) {
981             _removeTokenFromAllTokensEnumeration(tokenId);
982         } else if (to != from) {
983             _addTokenToOwnerEnumeration(to, tokenId);
984         }
985     }
986     /**
987      * @dev Private function to add a token to this extension's ownership-tracking data structures.
988      * @param to address representing the new owner of the given token ID
989      * @param tokenId uint256 ID of the token to be added to the tokens list of the given address
990      */
991     function _addTokenToOwnerEnumeration(address to, uint256 tokenId) private {
992         uint256 length = ERC721.balanceOf(to);
993         _ownedTokens[to][length] = tokenId;
994         _ownedTokensIndex[tokenId] = length;
995     }
996     /**
997      * @dev Private function to add a token to this extension's token tracking data structures.
998      * @param tokenId uint256 ID of the token to be added to the tokens list
999      */
1000     function _addTokenToAllTokensEnumeration(uint256 tokenId) private {
1001         _allTokensIndex[tokenId] = _allTokens.length;
1002         _allTokens.push(tokenId);
1003     }
1004     /**
1005      * @dev Private function to remove a token from this extension's ownership-tracking data structures. Note that
1006      * while the token is not assigned a new owner, the `_ownedTokensIndex` mapping is _not_ updated: this allows for
1007      * gas optimizations e.g. when performing a transfer operation (avoiding double writes).
1008      * This has O(1) time complexity, but alters the order of the _ownedTokens array.
1009      * @param from address representing the previous owner of the given token ID
1010      * @param tokenId uint256 ID of the token to be removed from the tokens list of the given address
1011      */
1012     function _removeTokenFromOwnerEnumeration(address from, uint256 tokenId) private {
1013         // To prevent a gap in from's tokens array, we store the last token in the index of the token to delete, and
1014         // then delete the last slot (swap and pop).
1015         uint256 lastTokenIndex = ERC721.balanceOf(from) - 1;
1016         uint256 tokenIndex = _ownedTokensIndex[tokenId];
1017         // When the token to delete is the last token, the swap operation is unnecessary
1018         if (tokenIndex != lastTokenIndex) {
1019             uint256 lastTokenId = _ownedTokens[from][lastTokenIndex];
1020             _ownedTokens[from][tokenIndex] = lastTokenId; // Move the last token to the slot of the to-delete token
1021             _ownedTokensIndex[lastTokenId] = tokenIndex; // Update the moved token's index
1022         }
1023         // This also deletes the contents at the last position of the array
1024         delete _ownedTokensIndex[tokenId];
1025         delete _ownedTokens[from][lastTokenIndex];
1026     }
1027     /**
1028      * @dev Private function to remove a token from this extension's token tracking data structures.
1029      * This has O(1) time complexity, but alters the order of the _allTokens array.
1030      * @param tokenId uint256 ID of the token to be removed from the tokens list
1031      */
1032     function _removeTokenFromAllTokensEnumeration(uint256 tokenId) private {
1033         // To prevent a gap in the tokens array, we store the last token in the index of the token to delete, and
1034         // then delete the last slot (swap and pop).
1035         uint256 lastTokenIndex = _allTokens.length - 1;
1036         uint256 tokenIndex = _allTokensIndex[tokenId];
1037         // When the token to delete is the last token, the swap operation is unnecessary. However, since this occurs so
1038         // rarely (when the last minted token is burnt) that we still do the swap here to avoid the gas cost of adding
1039         // an 'if' statement (like in _removeTokenFromOwnerEnumeration)
1040         uint256 lastTokenId = _allTokens[lastTokenIndex];
1041         _allTokens[tokenIndex] = lastTokenId; // Move the last token to the slot of the to-delete token
1042         _allTokensIndex[lastTokenId] = tokenIndex; // Update the moved token's index
1043         // This also deletes the contents at the last position of the array
1044         delete _allTokensIndex[tokenId];
1045         _allTokens.pop();
1046     }
1047 }
1048 // File: contracts\interfaces\IDemonzv1.sol
1049 interface IDemonzv1 is IERC721 {
1050     function burnToken(uint256 _token_id) external; 
1051 }
1052 // File: contracts\Demonzv2.sol
1053 contract Demonzv2 is ERC721Enumerable, Ownable {
1054     using Strings for uint256;
1055     uint256 public MAX_TOKENS = 2000;
1056     uint256 public MAX_PER_WALLET = 50;
1057     uint256 public CURRENT_TOKEN_ID = 0; // for testing 
1058     string public BEGINNING_URI = "https://api.cryptodemonz.com/";
1059     string public ENDING_URI = ".json";
1060     bool public ALLOW_SACRIFCE = true;
1061 
1062     IDemonzv1 public demonzv1;
1063     constructor(address _demonzv1) ERC721 ("CryptoDemonzV2", "DEMONZv2") {
1064         demonzv1 = IDemonzv1(_demonzv1);
1065     }
1066 
1067     modifier safeSacrificing {
1068         require(ALLOW_SACRIFCE, "Sacrificing has not begun yet");
1069         _;
1070     }
1071     event tokenSacrificed(address _sender);    
1072 
1073     /// @notice standard minting function
1074     /// @param _amount to be minted
1075     function mintToken(uint256 _amount) public onlyOwner {
1076         require(totalSupply() + _amount <= MAX_TOKENS, "Not enough NFTs left to mint");
1077         _batchMint(_amount, msg.sender);
1078     }
1079 
1080     /// @notice will mint demonzv2 for burning demonzv1
1081     /// @param _ids array of demonzv1 ids to be burned
1082     function burnV1(uint256[] memory _ids) external safeSacrificing {
1083         uint256 i = 0;
1084         require(_ids.length % 3 == 0 && _ids.length <= 9, "Invalid list");
1085         require(totalSupply() + _ids.length <= MAX_TOKENS, "Not enough NFTs left to mint");
1086         require(balanceOf(msg.sender) + _ids.length <= MAX_PER_WALLET, "Exceeds wallet max allowed balance");
1087         for (i=0; i<_ids.length; ++i) {
1088             require(demonzv1.ownerOf(_ids[i]) == msg.sender, "Sender is not owner");
1089             demonzv1.safeTransferFrom(msg.sender, address(this), _ids[i]);
1090             demonzv1.burnToken(_ids[i]);
1091            }
1092         _batchMint(_ids.length / 3, msg.sender);
1093         // no need to increment token id here
1094         emit tokenSacrificed(msg.sender);
1095     }
1096     function tokenURI(uint256 tokenId) public view virtual override returns (string memory) {
1097         return string(abi.encodePacked(BEGINNING_URI, tokenId.toString(), ENDING_URI));
1098     }
1099     function withdraw() external onlyOwner {
1100         payable(msg.sender).transfer(address(this).balance);
1101     }
1102 
1103     function setBeginningURI(string memory _new_uri) external onlyOwner {
1104         BEGINNING_URI = _new_uri;
1105     }
1106     function setEndingURI(string memory _new_uri) external onlyOwner {
1107         ENDING_URI = _new_uri;
1108     }
1109     function toggleSacrifice() external onlyOwner {
1110         ALLOW_SACRIFCE = !ALLOW_SACRIFCE;
1111     }
1112     function changeMaxPerWalletAmount(uint256 _amount) external onlyOwner {
1113         MAX_PER_WALLET = _amount;
1114     }
1115     /// @notice dummy function for unit testing
1116     function _incrementTokenId() internal {
1117         ++CURRENT_TOKEN_ID;
1118     }
1119 
1120     function _batchMint(uint256 _amount, address _sender) internal {
1121         for (uint256 i=0; i<_amount; ++i) {
1122             _safeMint(_sender, totalSupply());
1123             _incrementTokenId();
1124         }
1125     }
1126 
1127     /// @notice dummy function for unit testing
1128     function getCurrentTokenId() view external returns (uint256) {
1129         return CURRENT_TOKEN_ID;
1130     }
1131     /// @dev DO NOT FORMAT THIS TO PURE, even tho compiler is asking
1132     function onERC721Received(
1133         address,
1134         address,
1135         uint256,
1136         bytes calldata
1137     ) external returns (bytes4) {
1138         return
1139             bytes4(
1140                 keccak256("onERC721Received(address,address,uint256,bytes)")
1141             );
1142     }
1143 }