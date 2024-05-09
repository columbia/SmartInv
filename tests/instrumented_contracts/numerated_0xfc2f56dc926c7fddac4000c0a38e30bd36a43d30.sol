1 pragma solidity 0.8.10;
2 // SPDX-License-Identifier: MIT
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
25 /**
26  * @dev Required interface of an ERC721 compliant contract.
27  */
28 interface IERC721 is IERC165 {
29     /**
30      * @dev Emitted when `tokenId` token is transferred from `from` to `to`.
31      */
32     event Transfer(address indexed from, address indexed to, uint256 indexed tokenId);
33 
34     /**
35      * @dev Emitted when `owner` enables `approved` to manage the `tokenId` token.
36      */
37     event Approval(address indexed owner, address indexed approved, uint256 indexed tokenId);
38 
39     /**
40      * @dev Emitted when `owner` enables or disables (`approved`) `operator` to manage all of its assets.
41      */
42     event ApprovalForAll(address indexed owner, address indexed operator, bool approved);
43 
44     /**
45      * @dev Returns the number of tokens in ``owner``'s account.
46      */
47     function balanceOf(address owner) external view returns (uint256 balance);
48 
49     /**
50      * @dev Returns the owner of the `tokenId` token.
51      *
52      * Requirements:
53      *
54      * - `tokenId` must exist.
55      */
56     function ownerOf(uint256 tokenId) external view returns (address owner);
57 
58     /**
59      * @dev Safely transfers `tokenId` token from `from` to `to`, checking first that contract recipients
60      * are aware of the ERC721 protocol to prevent tokens from being forever locked.
61      *
62      * Requirements:
63      *
64      * - `from` cannot be the zero address.
65      * - `to` cannot be the zero address.
66      * - `tokenId` token must exist and be owned by `from`.
67      * - If the caller is not `from`, it must be have been allowed to move this token by either {approve} or {setApprovalForAll}.
68      * - If `to` refers to a smart contract, it must implement {IERC721Receiver-onERC721Received}, which is called upon a safe transfer.
69      *
70      * Emits a {Transfer} event.
71      */
72     function safeTransferFrom(
73         address from,
74         address to,
75         uint256 tokenId
76     ) external;
77 
78     /**
79      * @dev Transfers `tokenId` token from `from` to `to`.
80      *
81      * WARNING: Usage of this method is discouraged, use {safeTransferFrom} whenever possible.
82      *
83      * Requirements:
84      *
85      * - `from` cannot be the zero address.
86      * - `to` cannot be the zero address.
87      * - `tokenId` token must be owned by `from`.
88      * - If the caller is not `from`, it must be approved to move this token by either {approve} or {setApprovalForAll}.
89      *
90      * Emits a {Transfer} event.
91      */
92     function transferFrom(
93         address from,
94         address to,
95         uint256 tokenId
96     ) external;
97 
98     /**
99      * @dev Gives permission to `to` to transfer `tokenId` token to another account.
100      * The approval is cleared when the token is transferred.
101      *
102      * Only a single account can be approved at a time, so approving the zero address clears previous approvals.
103      *
104      * Requirements:
105      *
106      * - The caller must own the token or be an approved operator.
107      * - `tokenId` must exist.
108      *
109      * Emits an {Approval} event.
110      */
111     function approve(address to, uint256 tokenId) external;
112 
113     /**
114      * @dev Returns the account approved for `tokenId` token.
115      *
116      * Requirements:
117      *
118      * - `tokenId` must exist.
119      */
120     function getApproved(uint256 tokenId) external view returns (address operator);
121 
122     /**
123      * @dev Approve or remove `operator` as an operator for the caller.
124      * Operators can call {transferFrom} or {safeTransferFrom} for any token owned by the caller.
125      *
126      * Requirements:
127      *
128      * - The `operator` cannot be the caller.
129      *
130      * Emits an {ApprovalForAll} event.
131      */
132     function setApprovalForAll(address operator, bool _approved) external;
133 
134     /**
135      * @dev Returns if the `operator` is allowed to manage all of the assets of `owner`.
136      *
137      * See {setApprovalForAll}
138      */
139     function isApprovedForAll(address owner, address operator) external view returns (bool);
140 
141     /**
142      * @dev Safely transfers `tokenId` token from `from` to `to`.
143      *
144      * Requirements:
145      *
146      * - `from` cannot be the zero address.
147      * - `to` cannot be the zero address.
148      * - `tokenId` token must exist and be owned by `from`.
149      * - If the caller is not `from`, it must be approved to move this token by either {approve} or {setApprovalForAll}.
150      * - If `to` refers to a smart contract, it must implement {IERC721Receiver-onERC721Received}, which is called upon a safe transfer.
151      *
152      * Emits a {Transfer} event.
153      */
154     function safeTransferFrom(
155         address from,
156         address to,
157         uint256 tokenId,
158         bytes calldata data
159     ) external;
160 }
161 
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
188 
189 /**
190  * @title ERC-721 Non-Fungible Token Standard, optional metadata extension
191  * @dev See https://eips.ethereum.org/EIPS/eip-721
192  */
193 interface IERC721Metadata is IERC721 {
194     /**
195      * @dev Returns the token collection name.
196      */
197     function name() external view returns (string memory);
198 
199     /**
200      * @dev Returns the token collection symbol.
201      */
202     function symbol() external view returns (string memory);
203 
204     /**
205      * @dev Returns the Uniform Resource Identifier (URI) for `tokenId` token.
206      */
207     function tokenURI(uint256 tokenId) external view returns (string memory);
208 }
209 
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
426 
427 /**
428  * @dev Provides information about the current execution context, including the
429  * sender of the transaction and its data. While these are generally available
430  * via msg.sender and msg.data, they should not be accessed in such a direct
431  * manner, since when dealing with meta-transactions the account sending and
432  * paying for execution may not be the actual sender (as far as an application
433  * is concerned).
434  *
435  * This contract is only required for intermediate, library-like contracts.
436  */
437 abstract contract Context {
438     function _msgSender() internal view virtual returns (address) {
439         return msg.sender;
440     }
441 
442     function _msgData() internal view virtual returns (bytes calldata) {
443         return msg.data;
444     }
445 }
446 
447 
448 
449 /**
450  * @dev String operations.
451  */
452 library Strings {
453     bytes16 private constant _HEX_SYMBOLS = "0123456789abcdef";
454 
455     /**
456      * @dev Converts a `uint256` to its ASCII `string` decimal representation.
457      */
458     function toString(uint256 value) internal pure returns (string memory) {
459         // Inspired by OraclizeAPI's implementation - MIT licence
460         // https://github.com/oraclize/ethereum-api/blob/b42146b063c7d6ee1358846c198246239e9360e8/oraclizeAPI_0.4.25.sol
461 
462         if (value == 0) {
463             return "0";
464         }
465         uint256 temp = value;
466         uint256 digits;
467         while (temp != 0) {
468             digits++;
469             temp /= 10;
470         }
471         bytes memory buffer = new bytes(digits);
472         while (value != 0) {
473             digits -= 1;
474             buffer[digits] = bytes1(uint8(48 + uint256(value % 10)));
475             value /= 10;
476         }
477         return string(buffer);
478     }
479 
480     /**
481      * @dev Converts a `uint256` to its ASCII `string` hexadecimal representation.
482      */
483     function toHexString(uint256 value) internal pure returns (string memory) {
484         if (value == 0) {
485             return "0x00";
486         }
487         uint256 temp = value;
488         uint256 length = 0;
489         while (temp != 0) {
490             length++;
491             temp >>= 8;
492         }
493         return toHexString(value, length);
494     }
495 
496     /**
497      * @dev Converts a `uint256` to its ASCII `string` hexadecimal representation with fixed length.
498      */
499     function toHexString(uint256 value, uint256 length) internal pure returns (string memory) {
500         bytes memory buffer = new bytes(2 * length + 2);
501         buffer[0] = "0";
502         buffer[1] = "x";
503         for (uint256 i = 2 * length + 1; i > 1; --i) {
504             buffer[i] = _HEX_SYMBOLS[value & 0xf];
505             value >>= 4;
506         }
507         require(value == 0, "Strings: hex length insufficient");
508         return string(buffer);
509     }
510 }
511 
512 
513 
514 /**
515  * @dev Implementation of the {IERC165} interface.
516  *
517  * Contracts that want to implement ERC165 should inherit from this contract and override {supportsInterface} to check
518  * for the additional interface id that will be supported. For example:
519  *
520  * ```solidity
521  * function supportsInterface(bytes4 interfaceId) public view virtual override returns (bool) {
522  *     return interfaceId == type(MyInterface).interfaceId || super.supportsInterface(interfaceId);
523  * }
524  * ```
525  *
526  * Alternatively, {ERC165Storage} provides an easier to use but more expensive implementation.
527  */
528 abstract contract ERC165 is IERC165 {
529     /**
530      * @dev See {IERC165-supportsInterface}.
531      */
532     function supportsInterface(bytes4 interfaceId) public view virtual override returns (bool) {
533         return interfaceId == type(IERC165).interfaceId;
534     }
535 }
536 
537 /**
538  * @dev Implementation of https://eips.ethereum.org/EIPS/eip-721[ERC721] Non-Fungible Token Standard, including
539  * the Metadata extension, but not including the Enumerable extension, which is available separately as
540  * {ERC721Enumerable}.
541  */
542 contract ERC721 is Context, ERC165, IERC721, IERC721Metadata {
543     using Address for address;
544     using Strings for uint256;
545 
546     // Token name
547     string private _name;
548 
549     // Token symbol
550     string private _symbol;
551 
552     // Mapping from token ID to owner address
553     mapping(uint256 => address) private _owners;
554 
555     // Mapping owner address to token count
556     mapping(address => uint256) private _balances;
557 
558     // Mapping from token ID to approved address
559     mapping(uint256 => address) private _tokenApprovals;
560 
561     // Mapping from owner to operator approvals
562     mapping(address => mapping(address => bool)) private _operatorApprovals;
563 
564     /**
565      * @dev Initializes the contract by setting a `name` and a `symbol` to the token collection.
566      */
567     constructor(string memory name_, string memory symbol_) {
568         _name = name_;
569         _symbol = symbol_;
570     }
571 
572     /**
573      * @dev See {IERC165-supportsInterface}.
574      */
575     function supportsInterface(bytes4 interfaceId) public view virtual override(ERC165, IERC165) returns (bool) {
576         return
577             interfaceId == type(IERC721).interfaceId ||
578             interfaceId == type(IERC721Metadata).interfaceId ||
579             super.supportsInterface(interfaceId);
580     }
581 
582     /**
583      * @dev See {IERC721-balanceOf}.
584      */
585     function balanceOf(address owner) public view virtual override returns (uint256) {
586         require(owner != address(0), "ERC721: balance query for the zero address");
587         return _balances[owner];
588     }
589 
590     /**
591      * @dev See {IERC721-ownerOf}.
592      */
593     function ownerOf(uint256 tokenId) public view virtual override returns (address) {
594         address owner = _owners[tokenId];
595         require(owner != address(0), "ERC721: owner query for nonexistent token");
596         return owner;
597     }
598 
599     /**
600      * @dev See {IERC721Metadata-name}.
601      */
602     function name() public view virtual override returns (string memory) {
603         return _name;
604     }
605 
606     /**
607      * @dev See {IERC721Metadata-symbol}.
608      */
609     function symbol() public view virtual override returns (string memory) {
610         return _symbol;
611     }
612 
613     /**
614      * @dev See {IERC721Metadata-tokenURI}.
615      */
616     function tokenURI(uint256 tokenId) public view virtual override returns (string memory) {
617         require(_exists(tokenId), "ERC721Metadata: URI query for nonexistent token");
618 
619         string memory baseURI = _baseURI();
620         return bytes(baseURI).length > 0 ? string(abi.encodePacked(baseURI, tokenId.toString())) : "";
621     }
622 
623     /**
624      * @dev Base URI for computing {tokenURI}. If set, the resulting URI for each
625      * token will be the concatenation of the `baseURI` and the `tokenId`. Empty
626      * by default, can be overriden in child contracts.
627      */
628     function _baseURI() internal view virtual returns (string memory) {
629         return "";
630     }
631 
632     /**
633      * @dev See {IERC721-approve}.
634      */
635     function approve(address to, uint256 tokenId) public virtual override {
636         address owner = ERC721.ownerOf(tokenId);
637         require(to != owner, "ERC721: approval to current owner");
638 
639         require(
640             _msgSender() == owner || isApprovedForAll(owner, _msgSender()),
641             "ERC721: approve caller is not owner nor approved for all"
642         );
643 
644         _approve(to, tokenId);
645     }
646 
647     /**
648      * @dev See {IERC721-getApproved}.
649      */
650     function getApproved(uint256 tokenId) public view virtual override returns (address) {
651         require(_exists(tokenId), "ERC721: approved query for nonexistent token");
652 
653         return _tokenApprovals[tokenId];
654     }
655 
656     /**
657      * @dev See {IERC721-setApprovalForAll}.
658      */
659     function setApprovalForAll(address operator, bool approved) public virtual override {
660         require(operator != _msgSender(), "ERC721: approve to caller");
661 
662         _operatorApprovals[_msgSender()][operator] = approved;
663         emit ApprovalForAll(_msgSender(), operator, approved);
664     }
665 
666     /**
667      * @dev See {IERC721-isApprovedForAll}.
668      */
669     function isApprovedForAll(address owner, address operator) public view virtual override returns (bool) {
670         return _operatorApprovals[owner][operator];
671     }
672 
673     /**
674      * @dev See {IERC721-transferFrom}.
675      */
676     function transferFrom(
677         address from,
678         address to,
679         uint256 tokenId
680     ) public virtual override {
681         //solhint-disable-next-line max-line-length
682         require(_isApprovedOrOwner(_msgSender(), tokenId), "ERC721: transfer caller is not owner nor approved");
683 
684         _transfer(from, to, tokenId);
685     }
686 
687     /**
688      * @dev See {IERC721-safeTransferFrom}.
689      */
690     function safeTransferFrom(
691         address from,
692         address to,
693         uint256 tokenId
694     ) public virtual override {
695         safeTransferFrom(from, to, tokenId, "");
696     }
697 
698     /**
699      * @dev See {IERC721-safeTransferFrom}.
700      */
701     function safeTransferFrom(
702         address from,
703         address to,
704         uint256 tokenId,
705         bytes memory _data
706     ) public virtual override {
707         require(_isApprovedOrOwner(_msgSender(), tokenId), "ERC721: transfer caller is not owner nor approved");
708         _safeTransfer(from, to, tokenId, _data);
709     }
710 
711     /**
712      * @dev Safely transfers `tokenId` token from `from` to `to`, checking first that contract recipients
713      * are aware of the ERC721 protocol to prevent tokens from being forever locked.
714      *
715      * `_data` is additional data, it has no specified format and it is sent in call to `to`.
716      *
717      * This internal function is equivalent to {safeTransferFrom}, and can be used to e.g.
718      * implement alternative mechanisms to perform token transfer, such as signature-based.
719      *
720      * Requirements:
721      *
722      * - `from` cannot be the zero address.
723      * - `to` cannot be the zero address.
724      * - `tokenId` token must exist and be owned by `from`.
725      * - If `to` refers to a smart contract, it must implement {IERC721Receiver-onERC721Received}, which is called upon a safe transfer.
726      *
727      * Emits a {Transfer} event.
728      */
729     function _safeTransfer(
730         address from,
731         address to,
732         uint256 tokenId,
733         bytes memory _data
734     ) internal virtual {
735         _transfer(from, to, tokenId);
736         require(_checkOnERC721Received(from, to, tokenId, _data), "ERC721: transfer to non ERC721Receiver implementer");
737     }
738 
739     /**
740      * @dev Returns whether `tokenId` exists.
741      *
742      * Tokens can be managed by their owner or approved accounts via {approve} or {setApprovalForAll}.
743      *
744      * Tokens start existing when they are minted (`_mint`),
745      * and stop existing when they are burned (`_burn`).
746      */
747     function _exists(uint256 tokenId) internal view virtual returns (bool) {
748         return _owners[tokenId] != address(0);
749     }
750 
751     /**
752      * @dev Returns whether `spender` is allowed to manage `tokenId`.
753      *
754      * Requirements:
755      *
756      * - `tokenId` must exist.
757      */
758     function _isApprovedOrOwner(address spender, uint256 tokenId) internal view virtual returns (bool) {
759         require(_exists(tokenId), "ERC721: operator query for nonexistent token");
760         address owner = ERC721.ownerOf(tokenId);
761         return (spender == owner || getApproved(tokenId) == spender || isApprovedForAll(owner, spender));
762     }
763 
764     /**
765      * @dev Safely mints `tokenId` and transfers it to `to`.
766      *
767      * Requirements:
768      *
769      * - `tokenId` must not exist.
770      * - If `to` refers to a smart contract, it must implement {IERC721Receiver-onERC721Received}, which is called upon a safe transfer.
771      *
772      * Emits a {Transfer} event.
773      */
774     function _safeMint(address to, uint256 tokenId) internal virtual {
775         _safeMint(to, tokenId, "");
776     }
777 
778     /**
779      * @dev Same as {xref-ERC721-_safeMint-address-uint256-}[`_safeMint`], with an additional `data` parameter which is
780      * forwarded in {IERC721Receiver-onERC721Received} to contract recipients.
781      */
782     function _safeMint(
783         address to,
784         uint256 tokenId,
785         bytes memory _data
786     ) internal virtual {
787         _mint(to, tokenId);
788         require(
789             _checkOnERC721Received(address(0), to, tokenId, _data),
790             "ERC721: transfer to non ERC721Receiver implementer"
791         );
792     }
793 
794     /**
795      * @dev Mints `tokenId` and transfers it to `to`.
796      *
797      * WARNING: Usage of this method is discouraged, use {_safeMint} whenever possible
798      *
799      * Requirements:
800      *
801      * - `tokenId` must not exist.
802      * - `to` cannot be the zero address.
803      *
804      * Emits a {Transfer} event.
805      */
806     function _mint(address to, uint256 tokenId) internal virtual {
807         require(to != address(0), "ERC721: mint to the zero address");
808         require(!_exists(tokenId), "ERC721: token already minted");
809 
810         _beforeTokenTransfer(address(0), to, tokenId);
811 
812         _balances[to] += 1;
813         _owners[tokenId] = to;
814 
815         emit Transfer(address(0), to, tokenId);
816     }
817 
818     /**
819      * @dev Destroys `tokenId`.
820      * The approval is cleared when the token is burned.
821      *
822      * Requirements:
823      *
824      * - `tokenId` must exist.
825      *
826      * Emits a {Transfer} event.
827      */
828     function _burn(uint256 tokenId) internal virtual {
829         address owner = ERC721.ownerOf(tokenId);
830 
831         _beforeTokenTransfer(owner, address(0), tokenId);
832 
833         // Clear approvals
834         _approve(address(0), tokenId);
835 
836         _balances[owner] -= 1;
837         delete _owners[tokenId];
838 
839         emit Transfer(owner, address(0), tokenId);
840     }
841 
842     /**
843      * @dev Transfers `tokenId` from `from` to `to`.
844      *  As opposed to {transferFrom}, this imposes no restrictions on msg.sender.
845      *
846      * Requirements:
847      *
848      * - `to` cannot be the zero address.
849      * - `tokenId` token must be owned by `from`.
850      *
851      * Emits a {Transfer} event.
852      */
853     function _transfer(
854         address from,
855         address to,
856         uint256 tokenId
857     ) internal virtual {
858         require(ERC721.ownerOf(tokenId) == from, "ERC721: transfer of token that is not own");
859         require(to != address(0), "ERC721: transfer to the zero address");
860 
861         _beforeTokenTransfer(from, to, tokenId);
862 
863         // Clear approvals from the previous owner
864         _approve(address(0), tokenId);
865 
866         _balances[from] -= 1;
867         _balances[to] += 1;
868         _owners[tokenId] = to;
869 
870         emit Transfer(from, to, tokenId);
871     }
872 
873     /**
874      * @dev Approve `to` to operate on `tokenId`
875      *
876      * Emits a {Approval} event.
877      */
878     function _approve(address to, uint256 tokenId) internal virtual {
879         _tokenApprovals[tokenId] = to;
880         emit Approval(ERC721.ownerOf(tokenId), to, tokenId);
881     }
882 
883     /**
884      * @dev Internal function to invoke {IERC721Receiver-onERC721Received} on a target address.
885      * The call is not executed if the target address is not a contract.
886      *
887      * @param from address representing the previous owner of the given token ID
888      * @param to target address that will receive the tokens
889      * @param tokenId uint256 ID of the token to be transferred
890      * @param _data bytes optional data to send along with the call
891      * @return bool whether the call correctly returned the expected magic value
892      */
893     function _checkOnERC721Received(
894         address from,
895         address to,
896         uint256 tokenId,
897         bytes memory _data
898     ) private returns (bool) {
899         if (to.isContract()) {
900             try IERC721Receiver(to).onERC721Received(_msgSender(), from, tokenId, _data) returns (bytes4 retval) {
901                 return retval == IERC721Receiver.onERC721Received.selector;
902             } catch (bytes memory reason) {
903                 if (reason.length == 0) {
904                     revert("ERC721: transfer to non ERC721Receiver implementer");
905                 } else {
906                     assembly {
907                         revert(add(32, reason), mload(reason))
908                     }
909                 }
910             }
911         } else {
912             return true;
913         }
914     }
915 
916     /**
917      * @dev Hook that is called before any token transfer. This includes minting
918      * and burning.
919      *
920      * Calling conditions:
921      *
922      * - When `from` and `to` are both non-zero, ``from``'s `tokenId` will be
923      * transferred to `to`.
924      * - When `from` is zero, `tokenId` will be minted for `to`.
925      * - When `to` is zero, ``from``'s `tokenId` will be burned.
926      * - `from` and `to` are never both zero.
927      *
928      * To learn more about hooks, head to xref:ROOT:extending-contracts.adoc#using-hooks[Using Hooks].
929      */
930     function _beforeTokenTransfer(
931         address from,
932         address to,
933         uint256 tokenId
934     ) internal virtual {}
935 }
936 
937 
938 
939 /**
940  * @title ERC-721 Non-Fungible Token Standard, optional enumeration extension
941  * @dev See https://eips.ethereum.org/EIPS/eip-721
942  */
943 interface IERC721Enumerable is IERC721 {
944     /**
945      * @dev Returns the total amount of tokens stored by the contract.
946      */
947     function totalSupply() external view returns (uint256);
948 
949     /**
950      * @dev Returns a token ID owned by `owner` at a given `index` of its token list.
951      * Use along with {balanceOf} to enumerate all of ``owner``'s tokens.
952      */
953     function tokenOfOwnerByIndex(address owner, uint256 index) external view returns (uint256 tokenId);
954 
955     /**
956      * @dev Returns a token ID at a given `index` of all the tokens stored by the contract.
957      * Use along with {totalSupply} to enumerate all tokens.
958      */
959     function tokenByIndex(uint256 index) external view returns (uint256);
960 }
961 
962 /**
963  * @dev This implements an optional extension of {ERC721} defined in the EIP that adds
964  * enumerability of all the token ids in the contract as well as all token ids owned by each
965  * account.
966  */
967 abstract contract ERC721Enumerable is ERC721, IERC721Enumerable {
968     // Mapping from owner to list of owned token IDs
969     mapping(address => mapping(uint256 => uint256)) private _ownedTokens;
970 
971     // Mapping from token ID to index of the owner tokens list
972     mapping(uint256 => uint256) private _ownedTokensIndex;
973 
974     // Array with all token ids, used for enumeration
975     uint256[] private _allTokens;
976 
977     // Mapping from token id to position in the allTokens array
978     mapping(uint256 => uint256) private _allTokensIndex;
979 
980     /**
981      * @dev See {IERC165-supportsInterface}.
982      */
983     function supportsInterface(bytes4 interfaceId) public view virtual override(IERC165, ERC721) returns (bool) {
984         return interfaceId == type(IERC721Enumerable).interfaceId || super.supportsInterface(interfaceId);
985     }
986 
987     /**
988      * @dev See {IERC721Enumerable-tokenOfOwnerByIndex}.
989      */
990     function tokenOfOwnerByIndex(address owner, uint256 index) public view virtual override returns (uint256) {
991         require(index < ERC721.balanceOf(owner), "ERC721Enumerable: owner index out of bounds");
992         return _ownedTokens[owner][index];
993     }
994 
995     /**
996      * @dev See {IERC721Enumerable-totalSupply}.
997      */
998     function totalSupply() public view virtual override returns (uint256) {
999         return _allTokens.length;
1000     }
1001 
1002     /**
1003      * @dev See {IERC721Enumerable-tokenByIndex}.
1004      */
1005     function tokenByIndex(uint256 index) public view virtual override returns (uint256) {
1006         require(index < ERC721Enumerable.totalSupply(), "ERC721Enumerable: global index out of bounds");
1007         return _allTokens[index];
1008     }
1009 
1010     /**
1011      * @dev Hook that is called before any token transfer. This includes minting
1012      * and burning.
1013      *
1014      * Calling conditions:
1015      *
1016      * - When `from` and `to` are both non-zero, ``from``'s `tokenId` will be
1017      * transferred to `to`.
1018      * - When `from` is zero, `tokenId` will be minted for `to`.
1019      * - When `to` is zero, ``from``'s `tokenId` will be burned.
1020      * - `from` cannot be the zero address.
1021      * - `to` cannot be the zero address.
1022      *
1023      * To learn more about hooks, head to xref:ROOT:extending-contracts.adoc#using-hooks[Using Hooks].
1024      */
1025     function _beforeTokenTransfer(
1026         address from,
1027         address to,
1028         uint256 tokenId
1029     ) internal virtual override {
1030         super._beforeTokenTransfer(from, to, tokenId);
1031 
1032         if (from == address(0)) {
1033             _addTokenToAllTokensEnumeration(tokenId);
1034         } else if (from != to) {
1035             _removeTokenFromOwnerEnumeration(from, tokenId);
1036         }
1037         if (to == address(0)) {
1038             _removeTokenFromAllTokensEnumeration(tokenId);
1039         } else if (to != from) {
1040             _addTokenToOwnerEnumeration(to, tokenId);
1041         }
1042     }
1043 
1044     /**
1045      * @dev Private function to add a token to this extension's ownership-tracking data structures.
1046      * @param to address representing the new owner of the given token ID
1047      * @param tokenId uint256 ID of the token to be added to the tokens list of the given address
1048      */
1049     function _addTokenToOwnerEnumeration(address to, uint256 tokenId) private {
1050         uint256 length = ERC721.balanceOf(to);
1051         _ownedTokens[to][length] = tokenId;
1052         _ownedTokensIndex[tokenId] = length;
1053     }
1054 
1055     /**
1056      * @dev Private function to add a token to this extension's token tracking data structures.
1057      * @param tokenId uint256 ID of the token to be added to the tokens list
1058      */
1059     function _addTokenToAllTokensEnumeration(uint256 tokenId) private {
1060         _allTokensIndex[tokenId] = _allTokens.length;
1061         _allTokens.push(tokenId);
1062     }
1063 
1064     /**
1065      * @dev Private function to remove a token from this extension's ownership-tracking data structures. Note that
1066      * while the token is not assigned a new owner, the `_ownedTokensIndex` mapping is _not_ updated: this allows for
1067      * gas optimizations e.g. when performing a transfer operation (avoiding double writes).
1068      * This has O(1) time complexity, but alters the order of the _ownedTokens array.
1069      * @param from address representing the previous owner of the given token ID
1070      * @param tokenId uint256 ID of the token to be removed from the tokens list of the given address
1071      */
1072     function _removeTokenFromOwnerEnumeration(address from, uint256 tokenId) private {
1073         // To prevent a gap in from's tokens array, we store the last token in the index of the token to delete, and
1074         // then delete the last slot (swap and pop).
1075 
1076         uint256 lastTokenIndex = ERC721.balanceOf(from) - 1;
1077         uint256 tokenIndex = _ownedTokensIndex[tokenId];
1078 
1079         // When the token to delete is the last token, the swap operation is unnecessary
1080         if (tokenIndex != lastTokenIndex) {
1081             uint256 lastTokenId = _ownedTokens[from][lastTokenIndex];
1082 
1083             _ownedTokens[from][tokenIndex] = lastTokenId; // Move the last token to the slot of the to-delete token
1084             _ownedTokensIndex[lastTokenId] = tokenIndex; // Update the moved token's index
1085         }
1086 
1087         // This also deletes the contents at the last position of the array
1088         delete _ownedTokensIndex[tokenId];
1089         delete _ownedTokens[from][lastTokenIndex];
1090     }
1091 
1092     /**
1093      * @dev Private function to remove a token from this extension's token tracking data structures.
1094      * This has O(1) time complexity, but alters the order of the _allTokens array.
1095      * @param tokenId uint256 ID of the token to be removed from the tokens list
1096      */
1097     function _removeTokenFromAllTokensEnumeration(uint256 tokenId) private {
1098         // To prevent a gap in the tokens array, we store the last token in the index of the token to delete, and
1099         // then delete the last slot (swap and pop).
1100 
1101         uint256 lastTokenIndex = _allTokens.length - 1;
1102         uint256 tokenIndex = _allTokensIndex[tokenId];
1103 
1104         // When the token to delete is the last token, the swap operation is unnecessary. However, since this occurs so
1105         // rarely (when the last minted token is burnt) that we still do the swap here to avoid the gas cost of adding
1106         // an 'if' statement (like in _removeTokenFromOwnerEnumeration)
1107         uint256 lastTokenId = _allTokens[lastTokenIndex];
1108 
1109         _allTokens[tokenIndex] = lastTokenId; // Move the last token to the slot of the to-delete token
1110         _allTokensIndex[lastTokenId] = tokenIndex; // Update the moved token's index
1111 
1112         // This also deletes the contents at the last position of the array
1113         delete _allTokensIndex[tokenId];
1114         _allTokens.pop();
1115     }
1116 }
1117 
1118 
1119 
1120 /**
1121  * @dev Contract module which provides a basic access control mechanism, where
1122  * there is an account (an owner) that can be granted exclusive access to
1123  * specific functions.
1124  *
1125  * By default, the owner account will be the one that deploys the contract. This
1126  * can later be changed with {transferOwnership}.
1127  *
1128  * This module is used through inheritance. It will make available the modifier
1129  * `onlyOwner`, which can be applied to your functions to restrict their use to
1130  * the owner.
1131  */
1132 abstract contract Ownable is Context {
1133     address private _owner;
1134 
1135     event OwnershipTransferred(address indexed previousOwner, address indexed newOwner);
1136 
1137     /**
1138      * @dev Initializes the contract setting the deployer as the initial owner.
1139      */
1140     constructor() {
1141         _setOwner(_msgSender());
1142     }
1143 
1144     /**
1145      * @dev Returns the address of the current owner.
1146      */
1147     function owner() public view virtual returns (address) {
1148         return _owner;
1149     }
1150 
1151     /**
1152      * @dev Throws if called by any account other than the owner.
1153      */
1154     modifier onlyOwner() {
1155         require(owner() == _msgSender(), "Ownable: caller is not the owner");
1156         _;
1157     }
1158 
1159     /**
1160      * @dev Leaves the contract without owner. It will not be possible to call
1161      * `onlyOwner` functions anymore. Can only be called by the current owner.
1162      *
1163      * NOTE: Renouncing ownership will leave the contract without an owner,
1164      * thereby removing any functionality that is only available to the owner.
1165      */
1166     function renounceOwnership() public virtual onlyOwner {
1167         _setOwner(address(0));
1168     }
1169 
1170     /**
1171      * @dev Transfers ownership of the contract to a new account (`newOwner`).
1172      * Can only be called by the current owner.
1173      */
1174     function transferOwnership(address newOwner) public virtual onlyOwner {
1175         require(newOwner != address(0), "Ownable: new owner is the zero address");
1176         _setOwner(newOwner);
1177     }
1178 
1179     function _setOwner(address newOwner) private {
1180         address oldOwner = _owner;
1181         _owner = newOwner;
1182         emit OwnershipTransferred(oldOwner, newOwner);
1183     }
1184 }
1185 
1186 
1187 
1188 /**
1189  * @dev Contract module that helps prevent reentrant calls to a function.
1190  *
1191  * Inheriting from `ReentrancyGuard` will make the {nonReentrant} modifier
1192  * available, which can be applied to functions to make sure there are no nested
1193  * (reentrant) calls to them.
1194  *
1195  * Note that because there is a single `nonReentrant` guard, functions marked as
1196  * `nonReentrant` may not call one another. This can be worked around by making
1197  * those functions `private`, and then adding `external` `nonReentrant` entry
1198  * points to them.
1199  *
1200  * TIP: If you would like to learn more about reentrancy and alternative ways
1201  * to protect against it, check out our blog post
1202  * https://blog.openzeppelin.com/reentrancy-after-istanbul/[Reentrancy After Istanbul].
1203  */
1204 abstract contract ReentrancyGuard {
1205     // Booleans are more expensive than uint256 or any type that takes up a full
1206     // word because each write operation emits an extra SLOAD to first read the
1207     // slot's contents, replace the bits taken up by the boolean, and then write
1208     // back. This is the compiler's defense against contract upgrades and
1209     // pointer aliasing, and it cannot be disabled.
1210 
1211     // The values being non-zero value makes deployment a bit more expensive,
1212     // but in exchange the refund on every call to nonReentrant will be lower in
1213     // amount. Since refunds are capped to a percentage of the total
1214     // transaction's gas, it is best to keep them low in cases like this one, to
1215     // increase the likelihood of the full refund coming into effect.
1216     uint256 private constant _NOT_ENTERED = 1;
1217     uint256 private constant _ENTERED = 2;
1218 
1219     uint256 private _status;
1220 
1221     constructor() {
1222         _status = _NOT_ENTERED;
1223     }
1224 
1225     /**
1226      * @dev Prevents a contract from calling itself, directly or indirectly.
1227      * Calling a `nonReentrant` function from another `nonReentrant`
1228      * function is not supported. It is possible to prevent this from happening
1229      * by making the `nonReentrant` function external, and make it call a
1230      * `private` function that does the actual work.
1231      */
1232     modifier nonReentrant() {
1233         // On the first call to nonReentrant, _notEntered will be true
1234         require(_status != _ENTERED, "ReentrancyGuard: reentrant call");
1235 
1236         // Any calls to nonReentrant after this point will fail
1237         _status = _ENTERED;
1238 
1239         _;
1240 
1241         // By storing the original value once again, a refund is triggered (see
1242         // https://eips.ethereum.org/EIPS/eip-2200)
1243         _status = _NOT_ENTERED;
1244     }
1245 }
1246 
1247 
1248 
1249 // CAUTION
1250 // This version of SafeMath should only be used with Solidity 0.8 or later,
1251 // because it relies on the compiler's built in overflow checks.
1252 
1253 /**
1254  * @dev Wrappers over Solidity's arithmetic operations.
1255  *
1256  * NOTE: `SafeMath` is no longer needed starting with Solidity 0.8. The compiler
1257  * now has built in overflow checking.
1258  */
1259 library SafeMath {
1260     /**
1261      * @dev Returns the addition of two unsigned integers, with an overflow flag.
1262      *
1263      * _Available since v3.4._
1264      */
1265     function tryAdd(uint256 a, uint256 b) internal pure returns (bool, uint256) {
1266         unchecked {
1267             uint256 c = a + b;
1268             if (c < a) return (false, 0);
1269             return (true, c);
1270         }
1271     }
1272 
1273     /**
1274      * @dev Returns the substraction of two unsigned integers, with an overflow flag.
1275      *
1276      * _Available since v3.4._
1277      */
1278     function trySub(uint256 a, uint256 b) internal pure returns (bool, uint256) {
1279         unchecked {
1280             if (b > a) return (false, 0);
1281             return (true, a - b);
1282         }
1283     }
1284 
1285     /**
1286      * @dev Returns the multiplication of two unsigned integers, with an overflow flag.
1287      *
1288      * _Available since v3.4._
1289      */
1290     function tryMul(uint256 a, uint256 b) internal pure returns (bool, uint256) {
1291         unchecked {
1292             // Gas optimization: this is cheaper than requiring 'a' not being zero, but the
1293             // benefit is lost if 'b' is also tested.
1294             // See: https://github.com/OpenZeppelin/openzeppelin-contracts/pull/522
1295             if (a == 0) return (true, 0);
1296             uint256 c = a * b;
1297             if (c / a != b) return (false, 0);
1298             return (true, c);
1299         }
1300     }
1301 
1302     /**
1303      * @dev Returns the division of two unsigned integers, with a division by zero flag.
1304      *
1305      * _Available since v3.4._
1306      */
1307     function tryDiv(uint256 a, uint256 b) internal pure returns (bool, uint256) {
1308         unchecked {
1309             if (b == 0) return (false, 0);
1310             return (true, a / b);
1311         }
1312     }
1313 
1314     /**
1315      * @dev Returns the remainder of dividing two unsigned integers, with a division by zero flag.
1316      *
1317      * _Available since v3.4._
1318      */
1319     function tryMod(uint256 a, uint256 b) internal pure returns (bool, uint256) {
1320         unchecked {
1321             if (b == 0) return (false, 0);
1322             return (true, a % b);
1323         }
1324     }
1325 
1326     /**
1327      * @dev Returns the addition of two unsigned integers, reverting on
1328      * overflow.
1329      *
1330      * Counterpart to Solidity's `+` operator.
1331      *
1332      * Requirements:
1333      *
1334      * - Addition cannot overflow.
1335      */
1336     function add(uint256 a, uint256 b) internal pure returns (uint256) {
1337         return a + b;
1338     }
1339 
1340     /**
1341      * @dev Returns the subtraction of two unsigned integers, reverting on
1342      * overflow (when the result is negative).
1343      *
1344      * Counterpart to Solidity's `-` operator.
1345      *
1346      * Requirements:
1347      *
1348      * - Subtraction cannot overflow.
1349      */
1350     function sub(uint256 a, uint256 b) internal pure returns (uint256) {
1351         return a - b;
1352     }
1353 
1354     /**
1355      * @dev Returns the multiplication of two unsigned integers, reverting on
1356      * overflow.
1357      *
1358      * Counterpart to Solidity's `*` operator.
1359      *
1360      * Requirements:
1361      *
1362      * - Multiplication cannot overflow.
1363      */
1364     function mul(uint256 a, uint256 b) internal pure returns (uint256) {
1365         return a * b;
1366     }
1367 
1368     /**
1369      * @dev Returns the integer division of two unsigned integers, reverting on
1370      * division by zero. The result is rounded towards zero.
1371      *
1372      * Counterpart to Solidity's `/` operator.
1373      *
1374      * Requirements:
1375      *
1376      * - The divisor cannot be zero.
1377      */
1378     function div(uint256 a, uint256 b) internal pure returns (uint256) {
1379         return a / b;
1380     }
1381 
1382     /**
1383      * @dev Returns the remainder of dividing two unsigned integers. (unsigned integer modulo),
1384      * reverting when dividing by zero.
1385      *
1386      * Counterpart to Solidity's `%` operator. This function uses a `revert`
1387      * opcode (which leaves remaining gas untouched) while Solidity uses an
1388      * invalid opcode to revert (consuming all remaining gas).
1389      *
1390      * Requirements:
1391      *
1392      * - The divisor cannot be zero.
1393      */
1394     function mod(uint256 a, uint256 b) internal pure returns (uint256) {
1395         return a % b;
1396     }
1397 
1398     /**
1399      * @dev Returns the subtraction of two unsigned integers, reverting with custom message on
1400      * overflow (when the result is negative).
1401      *
1402      * CAUTION: This function is deprecated because it requires allocating memory for the error
1403      * message unnecessarily. For custom revert reasons use {trySub}.
1404      *
1405      * Counterpart to Solidity's `-` operator.
1406      *
1407      * Requirements:
1408      *
1409      * - Subtraction cannot overflow.
1410      */
1411     function sub(
1412         uint256 a,
1413         uint256 b,
1414         string memory errorMessage
1415     ) internal pure returns (uint256) {
1416         unchecked {
1417             require(b <= a, errorMessage);
1418             return a - b;
1419         }
1420     }
1421 
1422     /**
1423      * @dev Returns the integer division of two unsigned integers, reverting with custom message on
1424      * division by zero. The result is rounded towards zero.
1425      *
1426      * Counterpart to Solidity's `/` operator. Note: this function uses a
1427      * `revert` opcode (which leaves remaining gas untouched) while Solidity
1428      * uses an invalid opcode to revert (consuming all remaining gas).
1429      *
1430      * Requirements:
1431      *
1432      * - The divisor cannot be zero.
1433      */
1434     function div(
1435         uint256 a,
1436         uint256 b,
1437         string memory errorMessage
1438     ) internal pure returns (uint256) {
1439         unchecked {
1440             require(b > 0, errorMessage);
1441             return a / b;
1442         }
1443     }
1444 
1445     /**
1446      * @dev Returns the remainder of dividing two unsigned integers. (unsigned integer modulo),
1447      * reverting with custom message when dividing by zero.
1448      *
1449      * CAUTION: This function is deprecated because it requires allocating memory for the error
1450      * message unnecessarily. For custom revert reasons use {tryMod}.
1451      *
1452      * Counterpart to Solidity's `%` operator. This function uses a `revert`
1453      * opcode (which leaves remaining gas untouched) while Solidity uses an
1454      * invalid opcode to revert (consuming all remaining gas).
1455      *
1456      * Requirements:
1457      *
1458      * - The divisor cannot be zero.
1459      */
1460     function mod(
1461         uint256 a,
1462         uint256 b,
1463         string memory errorMessage
1464     ) internal pure returns (uint256) {
1465         unchecked {
1466             require(b > 0, errorMessage);
1467             return a % b;
1468         }
1469     }
1470 }
1471 
1472 contract CryptoHobosClient {
1473     function tokensOfOwner(address _owner) external view returns(uint256[] memory) {}
1474     function totalSupply() public view virtual returns (uint256) {}
1475     function ownerOf(uint256 id) public view virtual returns (address) {}
1476 }
1477 
1478 contract CryptoHobosPetPartners is ERC721, ERC721Enumerable, Ownable, ReentrancyGuard {
1479     using SafeMath for uint256;
1480     using Strings for string;
1481 
1482     string private _baseUriString;
1483 
1484     bool public hasClaimStarted = false;
1485     bool public hasMintStarted = false;
1486 
1487     uint256 public publicMintSupplyLeft = 4000;
1488     uint256 public lastPublicMintId = 10000;
1489     uint256 public hobosMaxSupply = 8000;
1490     uint256 public publicMintIssuedNum = 0;
1491     uint256 public reservedTokensLeft = 100;
1492 
1493     uint256 public currentTokenPrice = 0.03 ether;
1494     uint256 public MAX_MINTING_TOKENS_ON_TRANSACTION = 25;
1495 
1496     address private _hoboAddr;
1497 
1498     constructor(string memory baseURI, address hoboAddr) ERC721("Crypto Hobos Pet Partners", "CryptoHobosPetPartners") {
1499         setBaseURI(baseURI);
1500         setHoboAddr(hoboAddr);
1501     }
1502 
1503     function supportsInterface(bytes4 interfaceId) public view override(ERC721, ERC721Enumerable) returns (bool) {
1504         return super.supportsInterface(interfaceId);
1505     }
1506 
1507     function _beforeTokenTransfer(address from, address to, uint256 id)
1508     internal
1509     override(ERC721, ERC721Enumerable)
1510     {
1511         super._beforeTokenTransfer(from, to, id);
1512     }
1513 
1514     function tokensOfOwner(address _owner) external view returns(uint256[] memory ) {
1515         uint256 tokenCount = balanceOf(_owner);
1516         if (tokenCount == 0) {
1517             // Return an empty array
1518             return new uint256[](0);
1519         } else {
1520             uint256[] memory result = new uint256[](tokenCount);
1521             uint256 index;
1522             for (index = 0; index < tokenCount; index++) {
1523                 result[index] = tokenOfOwnerByIndex(_owner, index);
1524             }
1525             return result;
1526         }
1527     }
1528 
1529     function _setBaseURI(string memory baseURI) internal virtual {
1530         _baseUriString = baseURI;
1531     }
1532 
1533     function _setHoboAddr(address hoboAddr) internal virtual {
1534         _hoboAddr = hoboAddr;
1535     }
1536 
1537     function _baseURI() internal view override returns (string memory) {
1538         return _baseUriString;
1539     }
1540 
1541     function tokenURI(uint256 id) public view override(ERC721) returns (string memory) {
1542         string memory _tokenURI = super.tokenURI(id);
1543         return bytes(_tokenURI).length > 0 ? string(abi.encodePacked(_tokenURI, ".json")) : "";
1544     }
1545 
1546     function _mintPets(address to, uint256 count) private {
1547         uint256 _lastPublicMintid = lastPublicMintId;
1548         for (uint256 i = 0; i < count; i++) {
1549             _lastPublicMintid++;
1550             _safeMint(to, _lastPublicMintid);
1551         }
1552         lastPublicMintId = _lastPublicMintid;
1553         publicMintSupplyLeft -= count;
1554     }
1555 
1556     function mintReservedPetTo(address to, uint256 count) public onlyOwner {
1557         if (to == address(0)) {
1558             to = msg.sender;
1559         }
1560         require(count > 0
1561             && count <= reservedTokensLeft
1562         );
1563         _mintPets(to, count);
1564         reservedTokensLeft -= count;
1565 
1566     }
1567 
1568     function mintPet(uint256 count) external payable nonReentrant {
1569         require(hasMintStarted == true
1570         && count > 0
1571         && count <= MAX_MINTING_TOKENS_ON_TRANSACTION
1572         && publicMintSupplyLeft.sub(reservedTokensLeft) >= count
1573         && msg.value >= currentTokenPrice.mul(count),
1574             "Mint is impossible now");
1575         _mintPets(msg.sender, count);
1576     }
1577 
1578     function pauseClaim() public onlyOwner {
1579         require(hasClaimStarted == true);
1580         hasClaimStarted = false;
1581     }
1582 
1583     function playClaim() public onlyOwner {
1584         require(hasClaimStarted == false);
1585         hasClaimStarted = true;
1586     }
1587 
1588     function pauseMint() public onlyOwner {
1589         require(hasMintStarted == true);
1590         hasMintStarted = false;
1591     }
1592 
1593     function playMint() public onlyOwner {
1594         require(hasMintStarted == false);
1595         hasMintStarted = true;
1596     }
1597 
1598     function withdrawTo(address to, uint256 amount) public payable onlyOwner {
1599         if (to == address(0)) {
1600             to = msg.sender;
1601         }
1602         if (amount == 0) {
1603             amount = address(this).balance;
1604         }
1605         require(payable(to).send(amount));
1606     }
1607 
1608     function withdraw(uint256 amount) public payable onlyOwner {
1609         if (amount == 0) {
1610             amount = address(this).balance;
1611         }
1612         require(payable(owner()).send(amount));
1613     }
1614 
1615     function setPrice(uint256 price) public onlyOwner {
1616         currentTokenPrice = price;
1617     }
1618 
1619     function setMaxMintingTokensOnTransaction(uint256 count) public onlyOwner {
1620         MAX_MINTING_TOKENS_ON_TRANSACTION = count;
1621     }
1622 
1623     function reduceSupply(uint256 supply) public onlyOwner {
1624         require(supply < publicMintSupplyLeft && supply > reservedTokensLeft);
1625         publicMintSupplyLeft = supply;
1626     }
1627 
1628     function setBaseURI(string memory baseURI) public onlyOwner {
1629         _setBaseURI(baseURI);
1630     }
1631 
1632     function setHoboAddr(address hoboAddr) public onlyOwner {
1633         _setHoboAddr(hoboAddr);
1634     }
1635 
1636     /////////////////////// CLAIM FOR HOLDERS
1637 
1638     function hoboIdCheck(uint256 id) internal view returns (bool) {
1639         return (id > 0 && id <= hobosMaxSupply);
1640     }
1641 
1642     function getOwnerHoboIds(address _owner) public view returns(uint256[] memory ){
1643         CryptoHobosClient hobos = CryptoHobosClient(_hoboAddr);
1644         return hobos.tokensOfOwner(_owner);
1645 
1646     }
1647 
1648     function hoboOwnershipCheck(uint256 id) public view returns (bool) {
1649         CryptoHobosClient hobos = CryptoHobosClient(_hoboAddr);
1650         address tokenOwner = hobos.ownerOf(id);
1651         return tokenOwner == msg.sender;
1652     }
1653 
1654     function petMintedCheck(uint256 id) public view returns (bool){
1655         require(hoboIdCheck(id), "Not valid ID");
1656         return !_exists(id);
1657     }
1658 
1659     // CHECK AND MINT ONE
1660 
1661     function checkClaimPossibility(uint256 id) public view returns (bool) {
1662         return (hoboIdCheck(id) && petMintedCheck(id) && hoboOwnershipCheck(id));
1663     }
1664 
1665     function claimPet(uint256 id) external {
1666         require(hoboIdCheck(id), "Not valid ID");
1667         require(hasClaimStarted, "Not started");
1668         require(hoboOwnershipCheck(id), "You're not owner");
1669         _safeMint(msg.sender, id);
1670     }
1671 
1672     // CHECK AND MINT MANY
1673 
1674     function getPossibleIds(address _owner) public view returns (uint256[] memory){
1675         CryptoHobosClient hobos = CryptoHobosClient(_hoboAddr);
1676 
1677         uint256[] memory hoboIds = hobos.tokensOfOwner(_owner);
1678         require(hoboIds.length > 0, "Have no hobo");
1679 
1680         uint256[] memory innerHoboIds = new uint256[](MAX_MINTING_TOKENS_ON_TRANSACTION);
1681         uint256 cur;
1682         for (uint256 i=0; i<hoboIds.length; i++) {
1683             if (!_exists(hoboIds[i])) {
1684                 innerHoboIds[cur] = hoboIds[i];
1685                 cur++;
1686                 if (cur>= MAX_MINTING_TOKENS_ON_TRANSACTION) {
1687                     break;
1688                 }
1689             }
1690         }
1691 
1692         uint256[] memory possibleIds = new uint256[](cur);
1693         for (uint256 i=0; i<cur; i++) {
1694             possibleIds[i] = innerHoboIds[i];
1695         }
1696 
1697         return possibleIds;
1698     }
1699 
1700     function claimPets(uint256 _amount) external {
1701         require(hasClaimStarted, "Not started");
1702         uint256[] memory possibleIds = getPossibleIds(msg.sender);
1703         require(possibleIds.length > 0, "Have no hobo");
1704         require(_amount<=MAX_MINTING_TOKENS_ON_TRANSACTION, "Sorry, exceed limit");
1705         require(_amount<= possibleIds.length, "Sorry, exceed limit");
1706         require(_amount>0, "Must be 1 minimum");
1707         for (uint256 i=0; i<_amount; i++) {
1708             _safeMint(msg.sender, possibleIds[i]);
1709         }
1710 
1711     }
1712 
1713 }