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
938  * @title ERC-721 Non-Fungible Token Standard, optional enumeration extension
939  * @dev See https://eips.ethereum.org/EIPS/eip-721
940  */
941 interface IERC721Enumerable is IERC721 {
942     /**
943      * @dev Returns the total amount of tokens stored by the contract.
944      */
945     function totalSupply() external view returns (uint256);
946 
947     /**
948      * @dev Returns a token ID owned by `owner` at a given `index` of its token list.
949      * Use along with {balanceOf} to enumerate all of ``owner``'s tokens.
950      */
951     function tokenOfOwnerByIndex(address owner, uint256 index) external view returns (uint256 tokenId);
952 
953     /**
954      * @dev Returns a token ID at a given `index` of all the tokens stored by the contract.
955      * Use along with {totalSupply} to enumerate all tokens.
956      */
957     function tokenByIndex(uint256 index) external view returns (uint256);
958 }
959 
960 // 
961 /**
962  * @dev This implements an optional extension of {ERC721} defined in the EIP that adds
963  * enumerability of all the token ids in the contract as well as all token ids owned by each
964  * account.
965  */
966 abstract contract ERC721Enumerable is ERC721, IERC721Enumerable {
967     // Mapping from owner to list of owned token IDs
968     mapping(address => mapping(uint256 => uint256)) private _ownedTokens;
969 
970     // Mapping from token ID to index of the owner tokens list
971     mapping(uint256 => uint256) private _ownedTokensIndex;
972 
973     // Array with all token ids, used for enumeration
974     uint256[] private _allTokens;
975 
976     // Mapping from token id to position in the allTokens array
977     mapping(uint256 => uint256) private _allTokensIndex;
978 
979     /**
980      * @dev See {IERC165-supportsInterface}.
981      */
982     function supportsInterface(bytes4 interfaceId) public view virtual override(IERC165, ERC721) returns (bool) {
983         return interfaceId == type(IERC721Enumerable).interfaceId || super.supportsInterface(interfaceId);
984     }
985 
986     /**
987      * @dev See {IERC721Enumerable-tokenOfOwnerByIndex}.
988      */
989     function tokenOfOwnerByIndex(address owner, uint256 index) public view virtual override returns (uint256) {
990         require(index < ERC721.balanceOf(owner), "ERC721Enumerable: owner index out of bounds");
991         return _ownedTokens[owner][index];
992     }
993 
994     /**
995      * @dev See {IERC721Enumerable-totalSupply}.
996      */
997     function totalSupply() public view virtual override returns (uint256) {
998         return _allTokens.length;
999     }
1000 
1001     /**
1002      * @dev See {IERC721Enumerable-tokenByIndex}.
1003      */
1004     function tokenByIndex(uint256 index) public view virtual override returns (uint256) {
1005         require(index < ERC721Enumerable.totalSupply(), "ERC721Enumerable: global index out of bounds");
1006         return _allTokens[index];
1007     }
1008 
1009     /**
1010      * @dev Hook that is called before any token transfer. This includes minting
1011      * and burning.
1012      *
1013      * Calling conditions:
1014      *
1015      * - When `from` and `to` are both non-zero, ``from``'s `tokenId` will be
1016      * transferred to `to`.
1017      * - When `from` is zero, `tokenId` will be minted for `to`.
1018      * - When `to` is zero, ``from``'s `tokenId` will be burned.
1019      * - `from` cannot be the zero address.
1020      * - `to` cannot be the zero address.
1021      *
1022      * To learn more about hooks, head to xref:ROOT:extending-contracts.adoc#using-hooks[Using Hooks].
1023      */
1024     function _beforeTokenTransfer(
1025         address from,
1026         address to,
1027         uint256 tokenId
1028     ) internal virtual override {
1029         super._beforeTokenTransfer(from, to, tokenId);
1030 
1031         if (from == address(0)) {
1032             _addTokenToAllTokensEnumeration(tokenId);
1033         } else if (from != to) {
1034             _removeTokenFromOwnerEnumeration(from, tokenId);
1035         }
1036         if (to == address(0)) {
1037             _removeTokenFromAllTokensEnumeration(tokenId);
1038         } else if (to != from) {
1039             _addTokenToOwnerEnumeration(to, tokenId);
1040         }
1041     }
1042 
1043     /**
1044      * @dev Private function to add a token to this extension's ownership-tracking data structures.
1045      * @param to address representing the new owner of the given token ID
1046      * @param tokenId uint256 ID of the token to be added to the tokens list of the given address
1047      */
1048     function _addTokenToOwnerEnumeration(address to, uint256 tokenId) private {
1049         uint256 length = ERC721.balanceOf(to);
1050         _ownedTokens[to][length] = tokenId;
1051         _ownedTokensIndex[tokenId] = length;
1052     }
1053 
1054     /**
1055      * @dev Private function to add a token to this extension's token tracking data structures.
1056      * @param tokenId uint256 ID of the token to be added to the tokens list
1057      */
1058     function _addTokenToAllTokensEnumeration(uint256 tokenId) private {
1059         _allTokensIndex[tokenId] = _allTokens.length;
1060         _allTokens.push(tokenId);
1061     }
1062 
1063     /**
1064      * @dev Private function to remove a token from this extension's ownership-tracking data structures. Note that
1065      * while the token is not assigned a new owner, the `_ownedTokensIndex` mapping is _not_ updated: this allows for
1066      * gas optimizations e.g. when performing a transfer operation (avoiding double writes).
1067      * This has O(1) time complexity, but alters the order of the _ownedTokens array.
1068      * @param from address representing the previous owner of the given token ID
1069      * @param tokenId uint256 ID of the token to be removed from the tokens list of the given address
1070      */
1071     function _removeTokenFromOwnerEnumeration(address from, uint256 tokenId) private {
1072         // To prevent a gap in from's tokens array, we store the last token in the index of the token to delete, and
1073         // then delete the last slot (swap and pop).
1074 
1075         uint256 lastTokenIndex = ERC721.balanceOf(from) - 1;
1076         uint256 tokenIndex = _ownedTokensIndex[tokenId];
1077 
1078         // When the token to delete is the last token, the swap operation is unnecessary
1079         if (tokenIndex != lastTokenIndex) {
1080             uint256 lastTokenId = _ownedTokens[from][lastTokenIndex];
1081 
1082             _ownedTokens[from][tokenIndex] = lastTokenId; // Move the last token to the slot of the to-delete token
1083             _ownedTokensIndex[lastTokenId] = tokenIndex; // Update the moved token's index
1084         }
1085 
1086         // This also deletes the contents at the last position of the array
1087         delete _ownedTokensIndex[tokenId];
1088         delete _ownedTokens[from][lastTokenIndex];
1089     }
1090 
1091     /**
1092      * @dev Private function to remove a token from this extension's token tracking data structures.
1093      * This has O(1) time complexity, but alters the order of the _allTokens array.
1094      * @param tokenId uint256 ID of the token to be removed from the tokens list
1095      */
1096     function _removeTokenFromAllTokensEnumeration(uint256 tokenId) private {
1097         // To prevent a gap in the tokens array, we store the last token in the index of the token to delete, and
1098         // then delete the last slot (swap and pop).
1099 
1100         uint256 lastTokenIndex = _allTokens.length - 1;
1101         uint256 tokenIndex = _allTokensIndex[tokenId];
1102 
1103         // When the token to delete is the last token, the swap operation is unnecessary. However, since this occurs so
1104         // rarely (when the last minted token is burnt) that we still do the swap here to avoid the gas cost of adding
1105         // an 'if' statement (like in _removeTokenFromOwnerEnumeration)
1106         uint256 lastTokenId = _allTokens[lastTokenIndex];
1107 
1108         _allTokens[tokenIndex] = lastTokenId; // Move the last token to the slot of the to-delete token
1109         _allTokensIndex[lastTokenId] = tokenIndex; // Update the moved token's index
1110 
1111         // This also deletes the contents at the last position of the array
1112         delete _allTokensIndex[tokenId];
1113         _allTokens.pop();
1114     }
1115 }
1116 
1117 // 
1118 /**
1119  * @title ERC721 Burnable Token
1120  * @dev ERC721 Token that can be irreversibly burned (destroyed).
1121  */
1122 abstract contract ERC721Burnable is Context, ERC721 {
1123     /**
1124      * @dev Burns `tokenId`. See {ERC721-_burn}.
1125      *
1126      * Requirements:
1127      *
1128      * - The caller must own `tokenId` or be an approved operator.
1129      */
1130     function burn(uint256 tokenId) public virtual {
1131         //solhint-disable-next-line max-line-length
1132         require(_isApprovedOrOwner(_msgSender(), tokenId), "ERC721Burnable: caller is not owner nor approved");
1133         _burn(tokenId);
1134     }
1135 }
1136 
1137 // 
1138 /**
1139  * @dev Contract module which provides a basic access control mechanism, where
1140  * there is an account (an owner) that can be granted exclusive access to
1141  * specific functions.
1142  *
1143  * By default, the owner account will be the one that deploys the contract. This
1144  * can later be changed with {transferOwnership}.
1145  *
1146  * This module is used through inheritance. It will make available the modifier
1147  * `onlyOwner`, which can be applied to your functions to restrict their use to
1148  * the owner.
1149  */
1150 abstract contract Ownable is Context {
1151     address private _owner;
1152 
1153     event OwnershipTransferred(address indexed previousOwner, address indexed newOwner);
1154 
1155     /**
1156      * @dev Initializes the contract setting the deployer as the initial owner.
1157      */
1158     constructor() {
1159         _setOwner(_msgSender());
1160     }
1161 
1162     /**
1163      * @dev Returns the address of the current owner.
1164      */
1165     function owner() public view virtual returns (address) {
1166         return _owner;
1167     }
1168 
1169     /**
1170      * @dev Throws if called by any account other than the owner.
1171      */
1172     modifier onlyOwner() {
1173         require(owner() == _msgSender(), "Ownable: caller is not the owner");
1174         _;
1175     }
1176 
1177     /**
1178      * @dev Leaves the contract without owner. It will not be possible to call
1179      * `onlyOwner` functions anymore. Can only be called by the current owner.
1180      *
1181      * NOTE: Renouncing ownership will leave the contract without an owner,
1182      * thereby removing any functionality that is only available to the owner.
1183      */
1184     function renounceOwnership() public virtual onlyOwner {
1185         _setOwner(address(0));
1186     }
1187 
1188     /**
1189      * @dev Transfers ownership of the contract to a new account (`newOwner`).
1190      * Can only be called by the current owner.
1191      */
1192     function transferOwnership(address newOwner) public virtual onlyOwner {
1193         require(newOwner != address(0), "Ownable: new owner is the zero address");
1194         _setOwner(newOwner);
1195     }
1196 
1197     function _setOwner(address newOwner) private {
1198         address oldOwner = _owner;
1199         _owner = newOwner;
1200         emit OwnershipTransferred(oldOwner, newOwner);
1201     }
1202 }
1203 
1204 // 
1205 /**
1206  * @title Counters
1207  * @author Matt Condon (@shrugs)
1208  * @dev Provides counters that can only be incremented, decremented or reset. This can be used e.g. to track the number
1209  * of elements in a mapping, issuing ERC721 ids, or counting request ids.
1210  *
1211  * Include with `using Counters for Counters.Counter;`
1212  */
1213 library Counters {
1214     struct Counter {
1215         // This variable should never be directly accessed by users of the library: interactions must be restricted to
1216         // the library's function. As of Solidity v0.5.2, this cannot be enforced, though there is a proposal to add
1217         // this feature: see https://github.com/ethereum/solidity/issues/4637
1218         uint256 _value; // default: 0
1219     }
1220 
1221     function current(Counter storage counter) internal view returns (uint256) {
1222         return counter._value;
1223     }
1224 
1225     function increment(Counter storage counter) internal {
1226         unchecked {
1227             counter._value += 1;
1228         }
1229     }
1230 
1231     function decrement(Counter storage counter) internal {
1232         uint256 value = counter._value;
1233         require(value > 0, "Counter: decrement overflow");
1234         unchecked {
1235             counter._value = value - 1;
1236         }
1237     }
1238 
1239     function reset(Counter storage counter) internal {
1240         counter._value = 0;
1241     }
1242 }
1243 
1244 // 
1245 // CAUTION
1246 // This version of SafeMath should only be used with Solidity 0.8 or later,
1247 // because it relies on the compiler's built in overflow checks.
1248 /**
1249  * @dev Wrappers over Solidity's arithmetic operations.
1250  *
1251  * NOTE: `SafeMath` is no longer needed starting with Solidity 0.8. The compiler
1252  * now has built in overflow checking.
1253  */
1254 library SafeMath {
1255     /**
1256      * @dev Returns the addition of two unsigned integers, with an overflow flag.
1257      *
1258      * _Available since v3.4._
1259      */
1260     function tryAdd(uint256 a, uint256 b) internal pure returns (bool, uint256) {
1261         unchecked {
1262             uint256 c = a + b;
1263             if (c < a) return (false, 0);
1264             return (true, c);
1265         }
1266     }
1267 
1268     /**
1269      * @dev Returns the substraction of two unsigned integers, with an overflow flag.
1270      *
1271      * _Available since v3.4._
1272      */
1273     function trySub(uint256 a, uint256 b) internal pure returns (bool, uint256) {
1274         unchecked {
1275             if (b > a) return (false, 0);
1276             return (true, a - b);
1277         }
1278     }
1279 
1280     /**
1281      * @dev Returns the multiplication of two unsigned integers, with an overflow flag.
1282      *
1283      * _Available since v3.4._
1284      */
1285     function tryMul(uint256 a, uint256 b) internal pure returns (bool, uint256) {
1286         unchecked {
1287             // Gas optimization: this is cheaper than requiring 'a' not being zero, but the
1288             // benefit is lost if 'b' is also tested.
1289             // See: https://github.com/OpenZeppelin/openzeppelin-contracts/pull/522
1290             if (a == 0) return (true, 0);
1291             uint256 c = a * b;
1292             if (c / a != b) return (false, 0);
1293             return (true, c);
1294         }
1295     }
1296 
1297     /**
1298      * @dev Returns the division of two unsigned integers, with a division by zero flag.
1299      *
1300      * _Available since v3.4._
1301      */
1302     function tryDiv(uint256 a, uint256 b) internal pure returns (bool, uint256) {
1303         unchecked {
1304             if (b == 0) return (false, 0);
1305             return (true, a / b);
1306         }
1307     }
1308 
1309     /**
1310      * @dev Returns the remainder of dividing two unsigned integers, with a division by zero flag.
1311      *
1312      * _Available since v3.4._
1313      */
1314     function tryMod(uint256 a, uint256 b) internal pure returns (bool, uint256) {
1315         unchecked {
1316             if (b == 0) return (false, 0);
1317             return (true, a % b);
1318         }
1319     }
1320 
1321     /**
1322      * @dev Returns the addition of two unsigned integers, reverting on
1323      * overflow.
1324      *
1325      * Counterpart to Solidity's `+` operator.
1326      *
1327      * Requirements:
1328      *
1329      * - Addition cannot overflow.
1330      */
1331     function add(uint256 a, uint256 b) internal pure returns (uint256) {
1332         return a + b;
1333     }
1334 
1335     /**
1336      * @dev Returns the subtraction of two unsigned integers, reverting on
1337      * overflow (when the result is negative).
1338      *
1339      * Counterpart to Solidity's `-` operator.
1340      *
1341      * Requirements:
1342      *
1343      * - Subtraction cannot overflow.
1344      */
1345     function sub(uint256 a, uint256 b) internal pure returns (uint256) {
1346         return a - b;
1347     }
1348 
1349     /**
1350      * @dev Returns the multiplication of two unsigned integers, reverting on
1351      * overflow.
1352      *
1353      * Counterpart to Solidity's `*` operator.
1354      *
1355      * Requirements:
1356      *
1357      * - Multiplication cannot overflow.
1358      */
1359     function mul(uint256 a, uint256 b) internal pure returns (uint256) {
1360         return a * b;
1361     }
1362 
1363     /**
1364      * @dev Returns the integer division of two unsigned integers, reverting on
1365      * division by zero. The result is rounded towards zero.
1366      *
1367      * Counterpart to Solidity's `/` operator.
1368      *
1369      * Requirements:
1370      *
1371      * - The divisor cannot be zero.
1372      */
1373     function div(uint256 a, uint256 b) internal pure returns (uint256) {
1374         return a / b;
1375     }
1376 
1377     /**
1378      * @dev Returns the remainder of dividing two unsigned integers. (unsigned integer modulo),
1379      * reverting when dividing by zero.
1380      *
1381      * Counterpart to Solidity's `%` operator. This function uses a `revert`
1382      * opcode (which leaves remaining gas untouched) while Solidity uses an
1383      * invalid opcode to revert (consuming all remaining gas).
1384      *
1385      * Requirements:
1386      *
1387      * - The divisor cannot be zero.
1388      */
1389     function mod(uint256 a, uint256 b) internal pure returns (uint256) {
1390         return a % b;
1391     }
1392 
1393     /**
1394      * @dev Returns the subtraction of two unsigned integers, reverting with custom message on
1395      * overflow (when the result is negative).
1396      *
1397      * CAUTION: This function is deprecated because it requires allocating memory for the error
1398      * message unnecessarily. For custom revert reasons use {trySub}.
1399      *
1400      * Counterpart to Solidity's `-` operator.
1401      *
1402      * Requirements:
1403      *
1404      * - Subtraction cannot overflow.
1405      */
1406     function sub(
1407         uint256 a,
1408         uint256 b,
1409         string memory errorMessage
1410     ) internal pure returns (uint256) {
1411         unchecked {
1412             require(b <= a, errorMessage);
1413             return a - b;
1414         }
1415     }
1416 
1417     /**
1418      * @dev Returns the integer division of two unsigned integers, reverting with custom message on
1419      * division by zero. The result is rounded towards zero.
1420      *
1421      * Counterpart to Solidity's `/` operator. Note: this function uses a
1422      * `revert` opcode (which leaves remaining gas untouched) while Solidity
1423      * uses an invalid opcode to revert (consuming all remaining gas).
1424      *
1425      * Requirements:
1426      *
1427      * - The divisor cannot be zero.
1428      */
1429     function div(
1430         uint256 a,
1431         uint256 b,
1432         string memory errorMessage
1433     ) internal pure returns (uint256) {
1434         unchecked {
1435             require(b > 0, errorMessage);
1436             return a / b;
1437         }
1438     }
1439 
1440     /**
1441      * @dev Returns the remainder of dividing two unsigned integers. (unsigned integer modulo),
1442      * reverting with custom message when dividing by zero.
1443      *
1444      * CAUTION: This function is deprecated because it requires allocating memory for the error
1445      * message unnecessarily. For custom revert reasons use {tryMod}.
1446      *
1447      * Counterpart to Solidity's `%` operator. This function uses a `revert`
1448      * opcode (which leaves remaining gas untouched) while Solidity uses an
1449      * invalid opcode to revert (consuming all remaining gas).
1450      *
1451      * Requirements:
1452      *
1453      * - The divisor cannot be zero.
1454      */
1455     function mod(
1456         uint256 a,
1457         uint256 b,
1458         string memory errorMessage
1459     ) internal pure returns (uint256) {
1460         unchecked {
1461             require(b > 0, errorMessage);
1462             return a % b;
1463         }
1464     }
1465 }
1466 
1467 // 
1468 contract BeyondHumanity is ERC721, ERC721Enumerable, ERC721Burnable, Ownable {
1469     using Counters for Counters.Counter;
1470     using SafeMath for uint256;
1471     using Strings for uint256;
1472 
1473     Counters.Counter private _tokenIdCounter;
1474 
1475     string public baseURI;
1476 
1477     uint256 public constant MAX_PURCHASE = 20;
1478 
1479     uint256 public constant _price = 0.04 * 10**18;
1480 
1481     uint256 public maxSupply = 4444;
1482 
1483     bool public _saleIsActive = false;
1484 
1485     bool public isRevealed = false;
1486 
1487     address creator = 0x04e197B3f94C607154265A3aDEEEfBe18057815d;
1488 
1489     constructor(string memory initialBaseURI) ERC721("BeyondHumanity", "BH") {
1490         baseURI = initialBaseURI;
1491     }
1492 
1493     function mintNFT(uint256 mintCount) public payable {
1494         require(_saleIsActive, "Sale is not Active");
1495 
1496         require(totalSupply() < maxSupply, "Sale has ended");
1497 
1498         require(mintCount > 0, "Cannot buy 0");
1499 
1500         require(
1501             mintCount <= MAX_PURCHASE,
1502             "You may not buy that many BHs at once"
1503         );
1504 
1505         require(
1506             totalSupply().add(mintCount) <= maxSupply,
1507             "Exceeds max supply"
1508         );
1509 
1510         require(msg.value >= _price * mintCount, "Insufficent Payment Value");
1511 
1512         for (uint256 i = 0; i < mintCount; i++) {
1513             uint256 mintIndex = totalSupply();
1514             _safeMint(msg.sender, mintIndex);
1515         }
1516     }
1517 
1518     function withdrawAll() public payable {
1519         uint256 balance = address(this).balance;
1520         require(payable(creator).send(balance));
1521     }
1522 
1523     function flipReveal() external onlyOwner {
1524         isRevealed = !isRevealed;
1525     }
1526 
1527     function tokenURI(uint256 tokenId)
1528         public
1529         view
1530         virtual
1531         override
1532         returns (string memory)
1533     {
1534         if (!isRevealed) {
1535             return string(abi.encodePacked(baseURI, "unrevealed", ".json"));
1536         }
1537 
1538         return string(abi.encodePacked(baseURI, tokenId.toString(), ".json"));
1539     }
1540 
1541     function updateBaseURI(string calldata newBaseURI) external onlyOwner {
1542         baseURI = newBaseURI;
1543     }
1544 
1545     function saleStart() public onlyOwner {
1546         _saleIsActive = true;
1547     }
1548 
1549     function saleStop() public onlyOwner {
1550         _saleIsActive = false;
1551     }
1552 
1553     function _beforeTokenTransfer(
1554         address from,
1555         address to,
1556         uint256 tokenId
1557     ) internal override(ERC721, ERC721Enumerable) {
1558         super._beforeTokenTransfer(from, to, tokenId);
1559     }
1560 
1561     function supportsInterface(bytes4 interfaceId)
1562         public
1563         view
1564         override(ERC721, ERC721Enumerable)
1565         returns (bool)
1566     {
1567         return super.supportsInterface(interfaceId);
1568     }
1569 }