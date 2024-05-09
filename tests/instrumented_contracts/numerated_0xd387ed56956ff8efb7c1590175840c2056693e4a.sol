1 // Sources flattened with hardhat v2.9.9 https://hardhat.org
2 
3 // File @openzeppelin/contracts/utils/introspection/IERC165.sol@v4.6.0
4 
5 // SPDX-License-Identifier: MIT
6 // OpenZeppelin Contracts v4.4.1 (utils/introspection/IERC165.sol)
7 
8 pragma solidity ^0.8.0;
9 
10 /**
11  * @dev Interface of the ERC165 standard, as defined in the
12  * https://eips.ethereum.org/EIPS/eip-165[EIP].
13  *
14  * Implementers can declare support of contract interfaces, which can then be
15  * queried by others ({ERC165Checker}).
16  *
17  * For an implementation, see {ERC165}.
18  */
19 interface IERC165 {
20     /**
21      * @dev Returns true if this contract implements the interface defined by
22      * `interfaceId`. See the corresponding
23      * https://eips.ethereum.org/EIPS/eip-165#how-interfaces-are-identified[EIP section]
24      * to learn more about how these ids are created.
25      *
26      * This function call must use less than 30 000 gas.
27      */
28     function supportsInterface(bytes4 interfaceId) external view returns (bool);
29 }
30 
31 
32 // File @openzeppelin/contracts/token/ERC721/IERC721.sol@v4.6.0
33 
34 // OpenZeppelin Contracts (last updated v4.6.0) (token/ERC721/IERC721.sol)
35 
36 pragma solidity ^0.8.0;
37 
38 /**
39  * @dev Required interface of an ERC721 compliant contract.
40  */
41 interface IERC721 is IERC165 {
42     /**
43      * @dev Emitted when `tokenId` token is transferred from `from` to `to`.
44      */
45     event Transfer(address indexed from, address indexed to, uint256 indexed tokenId);
46 
47     /**
48      * @dev Emitted when `owner` enables `approved` to manage the `tokenId` token.
49      */
50     event Approval(address indexed owner, address indexed approved, uint256 indexed tokenId);
51 
52     /**
53      * @dev Emitted when `owner` enables or disables (`approved`) `operator` to manage all of its assets.
54      */
55     event ApprovalForAll(address indexed owner, address indexed operator, bool approved);
56 
57     /**
58      * @dev Returns the number of tokens in ``owner``'s account.
59      */
60     function balanceOf(address owner) external view returns (uint256 balance);
61 
62     /**
63      * @dev Returns the owner of the `tokenId` token.
64      *
65      * Requirements:
66      *
67      * - `tokenId` must exist.
68      */
69     function ownerOf(uint256 tokenId) external view returns (address owner);
70 
71     /**
72      * @dev Safely transfers `tokenId` token from `from` to `to`.
73      *
74      * Requirements:
75      *
76      * - `from` cannot be the zero address.
77      * - `to` cannot be the zero address.
78      * - `tokenId` token must exist and be owned by `from`.
79      * - If the caller is not `from`, it must be approved to move this token by either {approve} or {setApprovalForAll}.
80      * - If `to` refers to a smart contract, it must implement {IERC721Receiver-onERC721Received}, which is called upon a safe transfer.
81      *
82      * Emits a {Transfer} event.
83      */
84     function safeTransferFrom(
85         address from,
86         address to,
87         uint256 tokenId,
88         bytes calldata data
89     ) external;
90 
91     /**
92      * @dev Safely transfers `tokenId` token from `from` to `to`, checking first that contract recipients
93      * are aware of the ERC721 protocol to prevent tokens from being forever locked.
94      *
95      * Requirements:
96      *
97      * - `from` cannot be the zero address.
98      * - `to` cannot be the zero address.
99      * - `tokenId` token must exist and be owned by `from`.
100      * - If the caller is not `from`, it must be have been allowed to move this token by either {approve} or {setApprovalForAll}.
101      * - If `to` refers to a smart contract, it must implement {IERC721Receiver-onERC721Received}, which is called upon a safe transfer.
102      *
103      * Emits a {Transfer} event.
104      */
105     function safeTransferFrom(
106         address from,
107         address to,
108         uint256 tokenId
109     ) external;
110 
111     /**
112      * @dev Transfers `tokenId` token from `from` to `to`.
113      *
114      * WARNING: Usage of this method is discouraged, use {safeTransferFrom} whenever possible.
115      *
116      * Requirements:
117      *
118      * - `from` cannot be the zero address.
119      * - `to` cannot be the zero address.
120      * - `tokenId` token must be owned by `from`.
121      * - If the caller is not `from`, it must be approved to move this token by either {approve} or {setApprovalForAll}.
122      *
123      * Emits a {Transfer} event.
124      */
125     function transferFrom(
126         address from,
127         address to,
128         uint256 tokenId
129     ) external;
130 
131     /**
132      * @dev Gives permission to `to` to transfer `tokenId` token to another account.
133      * The approval is cleared when the token is transferred.
134      *
135      * Only a single account can be approved at a time, so approving the zero address clears previous approvals.
136      *
137      * Requirements:
138      *
139      * - The caller must own the token or be an approved operator.
140      * - `tokenId` must exist.
141      *
142      * Emits an {Approval} event.
143      */
144     function approve(address to, uint256 tokenId) external;
145 
146     /**
147      * @dev Approve or remove `operator` as an operator for the caller.
148      * Operators can call {transferFrom} or {safeTransferFrom} for any token owned by the caller.
149      *
150      * Requirements:
151      *
152      * - The `operator` cannot be the caller.
153      *
154      * Emits an {ApprovalForAll} event.
155      */
156     function setApprovalForAll(address operator, bool _approved) external;
157 
158     /**
159      * @dev Returns the account approved for `tokenId` token.
160      *
161      * Requirements:
162      *
163      * - `tokenId` must exist.
164      */
165     function getApproved(uint256 tokenId) external view returns (address operator);
166 
167     /**
168      * @dev Returns if the `operator` is allowed to manage all of the assets of `owner`.
169      *
170      * See {setApprovalForAll}
171      */
172     function isApprovedForAll(address owner, address operator) external view returns (bool);
173 }
174 
175 
176 // File @openzeppelin/contracts/token/ERC721/IERC721Receiver.sol@v4.6.0
177 
178 // OpenZeppelin Contracts (last updated v4.6.0) (token/ERC721/IERC721Receiver.sol)
179 
180 pragma solidity ^0.8.0;
181 
182 /**
183  * @title ERC721 token receiver interface
184  * @dev Interface for any contract that wants to support safeTransfers
185  * from ERC721 asset contracts.
186  */
187 interface IERC721Receiver {
188     /**
189      * @dev Whenever an {IERC721} `tokenId` token is transferred to this contract via {IERC721-safeTransferFrom}
190      * by `operator` from `from`, this function is called.
191      *
192      * It must return its Solidity selector to confirm the token transfer.
193      * If any other value is returned or the interface is not implemented by the recipient, the transfer will be reverted.
194      *
195      * The selector can be obtained in Solidity with `IERC721Receiver.onERC721Received.selector`.
196      */
197     function onERC721Received(
198         address operator,
199         address from,
200         uint256 tokenId,
201         bytes calldata data
202     ) external returns (bytes4);
203 }
204 
205 
206 // File @openzeppelin/contracts/token/ERC721/extensions/IERC721Metadata.sol@v4.6.0
207 
208 // OpenZeppelin Contracts v4.4.1 (token/ERC721/extensions/IERC721Metadata.sol)
209 
210 pragma solidity ^0.8.0;
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
233 
234 // File @openzeppelin/contracts/utils/Address.sol@v4.6.0
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
458 
459 // File @openzeppelin/contracts/utils/Context.sol@v4.6.0
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
485 
486 // File @openzeppelin/contracts/utils/Strings.sol@v4.6.0
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
555 
556 // File @openzeppelin/contracts/utils/introspection/ERC165.sol@v4.6.0
557 
558 // OpenZeppelin Contracts v4.4.1 (utils/introspection/ERC165.sol)
559 
560 pragma solidity ^0.8.0;
561 
562 /**
563  * @dev Implementation of the {IERC165} interface.
564  *
565  * Contracts that want to implement ERC165 should inherit from this contract and override {supportsInterface} to check
566  * for the additional interface id that will be supported. For example:
567  *
568  * ```solidity
569  * function supportsInterface(bytes4 interfaceId) public view virtual override returns (bool) {
570  *     return interfaceId == type(MyInterface).interfaceId || super.supportsInterface(interfaceId);
571  * }
572  * ```
573  *
574  * Alternatively, {ERC165Storage} provides an easier to use but more expensive implementation.
575  */
576 abstract contract ERC165 is IERC165 {
577     /**
578      * @dev See {IERC165-supportsInterface}.
579      */
580     function supportsInterface(bytes4 interfaceId) public view virtual override returns (bool) {
581         return interfaceId == type(IERC165).interfaceId;
582     }
583 }
584 
585 
586 // File @openzeppelin/contracts/token/ERC721/ERC721.sol@v4.6.0
587 
588 // OpenZeppelin Contracts (last updated v4.6.0) (token/ERC721/ERC721.sol)
589 
590 pragma solidity ^0.8.0;
591 
592 
593 
594 
595 
596 
597 
598 /**
599  * @dev Implementation of https://eips.ethereum.org/EIPS/eip-721[ERC721] Non-Fungible Token Standard, including
600  * the Metadata extension, but not including the Enumerable extension, which is available separately as
601  * {ERC721Enumerable}.
602  */
603 contract ERC721 is Context, ERC165, IERC721, IERC721Metadata {
604     using Address for address;
605     using Strings for uint256;
606 
607     // Token name
608     string private _name;
609 
610     // Token symbol
611     string private _symbol;
612 
613     // Mapping from token ID to owner address
614     mapping(uint256 => address) private _owners;
615 
616     // Mapping owner address to token count
617     mapping(address => uint256) private _balances;
618 
619     // Mapping from token ID to approved address
620     mapping(uint256 => address) private _tokenApprovals;
621 
622     // Mapping from owner to operator approvals
623     mapping(address => mapping(address => bool)) private _operatorApprovals;
624 
625     /**
626      * @dev Initializes the contract by setting a `name` and a `symbol` to the token collection.
627      */
628     constructor(string memory name_, string memory symbol_) {
629         _name = name_;
630         _symbol = symbol_;
631     }
632 
633     /**
634      * @dev See {IERC165-supportsInterface}.
635      */
636     function supportsInterface(bytes4 interfaceId) public view virtual override(ERC165, IERC165) returns (bool) {
637         return
638             interfaceId == type(IERC721).interfaceId ||
639             interfaceId == type(IERC721Metadata).interfaceId ||
640             super.supportsInterface(interfaceId);
641     }
642 
643     /**
644      * @dev See {IERC721-balanceOf}.
645      */
646     function balanceOf(address owner) public view virtual override returns (uint256) {
647         require(owner != address(0), "ERC721: balance query for the zero address");
648         return _balances[owner];
649     }
650 
651     /**
652      * @dev See {IERC721-ownerOf}.
653      */
654     function ownerOf(uint256 tokenId) public view virtual override returns (address) {
655         address owner = _owners[tokenId];
656         require(owner != address(0), "ERC721: owner query for nonexistent token");
657         return owner;
658     }
659 
660     /**
661      * @dev See {IERC721Metadata-name}.
662      */
663     function name() public view virtual override returns (string memory) {
664         return _name;
665     }
666 
667     /**
668      * @dev See {IERC721Metadata-symbol}.
669      */
670     function symbol() public view virtual override returns (string memory) {
671         return _symbol;
672     }
673 
674     /**
675      * @dev See {IERC721Metadata-tokenURI}.
676      */
677     function tokenURI(uint256 tokenId) public view virtual override returns (string memory) {
678         require(_exists(tokenId), "ERC721Metadata: URI query for nonexistent token");
679 
680         string memory baseURI = _baseURI();
681         return bytes(baseURI).length > 0 ? string(abi.encodePacked(baseURI, tokenId.toString())) : "";
682     }
683 
684     /**
685      * @dev Base URI for computing {tokenURI}. If set, the resulting URI for each
686      * token will be the concatenation of the `baseURI` and the `tokenId`. Empty
687      * by default, can be overridden in child contracts.
688      */
689     function _baseURI() internal view virtual returns (string memory) {
690         return "";
691     }
692 
693     /**
694      * @dev See {IERC721-approve}.
695      */
696     function approve(address to, uint256 tokenId) public virtual override {
697         address owner = ERC721.ownerOf(tokenId);
698         require(to != owner, "ERC721: approval to current owner");
699 
700         require(
701             _msgSender() == owner || isApprovedForAll(owner, _msgSender()),
702             "ERC721: approve caller is not owner nor approved for all"
703         );
704 
705         _approve(to, tokenId);
706     }
707 
708     /**
709      * @dev See {IERC721-getApproved}.
710      */
711     function getApproved(uint256 tokenId) public view virtual override returns (address) {
712         require(_exists(tokenId), "ERC721: approved query for nonexistent token");
713 
714         return _tokenApprovals[tokenId];
715     }
716 
717     /**
718      * @dev See {IERC721-setApprovalForAll}.
719      */
720     function setApprovalForAll(address operator, bool approved) public virtual override {
721         _setApprovalForAll(_msgSender(), operator, approved);
722     }
723 
724     /**
725      * @dev See {IERC721-isApprovedForAll}.
726      */
727     function isApprovedForAll(address owner, address operator) public view virtual override returns (bool) {
728         return _operatorApprovals[owner][operator];
729     }
730 
731     /**
732      * @dev See {IERC721-transferFrom}.
733      */
734     function transferFrom(
735         address from,
736         address to,
737         uint256 tokenId
738     ) public virtual override {
739         //solhint-disable-next-line max-line-length
740         require(_isApprovedOrOwner(_msgSender(), tokenId), "ERC721: transfer caller is not owner nor approved");
741 
742         _transfer(from, to, tokenId);
743     }
744 
745     /**
746      * @dev See {IERC721-safeTransferFrom}.
747      */
748     function safeTransferFrom(
749         address from,
750         address to,
751         uint256 tokenId
752     ) public virtual override {
753         safeTransferFrom(from, to, tokenId, "");
754     }
755 
756     /**
757      * @dev See {IERC721-safeTransferFrom}.
758      */
759     function safeTransferFrom(
760         address from,
761         address to,
762         uint256 tokenId,
763         bytes memory _data
764     ) public virtual override {
765         require(_isApprovedOrOwner(_msgSender(), tokenId), "ERC721: transfer caller is not owner nor approved");
766         _safeTransfer(from, to, tokenId, _data);
767     }
768 
769     /**
770      * @dev Safely transfers `tokenId` token from `from` to `to`, checking first that contract recipients
771      * are aware of the ERC721 protocol to prevent tokens from being forever locked.
772      *
773      * `_data` is additional data, it has no specified format and it is sent in call to `to`.
774      *
775      * This internal function is equivalent to {safeTransferFrom}, and can be used to e.g.
776      * implement alternative mechanisms to perform token transfer, such as signature-based.
777      *
778      * Requirements:
779      *
780      * - `from` cannot be the zero address.
781      * - `to` cannot be the zero address.
782      * - `tokenId` token must exist and be owned by `from`.
783      * - If `to` refers to a smart contract, it must implement {IERC721Receiver-onERC721Received}, which is called upon a safe transfer.
784      *
785      * Emits a {Transfer} event.
786      */
787     function _safeTransfer(
788         address from,
789         address to,
790         uint256 tokenId,
791         bytes memory _data
792     ) internal virtual {
793         _transfer(from, to, tokenId);
794         require(_checkOnERC721Received(from, to, tokenId, _data), "ERC721: transfer to non ERC721Receiver implementer");
795     }
796 
797     /**
798      * @dev Returns whether `tokenId` exists.
799      *
800      * Tokens can be managed by their owner or approved accounts via {approve} or {setApprovalForAll}.
801      *
802      * Tokens start existing when they are minted (`_mint`),
803      * and stop existing when they are burned (`_burn`).
804      */
805     function _exists(uint256 tokenId) internal view virtual returns (bool) {
806         return _owners[tokenId] != address(0);
807     }
808 
809     /**
810      * @dev Returns whether `spender` is allowed to manage `tokenId`.
811      *
812      * Requirements:
813      *
814      * - `tokenId` must exist.
815      */
816     function _isApprovedOrOwner(address spender, uint256 tokenId) internal view virtual returns (bool) {
817         require(_exists(tokenId), "ERC721: operator query for nonexistent token");
818         address owner = ERC721.ownerOf(tokenId);
819         return (spender == owner || isApprovedForAll(owner, spender) || getApproved(tokenId) == spender);
820     }
821 
822     /**
823      * @dev Safely mints `tokenId` and transfers it to `to`.
824      *
825      * Requirements:
826      *
827      * - `tokenId` must not exist.
828      * - If `to` refers to a smart contract, it must implement {IERC721Receiver-onERC721Received}, which is called upon a safe transfer.
829      *
830      * Emits a {Transfer} event.
831      */
832     function _safeMint(address to, uint256 tokenId) internal virtual {
833         _safeMint(to, tokenId, "");
834     }
835 
836     /**
837      * @dev Same as {xref-ERC721-_safeMint-address-uint256-}[`_safeMint`], with an additional `data` parameter which is
838      * forwarded in {IERC721Receiver-onERC721Received} to contract recipients.
839      */
840     function _safeMint(
841         address to,
842         uint256 tokenId,
843         bytes memory _data
844     ) internal virtual {
845         _mint(to, tokenId);
846         require(
847             _checkOnERC721Received(address(0), to, tokenId, _data),
848             "ERC721: transfer to non ERC721Receiver implementer"
849         );
850     }
851 
852     /**
853      * @dev Mints `tokenId` and transfers it to `to`.
854      *
855      * WARNING: Usage of this method is discouraged, use {_safeMint} whenever possible
856      *
857      * Requirements:
858      *
859      * - `tokenId` must not exist.
860      * - `to` cannot be the zero address.
861      *
862      * Emits a {Transfer} event.
863      */
864     function _mint(address to, uint256 tokenId) internal virtual {
865         require(to != address(0), "ERC721: mint to the zero address");
866         require(!_exists(tokenId), "ERC721: token already minted");
867 
868         _beforeTokenTransfer(address(0), to, tokenId);
869 
870         _balances[to] += 1;
871         _owners[tokenId] = to;
872 
873         emit Transfer(address(0), to, tokenId);
874 
875         _afterTokenTransfer(address(0), to, tokenId);
876     }
877 
878     /**
879      * @dev Destroys `tokenId`.
880      * The approval is cleared when the token is burned.
881      *
882      * Requirements:
883      *
884      * - `tokenId` must exist.
885      *
886      * Emits a {Transfer} event.
887      */
888     function _burn(uint256 tokenId) internal virtual {
889         address owner = ERC721.ownerOf(tokenId);
890 
891         _beforeTokenTransfer(owner, address(0), tokenId);
892 
893         // Clear approvals
894         _approve(address(0), tokenId);
895 
896         _balances[owner] -= 1;
897         delete _owners[tokenId];
898 
899         emit Transfer(owner, address(0), tokenId);
900 
901         _afterTokenTransfer(owner, address(0), tokenId);
902     }
903 
904     /**
905      * @dev Transfers `tokenId` from `from` to `to`.
906      *  As opposed to {transferFrom}, this imposes no restrictions on msg.sender.
907      *
908      * Requirements:
909      *
910      * - `to` cannot be the zero address.
911      * - `tokenId` token must be owned by `from`.
912      *
913      * Emits a {Transfer} event.
914      */
915     function _transfer(
916         address from,
917         address to,
918         uint256 tokenId
919     ) internal virtual {
920         require(ERC721.ownerOf(tokenId) == from, "ERC721: transfer from incorrect owner");
921         require(to != address(0), "ERC721: transfer to the zero address");
922 
923         _beforeTokenTransfer(from, to, tokenId);
924 
925         // Clear approvals from the previous owner
926         _approve(address(0), tokenId);
927 
928         _balances[from] -= 1;
929         _balances[to] += 1;
930         _owners[tokenId] = to;
931 
932         emit Transfer(from, to, tokenId);
933 
934         _afterTokenTransfer(from, to, tokenId);
935     }
936 
937     /**
938      * @dev Approve `to` to operate on `tokenId`
939      *
940      * Emits a {Approval} event.
941      */
942     function _approve(address to, uint256 tokenId) internal virtual {
943         _tokenApprovals[tokenId] = to;
944         emit Approval(ERC721.ownerOf(tokenId), to, tokenId);
945     }
946 
947     /**
948      * @dev Approve `operator` to operate on all of `owner` tokens
949      *
950      * Emits a {ApprovalForAll} event.
951      */
952     function _setApprovalForAll(
953         address owner,
954         address operator,
955         bool approved
956     ) internal virtual {
957         require(owner != operator, "ERC721: approve to caller");
958         _operatorApprovals[owner][operator] = approved;
959         emit ApprovalForAll(owner, operator, approved);
960     }
961 
962     /**
963      * @dev Internal function to invoke {IERC721Receiver-onERC721Received} on a target address.
964      * The call is not executed if the target address is not a contract.
965      *
966      * @param from address representing the previous owner of the given token ID
967      * @param to target address that will receive the tokens
968      * @param tokenId uint256 ID of the token to be transferred
969      * @param _data bytes optional data to send along with the call
970      * @return bool whether the call correctly returned the expected magic value
971      */
972     function _checkOnERC721Received(
973         address from,
974         address to,
975         uint256 tokenId,
976         bytes memory _data
977     ) private returns (bool) {
978         if (to.isContract()) {
979             try IERC721Receiver(to).onERC721Received(_msgSender(), from, tokenId, _data) returns (bytes4 retval) {
980                 return retval == IERC721Receiver.onERC721Received.selector;
981             } catch (bytes memory reason) {
982                 if (reason.length == 0) {
983                     revert("ERC721: transfer to non ERC721Receiver implementer");
984                 } else {
985                     assembly {
986                         revert(add(32, reason), mload(reason))
987                     }
988                 }
989             }
990         } else {
991             return true;
992         }
993     }
994 
995     /**
996      * @dev Hook that is called before any token transfer. This includes minting
997      * and burning.
998      *
999      * Calling conditions:
1000      *
1001      * - When `from` and `to` are both non-zero, ``from``'s `tokenId` will be
1002      * transferred to `to`.
1003      * - When `from` is zero, `tokenId` will be minted for `to`.
1004      * - When `to` is zero, ``from``'s `tokenId` will be burned.
1005      * - `from` and `to` are never both zero.
1006      *
1007      * To learn more about hooks, head to xref:ROOT:extending-contracts.adoc#using-hooks[Using Hooks].
1008      */
1009     function _beforeTokenTransfer(
1010         address from,
1011         address to,
1012         uint256 tokenId
1013     ) internal virtual {}
1014 
1015     /**
1016      * @dev Hook that is called after any transfer of tokens. This includes
1017      * minting and burning.
1018      *
1019      * Calling conditions:
1020      *
1021      * - when `from` and `to` are both non-zero.
1022      * - `from` and `to` are never both zero.
1023      *
1024      * To learn more about hooks, head to xref:ROOT:extending-contracts.adoc#using-hooks[Using Hooks].
1025      */
1026     function _afterTokenTransfer(
1027         address from,
1028         address to,
1029         uint256 tokenId
1030     ) internal virtual {}
1031 }
1032 
1033 
1034 // File @openzeppelin/contracts/token/ERC721/extensions/IERC721Enumerable.sol@v4.6.0
1035 
1036 // OpenZeppelin Contracts (last updated v4.5.0) (token/ERC721/extensions/IERC721Enumerable.sol)
1037 
1038 pragma solidity ^0.8.0;
1039 
1040 /**
1041  * @title ERC-721 Non-Fungible Token Standard, optional enumeration extension
1042  * @dev See https://eips.ethereum.org/EIPS/eip-721
1043  */
1044 interface IERC721Enumerable is IERC721 {
1045     /**
1046      * @dev Returns the total amount of tokens stored by the contract.
1047      */
1048     function totalSupply() external view returns (uint256);
1049 
1050     /**
1051      * @dev Returns a token ID owned by `owner` at a given `index` of its token list.
1052      * Use along with {balanceOf} to enumerate all of ``owner``'s tokens.
1053      */
1054     function tokenOfOwnerByIndex(address owner, uint256 index) external view returns (uint256);
1055 
1056     /**
1057      * @dev Returns a token ID at a given `index` of all the tokens stored by the contract.
1058      * Use along with {totalSupply} to enumerate all tokens.
1059      */
1060     function tokenByIndex(uint256 index) external view returns (uint256);
1061 }
1062 
1063 
1064 // File @openzeppelin/contracts/token/ERC721/extensions/ERC721Enumerable.sol@v4.6.0
1065 
1066 // OpenZeppelin Contracts v4.4.1 (token/ERC721/extensions/ERC721Enumerable.sol)
1067 
1068 pragma solidity ^0.8.0;
1069 
1070 
1071 /**
1072  * @dev This implements an optional extension of {ERC721} defined in the EIP that adds
1073  * enumerability of all the token ids in the contract as well as all token ids owned by each
1074  * account.
1075  */
1076 abstract contract ERC721Enumerable is ERC721, IERC721Enumerable {
1077     // Mapping from owner to list of owned token IDs
1078     mapping(address => mapping(uint256 => uint256)) private _ownedTokens;
1079 
1080     // Mapping from token ID to index of the owner tokens list
1081     mapping(uint256 => uint256) private _ownedTokensIndex;
1082 
1083     // Array with all token ids, used for enumeration
1084     uint256[] private _allTokens;
1085 
1086     // Mapping from token id to position in the allTokens array
1087     mapping(uint256 => uint256) private _allTokensIndex;
1088 
1089     /**
1090      * @dev See {IERC165-supportsInterface}.
1091      */
1092     function supportsInterface(bytes4 interfaceId) public view virtual override(IERC165, ERC721) returns (bool) {
1093         return interfaceId == type(IERC721Enumerable).interfaceId || super.supportsInterface(interfaceId);
1094     }
1095 
1096     /**
1097      * @dev See {IERC721Enumerable-tokenOfOwnerByIndex}.
1098      */
1099     function tokenOfOwnerByIndex(address owner, uint256 index) public view virtual override returns (uint256) {
1100         require(index < ERC721.balanceOf(owner), "ERC721Enumerable: owner index out of bounds");
1101         return _ownedTokens[owner][index];
1102     }
1103 
1104     /**
1105      * @dev See {IERC721Enumerable-totalSupply}.
1106      */
1107     function totalSupply() public view virtual override returns (uint256) {
1108         return _allTokens.length;
1109     }
1110 
1111     /**
1112      * @dev See {IERC721Enumerable-tokenByIndex}.
1113      */
1114     function tokenByIndex(uint256 index) public view virtual override returns (uint256) {
1115         require(index < ERC721Enumerable.totalSupply(), "ERC721Enumerable: global index out of bounds");
1116         return _allTokens[index];
1117     }
1118 
1119     /**
1120      * @dev Hook that is called before any token transfer. This includes minting
1121      * and burning.
1122      *
1123      * Calling conditions:
1124      *
1125      * - When `from` and `to` are both non-zero, ``from``'s `tokenId` will be
1126      * transferred to `to`.
1127      * - When `from` is zero, `tokenId` will be minted for `to`.
1128      * - When `to` is zero, ``from``'s `tokenId` will be burned.
1129      * - `from` cannot be the zero address.
1130      * - `to` cannot be the zero address.
1131      *
1132      * To learn more about hooks, head to xref:ROOT:extending-contracts.adoc#using-hooks[Using Hooks].
1133      */
1134     function _beforeTokenTransfer(
1135         address from,
1136         address to,
1137         uint256 tokenId
1138     ) internal virtual override {
1139         super._beforeTokenTransfer(from, to, tokenId);
1140 
1141         if (from == address(0)) {
1142             _addTokenToAllTokensEnumeration(tokenId);
1143         } else if (from != to) {
1144             _removeTokenFromOwnerEnumeration(from, tokenId);
1145         }
1146         if (to == address(0)) {
1147             _removeTokenFromAllTokensEnumeration(tokenId);
1148         } else if (to != from) {
1149             _addTokenToOwnerEnumeration(to, tokenId);
1150         }
1151     }
1152 
1153     /**
1154      * @dev Private function to add a token to this extension's ownership-tracking data structures.
1155      * @param to address representing the new owner of the given token ID
1156      * @param tokenId uint256 ID of the token to be added to the tokens list of the given address
1157      */
1158     function _addTokenToOwnerEnumeration(address to, uint256 tokenId) private {
1159         uint256 length = ERC721.balanceOf(to);
1160         _ownedTokens[to][length] = tokenId;
1161         _ownedTokensIndex[tokenId] = length;
1162     }
1163 
1164     /**
1165      * @dev Private function to add a token to this extension's token tracking data structures.
1166      * @param tokenId uint256 ID of the token to be added to the tokens list
1167      */
1168     function _addTokenToAllTokensEnumeration(uint256 tokenId) private {
1169         _allTokensIndex[tokenId] = _allTokens.length;
1170         _allTokens.push(tokenId);
1171     }
1172 
1173     /**
1174      * @dev Private function to remove a token from this extension's ownership-tracking data structures. Note that
1175      * while the token is not assigned a new owner, the `_ownedTokensIndex` mapping is _not_ updated: this allows for
1176      * gas optimizations e.g. when performing a transfer operation (avoiding double writes).
1177      * This has O(1) time complexity, but alters the order of the _ownedTokens array.
1178      * @param from address representing the previous owner of the given token ID
1179      * @param tokenId uint256 ID of the token to be removed from the tokens list of the given address
1180      */
1181     function _removeTokenFromOwnerEnumeration(address from, uint256 tokenId) private {
1182         // To prevent a gap in from's tokens array, we store the last token in the index of the token to delete, and
1183         // then delete the last slot (swap and pop).
1184 
1185         uint256 lastTokenIndex = ERC721.balanceOf(from) - 1;
1186         uint256 tokenIndex = _ownedTokensIndex[tokenId];
1187 
1188         // When the token to delete is the last token, the swap operation is unnecessary
1189         if (tokenIndex != lastTokenIndex) {
1190             uint256 lastTokenId = _ownedTokens[from][lastTokenIndex];
1191 
1192             _ownedTokens[from][tokenIndex] = lastTokenId; // Move the last token to the slot of the to-delete token
1193             _ownedTokensIndex[lastTokenId] = tokenIndex; // Update the moved token's index
1194         }
1195 
1196         // This also deletes the contents at the last position of the array
1197         delete _ownedTokensIndex[tokenId];
1198         delete _ownedTokens[from][lastTokenIndex];
1199     }
1200 
1201     /**
1202      * @dev Private function to remove a token from this extension's token tracking data structures.
1203      * This has O(1) time complexity, but alters the order of the _allTokens array.
1204      * @param tokenId uint256 ID of the token to be removed from the tokens list
1205      */
1206     function _removeTokenFromAllTokensEnumeration(uint256 tokenId) private {
1207         // To prevent a gap in the tokens array, we store the last token in the index of the token to delete, and
1208         // then delete the last slot (swap and pop).
1209 
1210         uint256 lastTokenIndex = _allTokens.length - 1;
1211         uint256 tokenIndex = _allTokensIndex[tokenId];
1212 
1213         // When the token to delete is the last token, the swap operation is unnecessary. However, since this occurs so
1214         // rarely (when the last minted token is burnt) that we still do the swap here to avoid the gas cost of adding
1215         // an 'if' statement (like in _removeTokenFromOwnerEnumeration)
1216         uint256 lastTokenId = _allTokens[lastTokenIndex];
1217 
1218         _allTokens[tokenIndex] = lastTokenId; // Move the last token to the slot of the to-delete token
1219         _allTokensIndex[lastTokenId] = tokenIndex; // Update the moved token's index
1220 
1221         // This also deletes the contents at the last position of the array
1222         delete _allTokensIndex[tokenId];
1223         _allTokens.pop();
1224     }
1225 }
1226 
1227 
1228 // File @openzeppelin/contracts/interfaces/IERC2981.sol@v4.6.0
1229 
1230 // OpenZeppelin Contracts (last updated v4.6.0) (interfaces/IERC2981.sol)
1231 
1232 pragma solidity ^0.8.0;
1233 
1234 /**
1235  * @dev Interface for the NFT Royalty Standard.
1236  *
1237  * A standardized way to retrieve royalty payment information for non-fungible tokens (NFTs) to enable universal
1238  * support for royalty payments across all NFT marketplaces and ecosystem participants.
1239  *
1240  * _Available since v4.5._
1241  */
1242 interface IERC2981 is IERC165 {
1243     /**
1244      * @dev Returns how much royalty is owed and to whom, based on a sale price that may be denominated in any unit of
1245      * exchange. The royalty amount is denominated and should be paid in that same unit of exchange.
1246      */
1247     function royaltyInfo(uint256 tokenId, uint256 salePrice)
1248         external
1249         view
1250         returns (address receiver, uint256 royaltyAmount);
1251 }
1252 
1253 
1254 // File @openzeppelin/contracts/token/common/ERC2981.sol@v4.6.0
1255 
1256 // OpenZeppelin Contracts (last updated v4.6.0) (token/common/ERC2981.sol)
1257 
1258 pragma solidity ^0.8.0;
1259 
1260 
1261 /**
1262  * @dev Implementation of the NFT Royalty Standard, a standardized way to retrieve royalty payment information.
1263  *
1264  * Royalty information can be specified globally for all token ids via {_setDefaultRoyalty}, and/or individually for
1265  * specific token ids via {_setTokenRoyalty}. The latter takes precedence over the first.
1266  *
1267  * Royalty is specified as a fraction of sale price. {_feeDenominator} is overridable but defaults to 10000, meaning the
1268  * fee is specified in basis points by default.
1269  *
1270  * IMPORTANT: ERC-2981 only specifies a way to signal royalty information and does not enforce its payment. See
1271  * https://eips.ethereum.org/EIPS/eip-2981#optional-royalty-payments[Rationale] in the EIP. Marketplaces are expected to
1272  * voluntarily pay royalties together with sales, but note that this standard is not yet widely supported.
1273  *
1274  * _Available since v4.5._
1275  */
1276 abstract contract ERC2981 is IERC2981, ERC165 {
1277     struct RoyaltyInfo {
1278         address receiver;
1279         uint96 royaltyFraction;
1280     }
1281 
1282     RoyaltyInfo private _defaultRoyaltyInfo;
1283     mapping(uint256 => RoyaltyInfo) private _tokenRoyaltyInfo;
1284 
1285     /**
1286      * @dev See {IERC165-supportsInterface}.
1287      */
1288     function supportsInterface(bytes4 interfaceId) public view virtual override(IERC165, ERC165) returns (bool) {
1289         return interfaceId == type(IERC2981).interfaceId || super.supportsInterface(interfaceId);
1290     }
1291 
1292     /**
1293      * @inheritdoc IERC2981
1294      */
1295     function royaltyInfo(uint256 _tokenId, uint256 _salePrice) public view virtual override returns (address, uint256) {
1296         RoyaltyInfo memory royalty = _tokenRoyaltyInfo[_tokenId];
1297 
1298         if (royalty.receiver == address(0)) {
1299             royalty = _defaultRoyaltyInfo;
1300         }
1301 
1302         uint256 royaltyAmount = (_salePrice * royalty.royaltyFraction) / _feeDenominator();
1303 
1304         return (royalty.receiver, royaltyAmount);
1305     }
1306 
1307     /**
1308      * @dev The denominator with which to interpret the fee set in {_setTokenRoyalty} and {_setDefaultRoyalty} as a
1309      * fraction of the sale price. Defaults to 10000 so fees are expressed in basis points, but may be customized by an
1310      * override.
1311      */
1312     function _feeDenominator() internal pure virtual returns (uint96) {
1313         return 10000;
1314     }
1315 
1316     /**
1317      * @dev Sets the royalty information that all ids in this contract will default to.
1318      *
1319      * Requirements:
1320      *
1321      * - `receiver` cannot be the zero address.
1322      * - `feeNumerator` cannot be greater than the fee denominator.
1323      */
1324     function _setDefaultRoyalty(address receiver, uint96 feeNumerator) internal virtual {
1325         require(feeNumerator <= _feeDenominator(), "ERC2981: royalty fee will exceed salePrice");
1326         require(receiver != address(0), "ERC2981: invalid receiver");
1327 
1328         _defaultRoyaltyInfo = RoyaltyInfo(receiver, feeNumerator);
1329     }
1330 
1331     /**
1332      * @dev Removes default royalty information.
1333      */
1334     function _deleteDefaultRoyalty() internal virtual {
1335         delete _defaultRoyaltyInfo;
1336     }
1337 
1338     /**
1339      * @dev Sets the royalty information for a specific token id, overriding the global default.
1340      *
1341      * Requirements:
1342      *
1343      * - `tokenId` must be already minted.
1344      * - `receiver` cannot be the zero address.
1345      * - `feeNumerator` cannot be greater than the fee denominator.
1346      */
1347     function _setTokenRoyalty(
1348         uint256 tokenId,
1349         address receiver,
1350         uint96 feeNumerator
1351     ) internal virtual {
1352         require(feeNumerator <= _feeDenominator(), "ERC2981: royalty fee will exceed salePrice");
1353         require(receiver != address(0), "ERC2981: Invalid parameters");
1354 
1355         _tokenRoyaltyInfo[tokenId] = RoyaltyInfo(receiver, feeNumerator);
1356     }
1357 
1358     /**
1359      * @dev Resets royalty information for the token id back to the global default.
1360      */
1361     function _resetTokenRoyalty(uint256 tokenId) internal virtual {
1362         delete _tokenRoyaltyInfo[tokenId];
1363     }
1364 }
1365 
1366 
1367 // File @openzeppelin/contracts/token/ERC721/extensions/ERC721Royalty.sol@v4.6.0
1368 
1369 // OpenZeppelin Contracts (last updated v4.5.0) (token/ERC721/extensions/ERC721Royalty.sol)
1370 
1371 pragma solidity ^0.8.0;
1372 
1373 
1374 
1375 /**
1376  * @dev Extension of ERC721 with the ERC2981 NFT Royalty Standard, a standardized way to retrieve royalty payment
1377  * information.
1378  *
1379  * Royalty information can be specified globally for all token ids via {_setDefaultRoyalty}, and/or individually for
1380  * specific token ids via {_setTokenRoyalty}. The latter takes precedence over the first.
1381  *
1382  * IMPORTANT: ERC-2981 only specifies a way to signal royalty information and does not enforce its payment. See
1383  * https://eips.ethereum.org/EIPS/eip-2981#optional-royalty-payments[Rationale] in the EIP. Marketplaces are expected to
1384  * voluntarily pay royalties together with sales, but note that this standard is not yet widely supported.
1385  *
1386  * _Available since v4.5._
1387  */
1388 abstract contract ERC721Royalty is ERC2981, ERC721 {
1389     /**
1390      * @dev See {IERC165-supportsInterface}.
1391      */
1392     function supportsInterface(bytes4 interfaceId) public view virtual override(ERC721, ERC2981) returns (bool) {
1393         return super.supportsInterface(interfaceId);
1394     }
1395 
1396     /**
1397      * @dev See {ERC721-_burn}. This override additionally clears the royalty information for the token.
1398      */
1399     function _burn(uint256 tokenId) internal virtual override {
1400         super._burn(tokenId);
1401         _resetTokenRoyalty(tokenId);
1402     }
1403 }
1404 
1405 
1406 // File @openzeppelin/contracts/access/Ownable.sol@v4.6.0
1407 
1408 // OpenZeppelin Contracts v4.4.1 (access/Ownable.sol)
1409 
1410 pragma solidity ^0.8.0;
1411 
1412 /**
1413  * @dev Contract module which provides a basic access control mechanism, where
1414  * there is an account (an owner) that can be granted exclusive access to
1415  * specific functions.
1416  *
1417  * By default, the owner account will be the one that deploys the contract. This
1418  * can later be changed with {transferOwnership}.
1419  *
1420  * This module is used through inheritance. It will make available the modifier
1421  * `onlyOwner`, which can be applied to your functions to restrict their use to
1422  * the owner.
1423  */
1424 abstract contract Ownable is Context {
1425     address private _owner;
1426 
1427     event OwnershipTransferred(address indexed previousOwner, address indexed newOwner);
1428 
1429     /**
1430      * @dev Initializes the contract setting the deployer as the initial owner.
1431      */
1432     constructor() {
1433         _transferOwnership(_msgSender());
1434     }
1435 
1436     /**
1437      * @dev Returns the address of the current owner.
1438      */
1439     function owner() public view virtual returns (address) {
1440         return _owner;
1441     }
1442 
1443     /**
1444      * @dev Throws if called by any account other than the owner.
1445      */
1446     modifier onlyOwner() {
1447         require(owner() == _msgSender(), "Ownable: caller is not the owner");
1448         _;
1449     }
1450 
1451     /**
1452      * @dev Leaves the contract without owner. It will not be possible to call
1453      * `onlyOwner` functions anymore. Can only be called by the current owner.
1454      *
1455      * NOTE: Renouncing ownership will leave the contract without an owner,
1456      * thereby removing any functionality that is only available to the owner.
1457      */
1458     function renounceOwnership() public virtual onlyOwner {
1459         _transferOwnership(address(0));
1460     }
1461 
1462     /**
1463      * @dev Transfers ownership of the contract to a new account (`newOwner`).
1464      * Can only be called by the current owner.
1465      */
1466     function transferOwnership(address newOwner) public virtual onlyOwner {
1467         require(newOwner != address(0), "Ownable: new owner is the zero address");
1468         _transferOwnership(newOwner);
1469     }
1470 
1471     /**
1472      * @dev Transfers ownership of the contract to a new account (`newOwner`).
1473      * Internal function without access restriction.
1474      */
1475     function _transferOwnership(address newOwner) internal virtual {
1476         address oldOwner = _owner;
1477         _owner = newOwner;
1478         emit OwnershipTransferred(oldOwner, newOwner);
1479     }
1480 }
1481 
1482 
1483 // File @openzeppelin/contracts/utils/cryptography/MerkleProof.sol@v4.6.0
1484 
1485 // OpenZeppelin Contracts (last updated v4.6.0) (utils/cryptography/MerkleProof.sol)
1486 
1487 pragma solidity ^0.8.0;
1488 
1489 /**
1490  * @dev These functions deal with verification of Merkle Trees proofs.
1491  *
1492  * The proofs can be generated using the JavaScript library
1493  * https://github.com/miguelmota/merkletreejs[merkletreejs].
1494  * Note: the hashing algorithm should be keccak256 and pair sorting should be enabled.
1495  *
1496  * See `test/utils/cryptography/MerkleProof.test.js` for some examples.
1497  *
1498  * WARNING: You should avoid using leaf values that are 64 bytes long prior to
1499  * hashing, or use a hash function other than keccak256 for hashing leaves.
1500  * This is because the concatenation of a sorted pair of internal nodes in
1501  * the merkle tree could be reinterpreted as a leaf value.
1502  */
1503 library MerkleProof {
1504     /**
1505      * @dev Returns true if a `leaf` can be proved to be a part of a Merkle tree
1506      * defined by `root`. For this, a `proof` must be provided, containing
1507      * sibling hashes on the branch from the leaf to the root of the tree. Each
1508      * pair of leaves and each pair of pre-images are assumed to be sorted.
1509      */
1510     function verify(
1511         bytes32[] memory proof,
1512         bytes32 root,
1513         bytes32 leaf
1514     ) internal pure returns (bool) {
1515         return processProof(proof, leaf) == root;
1516     }
1517 
1518     /**
1519      * @dev Returns the rebuilt hash obtained by traversing a Merkle tree up
1520      * from `leaf` using `proof`. A `proof` is valid if and only if the rebuilt
1521      * hash matches the root of the tree. When processing the proof, the pairs
1522      * of leafs & pre-images are assumed to be sorted.
1523      *
1524      * _Available since v4.4._
1525      */
1526     function processProof(bytes32[] memory proof, bytes32 leaf) internal pure returns (bytes32) {
1527         bytes32 computedHash = leaf;
1528         for (uint256 i = 0; i < proof.length; i++) {
1529             bytes32 proofElement = proof[i];
1530             if (computedHash <= proofElement) {
1531                 // Hash(current computed hash + current element of the proof)
1532                 computedHash = _efficientHash(computedHash, proofElement);
1533             } else {
1534                 // Hash(current element of the proof + current computed hash)
1535                 computedHash = _efficientHash(proofElement, computedHash);
1536             }
1537         }
1538         return computedHash;
1539     }
1540 
1541     function _efficientHash(bytes32 a, bytes32 b) private pure returns (bytes32 value) {
1542         assembly {
1543             mstore(0x00, a)
1544             mstore(0x20, b)
1545             value := keccak256(0x00, 0x40)
1546         }
1547     }
1548 }
1549 
1550 
1551 // File @openzeppelin/contracts/utils/Counters.sol@v4.6.0
1552 
1553 // OpenZeppelin Contracts v4.4.1 (utils/Counters.sol)
1554 
1555 pragma solidity ^0.8.0;
1556 
1557 /**
1558  * @title Counters
1559  * @author Matt Condon (@shrugs)
1560  * @dev Provides counters that can only be incremented, decremented or reset. This can be used e.g. to track the number
1561  * of elements in a mapping, issuing ERC721 ids, or counting request ids.
1562  *
1563  * Include with `using Counters for Counters.Counter;`
1564  */
1565 library Counters {
1566     struct Counter {
1567         // This variable should never be directly accessed by users of the library: interactions must be restricted to
1568         // the library's function. As of Solidity v0.5.2, this cannot be enforced, though there is a proposal to add
1569         // this feature: see https://github.com/ethereum/solidity/issues/4637
1570         uint256 _value; // default: 0
1571     }
1572 
1573     function current(Counter storage counter) internal view returns (uint256) {
1574         return counter._value;
1575     }
1576 
1577     function increment(Counter storage counter) internal {
1578         unchecked {
1579             counter._value += 1;
1580         }
1581     }
1582 
1583     function decrement(Counter storage counter) internal {
1584         uint256 value = counter._value;
1585         require(value > 0, "Counter: decrement overflow");
1586         unchecked {
1587             counter._value = value - 1;
1588         }
1589     }
1590 
1591     function reset(Counter storage counter) internal {
1592         counter._value = 0;
1593     }
1594 }
1595 
1596 
1597 // File contracts/TubzSocialClub.sol
1598 
1599 
1600 //   _______    _         _____            _       _  _____ _       _
1601 //  |__   __|  | |       / ____|          (_)     | |/ ____| |     | |
1602 //     | |_   _| |__ ___| (___   ___   ___ _  __ _| | |    | |_   _| |__
1603 //     | | | | | '_ \_  /\___ \ / _ \ / __| |/ _` | | |    | | | | | '_ \
1604 //     | | |_| | |_) / / ____) | (_) | (__| | (_| | | |____| | |_| | |_) |
1605 //     |_|\__,_|_.__/___|_____/ \___/ \___|_|\__,_|_|\_____|_|\__,_|_.__/
1606 //
1607 
1608 pragma solidity ^0.8.4;
1609 
1610 
1611 
1612 
1613 
1614 contract TubzSocialClub is ERC721Enumerable, ERC721Royalty, Ownable {
1615     using Strings for uint256;
1616     using Counters for Counters.Counter;
1617 
1618     Counters.Counter private tokenCounter;
1619 
1620     string public baseURI;
1621     string public baseExtension = ".json";
1622 
1623     uint256 public constant maxSupply = 5555;
1624     uint256 public constant maxMint = 5;
1625 
1626     uint96 public constant royaltiesPercentage = 10;
1627 
1628     uint256 public presalePrice = 0.08 ether;
1629     uint256 public mainsalePrice = 0.10 ether;
1630 
1631     bool public isPresale = true;
1632 
1633     mapping(address => bool) public whitelistClaimed;
1634     bytes32 public merkleRoot;
1635 
1636     address public presaleFundsReceiver;
1637     address public mainsaleFundsReceiver;
1638 
1639     constructor(
1640         string memory baseURI_,
1641         address royaltiesReceiver,
1642         address presaleFundsReceiver_,
1643         address mainsaleFundsReceiver_,
1644         bytes32 merkleRoot_
1645     ) ERC721("TubzSocialClub", "TUBZ") {
1646         setBaseURI(baseURI_);
1647         _setDefaultRoyalty(royaltiesReceiver, royaltiesPercentage * 100);
1648 
1649         presaleFundsReceiver = presaleFundsReceiver_;
1650         mainsaleFundsReceiver = mainsaleFundsReceiver_;
1651 
1652         merkleRoot = merkleRoot_;
1653     }
1654 
1655     // ********** internal
1656 
1657     function _baseURI() internal view virtual override returns (string memory) {
1658         return baseURI;
1659     }
1660 
1661     // ********** public
1662 
1663     function mint(uint256 amount) public payable {
1664         require(!isPresale, "Main sale not active");
1665         require(amount > 0 && amount <= maxMint, "Not valid amount");
1666         require(msg.value >= mainsalePrice * amount, "Not enough ETH");
1667         require(
1668             tokenCounter.current() + amount <= maxSupply,
1669             "Not enough NFTs"
1670         );
1671 
1672         unchecked {
1673             for (uint256 i = 0; i < amount; i++) {
1674                 tokenCounter.increment();
1675                 _safeMint(_msgSender(), tokenCounter.current());
1676             }
1677         }
1678     }
1679 
1680     function mintPresale(uint256 amount, bytes32[] calldata merkleProof)
1681         public
1682         payable
1683     {
1684         require(isPresale, "Presale not active");
1685         require(amount > 0 && amount <= maxMint, "Not valid amount");
1686         require(msg.value >= presalePrice * amount, "Not enough ETH");
1687         require(
1688             tokenCounter.current() + amount <= maxSupply,
1689             "Not enough NFTs"
1690         );
1691         require(!whitelistClaimed[_msgSender()], "Address already used");
1692 
1693         bytes32 leaf = keccak256(abi.encodePacked(_msgSender()));
1694         require(
1695             MerkleProof.verify(merkleProof, merkleRoot, leaf),
1696             "Address not whitelisted"
1697         );
1698 
1699         whitelistClaimed[_msgSender()] = true;
1700 
1701         unchecked {
1702             for (uint256 i = 0; i < amount; i++) {
1703                 tokenCounter.increment();
1704                 _safeMint(_msgSender(), tokenCounter.current());
1705             }
1706         }
1707     }
1708 
1709     function tokenURI(uint256 tokenId)
1710         public
1711         view
1712         virtual
1713         override
1714         returns (string memory)
1715     {
1716         require(_exists(tokenId), "Token ID doesn't exist");
1717 
1718         string memory currentBaseURI = _baseURI();
1719 
1720         return
1721             string(
1722                 abi.encodePacked(
1723                     currentBaseURI,
1724                     "/",
1725                     tokenId.toString(),
1726                     baseExtension
1727                 )
1728             );
1729     }
1730 
1731     // ********** only owner
1732 
1733     function airdrop(address to) public onlyOwner {
1734         require(tokenCounter.current() + 1 <= maxSupply, "Not enough NFTs");
1735 
1736         tokenCounter.increment();
1737         _safeMint(to, tokenCounter.current());
1738     }
1739 
1740     function setIsPresale(bool isPresale_) public onlyOwner {
1741         require(address(this).balance == 0, "Not zero balance");
1742         isPresale = isPresale_;
1743     }
1744 
1745     function setMerkleRoot(bytes32 merkleRoot_) public onlyOwner {
1746         merkleRoot = merkleRoot_;
1747     }
1748 
1749     function setPricing(uint256 presalePrice_, uint256 mainsalePrice_)
1750         public
1751         onlyOwner
1752     {
1753         presalePrice = presalePrice_;
1754         mainsalePrice = mainsalePrice_;
1755     }
1756 
1757     function setBaseURI(string memory newBaseURI) public onlyOwner {
1758         baseURI = newBaseURI;
1759     }
1760 
1761     function withdraw() public payable onlyOwner {
1762         address receiver = isPresale
1763             ? presaleFundsReceiver
1764             : mainsaleFundsReceiver;
1765         (bool os, ) = payable(receiver).call{value: address(this).balance}("");
1766         require(os);
1767     }
1768 
1769     // ************ Fix overrides
1770     function _burn(uint256 tokenId) internal override(ERC721, ERC721Royalty) {
1771         super._burn(tokenId);
1772     }
1773 
1774     function supportsInterface(bytes4 interfaceId)
1775         public
1776         view
1777         override(ERC721Enumerable, ERC721Royalty)
1778         returns (bool)
1779     {
1780         return super.supportsInterface(interfaceId);
1781     }
1782 
1783     function _beforeTokenTransfer(
1784         address from,
1785         address to,
1786         uint256 tokenId
1787     ) internal override(ERC721, ERC721Enumerable) {
1788         super._beforeTokenTransfer(from, to, tokenId);
1789     }
1790 }