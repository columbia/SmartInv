1 // SPDX-License-Identifier: MIT
2 pragma solidity ^0.8.2;
3 
4 
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
27 
28 /**
29  * @dev Required interface of an ERC721 compliant contract.
30  */
31 interface IERC721 is IERC165 {
32     /**
33      * @dev Emitted when `tokenId` token is transferred from `from` to `to`.
34      */
35     event Transfer(address indexed from, address indexed to, uint256 indexed tokenId);
36 
37     /**
38      * @dev Emitted when `owner` enables `approved` to manage the `tokenId` token.
39      */
40     event Approval(address indexed owner, address indexed approved, uint256 indexed tokenId);
41 
42     /**
43      * @dev Emitted when `owner` enables or disables (`approved`) `operator` to manage all of its assets.
44      */
45     event ApprovalForAll(address indexed owner, address indexed operator, bool approved);
46 
47     /**
48      * @dev Returns the number of tokens in ``owner``'s account.
49      */
50     function balanceOf(address owner) external view returns (uint256 balance);
51 
52     /**
53      * @dev Returns the owner of the `tokenId` token.
54      *
55      * Requirements:
56      *
57      * - `tokenId` must exist.
58      */
59     function ownerOf(uint256 tokenId) external view returns (address owner);
60 
61     /**
62      * @dev Safely transfers `tokenId` token from `from` to `to`, checking first that contract recipients
63      * are aware of the ERC721 protocol to prevent tokens from being forever locked.
64      *
65      * Requirements:
66      *
67      * - `from` cannot be the zero address.
68      * - `to` cannot be the zero address.
69      * - `tokenId` token must exist and be owned by `from`.
70      * - If the caller is not `from`, it must be have been allowed to move this token by either {approve} or {setApprovalForAll}.
71      * - If `to` refers to a smart contract, it must implement {IERC721Receiver-onERC721Received}, which is called upon a safe transfer.
72      *
73      * Emits a {Transfer} event.
74      */
75     function safeTransferFrom(
76         address from,
77         address to,
78         uint256 tokenId
79     ) external;
80 
81     /**
82      * @dev Transfers `tokenId` token from `from` to `to`.
83      *
84      * WARNING: Usage of this method is discouraged, use {safeTransferFrom} whenever possible.
85      *
86      * Requirements:
87      *
88      * - `from` cannot be the zero address.
89      * - `to` cannot be the zero address.
90      * - `tokenId` token must be owned by `from`.
91      * - If the caller is not `from`, it must be approved to move this token by either {approve} or {setApprovalForAll}.
92      *
93      * Emits a {Transfer} event.
94      */
95     function transferFrom(
96         address from,
97         address to,
98         uint256 tokenId
99     ) external;
100 
101     /**
102      * @dev Gives permission to `to` to transfer `tokenId` token to another account.
103      * The approval is cleared when the token is transferred.
104      *
105      * Only a single account can be approved at a time, so approving the zero address clears previous approvals.
106      *
107      * Requirements:
108      *
109      * - The caller must own the token or be an approved operator.
110      * - `tokenId` must exist.
111      *
112      * Emits an {Approval} event.
113      */
114     function approve(address to, uint256 tokenId) external;
115 
116     /**
117      * @dev Returns the account approved for `tokenId` token.
118      *
119      * Requirements:
120      *
121      * - `tokenId` must exist.
122      */
123     function getApproved(uint256 tokenId) external view returns (address operator);
124 
125     /**
126      * @dev Approve or remove `operator` as an operator for the caller.
127      * Operators can call {transferFrom} or {safeTransferFrom} for any token owned by the caller.
128      *
129      * Requirements:
130      *
131      * - The `operator` cannot be the caller.
132      *
133      * Emits an {ApprovalForAll} event.
134      */
135     function setApprovalForAll(address operator, bool _approved) external;
136 
137     /**
138      * @dev Returns if the `operator` is allowed to manage all of the assets of `owner`.
139      *
140      * See {setApprovalForAll}
141      */
142     function isApprovedForAll(address owner, address operator) external view returns (bool);
143 
144     /**
145      * @dev Safely transfers `tokenId` token from `from` to `to`.
146      *
147      * Requirements:
148      *
149      * - `from` cannot be the zero address.
150      * - `to` cannot be the zero address.
151      * - `tokenId` token must exist and be owned by `from`.
152      * - If the caller is not `from`, it must be approved to move this token by either {approve} or {setApprovalForAll}.
153      * - If `to` refers to a smart contract, it must implement {IERC721Receiver-onERC721Received}, which is called upon a safe transfer.
154      *
155      * Emits a {Transfer} event.
156      */
157     function safeTransferFrom(
158         address from,
159         address to,
160         uint256 tokenId,
161         bytes calldata data
162     ) external;
163 }
164 
165 
166 /**
167  * @title ERC721 token receiver interface
168  * @dev Interface for any contract that wants to support safeTransfers
169  * from ERC721 asset contracts.
170  */
171 interface IERC721Receiver {
172     /**
173      * @dev Whenever an {IERC721} `tokenId` token is transferred to this contract via {IERC721-safeTransferFrom}
174      * by `operator` from `from`, this function is called.
175      *
176      * It must return its Solidity selector to confirm the token transfer.
177      * If any other value is returned or the interface is not implemented by the recipient, the transfer will be reverted.
178      *
179      * The selector can be obtained in Solidity with `IERC721.onERC721Received.selector`.
180      */
181     function onERC721Received(
182         address operator,
183         address from,
184         uint256 tokenId,
185         bytes calldata data
186     ) external returns (bytes4);
187 }
188 
189 
190 /**
191  * @title ERC-721 Non-Fungible Token Standard, optional metadata extension
192  * @dev See https://eips.ethereum.org/EIPS/eip-721
193  */
194 interface IERC721Metadata is IERC721 {
195     /**
196      * @dev Returns the token collection name.
197      */
198     function name() external view returns (string memory);
199 
200     /**
201      * @dev Returns the token collection symbol.
202      */
203     function symbol() external view returns (string memory);
204 
205     /**
206      * @dev Returns the Uniform Resource Identifier (URI) for `tokenId` token.
207      */
208     function tokenURI(uint256 tokenId) external view returns (string memory);
209 }
210 
211 
212 /**
213  * @dev Collection of functions related to the address type
214  */
215 library Address {
216     /**
217      * @dev Returns true if `account` is a contract.
218      *
219      * [IMPORTANT]
220      * ====
221      * It is unsafe to assume that an address for which this function returns
222      * false is an externally-owned account (EOA) and not a contract.
223      *
224      * Among others, `isContract` will return false for the following
225      * types of addresses:
226      *
227      *  - an externally-owned account
228      *  - a contract in construction
229      *  - an address where a contract will be created
230      *  - an address where a contract lived, but was destroyed
231      * ====
232      */
233     function isContract(address account) internal view returns (bool) {
234         // This method relies on extcodesize, which returns 0 for contracts in
235         // construction, since the code is only stored at the end of the
236         // constructor execution.
237 
238         uint256 size;
239         assembly {
240             size := extcodesize(account)
241         }
242         return size > 0;
243     }
244 
245     /**
246      * @dev Replacement for Solidity's `transfer`: sends `amount` wei to
247      * `recipient`, forwarding all available gas and reverting on errors.
248      *
249      * https://eips.ethereum.org/EIPS/eip-1884[EIP1884] increases the gas cost
250      * of certain opcodes, possibly making contracts go over the 2300 gas limit
251      * imposed by `transfer`, making them unable to receive funds via
252      * `transfer`. {sendValue} removes this limitation.
253      *
254      * https://diligence.consensys.net/posts/2019/09/stop-using-soliditys-transfer-now/[Learn more].
255      *
256      * IMPORTANT: because control is transferred to `recipient`, care must be
257      * taken to not create reentrancy vulnerabilities. Consider using
258      * {ReentrancyGuard} or the
259      * https://solidity.readthedocs.io/en/v0.5.11/security-considerations.html#use-the-checks-effects-interactions-pattern[checks-effects-interactions pattern].
260      */
261     function sendValue(address payable recipient, uint256 amount) internal {
262         require(address(this).balance >= amount, "Address: insufficient balance");
263 
264         (bool success, ) = recipient.call{value: amount}("");
265         require(success, "Address: unable to send value, recipient may have reverted");
266     }
267 
268     /**
269      * @dev Performs a Solidity function call using a low level `call`. A
270      * plain `call` is an unsafe replacement for a function call: use this
271      * function instead.
272      *
273      * If `target` reverts with a revert reason, it is bubbled up by this
274      * function (like regular Solidity function calls).
275      *
276      * Returns the raw returned data. To convert to the expected return value,
277      * use https://solidity.readthedocs.io/en/latest/units-and-global-variables.html?highlight=abi.decode#abi-encoding-and-decoding-functions[`abi.decode`].
278      *
279      * Requirements:
280      *
281      * - `target` must be a contract.
282      * - calling `target` with `data` must not revert.
283      *
284      * _Available since v3.1._
285      */
286     function functionCall(address target, bytes memory data) internal returns (bytes memory) {
287         return functionCall(target, data, "Address: low-level call failed");
288     }
289 
290     /**
291      * @dev Same as {xref-Address-functionCall-address-bytes-}[`functionCall`], but with
292      * `errorMessage` as a fallback revert reason when `target` reverts.
293      *
294      * _Available since v3.1._
295      */
296     function functionCall(
297         address target,
298         bytes memory data,
299         string memory errorMessage
300     ) internal returns (bytes memory) {
301         return functionCallWithValue(target, data, 0, errorMessage);
302     }
303 
304     /**
305      * @dev Same as {xref-Address-functionCall-address-bytes-}[`functionCall`],
306      * but also transferring `value` wei to `target`.
307      *
308      * Requirements:
309      *
310      * - the calling contract must have an ETH balance of at least `value`.
311      * - the called Solidity function must be `payable`.
312      *
313      * _Available since v3.1._
314      */
315     function functionCallWithValue(
316         address target,
317         bytes memory data,
318         uint256 value
319     ) internal returns (bytes memory) {
320         return functionCallWithValue(target, data, value, "Address: low-level call with value failed");
321     }
322 
323     /**
324      * @dev Same as {xref-Address-functionCallWithValue-address-bytes-uint256-}[`functionCallWithValue`], but
325      * with `errorMessage` as a fallback revert reason when `target` reverts.
326      *
327      * _Available since v3.1._
328      */
329     function functionCallWithValue(
330         address target,
331         bytes memory data,
332         uint256 value,
333         string memory errorMessage
334     ) internal returns (bytes memory) {
335         require(address(this).balance >= value, "Address: insufficient balance for call");
336         require(isContract(target), "Address: call to non-contract");
337 
338         (bool success, bytes memory returndata) = target.call{value: value}(data);
339         return verifyCallResult(success, returndata, errorMessage);
340     }
341 
342     /**
343      * @dev Same as {xref-Address-functionCall-address-bytes-}[`functionCall`],
344      * but performing a static call.
345      *
346      * _Available since v3.3._
347      */
348     function functionStaticCall(address target, bytes memory data) internal view returns (bytes memory) {
349         return functionStaticCall(target, data, "Address: low-level static call failed");
350     }
351 
352     /**
353      * @dev Same as {xref-Address-functionCall-address-bytes-string-}[`functionCall`],
354      * but performing a static call.
355      *
356      * _Available since v3.3._
357      */
358     function functionStaticCall(
359         address target,
360         bytes memory data,
361         string memory errorMessage
362     ) internal view returns (bytes memory) {
363         require(isContract(target), "Address: static call to non-contract");
364 
365         (bool success, bytes memory returndata) = target.staticcall(data);
366         return verifyCallResult(success, returndata, errorMessage);
367     }
368 
369     /**
370      * @dev Same as {xref-Address-functionCall-address-bytes-}[`functionCall`],
371      * but performing a delegate call.
372      *
373      * _Available since v3.4._
374      */
375     function functionDelegateCall(address target, bytes memory data) internal returns (bytes memory) {
376         return functionDelegateCall(target, data, "Address: low-level delegate call failed");
377     }
378 
379     /**
380      * @dev Same as {xref-Address-functionCall-address-bytes-string-}[`functionCall`],
381      * but performing a delegate call.
382      *
383      * _Available since v3.4._
384      */
385     function functionDelegateCall(
386         address target,
387         bytes memory data,
388         string memory errorMessage
389     ) internal returns (bytes memory) {
390         require(isContract(target), "Address: delegate call to non-contract");
391 
392         (bool success, bytes memory returndata) = target.delegatecall(data);
393         return verifyCallResult(success, returndata, errorMessage);
394     }
395 
396     /**
397      * @dev Tool to verifies that a low level call was successful, and revert if it wasn't, either by bubbling the
398      * revert reason using the provided one.
399      *
400      * _Available since v4.3._
401      */
402     function verifyCallResult(
403         bool success,
404         bytes memory returndata,
405         string memory errorMessage
406     ) internal pure returns (bytes memory) {
407         if (success) {
408             return returndata;
409         } else {
410             // Look for revert reason and bubble it up if present
411             if (returndata.length > 0) {
412                 // The easiest way to bubble the revert reason is using memory via assembly
413 
414                 assembly {
415                     let returndata_size := mload(returndata)
416                     revert(add(32, returndata), returndata_size)
417                 }
418             } else {
419                 revert(errorMessage);
420             }
421         }
422     }
423 }
424 
425 
426 /**
427  * @dev Provides information about the current execution context, including the
428  * sender of the transaction and its data. While these are generally available
429  * via msg.sender and msg.data, they should not be accessed in such a direct
430  * manner, since when dealing with meta-transactions the account sending and
431  * paying for execution may not be the actual sender (as far as an application
432  * is concerned).
433  *
434  * This contract is only required for intermediate, library-like contracts.
435  */
436 abstract contract Context {
437     function _msgSender() internal view virtual returns (address) {
438         return msg.sender;
439     }
440 
441     function _msgData() internal view virtual returns (bytes calldata) {
442         return msg.data;
443     }
444 }
445 
446 
447 /**
448  * @dev String operations.
449  */
450 library Strings {
451     bytes16 private constant _HEX_SYMBOLS = "0123456789abcdef";
452 
453     /**
454      * @dev Converts a `uint256` to its ASCII `string` decimal representation.
455      */
456     function toString(uint256 value) internal pure returns (string memory) {
457         // Inspired by OraclizeAPI's implementation - MIT licence
458         // https://github.com/oraclize/ethereum-api/blob/b42146b063c7d6ee1358846c198246239e9360e8/oraclizeAPI_0.4.25.sol
459 
460         if (value == 0) {
461             return "0";
462         }
463         uint256 temp = value;
464         uint256 digits;
465         while (temp != 0) {
466             digits++;
467             temp /= 10;
468         }
469         bytes memory buffer = new bytes(digits);
470         while (value != 0) {
471             digits -= 1;
472             buffer[digits] = bytes1(uint8(48 + uint256(value % 10)));
473             value /= 10;
474         }
475         return string(buffer);
476     }
477 
478     /**
479      * @dev Converts a `uint256` to its ASCII `string` hexadecimal representation.
480      */
481     function toHexString(uint256 value) internal pure returns (string memory) {
482         if (value == 0) {
483             return "0x00";
484         }
485         uint256 temp = value;
486         uint256 length = 0;
487         while (temp != 0) {
488             length++;
489             temp >>= 8;
490         }
491         return toHexString(value, length);
492     }
493 
494     /**
495      * @dev Converts a `uint256` to its ASCII `string` hexadecimal representation with fixed length.
496      */
497     function toHexString(uint256 value, uint256 length) internal pure returns (string memory) {
498         bytes memory buffer = new bytes(2 * length + 2);
499         buffer[0] = "0";
500         buffer[1] = "x";
501         for (uint256 i = 2 * length + 1; i > 1; --i) {
502             buffer[i] = _HEX_SYMBOLS[value & 0xf];
503             value >>= 4;
504         }
505         require(value == 0, "Strings: hex length insufficient");
506         return string(buffer);
507     }
508 }
509 
510 
511 /**
512  * @dev Implementation of the {IERC165} interface.
513  *
514  * Contracts that want to implement ERC165 should inherit from this contract and override {supportsInterface} to check
515  * for the additional interface id that will be supported. For example:
516  *
517  * ```solidity
518  * function supportsInterface(bytes4 interfaceId) public view virtual override returns (bool) {
519  *     return interfaceId == type(MyInterface).interfaceId || super.supportsInterface(interfaceId);
520  * }
521  * ```
522  *
523  * Alternatively, {ERC165Storage} provides an easier to use but more expensive implementation.
524  */
525 abstract contract ERC165 is IERC165 {
526     /**
527      * @dev See {IERC165-supportsInterface}.
528      */
529     function supportsInterface(bytes4 interfaceId) public view virtual override returns (bool) {
530         return interfaceId == type(IERC165).interfaceId;
531     }
532 }
533 
534 
535 /**
536  * @dev Implementation of https://eips.ethereum.org/EIPS/eip-721[ERC721] Non-Fungible Token Standard, including
537  * the Metadata extension, but not including the Enumerable extension, which is available separately as
538  * {ERC721Enumerable}.
539  */
540 contract ERC721 is Context, ERC165, IERC721, IERC721Metadata {
541     using Address for address;
542     using Strings for uint256;
543 
544     // Token name
545     string private _name;
546 
547     // Token symbol
548     string private _symbol;
549 
550     // Mapping from token ID to owner address
551     mapping(uint256 => address) private _owners;
552 
553     // Mapping owner address to token count
554     mapping(address => uint256) private _balances;
555 
556     // Mapping from token ID to approved address
557     mapping(uint256 => address) private _tokenApprovals;
558 
559     // Mapping from owner to operator approvals
560     mapping(address => mapping(address => bool)) private _operatorApprovals;
561 
562     /**
563      * @dev Initializes the contract by setting a `name` and a `symbol` to the token collection.
564      */
565     constructor(string memory name_, string memory symbol_) {
566         _name = name_;
567         _symbol = symbol_;
568     }
569 
570     /**
571      * @dev See {IERC165-supportsInterface}.
572      */
573     function supportsInterface(bytes4 interfaceId) public view virtual override(ERC165, IERC165) returns (bool) {
574         return
575             interfaceId == type(IERC721).interfaceId ||
576             interfaceId == type(IERC721Metadata).interfaceId ||
577             super.supportsInterface(interfaceId);
578     }
579 
580     /**
581      * @dev See {IERC721-balanceOf}.
582      */
583     function balanceOf(address owner) public view virtual override returns (uint256) {
584         require(owner != address(0), "ERC721: balance query for the zero address");
585         return _balances[owner];
586     }
587 
588     /**
589      * @dev See {IERC721-ownerOf}.
590      */
591     function ownerOf(uint256 tokenId) public view virtual override returns (address) {
592         address owner = _owners[tokenId];
593         require(owner != address(0), "ERC721: owner query for nonexistent token");
594         return owner;
595     }
596 
597     /**
598      * @dev See {IERC721Metadata-name}.
599      */
600     function name() public view virtual override returns (string memory) {
601         return _name;
602     }
603 
604     /**
605      * @dev See {IERC721Metadata-symbol}.
606      */
607     function symbol() public view virtual override returns (string memory) {
608         return _symbol;
609     }
610 
611     /**
612      * @dev See {IERC721Metadata-tokenURI}.
613      */
614     function tokenURI(uint256 tokenId) public view virtual override returns (string memory) {
615         require(_exists(tokenId), "ERC721Metadata: URI query for nonexistent token");
616 
617         string memory baseURI = _baseURI();
618         return bytes(baseURI).length > 0 ? string(abi.encodePacked(baseURI, tokenId.toString())) : "";
619     }
620 
621     /**
622      * @dev Base URI for computing {tokenURI}. If set, the resulting URI for each
623      * token will be the concatenation of the `baseURI` and the `tokenId`. Empty
624      * by default, can be overriden in child contracts.
625      */
626     function _baseURI() internal view virtual returns (string memory) {
627         return "";
628     }
629 
630     /**
631      * @dev See {IERC721-approve}.
632      */
633     function approve(address to, uint256 tokenId) public virtual override {
634         address owner = ERC721.ownerOf(tokenId);
635         require(to != owner, "ERC721: approval to current owner");
636 
637         require(
638             _msgSender() == owner || isApprovedForAll(owner, _msgSender()),
639             "ERC721: approve caller is not owner nor approved for all"
640         );
641 
642         _approve(to, tokenId);
643     }
644 
645     /**
646      * @dev See {IERC721-getApproved}.
647      */
648     function getApproved(uint256 tokenId) public view virtual override returns (address) {
649         require(_exists(tokenId), "ERC721: approved query for nonexistent token");
650 
651         return _tokenApprovals[tokenId];
652     }
653 
654     /**
655      * @dev See {IERC721-setApprovalForAll}.
656      */
657     function setApprovalForAll(address operator, bool approved) public virtual override {
658         require(operator != _msgSender(), "ERC721: approve to caller");
659 
660         _operatorApprovals[_msgSender()][operator] = approved;
661         emit ApprovalForAll(_msgSender(), operator, approved);
662     }
663 
664     /**
665      * @dev See {IERC721-isApprovedForAll}.
666      */
667     function isApprovedForAll(address owner, address operator) public view virtual override returns (bool) {
668         return _operatorApprovals[owner][operator];
669     }
670 
671     /**
672      * @dev See {IERC721-transferFrom}.
673      */
674     function transferFrom(
675         address from,
676         address to,
677         uint256 tokenId
678     ) public virtual override {
679         //solhint-disable-next-line max-line-length
680         require(_isApprovedOrOwner(_msgSender(), tokenId), "ERC721: transfer caller is not owner nor approved");
681 
682         _transfer(from, to, tokenId);
683     }
684 
685     /**
686      * @dev See {IERC721-safeTransferFrom}.
687      */
688     function safeTransferFrom(
689         address from,
690         address to,
691         uint256 tokenId
692     ) public virtual override {
693         safeTransferFrom(from, to, tokenId, "");
694     }
695 
696     /**
697      * @dev See {IERC721-safeTransferFrom}.
698      */
699     function safeTransferFrom(
700         address from,
701         address to,
702         uint256 tokenId,
703         bytes memory _data
704     ) public virtual override {
705         require(_isApprovedOrOwner(_msgSender(), tokenId), "ERC721: transfer caller is not owner nor approved");
706         _safeTransfer(from, to, tokenId, _data);
707     }
708 
709     /**
710      * @dev Safely transfers `tokenId` token from `from` to `to`, checking first that contract recipients
711      * are aware of the ERC721 protocol to prevent tokens from being forever locked.
712      *
713      * `_data` is additional data, it has no specified format and it is sent in call to `to`.
714      *
715      * This internal function is equivalent to {safeTransferFrom}, and can be used to e.g.
716      * implement alternative mechanisms to perform token transfer, such as signature-based.
717      *
718      * Requirements:
719      *
720      * - `from` cannot be the zero address.
721      * - `to` cannot be the zero address.
722      * - `tokenId` token must exist and be owned by `from`.
723      * - If `to` refers to a smart contract, it must implement {IERC721Receiver-onERC721Received}, which is called upon a safe transfer.
724      *
725      * Emits a {Transfer} event.
726      */
727     function _safeTransfer(
728         address from,
729         address to,
730         uint256 tokenId,
731         bytes memory _data
732     ) internal virtual {
733         _transfer(from, to, tokenId);
734         require(_checkOnERC721Received(from, to, tokenId, _data), "ERC721: transfer to non ERC721Receiver implementer");
735     }
736 
737     /**
738      * @dev Returns whether `tokenId` exists.
739      *
740      * Tokens can be managed by their owner or approved accounts via {approve} or {setApprovalForAll}.
741      *
742      * Tokens start existing when they are minted (`_mint`),
743      * and stop existing when they are burned (`_burn`).
744      */
745     function _exists(uint256 tokenId) internal view virtual returns (bool) {
746         return _owners[tokenId] != address(0);
747     }
748 
749     /**
750      * @dev Returns whether `spender` is allowed to manage `tokenId`.
751      *
752      * Requirements:
753      *
754      * - `tokenId` must exist.
755      */
756     function _isApprovedOrOwner(address spender, uint256 tokenId) internal view virtual returns (bool) {
757         require(_exists(tokenId), "ERC721: operator query for nonexistent token");
758         address owner = ERC721.ownerOf(tokenId);
759         return (spender == owner || getApproved(tokenId) == spender || isApprovedForAll(owner, spender));
760     }
761 
762     /**
763      * @dev Safely mints `tokenId` and transfers it to `to`.
764      *
765      * Requirements:
766      *
767      * - `tokenId` must not exist.
768      * - If `to` refers to a smart contract, it must implement {IERC721Receiver-onERC721Received}, which is called upon a safe transfer.
769      *
770      * Emits a {Transfer} event.
771      */
772     function _safeMint(address to, uint256 tokenId) internal virtual {
773         _safeMint(to, tokenId, "");
774     }
775 
776     /**
777      * @dev Same as {xref-ERC721-_safeMint-address-uint256-}[`_safeMint`], with an additional `data` parameter which is
778      * forwarded in {IERC721Receiver-onERC721Received} to contract recipients.
779      */
780     function _safeMint(
781         address to,
782         uint256 tokenId,
783         bytes memory _data
784     ) internal virtual {
785         _mint(to, tokenId);
786         require(
787             _checkOnERC721Received(address(0), to, tokenId, _data),
788             "ERC721: transfer to non ERC721Receiver implementer"
789         );
790     }
791 
792     /**
793      * @dev Mints `tokenId` and transfers it to `to`.
794      *
795      * WARNING: Usage of this method is discouraged, use {_safeMint} whenever possible
796      *
797      * Requirements:
798      *
799      * - `tokenId` must not exist.
800      * - `to` cannot be the zero address.
801      *
802      * Emits a {Transfer} event.
803      */
804     function _mint(address to, uint256 tokenId) internal virtual {
805         require(to != address(0), "ERC721: mint to the zero address");
806         require(!_exists(tokenId), "ERC721: token already minted");
807 
808         _beforeTokenTransfer(address(0), to, tokenId);
809 
810         _balances[to] += 1;
811         _owners[tokenId] = to;
812 
813         emit Transfer(address(0), to, tokenId);
814     }
815 
816     /**
817      * @dev Destroys `tokenId`.
818      * The approval is cleared when the token is burned.
819      *
820      * Requirements:
821      *
822      * - `tokenId` must exist.
823      *
824      * Emits a {Transfer} event.
825      */
826     function _burn(uint256 tokenId) internal virtual {
827         address owner = ERC721.ownerOf(tokenId);
828 
829         _beforeTokenTransfer(owner, address(0), tokenId);
830 
831         // Clear approvals
832         _approve(address(0), tokenId);
833 
834         _balances[owner] -= 1;
835         delete _owners[tokenId];
836 
837         emit Transfer(owner, address(0), tokenId);
838     }
839 
840     /**
841      * @dev Transfers `tokenId` from `from` to `to`.
842      *  As opposed to {transferFrom}, this imposes no restrictions on msg.sender.
843      *
844      * Requirements:
845      *
846      * - `to` cannot be the zero address.
847      * - `tokenId` token must be owned by `from`.
848      *
849      * Emits a {Transfer} event.
850      */
851     function _transfer(
852         address from,
853         address to,
854         uint256 tokenId
855     ) internal virtual {
856         require(ERC721.ownerOf(tokenId) == from, "ERC721: transfer of token that is not own");
857         require(to != address(0), "ERC721: transfer to the zero address");
858 
859         _beforeTokenTransfer(from, to, tokenId);
860 
861         // Clear approvals from the previous owner
862         _approve(address(0), tokenId);
863 
864         _balances[from] -= 1;
865         _balances[to] += 1;
866         _owners[tokenId] = to;
867 
868         emit Transfer(from, to, tokenId);
869     }
870 
871     /**
872      * @dev Approve `to` to operate on `tokenId`
873      *
874      * Emits a {Approval} event.
875      */
876     function _approve(address to, uint256 tokenId) internal virtual {
877         _tokenApprovals[tokenId] = to;
878         emit Approval(ERC721.ownerOf(tokenId), to, tokenId);
879     }
880 
881     /**
882      * @dev Internal function to invoke {IERC721Receiver-onERC721Received} on a target address.
883      * The call is not executed if the target address is not a contract.
884      *
885      * @param from address representing the previous owner of the given token ID
886      * @param to target address that will receive the tokens
887      * @param tokenId uint256 ID of the token to be transferred
888      * @param _data bytes optional data to send along with the call
889      * @return bool whether the call correctly returned the expected magic value
890      */
891     function _checkOnERC721Received(
892         address from,
893         address to,
894         uint256 tokenId,
895         bytes memory _data
896     ) private returns (bool) {
897         if (to.isContract()) {
898             try IERC721Receiver(to).onERC721Received(_msgSender(), from, tokenId, _data) returns (bytes4 retval) {
899                 return retval == IERC721Receiver.onERC721Received.selector;
900             } catch (bytes memory reason) {
901                 if (reason.length == 0) {
902                     revert("ERC721: transfer to non ERC721Receiver implementer");
903                 } else {
904                     assembly {
905                         revert(add(32, reason), mload(reason))
906                     }
907                 }
908             }
909         } else {
910             return true;
911         }
912     }
913 
914     /**
915      * @dev Hook that is called before any token transfer. This includes minting
916      * and burning.
917      *
918      * Calling conditions:
919      *
920      * - When `from` and `to` are both non-zero, ``from``'s `tokenId` will be
921      * transferred to `to`.
922      * - When `from` is zero, `tokenId` will be minted for `to`.
923      * - When `to` is zero, ``from``'s `tokenId` will be burned.
924      * - `from` and `to` are never both zero.
925      *
926      * To learn more about hooks, head to xref:ROOT:extending-contracts.adoc#using-hooks[Using Hooks].
927      */
928     function _beforeTokenTransfer(
929         address from,
930         address to,
931         uint256 tokenId
932     ) internal virtual {}
933 }
934 
935 
936 /**
937  * @title ERC-721 Non-Fungible Token Standard, optional enumeration extension
938  * @dev See https://eips.ethereum.org/EIPS/eip-721
939  */
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
959 
960 /**
961  * @dev This implements an optional extension of {ERC721} defined in the EIP that adds
962  * enumerability of all the token ids in the contract as well as all token ids owned by each
963  * account.
964  */
965 abstract contract ERC721Enumerable is ERC721, IERC721Enumerable {
966     // Mapping from owner to list of owned token IDs
967     mapping(address => mapping(uint256 => uint256)) private _ownedTokens;
968 
969     // Mapping from token ID to index of the owner tokens list
970     mapping(uint256 => uint256) private _ownedTokensIndex;
971 
972     // Array with all token ids, used for enumeration
973     uint256[] private _allTokens;
974 
975     // Mapping from token id to position in the allTokens array
976     mapping(uint256 => uint256) private _allTokensIndex;
977 
978     /**
979      * @dev See {IERC165-supportsInterface}.
980      */
981     function supportsInterface(bytes4 interfaceId) public view virtual override(IERC165, ERC721) returns (bool) {
982         return interfaceId == type(IERC721Enumerable).interfaceId || super.supportsInterface(interfaceId);
983     }
984 
985     /**
986      * @dev See {IERC721Enumerable-tokenOfOwnerByIndex}.
987      */
988     function tokenOfOwnerByIndex(address owner, uint256 index) public view virtual override returns (uint256) {
989         require(index < ERC721.balanceOf(owner), "ERC721Enumerable: owner index out of bounds");
990         return _ownedTokens[owner][index];
991     }
992 
993     /**
994      * @dev See {IERC721Enumerable-totalSupply}.
995      */
996     function totalSupply() public view virtual override returns (uint256) {
997         return _allTokens.length;
998     }
999 
1000     /**
1001      * @dev See {IERC721Enumerable-tokenByIndex}.
1002      */
1003     function tokenByIndex(uint256 index) public view virtual override returns (uint256) {
1004         require(index < ERC721Enumerable.totalSupply(), "ERC721Enumerable: global index out of bounds");
1005         return _allTokens[index];
1006     }
1007 
1008     /**
1009      * @dev Hook that is called before any token transfer. This includes minting
1010      * and burning.
1011      *
1012      * Calling conditions:
1013      *
1014      * - When `from` and `to` are both non-zero, ``from``'s `tokenId` will be
1015      * transferred to `to`.
1016      * - When `from` is zero, `tokenId` will be minted for `to`.
1017      * - When `to` is zero, ``from``'s `tokenId` will be burned.
1018      * - `from` cannot be the zero address.
1019      * - `to` cannot be the zero address.
1020      *
1021      * To learn more about hooks, head to xref:ROOT:extending-contracts.adoc#using-hooks[Using Hooks].
1022      */
1023     function _beforeTokenTransfer(
1024         address from,
1025         address to,
1026         uint256 tokenId
1027     ) internal virtual override {
1028         super._beforeTokenTransfer(from, to, tokenId);
1029 
1030         if (from == address(0)) {
1031             _addTokenToAllTokensEnumeration(tokenId);
1032         } else if (from != to) {
1033             _removeTokenFromOwnerEnumeration(from, tokenId);
1034         }
1035         if (to == address(0)) {
1036             _removeTokenFromAllTokensEnumeration(tokenId);
1037         } else if (to != from) {
1038             _addTokenToOwnerEnumeration(to, tokenId);
1039         }
1040     }
1041 
1042     /**
1043      * @dev Private function to add a token to this extension's ownership-tracking data structures.
1044      * @param to address representing the new owner of the given token ID
1045      * @param tokenId uint256 ID of the token to be added to the tokens list of the given address
1046      */
1047     function _addTokenToOwnerEnumeration(address to, uint256 tokenId) private {
1048         uint256 length = ERC721.balanceOf(to);
1049         _ownedTokens[to][length] = tokenId;
1050         _ownedTokensIndex[tokenId] = length;
1051     }
1052 
1053     /**
1054      * @dev Private function to add a token to this extension's token tracking data structures.
1055      * @param tokenId uint256 ID of the token to be added to the tokens list
1056      */
1057     function _addTokenToAllTokensEnumeration(uint256 tokenId) private {
1058         _allTokensIndex[tokenId] = _allTokens.length;
1059         _allTokens.push(tokenId);
1060     }
1061 
1062     /**
1063      * @dev Private function to remove a token from this extension's ownership-tracking data structures. Note that
1064      * while the token is not assigned a new owner, the `_ownedTokensIndex` mapping is _not_ updated: this allows for
1065      * gas optimizations e.g. when performing a transfer operation (avoiding double writes).
1066      * This has O(1) time complexity, but alters the order of the _ownedTokens array.
1067      * @param from address representing the previous owner of the given token ID
1068      * @param tokenId uint256 ID of the token to be removed from the tokens list of the given address
1069      */
1070     function _removeTokenFromOwnerEnumeration(address from, uint256 tokenId) private {
1071         // To prevent a gap in from's tokens array, we store the last token in the index of the token to delete, and
1072         // then delete the last slot (swap and pop).
1073 
1074         uint256 lastTokenIndex = ERC721.balanceOf(from) - 1;
1075         uint256 tokenIndex = _ownedTokensIndex[tokenId];
1076 
1077         // When the token to delete is the last token, the swap operation is unnecessary
1078         if (tokenIndex != lastTokenIndex) {
1079             uint256 lastTokenId = _ownedTokens[from][lastTokenIndex];
1080 
1081             _ownedTokens[from][tokenIndex] = lastTokenId; // Move the last token to the slot of the to-delete token
1082             _ownedTokensIndex[lastTokenId] = tokenIndex; // Update the moved token's index
1083         }
1084 
1085         // This also deletes the contents at the last position of the array
1086         delete _ownedTokensIndex[tokenId];
1087         delete _ownedTokens[from][lastTokenIndex];
1088     }
1089 
1090     /**
1091      * @dev Private function to remove a token from this extension's token tracking data structures.
1092      * This has O(1) time complexity, but alters the order of the _allTokens array.
1093      * @param tokenId uint256 ID of the token to be removed from the tokens list
1094      */
1095     function _removeTokenFromAllTokensEnumeration(uint256 tokenId) private {
1096         // To prevent a gap in the tokens array, we store the last token in the index of the token to delete, and
1097         // then delete the last slot (swap and pop).
1098 
1099         uint256 lastTokenIndex = _allTokens.length - 1;
1100         uint256 tokenIndex = _allTokensIndex[tokenId];
1101 
1102         // When the token to delete is the last token, the swap operation is unnecessary. However, since this occurs so
1103         // rarely (when the last minted token is burnt) that we still do the swap here to avoid the gas cost of adding
1104         // an 'if' statement (like in _removeTokenFromOwnerEnumeration)
1105         uint256 lastTokenId = _allTokens[lastTokenIndex];
1106 
1107         _allTokens[tokenIndex] = lastTokenId; // Move the last token to the slot of the to-delete token
1108         _allTokensIndex[lastTokenId] = tokenIndex; // Update the moved token's index
1109 
1110         // This also deletes the contents at the last position of the array
1111         delete _allTokensIndex[tokenId];
1112         _allTokens.pop();
1113     }
1114 }
1115 
1116 
1117 /**
1118  * @dev ERC721 token with storage based token URI management.
1119  */
1120 abstract contract ERC721URIStorage is ERC721 {
1121     using Strings for uint256;
1122 
1123     // Optional mapping for token URIs
1124     mapping(uint256 => string) private _tokenURIs;
1125 
1126     /**
1127      * @dev See {IERC721Metadata-tokenURI}.
1128      */
1129     function tokenURI(uint256 tokenId) public view virtual override returns (string memory) {
1130         require(_exists(tokenId), "ERC721URIStorage: URI query for nonexistent token");
1131 
1132         string memory _tokenURI = _tokenURIs[tokenId];
1133         string memory base = _baseURI();
1134 
1135         // If there is no base URI, return the token URI.
1136         if (bytes(base).length == 0) {
1137             return _tokenURI;
1138         }
1139         // If both are set, concatenate the baseURI and tokenURI (via abi.encodePacked).
1140         if (bytes(_tokenURI).length > 0) {
1141             return string(abi.encodePacked(base, _tokenURI));
1142         }
1143 
1144         return super.tokenURI(tokenId);
1145     }
1146 
1147     /**
1148      * @dev Sets `_tokenURI` as the tokenURI of `tokenId`.
1149      *
1150      * Requirements:
1151      *
1152      * - `tokenId` must exist.
1153      */
1154     function _setTokenURI(uint256 tokenId, string memory _tokenURI) internal virtual {
1155         require(_exists(tokenId), "ERC721URIStorage: URI set of nonexistent token");
1156         _tokenURIs[tokenId] = _tokenURI;
1157     }
1158 
1159     /**
1160      * @dev Destroys `tokenId`.
1161      * The approval is cleared when the token is burned.
1162      *
1163      * Requirements:
1164      *
1165      * - `tokenId` must exist.
1166      *
1167      * Emits a {Transfer} event.
1168      */
1169     function _burn(uint256 tokenId) internal virtual override {
1170         super._burn(tokenId);
1171 
1172         if (bytes(_tokenURIs[tokenId]).length != 0) {
1173             delete _tokenURIs[tokenId];
1174         }
1175     }
1176 }
1177 
1178 
1179 /**
1180  * @dev Contract module which allows children to implement an emergency stop
1181  * mechanism that can be triggered by an authorized account.
1182  *
1183  * This module is used through inheritance. It will make available the
1184  * modifiers `whenNotPaused` and `whenPaused`, which can be applied to
1185  * the functions of your contract. Note that they will not be pausable by
1186  * simply including this module, only once the modifiers are put in place.
1187  */
1188 abstract contract Pausable is Context {
1189     /**
1190      * @dev Emitted when the pause is triggered by `account`.
1191      */
1192     event Paused(address account);
1193 
1194     /**
1195      * @dev Emitted when the pause is lifted by `account`.
1196      */
1197     event Unpaused(address account);
1198 
1199     bool private _paused;
1200 
1201     /**
1202      * @dev Initializes the contract in unpaused state.
1203      */
1204     constructor() {
1205         _paused = false;
1206     }
1207 
1208     /**
1209      * @dev Returns true if the contract is paused, and false otherwise.
1210      */
1211     function paused() public view virtual returns (bool) {
1212         return _paused;
1213     }
1214 
1215     /**
1216      * @dev Modifier to make a function callable only when the contract is not paused.
1217      *
1218      * Requirements:
1219      *
1220      * - The contract must not be paused.
1221      */
1222     modifier whenNotPaused() {
1223         require(!paused(), "Pausable: paused");
1224         _;
1225     }
1226 
1227     /**
1228      * @dev Modifier to make a function callable only when the contract is paused.
1229      *
1230      * Requirements:
1231      *
1232      * - The contract must be paused.
1233      */
1234     modifier whenPaused() {
1235         require(paused(), "Pausable: not paused");
1236         _;
1237     }
1238 
1239     /**
1240      * @dev Triggers stopped state.
1241      *
1242      * Requirements:
1243      *
1244      * - The contract must not be paused.
1245      */
1246     function _pause() internal virtual whenNotPaused {
1247         _paused = true;
1248         emit Paused(_msgSender());
1249     }
1250 
1251     /**
1252      * @dev Returns to normal state.
1253      *
1254      * Requirements:
1255      *
1256      * - The contract must be paused.
1257      */
1258     function _unpause() internal virtual whenPaused {
1259         _paused = false;
1260         emit Unpaused(_msgSender());
1261     }
1262 }
1263 
1264 
1265 /**
1266  * @dev Contract module which provides a basic access control mechanism, where
1267  * there is an account (an owner) that can be granted exclusive access to
1268  * specific functions.
1269  *
1270  * By default, the owner account will be the one that deploys the contract. This
1271  * can later be changed with {transferOwnership}.
1272  *
1273  * This module is used through inheritance. It will make available the modifier
1274  * `onlyOwner`, which can be applied to your functions to restrict their use to
1275  * the owner.
1276  */
1277 abstract contract Ownable is Context {
1278     address private _owner;
1279 
1280     event OwnershipTransferred(address indexed previousOwner, address indexed newOwner);
1281 
1282     /**
1283      * @dev Initializes the contract setting the deployer as the initial owner.
1284      */
1285     constructor() {
1286         _setOwner(_msgSender());
1287     }
1288 
1289     /**
1290      * @dev Returns the address of the current owner.
1291      */
1292     function owner() public view virtual returns (address) {
1293         return _owner;
1294     }
1295 
1296     /**
1297      * @dev Throws if called by any account other than the owner.
1298      */
1299     modifier onlyOwner() {
1300         require(owner() == _msgSender(), "Ownable: caller is not the owner");
1301         _;
1302     }
1303 
1304     /**
1305      * @dev Leaves the contract without owner. It will not be possible to call
1306      * `onlyOwner` functions anymore. Can only be called by the current owner.
1307      *
1308      * NOTE: Renouncing ownership will leave the contract without an owner,
1309      * thereby removing any functionality that is only available to the owner.
1310      */
1311     function renounceOwnership() public virtual onlyOwner {
1312         _setOwner(address(0));
1313     }
1314 
1315     /**
1316      * @dev Transfers ownership of the contract to a new account (`newOwner`).
1317      * Can only be called by the current owner.
1318      */
1319     function transferOwnership(address newOwner) public virtual onlyOwner {
1320         require(newOwner != address(0), "Ownable: new owner is the zero address");
1321         _setOwner(newOwner);
1322     }
1323 
1324     function _setOwner(address newOwner) private {
1325         address oldOwner = _owner;
1326         _owner = newOwner;
1327         emit OwnershipTransferred(oldOwner, newOwner);
1328     }
1329 }
1330 
1331 
1332 /**
1333  * @title ERC721 Burnable Token
1334  * @dev ERC721 Token that can be irreversibly burned (destroyed).
1335  */
1336 abstract contract ERC721Burnable is Context, ERC721 {
1337     /**
1338      * @dev Burns `tokenId`. See {ERC721-_burn}.
1339      *
1340      * Requirements:
1341      *
1342      * - The caller must own `tokenId` or be an approved operator.
1343      */
1344     function burn(uint256 tokenId) public virtual {
1345         //solhint-disable-next-line max-line-length
1346         require(_isApprovedOrOwner(_msgSender(), tokenId), "ERC721Burnable: caller is not owner nor approved");
1347         _burn(tokenId);
1348     }
1349 }
1350 
1351 
1352 /**
1353  * @title Counters
1354  * @author Matt Condon (@shrugs)
1355  * @dev Provides counters that can only be incremented, decremented or reset. This can be used e.g. to track the number
1356  * of elements in a mapping, issuing ERC721 ids, or counting request ids.
1357  *
1358  * Include with `using Counters for Counters.Counter;`
1359  */
1360 library Counters {
1361     struct Counter {
1362         // This variable should never be directly accessed by users of the library: interactions must be restricted to
1363         // the library's function. As of Solidity v0.5.2, this cannot be enforced, though there is a proposal to add
1364         // this feature: see https://github.com/ethereum/solidity/issues/4637
1365         uint256 _value; // default: 0
1366     }
1367 
1368     function current(Counter storage counter) internal view returns (uint256) {
1369         return counter._value;
1370     }
1371 
1372     function increment(Counter storage counter) internal {
1373         unchecked {
1374             counter._value += 1;
1375         }
1376     }
1377 
1378     function decrement(Counter storage counter) internal {
1379         uint256 value = counter._value;
1380         require(value > 0, "Counter: decrement overflow");
1381         unchecked {
1382             counter._value = value - 1;
1383         }
1384     }
1385 
1386     function reset(Counter storage counter) internal {
1387         counter._value = 0;
1388     }
1389 }
1390 
1391 
1392 struct Team {
1393     uint256 balance;
1394     uint256 share;
1395     string name;
1396 }
1397 
1398 contract MALPass is ERC721, ERC721Enumerable, ERC721URIStorage, Pausable, ERC721Burnable, Ownable {
1399     using Counters for Counters.Counter;
1400     Counters.Counter private _tokenIdCounter;
1401 
1402     uint256 public constant MAX_SUPPLY_GREEN =  1100;
1403     uint256 public constant RESERVED_GREEN = 100;
1404     uint256 public constant MAX_SUPPLY_BLUE =  100;
1405     uint256 public constant MAX_SUPPLY_GOLD =  10;
1406 
1407     uint256 public constant MAX_FOR_ONE_ADDRESS_GREEN = 20;
1408     uint256 public constant MAX_FOR_ONE_ADDRESS_BLUE = 4;
1409     uint256 public constant MAX_FOR_ONE_ADDRESS_GOLD = 1;
1410 
1411     uint256 public constant PASS_VALUE_IN_APES_GREEN = 1;
1412     uint256 public constant PASS_VALUE_IN_APES_BLUE = 5;
1413     uint256 public constant PASS_VALUE_IN_APES_GOLD = 10;
1414 
1415     uint256 public constant PASS_PRICE_GREEN = 0.09 ether;
1416     uint256 public constant PASS_PRICE_BLUE = 0.45 ether;
1417     uint256 public constant PASS_PRICE_GOLD = 0.9 ether;
1418 
1419     uint256 public MINTED_GREEN = 0;
1420     uint256 public MINTED_BLUE = 0;
1421     uint256 public MINTED_GOLD = 0;
1422 
1423     mapping(address=>uint256) OWNERS_GREEN;
1424     mapping(address=>uint256) OWNERS_BLUE;
1425     mapping(address=>uint256) OWNERS_GOLD;
1426     
1427     address public APE_CONTRACT; // for pause and burn
1428     
1429     uint256 total_teams;
1430     mapping(uint=>address) team_addresses;
1431     mapping(address=>Team) teams;
1432 
1433     mapping(uint=>uint) pass_types;
1434     
1435     constructor() ERC721("Moon Ape Lab Pass", "MALPASS") {
1436         total_teams = 0;
1437         
1438         team_addresses[total_teams] = 0x5966932Ae92fbE75280e0371cb3bC27B558115A8;
1439         teams[address(0x5966932Ae92fbE75280e0371cb3bC27B558115A8)] = Team(0, 30, "Pvl");
1440         total_teams = total_teams + 1;
1441         
1442         team_addresses[total_teams] = 0xA45845299bD26af707D0F3C902519b41D8aAefca;
1443         teams[address(0xA45845299bD26af707D0F3C902519b41D8aAefca)] = Team(0, 5, "Nkt");
1444         total_teams = total_teams + 1;
1445 
1446         team_addresses[total_teams] = 0x77FeB62f865365f4b81ef49901BC012d017509F3;
1447         teams[address(0x77FeB62f865365f4b81ef49901BC012d017509F3)] = Team(0, 20, "Sts");
1448         total_teams = total_teams + 1;
1449 
1450         team_addresses[total_teams] = 0xc2a6035fB9200446f154cdce00EA6ff0160C2854;
1451         teams[address(0xc2a6035fB9200446f154cdce00EA6ff0160C2854)] = Team(0, 20, "Vld");
1452         total_teams = total_teams + 1;
1453 
1454         team_addresses[total_teams] = 0xd44ac9eB549DCF1D47D47d81398182265C312232;
1455         teams[address(0xd44ac9eB549DCF1D47D47d81398182265C312232)] = Team(0, 5, "Nck");
1456         total_teams = total_teams + 1;
1457 
1458         team_addresses[total_teams] = 0x1eAC73484bcf66564D896213E06d6c5D013244A4;
1459         teams[address(0x1eAC73484bcf66564D896213E06d6c5D013244A4)] = Team(0, 20, "Andr");
1460         total_teams = total_teams + 1;
1461         
1462         _tokenIdCounter.increment();
1463     }
1464     
1465     function pause() public {
1466         require(msg.sender == owner() || msg.sender == APE_CONTRACT);
1467         _pause();
1468     }
1469 
1470     function reservePasses(uint256 quantity, uint256 _pass_type) public onlyOwner {
1471         require(_pass_type == 1 || _pass_type == 2 || _pass_type == 3, "Invalid pass type to be minted. Allowed are: 1=Green, 2=Blue, 3=Gold");
1472         if (_pass_type == 1){
1473             require(MINTED_GREEN + quantity < MAX_SUPPLY_GREEN + 1, "Too many passes are to be created.");
1474         } else if (_pass_type == 2){
1475             require(MINTED_BLUE + quantity < MAX_SUPPLY_BLUE + 1, "Too many passes are to be created.");
1476         } else {
1477             require(MINTED_GOLD + quantity < MAX_SUPPLY_GOLD + 1, "Too many passes are to be created.");
1478         }
1479         for (uint256 i = 0; i < quantity; i++) {
1480             _safeMint(msg.sender, _tokenIdCounter.current());
1481             pass_types[_tokenIdCounter.current()] = _pass_type;
1482             _tokenIdCounter.increment();
1483         }
1484         if (_pass_type == 1){
1485             MINTED_GREEN += quantity;
1486             OWNERS_GREEN[msg.sender] += quantity;
1487         } else if (_pass_type == 2){
1488             MINTED_BLUE += quantity;
1489             OWNERS_BLUE[msg.sender] += quantity;
1490         } else {
1491             MINTED_GOLD += quantity;
1492             OWNERS_GOLD[msg.sender] += quantity;
1493         }
1494     }
1495 
1496     function myBalance(uint256 _pass_type) public view returns (uint256){
1497         require(_pass_type == 1 || _pass_type == 2 || _pass_type == 3, "Invalid pass type. Allowed are: 1=Green, 2=Blue, 3=Gold");
1498         if (_pass_type == 1){
1499             return OWNERS_GREEN[msg.sender];
1500         } else if (_pass_type == 2){
1501             return OWNERS_BLUE[msg.sender];
1502         } else {
1503             return OWNERS_GOLD[msg.sender];
1504         }
1505     }
1506 
1507     function unpause() public onlyOwner {
1508         _unpause();
1509     }
1510     
1511     function setApeContract(address ape_contract_address) public onlyOwner{
1512         APE_CONTRACT = ape_contract_address;
1513     }
1514     
1515     function pass_value_in_apes(uint256 _tokenId) public view returns (uint256){
1516         require(_exists(_tokenId), "ERC721Metadata: URI query for nonexistent pass");
1517         uint256 token_pass_type = pass_types[_tokenId];
1518         if (token_pass_type == 1){
1519             return PASS_VALUE_IN_APES_GREEN;
1520         } else if (token_pass_type == 2){
1521             return PASS_VALUE_IN_APES_BLUE;
1522         } else {
1523             return PASS_VALUE_IN_APES_GOLD;
1524         }
1525     }
1526     
1527     function get_pass(uint256 quantity, uint256 _pass_type) public payable whenNotPaused{
1528         require(msg.sender != address(0) && msg.sender != address(this));
1529         require(_pass_type == 1 || _pass_type == 2 || _pass_type == 3, "Invalid pass type to be minted. Allowed are: 1=Green, 2=Blue, 3=Gold.");
1530         if (_pass_type == 1){
1531             require(quantity * PASS_PRICE_GREEN == msg.value, "Ether value sent is incorrect.");
1532             require(MINTED_GREEN + quantity < MAX_SUPPLY_GREEN - RESERVED_GREEN + 1, "Too many Green Passes are to be minted.");
1533             require(quantity + OWNERS_GREEN[msg.sender] <= MAX_FOR_ONE_ADDRESS_GREEN, "Maximum quantity of Green Passes to buy from 1 address is 20.");
1534         } else if (_pass_type == 2){
1535             require(quantity * PASS_PRICE_BLUE == msg.value, "Ether value sent is incorrect.");
1536             require(MINTED_BLUE + quantity < MAX_SUPPLY_BLUE + 1, "Too many Blue Passes are to be minted.");
1537             require(quantity + OWNERS_BLUE[msg.sender] <= MAX_FOR_ONE_ADDRESS_BLUE, "Maximum quantity of Blue Passes to buy from 1 address is 4.");
1538         } else {
1539             require(quantity * PASS_PRICE_GOLD == msg.value, "Ether value sent is incorrect.");
1540             require(MINTED_GOLD + quantity < MAX_SUPPLY_GOLD + 1, "Too many Gold Passes are to be minted.");
1541             require(quantity + OWNERS_GOLD[msg.sender] <= MAX_FOR_ONE_ADDRESS_GOLD, "Maximum quantity of Gold Passes to buy from 1 address is 1.");
1542         }
1543         
1544         for(uint256 i = 0; i < quantity; i++) {
1545             _safeMint(msg.sender, _tokenIdCounter.current());
1546             pass_types[_tokenIdCounter.current()] = _pass_type;
1547             _tokenIdCounter.increment();
1548         }
1549 
1550         if (_pass_type == 1){
1551             MINTED_GREEN += quantity;
1552             OWNERS_GREEN[msg.sender] += quantity;
1553         } else if (_pass_type == 2){
1554             MINTED_BLUE += quantity;
1555             OWNERS_BLUE[msg.sender] += quantity;
1556         } else {
1557             MINTED_GOLD += quantity;
1558             OWNERS_GOLD[msg.sender] += quantity;
1559         }
1560 
1561         for (uint256 i = 0; i < total_teams; i++){
1562             teams[team_addresses[i]].balance += msg.value * teams[team_addresses[i]].share / 100;
1563         }
1564     }
1565     
1566     function withdraw(address payable to_address) public returns (bool){
1567         require(teams[msg.sender].balance > 0, "Sorry! You have nothing to withdraw.");
1568         require(to_address != address(0) && to_address != address(this));
1569         require(msg.sender != address(0) && msg.sender != address(this));
1570         to_address.transfer(teams[msg.sender].balance);
1571         teams[msg.sender].balance = 0;
1572         return true;
1573     }
1574 
1575     function team_get_percentage(address my_address) public view returns (uint256){
1576         return teams[my_address].share;
1577     }
1578 
1579     function team_get_share_balance(address my_address) public view returns (uint256){
1580         return teams[my_address].balance;
1581     }
1582 
1583     function _beforeTokenTransfer(address from, address to, uint256 tokenId)
1584         internal
1585         whenNotPaused
1586         override(ERC721, ERC721Enumerable)
1587     {
1588         super._beforeTokenTransfer(from, to, tokenId);
1589     }
1590     
1591     function burn(uint256 tokenId) public override {
1592         require(_isApprovedOrOwner(_msgSender(), tokenId) || msg.sender == APE_CONTRACT, "Caller is not approved/owner nor the Ape contract");
1593         _burn(tokenId);
1594     }
1595 
1596     function _burn(uint256 tokenId) internal override(ERC721, ERC721URIStorage) {
1597         super._burn(tokenId);
1598     }
1599 
1600     function _baseURI() internal pure override returns (string memory) {
1601         return "ipfs://QmWTXioufvNjRkWod4dYGV685CD1ZDesFP5dezUMRoJkEc/";
1602     }
1603 
1604 
1605     function tokenURI(uint256 tokenId) public view override(ERC721, ERC721URIStorage) returns (string memory) {
1606         require(_exists(tokenId), "ERC721Metadata: URI query for nonexistent pass");
1607         string memory baseURI = _baseURI();
1608         uint256 token_pass_type = pass_types[tokenId];
1609         if (token_pass_type == 1){
1610             return string(abi.encodePacked(baseURI, "green_metadata.json"));
1611         } else if (token_pass_type == 2){
1612             return string(abi.encodePacked(baseURI, "blue_metadata.json"));
1613         } else {
1614             return string(abi.encodePacked(baseURI, "gold_metadata.json"));
1615         }
1616     }
1617 
1618     function supportsInterface(bytes4 interfaceId)
1619         public
1620         view
1621         override(ERC721, ERC721Enumerable)
1622         returns (bool)
1623     {
1624         return super.supportsInterface(interfaceId);
1625     }
1626 }
1627 
1628 
1629 
1630 contract MAL is ERC721, ERC721URIStorage, Ownable {
1631     using Counters for Counters.Counter;
1632     Counters.Counter private _tokenIdCounter;
1633 	
1634     uint256 total_teams;
1635     mapping(uint=>address) team_addresses;
1636     mapping(address=>Team) teams;
1637     
1638 	uint256 TOTAL_SUPPLY = 1;
1639     bool public MINTING_PAUSED;
1640     uint256 public constant MAX_SUPPLY = 8000;
1641     uint256 public constant APE_PRICE = 90000000000000000; //0.09 ETH
1642     
1643     address public PASS_CONTRACT_ADDRESS;
1644 
1645     bool public REVEALED;
1646     string private base_url;
1647 	bool private withdrawal_enabled;
1648 	bool public whitelist_sale;
1649 	
1650 	mapping(address=>uint256) whitelisted;
1651     
1652     
1653     constructor() ERC721("Moon Ape Lab", "MAL") {
1654         REVEALED = false;
1655 		withdrawal_enabled = true;
1656 		whitelist_sale = true;
1657         MINTING_PAUSED = true;
1658         
1659         team_addresses[0] = 0x84629C04D07FC89220E7Dc970a1Fb127bCd86f47;
1660         teams[address(0x84629C04D07FC89220E7Dc970a1Fb127bCd86f47)] = Team(0, 50, "Ph");
1661         
1662         team_addresses[1] = 0xC8e40F13434f1dFA4072382d15f8a00adD0ba481;
1663         teams[address(0xC8e40F13434f1dFA4072382d15f8a00adD0ba481)] = Team(0, 38, "StsVld");
1664 
1665         team_addresses[2] = 0x1eAC73484bcf66564D896213E06d6c5D013244A4;
1666         teams[address(0x1eAC73484bcf66564D896213E06d6c5D013244A4)] = Team(0, 12, "And");
1667 
1668         total_teams = 3;
1669         _tokenIdCounter.increment();
1670         
1671         base_url = "ipfs://QmUgcPaqkFq9FuknZx7gS2UVGBwLgGFuhFeaUzadvZFhgV/";
1672     }
1673 
1674     function addWhitelisted(address[] memory wl_addresses) external onlyOwner{
1675         for (uint256 i = 0; i < wl_addresses.length; i++){
1676             whitelisted[wl_addresses[i]] = 7;
1677         }
1678     }
1679 
1680     function setPassContract(address _pass_address) public onlyOwner{
1681         PASS_CONTRACT_ADDRESS = _pass_address;
1682     }
1683 
1684     function totalSupply() public view returns(uint256){
1685         return TOTAL_SUPPLY - 1;
1686     }
1687 
1688     function pause() external onlyOwner {
1689         require(MINTING_PAUSED == false, "Minting is already paused");
1690         MINTING_PAUSED = true;
1691     }
1692 
1693     function unpause() external onlyOwner {
1694         require(MINTING_PAUSED == true, "Minting is already unpaused");
1695         MINTING_PAUSED = false;
1696     }
1697 	
1698 	function startPublicSale() external onlyOwner{
1699 		require(whitelist_sale == true, "Public Sale is already active");
1700 		whitelist_sale = false;
1701 	}
1702 
1703     function transformToAddressesWithNum(address[] memory ape_owners, uint8[] memory qs) external onlyOwner{ // Passes to Apes
1704         require(ape_owners.length == qs.length, "Lists must be same length");
1705         for (uint256 i = 0; i < ape_owners.length; i++){
1706             for (uint8 j = 0; j < qs[i]; j++){
1707                 _safeMint(ape_owners[i], _tokenIdCounter.current());
1708                 _tokenIdCounter.increment();
1709             }
1710             TOTAL_SUPPLY += qs[i];
1711         }
1712     }
1713 
1714     function revealApes(string memory baseURI) external onlyOwner {
1715         require(REVEALED == false, "Apes are already revealed");
1716         base_url = baseURI;
1717         REVEALED = true;
1718     }
1719 	
1720 	function mintApeForWhitelisted(uint256 number_of_tokens) payable external{
1721 		require(whitelist_sale == true, "Public sale is active. Please use function mintApe(number_of_tokens)");
1722         require(MINTING_PAUSED == false, "Sorry! Minting is currently paused.");
1723 		require(msg.sender != address(0) && msg.sender != address(this));
1724 		require(APE_PRICE * number_of_tokens <= msg.value, "Ether value sent is not correct");
1725 		require(number_of_tokens > 0, "Please mint at least 1 Ape");
1726         require(TOTAL_SUPPLY + number_of_tokens < MAX_SUPPLY + 2, "Too many tokens are to be created. Max supply is 8000");
1727 		require(number_of_tokens < whitelisted[msg.sender], "Whitelisted users can purchase up to 6 NFTs. Either you are not whitelisted or you have already bought the maximum amount.");
1728 		
1729 		for(uint256 i = 0; i < number_of_tokens; i++) {
1730             _safeMint(msg.sender, _tokenIdCounter.current());
1731             _tokenIdCounter.increment();
1732         }
1733         for (uint256 i = 0; i < total_teams; i++){
1734             teams[team_addresses[i]].balance += msg.value * teams[team_addresses[i]].share / 100;
1735         }
1736         TOTAL_SUPPLY += number_of_tokens;
1737 		
1738 		whitelisted[msg.sender] -= number_of_tokens;
1739 	}
1740     
1741     function mintApe(uint256 number_of_tokens) payable external{
1742 		require(whitelist_sale == false, "Public sale is not active. Please try again later");
1743         require(MINTING_PAUSED == false, "Sorry! Minting is currently paused.");
1744         require(msg.sender != address(0) && msg.sender != address(this));
1745         require(APE_PRICE * number_of_tokens <= msg.value, "Ether value sent is not correct");
1746         require(TOTAL_SUPPLY + number_of_tokens < MAX_SUPPLY + 2, "Too many tokens are to be created. Max supply is 8000");
1747         require(number_of_tokens + balanceOf(msg.sender) <= 20, "1 address can hold max 20 NFTs");
1748 		require(number_of_tokens > 0, "Please mint at least 1 Ape");
1749         
1750         for(uint256 i = 0; i < number_of_tokens; i++) {
1751             _safeMint(msg.sender, _tokenIdCounter.current());
1752             _tokenIdCounter.increment();
1753         }
1754         for (uint256 i = 0; i < total_teams; i++){
1755             teams[team_addresses[i]].balance += msg.value * teams[team_addresses[i]].share / 100;
1756         }
1757         TOTAL_SUPPLY += number_of_tokens;
1758     }
1759     
1760     function withdraw(address payable to_address) external {
1761         require(teams[msg.sender].balance > 0, "Sorry! You have nothing to withdraw.");
1762         require(to_address != address(0) && to_address != address(this));
1763         require(msg.sender != address(0) && msg.sender != address(this));
1764 		require(withdrawal_enabled == true, "Please try again later.");
1765         to_address.transfer(teams[msg.sender].balance);
1766         teams[msg.sender].balance = 0;
1767     }
1768 
1769     function getTeamMemberBalance(address my_address) external view returns (uint256){
1770         return teams[my_address].balance;
1771     }
1772 	
1773 	function safeMint(address to) external onlyOwner {
1774         _safeMint(to, _tokenIdCounter.current());
1775         _tokenIdCounter.increment();
1776         TOTAL_SUPPLY += 1;
1777     }
1778 
1779     function safeMintMultiple(address[] memory receivers) external onlyOwner {
1780         for (uint256 i = 0; i < receivers.length; i++){
1781             _safeMint(receivers[i], _tokenIdCounter.current());
1782             _tokenIdCounter.increment();
1783         }
1784         TOTAL_SUPPLY += receivers.length;
1785     }
1786 
1787     function _baseURI() internal view override returns (string memory) {
1788         return base_url;
1789     }
1790     
1791     function tokenURI(uint256 tokenId) public view override(ERC721, ERC721URIStorage) returns (string memory) {
1792         require(_exists(tokenId), "ERC721Metadata: URI query for nonexistent token");
1793         return string(abi.encodePacked(super.tokenURI(tokenId), ".json"));
1794     }
1795 
1796     function toggle() external onlyOwner returns(bool) {
1797 		if (withdrawal_enabled == true){
1798 			withdrawal_enabled = false;
1799             return false;
1800 		} else {
1801 			withdrawal_enabled = true;
1802             return true;
1803 		}
1804 	}
1805 
1806     function _beforeTokenTransfer(address from, address to, uint256 tokenId) internal override {
1807         super._beforeTokenTransfer(from, to, tokenId);
1808     }
1809 
1810     function _burn(uint256 tokenId) internal override(ERC721, ERC721URIStorage) {
1811         super._burn(tokenId);
1812     }
1813 
1814     function supportsInterface(bytes4 interfaceId)
1815         public
1816         view
1817         override
1818         returns (bool)
1819     {
1820         return super.supportsInterface(interfaceId);
1821     }
1822 }