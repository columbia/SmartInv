1 // Sources flattened with hardhat v2.9.1 https://hardhat.org
2 
3 // File @openzeppelin/contracts/utils/introspection/IERC165.sol@v4.5.0
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
32 // File @openzeppelin/contracts/token/ERC721/IERC721.sol@v4.5.0
33 
34 // OpenZeppelin Contracts v4.4.1 (token/ERC721/IERC721.sol)
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
72      * @dev Safely transfers `tokenId` token from `from` to `to`, checking first that contract recipients
73      * are aware of the ERC721 protocol to prevent tokens from being forever locked.
74      *
75      * Requirements:
76      *
77      * - `from` cannot be the zero address.
78      * - `to` cannot be the zero address.
79      * - `tokenId` token must exist and be owned by `from`.
80      * - If the caller is not `from`, it must be have been allowed to move this token by either {approve} or {setApprovalForAll}.
81      * - If `to` refers to a smart contract, it must implement {IERC721Receiver-onERC721Received}, which is called upon a safe transfer.
82      *
83      * Emits a {Transfer} event.
84      */
85     function safeTransferFrom(
86         address from,
87         address to,
88         uint256 tokenId
89     ) external;
90 
91     /**
92      * @dev Transfers `tokenId` token from `from` to `to`.
93      *
94      * WARNING: Usage of this method is discouraged, use {safeTransferFrom} whenever possible.
95      *
96      * Requirements:
97      *
98      * - `from` cannot be the zero address.
99      * - `to` cannot be the zero address.
100      * - `tokenId` token must be owned by `from`.
101      * - If the caller is not `from`, it must be approved to move this token by either {approve} or {setApprovalForAll}.
102      *
103      * Emits a {Transfer} event.
104      */
105     function transferFrom(
106         address from,
107         address to,
108         uint256 tokenId
109     ) external;
110 
111     /**
112      * @dev Gives permission to `to` to transfer `tokenId` token to another account.
113      * The approval is cleared when the token is transferred.
114      *
115      * Only a single account can be approved at a time, so approving the zero address clears previous approvals.
116      *
117      * Requirements:
118      *
119      * - The caller must own the token or be an approved operator.
120      * - `tokenId` must exist.
121      *
122      * Emits an {Approval} event.
123      */
124     function approve(address to, uint256 tokenId) external;
125 
126     /**
127      * @dev Returns the account approved for `tokenId` token.
128      *
129      * Requirements:
130      *
131      * - `tokenId` must exist.
132      */
133     function getApproved(uint256 tokenId) external view returns (address operator);
134 
135     /**
136      * @dev Approve or remove `operator` as an operator for the caller.
137      * Operators can call {transferFrom} or {safeTransferFrom} for any token owned by the caller.
138      *
139      * Requirements:
140      *
141      * - The `operator` cannot be the caller.
142      *
143      * Emits an {ApprovalForAll} event.
144      */
145     function setApprovalForAll(address operator, bool _approved) external;
146 
147     /**
148      * @dev Returns if the `operator` is allowed to manage all of the assets of `owner`.
149      *
150      * See {setApprovalForAll}
151      */
152     function isApprovedForAll(address owner, address operator) external view returns (bool);
153 
154     /**
155      * @dev Safely transfers `tokenId` token from `from` to `to`.
156      *
157      * Requirements:
158      *
159      * - `from` cannot be the zero address.
160      * - `to` cannot be the zero address.
161      * - `tokenId` token must exist and be owned by `from`.
162      * - If the caller is not `from`, it must be approved to move this token by either {approve} or {setApprovalForAll}.
163      * - If `to` refers to a smart contract, it must implement {IERC721Receiver-onERC721Received}, which is called upon a safe transfer.
164      *
165      * Emits a {Transfer} event.
166      */
167     function safeTransferFrom(
168         address from,
169         address to,
170         uint256 tokenId,
171         bytes calldata data
172     ) external;
173 }
174 
175 
176 // File @openzeppelin/contracts/token/ERC721/IERC721Receiver.sol@v4.5.0
177 
178 // OpenZeppelin Contracts v4.4.1 (token/ERC721/IERC721Receiver.sol)
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
195      * The selector can be obtained in Solidity with `IERC721.onERC721Received.selector`.
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
206 // File @openzeppelin/contracts/token/ERC721/extensions/IERC721Metadata.sol@v4.5.0
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
234 // File @openzeppelin/contracts/utils/Address.sol@v4.5.0
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
459 // File @openzeppelin/contracts/utils/Context.sol@v4.5.0
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
486 // File @openzeppelin/contracts/utils/Strings.sol@v4.5.0
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
556 // File @openzeppelin/contracts/utils/introspection/ERC165.sol@v4.5.0
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
586 // File @openzeppelin/contracts/token/ERC721/ERC721.sol@v4.5.0
587 
588 // OpenZeppelin Contracts (last updated v4.5.0) (token/ERC721/ERC721.sol)
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
687      * by default, can be overriden in child contracts.
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
819         return (spender == owner || getApproved(tokenId) == spender || isApprovedForAll(owner, spender));
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
1034 // File @openzeppelin/contracts/security/Pausable.sol@v4.5.0
1035 
1036 // OpenZeppelin Contracts v4.4.1 (security/Pausable.sol)
1037 
1038 pragma solidity ^0.8.0;
1039 
1040 /**
1041  * @dev Contract module which allows children to implement an emergency stop
1042  * mechanism that can be triggered by an authorized account.
1043  *
1044  * This module is used through inheritance. It will make available the
1045  * modifiers `whenNotPaused` and `whenPaused`, which can be applied to
1046  * the functions of your contract. Note that they will not be pausable by
1047  * simply including this module, only once the modifiers are put in place.
1048  */
1049 abstract contract Pausable is Context {
1050     /**
1051      * @dev Emitted when the pause is triggered by `account`.
1052      */
1053     event Paused(address account);
1054 
1055     /**
1056      * @dev Emitted when the pause is lifted by `account`.
1057      */
1058     event Unpaused(address account);
1059 
1060     bool private _paused;
1061 
1062     /**
1063      * @dev Initializes the contract in unpaused state.
1064      */
1065     constructor() {
1066         _paused = false;
1067     }
1068 
1069     /**
1070      * @dev Returns true if the contract is paused, and false otherwise.
1071      */
1072     function paused() public view virtual returns (bool) {
1073         return _paused;
1074     }
1075 
1076     /**
1077      * @dev Modifier to make a function callable only when the contract is not paused.
1078      *
1079      * Requirements:
1080      *
1081      * - The contract must not be paused.
1082      */
1083     modifier whenNotPaused() {
1084         require(!paused(), "Pausable: paused");
1085         _;
1086     }
1087 
1088     /**
1089      * @dev Modifier to make a function callable only when the contract is paused.
1090      *
1091      * Requirements:
1092      *
1093      * - The contract must be paused.
1094      */
1095     modifier whenPaused() {
1096         require(paused(), "Pausable: not paused");
1097         _;
1098     }
1099 
1100     /**
1101      * @dev Triggers stopped state.
1102      *
1103      * Requirements:
1104      *
1105      * - The contract must not be paused.
1106      */
1107     function _pause() internal virtual whenNotPaused {
1108         _paused = true;
1109         emit Paused(_msgSender());
1110     }
1111 
1112     /**
1113      * @dev Returns to normal state.
1114      *
1115      * Requirements:
1116      *
1117      * - The contract must be paused.
1118      */
1119     function _unpause() internal virtual whenPaused {
1120         _paused = false;
1121         emit Unpaused(_msgSender());
1122     }
1123 }
1124 
1125 
1126 // File @openzeppelin/contracts/access/Ownable.sol@v4.5.0
1127 
1128 // OpenZeppelin Contracts v4.4.1 (access/Ownable.sol)
1129 
1130 pragma solidity ^0.8.0;
1131 
1132 /**
1133  * @dev Contract module which provides a basic access control mechanism, where
1134  * there is an account (an owner) that can be granted exclusive access to
1135  * specific functions.
1136  *
1137  * By default, the owner account will be the one that deploys the contract. This
1138  * can later be changed with {transferOwnership}.
1139  *
1140  * This module is used through inheritance. It will make available the modifier
1141  * `onlyOwner`, which can be applied to your functions to restrict their use to
1142  * the owner.
1143  */
1144 abstract contract Ownable is Context {
1145     address private _owner;
1146 
1147     event OwnershipTransferred(address indexed previousOwner, address indexed newOwner);
1148 
1149     /**
1150      * @dev Initializes the contract setting the deployer as the initial owner.
1151      */
1152     constructor() {
1153         _transferOwnership(_msgSender());
1154     }
1155 
1156     /**
1157      * @dev Returns the address of the current owner.
1158      */
1159     function owner() public view virtual returns (address) {
1160         return _owner;
1161     }
1162 
1163     /**
1164      * @dev Throws if called by any account other than the owner.
1165      */
1166     modifier onlyOwner() {
1167         require(owner() == _msgSender(), "Ownable: caller is not the owner");
1168         _;
1169     }
1170 
1171     /**
1172      * @dev Leaves the contract without owner. It will not be possible to call
1173      * `onlyOwner` functions anymore. Can only be called by the current owner.
1174      *
1175      * NOTE: Renouncing ownership will leave the contract without an owner,
1176      * thereby removing any functionality that is only available to the owner.
1177      */
1178     function renounceOwnership() public virtual onlyOwner {
1179         _transferOwnership(address(0));
1180     }
1181 
1182     /**
1183      * @dev Transfers ownership of the contract to a new account (`newOwner`).
1184      * Can only be called by the current owner.
1185      */
1186     function transferOwnership(address newOwner) public virtual onlyOwner {
1187         require(newOwner != address(0), "Ownable: new owner is the zero address");
1188         _transferOwnership(newOwner);
1189     }
1190 
1191     /**
1192      * @dev Transfers ownership of the contract to a new account (`newOwner`).
1193      * Internal function without access restriction.
1194      */
1195     function _transferOwnership(address newOwner) internal virtual {
1196         address oldOwner = _owner;
1197         _owner = newOwner;
1198         emit OwnershipTransferred(oldOwner, newOwner);
1199     }
1200 }
1201 
1202 
1203 // File @openzeppelin/contracts/token/ERC721/extensions/ERC721Burnable.sol@v4.5.0
1204 
1205 // OpenZeppelin Contracts v4.4.1 (token/ERC721/extensions/ERC721Burnable.sol)
1206 
1207 pragma solidity ^0.8.0;
1208 
1209 
1210 /**
1211  * @title ERC721 Burnable Token
1212  * @dev ERC721 Token that can be irreversibly burned (destroyed).
1213  */
1214 abstract contract ERC721Burnable is Context, ERC721 {
1215     /**
1216      * @dev Burns `tokenId`. See {ERC721-_burn}.
1217      *
1218      * Requirements:
1219      *
1220      * - The caller must own `tokenId` or be an approved operator.
1221      */
1222     function burn(uint256 tokenId) public virtual {
1223         //solhint-disable-next-line max-line-length
1224         require(_isApprovedOrOwner(_msgSender(), tokenId), "ERC721Burnable: caller is not owner nor approved");
1225         _burn(tokenId);
1226     }
1227 }
1228 
1229 
1230 // File @openzeppelin/contracts/utils/Counters.sol@v4.5.0
1231 
1232 // OpenZeppelin Contracts v4.4.1 (utils/Counters.sol)
1233 
1234 pragma solidity ^0.8.0;
1235 
1236 /**
1237  * @title Counters
1238  * @author Matt Condon (@shrugs)
1239  * @dev Provides counters that can only be incremented, decremented or reset. This can be used e.g. to track the number
1240  * of elements in a mapping, issuing ERC721 ids, or counting request ids.
1241  *
1242  * Include with `using Counters for Counters.Counter;`
1243  */
1244 library Counters {
1245     struct Counter {
1246         // This variable should never be directly accessed by users of the library: interactions must be restricted to
1247         // the library's function. As of Solidity v0.5.2, this cannot be enforced, though there is a proposal to add
1248         // this feature: see https://github.com/ethereum/solidity/issues/4637
1249         uint256 _value; // default: 0
1250     }
1251 
1252     function current(Counter storage counter) internal view returns (uint256) {
1253         return counter._value;
1254     }
1255 
1256     function increment(Counter storage counter) internal {
1257         unchecked {
1258             counter._value += 1;
1259         }
1260     }
1261 
1262     function decrement(Counter storage counter) internal {
1263         uint256 value = counter._value;
1264         require(value > 0, "Counter: decrement overflow");
1265         unchecked {
1266             counter._value = value - 1;
1267         }
1268     }
1269 
1270     function reset(Counter storage counter) internal {
1271         counter._value = 0;
1272     }
1273 }
1274 
1275 
1276 // File contracts/StartonMEE6ERC721.sol
1277 
1278 pragma solidity ^0.8.4;
1279 
1280 
1281 
1282 
1283 
1284 contract StartonMEE6ERC721 is ERC721, Pausable, Ownable, ERC721Burnable {
1285     using Counters for Counters.Counter;
1286 
1287     Counters.Counter private _tokenIdCounter;
1288     bool private _isMintAllowed;
1289     string private _contractUri;
1290     string private _uri;
1291 
1292     constructor(string memory name, string memory symbol, string memory baseUri, string memory contractUri) ERC721(name, symbol) {
1293         _uri = baseUri;
1294         _contractUri = contractUri;
1295         _isMintAllowed = true;
1296     }
1297 
1298     function _baseURI() internal view override returns (string memory) {
1299         return _uri;
1300     }
1301 
1302     function contractURI() public view returns (string memory) {
1303         return _contractUri;
1304     }
1305 
1306     function setContractURI(string memory newContractUri) public onlyOwner {
1307         _contractUri = newContractUri;
1308     }
1309 
1310     function setBaseURI(string memory newBaseUri) public onlyOwner {
1311         _uri = newBaseUri;
1312     }
1313 
1314     function lockMint() public onlyOwner {
1315         _isMintAllowed = false;
1316     }
1317 
1318     function pause() public onlyOwner {
1319         _pause();
1320     }
1321 
1322     function unpause() public onlyOwner {
1323         _unpause();
1324     }
1325 
1326     function safeMint(address to) public onlyOwner {
1327         require(_isMintAllowed);
1328         uint256 tokenId = _tokenIdCounter.current();
1329         _tokenIdCounter.increment();
1330         _safeMint(to, tokenId);
1331     }
1332 
1333     function batchMint(address[] calldata addresses) external onlyOwner {
1334         require(_isMintAllowed);
1335         for (uint256 i = 0; i < addresses.length; i++) {
1336             safeMint(addresses[i]);
1337         }
1338     }
1339 
1340     function _beforeTokenTransfer(address from, address to, uint256 tokenId)
1341     internal
1342     whenNotPaused
1343     override
1344     {
1345         super._beforeTokenTransfer(from, to, tokenId);
1346     }
1347 }