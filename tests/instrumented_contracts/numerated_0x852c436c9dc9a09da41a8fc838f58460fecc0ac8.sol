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
60      * @dev Safely transfers `tokenId` token from `from` to `to`.
61      *
62      * Requirements:
63      *
64      * - `from` cannot be the zero address.
65      * - `to` cannot be the zero address.
66      * - `tokenId` token must exist and be owned by `from`.
67      * - If the caller is not `from`, it must be approved to move this token by either {approve} or {setApprovalForAll}.
68      * - If `to` refers to a smart contract, it must implement {IERC721Receiver-onERC721Received}, which is called upon a safe transfer.
69      *
70      * Emits a {Transfer} event.
71      */
72     function safeTransferFrom(
73         address from,
74         address to,
75         uint256 tokenId,
76         bytes calldata data
77     ) external;
78 
79     /**
80      * @dev Safely transfers `tokenId` token from `from` to `to`, checking first that contract recipients
81      * are aware of the ERC721 protocol to prevent tokens from being forever locked.
82      *
83      * Requirements:
84      *
85      * - `from` cannot be the zero address.
86      * - `to` cannot be the zero address.
87      * - `tokenId` token must exist and be owned by `from`.
88      * - If the caller is not `from`, it must have been allowed to move this token by either {approve} or {setApprovalForAll}.
89      * - If `to` refers to a smart contract, it must implement {IERC721Receiver-onERC721Received}, which is called upon a safe transfer.
90      *
91      * Emits a {Transfer} event.
92      */
93     function safeTransferFrom(
94         address from,
95         address to,
96         uint256 tokenId
97     ) external;
98 
99     /**
100      * @dev Transfers `tokenId` token from `from` to `to`.
101      *
102      * WARNING: Usage of this method is discouraged, use {safeTransferFrom} whenever possible.
103      *
104      * Requirements:
105      *
106      * - `from` cannot be the zero address.
107      * - `to` cannot be the zero address.
108      * - `tokenId` token must be owned by `from`.
109      * - If the caller is not `from`, it must be approved to move this token by either {approve} or {setApprovalForAll}.
110      *
111      * Emits a {Transfer} event.
112      */
113     function transferFrom(
114         address from,
115         address to,
116         uint256 tokenId
117     ) external;
118 
119     /**
120      * @dev Gives permission to `to` to transfer `tokenId` token to another account.
121      * The approval is cleared when the token is transferred.
122      *
123      * Only a single account can be approved at a time, so approving the zero address clears previous approvals.
124      *
125      * Requirements:
126      *
127      * - The caller must own the token or be an approved operator.
128      * - `tokenId` must exist.
129      *
130      * Emits an {Approval} event.
131      */
132     function approve(address to, uint256 tokenId) external;
133 
134     /**
135      * @dev Approve or remove `operator` as an operator for the caller.
136      * Operators can call {transferFrom} or {safeTransferFrom} for any token owned by the caller.
137      *
138      * Requirements:
139      *
140      * - The `operator` cannot be the caller.
141      *
142      * Emits an {ApprovalForAll} event.
143      */
144     function setApprovalForAll(address operator, bool _approved) external;
145 
146     /**
147      * @dev Returns the account approved for `tokenId` token.
148      *
149      * Requirements:
150      *
151      * - `tokenId` must exist.
152      */
153     function getApproved(uint256 tokenId) external view returns (address operator);
154 
155     /**
156      * @dev Returns if the `operator` is allowed to manage all of the assets of `owner`.
157      *
158      * See {setApprovalForAll}
159      */
160     function isApprovedForAll(address owner, address operator) external view returns (bool);
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
177      * The selector can be obtained in Solidity with `IERC721Receiver.onERC721Received.selector`.
178      */
179     function onERC721Received(
180         address operator,
181         address from,
182         uint256 tokenId,
183         bytes calldata data
184     ) external returns (bytes4);
185 }
186 
187 /**
188  * @title ERC-721 Non-Fungible Token Standard, optional metadata extension
189  * @dev See https://eips.ethereum.org/EIPS/eip-721
190  */
191 interface IERC721Metadata is IERC721 {
192     /**
193      * @dev Returns the token collection name.
194      */
195     function name() external view returns (string memory);
196 
197     /**
198      * @dev Returns the token collection symbol.
199      */
200     function symbol() external view returns (string memory);
201 
202     /**
203      * @dev Returns the Uniform Resource Identifier (URI) for `tokenId` token.
204      */
205     function tokenURI(uint256 tokenId) external view returns (string memory);
206 }
207 
208 /**
209  * @dev Collection of functions related to the address type
210  */
211 library Address {
212     /**
213      * @dev Returns true if `account` is a contract.
214      *
215      * [IMPORTANT]
216      * ====
217      * It is unsafe to assume that an address for which this function returns
218      * false is an externally-owned account (EOA) and not a contract.
219      *
220      * Among others, `isContract` will return false for the following
221      * types of addresses:
222      *
223      *  - an externally-owned account
224      *  - a contract in construction
225      *  - an address where a contract will be created
226      *  - an address where a contract lived, but was destroyed
227      * ====
228      *
229      * [IMPORTANT]
230      * ====
231      * You shouldn't rely on `isContract` to protect against flash loan attacks!
232      *
233      * Preventing calls from contracts is highly discouraged. It breaks composability, breaks support for smart wallets
234      * like Gnosis Safe, and does not provide security since it can be circumvented by calling from a contract
235      * constructor.
236      * ====
237      */
238     function isContract(address account) internal view returns (bool) {
239         // This method relies on extcodesize/address.code.length, which returns 0
240         // for contracts in construction, since the code is only stored at the end
241         // of the constructor execution.
242 
243         return account.code.length > 0;
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
414                 /// @solidity memory-safe-assembly
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
446 /**
447  * @dev String operations.
448  */
449 library Strings {
450     bytes16 private constant _HEX_SYMBOLS = "0123456789abcdef";
451     uint8 private constant _ADDRESS_LENGTH = 20;
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
508 
509     /**
510      * @dev Converts an `address` with fixed length of 20 bytes to its not checksummed ASCII `string` hexadecimal representation.
511      */
512     function toHexString(address addr) internal pure returns (string memory) {
513         return toHexString(uint256(uint160(addr)), _ADDRESS_LENGTH);
514     }
515 }
516 
517 /**
518  * @dev Implementation of the {IERC165} interface.
519  *
520  * Contracts that want to implement ERC165 should inherit from this contract and override {supportsInterface} to check
521  * for the additional interface id that will be supported. For example:
522  *
523  * ```solidity
524  * function supportsInterface(bytes4 interfaceId) public view virtual override returns (bool) {
525  *     return interfaceId == type(MyInterface).interfaceId || super.supportsInterface(interfaceId);
526  * }
527  * ```
528  *
529  * Alternatively, {ERC165Storage} provides an easier to use but more expensive implementation.
530  */
531 abstract contract ERC165 is IERC165 {
532     /**
533      * @dev See {IERC165-supportsInterface}.
534      */
535     function supportsInterface(bytes4 interfaceId) public view virtual override returns (bool) {
536         return interfaceId == type(IERC165).interfaceId;
537     }
538 }
539 
540 
541 /**
542  * @dev Implementation of https://eips.ethereum.org/EIPS/eip-721[ERC721] Non-Fungible Token Standard, including
543  * the Metadata extension, but not including the Enumerable extension, which is available separately as
544  * {ERC721Enumerable}.
545  */
546 contract ERC721 is Context, ERC165, IERC721, IERC721Metadata {
547     using Address for address;
548     using Strings for uint256;
549 
550     // Token name
551     string private _name;
552 
553     // Token symbol
554     string private _symbol;
555 
556     // Mapping from token ID to owner address
557     mapping(uint256 => address) private _owners;
558 
559     // Mapping owner address to token count
560     mapping(address => uint256) private _balances;
561 
562     // Mapping from token ID to approved address
563     mapping(uint256 => address) private _tokenApprovals;
564 
565     // Mapping from owner to operator approvals
566     mapping(address => mapping(address => bool)) private _operatorApprovals;
567 
568     /**
569      * @dev Initializes the contract by setting a `name` and a `symbol` to the token collection.
570      */
571     constructor(string memory name_, string memory symbol_) {
572         _name = name_;
573         _symbol = symbol_;
574     }
575 
576     /**
577      * @dev See {IERC165-supportsInterface}.
578      */
579     function supportsInterface(bytes4 interfaceId) public view virtual override(ERC165, IERC165) returns (bool) {
580         return
581             interfaceId == type(IERC721).interfaceId ||
582             interfaceId == type(IERC721Metadata).interfaceId ||
583             super.supportsInterface(interfaceId);
584     }
585 
586     /**
587      * @dev See {IERC721-balanceOf}.
588      */
589     function balanceOf(address owner) public view virtual override returns (uint256) {
590         require(owner != address(0), "ERC721: address zero is not a valid owner");
591         return _balances[owner];
592     }
593 
594     /**
595      * @dev See {IERC721-ownerOf}.
596      */
597     function ownerOf(uint256 tokenId) public view virtual override returns (address) {
598         address owner = _owners[tokenId];
599         require(owner != address(0), "ERC721: invalid token ID");
600         return owner;
601     }
602 
603     /**
604      * @dev See {IERC721Metadata-name}.
605      */
606     function name() public view virtual override returns (string memory) {
607         return _name;
608     }
609 
610     /**
611      * @dev See {IERC721Metadata-symbol}.
612      */
613     function symbol() public view virtual override returns (string memory) {
614         return _symbol;
615     }
616 
617     /**
618      * @dev See {IERC721Metadata-tokenURI}.
619      */
620     function tokenURI(uint256 tokenId) public view virtual override returns (string memory) {
621         _requireMinted(tokenId);
622 
623         string memory baseURI = _baseURI();
624         return bytes(baseURI).length > 0 ? string(abi.encodePacked(baseURI, tokenId.toString())) : "";
625     }
626 
627     /**
628      * @dev Base URI for computing {tokenURI}. If set, the resulting URI for each
629      * token will be the concatenation of the `baseURI` and the `tokenId`. Empty
630      * by default, can be overridden in child contracts.
631      */
632     function _baseURI() internal view virtual returns (string memory) {
633         return "";
634     }
635 
636     /**
637      * @dev See {IERC721-approve}.
638      */
639     function approve(address to, uint256 tokenId) public virtual override {
640         address owner = ERC721.ownerOf(tokenId);
641         require(to != owner, "ERC721: approval to current owner");
642 
643         require(
644             _msgSender() == owner || isApprovedForAll(owner, _msgSender()),
645             "ERC721: approve caller is not token owner nor approved for all"
646         );
647 
648         _approve(to, tokenId);
649     }
650 
651     /**
652      * @dev See {IERC721-getApproved}.
653      */
654     function getApproved(uint256 tokenId) public view virtual override returns (address) {
655         _requireMinted(tokenId);
656 
657         return _tokenApprovals[tokenId];
658     }
659 
660     /**
661      * @dev See {IERC721-setApprovalForAll}.
662      */
663     function setApprovalForAll(address operator, bool approved) public virtual override {
664         _setApprovalForAll(_msgSender(), operator, approved);
665     }
666 
667     /**
668      * @dev See {IERC721-isApprovedForAll}.
669      */
670     function isApprovedForAll(address owner, address operator) public view virtual override returns (bool) {
671         return _operatorApprovals[owner][operator];
672     }
673 
674     /**
675      * @dev See {IERC721-transferFrom}.
676      */
677     function transferFrom(
678         address from,
679         address to,
680         uint256 tokenId
681     ) public virtual override {
682         //solhint-disable-next-line max-line-length
683         require(_isApprovedOrOwner(_msgSender(), tokenId), "ERC721: caller is not token owner nor approved");
684 
685         _transfer(from, to, tokenId);
686     }
687 
688     /**
689      * @dev See {IERC721-safeTransferFrom}.
690      */
691     function safeTransferFrom(
692         address from,
693         address to,
694         uint256 tokenId
695     ) public virtual override {
696         safeTransferFrom(from, to, tokenId, "");
697     }
698 
699     /**
700      * @dev See {IERC721-safeTransferFrom}.
701      */
702     function safeTransferFrom(
703         address from,
704         address to,
705         uint256 tokenId,
706         bytes memory data
707     ) public virtual override {
708         require(_isApprovedOrOwner(_msgSender(), tokenId), "ERC721: caller is not token owner nor approved");
709         _safeTransfer(from, to, tokenId, data);
710     }
711 
712     /**
713      * @dev Safely transfers `tokenId` token from `from` to `to`, checking first that contract recipients
714      * are aware of the ERC721 protocol to prevent tokens from being forever locked.
715      *
716      * `data` is additional data, it has no specified format and it is sent in call to `to`.
717      *
718      * This internal function is equivalent to {safeTransferFrom}, and can be used to e.g.
719      * implement alternative mechanisms to perform token transfer, such as signature-based.
720      *
721      * Requirements:
722      *
723      * - `from` cannot be the zero address.
724      * - `to` cannot be the zero address.
725      * - `tokenId` token must exist and be owned by `from`.
726      * - If `to` refers to a smart contract, it must implement {IERC721Receiver-onERC721Received}, which is called upon a safe transfer.
727      *
728      * Emits a {Transfer} event.
729      */
730     function _safeTransfer(
731         address from,
732         address to,
733         uint256 tokenId,
734         bytes memory data
735     ) internal virtual {
736         _transfer(from, to, tokenId);
737         require(_checkOnERC721Received(from, to, tokenId, data), "ERC721: transfer to non ERC721Receiver implementer");
738     }
739 
740     /**
741      * @dev Returns whether `tokenId` exists.
742      *
743      * Tokens can be managed by their owner or approved accounts via {approve} or {setApprovalForAll}.
744      *
745      * Tokens start existing when they are minted (`_mint`),
746      * and stop existing when they are burned (`_burn`).
747      */
748     function _exists(uint256 tokenId) internal view virtual returns (bool) {
749         return _owners[tokenId] != address(0);
750     }
751 
752     /**
753      * @dev Returns whether `spender` is allowed to manage `tokenId`.
754      *
755      * Requirements:
756      *
757      * - `tokenId` must exist.
758      */
759     function _isApprovedOrOwner(address spender, uint256 tokenId) internal view virtual returns (bool) {
760         address owner = ERC721.ownerOf(tokenId);
761         return (spender == owner || isApprovedForAll(owner, spender) || getApproved(tokenId) == spender);
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
785         bytes memory data
786     ) internal virtual {
787         _mint(to, tokenId);
788         require(
789             _checkOnERC721Received(address(0), to, tokenId, data),
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
816 
817         _afterTokenTransfer(address(0), to, tokenId);
818     }
819 
820     /**
821      * @dev Destroys `tokenId`.
822      * The approval is cleared when the token is burned.
823      *
824      * Requirements:
825      *
826      * - `tokenId` must exist.
827      *
828      * Emits a {Transfer} event.
829      */
830     function _burn(uint256 tokenId) internal virtual {
831         address owner = ERC721.ownerOf(tokenId);
832 
833         _beforeTokenTransfer(owner, address(0), tokenId);
834 
835         // Clear approvals
836         _approve(address(0), tokenId);
837 
838         _balances[owner] -= 1;
839         delete _owners[tokenId];
840 
841         emit Transfer(owner, address(0), tokenId);
842 
843         _afterTokenTransfer(owner, address(0), tokenId);
844     }
845 
846     /**
847      * @dev Transfers `tokenId` from `from` to `to`.
848      *  As opposed to {transferFrom}, this imposes no restrictions on msg.sender.
849      *
850      * Requirements:
851      *
852      * - `to` cannot be the zero address.
853      * - `tokenId` token must be owned by `from`.
854      *
855      * Emits a {Transfer} event.
856      */
857     function _transfer(
858         address from,
859         address to,
860         uint256 tokenId
861     ) internal virtual {
862         require(ERC721.ownerOf(tokenId) == from, "ERC721: transfer from incorrect owner");
863         require(to != address(0), "ERC721: transfer to the zero address");
864 
865         _beforeTokenTransfer(from, to, tokenId);
866 
867         // Clear approvals from the previous owner
868         _approve(address(0), tokenId);
869 
870         _balances[from] -= 1;
871         _balances[to] += 1;
872         _owners[tokenId] = to;
873 
874         emit Transfer(from, to, tokenId);
875 
876         _afterTokenTransfer(from, to, tokenId);
877     }
878 
879     /**
880      * @dev Approve `to` to operate on `tokenId`
881      *
882      * Emits an {Approval} event.
883      */
884     function _approve(address to, uint256 tokenId) internal virtual {
885         _tokenApprovals[tokenId] = to;
886         emit Approval(ERC721.ownerOf(tokenId), to, tokenId);
887     }
888 
889     /**
890      * @dev Approve `operator` to operate on all of `owner` tokens
891      *
892      * Emits an {ApprovalForAll} event.
893      */
894     function _setApprovalForAll(
895         address owner,
896         address operator,
897         bool approved
898     ) internal virtual {
899         require(owner != operator, "ERC721: approve to caller");
900         _operatorApprovals[owner][operator] = approved;
901         emit ApprovalForAll(owner, operator, approved);
902     }
903 
904     /**
905      * @dev Reverts if the `tokenId` has not been minted yet.
906      */
907     function _requireMinted(uint256 tokenId) internal view virtual {
908         require(_exists(tokenId), "ERC721: invalid token ID");
909     }
910 
911     /**
912      * @dev Internal function to invoke {IERC721Receiver-onERC721Received} on a target address.
913      * The call is not executed if the target address is not a contract.
914      *
915      * @param from address representing the previous owner of the given token ID
916      * @param to target address that will receive the tokens
917      * @param tokenId uint256 ID of the token to be transferred
918      * @param data bytes optional data to send along with the call
919      * @return bool whether the call correctly returned the expected magic value
920      */
921     function _checkOnERC721Received(
922         address from,
923         address to,
924         uint256 tokenId,
925         bytes memory data
926     ) private returns (bool) {
927         if (to.isContract()) {
928             try IERC721Receiver(to).onERC721Received(_msgSender(), from, tokenId, data) returns (bytes4 retval) {
929                 return retval == IERC721Receiver.onERC721Received.selector;
930             } catch (bytes memory reason) {
931                 if (reason.length == 0) {
932                     revert("ERC721: transfer to non ERC721Receiver implementer");
933                 } else {
934                     /// @solidity memory-safe-assembly
935                     assembly {
936                         revert(add(32, reason), mload(reason))
937                     }
938                 }
939             }
940         } else {
941             return true;
942         }
943     }
944 
945     /**
946      * @dev Hook that is called before any token transfer. This includes minting
947      * and burning.
948      *
949      * Calling conditions:
950      *
951      * - When `from` and `to` are both non-zero, ``from``'s `tokenId` will be
952      * transferred to `to`.
953      * - When `from` is zero, `tokenId` will be minted for `to`.
954      * - When `to` is zero, ``from``'s `tokenId` will be burned.
955      * - `from` and `to` are never both zero.
956      *
957      * To learn more about hooks, head to xref:ROOT:extending-contracts.adoc#using-hooks[Using Hooks].
958      */
959     function _beforeTokenTransfer(
960         address from,
961         address to,
962         uint256 tokenId
963     ) internal virtual {}
964 
965     /**
966      * @dev Hook that is called after any transfer of tokens. This includes
967      * minting and burning.
968      *
969      * Calling conditions:
970      *
971      * - when `from` and `to` are both non-zero.
972      * - `from` and `to` are never both zero.
973      *
974      * To learn more about hooks, head to xref:ROOT:extending-contracts.adoc#using-hooks[Using Hooks].
975      */
976     function _afterTokenTransfer(
977         address from,
978         address to,
979         uint256 tokenId
980     ) internal virtual {}
981 }
982 
983 /**
984  * @title Counters
985  * @author Matt Condon (@shrugs)
986  * @dev Provides counters that can only be incremented, decremented or reset. This can be used e.g. to track the number
987  * of elements in a mapping, issuing ERC721 ids, or counting request ids.
988  *
989  * Include with `using Counters for Counters.Counter;`
990  */
991 library Counters {
992     struct Counter {
993         // This variable should never be directly accessed by users of the library: interactions must be restricted to
994         // the library's function. As of Solidity v0.5.2, this cannot be enforced, though there is a proposal to add
995         // this feature: see https://github.com/ethereum/solidity/issues/4637
996         uint256 _value; // default: 0
997     }
998 
999     function current(Counter storage counter) internal view returns (uint256) {
1000         return counter._value;
1001     }
1002 
1003     function increment(Counter storage counter) internal {
1004         unchecked {
1005             counter._value += 1;
1006         }
1007     }
1008 
1009     function decrement(Counter storage counter) internal {
1010         uint256 value = counter._value;
1011         require(value > 0, "Counter: decrement overflow");
1012         unchecked {
1013             counter._value = value - 1;
1014         }
1015     }
1016 
1017     function reset(Counter storage counter) internal {
1018         counter._value = 0;
1019     }
1020 }
1021 
1022 /**
1023  * @dev Contract module which provides a basic access control mechanism, where
1024  * there is an account (an owner) that can be granted exclusive access to
1025  * specific functions.
1026  *
1027  * By default, the owner account will be the one that deploys the contract. This
1028  * can later be changed with {transferOwnership}.
1029  *
1030  * This module is used through inheritance. It will make available the modifier
1031  * `onlyOwner`, which can be applied to your functions to restrict their use to
1032  * the owner.
1033  */
1034 abstract contract Ownable is Context {
1035     address private _owner;
1036 
1037     event OwnershipTransferred(address indexed previousOwner, address indexed newOwner);
1038 
1039     /**
1040      * @dev Initializes the contract setting the deployer as the initial owner.
1041      */
1042     constructor() {
1043         _transferOwnership(_msgSender());
1044     }
1045 
1046     /**
1047      * @dev Throws if called by any account other than the owner.
1048      */
1049     modifier onlyOwner() {
1050         _checkOwner();
1051         _;
1052     }
1053 
1054     /**
1055      * @dev Returns the address of the current owner.
1056      */
1057     function owner() public view virtual returns (address) {
1058         return _owner;
1059     }
1060 
1061     /**
1062      * @dev Throws if the sender is not the owner.
1063      */
1064     function _checkOwner() internal view virtual {
1065         require(owner() == _msgSender(), "Ownable: caller is not the owner");
1066     }
1067 
1068     /**
1069      * @dev Leaves the contract without owner. It will not be possible to call
1070      * `onlyOwner` functions anymore. Can only be called by the current owner.
1071      *
1072      * NOTE: Renouncing ownership will leave the contract without an owner,
1073      * thereby removing any functionality that is only available to the owner.
1074      */
1075     function renounceOwnership() public virtual onlyOwner {
1076         _transferOwnership(address(0));
1077     }
1078 
1079     /**
1080      * @dev Transfers ownership of the contract to a new account (`newOwner`).
1081      * Can only be called by the current owner.
1082      */
1083     function transferOwnership(address newOwner) public virtual onlyOwner {
1084         require(newOwner != address(0), "Ownable: new owner is the zero address");
1085         _transferOwnership(newOwner);
1086     }
1087 
1088     /**
1089      * @dev Transfers ownership of the contract to a new account (`newOwner`).
1090      * Internal function without access restriction.
1091      */
1092     function _transferOwnership(address newOwner) internal virtual {
1093         address oldOwner = _owner;
1094         _owner = newOwner;
1095         emit OwnershipTransferred(oldOwner, newOwner);
1096     }
1097 }
1098 
1099 // CAUTION
1100 // This version of SafeMath should only be used with Solidity 0.8 or later,
1101 // because it relies on the compiler's built in overflow checks.
1102 
1103 /**
1104  * @dev Wrappers over Solidity's arithmetic operations.
1105  *
1106  * NOTE: `SafeMath` is generally not needed starting with Solidity 0.8, since the compiler
1107  * now has built in overflow checking.
1108  */
1109 library SafeMath {
1110     /**
1111      * @dev Returns the addition of two unsigned integers, with an overflow flag.
1112      *
1113      * _Available since v3.4._
1114      */
1115     function tryAdd(uint256 a, uint256 b) internal pure returns (bool, uint256) {
1116         unchecked {
1117             uint256 c = a + b;
1118             if (c < a) return (false, 0);
1119             return (true, c);
1120         }
1121     }
1122 
1123     /**
1124      * @dev Returns the subtraction of two unsigned integers, with an overflow flag.
1125      *
1126      * _Available since v3.4._
1127      */
1128     function trySub(uint256 a, uint256 b) internal pure returns (bool, uint256) {
1129         unchecked {
1130             if (b > a) return (false, 0);
1131             return (true, a - b);
1132         }
1133     }
1134 
1135     /**
1136      * @dev Returns the multiplication of two unsigned integers, with an overflow flag.
1137      *
1138      * _Available since v3.4._
1139      */
1140     function tryMul(uint256 a, uint256 b) internal pure returns (bool, uint256) {
1141         unchecked {
1142             // Gas optimization: this is cheaper than requiring 'a' not being zero, but the
1143             // benefit is lost if 'b' is also tested.
1144             // See: https://github.com/OpenZeppelin/openzeppelin-contracts/pull/522
1145             if (a == 0) return (true, 0);
1146             uint256 c = a * b;
1147             if (c / a != b) return (false, 0);
1148             return (true, c);
1149         }
1150     }
1151 
1152     /**
1153      * @dev Returns the division of two unsigned integers, with a division by zero flag.
1154      *
1155      * _Available since v3.4._
1156      */
1157     function tryDiv(uint256 a, uint256 b) internal pure returns (bool, uint256) {
1158         unchecked {
1159             if (b == 0) return (false, 0);
1160             return (true, a / b);
1161         }
1162     }
1163 
1164     /**
1165      * @dev Returns the remainder of dividing two unsigned integers, with a division by zero flag.
1166      *
1167      * _Available since v3.4._
1168      */
1169     function tryMod(uint256 a, uint256 b) internal pure returns (bool, uint256) {
1170         unchecked {
1171             if (b == 0) return (false, 0);
1172             return (true, a % b);
1173         }
1174     }
1175 
1176     /**
1177      * @dev Returns the addition of two unsigned integers, reverting on
1178      * overflow.
1179      *
1180      * Counterpart to Solidity's `+` operator.
1181      *
1182      * Requirements:
1183      *
1184      * - Addition cannot overflow.
1185      */
1186     function add(uint256 a, uint256 b) internal pure returns (uint256) {
1187         return a + b;
1188     }
1189 
1190     /**
1191      * @dev Returns the subtraction of two unsigned integers, reverting on
1192      * overflow (when the result is negative).
1193      *
1194      * Counterpart to Solidity's `-` operator.
1195      *
1196      * Requirements:
1197      *
1198      * - Subtraction cannot overflow.
1199      */
1200     function sub(uint256 a, uint256 b) internal pure returns (uint256) {
1201         return a - b;
1202     }
1203 
1204     /**
1205      * @dev Returns the multiplication of two unsigned integers, reverting on
1206      * overflow.
1207      *
1208      * Counterpart to Solidity's `*` operator.
1209      *
1210      * Requirements:
1211      *
1212      * - Multiplication cannot overflow.
1213      */
1214     function mul(uint256 a, uint256 b) internal pure returns (uint256) {
1215         return a * b;
1216     }
1217 
1218     /**
1219      * @dev Returns the integer division of two unsigned integers, reverting on
1220      * division by zero. The result is rounded towards zero.
1221      *
1222      * Counterpart to Solidity's `/` operator.
1223      *
1224      * Requirements:
1225      *
1226      * - The divisor cannot be zero.
1227      */
1228     function div(uint256 a, uint256 b) internal pure returns (uint256) {
1229         return a / b;
1230     }
1231 
1232     /**
1233      * @dev Returns the remainder of dividing two unsigned integers. (unsigned integer modulo),
1234      * reverting when dividing by zero.
1235      *
1236      * Counterpart to Solidity's `%` operator. This function uses a `revert`
1237      * opcode (which leaves remaining gas untouched) while Solidity uses an
1238      * invalid opcode to revert (consuming all remaining gas).
1239      *
1240      * Requirements:
1241      *
1242      * - The divisor cannot be zero.
1243      */
1244     function mod(uint256 a, uint256 b) internal pure returns (uint256) {
1245         return a % b;
1246     }
1247 
1248     /**
1249      * @dev Returns the subtraction of two unsigned integers, reverting with custom message on
1250      * overflow (when the result is negative).
1251      *
1252      * CAUTION: This function is deprecated because it requires allocating memory for the error
1253      * message unnecessarily. For custom revert reasons use {trySub}.
1254      *
1255      * Counterpart to Solidity's `-` operator.
1256      *
1257      * Requirements:
1258      *
1259      * - Subtraction cannot overflow.
1260      */
1261     function sub(
1262         uint256 a,
1263         uint256 b,
1264         string memory errorMessage
1265     ) internal pure returns (uint256) {
1266         unchecked {
1267             require(b <= a, errorMessage);
1268             return a - b;
1269         }
1270     }
1271 
1272     /**
1273      * @dev Returns the integer division of two unsigned integers, reverting with custom message on
1274      * division by zero. The result is rounded towards zero.
1275      *
1276      * Counterpart to Solidity's `/` operator. Note: this function uses a
1277      * `revert` opcode (which leaves remaining gas untouched) while Solidity
1278      * uses an invalid opcode to revert (consuming all remaining gas).
1279      *
1280      * Requirements:
1281      *
1282      * - The divisor cannot be zero.
1283      */
1284     function div(
1285         uint256 a,
1286         uint256 b,
1287         string memory errorMessage
1288     ) internal pure returns (uint256) {
1289         unchecked {
1290             require(b > 0, errorMessage);
1291             return a / b;
1292         }
1293     }
1294 
1295     /**
1296      * @dev Returns the remainder of dividing two unsigned integers. (unsigned integer modulo),
1297      * reverting with custom message when dividing by zero.
1298      *
1299      * CAUTION: This function is deprecated because it requires allocating memory for the error
1300      * message unnecessarily. For custom revert reasons use {tryMod}.
1301      *
1302      * Counterpart to Solidity's `%` operator. This function uses a `revert`
1303      * opcode (which leaves remaining gas untouched) while Solidity uses an
1304      * invalid opcode to revert (consuming all remaining gas).
1305      *
1306      * Requirements:
1307      *
1308      * - The divisor cannot be zero.
1309      */
1310     function mod(
1311         uint256 a,
1312         uint256 b,
1313         string memory errorMessage
1314     ) internal pure returns (uint256) {
1315         unchecked {
1316             require(b > 0, errorMessage);
1317             return a % b;
1318         }
1319     }
1320 }
1321 
1322 interface Whitelist {
1323     function _whitlisted(address account) external view returns (bool);
1324 } 
1325 
1326 contract BridgeKeepers is ERC721, Ownable {
1327     using Strings for uint256;
1328     using SafeMath for uint256;
1329     using Counters for Counters.Counter;
1330     
1331 	Whitelist private _Whitelist = Whitelist(0xb35bB4d6Fbc83812ec4ABc19203721D4CA857a11);
1332     Counters.Counter private _tokenIdTracker;
1333     mapping (uint256 => string) private _tokenURIs;
1334     mapping (string => address) private _tokenIDs;
1335     mapping (address => uint) public _whitlistedBuy;
1336     mapping (address => uint) public _publicBuy;
1337     
1338     address private constant CreatorAddress = 0xf99613B4AE868b1aB1219Ba4FAf933DA928EA8ec;
1339 
1340     string private baseURIextended;
1341     uint256 private constant min_price = 1 ether;
1342     uint256 private maxSupply = 500;
1343     uint256 public publicTime;
1344     uint256 private whitelistedTime = 6 hours;
1345     uint whitelistedMaxBuy = 5;
1346     uint publicMaxBuy = 5;
1347     
1348     
1349     bool private pause = false;
1350 
1351     event NFTMinted(uint256 indexed tokenId, address owner, address to, string tokenURI);
1352     event NFTMintTransfered(address to, uint value);
1353 
1354     constructor(string memory _baseURIextended, uint256 _publicTime ) ERC721("BRIDGE KEEPERS", "BKS"){
1355         baseURIextended = _baseURIextended;
1356         publicTime = _publicTime;
1357     }
1358     
1359     function _setTokenURI(uint256 tokenId, string memory _tokenURI) internal virtual {
1360         require(_exists(tokenId), "URI set of nonexistent token");
1361         _tokenURIs[tokenId] = _tokenURI;
1362     }
1363     
1364     function revealCollection(string memory _baseURIextended) public onlyOwner {
1365         require(keccak256(bytes(baseURIextended)) != keccak256(bytes(_baseURIextended)), "Collection already revealed");
1366         setBaseURI(_baseURIextended);
1367     }
1368 
1369     function setBaseURI(string memory _baseURIextended) private onlyOwner {
1370         baseURIextended = _baseURIextended;
1371     }
1372 
1373     function setMaxSupply(uint256 _maxSupply) public onlyOwner {
1374         maxSupply = _maxSupply;
1375     }
1376     
1377     function setPause(bool _pause) public onlyOwner {
1378         pause = _pause;
1379     }
1380 
1381     function getPause() public view virtual returns (bool) {
1382         return pause;
1383     }
1384     
1385     function _baseURI() internal view virtual override returns (string memory) {
1386         return baseURIextended;
1387     }
1388 
1389     function burn(uint256 tokenId) public onlyOwner {
1390         require(_exists(tokenId), "URI query for nonexistent token");
1391         _tokenIDs[_tokenURIs[tokenId]] = address(0);
1392         _tokenURIs[tokenId] = "";
1393         _burn(tokenId);
1394     }
1395     
1396     function tokenURI(uint256 tokenId) public view virtual override returns (string memory) {
1397         require(_exists(tokenId), "URI query for nonexistent token");
1398 
1399         string memory _tokenURI = _tokenURIs[tokenId];
1400         string memory base = _baseURI();
1401 
1402         return string(abi.encodePacked(base, _tokenURI));
1403     }
1404 	
1405 	
1406     function setWhitelistedMaxBuy(uint256 _whitelistedMaxBuy) public onlyOwner {
1407         whitelistedMaxBuy = _whitelistedMaxBuy;
1408     }
1409 
1410     function setPublicMaxBuy(uint256 _publicMaxBuy) public onlyOwner {
1411         publicMaxBuy = _publicMaxBuy;
1412     }
1413 
1414 
1415 
1416     function mint(address _to, string[] memory _tokensURI, uint256 _deadline) public payable {
1417         require(!pause, "Sales paused");
1418         require(msg.value >= min_price.mul(_tokensURI.length), "Value below price");
1419         require(maxSupply >= _tokenIdTracker.current() + _tokensURI.length, "SoldOut");
1420         require(_tokensURI.length > 0, "Minimum count");
1421 
1422 
1423         require(_deadline >= block.timestamp - 300, "Out of time");
1424 		
1425 		if(publicTime > block.timestamp){
1426             if(_Whitelist._whitlisted(msg.sender)){
1427 		    	require(block.timestamp >= publicTime - whitelistedTime, "Mint not opened yet for whitelisted");
1428                 require(whitelistedMaxBuy >= _tokensURI.length, "Max Buy Limit");
1429                 require(whitelistedMaxBuy >= _whitlistedBuy[msg.sender] + _tokensURI.length, "Max Buy Limit");
1430 		    } else {
1431                 require(block.timestamp >= publicTime, "Mint not opened yet for public");
1432 		    }
1433 		} else {
1434             require(block.timestamp >= publicTime, "Mint not opened yet for public");
1435             require(publicMaxBuy >= _tokensURI.length, "Max Buy Limit");
1436             require(publicMaxBuy >= _publicBuy[msg.sender] + _tokensURI.length, "Max Buy Limit");
1437 		}
1438 		
1439         
1440         _mintAnElement(_to, _tokensURI[0]);
1441         
1442 		
1443 	
1444 		if(publicTime > block.timestamp){
1445 		    _whitlistedBuy[msg.sender] += 1;
1446 		} else {
1447 		    _publicBuy[msg.sender] += 1;
1448 		}
1449 		
1450 		transfer(CreatorAddress, msg.value);
1451     }
1452 
1453     function _mintAnElement(address _to, string memory _tokenURI) private {
1454         uint256 _tokenId = _tokenIdTracker.current();
1455         
1456         _tokenIdTracker.increment();
1457         _tokenId = _tokenId + 1;
1458         _mint(_to, _tokenId);
1459         _setTokenURI(_tokenId, _tokenURI);
1460         _tokenIDs[_tokenURI] = _to;
1461 
1462         emit NFTMinted(_tokenId, CreatorAddress, _to, _tokenURI);
1463     }
1464 
1465     function transfer(address to, uint256 value) private {
1466         (bool success, ) = to.call{value: value}("");
1467         require(success, "Transfer failed.");
1468         emit NFTMintTransfered(to, value);
1469     }
1470 }