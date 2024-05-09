1 pragma solidity ^0.8.7;
2 
3 // File: @openzeppelin/contracts/utils/introspection/IERC165.sol
4 // SPDX-License-Identifier: MIT
5 // OpenZeppelin Contracts v4.4.1 (utils/introspection/IERC165.sol)
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
26 // File: @openzeppelin/contracts/token/ERC721/IERC721.sol
27 // 
28 // OpenZeppelin Contracts (last updated v4.6.0) (token/ERC721/IERC721.sol)
29 /**
30  * @dev Required interface of an ERC721 compliant contract.
31  */
32 interface IERC721 is IERC165 {
33     /**
34      * @dev Emitted when `tokenId` token is transferred from `from` to `to`.
35      */
36     event Transfer(address indexed from, address indexed to, uint256 indexed tokenId);
37     /**
38      * @dev Emitted when `owner` enables `approved` to manage the `tokenId` token.
39      */
40     event Approval(address indexed owner, address indexed approved, uint256 indexed tokenId);
41     /**
42      * @dev Emitted when `owner` enables or disables (`approved`) `operator` to manage all of its assets.
43      */
44     event ApprovalForAll(address indexed owner, address indexed operator, bool approved);
45     /**
46      * @dev Returns the number of tokens in ``owner``'s account.
47      */
48     function balanceOf(address owner) external view returns (uint256 balance);
49     /**
50      * @dev Returns the owner of the `tokenId` token.
51      *
52      * Requirements:
53      *
54      * - `tokenId` must exist.
55      */
56     function ownerOf(uint256 tokenId) external view returns (address owner);
57     /**
58      * @dev Safely transfers `tokenId` token from `from` to `to`.
59      *
60      * Requirements:
61      *
62      * - `from` cannot be the zero address.
63      * - `to` cannot be the zero address.
64      * - `tokenId` token must exist and be owned by `from`.
65      * - If the caller is not `from`, it must be approved to move this token by either {approve} or {setApprovalForAll}.
66      * - If `to` refers to a smart contract, it must implement {IERC721Receiver-onERC721Received}, which is called upon a safe transfer.
67      *
68      * Emits a {Transfer} event.
69      */
70     function safeTransferFrom(
71         address from,
72         address to,
73         uint256 tokenId,
74         bytes calldata data
75     ) external;
76     /**
77      * @dev Safely transfers `tokenId` token from `from` to `to`, checking first that contract recipients
78      * are aware of the ERC721 protocol to prevent tokens from being forever locked.
79      *
80      * Requirements:
81      *
82      * - `from` cannot be the zero address.
83      * - `to` cannot be the zero address.
84      * - `tokenId` token must exist and be owned by `from`.
85      * - If the caller is not `from`, it must be have been allowed to move this token by either {approve} or {setApprovalForAll}.
86      * - If `to` refers to a smart contract, it must implement {IERC721Receiver-onERC721Received}, which is called upon a safe transfer.
87      *
88      * Emits a {Transfer} event.
89      */
90     function safeTransferFrom(
91         address from,
92         address to,
93         uint256 tokenId
94     ) external;
95     /**
96      * @dev Transfers `tokenId` token from `from` to `to`.
97      *
98      * WARNING: Usage of this method is discouraged, use {safeTransferFrom} whenever possible.
99      *
100      * Requirements:
101      *
102      * - `from` cannot be the zero address.
103      * - `to` cannot be the zero address.
104      * - `tokenId` token must be owned by `from`.
105      * - If the caller is not `from`, it must be approved to move this token by either {approve} or {setApprovalForAll}.
106      *
107      * Emits a {Transfer} event.
108      */
109     function transferFrom(
110         address from,
111         address to,
112         uint256 tokenId
113     ) external;
114     /**
115      * @dev Gives permission to `to` to transfer `tokenId` token to another account.
116      * The approval is cleared when the token is transferred.
117      *
118      * Only a single account can be approved at a time, so approving the zero address clears previous approvals.
119      *
120      * Requirements:
121      *
122      * - The caller must own the token or be an approved operator.
123      * - `tokenId` must exist.
124      *
125      * Emits an {Approval} event.
126      */
127     function approve(address to, uint256 tokenId) external;
128     /**
129      * @dev Approve or remove `operator` as an operator for the caller.
130      * Operators can call {transferFrom} or {safeTransferFrom} for any token owned by the caller.
131      *
132      * Requirements:
133      *
134      * - The `operator` cannot be the caller.
135      *
136      * Emits an {ApprovalForAll} event.
137      */
138     function setApprovalForAll(address operator, bool _approved) external;
139     /**
140      * @dev Returns the account approved for `tokenId` token.
141      *
142      * Requirements:
143      *
144      * - `tokenId` must exist.
145      */
146     function getApproved(uint256 tokenId) external view returns (address operator);
147     /**
148      * @dev Returns if the `operator` is allowed to manage all of the assets of `owner`.
149      *
150      * See {setApprovalForAll}
151      */
152     function isApprovedForAll(address owner, address operator) external view returns (bool);
153 }
154 // File: @openzeppelin/contracts/token/ERC721/IERC721Receiver.sol
155 // 
156 // OpenZeppelin Contracts (last updated v4.6.0) (token/ERC721/IERC721Receiver.sol)
157 /**
158  * @title ERC721 token receiver interface
159  * @dev Interface for any contract that wants to support safeTransfers
160  * from ERC721 asset contracts.
161  */
162 interface IERC721Receiver {
163     /**
164      * @dev Whenever an {IERC721} `tokenId` token is transferred to this contract via {IERC721-safeTransferFrom}
165      * by `operator` from `from`, this function is called.
166      *
167      * It must return its Solidity selector to confirm the token transfer.
168      * If any other value is returned or the interface is not implemented by the recipient, the transfer will be reverted.
169      *
170      * The selector can be obtained in Solidity with `IERC721Receiver.onERC721Received.selector`.
171      */
172     function onERC721Received(
173         address operator,
174         address from,
175         uint256 tokenId,
176         bytes calldata data
177     ) external returns (bytes4);
178 }
179 // File: @openzeppelin/contracts/token/ERC721/extensions/IERC721Metadata.sol
180 // 
181 // OpenZeppelin Contracts v4.4.1 (token/ERC721/extensions/IERC721Metadata.sol)
182 /**
183  * @title ERC-721 Non-Fungible Token Standard, optional metadata extension
184  * @dev See https://eips.ethereum.org/EIPS/eip-721
185  */
186 interface IERC721Metadata is IERC721 {
187     /**
188      * @dev Returns the token collection name.
189      */
190     function name() external view returns (string memory);
191     /**
192      * @dev Returns the token collection symbol.
193      */
194     function symbol() external view returns (string memory);
195     /**
196      * @dev Returns the Uniform Resource Identifier (URI) for `tokenId` token.
197      */
198     function tokenURI(uint256 tokenId) external view returns (string memory);
199 }
200 // File: @openzeppelin/contracts/utils/Address.sol
201 // 
202 // OpenZeppelin Contracts (last updated v4.5.0) (utils/Address.sol)
203 /**
204  * @dev Collection of functions related to the address type
205  */
206 library Address {
207     /**
208      * @dev Returns true if `account` is a contract.
209      *
210      * [IMPORTANT]
211      * ====
212      * It is unsafe to assume that an address for which this function returns
213      * false is an externally-owned account (EOA) and not a contract.
214      *
215      * Among others, `isContract` will return false for the following
216      * types of addresses:
217      *
218      *  - an externally-owned account
219      *  - a contract in construction
220      *  - an address where a contract will be created
221      *  - an address where a contract lived, but was destroyed
222      * ====
223      *
224      * [IMPORTANT]
225      * ====
226      * You shouldn't rely on `isContract` to protect against flash loan attacks!
227      *
228      * Preventing calls from contracts is highly discouraged. It breaks composability, breaks support for smart wallets
229      * like Gnosis Safe, and does not provide security since it can be circumvented by calling from a contract
230      * constructor.
231      * ====
232      */
233     function isContract(address account) internal view returns (bool) {
234         // This method relies on extcodesize/address.code.length, which returns 0
235         // for contracts in construction, since the code is only stored at the end
236         // of the constructor execution.
237         return account.code.length > 0;
238     }
239     /**
240      * @dev Replacement for Solidity's `transfer`: sends `amount` wei to
241      * `recipient`, forwarding all available gas and reverting on errors.
242      *
243      * https://eips.ethereum.org/EIPS/eip-1884[EIP1884] increases the gas cost
244      * of certain opcodes, possibly making contracts go over the 2300 gas limit
245      * imposed by `transfer`, making them unable to receive funds via
246      * `transfer`. {sendValue} removes this limitation.
247      *
248      * https://diligence.consensys.net/posts/2019/09/stop-using-soliditys-transfer-now/[Learn more].
249      *
250      * IMPORTANT: because control is transferred to `recipient`, care must be
251      * taken to not create reentrancy vulnerabilities. Consider using
252      * {ReentrancyGuard} or the
253      * https://solidity.readthedocs.io/en/v0.5.11/security-considerations.html#use-the-checks-effects-interactions-pattern[checks-effects-interactions pattern].
254      */
255     function sendValue(address payable recipient, uint256 amount) internal {
256         require(address(this).balance >= amount, "Address: insufficient balance");
257         (bool success, ) = recipient.call{value: amount}("");
258         require(success, "Address: unable to send value, recipient may have reverted");
259     }
260     /**
261      * @dev Performs a Solidity function call using a low level `call`. A
262      * plain `call` is an unsafe replacement for a function call: use this
263      * function instead.
264      *
265      * If `target` reverts with a revert reason, it is bubbled up by this
266      * function (like regular Solidity function calls).
267      *
268      * Returns the raw returned data. To convert to the expected return value,
269      * use https://solidity.readthedocs.io/en/latest/units-and-global-variables.html?highlight=abi.decode#abi-encoding-and-decoding-functions[`abi.decode`].
270      *
271      * Requirements:
272      *
273      * - `target` must be a contract.
274      * - calling `target` with `data` must not revert.
275      *
276      * _Available since v3.1._
277      */
278     function functionCall(address target, bytes memory data) internal returns (bytes memory) {
279         return functionCall(target, data, "Address: low-level call failed");
280     }
281     /**
282      * @dev Same as {xref-Address-functionCall-address-bytes-}[`functionCall`], but with
283      * `errorMessage` as a fallback revert reason when `target` reverts.
284      *
285      * _Available since v3.1._
286      */
287     function functionCall(
288         address target,
289         bytes memory data,
290         string memory errorMessage
291     ) internal returns (bytes memory) {
292         return functionCallWithValue(target, data, 0, errorMessage);
293     }
294     /**
295      * @dev Same as {xref-Address-functionCall-address-bytes-}[`functionCall`],
296      * but also transferring `value` wei to `target`.
297      *
298      * Requirements:
299      *
300      * - the calling contract must have an ETH balance of at least `value`.
301      * - the called Solidity function must be `payable`.
302      *
303      * _Available since v3.1._
304      */
305     function functionCallWithValue(
306         address target,
307         bytes memory data,
308         uint256 value
309     ) internal returns (bytes memory) {
310         return functionCallWithValue(target, data, value, "Address: low-level call with value failed");
311     }
312     /**
313      * @dev Same as {xref-Address-functionCallWithValue-address-bytes-uint256-}[`functionCallWithValue`], but
314      * with `errorMessage` as a fallback revert reason when `target` reverts.
315      *
316      * _Available since v3.1._
317      */
318     function functionCallWithValue(
319         address target,
320         bytes memory data,
321         uint256 value,
322         string memory errorMessage
323     ) internal returns (bytes memory) {
324         require(address(this).balance >= value, "Address: insufficient balance for call");
325         require(isContract(target), "Address: call to non-contract");
326         (bool success, bytes memory returndata) = target.call{value: value}(data);
327         return verifyCallResult(success, returndata, errorMessage);
328     }
329     /**
330      * @dev Same as {xref-Address-functionCall-address-bytes-}[`functionCall`],
331      * but performing a static call.
332      *
333      * _Available since v3.3._
334      */
335     function functionStaticCall(address target, bytes memory data) internal view returns (bytes memory) {
336         return functionStaticCall(target, data, "Address: low-level static call failed");
337     }
338     /**
339      * @dev Same as {xref-Address-functionCall-address-bytes-string-}[`functionCall`],
340      * but performing a static call.
341      *
342      * _Available since v3.3._
343      */
344     function functionStaticCall(
345         address target,
346         bytes memory data,
347         string memory errorMessage
348     ) internal view returns (bytes memory) {
349         require(isContract(target), "Address: static call to non-contract");
350         (bool success, bytes memory returndata) = target.staticcall(data);
351         return verifyCallResult(success, returndata, errorMessage);
352     }
353     /**
354      * @dev Same as {xref-Address-functionCall-address-bytes-}[`functionCall`],
355      * but performing a delegate call.
356      *
357      * _Available since v3.4._
358      */
359     function functionDelegateCall(address target, bytes memory data) internal returns (bytes memory) {
360         return functionDelegateCall(target, data, "Address: low-level delegate call failed");
361     }
362     /**
363      * @dev Same as {xref-Address-functionCall-address-bytes-string-}[`functionCall`],
364      * but performing a delegate call.
365      *
366      * _Available since v3.4._
367      */
368     function functionDelegateCall(
369         address target,
370         bytes memory data,
371         string memory errorMessage
372     ) internal returns (bytes memory) {
373         require(isContract(target), "Address: delegate call to non-contract");
374         (bool success, bytes memory returndata) = target.delegatecall(data);
375         return verifyCallResult(success, returndata, errorMessage);
376     }
377     /**
378      * @dev Tool to verifies that a low level call was successful, and revert if it wasn't, either by bubbling the
379      * revert reason using the provided one.
380      *
381      * _Available since v4.3._
382      */
383     function verifyCallResult(
384         bool success,
385         bytes memory returndata,
386         string memory errorMessage
387     ) internal pure returns (bytes memory) {
388         if (success) {
389             return returndata;
390         } else {
391             // Look for revert reason and bubble it up if present
392             if (returndata.length > 0) {
393                 // The easiest way to bubble the revert reason is using memory via assembly
394                 assembly {
395                     let returndata_size := mload(returndata)
396                     revert(add(32, returndata), returndata_size)
397                 }
398             } else {
399                 revert(errorMessage);
400             }
401         }
402     }
403 }
404 // File: @openzeppelin/contracts/utils/Context.sol
405 // 
406 // OpenZeppelin Contracts v4.4.1 (utils/Context.sol)
407 /**
408  * @dev Provides information about the current execution context, including the
409  * sender of the transaction and its data. While these are generally available
410  * via msg.sender and msg.data, they should not be accessed in such a direct
411  * manner, since when dealing with meta-transactions the account sending and
412  * paying for execution may not be the actual sender (as far as an application
413  * is concerned).
414  *
415  * This contract is only required for intermediate, library-like contracts.
416  */
417 abstract contract Context {
418     function _msgSender() internal view virtual returns (address) {
419         return msg.sender;
420     }
421     function _msgData() internal view virtual returns (bytes calldata) {
422         return msg.data;
423     }
424 }
425 // File: @openzeppelin/contracts/utils/Strings.sol
426 // 
427 // OpenZeppelin Contracts v4.4.1 (utils/Strings.sol)
428 /**
429  * @dev String operations.
430  */
431 library Strings {
432     bytes16 private constant _HEX_SYMBOLS = "0123456789abcdef";
433     /**
434      * @dev Converts a `uint256` to its ASCII `string` decimal representation.
435      */
436     function toString(uint256 value) internal pure returns (string memory) {
437         // Inspired by OraclizeAPI's implementation - MIT licence
438         // https://github.com/oraclize/ethereum-api/blob/b42146b063c7d6ee1358846c198246239e9360e8/oraclizeAPI_0.4.25.sol
439         if (value == 0) {
440             return "0";
441         }
442         uint256 temp = value;
443         uint256 digits;
444         while (temp != 0) {
445             digits++;
446             temp /= 10;
447         }
448         bytes memory buffer = new bytes(digits);
449         while (value != 0) {
450             digits -= 1;
451             buffer[digits] = bytes1(uint8(48 + uint256(value % 10)));
452             value /= 10;
453         }
454         return string(buffer);
455     }
456     /**
457      * @dev Converts a `uint256` to its ASCII `string` hexadecimal representation.
458      */
459     function toHexString(uint256 value) internal pure returns (string memory) {
460         if (value == 0) {
461             return "0x00";
462         }
463         uint256 temp = value;
464         uint256 length = 0;
465         while (temp != 0) {
466             length++;
467             temp >>= 8;
468         }
469         return toHexString(value, length);
470     }
471     /**
472      * @dev Converts a `uint256` to its ASCII `string` hexadecimal representation with fixed length.
473      */
474     function toHexString(uint256 value, uint256 length) internal pure returns (string memory) {
475         bytes memory buffer = new bytes(2 * length + 2);
476         buffer[0] = "0";
477         buffer[1] = "x";
478         for (uint256 i = 2 * length + 1; i > 1; --i) {
479             buffer[i] = _HEX_SYMBOLS[value & 0xf];
480             value >>= 4;
481         }
482         require(value == 0, "Strings: hex length insufficient");
483         return string(buffer);
484     }
485 }
486 // File: @openzeppelin/contracts/utils/introspection/ERC165.sol
487 // 
488 // OpenZeppelin Contracts v4.4.1 (utils/introspection/ERC165.sol)
489 /**
490  * @dev Implementation of the {IERC165} interface.
491  *
492  * Contracts that want to implement ERC165 should inherit from this contract and override {supportsInterface} to check
493  * for the additional interface id that will be supported. For example:
494  *
495  * ```solidity
496  * function supportsInterface(bytes4 interfaceId) public view virtual override returns (bool) {
497  *     return interfaceId == type(MyInterface).interfaceId || super.supportsInterface(interfaceId);
498  * }
499  * ```
500  *
501  * Alternatively, {ERC165Storage} provides an easier to use but more expensive implementation.
502  */
503 abstract contract ERC165 is IERC165 {
504     /**
505      * @dev See {IERC165-supportsInterface}.
506      */
507     function supportsInterface(bytes4 interfaceId) public view virtual override returns (bool) {
508         return interfaceId == type(IERC165).interfaceId;
509     }
510 }
511 // File: @openzeppelin/contracts/token/ERC721/ERC721.sol
512 // 
513 // OpenZeppelin Contracts (last updated v4.6.0) (token/ERC721/ERC721.sol)
514 /**
515  * @dev Implementation of https://eips.ethereum.org/EIPS/eip-721[ERC721] Non-Fungible Token Standard, including
516  * the Metadata extension, but not including the Enumerable extension, which is available separately as
517  * {ERC721Enumerable}.
518  */
519 contract ERC721 is Context, ERC165, IERC721, IERC721Metadata {
520     using Address for address;
521     using Strings for uint256;
522     // Token name
523     string private _name;
524     // Token symbol
525     string private _symbol;
526     // Mapping from token ID to owner address
527     mapping(uint256 => address) private _owners;
528     // Mapping owner address to token count
529     mapping(address => uint256) private _balances;
530     // Mapping from token ID to approved address
531     mapping(uint256 => address) private _tokenApprovals;
532     // Mapping from owner to operator approvals
533     mapping(address => mapping(address => bool)) private _operatorApprovals;
534     /**
535      * @dev Initializes the contract by setting a `name` and a `symbol` to the token collection.
536      */
537     constructor(string memory name_, string memory symbol_) {
538         _name = name_;
539         _symbol = symbol_;
540     }
541     /**
542      * @dev See {IERC165-supportsInterface}.
543      */
544     function supportsInterface(bytes4 interfaceId) public view virtual override(ERC165, IERC165) returns (bool) {
545         return
546             interfaceId == type(IERC721).interfaceId ||
547             interfaceId == type(IERC721Metadata).interfaceId ||
548             super.supportsInterface(interfaceId);
549     }
550     /**
551      * @dev See {IERC721-balanceOf}.
552      */
553     function balanceOf(address owner) public view virtual override returns (uint256) {
554         require(owner != address(0), "ERC721: balance query for the zero address");
555         return _balances[owner];
556     }
557     /**
558      * @dev See {IERC721-ownerOf}.
559      */
560     function ownerOf(uint256 tokenId) public view virtual override returns (address) {
561         address owner = _owners[tokenId];
562         require(owner != address(0), "ERC721: owner query for nonexistent token");
563         return owner;
564     }
565     /**
566      * @dev See {IERC721Metadata-name}.
567      */
568     function name() public view virtual override returns (string memory) {
569         return _name;
570     }
571     /**
572      * @dev See {IERC721Metadata-symbol}.
573      */
574     function symbol() public view virtual override returns (string memory) {
575         return _symbol;
576     }
577     /**
578      * @dev See {IERC721Metadata-tokenURI}.
579      */
580     function tokenURI(uint256 tokenId) public view virtual override returns (string memory) {
581         require(_exists(tokenId), "ERC721Metadata: URI query for nonexistent token");
582         string memory baseURI = _baseURI();
583         return bytes(baseURI).length > 0 ? string(abi.encodePacked(baseURI, tokenId.toString())) : "";
584     }
585     /**
586      * @dev Base URI for computing {tokenURI}. If set, the resulting URI for each
587      * token will be the concatenation of the `baseURI` and the `tokenId`. Empty
588      * by default, can be overridden in child contracts.
589      */
590     function _baseURI() internal view virtual returns (string memory) {
591         return "";
592     }
593     /**
594      * @dev See {IERC721-approve}.
595      */
596     function approve(address to, uint256 tokenId) public virtual override {
597         address owner = ERC721.ownerOf(tokenId);
598         require(to != owner, "ERC721: approval to current owner");
599         require(
600             _msgSender() == owner || isApprovedForAll(owner, _msgSender()),
601             "ERC721: approve caller is not owner nor approved for all"
602         );
603         _approve(to, tokenId);
604     }
605     /**
606      * @dev See {IERC721-getApproved}.
607      */
608     function getApproved(uint256 tokenId) public view virtual override returns (address) {
609         require(_exists(tokenId), "ERC721: approved query for nonexistent token");
610         return _tokenApprovals[tokenId];
611     }
612     /**
613      * @dev See {IERC721-setApprovalForAll}.
614      */
615     function setApprovalForAll(address operator, bool approved) public virtual override {
616         _setApprovalForAll(_msgSender(), operator, approved);
617     }
618     /**
619      * @dev See {IERC721-isApprovedForAll}.
620      */
621     function isApprovedForAll(address owner, address operator) public view virtual override returns (bool) {
622         return _operatorApprovals[owner][operator];
623     }
624     /**
625      * @dev See {IERC721-transferFrom}.
626      */
627     function transferFrom(
628         address from,
629         address to,
630         uint256 tokenId
631     ) public virtual override {
632         //solhint-disable-next-line max-line-length
633         require(_isApprovedOrOwner(_msgSender(), tokenId), "ERC721: transfer caller is not owner nor approved");
634         _transfer(from, to, tokenId);
635     }
636     /**
637      * @dev See {IERC721-safeTransferFrom}.
638      */
639     function safeTransferFrom(
640         address from,
641         address to,
642         uint256 tokenId
643     ) public virtual override {
644         safeTransferFrom(from, to, tokenId, "");
645     }
646     /**
647      * @dev See {IERC721-safeTransferFrom}.
648      */
649     function safeTransferFrom(
650         address from,
651         address to,
652         uint256 tokenId,
653         bytes memory _data
654     ) public virtual override {
655         require(_isApprovedOrOwner(_msgSender(), tokenId), "ERC721: transfer caller is not owner nor approved");
656         _safeTransfer(from, to, tokenId, _data);
657     }
658     /**
659      * @dev Safely transfers `tokenId` token from `from` to `to`, checking first that contract recipients
660      * are aware of the ERC721 protocol to prevent tokens from being forever locked.
661      *
662      * `_data` is additional data, it has no specified format and it is sent in call to `to`.
663      *
664      * This internal function is equivalent to {safeTransferFrom}, and can be used to e.g.
665      * implement alternative mechanisms to perform token transfer, such as signature-based.
666      *
667      * Requirements:
668      *
669      * - `from` cannot be the zero address.
670      * - `to` cannot be the zero address.
671      * - `tokenId` token must exist and be owned by `from`.
672      * - If `to` refers to a smart contract, it must implement {IERC721Receiver-onERC721Received}, which is called upon a safe transfer.
673      *
674      * Emits a {Transfer} event.
675      */
676     function _safeTransfer(
677         address from,
678         address to,
679         uint256 tokenId,
680         bytes memory _data
681     ) internal virtual {
682         _transfer(from, to, tokenId);
683         require(_checkOnERC721Received(from, to, tokenId, _data), "ERC721: transfer to non ERC721Receiver implementer");
684     }
685     /**
686      * @dev Returns whether `tokenId` exists.
687      *
688      * Tokens can be managed by their owner or approved accounts via {approve} or {setApprovalForAll}.
689      *
690      * Tokens start existing when they are minted (`_mint`),
691      * and stop existing when they are burned (`_burn`).
692      */
693     function _exists(uint256 tokenId) internal view virtual returns (bool) {
694         return _owners[tokenId] != address(0);
695     }
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
706         return (spender == owner || isApprovedForAll(owner, spender) || getApproved(tokenId) == spender);
707     }
708     /**
709      * @dev Safely mints `tokenId` and transfers it to `to`.
710      *
711      * Requirements:
712      *
713      * - `tokenId` must not exist.
714      * - If `to` refers to a smart contract, it must implement {IERC721Receiver-onERC721Received}, which is called upon a safe transfer.
715      *
716      * Emits a {Transfer} event.
717      */
718     function _safeMint(address to, uint256 tokenId) internal virtual {
719         _safeMint(to, tokenId, "");
720     }
721     /**
722      * @dev Same as {xref-ERC721-_safeMint-address-uint256-}[`_safeMint`], with an additional `data` parameter which is
723      * forwarded in {IERC721Receiver-onERC721Received} to contract recipients.
724      */
725     function _safeMint(
726         address to,
727         uint256 tokenId,
728         bytes memory _data
729     ) internal virtual {
730         _mint(to, tokenId);
731         require(
732             _checkOnERC721Received(address(0), to, tokenId, _data),
733             "ERC721: transfer to non ERC721Receiver implementer"
734         );
735     }
736     /**
737      * @dev Mints `tokenId` and transfers it to `to`.
738      *
739      * WARNING: Usage of this method is discouraged, use {_safeMint} whenever possible
740      *
741      * Requirements:
742      *
743      * - `tokenId` must not exist.
744      * - `to` cannot be the zero address.
745      *
746      * Emits a {Transfer} event.
747      */
748     function _mint(address to, uint256 tokenId) internal virtual {
749         require(to != address(0), "ERC721: mint to the zero address");
750         require(!_exists(tokenId), "ERC721: token already minted");
751         _beforeTokenTransfer(address(0), to, tokenId);
752         _balances[to] += 1;
753         _owners[tokenId] = to;
754         emit Transfer(address(0), to, tokenId);
755         _afterTokenTransfer(address(0), to, tokenId);
756     }
757     /**
758      * @dev Destroys `tokenId`.
759      * The approval is cleared when the token is burned.
760      *
761      * Requirements:
762      *
763      * - `tokenId` must exist.
764      *
765      * Emits a {Transfer} event.
766      */
767     function _burn(uint256 tokenId) internal virtual {
768         address owner = ERC721.ownerOf(tokenId);
769         _beforeTokenTransfer(owner, address(0), tokenId);
770         // Clear approvals
771         _approve(address(0), tokenId);
772         _balances[owner] -= 1;
773         delete _owners[tokenId];
774         emit Transfer(owner, address(0), tokenId);
775         _afterTokenTransfer(owner, address(0), tokenId);
776     }
777     /**
778      * @dev Transfers `tokenId` from `from` to `to`.
779      *  As opposed to {transferFrom}, this imposes no restrictions on msg.sender.
780      *
781      * Requirements:
782      *
783      * - `to` cannot be the zero address.
784      * - `tokenId` token must be owned by `from`.
785      *
786      * Emits a {Transfer} event.
787      */
788     function _transfer(
789         address from,
790         address to,
791         uint256 tokenId
792     ) internal virtual {
793         require(ERC721.ownerOf(tokenId) == from, "ERC721: transfer from incorrect owner");
794         require(to != address(0), "ERC721: transfer to the zero address");
795         _beforeTokenTransfer(from, to, tokenId);
796         // Clear approvals from the previous owner
797         _approve(address(0), tokenId);
798         _balances[from] -= 1;
799         _balances[to] += 1;
800         _owners[tokenId] = to;
801         emit Transfer(from, to, tokenId);
802         _afterTokenTransfer(from, to, tokenId);
803     }
804     /**
805      * @dev Approve `to` to operate on `tokenId`
806      *
807      * Emits a {Approval} event.
808      */
809     function _approve(address to, uint256 tokenId) internal virtual {
810         _tokenApprovals[tokenId] = to;
811         emit Approval(ERC721.ownerOf(tokenId), to, tokenId);
812     }
813     /**
814      * @dev Approve `operator` to operate on all of `owner` tokens
815      *
816      * Emits a {ApprovalForAll} event.
817      */
818     function _setApprovalForAll(
819         address owner,
820         address operator,
821         bool approved
822     ) internal virtual {
823         require(owner != operator, "ERC721: approve to caller");
824         _operatorApprovals[owner][operator] = approved;
825         emit ApprovalForAll(owner, operator, approved);
826     }
827     /**
828      * @dev Internal function to invoke {IERC721Receiver-onERC721Received} on a target address.
829      * The call is not executed if the target address is not a contract.
830      *
831      * @param from address representing the previous owner of the given token ID
832      * @param to target address that will receive the tokens
833      * @param tokenId uint256 ID of the token to be transferred
834      * @param _data bytes optional data to send along with the call
835      * @return bool whether the call correctly returned the expected magic value
836      */
837     function _checkOnERC721Received(
838         address from,
839         address to,
840         uint256 tokenId,
841         bytes memory _data
842     ) private returns (bool) {
843         if (to.isContract()) {
844             try IERC721Receiver(to).onERC721Received(_msgSender(), from, tokenId, _data) returns (bytes4 retval) {
845                 return retval == IERC721Receiver.onERC721Received.selector;
846             } catch (bytes memory reason) {
847                 if (reason.length == 0) {
848                     revert("ERC721: transfer to non ERC721Receiver implementer");
849                 } else {
850                     assembly {
851                         revert(add(32, reason), mload(reason))
852                     }
853                 }
854             }
855         } else {
856             return true;
857         }
858     }
859     /**
860      * @dev Hook that is called before any token transfer. This includes minting
861      * and burning.
862      *
863      * Calling conditions:
864      *
865      * - When `from` and `to` are both non-zero, ``from``'s `tokenId` will be
866      * transferred to `to`.
867      * - When `from` is zero, `tokenId` will be minted for `to`.
868      * - When `to` is zero, ``from``'s `tokenId` will be burned.
869      * - `from` and `to` are never both zero.
870      *
871      * To learn more about hooks, head to xref:ROOT:extending-contracts.adoc#using-hooks[Using Hooks].
872      */
873     function _beforeTokenTransfer(
874         address from,
875         address to,
876         uint256 tokenId
877     ) internal virtual {}
878     /**
879      * @dev Hook that is called after any transfer of tokens. This includes
880      * minting and burning.
881      *
882      * Calling conditions:
883      *
884      * - when `from` and `to` are both non-zero.
885      * - `from` and `to` are never both zero.
886      *
887      * To learn more about hooks, head to xref:ROOT:extending-contracts.adoc#using-hooks[Using Hooks].
888      */
889     function _afterTokenTransfer(
890         address from,
891         address to,
892         uint256 tokenId
893     ) internal virtual {}
894 }
895 // File: @openzeppelin/contracts/access/Ownable.sol
896 // 
897 // OpenZeppelin Contracts v4.4.1 (access/Ownable.sol)
898 /**
899  * @dev Contract module which provides a basic access control mechanism, where
900  * there is an account (an owner) that can be granted exclusive access to
901  * specific functions.
902  *
903  * By default, the owner account will be the one that deploys the contract. This
904  * can later be changed with {transferOwnership}.
905  *
906  * This module is used through inheritance. It will make available the modifier
907  * `onlyOwner`, which can be applied to your functions to restrict their use to
908  * the owner.
909  */
910 abstract contract Ownable is Context {
911     address private _owner;
912     event OwnershipTransferred(address indexed previousOwner, address indexed newOwner);
913     /**
914      * @dev Initializes the contract setting the deployer as the initial owner.
915      */
916     constructor() {
917         _transferOwnership(_msgSender());
918     }
919     /**
920      * @dev Returns the address of the current owner.
921      */
922     function owner() public view virtual returns (address) {
923         return _owner;
924     }
925     /**
926      * @dev Throws if called by any account other than the owner.
927      */
928     modifier onlyOwner() {
929         require(owner() == _msgSender(), "Ownable: caller is not the owner");
930         _;
931     }
932     /**
933      * @dev Leaves the contract without owner. It will not be possible to call
934      * `onlyOwner` functions anymore. Can only be called by the current owner.
935      *
936      * NOTE: Renouncing ownership will leave the contract without an owner,
937      * thereby removing any functionality that is only available to the owner.
938      */
939     function renounceOwnership() public virtual onlyOwner {
940         _transferOwnership(address(0));
941     }
942     /**
943      * @dev Transfers ownership of the contract to a new account (`newOwner`).
944      * Can only be called by the current owner.
945      */
946     function transferOwnership(address newOwner) public virtual onlyOwner {
947         require(newOwner != address(0), "Ownable: new owner is the zero address");
948         _transferOwnership(newOwner);
949     }
950     /**
951      * @dev Transfers ownership of the contract to a new account (`newOwner`).
952      * Internal function without access restriction.
953      */
954     function _transferOwnership(address newOwner) internal virtual {
955         address oldOwner = _owner;
956         _owner = newOwner;
957         emit OwnershipTransferred(oldOwner, newOwner);
958     }
959 }
960 // File: @openzeppelin/contracts/utils/Counters.sol
961 // 
962 // OpenZeppelin Contracts v4.4.1 (utils/Counters.sol)
963 /**
964  * @title Counters
965  * @author Matt Condon (@shrugs)
966  * @dev Provides counters that can only be incremented, decremented or reset. This can be used e.g. to track the number
967  * of elements in a mapping, issuing ERC721 ids, or counting request ids.
968  *
969  * Include with `using Counters for Counters.Counter;`
970  */
971 library Counters {
972     struct Counter {
973         // This variable should never be directly accessed by users of the library: interactions must be restricted to
974         // the library's function. As of Solidity v0.5.2, this cannot be enforced, though there is a proposal to add
975         // this feature: see https://github.com/ethereum/solidity/issues/4637
976         uint256 _value; // default: 0
977     }
978     function current(Counter storage counter) internal view returns (uint256) {
979         return counter._value;
980     }
981     function increment(Counter storage counter) internal {
982         unchecked {
983             counter._value += 1;
984         }
985     }
986     function decrement(Counter storage counter) internal {
987         uint256 value = counter._value;
988         require(value > 0, "Counter: decrement overflow");
989         unchecked {
990             counter._value = value - 1;
991         }
992     }
993     function reset(Counter storage counter) internal {
994         counter._value = 0;
995     }
996 }
997 // File: contracts/ERC721clean.sol
998 // 
999 contract ERC721CarlitoCollection is ERC721, Ownable {
1000     using Counters for Counters.Counter;
1001     Counters.Counter private _tokenIdCounter;
1002     /*
1003      * Base uri for tokens.
1004      */
1005     string private baseUri;
1006     /*
1007      * Enforce the existence of only 100 Tokens.
1008      */
1009     uint256 MAX_SUPPLY;
1010     constructor(
1011         string memory _name,
1012         string memory _symbol,
1013         uint256 _maxSupply,
1014         string memory _baseUri
1015     ) ERC721(_name, _symbol) {
1016         baseUri = _baseUri;
1017         MAX_SUPPLY = _maxSupply;
1018         _tokenIdCounter.increment();
1019     }
1020     /**
1021      * @dev Mints a token to an address with a tokenURI.
1022      * @param to address of the future owner of the token
1023      */
1024     function safeMint(address to) public onlyOwner {
1025         require(canMint(1));
1026         uint256 tokenId = _tokenIdCounter.current();
1027         _tokenIdCounter.increment();
1028         _safeMint(to, tokenId);
1029     }
1030     /**
1031      * @dev Mints a certain amount of NFTs in advance to save gas costs.
1032      * @param _to address of the future owner of the token
1033      * @param amount amount of tokens to mint
1034      */
1035     function preMint(address _to, uint256 amount) public onlyOwner {
1036         require(canMint(amount));
1037         for (uint256 i = 0; i < amount; i++) {
1038             safeMint(_to);
1039         }
1040     }
1041     function airDrop(address[] memory _to) public onlyOwner {
1042         require(canMint(_to.length));
1043         for (uint256 i = 0; i < _to.length; i++) {
1044             safeMint(_to[i]);
1045         }
1046     }
1047     /**
1048      * @dev Checks if amount of tokens can be minted
1049      * @dev Takles the amount of tokens to mint as input, not the type!
1050      * @param amount amount of tokens to mint
1051      */
1052     function canMint(uint256 amount) public view returns (bool) {
1053         return totalSupply() <= (MAX_SUPPLY - amount);
1054     }
1055     /**
1056         @dev Returns the total tokens minted so far.
1057         1 is always subtracted from the Counter since it tracks the next available tokenId.
1058      */
1059     function totalSupply() public view returns (uint256) {
1060         return _tokenIdCounter.current() - 1;
1061     }
1062     
1063     function baseTokenURI() public view returns (string memory) {
1064         return baseUri;
1065     }
1066 
1067     function setBaseTokenURI(string memory _baseUri) public onlyOwner {
1068         baseUri = _baseUri;
1069     }
1070 
1071     function tokenURI(uint256 _tokenId)
1072         public
1073         view
1074         override
1075         returns (string memory)
1076     {
1077         return
1078             string(
1079                 abi.encodePacked(baseTokenURI(), Strings.toString(_tokenId))
1080             );
1081     }
1082 }