1 library Address {
2     /**
3      * @dev Returns true if `account` is a contract.
4      *
5      * [IMPORTANT]
6      * ====
7      * It is unsafe to assume that an address for which this function returns
8      * false is an externally-owned account (EOA) and not a contract.
9      *
10      * Among others, `isContract` will return false for the following
11      * types of addresses:
12      *
13      *  - an externally-owned account
14      *  - a contract in construction
15      *  - an address where a contract will be created
16      *  - an address where a contract lived, but was destroyed
17      * ====
18      */
19     function isContract(address account) internal view returns (bool) {
20         // This method relies on extcodesize, which returns 0 for contracts in
21         // construction, since the code is only stored at the end of the
22         // constructor execution.
23 
24         uint256 size;
25         assembly {
26             size := extcodesize(account)
27         }
28         return size > 0;
29     }
30 
31     /**
32      * @dev Replacement for Solidity's `transfer`: sends `amount` wei to
33      * `recipient`, forwarding all available gas and reverting on errors.
34      *
35      * https://eips.ethereum.org/EIPS/eip-1884[EIP1884] increases the gas cost
36      * of certain opcodes, possibly making contracts go over the 2300 gas limit
37      * imposed by `transfer`, making them unable to receive funds via
38      * `transfer`. {sendValue} removes this limitation.
39      *
40      * https://diligence.consensys.net/posts/2019/09/stop-using-soliditys-transfer-now/[Learn more].
41      *
42      * IMPORTANT: because control is transferred to `recipient`, care must be
43      * taken to not create reentrancy vulnerabilities. Consider using
44      * {ReentrancyGuard} or the
45      * https://solidity.readthedocs.io/en/v0.5.11/security-considerations.html#use-the-checks-effects-interactions-pattern[checks-effects-interactions pattern].
46      */
47     function sendValue(address payable recipient, uint256 amount) internal {
48         require(address(this).balance >= amount, "Address: insufficient balance");
49 
50         (bool success, ) = recipient.call{value: amount}("");
51         require(success, "Address: unable to send value, recipient may have reverted");
52     }
53 
54     /**
55      * @dev Performs a Solidity function call using a low level `call`. A
56      * plain `call` is an unsafe replacement for a function call: use this
57      * function instead.
58      *
59      * If `target` reverts with a revert reason, it is bubbled up by this
60      * function (like regular Solidity function calls).
61      *
62      * Returns the raw returned data. To convert to the expected return value,
63      * use https://solidity.readthedocs.io/en/latest/units-and-global-variables.html?highlight=abi.decode#abi-encoding-and-decoding-functions[`abi.decode`].
64      *
65      * Requirements:
66      *
67      * - `target` must be a contract.
68      * - calling `target` with `data` must not revert.
69      *
70      * _Available since v3.1._
71      */
72     function functionCall(address target, bytes memory data) internal returns (bytes memory) {
73         return functionCall(target, data, "Address: low-level call failed");
74     }
75 
76     /**
77      * @dev Same as {xref-Address-functionCall-address-bytes-}[`functionCall`], but with
78      * `errorMessage` as a fallback revert reason when `target` reverts.
79      *
80      * _Available since v3.1._
81      */
82     function functionCall(
83         address target,
84         bytes memory data,
85         string memory errorMessage
86     ) internal returns (bytes memory) {
87         return functionCallWithValue(target, data, 0, errorMessage);
88     }
89 
90     /**
91      * @dev Same as {xref-Address-functionCall-address-bytes-}[`functionCall`],
92      * but also transferring `value` wei to `target`.
93      *
94      * Requirements:
95      *
96      * - the calling contract must have an ETH balance of at least `value`.
97      * - the called Solidity function must be `payable`.
98      *
99      * _Available since v3.1._
100      */
101     function functionCallWithValue(
102         address target,
103         bytes memory data,
104         uint256 value
105     ) internal returns (bytes memory) {
106         return functionCallWithValue(target, data, value, "Address: low-level call with value failed");
107     }
108 
109     /**
110      * @dev Same as {xref-Address-functionCallWithValue-address-bytes-uint256-}[`functionCallWithValue`], but
111      * with `errorMessage` as a fallback revert reason when `target` reverts.
112      *
113      * _Available since v3.1._
114      */
115     function functionCallWithValue(
116         address target,
117         bytes memory data,
118         uint256 value,
119         string memory errorMessage
120     ) internal returns (bytes memory) {
121         require(address(this).balance >= value, "Address: insufficient balance for call");
122         require(isContract(target), "Address: call to non-contract");
123 
124         (bool success, bytes memory returndata) = target.call{value: value}(data);
125         return verifyCallResult(success, returndata, errorMessage);
126     }
127 
128     /**
129      * @dev Same as {xref-Address-functionCall-address-bytes-}[`functionCall`],
130      * but performing a static call.
131      *
132      * _Available since v3.3._
133      */
134     function functionStaticCall(address target, bytes memory data) internal view returns (bytes memory) {
135         return functionStaticCall(target, data, "Address: low-level static call failed");
136     }
137 
138     /**
139      * @dev Same as {xref-Address-functionCall-address-bytes-string-}[`functionCall`],
140      * but performing a static call.
141      *
142      * _Available since v3.3._
143      */
144     function functionStaticCall(
145         address target,
146         bytes memory data,
147         string memory errorMessage
148     ) internal view returns (bytes memory) {
149         require(isContract(target), "Address: static call to non-contract");
150 
151         (bool success, bytes memory returndata) = target.staticcall(data);
152         return verifyCallResult(success, returndata, errorMessage);
153     }
154 
155     /**
156      * @dev Same as {xref-Address-functionCall-address-bytes-}[`functionCall`],
157      * but performing a delegate call.
158      *
159      * _Available since v3.4._
160      */
161     function functionDelegateCall(address target, bytes memory data) internal returns (bytes memory) {
162         return functionDelegateCall(target, data, "Address: low-level delegate call failed");
163     }
164 
165     /**
166      * @dev Same as {xref-Address-functionCall-address-bytes-string-}[`functionCall`],
167      * but performing a delegate call.
168      *
169      * _Available since v3.4._
170      */
171     function functionDelegateCall(
172         address target,
173         bytes memory data,
174         string memory errorMessage
175     ) internal returns (bytes memory) {
176         require(isContract(target), "Address: delegate call to non-contract");
177 
178         (bool success, bytes memory returndata) = target.delegatecall(data);
179         return verifyCallResult(success, returndata, errorMessage);
180     }
181 
182     /**
183      * @dev Tool to verifies that a low level call was successful, and revert if it wasn't, either by bubbling the
184      * revert reason using the provided one.
185      *
186      * _Available since v4.3._
187      */
188     function verifyCallResult(
189         bool success,
190         bytes memory returndata,
191         string memory errorMessage
192     ) internal pure returns (bytes memory) {
193         if (success) {
194             return returndata;
195         } else {
196             // Look for revert reason and bubble it up if present
197             if (returndata.length > 0) {
198                 // The easiest way to bubble the revert reason is using memory via assembly
199 
200                 assembly {
201                     let returndata_size := mload(returndata)
202                     revert(add(32, returndata), returndata_size)
203                 }
204             } else {
205                 revert(errorMessage);
206             }
207         }
208     }
209 } 
210 
211 library Strings {
212     bytes16 private constant _HEX_SYMBOLS = "0123456789abcdef";
213 
214     /**
215      * @dev Converts a `uint256` to its ASCII `string` decimal representation.
216      */
217     function toString(uint256 value) internal pure returns (string memory) {
218         // Inspired by OraclizeAPI's implementation - MIT licence
219         // https://github.com/oraclize/ethereum-api/blob/b42146b063c7d6ee1358846c198246239e9360e8/oraclizeAPI_0.4.25.sol
220 
221         if (value == 0) {
222             return "0";
223         }
224         uint256 temp = value;
225         uint256 digits;
226         while (temp != 0) {
227             digits++;
228             temp /= 10;
229         }
230         bytes memory buffer = new bytes(digits);
231         while (value != 0) {
232             digits -= 1;
233             buffer[digits] = bytes1(uint8(48 + uint256(value % 10)));
234             value /= 10;
235         }
236         return string(buffer);
237     }
238 
239     /**
240      * @dev Converts a `uint256` to its ASCII `string` hexadecimal representation.
241      */
242     function toHexString(uint256 value) internal pure returns (string memory) {
243         if (value == 0) {
244             return "0x00";
245         }
246         uint256 temp = value;
247         uint256 length = 0;
248         while (temp != 0) {
249             length++;
250             temp >>= 8;
251         }
252         return toHexString(value, length);
253     }
254 
255     /**
256      * @dev Converts a `uint256` to its ASCII `string` hexadecimal representation with fixed length.
257      */
258     function toHexString(uint256 value, uint256 length) internal pure returns (string memory) {
259         bytes memory buffer = new bytes(2 * length + 2);
260         buffer[0] = "0";
261         buffer[1] = "x";
262         for (uint256 i = 2 * length + 1; i > 1; --i) {
263             buffer[i] = _HEX_SYMBOLS[value & 0xf];
264             value >>= 4;
265         }
266         require(value == 0, "Strings: hex length insufficient");
267         return string(buffer);
268     }
269 } 
270 
271 abstract contract Context {
272     function _msgSender() internal view virtual returns (address) {
273         return msg.sender;
274     }
275 
276     function _msgData() internal view virtual returns (bytes calldata) {
277         return msg.data;
278     }
279 } 
280 
281 interface IERC165 {
282     /**
283      * @dev Returns true if this contract implements the interface defined by
284      * `interfaceId`. See the corresponding
285      * https://eips.ethereum.org/EIPS/eip-165#how-interfaces-are-identified[EIP section]
286      * to learn more about how these ids are created.
287      *
288      * This function call must use less than 30 000 gas.
289      */
290     function supportsInterface(bytes4 interfaceId) external view returns (bool);
291 } 
292 
293 interface IERC721 is IERC165 {
294     /**
295      * @dev Emitted when `tokenId` token is transferred from `from` to `to`.
296      */
297     event Transfer(address indexed from, address indexed to, uint256 indexed tokenId);
298 
299     /**
300      * @dev Emitted when `owner` enables `approved` to manage the `tokenId` token.
301      */
302     event Approval(address indexed owner, address indexed approved, uint256 indexed tokenId);
303 
304     /**
305      * @dev Emitted when `owner` enables or disables (`approved`) `operator` to manage all of its assets.
306      */
307     event ApprovalForAll(address indexed owner, address indexed operator, bool approved);
308 
309     /**
310      * @dev Returns the number of tokens in ``owner``'s account.
311      */
312     function balanceOf(address owner) external view returns (uint256 balance);
313 
314     /**
315      * @dev Returns the owner of the `tokenId` token.
316      *
317      * Requirements:
318      *
319      * - `tokenId` must exist.
320      */
321     function ownerOf(uint256 tokenId) external view returns (address owner);
322 
323     /**
324      * @dev Safely transfers `tokenId` token from `from` to `to`, checking first that contract recipients
325      * are aware of the ERC721 protocol to prevent tokens from being forever locked.
326      *
327      * Requirements:
328      *
329      * - `from` cannot be the zero address.
330      * - `to` cannot be the zero address.
331      * - `tokenId` token must exist and be owned by `from`.
332      * - If the caller is not `from`, it must be have been allowed to move this token by either {approve} or {setApprovalForAll}.
333      * - If `to` refers to a smart contract, it must implement {IERC721Receiver-onERC721Received}, which is called upon a safe transfer.
334      *
335      * Emits a {Transfer} event.
336      */
337     function safeTransferFrom(
338         address from,
339         address to,
340         uint256 tokenId
341     ) external;
342 
343     /**
344      * @dev Transfers `tokenId` token from `from` to `to`.
345      *
346      * WARNING: Usage of this method is discouraged, use {safeTransferFrom} whenever possible.
347      *
348      * Requirements:
349      *
350      * - `from` cannot be the zero address.
351      * - `to` cannot be the zero address.
352      * - `tokenId` token must be owned by `from`.
353      * - If the caller is not `from`, it must be approved to move this token by either {approve} or {setApprovalForAll}.
354      *
355      * Emits a {Transfer} event.
356      */
357     function transferFrom(
358         address from,
359         address to,
360         uint256 tokenId
361     ) external;
362 
363     /**
364      * @dev Gives permission to `to` to transfer `tokenId` token to another account.
365      * The approval is cleared when the token is transferred.
366      *
367      * Only a single account can be approved at a time, so approving the zero address clears previous approvals.
368      *
369      * Requirements:
370      *
371      * - The caller must own the token or be an approved operator.
372      * - `tokenId` must exist.
373      *
374      * Emits an {Approval} event.
375      */
376     function approve(address to, uint256 tokenId) external;
377 
378     /**
379      * @dev Returns the account approved for `tokenId` token.
380      *
381      * Requirements:
382      *
383      * - `tokenId` must exist.
384      */
385     function getApproved(uint256 tokenId) external view returns (address operator);
386 
387     /**
388      * @dev Approve or remove `operator` as an operator for the caller.
389      * Operators can call {transferFrom} or {safeTransferFrom} for any token owned by the caller.
390      *
391      * Requirements:
392      *
393      * - The `operator` cannot be the caller.
394      *
395      * Emits an {ApprovalForAll} event.
396      */
397     function setApprovalForAll(address operator, bool _approved) external;
398 
399     /**
400      * @dev Returns if the `operator` is allowed to manage all of the assets of `owner`.
401      *
402      * See {setApprovalForAll}
403      */
404     function isApprovedForAll(address owner, address operator) external view returns (bool);
405 
406     /**
407      * @dev Safely transfers `tokenId` token from `from` to `to`.
408      *
409      * Requirements:
410      *
411      * - `from` cannot be the zero address.
412      * - `to` cannot be the zero address.
413      * - `tokenId` token must exist and be owned by `from`.
414      * - If the caller is not `from`, it must be approved to move this token by either {approve} or {setApprovalForAll}.
415      * - If `to` refers to a smart contract, it must implement {IERC721Receiver-onERC721Received}, which is called upon a safe transfer.
416      *
417      * Emits a {Transfer} event.
418      */
419     function safeTransferFrom(
420         address from,
421         address to,
422         uint256 tokenId,
423         bytes calldata data
424     ) external;
425 } 
426 
427 interface IERC721Enumerable is IERC721 {
428     /**
429      * @dev Returns the total amount of tokens stored by the contract.
430      */
431     function totalSupply() external view returns (uint256);
432 
433     /**
434      * @dev Returns a token ID owned by `owner` at a given `index` of its token list.
435      * Use along with {balanceOf} to enumerate all of ``owner``'s tokens.
436      */
437     function tokenOfOwnerByIndex(address owner, uint256 index) external view returns (uint256 tokenId);
438 
439     /**
440      * @dev Returns a token ID at a given `index` of all the tokens stored by the contract.
441      * Use along with {totalSupply} to enumerate all tokens.
442      */
443     function tokenByIndex(uint256 index) external view returns (uint256);
444 } 
445 
446 interface IERC721Metadata is IERC721 {
447     /**
448      * @dev Returns the token collection name.
449      */
450     function name() external view returns (string memory);
451 
452     /**
453      * @dev Returns the token collection symbol.
454      */
455     function symbol() external view returns (string memory);
456 
457     /**
458      * @dev Returns the Uniform Resource Identifier (URI) for `tokenId` token.
459      */
460     function tokenURI(uint256 tokenId) external view returns (string memory);
461 } 
462 
463 interface IERC721Receiver {
464     /**
465      * @dev Whenever an {IERC721} `tokenId` token is transferred to this contract via {IERC721-safeTransferFrom}
466      * by `operator` from `from`, this function is called.
467      *
468      * It must return its Solidity selector to confirm the token transfer.
469      * If any other value is returned or the interface is not implemented by the recipient, the transfer will be reverted.
470      *
471      * The selector can be obtained in Solidity with `IERC721.onERC721Received.selector`.
472      */
473     function onERC721Received(
474         address operator,
475         address from,
476         uint256 tokenId,
477         bytes calldata data
478     ) external returns (bytes4);
479 } 
480 
481 abstract contract ERC165 is IERC165 {
482     /**
483      * @dev See {IERC165-supportsInterface}.
484      */
485     function supportsInterface(bytes4 interfaceId) public view virtual override returns (bool) {
486         return interfaceId == type(IERC165).interfaceId;
487     }
488 } 
489 
490 contract ERC721 is Context, ERC165, IERC721, IERC721Metadata {
491     using Address for address;
492     using Strings for uint256;
493 
494     // Token name
495     string private _name;
496 
497     // Token symbol
498     string private _symbol;
499 
500     // Mapping from token ID to owner address
501     mapping(uint256 => address) private _owners;
502 
503     // Mapping owner address to token count
504     mapping(address => uint256) private _balances;
505 
506     // Mapping from token ID to approved address
507     mapping(uint256 => address) private _tokenApprovals;
508 
509     // Mapping from owner to operator approvals
510     mapping(address => mapping(address => bool)) private _operatorApprovals;
511 
512     /**
513      * @dev Initializes the contract by setting a `name` and a `symbol` to the token collection.
514      */
515     constructor(string memory name_, string memory symbol_) {
516         _name = name_;
517         _symbol = symbol_;
518     }
519 
520     /**
521      * @dev See {IERC165-supportsInterface}.
522      */
523     function supportsInterface(bytes4 interfaceId) public view virtual override(ERC165, IERC165) returns (bool) {
524         return
525             interfaceId == type(IERC721).interfaceId ||
526             interfaceId == type(IERC721Metadata).interfaceId ||
527             super.supportsInterface(interfaceId);
528     }
529 
530     /**
531      * @dev See {IERC721-balanceOf}.
532      */
533     function balanceOf(address owner) public view virtual override returns (uint256) {
534         require(owner != address(0), "ERC721: balance query for the zero address");
535         return _balances[owner];
536     }
537 
538     /**
539      * @dev See {IERC721-ownerOf}.
540      */
541     function ownerOf(uint256 tokenId) public view virtual override returns (address) {
542         address owner = _owners[tokenId];
543         require(owner != address(0), "ERC721: owner query for nonexistent token");
544         return owner;
545     }
546 
547     /**
548      * @dev See {IERC721Metadata-name}.
549      */
550     function name() public view virtual override returns (string memory) {
551         return _name;
552     }
553 
554     /**
555      * @dev See {IERC721Metadata-symbol}.
556      */
557     function symbol() public view virtual override returns (string memory) {
558         return _symbol;
559     }
560 
561     /**
562      * @dev See {IERC721Metadata-tokenURI}.
563      */
564     function tokenURI(uint256 tokenId) public view virtual override returns (string memory) {
565         require(_exists(tokenId), "ERC721Metadata: URI query for nonexistent token");
566 
567         string memory baseURI = _baseURI();
568         return bytes(baseURI).length > 0 ? string(abi.encodePacked(baseURI, tokenId.toString())) : "";
569     }
570 
571     /**
572      * @dev Base URI for computing {tokenURI}. If set, the resulting URI for each
573      * token will be the concatenation of the `baseURI` and the `tokenId`. Empty
574      * by default, can be overriden in child contracts.
575      */
576     function _baseURI() internal view virtual returns (string memory) {
577         return "";
578     }
579 
580     /**
581      * @dev See {IERC721-approve}.
582      */
583     function approve(address to, uint256 tokenId) public virtual override {
584         address owner = ERC721.ownerOf(tokenId);
585         require(to != owner, "ERC721: approval to current owner");
586 
587         require(
588             _msgSender() == owner || isApprovedForAll(owner, _msgSender()),
589             "ERC721: approve caller is not owner nor approved for all"
590         );
591 
592         _approve(to, tokenId);
593     }
594 
595     /**
596      * @dev See {IERC721-getApproved}.
597      */
598     function getApproved(uint256 tokenId) public view virtual override returns (address) {
599         require(_exists(tokenId), "ERC721: approved query for nonexistent token");
600 
601         return _tokenApprovals[tokenId];
602     }
603 
604     /**
605      * @dev See {IERC721-setApprovalForAll}.
606      */
607     function setApprovalForAll(address operator, bool approved) public virtual override {
608         _setApprovalForAll(_msgSender(), operator, approved);
609     }
610 
611     /**
612      * @dev See {IERC721-isApprovedForAll}.
613      */
614     function isApprovedForAll(address owner, address operator) public view virtual override returns (bool) {
615         return _operatorApprovals[owner][operator];
616     }
617 
618     /**
619      * @dev See {IERC721-transferFrom}.
620      */
621     function transferFrom(
622         address from,
623         address to,
624         uint256 tokenId
625     ) public virtual override {
626         //solhint-disable-next-line max-line-length
627         require(_isApprovedOrOwner(_msgSender(), tokenId), "ERC721: transfer caller is not owner nor approved");
628 
629         _transfer(from, to, tokenId);
630     }
631 
632     /**
633      * @dev See {IERC721-safeTransferFrom}.
634      */
635     function safeTransferFrom(
636         address from,
637         address to,
638         uint256 tokenId
639     ) public virtual override {
640         safeTransferFrom(from, to, tokenId, "");
641     }
642 
643     /**
644      * @dev See {IERC721-safeTransferFrom}.
645      */
646     function safeTransferFrom(
647         address from,
648         address to,
649         uint256 tokenId,
650         bytes memory _data
651     ) public virtual override {
652         require(_isApprovedOrOwner(_msgSender(), tokenId), "ERC721: transfer caller is not owner nor approved");
653         _safeTransfer(from, to, tokenId, _data);
654     }
655 
656     /**
657      * @dev Safely transfers `tokenId` token from `from` to `to`, checking first that contract recipients
658      * are aware of the ERC721 protocol to prevent tokens from being forever locked.
659      *
660      * `_data` is additional data, it has no specified format and it is sent in call to `to`.
661      *
662      * This internal function is equivalent to {safeTransferFrom}, and can be used to e.g.
663      * implement alternative mechanisms to perform token transfer, such as signature-based.
664      *
665      * Requirements:
666      *
667      * - `from` cannot be the zero address.
668      * - `to` cannot be the zero address.
669      * - `tokenId` token must exist and be owned by `from`.
670      * - If `to` refers to a smart contract, it must implement {IERC721Receiver-onERC721Received}, which is called upon a safe transfer.
671      *
672      * Emits a {Transfer} event.
673      */
674     function _safeTransfer(
675         address from,
676         address to,
677         uint256 tokenId,
678         bytes memory _data
679     ) internal virtual {
680         _transfer(from, to, tokenId);
681         require(_checkOnERC721Received(from, to, tokenId, _data), "ERC721: transfer to non ERC721Receiver implementer");
682     }
683 
684     /**
685      * @dev Returns whether `tokenId` exists.
686      *
687      * Tokens can be managed by their owner or approved accounts via {approve} or {setApprovalForAll}.
688      *
689      * Tokens start existing when they are minted (`_mint`),
690      * and stop existing when they are burned (`_burn`).
691      */
692     function _exists(uint256 tokenId) internal view virtual returns (bool) {
693         return _owners[tokenId] != address(0);
694     }
695 
696     /**
697      * @dev Returns whether `spender` is allowed to manage `tokenId`.
698      *
699      * Requirements:
700      *
701      * - `tokenId` must exist.
702      */
703     function _isApprovedOrOwner(address spender, uint256 tokenId) internal view virtual returns (bool) {
704         require(_exists(tokenId), "ERC721: operator query for nonexistent token");
705         address owner = ERC721.ownerOf(tokenId);
706         return (spender == owner || getApproved(tokenId) == spender || isApprovedForAll(owner, spender));
707     }
708 
709     /**
710      * @dev Safely mints `tokenId` and transfers it to `to`.
711      *
712      * Requirements:
713      *
714      * - `tokenId` must not exist.
715      * - If `to` refers to a smart contract, it must implement {IERC721Receiver-onERC721Received}, which is called upon a safe transfer.
716      *
717      * Emits a {Transfer} event.
718      */
719     function _safeMint(address to, uint256 tokenId) internal virtual {
720         _safeMint(to, tokenId, "");
721     }
722 
723     /**
724      * @dev Same as {xref-ERC721-_safeMint-address-uint256-}[`_safeMint`], with an additional `data` parameter which is
725      * forwarded in {IERC721Receiver-onERC721Received} to contract recipients.
726      */
727     function _safeMint(
728         address to,
729         uint256 tokenId,
730         bytes memory _data
731     ) internal virtual {
732         _mint(to, tokenId);
733         require(
734             _checkOnERC721Received(address(0), to, tokenId, _data),
735             "ERC721: transfer to non ERC721Receiver implementer"
736         );
737     }
738 
739     /**
740      * @dev Mints `tokenId` and transfers it to `to`.
741      *
742      * WARNING: Usage of this method is discouraged, use {_safeMint} whenever possible
743      *
744      * Requirements:
745      *
746      * - `tokenId` must not exist.
747      * - `to` cannot be the zero address.
748      *
749      * Emits a {Transfer} event.
750      */
751     function _mint(address to, uint256 tokenId) internal virtual {
752         require(to != address(0), "ERC721: mint to the zero address");
753         require(!_exists(tokenId), "ERC721: token already minted");
754 
755         _beforeTokenTransfer(address(0), to, tokenId);
756 
757         _balances[to] += 1;
758         _owners[tokenId] = to;
759 
760         emit Transfer(address(0), to, tokenId);
761     }
762 
763     /**
764      * @dev Destroys `tokenId`.
765      * The approval is cleared when the token is burned.
766      *
767      * Requirements:
768      *
769      * - `tokenId` must exist.
770      *
771      * Emits a {Transfer} event.
772      */
773     function _burn(uint256 tokenId) internal virtual {
774         address owner = ERC721.ownerOf(tokenId);
775 
776         _beforeTokenTransfer(owner, address(0), tokenId);
777 
778         // Clear approvals
779         _approve(address(0), tokenId);
780 
781         _balances[owner] -= 1;
782         delete _owners[tokenId];
783 
784         emit Transfer(owner, address(0), tokenId);
785     }
786 
787     /**
788      * @dev Transfers `tokenId` from `from` to `to`.
789      *  As opposed to {transferFrom}, this imposes no restrictions on msg.sender.
790      *
791      * Requirements:
792      *
793      * - `to` cannot be the zero address.
794      * - `tokenId` token must be owned by `from`.
795      *
796      * Emits a {Transfer} event.
797      */
798     function _transfer(
799         address from,
800         address to,
801         uint256 tokenId
802     ) internal virtual {
803         require(ERC721.ownerOf(tokenId) == from, "ERC721: transfer of token that is not own");
804         require(to != address(0), "ERC721: transfer to the zero address");
805 
806         _beforeTokenTransfer(from, to, tokenId);
807 
808         // Clear approvals from the previous owner
809         _approve(address(0), tokenId);
810 
811         _balances[from] -= 1;
812         _balances[to] += 1;
813         _owners[tokenId] = to;
814 
815         emit Transfer(from, to, tokenId);
816     }
817 
818     /**
819      * @dev Approve `to` to operate on `tokenId`
820      *
821      * Emits a {Approval} event.
822      */
823     function _approve(address to, uint256 tokenId) internal virtual {
824         _tokenApprovals[tokenId] = to;
825         emit Approval(ERC721.ownerOf(tokenId), to, tokenId);
826     }
827 
828     /**
829      * @dev Approve `operator` to operate on all of `owner` tokens
830      *
831      * Emits a {ApprovalForAll} event.
832      */
833     function _setApprovalForAll(
834         address owner,
835         address operator,
836         bool approved
837     ) internal virtual {
838         require(owner != operator, "ERC721: approve to caller");
839         _operatorApprovals[owner][operator] = approved;
840         emit ApprovalForAll(owner, operator, approved);
841     }
842 
843     /**
844      * @dev Internal function to invoke {IERC721Receiver-onERC721Received} on a target address.
845      * The call is not executed if the target address is not a contract.
846      *
847      * @param from address representing the previous owner of the given token ID
848      * @param to target address that will receive the tokens
849      * @param tokenId uint256 ID of the token to be transferred
850      * @param _data bytes optional data to send along with the call
851      * @return bool whether the call correctly returned the expected magic value
852      */
853     function _checkOnERC721Received(
854         address from,
855         address to,
856         uint256 tokenId,
857         bytes memory _data
858     ) private returns (bool) {
859         if (to.isContract()) {
860             try IERC721Receiver(to).onERC721Received(_msgSender(), from, tokenId, _data) returns (bytes4 retval) {
861                 return retval == IERC721Receiver.onERC721Received.selector;
862             } catch (bytes memory reason) {
863                 if (reason.length == 0) {
864                     revert("ERC721: transfer to non ERC721Receiver implementer");
865                 } else {
866                     assembly {
867                         revert(add(32, reason), mload(reason))
868                     }
869                 }
870             }
871         } else {
872             return true;
873         }
874     }
875 
876     /**
877      * @dev Hook that is called before any token transfer. This includes minting
878      * and burning.
879      *
880      * Calling conditions:
881      *
882      * - When `from` and `to` are both non-zero, ``from``'s `tokenId` will be
883      * transferred to `to`.
884      * - When `from` is zero, `tokenId` will be minted for `to`.
885      * - When `to` is zero, ``from``'s `tokenId` will be burned.
886      * - `from` and `to` are never both zero.
887      *
888      * To learn more about hooks, head to xref:ROOT:extending-contracts.adoc#using-hooks[Using Hooks].
889      */
890     function _beforeTokenTransfer(
891         address from,
892         address to,
893         uint256 tokenId
894     ) internal virtual {}
895 } 
896 
897 abstract contract ERC721Enumerable is ERC721, IERC721Enumerable {
898     // Mapping from owner to list of owned token IDs
899     mapping(address => mapping(uint256 => uint256)) private _ownedTokens;
900 
901     // Mapping from token ID to index of the owner tokens list
902     mapping(uint256 => uint256) private _ownedTokensIndex;
903 
904     // Array with all token ids, used for enumeration
905     uint256[] private _allTokens;
906 
907     // Mapping from token id to position in the allTokens array
908     mapping(uint256 => uint256) private _allTokensIndex;
909 
910     /**
911      * @dev See {IERC165-supportsInterface}.
912      */
913     function supportsInterface(bytes4 interfaceId) public view virtual override(IERC165, ERC721) returns (bool) {
914         return interfaceId == type(IERC721Enumerable).interfaceId || super.supportsInterface(interfaceId);
915     }
916 
917     /**
918      * @dev See {IERC721Enumerable-tokenOfOwnerByIndex}.
919      */
920     function tokenOfOwnerByIndex(address owner, uint256 index) public view virtual override returns (uint256) {
921         require(index < ERC721.balanceOf(owner), "ERC721Enumerable: owner index out of bounds");
922         return _ownedTokens[owner][index];
923     }
924 
925     /**
926      * @dev See {IERC721Enumerable-totalSupply}.
927      */
928     function totalSupply() public view virtual override returns (uint256) {
929         return _allTokens.length;
930     }
931 
932     /**
933      * @dev See {IERC721Enumerable-tokenByIndex}.
934      */
935     function tokenByIndex(uint256 index) public view virtual override returns (uint256) {
936         require(index < ERC721Enumerable.totalSupply(), "ERC721Enumerable: global index out of bounds");
937         return _allTokens[index];
938     }
939 
940     /**
941      * @dev Hook that is called before any token transfer. This includes minting
942      * and burning.
943      *
944      * Calling conditions:
945      *
946      * - When `from` and `to` are both non-zero, ``from``'s `tokenId` will be
947      * transferred to `to`.
948      * - When `from` is zero, `tokenId` will be minted for `to`.
949      * - When `to` is zero, ``from``'s `tokenId` will be burned.
950      * - `from` cannot be the zero address.
951      * - `to` cannot be the zero address.
952      *
953      * To learn more about hooks, head to xref:ROOT:extending-contracts.adoc#using-hooks[Using Hooks].
954      */
955     function _beforeTokenTransfer(
956         address from,
957         address to,
958         uint256 tokenId
959     ) internal virtual override {
960         super._beforeTokenTransfer(from, to, tokenId);
961 
962         if (from == address(0)) {
963             _addTokenToAllTokensEnumeration(tokenId);
964         } else if (from != to) {
965             _removeTokenFromOwnerEnumeration(from, tokenId);
966         }
967         if (to == address(0)) {
968             _removeTokenFromAllTokensEnumeration(tokenId);
969         } else if (to != from) {
970             _addTokenToOwnerEnumeration(to, tokenId);
971         }
972     }
973 
974     /**
975      * @dev Private function to add a token to this extension's ownership-tracking data structures.
976      * @param to address representing the new owner of the given token ID
977      * @param tokenId uint256 ID of the token to be added to the tokens list of the given address
978      */
979     function _addTokenToOwnerEnumeration(address to, uint256 tokenId) private {
980         uint256 length = ERC721.balanceOf(to);
981         _ownedTokens[to][length] = tokenId;
982         _ownedTokensIndex[tokenId] = length;
983     }
984 
985     /**
986      * @dev Private function to add a token to this extension's token tracking data structures.
987      * @param tokenId uint256 ID of the token to be added to the tokens list
988      */
989     function _addTokenToAllTokensEnumeration(uint256 tokenId) private {
990         _allTokensIndex[tokenId] = _allTokens.length;
991         _allTokens.push(tokenId);
992     }
993 
994     /**
995      * @dev Private function to remove a token from this extension's ownership-tracking data structures. Note that
996      * while the token is not assigned a new owner, the `_ownedTokensIndex` mapping is _not_ updated: this allows for
997      * gas optimizations e.g. when performing a transfer operation (avoiding double writes).
998      * This has O(1) time complexity, but alters the order of the _ownedTokens array.
999      * @param from address representing the previous owner of the given token ID
1000      * @param tokenId uint256 ID of the token to be removed from the tokens list of the given address
1001      */
1002     function _removeTokenFromOwnerEnumeration(address from, uint256 tokenId) private {
1003         // To prevent a gap in from's tokens array, we store the last token in the index of the token to delete, and
1004         // then delete the last slot (swap and pop).
1005 
1006         uint256 lastTokenIndex = ERC721.balanceOf(from) - 1;
1007         uint256 tokenIndex = _ownedTokensIndex[tokenId];
1008 
1009         // When the token to delete is the last token, the swap operation is unnecessary
1010         if (tokenIndex != lastTokenIndex) {
1011             uint256 lastTokenId = _ownedTokens[from][lastTokenIndex];
1012 
1013             _ownedTokens[from][tokenIndex] = lastTokenId; // Move the last token to the slot of the to-delete token
1014             _ownedTokensIndex[lastTokenId] = tokenIndex; // Update the moved token's index
1015         }
1016 
1017         // This also deletes the contents at the last position of the array
1018         delete _ownedTokensIndex[tokenId];
1019         delete _ownedTokens[from][lastTokenIndex];
1020     }
1021 
1022     /**
1023      * @dev Private function to remove a token from this extension's token tracking data structures.
1024      * This has O(1) time complexity, but alters the order of the _allTokens array.
1025      * @param tokenId uint256 ID of the token to be removed from the tokens list
1026      */
1027     function _removeTokenFromAllTokensEnumeration(uint256 tokenId) private {
1028         // To prevent a gap in the tokens array, we store the last token in the index of the token to delete, and
1029         // then delete the last slot (swap and pop).
1030 
1031         uint256 lastTokenIndex = _allTokens.length - 1;
1032         uint256 tokenIndex = _allTokensIndex[tokenId];
1033 
1034         // When the token to delete is the last token, the swap operation is unnecessary. However, since this occurs so
1035         // rarely (when the last minted token is burnt) that we still do the swap here to avoid the gas cost of adding
1036         // an 'if' statement (like in _removeTokenFromOwnerEnumeration)
1037         uint256 lastTokenId = _allTokens[lastTokenIndex];
1038 
1039         _allTokens[tokenIndex] = lastTokenId; // Move the last token to the slot of the to-delete token
1040         _allTokensIndex[lastTokenId] = tokenIndex; // Update the moved token's index
1041 
1042         // This also deletes the contents at the last position of the array
1043         delete _allTokensIndex[tokenId];
1044         _allTokens.pop();
1045     }
1046 } 
1047 
1048 library MerkleProof {
1049     /**
1050      * @dev Returns true if a `leaf` can be proved to be a part of a Merkle tree
1051      * defined by `root`. For this, a `proof` must be provided, containing
1052      * sibling hashes on the branch from the leaf to the root of the tree. Each
1053      * pair of leaves and each pair of pre-images are assumed to be sorted.
1054      */
1055     function verify(
1056         bytes32[] memory proof,
1057         bytes32 root,
1058         bytes32 leaf
1059     ) internal pure returns (bool) {
1060         return processProof(proof, leaf) == root;
1061     }
1062 
1063     /**
1064      * @dev Returns the rebuilt hash obtained by traversing a Merklee tree up
1065      * from `leaf` using `proof`. A `proof` is valid if and only if the rebuilt
1066      * hash matches the root of the tree. When processing the proof, the pairs
1067      * of leafs & pre-images are assumed to be sorted.
1068      *
1069      * _Available since v4.4._
1070      */
1071     function processProof(bytes32[] memory proof, bytes32 leaf) internal pure returns (bytes32) {
1072         bytes32 computedHash = leaf;
1073         for (uint256 i = 0; i < proof.length; i++) {
1074             bytes32 proofElement = proof[i];
1075             if (computedHash <= proofElement) {
1076                 // Hash(current computed hash + current element of the proof)
1077                 computedHash = keccak256(abi.encodePacked(computedHash, proofElement));
1078             } else {
1079                 // Hash(current element of the proof + current computed hash)
1080                 computedHash = keccak256(abi.encodePacked(proofElement, computedHash));
1081             }
1082         }
1083         return computedHash;
1084     }
1085 } 
1086 
1087 abstract contract Ownable is Context {
1088     address private _owner;
1089 
1090     event OwnershipTransferred(address indexed previousOwner, address indexed newOwner);
1091 
1092     /**
1093      * @dev Initializes the contract setting the deployer as the initial owner.
1094      */
1095     constructor() {
1096         _transferOwnership(_msgSender());
1097     }
1098 
1099     /**
1100      * @dev Returns the address of the current owner.
1101      */
1102     function owner() public view virtual returns (address) {
1103         return _owner;
1104     }
1105 
1106     /**
1107      * @dev Throws if called by any account other than the owner.
1108      */
1109     modifier onlyOwner() {
1110         require(owner() == _msgSender(), "Ownable: caller is not the owner");
1111         _;
1112     }
1113 
1114     /**
1115      * @dev Leaves the contract without owner. It will not be possible to call
1116      * `onlyOwner` functions anymore. Can only be called by the current owner.
1117      *
1118      * NOTE: Renouncing ownership will leave the contract without an owner,
1119      * thereby removing any functionality that is only available to the owner.
1120      */
1121     function renounceOwnership() public virtual onlyOwner {
1122         _transferOwnership(address(0));
1123     }
1124 
1125     /**
1126      * @dev Transfers ownership of the contract to a new account (`newOwner`).
1127      * Can only be called by the current owner.
1128      */
1129     function transferOwnership(address newOwner) public virtual onlyOwner {
1130         require(newOwner != address(0), "Ownable: new owner is the zero address");
1131         _transferOwnership(newOwner);
1132     }
1133 
1134     /**
1135      * @dev Transfers ownership of the contract to a new account (`newOwner`).
1136      * Internal function without access restriction.
1137      */
1138     function _transferOwnership(address newOwner) internal virtual {
1139         address oldOwner = _owner;
1140         _owner = newOwner;
1141         emit OwnershipTransferred(oldOwner, newOwner);
1142     }
1143 } 
1144 
1145 contract Cybernites is Ownable, ERC721Enumerable {
1146     using Strings for uint256;
1147 
1148     enum MintState {Inactive, Private, Public}
1149 
1150     string private _token_baseExtension = ".json";
1151     string private _token_baseUri =       "https://cybernites1sa.blob.core.windows.net/tokens/";
1152     string private _token_metadataUri =   "https://cybernites1sa.blob.core.windows.net/tokens/cybernites-metadata.json";
1153     mapping(address => uint256) _token_shareholders;
1154 
1155     MintState private _mint_state = MintState.Inactive;
1156 
1157     uint256 private _mint_price = 0.1 ether;
1158     uint256 private _mint_maxSupply = 11111;
1159     uint256 private _mint_maxSupplyTemporary = 8100;  //to restrict minting temporarily (e.g., to change minting parameters)
1160     uint256 private _mint_maxPerMint = 6;
1161     uint256 private _mint_maxPerWallet = 6;
1162     bytes32 private _mint_merkleRoot;
1163     uint256 private _mint_globalCode;
1164     uint256[] private _mint_requested2Minted = [0,1,3,4,6];
1165  
1166     mapping(uint256 => address) _mint_tokenId2Authors;
1167     mapping(address => uint256) _mint_privileged;
1168 
1169     address private _transfer_poolAddress;
1170 
1171     constructor() payable ERC721("Cybernites", "CYBERNITES") {
1172         mint(msg.sender, 25, 0, new bytes32[](0));
1173     }
1174 
1175     receive() external payable {} // default receive, so ether can be sent to the contract account
1176 
1177     function verifyMerkle(bytes32 root, bytes32 leaf, bytes32[] memory proof) 
1178         internal pure returns (bool) {
1179             return MerkleProof.verify(proof, root, leaf);
1180     }
1181 
1182     function pay(uint256 amount) public payable {
1183         if (msg.sender != owner() && _mint_privileged[msg.sender] == 0) {
1184             require(
1185                 msg.value >= amount,
1186                 "Not enough ether."
1187             );
1188         }
1189     }
1190 
1191     function mint(address to, uint256 mintAmount, uint256 code, bytes32[] memory proof) public payable {
1192         uint256 mintedWithBonuses = calculateBonuses(mintAmount);
1193         checkMintPreConditions(to, code, mintedWithBonuses, proof);
1194 
1195         uint256 totalCost = _mint_price * mintAmount;
1196         pay(totalCost);
1197 
1198         uint256 supply = totalSupply();
1199         for (uint256 i = 1; i <= mintedWithBonuses; i++) {
1200             _mint_tokenId2Authors[supply + i]=to;
1201             _safeMint(to, supply + i);
1202         }
1203     }
1204     function tokenAuthor(uint tokenId) public view returns(address) {
1205         return _mint_tokenId2Authors[tokenId];
1206     }
1207 
1208     function walletOfAccount(address _owner)
1209         public view returns (uint256[] memory)
1210     {
1211         uint256 ownerTokenCount = balanceOf(_owner);
1212         uint256[] memory tokenIds = new uint256[](ownerTokenCount);
1213         for (uint256 i; i < ownerTokenCount; i++) {
1214             tokenIds[i] = tokenOfOwnerByIndex(_owner, i);
1215         }
1216 
1217         return tokenIds;
1218     }
1219 
1220     function tokenURI(uint256 tokenId)
1221         public view virtual override returns (string memory)
1222     {
1223         require(
1224             _exists(tokenId),
1225             "Invalid token"
1226         );
1227 
1228         string memory currentBaseURI = _baseURI();
1229         return
1230             bytes(currentBaseURI).length > 0
1231                 ? string(
1232                     abi.encodePacked(
1233                         currentBaseURI,
1234                         tokenId.toString(),
1235                         _token_baseExtension
1236                     )
1237                 )
1238                 : "";
1239     }
1240 
1241     // private
1242     
1243     function calculateBonuses(uint256 mintedAmount) private view returns(uint256 result){
1244         if(msg.sender == owner() || _mint_privileged[msg.sender] > 0) { return mintedAmount; } 
1245 
1246         require(
1247             mintedAmount < _mint_requested2Minted.length ,
1248             "Too many"
1249         );
1250 
1251         uint256 mintedWithBonuses = _mint_requested2Minted[mintedAmount];
1252         return mintedWithBonuses;
1253     }
1254 
1255     function isProofOk(bytes32[] memory proof) private view returns (bool result) {
1256         bytes32 sender = keccak256(abi.encodePacked(msg.sender));
1257         return verifyMerkle(_mint_merkleRoot, sender, proof);
1258     }
1259 
1260     function checkMintPreConditions(address buyer, uint256 code, uint256 mintedAmount, bytes32[] memory proof) 
1261         private view {
1262         checkTokenAmount(mintedAmount);
1263         checkMintMode(code, proof);
1264         checkMaxPerMint(mintedAmount);
1265         checkMaxPerWallet(buyer, mintedAmount);
1266     }
1267 
1268     function checkAuthorization(uint256 code, bytes32[] memory proof) private view {
1269         require(
1270             msg.sender == owner() || _mint_privileged[msg.sender] > 0 ||
1271             (code == _mint_globalCode && _mint_globalCode != 0) || 
1272             isProofOk(proof), 
1273             "Unauthorized");
1274     }
1275     function checkMintMode(uint256 code, bytes32[] memory proof) private view {
1276         require(
1277             msg.sender == owner() || _mint_state != MintState.Inactive, 
1278             "Minting closed"
1279         );
1280 
1281         if(_mint_state == MintState.Private){
1282             checkAuthorization(code, proof);
1283         }
1284     }
1285     function checkMaxPerMint(uint256 mintedAmount) private view {
1286         require(
1287             msg.sender == owner() || 
1288             mintedAmount <= _mint_maxPerMint, 
1289             "Max per mint"
1290         );
1291     }
1292     function checkMaxPerWallet(address buyer, uint256 mintedAmount) private view {
1293         require(
1294             msg.sender == owner() || _mint_privileged[msg.sender] > 0 ||
1295             balanceOf(buyer) + mintedAmount <= _mint_maxPerWallet, 
1296             "Max per wallet"
1297         );
1298     }
1299     function checkTokenAmount(uint256 mintedAmount) private view {
1300         require(mintedAmount > 0, "Only >0 can be minted");
1301         require(totalSupply() + mintedAmount <= _mint_maxSupply, "Max tokens");
1302         require(totalSupply() + mintedAmount <= _mint_maxSupplyTemporary, "Minting paused");
1303     }
1304 
1305     // public getters and setters (only owner)
1306 
1307     function getBalance() public view returns (uint256) { return address(this).balance; }
1308     function getBalanceOfAny(address any_account) public view  returns (uint256) { return any_account.balance; }
1309 
1310     function baseExtension() public view virtual returns (string memory) { return _token_baseExtension; }
1311     function setBaseExtension(string memory newExtension) public onlyOwner { _token_baseExtension = newExtension; }
1312 
1313     function _baseURI() internal view virtual override returns (string memory) { return _token_baseUri; }
1314     function setBaseURI(string memory newUri) public onlyOwner { _token_baseUri = newUri; }
1315 
1316     function metadataUri() public view virtual returns (string memory) { return _token_metadataUri; }
1317     function setMetadataUri(string memory newUri) public onlyOwner { _token_metadataUri = newUri; }
1318 
1319     function mintState() public view virtual returns (MintState) { return _mint_state; }
1320     function setMintState(MintState newState) public onlyOwner { _mint_state = newState; }
1321 
1322     function price() public view virtual returns (uint256) { return _mint_price; }
1323     function setPrice(uint256 newPrice) public onlyOwner { _mint_price = newPrice; }
1324 
1325     function maxSupply() public view virtual returns (uint256) { return _mint_maxSupply; }
1326     function setMaxSupply(uint256 newSupply) public onlyOwner { _mint_maxSupply = newSupply; }
1327 
1328     function maxSupplyTemporary() public view virtual returns (uint256) { return _mint_maxSupplyTemporary; }
1329     function setMaxSupplyTemporary(uint256 newTemporarySupply) public onlyOwner { _mint_maxSupplyTemporary = newTemporarySupply; }
1330 
1331     function maxPerMint() public view virtual returns (uint256) { return _mint_maxPerMint; }
1332     function setMaxPerMint(uint256 newMax) public onlyOwner { _mint_maxPerMint = newMax; }
1333 
1334     function maxPerWallet() public view virtual returns (uint256) { return _mint_maxPerWallet; }
1335     function setMaxPerWallet(uint256 newMax) public onlyOwner { _mint_maxPerWallet = newMax; }
1336 
1337     function merkleRoot() public view virtual returns (bytes32) { return _mint_merkleRoot; }
1338     function setMerkleRoot(bytes32 newRoot) public onlyOwner { _mint_merkleRoot = newRoot; }
1339 
1340     function globalCode() public view virtual returns (uint256 code) { return _mint_globalCode; }
1341     function setGlobalCode(uint256 newCode) public onlyOwner { _mint_globalCode = newCode; }
1342 
1343     function requested2Minted() public view virtual returns (uint256[] memory) { return _mint_requested2Minted; }
1344     function setRequested2Minted(uint256[] calldata newArray) public onlyOwner { _mint_requested2Minted = newArray; }
1345 
1346     function getShare(address shareholder) public view returns (uint256 promile) { return _token_shareholders[shareholder]; }
1347 
1348     // other public - only owner
1349 
1350     function updateShareholder(address shareholder, uint256 promile) public onlyOwner {
1351         _token_shareholders[shareholder]=promile;
1352     }
1353 
1354     function getPrivileged(address privileged) public onlyOwner view returns (uint256 privileges) { return _mint_privileged[privileged]; }
1355     function updatePrivileged(address privileged, uint256 privileges) public onlyOwner {
1356         _mint_privileged[privileged] = privileges;
1357     }
1358 
1359     function withdraw() public onlyOwner {
1360         require(
1361             payable(msg.sender).send(address(this).balance),
1362             "Withdraw failed"
1363         );
1364     }
1365 
1366     function withdrawAmount(uint256 amount) public onlyOwner {
1367         (bool success, ) = msg.sender.call{value: amount}("");
1368         require(success, "Transfer failed");
1369     }
1370 
1371 }