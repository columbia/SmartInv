1 // SPDX-License-Identifier: MIT
2 
3 /*
4 ████████╗██╗  ██╗███████╗███████╗ ██████╗  ██████╗ ██╗     
5 ╚══██╔══╝██║  ██║██╔════╝██╔════╝██╔═══██╗██╔═══██╗██║     
6    ██║   ███████║█████╗  █████╗  ██║   ██║██║   ██║██║     
7    ██║   ██╔══██║██╔══╝  ██╔══╝  ██║   ██║██║   ██║██║     
8    ██║   ██║  ██║███████╗██║     ╚██████╔╝╚██████╔╝███████╗
9    ╚═╝   ╚═╝  ╚═╝╚══════╝╚═╝      ╚═════╝  ╚═════╝ ╚══════╝                                                                                                                                                                                         
10 */
11 
12 pragma solidity ^0.8.0;
13 
14 /**
15  * @dev Interface of the ERC165 standard, as defined in the
16  * https://eips.ethereum.org/EIPS/eip-165[EIP].
17  *
18  * Implementers can declare support of contract interfaces, which can then be
19  * queried by others ({ERC165Checker}).
20  *
21  * For an implementation, see {ERC165}.
22  */
23 interface IERC165 {
24     /**
25      * @dev Returns true if this contract implements the interface defined by
26      * `interfaceId`. See the corresponding
27      * https://eips.ethereum.org/EIPS/eip-165#how-interfaces-are-identified[EIP section]
28      * to learn more about how these ids are created.
29      *
30      * This function call must use less than 30 000 gas.
31      */
32     function supportsInterface(bytes4 interfaceId) external view returns (bool);
33 }
34 
35 
36 // File @openzeppelin/contracts/token/ERC721/IERC721.sol@v4.4.1
37 
38 
39 // OpenZeppelin Contracts v4.4.1 (token/ERC721/IERC721.sol)
40 
41 pragma solidity ^0.8.0;
42 
43 /**
44  * @dev Required interface of an ERC721 compliant contract.
45  */
46 interface IERC721 is IERC165 {
47     /**
48      * @dev Emitted when `tokenId` token is transferred from `from` to `to`.
49      */
50     event Transfer(address indexed from, address indexed to, uint256 indexed tokenId);
51 
52     /**
53      * @dev Emitted when `owner` enables `approved` to manage the `tokenId` token.
54      */
55     event Approval(address indexed owner, address indexed approved, uint256 indexed tokenId);
56 
57     /**
58      * @dev Emitted when `owner` enables or disables (`approved`) `operator` to manage all of its assets.
59      */
60     event ApprovalForAll(address indexed owner, address indexed operator, bool approved);
61 
62     /**
63      * @dev Returns the number of tokens in ``owner``'s account.
64      */
65     function balanceOf(address owner) external view returns (uint256 balance);
66 
67     /**
68      * @dev Returns the owner of the `tokenId` token.
69      *
70      * Requirements:
71      *
72      * - `tokenId` must exist.
73      */
74     function ownerOf(uint256 tokenId) external view returns (address owner);
75 
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
95 
96     /**
97      * @dev Transfers `tokenId` token from `from` to `to`.
98      *
99      * WARNING: Usage of this method is discouraged, use {safeTransferFrom} whenever possible.
100      *
101      * Requirements:
102      *
103      * - `from` cannot be the zero address.
104      * - `to` cannot be the zero address.
105      * - `tokenId` token must be owned by `from`.
106      * - If the caller is not `from`, it must be approved to move this token by either {approve} or {setApprovalForAll}.
107      *
108      * Emits a {Transfer} event.
109      */
110     function transferFrom(
111         address from,
112         address to,
113         uint256 tokenId
114     ) external;
115 
116     /**
117      * @dev Gives permission to `to` to transfer `tokenId` token to another account.
118      * The approval is cleared when the token is transferred.
119      *
120      * Only a single account can be approved at a time, so approving the zero address clears previous approvals.
121      *
122      * Requirements:
123      *
124      * - The caller must own the token or be an approved operator.
125      * - `tokenId` must exist.
126      *
127      * Emits an {Approval} event.
128      */
129     function approve(address to, uint256 tokenId) external;
130 
131     /**
132      * @dev Returns the account approved for `tokenId` token.
133      *
134      * Requirements:
135      *
136      * - `tokenId` must exist.
137      */
138     function getApproved(uint256 tokenId) external view returns (address operator);
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
153      * @dev Returns if the `operator` is allowed to manage all of the assets of `owner`.
154      *
155      * See {setApprovalForAll}
156      */
157     function isApprovedForAll(address owner, address operator) external view returns (bool);
158 
159     /**
160      * @dev Safely transfers `tokenId` token from `from` to `to`.
161      *
162      * Requirements:
163      *
164      * - `from` cannot be the zero address.
165      * - `to` cannot be the zero address.
166      * - `tokenId` token must exist and be owned by `from`.
167      * - If the caller is not `from`, it must be approved to move this token by either {approve} or {setApprovalForAll}.
168      * - If `to` refers to a smart contract, it must implement {IERC721Receiver-onERC721Received}, which is called upon a safe transfer.
169      *
170      * Emits a {Transfer} event.
171      */
172     function safeTransferFrom(
173         address from,
174         address to,
175         uint256 tokenId,
176         bytes calldata data
177     ) external;
178 }
179 
180 
181 // File @openzeppelin/contracts/token/ERC721/IERC721Receiver.sol@v4.4.1
182 
183 
184 // OpenZeppelin Contracts v4.4.1 (token/ERC721/IERC721Receiver.sol)
185 
186 pragma solidity ^0.8.0;
187 
188 /**
189  * @title ERC721 token receiver interface
190  * @dev Interface for any contract that wants to support safeTransfers
191  * from ERC721 asset contracts.
192  */
193 interface IERC721Receiver {
194     /**
195      * @dev Whenever an {IERC721} `tokenId` token is transferred to this contract via {IERC721-safeTransferFrom}
196      * by `operator` from `from`, this function is called.
197      *
198      * It must return its Solidity selector to confirm the token transfer.
199      * If any other value is returned or the interface is not implemented by the recipient, the transfer will be reverted.
200      *
201      * The selector can be obtained in Solidity with `IERC721.onERC721Received.selector`.
202      */
203     function onERC721Received(
204         address operator,
205         address from,
206         uint256 tokenId,
207         bytes calldata data
208     ) external returns (bytes4);
209 }
210 
211 
212 // File @openzeppelin/contracts/token/ERC721/extensions/IERC721Metadata.sol@v4.4.1
213 
214 
215 // OpenZeppelin Contracts v4.4.1 (token/ERC721/extensions/IERC721Metadata.sol)
216 
217 pragma solidity ^0.8.0;
218 
219 /**
220  * @title ERC-721 Non-Fungible Token Standard, optional metadata extension
221  * @dev See https://eips.ethereum.org/EIPS/eip-721
222  */
223 interface IERC721Metadata is IERC721 {
224     /**
225      * @dev Returns the token collection name.
226      */
227     function name() external view returns (string memory);
228 
229     /**
230      * @dev Returns the token collection symbol.
231      */
232     function symbol() external view returns (string memory);
233 
234     /**
235      * @dev Returns the Uniform Resource Identifier (URI) for `tokenId` token.
236      */
237     function tokenURI(uint256 tokenId) external view returns (string memory);
238 }
239 
240 
241 // File @openzeppelin/contracts/utils/Address.sol@v4.4.1
242 
243 
244 // OpenZeppelin Contracts v4.4.1 (utils/Address.sol)
245 
246 pragma solidity ^0.8.0;
247 
248 /**
249  * @dev Collection of functions related to the address type
250  */
251 library Address {
252     /**
253      * @dev Returns true if `account` is a contract.
254      *
255      * [IMPORTANT]
256      * ====
257      * It is unsafe to assume that an address for which this function returns
258      * false is an externally-owned account (EOA) and not a contract.
259      *
260      * Among others, `isContract` will return false for the following
261      * types of addresses:
262      *
263      *  - an externally-owned account
264      *  - a contract in construction
265      *  - an address where a contract will be created
266      *  - an address where a contract lived, but was destroyed
267      * ====
268      */
269     function isContract(address account) internal view returns (bool) {
270         // This method relies on extcodesize, which returns 0 for contracts in
271         // construction, since the code is only stored at the end of the
272         // constructor execution.
273 
274         uint256 size;
275         assembly {
276             size := extcodesize(account)
277         }
278         return size > 0;
279     }
280 
281     /**
282      * @dev Replacement for Solidity's `transfer`: sends `amount` wei to
283      * `recipient`, forwarding all available gas and reverting on errors.
284      *
285      * https://eips.ethereum.org/EIPS/eip-1884[EIP1884] increases the gas cost
286      * of certain opcodes, possibly making contracts go over the 2300 gas limit
287      * imposed by `transfer`, making them unable to receive funds via
288      * `transfer`. {sendValue} removes this limitation.
289      *
290      * https://diligence.consensys.net/posts/2019/09/stop-using-soliditys-transfer-now/[Learn more].
291      *
292      * IMPORTANT: because control is transferred to `recipient`, care must be
293      * taken to not create reentrancy vulnerabilities. Consider using
294      * {ReentrancyGuard} or the
295      * https://solidity.readthedocs.io/en/v0.5.11/security-considerations.html#use-the-checks-effects-interactions-pattern[checks-effects-interactions pattern].
296      */
297     function sendValue(address payable recipient, uint256 amount) internal {
298         require(address(this).balance >= amount, "Address: insufficient balance");
299 
300         (bool success, ) = recipient.call{value: amount}("");
301         require(success, "Address: unable to send value, recipient may have reverted");
302     }
303 
304     /**
305      * @dev Performs a Solidity function call using a low level `call`. A
306      * plain `call` is an unsafe replacement for a function call: use this
307      * function instead.
308      *
309      * If `target` reverts with a revert reason, it is bubbled up by this
310      * function (like regular Solidity function calls).
311      *
312      * Returns the raw returned data. To convert to the expected return value,
313      * use https://solidity.readthedocs.io/en/latest/units-and-global-variables.html?highlight=abi.decode#abi-encoding-and-decoding-functions[`abi.decode`].
314      *
315      * Requirements:
316      *
317      * - `target` must be a contract.
318      * - calling `target` with `data` must not revert.
319      *
320      * _Available since v3.1._
321      */
322     function functionCall(address target, bytes memory data) internal returns (bytes memory) {
323         return functionCall(target, data, "Address: low-level call failed");
324     }
325 
326     /**
327      * @dev Same as {xref-Address-functionCall-address-bytes-}[`functionCall`], but with
328      * `errorMessage` as a fallback revert reason when `target` reverts.
329      *
330      * _Available since v3.1._
331      */
332     function functionCall(
333         address target,
334         bytes memory data,
335         string memory errorMessage
336     ) internal returns (bytes memory) {
337         return functionCallWithValue(target, data, 0, errorMessage);
338     }
339 
340     /**
341      * @dev Same as {xref-Address-functionCall-address-bytes-}[`functionCall`],
342      * but also transferring `value` wei to `target`.
343      *
344      * Requirements:
345      *
346      * - the calling contract must have an ETH balance of at least `value`.
347      * - the called Solidity function must be `payable`.
348      *
349      * _Available since v3.1._
350      */
351     function functionCallWithValue(
352         address target,
353         bytes memory data,
354         uint256 value
355     ) internal returns (bytes memory) {
356         return functionCallWithValue(target, data, value, "Address: low-level call with value failed");
357     }
358 
359     /**
360      * @dev Same as {xref-Address-functionCallWithValue-address-bytes-uint256-}[`functionCallWithValue`], but
361      * with `errorMessage` as a fallback revert reason when `target` reverts.
362      *
363      * _Available since v3.1._
364      */
365     function functionCallWithValue(
366         address target,
367         bytes memory data,
368         uint256 value,
369         string memory errorMessage
370     ) internal returns (bytes memory) {
371         require(address(this).balance >= value, "Address: insufficient balance for call");
372         require(isContract(target), "Address: call to non-contract");
373 
374         (bool success, bytes memory returndata) = target.call{value: value}(data);
375         return verifyCallResult(success, returndata, errorMessage);
376     }
377 
378     /**
379      * @dev Same as {xref-Address-functionCall-address-bytes-}[`functionCall`],
380      * but performing a static call.
381      *
382      * _Available since v3.3._
383      */
384     function functionStaticCall(address target, bytes memory data) internal view returns (bytes memory) {
385         return functionStaticCall(target, data, "Address: low-level static call failed");
386     }
387 
388     /**
389      * @dev Same as {xref-Address-functionCall-address-bytes-string-}[`functionCall`],
390      * but performing a static call.
391      *
392      * _Available since v3.3._
393      */
394     function functionStaticCall(
395         address target,
396         bytes memory data,
397         string memory errorMessage
398     ) internal view returns (bytes memory) {
399         require(isContract(target), "Address: static call to non-contract");
400 
401         (bool success, bytes memory returndata) = target.staticcall(data);
402         return verifyCallResult(success, returndata, errorMessage);
403     }
404 
405     /**
406      * @dev Same as {xref-Address-functionCall-address-bytes-}[`functionCall`],
407      * but performing a delegate call.
408      *
409      * _Available since v3.4._
410      */
411     function functionDelegateCall(address target, bytes memory data) internal returns (bytes memory) {
412         return functionDelegateCall(target, data, "Address: low-level delegate call failed");
413     }
414 
415     /**
416      * @dev Same as {xref-Address-functionCall-address-bytes-string-}[`functionCall`],
417      * but performing a delegate call.
418      *
419      * _Available since v3.4._
420      */
421     function functionDelegateCall(
422         address target,
423         bytes memory data,
424         string memory errorMessage
425     ) internal returns (bytes memory) {
426         require(isContract(target), "Address: delegate call to non-contract");
427 
428         (bool success, bytes memory returndata) = target.delegatecall(data);
429         return verifyCallResult(success, returndata, errorMessage);
430     }
431 
432     /**
433      * @dev Tool to verifies that a low level call was successful, and revert if it wasn't, either by bubbling the
434      * revert reason using the provided one.
435      *
436      * _Available since v4.3._
437      */
438     function verifyCallResult(
439         bool success,
440         bytes memory returndata,
441         string memory errorMessage
442     ) internal pure returns (bytes memory) {
443         if (success) {
444             return returndata;
445         } else {
446             // Look for revert reason and bubble it up if present
447             if (returndata.length > 0) {
448                 // The easiest way to bubble the revert reason is using memory via assembly
449 
450                 assembly {
451                     let returndata_size := mload(returndata)
452                     revert(add(32, returndata), returndata_size)
453                 }
454             } else {
455                 revert(errorMessage);
456             }
457         }
458     }
459 }
460 
461 
462 // File @openzeppelin/contracts/utils/Context.sol@v4.4.1
463 
464 
465 // OpenZeppelin Contracts v4.4.1 (utils/Context.sol)
466 
467 pragma solidity ^0.8.0;
468 
469 /**
470  * @dev Provides information about the current execution context, including the
471  * sender of the transaction and its data. While these are generally available
472  * via msg.sender and msg.data, they should not be accessed in such a direct
473  * manner, since when dealing with meta-transactions the account sending and
474  * paying for execution may not be the actual sender (as far as an application
475  * is concerned).
476  *
477  * This contract is only required for intermediate, library-like contracts.
478  */
479 abstract contract Context {
480     function _msgSender() internal view virtual returns (address) {
481         return msg.sender;
482     }
483 
484     function _msgData() internal view virtual returns (bytes calldata) {
485         return msg.data;
486     }
487 }
488 
489 
490 // File @openzeppelin/contracts/utils/Strings.sol@v4.4.1
491 
492 
493 // OpenZeppelin Contracts v4.4.1 (utils/Strings.sol)
494 
495 pragma solidity ^0.8.0;
496 
497 /**
498  * @dev String operations.
499  */
500 library Strings {
501     bytes16 private constant _HEX_SYMBOLS = "0123456789abcdef";
502 
503     /**
504      * @dev Converts a `uint256` to its ASCII `string` decimal representation.
505      */
506     function toString(uint256 value) internal pure returns (string memory) {
507         // Inspired by OraclizeAPI's implementation - MIT licence
508         // https://github.com/oraclize/ethereum-api/blob/b42146b063c7d6ee1358846c198246239e9360e8/oraclizeAPI_0.4.25.sol
509 
510         if (value == 0) {
511             return "0";
512         }
513         uint256 temp = value;
514         uint256 digits;
515         while (temp != 0) {
516             digits++;
517             temp /= 10;
518         }
519         bytes memory buffer = new bytes(digits);
520         while (value != 0) {
521             digits -= 1;
522             buffer[digits] = bytes1(uint8(48 + uint256(value % 10)));
523             value /= 10;
524         }
525         return string(buffer);
526     }
527 
528     /**
529      * @dev Converts a `uint256` to its ASCII `string` hexadecimal representation.
530      */
531     function toHexString(uint256 value) internal pure returns (string memory) {
532         if (value == 0) {
533             return "0x00";
534         }
535         uint256 temp = value;
536         uint256 length = 0;
537         while (temp != 0) {
538             length++;
539             temp >>= 8;
540         }
541         return toHexString(value, length);
542     }
543 
544     /**
545      * @dev Converts a `uint256` to its ASCII `string` hexadecimal representation with fixed length.
546      */
547     function toHexString(uint256 value, uint256 length) internal pure returns (string memory) {
548         bytes memory buffer = new bytes(2 * length + 2);
549         buffer[0] = "0";
550         buffer[1] = "x";
551         for (uint256 i = 2 * length + 1; i > 1; --i) {
552             buffer[i] = _HEX_SYMBOLS[value & 0xf];
553             value >>= 4;
554         }
555         require(value == 0, "Strings: hex length insufficient");
556         return string(buffer);
557     }
558 }
559 
560 
561 // File @openzeppelin/contracts/utils/introspection/ERC165.sol@v4.4.1
562 
563 
564 // OpenZeppelin Contracts v4.4.1 (utils/introspection/ERC165.sol)
565 
566 pragma solidity ^0.8.0;
567 
568 /**
569  * @dev Implementation of the {IERC165} interface.
570  *
571  * Contracts that want to implement ERC165 should inherit from this contract and override {supportsInterface} to check
572  * for the additional interface id that will be supported. For example:
573  *
574  * ```solidity
575  * function supportsInterface(bytes4 interfaceId) public view virtual override returns (bool) {
576  *     return interfaceId == type(MyInterface).interfaceId || super.supportsInterface(interfaceId);
577  * }
578  * ```
579  *
580  * Alternatively, {ERC165Storage} provides an easier to use but more expensive implementation.
581  */
582 abstract contract ERC165 is IERC165 {
583     /**
584      * @dev See {IERC165-supportsInterface}.
585      */
586     function supportsInterface(bytes4 interfaceId) public view virtual override returns (bool) {
587         return interfaceId == type(IERC165).interfaceId;
588     }
589 }
590 
591 
592 // File @openzeppelin/contracts/token/ERC721/ERC721.sol@v4.4.1
593 
594 
595 // OpenZeppelin Contracts v4.4.1 (token/ERC721/ERC721.sol)
596 
597 pragma solidity ^0.8.0;
598 
599 
600 
601 
602 
603 
604 
605 /**
606  * @dev Implementation of https://eips.ethereum.org/EIPS/eip-721[ERC721] Non-Fungible Token Standard, including
607  * the Metadata extension, but not including the Enumerable extension, which is available separately as
608  * {ERC721Enumerable}.
609  */
610 contract ERC721 is Context, ERC165, IERC721, IERC721Metadata {
611     using Address for address;
612     using Strings for uint256;
613 
614     // Token name
615     string private _name;
616 
617     // Token symbol
618     string private _symbol;
619 
620     // Mapping from token ID to owner address
621     mapping(uint256 => address) private _owners;
622 
623     // Mapping owner address to token count
624     mapping(address => uint256) private _balances;
625 
626     // Mapping from token ID to approved address
627     mapping(uint256 => address) private _tokenApprovals;
628 
629     // Mapping from owner to operator approvals
630     mapping(address => mapping(address => bool)) private _operatorApprovals;
631 
632     /**
633      * @dev Initializes the contract by setting a `name` and a `symbol` to the token collection.
634      */
635     constructor(string memory name_, string memory symbol_) {
636         _name = name_;
637         _symbol = symbol_;
638     }
639 
640     /**
641      * @dev See {IERC165-supportsInterface}.
642      */
643     function supportsInterface(bytes4 interfaceId) public view virtual override(ERC165, IERC165) returns (bool) {
644         return
645             interfaceId == type(IERC721).interfaceId ||
646             interfaceId == type(IERC721Metadata).interfaceId ||
647             super.supportsInterface(interfaceId);
648     }
649 
650     /**
651      * @dev See {IERC721-balanceOf}.
652      */
653     function balanceOf(address owner) public view virtual override returns (uint256) {
654         require(owner != address(0), "ERC721: balance query for the zero address");
655         return _balances[owner];
656     }
657 
658     /**
659      * @dev See {IERC721-ownerOf}.
660      */
661     function ownerOf(uint256 tokenId) public view virtual override returns (address) {
662         address owner = _owners[tokenId];
663         require(owner != address(0), "ERC721: owner query for nonexistent token");
664         return owner;
665     }
666 
667     /**
668      * @dev See {IERC721Metadata-name}.
669      */
670     function name() public view virtual override returns (string memory) {
671         return _name;
672     }
673 
674     /**
675      * @dev See {IERC721Metadata-symbol}.
676      */
677     function symbol() public view virtual override returns (string memory) {
678         return _symbol;
679     }
680 
681     /**
682      * @dev See {IERC721Metadata-tokenURI}.
683      */
684     function tokenURI(uint256 tokenId) public view virtual override returns (string memory) {
685         require(_exists(tokenId), "ERC721Metadata: URI query for nonexistent token");
686 
687         string memory baseURI = _baseURI();
688         return bytes(baseURI).length > 0 ? string(abi.encodePacked(baseURI, tokenId.toString())) : "";
689     }
690 
691     /**
692      * @dev Base URI for computing {tokenURI}. If set, the resulting URI for each
693      * token will be the concatenation of the `baseURI` and the `tokenId`. Empty
694      * by default, can be overriden in child contracts.
695      */
696     function _baseURI() internal view virtual returns (string memory) {
697         return "";
698     }
699 
700     /**
701      * @dev See {IERC721-approve}.
702      */
703     function approve(address to, uint256 tokenId) public virtual override {
704         address owner = ERC721.ownerOf(tokenId);
705         require(to != owner, "ERC721: approval to current owner");
706 
707         require(
708             _msgSender() == owner || isApprovedForAll(owner, _msgSender()),
709             "ERC721: approve caller is not owner nor approved for all"
710         );
711 
712         _approve(to, tokenId);
713     }
714 
715     /**
716      * @dev See {IERC721-getApproved}.
717      */
718     function getApproved(uint256 tokenId) public view virtual override returns (address) {
719         require(_exists(tokenId), "ERC721: approved query for nonexistent token");
720 
721         return _tokenApprovals[tokenId];
722     }
723 
724     /**
725      * @dev See {IERC721-setApprovalForAll}.
726      */
727     function setApprovalForAll(address operator, bool approved) public virtual override {
728         _setApprovalForAll(_msgSender(), operator, approved);
729     }
730 
731     /**
732      * @dev See {IERC721-isApprovedForAll}.
733      */
734     function isApprovedForAll(address owner, address operator) public view virtual override returns (bool) {
735         return _operatorApprovals[owner][operator];
736     }
737 
738     /**
739      * @dev See {IERC721-transferFrom}.
740      */
741     function transferFrom(
742         address from,
743         address to,
744         uint256 tokenId
745     ) public virtual override {
746         //solhint-disable-next-line max-line-length
747         require(_isApprovedOrOwner(_msgSender(), tokenId), "ERC721: transfer caller is not owner nor approved");
748 
749         _transfer(from, to, tokenId);
750     }
751 
752     /**
753      * @dev See {IERC721-safeTransferFrom}.
754      */
755     function safeTransferFrom(
756         address from,
757         address to,
758         uint256 tokenId
759     ) public virtual override {
760         safeTransferFrom(from, to, tokenId, "");
761     }
762 
763     /**
764      * @dev See {IERC721-safeTransferFrom}.
765      */
766     function safeTransferFrom(
767         address from,
768         address to,
769         uint256 tokenId,
770         bytes memory _data
771     ) public virtual override {
772         require(_isApprovedOrOwner(_msgSender(), tokenId), "ERC721: transfer caller is not owner nor approved");
773         _safeTransfer(from, to, tokenId, _data);
774     }
775 
776     /**
777      * @dev Safely transfers `tokenId` token from `from` to `to`, checking first that contract recipients
778      * are aware of the ERC721 protocol to prevent tokens from being forever locked.
779      *
780      * `_data` is additional data, it has no specified format and it is sent in call to `to`.
781      *
782      * This internal function is equivalent to {safeTransferFrom}, and can be used to e.g.
783      * implement alternative mechanisms to perform token transfer, such as signature-based.
784      *
785      * Requirements:
786      *
787      * - `from` cannot be the zero address.
788      * - `to` cannot be the zero address.
789      * - `tokenId` token must exist and be owned by `from`.
790      * - If `to` refers to a smart contract, it must implement {IERC721Receiver-onERC721Received}, which is called upon a safe transfer.
791      *
792      * Emits a {Transfer} event.
793      */
794     function _safeTransfer(
795         address from,
796         address to,
797         uint256 tokenId,
798         bytes memory _data
799     ) internal virtual {
800         _transfer(from, to, tokenId);
801         require(_checkOnERC721Received(from, to, tokenId, _data), "ERC721: transfer to non ERC721Receiver implementer");
802     }
803 
804     /**
805      * @dev Returns whether `tokenId` exists.
806      *
807      * Tokens can be managed by their owner or approved accounts via {approve} or {setApprovalForAll}.
808      *
809      * Tokens start existing when they are minted (`_mint`),
810      * and stop existing when they are burned (`_burn`).
811      */
812     function _exists(uint256 tokenId) internal view virtual returns (bool) {
813         return _owners[tokenId] != address(0);
814     }
815 
816     /**
817      * @dev Returns whether `spender` is allowed to manage `tokenId`.
818      *
819      * Requirements:
820      *
821      * - `tokenId` must exist.
822      */
823     function _isApprovedOrOwner(address spender, uint256 tokenId) internal view virtual returns (bool) {
824         require(_exists(tokenId), "ERC721: operator query for nonexistent token");
825         address owner = ERC721.ownerOf(tokenId);
826         return (spender == owner || getApproved(tokenId) == spender || isApprovedForAll(owner, spender));
827     }
828 
829     /**
830      * @dev Safely mints `tokenId` and transfers it to `to`.
831      *
832      * Requirements:
833      *
834      * - `tokenId` must not exist.
835      * - If `to` refers to a smart contract, it must implement {IERC721Receiver-onERC721Received}, which is called upon a safe transfer.
836      *
837      * Emits a {Transfer} event.
838      */
839     function _safeMint(address to, uint256 tokenId) internal virtual {
840         _safeMint(to, tokenId, "");
841     }
842 
843     /**
844      * @dev Same as {xref-ERC721-_safeMint-address-uint256-}[`_safeMint`], with an additional `data` parameter which is
845      * forwarded in {IERC721Receiver-onERC721Received} to contract recipients.
846      */
847     function _safeMint(
848         address to,
849         uint256 tokenId,
850         bytes memory _data
851     ) internal virtual {
852         _mint(to, tokenId);
853         require(
854             _checkOnERC721Received(address(0), to, tokenId, _data),
855             "ERC721: transfer to non ERC721Receiver implementer"
856         );
857     }
858 
859     /**
860      * @dev Mints `tokenId` and transfers it to `to`.
861      *
862      * WARNING: Usage of this method is discouraged, use {_safeMint} whenever possible
863      *
864      * Requirements:
865      *
866      * - `tokenId` must not exist.
867      * - `to` cannot be the zero address.
868      *
869      * Emits a {Transfer} event.
870      */
871     function _mint(address to, uint256 tokenId) internal virtual {
872         require(to != address(0), "ERC721: mint to the zero address");
873         require(!_exists(tokenId), "ERC721: token already minted");
874 
875         _beforeTokenTransfer(address(0), to, tokenId);
876 
877         _balances[to] += 1;
878         _owners[tokenId] = to;
879 
880         emit Transfer(address(0), to, tokenId);
881     }
882 
883     /**
884      * @dev Destroys `tokenId`.
885      * The approval is cleared when the token is burned.
886      *
887      * Requirements:
888      *
889      * - `tokenId` must exist.
890      *
891      * Emits a {Transfer} event.
892      */
893     function _burn(uint256 tokenId) internal virtual {
894         address owner = ERC721.ownerOf(tokenId);
895 
896         _beforeTokenTransfer(owner, address(0), tokenId);
897 
898         // Clear approvals
899         _approve(address(0), tokenId);
900 
901         _balances[owner] -= 1;
902         delete _owners[tokenId];
903 
904         emit Transfer(owner, address(0), tokenId);
905     }
906 
907     /**
908      * @dev Transfers `tokenId` from `from` to `to`.
909      *  As opposed to {transferFrom}, this imposes no restrictions on msg.sender.
910      *
911      * Requirements:
912      *
913      * - `to` cannot be the zero address.
914      * - `tokenId` token must be owned by `from`.
915      *
916      * Emits a {Transfer} event.
917      */
918     function _transfer(
919         address from,
920         address to,
921         uint256 tokenId
922     ) internal virtual {
923         require(ERC721.ownerOf(tokenId) == from, "ERC721: transfer of token that is not own");
924         require(to != address(0), "ERC721: transfer to the zero address");
925 
926         _beforeTokenTransfer(from, to, tokenId);
927 
928         // Clear approvals from the previous owner
929         _approve(address(0), tokenId);
930 
931         _balances[from] -= 1;
932         _balances[to] += 1;
933         _owners[tokenId] = to;
934 
935         emit Transfer(from, to, tokenId);
936     }
937 
938     /**
939      * @dev Approve `to` to operate on `tokenId`
940      *
941      * Emits a {Approval} event.
942      */
943     function _approve(address to, uint256 tokenId) internal virtual {
944         _tokenApprovals[tokenId] = to;
945         emit Approval(ERC721.ownerOf(tokenId), to, tokenId);
946     }
947 
948     /**
949      * @dev Approve `operator` to operate on all of `owner` tokens
950      *
951      * Emits a {ApprovalForAll} event.
952      */
953     function _setApprovalForAll(
954         address owner,
955         address operator,
956         bool approved
957     ) internal virtual {
958         require(owner != operator, "ERC721: approve to caller");
959         _operatorApprovals[owner][operator] = approved;
960         emit ApprovalForAll(owner, operator, approved);
961     }
962 
963     /**
964      * @dev Internal function to invoke {IERC721Receiver-onERC721Received} on a target address.
965      * The call is not executed if the target address is not a contract.
966      *
967      * @param from address representing the previous owner of the given token ID
968      * @param to target address that will receive the tokens
969      * @param tokenId uint256 ID of the token to be transferred
970      * @param _data bytes optional data to send along with the call
971      * @return bool whether the call correctly returned the expected magic value
972      */
973     function _checkOnERC721Received(
974         address from,
975         address to,
976         uint256 tokenId,
977         bytes memory _data
978     ) private returns (bool) {
979         if (to.isContract()) {
980             try IERC721Receiver(to).onERC721Received(_msgSender(), from, tokenId, _data) returns (bytes4 retval) {
981                 return retval == IERC721Receiver.onERC721Received.selector;
982             } catch (bytes memory reason) {
983                 if (reason.length == 0) {
984                     revert("ERC721: transfer to non ERC721Receiver implementer");
985                 } else {
986                     assembly {
987                         revert(add(32, reason), mload(reason))
988                     }
989                 }
990             }
991         } else {
992             return true;
993         }
994     }
995 
996     /**
997      * @dev Hook that is called before any token transfer. This includes minting
998      * and burning.
999      *
1000      * Calling conditions:
1001      *
1002      * - When `from` and `to` are both non-zero, ``from``'s `tokenId` will be
1003      * transferred to `to`.
1004      * - When `from` is zero, `tokenId` will be minted for `to`.
1005      * - When `to` is zero, ``from``'s `tokenId` will be burned.
1006      * - `from` and `to` are never both zero.
1007      *
1008      * To learn more about hooks, head to xref:ROOT:extending-contracts.adoc#using-hooks[Using Hooks].
1009      */
1010     function _beforeTokenTransfer(
1011         address from,
1012         address to,
1013         uint256 tokenId
1014     ) internal virtual {}
1015 }
1016 
1017 
1018 // File @openzeppelin/contracts/access/Ownable.sol@v4.4.1
1019 
1020 
1021 // OpenZeppelin Contracts v4.4.1 (access/Ownable.sol)
1022 
1023 pragma solidity ^0.8.0;
1024 
1025 /**
1026  * @dev Contract module which provides a basic access control mechanism, where
1027  * there is an account (an owner) that can be granted exclusive access to
1028  * specific functions.
1029  *
1030  * By default, the owner account will be the one that deploys the contract. This
1031  * can later be changed with {transferOwnership}.
1032  *
1033  * This module is used through inheritance. It will make available the modifier
1034  * `onlyOwner`, which can be applied to your functions to restrict their use to
1035  * the owner.
1036  */
1037 abstract contract Ownable is Context {
1038     address private _owner;
1039 
1040     event OwnershipTransferred(address indexed previousOwner, address indexed newOwner);
1041 
1042     /**
1043      * @dev Initializes the contract setting the deployer as the initial owner.
1044      */
1045     constructor() {
1046         _transferOwnership(_msgSender());
1047     }
1048 
1049     /**
1050      * @dev Returns the address of the current owner.
1051      */
1052     function owner() public view virtual returns (address) {
1053         return _owner;
1054     }
1055 
1056     /**
1057      * @dev Throws if called by any account other than the owner.
1058      */
1059     modifier onlyOwner() {
1060         require(owner() == _msgSender(), "Ownable: caller is not the owner");
1061         _;
1062     }
1063 
1064     /**
1065      * @dev Leaves the contract without owner. It will not be possible to call
1066      * `onlyOwner` functions anymore. Can only be called by the current owner.
1067      *
1068      * NOTE: Renouncing ownership will leave the contract without an owner,
1069      * thereby removing any functionality that is only available to the owner.
1070      */
1071     function renounceOwnership() public virtual onlyOwner {
1072         _transferOwnership(address(0));
1073     }
1074 
1075     /**
1076      * @dev Transfers ownership of the contract to a new account (`newOwner`).
1077      * Can only be called by the current owner.
1078      */
1079     function transferOwnership(address newOwner) public virtual onlyOwner {
1080         require(newOwner != address(0), "Ownable: new owner is the zero address");
1081         _transferOwnership(newOwner);
1082     }
1083 
1084     /**
1085      * @dev Transfers ownership of the contract to a new account (`newOwner`).
1086      * Internal function without access restriction.
1087      */
1088     function _transferOwnership(address newOwner) internal virtual {
1089         address oldOwner = _owner;
1090         _owner = newOwner;
1091         emit OwnershipTransferred(oldOwner, newOwner);
1092     }
1093 }
1094 
1095 
1096 // File @openzeppelin/contracts/token/ERC721/extensions/IERC721Enumerable.sol@v4.4.1
1097 
1098 
1099 // OpenZeppelin Contracts v4.4.1 (token/ERC721/extensions/IERC721Enumerable.sol)
1100 
1101 pragma solidity ^0.8.0;
1102 
1103 /**
1104  * @title ERC-721 Non-Fungible Token Standard, optional enumeration extension
1105  * @dev See https://eips.ethereum.org/EIPS/eip-721
1106  */
1107 interface IERC721Enumerable is IERC721 {
1108     /**
1109      * @dev Returns the total amount of tokens stored by the contract.
1110      */
1111     function totalSupply() external view returns (uint256);
1112 
1113     /**
1114      * @dev Returns a token ID owned by `owner` at a given `index` of its token list.
1115      * Use along with {balanceOf} to enumerate all of ``owner``'s tokens.
1116      */
1117     function tokenOfOwnerByIndex(address owner, uint256 index) external view returns (uint256 tokenId);
1118 
1119     /**
1120      * @dev Returns a token ID at a given `index` of all the tokens stored by the contract.
1121      * Use along with {totalSupply} to enumerate all tokens.
1122      */
1123     function tokenByIndex(uint256 index) external view returns (uint256);
1124 }
1125 
1126 
1127 // File @openzeppelin/contracts/token/ERC721/extensions/ERC721Enumerable.sol@v4.4.1
1128 
1129 
1130 // OpenZeppelin Contracts v4.4.1 (token/ERC721/extensions/ERC721Enumerable.sol)
1131 
1132 pragma solidity ^0.8.0;
1133 
1134 
1135 /**
1136  * @dev This implements an optional extension of {ERC721} defined in the EIP that adds
1137  * enumerability of all the token ids in the contract as well as all token ids owned by each
1138  * account.
1139  */
1140 abstract contract ERC721Enumerable is ERC721, IERC721Enumerable {
1141     // Mapping from owner to list of owned token IDs
1142     mapping(address => mapping(uint256 => uint256)) private _ownedTokens;
1143 
1144     // Mapping from token ID to index of the owner tokens list
1145     mapping(uint256 => uint256) private _ownedTokensIndex;
1146 
1147     // Array with all token ids, used for enumeration
1148     uint256[] private _allTokens;
1149 
1150     // Mapping from token id to position in the allTokens array
1151     mapping(uint256 => uint256) private _allTokensIndex;
1152 
1153     /**
1154      * @dev See {IERC165-supportsInterface}.
1155      */
1156     function supportsInterface(bytes4 interfaceId) public view virtual override(IERC165, ERC721) returns (bool) {
1157         return interfaceId == type(IERC721Enumerable).interfaceId || super.supportsInterface(interfaceId);
1158     }
1159 
1160     /**
1161      * @dev See {IERC721Enumerable-tokenOfOwnerByIndex}.
1162      */
1163     function tokenOfOwnerByIndex(address owner, uint256 index) public view virtual override returns (uint256) {
1164         require(index < ERC721.balanceOf(owner), "ERC721Enumerable: owner index out of bounds");
1165         return _ownedTokens[owner][index];
1166     }
1167 
1168     /**
1169      * @dev See {IERC721Enumerable-totalSupply}.
1170      */
1171     function totalSupply() public view virtual override returns (uint256) {
1172         return _allTokens.length;
1173     }
1174 
1175     /**
1176      * @dev See {IERC721Enumerable-tokenByIndex}.
1177      */
1178     function tokenByIndex(uint256 index) public view virtual override returns (uint256) {
1179         require(index < ERC721Enumerable.totalSupply(), "ERC721Enumerable: global index out of bounds");
1180         return _allTokens[index];
1181     }
1182 
1183     /**
1184      * @dev Hook that is called before any token transfer. This includes minting
1185      * and burning.
1186      *
1187      * Calling conditions:
1188      *
1189      * - When `from` and `to` are both non-zero, ``from``'s `tokenId` will be
1190      * transferred to `to`.
1191      * - When `from` is zero, `tokenId` will be minted for `to`.
1192      * - When `to` is zero, ``from``'s `tokenId` will be burned.
1193      * - `from` cannot be the zero address.
1194      * - `to` cannot be the zero address.
1195      *
1196      * To learn more about hooks, head to xref:ROOT:extending-contracts.adoc#using-hooks[Using Hooks].
1197      */
1198     function _beforeTokenTransfer(
1199         address from,
1200         address to,
1201         uint256 tokenId
1202     ) internal virtual override {
1203         super._beforeTokenTransfer(from, to, tokenId);
1204 
1205         if (from == address(0)) {
1206             _addTokenToAllTokensEnumeration(tokenId);
1207         } else if (from != to) {
1208             _removeTokenFromOwnerEnumeration(from, tokenId);
1209         }
1210         if (to == address(0)) {
1211             _removeTokenFromAllTokensEnumeration(tokenId);
1212         } else if (to != from) {
1213             _addTokenToOwnerEnumeration(to, tokenId);
1214         }
1215     }
1216 
1217     /**
1218      * @dev Private function to add a token to this extension's ownership-tracking data structures.
1219      * @param to address representing the new owner of the given token ID
1220      * @param tokenId uint256 ID of the token to be added to the tokens list of the given address
1221      */
1222     function _addTokenToOwnerEnumeration(address to, uint256 tokenId) private {
1223         uint256 length = ERC721.balanceOf(to);
1224         _ownedTokens[to][length] = tokenId;
1225         _ownedTokensIndex[tokenId] = length;
1226     }
1227 
1228     /**
1229      * @dev Private function to add a token to this extension's token tracking data structures.
1230      * @param tokenId uint256 ID of the token to be added to the tokens list
1231      */
1232     function _addTokenToAllTokensEnumeration(uint256 tokenId) private {
1233         _allTokensIndex[tokenId] = _allTokens.length;
1234         _allTokens.push(tokenId);
1235     }
1236 
1237     /**
1238      * @dev Private function to remove a token from this extension's ownership-tracking data structures. Note that
1239      * while the token is not assigned a new owner, the `_ownedTokensIndex` mapping is _not_ updated: this allows for
1240      * gas optimizations e.g. when performing a transfer operation (avoiding double writes).
1241      * This has O(1) time complexity, but alters the order of the _ownedTokens array.
1242      * @param from address representing the previous owner of the given token ID
1243      * @param tokenId uint256 ID of the token to be removed from the tokens list of the given address
1244      */
1245     function _removeTokenFromOwnerEnumeration(address from, uint256 tokenId) private {
1246         // To prevent a gap in from's tokens array, we store the last token in the index of the token to delete, and
1247         // then delete the last slot (swap and pop).
1248 
1249         uint256 lastTokenIndex = ERC721.balanceOf(from) - 1;
1250         uint256 tokenIndex = _ownedTokensIndex[tokenId];
1251 
1252         // When the token to delete is the last token, the swap operation is unnecessary
1253         if (tokenIndex != lastTokenIndex) {
1254             uint256 lastTokenId = _ownedTokens[from][lastTokenIndex];
1255 
1256             _ownedTokens[from][tokenIndex] = lastTokenId; // Move the last token to the slot of the to-delete token
1257             _ownedTokensIndex[lastTokenId] = tokenIndex; // Update the moved token's index
1258         }
1259 
1260         // This also deletes the contents at the last position of the array
1261         delete _ownedTokensIndex[tokenId];
1262         delete _ownedTokens[from][lastTokenIndex];
1263     }
1264 
1265     /**
1266      * @dev Private function to remove a token from this extension's token tracking data structures.
1267      * This has O(1) time complexity, but alters the order of the _allTokens array.
1268      * @param tokenId uint256 ID of the token to be removed from the tokens list
1269      */
1270     function _removeTokenFromAllTokensEnumeration(uint256 tokenId) private {
1271         // To prevent a gap in the tokens array, we store the last token in the index of the token to delete, and
1272         // then delete the last slot (swap and pop).
1273 
1274         uint256 lastTokenIndex = _allTokens.length - 1;
1275         uint256 tokenIndex = _allTokensIndex[tokenId];
1276 
1277         // When the token to delete is the last token, the swap operation is unnecessary. However, since this occurs so
1278         // rarely (when the last minted token is burnt) that we still do the swap here to avoid the gas cost of adding
1279         // an 'if' statement (like in _removeTokenFromOwnerEnumeration)
1280         uint256 lastTokenId = _allTokens[lastTokenIndex];
1281 
1282         _allTokens[tokenIndex] = lastTokenId; // Move the last token to the slot of the to-delete token
1283         _allTokensIndex[lastTokenId] = tokenIndex; // Update the moved token's index
1284 
1285         // This also deletes the contents at the last position of the array
1286         delete _allTokensIndex[tokenId];
1287         _allTokens.pop();
1288     }
1289 }
1290 
1291 
1292 // File contracts/tf.sol
1293 
1294 /*
1295 ████████╗██╗  ██╗███████╗███████╗ ██████╗  ██████╗ ██╗     
1296 ╚══██╔══╝██║  ██║██╔════╝██╔════╝██╔═══██╗██╔═══██╗██║     
1297    ██║   ███████║█████╗  █████╗  ██║   ██║██║   ██║██║     
1298    ██║   ██╔══██║██╔══╝  ██╔══╝  ██║   ██║██║   ██║██║     
1299    ██║   ██║  ██║███████╗██║     ╚██████╔╝╚██████╔╝███████╗
1300    ╚═╝   ╚═╝  ╚═╝╚══════╝╚═╝      ╚═════╝  ╚═════╝ ╚══════╝                                                                                                                                                                                         
1301 */
1302 pragma solidity ^0.8.0;
1303 
1304 
1305 
1306 contract TF is ERC721, ERC721Enumerable, Ownable {
1307     string private _baseURIextended;
1308     address payable public immutable shareholderAddress;
1309     uint256 public constant maxSupply = 6555;
1310     uint256 public immutable maxMint = 10;
1311     uint256 public immutable freeSupply = 1000;
1312 
1313     
1314     bool public isSaleActive = false;
1315     constructor(address payable shareholderAddress_) ERC721("The Fool NFT", "TF") {
1316         require(shareholderAddress_ != address(0));
1317         shareholderAddress = shareholderAddress_;
1318         _baseURIextended = "ipfs://QmSpv36AoMFJmn4KqGWYmGtMvnxXgP5F8P9QTaoznVyq4p/";
1319     }
1320 
1321     function _beforeTokenTransfer(address from, address to, uint256 tokenId) internal override(ERC721, ERC721Enumerable) {
1322         super._beforeTokenTransfer(from, to, tokenId);
1323     }
1324 
1325     function supportsInterface(bytes4 interfaceId) public view virtual override(ERC721, ERC721Enumerable) returns (bool) {
1326         return super.supportsInterface(interfaceId);
1327     }
1328 
1329     function setBaseURI(string memory baseURI_) external onlyOwner() {
1330         _baseURIextended = baseURI_;
1331     }
1332 
1333     function _baseURI() internal view virtual override returns (string memory) {
1334         return _baseURIextended;
1335     }
1336 
1337     function freeMint(uint numberOfTokens) public {
1338 
1339         require(isSaleActive, "TF: Sale are not active");
1340         require(numberOfTokens <= 5, "TF: You can only mint a maximum of 5 tokens per transaction");
1341         require(balanceOf(msg.sender) + numberOfTokens <= maxMint, "TF: Maximum 10 per wallet");
1342         require(totalSupply() + numberOfTokens <= freeSupply, "TF: Only the 1000 first mphers were free. Please use mint function now ;)");
1343         for(uint i = 0; i < numberOfTokens; i++) {
1344             uint mintIndex = totalSupply();
1345             if (totalSupply() < freeSupply) {
1346                 _safeMint(msg.sender, mintIndex);
1347             }
1348         }
1349     }
1350     function toggleSale() external onlyOwner {
1351         isSaleActive = !isSaleActive;
1352     }
1353     function mint(uint numberOfTokens) public payable {
1354         require(isSaleActive, "TF: Sale are not active");
1355         require(numberOfTokens <= 5, "TF: You can only mint a maximum of 5 tokens per transaction");
1356         require(balanceOf(msg.sender) + numberOfTokens <= maxMint, "TF: Maximum 10 tokens per wallet");
1357         require(totalSupply() + numberOfTokens <= maxSupply, "TF: Purchase would exceed max supply of tokens");
1358         require(0.01 ether * numberOfTokens <= msg.value, "TF: Ether value sent is not correct");
1359 
1360         for(uint i = 0; i < numberOfTokens; i++) {
1361             uint mintIndex = totalSupply();
1362             if (totalSupply() < maxSupply) {
1363                 _safeMint(msg.sender, mintIndex);
1364             }
1365         }
1366     }
1367 
1368     function withdraw() public onlyOwner {
1369         uint256 balance = address(this).balance;
1370         Address.sendValue(shareholderAddress, balance);
1371     }
1372 }
1373 
1374 
1375 // File contracts/libraries/Base64.sol
1376 
1377 /**
1378  *Submitted for verification at Etherscan.io on 2021-09-05
1379  */
1380 
1381 
1382 pragma solidity ^0.8.0;
1383 
1384 /// [MIT License]
1385 /// @title Base64
1386 /// @notice Provides a function for encoding some bytes in base64
1387 /// @author Brecht Devos <brecht@loopring.org>
1388 library Base64 {
1389     bytes internal constant TABLE =
1390         "ABCDEFGHIJKLMNOPQRSTUVWXYZabcdefghijklmnopqrstuvwxyz0123456789+/";
1391 
1392     /// @notice Encodes some bytes to the base64 representation
1393     function encode(bytes memory data) internal pure returns (string memory) {
1394         uint256 len = data.length;
1395         if (len == 0) return "";
1396 
1397         // multiply by 4/3 rounded up
1398         uint256 encodedLen = 4 * ((len + 2) / 3);
1399 
1400         // Add some extra buffer at the end
1401         bytes memory result = new bytes(encodedLen + 32);
1402 
1403         bytes memory table = TABLE;
1404 
1405         assembly {
1406             let tablePtr := add(table, 1)
1407             let resultPtr := add(result, 32)
1408 
1409             for {
1410                 let i := 0
1411             } lt(i, len) {
1412 
1413             } {
1414                 i := add(i, 3)
1415                 let input := and(mload(add(data, i)), 0xffffff)
1416 
1417                 let out := mload(add(tablePtr, and(shr(18, input), 0x3F)))
1418                 out := shl(8, out)
1419                 out := add(
1420                     out,
1421                     and(mload(add(tablePtr, and(shr(12, input), 0x3F))), 0xFF)
1422                 )
1423                 out := shl(8, out)
1424                 out := add(
1425                     out,
1426                     and(mload(add(tablePtr, and(shr(6, input), 0x3F))), 0xFF)
1427                 )
1428                 out := shl(8, out)
1429                 out := add(
1430                     out,
1431                     and(mload(add(tablePtr, and(input, 0x3F))), 0xFF)
1432                 )
1433                 out := shl(224, out)
1434 
1435                 mstore(resultPtr, out)
1436 
1437                 resultPtr := add(resultPtr, 4)
1438             }
1439 
1440             switch mod(len, 3)
1441             case 1 {
1442                 mstore(sub(resultPtr, 2), shl(240, 0x3d3d))
1443             }
1444             case 2 {
1445                 mstore(sub(resultPtr, 1), shl(248, 0x3d))
1446             }
1447 
1448             mstore(result, encodedLen)
1449         }
1450 
1451         return string(result);
1452     }
1453 }