1 // SPDX-License-Identifier: MIT
2 pragma solidity ^0.8.0;
3 
4 interface IERC165 {
5     /**
6      * @dev Returns true if this contract implements the interface defined by
7      * `interfaceId`. See the corresponding
8      * https://eips.ethereum.org/EIPS/eip-165#how-interfaces-are-identified[EIP section]
9      * to learn more about how these ids are created.
10      *
11      * This function call must use less than 30 000 gas.
12      */
13     function supportsInterface(bytes4 interfaceId) external view returns (bool);
14 }
15 abstract contract ERC165 is IERC165 {
16     /**
17      * @dev See {IERC165-supportsInterface}.
18      */
19     function supportsInterface(bytes4 interfaceId) public view virtual override returns (bool) {
20         return interfaceId == type(IERC165).interfaceId;
21     }
22 }
23 
24 /**
25  * @dev Required interface of an ERC721 compliant contract.
26  */
27 interface IERC721 is IERC165 {
28     /**
29      * @dev Emitted when `tokenId` token is transferred from `from` to `to`.
30      */
31     event Transfer(address indexed from, address indexed to, uint256 indexed tokenId);
32 
33     /**
34      * @dev Emitted when `owner` enables `approved` to manage the `tokenId` token.
35      */
36     event Approval(address indexed owner, address indexed approved, uint256 indexed tokenId);
37 
38     /**
39      * @dev Emitted when `owner` enables or disables (`approved`) `operator` to manage all of its assets.
40      */
41     event ApprovalForAll(address indexed owner, address indexed operator, bool approved);
42 
43     /**
44      * @dev Returns the number of tokens in ``owner``'s account.
45      */
46     function balanceOf(address owner) external view returns (uint256 balance);
47 
48     /**
49      * @dev Returns the owner of the `tokenId` token.
50      *
51      * Requirements:
52      *
53      * - `tokenId` must exist.
54      */
55     function ownerOf(uint256 tokenId) external view returns (address owner);
56 
57     /**
58      * @dev Safely transfers `tokenId` token from `from` to `to`, checking first that contract recipients
59      * are aware of the ERC721 protocol to prevent tokens from being forever locked.
60      *
61      * Requirements:
62      *
63      * - `from` cannot be the zero address.
64      * - `to` cannot be the zero address.
65      * - `tokenId` token must exist and be owned by `from`.
66      * - If the caller is not `from`, it must be have been allowed to move this token by either {approve} or {setApprovalForAll}.
67      * - If `to` refers to a smart contract, it must implement {IERC721Receiver-onERC721Received}, which is called upon a safe transfer.
68      *
69      * Emits a {Transfer} event.
70      */
71     function safeTransferFrom(
72         address from,
73         address to,
74         uint256 tokenId
75     ) external;
76 
77     /**
78      * @dev Transfers `tokenId` token from `from` to `to`.
79      *
80      * WARNING: Usage of this method is discouraged, use {safeTransferFrom} whenever possible.
81      *
82      * Requirements:
83      *
84      * - `from` cannot be the zero address.
85      * - `to` cannot be the zero address.
86      * - `tokenId` token must be owned by `from`.
87      * - If the caller is not `from`, it must be approved to move this token by either {approve} or {setApprovalForAll}.
88      *
89      * Emits a {Transfer} event.
90      */
91     function transferFrom(
92         address from,
93         address to,
94         uint256 tokenId
95     ) external;
96 
97     /**
98      * @dev Gives permission to `to` to transfer `tokenId` token to another account.
99      * The approval is cleared when the token is transferred.
100      *
101      * Only a single account can be approved at a time, so approving the zero address clears previous approvals.
102      *
103      * Requirements:
104      *
105      * - The caller must own the token or be an approved operator.
106      * - `tokenId` must exist.
107      *
108      * Emits an {Approval} event.
109      */
110     function approve(address to, uint256 tokenId) external;
111 
112     /**
113      * @dev Returns the account approved for `tokenId` token.
114      *
115      * Requirements:
116      *
117      * - `tokenId` must exist.
118      */
119     function getApproved(uint256 tokenId) external view returns (address operator);
120 
121     /**
122      * @dev Approve or remove `operator` as an operator for the caller.
123      * Operators can call {transferFrom} or {safeTransferFrom} for any token owned by the caller.
124      *
125      * Requirements:
126      *
127      * - The `operator` cannot be the caller.
128      *
129      * Emits an {ApprovalForAll} event.
130      */
131     function setApprovalForAll(address operator, bool _approved) external;
132 
133     /**
134      * @dev Returns if the `operator` is allowed to manage all of the assets of `owner`.
135      *
136      * See {setApprovalForAll}
137      */
138     function isApprovedForAll(address owner, address operator) external view returns (bool);
139 
140     /**
141      * @dev Safely transfers `tokenId` token from `from` to `to`.
142      *
143      * Requirements:
144      *
145      * - `from` cannot be the zero address.
146      * - `to` cannot be the zero address.
147      * - `tokenId` token must exist and be owned by `from`.
148      * - If the caller is not `from`, it must be approved to move this token by either {approve} or {setApprovalForAll}.
149      * - If `to` refers to a smart contract, it must implement {IERC721Receiver-onERC721Received}, which is called upon a safe transfer.
150      *
151      * Emits a {Transfer} event.
152      */
153     function safeTransferFrom(
154         address from,
155         address to,
156         uint256 tokenId,
157         bytes calldata data
158     ) external;
159 }
160 
161 interface IERC721Receiver {
162     /**
163      * @dev Whenever an {IERC721} `tokenId` token is transferred to this contract via {IERC721-safeTransferFrom}
164      * by `operator` from `from`, this function is called.
165      *
166      * It must return its Solidity selector to confirm the token transfer.
167      * If any other value is returned or the interface is not implemented by the recipient, the transfer will be reverted.
168      *
169      * The selector can be obtained in Solidity with `IERC721.onERC721Received.selector`.
170      */
171     function onERC721Received(
172         address operator,
173         address from,
174         uint256 tokenId,
175         bytes calldata data
176     ) external returns (bytes4);
177 }
178 
179 interface IERC721Metadata is IERC721 {
180     /**
181      * @dev Returns the token collection name.
182      */
183     function name() external view returns (string memory);
184 
185     /**
186      * @dev Returns the token collection symbol.
187      */
188     function symbol() external view returns (string memory);
189 
190     /**
191      * @dev Returns the Uniform Resource Identifier (URI) for `tokenId` token.
192      */
193     function tokenURI(uint256 tokenId) external view returns (string memory);
194 }
195 
196 library Address {
197     /**
198      * @dev Returns true if `account` is a contract.
199      *
200      * [IMPORTANT]
201      * ====
202      * It is unsafe to assume that an address for which this function returns
203      * false is an externally-owned account (EOA) and not a contract.
204      *
205      * Among others, `isContract` will return false for the following
206      * types of addresses:
207      *
208      *  - an externally-owned account
209      *  - a contract in construction
210      *  - an address where a contract will be created
211      *  - an address where a contract lived, but was destroyed
212      * ====
213      */
214     function isContract(address account) internal view returns (bool) {
215         // This method relies on extcodesize, which returns 0 for contracts in
216         // construction, since the code is only stored at the end of the
217         // constructor execution.
218 
219         uint256 size;
220         assembly {
221             size := extcodesize(account)
222         }
223         return size > 0;
224     }
225 
226     /**
227      * @dev Replacement for Solidity's `transfer`: sends `amount` wei to
228      * `recipient`, forwarding all available gas and reverting on errors.
229      *
230      * https://eips.ethereum.org/EIPS/eip-1884[EIP1884] increases the gas cost
231      * of certain opcodes, possibly making contracts go over the 2300 gas limit
232      * imposed by `transfer`, making them unable to receive funds via
233      * `transfer`. {sendValue} removes this limitation.
234      *
235      * https://diligence.consensys.net/posts/2019/09/stop-using-soliditys-transfer-now/[Learn more].
236      *
237      * IMPORTANT: because control is transferred to `recipient`, care must be
238      * taken to not create reentrancy vulnerabilities. Consider using
239      * {ReentrancyGuard} or the
240      * https://solidity.readthedocs.io/en/v0.5.11/security-considerations.html#use-the-checks-effects-interactions-pattern[checks-effects-interactions pattern].
241      */
242     function sendValue(address payable recipient, uint256 amount) internal {
243         require(address(this).balance >= amount, "Address: insufficient balance");
244 
245         (bool success, ) = recipient.call{value: amount}("");
246         require(success, "Address: unable to send value, recipient may have reverted");
247     }
248 
249     /**
250      * @dev Performs a Solidity function call using a low level `call`. A
251      * plain `call` is an unsafe replacement for a function call: use this
252      * function instead.
253      *
254      * If `target` reverts with a revert reason, it is bubbled up by this
255      * function (like regular Solidity function calls).
256      *
257      * Returns the raw returned data. To convert to the expected return value,
258      * use https://solidity.readthedocs.io/en/latest/units-and-global-variables.html?highlight=abi.decode#abi-encoding-and-decoding-functions[`abi.decode`].
259      *
260      * Requirements:
261      *
262      * - `target` must be a contract.
263      * - calling `target` with `data` must not revert.
264      *
265      * _Available since v3.1._
266      */
267     function functionCall(address target, bytes memory data) internal returns (bytes memory) {
268         return functionCall(target, data, "Address: low-level call failed");
269     }
270 
271     /**
272      * @dev Same as {xref-Address-functionCall-address-bytes-}[`functionCall`], but with
273      * `errorMessage` as a fallback revert reason when `target` reverts.
274      *
275      * _Available since v3.1._
276      */
277     function functionCall(
278         address target,
279         bytes memory data,
280         string memory errorMessage
281     ) internal returns (bytes memory) {
282         return functionCallWithValue(target, data, 0, errorMessage);
283     }
284 
285     /**
286      * @dev Same as {xref-Address-functionCall-address-bytes-}[`functionCall`],
287      * but also transferring `value` wei to `target`.
288      *
289      * Requirements:
290      *
291      * - the calling contract must have an ETH balance of at least `value`.
292      * - the called Solidity function must be `payable`.
293      *
294      * _Available since v3.1._
295      */
296     function functionCallWithValue(
297         address target,
298         bytes memory data,
299         uint256 value
300     ) internal returns (bytes memory) {
301         return functionCallWithValue(target, data, value, "Address: low-level call with value failed");
302     }
303 
304     /**
305      * @dev Same as {xref-Address-functionCallWithValue-address-bytes-uint256-}[`functionCallWithValue`], but
306      * with `errorMessage` as a fallback revert reason when `target` reverts.
307      *
308      * _Available since v3.1._
309      */
310     function functionCallWithValue(
311         address target,
312         bytes memory data,
313         uint256 value,
314         string memory errorMessage
315     ) internal returns (bytes memory) {
316         require(address(this).balance >= value, "Address: insufficient balance for call");
317         require(isContract(target), "Address: call to non-contract");
318 
319         (bool success, bytes memory returndata) = target.call{value: value}(data);
320         return verifyCallResult(success, returndata, errorMessage);
321     }
322 
323     /**
324      * @dev Same as {xref-Address-functionCall-address-bytes-}[`functionCall`],
325      * but performing a static call.
326      *
327      * _Available since v3.3._
328      */
329     function functionStaticCall(address target, bytes memory data) internal view returns (bytes memory) {
330         return functionStaticCall(target, data, "Address: low-level static call failed");
331     }
332 
333     /**
334      * @dev Same as {xref-Address-functionCall-address-bytes-string-}[`functionCall`],
335      * but performing a static call.
336      *
337      * _Available since v3.3._
338      */
339     function functionStaticCall(
340         address target,
341         bytes memory data,
342         string memory errorMessage
343     ) internal view returns (bytes memory) {
344         require(isContract(target), "Address: static call to non-contract");
345 
346         (bool success, bytes memory returndata) = target.staticcall(data);
347         return verifyCallResult(success, returndata, errorMessage);
348     }
349 
350     /**
351      * @dev Same as {xref-Address-functionCall-address-bytes-}[`functionCall`],
352      * but performing a delegate call.
353      *
354      * _Available since v3.4._
355      */
356     function functionDelegateCall(address target, bytes memory data) internal returns (bytes memory) {
357         return functionDelegateCall(target, data, "Address: low-level delegate call failed");
358     }
359 
360     /**
361      * @dev Same as {xref-Address-functionCall-address-bytes-string-}[`functionCall`],
362      * but performing a delegate call.
363      *
364      * _Available since v3.4._
365      */
366     function functionDelegateCall(
367         address target,
368         bytes memory data,
369         string memory errorMessage
370     ) internal returns (bytes memory) {
371         require(isContract(target), "Address: delegate call to non-contract");
372 
373         (bool success, bytes memory returndata) = target.delegatecall(data);
374         return verifyCallResult(success, returndata, errorMessage);
375     }
376 
377     /**
378      * @dev Tool to verifies that a low level call was successful, and revert if it wasn't, either by bubbling the
379      * revert reason using the provided one.
380      *
381      * _Available since v4.3._
382      */
383     function verifyCallResult(
384         bool success,
385         bytes memory returndata,
386         string memory errorMessage
387     ) internal pure returns (bytes memory) {
388         if (success) {
389             return returndata;
390         } else {
391             // Look for revert reason and bubble it up if present
392             if (returndata.length > 0) {
393                 // The easiest way to bubble the revert reason is using memory via assembly
394 
395                 assembly {
396                     let returndata_size := mload(returndata)
397                     revert(add(32, returndata), returndata_size)
398                 }
399             } else {
400                 revert(errorMessage);
401             }
402         }
403     }
404 }
405 
406 abstract contract Context {
407     function _msgSender() internal view virtual returns (address) {
408         return msg.sender;
409     }
410 
411     function _msgData() internal view virtual returns (bytes calldata) {
412         return msg.data;
413     }
414 }
415 
416 library Strings {
417     bytes16 private constant _HEX_SYMBOLS = "0123456789abcdef";
418 
419     /**
420      * @dev Converts a `uint256` to its ASCII `string` decimal representation.
421      */
422     function toString(uint256 value) internal pure returns (string memory) {
423         // Inspired by OraclizeAPI's implementation - MIT licence
424         // https://github.com/oraclize/ethereum-api/blob/b42146b063c7d6ee1358846c198246239e9360e8/oraclizeAPI_0.4.25.sol
425 
426         if (value == 0) {
427             return "0";
428         }
429         uint256 temp = value;
430         uint256 digits;
431         while (temp != 0) {
432             digits++;
433             temp /= 10;
434         }
435         bytes memory buffer = new bytes(digits);
436         while (value != 0) {
437             digits -= 1;
438             buffer[digits] = bytes1(uint8(48 + uint256(value % 10)));
439             value /= 10;
440         }
441         return string(buffer);
442     }
443 
444     /**
445      * @dev Converts a `uint256` to its ASCII `string` hexadecimal representation.
446      */
447     function toHexString(uint256 value) internal pure returns (string memory) {
448         if (value == 0) {
449             return "0x00";
450         }
451         uint256 temp = value;
452         uint256 length = 0;
453         while (temp != 0) {
454             length++;
455             temp >>= 8;
456         }
457         return toHexString(value, length);
458     }
459 
460     /**
461      * @dev Converts a `uint256` to its ASCII `string` hexadecimal representation with fixed length.
462      */
463     function toHexString(uint256 value, uint256 length) internal pure returns (string memory) {
464         bytes memory buffer = new bytes(2 * length + 2);
465         buffer[0] = "0";
466         buffer[1] = "x";
467         for (uint256 i = 2 * length + 1; i > 1; --i) {
468             buffer[i] = _HEX_SYMBOLS[value & 0xf];
469             value >>= 4;
470         }
471         require(value == 0, "Strings: hex length insufficient");
472         return string(buffer);
473     }
474 }
475 contract ERC721 is Context, ERC165, IERC721, IERC721Metadata {
476     using Address for address;
477     using Strings for uint256;
478 
479     // Token name
480     string private _name;
481 
482     // Token symbol
483     string private _symbol;
484 
485     // Mapping from token ID to owner address
486     mapping(uint256 => address) private _owners;
487 
488     // Mapping owner address to token count
489     mapping(address => uint256) private _balances;
490 
491     // Mapping from token ID to approved address
492     mapping(uint256 => address) private _tokenApprovals;
493 
494     // Mapping from owner to operator approvals
495     mapping(address => mapping(address => bool)) private _operatorApprovals;
496 
497     /**
498      * @dev Initializes the contract by setting a `name` and a `symbol` to the token collection.
499      */
500     constructor(string memory name_, string memory symbol_) {
501         _name = name_;
502         _symbol = symbol_;
503     }
504 
505     /**
506      * @dev See {IERC165-supportsInterface}.
507      */
508     function supportsInterface(bytes4 interfaceId) public view virtual override(ERC165, IERC165) returns (bool) {
509         return
510             interfaceId == type(IERC721).interfaceId ||
511             interfaceId == type(IERC721Metadata).interfaceId ||
512             super.supportsInterface(interfaceId);
513     }
514 
515     /**
516      * @dev See {IERC721-balanceOf}.
517      */
518     function balanceOf(address owner) public view virtual override returns (uint256) {
519         require(owner != address(0), "ERC721: balance query for the zero address");
520         return _balances[owner];
521     }
522 
523     /**
524      * @dev See {IERC721-ownerOf}.
525      */
526     function ownerOf(uint256 tokenId) public view virtual override returns (address) {
527         address owner = _owners[tokenId];
528         require(owner != address(0), "ERC721: owner query for nonexistent token");
529         return owner;
530     }
531 
532     /**
533      * @dev See {IERC721Metadata-name}.
534      */
535     function name() public view virtual override returns (string memory) {
536         return _name;
537     }
538 
539     /**
540      * @dev See {IERC721Metadata-symbol}.
541      */
542     function symbol() public view virtual override returns (string memory) {
543         return _symbol;
544     }
545 
546     /**
547      * @dev See {IERC721Metadata-tokenURI}.
548      */
549     function tokenURI(uint256 tokenId) public view virtual override returns (string memory) {
550         require(_exists(tokenId), "ERC721Metadata: URI query for nonexistent token");
551 
552         string memory baseURI = _baseURI();
553         return bytes(baseURI).length > 0 ? string(abi.encodePacked(baseURI, tokenId.toString())) : "";
554     }
555 
556     /**
557      * @dev Base URI for computing {tokenURI}. If set, the resulting URI for each
558      * token will be the concatenation of the `baseURI` and the `tokenId`. Empty
559      * by default, can be overriden in child contracts.
560      */
561     function _baseURI() internal view virtual returns (string memory) {
562         return "";
563     }
564 
565     /**
566      * @dev See {IERC721-approve}.
567      */
568     function approve(address to, uint256 tokenId) public virtual override {
569         address owner = ERC721.ownerOf(tokenId);
570         require(to != owner, "ERC721: approval to current owner");
571 
572         require(
573             _msgSender() == owner || isApprovedForAll(owner, _msgSender()),
574             "ERC721: approve caller is not owner nor approved for all"
575         );
576 
577         _approve(to, tokenId);
578     }
579 
580     /**
581      * @dev See {IERC721-getApproved}.
582      */
583     function getApproved(uint256 tokenId) public view virtual override returns (address) {
584         require(_exists(tokenId), "ERC721: approved query for nonexistent token");
585 
586         return _tokenApprovals[tokenId];
587     }
588 
589     /**
590      * @dev See {IERC721-setApprovalForAll}.
591      */
592     function setApprovalForAll(address operator, bool approved) public virtual override {
593         require(operator != _msgSender(), "ERC721: approve to caller");
594 
595         _operatorApprovals[_msgSender()][operator] = approved;
596         emit ApprovalForAll(_msgSender(), operator, approved);
597     }
598 
599     /**
600      * @dev See {IERC721-isApprovedForAll}.
601      */
602     function isApprovedForAll(address owner, address operator) public view virtual override returns (bool) {
603         return _operatorApprovals[owner][operator];
604     }
605 
606     /**
607      * @dev See {IERC721-transferFrom}.
608      */
609     function transferFrom(
610         address from,
611         address to,
612         uint256 tokenId
613     ) public virtual override {
614         //solhint-disable-next-line max-line-length
615         require(_isApprovedOrOwner(_msgSender(), tokenId), "ERC721: transfer caller is not owner nor approved");
616 
617         _transfer(from, to, tokenId);
618     }
619 
620     /**
621      * @dev See {IERC721-safeTransferFrom}.
622      */
623     function safeTransferFrom(
624         address from,
625         address to,
626         uint256 tokenId
627     ) public virtual override {
628         safeTransferFrom(from, to, tokenId, "");
629     }
630 
631     /**
632      * @dev See {IERC721-safeTransferFrom}.
633      */
634     function safeTransferFrom(
635         address from,
636         address to,
637         uint256 tokenId,
638         bytes memory _data
639     ) public virtual override {
640         require(_isApprovedOrOwner(_msgSender(), tokenId), "ERC721: transfer caller is not owner nor approved");
641         _safeTransfer(from, to, tokenId, _data);
642     }
643 
644     /**
645      * @dev Safely transfers `tokenId` token from `from` to `to`, checking first that contract recipients
646      * are aware of the ERC721 protocol to prevent tokens from being forever locked.
647      *
648      * `_data` is additional data, it has no specified format and it is sent in call to `to`.
649      *
650      * This internal function is equivalent to {safeTransferFrom}, and can be used to e.g.
651      * implement alternative mechanisms to perform token transfer, such as signature-based.
652      *
653      * Requirements:
654      *
655      * - `from` cannot be the zero address.
656      * - `to` cannot be the zero address.
657      * - `tokenId` token must exist and be owned by `from`.
658      * - If `to` refers to a smart contract, it must implement {IERC721Receiver-onERC721Received}, which is called upon a safe transfer.
659      *
660      * Emits a {Transfer} event.
661      */
662     function _safeTransfer(
663         address from,
664         address to,
665         uint256 tokenId,
666         bytes memory _data
667     ) internal virtual {
668         _transfer(from, to, tokenId);
669         require(_checkOnERC721Received(from, to, tokenId, _data), "ERC721: transfer to non ERC721Receiver implementer");
670     }
671 
672     /**
673      * @dev Returns whether `tokenId` exists.
674      *
675      * Tokens can be managed by their owner or approved accounts via {approve} or {setApprovalForAll}.
676      *
677      * Tokens start existing when they are minted (`_mint`),
678      * and stop existing when they are burned (`_burn`).
679      */
680     function _exists(uint256 tokenId) internal view virtual returns (bool) {
681         return _owners[tokenId] != address(0);
682     }
683 
684     /**
685      * @dev Returns whether `spender` is allowed to manage `tokenId`.
686      *
687      * Requirements:
688      *
689      * - `tokenId` must exist.
690      */
691     function _isApprovedOrOwner(address spender, uint256 tokenId) internal view virtual returns (bool) {
692         require(_exists(tokenId), "ERC721: operator query for nonexistent token");
693         address owner = ERC721.ownerOf(tokenId);
694         return (spender == owner || getApproved(tokenId) == spender || isApprovedForAll(owner, spender));
695     }
696 
697     /**
698      * @dev Safely mints `tokenId` and transfers it to `to`.
699      *
700      * Requirements:
701      *
702      * - `tokenId` must not exist.
703      * - If `to` refers to a smart contract, it must implement {IERC721Receiver-onERC721Received}, which is called upon a safe transfer.
704      *
705      * Emits a {Transfer} event.
706      */
707     function _safeMint(address to, uint256 tokenId) internal virtual {
708         _safeMint(to, tokenId, "");
709     }
710 
711     /**
712      * @dev Same as {xref-ERC721-_safeMint-address-uint256-}[`_safeMint`], with an additional `data` parameter which is
713      * forwarded in {IERC721Receiver-onERC721Received} to contract recipients.
714      */
715     function _safeMint(
716         address to,
717         uint256 tokenId,
718         bytes memory _data
719     ) internal virtual {
720         _mint(to, tokenId);
721         require(
722             _checkOnERC721Received(address(0), to, tokenId, _data),
723             "ERC721: transfer to non ERC721Receiver implementer"
724         );
725     }
726 
727     /**
728      * @dev Mints `tokenId` and transfers it to `to`.
729      *
730      * WARNING: Usage of this method is discouraged, use {_safeMint} whenever possible
731      *
732      * Requirements:
733      *
734      * - `tokenId` must not exist.
735      * - `to` cannot be the zero address.
736      *
737      * Emits a {Transfer} event.
738      */
739     function _mint(address to, uint256 tokenId) internal virtual {
740         require(to != address(0), "ERC721: mint to the zero address");
741         require(!_exists(tokenId), "ERC721: token already minted");
742 
743         _beforeTokenTransfer(address(0), to, tokenId);
744 
745         _balances[to] += 1;
746         _owners[tokenId] = to;
747 
748         emit Transfer(address(0), to, tokenId);
749     }
750 
751     /**
752      * @dev Destroys `tokenId`.
753      * The approval is cleared when the token is burned.
754      *
755      * Requirements:
756      *
757      * - `tokenId` must exist.
758      *
759      * Emits a {Transfer} event.
760      */
761     function _burn(uint256 tokenId) internal virtual {
762         address owner = ERC721.ownerOf(tokenId);
763 
764         _beforeTokenTransfer(owner, address(0), tokenId);
765 
766         // Clear approvals
767         _approve(address(0), tokenId);
768 
769         _balances[owner] -= 1;
770         delete _owners[tokenId];
771 
772         emit Transfer(owner, address(0), tokenId);
773     }
774 
775     /**
776      * @dev Transfers `tokenId` from `from` to `to`.
777      *  As opposed to {transferFrom}, this imposes no restrictions on msg.sender.
778      *
779      * Requirements:
780      *
781      * - `to` cannot be the zero address.
782      * - `tokenId` token must be owned by `from`.
783      *
784      * Emits a {Transfer} event.
785      */
786     function _transfer(
787         address from,
788         address to,
789         uint256 tokenId
790     ) internal virtual {
791         require(ERC721.ownerOf(tokenId) == from, "ERC721: transfer of token that is not own");
792         require(to != address(0), "ERC721: transfer to the zero address");
793 
794         _beforeTokenTransfer(from, to, tokenId);
795 
796         // Clear approvals from the previous owner
797         _approve(address(0), tokenId);
798 
799         _balances[from] -= 1;
800         _balances[to] += 1;
801         _owners[tokenId] = to;
802 
803         emit Transfer(from, to, tokenId);
804     }
805 
806     /**
807      * @dev Approve `to` to operate on `tokenId`
808      *
809      * Emits a {Approval} event.
810      */
811     function _approve(address to, uint256 tokenId) internal virtual {
812         _tokenApprovals[tokenId] = to;
813         emit Approval(ERC721.ownerOf(tokenId), to, tokenId);
814     }
815 
816     /**
817      * @dev Internal function to invoke {IERC721Receiver-onERC721Received} on a target address.
818      * The call is not executed if the target address is not a contract.
819      *
820      * @param from address representing the previous owner of the given token ID
821      * @param to target address that will receive the tokens
822      * @param tokenId uint256 ID of the token to be transferred
823      * @param _data bytes optional data to send along with the call
824      * @return bool whether the call correctly returned the expected magic value
825      */
826     function _checkOnERC721Received(
827         address from,
828         address to,
829         uint256 tokenId,
830         bytes memory _data
831     ) private returns (bool) {
832         if (to.isContract()) {
833             try IERC721Receiver(to).onERC721Received(_msgSender(), from, tokenId, _data) returns (bytes4 retval) {
834                 return retval == IERC721Receiver.onERC721Received.selector;
835             } catch (bytes memory reason) {
836                 if (reason.length == 0) {
837                     revert("ERC721: transfer to non ERC721Receiver implementer");
838                 } else {
839                     assembly {
840                         revert(add(32, reason), mload(reason))
841                     }
842                 }
843             }
844         } else {
845             return true;
846         }
847     }
848 
849     /**
850      * @dev Hook that is called before any token transfer. This includes minting
851      * and burning.
852      *
853      * Calling conditions:
854      *
855      * - When `from` and `to` are both non-zero, ``from``'s `tokenId` will be
856      * transferred to `to`.
857      * - When `from` is zero, `tokenId` will be minted for `to`.
858      * - When `to` is zero, ``from``'s `tokenId` will be burned.
859      * - `from` and `to` are never both zero.
860      *
861      * To learn more about hooks, head to xref:ROOT:extending-contracts.adoc#using-hooks[Using Hooks].
862      */
863     function _beforeTokenTransfer(
864         address from,
865         address to,
866         uint256 tokenId
867     ) internal virtual {}
868 }
869 
870 interface IERC721Enumerable is IERC721 {
871     /**
872      * @dev Returns the total amount of tokens stored by the contract.
873      */
874     function totalSupply() external view returns (uint256);
875 
876     /**
877      * @dev Returns a token ID owned by `owner` at a given `index` of its token list.
878      * Use along with {balanceOf} to enumerate all of ``owner``'s tokens.
879      */
880     function tokenOfOwnerByIndex(address owner, uint256 index) external view returns (uint256 tokenId);
881 
882     /**
883      * @dev Returns a token ID at a given `index` of all the tokens stored by the contract.
884      * Use along with {totalSupply} to enumerate all tokens.
885      */
886     function tokenByIndex(uint256 index) external view returns (uint256);
887 }
888 
889 
890 abstract contract ERC721Enumerable is ERC721, IERC721Enumerable {
891     // Mapping from owner to list of owned token IDs
892     mapping(address => mapping(uint256 => uint256)) private _ownedTokens;
893 
894     // Mapping from token ID to index of the owner tokens list
895     mapping(uint256 => uint256) private _ownedTokensIndex;
896 
897     // Array with all token ids, used for enumeration
898     uint256[] private _allTokens;
899 
900     // Mapping from token id to position in the allTokens array
901     mapping(uint256 => uint256) private _allTokensIndex;
902 
903     /**
904      * @dev See {IERC165-supportsInterface}.
905      */
906     function supportsInterface(bytes4 interfaceId) public view virtual override(IERC165, ERC721) returns (bool) {
907         return interfaceId == type(IERC721Enumerable).interfaceId || super.supportsInterface(interfaceId);
908     }
909 
910     /**
911      * @dev See {IERC721Enumerable-tokenOfOwnerByIndex}.
912      */
913     function tokenOfOwnerByIndex(address owner, uint256 index) public view virtual override returns (uint256) {
914         require(index < ERC721.balanceOf(owner), "ERC721Enumerable: owner index out of bounds");
915         return _ownedTokens[owner][index];
916     }
917 
918     /**
919      * @dev See {IERC721Enumerable-totalSupply}.
920      */
921     function totalSupply() public view virtual override returns (uint256) {
922         return _allTokens.length;
923     }
924 
925     /**
926      * @dev See {IERC721Enumerable-tokenByIndex}.
927      */
928     function tokenByIndex(uint256 index) public view virtual override returns (uint256) {
929         require(index < ERC721Enumerable.totalSupply(), "ERC721Enumerable: global index out of bounds");
930         return _allTokens[index];
931     }
932 
933     /**
934      * @dev Hook that is called before any token transfer. This includes minting
935      * and burning.
936      *
937      * Calling conditions:
938      *
939      * - When `from` and `to` are both non-zero, ``from``'s `tokenId` will be
940      * transferred to `to`.
941      * - When `from` is zero, `tokenId` will be minted for `to`.
942      * - When `to` is zero, ``from``'s `tokenId` will be burned.
943      * - `from` cannot be the zero address.
944      * - `to` cannot be the zero address.
945      *
946      * To learn more about hooks, head to xref:ROOT:extending-contracts.adoc#using-hooks[Using Hooks].
947      */
948     function _beforeTokenTransfer(
949         address from,
950         address to,
951         uint256 tokenId
952     ) internal virtual override {
953         super._beforeTokenTransfer(from, to, tokenId);
954 
955         if (from == address(0)) {
956             _addTokenToAllTokensEnumeration(tokenId);
957         } else if (from != to) {
958             _removeTokenFromOwnerEnumeration(from, tokenId);
959         }
960         if (to == address(0)) {
961             _removeTokenFromAllTokensEnumeration(tokenId);
962         } else if (to != from) {
963             _addTokenToOwnerEnumeration(to, tokenId);
964         }
965     }
966 
967     /**
968      * @dev Private function to add a token to this extension's ownership-tracking data structures.
969      * @param to address representing the new owner of the given token ID
970      * @param tokenId uint256 ID of the token to be added to the tokens list of the given address
971      */
972     function _addTokenToOwnerEnumeration(address to, uint256 tokenId) private {
973         uint256 length = ERC721.balanceOf(to);
974         _ownedTokens[to][length] = tokenId;
975         _ownedTokensIndex[tokenId] = length;
976     }
977 
978     /**
979      * @dev Private function to add a token to this extension's token tracking data structures.
980      * @param tokenId uint256 ID of the token to be added to the tokens list
981      */
982     function _addTokenToAllTokensEnumeration(uint256 tokenId) private {
983         _allTokensIndex[tokenId] = _allTokens.length;
984         _allTokens.push(tokenId);
985     }
986 
987     /**
988      * @dev Private function to remove a token from this extension's ownership-tracking data structures. Note that
989      * while the token is not assigned a new owner, the `_ownedTokensIndex` mapping is _not_ updated: this allows for
990      * gas optimizations e.g. when performing a transfer operation (avoiding double writes).
991      * This has O(1) time complexity, but alters the order of the _ownedTokens array.
992      * @param from address representing the previous owner of the given token ID
993      * @param tokenId uint256 ID of the token to be removed from the tokens list of the given address
994      */
995     function _removeTokenFromOwnerEnumeration(address from, uint256 tokenId) private {
996         // To prevent a gap in from's tokens array, we store the last token in the index of the token to delete, and
997         // then delete the last slot (swap and pop).
998 
999         uint256 lastTokenIndex = ERC721.balanceOf(from) - 1;
1000         uint256 tokenIndex = _ownedTokensIndex[tokenId];
1001 
1002         // When the token to delete is the last token, the swap operation is unnecessary
1003         if (tokenIndex != lastTokenIndex) {
1004             uint256 lastTokenId = _ownedTokens[from][lastTokenIndex];
1005 
1006             _ownedTokens[from][tokenIndex] = lastTokenId; // Move the last token to the slot of the to-delete token
1007             _ownedTokensIndex[lastTokenId] = tokenIndex; // Update the moved token's index
1008         }
1009 
1010         // This also deletes the contents at the last position of the array
1011         delete _ownedTokensIndex[tokenId];
1012         delete _ownedTokens[from][lastTokenIndex];
1013     }
1014 
1015     /**
1016      * @dev Private function to remove a token from this extension's token tracking data structures.
1017      * This has O(1) time complexity, but alters the order of the _allTokens array.
1018      * @param tokenId uint256 ID of the token to be removed from the tokens list
1019      */
1020     function _removeTokenFromAllTokensEnumeration(uint256 tokenId) private {
1021         // To prevent a gap in the tokens array, we store the last token in the index of the token to delete, and
1022         // then delete the last slot (swap and pop).
1023 
1024         uint256 lastTokenIndex = _allTokens.length - 1;
1025         uint256 tokenIndex = _allTokensIndex[tokenId];
1026 
1027         // When the token to delete is the last token, the swap operation is unnecessary. However, since this occurs so
1028         // rarely (when the last minted token is burnt) that we still do the swap here to avoid the gas cost of adding
1029         // an 'if' statement (like in _removeTokenFromOwnerEnumeration)
1030         uint256 lastTokenId = _allTokens[lastTokenIndex];
1031 
1032         _allTokens[tokenIndex] = lastTokenId; // Move the last token to the slot of the to-delete token
1033         _allTokensIndex[lastTokenId] = tokenIndex; // Update the moved token's index
1034 
1035         // This also deletes the contents at the last position of the array
1036         delete _allTokensIndex[tokenId];
1037         _allTokens.pop();
1038     }
1039 }
1040 
1041 abstract contract ERC721URIStorage is ERC721 {
1042     using Strings for uint256;
1043 
1044     // Optional mapping for token URIs
1045     mapping(uint256 => string) private _tokenURIs;
1046 
1047     /**
1048      * @dev See {IERC721Metadata-tokenURI}.
1049      */
1050     function tokenURI(uint256 tokenId) public view virtual override returns (string memory) {
1051         require(_exists(tokenId), "ERC721URIStorage: URI query for nonexistent token");
1052 
1053         string memory _tokenURI = _tokenURIs[tokenId];
1054         string memory base = _baseURI();
1055 
1056         // If there is no base URI, return the token URI.
1057         if (bytes(base).length == 0) {
1058             return _tokenURI;
1059         }
1060         // If both are set, concatenate the baseURI and tokenURI (via abi.encodePacked).
1061         if (bytes(_tokenURI).length > 0) {
1062             return string(abi.encodePacked(base, _tokenURI));
1063         }
1064 
1065         return super.tokenURI(tokenId);
1066     }
1067 
1068     /**
1069      * @dev Sets `_tokenURI` as the tokenURI of `tokenId`.
1070      *
1071      * Requirements:
1072      *
1073      * - `tokenId` must exist.
1074      */
1075     function _setTokenURI(uint256 tokenId, string memory _tokenURI) internal virtual {
1076         require(_exists(tokenId), "ERC721URIStorage: URI set of nonexistent token");
1077         _tokenURIs[tokenId] = _tokenURI;
1078     }
1079 
1080     /**
1081      * @dev Destroys `tokenId`.
1082      * The approval is cleared when the token is burned.
1083      *
1084      * Requirements:
1085      *
1086      * - `tokenId` must exist.
1087      *
1088      * Emits a {Transfer} event.
1089      */
1090     function _burn(uint256 tokenId) internal virtual override {
1091         super._burn(tokenId);
1092 
1093         if (bytes(_tokenURIs[tokenId]).length != 0) {
1094             delete _tokenURIs[tokenId];
1095         }
1096     }
1097 }
1098 
1099 abstract contract Ownable is Context {
1100     address private _owner;
1101 
1102     event OwnershipTransferred(address indexed previousOwner, address indexed newOwner);
1103 
1104     /**
1105      * @dev Initializes the contract setting the deployer as the initial owner.
1106      */
1107     constructor() {
1108         _setOwner(_msgSender());
1109     }
1110 
1111     /**
1112      * @dev Returns the address of the current owner.
1113      */
1114     function owner() public view virtual returns (address) {
1115         return _owner;
1116     }
1117 
1118     /**
1119      * @dev Throws if called by any account other than the owner.
1120      */
1121     modifier onlyOwner() {
1122         require(owner() == _msgSender(), "Ownable: caller is not the owner");
1123         _;
1124     }
1125 
1126     /**
1127      * @dev Leaves the contract without owner. It will not be possible to call
1128      * `onlyOwner` functions anymore. Can only be called by the current owner.
1129      *
1130      * NOTE: Renouncing ownership will leave the contract without an owner,
1131      * thereby removing any functionality that is only available to the owner.
1132      */
1133     function renounceOwnership() public virtual onlyOwner {
1134         _setOwner(address(0));
1135     }
1136 
1137     /**
1138      * @dev Transfers ownership of the contract to a new account (`newOwner`).
1139      * Can only be called by the current owner.
1140      */
1141     function transferOwnership(address newOwner) public virtual onlyOwner {
1142         require(newOwner != address(0), "Ownable: new owner is the zero address");
1143         _setOwner(newOwner);
1144     }
1145 
1146     function _setOwner(address newOwner) private {
1147         address oldOwner = _owner;
1148         _owner = newOwner;
1149         emit OwnershipTransferred(oldOwner, newOwner);
1150     }
1151 }
1152 
1153 abstract contract Pausable is Context {
1154     /**
1155      * @dev Emitted when the pause is triggered by `account`.
1156      */
1157     event Paused(address account);
1158 
1159     /**
1160      * @dev Emitted when the pause is lifted by `account`.
1161      */
1162     event Unpaused(address account);
1163 
1164     bool private _paused;
1165 
1166     /**
1167      * @dev Initializes the contract in unpaused state.
1168      */
1169     constructor() {
1170         _paused = false;
1171     }
1172 
1173     /**
1174      * @dev Returns true if the contract is paused, and false otherwise.
1175      */
1176     function paused() public view virtual returns (bool) {
1177         return _paused;
1178     }
1179 
1180     /**
1181      * @dev Modifier to make a function callable only when the contract is not paused.
1182      *
1183      * Requirements:
1184      *
1185      * - The contract must not be paused.
1186      */
1187     modifier whenNotPaused() {
1188         require(!paused(), "Pausable: paused");
1189         _;
1190     }
1191 
1192     /**
1193      * @dev Modifier to make a function callable only when the contract is paused.
1194      *
1195      * Requirements:
1196      *
1197      * - The contract must be paused.
1198      */
1199     modifier whenPaused() {
1200         require(paused(), "Pausable: not paused");
1201         _;
1202     }
1203 
1204     /**
1205      * @dev Triggers stopped state.
1206      *
1207      * Requirements:
1208      *
1209      * - The contract must not be paused.
1210      */
1211     function _pause() internal virtual whenNotPaused {
1212         _paused = true;
1213         emit Paused(_msgSender());
1214     }
1215 
1216     /**
1217      * @dev Returns to normal state.
1218      *
1219      * Requirements:
1220      *
1221      * - The contract must be paused.
1222      */
1223     function _unpause() internal virtual whenPaused {
1224         _paused = false;
1225         emit Unpaused(_msgSender());
1226     }
1227 }
1228 
1229 abstract contract ERC721Burnable is Context, ERC721 {
1230     /**
1231      * @dev Burns `tokenId`. See {ERC721-_burn}.
1232      *
1233      * Requirements:
1234      *
1235      * - The caller must own `tokenId` or be an approved operator.
1236      */
1237     function burn(uint256 tokenId) public virtual {
1238         //solhint-disable-next-line max-line-length
1239         require(_isApprovedOrOwner(_msgSender(), tokenId), "ERC721Burnable: caller is not owner nor approved");
1240         _burn(tokenId);
1241     }
1242 }
1243 
1244 contract Sst is ERC721,ERC721Enumerable,ERC721URIStorage, Ownable, Pausable, ERC721Burnable {
1245     using Address for address;
1246     uint256 private _price = 0.075 ether;
1247     address a1 = 0x4d6a6E6cF080Fb3E7f611aC22B601D8EdfcF1bCB;
1248                  
1249 
1250     uint256 private _reserved = 100;
1251     uint256 private _supplylimit = 10;
1252     string private _base_url = 'https://koingames.s3.amazonaws.com/UBIW1OT08AE/NFT_META/';
1253     string private _ext = '.json';
1254     bool private _change = false;
1255      
1256     mapping (address => bool) private whitelist;
1257       
1258       
1259     
1260 
1261     constructor() ERC721("Video Game Dev Squad", "VGDS") {}
1262   
1263 
1264    
1265     function isWhitelisted(address _address) public view returns (bool) {
1266         return whitelist[_address];
1267     }
1268     
1269     
1270     function switchWhiteListOn(bool change) public onlyOwner
1271     {
1272         _change = change;
1273     }
1274     
1275     
1276      function addAddress(address _address) public onlyOwner
1277     {
1278         if (whitelist[_address]) 
1279             return;
1280 
1281         whitelist[_address] = true;
1282        
1283     }
1284     
1285     
1286      function whitelistAddress (address[] memory users) public onlyOwner {
1287         for (uint i = 0; i < users.length; i++) {
1288             whitelist[users[i]] = true;
1289         }
1290     }
1291 
1292 
1293     function setPrice(uint256 _newPrice) public onlyOwner() {
1294         _price = _newPrice;
1295     }
1296     
1297     function setSupplyLimit(uint256 _newLimit) public onlyOwner() {
1298         _supplylimit = _newLimit;
1299     }
1300     
1301      function setUri(string memory _newUri) public onlyOwner() {
1302         _base_url = _newUri;
1303     }
1304     
1305       function setMUri(uint256 _id,string memory _newUri) public onlyOwner() {
1306        
1307         
1308         _setTokenURI(_id, _newUri);
1309     }
1310     
1311        function makeNFT(uint256 num) public payable  {
1312          
1313        uint256 supply = totalSupply();
1314         
1315         require( num <= _supplylimit, "You have exceeded maximum mint" );
1316         require( supply + num < 5555 - _reserved,  "Exceeds maximum  supply" );
1317         require( msg.value >= _price * num,  "Ether sent is not correct" );
1318         if(_change == true)
1319         {
1320         require(isWhitelisted(msg.sender), "Not on whitelist");
1321         }
1322 
1323         for(uint256 i; i < num; i++){
1324            
1325         string memory base = string(abi.encodePacked(_base_url, Strings.toString(supply  + i),_ext));
1326     
1327         _safeMint( msg.sender, supply + i );
1328         _setTokenURI(supply + i, base);
1329            
1330       }
1331     }
1332  
1333       function pause() public onlyOwner {
1334         _pause();
1335       }
1336 
1337     function unpause() public onlyOwner {
1338         _unpause();
1339       }
1340  
1341      function getPrice() public view returns (uint256){
1342         return _price;
1343      }
1344     
1345     function getSupplyLimit() public view returns (uint256){
1346         return _supplylimit;
1347     }
1348     
1349      function getUri() public view returns (string memory){
1350         return _base_url;
1351     }
1352     
1353     function checkWhitelist() public view returns (bool){
1354         return _change;
1355     }
1356     
1357     
1358     
1359     function withdrawAll() public payable onlyOwner {
1360         uint256 _each = address(this).balance / 1;
1361         require(payable(a1).send(_each));
1362          
1363        
1364     }
1365     
1366     
1367     function _beforeTokenTransfer(address from, address to, uint256 tokenId)
1368         internal
1369         whenNotPaused
1370         override(ERC721, ERC721Enumerable)
1371     {
1372         super._beforeTokenTransfer(from, to, tokenId);
1373     }
1374     
1375     function _burn(uint256 tokenId) internal override(ERC721, ERC721URIStorage) {
1376         super._burn(tokenId);
1377     }
1378     
1379     function tokenURI(uint256 tokenId)
1380         public
1381         view
1382         override(ERC721, ERC721URIStorage)
1383         returns (string memory)
1384     {
1385         return super.tokenURI(tokenId);
1386     }
1387     
1388     function removeAddress(address _address) public onlyOwner {
1389         if (!whitelist[_address]) 
1390             return;
1391 
1392         whitelist[_address] = false;
1393     }
1394 
1395 function walletOfOwner(address _owner) external view returns (uint256[] memory) {
1396         uint256 tokenCount = balanceOf(_owner);
1397 
1398         uint256[] memory tokensId = new uint256[](tokenCount);
1399         for (uint256 i = 0; i < tokenCount; i++) {
1400             tokensId[i] = tokenOfOwnerByIndex(_owner, i);
1401         }
1402 
1403         return tokensId;
1404     }
1405     
1406     
1407      function reserve(address _to, uint256 num) external onlyOwner() {
1408         uint256 supply = totalSupply();
1409         uint256 _lim = 200;
1410         require( num <= _lim, "You have exceeded maximum mint" );
1411        
1412         for(uint256 i; i < num; i++){
1413            
1414         string memory base = string(abi.encodePacked(_base_url, Strings.toString(supply  + i),_ext));
1415     
1416          _safeMint( _to, supply + i );
1417          _setTokenURI(supply + i, base);
1418       
1419        }
1420       
1421       }
1422     
1423    
1424     
1425     function supportsInterface(bytes4 interfaceId)
1426         public
1427         view
1428         override(ERC721, ERC721Enumerable)
1429         returns (bool)
1430     {
1431         return super.supportsInterface(interfaceId);
1432     }
1433 }