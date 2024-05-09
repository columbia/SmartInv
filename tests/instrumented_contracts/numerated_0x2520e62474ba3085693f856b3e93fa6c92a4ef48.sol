1 // SPDX-License-Identifier: UNLICENSED
2 
3 pragma solidity 0.8.15;
4 
5 /* This contract is a subsidiary of the Icosa contract. The Icosa        *
6  *  contract can be found at 0xfc4913214444aF5c715cc9F7b52655e788A569ed. */
7 
8 /* Icosa is a collection of Ethereum / PulseChain smart contracts that  *
9  * build upon the Hedron smart contract to provide additional functionality */
10 
11 /**
12  * @dev Interface of the ERC165 standard, as defined in the
13  * https://eips.ethereum.org/EIPS/eip-165[EIP].
14  *
15  * Implementers can declare support of contract interfaces, which can then be
16  * queried by others ({ERC165Checker}).
17  *
18  * For an implementation, see {ERC165}.
19  */
20 interface IERC165 {
21     /**
22      * @dev Returns true if this contract implements the interface defined by
23      * `interfaceId`. See the corresponding
24      * https://eips.ethereum.org/EIPS/eip-165#how-interfaces-are-identified[EIP section]
25      * to learn more about how these ids are created.
26      *
27      * This function call must use less than 30 000 gas.
28      */
29     function supportsInterface(bytes4 interfaceId) external view returns (bool);
30 }
31 
32 /**
33  * @dev Required interface of an ERC721 compliant contract.
34  */
35 interface IERC721 is IERC165 {
36     /**
37      * @dev Emitted when `tokenId` token is transferred from `from` to `to`.
38      */
39     event Transfer(address indexed from, address indexed to, uint256 indexed tokenId);
40 
41     /**
42      * @dev Emitted when `owner` enables `approved` to manage the `tokenId` token.
43      */
44     event Approval(address indexed owner, address indexed approved, uint256 indexed tokenId);
45 
46     /**
47      * @dev Emitted when `owner` enables or disables (`approved`) `operator` to manage all of its assets.
48      */
49     event ApprovalForAll(address indexed owner, address indexed operator, bool approved);
50 
51     /**
52      * @dev Returns the number of tokens in ``owner``'s account.
53      */
54     function balanceOf(address owner) external view returns (uint256 balance);
55 
56     /**
57      * @dev Returns the owner of the `tokenId` token.
58      *
59      * Requirements:
60      *
61      * - `tokenId` must exist.
62      */
63     function ownerOf(uint256 tokenId) external view returns (address owner);
64 
65     /**
66      * @dev Safely transfers `tokenId` token from `from` to `to`.
67      *
68      * Requirements:
69      *
70      * - `from` cannot be the zero address.
71      * - `to` cannot be the zero address.
72      * - `tokenId` token must exist and be owned by `from`.
73      * - If the caller is not `from`, it must be approved to move this token by either {approve} or {setApprovalForAll}.
74      * - If `to` refers to a smart contract, it must implement {IERC721Receiver-onERC721Received}, which is called upon a safe transfer.
75      *
76      * Emits a {Transfer} event.
77      */
78     function safeTransferFrom(
79         address from,
80         address to,
81         uint256 tokenId,
82         bytes calldata data
83     ) external;
84 
85     /**
86      * @dev Safely transfers `tokenId` token from `from` to `to`, checking first that contract recipients
87      * are aware of the ERC721 protocol to prevent tokens from being forever locked.
88      *
89      * Requirements:
90      *
91      * - `from` cannot be the zero address.
92      * - `to` cannot be the zero address.
93      * - `tokenId` token must exist and be owned by `from`.
94      * - If the caller is not `from`, it must have been allowed to move this token by either {approve} or {setApprovalForAll}.
95      * - If `to` refers to a smart contract, it must implement {IERC721Receiver-onERC721Received}, which is called upon a safe transfer.
96      *
97      * Emits a {Transfer} event.
98      */
99     function safeTransferFrom(
100         address from,
101         address to,
102         uint256 tokenId
103     ) external;
104 
105     /**
106      * @dev Transfers `tokenId` token from `from` to `to`.
107      *
108      * WARNING: Usage of this method is discouraged, use {safeTransferFrom} whenever possible.
109      *
110      * Requirements:
111      *
112      * - `from` cannot be the zero address.
113      * - `to` cannot be the zero address.
114      * - `tokenId` token must be owned by `from`.
115      * - If the caller is not `from`, it must be approved to move this token by either {approve} or {setApprovalForAll}.
116      *
117      * Emits a {Transfer} event.
118      */
119     function transferFrom(
120         address from,
121         address to,
122         uint256 tokenId
123     ) external;
124 
125     /**
126      * @dev Gives permission to `to` to transfer `tokenId` token to another account.
127      * The approval is cleared when the token is transferred.
128      *
129      * Only a single account can be approved at a time, so approving the zero address clears previous approvals.
130      *
131      * Requirements:
132      *
133      * - The caller must own the token or be an approved operator.
134      * - `tokenId` must exist.
135      *
136      * Emits an {Approval} event.
137      */
138     function approve(address to, uint256 tokenId) external;
139 
140     /**
141      * @dev Approve or remove `operator` as an operator for the caller.
142      * Operators can call {transferFrom} or {safeTransferFrom} for any token owned by the caller.
143      *
144      * Requirements:
145      *
146      * - The `operator` cannot be the caller.
147      *
148      * Emits an {ApprovalForAll} event.
149      */
150     function setApprovalForAll(address operator, bool _approved) external;
151 
152     /**
153      * @dev Returns the account approved for `tokenId` token.
154      *
155      * Requirements:
156      *
157      * - `tokenId` must exist.
158      */
159     function getApproved(uint256 tokenId) external view returns (address operator);
160 
161     /**
162      * @dev Returns if the `operator` is allowed to manage all of the assets of `owner`.
163      *
164      * See {setApprovalForAll}
165      */
166     function isApprovedForAll(address owner, address operator) external view returns (bool);
167 }
168 
169 /**
170  * @title ERC721 token receiver interface
171  * @dev Interface for any contract that wants to support safeTransfers
172  * from ERC721 asset contracts.
173  */
174 interface IERC721Receiver {
175     /**
176      * @dev Whenever an {IERC721} `tokenId` token is transferred to this contract via {IERC721-safeTransferFrom}
177      * by `operator` from `from`, this function is called.
178      *
179      * It must return its Solidity selector to confirm the token transfer.
180      * If any other value is returned or the interface is not implemented by the recipient, the transfer will be reverted.
181      *
182      * The selector can be obtained in Solidity with `IERC721Receiver.onERC721Received.selector`.
183      */
184     function onERC721Received(
185         address operator,
186         address from,
187         uint256 tokenId,
188         bytes calldata data
189     ) external returns (bytes4);
190 }
191 
192 /**
193  * @title ERC-721 Non-Fungible Token Standard, optional metadata extension
194  * @dev See https://eips.ethereum.org/EIPS/eip-721
195  */
196 interface IERC721Metadata is IERC721 {
197     /**
198      * @dev Returns the token collection name.
199      */
200     function name() external view returns (string memory);
201 
202     /**
203      * @dev Returns the token collection symbol.
204      */
205     function symbol() external view returns (string memory);
206 
207     /**
208      * @dev Returns the Uniform Resource Identifier (URI) for `tokenId` token.
209      */
210     function tokenURI(uint256 tokenId) external view returns (string memory);
211 }
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
233      *
234      * [IMPORTANT]
235      * ====
236      * You shouldn't rely on `isContract` to protect against flash loan attacks!
237      *
238      * Preventing calls from contracts is highly discouraged. It breaks composability, breaks support for smart wallets
239      * like Gnosis Safe, and does not provide security since it can be circumvented by calling from a contract
240      * constructor.
241      * ====
242      */
243     function isContract(address account) internal view returns (bool) {
244         // This method relies on extcodesize/address.code.length, which returns 0
245         // for contracts in construction, since the code is only stored at the end
246         // of the constructor execution.
247 
248         return account.code.length > 0;
249     }
250 
251     /**
252      * @dev Replacement for Solidity's `transfer`: sends `amount` wei to
253      * `recipient`, forwarding all available gas and reverting on errors.
254      *
255      * https://eips.ethereum.org/EIPS/eip-1884[EIP1884] increases the gas cost
256      * of certain opcodes, possibly making contracts go over the 2300 gas limit
257      * imposed by `transfer`, making them unable to receive funds via
258      * `transfer`. {sendValue} removes this limitation.
259      *
260      * https://diligence.consensys.net/posts/2019/09/stop-using-soliditys-transfer-now/[Learn more].
261      *
262      * IMPORTANT: because control is transferred to `recipient`, care must be
263      * taken to not create reentrancy vulnerabilities. Consider using
264      * {ReentrancyGuard} or the
265      * https://solidity.readthedocs.io/en/v0.5.11/security-considerations.html#use-the-checks-effects-interactions-pattern[checks-effects-interactions pattern].
266      */
267     function sendValue(address payable recipient, uint256 amount) internal {
268         require(address(this).balance >= amount, "Address: insufficient balance");
269 
270         (bool success, ) = recipient.call{value: amount}("");
271         require(success, "Address: unable to send value, recipient may have reverted");
272     }
273 
274     /**
275      * @dev Performs a Solidity function call using a low level `call`. A
276      * plain `call` is an unsafe replacement for a function call: use this
277      * function instead.
278      *
279      * If `target` reverts with a revert reason, it is bubbled up by this
280      * function (like regular Solidity function calls).
281      *
282      * Returns the raw returned data. To convert to the expected return value,
283      * use https://solidity.readthedocs.io/en/latest/units-and-global-variables.html?highlight=abi.decode#abi-encoding-and-decoding-functions[`abi.decode`].
284      *
285      * Requirements:
286      *
287      * - `target` must be a contract.
288      * - calling `target` with `data` must not revert.
289      *
290      * _Available since v3.1._
291      */
292     function functionCall(address target, bytes memory data) internal returns (bytes memory) {
293         return functionCall(target, data, "Address: low-level call failed");
294     }
295 
296     /**
297      * @dev Same as {xref-Address-functionCall-address-bytes-}[`functionCall`], but with
298      * `errorMessage` as a fallback revert reason when `target` reverts.
299      *
300      * _Available since v3.1._
301      */
302     function functionCall(
303         address target,
304         bytes memory data,
305         string memory errorMessage
306     ) internal returns (bytes memory) {
307         return functionCallWithValue(target, data, 0, errorMessage);
308     }
309 
310     /**
311      * @dev Same as {xref-Address-functionCall-address-bytes-}[`functionCall`],
312      * but also transferring `value` wei to `target`.
313      *
314      * Requirements:
315      *
316      * - the calling contract must have an ETH balance of at least `value`.
317      * - the called Solidity function must be `payable`.
318      *
319      * _Available since v3.1._
320      */
321     function functionCallWithValue(
322         address target,
323         bytes memory data,
324         uint256 value
325     ) internal returns (bytes memory) {
326         return functionCallWithValue(target, data, value, "Address: low-level call with value failed");
327     }
328 
329     /**
330      * @dev Same as {xref-Address-functionCallWithValue-address-bytes-uint256-}[`functionCallWithValue`], but
331      * with `errorMessage` as a fallback revert reason when `target` reverts.
332      *
333      * _Available since v3.1._
334      */
335     function functionCallWithValue(
336         address target,
337         bytes memory data,
338         uint256 value,
339         string memory errorMessage
340     ) internal returns (bytes memory) {
341         require(address(this).balance >= value, "Address: insufficient balance for call");
342         require(isContract(target), "Address: call to non-contract");
343 
344         (bool success, bytes memory returndata) = target.call{value: value}(data);
345         return verifyCallResult(success, returndata, errorMessage);
346     }
347 
348     /**
349      * @dev Same as {xref-Address-functionCall-address-bytes-}[`functionCall`],
350      * but performing a static call.
351      *
352      * _Available since v3.3._
353      */
354     function functionStaticCall(address target, bytes memory data) internal view returns (bytes memory) {
355         return functionStaticCall(target, data, "Address: low-level static call failed");
356     }
357 
358     /**
359      * @dev Same as {xref-Address-functionCall-address-bytes-string-}[`functionCall`],
360      * but performing a static call.
361      *
362      * _Available since v3.3._
363      */
364     function functionStaticCall(
365         address target,
366         bytes memory data,
367         string memory errorMessage
368     ) internal view returns (bytes memory) {
369         require(isContract(target), "Address: static call to non-contract");
370 
371         (bool success, bytes memory returndata) = target.staticcall(data);
372         return verifyCallResult(success, returndata, errorMessage);
373     }
374 
375     /**
376      * @dev Same as {xref-Address-functionCall-address-bytes-}[`functionCall`],
377      * but performing a delegate call.
378      *
379      * _Available since v3.4._
380      */
381     function functionDelegateCall(address target, bytes memory data) internal returns (bytes memory) {
382         return functionDelegateCall(target, data, "Address: low-level delegate call failed");
383     }
384 
385     /**
386      * @dev Same as {xref-Address-functionCall-address-bytes-string-}[`functionCall`],
387      * but performing a delegate call.
388      *
389      * _Available since v3.4._
390      */
391     function functionDelegateCall(
392         address target,
393         bytes memory data,
394         string memory errorMessage
395     ) internal returns (bytes memory) {
396         require(isContract(target), "Address: delegate call to non-contract");
397 
398         (bool success, bytes memory returndata) = target.delegatecall(data);
399         return verifyCallResult(success, returndata, errorMessage);
400     }
401 
402     /**
403      * @dev Tool to verifies that a low level call was successful, and revert if it wasn't, either by bubbling the
404      * revert reason using the provided one.
405      *
406      * _Available since v4.3._
407      */
408     function verifyCallResult(
409         bool success,
410         bytes memory returndata,
411         string memory errorMessage
412     ) internal pure returns (bytes memory) {
413         if (success) {
414             return returndata;
415         } else {
416             // Look for revert reason and bubble it up if present
417             if (returndata.length > 0) {
418                 // The easiest way to bubble the revert reason is using memory via assembly
419                 /// @solidity memory-safe-assembly
420                 assembly {
421                     let returndata_size := mload(returndata)
422                     revert(add(32, returndata), returndata_size)
423                 }
424             } else {
425                 revert(errorMessage);
426             }
427         }
428     }
429 }
430 
431 /**
432  * @dev Provides information about the current execution context, including the
433  * sender of the transaction and its data. While these are generally available
434  * via msg.sender and msg.data, they should not be accessed in such a direct
435  * manner, since when dealing with meta-transactions the account sending and
436  * paying for execution may not be the actual sender (as far as an application
437  * is concerned).
438  *
439  * This contract is only required for intermediate, library-like contracts.
440  */
441 abstract contract Context {
442     function _msgSender() internal view virtual returns (address) {
443         return msg.sender;
444     }
445 
446     function _msgData() internal view virtual returns (bytes calldata) {
447         return msg.data;
448     }
449 }
450 
451 /**
452  * @dev String operations.
453  */
454 library Strings {
455     bytes16 private constant _HEX_SYMBOLS = "0123456789abcdef";
456     uint8 private constant _ADDRESS_LENGTH = 20;
457 
458     /**
459      * @dev Converts a `uint256` to its ASCII `string` decimal representation.
460      */
461     function toString(uint256 value) internal pure returns (string memory) {
462         // Inspired by OraclizeAPI's implementation - MIT licence
463         // https://github.com/oraclize/ethereum-api/blob/b42146b063c7d6ee1358846c198246239e9360e8/oraclizeAPI_0.4.25.sol
464 
465         if (value == 0) {
466             return "0";
467         }
468         uint256 temp = value;
469         uint256 digits;
470         while (temp != 0) {
471             digits++;
472             temp /= 10;
473         }
474         bytes memory buffer = new bytes(digits);
475         while (value != 0) {
476             digits -= 1;
477             buffer[digits] = bytes1(uint8(48 + uint256(value % 10)));
478             value /= 10;
479         }
480         return string(buffer);
481     }
482 
483     /**
484      * @dev Converts a `uint256` to its ASCII `string` hexadecimal representation.
485      */
486     function toHexString(uint256 value) internal pure returns (string memory) {
487         if (value == 0) {
488             return "0x00";
489         }
490         uint256 temp = value;
491         uint256 length = 0;
492         while (temp != 0) {
493             length++;
494             temp >>= 8;
495         }
496         return toHexString(value, length);
497     }
498 
499     /**
500      * @dev Converts a `uint256` to its ASCII `string` hexadecimal representation with fixed length.
501      */
502     function toHexString(uint256 value, uint256 length) internal pure returns (string memory) {
503         bytes memory buffer = new bytes(2 * length + 2);
504         buffer[0] = "0";
505         buffer[1] = "x";
506         for (uint256 i = 2 * length + 1; i > 1; --i) {
507             buffer[i] = _HEX_SYMBOLS[value & 0xf];
508             value >>= 4;
509         }
510         require(value == 0, "Strings: hex length insufficient");
511         return string(buffer);
512     }
513 
514     /**
515      * @dev Converts an `address` with fixed length of 20 bytes to its not checksummed ASCII `string` hexadecimal representation.
516      */
517     function toHexString(address addr) internal pure returns (string memory) {
518         return toHexString(uint256(uint160(addr)), _ADDRESS_LENGTH);
519     }
520 }
521 
522 /**
523  * @dev Implementation of the {IERC165} interface.
524  *
525  * Contracts that want to implement ERC165 should inherit from this contract and override {supportsInterface} to check
526  * for the additional interface id that will be supported. For example:
527  *
528  * ```solidity
529  * function supportsInterface(bytes4 interfaceId) public view virtual override returns (bool) {
530  *     return interfaceId == type(MyInterface).interfaceId || super.supportsInterface(interfaceId);
531  * }
532  * ```
533  *
534  * Alternatively, {ERC165Storage} provides an easier to use but more expensive implementation.
535  */
536 abstract contract ERC165 is IERC165 {
537     /**
538      * @dev See {IERC165-supportsInterface}.
539      */
540     function supportsInterface(bytes4 interfaceId) public view virtual override returns (bool) {
541         return interfaceId == type(IERC165).interfaceId;
542     }
543 }
544 
545 /**
546  * @dev Implementation of https://eips.ethereum.org/EIPS/eip-721[ERC721] Non-Fungible Token Standard, including
547  * the Metadata extension, but not including the Enumerable extension, which is available separately as
548  * {ERC721Enumerable}.
549  */
550 contract ERC721 is Context, ERC165, IERC721, IERC721Metadata {
551     using Address for address;
552     using Strings for uint256;
553 
554     // Token name
555     string private _name;
556 
557     // Token symbol
558     string private _symbol;
559 
560     // Mapping from token ID to owner address
561     mapping(uint256 => address) private _owners;
562 
563     // Mapping owner address to token count
564     mapping(address => uint256) private _balances;
565 
566     // Mapping from token ID to approved address
567     mapping(uint256 => address) private _tokenApprovals;
568 
569     // Mapping from owner to operator approvals
570     mapping(address => mapping(address => bool)) private _operatorApprovals;
571 
572     /**
573      * @dev Initializes the contract by setting a `name` and a `symbol` to the token collection.
574      */
575     constructor(string memory name_, string memory symbol_) {
576         _name = name_;
577         _symbol = symbol_;
578     }
579 
580     /**
581      * @dev See {IERC165-supportsInterface}.
582      */
583     function supportsInterface(bytes4 interfaceId) public view virtual override(ERC165, IERC165) returns (bool) {
584         return
585             interfaceId == type(IERC721).interfaceId ||
586             interfaceId == type(IERC721Metadata).interfaceId ||
587             super.supportsInterface(interfaceId);
588     }
589 
590     /**
591      * @dev See {IERC721-balanceOf}.
592      */
593     function balanceOf(address owner) public view virtual override returns (uint256) {
594         require(owner != address(0), "ERC721: address zero is not a valid owner");
595         return _balances[owner];
596     }
597 
598     /**
599      * @dev See {IERC721-ownerOf}.
600      */
601     function ownerOf(uint256 tokenId) public view virtual override returns (address) {
602         address owner = _owners[tokenId];
603         require(owner != address(0), "ERC721: invalid token ID");
604         return owner;
605     }
606 
607     /**
608      * @dev See {IERC721Metadata-name}.
609      */
610     function name() public view virtual override returns (string memory) {
611         return _name;
612     }
613 
614     /**
615      * @dev See {IERC721Metadata-symbol}.
616      */
617     function symbol() public view virtual override returns (string memory) {
618         return _symbol;
619     }
620 
621     /**
622      * @dev See {IERC721Metadata-tokenURI}.
623      */
624     function tokenURI(uint256 tokenId) public view virtual override returns (string memory) {
625         _requireMinted(tokenId);
626 
627         string memory baseURI = _baseURI();
628         return bytes(baseURI).length > 0 ? string(abi.encodePacked(baseURI, tokenId.toString())) : "";
629     }
630 
631     /**
632      * @dev Base URI for computing {tokenURI}. If set, the resulting URI for each
633      * token will be the concatenation of the `baseURI` and the `tokenId`. Empty
634      * by default, can be overridden in child contracts.
635      */
636     function _baseURI() internal view virtual returns (string memory) {
637         return "";
638     }
639 
640     /**
641      * @dev See {IERC721-approve}.
642      */
643     function approve(address to, uint256 tokenId) public virtual override {
644         address owner = ERC721.ownerOf(tokenId);
645         require(to != owner, "ERC721: approval to current owner");
646 
647         require(
648             _msgSender() == owner || isApprovedForAll(owner, _msgSender()),
649             "ERC721: approve caller is not token owner nor approved for all"
650         );
651 
652         _approve(to, tokenId);
653     }
654 
655     /**
656      * @dev See {IERC721-getApproved}.
657      */
658     function getApproved(uint256 tokenId) public view virtual override returns (address) {
659         _requireMinted(tokenId);
660 
661         return _tokenApprovals[tokenId];
662     }
663 
664     /**
665      * @dev See {IERC721-setApprovalForAll}.
666      */
667     function setApprovalForAll(address operator, bool approved) public virtual override {
668         _setApprovalForAll(_msgSender(), operator, approved);
669     }
670 
671     /**
672      * @dev See {IERC721-isApprovedForAll}.
673      */
674     function isApprovedForAll(address owner, address operator) public view virtual override returns (bool) {
675         return _operatorApprovals[owner][operator];
676     }
677 
678     /**
679      * @dev See {IERC721-transferFrom}.
680      */
681     function transferFrom(
682         address from,
683         address to,
684         uint256 tokenId
685     ) public virtual override {
686         //solhint-disable-next-line max-line-length
687         require(_isApprovedOrOwner(_msgSender(), tokenId), "ERC721: caller is not token owner nor approved");
688 
689         _transfer(from, to, tokenId);
690     }
691 
692     /**
693      * @dev See {IERC721-safeTransferFrom}.
694      */
695     function safeTransferFrom(
696         address from,
697         address to,
698         uint256 tokenId
699     ) public virtual override {
700         safeTransferFrom(from, to, tokenId, "");
701     }
702 
703     /**
704      * @dev See {IERC721-safeTransferFrom}.
705      */
706     function safeTransferFrom(
707         address from,
708         address to,
709         uint256 tokenId,
710         bytes memory data
711     ) public virtual override {
712         require(_isApprovedOrOwner(_msgSender(), tokenId), "ERC721: caller is not token owner nor approved");
713         _safeTransfer(from, to, tokenId, data);
714     }
715 
716     /**
717      * @dev Safely transfers `tokenId` token from `from` to `to`, checking first that contract recipients
718      * are aware of the ERC721 protocol to prevent tokens from being forever locked.
719      *
720      * `data` is additional data, it has no specified format and it is sent in call to `to`.
721      *
722      * This internal function is equivalent to {safeTransferFrom}, and can be used to e.g.
723      * implement alternative mechanisms to perform token transfer, such as signature-based.
724      *
725      * Requirements:
726      *
727      * - `from` cannot be the zero address.
728      * - `to` cannot be the zero address.
729      * - `tokenId` token must exist and be owned by `from`.
730      * - If `to` refers to a smart contract, it must implement {IERC721Receiver-onERC721Received}, which is called upon a safe transfer.
731      *
732      * Emits a {Transfer} event.
733      */
734     function _safeTransfer(
735         address from,
736         address to,
737         uint256 tokenId,
738         bytes memory data
739     ) internal virtual {
740         _transfer(from, to, tokenId);
741         require(_checkOnERC721Received(from, to, tokenId, data), "ERC721: transfer to non ERC721Receiver implementer");
742     }
743 
744     /**
745      * @dev Returns whether `tokenId` exists.
746      *
747      * Tokens can be managed by their owner or approved accounts via {approve} or {setApprovalForAll}.
748      *
749      * Tokens start existing when they are minted (`_mint`),
750      * and stop existing when they are burned (`_burn`).
751      */
752     function _exists(uint256 tokenId) internal view virtual returns (bool) {
753         return _owners[tokenId] != address(0);
754     }
755 
756     /**
757      * @dev Returns whether `spender` is allowed to manage `tokenId`.
758      *
759      * Requirements:
760      *
761      * - `tokenId` must exist.
762      */
763     function _isApprovedOrOwner(address spender, uint256 tokenId) internal view virtual returns (bool) {
764         address owner = ERC721.ownerOf(tokenId);
765         return (spender == owner || isApprovedForAll(owner, spender) || getApproved(tokenId) == spender);
766     }
767 
768     /**
769      * @dev Safely mints `tokenId` and transfers it to `to`.
770      *
771      * Requirements:
772      *
773      * - `tokenId` must not exist.
774      * - If `to` refers to a smart contract, it must implement {IERC721Receiver-onERC721Received}, which is called upon a safe transfer.
775      *
776      * Emits a {Transfer} event.
777      */
778     function _safeMint(address to, uint256 tokenId) internal virtual {
779         _safeMint(to, tokenId, "");
780     }
781 
782     /**
783      * @dev Same as {xref-ERC721-_safeMint-address-uint256-}[`_safeMint`], with an additional `data` parameter which is
784      * forwarded in {IERC721Receiver-onERC721Received} to contract recipients.
785      */
786     function _safeMint(
787         address to,
788         uint256 tokenId,
789         bytes memory data
790     ) internal virtual {
791         _mint(to, tokenId);
792         require(
793             _checkOnERC721Received(address(0), to, tokenId, data),
794             "ERC721: transfer to non ERC721Receiver implementer"
795         );
796     }
797 
798     /**
799      * @dev Mints `tokenId` and transfers it to `to`.
800      *
801      * WARNING: Usage of this method is discouraged, use {_safeMint} whenever possible
802      *
803      * Requirements:
804      *
805      * - `tokenId` must not exist.
806      * - `to` cannot be the zero address.
807      *
808      * Emits a {Transfer} event.
809      */
810     function _mint(address to, uint256 tokenId) internal virtual {
811         require(to != address(0), "ERC721: mint to the zero address");
812         require(!_exists(tokenId), "ERC721: token already minted");
813 
814         _beforeTokenTransfer(address(0), to, tokenId);
815 
816         _balances[to] += 1;
817         _owners[tokenId] = to;
818 
819         emit Transfer(address(0), to, tokenId);
820 
821         _afterTokenTransfer(address(0), to, tokenId);
822     }
823 
824     /**
825      * @dev Destroys `tokenId`.
826      * The approval is cleared when the token is burned.
827      *
828      * Requirements:
829      *
830      * - `tokenId` must exist.
831      *
832      * Emits a {Transfer} event.
833      */
834     function _burn(uint256 tokenId) internal virtual {
835         address owner = ERC721.ownerOf(tokenId);
836 
837         _beforeTokenTransfer(owner, address(0), tokenId);
838 
839         // Clear approvals
840         _approve(address(0), tokenId);
841 
842         _balances[owner] -= 1;
843         delete _owners[tokenId];
844 
845         emit Transfer(owner, address(0), tokenId);
846 
847         _afterTokenTransfer(owner, address(0), tokenId);
848     }
849 
850     /**
851      * @dev Transfers `tokenId` from `from` to `to`.
852      *  As opposed to {transferFrom}, this imposes no restrictions on msg.sender.
853      *
854      * Requirements:
855      *
856      * - `to` cannot be the zero address.
857      * - `tokenId` token must be owned by `from`.
858      *
859      * Emits a {Transfer} event.
860      */
861     function _transfer(
862         address from,
863         address to,
864         uint256 tokenId
865     ) internal virtual {
866         require(ERC721.ownerOf(tokenId) == from, "ERC721: transfer from incorrect owner");
867         require(to != address(0), "ERC721: transfer to the zero address");
868 
869         _beforeTokenTransfer(from, to, tokenId);
870 
871         // Clear approvals from the previous owner
872         _approve(address(0), tokenId);
873 
874         _balances[from] -= 1;
875         _balances[to] += 1;
876         _owners[tokenId] = to;
877 
878         emit Transfer(from, to, tokenId);
879 
880         _afterTokenTransfer(from, to, tokenId);
881     }
882 
883     /**
884      * @dev Approve `to` to operate on `tokenId`
885      *
886      * Emits an {Approval} event.
887      */
888     function _approve(address to, uint256 tokenId) internal virtual {
889         _tokenApprovals[tokenId] = to;
890         emit Approval(ERC721.ownerOf(tokenId), to, tokenId);
891     }
892 
893     /**
894      * @dev Approve `operator` to operate on all of `owner` tokens
895      *
896      * Emits an {ApprovalForAll} event.
897      */
898     function _setApprovalForAll(
899         address owner,
900         address operator,
901         bool approved
902     ) internal virtual {
903         require(owner != operator, "ERC721: approve to caller");
904         _operatorApprovals[owner][operator] = approved;
905         emit ApprovalForAll(owner, operator, approved);
906     }
907 
908     /**
909      * @dev Reverts if the `tokenId` has not been minted yet.
910      */
911     function _requireMinted(uint256 tokenId) internal view virtual {
912         require(_exists(tokenId), "ERC721: invalid token ID");
913     }
914 
915     /**
916      * @dev Internal function to invoke {IERC721Receiver-onERC721Received} on a target address.
917      * The call is not executed if the target address is not a contract.
918      *
919      * @param from address representing the previous owner of the given token ID
920      * @param to target address that will receive the tokens
921      * @param tokenId uint256 ID of the token to be transferred
922      * @param data bytes optional data to send along with the call
923      * @return bool whether the call correctly returned the expected magic value
924      */
925     function _checkOnERC721Received(
926         address from,
927         address to,
928         uint256 tokenId,
929         bytes memory data
930     ) private returns (bool) {
931         if (to.isContract()) {
932             try IERC721Receiver(to).onERC721Received(_msgSender(), from, tokenId, data) returns (bytes4 retval) {
933                 return retval == IERC721Receiver.onERC721Received.selector;
934             } catch (bytes memory reason) {
935                 if (reason.length == 0) {
936                     revert("ERC721: transfer to non ERC721Receiver implementer");
937                 } else {
938                     /// @solidity memory-safe-assembly
939                     assembly {
940                         revert(add(32, reason), mload(reason))
941                     }
942                 }
943             }
944         } else {
945             return true;
946         }
947     }
948 
949     /**
950      * @dev Hook that is called before any token transfer. This includes minting
951      * and burning.
952      *
953      * Calling conditions:
954      *
955      * - When `from` and `to` are both non-zero, ``from``'s `tokenId` will be
956      * transferred to `to`.
957      * - When `from` is zero, `tokenId` will be minted for `to`.
958      * - When `to` is zero, ``from``'s `tokenId` will be burned.
959      * - `from` and `to` are never both zero.
960      *
961      * To learn more about hooks, head to xref:ROOT:extending-contracts.adoc#using-hooks[Using Hooks].
962      */
963     function _beforeTokenTransfer(
964         address from,
965         address to,
966         uint256 tokenId
967     ) internal virtual {}
968 
969     /**
970      * @dev Hook that is called after any transfer of tokens. This includes
971      * minting and burning.
972      *
973      * Calling conditions:
974      *
975      * - when `from` and `to` are both non-zero.
976      * - `from` and `to` are never both zero.
977      *
978      * To learn more about hooks, head to xref:ROOT:extending-contracts.adoc#using-hooks[Using Hooks].
979      */
980     function _afterTokenTransfer(
981         address from,
982         address to,
983         uint256 tokenId
984     ) internal virtual {}
985 }
986 
987 /**
988  * @title ERC-721 Non-Fungible Token Standard, optional enumeration extension
989  * @dev See https://eips.ethereum.org/EIPS/eip-721
990  */
991 interface IERC721Enumerable is IERC721 {
992     /**
993      * @dev Returns the total amount of tokens stored by the contract.
994      */
995     function totalSupply() external view returns (uint256);
996 
997     /**
998      * @dev Returns a token ID owned by `owner` at a given `index` of its token list.
999      * Use along with {balanceOf} to enumerate all of ``owner``'s tokens.
1000      */
1001     function tokenOfOwnerByIndex(address owner, uint256 index) external view returns (uint256);
1002 
1003     /**
1004      * @dev Returns a token ID at a given `index` of all the tokens stored by the contract.
1005      * Use along with {totalSupply} to enumerate all tokens.
1006      */
1007     function tokenByIndex(uint256 index) external view returns (uint256);
1008 }
1009 
1010 /**
1011  * @dev This implements an optional extension of {ERC721} defined in the EIP that adds
1012  * enumerability of all the token ids in the contract as well as all token ids owned by each
1013  * account.
1014  */
1015 abstract contract ERC721Enumerable is ERC721, IERC721Enumerable {
1016     // Mapping from owner to list of owned token IDs
1017     mapping(address => mapping(uint256 => uint256)) private _ownedTokens;
1018 
1019     // Mapping from token ID to index of the owner tokens list
1020     mapping(uint256 => uint256) private _ownedTokensIndex;
1021 
1022     // Array with all token ids, used for enumeration
1023     uint256[] private _allTokens;
1024 
1025     // Mapping from token id to position in the allTokens array
1026     mapping(uint256 => uint256) private _allTokensIndex;
1027 
1028     /**
1029      * @dev See {IERC165-supportsInterface}.
1030      */
1031     function supportsInterface(bytes4 interfaceId) public view virtual override(IERC165, ERC721) returns (bool) {
1032         return interfaceId == type(IERC721Enumerable).interfaceId || super.supportsInterface(interfaceId);
1033     }
1034 
1035     /**
1036      * @dev See {IERC721Enumerable-tokenOfOwnerByIndex}.
1037      */
1038     function tokenOfOwnerByIndex(address owner, uint256 index) public view virtual override returns (uint256) {
1039         require(index < ERC721.balanceOf(owner), "ERC721Enumerable: owner index out of bounds");
1040         return _ownedTokens[owner][index];
1041     }
1042 
1043     /**
1044      * @dev See {IERC721Enumerable-totalSupply}.
1045      */
1046     function totalSupply() public view virtual override returns (uint256) {
1047         return _allTokens.length;
1048     }
1049 
1050     /**
1051      * @dev See {IERC721Enumerable-tokenByIndex}.
1052      */
1053     function tokenByIndex(uint256 index) public view virtual override returns (uint256) {
1054         require(index < ERC721Enumerable.totalSupply(), "ERC721Enumerable: global index out of bounds");
1055         return _allTokens[index];
1056     }
1057 
1058     /**
1059      * @dev Hook that is called before any token transfer. This includes minting
1060      * and burning.
1061      *
1062      * Calling conditions:
1063      *
1064      * - When `from` and `to` are both non-zero, ``from``'s `tokenId` will be
1065      * transferred to `to`.
1066      * - When `from` is zero, `tokenId` will be minted for `to`.
1067      * - When `to` is zero, ``from``'s `tokenId` will be burned.
1068      * - `from` cannot be the zero address.
1069      * - `to` cannot be the zero address.
1070      *
1071      * To learn more about hooks, head to xref:ROOT:extending-contracts.adoc#using-hooks[Using Hooks].
1072      */
1073     function _beforeTokenTransfer(
1074         address from,
1075         address to,
1076         uint256 tokenId
1077     ) internal virtual override {
1078         super._beforeTokenTransfer(from, to, tokenId);
1079 
1080         if (from == address(0)) {
1081             _addTokenToAllTokensEnumeration(tokenId);
1082         } else if (from != to) {
1083             _removeTokenFromOwnerEnumeration(from, tokenId);
1084         }
1085         if (to == address(0)) {
1086             _removeTokenFromAllTokensEnumeration(tokenId);
1087         } else if (to != from) {
1088             _addTokenToOwnerEnumeration(to, tokenId);
1089         }
1090     }
1091 
1092     /**
1093      * @dev Private function to add a token to this extension's ownership-tracking data structures.
1094      * @param to address representing the new owner of the given token ID
1095      * @param tokenId uint256 ID of the token to be added to the tokens list of the given address
1096      */
1097     function _addTokenToOwnerEnumeration(address to, uint256 tokenId) private {
1098         uint256 length = ERC721.balanceOf(to);
1099         _ownedTokens[to][length] = tokenId;
1100         _ownedTokensIndex[tokenId] = length;
1101     }
1102 
1103     /**
1104      * @dev Private function to add a token to this extension's token tracking data structures.
1105      * @param tokenId uint256 ID of the token to be added to the tokens list
1106      */
1107     function _addTokenToAllTokensEnumeration(uint256 tokenId) private {
1108         _allTokensIndex[tokenId] = _allTokens.length;
1109         _allTokens.push(tokenId);
1110     }
1111 
1112     /**
1113      * @dev Private function to remove a token from this extension's ownership-tracking data structures. Note that
1114      * while the token is not assigned a new owner, the `_ownedTokensIndex` mapping is _not_ updated: this allows for
1115      * gas optimizations e.g. when performing a transfer operation (avoiding double writes).
1116      * This has O(1) time complexity, but alters the order of the _ownedTokens array.
1117      * @param from address representing the previous owner of the given token ID
1118      * @param tokenId uint256 ID of the token to be removed from the tokens list of the given address
1119      */
1120     function _removeTokenFromOwnerEnumeration(address from, uint256 tokenId) private {
1121         // To prevent a gap in from's tokens array, we store the last token in the index of the token to delete, and
1122         // then delete the last slot (swap and pop).
1123 
1124         uint256 lastTokenIndex = ERC721.balanceOf(from) - 1;
1125         uint256 tokenIndex = _ownedTokensIndex[tokenId];
1126 
1127         // When the token to delete is the last token, the swap operation is unnecessary
1128         if (tokenIndex != lastTokenIndex) {
1129             uint256 lastTokenId = _ownedTokens[from][lastTokenIndex];
1130 
1131             _ownedTokens[from][tokenIndex] = lastTokenId; // Move the last token to the slot of the to-delete token
1132             _ownedTokensIndex[lastTokenId] = tokenIndex; // Update the moved token's index
1133         }
1134 
1135         // This also deletes the contents at the last position of the array
1136         delete _ownedTokensIndex[tokenId];
1137         delete _ownedTokens[from][lastTokenIndex];
1138     }
1139 
1140     /**
1141      * @dev Private function to remove a token from this extension's token tracking data structures.
1142      * This has O(1) time complexity, but alters the order of the _allTokens array.
1143      * @param tokenId uint256 ID of the token to be removed from the tokens list
1144      */
1145     function _removeTokenFromAllTokensEnumeration(uint256 tokenId) private {
1146         // To prevent a gap in the tokens array, we store the last token in the index of the token to delete, and
1147         // then delete the last slot (swap and pop).
1148 
1149         uint256 lastTokenIndex = _allTokens.length - 1;
1150         uint256 tokenIndex = _allTokensIndex[tokenId];
1151 
1152         // When the token to delete is the last token, the swap operation is unnecessary. However, since this occurs so
1153         // rarely (when the last minted token is burnt) that we still do the swap here to avoid the gas cost of adding
1154         // an 'if' statement (like in _removeTokenFromOwnerEnumeration)
1155         uint256 lastTokenId = _allTokens[lastTokenIndex];
1156 
1157         _allTokens[tokenIndex] = lastTokenId; // Move the last token to the slot of the to-delete token
1158         _allTokensIndex[lastTokenId] = tokenIndex; // Update the moved token's index
1159 
1160         // This also deletes the contents at the last position of the array
1161         delete _allTokensIndex[tokenId];
1162         _allTokens.pop();
1163     }
1164 }
1165 
1166 /**
1167  * @title Counters
1168  * @author Matt Condon (@shrugs)
1169  * @dev Provides counters that can only be incremented, decremented or reset. This can be used e.g. to track the number
1170  * of elements in a mapping, issuing ERC721 ids, or counting request ids.
1171  *
1172  * Include with `using Counters for Counters.Counter;`
1173  */
1174 library Counters {
1175     struct Counter {
1176         // This variable should never be directly accessed by users of the library: interactions must be restricted to
1177         // the library's function. As of Solidity v0.5.2, this cannot be enforced, though there is a proposal to add
1178         // this feature: see https://github.com/ethereum/solidity/issues/4637
1179         uint256 _value; // default: 0
1180     }
1181 
1182     function current(Counter storage counter) internal view returns (uint256) {
1183         return counter._value;
1184     }
1185 
1186     function increment(Counter storage counter) internal {
1187         unchecked {
1188             counter._value += 1;
1189         }
1190     }
1191 
1192     function decrement(Counter storage counter) internal {
1193         uint256 value = counter._value;
1194         require(value > 0, "Counter: decrement overflow");
1195         unchecked {
1196             counter._value = value - 1;
1197         }
1198     }
1199 
1200     function reset(Counter storage counter) internal {
1201         counter._value = 0;
1202     }
1203 }
1204 
1205 library LibPart {
1206     bytes32 public constant TYPE_HASH = keccak256("Part(address account,uint96 value)");
1207 
1208     struct Part {
1209         address payable account;
1210         uint96 value;
1211     }
1212 
1213     function hash(Part memory part) internal pure returns (bytes32) {
1214         return keccak256(abi.encode(TYPE_HASH, part.account, part.value));
1215     }
1216 }
1217 
1218 abstract contract AbstractRoyalties {
1219     mapping (uint256 => LibPart.Part[]) internal royalties;
1220 
1221     function _saveRoyalties(uint256 id, LibPart.Part[] memory _royalties) internal {
1222         uint256 totalValue;
1223         for (uint i = 0; i < _royalties.length; i++) {
1224             require(_royalties[i].account != address(0x0), "Recipient should be present");
1225             require(_royalties[i].value != 0, "Royalty value should be positive");
1226             totalValue += _royalties[i].value;
1227             royalties[id].push(_royalties[i]);
1228         }
1229         require(totalValue < 10000, "Royalty total value should be < 10000");
1230         _onRoyaltiesSet(id, _royalties);
1231     }
1232 
1233     function _updateAccount(uint256 _id, address _from, address _to) internal {
1234         uint length = royalties[_id].length;
1235         for(uint i = 0; i < length; i++) {
1236             if (royalties[_id][i].account == _from) {
1237                 royalties[_id][i].account = payable(address(uint160(_to)));
1238             }
1239         }
1240     }
1241 
1242     function _onRoyaltiesSet(uint256 id, LibPart.Part[] memory _royalties) virtual internal;
1243 }
1244 
1245 interface RoyaltiesV2 {
1246     event RoyaltiesSet(uint256 tokenId, LibPart.Part[] royalties);
1247 
1248     function getRaribleV2Royalties(uint256 id) external view returns (LibPart.Part[] memory);
1249 }
1250 
1251 contract RoyaltiesV2Impl is AbstractRoyalties, RoyaltiesV2 {
1252 
1253     function getRaribleV2Royalties(uint256 id) override external view returns (LibPart.Part[] memory) {
1254         return royalties[id];
1255     }
1256 
1257     function _onRoyaltiesSet(uint256 id, LibPart.Part[] memory _royalties) override internal {
1258         emit RoyaltiesSet(id, _royalties);
1259     }
1260 }
1261 
1262 library LibRoyaltiesV2 {
1263     /*
1264      * bytes4(keccak256('getRaribleV2Royalties(uint256)')) == 0xcad96cca
1265      */
1266     bytes4 constant _INTERFACE_ID_ROYALTIES = 0xcad96cca;
1267 }
1268 
1269 contract WeAreAllTheSA is ERC721, ERC721Enumerable, RoyaltiesV2Impl {
1270 
1271     using Counters for Counters.Counter;
1272 
1273     address private constant _hdrnFlowAddress = address(0xF447BE386164dADfB5d1e7622613f289F17024D8);
1274     bytes4  private constant _INTERFACE_ID_ERC2981 = 0x2a55205a;
1275     uint96  private constant _waatsaRoyaltyBasis = 369; // Rarible V2 royalty basis
1276     string  private constant _hostname = "https://api.icosa.pro/";
1277     string  private constant _endpoint = "/waatsa/";
1278 
1279     Counters.Counter private _tokenIds;
1280     address          private _creator;
1281 
1282     constructor() ERC721("We Are All the SA", "WAATSA")
1283     {
1284         /* _creator is not an admin key. It is set at contsruction to be a link
1285            to the parent contract. In this case Hedron */
1286         _creator = msg.sender;
1287     }
1288 
1289     function _baseURI(
1290     )
1291         internal
1292         view
1293         virtual
1294         override
1295         returns (string memory)
1296     {
1297         string memory chainid = Strings.toString(block.chainid);
1298         return string(abi.encodePacked(_hostname, chainid, _endpoint));
1299     }
1300 
1301     function _beforeTokenTransfer(
1302         address from,
1303         address to,
1304         uint256 tokenId
1305     )
1306         internal
1307         override(ERC721, ERC721Enumerable) 
1308     {
1309         super._beforeTokenTransfer(from, to, tokenId);
1310     }
1311 
1312     // Internal NFT Marketplace Glue
1313 
1314     /** @dev Sets the Rarible V2 royalties on a specific token
1315      *  @param tokenId Unique ID of the HSI NFT token.
1316      */
1317     function _setRoyalties(
1318         uint256 tokenId
1319     )
1320         internal
1321     {
1322         LibPart.Part[] memory _royalties = new LibPart.Part[](1);
1323         _royalties[0].value = _waatsaRoyaltyBasis;
1324         _royalties[0].account = payable(_hdrnFlowAddress);
1325         _saveRoyalties(tokenId, _royalties);
1326     }
1327 
1328     function mintStakeNft (address staker)
1329         external
1330         returns (uint256)
1331     {
1332         require(msg.sender == _creator,
1333             "WAATSA: NOT ICSA");
1334 
1335         _tokenIds.increment();
1336         uint256 newTokenId = _tokenIds.current();
1337 
1338         _setRoyalties(newTokenId);
1339 
1340         _mint(staker, newTokenId);
1341         return newTokenId;
1342     }
1343 
1344     function burnStakeNft (uint256 tokenId)
1345         external
1346     {
1347         require(msg.sender == _creator,
1348             "WAATSA: NOT ICSA");
1349 
1350         _burn(tokenId);
1351     }
1352 
1353     // External NFT Marketplace Glue
1354 
1355     /**
1356      * @dev Implements ERC2981 royalty functionality. We just read the royalty data from
1357      *      the Rarible V2 implementation. 
1358      * @param tokenId Unique ID of the HSI NFT token.
1359      * @param salePrice Price the HSI NFT token was sold for.
1360      * @return receiver address to send the royalties to as well as the royalty amount.
1361      */
1362     function royaltyInfo(
1363         uint256 tokenId,
1364         uint256 salePrice
1365     )
1366         external
1367         view
1368         returns (address receiver, uint256 royaltyAmount)
1369     {
1370         LibPart.Part[] memory _royalties = royalties[tokenId];
1371         
1372         if (_royalties.length > 0) {
1373             return (_royalties[0].account, (salePrice * _royalties[0].value) / 10000);
1374         }
1375 
1376         return (address(0), 0);
1377     }
1378 
1379     /**
1380      * @dev returns _hdrnFlowAddress, needed for some NFT marketplaces. This is not
1381      *       an admin key.
1382      * @return _hdrnFlowAddress
1383      */
1384     function owner(
1385     )
1386         external
1387         pure
1388         returns (address) 
1389     {
1390         return _hdrnFlowAddress;
1391     }
1392 
1393     /**
1394      * @dev Adds Rarible V2 and ERC2981 interface support.
1395      * @param interfaceId Unique contract interface identifier.
1396      * @return True if the interface is supported, false if not.
1397      */
1398     function supportsInterface(
1399         bytes4 interfaceId
1400     )
1401         public
1402         view
1403         virtual
1404         override(ERC721, ERC721Enumerable)
1405         returns (bool)
1406     {
1407         if (interfaceId == LibRoyaltiesV2._INTERFACE_ID_ROYALTIES) {
1408             return true;
1409         }
1410 
1411         if (interfaceId == _INTERFACE_ID_ERC2981) {
1412             return true;
1413         }
1414 
1415         return super.supportsInterface(interfaceId);
1416     }
1417 
1418 }