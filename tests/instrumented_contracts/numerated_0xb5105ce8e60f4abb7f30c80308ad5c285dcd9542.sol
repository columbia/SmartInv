1 // File: @openzeppelin/contracts/utils/introspection/IERC165.sol
2 
3 // SPDX-License-Identifier: MIT
4 // OpenZeppelin Contracts v4.4.1 (utils/introspection/IERC165.sol)
5 
6 pragma solidity ^0.8.0;
7 
8 /**
9  * @dev Interface of the ERC165 standard, as defined in the
10  * https://eips.ethereum.org/EIPS/eip-165[EIP].
11  *
12  * Implementers can declare support of contract interfaces, which can then be
13  * queried by others ({ERC165Checker}).
14  *
15  * For an implementation, see {ERC165}.
16  */
17 interface IERC165 {
18     /**
19      * @dev Returns true if this contract implements the interface defined by
20      * `interfaceId`. See the corresponding
21      * https://eips.ethereum.org/EIPS/eip-165#how-interfaces-are-identified[EIP section]
22      * to learn more about how these ids are created.
23      *
24      * This function call must use less than 30 000 gas.
25      */
26     function supportsInterface(bytes4 interfaceId) external view returns (bool);
27 }
28 
29 // File: @openzeppelin/contracts/token/ERC721/IERC721.sol
30 
31 
32 // OpenZeppelin Contracts v4.4.1 (token/ERC721/IERC721.sol)
33 
34 pragma solidity ^0.8.0;
35 
36 
37 /**
38  * @dev Required interface of an ERC721 compliant contract.
39  */
40 interface IERC721 is IERC165 {
41     /**
42      * @dev Emitted when `tokenId` token is transferred from `from` to `to`.
43      */
44     event Transfer(address indexed from, address indexed to, uint256 indexed tokenId);
45 
46     /**
47      * @dev Emitted when `owner` enables `approved` to manage the `tokenId` token.
48      */
49     event Approval(address indexed owner, address indexed approved, uint256 indexed tokenId);
50 
51     /**
52      * @dev Emitted when `owner` enables or disables (`approved`) `operator` to manage all of its assets.
53      */
54     event ApprovalForAll(address indexed owner, address indexed operator, bool approved);
55 
56     /**
57      * @dev Returns the number of tokens in ``owner``'s account.
58      */
59     function balanceOf(address owner) external view returns (uint256 balance);
60 
61     /**
62      * @dev Returns the owner of the `tokenId` token.
63      *
64      * Requirements:
65      *
66      * - `tokenId` must exist.
67      */
68     function ownerOf(uint256 tokenId) external view returns (address owner);
69 
70     /**
71      * @dev Safely transfers `tokenId` token from `from` to `to`, checking first that contract recipients
72      * are aware of the ERC721 protocol to prevent tokens from being forever locked.
73      *
74      * Requirements:
75      *
76      * - `from` cannot be the zero address.
77      * - `to` cannot be the zero address.
78      * - `tokenId` token must exist and be owned by `from`.
79      * - If the caller is not `from`, it must be have been allowed to move this token by either {approve} or {setApprovalForAll}.
80      * - If `to` refers to a smart contract, it must implement {IERC721Receiver-onERC721Received}, which is called upon a safe transfer.
81      *
82      * Emits a {Transfer} event.
83      */
84     function safeTransferFrom(
85         address from,
86         address to,
87         uint256 tokenId
88     ) external;
89 
90     /**
91      * @dev Transfers `tokenId` token from `from` to `to`.
92      *
93      * WARNING: Usage of this method is discouraged, use {safeTransferFrom} whenever possible.
94      *
95      * Requirements:
96      *
97      * - `from` cannot be the zero address.
98      * - `to` cannot be the zero address.
99      * - `tokenId` token must be owned by `from`.
100      * - If the caller is not `from`, it must be approved to move this token by either {approve} or {setApprovalForAll}.
101      *
102      * Emits a {Transfer} event.
103      */
104     function transferFrom(
105         address from,
106         address to,
107         uint256 tokenId
108     ) external;
109 
110     /**
111      * @dev Gives permission to `to` to transfer `tokenId` token to another account.
112      * The approval is cleared when the token is transferred.
113      *
114      * Only a single account can be approved at a time, so approving the zero address clears previous approvals.
115      *
116      * Requirements:
117      *
118      * - The caller must own the token or be an approved operator.
119      * - `tokenId` must exist.
120      *
121      * Emits an {Approval} event.
122      */
123     function approve(address to, uint256 tokenId) external;
124 
125     /**
126      * @dev Returns the account approved for `tokenId` token.
127      *
128      * Requirements:
129      *
130      * - `tokenId` must exist.
131      */
132     function getApproved(uint256 tokenId) external view returns (address operator);
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
147      * @dev Returns if the `operator` is allowed to manage all of the assets of `owner`.
148      *
149      * See {setApprovalForAll}
150      */
151     function isApprovedForAll(address owner, address operator) external view returns (bool);
152 
153     /**
154      * @dev Safely transfers `tokenId` token from `from` to `to`.
155      *
156      * Requirements:
157      *
158      * - `from` cannot be the zero address.
159      * - `to` cannot be the zero address.
160      * - `tokenId` token must exist and be owned by `from`.
161      * - If the caller is not `from`, it must be approved to move this token by either {approve} or {setApprovalForAll}.
162      * - If `to` refers to a smart contract, it must implement {IERC721Receiver-onERC721Received}, which is called upon a safe transfer.
163      *
164      * Emits a {Transfer} event.
165      */
166     function safeTransferFrom(
167         address from,
168         address to,
169         uint256 tokenId,
170         bytes calldata data
171     ) external;
172 }
173 
174 // File: @openzeppelin/contracts/token/ERC721/IERC721Receiver.sol
175 
176 
177 // OpenZeppelin Contracts v4.4.1 (token/ERC721/IERC721Receiver.sol)
178 
179 pragma solidity ^0.8.0;
180 
181 /**
182  * @title ERC721 token receiver interface
183  * @dev Interface for any contract that wants to support safeTransfers
184  * from ERC721 asset contracts.
185  */
186 interface IERC721Receiver {
187     /**
188      * @dev Whenever an {IERC721} `tokenId` token is transferred to this contract via {IERC721-safeTransferFrom}
189      * by `operator` from `from`, this function is called.
190      *
191      * It must return its Solidity selector to confirm the token transfer.
192      * If any other value is returned or the interface is not implemented by the recipient, the transfer will be reverted.
193      *
194      * The selector can be obtained in Solidity with `IERC721.onERC721Received.selector`.
195      */
196     function onERC721Received(
197         address operator,
198         address from,
199         uint256 tokenId,
200         bytes calldata data
201     ) external returns (bytes4);
202 }
203 
204 // File: @openzeppelin/contracts/token/ERC721/extensions/IERC721Metadata.sol
205 
206 
207 // OpenZeppelin Contracts v4.4.1 (token/ERC721/extensions/IERC721Metadata.sol)
208 
209 pragma solidity ^0.8.0;
210 
211 
212 /**
213  * @title ERC-721 Non-Fungible Token Standard, optional metadata extension
214  * @dev See https://eips.ethereum.org/EIPS/eip-721
215  */
216 interface IERC721Metadata is IERC721 {
217     /**
218      * @dev Returns the token collection name.
219      */
220     function name() external view returns (string memory);
221 
222     /**
223      * @dev Returns the token collection symbol.
224      */
225     function symbol() external view returns (string memory);
226 
227     /**
228      * @dev Returns the Uniform Resource Identifier (URI) for `tokenId` token.
229      */
230     function tokenURI(uint256 tokenId) external view returns (string memory);
231 }
232 
233 // File: @openzeppelin/contracts/utils/Address.sol
234 
235 
236 // OpenZeppelin Contracts (last updated v4.5.0) (utils/Address.sol)
237 
238 pragma solidity ^0.8.1;
239 
240 /**
241  * @dev Collection of functions related to the address type
242  */
243 library Address {
244     /**
245      * @dev Returns true if `account` is a contract.
246      *
247      * [IMPORTANT]
248      * ====
249      * It is unsafe to assume that an address for which this function returns
250      * false is an externally-owned account (EOA) and not a contract.
251      *
252      * Among others, `isContract` will return false for the following
253      * types of addresses:
254      *
255      *  - an externally-owned account
256      *  - a contract in construction
257      *  - an address where a contract will be created
258      *  - an address where a contract lived, but was destroyed
259      * ====
260      *
261      * [IMPORTANT]
262      * ====
263      * You shouldn't rely on `isContract` to protect against flash loan attacks!
264      *
265      * Preventing calls from contracts is highly discouraged. It breaks composability, breaks support for smart wallets
266      * like Gnosis Safe, and does not provide security since it can be circumvented by calling from a contract
267      * constructor.
268      * ====
269      */
270     function isContract(address account) internal view returns (bool) {
271         // This method relies on extcodesize/address.code.length, which returns 0
272         // for contracts in construction, since the code is only stored at the end
273         // of the constructor execution.
274 
275         return account.code.length > 0;
276     }
277 
278     /**
279      * @dev Replacement for Solidity's `transfer`: sends `amount` wei to
280      * `recipient`, forwarding all available gas and reverting on errors.
281      *
282      * https://eips.ethereum.org/EIPS/eip-1884[EIP1884] increases the gas cost
283      * of certain opcodes, possibly making contracts go over the 2300 gas limit
284      * imposed by `transfer`, making them unable to receive funds via
285      * `transfer`. {sendValue} removes this limitation.
286      *
287      * https://diligence.consensys.net/posts/2019/09/stop-using-soliditys-transfer-now/[Learn more].
288      *
289      * IMPORTANT: because control is transferred to `recipient`, care must be
290      * taken to not create reentrancy vulnerabilities. Consider using
291      * {ReentrancyGuard} or the
292      * https://solidity.readthedocs.io/en/v0.5.11/security-considerations.html#use-the-checks-effects-interactions-pattern[checks-effects-interactions pattern].
293      */
294     function sendValue(address payable recipient, uint256 amount) internal {
295         require(address(this).balance >= amount, "Address: insufficient balance");
296 
297         (bool success, ) = recipient.call{value: amount}("");
298         require(success, "Address: unable to send value, recipient may have reverted");
299     }
300 
301     /**
302      * @dev Performs a Solidity function call using a low level `call`. A
303      * plain `call` is an unsafe replacement for a function call: use this
304      * function instead.
305      *
306      * If `target` reverts with a revert reason, it is bubbled up by this
307      * function (like regular Solidity function calls).
308      *
309      * Returns the raw returned data. To convert to the expected return value,
310      * use https://solidity.readthedocs.io/en/latest/units-and-global-variables.html?highlight=abi.decode#abi-encoding-and-decoding-functions[`abi.decode`].
311      *
312      * Requirements:
313      *
314      * - `target` must be a contract.
315      * - calling `target` with `data` must not revert.
316      *
317      * _Available since v3.1._
318      */
319     function functionCall(address target, bytes memory data) internal returns (bytes memory) {
320         return functionCall(target, data, "Address: low-level call failed");
321     }
322 
323     /**
324      * @dev Same as {xref-Address-functionCall-address-bytes-}[`functionCall`], but with
325      * `errorMessage` as a fallback revert reason when `target` reverts.
326      *
327      * _Available since v3.1._
328      */
329     function functionCall(
330         address target,
331         bytes memory data,
332         string memory errorMessage
333     ) internal returns (bytes memory) {
334         return functionCallWithValue(target, data, 0, errorMessage);
335     }
336 
337     /**
338      * @dev Same as {xref-Address-functionCall-address-bytes-}[`functionCall`],
339      * but also transferring `value` wei to `target`.
340      *
341      * Requirements:
342      *
343      * - the calling contract must have an ETH balance of at least `value`.
344      * - the called Solidity function must be `payable`.
345      *
346      * _Available since v3.1._
347      */
348     function functionCallWithValue(
349         address target,
350         bytes memory data,
351         uint256 value
352     ) internal returns (bytes memory) {
353         return functionCallWithValue(target, data, value, "Address: low-level call with value failed");
354     }
355 
356     /**
357      * @dev Same as {xref-Address-functionCallWithValue-address-bytes-uint256-}[`functionCallWithValue`], but
358      * with `errorMessage` as a fallback revert reason when `target` reverts.
359      *
360      * _Available since v3.1._
361      */
362     function functionCallWithValue(
363         address target,
364         bytes memory data,
365         uint256 value,
366         string memory errorMessage
367     ) internal returns (bytes memory) {
368         require(address(this).balance >= value, "Address: insufficient balance for call");
369         require(isContract(target), "Address: call to non-contract");
370 
371         (bool success, bytes memory returndata) = target.call{value: value}(data);
372         return verifyCallResult(success, returndata, errorMessage);
373     }
374 
375     /**
376      * @dev Same as {xref-Address-functionCall-address-bytes-}[`functionCall`],
377      * but performing a static call.
378      *
379      * _Available since v3.3._
380      */
381     function functionStaticCall(address target, bytes memory data) internal view returns (bytes memory) {
382         return functionStaticCall(target, data, "Address: low-level static call failed");
383     }
384 
385     /**
386      * @dev Same as {xref-Address-functionCall-address-bytes-string-}[`functionCall`],
387      * but performing a static call.
388      *
389      * _Available since v3.3._
390      */
391     function functionStaticCall(
392         address target,
393         bytes memory data,
394         string memory errorMessage
395     ) internal view returns (bytes memory) {
396         require(isContract(target), "Address: static call to non-contract");
397 
398         (bool success, bytes memory returndata) = target.staticcall(data);
399         return verifyCallResult(success, returndata, errorMessage);
400     }
401 
402     /**
403      * @dev Same as {xref-Address-functionCall-address-bytes-}[`functionCall`],
404      * but performing a delegate call.
405      *
406      * _Available since v3.4._
407      */
408     function functionDelegateCall(address target, bytes memory data) internal returns (bytes memory) {
409         return functionDelegateCall(target, data, "Address: low-level delegate call failed");
410     }
411 
412     /**
413      * @dev Same as {xref-Address-functionCall-address-bytes-string-}[`functionCall`],
414      * but performing a delegate call.
415      *
416      * _Available since v3.4._
417      */
418     function functionDelegateCall(
419         address target,
420         bytes memory data,
421         string memory errorMessage
422     ) internal returns (bytes memory) {
423         require(isContract(target), "Address: delegate call to non-contract");
424 
425         (bool success, bytes memory returndata) = target.delegatecall(data);
426         return verifyCallResult(success, returndata, errorMessage);
427     }
428 
429     /**
430      * @dev Tool to verifies that a low level call was successful, and revert if it wasn't, either by bubbling the
431      * revert reason using the provided one.
432      *
433      * _Available since v4.3._
434      */
435     function verifyCallResult(
436         bool success,
437         bytes memory returndata,
438         string memory errorMessage
439     ) internal pure returns (bytes memory) {
440         if (success) {
441             return returndata;
442         } else {
443             // Look for revert reason and bubble it up if present
444             if (returndata.length > 0) {
445                 // The easiest way to bubble the revert reason is using memory via assembly
446 
447                 assembly {
448                     let returndata_size := mload(returndata)
449                     revert(add(32, returndata), returndata_size)
450                 }
451             } else {
452                 revert(errorMessage);
453             }
454         }
455     }
456 }
457 
458 // File: @openzeppelin/contracts/utils/Context.sol
459 
460 
461 // OpenZeppelin Contracts v4.4.1 (utils/Context.sol)
462 
463 pragma solidity ^0.8.0;
464 
465 /**
466  * @dev Provides information about the current execution context, including the
467  * sender of the transaction and its data. While these are generally available
468  * via msg.sender and msg.data, they should not be accessed in such a direct
469  * manner, since when dealing with meta-transactions the account sending and
470  * paying for execution may not be the actual sender (as far as an application
471  * is concerned).
472  *
473  * This contract is only required for intermediate, library-like contracts.
474  */
475 abstract contract Context {
476     function _msgSender() internal view virtual returns (address) {
477         return msg.sender;
478     }
479 
480     function _msgData() internal view virtual returns (bytes calldata) {
481         return msg.data;
482     }
483 }
484 
485 // File: @openzeppelin/contracts/utils/Strings.sol
486 
487 
488 // OpenZeppelin Contracts v4.4.1 (utils/Strings.sol)
489 
490 pragma solidity ^0.8.0;
491 
492 /**
493  * @dev String operations.
494  */
495 library Strings {
496     bytes16 private constant _HEX_SYMBOLS = "0123456789abcdef";
497 
498     /**
499      * @dev Converts a `uint256` to its ASCII `string` decimal representation.
500      */
501     function toString(uint256 value) internal pure returns (string memory) {
502         // Inspired by OraclizeAPI's implementation - MIT licence
503         // https://github.com/oraclize/ethereum-api/blob/b42146b063c7d6ee1358846c198246239e9360e8/oraclizeAPI_0.4.25.sol
504 
505         if (value == 0) {
506             return "0";
507         }
508         uint256 temp = value;
509         uint256 digits;
510         while (temp != 0) {
511             digits++;
512             temp /= 10;
513         }
514         bytes memory buffer = new bytes(digits);
515         while (value != 0) {
516             digits -= 1;
517             buffer[digits] = bytes1(uint8(48 + uint256(value % 10)));
518             value /= 10;
519         }
520         return string(buffer);
521     }
522 
523     /**
524      * @dev Converts a `uint256` to its ASCII `string` hexadecimal representation.
525      */
526     function toHexString(uint256 value) internal pure returns (string memory) {
527         if (value == 0) {
528             return "0x00";
529         }
530         uint256 temp = value;
531         uint256 length = 0;
532         while (temp != 0) {
533             length++;
534             temp >>= 8;
535         }
536         return toHexString(value, length);
537     }
538 
539     /**
540      * @dev Converts a `uint256` to its ASCII `string` hexadecimal representation with fixed length.
541      */
542     function toHexString(uint256 value, uint256 length) internal pure returns (string memory) {
543         bytes memory buffer = new bytes(2 * length + 2);
544         buffer[0] = "0";
545         buffer[1] = "x";
546         for (uint256 i = 2 * length + 1; i > 1; --i) {
547             buffer[i] = _HEX_SYMBOLS[value & 0xf];
548             value >>= 4;
549         }
550         require(value == 0, "Strings: hex length insufficient");
551         return string(buffer);
552     }
553 }
554 
555 // File: @openzeppelin/contracts/utils/introspection/ERC165.sol
556 
557 
558 // OpenZeppelin Contracts v4.4.1 (utils/introspection/ERC165.sol)
559 
560 pragma solidity ^0.8.0;
561 
562 
563 /**
564  * @dev Implementation of the {IERC165} interface.
565  *
566  * Contracts that want to implement ERC165 should inherit from this contract and override {supportsInterface} to check
567  * for the additional interface id that will be supported. For example:
568  *
569  * ```solidity
570  * function supportsInterface(bytes4 interfaceId) public view virtual override returns (bool) {
571  *     return interfaceId == type(MyInterface).interfaceId || super.supportsInterface(interfaceId);
572  * }
573  * ```
574  *
575  * Alternatively, {ERC165Storage} provides an easier to use but more expensive implementation.
576  */
577 abstract contract ERC165 is IERC165 {
578     /**
579      * @dev See {IERC165-supportsInterface}.
580      */
581     function supportsInterface(bytes4 interfaceId) public view virtual override returns (bool) {
582         return interfaceId == type(IERC165).interfaceId;
583     }
584 }
585 
586 // File: @openzeppelin/contracts/token/ERC721/ERC721.sol
587 
588 
589 // OpenZeppelin Contracts (last updated v4.5.0) (token/ERC721/ERC721.sol)
590 
591 pragma solidity ^0.8.0;
592 
593 
594 
595 
596 
597 
598 
599 
600 /**
601  * @dev Implementation of https://eips.ethereum.org/EIPS/eip-721[ERC721] Non-Fungible Token Standard, including
602  * the Metadata extension, but not including the Enumerable extension, which is available separately as
603  * {ERC721Enumerable}.
604  */
605 contract ERC721 is Context, ERC165, IERC721, IERC721Metadata {
606     using Address for address;
607     using Strings for uint256;
608 
609     // Token name
610     string private _name;
611 
612     // Token symbol
613     string private _symbol;
614 
615     // Mapping from token ID to owner address
616     mapping(uint256 => address) private _owners;
617 
618     // Mapping owner address to token count
619     mapping(address => uint256) private _balances;
620 
621     // Mapping from token ID to approved address
622     mapping(uint256 => address) private _tokenApprovals;
623 
624     // Mapping from owner to operator approvals
625     mapping(address => mapping(address => bool)) private _operatorApprovals;
626 
627     /**
628      * @dev Initializes the contract by setting a `name` and a `symbol` to the token collection.
629      */
630     constructor(string memory name_, string memory symbol_) {
631         _name = name_;
632         _symbol = symbol_;
633     }
634 
635     /**
636      * @dev See {IERC165-supportsInterface}.
637      */
638     function supportsInterface(bytes4 interfaceId) public view virtual override(ERC165, IERC165) returns (bool) {
639         return
640             interfaceId == type(IERC721).interfaceId ||
641             interfaceId == type(IERC721Metadata).interfaceId ||
642             super.supportsInterface(interfaceId);
643     }
644 
645     /**
646      * @dev See {IERC721-balanceOf}.
647      */
648     function balanceOf(address owner) public view virtual override returns (uint256) {
649         require(owner != address(0), "ERC721: balance query for the zero address");
650         return _balances[owner];
651     }
652 
653     /**
654      * @dev See {IERC721-ownerOf}.
655      */
656     function ownerOf(uint256 tokenId) public view virtual override returns (address) {
657         address owner = _owners[tokenId];
658         require(owner != address(0), "ERC721: owner query for nonexistent token");
659         return owner;
660     }
661 
662     /**
663      * @dev See {IERC721Metadata-name}.
664      */
665     function name() public view virtual override returns (string memory) {
666         return _name;
667     }
668 
669     /**
670      * @dev See {IERC721Metadata-symbol}.
671      */
672     function symbol() public view virtual override returns (string memory) {
673         return _symbol;
674     }
675 
676     /**
677      * @dev See {IERC721Metadata-tokenURI}.
678      */
679     function tokenURI(uint256 tokenId) public view virtual override returns (string memory) {
680         require(_exists(tokenId), "ERC721Metadata: URI query for nonexistent token");
681 
682         string memory baseURI = _baseURI();
683         return bytes(baseURI).length > 0 ? string(abi.encodePacked(baseURI, tokenId.toString())) : "";
684     }
685 
686     /**
687      * @dev Base URI for computing {tokenURI}. If set, the resulting URI for each
688      * token will be the concatenation of the `baseURI` and the `tokenId`. Empty
689      * by default, can be overriden in child contracts.
690      */
691     function _baseURI() internal view virtual returns (string memory) {
692         return "";
693     }
694 
695     /**
696      * @dev See {IERC721-approve}.
697      */
698     function approve(address to, uint256 tokenId) public virtual override {
699         address owner = ERC721.ownerOf(tokenId);
700         require(to != owner, "ERC721: approval to current owner");
701 
702         require(
703             _msgSender() == owner || isApprovedForAll(owner, _msgSender()),
704             "ERC721: approve caller is not owner nor approved for all"
705         );
706 
707         _approve(to, tokenId);
708     }
709 
710     /**
711      * @dev See {IERC721-getApproved}.
712      */
713     function getApproved(uint256 tokenId) public view virtual override returns (address) {
714         require(_exists(tokenId), "ERC721: approved query for nonexistent token");
715 
716         return _tokenApprovals[tokenId];
717     }
718 
719     /**
720      * @dev See {IERC721-setApprovalForAll}.
721      */
722     function setApprovalForAll(address operator, bool approved) public virtual override {
723         _setApprovalForAll(_msgSender(), operator, approved);
724     }
725 
726     /**
727      * @dev See {IERC721-isApprovedForAll}.
728      */
729     function isApprovedForAll(address owner, address operator) public view virtual override returns (bool) {
730         return _operatorApprovals[owner][operator];
731     }
732 
733     /**
734      * @dev See {IERC721-transferFrom}.
735      */
736     function transferFrom(
737         address from,
738         address to,
739         uint256 tokenId
740     ) public virtual override {
741         //solhint-disable-next-line max-line-length
742         require(_isApprovedOrOwner(_msgSender(), tokenId), "ERC721: transfer caller is not owner nor approved");
743 
744         _transfer(from, to, tokenId);
745     }
746 
747     /**
748      * @dev See {IERC721-safeTransferFrom}.
749      */
750     function safeTransferFrom(
751         address from,
752         address to,
753         uint256 tokenId
754     ) public virtual override {
755         safeTransferFrom(from, to, tokenId, "");
756     }
757 
758     /**
759      * @dev See {IERC721-safeTransferFrom}.
760      */
761     function safeTransferFrom(
762         address from,
763         address to,
764         uint256 tokenId,
765         bytes memory _data
766     ) public virtual override {
767         require(_isApprovedOrOwner(_msgSender(), tokenId), "ERC721: transfer caller is not owner nor approved");
768         _safeTransfer(from, to, tokenId, _data);
769     }
770 
771     /**
772      * @dev Safely transfers `tokenId` token from `from` to `to`, checking first that contract recipients
773      * are aware of the ERC721 protocol to prevent tokens from being forever locked.
774      *
775      * `_data` is additional data, it has no specified format and it is sent in call to `to`.
776      *
777      * This internal function is equivalent to {safeTransferFrom}, and can be used to e.g.
778      * implement alternative mechanisms to perform token transfer, such as signature-based.
779      *
780      * Requirements:
781      *
782      * - `from` cannot be the zero address.
783      * - `to` cannot be the zero address.
784      * - `tokenId` token must exist and be owned by `from`.
785      * - If `to` refers to a smart contract, it must implement {IERC721Receiver-onERC721Received}, which is called upon a safe transfer.
786      *
787      * Emits a {Transfer} event.
788      */
789     function _safeTransfer(
790         address from,
791         address to,
792         uint256 tokenId,
793         bytes memory _data
794     ) internal virtual {
795         _transfer(from, to, tokenId);
796         require(_checkOnERC721Received(from, to, tokenId, _data), "ERC721: transfer to non ERC721Receiver implementer");
797     }
798 
799     /**
800      * @dev Returns whether `tokenId` exists.
801      *
802      * Tokens can be managed by their owner or approved accounts via {approve} or {setApprovalForAll}.
803      *
804      * Tokens start existing when they are minted (`_mint`),
805      * and stop existing when they are burned (`_burn`).
806      */
807     function _exists(uint256 tokenId) internal view virtual returns (bool) {
808         return _owners[tokenId] != address(0);
809     }
810 
811     /**
812      * @dev Returns whether `spender` is allowed to manage `tokenId`.
813      *
814      * Requirements:
815      *
816      * - `tokenId` must exist.
817      */
818     function _isApprovedOrOwner(address spender, uint256 tokenId) internal view virtual returns (bool) {
819         require(_exists(tokenId), "ERC721: operator query for nonexistent token");
820         address owner = ERC721.ownerOf(tokenId);
821         return (spender == owner || getApproved(tokenId) == spender || isApprovedForAll(owner, spender));
822     }
823 
824     /**
825      * @dev Safely mints `tokenId` and transfers it to `to`.
826      *
827      * Requirements:
828      *
829      * - `tokenId` must not exist.
830      * - If `to` refers to a smart contract, it must implement {IERC721Receiver-onERC721Received}, which is called upon a safe transfer.
831      *
832      * Emits a {Transfer} event.
833      */
834     function _safeMint(address to, uint256 tokenId) internal virtual {
835         _safeMint(to, tokenId, "");
836     }
837 
838     /**
839      * @dev Same as {xref-ERC721-_safeMint-address-uint256-}[`_safeMint`], with an additional `data` parameter which is
840      * forwarded in {IERC721Receiver-onERC721Received} to contract recipients.
841      */
842     function _safeMint(
843         address to,
844         uint256 tokenId,
845         bytes memory _data
846     ) internal virtual {
847         _mint(to, tokenId);
848         require(
849             _checkOnERC721Received(address(0), to, tokenId, _data),
850             "ERC721: transfer to non ERC721Receiver implementer"
851         );
852     }
853 
854     /**
855      * @dev Mints `tokenId` and transfers it to `to`.
856      *
857      * WARNING: Usage of this method is discouraged, use {_safeMint} whenever possible
858      *
859      * Requirements:
860      *
861      * - `tokenId` must not exist.
862      * - `to` cannot be the zero address.
863      *
864      * Emits a {Transfer} event.
865      */
866     function _mint(address to, uint256 tokenId) internal virtual {
867         require(to != address(0), "ERC721: mint to the zero address");
868         require(!_exists(tokenId), "ERC721: token already minted");
869 
870         _beforeTokenTransfer(address(0), to, tokenId);
871 
872         _balances[to] += 1;
873         _owners[tokenId] = to;
874 
875         emit Transfer(address(0), to, tokenId);
876 
877         _afterTokenTransfer(address(0), to, tokenId);
878     }
879 
880     /**
881      * @dev Destroys `tokenId`.
882      * The approval is cleared when the token is burned.
883      *
884      * Requirements:
885      *
886      * - `tokenId` must exist.
887      *
888      * Emits a {Transfer} event.
889      */
890     function _burn(uint256 tokenId) internal virtual {
891         address owner = ERC721.ownerOf(tokenId);
892 
893         _beforeTokenTransfer(owner, address(0), tokenId);
894 
895         // Clear approvals
896         _approve(address(0), tokenId);
897 
898         _balances[owner] -= 1;
899         delete _owners[tokenId];
900 
901         emit Transfer(owner, address(0), tokenId);
902 
903         _afterTokenTransfer(owner, address(0), tokenId);
904     }
905 
906     /**
907      * @dev Transfers `tokenId` from `from` to `to`.
908      *  As opposed to {transferFrom}, this imposes no restrictions on msg.sender.
909      *
910      * Requirements:
911      *
912      * - `to` cannot be the zero address.
913      * - `tokenId` token must be owned by `from`.
914      *
915      * Emits a {Transfer} event.
916      */
917     function _transfer(
918         address from,
919         address to,
920         uint256 tokenId
921     ) internal virtual {
922         require(ERC721.ownerOf(tokenId) == from, "ERC721: transfer from incorrect owner");
923         require(to != address(0), "ERC721: transfer to the zero address");
924 
925         _beforeTokenTransfer(from, to, tokenId);
926 
927         // Clear approvals from the previous owner
928         _approve(address(0), tokenId);
929 
930         _balances[from] -= 1;
931         _balances[to] += 1;
932         _owners[tokenId] = to;
933 
934         emit Transfer(from, to, tokenId);
935 
936         _afterTokenTransfer(from, to, tokenId);
937     }
938 
939     /**
940      * @dev Approve `to` to operate on `tokenId`
941      *
942      * Emits a {Approval} event.
943      */
944     function _approve(address to, uint256 tokenId) internal virtual {
945         _tokenApprovals[tokenId] = to;
946         emit Approval(ERC721.ownerOf(tokenId), to, tokenId);
947     }
948 
949     /**
950      * @dev Approve `operator` to operate on all of `owner` tokens
951      *
952      * Emits a {ApprovalForAll} event.
953      */
954     function _setApprovalForAll(
955         address owner,
956         address operator,
957         bool approved
958     ) internal virtual {
959         require(owner != operator, "ERC721: approve to caller");
960         _operatorApprovals[owner][operator] = approved;
961         emit ApprovalForAll(owner, operator, approved);
962     }
963 
964     /**
965      * @dev Internal function to invoke {IERC721Receiver-onERC721Received} on a target address.
966      * The call is not executed if the target address is not a contract.
967      *
968      * @param from address representing the previous owner of the given token ID
969      * @param to target address that will receive the tokens
970      * @param tokenId uint256 ID of the token to be transferred
971      * @param _data bytes optional data to send along with the call
972      * @return bool whether the call correctly returned the expected magic value
973      */
974     function _checkOnERC721Received(
975         address from,
976         address to,
977         uint256 tokenId,
978         bytes memory _data
979     ) private returns (bool) {
980         if (to.isContract()) {
981             try IERC721Receiver(to).onERC721Received(_msgSender(), from, tokenId, _data) returns (bytes4 retval) {
982                 return retval == IERC721Receiver.onERC721Received.selector;
983             } catch (bytes memory reason) {
984                 if (reason.length == 0) {
985                     revert("ERC721: transfer to non ERC721Receiver implementer");
986                 } else {
987                     assembly {
988                         revert(add(32, reason), mload(reason))
989                     }
990                 }
991             }
992         } else {
993             return true;
994         }
995     }
996 
997     /**
998      * @dev Hook that is called before any token transfer. This includes minting
999      * and burning.
1000      *
1001      * Calling conditions:
1002      *
1003      * - When `from` and `to` are both non-zero, ``from``'s `tokenId` will be
1004      * transferred to `to`.
1005      * - When `from` is zero, `tokenId` will be minted for `to`.
1006      * - When `to` is zero, ``from``'s `tokenId` will be burned.
1007      * - `from` and `to` are never both zero.
1008      *
1009      * To learn more about hooks, head to xref:ROOT:extending-contracts.adoc#using-hooks[Using Hooks].
1010      */
1011     function _beforeTokenTransfer(
1012         address from,
1013         address to,
1014         uint256 tokenId
1015     ) internal virtual {}
1016 
1017     /**
1018      * @dev Hook that is called after any transfer of tokens. This includes
1019      * minting and burning.
1020      *
1021      * Calling conditions:
1022      *
1023      * - when `from` and `to` are both non-zero.
1024      * - `from` and `to` are never both zero.
1025      *
1026      * To learn more about hooks, head to xref:ROOT:extending-contracts.adoc#using-hooks[Using Hooks].
1027      */
1028     function _afterTokenTransfer(
1029         address from,
1030         address to,
1031         uint256 tokenId
1032     ) internal virtual {}
1033 }
1034 
1035 // File: @openzeppelin/contracts/access/Ownable.sol
1036 
1037 
1038 // OpenZeppelin Contracts v4.4.1 (access/Ownable.sol)
1039 
1040 pragma solidity ^0.8.0;
1041 
1042 
1043 /**
1044  * @dev Contract module which provides a basic access control mechanism, where
1045  * there is an account (an owner) that can be granted exclusive access to
1046  * specific functions.
1047  *
1048  * By default, the owner account will be the one that deploys the contract. This
1049  * can later be changed with {transferOwnership}.
1050  *
1051  * This module is used through inheritance. It will make available the modifier
1052  * `onlyOwner`, which can be applied to your functions to restrict their use to
1053  * the owner.
1054  */
1055 abstract contract Ownable is Context {
1056     address private _owner;
1057 
1058     event OwnershipTransferred(address indexed previousOwner, address indexed newOwner);
1059 
1060     /**
1061      * @dev Initializes the contract setting the deployer as the initial owner.
1062      */
1063     constructor() {
1064         _transferOwnership(_msgSender());
1065     }
1066 
1067     /**
1068      * @dev Returns the address of the current owner.
1069      */
1070     function owner() public view virtual returns (address) {
1071         return _owner;
1072     }
1073 
1074     /**
1075      * @dev Throws if called by any account other than the owner.
1076      */
1077     modifier onlyOwner() {
1078         require(owner() == _msgSender(), "Ownable: caller is not the owner");
1079         _;
1080     }
1081 
1082     /**
1083      * @dev Leaves the contract without owner. It will not be possible to call
1084      * `onlyOwner` functions anymore. Can only be called by the current owner.
1085      *
1086      * NOTE: Renouncing ownership will leave the contract without an owner,
1087      * thereby removing any functionality that is only available to the owner.
1088      */
1089     function renounceOwnership() public virtual onlyOwner {
1090         _transferOwnership(address(0));
1091     }
1092 
1093     /**
1094      * @dev Transfers ownership of the contract to a new account (`newOwner`).
1095      * Can only be called by the current owner.
1096      */
1097     function transferOwnership(address newOwner) public virtual onlyOwner {
1098         require(newOwner != address(0), "Ownable: new owner is the zero address");
1099         _transferOwnership(newOwner);
1100     }
1101 
1102     /**
1103      * @dev Transfers ownership of the contract to a new account (`newOwner`).
1104      * Internal function without access restriction.
1105      */
1106     function _transferOwnership(address newOwner) internal virtual {
1107         address oldOwner = _owner;
1108         _owner = newOwner;
1109         emit OwnershipTransferred(oldOwner, newOwner);
1110     }
1111 }
1112 
1113 // File: @openzeppelin/contracts/utils/cryptography/MerkleProof.sol
1114 
1115 
1116 // OpenZeppelin Contracts (last updated v4.5.0) (utils/cryptography/MerkleProof.sol)
1117 
1118 pragma solidity ^0.8.0;
1119 
1120 /**
1121  * @dev These functions deal with verification of Merkle Trees proofs.
1122  *
1123  * The proofs can be generated using the JavaScript library
1124  * https://github.com/miguelmota/merkletreejs[merkletreejs].
1125  * Note: the hashing algorithm should be keccak256 and pair sorting should be enabled.
1126  *
1127  * See `test/utils/cryptography/MerkleProof.test.js` for some examples.
1128  */
1129 library MerkleProof {
1130     /**
1131      * @dev Returns true if a `leaf` can be proved to be a part of a Merkle tree
1132      * defined by `root`. For this, a `proof` must be provided, containing
1133      * sibling hashes on the branch from the leaf to the root of the tree. Each
1134      * pair of leaves and each pair of pre-images are assumed to be sorted.
1135      */
1136     function verify(
1137         bytes32[] memory proof,
1138         bytes32 root,
1139         bytes32 leaf
1140     ) internal pure returns (bool) {
1141         return processProof(proof, leaf) == root;
1142     }
1143 
1144     /**
1145      * @dev Returns the rebuilt hash obtained by traversing a Merklee tree up
1146      * from `leaf` using `proof`. A `proof` is valid if and only if the rebuilt
1147      * hash matches the root of the tree. When processing the proof, the pairs
1148      * of leafs & pre-images are assumed to be sorted.
1149      *
1150      * _Available since v4.4._
1151      */
1152     function processProof(bytes32[] memory proof, bytes32 leaf) internal pure returns (bytes32) {
1153         bytes32 computedHash = leaf;
1154         for (uint256 i = 0; i < proof.length; i++) {
1155             bytes32 proofElement = proof[i];
1156             if (computedHash <= proofElement) {
1157                 // Hash(current computed hash + current element of the proof)
1158                 computedHash = _efficientHash(computedHash, proofElement);
1159             } else {
1160                 // Hash(current element of the proof + current computed hash)
1161                 computedHash = _efficientHash(proofElement, computedHash);
1162             }
1163         }
1164         return computedHash;
1165     }
1166 
1167     function _efficientHash(bytes32 a, bytes32 b) private pure returns (bytes32 value) {
1168         assembly {
1169             mstore(0x00, a)
1170             mstore(0x20, b)
1171             value := keccak256(0x00, 0x40)
1172         }
1173     }
1174 }
1175 
1176 // File: @openzeppelin/contracts/utils/math/SafeMath.sol
1177 
1178 
1179 // OpenZeppelin Contracts v4.4.1 (utils/math/SafeMath.sol)
1180 
1181 pragma solidity ^0.8.0;
1182 
1183 // CAUTION
1184 // This version of SafeMath should only be used with Solidity 0.8 or later,
1185 // because it relies on the compiler's built in overflow checks.
1186 
1187 /**
1188  * @dev Wrappers over Solidity's arithmetic operations.
1189  *
1190  * NOTE: `SafeMath` is generally not needed starting with Solidity 0.8, since the compiler
1191  * now has built in overflow checking.
1192  */
1193 library SafeMath {
1194     /**
1195      * @dev Returns the addition of two unsigned integers, with an overflow flag.
1196      *
1197      * _Available since v3.4._
1198      */
1199     function tryAdd(uint256 a, uint256 b) internal pure returns (bool, uint256) {
1200         unchecked {
1201             uint256 c = a + b;
1202             if (c < a) return (false, 0);
1203             return (true, c);
1204         }
1205     }
1206 
1207     /**
1208      * @dev Returns the substraction of two unsigned integers, with an overflow flag.
1209      *
1210      * _Available since v3.4._
1211      */
1212     function trySub(uint256 a, uint256 b) internal pure returns (bool, uint256) {
1213         unchecked {
1214             if (b > a) return (false, 0);
1215             return (true, a - b);
1216         }
1217     }
1218 
1219     /**
1220      * @dev Returns the multiplication of two unsigned integers, with an overflow flag.
1221      *
1222      * _Available since v3.4._
1223      */
1224     function tryMul(uint256 a, uint256 b) internal pure returns (bool, uint256) {
1225         unchecked {
1226             // Gas optimization: this is cheaper than requiring 'a' not being zero, but the
1227             // benefit is lost if 'b' is also tested.
1228             // See: https://github.com/OpenZeppelin/openzeppelin-contracts/pull/522
1229             if (a == 0) return (true, 0);
1230             uint256 c = a * b;
1231             if (c / a != b) return (false, 0);
1232             return (true, c);
1233         }
1234     }
1235 
1236     /**
1237      * @dev Returns the division of two unsigned integers, with a division by zero flag.
1238      *
1239      * _Available since v3.4._
1240      */
1241     function tryDiv(uint256 a, uint256 b) internal pure returns (bool, uint256) {
1242         unchecked {
1243             if (b == 0) return (false, 0);
1244             return (true, a / b);
1245         }
1246     }
1247 
1248     /**
1249      * @dev Returns the remainder of dividing two unsigned integers, with a division by zero flag.
1250      *
1251      * _Available since v3.4._
1252      */
1253     function tryMod(uint256 a, uint256 b) internal pure returns (bool, uint256) {
1254         unchecked {
1255             if (b == 0) return (false, 0);
1256             return (true, a % b);
1257         }
1258     }
1259 
1260     /**
1261      * @dev Returns the addition of two unsigned integers, reverting on
1262      * overflow.
1263      *
1264      * Counterpart to Solidity's `+` operator.
1265      *
1266      * Requirements:
1267      *
1268      * - Addition cannot overflow.
1269      */
1270     function add(uint256 a, uint256 b) internal pure returns (uint256) {
1271         return a + b;
1272     }
1273 
1274     /**
1275      * @dev Returns the subtraction of two unsigned integers, reverting on
1276      * overflow (when the result is negative).
1277      *
1278      * Counterpart to Solidity's `-` operator.
1279      *
1280      * Requirements:
1281      *
1282      * - Subtraction cannot overflow.
1283      */
1284     function sub(uint256 a, uint256 b) internal pure returns (uint256) {
1285         return a - b;
1286     }
1287 
1288     /**
1289      * @dev Returns the multiplication of two unsigned integers, reverting on
1290      * overflow.
1291      *
1292      * Counterpart to Solidity's `*` operator.
1293      *
1294      * Requirements:
1295      *
1296      * - Multiplication cannot overflow.
1297      */
1298     function mul(uint256 a, uint256 b) internal pure returns (uint256) {
1299         return a * b;
1300     }
1301 
1302     /**
1303      * @dev Returns the integer division of two unsigned integers, reverting on
1304      * division by zero. The result is rounded towards zero.
1305      *
1306      * Counterpart to Solidity's `/` operator.
1307      *
1308      * Requirements:
1309      *
1310      * - The divisor cannot be zero.
1311      */
1312     function div(uint256 a, uint256 b) internal pure returns (uint256) {
1313         return a / b;
1314     }
1315 
1316     /**
1317      * @dev Returns the remainder of dividing two unsigned integers. (unsigned integer modulo),
1318      * reverting when dividing by zero.
1319      *
1320      * Counterpart to Solidity's `%` operator. This function uses a `revert`
1321      * opcode (which leaves remaining gas untouched) while Solidity uses an
1322      * invalid opcode to revert (consuming all remaining gas).
1323      *
1324      * Requirements:
1325      *
1326      * - The divisor cannot be zero.
1327      */
1328     function mod(uint256 a, uint256 b) internal pure returns (uint256) {
1329         return a % b;
1330     }
1331 
1332     /**
1333      * @dev Returns the subtraction of two unsigned integers, reverting with custom message on
1334      * overflow (when the result is negative).
1335      *
1336      * CAUTION: This function is deprecated because it requires allocating memory for the error
1337      * message unnecessarily. For custom revert reasons use {trySub}.
1338      *
1339      * Counterpart to Solidity's `-` operator.
1340      *
1341      * Requirements:
1342      *
1343      * - Subtraction cannot overflow.
1344      */
1345     function sub(
1346         uint256 a,
1347         uint256 b,
1348         string memory errorMessage
1349     ) internal pure returns (uint256) {
1350         unchecked {
1351             require(b <= a, errorMessage);
1352             return a - b;
1353         }
1354     }
1355 
1356     /**
1357      * @dev Returns the integer division of two unsigned integers, reverting with custom message on
1358      * division by zero. The result is rounded towards zero.
1359      *
1360      * Counterpart to Solidity's `/` operator. Note: this function uses a
1361      * `revert` opcode (which leaves remaining gas untouched) while Solidity
1362      * uses an invalid opcode to revert (consuming all remaining gas).
1363      *
1364      * Requirements:
1365      *
1366      * - The divisor cannot be zero.
1367      */
1368     function div(
1369         uint256 a,
1370         uint256 b,
1371         string memory errorMessage
1372     ) internal pure returns (uint256) {
1373         unchecked {
1374             require(b > 0, errorMessage);
1375             return a / b;
1376         }
1377     }
1378 
1379     /**
1380      * @dev Returns the remainder of dividing two unsigned integers. (unsigned integer modulo),
1381      * reverting with custom message when dividing by zero.
1382      *
1383      * CAUTION: This function is deprecated because it requires allocating memory for the error
1384      * message unnecessarily. For custom revert reasons use {tryMod}.
1385      *
1386      * Counterpart to Solidity's `%` operator. This function uses a `revert`
1387      * opcode (which leaves remaining gas untouched) while Solidity uses an
1388      * invalid opcode to revert (consuming all remaining gas).
1389      *
1390      * Requirements:
1391      *
1392      * - The divisor cannot be zero.
1393      */
1394     function mod(
1395         uint256 a,
1396         uint256 b,
1397         string memory errorMessage
1398     ) internal pure returns (uint256) {
1399         unchecked {
1400             require(b > 0, errorMessage);
1401             return a % b;
1402         }
1403     }
1404 }
1405 
1406 // File: contracts/NFT.sol
1407 
1408 
1409 
1410 pragma solidity 0.8.12;
1411 
1412 
1413 
1414 
1415 
1416 contract TrillioHeirs is ERC721, Ownable {
1417     using SafeMath for uint256;
1418 
1419     bool public paused = false;
1420     bool public presale = true;
1421     string public baseURI;
1422 
1423     uint256 public mintedAmount_1 = 0;
1424     uint256 public mintedAmount_2 = 0;
1425     uint256 public mintedAmount_3 = 0;
1426     uint256 public mintedAmount_4 = 0;
1427 
1428     uint256 public maxMint_presale = 3000;
1429     uint256 public maxMint_1 = 7000;
1430     uint256 public maxMint_2 = 1500;
1431     uint256 public maxMint_3 = 370;
1432     uint256 public maxMint_4 = 18;
1433 
1434     uint256 public presalePrice = 0.15 ether;
1435     uint256 public publicsalePrice = 0.18 ether;
1436 
1437     uint256 public presaleMaxMint = 10;
1438     uint256 public publicsaleMaxMint = 5;
1439 
1440     bytes32 private merkleTreeRoot_1;
1441     bytes32 private merkleTreeRoot_2;
1442     bytes32 private merkleTreeRoot_3;
1443 
1444     mapping(address => bool) presaleAttenders;
1445 
1446     uint256 public ownerMintTotal = 206;
1447     uint256 ownerMint_1 = 0;
1448     uint256 ownerMint_2 = 0;
1449     uint256 ownerMint_3 = 0;
1450     uint256 ownerMint_4 = 0;
1451 
1452     struct SpecialWallet {
1453         uint256 level;
1454         uint256 maxMintAmount;
1455     }
1456     mapping(address => SpecialWallet) specialListInfo;
1457 
1458     constructor(string memory name, string memory symbol, string memory baseUrl) ERC721(name, symbol) {
1459         setBaseURI(baseUrl);
1460     }
1461 
1462     receive() external payable {}
1463 
1464     function withdrawAll() external onlyOwner {
1465         uint256 amount = address(this).balance;
1466         payable(owner()).transfer(amount);
1467     }
1468 
1469     function _baseURI() internal view virtual override returns (string memory) {
1470         return baseURI;
1471     }
1472 
1473     function setBaseURI(string memory _newBaseURI) public onlyOwner {
1474         baseURI = _newBaseURI;
1475     }
1476 
1477     function setPresale(bool s_) public onlyOwner {
1478         require(presale == true, "TrillioHeirs: presale can be set only once");
1479         presale = s_;
1480     }
1481 
1482     modifier isPresale {
1483         require(presale, "TrillioHeirs: presale finished");
1484         _;
1485     }
1486 
1487     modifier isPublicsale {
1488         require(!presale, "TrillioHeirs: public sale not started");
1489         _;
1490     }
1491 
1492     function setPaused(bool s_) public onlyOwner {
1493         paused = s_;
1494     }
1495 
1496     modifier emergencyPause {
1497         require(!paused);
1498         _;
1499     }
1500 
1501     function _getRemainingForLvl(uint256 lvl) private view returns(uint256) {
1502         if (lvl == 1)
1503             return maxMint_1 - mintedAmount_1;
1504         else if (lvl == 2)
1505             return maxMint_2 - mintedAmount_2;
1506         else if (lvl == 3)
1507             return maxMint_3 - mintedAmount_3;
1508         else 
1509             return 0;
1510     }
1511 
1512     function addToSpecialList(address[] memory addresses, uint256[] memory levels, uint256[] memory maxMintCounts) public onlyOwner {
1513         require(addresses.length == levels.length && levels.length == maxMintCounts.length, "TrillioHeirs: arrays has different length");
1514 
1515         for (uint256 i = 0; i < addresses.length; i++) {
1516             require(levels[i] > 0 && levels[i] < 4, "TrillioHeirs: The level of special wallet can not be greater than 4");
1517             SpecialWallet memory item = SpecialWallet(levels[i], maxMintCounts[i]);
1518             specialListInfo[addresses[i]] = item;
1519         }
1520     }
1521 
1522     function _getPresoldAmount() private view returns(uint256) {
1523         return mintedAmount_1 + mintedAmount_2 + mintedAmount_3;
1524     }
1525 
1526     function _getPresaleCost(uint256 amount) private view returns(uint256) {
1527         return presalePrice.mul(amount);
1528     }
1529 
1530     function setMerkleTree(bytes32 root_, uint256 lvl) public onlyOwner {
1531         if (lvl == 1)
1532             merkleTreeRoot_1 = root_;
1533         else if (lvl == 2)
1534             merkleTreeRoot_2 = root_;
1535         else 
1536             merkleTreeRoot_3 = root_;
1537     }
1538 
1539     function _verifyWhitelist(bytes32[] memory proof, uint256 lvl) private view returns(bool) {
1540         bytes32 leaf = keccak256(abi.encodePacked(msg.sender));
1541         if(lvl == 1)
1542             return MerkleProof.verify(proof, merkleTreeRoot_1, leaf);
1543         else if (lvl == 2)
1544             return MerkleProof.verify(proof, merkleTreeRoot_2, leaf);
1545         else 
1546             return MerkleProof.verify(proof, merkleTreeRoot_3, leaf);
1547     }
1548 
1549     function presaleMint(uint256 amount, uint256 lvl, bytes32[] memory proof) public payable emergencyPause isPresale {
1550         uint256 estimatedAmount = balanceOf(msg.sender).add(amount);
1551         require(estimatedAmount <= presaleMaxMint, "TrillioHeirs: You have already minted max NFTs or you are going to mint too many NFTs now");
1552         require(_verifyWhitelist(proof, lvl), "TrillioHeirs: Only whitelisted wallet can attend in presale");
1553         require(_getPresoldAmount() < maxMint_presale, "TrillioHeirs: In presale, Only 3000 NFTs can be mint");
1554         require(_getRemainingForLvl(lvl) >= amount, "TrillioHeirs: Mint amount can not be greater than remaining NFT amount in each level");
1555         require(msg.value == _getPresaleCost(amount), "TrillioHeirs: Msg.value is less than the real value");
1556         if (lvl == 1) {
1557             for(uint256 i = 1 ; i <= amount ; i++)
1558                 _safeMint(msg.sender, mintedAmount_1 + i);
1559             mintedAmount_1 += amount;
1560         } else if (lvl == 2) {
1561             for(uint256 i = 1 ; i <= amount ; i++)
1562                 _safeMint(msg.sender, (mintedAmount_2 + maxMint_1 + i));
1563             mintedAmount_2 += amount;
1564         } else {
1565             for(uint256 i = 1 ; i <= amount ; i++)
1566                 _safeMint(msg.sender, (mintedAmount_3 + maxMint_1 + maxMint_2 + i));
1567             mintedAmount_3 += amount;
1568         }
1569         presaleAttenders[msg.sender] = true;
1570     }
1571 
1572     function _getRandomLevel() private view returns(uint256) {
1573         uint256 remain = _getRemainingForLvl(1).add(_getRemainingForLvl(2)).add(_getRemainingForLvl(3)).sub(_getRemainingOwnerMintAmount());
1574         require(remain >= 1, "TrillioHeirs: Remaining NFT is not enough");
1575         uint256 random = uint256(keccak256(abi.encodePacked(block.difficulty, block.timestamp, msg.sender, mintedAmount_1, mintedAmount_2, mintedAmount_3)));
1576         uint256 lvl = random.mod(3).add(1);
1577         uint256 count = 0;
1578         while (_getRemainingForLvl(lvl) < 1) {
1579             lvl = lvl.mod(3).add(1);
1580             if (count == 2)
1581                 return 0;
1582             count++;
1583         }
1584         return lvl;
1585     }
1586 
1587     function _getPublicsaleCost(uint256 amount) private view returns(uint256) {
1588         return amount.mul(publicsalePrice);
1589     }
1590 
1591     function publicsaleMint(uint256 amount) public payable emergencyPause isPublicsale {
1592         uint256 estimatedAmount = balanceOf(msg.sender).add(amount);
1593         if(presaleAttenders[msg.sender])
1594             require(estimatedAmount <= (publicsaleMaxMint + presaleMaxMint), "TrillioHeirs: You have already minted max NFTs or you are going to mint too many NFTs now");
1595         else
1596             require(estimatedAmount <= publicsaleMaxMint, "TrillioHeirs: You have already minted max NFTs or you are going to mint too many NFTs now");
1597         require(msg.value == _getPublicsaleCost(amount), "TrillioHeirs: Msg.value is not enough");
1598         for (uint256 i = 1; i <= amount ; i++) {
1599             uint256 randomLvl = _getRandomLevel();
1600             require(randomLvl > 0, "TrillioHeirs: Amount of remaining NFT for each level is not enough");
1601 
1602             if (randomLvl == 1) {
1603                 _safeMint(msg.sender, mintedAmount_1 + 1);
1604                 mintedAmount_1 += 1;
1605             } else if (randomLvl == 2) {
1606                 _safeMint(msg.sender, (mintedAmount_2 + maxMint_1 + 1));
1607                 mintedAmount_2 += 1;
1608             } else {
1609                 _safeMint(msg.sender, (mintedAmount_3 + maxMint_1 + maxMint_2 + 1));
1610                 mintedAmount_3 += 1;
1611             }
1612         }
1613     }
1614 
1615     function specialMint(uint256 amount) public emergencyPause isPublicsale {
1616         uint256 estimatedAmount = balanceOf(msg.sender).add(amount);
1617         uint256 remain = _getRemainingForLvl(1).add(_getRemainingForLvl(2)).add(_getRemainingForLvl(3));
1618         require(amount <= remain, "TrilloHeirs: Remaining NFT is not enough");
1619         uint256 maxMintAmount = specialListInfo[msg.sender].maxMintAmount;
1620         if(presaleAttenders[msg.sender])
1621             require(estimatedAmount <= (maxMintAmount + presaleMaxMint), "Trillioheirs: Amount can not be greater than max mint amount");
1622         else
1623             require(estimatedAmount <= maxMintAmount, "Trillioheirs: Amount can not be greater than max mint amount");
1624         uint256 lvl = specialListInfo[msg.sender].level;
1625         require(amount <= _getRemainingForLvl(lvl), "Trillioheirs: Remaining NFT for level is not enough");
1626 
1627         if (lvl == 1) {
1628             for(uint256 i = 1 ; i <= amount ; i++)
1629                 _safeMint(msg.sender, mintedAmount_1 + i);
1630             mintedAmount_1 += amount;
1631         } else if (lvl == 2) {
1632             for(uint256 i = 1 ; i <= amount ; i++)
1633                 _safeMint(msg.sender, (mintedAmount_2 + maxMint_1 + i));
1634             mintedAmount_2 += amount;
1635         } else {
1636             for(uint256 i = 1 ; i <= amount ; i++)
1637                 _safeMint(msg.sender, (mintedAmount_3 + maxMint_1 + maxMint_2 + i));
1638             mintedAmount_3 += amount;
1639         }
1640     }
1641 
1642     function _getRemainingOwnerMintAmount() private view returns(uint256) {
1643         return (ownerMintTotal.sub(maxMint_4)).sub(ownerMint_1.add(ownerMint_2).add(ownerMint_3));
1644     }
1645 
1646     function ownerLvl4Mint() public onlyOwner {
1647         uint256 remaining = maxMint_4.sub(mintedAmount_4);
1648         require(remaining > 0, "TrillioHeirs: level 4 already minted");
1649         for(uint256 i = 1 ; i <= remaining ; i++)
1650             _safeMint(msg.sender, (mintedAmount_4 + maxMint_1 + maxMint_2 + maxMint_3 + i));
1651         mintedAmount_4 += remaining;
1652         ownerMint_4 += remaining;
1653     }
1654 }