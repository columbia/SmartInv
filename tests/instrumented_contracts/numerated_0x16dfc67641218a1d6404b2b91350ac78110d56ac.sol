1 // File: @openzeppelin/contracts/utils/introspection/IERC165.sol
2 
3 
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
32 // OpenZeppelin Contracts (last updated v4.6.0) (token/ERC721/IERC721.sol)
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
71      * @dev Safely transfers `tokenId` token from `from` to `to`.
72      *
73      * Requirements:
74      *
75      * - `from` cannot be the zero address.
76      * - `to` cannot be the zero address.
77      * - `tokenId` token must exist and be owned by `from`.
78      * - If the caller is not `from`, it must be approved to move this token by either {approve} or {setApprovalForAll}.
79      * - If `to` refers to a smart contract, it must implement {IERC721Receiver-onERC721Received}, which is called upon a safe transfer.
80      *
81      * Emits a {Transfer} event.
82      */
83     function safeTransferFrom(
84         address from,
85         address to,
86         uint256 tokenId,
87         bytes calldata data
88     ) external;
89 
90     /**
91      * @dev Safely transfers `tokenId` token from `from` to `to`, checking first that contract recipients
92      * are aware of the ERC721 protocol to prevent tokens from being forever locked.
93      *
94      * Requirements:
95      *
96      * - `from` cannot be the zero address.
97      * - `to` cannot be the zero address.
98      * - `tokenId` token must exist and be owned by `from`.
99      * - If the caller is not `from`, it must be have been allowed to move this token by either {approve} or {setApprovalForAll}.
100      * - If `to` refers to a smart contract, it must implement {IERC721Receiver-onERC721Received}, which is called upon a safe transfer.
101      *
102      * Emits a {Transfer} event.
103      */
104     function safeTransferFrom(
105         address from,
106         address to,
107         uint256 tokenId
108     ) external;
109 
110     /**
111      * @dev Transfers `tokenId` token from `from` to `to`.
112      *
113      * WARNING: Usage of this method is discouraged, use {safeTransferFrom} whenever possible.
114      *
115      * Requirements:
116      *
117      * - `from` cannot be the zero address.
118      * - `to` cannot be the zero address.
119      * - `tokenId` token must be owned by `from`.
120      * - If the caller is not `from`, it must be approved to move this token by either {approve} or {setApprovalForAll}.
121      *
122      * Emits a {Transfer} event.
123      */
124     function transferFrom(
125         address from,
126         address to,
127         uint256 tokenId
128     ) external;
129 
130     /**
131      * @dev Gives permission to `to` to transfer `tokenId` token to another account.
132      * The approval is cleared when the token is transferred.
133      *
134      * Only a single account can be approved at a time, so approving the zero address clears previous approvals.
135      *
136      * Requirements:
137      *
138      * - The caller must own the token or be an approved operator.
139      * - `tokenId` must exist.
140      *
141      * Emits an {Approval} event.
142      */
143     function approve(address to, uint256 tokenId) external;
144 
145     /**
146      * @dev Approve or remove `operator` as an operator for the caller.
147      * Operators can call {transferFrom} or {safeTransferFrom} for any token owned by the caller.
148      *
149      * Requirements:
150      *
151      * - The `operator` cannot be the caller.
152      *
153      * Emits an {ApprovalForAll} event.
154      */
155     function setApprovalForAll(address operator, bool _approved) external;
156 
157     /**
158      * @dev Returns the account approved for `tokenId` token.
159      *
160      * Requirements:
161      *
162      * - `tokenId` must exist.
163      */
164     function getApproved(uint256 tokenId) external view returns (address operator);
165 
166     /**
167      * @dev Returns if the `operator` is allowed to manage all of the assets of `owner`.
168      *
169      * See {setApprovalForAll}
170      */
171     function isApprovedForAll(address owner, address operator) external view returns (bool);
172 }
173 
174 // File: @openzeppelin/contracts/token/ERC721/extensions/IERC721Metadata.sol
175 
176 
177 // OpenZeppelin Contracts v4.4.1 (token/ERC721/extensions/IERC721Metadata.sol)
178 
179 pragma solidity ^0.8.0;
180 
181 
182 /**
183  * @title ERC-721 Non-Fungible Token Standard, optional metadata extension
184  * @dev See https://eips.ethereum.org/EIPS/eip-721
185  */
186 interface IERC721Metadata is IERC721 {
187     /**
188      * @dev Returns the token collection name.
189      */
190     function name() external view returns (string memory);
191 
192     /**
193      * @dev Returns the token collection symbol.
194      */
195     function symbol() external view returns (string memory);
196 
197     /**
198      * @dev Returns the Uniform Resource Identifier (URI) for `tokenId` token.
199      */
200     function tokenURI(uint256 tokenId) external view returns (string memory);
201 }
202 
203 // File: @openzeppelin/contracts/utils/introspection/ERC165.sol
204 
205 
206 // OpenZeppelin Contracts v4.4.1 (utils/introspection/ERC165.sol)
207 
208 pragma solidity ^0.8.0;
209 
210 
211 /**
212  * @dev Implementation of the {IERC165} interface.
213  *
214  * Contracts that want to implement ERC165 should inherit from this contract and override {supportsInterface} to check
215  * for the additional interface id that will be supported. For example:
216  *
217  * ```solidity
218  * function supportsInterface(bytes4 interfaceId) public view virtual override returns (bool) {
219  *     return interfaceId == type(MyInterface).interfaceId || super.supportsInterface(interfaceId);
220  * }
221  * ```
222  *
223  * Alternatively, {ERC165Storage} provides an easier to use but more expensive implementation.
224  */
225 abstract contract ERC165 is IERC165 {
226     /**
227      * @dev See {IERC165-supportsInterface}.
228      */
229     function supportsInterface(bytes4 interfaceId) public view virtual override returns (bool) {
230         return interfaceId == type(IERC165).interfaceId;
231     }
232 }
233 
234 // File: @openzeppelin/contracts/token/ERC721/IERC721Receiver.sol
235 
236 
237 // OpenZeppelin Contracts (last updated v4.6.0) (token/ERC721/IERC721Receiver.sol)
238 
239 pragma solidity ^0.8.0;
240 
241 /**
242  * @title ERC721 token receiver interface
243  * @dev Interface for any contract that wants to support safeTransfers
244  * from ERC721 asset contracts.
245  */
246 interface IERC721Receiver {
247     /**
248      * @dev Whenever an {IERC721} `tokenId` token is transferred to this contract via {IERC721-safeTransferFrom}
249      * by `operator` from `from`, this function is called.
250      *
251      * It must return its Solidity selector to confirm the token transfer.
252      * If any other value is returned or the interface is not implemented by the recipient, the transfer will be reverted.
253      *
254      * The selector can be obtained in Solidity with `IERC721Receiver.onERC721Received.selector`.
255      */
256     function onERC721Received(
257         address operator,
258         address from,
259         uint256 tokenId,
260         bytes calldata data
261     ) external returns (bytes4);
262 }
263 
264 // File: @openzeppelin/contracts/utils/Address.sol
265 
266 
267 // OpenZeppelin Contracts (last updated v4.5.0) (utils/Address.sol)
268 
269 pragma solidity ^0.8.1;
270 
271 /**
272  * @dev Collection of functions related to the address type
273  */
274 library Address {
275     /**
276      * @dev Returns true if `account` is a contract.
277      *
278      * [IMPORTANT]
279      * ====
280      * It is unsafe to assume that an address for which this function returns
281      * false is an externally-owned account (EOA) and not a contract.
282      *
283      * Among others, `isContract` will return false for the following
284      * types of addresses:
285      *
286      *  - an externally-owned account
287      *  - a contract in construction
288      *  - an address where a contract will be created
289      *  - an address where a contract lived, but was destroyed
290      * ====
291      *
292      * [IMPORTANT]
293      * ====
294      * You shouldn't rely on `isContract` to protect against flash loan attacks!
295      *
296      * Preventing calls from contracts is highly discouraged. It breaks composability, breaks support for smart wallets
297      * like Gnosis Safe, and does not provide security since it can be circumvented by calling from a contract
298      * constructor.
299      * ====
300      */
301     function isContract(address account) internal view returns (bool) {
302         // This method relies on extcodesize/address.code.length, which returns 0
303         // for contracts in construction, since the code is only stored at the end
304         // of the constructor execution.
305 
306         return account.code.length > 0;
307     }
308 
309     /**
310      * @dev Replacement for Solidity's `transfer`: sends `amount` wei to
311      * `recipient`, forwarding all available gas and reverting on errors.
312      *
313      * https://eips.ethereum.org/EIPS/eip-1884[EIP1884] increases the gas cost
314      * of certain opcodes, possibly making contracts go over the 2300 gas limit
315      * imposed by `transfer`, making them unable to receive funds via
316      * `transfer`. {sendValue} removes this limitation.
317      *
318      * https://diligence.consensys.net/posts/2019/09/stop-using-soliditys-transfer-now/[Learn more].
319      *
320      * IMPORTANT: because control is transferred to `recipient`, care must be
321      * taken to not create reentrancy vulnerabilities. Consider using
322      * {ReentrancyGuard} or the
323      * https://solidity.readthedocs.io/en/v0.5.11/security-considerations.html#use-the-checks-effects-interactions-pattern[checks-effects-interactions pattern].
324      */
325     function sendValue(address payable recipient, uint256 amount) internal {
326         require(address(this).balance >= amount, "Address: insufficient balance");
327 
328         (bool success, ) = recipient.call{value: amount}("");
329         require(success, "Address: unable to send value, recipient may have reverted");
330     }
331 
332     /**
333      * @dev Performs a Solidity function call using a low level `call`. A
334      * plain `call` is an unsafe replacement for a function call: use this
335      * function instead.
336      *
337      * If `target` reverts with a revert reason, it is bubbled up by this
338      * function (like regular Solidity function calls).
339      *
340      * Returns the raw returned data. To convert to the expected return value,
341      * use https://solidity.readthedocs.io/en/latest/units-and-global-variables.html?highlight=abi.decode#abi-encoding-and-decoding-functions[`abi.decode`].
342      *
343      * Requirements:
344      *
345      * - `target` must be a contract.
346      * - calling `target` with `data` must not revert.
347      *
348      * _Available since v3.1._
349      */
350     function functionCall(address target, bytes memory data) internal returns (bytes memory) {
351         return functionCall(target, data, "Address: low-level call failed");
352     }
353 
354     /**
355      * @dev Same as {xref-Address-functionCall-address-bytes-}[`functionCall`], but with
356      * `errorMessage` as a fallback revert reason when `target` reverts.
357      *
358      * _Available since v3.1._
359      */
360     function functionCall(
361         address target,
362         bytes memory data,
363         string memory errorMessage
364     ) internal returns (bytes memory) {
365         return functionCallWithValue(target, data, 0, errorMessage);
366     }
367 
368     /**
369      * @dev Same as {xref-Address-functionCall-address-bytes-}[`functionCall`],
370      * but also transferring `value` wei to `target`.
371      *
372      * Requirements:
373      *
374      * - the calling contract must have an ETH balance of at least `value`.
375      * - the called Solidity function must be `payable`.
376      *
377      * _Available since v3.1._
378      */
379     function functionCallWithValue(
380         address target,
381         bytes memory data,
382         uint256 value
383     ) internal returns (bytes memory) {
384         return functionCallWithValue(target, data, value, "Address: low-level call with value failed");
385     }
386 
387     /**
388      * @dev Same as {xref-Address-functionCallWithValue-address-bytes-uint256-}[`functionCallWithValue`], but
389      * with `errorMessage` as a fallback revert reason when `target` reverts.
390      *
391      * _Available since v3.1._
392      */
393     function functionCallWithValue(
394         address target,
395         bytes memory data,
396         uint256 value,
397         string memory errorMessage
398     ) internal returns (bytes memory) {
399         require(address(this).balance >= value, "Address: insufficient balance for call");
400         require(isContract(target), "Address: call to non-contract");
401 
402         (bool success, bytes memory returndata) = target.call{value: value}(data);
403         return verifyCallResult(success, returndata, errorMessage);
404     }
405 
406     /**
407      * @dev Same as {xref-Address-functionCall-address-bytes-}[`functionCall`],
408      * but performing a static call.
409      *
410      * _Available since v3.3._
411      */
412     function functionStaticCall(address target, bytes memory data) internal view returns (bytes memory) {
413         return functionStaticCall(target, data, "Address: low-level static call failed");
414     }
415 
416     /**
417      * @dev Same as {xref-Address-functionCall-address-bytes-string-}[`functionCall`],
418      * but performing a static call.
419      *
420      * _Available since v3.3._
421      */
422     function functionStaticCall(
423         address target,
424         bytes memory data,
425         string memory errorMessage
426     ) internal view returns (bytes memory) {
427         require(isContract(target), "Address: static call to non-contract");
428 
429         (bool success, bytes memory returndata) = target.staticcall(data);
430         return verifyCallResult(success, returndata, errorMessage);
431     }
432 
433     /**
434      * @dev Same as {xref-Address-functionCall-address-bytes-}[`functionCall`],
435      * but performing a delegate call.
436      *
437      * _Available since v3.4._
438      */
439     function functionDelegateCall(address target, bytes memory data) internal returns (bytes memory) {
440         return functionDelegateCall(target, data, "Address: low-level delegate call failed");
441     }
442 
443     /**
444      * @dev Same as {xref-Address-functionCall-address-bytes-string-}[`functionCall`],
445      * but performing a delegate call.
446      *
447      * _Available since v3.4._
448      */
449     function functionDelegateCall(
450         address target,
451         bytes memory data,
452         string memory errorMessage
453     ) internal returns (bytes memory) {
454         require(isContract(target), "Address: delegate call to non-contract");
455 
456         (bool success, bytes memory returndata) = target.delegatecall(data);
457         return verifyCallResult(success, returndata, errorMessage);
458     }
459 
460     /**
461      * @dev Tool to verifies that a low level call was successful, and revert if it wasn't, either by bubbling the
462      * revert reason using the provided one.
463      *
464      * _Available since v4.3._
465      */
466     function verifyCallResult(
467         bool success,
468         bytes memory returndata,
469         string memory errorMessage
470     ) internal pure returns (bytes memory) {
471         if (success) {
472             return returndata;
473         } else {
474             // Look for revert reason and bubble it up if present
475             if (returndata.length > 0) {
476                 // The easiest way to bubble the revert reason is using memory via assembly
477 
478                 assembly {
479                     let returndata_size := mload(returndata)
480                     revert(add(32, returndata), returndata_size)
481                 }
482             } else {
483                 revert(errorMessage);
484             }
485         }
486     }
487 }
488 
489 // File: @openzeppelin/contracts/utils/Strings.sol
490 
491 
492 // OpenZeppelin Contracts v4.4.1 (utils/Strings.sol)
493 
494 pragma solidity ^0.8.0;
495 
496 /**
497  * @dev String operations.
498  */
499 library Strings {
500     bytes16 private constant _HEX_SYMBOLS = "0123456789abcdef";
501 
502     /**
503      * @dev Converts a `uint256` to its ASCII `string` decimal representation.
504      */
505     function toString(uint256 value) internal pure returns (string memory) {
506         // Inspired by OraclizeAPI's implementation - MIT licence
507         // https://github.com/oraclize/ethereum-api/blob/b42146b063c7d6ee1358846c198246239e9360e8/oraclizeAPI_0.4.25.sol
508 
509         if (value == 0) {
510             return "0";
511         }
512         uint256 temp = value;
513         uint256 digits;
514         while (temp != 0) {
515             digits++;
516             temp /= 10;
517         }
518         bytes memory buffer = new bytes(digits);
519         while (value != 0) {
520             digits -= 1;
521             buffer[digits] = bytes1(uint8(48 + uint256(value % 10)));
522             value /= 10;
523         }
524         return string(buffer);
525     }
526 
527     /**
528      * @dev Converts a `uint256` to its ASCII `string` hexadecimal representation.
529      */
530     function toHexString(uint256 value) internal pure returns (string memory) {
531         if (value == 0) {
532             return "0x00";
533         }
534         uint256 temp = value;
535         uint256 length = 0;
536         while (temp != 0) {
537             length++;
538             temp >>= 8;
539         }
540         return toHexString(value, length);
541     }
542 
543     /**
544      * @dev Converts a `uint256` to its ASCII `string` hexadecimal representation with fixed length.
545      */
546     function toHexString(uint256 value, uint256 length) internal pure returns (string memory) {
547         bytes memory buffer = new bytes(2 * length + 2);
548         buffer[0] = "0";
549         buffer[1] = "x";
550         for (uint256 i = 2 * length + 1; i > 1; --i) {
551             buffer[i] = _HEX_SYMBOLS[value & 0xf];
552             value >>= 4;
553         }
554         require(value == 0, "Strings: hex length insufficient");
555         return string(buffer);
556     }
557 }
558 
559 // File: @openzeppelin/contracts/utils/Context.sol
560 
561 
562 // OpenZeppelin Contracts v4.4.1 (utils/Context.sol)
563 
564 pragma solidity ^0.8.0;
565 
566 /**
567  * @dev Provides information about the current execution context, including the
568  * sender of the transaction and its data. While these are generally available
569  * via msg.sender and msg.data, they should not be accessed in such a direct
570  * manner, since when dealing with meta-transactions the account sending and
571  * paying for execution may not be the actual sender (as far as an application
572  * is concerned).
573  *
574  * This contract is only required for intermediate, library-like contracts.
575  */
576 abstract contract Context {
577     function _msgSender() internal view virtual returns (address) {
578         return msg.sender;
579     }
580 
581     function _msgData() internal view virtual returns (bytes calldata) {
582         return msg.data;
583     }
584 }
585 
586 // File: @openzeppelin/contracts/token/ERC721/ERC721.sol
587 
588 
589 // OpenZeppelin Contracts (last updated v4.6.0) (token/ERC721/ERC721.sol)
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
689      * by default, can be overridden in child contracts.
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
821         return (spender == owner || isApprovedForAll(owner, spender) || getApproved(tokenId) == spender);
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
1113 // File: contracts/interfaces/ILayerZeroReceiver.sol
1114 
1115 
1116 
1117 pragma solidity >=0.5.0;
1118 
1119 interface ILayerZeroReceiver {
1120     // @notice LayerZero endpoint will invoke this function to deliver the message on the destination
1121     // @param _srcChainId - the source endpoint identifier
1122     // @param _srcAddress - the source sending contract address from the source chain
1123     // @param _nonce - the ordered message nonce
1124     // @param _payload - the signed payload is the UA bytes has encoded to be sent
1125     function lzReceive(uint16 _srcChainId, bytes calldata _srcAddress, uint64 _nonce, bytes calldata _payload) external;
1126 }
1127 // File: contracts/interfaces/ILayerZeroUserApplicationConfig.sol
1128 
1129 
1130 
1131 pragma solidity >=0.5.0;
1132 
1133 interface ILayerZeroUserApplicationConfig {
1134     // @notice set the configuration of the LayerZero messaging library of the specified version
1135     // @param _version - messaging library version
1136     // @param _chainId - the chainId for the pending config change
1137     // @param _configType - type of configuration. every messaging library has its own convention.
1138     // @param _config - configuration in the bytes. can encode arbitrary content.
1139     function setConfig(uint16 _version, uint16 _chainId, uint _configType, bytes calldata _config) external;
1140 
1141     // @notice set the send() LayerZero messaging library version to _version
1142     // @param _version - new messaging library version
1143     function setSendVersion(uint16 _version) external;
1144 
1145     // @notice set the lzReceive() LayerZero messaging library version to _version
1146     // @param _version - new messaging library version
1147     function setReceiveVersion(uint16 _version) external;
1148 
1149     // @notice Only when the UA needs to resume the message flow in blocking mode and clear the stored payload
1150     // @param _srcChainId - the chainId of the source chain
1151     // @param _srcAddress - the contract address of the source contract at the source chain
1152     function forceResumeReceive(uint16 _srcChainId, bytes calldata _srcAddress) external;
1153 }
1154 
1155 // File: contracts/interfaces/ILayerZeroEndpoint.sol
1156 
1157 
1158 
1159 pragma solidity >=0.5.0;
1160 
1161 
1162 interface ILayerZeroEndpoint is ILayerZeroUserApplicationConfig {
1163     // @notice send a LayerZero message to the specified address at a LayerZero endpoint.
1164     // @param _dstChainId - the destination chain identifier
1165     // @param _destination - the address on destination chain (in bytes). address length/format may vary by chains
1166     // @param _payload - a custom bytes payload to send to the destination contract
1167     // @param _refundAddress - if the source transaction is cheaper than the amount of value passed, refund the additional amount to this address
1168     // @param _zroPaymentAddress - the address of the ZRO token holder who would pay for the transaction
1169     // @param _adapterParams - parameters for custom functionality. e.g. receive airdropped native gas from the relayer on destination
1170     function send(uint16 _dstChainId, bytes calldata _destination, bytes calldata _payload, address payable _refundAddress, address _zroPaymentAddress, bytes calldata _adapterParams) external payable;
1171 
1172     // @notice used by the messaging library to publish verified payload
1173     // @param _srcChainId - the source chain identifier
1174     // @param _srcAddress - the source contract (as bytes) at the source chain
1175     // @param _dstAddress - the address on destination chain
1176     // @param _nonce - the unbound message ordering nonce
1177     // @param _gasLimit - the gas limit for external contract execution
1178     // @param _payload - verified payload to send to the destination contract
1179     function receivePayload(uint16 _srcChainId, bytes calldata _srcAddress, address _dstAddress, uint64 _nonce, uint _gasLimit, bytes calldata _payload) external;
1180 
1181     // @notice get the inboundNonce of a receiver from a source chain which could be EVM or non-EVM chain
1182     // @param _srcChainId - the source chain identifier
1183     // @param _srcAddress - the source chain contract address
1184     function getInboundNonce(uint16 _srcChainId, bytes calldata _srcAddress) external view returns (uint64);
1185 
1186     // @notice get the outboundNonce from this source chain which, consequently, is always an EVM
1187     // @param _srcAddress - the source chain contract address
1188     function getOutboundNonce(uint16 _dstChainId, address _srcAddress) external view returns (uint64);
1189 
1190     // @notice gets a quote in source native gas, for the amount that send() requires to pay for message delivery
1191     // @param _dstChainId - the destination chain identifier
1192     // @param _userApplication - the user app address on this EVM chain
1193     // @param _payload - the custom message to send over LayerZero
1194     // @param _payInZRO - if false, user app pays the protocol fee in native token
1195     // @param _adapterParam - parameters for the adapter service, e.g. send some dust native token to dstChain
1196     function estimateFees(uint16 _dstChainId, address _userApplication, bytes calldata _payload, bool _payInZRO, bytes calldata _adapterParam) external view returns (uint nativeFee, uint zroFee);
1197 
1198     // @notice get this Endpoint's immutable source identifier
1199     function getChainId() external view returns (uint16);
1200 
1201     // @notice the interface to retry failed message on this Endpoint destination
1202     // @param _srcChainId - the source chain identifier
1203     // @param _srcAddress - the source chain contract address
1204     // @param _payload - the payload to be retried
1205     function retryPayload(uint16 _srcChainId, bytes calldata _srcAddress, bytes calldata _payload) external;
1206 
1207     // @notice query if any STORED payload (message blocking) at the endpoint.
1208     // @param _srcChainId - the source chain identifier
1209     // @param _srcAddress - the source chain contract address
1210     function hasStoredPayload(uint16 _srcChainId, bytes calldata _srcAddress) external view returns (bool);
1211 
1212     // @notice query if the _libraryAddress is valid for sending msgs.
1213     // @param _userApplication - the user app address on this EVM chain
1214     function getSendLibraryAddress(address _userApplication) external view returns (address);
1215 
1216     // @notice query if the _libraryAddress is valid for receiving msgs.
1217     // @param _userApplication - the user app address on this EVM chain
1218     function getReceiveLibraryAddress(address _userApplication) external view returns (address);
1219 
1220     // @notice query if the non-reentrancy guard for send() is on
1221     // @return true if the guard is on. false otherwise
1222     function isSendingPayload() external view returns (bool);
1223 
1224     // @notice query if the non-reentrancy guard for receive() is on
1225     // @return true if the guard is on. false otherwise
1226     function isReceivingPayload() external view returns (bool);
1227 
1228     // @notice get the configuration of the LayerZero messaging library of the specified version
1229     // @param _version - messaging library version
1230     // @param _chainId - the chainId for the pending config change
1231     // @param _userApplication - the contract address of the user application
1232     // @param _configType - type of configuration. every messaging library has its own convention.
1233     function getConfig(uint16 _version, uint16 _chainId, address _userApplication, uint _configType) external view returns (bytes memory);
1234 
1235     // @notice get the send() LayerZero messaging library version
1236     // @param _userApplication - the contract address of the user application
1237     function getSendVersion(address _userApplication) external view returns (uint16);
1238 
1239     // @notice get the lzReceive() LayerZero messaging library version
1240     // @param _userApplication - the contract address of the user application
1241     function getReceiveVersion(address _userApplication) external view returns (uint16);
1242 }
1243 
1244 // File: contracts/NonblockingReceiver.sol
1245 
1246 
1247 
1248 
1249 
1250 
1251 pragma solidity ^0.8.6;
1252 
1253 abstract contract NonblockingReceiver is Ownable, ILayerZeroReceiver {
1254     ILayerZeroEndpoint internal endpoint;
1255 
1256     struct FailedMessages {
1257         uint256 payloadLength;
1258         bytes32 payloadHash;
1259     }
1260 
1261     mapping(uint16 => mapping(bytes => mapping(uint256 => FailedMessages)))
1262         public failedMessages;
1263     mapping(uint16 => bytes) public trustedRemoteLookup;
1264 
1265     event MessageFailed(
1266         uint16 _srcChainId,
1267         bytes _srcAddress,
1268         uint64 _nonce,
1269         bytes _payload
1270     );
1271 
1272     function lzReceive(
1273         uint16 _srcChainId,
1274         bytes memory _srcAddress,
1275         uint64 _nonce,
1276         bytes memory _payload
1277     ) external override {
1278         require(msg.sender == address(endpoint)); // boilerplate! lzReceive must be called by the endpoint for security
1279         require(
1280             _srcAddress.length == trustedRemoteLookup[_srcChainId].length &&
1281                 keccak256(_srcAddress) ==
1282                 keccak256(trustedRemoteLookup[_srcChainId]),
1283             "NonblockingReceiver: invalid source sending contract"
1284         );
1285 
1286         // try-catch all errors/exceptions
1287         // having failed messages does not block messages passing
1288         try this.onLzReceive(_srcChainId, _srcAddress, _nonce, _payload) {
1289             // do nothing
1290         } catch {
1291             // error / exception
1292             failedMessages[_srcChainId][_srcAddress][_nonce] = FailedMessages(
1293                 _payload.length,
1294                 keccak256(_payload)
1295             );
1296             emit MessageFailed(_srcChainId, _srcAddress, _nonce, _payload);
1297         }
1298     }
1299 
1300     function onLzReceive(
1301         uint16 _srcChainId,
1302         bytes memory _srcAddress,
1303         uint64 _nonce,
1304         bytes memory _payload
1305     ) public {
1306         // only internal transaction
1307         require(
1308             msg.sender == address(this),
1309             "NonblockingReceiver: caller must be Bridge."
1310         );
1311 
1312         // handle incoming message
1313         _LzReceive(_srcChainId, _srcAddress, _nonce, _payload);
1314     }
1315 
1316     // abstract function
1317     function _LzReceive(
1318         uint16 _srcChainId,
1319         bytes memory _srcAddress,
1320         uint64 _nonce,
1321         bytes memory _payload
1322     ) internal virtual;
1323 
1324     function _lzSend(
1325         uint16 _dstChainId,
1326         bytes memory _payload,
1327         address payable _refundAddress,
1328         address _zroPaymentAddress,
1329         bytes memory _txParam
1330     ) internal {
1331         endpoint.send{value: msg.value}(
1332             _dstChainId,
1333             trustedRemoteLookup[_dstChainId],
1334             _payload,
1335             _refundAddress,
1336             _zroPaymentAddress,
1337             _txParam
1338         );
1339     }
1340 
1341     function retryMessage(
1342         uint16 _srcChainId,
1343         bytes memory _srcAddress,
1344         uint64 _nonce,
1345         bytes calldata _payload
1346     ) external payable {
1347         // assert there is message to retry
1348         FailedMessages storage failedMsg = failedMessages[_srcChainId][
1349             _srcAddress
1350         ][_nonce];
1351         require(
1352             failedMsg.payloadHash != bytes32(0),
1353             "NonblockingReceiver: no stored message"
1354         );
1355         require(
1356             _payload.length == failedMsg.payloadLength &&
1357                 keccak256(_payload) == failedMsg.payloadHash,
1358             "LayerZero: invalid payload"
1359         );
1360         // clear the stored message
1361         failedMsg.payloadLength = 0;
1362         failedMsg.payloadHash = bytes32(0);
1363         // execute the message. revert if it fails again
1364         this.onLzReceive(_srcChainId, _srcAddress, _nonce, _payload);
1365     }
1366 
1367     function setTrustedRemote(uint16 _chainId, bytes calldata _trustedRemote)
1368         external
1369         onlyOwner
1370     {
1371         trustedRemoteLookup[_chainId] = _trustedRemote;
1372     }
1373 }
1374 // File: contracts/Flekos.sol
1375 
1376 
1377 
1378 /*
1379 ................................................................................
1380 .........&&&&&&.................................................................
1381 .........&&&...............................&&&&&&....................&&&&&&.....
1382 ......&&&&&&&&&...&&&&&......&&&&&&........&&&.......................&&&........
1383 ......&&&&&&   ...&&.........&&&...........&&&...   .................&&&........
1384 ......   &&&......&&.........&&&&&&   .....&&&&&&......&&&&&%%%......&&&........
1385 ......   &&&......&&.........&&&&&&   .....&&&&&&......&&&&&%%%......&&&........
1386 .........&&&......&&.........&&&...........   &&&......&&&..&&&......   ........
1387 .........%%%......  &&&%%%...&&&&&&%%%..%%%&&&...%%%...&&&&&   ...%%%&&&........
1388 ................................................................................
1389 An NFT collection minted across different chains.
1390 */
1391 
1392 
1393 
1394 
1395 
1396 
1397 
1398 
1399 
1400 
1401 
1402 
1403 pragma solidity ^0.8.7;
1404 
1405 contract flekos is Ownable, ERC721, NonblockingReceiver {
1406     using Strings for uint256;
1407 
1408     address public _owner;
1409     string private baseURI;
1410     string private fatherURI;
1411     uint256 nextTokenId = 6400;
1412     uint256 MAX_MINT = 10000;
1413 
1414     uint256 gasForDestinationLzReceive = 350000;
1415 
1416     constructor(string memory baseURI_, string memory fatherURI_, address _layerZeroEndpoint)
1417         ERC721("Flekos", "FLK")
1418     {
1419         _owner = msg.sender;
1420         endpoint = ILayerZeroEndpoint(_layerZeroEndpoint);
1421         baseURI = baseURI_;
1422         fatherURI = fatherURI_;
1423     }
1424 
1425     // mint function
1426     // you can choose to mint 1 or 2
1427     // mint is free, but payments are accepted
1428     function mint(uint8 numTokens) external payable {
1429         require(numTokens < 3, "Flekos contract: Max 2 NFTs per transaction");
1430         require(
1431             nextTokenId + numTokens <= MAX_MINT,
1432             "Flekos contract: Mint exceeds supply"
1433         );
1434         _safeMint(msg.sender, ++nextTokenId);
1435         if (numTokens == 2) {
1436             _safeMint(msg.sender, ++nextTokenId);
1437         }
1438     }
1439 
1440     // This function transfers the nft from your address on the
1441     // source chain to the same address on the destination chain
1442     function traverseChains(uint16 _chainId, uint256 tokenId) public payable {
1443         require(
1444             msg.sender == ownerOf(tokenId),
1445             "You must own the token to traverse"
1446         );
1447         require(
1448             trustedRemoteLookup[_chainId].length > 0,
1449             "This chain is currently unavailable for travel"
1450         );
1451 
1452         // burn NFT, eliminating it from circulation on src chain
1453         _burn(tokenId);
1454 
1455         // abi.encode() the payload with the values to send
1456         bytes memory payload = abi.encode(msg.sender, tokenId);
1457 
1458         // encode adapterParams to specify more gas for the destination
1459         uint16 version = 1;
1460         bytes memory adapterParams = abi.encodePacked(
1461             version,
1462             gasForDestinationLzReceive
1463         );
1464 
1465         // get the fees we need to pay to LayerZero + Relayer to cover message delivery
1466         // you will be refunded for extra gas paid
1467         (uint256 messageFee, ) = endpoint.estimateFees(
1468             _chainId,
1469             address(this),
1470             payload,
1471             false,
1472             adapterParams
1473         );
1474 
1475         require(
1476             msg.value >= messageFee,
1477             "Flekos contract: msg.value not enough to cover messageFee. Send gas for message fees"
1478         );
1479 
1480         endpoint.send{value: msg.value}(
1481             _chainId, // destination chainId
1482             trustedRemoteLookup[_chainId], // destination address of nft contract
1483             payload, // abi.encoded()'ed bytes
1484             payable(msg.sender), // refund address
1485             address(0x0), // 'zroPaymentAddress' unused for this
1486             adapterParams // txParameters
1487         );
1488     }
1489 
1490     // ERC721 tokenURI function override to allow a different URI for tokenId 0
1491     function tokenURI(uint256 tokenId) public view override returns (string memory) {
1492         require(_exists(tokenId), "ERC721Metadata: URI query for nonexistent token");
1493 
1494         string memory bURI;
1495         if (tokenId == 0) { bURI = _fatherURI(); }
1496         else { bURI = _baseURI(); }
1497         return bytes(bURI).length > 0 ? string(abi.encodePacked(bURI, tokenId.toString())) : "";
1498     }
1499 
1500     function setBaseURI(string memory URI) external onlyOwner {
1501         baseURI = URI;
1502     }
1503 
1504     // Set URI for father fleko (with tokenId = 0)
1505     function setFatherURI(string memory URI) external onlyOwner {
1506         fatherURI = URI;
1507     }
1508 
1509     // You can claim the ownership of the contract if you are the owner of the fleko father.
1510     function claimOwnership() external {
1511         require(msg.sender == ownerOf(0), "Flekos contract: You have to be the owner of the fleko father");
1512         _transferOwnership(msg.sender);
1513     }
1514 
1515     function donate() external payable {
1516         // thank you! <3
1517     }
1518 
1519     // This allows the devs to receive kind donations
1520     function withdraw(uint256 amt) external onlyOwner {
1521         (bool sent, ) = payable(_owner).call{value: amt}("");
1522         require(sent, "Flekos contract: Failed to withdraw");
1523     }
1524 
1525     // Just in case this fixed variable limits us from future integrations
1526     function setGasForDestinationLzReceive(uint256 newVal) external onlyOwner {
1527         gasForDestinationLzReceive = newVal;
1528     }
1529 
1530     // ------------------
1531     // Internal Functions
1532     // ------------------
1533 
1534     function _LzReceive(
1535         uint16 _srcChainId,
1536         bytes memory _srcAddress,
1537         uint64 _nonce,
1538         bytes memory _payload
1539     ) internal override {
1540         // decode
1541         (address toAddr, uint256 tokenId) = abi.decode(
1542             _payload,
1543             (address, uint256)
1544         );
1545 
1546         // mint the tokens back into existence on destination chain
1547         _safeMint(toAddr, tokenId);
1548     }
1549 
1550     function _baseURI() internal view override returns (string memory) {
1551         return baseURI;
1552     }
1553 
1554     function _fatherURI() internal view returns (string memory) {
1555         return fatherURI;
1556     }
1557 }