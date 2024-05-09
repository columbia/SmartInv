1 // SPDX-License-Identifier: MIT
2 // # MysteriousWorld
3 // Read more at https://www.themysterious.world/utility
4 
5 pragma solidity ^0.8.0;
6 
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
28 
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
166 
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
190 
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
212 
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
511 
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
535 
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
936 
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
1003 
1004 // CAUTION
1005 // This version of SafeMath should only be used with Solidity 0.8 or later,
1006 // because it relies on the compiler's built in overflow checks.
1007 /**
1008  * @dev Wrappers over Solidity's arithmetic operations.
1009  *
1010  * NOTE: `SafeMath` is no longer needed starting with Solidity 0.8. The compiler
1011  * now has built in overflow checking.
1012  */
1013 library SafeMath {
1014     /**
1015      * @dev Returns the addition of two unsigned integers, with an overflow flag.
1016      *
1017      * _Available since v3.4._
1018      */
1019     function tryAdd(uint256 a, uint256 b) internal pure returns (bool, uint256) {
1020         unchecked {
1021             uint256 c = a + b;
1022             if (c < a) return (false, 0);
1023             return (true, c);
1024         }
1025     }
1026 
1027     /**
1028      * @dev Returns the substraction of two unsigned integers, with an overflow flag.
1029      *
1030      * _Available since v3.4._
1031      */
1032     function trySub(uint256 a, uint256 b) internal pure returns (bool, uint256) {
1033         unchecked {
1034             if (b > a) return (false, 0);
1035             return (true, a - b);
1036         }
1037     }
1038 
1039     /**
1040      * @dev Returns the multiplication of two unsigned integers, with an overflow flag.
1041      *
1042      * _Available since v3.4._
1043      */
1044     function tryMul(uint256 a, uint256 b) internal pure returns (bool, uint256) {
1045         unchecked {
1046             // Gas optimization: this is cheaper than requiring 'a' not being zero, but the
1047             // benefit is lost if 'b' is also tested.
1048             // See: https://github.com/OpenZeppelin/openzeppelin-contracts/pull/522
1049             if (a == 0) return (true, 0);
1050             uint256 c = a * b;
1051             if (c / a != b) return (false, 0);
1052             return (true, c);
1053         }
1054     }
1055 
1056     /**
1057      * @dev Returns the division of two unsigned integers, with a division by zero flag.
1058      *
1059      * _Available since v3.4._
1060      */
1061     function tryDiv(uint256 a, uint256 b) internal pure returns (bool, uint256) {
1062         unchecked {
1063             if (b == 0) return (false, 0);
1064             return (true, a / b);
1065         }
1066     }
1067 
1068     /**
1069      * @dev Returns the remainder of dividing two unsigned integers, with a division by zero flag.
1070      *
1071      * _Available since v3.4._
1072      */
1073     function tryMod(uint256 a, uint256 b) internal pure returns (bool, uint256) {
1074         unchecked {
1075             if (b == 0) return (false, 0);
1076             return (true, a % b);
1077         }
1078     }
1079 
1080     /**
1081      * @dev Returns the addition of two unsigned integers, reverting on
1082      * overflow.
1083      *
1084      * Counterpart to Solidity's `+` operator.
1085      *
1086      * Requirements:
1087      *
1088      * - Addition cannot overflow.
1089      */
1090     function add(uint256 a, uint256 b) internal pure returns (uint256) {
1091         return a + b;
1092     }
1093 
1094     /**
1095      * @dev Returns the subtraction of two unsigned integers, reverting on
1096      * overflow (when the result is negative).
1097      *
1098      * Counterpart to Solidity's `-` operator.
1099      *
1100      * Requirements:
1101      *
1102      * - Subtraction cannot overflow.
1103      */
1104     function sub(uint256 a, uint256 b) internal pure returns (uint256) {
1105         return a - b;
1106     }
1107 
1108     /**
1109      * @dev Returns the multiplication of two unsigned integers, reverting on
1110      * overflow.
1111      *
1112      * Counterpart to Solidity's `*` operator.
1113      *
1114      * Requirements:
1115      *
1116      * - Multiplication cannot overflow.
1117      */
1118     function mul(uint256 a, uint256 b) internal pure returns (uint256) {
1119         return a * b;
1120     }
1121 
1122     /**
1123      * @dev Returns the integer division of two unsigned integers, reverting on
1124      * division by zero. The result is rounded towards zero.
1125      *
1126      * Counterpart to Solidity's `/` operator.
1127      *
1128      * Requirements:
1129      *
1130      * - The divisor cannot be zero.
1131      */
1132     function div(uint256 a, uint256 b) internal pure returns (uint256) {
1133         return a / b;
1134     }
1135 
1136     /**
1137      * @dev Returns the remainder of dividing two unsigned integers. (unsigned integer modulo),
1138      * reverting when dividing by zero.
1139      *
1140      * Counterpart to Solidity's `%` operator. This function uses a `revert`
1141      * opcode (which leaves remaining gas untouched) while Solidity uses an
1142      * invalid opcode to revert (consuming all remaining gas).
1143      *
1144      * Requirements:
1145      *
1146      * - The divisor cannot be zero.
1147      */
1148     function mod(uint256 a, uint256 b) internal pure returns (uint256) {
1149         return a % b;
1150     }
1151 
1152     /**
1153      * @dev Returns the subtraction of two unsigned integers, reverting with custom message on
1154      * overflow (when the result is negative).
1155      *
1156      * CAUTION: This function is deprecated because it requires allocating memory for the error
1157      * message unnecessarily. For custom revert reasons use {trySub}.
1158      *
1159      * Counterpart to Solidity's `-` operator.
1160      *
1161      * Requirements:
1162      *
1163      * - Subtraction cannot overflow.
1164      */
1165     function sub(
1166         uint256 a,
1167         uint256 b,
1168         string memory errorMessage
1169     ) internal pure returns (uint256) {
1170         unchecked {
1171             require(b <= a, errorMessage);
1172             return a - b;
1173         }
1174     }
1175 
1176     /**
1177      * @dev Returns the integer division of two unsigned integers, reverting with custom message on
1178      * division by zero. The result is rounded towards zero.
1179      *
1180      * Counterpart to Solidity's `/` operator. Note: this function uses a
1181      * `revert` opcode (which leaves remaining gas untouched) while Solidity
1182      * uses an invalid opcode to revert (consuming all remaining gas).
1183      *
1184      * Requirements:
1185      *
1186      * - The divisor cannot be zero.
1187      */
1188     function div(
1189         uint256 a,
1190         uint256 b,
1191         string memory errorMessage
1192     ) internal pure returns (uint256) {
1193         unchecked {
1194             require(b > 0, errorMessage);
1195             return a / b;
1196         }
1197     }
1198 
1199     /**
1200      * @dev Returns the remainder of dividing two unsigned integers. (unsigned integer modulo),
1201      * reverting with custom message when dividing by zero.
1202      *
1203      * CAUTION: This function is deprecated because it requires allocating memory for the error
1204      * message unnecessarily. For custom revert reasons use {tryMod}.
1205      *
1206      * Counterpart to Solidity's `%` operator. This function uses a `revert`
1207      * opcode (which leaves remaining gas untouched) while Solidity uses an
1208      * invalid opcode to revert (consuming all remaining gas).
1209      *
1210      * Requirements:
1211      *
1212      * - The divisor cannot be zero.
1213      */
1214     function mod(
1215         uint256 a,
1216         uint256 b,
1217         string memory errorMessage
1218     ) internal pure returns (uint256) {
1219         unchecked {
1220             require(b > 0, errorMessage);
1221             return a % b;
1222         }
1223     }
1224 }
1225 
1226 
1227 /**
1228  * @title Counters
1229  * @author Matt Condon (@shrugs)
1230  * @dev Provides counters that can only be incremented, decremented or reset. This can be used e.g. to track the number
1231  * of elements in a mapping, issuing ERC721 ids, or counting request ids.
1232  *
1233  * Include with `using Counters for Counters.Counter;`
1234  */
1235 library Counters {
1236     struct Counter {
1237         // This variable should never be directly accessed by users of the library: interactions must be restricted to
1238         // the library's function. As of Solidity v0.5.2, this cannot be enforced, though there is a proposal to add
1239         // this feature: see https://github.com/ethereum/solidity/issues/4637
1240         uint256 _value; // default: 0
1241     }
1242 
1243     function current(Counter storage counter) internal view returns (uint256) {
1244         return counter._value;
1245     }
1246 
1247     function increment(Counter storage counter) internal {
1248         unchecked {
1249             counter._value += 1;
1250         }
1251     }
1252 
1253     function decrement(Counter storage counter) internal {
1254         uint256 value = counter._value;
1255         require(value > 0, "Counter: decrement overflow");
1256         unchecked {
1257             counter._value = value - 1;
1258         }
1259     }
1260 
1261     function reset(Counter storage counter) internal {
1262         counter._value = 0;
1263     }
1264 }
1265 
1266 // The Creature World and Superlative Secret Society is used so we check who holds a nft
1267 // for the free mint claim system
1268 interface Creature {
1269     function ownerOf(uint256 token) external view returns(address);
1270     function tokenOfOwnerByIndex(address inhabitant, uint256 index) external view returns(uint256);
1271     function balanceOf(address inhabitant) external view returns(uint256);
1272 }
1273 
1274 interface Superlative {
1275     function ownerOf(uint256 token) external view returns(address);
1276     function tokenOfOwnerByIndex(address inhabitant, uint256 index) external view returns(uint256);
1277     function balanceOf(address inhabitant) external view returns(uint256);
1278 }
1279 
1280 // The runes contract is used to burn for sacrifices and update balances on transfers
1281 interface IRunes {
1282     function burn(address inhabitant, uint256 cost) external;
1283     function updateRunes(address from, address to) external;
1284 }
1285 
1286 // Allows us to mint with $LOOKS instead of ETH
1287 interface Looks {
1288     function transferFrom(address from, address to, uint256 amount) external;
1289     function balanceOf(address owner) external view returns(uint256);
1290 }
1291 
1292 /*
1293  * o               .        ___---___                    .                   
1294  *        .              .--\        --.     .     .         .
1295  *                     ./.;_.\     __/~ \.     
1296  *                    /;  / `-'  __\    . \                            
1297  *  .        .       / ,--'     / .   .;   \        |
1298  *                  | .|       /       __   |      -O-       .
1299  *                 |__/    __ |  . ;   \ | . |      |
1300  *                 |      /  \\_    . ;| \___|    
1301  *    .    o       |      \  .~\\___,--'     |           .
1302  *                  |     | . ; ~~~~\_    __|
1303  *     |             \    \   .  .  ; \  /_/   .
1304  *    -O-        .    \   /         . |  ~/                  .
1305  *     |    .          ~\ \   .      /  /~          o
1306  *   .                   ~--___ ; ___--~       
1307  *                  .          ---         .   MYSTERIOUS WORLD
1308  */
1309 contract MysteriousWorld is ERC721, Ownable {
1310     using Address  for address;
1311     using Counters for Counters.Counter;
1312 
1313     Counters.Counter private Population;
1314     Counters.Counter private sacrificed; // tracks the amount of rituals performed
1315     Counters.Counter private sacred; // tracks the 1/1s created from rituals
1316 
1317     Creature public creature;
1318     Superlative public superlative;
1319     IRunes public runes;
1320     Looks public looks;
1321 
1322     string private baseURI;
1323 
1324     uint256 constant public maxInhabitants  = 6666;
1325     uint256 constant public maxRituals      = 3333; // max amount of rituals that can be performed
1326     uint256 constant public teamInhabitants = 66; // the amount of inhabitants that will be reserved to the teams wallet
1327     uint256 constant public maxWInhabitants = 900; // the amount of free inhabitants given to the community
1328     uint256 constant public maxFInhabitants = 100; // the amount of free inhabitants given to holders of superlative & creatureworld - fcfs basis
1329     uint256 constant public maxPerTxn       = 6;
1330 
1331     uint256 public whitelistInhabitantsClaimed; // tracks the amount of mints claimed from giveaway winners
1332     uint256 public freeInhabitantsClaimed; // tracks the amount of free mints claimed from superlative & creatureworld holders
1333     uint256 public teamInhabitantsClaimed; // tracks the amount reserved for the team wallet
1334     uint256 public saleActive = 0; // the period for when public mint starts
1335     uint256 public claimActive = 0; // the period for free mint claiming - once the claimActive timestamp is reached, remaing supply goes to public fcfs
1336 
1337     uint256 public mintPrice   = 0.06 ether;
1338     uint256 public ritualPrice = 100 ether; // base price for rituals is 100 $RUNES
1339     uint256 public ritualRate  = 0.5 ether; // the rate increases the ritualPrice by the amount of rituals performed
1340     address public ritualWallet; // where the ritualized tokens go when u perform a ritual on them
1341     uint256 public looksPrice = 37 ether; // will be updated once contract is deployed if price difference is to high
1342     address public looksWallet;
1343 
1344     bool public templeAvailable = false; // once revealed, the temple will be available for rituals to be performed
1345 
1346     mapping(uint256 => bool)    public ritualizedInhabitants; // tracks the tokens that survived the ritual process
1347     mapping(uint256 => bool)    public uniqueInhabitants; // tracks the tokens that became gods
1348     mapping(address => uint256) public claimedW; // tracks to see what wallets claimed their whitelisted free mints
1349     mapping(address => uint256) public claimedF; // tracks to see what wallets claimed the free mints for the superlative & creatureworld
1350 
1351     event performRitualEvent(address caller, uint256 vessel, uint256 sacrifice);
1352     event performSacredRitualEvent(address caller, uint256 vessel, uint256 sacrifice);
1353 
1354     /*
1355      * # isTempleOpen
1356      * only allows you to perform a ritual if its enabled - this will be set after reveal
1357      */
1358     modifier isTempleOpen() {
1359         require(templeAvailable, "The temple is not ready yet");
1360         _;
1361     }
1362 
1363     /*
1364      * # inhabitantOwner
1365      * checks if you own the tokens your sacrificing
1366      */
1367     modifier inhabitantOwner(uint256 inhabitant) {
1368         require(ownerOf(inhabitant) == msg.sender, "You can't use another persons inhabitants");
1369         _;
1370     }
1371 
1372     /*
1373      * # ascendedOwner
1374      * checks if the inhabitant passed is ascended
1375      */
1376     modifier ascendedOwner(uint256 inhabitant) {
1377         require(ritualizedInhabitants[inhabitant], "This inhabitant needs to sacrifice another inhabitant to ascend");
1378         _;
1379     }
1380 
1381     /*
1382      * # isSaleActive
1383      * allows inhabitants to be sold...
1384      */
1385     modifier isSaleActive() {
1386         require(block.timestamp > saleActive, "Inhabitants aren't born yet");
1387         _;
1388     }
1389 
1390     /*
1391      * # isClaimActive
1392      * allows inhabitants to be taken for free... use this for the greater good
1393      */
1394     modifier isClaimActive() {
1395         require(block.timestamp < claimActive, "All inhabitants are gone");
1396         _;
1397     }
1398 
1399     constructor(address burner, address rare) ERC721("The Mysterious World", "The Mysterious World") {
1400         ritualWallet = burner;
1401         looksWallet = rare;
1402     }
1403 
1404     /*
1405      * # getAmountOfCreaturesHeld
1406      * returns the total amount of creature world nfts a wallet holds
1407      */
1408     function getAmountOfCreaturesHeld(address holder) public view returns(uint256) {
1409         return creature.balanceOf(holder);
1410     }
1411 
1412     /*
1413      * # getAmountOfSuperlativesHeld
1414      * returns the total amount of superlatives nfts a wallet holds
1415      */
1416     function getAmountOfSuperlativesHeld(address holder) public view returns(uint256) {
1417         return superlative.balanceOf(holder);
1418     }
1419 
1420     /*
1421      * # checkIfClaimedW
1422      * checks if the giveaway winners minted their tokens
1423      */
1424     function checkIfClaimedW(address holder) public view returns(uint256) {
1425         return claimedW[holder];
1426     }
1427 
1428     /*
1429      * # checkIfClaimedF
1430      * checks if the superlative and creature holders minted their free tokens
1431      */
1432     function checkIfClaimedF(address holder) public view returns(uint256) {
1433         return claimedF[holder];
1434     }
1435 
1436     /*
1437      * # addWhitelistWallets
1438      * adds the addresses to claimedW while setting the amount each address can claim
1439      */
1440     function addWhitelistWallets(address[] calldata winners) external payable onlyOwner {
1441         for (uint256 wallet;wallet < winners.length;wallet++) {
1442             claimedW[winners[wallet]] = 1;
1443         }
1444     }
1445     
1446     /*
1447      * # mint
1448      * mints a inhabitant - godspeed
1449      */
1450     function mint(uint256 amount) public payable isSaleActive {
1451         require(tx.origin == msg.sender, "Can't mint from other contracts!");
1452         require(amount > 0 && amount <= maxPerTxn, "Your amount must be between 1 and 6");
1453 
1454         if (block.timestamp <= claimActive) {
1455             require(Population.current() + amount <= (maxInhabitants - (maxWInhabitants + maxFInhabitants)), "Not enough inhabitants for that");
1456         } else {
1457             require(Population.current() + amount <= maxInhabitants, "Not enough inhabitants for that");
1458         }
1459 
1460         require(mintPrice * amount == msg.value, "Mint Price is not correct");
1461         
1462         for (uint256 i = 0;i < amount;i++) {
1463             _safeMint(msg.sender, Population.current());
1464             Population.increment();
1465         }
1466     }
1467 
1468     /*
1469      * # mintWhitelist
1470      * mints a free inhabitant from the whitelist wallets
1471      */
1472     function mintWhitelist() public payable isSaleActive isClaimActive {
1473         uint256 currentInhabitants = Population.current();
1474 
1475         require(tx.origin == msg.sender, "Can't mint from other contracts!");
1476         require(currentInhabitants + 1 <= maxInhabitants, "No inhabitants left");
1477         require(whitelistInhabitantsClaimed + 1 <= maxWInhabitants, "No inhabitants left");
1478         require(claimedW[msg.sender] == 1, "You don't have permission to be here outsider");
1479 
1480         _safeMint(msg.sender, currentInhabitants);
1481         
1482         Population.increment();
1483         claimedW[msg.sender] = 0;
1484         whitelistInhabitantsClaimed++;
1485 
1486         delete currentInhabitants;
1487     }
1488 
1489     /*
1490      * # mintFList
1491      * mints a free inhabitant if your holding a creature world or superlative token - can only be claimed once fcfs
1492      */
1493     function mintFList() public payable isSaleActive isClaimActive {
1494         uint256 currentInhabitants = Population.current();
1495 
1496         require(tx.origin == msg.sender, "Can't mint from other contracts!");
1497         require(currentInhabitants + 1 <= maxInhabitants, "No inhabitants left");
1498         require(freeInhabitantsClaimed + 1 <= maxFInhabitants, "No inhabitants left");
1499         require(getAmountOfCreaturesHeld(msg.sender) >= 1 || getAmountOfSuperlativesHeld(msg.sender) >= 1, "You don't have permission to be here outsider");
1500         require(claimedF[msg.sender] < 1, "You already took a inhabitant");
1501 
1502         _safeMint(msg.sender, currentInhabitants);
1503 
1504         Population.increment();
1505         claimedF[msg.sender] = 1;
1506         freeInhabitantsClaimed++;
1507 
1508         delete currentInhabitants;
1509     }
1510 
1511     /*
1512      * # mintWithLooks
1513      * allows you to mint with $LOOKS token - still need to pay gas :(
1514      */
1515     function mintWithLooks(uint256 amount) public payable isSaleActive {
1516         uint256 currentInhabitants = Population.current();
1517 
1518         require(tx.origin == msg.sender, "Can't mint from other contracts!");
1519         require(amount > 0 && amount <= maxPerTxn, "Your amount must be between 1 and 6");
1520 
1521         if (block.timestamp <= claimActive) {
1522             require(currentInhabitants + amount <= (maxInhabitants - (maxWInhabitants + maxFInhabitants)), "Not enough inhabitants for that");
1523         } else {
1524             require(currentInhabitants + amount <= maxInhabitants, "Not enough inhabitants for that");
1525         }
1526 
1527         require(looks.balanceOf(msg.sender) >= looksPrice * amount, "Not enough $LOOKS to buy a inhabitant");
1528         
1529         looks.transferFrom(msg.sender, looksWallet, looksPrice * amount);
1530 
1531         for (uint256 i = 0;i < amount;i++) {
1532             _safeMint(msg.sender, currentInhabitants + i);
1533 
1534             Population.increment();
1535         }
1536 
1537         delete currentInhabitants;
1538     }
1539 
1540     /*
1541      * # reserveInhabitants
1542      * mints the amount provided for the team wallet - the amount is capped by teamInhabitants
1543      */
1544     function reserveInhabitants(uint256 amount) public payable onlyOwner {
1545         uint256 currentInhabitants = Population.current();
1546 
1547         require(teamInhabitantsClaimed + amount < teamInhabitants, "We've run out of inhabitants for the team");
1548 
1549         for (uint256 i = 0;i < amount;i++) {
1550             _safeMint(msg.sender, currentInhabitants + i);
1551 
1552             Population.increment();
1553             teamInhabitantsClaimed++;
1554         }
1555 
1556         delete currentInhabitants;
1557     }
1558 
1559     /*
1560      * # performRitual
1561      * performing the ritual will burn one of the tokens passed and upgrade the first token passed. upgrading will
1562      * change the metadata of the image and add to the sacrifice goals for the project.
1563      */
1564     function performRitual(uint256 vessel, uint256 sacrifice) public payable inhabitantOwner(vessel) inhabitantOwner(sacrifice) isTempleOpen {
1565         require(vessel != sacrifice, "You can't sacrifice the same inhabitants");
1566         require(!ritualizedInhabitants[vessel] && !ritualizedInhabitants[sacrifice], "You can't sacrifice ascended inhabitants with those of the lower class");
1567 
1568         // burn the $RUNES and transfer the sacrificed token to the burn wallet
1569         runes.burn(msg.sender, ritualPrice + (ritualRate * sacrificed.current()));
1570         safeTransferFrom(msg.sender, ritualWallet, sacrifice, "");
1571 
1572         // track the tokens that ascended & add to the global goal
1573         sacrificed.increment();
1574         ritualizedInhabitants[vessel] = true;
1575 
1576         emit performRitualEvent(msg.sender, vessel, sacrifice);
1577     }
1578 
1579     /*
1580      * # performSacredRight
1581      * this is performed during the 10% sacrifical goals for the 1/1s. check the utility page for more info
1582      */
1583     function performSacredRitual(uint256 vessel, uint256 sacrifice) public payable inhabitantOwner(vessel) inhabitantOwner(sacrifice) ascendedOwner(vessel) ascendedOwner(sacrifice) isTempleOpen {
1584         uint256 currentGoal = 333 * sacred.current(); // 10% of maxRituals 
1585 
1586         require(vessel != sacrifice, "You can't sacrifice the same inhabitants");
1587         require(sacrificed.current() >= currentGoal, "Not enough sacrifices to discover a God!");
1588 
1589          // burn the $RUNES and transfer the sacrificed token to the burn wallet
1590         runes.burn(msg.sender, ritualPrice + (ritualRate * sacrificed.current()));
1591         safeTransferFrom(msg.sender, ritualWallet, sacrifice, "");
1592 
1593         ritualizedInhabitants[vessel] = false;
1594         uniqueInhabitants[vessel] = true;
1595         sacrificed.increment();
1596         sacred.increment();
1597 
1598         emit performSacredRitualEvent(msg.sender, vessel, sacrifice);
1599     }
1600 
1601     /*
1602      * # getCaptives
1603      * returns all the tokens a wallet holds
1604      */
1605     function getCaptives(address inhabitant) public view returns(uint256[] memory) {
1606         uint256 population = Population.current();
1607         uint256 amount     = balanceOf(inhabitant);
1608         uint256 selector   = 0;
1609 
1610         uint256[] memory inhabitants = new uint256[](amount);
1611 
1612         for (uint256 i = 0;i < population;i++) {
1613             if (ownerOf(i) == inhabitant) {
1614                 inhabitants[selector] = i;
1615                 selector++;
1616             }
1617         }
1618 
1619         return inhabitants;
1620     }
1621 
1622     /*
1623      * # totalSupply
1624      */
1625     function totalSupply() external view returns(uint256) {
1626         return Population.current();
1627     }
1628 
1629     /*
1630      * # getSacrificed
1631      */
1632     function getSacrificed() external view returns(uint256) {
1633         return sacrificed.current();
1634     }
1635 
1636     /*
1637      * # getSacred
1638      */
1639     function getSacred() external view returns(uint256) {
1640         return sacred.current();
1641     }
1642 
1643     /*
1644      * # _baseURI
1645      */
1646     function _baseURI() internal view override returns (string memory) {
1647         return baseURI;
1648     }
1649 
1650     /*
1651      * # setBaseURI
1652      */
1653     function setBaseURI(string memory metadataUrl) public payable onlyOwner {
1654         baseURI = metadataUrl;
1655     }
1656 
1657     /*
1658      * # withdraw
1659      * withdraws the funds from the smart contract to the owner
1660      */
1661     function withdraw() public payable onlyOwner {
1662         uint256 balance = address(this).balance;
1663         payable(msg.sender).transfer(balance);
1664 
1665         delete balance;
1666     }
1667 
1668     /*
1669      * # setSaleSettings
1670      * sets the drop time and the claimimg time
1671      */
1672     function setSaleSettings(uint256 saleTime, uint256 claimTime) public payable onlyOwner {
1673         saleActive  = saleTime;
1674         claimActive = claimTime;
1675     }
1676 
1677     /*
1678      * # setMintPrice
1679      * sets the mint price for the sale incase we need to change it
1680      */
1681     function setMintPrice(uint256 price) public payable onlyOwner {
1682         mintPrice = price;
1683     }
1684 
1685     /*
1686      * # setLooksPrice
1687      * sets the price of $LOOKS to mint with incase we need to set it multiple times
1688      */
1689     function setLooksPrice(uint256 price) public payable onlyOwner {
1690         looksPrice = price;
1691     }
1692 
1693     /*
1694      * # setRitualSettings
1695      * allows us to change the ritual price, rate, and whether ritual is enabled or not
1696      */
1697     function setRitualSettings(uint256 price, uint256 rate, bool available) public payable onlyOwner {
1698         ritualPrice     = price;
1699         ritualRate      = rate;
1700         templeAvailable = available;
1701     }
1702 
1703     /*
1704      * # setCollectionInterfaces
1705      * sets the interfaces for creatureworld, superlative, and runes
1706      */
1707     function setCollectionInterfaces(address creatureContract, address superlativeContract, address runesContract, address looksContract) public payable onlyOwner {
1708         creature    = Creature(creatureContract);
1709         superlative = Superlative(superlativeContract);
1710         runes       = IRunes(runesContract);
1711         looks       = Looks(looksContract);
1712     }
1713 
1714     /*
1715      * # transferFrom
1716      */
1717     function transferFrom(address from, address to, uint256 inhabitant) public override {
1718         runes.updateRunes(from, to);
1719 
1720         ERC721.transferFrom(from, to, inhabitant);
1721     }
1722 
1723     /*
1724      * # safeTransferFrom
1725      */
1726     function safeTransferFrom(address from, address to, uint256 inhabitant) public override {
1727         safeTransferFrom(from, to, inhabitant, "");
1728     }
1729     
1730     function safeTransferFrom(address from, address to, uint256 inhabitant, bytes memory data) public override {
1731         runes.updateRunes(from, to);
1732 
1733         ERC721.safeTransferFrom(from, to, inhabitant, data);
1734     }
1735 }