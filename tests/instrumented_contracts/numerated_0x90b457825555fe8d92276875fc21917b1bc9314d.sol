1 pragma solidity ^0.8.0;
2 
3 interface IERC165 {
4     /**
5      * @dev Returns true if this contract implements the interface defined by
6      * `interfaceId`. See the corresponding
7      * https://eips.ethereum.org/EIPS/eip-165#how-interfaces-are-identified[EIP section]
8      * to learn more about how these ids are created.
9      *
10      * This function call must use less than 30 000 gas.
11      */
12     function supportsInterface(bytes4 interfaceId) external view returns (bool);
13 }
14 
15 interface IERC721 is IERC165 {
16     /**
17      * @dev Emitted when `tokenId` token is transferred from `from` to `to`.
18      */
19     event Transfer(address indexed from, address indexed to, uint256 indexed tokenId);
20 
21     /**
22      * @dev Emitted when `owner` enables `approved` to manage the `tokenId` token.
23      */
24     event Approval(address indexed owner, address indexed approved, uint256 indexed tokenId);
25 
26     /**
27      * @dev Emitted when `owner` enables or disables (`approved`) `operator` to manage all of its assets.
28      */
29     event ApprovalForAll(address indexed owner, address indexed operator, bool approved);
30 
31     /**
32      * @dev Returns the number of tokens in ``owner``'s account.
33      */
34     function balanceOf(address owner) external view returns (uint256 balance);
35 
36     /**
37      * @dev Returns the owner of the `tokenId` token.
38      *
39      * Requirements:
40      *
41      * - `tokenId` must exist.
42      */
43     function ownerOf(uint256 tokenId) external view returns (address owner);
44 
45     /**
46      * @dev Safely transfers `tokenId` token from `from` to `to`, checking first that contract recipients
47      * are aware of the ERC721 protocol to prevent tokens from being forever locked.
48      *
49      * Requirements:
50      *
51      * - `from` cannot be the zero address.
52      * - `to` cannot be the zero address.
53      * - `tokenId` token must exist and be owned by `from`.
54      * - If the caller is not `from`, it must be have been allowed to move this token by either {approve} or {setApprovalForAll}.
55      * - If `to` refers to a smart contract, it must implement {IERC721Receiver-onERC721Received}, which is called upon a safe transfer.
56      *
57      * Emits a {Transfer} event.
58      */
59     function safeTransferFrom(
60         address from,
61         address to,
62         uint256 tokenId
63     ) external;
64 
65     /**
66      * @dev Transfers `tokenId` token from `from` to `to`.
67      *
68      * WARNING: Usage of this method is discouraged, use {safeTransferFrom} whenever possible.
69      *
70      * Requirements:
71      *
72      * - `from` cannot be the zero address.
73      * - `to` cannot be the zero address.
74      * - `tokenId` token must be owned by `from`.
75      * - If the caller is not `from`, it must be approved to move this token by either {approve} or {setApprovalForAll}.
76      *
77      * Emits a {Transfer} event.
78      */
79     function transferFrom(
80         address from,
81         address to,
82         uint256 tokenId
83     ) external;
84 
85     /**
86      * @dev Gives permission to `to` to transfer `tokenId` token to another account.
87      * The approval is cleared when the token is transferred.
88      *
89      * Only a single account can be approved at a time, so approving the zero address clears previous approvals.
90      *
91      * Requirements:
92      *
93      * - The caller must own the token or be an approved operator.
94      * - `tokenId` must exist.
95      *
96      * Emits an {Approval} event.
97      */
98     function approve(address to, uint256 tokenId) external;
99 
100     /**
101      * @dev Returns the account approved for `tokenId` token.
102      *
103      * Requirements:
104      *
105      * - `tokenId` must exist.
106      */
107     function getApproved(uint256 tokenId) external view returns (address operator);
108 
109     /**
110      * @dev Approve or remove `operator` as an operator for the caller.
111      * Operators can call {transferFrom} or {safeTransferFrom} for any token owned by the caller.
112      *
113      * Requirements:
114      *
115      * - The `operator` cannot be the caller.
116      *
117      * Emits an {ApprovalForAll} event.
118      */
119     function setApprovalForAll(address operator, bool _approved) external;
120 
121     /**
122      * @dev Returns if the `operator` is allowed to manage all of the assets of `owner`.
123      *
124      * See {setApprovalForAll}
125      */
126     function isApprovedForAll(address owner, address operator) external view returns (bool);
127 
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
148 
149 abstract contract ERC165 is IERC165 {
150     /**
151      * @dev See {IERC165-supportsInterface}.
152      */
153     function supportsInterface(bytes4 interfaceId) public view virtual override returns (bool) {
154         return interfaceId == type(IERC165).interfaceId;
155     }
156 }
157 
158 interface IERC721Receiver {
159     /**
160      * @dev Whenever an {IERC721} `tokenId` token is transferred to this contract via {IERC721-safeTransferFrom}
161      * by `operator` from `from`, this function is called.
162      *
163      * It must return its Solidity selector to confirm the token transfer.
164      * If any other value is returned or the interface is not implemented by the recipient, the transfer will be reverted.
165      *
166      * The selector can be obtained in Solidity with `IERC721.onERC721Received.selector`.
167      */
168     function onERC721Received(
169         address operator,
170         address from,
171         uint256 tokenId,
172         bytes calldata data
173     ) external returns (bytes4);
174 }
175 
176 interface IERC721Metadata is IERC721 {
177     /**
178      * @dev Returns the token collection name.
179      */
180     function name() external view returns (string memory);
181 
182     /**
183      * @dev Returns the token collection symbol.
184      */
185     function symbol() external view returns (string memory);
186 
187     /**
188      * @dev Returns the Uniform Resource Identifier (URI) for `tokenId` token.
189      */
190     function tokenURI(uint256 tokenId) external view returns (string memory);
191 }
192 
193 library Address {
194     /**
195      * @dev Returns true if `account` is a contract.
196      *
197      * [IMPORTANT]
198      * ====
199      * It is unsafe to assume that an address for which this function returns
200      * false is an externally-owned account (EOA) and not a contract.
201      *
202      * Among others, `isContract` will return false for the following
203      * types of addresses:
204      *
205      *  - an externally-owned account
206      *  - a contract in construction
207      *  - an address where a contract will be created
208      *  - an address where a contract lived, but was destroyed
209      * ====
210      */
211     function isContract(address account) internal view returns (bool) {
212         // This method relies on extcodesize, which returns 0 for contracts in
213         // construction, since the code is only stored at the end of the
214         // constructor execution.
215 
216         uint256 size;
217         assembly {
218             size := extcodesize(account)
219         }
220         return size > 0;
221     }
222 
223     /**
224      * @dev Replacement for Solidity's `transfer`: sends `amount` wei to
225      * `recipient`, forwarding all available gas and reverting on errors.
226      *
227      * https://eips.ethereum.org/EIPS/eip-1884[EIP1884] increases the gas cost
228      * of certain opcodes, possibly making contracts go over the 2300 gas limit
229      * imposed by `transfer`, making them unable to receive funds via
230      * `transfer`. {sendValue} removes this limitation.
231      *
232      * https://diligence.consensys.net/posts/2019/09/stop-using-soliditys-transfer-now/[Learn more].
233      *
234      * IMPORTANT: because control is transferred to `recipient`, care must be
235      * taken to not create reentrancy vulnerabilities. Consider using
236      * {ReentrancyGuard} or the
237      * https://solidity.readthedocs.io/en/v0.5.11/security-considerations.html#use-the-checks-effects-interactions-pattern[checks-effects-interactions pattern].
238      */
239     function sendValue(address payable recipient, uint256 amount) internal {
240         require(address(this).balance >= amount, "Address: insufficient balance");
241 
242         (bool success, ) = recipient.call{value: amount}("");
243         require(success, "Address: unable to send value, recipient may have reverted");
244     }
245 
246     /**
247      * @dev Performs a Solidity function call using a low level `call`. A
248      * plain `call` is an unsafe replacement for a function call: use this
249      * function instead.
250      *
251      * If `target` reverts with a revert reason, it is bubbled up by this
252      * function (like regular Solidity function calls).
253      *
254      * Returns the raw returned data. To convert to the expected return value,
255      * use https://solidity.readthedocs.io/en/latest/units-and-global-variables.html?highlight=abi.decode#abi-encoding-and-decoding-functions[`abi.decode`].
256      *
257      * Requirements:
258      *
259      * - `target` must be a contract.
260      * - calling `target` with `data` must not revert.
261      *
262      * _Available since v3.1._
263      */
264     function functionCall(address target, bytes memory data) internal returns (bytes memory) {
265         return functionCall(target, data, "Address: low-level call failed");
266     }
267 
268     /**
269      * @dev Same as {xref-Address-functionCall-address-bytes-}[`functionCall`], but with
270      * `errorMessage` as a fallback revert reason when `target` reverts.
271      *
272      * _Available since v3.1._
273      */
274     function functionCall(
275         address target,
276         bytes memory data,
277         string memory errorMessage
278     ) internal returns (bytes memory) {
279         return functionCallWithValue(target, data, 0, errorMessage);
280     }
281 
282     /**
283      * @dev Same as {xref-Address-functionCall-address-bytes-}[`functionCall`],
284      * but also transferring `value` wei to `target`.
285      *
286      * Requirements:
287      *
288      * - the calling contract must have an ETH balance of at least `value`.
289      * - the called Solidity function must be `payable`.
290      *
291      * _Available since v3.1._
292      */
293     function functionCallWithValue(
294         address target,
295         bytes memory data,
296         uint256 value
297     ) internal returns (bytes memory) {
298         return functionCallWithValue(target, data, value, "Address: low-level call with value failed");
299     }
300 
301     /**
302      * @dev Same as {xref-Address-functionCallWithValue-address-bytes-uint256-}[`functionCallWithValue`], but
303      * with `errorMessage` as a fallback revert reason when `target` reverts.
304      *
305      * _Available since v3.1._
306      */
307     function functionCallWithValue(
308         address target,
309         bytes memory data,
310         uint256 value,
311         string memory errorMessage
312     ) internal returns (bytes memory) {
313         require(address(this).balance >= value, "Address: insufficient balance for call");
314         require(isContract(target), "Address: call to non-contract");
315 
316         (bool success, bytes memory returndata) = target.call{value: value}(data);
317         return verifyCallResult(success, returndata, errorMessage);
318     }
319 
320     /**
321      * @dev Same as {xref-Address-functionCall-address-bytes-}[`functionCall`],
322      * but performing a static call.
323      *
324      * _Available since v3.3._
325      */
326     function functionStaticCall(address target, bytes memory data) internal view returns (bytes memory) {
327         return functionStaticCall(target, data, "Address: low-level static call failed");
328     }
329 
330     /**
331      * @dev Same as {xref-Address-functionCall-address-bytes-string-}[`functionCall`],
332      * but performing a static call.
333      *
334      * _Available since v3.3._
335      */
336     function functionStaticCall(
337         address target,
338         bytes memory data,
339         string memory errorMessage
340     ) internal view returns (bytes memory) {
341         require(isContract(target), "Address: static call to non-contract");
342 
343         (bool success, bytes memory returndata) = target.staticcall(data);
344         return verifyCallResult(success, returndata, errorMessage);
345     }
346 
347     /**
348      * @dev Same as {xref-Address-functionCall-address-bytes-}[`functionCall`],
349      * but performing a delegate call.
350      *
351      * _Available since v3.4._
352      */
353     function functionDelegateCall(address target, bytes memory data) internal returns (bytes memory) {
354         return functionDelegateCall(target, data, "Address: low-level delegate call failed");
355     }
356 
357     /**
358      * @dev Same as {xref-Address-functionCall-address-bytes-string-}[`functionCall`],
359      * but performing a delegate call.
360      *
361      * _Available since v3.4._
362      */
363     function functionDelegateCall(
364         address target,
365         bytes memory data,
366         string memory errorMessage
367     ) internal returns (bytes memory) {
368         require(isContract(target), "Address: delegate call to non-contract");
369 
370         (bool success, bytes memory returndata) = target.delegatecall(data);
371         return verifyCallResult(success, returndata, errorMessage);
372     }
373 
374     /**
375      * @dev Tool to verifies that a low level call was successful, and revert if it wasn't, either by bubbling the
376      * revert reason using the provided one.
377      *
378      * _Available since v4.3._
379      */
380     function verifyCallResult(
381         bool success,
382         bytes memory returndata,
383         string memory errorMessage
384     ) internal pure returns (bytes memory) {
385         if (success) {
386             return returndata;
387         } else {
388             // Look for revert reason and bubble it up if present
389             if (returndata.length > 0) {
390                 // The easiest way to bubble the revert reason is using memory via assembly
391 
392                 assembly {
393                     let returndata_size := mload(returndata)
394                     revert(add(32, returndata), returndata_size)
395                 }
396             } else {
397                 revert(errorMessage);
398             }
399         }
400     }
401 }
402 
403 abstract contract Context {
404     function _msgSender() internal view virtual returns (address) {
405         return msg.sender;
406     }
407 
408     function _msgData() internal view virtual returns (bytes calldata) {
409         return msg.data;
410     }
411 }
412 
413 library Strings {
414     bytes16 private constant _HEX_SYMBOLS = "0123456789abcdef";
415 
416     /**
417      * @dev Converts a `uint256` to its ASCII `string` decimal representation.
418      */
419     function toString(uint256 value) internal pure returns (string memory) {
420         // Inspired by OraclizeAPI's implementation - MIT licence
421         // https://github.com/oraclize/ethereum-api/blob/b42146b063c7d6ee1358846c198246239e9360e8/oraclizeAPI_0.4.25.sol
422 
423         if (value == 0) {
424             return "0";
425         }
426         uint256 temp = value;
427         uint256 digits;
428         while (temp != 0) {
429             digits++;
430             temp /= 10;
431         }
432         bytes memory buffer = new bytes(digits);
433         while (value != 0) {
434             digits -= 1;
435             buffer[digits] = bytes1(uint8(48 + uint256(value % 10)));
436             value /= 10;
437         }
438         return string(buffer);
439     }
440 
441     /**
442      * @dev Converts a `uint256` to its ASCII `string` hexadecimal representation.
443      */
444     function toHexString(uint256 value) internal pure returns (string memory) {
445         if (value == 0) {
446             return "0x00";
447         }
448         uint256 temp = value;
449         uint256 length = 0;
450         while (temp != 0) {
451             length++;
452             temp >>= 8;
453         }
454         return toHexString(value, length);
455     }
456 
457     /**
458      * @dev Converts a `uint256` to its ASCII `string` hexadecimal representation with fixed length.
459      */
460     function toHexString(uint256 value, uint256 length) internal pure returns (string memory) {
461         bytes memory buffer = new bytes(2 * length + 2);
462         buffer[0] = "0";
463         buffer[1] = "x";
464         for (uint256 i = 2 * length + 1; i > 1; --i) {
465             buffer[i] = _HEX_SYMBOLS[value & 0xf];
466             value >>= 4;
467         }
468         require(value == 0, "Strings: hex length insufficient");
469         return string(buffer);
470     }
471 }
472 
473 
474 
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
593         _setApprovalForAll(_msgSender(), operator, approved);
594     }
595 
596     /**
597      * @dev See {IERC721-isApprovedForAll}.
598      */
599     function isApprovedForAll(address owner, address operator) public view virtual override returns (bool) {
600         return _operatorApprovals[owner][operator];
601     }
602 
603     /**
604      * @dev See {IERC721-transferFrom}.
605      */
606     function transferFrom(
607         address from,
608         address to,
609         uint256 tokenId
610     ) public virtual override {
611         //solhint-disable-next-line max-line-length
612         require(_isApprovedOrOwner(_msgSender(), tokenId), "ERC721: transfer caller is not owner nor approved");
613 
614         _transfer(from, to, tokenId);
615     }
616 
617     /**
618      * @dev See {IERC721-safeTransferFrom}.
619      */
620     function safeTransferFrom(
621         address from,
622         address to,
623         uint256 tokenId
624     ) public virtual override {
625         safeTransferFrom(from, to, tokenId, "");
626     }
627 
628     /**
629      * @dev See {IERC721-safeTransferFrom}.
630      */
631     function safeTransferFrom(
632         address from,
633         address to,
634         uint256 tokenId,
635         bytes memory _data
636     ) public virtual override {
637         require(_isApprovedOrOwner(_msgSender(), tokenId), "ERC721: transfer caller is not owner nor approved");
638         _safeTransfer(from, to, tokenId, _data);
639     }
640 
641     /**
642      * @dev Safely transfers `tokenId` token from `from` to `to`, checking first that contract recipients
643      * are aware of the ERC721 protocol to prevent tokens from being forever locked.
644      *
645      * `_data` is additional data, it has no specified format and it is sent in call to `to`.
646      *
647      * This internal function is equivalent to {safeTransferFrom}, and can be used to e.g.
648      * implement alternative mechanisms to perform token transfer, such as signature-based.
649      *
650      * Requirements:
651      *
652      * - `from` cannot be the zero address.
653      * - `to` cannot be the zero address.
654      * - `tokenId` token must exist and be owned by `from`.
655      * - If `to` refers to a smart contract, it must implement {IERC721Receiver-onERC721Received}, which is called upon a safe transfer.
656      *
657      * Emits a {Transfer} event.
658      */
659     function _safeTransfer(
660         address from,
661         address to,
662         uint256 tokenId,
663         bytes memory _data
664     ) internal virtual {
665         _transfer(from, to, tokenId);
666         require(_checkOnERC721Received(from, to, tokenId, _data), "ERC721: transfer to non ERC721Receiver implementer");
667     }
668 
669     /**
670      * @dev Returns whether `tokenId` exists.
671      *
672      * Tokens can be managed by their owner or approved accounts via {approve} or {setApprovalForAll}.
673      *
674      * Tokens start existing when they are minted (`_mint`),
675      * and stop existing when they are burned (`_burn`).
676      */
677     function _exists(uint256 tokenId) internal view virtual returns (bool) {
678         return _owners[tokenId] != address(0);
679     }
680 
681     /**
682      * @dev Returns whether `spender` is allowed to manage `tokenId`.
683      *
684      * Requirements:
685      *
686      * - `tokenId` must exist.
687      */
688     function _isApprovedOrOwner(address spender, uint256 tokenId) internal view virtual returns (bool) {
689         require(_exists(tokenId), "ERC721: operator query for nonexistent token");
690         address owner = ERC721.ownerOf(tokenId);
691         return (spender == owner || getApproved(tokenId) == spender || isApprovedForAll(owner, spender));
692     }
693 
694     /**
695      * @dev Safely mints `tokenId` and transfers it to `to`.
696      *
697      * Requirements:
698      *
699      * - `tokenId` must not exist.
700      * - If `to` refers to a smart contract, it must implement {IERC721Receiver-onERC721Received}, which is called upon a safe transfer.
701      *
702      * Emits a {Transfer} event.
703      */
704     function _safeMint(address to, uint256 tokenId) internal virtual {
705         _safeMint(to, tokenId, "");
706     }
707 
708     /**
709      * @dev Same as {xref-ERC721-_safeMint-address-uint256-}[`_safeMint`], with an additional `data` parameter which is
710      * forwarded in {IERC721Receiver-onERC721Received} to contract recipients.
711      */
712     function _safeMint(
713         address to,
714         uint256 tokenId,
715         bytes memory _data
716     ) internal virtual {
717         _mint(to, tokenId);
718         require(
719             _checkOnERC721Received(address(0), to, tokenId, _data),
720             "ERC721: transfer to non ERC721Receiver implementer"
721         );
722     }
723 
724     /**
725      * @dev Mints `tokenId` and transfers it to `to`.
726      *
727      * WARNING: Usage of this method is discouraged, use {_safeMint} whenever possible
728      *
729      * Requirements:
730      *
731      * - `tokenId` must not exist.
732      * - `to` cannot be the zero address.
733      *
734      * Emits a {Transfer} event.
735      */
736     function _mint(address to, uint256 tokenId) internal virtual {
737         require(to != address(0), "ERC721: mint to the zero address");
738         require(!_exists(tokenId), "ERC721: token already minted");
739 
740         _beforeTokenTransfer(address(0), to, tokenId);
741 
742         _balances[to] += 1;
743         _owners[tokenId] = to;
744 
745         emit Transfer(address(0), to, tokenId);
746     }
747 
748     /**
749      * @dev Destroys `tokenId`.
750      * The approval is cleared when the token is burned.
751      *
752      * Requirements:
753      *
754      * - `tokenId` must exist.
755      *
756      * Emits a {Transfer} event.
757      */
758     function _burn(uint256 tokenId) internal virtual {
759         address owner = ERC721.ownerOf(tokenId);
760 
761         _beforeTokenTransfer(owner, address(0), tokenId);
762 
763         // Clear approvals
764         _approve(address(0), tokenId);
765 
766         _balances[owner] -= 1;
767         delete _owners[tokenId];
768 
769         emit Transfer(owner, address(0), tokenId);
770     }
771 
772     /**
773      * @dev Transfers `tokenId` from `from` to `to`.
774      *  As opposed to {transferFrom}, this imposes no restrictions on msg.sender.
775      *
776      * Requirements:
777      *
778      * - `to` cannot be the zero address.
779      * - `tokenId` token must be owned by `from`.
780      *
781      * Emits a {Transfer} event.
782      */
783     function _transfer(
784         address from,
785         address to,
786         uint256 tokenId
787     ) internal virtual {
788         require(ERC721.ownerOf(tokenId) == from, "ERC721: transfer of token that is not own");
789         require(to != address(0), "ERC721: transfer to the zero address");
790 
791         _beforeTokenTransfer(from, to, tokenId);
792 
793         // Clear approvals from the previous owner
794         _approve(address(0), tokenId);
795 
796         _balances[from] -= 1;
797         _balances[to] += 1;
798         _owners[tokenId] = to;
799 
800         emit Transfer(from, to, tokenId);
801     }
802 
803     /**
804      * @dev Approve `to` to operate on `tokenId`
805      *
806      * Emits a {Approval} event.
807      */
808     function _approve(address to, uint256 tokenId) internal virtual {
809         _tokenApprovals[tokenId] = to;
810         emit Approval(ERC721.ownerOf(tokenId), to, tokenId);
811     }
812 
813     /**
814      * @dev Approve `operator` to operate on all of `owner` tokens
815      *
816      * Emits a {ApprovalForAll} event.
817      */
818     function _setApprovalForAll(
819         address owner,
820         address operator,
821         bool approved
822     ) internal virtual {
823         require(owner != operator, "ERC721: approve to caller");
824         _operatorApprovals[owner][operator] = approved;
825         emit ApprovalForAll(owner, operator, approved);
826     }
827 
828     /**
829      * @dev Internal function to invoke {IERC721Receiver-onERC721Received} on a target address.
830      * The call is not executed if the target address is not a contract.
831      *
832      * @param from address representing the previous owner of the given token ID
833      * @param to target address that will receive the tokens
834      * @param tokenId uint256 ID of the token to be transferred
835      * @param _data bytes optional data to send along with the call
836      * @return bool whether the call correctly returned the expected magic value
837      */
838     function _checkOnERC721Received(
839         address from,
840         address to,
841         uint256 tokenId,
842         bytes memory _data
843     ) private returns (bool) {
844         if (to.isContract()) {
845             try IERC721Receiver(to).onERC721Received(_msgSender(), from, tokenId, _data) returns (bytes4 retval) {
846                 return retval == IERC721Receiver.onERC721Received.selector;
847             } catch (bytes memory reason) {
848                 if (reason.length == 0) {
849                     revert("ERC721: transfer to non ERC721Receiver implementer");
850                 } else {
851                     assembly {
852                         revert(add(32, reason), mload(reason))
853                     }
854                 }
855             }
856         } else {
857             return true;
858         }
859     }
860 
861     /**
862      * @dev Hook that is called before any token transfer. This includes minting
863      * and burning.
864      *
865      * Calling conditions:
866      *
867      * - When `from` and `to` are both non-zero, ``from``'s `tokenId` will be
868      * transferred to `to`.
869      * - When `from` is zero, `tokenId` will be minted for `to`.
870      * - When `to` is zero, ``from``'s `tokenId` will be burned.
871      * - `from` and `to` are never both zero.
872      *
873      * To learn more about hooks, head to xref:ROOT:extending-contracts.adoc#using-hooks[Using Hooks].
874      */
875     function _beforeTokenTransfer(
876         address from,
877         address to,
878         uint256 tokenId
879     ) internal virtual {}
880 }
881 
882 abstract contract Ownable is Context {
883     address private _owner;
884 
885     event OwnershipTransferred(address indexed previousOwner, address indexed newOwner);
886 
887     /**
888      * @dev Initializes the contract setting the deployer as the initial owner.
889      */
890     constructor() {
891         _transferOwnership(_msgSender());
892     }
893 
894     /**
895      * @dev Returns the address of the current owner.
896      */
897     function owner() public view virtual returns (address) {
898         return _owner;
899     }
900 
901     /**
902      * @dev Throws if called by any account other than the owner.
903      */
904     modifier onlyOwner() {
905         require(owner() == _msgSender(), "Ownable: caller is not the owner");
906         _;
907     }
908 
909     /**
910      * @dev Leaves the contract without owner. It will not be possible to call
911      * `onlyOwner` functions anymore. Can only be called by the current owner.
912      *
913      * NOTE: Renouncing ownership will leave the contract without an owner,
914      * thereby removing any functionality that is only available to the owner.
915      */
916     function renounceOwnership() public virtual onlyOwner {
917         _transferOwnership(address(0));
918     }
919 
920     /**
921      * @dev Transfers ownership of the contract to a new account (`newOwner`).
922      * Can only be called by the current owner.
923      */
924     function transferOwnership(address newOwner) public virtual onlyOwner {
925         require(newOwner != address(0), "Ownable: new owner is the zero address");
926         _transferOwnership(newOwner);
927     }
928 
929     /**
930      * @dev Transfers ownership of the contract to a new account (`newOwner`).
931      * Internal function without access restriction.
932      */
933     function _transferOwnership(address newOwner) internal virtual {
934         address oldOwner = _owner;
935         _owner = newOwner;
936         emit OwnershipTransferred(oldOwner, newOwner);
937     }
938 }
939 
940 interface IERC721Enumerable is IERC721 {
941     /**
942      * @dev Returns the total amount of tokens stored by the contract.
943      */
944     function totalSupply() external view returns (uint256);
945 
946     /**
947      * @dev Returns a token ID owned by `owner` at a given `index` of its token list.
948      * Use along with {balanceOf} to enumerate all of ``owner``'s tokens.
949      */
950     function tokenOfOwnerByIndex(address owner, uint256 index) external view returns (uint256 tokenId);
951 
952     /**
953      * @dev Returns a token ID at a given `index` of all the tokens stored by the contract.
954      * Use along with {totalSupply} to enumerate all tokens.
955      */
956     function tokenByIndex(uint256 index) external view returns (uint256);
957 }
958 
959 abstract contract ERC721Enumerable is ERC721, IERC721Enumerable {
960     // Mapping from owner to list of owned token IDs
961     mapping(address => mapping(uint256 => uint256)) private _ownedTokens;
962 
963     // Mapping from token ID to index of the owner tokens list
964     mapping(uint256 => uint256) private _ownedTokensIndex;
965 
966     // Array with all token ids, used for enumeration
967     uint256[] private _allTokens;
968 
969     // Mapping from token id to position in the allTokens array
970     mapping(uint256 => uint256) private _allTokensIndex;
971 
972     /**
973      * @dev See {IERC165-supportsInterface}.
974      */
975     function supportsInterface(bytes4 interfaceId) public view virtual override(IERC165, ERC721) returns (bool) {
976         return interfaceId == type(IERC721Enumerable).interfaceId || super.supportsInterface(interfaceId);
977     }
978 
979     /**
980      * @dev See {IERC721Enumerable-tokenOfOwnerByIndex}.
981      */
982     function tokenOfOwnerByIndex(address owner, uint256 index) public view virtual override returns (uint256) {
983         require(index < ERC721.balanceOf(owner), "ERC721Enumerable: owner index out of bounds");
984         return _ownedTokens[owner][index];
985     }
986 
987     /**
988      * @dev See {IERC721Enumerable-totalSupply}.
989      */
990     function totalSupply() public view virtual override returns (uint256) {
991         return _allTokens.length;
992     }
993 
994     /**
995      * @dev See {IERC721Enumerable-tokenByIndex}.
996      */
997     function tokenByIndex(uint256 index) public view virtual override returns (uint256) {
998         require(index < ERC721Enumerable.totalSupply(), "ERC721Enumerable: global index out of bounds");
999         return _allTokens[index];
1000     }
1001 
1002     /**
1003      * @dev Hook that is called before any token transfer. This includes minting
1004      * and burning.
1005      *
1006      * Calling conditions:
1007      *
1008      * - When `from` and `to` are both non-zero, ``from``'s `tokenId` will be
1009      * transferred to `to`.
1010      * - When `from` is zero, `tokenId` will be minted for `to`.
1011      * - When `to` is zero, ``from``'s `tokenId` will be burned.
1012      * - `from` cannot be the zero address.
1013      * - `to` cannot be the zero address.
1014      *
1015      * To learn more about hooks, head to xref:ROOT:extending-contracts.adoc#using-hooks[Using Hooks].
1016      */
1017     function _beforeTokenTransfer(
1018         address from,
1019         address to,
1020         uint256 tokenId
1021     ) internal virtual override {
1022         super._beforeTokenTransfer(from, to, tokenId);
1023 
1024         if (from == address(0)) {
1025             _addTokenToAllTokensEnumeration(tokenId);
1026         } else if (from != to) {
1027             _removeTokenFromOwnerEnumeration(from, tokenId);
1028         }
1029         if (to == address(0)) {
1030             _removeTokenFromAllTokensEnumeration(tokenId);
1031         } else if (to != from) {
1032             _addTokenToOwnerEnumeration(to, tokenId);
1033         }
1034     }
1035 
1036     /**
1037      * @dev Private function to add a token to this extension's ownership-tracking data structures.
1038      * @param to address representing the new owner of the given token ID
1039      * @param tokenId uint256 ID of the token to be added to the tokens list of the given address
1040      */
1041     function _addTokenToOwnerEnumeration(address to, uint256 tokenId) private {
1042         uint256 length = ERC721.balanceOf(to);
1043         _ownedTokens[to][length] = tokenId;
1044         _ownedTokensIndex[tokenId] = length;
1045     }
1046 
1047     /**
1048      * @dev Private function to add a token to this extension's token tracking data structures.
1049      * @param tokenId uint256 ID of the token to be added to the tokens list
1050      */
1051     function _addTokenToAllTokensEnumeration(uint256 tokenId) private {
1052         _allTokensIndex[tokenId] = _allTokens.length;
1053         _allTokens.push(tokenId);
1054     }
1055 
1056     /**
1057      * @dev Private function to remove a token from this extension's ownership-tracking data structures. Note that
1058      * while the token is not assigned a new owner, the `_ownedTokensIndex` mapping is _not_ updated: this allows for
1059      * gas optimizations e.g. when performing a transfer operation (avoiding double writes).
1060      * This has O(1) time complexity, but alters the order of the _ownedTokens array.
1061      * @param from address representing the previous owner of the given token ID
1062      * @param tokenId uint256 ID of the token to be removed from the tokens list of the given address
1063      */
1064     function _removeTokenFromOwnerEnumeration(address from, uint256 tokenId) private {
1065         // To prevent a gap in from's tokens array, we store the last token in the index of the token to delete, and
1066         // then delete the last slot (swap and pop).
1067 
1068         uint256 lastTokenIndex = ERC721.balanceOf(from) - 1;
1069         uint256 tokenIndex = _ownedTokensIndex[tokenId];
1070 
1071         // When the token to delete is the last token, the swap operation is unnecessary
1072         if (tokenIndex != lastTokenIndex) {
1073             uint256 lastTokenId = _ownedTokens[from][lastTokenIndex];
1074 
1075             _ownedTokens[from][tokenIndex] = lastTokenId; // Move the last token to the slot of the to-delete token
1076             _ownedTokensIndex[lastTokenId] = tokenIndex; // Update the moved token's index
1077         }
1078 
1079         // This also deletes the contents at the last position of the array
1080         delete _ownedTokensIndex[tokenId];
1081         delete _ownedTokens[from][lastTokenIndex];
1082     }
1083 
1084     /**
1085      * @dev Private function to remove a token from this extension's token tracking data structures.
1086      * This has O(1) time complexity, but alters the order of the _allTokens array.
1087      * @param tokenId uint256 ID of the token to be removed from the tokens list
1088      */
1089     function _removeTokenFromAllTokensEnumeration(uint256 tokenId) private {
1090         // To prevent a gap in the tokens array, we store the last token in the index of the token to delete, and
1091         // then delete the last slot (swap and pop).
1092 
1093         uint256 lastTokenIndex = _allTokens.length - 1;
1094         uint256 tokenIndex = _allTokensIndex[tokenId];
1095 
1096         // When the token to delete is the last token, the swap operation is unnecessary. However, since this occurs so
1097         // rarely (when the last minted token is burnt) that we still do the swap here to avoid the gas cost of adding
1098         // an 'if' statement (like in _removeTokenFromOwnerEnumeration)
1099         uint256 lastTokenId = _allTokens[lastTokenIndex];
1100 
1101         _allTokens[tokenIndex] = lastTokenId; // Move the last token to the slot of the to-delete token
1102         _allTokensIndex[lastTokenId] = tokenIndex; // Update the moved token's index
1103 
1104         // This also deletes the contents at the last position of the array
1105         delete _allTokensIndex[tokenId];
1106         _allTokens.pop();
1107     }
1108 }
1109 
1110 contract EliteSociety is ERC721, ERC721Enumerable, Ownable {
1111     address authenticator = 0x866c2F3E8370D54b5B0cB7e60d9FE0459Cfc2352;
1112     
1113     uint16 public maxSupply = 1337;
1114 
1115     uint8 public reserved = 20;
1116 
1117     uint8 public state = 0; // 0-Stop 1-OgSale 2-PreSale 3-Sale
1118     
1119     bool public revealed = false;
1120     
1121     uint public mintPrice = 0.1 ether;
1122     
1123     string unrevealedURI = "";
1124     string baseURI = "";
1125 
1126     mapping (address => bool) public ogMinted;
1127     mapping (address => uint8) public minted;
1128     
1129     constructor() ERC721("Elite Society", "ELITE") {
1130         
1131     }
1132     
1133     function _beforeTokenTransfer(address from, address to, uint256 tokenId)
1134         internal
1135         override(ERC721, ERC721Enumerable)
1136     {
1137         super._beforeTokenTransfer(from, to, tokenId);
1138     }
1139 
1140     function supportsInterface(bytes4 interfaceId)
1141         public
1142         view
1143         override(ERC721, ERC721Enumerable)
1144         returns (bool)
1145     {
1146         return super.supportsInterface(interfaceId);
1147     }
1148 
1149     function withdrawEther(address payable _to, uint _amount) public onlyOwner {
1150         _to.transfer(_amount);
1151     }
1152 
1153     function ogMint (bytes memory signature) external {
1154         require(state == 1, "OG Elite mint is currently closed.");
1155         
1156         require(verifyPassword(msg.sender, 0, signature), "You were not added to the OG whitelist. Please contact Elite Society team if you think this is an error.");
1157         
1158         require(!ogMinted[msg.sender], "You have already minted your OG Elite.");
1159         
1160         _mint(msg.sender, totalSupply () + 1);
1161         
1162         ogMinted[msg.sender] = true;
1163     }
1164 
1165     function mint(uint8 tokenAmt, bytes memory signature) external payable {
1166         require(state == 2 ? verifyPassword(msg.sender, 1, signature) : state == 3, "You haven't been added to the whitelist or the sale hasn't started yet.");
1167         
1168         require(msg.value >= tokenAmt * mintPrice, "Wrong eth amount sent.");
1169         
1170         require(minted[msg.sender] + tokenAmt <= 2, "This would exceed maximum mint amount.");
1171         
1172         require(totalSupply() + tokenAmt <= maxSupply - reserved, "This would exceed max supply.");
1173         
1174         for(uint16 i = 0; i < tokenAmt; i++) {
1175             uint256 mintIndex = totalSupply () + 1;
1176             _mint(msg.sender, mintIndex);
1177         }
1178         
1179         minted[msg.sender] += tokenAmt;
1180     }
1181     
1182     function claimToAdmin(uint16 tokenAmt) public onlyOwner {
1183         require(totalSupply() + tokenAmt <= maxSupply, "This would exceed max supply");
1184         //require(reserved > 0, "This would exceed reserved supply");
1185         
1186         for(uint256 i = 0; i < tokenAmt; i++) {
1187             uint256 mintIndex = totalSupply () + 1;
1188             _mint(msg.sender, mintIndex);
1189             reserved--;
1190         }
1191     }
1192 
1193     function tokenURI(uint tokenId) public view override returns(string memory) {
1194         return revealed ? super.tokenURI(tokenId) : unrevealedURI;
1195     }
1196 
1197     function setState(uint8 newState) external onlyOwner {
1198         state = newState;
1199     }
1200     
1201     function setRevealed() external onlyOwner {
1202         revealed = !revealed;
1203     }
1204 
1205     function setBaseURI(string calldata baseURI_) external onlyOwner {
1206         baseURI = baseURI_;
1207     }
1208 
1209      function setUnrevealedURI(string calldata unrevealedURI_) external onlyOwner {
1210         unrevealedURI = unrevealedURI_;
1211     }
1212 
1213     function _baseURI() internal view override returns (string memory) {
1214         return baseURI;
1215     }
1216     
1217     function verifyPassword(address user, uint256 listId, bytes memory signature) public view returns (bool) {
1218         bytes32 messageHash = keccak256(abi.encode(user, listId));
1219         bytes32 ethSignedMessageHash = getEthSignedMessageHash(messageHash);
1220 
1221         return recoverSigner(ethSignedMessageHash, signature) == authenticator;
1222     }
1223     
1224     function getEthSignedMessageHash(bytes32 _messageHash) public pure returns (bytes32) {
1225         /*
1226         Signature is produced by signing a keccak256 hash with the following format:
1227         "\x19Ethereum Signed Message\n" + len(msg) + msg
1228         */
1229         return
1230         keccak256(
1231             abi.encodePacked("\x19Ethereum Signed Message:\n32", _messageHash)
1232         );
1233     }
1234 
1235     function recoverSigner(bytes32 _ethSignedMessageHash, bytes memory _signature) public pure returns (address) {
1236         (bytes32 r, bytes32 s, uint8 v) = splitSignature(_signature);
1237         return ecrecover(_ethSignedMessageHash, v, r, s);
1238     }
1239 
1240     function splitSignature(bytes memory sig)
1241     public
1242     pure
1243     returns (
1244         bytes32 r,
1245         bytes32 s,
1246         uint8 v
1247     )
1248     {
1249         require(sig.length == 65, "invalid signature length");
1250 
1251         assembly {
1252         /*
1253         First 32 bytes stores the length of the signature
1254 
1255         add(sig, 32) = pointer of sig + 32
1256         effectively, skips first 32 bytes of signature
1257 
1258         mload(p) loads next 32 bytes starting at the memory address p into memory
1259         */
1260 
1261         // first 32 bytes, after the length prefix
1262             r := mload(add(sig, 32))
1263         // second 32 bytes
1264             s := mload(add(sig, 64))
1265         // final byte (first byte of the next 32 bytes)
1266             v := byte(0, mload(add(sig, 96)))
1267         }
1268 
1269         // implicitly return (r, s, v)
1270     }
1271 }