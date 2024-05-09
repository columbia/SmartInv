1 // SPDX-License-Identifier: MIT
2 
3 pragma solidity ^0.8.0;
4 
5 
6 // 
7 /**
8  * @dev Interface of the ERC165 standard, as defined in the
9  * https://eips.ethereum.org/EIPS/eip-165[EIP].
10  *
11  * Implementers can declare support of contract interfaces, which can then be
12  * queried by others ({ERC165Checker}).
13  *
14  * For an implementation, see {ERC165}.
15  */
16 interface IERC165 {
17     /**
18      * @dev Returns true if this contract implements the interface defined by
19      * `interfaceId`. See the corresponding
20      * https://eips.ethereum.org/EIPS/eip-165#how-interfaces-are-identified[EIP section]
21      * to learn more about how these ids are created.
22      *
23      * This function call must use less than 30 000 gas.
24      */
25     function supportsInterface(bytes4 interfaceId) external view returns (bool);
26 }
27 
28 // 
29 /**
30  * @dev Required interface of an ERC721 compliant contract.
31  */
32 interface IERC721 is IERC165 {
33     /**
34      * @dev Emitted when `tokenId` token is transferred from `from` to `to`.
35      */
36     event Transfer(address indexed from, address indexed to, uint256 indexed tokenId);
37 
38     /**
39      * @dev Emitted when `owner` enables `approved` to manage the `tokenId` token.
40      */
41     event Approval(address indexed owner, address indexed approved, uint256 indexed tokenId);
42 
43     /**
44      * @dev Emitted when `owner` enables or disables (`approved`) `operator` to manage all of its assets.
45      */
46     event ApprovalForAll(address indexed owner, address indexed operator, bool approved);
47 
48     /**
49      * @dev Returns the number of tokens in ``owner``'s account.
50      */
51     function balanceOf(address owner) external view returns (uint256 balance);
52 
53     /**
54      * @dev Returns the owner of the `tokenId` token.
55      *
56      * Requirements:
57      *
58      * - `tokenId` must exist.
59      */
60     function ownerOf(uint256 tokenId) external view returns (address owner);
61 
62     /**
63      * @dev Safely transfers `tokenId` token from `from` to `to`, checking first that contract recipients
64      * are aware of the ERC721 protocol to prevent tokens from being forever locked.
65      *
66      * Requirements:
67      *
68      * - `from` cannot be the zero address.
69      * - `to` cannot be the zero address.
70      * - `tokenId` token must exist and be owned by `from`.
71      * - If the caller is not `from`, it must be have been allowed to move this token by either {approve} or {setApprovalForAll}.
72      * - If `to` refers to a smart contract, it must implement {IERC721Receiver-onERC721Received}, which is called upon a safe transfer.
73      *
74      * Emits a {Transfer} event.
75      */
76     function safeTransferFrom(
77         address from,
78         address to,
79         uint256 tokenId
80     ) external;
81 
82     /**
83      * @dev Transfers `tokenId` token from `from` to `to`.
84      *
85      * WARNING: Usage of this method is discouraged, use {safeTransferFrom} whenever possible.
86      *
87      * Requirements:
88      *
89      * - `from` cannot be the zero address.
90      * - `to` cannot be the zero address.
91      * - `tokenId` token must be owned by `from`.
92      * - If the caller is not `from`, it must be approved to move this token by either {approve} or {setApprovalForAll}.
93      *
94      * Emits a {Transfer} event.
95      */
96     function transferFrom(
97         address from,
98         address to,
99         uint256 tokenId
100     ) external;
101 
102     /**
103      * @dev Gives permission to `to` to transfer `tokenId` token to another account.
104      * The approval is cleared when the token is transferred.
105      *
106      * Only a single account can be approved at a time, so approving the zero address clears previous approvals.
107      *
108      * Requirements:
109      *
110      * - The caller must own the token or be an approved operator.
111      * - `tokenId` must exist.
112      *
113      * Emits an {Approval} event.
114      */
115     function approve(address to, uint256 tokenId) external;
116 
117     /**
118      * @dev Returns the account approved for `tokenId` token.
119      *
120      * Requirements:
121      *
122      * - `tokenId` must exist.
123      */
124     function getApproved(uint256 tokenId) external view returns (address operator);
125 
126     /**
127      * @dev Approve or remove `operator` as an operator for the caller.
128      * Operators can call {transferFrom} or {safeTransferFrom} for any token owned by the caller.
129      *
130      * Requirements:
131      *
132      * - The `operator` cannot be the caller.
133      *
134      * Emits an {ApprovalForAll} event.
135      */
136     function setApprovalForAll(address operator, bool _approved) external;
137 
138     /**
139      * @dev Returns if the `operator` is allowed to manage all of the assets of `owner`.
140      *
141      * See {setApprovalForAll}
142      */
143     function isApprovedForAll(address owner, address operator) external view returns (bool);
144 
145     /**
146      * @dev Safely transfers `tokenId` token from `from` to `to`.
147      *
148      * Requirements:
149      *
150      * - `from` cannot be the zero address.
151      * - `to` cannot be the zero address.
152      * - `tokenId` token must exist and be owned by `from`.
153      * - If the caller is not `from`, it must be approved to move this token by either {approve} or {setApprovalForAll}.
154      * - If `to` refers to a smart contract, it must implement {IERC721Receiver-onERC721Received}, which is called upon a safe transfer.
155      *
156      * Emits a {Transfer} event.
157      */
158     function safeTransferFrom(
159         address from,
160         address to,
161         uint256 tokenId,
162         bytes calldata data
163     ) external;
164 }
165 
166 // 
167 /**
168  * @title ERC721 token receiver interface
169  * @dev Interface for any contract that wants to support safeTransfers
170  * from ERC721 asset contracts.
171  */
172 interface IERC721Receiver {
173     /**
174      * @dev Whenever an {IERC721} `tokenId` token is transferred to this contract via {IERC721-safeTransferFrom}
175      * by `operator` from `from`, this function is called.
176      *
177      * It must return its Solidity selector to confirm the token transfer.
178      * If any other value is returned or the interface is not implemented by the recipient, the transfer will be reverted.
179      *
180      * The selector can be obtained in Solidity with `IERC721.onERC721Received.selector`.
181      */
182     function onERC721Received(
183         address operator,
184         address from,
185         uint256 tokenId,
186         bytes calldata data
187     ) external returns (bytes4);
188 }
189 
190 // 
191 /**
192  * @title ERC-721 Non-Fungible Token Standard, optional metadata extension
193  * @dev See https://eips.ethereum.org/EIPS/eip-721
194  */
195 interface IERC721Metadata is IERC721 {
196     /**
197      * @dev Returns the token collection name.
198      */
199     function name() external view returns (string memory);
200 
201     /**
202      * @dev Returns the token collection symbol.
203      */
204     function symbol() external view returns (string memory);
205 
206     /**
207      * @dev Returns the Uniform Resource Identifier (URI) for `tokenId` token.
208      */
209     function tokenURI(uint256 tokenId) external view returns (string memory);
210 }
211 
212 // 
213 /**
214  * @dev Collection of functions related to the address type
215  */
216 library Address {
217     /**
218      * @dev Returns true if `account` is a contract.
219      *
220      * [IMPORTANT]
221      * ====
222      * It is unsafe to assume that an address for which this function returns
223      * false is an externally-owned account (EOA) and not a contract.
224      *
225      * Among others, `isContract` will return false for the following
226      * types of addresses:
227      *
228      *  - an externally-owned account
229      *  - a contract in construction
230      *  - an address where a contract will be created
231      *  - an address where a contract lived, but was destroyed
232      * ====
233      */
234     function isContract(address account) internal view returns (bool) {
235         // This method relies on extcodesize, which returns 0 for contracts in
236         // construction, since the code is only stored at the end of the
237         // constructor execution.
238 
239         uint256 size;
240         assembly {
241             size := extcodesize(account)
242         }
243         return size > 0;
244     }
245 
246     /**
247      * @dev Replacement for Solidity's `transfer`: sends `amount` wei to
248      * `recipient`, forwarding all available gas and reverting on errors.
249      *
250      * https://eips.ethereum.org/EIPS/eip-1884[EIP1884] increases the gas cost
251      * of certain opcodes, possibly making contracts go over the 2300 gas limit
252      * imposed by `transfer`, making them unable to receive funds via
253      * `transfer`. {sendValue} removes this limitation.
254      *
255      * https://diligence.consensys.net/posts/2019/09/stop-using-soliditys-transfer-now/[Learn more].
256      *
257      * IMPORTANT: because control is transferred to `recipient`, care must be
258      * taken to not create reentrancy vulnerabilities. Consider using
259      * {ReentrancyGuard} or the
260      * https://solidity.readthedocs.io/en/v0.5.11/security-considerations.html#use-the-checks-effects-interactions-pattern[checks-effects-interactions pattern].
261      */
262     function sendValue(address payable recipient, uint256 amount) internal {
263         require(address(this).balance >= amount, "Address: insufficient balance");
264 
265         (bool success, ) = recipient.call{value: amount}("");
266         require(success, "Address: unable to send value, recipient may have reverted");
267     }
268 
269     /**
270      * @dev Performs a Solidity function call using a low level `call`. A
271      * plain `call` is an unsafe replacement for a function call: use this
272      * function instead.
273      *
274      * If `target` reverts with a revert reason, it is bubbled up by this
275      * function (like regular Solidity function calls).
276      *
277      * Returns the raw returned data. To convert to the expected return value,
278      * use https://solidity.readthedocs.io/en/latest/units-and-global-variables.html?highlight=abi.decode#abi-encoding-and-decoding-functions[`abi.decode`].
279      *
280      * Requirements:
281      *
282      * - `target` must be a contract.
283      * - calling `target` with `data` must not revert.
284      *
285      * _Available since v3.1._
286      */
287     function functionCall(address target, bytes memory data) internal returns (bytes memory) {
288         return functionCall(target, data, "Address: low-level call failed");
289     }
290 
291     /**
292      * @dev Same as {xref-Address-functionCall-address-bytes-}[`functionCall`], but with
293      * `errorMessage` as a fallback revert reason when `target` reverts.
294      *
295      * _Available since v3.1._
296      */
297     function functionCall(
298         address target,
299         bytes memory data,
300         string memory errorMessage
301     ) internal returns (bytes memory) {
302         return functionCallWithValue(target, data, 0, errorMessage);
303     }
304 
305     /**
306      * @dev Same as {xref-Address-functionCall-address-bytes-}[`functionCall`],
307      * but also transferring `value` wei to `target`.
308      *
309      * Requirements:
310      *
311      * - the calling contract must have an ETH balance of at least `value`.
312      * - the called Solidity function must be `payable`.
313      *
314      * _Available since v3.1._
315      */
316     function functionCallWithValue(
317         address target,
318         bytes memory data,
319         uint256 value
320     ) internal returns (bytes memory) {
321         return functionCallWithValue(target, data, value, "Address: low-level call with value failed");
322     }
323 
324     /**
325      * @dev Same as {xref-Address-functionCallWithValue-address-bytes-uint256-}[`functionCallWithValue`], but
326      * with `errorMessage` as a fallback revert reason when `target` reverts.
327      *
328      * _Available since v3.1._
329      */
330     function functionCallWithValue(
331         address target,
332         bytes memory data,
333         uint256 value,
334         string memory errorMessage
335     ) internal returns (bytes memory) {
336         require(address(this).balance >= value, "Address: insufficient balance for call");
337         require(isContract(target), "Address: call to non-contract");
338 
339         (bool success, bytes memory returndata) = target.call{value: value}(data);
340         return verifyCallResult(success, returndata, errorMessage);
341     }
342 
343     /**
344      * @dev Same as {xref-Address-functionCall-address-bytes-}[`functionCall`],
345      * but performing a static call.
346      *
347      * _Available since v3.3._
348      */
349     function functionStaticCall(address target, bytes memory data) internal view returns (bytes memory) {
350         return functionStaticCall(target, data, "Address: low-level static call failed");
351     }
352 
353     /**
354      * @dev Same as {xref-Address-functionCall-address-bytes-string-}[`functionCall`],
355      * but performing a static call.
356      *
357      * _Available since v3.3._
358      */
359     function functionStaticCall(
360         address target,
361         bytes memory data,
362         string memory errorMessage
363     ) internal view returns (bytes memory) {
364         require(isContract(target), "Address: static call to non-contract");
365 
366         (bool success, bytes memory returndata) = target.staticcall(data);
367         return verifyCallResult(success, returndata, errorMessage);
368     }
369 
370     /**
371      * @dev Same as {xref-Address-functionCall-address-bytes-}[`functionCall`],
372      * but performing a delegate call.
373      *
374      * _Available since v3.4._
375      */
376     function functionDelegateCall(address target, bytes memory data) internal returns (bytes memory) {
377         return functionDelegateCall(target, data, "Address: low-level delegate call failed");
378     }
379 
380     /**
381      * @dev Same as {xref-Address-functionCall-address-bytes-string-}[`functionCall`],
382      * but performing a delegate call.
383      *
384      * _Available since v3.4._
385      */
386     function functionDelegateCall(
387         address target,
388         bytes memory data,
389         string memory errorMessage
390     ) internal returns (bytes memory) {
391         require(isContract(target), "Address: delegate call to non-contract");
392 
393         (bool success, bytes memory returndata) = target.delegatecall(data);
394         return verifyCallResult(success, returndata, errorMessage);
395     }
396 
397     /**
398      * @dev Tool to verifies that a low level call was successful, and revert if it wasn't, either by bubbling the
399      * revert reason using the provided one.
400      *
401      * _Available since v4.3._
402      */
403     function verifyCallResult(
404         bool success,
405         bytes memory returndata,
406         string memory errorMessage
407     ) internal pure returns (bytes memory) {
408         if (success) {
409             return returndata;
410         } else {
411             // Look for revert reason and bubble it up if present
412             if (returndata.length > 0) {
413                 // The easiest way to bubble the revert reason is using memory via assembly
414 
415                 assembly {
416                     let returndata_size := mload(returndata)
417                     revert(add(32, returndata), returndata_size)
418                 }
419             } else {
420                 revert(errorMessage);
421             }
422         }
423     }
424 }
425 
426 // 
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
447 // 
448 /**
449  * @dev String operations.
450  */
451 library Strings {
452     bytes16 private constant _HEX_SYMBOLS = "0123456789abcdef";
453 
454     /**
455      * @dev Converts a `uint256` to its ASCII `string` decimal representation.
456      */
457     function toString(uint256 value) internal pure returns (string memory) {
458         // Inspired by OraclizeAPI's implementation - MIT licence
459         // https://github.com/oraclize/ethereum-api/blob/b42146b063c7d6ee1358846c198246239e9360e8/oraclizeAPI_0.4.25.sol
460 
461         if (value == 0) {
462             return "0";
463         }
464         uint256 temp = value;
465         uint256 digits;
466         while (temp != 0) {
467             digits++;
468             temp /= 10;
469         }
470         bytes memory buffer = new bytes(digits);
471         while (value != 0) {
472             digits -= 1;
473             buffer[digits] = bytes1(uint8(48 + uint256(value % 10)));
474             value /= 10;
475         }
476         return string(buffer);
477     }
478 
479     /**
480      * @dev Converts a `uint256` to its ASCII `string` hexadecimal representation.
481      */
482     function toHexString(uint256 value) internal pure returns (string memory) {
483         if (value == 0) {
484             return "0x00";
485         }
486         uint256 temp = value;
487         uint256 length = 0;
488         while (temp != 0) {
489             length++;
490             temp >>= 8;
491         }
492         return toHexString(value, length);
493     }
494 
495     /**
496      * @dev Converts a `uint256` to its ASCII `string` hexadecimal representation with fixed length.
497      */
498     function toHexString(uint256 value, uint256 length) internal pure returns (string memory) {
499         bytes memory buffer = new bytes(2 * length + 2);
500         buffer[0] = "0";
501         buffer[1] = "x";
502         for (uint256 i = 2 * length + 1; i > 1; --i) {
503             buffer[i] = _HEX_SYMBOLS[value & 0xf];
504             value >>= 4;
505         }
506         require(value == 0, "Strings: hex length insufficient");
507         return string(buffer);
508     }
509 }
510 
511 // 
512 /**
513  * @dev Implementation of the {IERC165} interface.
514  *
515  * Contracts that want to implement ERC165 should inherit from this contract and override {supportsInterface} to check
516  * for the additional interface id that will be supported. For example:
517  *
518  * ```solidity
519  * function supportsInterface(bytes4 interfaceId) public view virtual override returns (bool) {
520  *     return interfaceId == type(MyInterface).interfaceId || super.supportsInterface(interfaceId);
521  * }
522  * ```
523  *
524  * Alternatively, {ERC165Storage} provides an easier to use but more expensive implementation.
525  */
526 abstract contract ERC165 is IERC165 {
527     /**
528      * @dev See {IERC165-supportsInterface}.
529      */
530     function supportsInterface(bytes4 interfaceId) public view virtual override returns (bool) {
531         return interfaceId == type(IERC165).interfaceId;
532     }
533 }
534 
535 // 
536 /**
537  * @dev Implementation of https://eips.ethereum.org/EIPS/eip-721[ERC721] Non-Fungible Token Standard, including
538  * the Metadata extension, but not including the Enumerable extension, which is available separately as
539  * {ERC721Enumerable}.
540  */
541 contract ERC721 is Context, ERC165, IERC721, IERC721Metadata {
542     using Address for address;
543     using Strings for uint256;
544 
545     // Token name
546     string private _name;
547 
548     // Token symbol
549     string private _symbol;
550 
551     // Mapping from token ID to owner address
552     mapping(uint256 => address) private _owners;
553 
554     // Mapping owner address to token count
555     mapping(address => uint256) private _balances;
556 
557     // Mapping from token ID to approved address
558     mapping(uint256 => address) private _tokenApprovals;
559 
560     // Mapping from owner to operator approvals
561     mapping(address => mapping(address => bool)) private _operatorApprovals;
562 
563     /**
564      * @dev Initializes the contract by setting a `name` and a `symbol` to the token collection.
565      */
566     constructor(string memory name_, string memory symbol_) {
567         _name = name_;
568         _symbol = symbol_;
569     }
570 
571     /**
572      * @dev See {IERC165-supportsInterface}.
573      */
574     function supportsInterface(bytes4 interfaceId) public view virtual override(ERC165, IERC165) returns (bool) {
575         return
576             interfaceId == type(IERC721).interfaceId ||
577             interfaceId == type(IERC721Metadata).interfaceId ||
578             super.supportsInterface(interfaceId);
579     }
580 
581     /**
582      * @dev See {IERC721-balanceOf}.
583      */
584     function balanceOf(address owner) public view virtual override returns (uint256) {
585         require(owner != address(0), "ERC721: balance query for the zero address");
586         return _balances[owner];
587     }
588 
589     /**
590      * @dev See {IERC721-ownerOf}.
591      */
592     function ownerOf(uint256 tokenId) public view virtual override returns (address) {
593         address owner = _owners[tokenId];
594         require(owner != address(0), "ERC721: owner query for nonexistent token");
595         return owner;
596     }
597 
598     /**
599      * @dev See {IERC721Metadata-name}.
600      */
601     function name() public view virtual override returns (string memory) {
602         return _name;
603     }
604 
605     /**
606      * @dev See {IERC721Metadata-symbol}.
607      */
608     function symbol() public view virtual override returns (string memory) {
609         return _symbol;
610     }
611 
612     /**
613      * @dev See {IERC721Metadata-tokenURI}.
614      */
615     function tokenURI(uint256 tokenId) public view virtual override returns (string memory) {
616         require(_exists(tokenId), "ERC721Metadata: URI query for nonexistent token");
617 
618         string memory baseURI = _baseURI();
619         return bytes(baseURI).length > 0 ? string(abi.encodePacked(baseURI, tokenId.toString())) : "";
620     }
621 
622     /**
623      * @dev Base URI for computing {tokenURI}. If set, the resulting URI for each
624      * token will be the concatenation of the `baseURI` and the `tokenId`. Empty
625      * by default, can be overriden in child contracts.
626      */
627     function _baseURI() internal view virtual returns (string memory) {
628         return "";
629     }
630 
631     /**
632      * @dev See {IERC721-approve}.
633      */
634     function approve(address to, uint256 tokenId) public virtual override {
635         address owner = ERC721.ownerOf(tokenId);
636         require(to != owner, "ERC721: approval to current owner");
637 
638         require(
639             _msgSender() == owner || isApprovedForAll(owner, _msgSender()),
640             "ERC721: approve caller is not owner nor approved for all"
641         );
642 
643         _approve(to, tokenId);
644     }
645 
646     /**
647      * @dev See {IERC721-getApproved}.
648      */
649     function getApproved(uint256 tokenId) public view virtual override returns (address) {
650         require(_exists(tokenId), "ERC721: approved query for nonexistent token");
651 
652         return _tokenApprovals[tokenId];
653     }
654 
655     /**
656      * @dev See {IERC721-setApprovalForAll}.
657      */
658     function setApprovalForAll(address operator, bool approved) public virtual override {
659         require(operator != _msgSender(), "ERC721: approve to caller");
660 
661         _operatorApprovals[_msgSender()][operator] = approved;
662         emit ApprovalForAll(_msgSender(), operator, approved);
663     }
664 
665     /**
666      * @dev See {IERC721-isApprovedForAll}.
667      */
668     function isApprovedForAll(address owner, address operator) public view virtual override returns (bool) {
669         return _operatorApprovals[owner][operator];
670     }
671 
672     /**
673      * @dev See {IERC721-transferFrom}.
674      */
675     function transferFrom(
676         address from,
677         address to,
678         uint256 tokenId
679     ) public virtual override {
680         //solhint-disable-next-line max-line-length
681         require(_isApprovedOrOwner(_msgSender(), tokenId), "ERC721: transfer caller is not owner nor approved");
682 
683         _transfer(from, to, tokenId);
684     }
685 
686     /**
687      * @dev See {IERC721-safeTransferFrom}.
688      */
689     function safeTransferFrom(
690         address from,
691         address to,
692         uint256 tokenId
693     ) public virtual override {
694         safeTransferFrom(from, to, tokenId, "");
695     }
696 
697     /**
698      * @dev See {IERC721-safeTransferFrom}.
699      */
700     function safeTransferFrom(
701         address from,
702         address to,
703         uint256 tokenId,
704         bytes memory _data
705     ) public virtual override {
706         require(_isApprovedOrOwner(_msgSender(), tokenId), "ERC721: transfer caller is not owner nor approved");
707         _safeTransfer(from, to, tokenId, _data);
708     }
709 
710     /**
711      * @dev Safely transfers `tokenId` token from `from` to `to`, checking first that contract recipients
712      * are aware of the ERC721 protocol to prevent tokens from being forever locked.
713      *
714      * `_data` is additional data, it has no specified format and it is sent in call to `to`.
715      *
716      * This internal function is equivalent to {safeTransferFrom}, and can be used to e.g.
717      * implement alternative mechanisms to perform token transfer, such as signature-based.
718      *
719      * Requirements:
720      *
721      * - `from` cannot be the zero address.
722      * - `to` cannot be the zero address.
723      * - `tokenId` token must exist and be owned by `from`.
724      * - If `to` refers to a smart contract, it must implement {IERC721Receiver-onERC721Received}, which is called upon a safe transfer.
725      *
726      * Emits a {Transfer} event.
727      */
728     function _safeTransfer(
729         address from,
730         address to,
731         uint256 tokenId,
732         bytes memory _data
733     ) internal virtual {
734         _transfer(from, to, tokenId);
735         require(_checkOnERC721Received(from, to, tokenId, _data), "ERC721: transfer to non ERC721Receiver implementer");
736     }
737 
738     /**
739      * @dev Returns whether `tokenId` exists.
740      *
741      * Tokens can be managed by their owner or approved accounts via {approve} or {setApprovalForAll}.
742      *
743      * Tokens start existing when they are minted (`_mint`),
744      * and stop existing when they are burned (`_burn`).
745      */
746     function _exists(uint256 tokenId) internal view virtual returns (bool) {
747         return _owners[tokenId] != address(0);
748     }
749 
750     /**
751      * @dev Returns whether `spender` is allowed to manage `tokenId`.
752      *
753      * Requirements:
754      *
755      * - `tokenId` must exist.
756      */
757     function _isApprovedOrOwner(address spender, uint256 tokenId) internal view virtual returns (bool) {
758         require(_exists(tokenId), "ERC721: operator query for nonexistent token");
759         address owner = ERC721.ownerOf(tokenId);
760         return (spender == owner || getApproved(tokenId) == spender || isApprovedForAll(owner, spender));
761     }
762 
763     /**
764      * @dev Safely mints `tokenId` and transfers it to `to`.
765      *
766      * Requirements:
767      *
768      * - `tokenId` must not exist.
769      * - If `to` refers to a smart contract, it must implement {IERC721Receiver-onERC721Received}, which is called upon a safe transfer.
770      *
771      * Emits a {Transfer} event.
772      */
773     function _safeMint(address to, uint256 tokenId) internal virtual {
774         _safeMint(to, tokenId, "");
775     }
776 
777     /**
778      * @dev Same as {xref-ERC721-_safeMint-address-uint256-}[`_safeMint`], with an additional `data` parameter which is
779      * forwarded in {IERC721Receiver-onERC721Received} to contract recipients.
780      */
781     function _safeMint(
782         address to,
783         uint256 tokenId,
784         bytes memory _data
785     ) internal virtual {
786         _mint(to, tokenId);
787         require(
788             _checkOnERC721Received(address(0), to, tokenId, _data),
789             "ERC721: transfer to non ERC721Receiver implementer"
790         );
791     }
792 
793     /**
794      * @dev Mints `tokenId` and transfers it to `to`.
795      *
796      * WARNING: Usage of this method is discouraged, use {_safeMint} whenever possible
797      *
798      * Requirements:
799      *
800      * - `tokenId` must not exist.
801      * - `to` cannot be the zero address.
802      *
803      * Emits a {Transfer} event.
804      */
805     function _mint(address to, uint256 tokenId) internal virtual {
806         require(to != address(0), "ERC721: mint to the zero address");
807         require(!_exists(tokenId), "ERC721: token already minted");
808 
809         _beforeTokenTransfer(address(0), to, tokenId);
810 
811         _balances[to] += 1;
812         _owners[tokenId] = to;
813 
814         emit Transfer(address(0), to, tokenId);
815     }
816 
817     /**
818      * @dev Destroys `tokenId`.
819      * The approval is cleared when the token is burned.
820      *
821      * Requirements:
822      *
823      * - `tokenId` must exist.
824      *
825      * Emits a {Transfer} event.
826      */
827     function _burn(uint256 tokenId) internal virtual {
828         address owner = ERC721.ownerOf(tokenId);
829 
830         _beforeTokenTransfer(owner, address(0), tokenId);
831 
832         // Clear approvals
833         _approve(address(0), tokenId);
834 
835         _balances[owner] -= 1;
836         delete _owners[tokenId];
837 
838         emit Transfer(owner, address(0), tokenId);
839     }
840 
841     /**
842      * @dev Transfers `tokenId` from `from` to `to`.
843      *  As opposed to {transferFrom}, this imposes no restrictions on msg.sender.
844      *
845      * Requirements:
846      *
847      * - `to` cannot be the zero address.
848      * - `tokenId` token must be owned by `from`.
849      *
850      * Emits a {Transfer} event.
851      */
852     function _transfer(
853         address from,
854         address to,
855         uint256 tokenId
856     ) internal virtual {
857         require(ERC721.ownerOf(tokenId) == from, "ERC721: transfer of token that is not own");
858         require(to != address(0), "ERC721: transfer to the zero address");
859 
860         _beforeTokenTransfer(from, to, tokenId);
861 
862         // Clear approvals from the previous owner
863         _approve(address(0), tokenId);
864 
865         _balances[from] -= 1;
866         _balances[to] += 1;
867         _owners[tokenId] = to;
868 
869         emit Transfer(from, to, tokenId);
870     }
871 
872     /**
873      * @dev Approve `to` to operate on `tokenId`
874      *
875      * Emits a {Approval} event.
876      */
877     function _approve(address to, uint256 tokenId) internal virtual {
878         _tokenApprovals[tokenId] = to;
879         emit Approval(ERC721.ownerOf(tokenId), to, tokenId);
880     }
881 
882     /**
883      * @dev Internal function to invoke {IERC721Receiver-onERC721Received} on a target address.
884      * The call is not executed if the target address is not a contract.
885      *
886      * @param from address representing the previous owner of the given token ID
887      * @param to target address that will receive the tokens
888      * @param tokenId uint256 ID of the token to be transferred
889      * @param _data bytes optional data to send along with the call
890      * @return bool whether the call correctly returned the expected magic value
891      */
892     function _checkOnERC721Received(
893         address from,
894         address to,
895         uint256 tokenId,
896         bytes memory _data
897     ) private returns (bool) {
898         if (to.isContract()) {
899             try IERC721Receiver(to).onERC721Received(_msgSender(), from, tokenId, _data) returns (bytes4 retval) {
900                 return retval == IERC721Receiver.onERC721Received.selector;
901             } catch (bytes memory reason) {
902                 if (reason.length == 0) {
903                     revert("ERC721: transfer to non ERC721Receiver implementer");
904                 } else {
905                     assembly {
906                         revert(add(32, reason), mload(reason))
907                     }
908                 }
909             }
910         } else {
911             return true;
912         }
913     }
914 
915     /**
916      * @dev Hook that is called before any token transfer. This includes minting
917      * and burning.
918      *
919      * Calling conditions:
920      *
921      * - When `from` and `to` are both non-zero, ``from``'s `tokenId` will be
922      * transferred to `to`.
923      * - When `from` is zero, `tokenId` will be minted for `to`.
924      * - When `to` is zero, ``from``'s `tokenId` will be burned.
925      * - `from` and `to` are never both zero.
926      *
927      * To learn more about hooks, head to xref:ROOT:extending-contracts.adoc#using-hooks[Using Hooks].
928      */
929     function _beforeTokenTransfer(
930         address from,
931         address to,
932         uint256 tokenId
933     ) internal virtual {}
934 }
935 
936 // 
937 /**
938  * @dev Contract module which provides a basic access control mechanism, where
939  * there is an account (an owner) that can be granted exclusive access to
940  * specific functions.
941  *
942  * By default, the owner account will be the one that deploys the contract. This
943  * can later be changed with {transferOwnership}.
944  *
945  * This module is used through inheritance. It will make available the modifier
946  * `onlyOwner`, which can be applied to your functions to restrict their use to
947  * the owner.
948  */
949 abstract contract Ownable is Context {
950     address private _owner;
951 
952     event OwnershipTransferred(address indexed previousOwner, address indexed newOwner);
953 
954     /**
955      * @dev Initializes the contract setting the deployer as the initial owner.
956      */
957     constructor() {
958         _setOwner(_msgSender());
959     }
960 
961     /**
962      * @dev Returns the address of the current owner.
963      */
964     function owner() public view virtual returns (address) {
965         return _owner;
966     }
967 
968     /**
969      * @dev Throws if called by any account other than the owner.
970      */
971     modifier onlyOwner() {
972         require(owner() == _msgSender(), "Ownable: caller is not the owner");
973         _;
974     }
975 
976     /**
977      * @dev Leaves the contract without owner. It will not be possible to call
978      * `onlyOwner` functions anymore. Can only be called by the current owner.
979      *
980      * NOTE: Renouncing ownership will leave the contract without an owner,
981      * thereby removing any functionality that is only available to the owner.
982      */
983     function renounceOwnership() public virtual onlyOwner {
984         _setOwner(address(0));
985     }
986 
987     /**
988      * @dev Transfers ownership of the contract to a new account (`newOwner`).
989      * Can only be called by the current owner.
990      */
991     function transferOwnership(address newOwner) public virtual onlyOwner {
992         require(newOwner != address(0), "Ownable: new owner is the zero address");
993         _setOwner(newOwner);
994     }
995 
996     function _setOwner(address newOwner) private {
997         address oldOwner = _owner;
998         _owner = newOwner;
999         emit OwnershipTransferred(oldOwner, newOwner);
1000     }
1001 }
1002 
1003 // 
1004 /**
1005  * @dev Contract module which allows children to implement an emergency stop
1006  * mechanism that can be triggered by an authorized account.
1007  *
1008  * This module is used through inheritance. It will make available the
1009  * modifiers `whenNotPaused` and `whenPaused`, which can be applied to
1010  * the functions of your contract. Note that they will not be pausable by
1011  * simply including this module, only once the modifiers are put in place.
1012  */
1013 abstract contract Pausable is Context {
1014     /**
1015      * @dev Emitted when the pause is triggered by `account`.
1016      */
1017     event Paused(address account);
1018 
1019     /**
1020      * @dev Emitted when the pause is lifted by `account`.
1021      */
1022     event Unpaused(address account);
1023 
1024     bool private _paused;
1025 
1026     /**
1027      * @dev Initializes the contract in unpaused state.
1028      */
1029     constructor() {
1030         _paused = false;
1031     }
1032 
1033     /**
1034      * @dev Returns true if the contract is paused, and false otherwise.
1035      */
1036     function paused() public view virtual returns (bool) {
1037         return _paused;
1038     }
1039 
1040     /**
1041      * @dev Modifier to make a function callable only when the contract is not paused.
1042      *
1043      * Requirements:
1044      *
1045      * - The contract must not be paused.
1046      */
1047     modifier whenNotPaused() {
1048         require(!paused(), "Pausable: paused");
1049         _;
1050     }
1051 
1052     /**
1053      * @dev Modifier to make a function callable only when the contract is paused.
1054      *
1055      * Requirements:
1056      *
1057      * - The contract must be paused.
1058      */
1059     modifier whenPaused() {
1060         require(paused(), "Pausable: not paused");
1061         _;
1062     }
1063 
1064     /**
1065      * @dev Triggers stopped state.
1066      *
1067      * Requirements:
1068      *
1069      * - The contract must not be paused.
1070      */
1071     function _pause() internal virtual whenNotPaused {
1072         _paused = true;
1073         emit Paused(_msgSender());
1074     }
1075 
1076     /**
1077      * @dev Returns to normal state.
1078      *
1079      * Requirements:
1080      *
1081      * - The contract must be paused.
1082      */
1083     function _unpause() internal virtual whenPaused {
1084         _paused = false;
1085         emit Unpaused(_msgSender());
1086     }
1087 }
1088 
1089 // 
1090 // CAUTION
1091 // This version of SafeMath should only be used with Solidity 0.8 or later,
1092 // because it relies on the compiler's built in overflow checks.
1093 /**
1094  * @dev Wrappers over Solidity's arithmetic operations.
1095  *
1096  * NOTE: `SafeMath` is no longer needed starting with Solidity 0.8. The compiler
1097  * now has built in overflow checking.
1098  */
1099 library SafeMath {
1100     /**
1101      * @dev Returns the addition of two unsigned integers, with an overflow flag.
1102      *
1103      * _Available since v3.4._
1104      */
1105     function tryAdd(uint256 a, uint256 b) internal pure returns (bool, uint256) {
1106         unchecked {
1107             uint256 c = a + b;
1108             if (c < a) return (false, 0);
1109             return (true, c);
1110         }
1111     }
1112 
1113     /**
1114      * @dev Returns the substraction of two unsigned integers, with an overflow flag.
1115      *
1116      * _Available since v3.4._
1117      */
1118     function trySub(uint256 a, uint256 b) internal pure returns (bool, uint256) {
1119         unchecked {
1120             if (b > a) return (false, 0);
1121             return (true, a - b);
1122         }
1123     }
1124 
1125     /**
1126      * @dev Returns the multiplication of two unsigned integers, with an overflow flag.
1127      *
1128      * _Available since v3.4._
1129      */
1130     function tryMul(uint256 a, uint256 b) internal pure returns (bool, uint256) {
1131         unchecked {
1132             // Gas optimization: this is cheaper than requiring 'a' not being zero, but the
1133             // benefit is lost if 'b' is also tested.
1134             // See: https://github.com/OpenZeppelin/openzeppelin-contracts/pull/522
1135             if (a == 0) return (true, 0);
1136             uint256 c = a * b;
1137             if (c / a != b) return (false, 0);
1138             return (true, c);
1139         }
1140     }
1141 
1142     /**
1143      * @dev Returns the division of two unsigned integers, with a division by zero flag.
1144      *
1145      * _Available since v3.4._
1146      */
1147     function tryDiv(uint256 a, uint256 b) internal pure returns (bool, uint256) {
1148         unchecked {
1149             if (b == 0) return (false, 0);
1150             return (true, a / b);
1151         }
1152     }
1153 
1154     /**
1155      * @dev Returns the remainder of dividing two unsigned integers, with a division by zero flag.
1156      *
1157      * _Available since v3.4._
1158      */
1159     function tryMod(uint256 a, uint256 b) internal pure returns (bool, uint256) {
1160         unchecked {
1161             if (b == 0) return (false, 0);
1162             return (true, a % b);
1163         }
1164     }
1165 
1166     /**
1167      * @dev Returns the addition of two unsigned integers, reverting on
1168      * overflow.
1169      *
1170      * Counterpart to Solidity's `+` operator.
1171      *
1172      * Requirements:
1173      *
1174      * - Addition cannot overflow.
1175      */
1176     function add(uint256 a, uint256 b) internal pure returns (uint256) {
1177         return a + b;
1178     }
1179 
1180     /**
1181      * @dev Returns the subtraction of two unsigned integers, reverting on
1182      * overflow (when the result is negative).
1183      *
1184      * Counterpart to Solidity's `-` operator.
1185      *
1186      * Requirements:
1187      *
1188      * - Subtraction cannot overflow.
1189      */
1190     function sub(uint256 a, uint256 b) internal pure returns (uint256) {
1191         return a - b;
1192     }
1193 
1194     /**
1195      * @dev Returns the multiplication of two unsigned integers, reverting on
1196      * overflow.
1197      *
1198      * Counterpart to Solidity's `*` operator.
1199      *
1200      * Requirements:
1201      *
1202      * - Multiplication cannot overflow.
1203      */
1204     function mul(uint256 a, uint256 b) internal pure returns (uint256) {
1205         return a * b;
1206     }
1207 
1208     /**
1209      * @dev Returns the integer division of two unsigned integers, reverting on
1210      * division by zero. The result is rounded towards zero.
1211      *
1212      * Counterpart to Solidity's `/` operator.
1213      *
1214      * Requirements:
1215      *
1216      * - The divisor cannot be zero.
1217      */
1218     function div(uint256 a, uint256 b) internal pure returns (uint256) {
1219         return a / b;
1220     }
1221 
1222     /**
1223      * @dev Returns the remainder of dividing two unsigned integers. (unsigned integer modulo),
1224      * reverting when dividing by zero.
1225      *
1226      * Counterpart to Solidity's `%` operator. This function uses a `revert`
1227      * opcode (which leaves remaining gas untouched) while Solidity uses an
1228      * invalid opcode to revert (consuming all remaining gas).
1229      *
1230      * Requirements:
1231      *
1232      * - The divisor cannot be zero.
1233      */
1234     function mod(uint256 a, uint256 b) internal pure returns (uint256) {
1235         return a % b;
1236     }
1237 
1238     /**
1239      * @dev Returns the subtraction of two unsigned integers, reverting with custom message on
1240      * overflow (when the result is negative).
1241      *
1242      * CAUTION: This function is deprecated because it requires allocating memory for the error
1243      * message unnecessarily. For custom revert reasons use {trySub}.
1244      *
1245      * Counterpart to Solidity's `-` operator.
1246      *
1247      * Requirements:
1248      *
1249      * - Subtraction cannot overflow.
1250      */
1251     function sub(
1252         uint256 a,
1253         uint256 b,
1254         string memory errorMessage
1255     ) internal pure returns (uint256) {
1256         unchecked {
1257             require(b <= a, errorMessage);
1258             return a - b;
1259         }
1260     }
1261 
1262     /**
1263      * @dev Returns the integer division of two unsigned integers, reverting with custom message on
1264      * division by zero. The result is rounded towards zero.
1265      *
1266      * Counterpart to Solidity's `/` operator. Note: this function uses a
1267      * `revert` opcode (which leaves remaining gas untouched) while Solidity
1268      * uses an invalid opcode to revert (consuming all remaining gas).
1269      *
1270      * Requirements:
1271      *
1272      * - The divisor cannot be zero.
1273      */
1274     function div(
1275         uint256 a,
1276         uint256 b,
1277         string memory errorMessage
1278     ) internal pure returns (uint256) {
1279         unchecked {
1280             require(b > 0, errorMessage);
1281             return a / b;
1282         }
1283     }
1284 
1285     /**
1286      * @dev Returns the remainder of dividing two unsigned integers. (unsigned integer modulo),
1287      * reverting with custom message when dividing by zero.
1288      *
1289      * CAUTION: This function is deprecated because it requires allocating memory for the error
1290      * message unnecessarily. For custom revert reasons use {tryMod}.
1291      *
1292      * Counterpart to Solidity's `%` operator. This function uses a `revert`
1293      * opcode (which leaves remaining gas untouched) while Solidity uses an
1294      * invalid opcode to revert (consuming all remaining gas).
1295      *
1296      * Requirements:
1297      *
1298      * - The divisor cannot be zero.
1299      */
1300     function mod(
1301         uint256 a,
1302         uint256 b,
1303         string memory errorMessage
1304     ) internal pure returns (uint256) {
1305         unchecked {
1306             require(b > 0, errorMessage);
1307             return a % b;
1308         }
1309     }
1310 }
1311 
1312 // 
1313 /**
1314  * @dev These functions deal with verification of Merkle Trees proofs.
1315  *
1316  * The proofs can be generated using the JavaScript library
1317  * https://github.com/miguelmota/merkletreejs[merkletreejs].
1318  * Note: the hashing algorithm should be keccak256 and pair sorting should be enabled.
1319  *
1320  * See `test/utils/cryptography/MerkleProof.test.js` for some examples.
1321  */
1322 library MerkleProof {
1323     /**
1324      * @dev Returns true if a `leaf` can be proved to be a part of a Merkle tree
1325      * defined by `root`. For this, a `proof` must be provided, containing
1326      * sibling hashes on the branch from the leaf to the root of the tree. Each
1327      * pair of leaves and each pair of pre-images are assumed to be sorted.
1328      */
1329     function verify(
1330         bytes32[] memory proof,
1331         bytes32 root,
1332         bytes32 leaf
1333     ) internal pure returns (bool) {
1334         bytes32 computedHash = leaf;
1335 
1336         for (uint256 i = 0; i < proof.length; i++) {
1337             bytes32 proofElement = proof[i];
1338 
1339             if (computedHash <= proofElement) {
1340                 // Hash(current computed hash + current element of the proof)
1341                 computedHash = keccak256(abi.encodePacked(computedHash, proofElement));
1342             } else {
1343                 // Hash(current element of the proof + current computed hash)
1344                 computedHash = keccak256(abi.encodePacked(proofElement, computedHash));
1345             }
1346         }
1347 
1348         // Check if the computed hash (root) is equal to the provided root
1349         return computedHash == root;
1350     }
1351 }
1352 
1353 // 
1354 contract RoyalRabbits is ERC721, Ownable, Pausable {
1355 
1356     using SafeMath for uint256;
1357     using MerkleProof for bytes32[];
1358 
1359     bytes32 merkleRoot;
1360     bool merkleSet = false;
1361 
1362     uint256 public constant MAX_PER_CALL = 20;
1363     uint256 public constant MAX_PER_CALL_PRESALE = 10;
1364     uint256 public constant MAX_SUPPLY = 10000;
1365     uint256 public NFT_PRICE = 0.088e18;
1366 
1367     string internal baseURI;
1368     bool public presaleOngoing;
1369 
1370     uint256 public totalSupply;
1371     mapping(address => uint256) public presaleMintedAmounts;
1372 
1373     constructor() ERC721("Royal Rabbits", "RoyalRabbits") {
1374         _pause();
1375     }
1376 
1377     function mint(uint256 amount) external payable whenNotPaused {
1378         require(amount <= MAX_PER_CALL, "Amount exceeds max per tx");
1379 
1380         uint256 newSupply = totalSupply + amount;
1381 
1382         require(newSupply <= MAX_SUPPLY, "Amount exceeds max supply");
1383         require(msg.value == NFT_PRICE * amount, "Wrong eth amount");
1384 
1385         for (uint256 i = 0; i < amount; i++) {
1386             _mint(msg.sender, totalSupply + i);
1387         }
1388 
1389         totalSupply = newSupply;
1390     }
1391 
1392     function mintOwner(uint256 amount) external onlyOwner {
1393         uint256 newSupply = totalSupply + amount;
1394         require(newSupply <= MAX_SUPPLY, "Amount exceeds max supply");
1395 
1396         for (uint256 i = 0; i < amount; i++) {
1397             _mint(msg.sender, totalSupply + i);
1398         }
1399 
1400         totalSupply = newSupply;
1401     }
1402 
1403     function mintPresale(uint256 amount, uint256 index, bytes32[] calldata merkleProof) external payable whenPaused {
1404         require(presaleOngoing, "Presale hasn't started yet");
1405         require(presaleMintedAmounts[msg.sender] + amount <= MAX_PER_CALL_PRESALE, "Amount exceeds presale max");
1406         require(msg.value == NFT_PRICE * amount, "Wrong eth amount");
1407 
1408         // Verify merkleProof
1409         bytes32 node = keccak256(abi.encodePacked(index, msg.sender, uint256(1)));
1410         require(MerkleProof.verify(merkleProof, merkleRoot, node), "Invalid proof. Not whitelisted");
1411 
1412         for (uint256 i = 0; i < amount; i++) {
1413             _mint(msg.sender, totalSupply + i);
1414         }
1415 
1416         totalSupply += amount;
1417         presaleMintedAmounts[msg.sender] += amount;
1418     }
1419 
1420     function startPresale() external onlyOwner {
1421         presaleOngoing = true;
1422     }
1423 
1424     function setBaseURI(string memory uri) external onlyOwner {
1425         baseURI = uri;
1426     }
1427 
1428     function withdraw() external onlyOwner {
1429         uint256 balance = address(this).balance;
1430 
1431         // 4%
1432         payable(0x2b87c010dA8df9E7F406F81E0853fa4aD5a723B2).transfer(balance.mul(40).div(1000));
1433         // multisig 26%
1434         payable(0xD3622Df5b1bd7C9de89Af4E07aa9f19A76a2C9Ee).transfer(balance.mul(260).div(1000));
1435         // 15%
1436         payable(0xFCb729A70E3D7855265a22Ff0341C9962EfAc5D1).transfer(balance.mul(150).div(1000));
1437         // 15%
1438         payable(0x8AED4CD149c4E1447e391c61EcCc74A2125328C6).transfer(balance.mul(150).div(1000));
1439         // 30%
1440         payable(0x2AAa1F8da3741b1Bb408Aa60725a40695C6b7353).transfer(balance.mul(300).div(1000));
1441         // approx 10% in case of rounded dust
1442         payable(0x4d1aD0cB315bd0b3a58530b2f7022b299d0f0451).transfer(address(this).balance);
1443     }
1444 
1445     function _baseURI() internal override view returns(string memory) {
1446         return baseURI;
1447     }
1448 
1449     function setNftPrice(uint256 _nftPrice) external onlyOwner {
1450         NFT_PRICE = _nftPrice;
1451     }
1452 
1453     function pause() external onlyOwner {
1454         _pause();
1455     }
1456 
1457     function unpause() external onlyOwner {
1458         _unpause();
1459     }
1460 
1461     // Specify a merkle root hash from the gathered k/v dictionary of addresses
1462     // https://github.com/0xKiwi/go-merkle-distributor
1463     function setMerkleRoot(bytes32 root) external onlyOwner {
1464         merkleRoot = root;
1465         merkleSet = true;
1466     }
1467 
1468     // Return bool on if merkle root hash is set
1469     function isMerkleSet() public view returns (bool) {
1470         return merkleSet;
1471     }
1472 }