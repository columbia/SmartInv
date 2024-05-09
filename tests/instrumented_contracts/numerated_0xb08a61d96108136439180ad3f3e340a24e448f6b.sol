1 // SPDX-License-Identifier: MIT
2 pragma solidity ^0.8.0;
3 
4 /**
5  * @dev Interface of the ERC165 standard, as defined in the
6  * https://eips.ethereum.org/EIPS/eip-165[EIP].
7  *
8  * Implementers can declare support of contract interfaces, which can then be
9  * queried by others ({ERC165Checker}).
10  *
11  * For an implementation, see {ERC165}.
12  */
13 interface IERC165 {
14     /**
15      * @dev Returns true if this contract implements the interface defined by
16      * `interfaceId`. See the corresponding
17      * https://eips.ethereum.org/EIPS/eip-165#how-interfaces-are-identified[EIP section]
18      * to learn more about how these ids are created.
19      *
20      * This function call must use less than 30 000 gas.
21      */
22     function supportsInterface(bytes4 interfaceId) external view returns (bool);
23 }
24 
25 
26 /**
27  * @dev Required interface of an ERC721 compliant contract.
28  */
29 interface IERC721 is IERC165 {
30     /**
31      * @dev Emitted when `tokenId` token is transferred from `from` to `to`.
32      */
33     event Transfer(address indexed from, address indexed to, uint256 indexed tokenId);
34 
35     /**
36      * @dev Emitted when `owner` enables `approved` to manage the `tokenId` token.
37      */
38     event Approval(address indexed owner, address indexed approved, uint256 indexed tokenId);
39 
40     /**
41      * @dev Emitted when `owner` enables or disables (`approved`) `operator` to manage all of its assets.
42      */
43     event ApprovalForAll(address indexed owner, address indexed operator, bool approved);
44 
45     /**
46      * @dev Returns the number of tokens in ``owner``'s account.
47      */
48     function balanceOf(address owner) external view returns (uint256 balance);
49 
50     /**
51      * @dev Returns the owner of the `tokenId` token.
52      *
53      * Requirements:
54      *
55      * - `tokenId` must exist.
56      */
57     function ownerOf(uint256 tokenId) external view returns (address owner);
58 
59     /**
60      * @dev Safely transfers `tokenId` token from `from` to `to`, checking first that contract recipients
61      * are aware of the ERC721 protocol to prevent tokens from being forever locked.
62      *
63      * Requirements:
64      *
65      * - `from` cannot be the zero address.
66      * - `to` cannot be the zero address.
67      * - `tokenId` token must exist and be owned by `from`.
68      * - If the caller is not `from`, it must be have been allowed to move this token by either {approve} or {setApprovalForAll}.
69      * - If `to` refers to a smart contract, it must implement {IERC721Receiver-onERC721Received}, which is called upon a safe transfer.
70      *
71      * Emits a {Transfer} event.
72      */
73     function safeTransferFrom(
74         address from,
75         address to,
76         uint256 tokenId
77     ) external;
78 
79     /**
80      * @dev Transfers `tokenId` token from `from` to `to`.
81      *
82      * WARNING: Usage of this method is discouraged, use {safeTransferFrom} whenever possible.
83      *
84      * Requirements:
85      *
86      * - `from` cannot be the zero address.
87      * - `to` cannot be the zero address.
88      * - `tokenId` token must be owned by `from`.
89      * - If the caller is not `from`, it must be approved to move this token by either {approve} or {setApprovalForAll}.
90      *
91      * Emits a {Transfer} event.
92      */
93     function transferFrom(
94         address from,
95         address to,
96         uint256 tokenId
97     ) external;
98 
99     /**
100      * @dev Gives permission to `to` to transfer `tokenId` token to another account.
101      * The approval is cleared when the token is transferred.
102      *
103      * Only a single account can be approved at a time, so approving the zero address clears previous approvals.
104      *
105      * Requirements:
106      *
107      * - The caller must own the token or be an approved operator.
108      * - `tokenId` must exist.
109      *
110      * Emits an {Approval} event.
111      */
112     function approve(address to, uint256 tokenId) external;
113 
114     /**
115      * @dev Returns the account approved for `tokenId` token.
116      *
117      * Requirements:
118      *
119      * - `tokenId` must exist.
120      */
121     function getApproved(uint256 tokenId) external view returns (address operator);
122 
123     /**
124      * @dev Approve or remove `operator` as an operator for the caller.
125      * Operators can call {transferFrom} or {safeTransferFrom} for any token owned by the caller.
126      *
127      * Requirements:
128      *
129      * - The `operator` cannot be the caller.
130      *
131      * Emits an {ApprovalForAll} event.
132      */
133     function setApprovalForAll(address operator, bool _approved) external;
134 
135     /**
136      * @dev Returns if the `operator` is allowed to manage all of the assets of `owner`.
137      *
138      * See {setApprovalForAll}
139      */
140     function isApprovedForAll(address owner, address operator) external view returns (bool);
141 
142     /**
143      * @dev Safely transfers `tokenId` token from `from` to `to`.
144      *
145      * Requirements:
146      *
147      * - `from` cannot be the zero address.
148      * - `to` cannot be the zero address.
149      * - `tokenId` token must exist and be owned by `from`.
150      * - If the caller is not `from`, it must be approved to move this token by either {approve} or {setApprovalForAll}.
151      * - If `to` refers to a smart contract, it must implement {IERC721Receiver-onERC721Received}, which is called upon a safe transfer.
152      *
153      * Emits a {Transfer} event.
154      */
155     function safeTransferFrom(
156         address from,
157         address to,
158         uint256 tokenId,
159         bytes calldata data
160     ) external;
161 }
162 
163 
164 /**
165  * @title ERC721 token receiver interface
166  * @dev Interface for any contract that wants to support safeTransfers
167  * from ERC721 asset contracts.
168  */
169 interface IERC721Receiver {
170     /**
171      * @dev Whenever an {IERC721} `tokenId` token is transferred to this contract via {IERC721-safeTransferFrom}
172      * by `operator` from `from`, this function is called.
173      *
174      * It must return its Solidity selector to confirm the token transfer.
175      * If any other value is returned or the interface is not implemented by the recipient, the transfer will be reverted.
176      *
177      * The selector can be obtained in Solidity with `IERC721.onERC721Received.selector`.
178      */
179     function onERC721Received(
180         address operator,
181         address from,
182         uint256 tokenId,
183         bytes calldata data
184     ) external returns (bytes4);
185 }
186 
187 
188 /**
189  * @title ERC-721 Non-Fungible Token Standard, optional metadata extension
190  * @dev See https://eips.ethereum.org/EIPS/eip-721
191  */
192 interface IERC721Metadata is IERC721 {
193     /**
194      * @dev Returns the token collection name.
195      */
196     function name() external view returns (string memory);
197 
198     /**
199      * @dev Returns the token collection symbol.
200      */
201     function symbol() external view returns (string memory);
202 
203     /**
204      * @dev Returns the Uniform Resource Identifier (URI) for `tokenId` token.
205      */
206     function tokenURI(uint256 tokenId) external view returns (string memory);
207 }
208 
209 
210 /**
211  * @dev Collection of functions related to the address type
212  */
213 library Address {
214     /**
215      * @dev Returns true if `account` is a contract.
216      *
217      * [IMPORTANT]
218      * ====
219      * It is unsafe to assume that an address for which this function returns
220      * false is an externally-owned account (EOA) and not a contract.
221      *
222      * Among others, `isContract` will return false for the following
223      * types of addresses:
224      *
225      *  - an externally-owned account
226      *  - a contract in construction
227      *  - an address where a contract will be created
228      *  - an address where a contract lived, but was destroyed
229      * ====
230      */
231     function isContract(address account) internal view returns (bool) {
232         // This method relies on extcodesize, which returns 0 for contracts in
233         // construction, since the code is only stored at the end of the
234         // constructor execution.
235 
236         uint256 size;
237         assembly {
238             size := extcodesize(account)
239         }
240         return size > 0;
241     }
242 
243     /**
244      * @dev Replacement for Solidity's `transfer`: sends `amount` wei to
245      * `recipient`, forwarding all available gas and reverting on errors.
246      *
247      * https://eips.ethereum.org/EIPS/eip-1884[EIP1884] increases the gas cost
248      * of certain opcodes, possibly making contracts go over the 2300 gas limit
249      * imposed by `transfer`, making them unable to receive funds via
250      * `transfer`. {sendValue} removes this limitation.
251      *
252      * https://diligence.consensys.net/posts/2019/09/stop-using-soliditys-transfer-now/[Learn more].
253      *
254      * IMPORTANT: because control is transferred to `recipient`, care must be
255      * taken to not create reentrancy vulnerabilities. Consider using
256      * {ReentrancyGuard} or the
257      * https://solidity.readthedocs.io/en/v0.5.11/security-considerations.html#use-the-checks-effects-interactions-pattern[checks-effects-interactions pattern].
258      */
259     function sendValue(address payable recipient, uint256 amount) internal {
260         require(address(this).balance >= amount, "Address: insufficient balance");
261 
262         (bool success, ) = recipient.call{value: amount}("");
263         require(success, "Address: unable to send value, recipient may have reverted");
264     }
265 
266     /**
267      * @dev Performs a Solidity function call using a low level `call`. A
268      * plain `call` is an unsafe replacement for a function call: use this
269      * function instead.
270      *
271      * If `target` reverts with a revert reason, it is bubbled up by this
272      * function (like regular Solidity function calls).
273      *
274      * Returns the raw returned data. To convert to the expected return value,
275      * use https://solidity.readthedocs.io/en/latest/units-and-global-variables.html?highlight=abi.decode#abi-encoding-and-decoding-functions[`abi.decode`].
276      *
277      * Requirements:
278      *
279      * - `target` must be a contract.
280      * - calling `target` with `data` must not revert.
281      *
282      * _Available since v3.1._
283      */
284     function functionCall(address target, bytes memory data) internal returns (bytes memory) {
285         return functionCall(target, data, "Address: low-level call failed");
286     }
287 
288     /**
289      * @dev Same as {xref-Address-functionCall-address-bytes-}[`functionCall`], but with
290      * `errorMessage` as a fallback revert reason when `target` reverts.
291      *
292      * _Available since v3.1._
293      */
294     function functionCall(
295         address target,
296         bytes memory data,
297         string memory errorMessage
298     ) internal returns (bytes memory) {
299         return functionCallWithValue(target, data, 0, errorMessage);
300     }
301 
302     /**
303      * @dev Same as {xref-Address-functionCall-address-bytes-}[`functionCall`],
304      * but also transferring `value` wei to `target`.
305      *
306      * Requirements:
307      *
308      * - the calling contract must have an ETH balance of at least `value`.
309      * - the called Solidity function must be `payable`.
310      *
311      * _Available since v3.1._
312      */
313     function functionCallWithValue(
314         address target,
315         bytes memory data,
316         uint256 value
317     ) internal returns (bytes memory) {
318         return functionCallWithValue(target, data, value, "Address: low-level call with value failed");
319     }
320 
321     /**
322      * @dev Same as {xref-Address-functionCallWithValue-address-bytes-uint256-}[`functionCallWithValue`], but
323      * with `errorMessage` as a fallback revert reason when `target` reverts.
324      *
325      * _Available since v3.1._
326      */
327     function functionCallWithValue(
328         address target,
329         bytes memory data,
330         uint256 value,
331         string memory errorMessage
332     ) internal returns (bytes memory) {
333         require(address(this).balance >= value, "Address: insufficient balance for call");
334         require(isContract(target), "Address: call to non-contract");
335 
336         (bool success, bytes memory returndata) = target.call{value: value}(data);
337         return verifyCallResult(success, returndata, errorMessage);
338     }
339 
340     /**
341      * @dev Same as {xref-Address-functionCall-address-bytes-}[`functionCall`],
342      * but performing a static call.
343      *
344      * _Available since v3.3._
345      */
346     function functionStaticCall(address target, bytes memory data) internal view returns (bytes memory) {
347         return functionStaticCall(target, data, "Address: low-level static call failed");
348     }
349 
350     /**
351      * @dev Same as {xref-Address-functionCall-address-bytes-string-}[`functionCall`],
352      * but performing a static call.
353      *
354      * _Available since v3.3._
355      */
356     function functionStaticCall(
357         address target,
358         bytes memory data,
359         string memory errorMessage
360     ) internal view returns (bytes memory) {
361         require(isContract(target), "Address: static call to non-contract");
362 
363         (bool success, bytes memory returndata) = target.staticcall(data);
364         return verifyCallResult(success, returndata, errorMessage);
365     }
366 
367     /**
368      * @dev Same as {xref-Address-functionCall-address-bytes-}[`functionCall`],
369      * but performing a delegate call.
370      *
371      * _Available since v3.4._
372      */
373     function functionDelegateCall(address target, bytes memory data) internal returns (bytes memory) {
374         return functionDelegateCall(target, data, "Address: low-level delegate call failed");
375     }
376 
377     /**
378      * @dev Same as {xref-Address-functionCall-address-bytes-string-}[`functionCall`],
379      * but performing a delegate call.
380      *
381      * _Available since v3.4._
382      */
383     function functionDelegateCall(
384         address target,
385         bytes memory data,
386         string memory errorMessage
387     ) internal returns (bytes memory) {
388         require(isContract(target), "Address: delegate call to non-contract");
389 
390         (bool success, bytes memory returndata) = target.delegatecall(data);
391         return verifyCallResult(success, returndata, errorMessage);
392     }
393 
394     /**
395      * @dev Tool to verifies that a low level call was successful, and revert if it wasn't, either by bubbling the
396      * revert reason using the provided one.
397      *
398      * _Available since v4.3._
399      */
400     function verifyCallResult(
401         bool success,
402         bytes memory returndata,
403         string memory errorMessage
404     ) internal pure returns (bytes memory) {
405         if (success) {
406             return returndata;
407         } else {
408             // Look for revert reason and bubble it up if present
409             if (returndata.length > 0) {
410                 // The easiest way to bubble the revert reason is using memory via assembly
411 
412                 assembly {
413                     let returndata_size := mload(returndata)
414                     revert(add(32, returndata), returndata_size)
415                 }
416             } else {
417                 revert(errorMessage);
418             }
419         }
420     }
421 }
422 
423 
424 /**
425  * @dev Provides information about the current execution context, including the
426  * sender of the transaction and its data. While these are generally available
427  * via msg.sender and msg.data, they should not be accessed in such a direct
428  * manner, since when dealing with meta-transactions the account sending and
429  * paying for execution may not be the actual sender (as far as an application
430  * is concerned).
431  *
432  * This contract is only required for intermediate, library-like contracts.
433  */
434 abstract contract Context {
435     function _msgSender() internal view virtual returns (address) {
436         return msg.sender;
437     }
438 
439     function _msgData() internal view virtual returns (bytes calldata) {
440         return msg.data;
441     }
442 }
443 
444 
445 /**
446  * @dev String operations.
447  */
448 library Strings {
449     bytes16 private constant _HEX_SYMBOLS = "0123456789abcdef";
450 
451     /**
452      * @dev Converts a `uint256` to its ASCII `string` decimal representation.
453      */
454     function toString(uint256 value) internal pure returns (string memory) {
455         // Inspired by OraclizeAPI's implementation - MIT licence
456         // https://github.com/oraclize/ethereum-api/blob/b42146b063c7d6ee1358846c198246239e9360e8/oraclizeAPI_0.4.25.sol
457 
458         if (value == 0) {
459             return "0";
460         }
461         uint256 temp = value;
462         uint256 digits;
463         while (temp != 0) {
464             digits++;
465             temp /= 10;
466         }
467         bytes memory buffer = new bytes(digits);
468         while (value != 0) {
469             digits -= 1;
470             buffer[digits] = bytes1(uint8(48 + uint256(value % 10)));
471             value /= 10;
472         }
473         return string(buffer);
474     }
475 
476     /**
477      * @dev Converts a `uint256` to its ASCII `string` hexadecimal representation.
478      */
479     function toHexString(uint256 value) internal pure returns (string memory) {
480         if (value == 0) {
481             return "0x00";
482         }
483         uint256 temp = value;
484         uint256 length = 0;
485         while (temp != 0) {
486             length++;
487             temp >>= 8;
488         }
489         return toHexString(value, length);
490     }
491 
492     /**
493      * @dev Converts a `uint256` to its ASCII `string` hexadecimal representation with fixed length.
494      */
495     function toHexString(uint256 value, uint256 length) internal pure returns (string memory) {
496         bytes memory buffer = new bytes(2 * length + 2);
497         buffer[0] = "0";
498         buffer[1] = "x";
499         for (uint256 i = 2 * length + 1; i > 1; --i) {
500             buffer[i] = _HEX_SYMBOLS[value & 0xf];
501             value >>= 4;
502         }
503         require(value == 0, "Strings: hex length insufficient");
504         return string(buffer);
505     }
506 }
507 
508 
509 /**
510  * @dev Implementation of the {IERC165} interface.
511  *
512  * Contracts that want to implement ERC165 should inherit from this contract and override {supportsInterface} to check
513  * for the additional interface id that will be supported. For example:
514  *
515  * ```solidity
516  * function supportsInterface(bytes4 interfaceId) public view virtual override returns (bool) {
517  *     return interfaceId == type(MyInterface).interfaceId || super.supportsInterface(interfaceId);
518  * }
519  * ```
520  *
521  * Alternatively, {ERC165Storage} provides an easier to use but more expensive implementation.
522  */
523 abstract contract ERC165 is IERC165 {
524     /**
525      * @dev See {IERC165-supportsInterface}.
526      */
527     function supportsInterface(bytes4 interfaceId) public view virtual override returns (bool) {
528         return interfaceId == type(IERC165).interfaceId;
529     }
530 }
531 
532 
533 /**
534  * @dev Implementation of https://eips.ethereum.org/EIPS/eip-721[ERC721] Non-Fungible Token Standard, including
535  * the Metadata extension, but not including the Enumerable extension, which is available separately as
536  * {ERC721Enumerable}.
537  */
538 contract ERC721 is Context, ERC165, IERC721, IERC721Metadata {
539     using Address for address;
540     using Strings for uint256;
541 
542     // Token name
543     string private _name;
544 
545     // Token symbol
546     string private _symbol;
547 
548     // Mapping from token ID to owner address
549     mapping(uint256 => address) private _owners;
550 
551     // Mapping owner address to token count
552     mapping(address => uint256) private _balances;
553 
554     // Mapping from token ID to approved address
555     mapping(uint256 => address) private _tokenApprovals;
556 
557     // Mapping from owner to operator approvals
558     mapping(address => mapping(address => bool)) private _operatorApprovals;
559 
560     /**
561      * @dev Initializes the contract by setting a `name` and a `symbol` to the token collection.
562      */
563     constructor(string memory name_, string memory symbol_) {
564         _name = name_;
565         _symbol = symbol_;
566     }
567 
568     /**
569      * @dev See {IERC165-supportsInterface}.
570      */
571     function supportsInterface(bytes4 interfaceId) public view virtual override(ERC165, IERC165) returns (bool) {
572         return
573             interfaceId == type(IERC721).interfaceId ||
574             interfaceId == type(IERC721Metadata).interfaceId ||
575             super.supportsInterface(interfaceId);
576     }
577 
578     /**
579      * @dev See {IERC721-balanceOf}.
580      */
581     function balanceOf(address owner) public view virtual override returns (uint256) {
582         require(owner != address(0), "ERC721: balance query for the zero address");
583         return _balances[owner];
584     }
585 
586     /**
587      * @dev See {IERC721-ownerOf}.
588      */
589     function ownerOf(uint256 tokenId) public view virtual override returns (address) {
590         address owner = _owners[tokenId];
591         require(owner != address(0), "ERC721: owner query for nonexistent token");
592         return owner;
593     }
594 
595     /**
596      * @dev See {IERC721Metadata-name}.
597      */
598     function name() public view virtual override returns (string memory) {
599         return _name;
600     }
601 
602     /**
603      * @dev See {IERC721Metadata-symbol}.
604      */
605     function symbol() public view virtual override returns (string memory) {
606         return _symbol;
607     }
608 
609     /**
610      * @dev See {IERC721Metadata-tokenURI}.
611      */
612     function tokenURI(uint256 tokenId) public view virtual override returns (string memory) {
613         require(_exists(tokenId), "ERC721Metadata: URI query for nonexistent token");
614 
615         string memory baseURI = _baseURI();
616         return bytes(baseURI).length > 0 ? string(abi.encodePacked(baseURI, tokenId.toString())) : "";
617     }
618 
619     /**
620      * @dev Base URI for computing {tokenURI}. If set, the resulting URI for each
621      * token will be the concatenation of the `baseURI` and the `tokenId`. Empty
622      * by default, can be overriden in child contracts.
623      */
624     function _baseURI() internal view virtual returns (string memory) {
625         return "";
626     }
627 
628     /**
629      * @dev See {IERC721-approve}.
630      */
631     function approve(address to, uint256 tokenId) public virtual override {
632         address owner = ERC721.ownerOf(tokenId);
633         require(to != owner, "ERC721: approval to current owner");
634 
635         require(
636             _msgSender() == owner || isApprovedForAll(owner, _msgSender()),
637             "ERC721: approve caller is not owner nor approved for all"
638         );
639 
640         _approve(to, tokenId);
641     }
642 
643     /**
644      * @dev See {IERC721-getApproved}.
645      */
646     function getApproved(uint256 tokenId) public view virtual override returns (address) {
647         require(_exists(tokenId), "ERC721: approved query for nonexistent token");
648 
649         return _tokenApprovals[tokenId];
650     }
651 
652     /**
653      * @dev See {IERC721-setApprovalForAll}.
654      */
655     function setApprovalForAll(address operator, bool approved) public virtual override {
656         require(operator != _msgSender(), "ERC721: approve to caller");
657 
658         _operatorApprovals[_msgSender()][operator] = approved;
659         emit ApprovalForAll(_msgSender(), operator, approved);
660     }
661 
662     /**
663      * @dev See {IERC721-isApprovedForAll}.
664      */
665     function isApprovedForAll(address owner, address operator) public view virtual override returns (bool) {
666         return _operatorApprovals[owner][operator];
667     }
668 
669     /**
670      * @dev See {IERC721-transferFrom}.
671      */
672     function transferFrom(
673         address from,
674         address to,
675         uint256 tokenId
676     ) public virtual override {
677         //solhint-disable-next-line max-line-length
678         require(_isApprovedOrOwner(_msgSender(), tokenId), "ERC721: transfer caller is not owner nor approved");
679 
680         _transfer(from, to, tokenId);
681     }
682 
683     /**
684      * @dev See {IERC721-safeTransferFrom}.
685      */
686     function safeTransferFrom(
687         address from,
688         address to,
689         uint256 tokenId
690     ) public virtual override {
691         safeTransferFrom(from, to, tokenId, "");
692     }
693 
694     /**
695      * @dev See {IERC721-safeTransferFrom}.
696      */
697     function safeTransferFrom(
698         address from,
699         address to,
700         uint256 tokenId,
701         bytes memory _data
702     ) public virtual override {
703         require(_isApprovedOrOwner(_msgSender(), tokenId), "ERC721: transfer caller is not owner nor approved");
704         _safeTransfer(from, to, tokenId, _data);
705     }
706 
707     /**
708      * @dev Safely transfers `tokenId` token from `from` to `to`, checking first that contract recipients
709      * are aware of the ERC721 protocol to prevent tokens from being forever locked.
710      *
711      * `_data` is additional data, it has no specified format and it is sent in call to `to`.
712      *
713      * This internal function is equivalent to {safeTransferFrom}, and can be used to e.g.
714      * implement alternative mechanisms to perform token transfer, such as signature-based.
715      *
716      * Requirements:
717      *
718      * - `from` cannot be the zero address.
719      * - `to` cannot be the zero address.
720      * - `tokenId` token must exist and be owned by `from`.
721      * - If `to` refers to a smart contract, it must implement {IERC721Receiver-onERC721Received}, which is called upon a safe transfer.
722      *
723      * Emits a {Transfer} event.
724      */
725     function _safeTransfer(
726         address from,
727         address to,
728         uint256 tokenId,
729         bytes memory _data
730     ) internal virtual {
731         _transfer(from, to, tokenId);
732         require(_checkOnERC721Received(from, to, tokenId, _data), "ERC721: transfer to non ERC721Receiver implementer");
733     }
734 
735     /**
736      * @dev Returns whether `tokenId` exists.
737      *
738      * Tokens can be managed by their owner or approved accounts via {approve} or {setApprovalForAll}.
739      *
740      * Tokens start existing when they are minted (`_mint`),
741      * and stop existing when they are burned (`_burn`).
742      */
743     function _exists(uint256 tokenId) internal view virtual returns (bool) {
744         return _owners[tokenId] != address(0);
745     }
746 
747     /**
748      * @dev Returns whether `spender` is allowed to manage `tokenId`.
749      *
750      * Requirements:
751      *
752      * - `tokenId` must exist.
753      */
754     function _isApprovedOrOwner(address spender, uint256 tokenId) internal view virtual returns (bool) {
755         require(_exists(tokenId), "ERC721: operator query for nonexistent token");
756         address owner = ERC721.ownerOf(tokenId);
757         return (spender == owner || getApproved(tokenId) == spender || isApprovedForAll(owner, spender));
758     }
759 
760     /**
761      * @dev Safely mints `tokenId` and transfers it to `to`.
762      *
763      * Requirements:
764      *
765      * - `tokenId` must not exist.
766      * - If `to` refers to a smart contract, it must implement {IERC721Receiver-onERC721Received}, which is called upon a safe transfer.
767      *
768      * Emits a {Transfer} event.
769      */
770     function _safeMint(address to, uint256 tokenId) internal virtual {
771         _safeMint(to, tokenId, "");
772     }
773 
774     /**
775      * @dev Same as {xref-ERC721-_safeMint-address-uint256-}[`_safeMint`], with an additional `data` parameter which is
776      * forwarded in {IERC721Receiver-onERC721Received} to contract recipients.
777      */
778     function _safeMint(
779         address to,
780         uint256 tokenId,
781         bytes memory _data
782     ) internal virtual {
783         _mint(to, tokenId);
784         require(
785             _checkOnERC721Received(address(0), to, tokenId, _data),
786             "ERC721: transfer to non ERC721Receiver implementer"
787         );
788     }
789 
790     /**
791      * @dev Mints `tokenId` and transfers it to `to`.
792      *
793      * WARNING: Usage of this method is discouraged, use {_safeMint} whenever possible
794      *
795      * Requirements:
796      *
797      * - `tokenId` must not exist.
798      * - `to` cannot be the zero address.
799      *
800      * Emits a {Transfer} event.
801      */
802     function _mint(address to, uint256 tokenId) internal virtual {
803         require(to != address(0), "ERC721: mint to the zero address");
804         require(!_exists(tokenId), "ERC721: token already minted");
805 
806         _beforeTokenTransfer(address(0), to, tokenId);
807 
808         _balances[to] += 1;
809         _owners[tokenId] = to;
810 
811         emit Transfer(address(0), to, tokenId);
812     }
813 
814     /**
815      * @dev Destroys `tokenId`.
816      * The approval is cleared when the token is burned.
817      *
818      * Requirements:
819      *
820      * - `tokenId` must exist.
821      *
822      * Emits a {Transfer} event.
823      */
824     function _burn(uint256 tokenId) internal virtual {
825         address owner = ERC721.ownerOf(tokenId);
826 
827         _beforeTokenTransfer(owner, address(0), tokenId);
828 
829         // Clear approvals
830         _approve(address(0), tokenId);
831 
832         _balances[owner] -= 1;
833         delete _owners[tokenId];
834 
835         emit Transfer(owner, address(0), tokenId);
836     }
837 
838     /**
839      * @dev Transfers `tokenId` from `from` to `to`.
840      *  As opposed to {transferFrom}, this imposes no restrictions on msg.sender.
841      *
842      * Requirements:
843      *
844      * - `to` cannot be the zero address.
845      * - `tokenId` token must be owned by `from`.
846      *
847      * Emits a {Transfer} event.
848      */
849     function _transfer(
850         address from,
851         address to,
852         uint256 tokenId
853     ) internal virtual {
854         require(ERC721.ownerOf(tokenId) == from, "ERC721: transfer of token that is not own");
855         require(to != address(0), "ERC721: transfer to the zero address");
856 
857         _beforeTokenTransfer(from, to, tokenId);
858 
859         // Clear approvals from the previous owner
860         _approve(address(0), tokenId);
861 
862         _balances[from] -= 1;
863         _balances[to] += 1;
864         _owners[tokenId] = to;
865 
866         emit Transfer(from, to, tokenId);
867     }
868 
869     /**
870      * @dev Approve `to` to operate on `tokenId`
871      *
872      * Emits a {Approval} event.
873      */
874     function _approve(address to, uint256 tokenId) internal virtual {
875         _tokenApprovals[tokenId] = to;
876         emit Approval(ERC721.ownerOf(tokenId), to, tokenId);
877     }
878 
879     /**
880      * @dev Internal function to invoke {IERC721Receiver-onERC721Received} on a target address.
881      * The call is not executed if the target address is not a contract.
882      *
883      * @param from address representing the previous owner of the given token ID
884      * @param to target address that will receive the tokens
885      * @param tokenId uint256 ID of the token to be transferred
886      * @param _data bytes optional data to send along with the call
887      * @return bool whether the call correctly returned the expected magic value
888      */
889     function _checkOnERC721Received(
890         address from,
891         address to,
892         uint256 tokenId,
893         bytes memory _data
894     ) private returns (bool) {
895         if (to.isContract()) {
896             try IERC721Receiver(to).onERC721Received(_msgSender(), from, tokenId, _data) returns (bytes4 retval) {
897                 return retval == IERC721Receiver.onERC721Received.selector;
898             } catch (bytes memory reason) {
899                 if (reason.length == 0) {
900                     revert("ERC721: transfer to non ERC721Receiver implementer");
901                 } else {
902                     assembly {
903                         revert(add(32, reason), mload(reason))
904                     }
905                 }
906             }
907         } else {
908             return true;
909         }
910     }
911 
912     /**
913      * @dev Hook that is called before any token transfer. This includes minting
914      * and burning.
915      *
916      * Calling conditions:
917      *
918      * - When `from` and `to` are both non-zero, ``from``'s `tokenId` will be
919      * transferred to `to`.
920      * - When `from` is zero, `tokenId` will be minted for `to`.
921      * - When `to` is zero, ``from``'s `tokenId` will be burned.
922      * - `from` and `to` are never both zero.
923      *
924      * To learn more about hooks, head to xref:ROOT:extending-contracts.adoc#using-hooks[Using Hooks].
925      */
926     function _beforeTokenTransfer(
927         address from,
928         address to,
929         uint256 tokenId
930     ) internal virtual {}
931 }
932 
933 
934 /**
935  * @dev Contract module which provides a basic access control mechanism, where
936  * there is an account (an owner) that can be granted exclusive access to
937  * specific functions.
938  *
939  * By default, the owner account will be the one that deploys the contract. This
940  * can later be changed with {transferOwnership}.
941  *
942  * This module is used through inheritance. It will make available the modifier
943  * `onlyOwner`, which can be applied to your functions to restrict their use to
944  * the owner.
945  */
946 abstract contract Ownable is Context {
947     address private _owner;
948 
949     event OwnershipTransferred(address indexed previousOwner, address indexed newOwner);
950 
951     /**
952      * @dev Initializes the contract setting the deployer as the initial owner.
953      */
954     constructor() {
955         _setOwner(_msgSender());
956     }
957 
958     /**
959      * @dev Returns the address of the current owner.
960      */
961     function owner() public view virtual returns (address) {
962         return _owner;
963     }
964 
965     /**
966      * @dev Throws if called by any account other than the owner.
967      */
968     modifier onlyOwner() {
969         require(owner() == _msgSender(), "Ownable: caller is not the owner");
970         _;
971     }
972 
973     /**
974      * @dev Leaves the contract without owner. It will not be possible to call
975      * `onlyOwner` functions anymore. Can only be called by the current owner.
976      *
977      * NOTE: Renouncing ownership will leave the contract without an owner,
978      * thereby removing any functionality that is only available to the owner.
979      */
980     function renounceOwnership() public virtual onlyOwner {
981         _setOwner(address(0));
982     }
983 
984     /**
985      * @dev Transfers ownership of the contract to a new account (`newOwner`).
986      * Can only be called by the current owner.
987      */
988     function transferOwnership(address newOwner) public virtual onlyOwner {
989         require(newOwner != address(0), "Ownable: new owner is the zero address");
990         _setOwner(newOwner);
991     }
992 
993     function _setOwner(address newOwner) private {
994         address oldOwner = _owner;
995         _owner = newOwner;
996         emit OwnershipTransferred(oldOwner, newOwner);
997     }
998 }
999 
1000 
1001 // CAUTION
1002 // This version of SafeMath should only be used with Solidity 0.8 or later,
1003 // because it relies on the compiler's built in overflow checks.
1004 /**
1005  * @dev Wrappers over Solidity's arithmetic operations.
1006  *
1007  * NOTE: `SafeMath` is no longer needed starting with Solidity 0.8. The compiler
1008  * now has built in overflow checking.
1009  */
1010 library SafeMath {
1011     /**
1012      * @dev Returns the addition of two unsigned integers, with an overflow flag.
1013      *
1014      * _Available since v3.4._
1015      */
1016     function tryAdd(uint256 a, uint256 b) internal pure returns (bool, uint256) {
1017         unchecked {
1018             uint256 c = a + b;
1019             if (c < a) return (false, 0);
1020             return (true, c);
1021         }
1022     }
1023 
1024     /**
1025      * @dev Returns the substraction of two unsigned integers, with an overflow flag.
1026      *
1027      * _Available since v3.4._
1028      */
1029     function trySub(uint256 a, uint256 b) internal pure returns (bool, uint256) {
1030         unchecked {
1031             if (b > a) return (false, 0);
1032             return (true, a - b);
1033         }
1034     }
1035 
1036     /**
1037      * @dev Returns the multiplication of two unsigned integers, with an overflow flag.
1038      *
1039      * _Available since v3.4._
1040      */
1041     function tryMul(uint256 a, uint256 b) internal pure returns (bool, uint256) {
1042         unchecked {
1043             // Gas optimization: this is cheaper than requiring 'a' not being zero, but the
1044             // benefit is lost if 'b' is also tested.
1045             // See: https://github.com/OpenZeppelin/openzeppelin-contracts/pull/522
1046             if (a == 0) return (true, 0);
1047             uint256 c = a * b;
1048             if (c / a != b) return (false, 0);
1049             return (true, c);
1050         }
1051     }
1052 
1053     /**
1054      * @dev Returns the division of two unsigned integers, with a division by zero flag.
1055      *
1056      * _Available since v3.4._
1057      */
1058     function tryDiv(uint256 a, uint256 b) internal pure returns (bool, uint256) {
1059         unchecked {
1060             if (b == 0) return (false, 0);
1061             return (true, a / b);
1062         }
1063     }
1064 
1065     /**
1066      * @dev Returns the remainder of dividing two unsigned integers, with a division by zero flag.
1067      *
1068      * _Available since v3.4._
1069      */
1070     function tryMod(uint256 a, uint256 b) internal pure returns (bool, uint256) {
1071         unchecked {
1072             if (b == 0) return (false, 0);
1073             return (true, a % b);
1074         }
1075     }
1076 
1077     /**
1078      * @dev Returns the addition of two unsigned integers, reverting on
1079      * overflow.
1080      *
1081      * Counterpart to Solidity's `+` operator.
1082      *
1083      * Requirements:
1084      *
1085      * - Addition cannot overflow.
1086      */
1087     function add(uint256 a, uint256 b) internal pure returns (uint256) {
1088         return a + b;
1089     }
1090 
1091     /**
1092      * @dev Returns the subtraction of two unsigned integers, reverting on
1093      * overflow (when the result is negative).
1094      *
1095      * Counterpart to Solidity's `-` operator.
1096      *
1097      * Requirements:
1098      *
1099      * - Subtraction cannot overflow.
1100      */
1101     function sub(uint256 a, uint256 b) internal pure returns (uint256) {
1102         return a - b;
1103     }
1104 
1105     /**
1106      * @dev Returns the multiplication of two unsigned integers, reverting on
1107      * overflow.
1108      *
1109      * Counterpart to Solidity's `*` operator.
1110      *
1111      * Requirements:
1112      *
1113      * - Multiplication cannot overflow.
1114      */
1115     function mul(uint256 a, uint256 b) internal pure returns (uint256) {
1116         return a * b;
1117     }
1118 
1119     /**
1120      * @dev Returns the integer division of two unsigned integers, reverting on
1121      * division by zero. The result is rounded towards zero.
1122      *
1123      * Counterpart to Solidity's `/` operator.
1124      *
1125      * Requirements:
1126      *
1127      * - The divisor cannot be zero.
1128      */
1129     function div(uint256 a, uint256 b) internal pure returns (uint256) {
1130         return a / b;
1131     }
1132 
1133     /**
1134      * @dev Returns the remainder of dividing two unsigned integers. (unsigned integer modulo),
1135      * reverting when dividing by zero.
1136      *
1137      * Counterpart to Solidity's `%` operator. This function uses a `revert`
1138      * opcode (which leaves remaining gas untouched) while Solidity uses an
1139      * invalid opcode to revert (consuming all remaining gas).
1140      *
1141      * Requirements:
1142      *
1143      * - The divisor cannot be zero.
1144      */
1145     function mod(uint256 a, uint256 b) internal pure returns (uint256) {
1146         return a % b;
1147     }
1148 
1149     /**
1150      * @dev Returns the subtraction of two unsigned integers, reverting with custom message on
1151      * overflow (when the result is negative).
1152      *
1153      * CAUTION: This function is deprecated because it requires allocating memory for the error
1154      * message unnecessarily. For custom revert reasons use {trySub}.
1155      *
1156      * Counterpart to Solidity's `-` operator.
1157      *
1158      * Requirements:
1159      *
1160      * - Subtraction cannot overflow.
1161      */
1162     function sub(
1163         uint256 a,
1164         uint256 b,
1165         string memory errorMessage
1166     ) internal pure returns (uint256) {
1167         unchecked {
1168             require(b <= a, errorMessage);
1169             return a - b;
1170         }
1171     }
1172 
1173     /**
1174      * @dev Returns the integer division of two unsigned integers, reverting with custom message on
1175      * division by zero. The result is rounded towards zero.
1176      *
1177      * Counterpart to Solidity's `/` operator. Note: this function uses a
1178      * `revert` opcode (which leaves remaining gas untouched) while Solidity
1179      * uses an invalid opcode to revert (consuming all remaining gas).
1180      *
1181      * Requirements:
1182      *
1183      * - The divisor cannot be zero.
1184      */
1185     function div(
1186         uint256 a,
1187         uint256 b,
1188         string memory errorMessage
1189     ) internal pure returns (uint256) {
1190         unchecked {
1191             require(b > 0, errorMessage);
1192             return a / b;
1193         }
1194     }
1195 
1196     /**
1197      * @dev Returns the remainder of dividing two unsigned integers. (unsigned integer modulo),
1198      * reverting with custom message when dividing by zero.
1199      *
1200      * CAUTION: This function is deprecated because it requires allocating memory for the error
1201      * message unnecessarily. For custom revert reasons use {tryMod}.
1202      *
1203      * Counterpart to Solidity's `%` operator. This function uses a `revert`
1204      * opcode (which leaves remaining gas untouched) while Solidity uses an
1205      * invalid opcode to revert (consuming all remaining gas).
1206      *
1207      * Requirements:
1208      *
1209      * - The divisor cannot be zero.
1210      */
1211     function mod(
1212         uint256 a,
1213         uint256 b,
1214         string memory errorMessage
1215     ) internal pure returns (uint256) {
1216         unchecked {
1217             require(b > 0, errorMessage);
1218             return a % b;
1219         }
1220     }
1221 }
1222 
1223 
1224 /**
1225  * @title Counters
1226  * @author Matt Condon (@shrugs)
1227  * @dev Provides counters that can only be incremented, decremented or reset. This can be used e.g. to track the number
1228  * of elements in a mapping, issuing ERC721 ids, or counting request ids.
1229  *
1230  * Include with `using Counters for Counters.Counter;`
1231  */
1232 library Counters {
1233     struct Counter {
1234         // This variable should never be directly accessed by users of the library: interactions must be restricted to
1235         // the library's function. As of Solidity v0.5.2, this cannot be enforced, though there is a proposal to add
1236         // this feature: see https://github.com/ethereum/solidity/issues/4637
1237         uint256 _value; // default: 0
1238     }
1239 
1240     function current(Counter storage counter) internal view returns (uint256) {
1241         return counter._value;
1242     }
1243 
1244     function increment(Counter storage counter) internal {
1245         unchecked {
1246             counter._value += 1;
1247         }
1248     }
1249 
1250     function decrement(Counter storage counter) internal {
1251         uint256 value = counter._value;
1252         require(value > 0, "Counter: decrement overflow");
1253         unchecked {
1254             counter._value = value - 1;
1255         }
1256     }
1257 
1258     function reset(Counter storage counter) internal {
1259         counter._value = 0;
1260     }
1261 }
1262 
1263 
1264 contract MirrorPass is ERC721, Ownable {
1265     using SafeMath for uint256;
1266     using Address for address;
1267     using Counters for Counters.Counter;
1268 
1269     Counters.Counter private Passes;
1270     string private baseURI;
1271 
1272     uint256 constant public maxPasses = 5555;
1273 
1274     uint256 public mintPrice = 0.035 ether;
1275     uint256 public maxPerTxn = 10;
1276     bool public saleLive = false;
1277 
1278     modifier activeSale() {
1279         require(saleLive, "Passes are not available to be minted yet");
1280         _;
1281     }
1282 
1283     modifier isNotContract() {
1284         require(tx.origin == msg.sender, "What are you doing? >:(");
1285         _;
1286     }
1287 
1288     constructor() ERC721("Mirror Passes", "Mirror") {}
1289 
1290     function mintPass(uint256 qty) public payable activeSale isNotContract {
1291         uint256 currentPasses = Passes.current();
1292 
1293         require(currentPasses <= maxPasses, "Total Supply has been reached");
1294         require(qty > 0 && qty <= maxPerTxn, "Not a valid quantity of passes");
1295         require(currentPasses.add(qty) <= maxPasses, "You would exceed Total Supply");
1296         require(mintPrice * qty == msg.value, "You didn't send enough eth");
1297 
1298         for (uint256 i;i < qty;i++) {
1299             _safeMint(msg.sender, currentPasses + i);
1300             Passes.increment();
1301         }
1302     }
1303 
1304     function getPassesFromAddress(address wallet) public view returns(uint256[] memory) {
1305         uint256 passesHeld = balanceOf(wallet);
1306         uint256 currentPasses = Passes.current();
1307         uint256 x = 0;
1308 
1309         uint256[] memory passes = new uint256[](passesHeld);
1310         
1311         for (uint256 i;i < currentPasses;i++) {
1312             if (ownerOf(i) == wallet) {
1313                 passes[x] = i;
1314                 x++;
1315             }
1316         }
1317 
1318         return passes;
1319     }
1320 
1321     function withdraw() public onlyOwner {
1322         uint256 balance = address(this).balance;
1323         payable(msg.sender).transfer(balance);
1324     }
1325 
1326     function totalSupply() external view returns(uint256) {
1327         return Passes.current();
1328     }
1329 
1330     function setMintSettings(bool isSaleLive, uint256 howManyPerTxn) public payable onlyOwner {
1331         saleLive = isSaleLive;
1332         maxPerTxn = howManyPerTxn;
1333     }
1334 
1335     function setMintPrice(uint256 howMuch) public payable onlyOwner {
1336         mintPrice = howMuch;
1337     }
1338 
1339     function _baseURI() internal view override returns (string memory) {
1340         return baseURI;
1341     }
1342 
1343     function setMetadata(string memory metadata) public payable onlyOwner {
1344         baseURI = metadata;
1345     }
1346 
1347     function transferFrom(address from, address to, uint256 tokenId) public override {
1348         ERC721.transferFrom(from, to, tokenId);
1349     }
1350 
1351     function safeTransferFrom(address from, address to, uint256 tokenId) public override {
1352         safeTransferFrom(from, to, tokenId, "");
1353     }
1354 
1355     function safeTransferFrom(address from, address to, uint256 tokenId, bytes memory data) public override {
1356         ERC721.safeTransferFrom(from, to, tokenId, data);
1357     }
1358 }