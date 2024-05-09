1 /**
2  *Submitted for verification at Etherscan.io on 2022-03-21
3 */
4 
5 // Hi. If you have any questions or comments in this smart contract please let me know at:
6 // Whatsapp +923178866631, website : http://corecis.org
7 //
8 //
9 // Complete DApp created by Corecis 
10 //
11 //
12 //
13 // SPDX-License-Identifier: MIT
14 
15 pragma solidity ^0.8.9;
16 library Address {
17     /**
18      * @dev Returns true if `account` is a contract.
19      *
20      * [IMPORTANT]
21      * ====
22      * It is unsafe to assume that an address for which this function returns
23      * false is an externally-owned account (EOA) and not a contract.
24      *
25      * Among others, `isContract` will return false for the following
26      * types of addresses:
27      *
28      *  - an externally-owned account
29      *  - a contract in construction
30      *  - an address where a contract will be created
31      *  - an address where a contract lived, but was destroyed
32      * ====
33      */
34     function isContract(address account) internal view returns (bool) {
35         // This method relies on extcodesize, which returns 0 for contracts in
36         // construction, since the code is only stored at the end of the
37         // constructor execution.
38 
39         uint256 size;
40         assembly {
41             size := extcodesize(account)
42         }
43         return size > 0;
44     }
45 
46     /**
47      * @dev Replacement for Solidity's `transfer`: sends `amount` wei to
48      * `recipient`, forwarding all available gas and reverting on errors.
49      *
50      * https://eips.ethereum.org/EIPS/eip-1884[EIP1884] increases the gas cost
51      * of certain opcodes, possibly making contracts go over the 2300 gas limit
52      * imposed by `transfer`, making them unable to receive funds via
53      * `transfer`. {sendValue} removes this limitation.
54      *
55      * https://diligence.consensys.net/posts/2019/09/stop-using-soliditys-transfer-now/[Learn more].
56      *
57      * IMPORTANT: because control is transferred to `recipient`, care must be
58      * taken to not create reentrancy vulnerabilities. Consider using
59      * {ReentrancyGuard} or the
60      * https://solidity.readthedocs.io/en/v0.5.11/security-considerations.html#use-the-checks-effects-interactions-pattern[checks-effects-interactions pattern].
61      */
62     function sendValue(address payable recipient, uint256 amount) internal {
63         require(address(this).balance >= amount, "Address: insufficient balance");
64 
65         (bool success, ) = recipient.call{value: amount}("");
66         require(success, "Address: unable to send value, recipient may have reverted");
67     }
68 
69     /**
70      * @dev Performs a Solidity function call using a low level `call`. A
71      * plain `call` is an unsafe replacement for a function call: use this
72      * function instead.
73      *
74      * If `target` reverts with a revert reason, it is bubbled up by this
75      * function (like regular Solidity function calls).
76      *
77      * Returns the raw returned data. To convert to the expected return value,
78      * use https://solidity.readthedocs.io/en/latest/units-and-global-variables.html?highlight=abi.decode#abi-encoding-and-decoding-functions[`abi.decode`].
79      *
80      * Requirements:
81      *
82      * - `target` must be a contract.
83      * - calling `target` with `data` must not revert.
84      *
85      * _Available since v3.1._
86      */
87     function functionCall(address target, bytes memory data) internal returns (bytes memory) {
88         return functionCall(target, data, "Address: low-level call failed");
89     }
90 
91     /**
92      * @dev Same as {xref-Address-functionCall-address-bytes-}[`functionCall`], but with
93      * `errorMessage` as a fallback revert reason when `target` reverts.
94      *
95      * _Available since v3.1._
96      */
97     function functionCall(
98         address target,
99         bytes memory data,
100         string memory errorMessage
101     ) internal returns (bytes memory) {
102         return functionCallWithValue(target, data, 0, errorMessage);
103     }
104 
105     /**
106      * @dev Same as {xref-Address-functionCall-address-bytes-}[`functionCall`],
107      * but also transferring `value` wei to `target`.
108      *
109      * Requirements:
110      *
111      * - the calling contract must have an ETH balance of at least `value`.
112      * - the called Solidity function must be `payable`.
113      *
114      * _Available since v3.1._
115      */
116     function functionCallWithValue(
117         address target,
118         bytes memory data,
119         uint256 value
120     ) internal returns (bytes memory) {
121         return functionCallWithValue(target, data, value, "Address: low-level call with value failed");
122     }
123 
124     /**
125      * @dev Same as {xref-Address-functionCallWithValue-address-bytes-uint256-}[`functionCallWithValue`], but
126      * with `errorMessage` as a fallback revert reason when `target` reverts.
127      *
128      * _Available since v3.1._
129      */
130     function functionCallWithValue(
131         address target,
132         bytes memory data,
133         uint256 value,
134         string memory errorMessage
135     ) internal returns (bytes memory) {
136         require(address(this).balance >= value, "Address: insufficient balance for call");
137         require(isContract(target), "Address: call to non-contract");
138 
139         (bool success, bytes memory returndata) = target.call{value: value}(data);
140         return verifyCallResult(success, returndata, errorMessage);
141     }
142 
143     /**
144      * @dev Same as {xref-Address-functionCall-address-bytes-}[`functionCall`],
145      * but performing a static call.
146      *
147      * _Available since v3.3._
148      */
149     function functionStaticCall(address target, bytes memory data) internal view returns (bytes memory) {
150         return functionStaticCall(target, data, "Address: low-level static call failed");
151     }
152 
153     /**
154      * @dev Same as {xref-Address-functionCall-address-bytes-string-}[`functionCall`],
155      * but performing a static call.
156      *
157      * _Available since v3.3._
158      */
159     function functionStaticCall(
160         address target,
161         bytes memory data,
162         string memory errorMessage
163     ) internal view returns (bytes memory) {
164         require(isContract(target), "Address: static call to non-contract");
165 
166         (bool success, bytes memory returndata) = target.staticcall(data);
167         return verifyCallResult(success, returndata, errorMessage);
168     }
169 
170     /**
171      * @dev Same as {xref-Address-functionCall-address-bytes-}[`functionCall`],
172      * but performing a delegate call.
173      *
174      * _Available since v3.4._
175      */
176     function functionDelegateCall(address target, bytes memory data) internal returns (bytes memory) {
177         return functionDelegateCall(target, data, "Address: low-level delegate call failed");
178     }
179 
180     /**
181      * @dev Same as {xref-Address-functionCall-address-bytes-string-}[`functionCall`],
182      * but performing a delegate call.
183      *
184      * _Available since v3.4._
185      */
186     function functionDelegateCall(
187         address target,
188         bytes memory data,
189         string memory errorMessage
190     ) internal returns (bytes memory) {
191         require(isContract(target), "Address: delegate call to non-contract");
192 
193         (bool success, bytes memory returndata) = target.delegatecall(data);
194         return verifyCallResult(success, returndata, errorMessage);
195     }
196 
197     /**
198      * @dev Tool to verifies that a low level call was successful, and revert if it wasn't, either by bubbling the
199      * revert reason using the provided one.
200      *
201      * _Available since v4.3._
202      */
203     function verifyCallResult(
204         bool success,
205         bytes memory returndata,
206         string memory errorMessage
207     ) internal pure returns (bytes memory) {
208         if (success) {
209             return returndata;
210         } else {
211             // Look for revert reason and bubble it up if present
212             if (returndata.length > 0) {
213                 // The easiest way to bubble the revert reason is using memory via assembly
214 
215                 assembly {
216                     let returndata_size := mload(returndata)
217                     revert(add(32, returndata), returndata_size)
218                 }
219             } else {
220                 revert(errorMessage);
221             }
222         }
223     }
224 }
225 library Strings {
226     bytes16 private constant _HEX_SYMBOLS = "0123456789abcdef";
227 
228     /**
229      * @dev Converts a `uint256` to its ASCII `string` decimal representation.
230      */
231     function toString(uint256 value) internal pure returns (string memory) {
232         // Inspired by OraclizeAPI's implementation - MIT licence
233         // https://github.com/oraclize/ethereum-api/blob/b42146b063c7d6ee1358846c198246239e9360e8/oraclizeAPI_0.4.25.sol
234 
235         if (value == 0) {
236             return "0";
237         }
238         uint256 temp = value;
239         uint256 digits;
240         while (temp != 0) {
241             digits++;
242             temp /= 10;
243         }
244         bytes memory buffer = new bytes(digits);
245         while (value != 0) {
246             digits -= 1;
247             buffer[digits] = bytes1(uint8(48 + uint256(value % 10)));
248             value /= 10;
249         }
250         return string(buffer);
251     }
252 
253     /**
254      * @dev Converts a `uint256` to its ASCII `string` hexadecimal representation.
255      */
256     function toHexString(uint256 value) internal pure returns (string memory) {
257         if (value == 0) {
258             return "0x00";
259         }
260         uint256 temp = value;
261         uint256 length = 0;
262         while (temp != 0) {
263             length++;
264             temp >>= 8;
265         }
266         return toHexString(value, length);
267     }
268 
269     /**
270      * @dev Converts a `uint256` to its ASCII `string` hexadecimal representation with fixed length.
271      */
272     function toHexString(uint256 value, uint256 length) internal pure returns (string memory) {
273         bytes memory buffer = new bytes(2 * length + 2);
274         buffer[0] = "0";
275         buffer[1] = "x";
276         for (uint256 i = 2 * length + 1; i > 1; --i) {
277             buffer[i] = _HEX_SYMBOLS[value & 0xf];
278             value >>= 4;
279         }
280         require(value == 0, "Strings: hex length insufficient");
281         return string(buffer);
282     }
283 }
284 
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
302 interface IERC165 {
303     /**
304      * @dev Returns true if this contract implements the interface defined by
305      * `interfaceId`. See the corresponding
306      * https://eips.ethereum.org/EIPS/eip-165#how-interfaces-are-identified[EIP section]
307      * to learn more about how these ids are created.
308      *
309      * This function call must use less than 30 000 gas.
310      */
311     function supportsInterface(bytes4 interfaceId) external view returns (bool);
312 }
313 abstract contract ERC165 is IERC165 {
314     /**
315      * @dev See {IERC165-supportsInterface}.
316      */
317     function supportsInterface(bytes4 interfaceId) public view virtual override returns (bool) {
318         return interfaceId == type(IERC165).interfaceId;
319     }
320 }
321 interface IERC721 is IERC165 {
322     /**
323      * @dev Emitted when `tokenId` token is transferred from `from` to `to`.
324      */
325     event Transfer(address indexed from, address indexed to, uint256 indexed tokenId);
326 
327     /**
328      * @dev Emitted when `owner` enables `approved` to manage the `tokenId` token.
329      */
330     event Approval(address indexed owner, address indexed approved, uint256 indexed tokenId);
331 
332     /**
333      * @dev Emitted when `owner` enables or disables (`approved`) `operator` to manage all of its assets.
334      */
335     event ApprovalForAll(address indexed owner, address indexed operator, bool approved);
336 
337     /**
338      * @dev Returns the number of tokens in ``owner``'s account.
339      */
340     function balanceOf(address owner) external view returns (uint256 balance);
341 
342     /**
343      * @dev Returns the owner of the `tokenId` token.
344      *
345      * Requirements:
346      *
347      * - `tokenId` must exist.
348      */
349     function ownerOf(uint256 tokenId) external view returns (address owner);
350 
351     /**
352      * @dev Safely transfers `tokenId` token from `from` to `to`, checking first that contract recipients
353      * are aware of the ERC721 protocol to prevent tokens from being forever locked.
354      *
355      * Requirements:
356      *
357      * - `from` cannot be the zero address.
358      * - `to` cannot be the zero address.
359      * - `tokenId` token must exist and be owned by `from`.
360      * - If the caller is not `from`, it must be have been allowed to move this token by either {approve} or {setApprovalForAll}.
361      * - If `to` refers to a smart contract, it must implement {IERC721Receiver-onERC721Received}, which is called upon a safe transfer.
362      *
363      * Emits a {Transfer} event.
364      */
365     function safeTransferFrom(
366         address from,
367         address to,
368         uint256 tokenId
369     ) external;
370 
371     /**
372      * @dev Transfers `tokenId` token from `from` to `to`.
373      *
374      * WARNING: Usage of this method is discouraged, use {safeTransferFrom} whenever possible.
375      *
376      * Requirements:
377      *
378      * - `from` cannot be the zero address.
379      * - `to` cannot be the zero address.
380      * - `tokenId` token must be owned by `from`.
381      * - If the caller is not `from`, it must be approved to move this token by either {approve} or {setApprovalForAll}.
382      *
383      * Emits a {Transfer} event.
384      */
385     function transferFrom(
386         address from,
387         address to,
388         uint256 tokenId
389     ) external;
390 
391     /**
392      * @dev Gives permission to `to` to transfer `tokenId` token to another account.
393      * The approval is cleared when the token is transferred.
394      *
395      * Only a single account can be approved at a time, so approving the zero address clears previous approvals.
396      *
397      * Requirements:
398      *
399      * - The caller must own the token or be an approved operator.
400      * - `tokenId` must exist.
401      *
402      * Emits an {Approval} event.
403      */
404     function approve(address to, uint256 tokenId) external;
405 
406     /**
407      * @dev Returns the account approved for `tokenId` token.
408      *
409      * Requirements:
410      *
411      * - `tokenId` must exist.
412      */
413     function getApproved(uint256 tokenId) external view returns (address operator);
414 
415     /**
416      * @dev Approve or remove `operator` as an operator for the caller.
417      * Operators can call {transferFrom} or {safeTransferFrom} for any token owned by the caller.
418      *
419      * Requirements:
420      *
421      * - The `operator` cannot be the caller.
422      *
423      * Emits an {ApprovalForAll} event.
424      */
425     function setApprovalForAll(address operator, bool _approved) external;
426 
427     /**
428      * @dev Returns if the `operator` is allowed to manage all of the assets of `owner`.
429      *
430      * See {setApprovalForAll}
431      */
432     function isApprovedForAll(address owner, address operator) external view returns (bool);
433 
434     /**
435      * @dev Safely transfers `tokenId` token from `from` to `to`.
436      *
437      * Requirements:
438      *
439      * - `from` cannot be the zero address.
440      * - `to` cannot be the zero address.
441      * - `tokenId` token must exist and be owned by `from`.
442      * - If the caller is not `from`, it must be approved to move this token by either {approve} or {setApprovalForAll}.
443      * - If `to` refers to a smart contract, it must implement {IERC721Receiver-onERC721Received}, which is called upon a safe transfer.
444      *
445      * Emits a {Transfer} event.
446      */
447     function safeTransferFrom(
448         address from,
449         address to,
450         uint256 tokenId,
451         bytes calldata data
452     ) external;
453 }
454 interface IERC721Metadata is IERC721 {
455     /**
456      * @dev Returns the token collection name.
457      */
458     function name() external view returns (string memory);
459 
460     /**
461      * @dev Returns the token collection symbol.
462      */
463     function symbol() external view returns (string memory);
464 
465     /**
466      * @dev Returns the Uniform Resource Identifier (URI) for `tokenId` token.
467      */
468     function tokenURI(uint256 tokenId) external view returns (string memory);
469 }
470 abstract contract Context {
471     function _msgSender() internal view virtual returns (address) {
472         return msg.sender;
473     }
474 
475     function _msgData() internal view virtual returns (bytes calldata) {
476         return msg.data;
477     }
478 }
479 contract ERC721 is Context, ERC165, IERC721, IERC721Metadata {
480     using Address for address;
481     using Strings for uint256;
482 
483     // Token name
484     string private _name;
485 
486     // Token symbol
487     string private _symbol;
488 
489     // Mapping from token ID to owner address
490     mapping(uint256 => address) private _owners;
491 
492     // Mapping owner address to token count
493     mapping(address => uint256) private _balances;
494 
495     // Mapping from token ID to approved address
496     mapping(uint256 => address) private _tokenApprovals;
497 
498     // Mapping from owner to operator approvals
499     mapping(address => mapping(address => bool)) private _operatorApprovals;
500 
501     /**
502      * @dev Initializes the contract by setting a `name` and a `symbol` to the token collection.
503      */
504     constructor(string memory name_, string memory symbol_) {
505         _name = name_;
506         _symbol = symbol_;
507     }
508 
509     /**
510      * @dev See {IERC165-supportsInterface}.
511      */
512     function supportsInterface(bytes4 interfaceId) public view virtual override(ERC165, IERC165) returns (bool) {
513         return
514             interfaceId == type(IERC721).interfaceId ||
515             interfaceId == type(IERC721Metadata).interfaceId ||
516             super.supportsInterface(interfaceId);
517     }
518 
519     /**
520      * @dev See {IERC721-balanceOf}.
521      */
522     function balanceOf(address owner) public view virtual override returns (uint256) {
523         require(owner != address(0), "ERC721: balance query for the zero address");
524         return _balances[owner];
525     }
526 
527     /**
528      * @dev See {IERC721-ownerOf}.
529      */
530     function ownerOf(uint256 tokenId) public view virtual override returns (address) {
531         address owner = _owners[tokenId];
532         require(owner != address(0), "ERC721: owner query for nonexistent token");
533         return owner;
534     }
535 
536     /**
537      * @dev See {IERC721Metadata-name}.
538      */
539     function name() public view virtual override returns (string memory) {
540         return _name;
541     }
542 
543     /**
544      * @dev See {IERC721Metadata-symbol}.
545      */
546     function symbol() public view virtual override returns (string memory) {
547         return _symbol;
548     }
549 
550     /**
551      * @dev See {IERC721Metadata-tokenURI}.
552      */
553     function tokenURI(uint256 tokenId) public view virtual override returns (string memory) {
554         require(_exists(tokenId), "ERC721Metadata: URI query for nonexistent token");
555 
556         string memory baseURI = _baseURI();
557         return bytes(baseURI).length > 0 ? string(abi.encodePacked(baseURI, tokenId.toString())) : "";
558     }
559 
560     /**
561      * @dev Base URI for computing {tokenURI}. If set, the resulting URI for each
562      * token will be the concatenation of the `baseURI` and the `tokenId`. Empty
563      * by default, can be overriden in child contracts.
564      */
565     function _baseURI() internal view virtual returns (string memory) {
566         return "";
567     }
568 
569     /**
570      * @dev See {IERC721-approve}.
571      */
572     function approve(address to, uint256 tokenId) public virtual override {
573         address owner = ERC721.ownerOf(tokenId);
574         require(to != owner, "ERC721: approval to current owner");
575 
576         require(
577             _msgSender() == owner || isApprovedForAll(owner, _msgSender()),
578             "ERC721: approve caller is not owner nor approved for all"
579         );
580 
581         _approve(to, tokenId);
582     }
583 
584     /**
585      * @dev See {IERC721-getApproved}.
586      */
587     function getApproved(uint256 tokenId) public view virtual override returns (address) {
588         require(_exists(tokenId), "ERC721: approved query for nonexistent token");
589 
590         return _tokenApprovals[tokenId];
591     }
592 
593     /**
594      * @dev See {IERC721-setApprovalForAll}.
595      */
596     function setApprovalForAll(address operator, bool approved) public virtual override {
597         _setApprovalForAll(_msgSender(), operator, approved);
598     }
599 
600     /**
601      * @dev See {IERC721-isApprovedForAll}.
602      */
603     function isApprovedForAll(address owner, address operator) public view virtual override returns (bool) {
604         return _operatorApprovals[owner][operator];
605     }
606 
607     /**
608      * @dev See {IERC721-transferFrom}.
609      */
610     function transferFrom(
611         address from,
612         address to,
613         uint256 tokenId
614     ) public virtual override {
615         //solhint-disable-next-line max-line-length
616         require(_isApprovedOrOwner(_msgSender(), tokenId), "ERC721: transfer caller is not owner nor approved");
617 
618         _transfer(from, to, tokenId);
619     }
620 
621     /**
622      * @dev See {IERC721-safeTransferFrom}.
623      */
624     function safeTransferFrom(
625         address from,
626         address to,
627         uint256 tokenId
628     ) public virtual override {
629         safeTransferFrom(from, to, tokenId, "");
630     }
631 
632     /**
633      * @dev See {IERC721-safeTransferFrom}.
634      */
635     function safeTransferFrom(
636         address from,
637         address to,
638         uint256 tokenId,
639         bytes memory _data
640     ) public virtual override {
641         require(_isApprovedOrOwner(_msgSender(), tokenId), "ERC721: transfer caller is not owner nor approved");
642         _safeTransfer(from, to, tokenId, _data);
643     }
644 
645     /**
646      * @dev Safely transfers `tokenId` token from `from` to `to`, checking first that contract recipients
647      * are aware of the ERC721 protocol to prevent tokens from being forever locked.
648      *
649      * `_data` is additional data, it has no specified format and it is sent in call to `to`.
650      *
651      * This internal function is equivalent to {safeTransferFrom}, and can be used to e.g.
652      * implement alternative mechanisms to perform token transfer, such as signature-based.
653      *
654      * Requirements:
655      *
656      * - `from` cannot be the zero address.
657      * - `to` cannot be the zero address.
658      * - `tokenId` token must exist and be owned by `from`.
659      * - If `to` refers to a smart contract, it must implement {IERC721Receiver-onERC721Received}, which is called upon a safe transfer.
660      *
661      * Emits a {Transfer} event.
662      */
663     function _safeTransfer(
664         address from,
665         address to,
666         uint256 tokenId,
667         bytes memory _data
668     ) internal virtual {
669         _transfer(from, to, tokenId);
670         require(_checkOnERC721Received(from, to, tokenId, _data), "ERC721: transfer to non ERC721Receiver implementer");
671     }
672 
673     /**
674      * @dev Returns whether `tokenId` exists.
675      *
676      * Tokens can be managed by their owner or approved accounts via {approve} or {setApprovalForAll}.
677      *
678      * Tokens start existing when they are minted (`_mint`),
679      * and stop existing when they are burned (`_burn`).
680      */
681     function _exists(uint256 tokenId) internal view virtual returns (bool) {
682         return _owners[tokenId] != address(0);
683     }
684 
685     /**
686      * @dev Returns whether `spender` is allowed to manage `tokenId`.
687      *
688      * Requirements:
689      *
690      * - `tokenId` must exist.
691      */
692     function _isApprovedOrOwner(address spender, uint256 tokenId) internal view virtual returns (bool) {
693         require(_exists(tokenId), "ERC721: operator query for nonexistent token");
694         address owner = ERC721.ownerOf(tokenId);
695         return (spender == owner || getApproved(tokenId) == spender || isApprovedForAll(owner, spender));
696     }
697 
698     /**
699      * @dev Safely mints `tokenId` and transfers it to `to`.
700      *
701      * Requirements:
702      *
703      * - `tokenId` must not exist.
704      * - If `to` refers to a smart contract, it must implement {IERC721Receiver-onERC721Received}, which is called upon a safe transfer.
705      *
706      * Emits a {Transfer} event.
707      */
708     function _safeMint(address to, uint256 tokenId) internal virtual {
709         _safeMint(to, tokenId, "");
710     }
711 
712     /**
713      * @dev Same as {xref-ERC721-_safeMint-address-uint256-}[`_safeMint`], with an additional `data` parameter which is
714      * forwarded in {IERC721Receiver-onERC721Received} to contract recipients.
715      */
716     function _safeMint(
717         address to,
718         uint256 tokenId,
719         bytes memory _data
720     ) internal virtual {
721         _mint(to, tokenId);
722         require(
723             _checkOnERC721Received(address(0), to, tokenId, _data),
724             "ERC721: transfer to non ERC721Receiver implementer"
725         );
726     }
727 
728     /**
729      * @dev Mints `tokenId` and transfers it to `to`.
730      *
731      * WARNING: Usage of this method is discouraged, use {_safeMint} whenever possible
732      *
733      * Requirements:
734      *
735      * - `tokenId` must not exist.
736      * - `to` cannot be the zero address.
737      *
738      * Emits a {Transfer} event.
739      */
740     function _mint(address to, uint256 tokenId) internal virtual {
741         require(to != address(0), "ERC721: mint to the zero address");
742         require(!_exists(tokenId), "ERC721: token already minted");
743 
744         _beforeTokenTransfer(address(0), to, tokenId);
745 
746         _balances[to] += 1;
747         _owners[tokenId] = to;
748 
749         emit Transfer(address(0), to, tokenId);
750     }
751 
752     /**
753      * @dev Destroys `tokenId`.
754      * The approval is cleared when the token is burned.
755      *
756      * Requirements:
757      *
758      * - `tokenId` must exist.
759      *
760      * Emits a {Transfer} event.
761      */
762     function _burn(uint256 tokenId) internal virtual {
763         address owner = ERC721.ownerOf(tokenId);
764 
765         _beforeTokenTransfer(owner, address(0), tokenId);
766 
767         // Clear approvals
768         _approve(address(0), tokenId);
769 
770         _balances[owner] -= 1;
771         delete _owners[tokenId];
772 
773         emit Transfer(owner, address(0), tokenId);
774     }
775 
776     /**
777      * @dev Transfers `tokenId` from `from` to `to`.
778      *  As opposed to {transferFrom}, this imposes no restrictions on msg.sender.
779      *
780      * Requirements:
781      *
782      * - `to` cannot be the zero address.
783      * - `tokenId` token must be owned by `from`.
784      *
785      * Emits a {Transfer} event.
786      */
787     function _transfer(
788         address from,
789         address to,
790         uint256 tokenId
791     ) internal virtual {
792         require(ERC721.ownerOf(tokenId) == from, "ERC721: transfer of token that is not own");
793         require(to != address(0), "ERC721: transfer to the zero address");
794 
795         _beforeTokenTransfer(from, to, tokenId);
796 
797         // Clear approvals from the previous owner
798         _approve(address(0), tokenId);
799 
800         _balances[from] -= 1;
801         _balances[to] += 1;
802         _owners[tokenId] = to;
803 
804         emit Transfer(from, to, tokenId);
805     }
806 
807     /**
808      * @dev Approve `to` to operate on `tokenId`
809      *
810      * Emits a {Approval} event.
811      */
812     function _approve(address to, uint256 tokenId) internal virtual {
813         _tokenApprovals[tokenId] = to;
814         emit Approval(ERC721.ownerOf(tokenId), to, tokenId);
815     }
816 
817     /**
818      * @dev Approve `operator` to operate on all of `owner` tokens
819      *
820      * Emits a {ApprovalForAll} event.
821      */
822     function _setApprovalForAll(
823         address owner,
824         address operator,
825         bool approved
826     ) internal virtual {
827         require(owner != operator, "ERC721: approve to caller");
828         _operatorApprovals[owner][operator] = approved;
829         emit ApprovalForAll(owner, operator, approved);
830     }
831 
832     /**
833      * @dev Internal function to invoke {IERC721Receiver-onERC721Received} on a target address.
834      * The call is not executed if the target address is not a contract.
835      *
836      * @param from address representing the previous owner of the given token ID
837      * @param to target address that will receive the tokens
838      * @param tokenId uint256 ID of the token to be transferred
839      * @param _data bytes optional data to send along with the call
840      * @return bool whether the call correctly returned the expected magic value
841      */
842     function _checkOnERC721Received(
843         address from,
844         address to,
845         uint256 tokenId,
846         bytes memory _data
847     ) private returns (bool) {
848         if (to.isContract()) {
849             try IERC721Receiver(to).onERC721Received(_msgSender(), from, tokenId, _data) returns (bytes4 retval) {
850                 return retval == IERC721Receiver.onERC721Received.selector;
851             } catch (bytes memory reason) {
852                 if (reason.length == 0) {
853                     revert("ERC721: transfer to non ERC721Receiver implementer");
854                 } else {
855                     assembly {
856                         revert(add(32, reason), mload(reason))
857                     }
858                 }
859             }
860         } else {
861             return true;
862         }
863     }
864 
865     /**
866      * @dev Hook that is called before any token transfer. This includes minting
867      * and burning.
868      *
869      * Calling conditions:
870      *
871      * - When `from` and `to` are both non-zero, ``from``'s `tokenId` will be
872      * transferred to `to`.
873      * - When `from` is zero, `tokenId` will be minted for `to`.
874      * - When `to` is zero, ``from``'s `tokenId` will be burned.
875      * - `from` and `to` are never both zero.
876      *
877      * To learn more about hooks, head to xref:ROOT:extending-contracts.adoc#using-hooks[Using Hooks].
878      */
879     function _beforeTokenTransfer(
880         address from,
881         address to,
882         uint256 tokenId
883     ) internal virtual {}
884 }
885 
886 
887 /*
888         _____ _               _          
889         /  __ \ |             | |         
890         | /  \/ |__   ___  ___| | ___   _ 
891         | |   | '_ \ / _ \/ _ \ |/ / | | |
892         | \__/\ | | |  __/  __/   <| |_| |
893         \____/_| |_|\___|\___|_|\_\\__, |
894                                     __/ |
895                                     |___/ 
896 
897 /                                    _____       _     
898                                     /  __ \     | |    
899                                     | /  \/_   _| |__  
900                                     | |   | | | | '_ \ 
901                                     | \__/\ |_| | |_) |
902                                     \____/\__,_|_.__/ 
903                                                     
904 
905 /                                                _____ _       _     
906                                                 /  __ \ |     | |    
907                                                 | /  \/ |_   _| |__  
908                                                 | |   | | | | | '_ \ 
909                                                 | \__/\ | |_| | |_) |
910                                                 \____/_|\__,_|_.__/ 
911 
912 
913 
914 */
915 
916 contract CheekyCubClub is ERC721("Cheeky Cub Club", "CCC") {
917 
918     IERC721 public Lion;
919     IERC721 public Cougar;
920     string public baseURI;
921     bool public isSaleActive;
922     bool isBreedCubActive;
923     uint256 public circulatingSupply;
924     address public owner;
925     uint[] _BreadedLion;
926     uint[] _BreededCougar;
927     uint256 public constant totalSupply = 10333;
928     uint256 public itemPrice = 0.04 ether;
929 
930     mapping(uint => uint) BreededLion;
931     mapping(uint => uint) BreededCougar;
932 
933     constructor(address _lion, address _cougar, address _owner) {
934         Lion = IERC721(_lion);
935         Cougar = IERC721(_cougar);
936         owner = _owner;
937     }
938 
939     /////////////////////////////////
940     //    breeding conditioner     //
941     /////////////////////////////////
942 
943 
944 
945     // ✅ done Checked
946     function breedingCondition(uint _howMany, uint _Lion, uint _Cougar)internal{
947         require(Lion.ownerOf(_Lion) == msg.sender, "your are not owner of this Lion");
948         require(Cougar.ownerOf(_Cougar) == msg.sender, "your are not owner of this Cougar");
949         require(breededLion(_Lion) != true && breededCougar(_Cougar) != true, "already Breeded");
950         require(_howMany <= Lion.balanceOf(msg.sender), "You dont have enough Lions");
951         require(_howMany <= Cougar.balanceOf(msg.sender), "You dont have enough Cougars");
952         _BreadedLion.push(_Lion);
953         _BreededCougar.push(_Cougar);
954         BreededLion[_Lion] = _Cougar;
955         BreededCougar[_Cougar] = _Lion;
956     }
957 
958     // ✅ done Checked
959     function checkAvailabilityOfLion(uint _Lion) public view returns(string memory message){
960         if(breededLion(_Lion) == true){
961             return message = "not availability";
962         }else{
963             return message = "available";
964         }
965     }
966 
967     // ✅ done Checked
968     function checkAvailabilityOfCougar(uint _Cougar) public view returns(string memory message){
969         if(breededCougar(_Cougar) == true){
970             return message = "not availability";
971         }else{
972             return message = "available";
973         }
974     }
975 
976     // ✅ done Checked
977     function breededLion(uint _Lion) public view returns(bool breeded){
978             if(BreededLion[_Lion] > 0){
979                 return breeded = true;
980             }
981     }
982 
983     // ✅ done Checked
984     function breededCougar(uint _Cougar) public view returns(bool breeded){
985             if(BreededCougar[_Cougar] > 0){
986                 return breeded = true;
987             }
988     }
989 
990     ////////////////////
991     //  PUBLIC SALE   //
992     ////////////////////
993 
994     // Purchase NFT
995 
996     // ✅ done Checked
997     function breedCub(uint256 _howMany, uint _Lion, uint _Cougar)
998         external
999         tokensAvailable(_howMany)
1000     {
1001         require(
1002             isBreedCubActive && circulatingSupply <= 10333,
1003             "Breed is not active"
1004         );
1005         breedingCondition(_howMany,_Lion,_Cougar);
1006         _mint(msg.sender, ++circulatingSupply);
1007     }
1008 
1009     // ✅ done Checked
1010     function startBreedCub() external onlyOwner {
1011         isBreedCubActive = true;
1012     }
1013     // ✅ done Checked
1014     function stopBreedCub() external onlyOwner {
1015         isBreedCubActive = false;
1016     }
1017 
1018     // ✅ done Checked
1019     // Purchase multiple NFTs at once
1020     function purchaseTokens(uint256 _howMany)
1021         external
1022         payable
1023         tokensAvailable(_howMany)
1024     {
1025 
1026         require( isSaleActive, "Sale is not active" );
1027 
1028         require( _howMany > 0 && _howMany <= 10, "Mint min 1, max 10" );
1029 
1030         require( msg.value >= _howMany * itemPrice, "Try to send more ETH" );
1031 
1032         require( circulatingSupply <= 10333, "can't mint more then circulating supply" );
1033 
1034         payable(owner).transfer(msg.value);
1035 
1036         for (uint256 i = 0; i < _howMany; i++)
1037             _mint(msg.sender, ++circulatingSupply);
1038 
1039     }
1040 
1041     //Gift 
1042         // Send NFTs to a list of addresses
1043     function giftNftToList(address[] calldata _sendNftsTo)
1044         external
1045         onlyOwner
1046         tokensAvailable(_sendNftsTo.length)
1047     {
1048         for (uint256 i = 0; i < _sendNftsTo.length; i++)
1049             _mint(_sendNftsTo[i], ++circulatingSupply);
1050     }
1051 
1052     function LionFinder() public view returns(uint[] memory){
1053         return _BreadedLion;
1054     }
1055     function CougarFinder() public view returns(uint[] memory){
1056         return _BreededCougar;
1057     }
1058 
1059     //////////////////////////
1060     // Only Owner Methods   //
1061     //////////////////////////
1062     
1063     // ✅ done Checked
1064     function stopSale() external onlyOwner {
1065         isSaleActive = false;
1066     }
1067     // ✅ done Checked
1068     function startSale() external onlyOwner {
1069         isSaleActive = true;
1070     }
1071 
1072     // Hide identity or show identity from here
1073     // ✅ done Checked
1074     function setBaseURI(string memory __baseURI) external onlyOwner {
1075         baseURI = __baseURI;
1076     }
1077 
1078     // ✅ done Checked
1079     // Change price in case of ETH price changes too much
1080     function setPrice(uint256 _newPrice) external onlyOwner {
1081         itemPrice = _newPrice;
1082     }
1083 
1084 
1085     ///////////////////
1086     // Query Method  //
1087     ///////////////////
1088     
1089     // ✅ done Checked
1090     function tokensRemaining() public view returns (uint256) {
1091         return totalSupply - circulatingSupply;
1092     }
1093     
1094     function _baseURI() internal view override returns (string memory) {
1095         return baseURI;
1096     }
1097 
1098     ///////////////////
1099     //   Modifiers   //
1100     ///////////////////
1101 
1102     // ✅ done Checked
1103     modifier tokensAvailable(uint256 _howMany) {
1104         require(_howMany <= tokensRemaining(), "Try minting less tokens");
1105         _;
1106     }
1107 
1108     // ✅ done Checked
1109     modifier onlyOwner() {
1110         require(owner == msg.sender, "Ownable: caller is not the owner");
1111         _;
1112     }
1113 }