1 // File: @openzeppelin/contracts/utils/Strings.sol
2 
3 
4 // OpenZeppelin Contracts v4.4.1 (utils/Strings.sol)
5 
6 pragma solidity ^0.8.0;
7 
8 /**
9  * @dev String operations.
10  */
11 library Strings {
12     bytes16 private constant _HEX_SYMBOLS = "0123456789abcdef";
13 
14     /**
15      * @dev Converts a `uint256` to its ASCII `string` decimal representation.
16      */
17     function toString(uint256 value) internal pure returns (string memory) {
18         // Inspired by OraclizeAPI's implementation - MIT licence
19         // https://github.com/oraclize/ethereum-api/blob/b42146b063c7d6ee1358846c198246239e9360e8/oraclizeAPI_0.4.25.sol
20 
21         if (value == 0) {
22             return "0";
23         }
24         uint256 temp = value;
25         uint256 digits;
26         while (temp != 0) {
27             digits++;
28             temp /= 10;
29         }
30         bytes memory buffer = new bytes(digits);
31         while (value != 0) {
32             digits -= 1;
33             buffer[digits] = bytes1(uint8(48 + uint256(value % 10)));
34             value /= 10;
35         }
36         return string(buffer);
37     }
38 
39     /**
40      * @dev Converts a `uint256` to its ASCII `string` hexadecimal representation.
41      */
42     function toHexString(uint256 value) internal pure returns (string memory) {
43         if (value == 0) {
44             return "0x00";
45         }
46         uint256 temp = value;
47         uint256 length = 0;
48         while (temp != 0) {
49             length++;
50             temp >>= 8;
51         }
52         return toHexString(value, length);
53     }
54 
55     /**
56      * @dev Converts a `uint256` to its ASCII `string` hexadecimal representation with fixed length.
57      */
58     function toHexString(uint256 value, uint256 length) internal pure returns (string memory) {
59         bytes memory buffer = new bytes(2 * length + 2);
60         buffer[0] = "0";
61         buffer[1] = "x";
62         for (uint256 i = 2 * length + 1; i > 1; --i) {
63             buffer[i] = _HEX_SYMBOLS[value & 0xf];
64             value >>= 4;
65         }
66         require(value == 0, "Strings: hex length insufficient");
67         return string(buffer);
68     }
69 }
70 
71 // File: @openzeppelin/contracts/utils/Address.sol
72 
73 
74 // OpenZeppelin Contracts (last updated v4.5.0) (utils/Address.sol)
75 
76 pragma solidity ^0.8.1;
77 
78 /**
79  * @dev Collection of functions related to the address type
80  */
81 library Address {
82     /**
83      * @dev Returns true if `account` is a contract.
84      *
85      * [IMPORTANT]
86      * ====
87      * It is unsafe to assume that an address for which this function returns
88      * false is an externally-owned account (EOA) and not a contract.
89      *
90      * Among others, `isContract` will return false for the following
91      * types of addresses:
92      *
93      *  - an externally-owned account
94      *  - a contract in construction
95      *  - an address where a contract will be created
96      *  - an address where a contract lived, but was destroyed
97      * ====
98      *
99      * [IMPORTANT]
100      * ====
101      * You shouldn't rely on `isContract` to protect against flash loan attacks!
102      *
103      * Preventing calls from contracts is highly discouraged. It breaks composability, breaks support for smart wallets
104      * like Gnosis Safe, and does not provide security since it can be circumvented by calling from a contract
105      * constructor.
106      * ====
107      */
108     function isContract(address account) internal view returns (bool) {
109         // This method relies on extcodesize/address.code.length, which returns 0
110         // for contracts in construction, since the code is only stored at the end
111         // of the constructor execution.
112 
113         return account.code.length > 0;
114     }
115 
116     /**
117      * @dev Replacement for Solidity's `transfer`: sends `amount` wei to
118      * `recipient`, forwarding all available gas and reverting on errors.
119      *
120      * https://eips.ethereum.org/EIPS/eip-1884[EIP1884] increases the gas cost
121      * of certain opcodes, possibly making contracts go over the 2300 gas limit
122      * imposed by `transfer`, making them unable to receive funds via
123      * `transfer`. {sendValue} removes this limitation.
124      *
125      * https://diligence.consensys.net/posts/2019/09/stop-using-soliditys-transfer-now/[Learn more].
126      *
127      * IMPORTANT: because control is transferred to `recipient`, care must be
128      * taken to not create reentrancy vulnerabilities. Consider using
129      * {ReentrancyGuard} or the
130      * https://solidity.readthedocs.io/en/v0.5.11/security-considerations.html#use-the-checks-effects-interactions-pattern[checks-effects-interactions pattern].
131      */
132     function sendValue(address payable recipient, uint256 amount) internal {
133         require(address(this).balance >= amount, "Address: insufficient balance");
134 
135         (bool success, ) = recipient.call{value: amount}("");
136         require(success, "Address: unable to send value, recipient may have reverted");
137     }
138 
139     /**
140      * @dev Performs a Solidity function call using a low level `call`. A
141      * plain `call` is an unsafe replacement for a function call: use this
142      * function instead.
143      *
144      * If `target` reverts with a revert reason, it is bubbled up by this
145      * function (like regular Solidity function calls).
146      *
147      * Returns the raw returned data. To convert to the expected return value,
148      * use https://solidity.readthedocs.io/en/latest/units-and-global-variables.html?highlight=abi.decode#abi-encoding-and-decoding-functions[`abi.decode`].
149      *
150      * Requirements:
151      *
152      * - `target` must be a contract.
153      * - calling `target` with `data` must not revert.
154      *
155      * _Available since v3.1._
156      */
157     function functionCall(address target, bytes memory data) internal returns (bytes memory) {
158         return functionCall(target, data, "Address: low-level call failed");
159     }
160 
161     /**
162      * @dev Same as {xref-Address-functionCall-address-bytes-}[`functionCall`], but with
163      * `errorMessage` as a fallback revert reason when `target` reverts.
164      *
165      * _Available since v3.1._
166      */
167     function functionCall(
168         address target,
169         bytes memory data,
170         string memory errorMessage
171     ) internal returns (bytes memory) {
172         return functionCallWithValue(target, data, 0, errorMessage);
173     }
174 
175     /**
176      * @dev Same as {xref-Address-functionCall-address-bytes-}[`functionCall`],
177      * but also transferring `value` wei to `target`.
178      *
179      * Requirements:
180      *
181      * - the calling contract must have an ETH balance of at least `value`.
182      * - the called Solidity function must be `payable`.
183      *
184      * _Available since v3.1._
185      */
186     function functionCallWithValue(
187         address target,
188         bytes memory data,
189         uint256 value
190     ) internal returns (bytes memory) {
191         return functionCallWithValue(target, data, value, "Address: low-level call with value failed");
192     }
193 
194     /**
195      * @dev Same as {xref-Address-functionCallWithValue-address-bytes-uint256-}[`functionCallWithValue`], but
196      * with `errorMessage` as a fallback revert reason when `target` reverts.
197      *
198      * _Available since v3.1._
199      */
200     function functionCallWithValue(
201         address target,
202         bytes memory data,
203         uint256 value,
204         string memory errorMessage
205     ) internal returns (bytes memory) {
206         require(address(this).balance >= value, "Address: insufficient balance for call");
207         require(isContract(target), "Address: call to non-contract");
208 
209         (bool success, bytes memory returndata) = target.call{value: value}(data);
210         return verifyCallResult(success, returndata, errorMessage);
211     }
212 
213     /**
214      * @dev Same as {xref-Address-functionCall-address-bytes-}[`functionCall`],
215      * but performing a static call.
216      *
217      * _Available since v3.3._
218      */
219     function functionStaticCall(address target, bytes memory data) internal view returns (bytes memory) {
220         return functionStaticCall(target, data, "Address: low-level static call failed");
221     }
222 
223     /**
224      * @dev Same as {xref-Address-functionCall-address-bytes-string-}[`functionCall`],
225      * but performing a static call.
226      *
227      * _Available since v3.3._
228      */
229     function functionStaticCall(
230         address target,
231         bytes memory data,
232         string memory errorMessage
233     ) internal view returns (bytes memory) {
234         require(isContract(target), "Address: static call to non-contract");
235 
236         (bool success, bytes memory returndata) = target.staticcall(data);
237         return verifyCallResult(success, returndata, errorMessage);
238     }
239 
240     /**
241      * @dev Same as {xref-Address-functionCall-address-bytes-}[`functionCall`],
242      * but performing a delegate call.
243      *
244      * _Available since v3.4._
245      */
246     function functionDelegateCall(address target, bytes memory data) internal returns (bytes memory) {
247         return functionDelegateCall(target, data, "Address: low-level delegate call failed");
248     }
249 
250     /**
251      * @dev Same as {xref-Address-functionCall-address-bytes-string-}[`functionCall`],
252      * but performing a delegate call.
253      *
254      * _Available since v3.4._
255      */
256     function functionDelegateCall(
257         address target,
258         bytes memory data,
259         string memory errorMessage
260     ) internal returns (bytes memory) {
261         require(isContract(target), "Address: delegate call to non-contract");
262 
263         (bool success, bytes memory returndata) = target.delegatecall(data);
264         return verifyCallResult(success, returndata, errorMessage);
265     }
266 
267     /**
268      * @dev Tool to verifies that a low level call was successful, and revert if it wasn't, either by bubbling the
269      * revert reason using the provided one.
270      *
271      * _Available since v4.3._
272      */
273     function verifyCallResult(
274         bool success,
275         bytes memory returndata,
276         string memory errorMessage
277     ) internal pure returns (bytes memory) {
278         if (success) {
279             return returndata;
280         } else {
281             // Look for revert reason and bubble it up if present
282             if (returndata.length > 0) {
283                 // The easiest way to bubble the revert reason is using memory via assembly
284 
285                 assembly {
286                     let returndata_size := mload(returndata)
287                     revert(add(32, returndata), returndata_size)
288                 }
289             } else {
290                 revert(errorMessage);
291             }
292         }
293     }
294 }
295 
296 // File: @openzeppelin/contracts/token/ERC721/IERC721Receiver.sol
297 
298 
299 // OpenZeppelin Contracts (last updated v4.6.0) (token/ERC721/IERC721Receiver.sol)
300 
301 pragma solidity ^0.8.0;
302 
303 /**
304  * @title ERC721 token receiver interface
305  * @dev Interface for any contract that wants to support safeTransfers
306  * from ERC721 asset contracts.
307  */
308 interface IERC721Receiver {
309     /**
310      * @dev Whenever an {IERC721} `tokenId` token is transferred to this contract via {IERC721-safeTransferFrom}
311      * by `operator` from `from`, this function is called.
312      *
313      * It must return its Solidity selector to confirm the token transfer.
314      * If any other value is returned or the interface is not implemented by the recipient, the transfer will be reverted.
315      *
316      * The selector can be obtained in Solidity with `IERC721Receiver.onERC721Received.selector`.
317      */
318     function onERC721Received(
319         address operator,
320         address from,
321         uint256 tokenId,
322         bytes calldata data
323     ) external returns (bytes4);
324 }
325 
326 // File: @openzeppelin/contracts/utils/introspection/IERC165.sol
327 
328 
329 // OpenZeppelin Contracts v4.4.1 (utils/introspection/IERC165.sol)
330 
331 pragma solidity ^0.8.0;
332 
333 /**
334  * @dev Interface of the ERC165 standard, as defined in the
335  * https://eips.ethereum.org/EIPS/eip-165[EIP].
336  *
337  * Implementers can declare support of contract interfaces, which can then be
338  * queried by others ({ERC165Checker}).
339  *
340  * For an implementation, see {ERC165}.
341  */
342 interface IERC165 {
343     /**
344      * @dev Returns true if this contract implements the interface defined by
345      * `interfaceId`. See the corresponding
346      * https://eips.ethereum.org/EIPS/eip-165#how-interfaces-are-identified[EIP section]
347      * to learn more about how these ids are created.
348      *
349      * This function call must use less than 30 000 gas.
350      */
351     function supportsInterface(bytes4 interfaceId) external view returns (bool);
352 }
353 
354 // File: @openzeppelin/contracts/utils/introspection/ERC165.sol
355 
356 
357 // OpenZeppelin Contracts v4.4.1 (utils/introspection/ERC165.sol)
358 
359 pragma solidity ^0.8.0;
360 
361 
362 /**
363  * @dev Implementation of the {IERC165} interface.
364  *
365  * Contracts that want to implement ERC165 should inherit from this contract and override {supportsInterface} to check
366  * for the additional interface id that will be supported. For example:
367  *
368  * ```solidity
369  * function supportsInterface(bytes4 interfaceId) public view virtual override returns (bool) {
370  *     return interfaceId == type(MyInterface).interfaceId || super.supportsInterface(interfaceId);
371  * }
372  * ```
373  *
374  * Alternatively, {ERC165Storage} provides an easier to use but more expensive implementation.
375  */
376 abstract contract ERC165 is IERC165 {
377     /**
378      * @dev See {IERC165-supportsInterface}.
379      */
380     function supportsInterface(bytes4 interfaceId) public view virtual override returns (bool) {
381         return interfaceId == type(IERC165).interfaceId;
382     }
383 }
384 
385 // File: @openzeppelin/contracts/token/ERC721/IERC721.sol
386 
387 
388 // OpenZeppelin Contracts (last updated v4.6.0) (token/ERC721/IERC721.sol)
389 
390 pragma solidity ^0.8.0;
391 
392 
393 /**
394  * @dev Required interface of an ERC721 compliant contract.
395  */
396 interface IERC721 is IERC165 {
397     /**
398      * @dev Emitted when `tokenId` token is transferred from `from` to `to`.
399      */
400     event Transfer(address indexed from, address indexed to, uint256 indexed tokenId);
401 
402     /**
403      * @dev Emitted when `owner` enables `approved` to manage the `tokenId` token.
404      */
405     event Approval(address indexed owner, address indexed approved, uint256 indexed tokenId);
406 
407     /**
408      * @dev Emitted when `owner` enables or disables (`approved`) `operator` to manage all of its assets.
409      */
410     event ApprovalForAll(address indexed owner, address indexed operator, bool approved);
411 
412     /**
413      * @dev Returns the number of tokens in ``owner``'s account.
414      */
415     function balanceOf(address owner) external view returns (uint256 balance);
416 
417     /**
418      * @dev Returns the owner of the `tokenId` token.
419      *
420      * Requirements:
421      *
422      * - `tokenId` must exist.
423      */
424     function ownerOf(uint256 tokenId) external view returns (address owner);
425 
426     /**
427      * @dev Safely transfers `tokenId` token from `from` to `to`.
428      *
429      * Requirements:
430      *
431      * - `from` cannot be the zero address.
432      * - `to` cannot be the zero address.
433      * - `tokenId` token must exist and be owned by `from`.
434      * - If the caller is not `from`, it must be approved to move this token by either {approve} or {setApprovalForAll}.
435      * - If `to` refers to a smart contract, it must implement {IERC721Receiver-onERC721Received}, which is called upon a safe transfer.
436      *
437      * Emits a {Transfer} event.
438      */
439     function safeTransferFrom(
440         address from,
441         address to,
442         uint256 tokenId,
443         bytes calldata data
444     ) external;
445 
446     /**
447      * @dev Safely transfers `tokenId` token from `from` to `to`, checking first that contract recipients
448      * are aware of the ERC721 protocol to prevent tokens from being forever locked.
449      *
450      * Requirements:
451      *
452      * - `from` cannot be the zero address.
453      * - `to` cannot be the zero address.
454      * - `tokenId` token must exist and be owned by `from`.
455      * - If the caller is not `from`, it must be have been allowed to move this token by either {approve} or {setApprovalForAll}.
456      * - If `to` refers to a smart contract, it must implement {IERC721Receiver-onERC721Received}, which is called upon a safe transfer.
457      *
458      * Emits a {Transfer} event.
459      */
460     function safeTransferFrom(
461         address from,
462         address to,
463         uint256 tokenId
464     ) external;
465 
466     /**
467      * @dev Transfers `tokenId` token from `from` to `to`.
468      *
469      * WARNING: Usage of this method is discouraged, use {safeTransferFrom} whenever possible.
470      *
471      * Requirements:
472      *
473      * - `from` cannot be the zero address.
474      * - `to` cannot be the zero address.
475      * - `tokenId` token must be owned by `from`.
476      * - If the caller is not `from`, it must be approved to move this token by either {approve} or {setApprovalForAll}.
477      *
478      * Emits a {Transfer} event.
479      */
480     function transferFrom(
481         address from,
482         address to,
483         uint256 tokenId
484     ) external;
485 
486     /**
487      * @dev Gives permission to `to` to transfer `tokenId` token to another account.
488      * The approval is cleared when the token is transferred.
489      *
490      * Only a single account can be approved at a time, so approving the zero address clears previous approvals.
491      *
492      * Requirements:
493      *
494      * - The caller must own the token or be an approved operator.
495      * - `tokenId` must exist.
496      *
497      * Emits an {Approval} event.
498      */
499     function approve(address to, uint256 tokenId) external;
500 
501     /**
502      * @dev Approve or remove `operator` as an operator for the caller.
503      * Operators can call {transferFrom} or {safeTransferFrom} for any token owned by the caller.
504      *
505      * Requirements:
506      *
507      * - The `operator` cannot be the caller.
508      *
509      * Emits an {ApprovalForAll} event.
510      */
511     function setApprovalForAll(address operator, bool _approved) external;
512 
513     /**
514      * @dev Returns the account approved for `tokenId` token.
515      *
516      * Requirements:
517      *
518      * - `tokenId` must exist.
519      */
520     function getApproved(uint256 tokenId) external view returns (address operator);
521 
522     /**
523      * @dev Returns if the `operator` is allowed to manage all of the assets of `owner`.
524      *
525      * See {setApprovalForAll}
526      */
527     function isApprovedForAll(address owner, address operator) external view returns (bool);
528 }
529 
530 // File: @openzeppelin/contracts/token/ERC721/extensions/IERC721Metadata.sol
531 
532 
533 // OpenZeppelin Contracts v4.4.1 (token/ERC721/extensions/IERC721Metadata.sol)
534 
535 pragma solidity ^0.8.0;
536 
537 
538 /**
539  * @title ERC-721 Non-Fungible Token Standard, optional metadata extension
540  * @dev See https://eips.ethereum.org/EIPS/eip-721
541  */
542 interface IERC721Metadata is IERC721 {
543     /**
544      * @dev Returns the token collection name.
545      */
546     function name() external view returns (string memory);
547 
548     /**
549      * @dev Returns the token collection symbol.
550      */
551     function symbol() external view returns (string memory);
552 
553     /**
554      * @dev Returns the Uniform Resource Identifier (URI) for `tokenId` token.
555      */
556     function tokenURI(uint256 tokenId) external view returns (string memory);
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
1113 // File: erc721a/contracts/IERC721A.sol
1114 
1115 
1116 // ERC721A Contracts v4.1.0
1117 // Creator: Chiru Labs
1118 
1119 pragma solidity ^0.8.4;
1120 
1121 /**
1122  * @dev Interface of an ERC721A compliant contract.
1123  */
1124 interface IERC721A {
1125     /**
1126      * The caller must own the token or be an approved operator.
1127      */
1128     error ApprovalCallerNotOwnerNorApproved();
1129 
1130     /**
1131      * The token does not exist.
1132      */
1133     error ApprovalQueryForNonexistentToken();
1134 
1135     /**
1136      * The caller cannot approve to their own address.
1137      */
1138     error ApproveToCaller();
1139 
1140     /**
1141      * Cannot query the balance for the zero address.
1142      */
1143     error BalanceQueryForZeroAddress();
1144 
1145     /**
1146      * Cannot mint to the zero address.
1147      */
1148     error MintToZeroAddress();
1149 
1150     /**
1151      * The quantity of tokens minted must be more than zero.
1152      */
1153     error MintZeroQuantity();
1154 
1155     /**
1156      * The token does not exist.
1157      */
1158     error OwnerQueryForNonexistentToken();
1159 
1160     /**
1161      * The caller must own the token or be an approved operator.
1162      */
1163     error TransferCallerNotOwnerNorApproved();
1164 
1165     /**
1166      * The token must be owned by `from`.
1167      */
1168     error TransferFromIncorrectOwner();
1169 
1170     /**
1171      * Cannot safely transfer to a contract that does not implement the ERC721Receiver interface.
1172      */
1173     error TransferToNonERC721ReceiverImplementer();
1174 
1175     /**
1176      * Cannot transfer to the zero address.
1177      */
1178     error TransferToZeroAddress();
1179 
1180     /**
1181      * The token does not exist.
1182      */
1183     error URIQueryForNonexistentToken();
1184 
1185     /**
1186      * The `quantity` minted with ERC2309 exceeds the safety limit.
1187      */
1188     error MintERC2309QuantityExceedsLimit();
1189 
1190     /**
1191      * The `extraData` cannot be set on an unintialized ownership slot.
1192      */
1193     error OwnershipNotInitializedForExtraData();
1194 
1195     struct TokenOwnership {
1196         // The address of the owner.
1197         address addr;
1198         // Keeps track of the start time of ownership with minimal overhead for tokenomics.
1199         uint64 startTimestamp;
1200         // Whether the token has been burned.
1201         bool burned;
1202         // Arbitrary data similar to `startTimestamp` that can be set through `_extraData`.
1203         uint24 extraData;
1204     }
1205 
1206     /**
1207      * @dev Returns the total amount of tokens stored by the contract.
1208      *
1209      * Burned tokens are calculated here, use `_totalMinted()` if you want to count just minted tokens.
1210      */
1211     function totalSupply() external view returns (uint256);
1212 
1213     // ==============================
1214     //            IERC165
1215     // ==============================
1216 
1217     /**
1218      * @dev Returns true if this contract implements the interface defined by
1219      * `interfaceId`. See the corresponding
1220      * https://eips.ethereum.org/EIPS/eip-165#how-interfaces-are-identified[EIP section]
1221      * to learn more about how these ids are created.
1222      *
1223      * This function call must use less than 30 000 gas.
1224      */
1225     function supportsInterface(bytes4 interfaceId) external view returns (bool);
1226 
1227     // ==============================
1228     //            IERC721
1229     // ==============================
1230 
1231     /**
1232      * @dev Emitted when `tokenId` token is transferred from `from` to `to`.
1233      */
1234     event Transfer(address indexed from, address indexed to, uint256 indexed tokenId);
1235 
1236     /**
1237      * @dev Emitted when `owner` enables `approved` to manage the `tokenId` token.
1238      */
1239     event Approval(address indexed owner, address indexed approved, uint256 indexed tokenId);
1240 
1241     /**
1242      * @dev Emitted when `owner` enables or disables (`approved`) `operator` to manage all of its assets.
1243      */
1244     event ApprovalForAll(address indexed owner, address indexed operator, bool approved);
1245 
1246     /**
1247      * @dev Returns the number of tokens in ``owner``'s account.
1248      */
1249     function balanceOf(address owner) external view returns (uint256 balance);
1250 
1251     /**
1252      * @dev Returns the owner of the `tokenId` token.
1253      *
1254      * Requirements:
1255      *
1256      * - `tokenId` must exist.
1257      */
1258     function ownerOf(uint256 tokenId) external view returns (address owner);
1259 
1260     /**
1261      * @dev Safely transfers `tokenId` token from `from` to `to`.
1262      *
1263      * Requirements:
1264      *
1265      * - `from` cannot be the zero address.
1266      * - `to` cannot be the zero address.
1267      * - `tokenId` token must exist and be owned by `from`.
1268      * - If the caller is not `from`, it must be approved to move this token by either {approve} or {setApprovalForAll}.
1269      * - If `to` refers to a smart contract, it must implement {IERC721Receiver-onERC721Received}, which is called upon a safe transfer.
1270      *
1271      * Emits a {Transfer} event.
1272      */
1273     function safeTransferFrom(
1274         address from,
1275         address to,
1276         uint256 tokenId,
1277         bytes calldata data
1278     ) external;
1279 
1280     /**
1281      * @dev Safely transfers `tokenId` token from `from` to `to`, checking first that contract recipients
1282      * are aware of the ERC721 protocol to prevent tokens from being forever locked.
1283      *
1284      * Requirements:
1285      *
1286      * - `from` cannot be the zero address.
1287      * - `to` cannot be the zero address.
1288      * - `tokenId` token must exist and be owned by `from`.
1289      * - If the caller is not `from`, it must be have been allowed to move this token by either {approve} or {setApprovalForAll}.
1290      * - If `to` refers to a smart contract, it must implement {IERC721Receiver-onERC721Received}, which is called upon a safe transfer.
1291      *
1292      * Emits a {Transfer} event.
1293      */
1294     function safeTransferFrom(
1295         address from,
1296         address to,
1297         uint256 tokenId
1298     ) external;
1299 
1300     /**
1301      * @dev Transfers `tokenId` token from `from` to `to`.
1302      *
1303      * WARNING: Usage of this method is discouraged, use {safeTransferFrom} whenever possible.
1304      *
1305      * Requirements:
1306      *
1307      * - `from` cannot be the zero address.
1308      * - `to` cannot be the zero address.
1309      * - `tokenId` token must be owned by `from`.
1310      * - If the caller is not `from`, it must be approved to move this token by either {approve} or {setApprovalForAll}.
1311      *
1312      * Emits a {Transfer} event.
1313      */
1314     function transferFrom(
1315         address from,
1316         address to,
1317         uint256 tokenId
1318     ) external;
1319 
1320     /**
1321      * @dev Gives permission to `to` to transfer `tokenId` token to another account.
1322      * The approval is cleared when the token is transferred.
1323      *
1324      * Only a single account can be approved at a time, so approving the zero address clears previous approvals.
1325      *
1326      * Requirements:
1327      *
1328      * - The caller must own the token or be an approved operator.
1329      * - `tokenId` must exist.
1330      *
1331      * Emits an {Approval} event.
1332      */
1333     function approve(address to, uint256 tokenId) external;
1334 
1335     /**
1336      * @dev Approve or remove `operator` as an operator for the caller.
1337      * Operators can call {transferFrom} or {safeTransferFrom} for any token owned by the caller.
1338      *
1339      * Requirements:
1340      *
1341      * - The `operator` cannot be the caller.
1342      *
1343      * Emits an {ApprovalForAll} event.
1344      */
1345     function setApprovalForAll(address operator, bool _approved) external;
1346 
1347     /**
1348      * @dev Returns the account approved for `tokenId` token.
1349      *
1350      * Requirements:
1351      *
1352      * - `tokenId` must exist.
1353      */
1354     function getApproved(uint256 tokenId) external view returns (address operator);
1355 
1356     /**
1357      * @dev Returns if the `operator` is allowed to manage all of the assets of `owner`.
1358      *
1359      * See {setApprovalForAll}
1360      */
1361     function isApprovedForAll(address owner, address operator) external view returns (bool);
1362 
1363     // ==============================
1364     //        IERC721Metadata
1365     // ==============================
1366 
1367     /**
1368      * @dev Returns the token collection name.
1369      */
1370     function name() external view returns (string memory);
1371 
1372     /**
1373      * @dev Returns the token collection symbol.
1374      */
1375     function symbol() external view returns (string memory);
1376 
1377     /**
1378      * @dev Returns the Uniform Resource Identifier (URI) for `tokenId` token.
1379      */
1380     function tokenURI(uint256 tokenId) external view returns (string memory);
1381 
1382     // ==============================
1383     //            IERC2309
1384     // ==============================
1385 
1386     /**
1387      * @dev Emitted when tokens in `fromTokenId` to `toTokenId` (inclusive) is transferred from `from` to `to`,
1388      * as defined in the ERC2309 standard. See `_mintERC2309` for more details.
1389      */
1390     event ConsecutiveTransfer(uint256 indexed fromTokenId, uint256 toTokenId, address indexed from, address indexed to);
1391 }
1392 
1393 // File: erc721a/contracts/ERC721A.sol
1394 
1395 
1396 // ERC721A Contracts v4.1.0
1397 // Creator: Chiru Labs
1398 
1399 pragma solidity ^0.8.4;
1400 
1401 
1402 /**
1403  * @dev ERC721 token receiver interface.
1404  */
1405 interface ERC721A__IERC721Receiver {
1406     function onERC721Received(
1407         address operator,
1408         address from,
1409         uint256 tokenId,
1410         bytes calldata data
1411     ) external returns (bytes4);
1412 }
1413 
1414 /**
1415  * @dev Implementation of https://eips.ethereum.org/EIPS/eip-721[ERC721] Non-Fungible Token Standard,
1416  * including the Metadata extension. Built to optimize for lower gas during batch mints.
1417  *
1418  * Assumes serials are sequentially minted starting at `_startTokenId()`
1419  * (defaults to 0, e.g. 0, 1, 2, 3..).
1420  *
1421  * Assumes that an owner cannot have more than 2**64 - 1 (max value of uint64) of supply.
1422  *
1423  * Assumes that the maximum token id cannot exceed 2**256 - 1 (max value of uint256).
1424  */
1425 contract ERC721A is IERC721A {
1426     // Mask of an entry in packed address data.
1427     uint256 private constant BITMASK_ADDRESS_DATA_ENTRY = (1 << 64) - 1;
1428 
1429     // The bit position of `numberMinted` in packed address data.
1430     uint256 private constant BITPOS_NUMBER_MINTED = 64;
1431 
1432     // The bit position of `numberBurned` in packed address data.
1433     uint256 private constant BITPOS_NUMBER_BURNED = 128;
1434 
1435     // The bit position of `aux` in packed address data.
1436     uint256 private constant BITPOS_AUX = 192;
1437 
1438     // Mask of all 256 bits in packed address data except the 64 bits for `aux`.
1439     uint256 private constant BITMASK_AUX_COMPLEMENT = (1 << 192) - 1;
1440 
1441     // The bit position of `startTimestamp` in packed ownership.
1442     uint256 private constant BITPOS_START_TIMESTAMP = 160;
1443 
1444     // The bit mask of the `burned` bit in packed ownership.
1445     uint256 private constant BITMASK_BURNED = 1 << 224;
1446 
1447     // The bit position of the `nextInitialized` bit in packed ownership.
1448     uint256 private constant BITPOS_NEXT_INITIALIZED = 225;
1449 
1450     // The bit mask of the `nextInitialized` bit in packed ownership.
1451     uint256 private constant BITMASK_NEXT_INITIALIZED = 1 << 225;
1452 
1453     // The bit position of `extraData` in packed ownership.
1454     uint256 private constant BITPOS_EXTRA_DATA = 232;
1455 
1456     // Mask of all 256 bits in a packed ownership except the 24 bits for `extraData`.
1457     uint256 private constant BITMASK_EXTRA_DATA_COMPLEMENT = (1 << 232) - 1;
1458 
1459     // The mask of the lower 160 bits for addresses.
1460     uint256 private constant BITMASK_ADDRESS = (1 << 160) - 1;
1461 
1462     // The maximum `quantity` that can be minted with `_mintERC2309`.
1463     // This limit is to prevent overflows on the address data entries.
1464     // For a limit of 5000, a total of 3.689e15 calls to `_mintERC2309`
1465     // is required to cause an overflow, which is unrealistic.
1466     uint256 private constant MAX_MINT_ERC2309_QUANTITY_LIMIT = 5000;
1467 
1468     // The tokenId of the next token to be minted.
1469     uint256 private _currentIndex;
1470 
1471     // The number of tokens burned.
1472     uint256 private _burnCounter;
1473 
1474     // Token name
1475     string private _name;
1476 
1477     // Token symbol
1478     string private _symbol;
1479 
1480     // Mapping from token ID to ownership details
1481     // An empty struct value does not necessarily mean the token is unowned.
1482     // See `_packedOwnershipOf` implementation for details.
1483     //
1484     // Bits Layout:
1485     // - [0..159]   `addr`
1486     // - [160..223] `startTimestamp`
1487     // - [224]      `burned`
1488     // - [225]      `nextInitialized`
1489     // - [232..255] `extraData`
1490     mapping(uint256 => uint256) private _packedOwnerships;
1491 
1492     // Mapping owner address to address data.
1493     //
1494     // Bits Layout:
1495     // - [0..63]    `balance`
1496     // - [64..127]  `numberMinted`
1497     // - [128..191] `numberBurned`
1498     // - [192..255] `aux`
1499     mapping(address => uint256) private _packedAddressData;
1500 
1501     // Mapping from token ID to approved address.
1502     mapping(uint256 => address) private _tokenApprovals;
1503 
1504     // Mapping from owner to operator approvals
1505     mapping(address => mapping(address => bool)) private _operatorApprovals;
1506 
1507     constructor(string memory name_, string memory symbol_) {
1508         _name = name_;
1509         _symbol = symbol_;
1510         _currentIndex = _startTokenId();
1511     }
1512 
1513     /**
1514      * @dev Returns the starting token ID.
1515      * To change the starting token ID, please override this function.
1516      */
1517     function _startTokenId() internal view virtual returns (uint256) {
1518         return 0;
1519     }
1520 
1521     /**
1522      * @dev Returns the next token ID to be minted.
1523      */
1524     function _nextTokenId() internal view returns (uint256) {
1525         return _currentIndex;
1526     }
1527 
1528     /**
1529      * @dev Returns the total number of tokens in existence.
1530      * Burned tokens will reduce the count.
1531      * To get the total number of tokens minted, please see `_totalMinted`.
1532      */
1533     function totalSupply() public view override returns (uint256) {
1534         // Counter underflow is impossible as _burnCounter cannot be incremented
1535         // more than `_currentIndex - _startTokenId()` times.
1536         unchecked {
1537             return _currentIndex - _burnCounter - _startTokenId();
1538         }
1539     }
1540 
1541     /**
1542      * @dev Returns the total amount of tokens minted in the contract.
1543      */
1544     function _totalMinted() internal view returns (uint256) {
1545         // Counter underflow is impossible as _currentIndex does not decrement,
1546         // and it is initialized to `_startTokenId()`
1547         unchecked {
1548             return _currentIndex - _startTokenId();
1549         }
1550     }
1551 
1552     /**
1553      * @dev Returns the total number of tokens burned.
1554      */
1555     function _totalBurned() internal view returns (uint256) {
1556         return _burnCounter;
1557     }
1558 
1559     /**
1560      * @dev See {IERC165-supportsInterface}.
1561      */
1562     function supportsInterface(bytes4 interfaceId) public view virtual override returns (bool) {
1563         // The interface IDs are constants representing the first 4 bytes of the XOR of
1564         // all function selectors in the interface. See: https://eips.ethereum.org/EIPS/eip-165
1565         // e.g. `bytes4(i.functionA.selector ^ i.functionB.selector ^ ...)`
1566         return
1567             interfaceId == 0x01ffc9a7 || // ERC165 interface ID for ERC165.
1568             interfaceId == 0x80ac58cd || // ERC165 interface ID for ERC721.
1569             interfaceId == 0x5b5e139f; // ERC165 interface ID for ERC721Metadata.
1570     }
1571 
1572     /**
1573      * @dev See {IERC721-balanceOf}.
1574      */
1575     function balanceOf(address owner) public view override returns (uint256) {
1576         if (owner == address(0)) revert BalanceQueryForZeroAddress();
1577         return _packedAddressData[owner] & BITMASK_ADDRESS_DATA_ENTRY;
1578     }
1579 
1580     /**
1581      * Returns the number of tokens minted by `owner`.
1582      */
1583     function _numberMinted(address owner) internal view returns (uint256) {
1584         return (_packedAddressData[owner] >> BITPOS_NUMBER_MINTED) & BITMASK_ADDRESS_DATA_ENTRY;
1585     }
1586 
1587     /**
1588      * Returns the number of tokens burned by or on behalf of `owner`.
1589      */
1590     function _numberBurned(address owner) internal view returns (uint256) {
1591         return (_packedAddressData[owner] >> BITPOS_NUMBER_BURNED) & BITMASK_ADDRESS_DATA_ENTRY;
1592     }
1593 
1594     /**
1595      * Returns the auxiliary data for `owner`. (e.g. number of whitelist mint slots used).
1596      */
1597     function _getAux(address owner) internal view returns (uint64) {
1598         return uint64(_packedAddressData[owner] >> BITPOS_AUX);
1599     }
1600 
1601     /**
1602      * Sets the auxiliary data for `owner`. (e.g. number of whitelist mint slots used).
1603      * If there are multiple variables, please pack them into a uint64.
1604      */
1605     function _setAux(address owner, uint64 aux) internal {
1606         uint256 packed = _packedAddressData[owner];
1607         uint256 auxCasted;
1608         // Cast `aux` with assembly to avoid redundant masking.
1609         assembly {
1610             auxCasted := aux
1611         }
1612         packed = (packed & BITMASK_AUX_COMPLEMENT) | (auxCasted << BITPOS_AUX);
1613         _packedAddressData[owner] = packed;
1614     }
1615 
1616     /**
1617      * Returns the packed ownership data of `tokenId`.
1618      */
1619     function _packedOwnershipOf(uint256 tokenId) private view returns (uint256) {
1620         uint256 curr = tokenId;
1621 
1622         unchecked {
1623             if (_startTokenId() <= curr)
1624                 if (curr < _currentIndex) {
1625                     uint256 packed = _packedOwnerships[curr];
1626                     // If not burned.
1627                     if (packed & BITMASK_BURNED == 0) {
1628                         // Invariant:
1629                         // There will always be an ownership that has an address and is not burned
1630                         // before an ownership that does not have an address and is not burned.
1631                         // Hence, curr will not underflow.
1632                         //
1633                         // We can directly compare the packed value.
1634                         // If the address is zero, packed is zero.
1635                         while (packed == 0) {
1636                             packed = _packedOwnerships[--curr];
1637                         }
1638                         return packed;
1639                     }
1640                 }
1641         }
1642         revert OwnerQueryForNonexistentToken();
1643     }
1644 
1645     /**
1646      * Returns the unpacked `TokenOwnership` struct from `packed`.
1647      */
1648     function _unpackedOwnership(uint256 packed) private pure returns (TokenOwnership memory ownership) {
1649         ownership.addr = address(uint160(packed));
1650         ownership.startTimestamp = uint64(packed >> BITPOS_START_TIMESTAMP);
1651         ownership.burned = packed & BITMASK_BURNED != 0;
1652         ownership.extraData = uint24(packed >> BITPOS_EXTRA_DATA);
1653     }
1654 
1655     /**
1656      * Returns the unpacked `TokenOwnership` struct at `index`.
1657      */
1658     function _ownershipAt(uint256 index) internal view returns (TokenOwnership memory) {
1659         return _unpackedOwnership(_packedOwnerships[index]);
1660     }
1661 
1662     /**
1663      * @dev Initializes the ownership slot minted at `index` for efficiency purposes.
1664      */
1665     function _initializeOwnershipAt(uint256 index) internal {
1666         if (_packedOwnerships[index] == 0) {
1667             _packedOwnerships[index] = _packedOwnershipOf(index);
1668         }
1669     }
1670 
1671     /**
1672      * Gas spent here starts off proportional to the maximum mint batch size.
1673      * It gradually moves to O(1) as tokens get transferred around in the collection over time.
1674      */
1675     function _ownershipOf(uint256 tokenId) internal view returns (TokenOwnership memory) {
1676         return _unpackedOwnership(_packedOwnershipOf(tokenId));
1677     }
1678 
1679     /**
1680      * @dev Packs ownership data into a single uint256.
1681      */
1682     function _packOwnershipData(address owner, uint256 flags) private view returns (uint256 result) {
1683         assembly {
1684             // Mask `owner` to the lower 160 bits, in case the upper bits somehow aren't clean.
1685             owner := and(owner, BITMASK_ADDRESS)
1686             // `owner | (block.timestamp << BITPOS_START_TIMESTAMP) | flags`.
1687             result := or(owner, or(shl(BITPOS_START_TIMESTAMP, timestamp()), flags))
1688         }
1689     }
1690 
1691     /**
1692      * @dev See {IERC721-ownerOf}.
1693      */
1694     function ownerOf(uint256 tokenId) public view override returns (address) {
1695         return address(uint160(_packedOwnershipOf(tokenId)));
1696     }
1697 
1698     /**
1699      * @dev See {IERC721Metadata-name}.
1700      */
1701     function name() public view virtual override returns (string memory) {
1702         return _name;
1703     }
1704 
1705     /**
1706      * @dev See {IERC721Metadata-symbol}.
1707      */
1708     function symbol() public view virtual override returns (string memory) {
1709         return _symbol;
1710     }
1711 
1712     /**
1713      * @dev See {IERC721Metadata-tokenURI}.
1714      */
1715     function tokenURI(uint256 tokenId) public view virtual override returns (string memory) {
1716         if (!_exists(tokenId)) revert URIQueryForNonexistentToken();
1717 
1718         string memory baseURI = _baseURI();
1719         return bytes(baseURI).length != 0 ? string(abi.encodePacked(baseURI, _toString(tokenId))) : '';
1720     }
1721 
1722     /**
1723      * @dev Base URI for computing {tokenURI}. If set, the resulting URI for each
1724      * token will be the concatenation of the `baseURI` and the `tokenId`. Empty
1725      * by default, it can be overridden in child contracts.
1726      */
1727     function _baseURI() internal view virtual returns (string memory) {
1728         return '';
1729     }
1730 
1731     /**
1732      * @dev Returns the `nextInitialized` flag set if `quantity` equals 1.
1733      */
1734     function _nextInitializedFlag(uint256 quantity) private pure returns (uint256 result) {
1735         // For branchless setting of the `nextInitialized` flag.
1736         assembly {
1737             // `(quantity == 1) << BITPOS_NEXT_INITIALIZED`.
1738             result := shl(BITPOS_NEXT_INITIALIZED, eq(quantity, 1))
1739         }
1740     }
1741 
1742     /**
1743      * @dev See {IERC721-approve}.
1744      */
1745     function approve(address to, uint256 tokenId) public override {
1746         address owner = ownerOf(tokenId);
1747 
1748         if (_msgSenderERC721A() != owner)
1749             if (!isApprovedForAll(owner, _msgSenderERC721A())) {
1750                 revert ApprovalCallerNotOwnerNorApproved();
1751             }
1752 
1753         _tokenApprovals[tokenId] = to;
1754         emit Approval(owner, to, tokenId);
1755     }
1756 
1757     /**
1758      * @dev See {IERC721-getApproved}.
1759      */
1760     function getApproved(uint256 tokenId) public view override returns (address) {
1761         if (!_exists(tokenId)) revert ApprovalQueryForNonexistentToken();
1762 
1763         return _tokenApprovals[tokenId];
1764     }
1765 
1766     /**
1767      * @dev See {IERC721-setApprovalForAll}.
1768      */
1769     function setApprovalForAll(address operator, bool approved) public virtual override {
1770         if (operator == _msgSenderERC721A()) revert ApproveToCaller();
1771 
1772         _operatorApprovals[_msgSenderERC721A()][operator] = approved;
1773         emit ApprovalForAll(_msgSenderERC721A(), operator, approved);
1774     }
1775 
1776     /**
1777      * @dev See {IERC721-isApprovedForAll}.
1778      */
1779     function isApprovedForAll(address owner, address operator) public view virtual override returns (bool) {
1780         return _operatorApprovals[owner][operator];
1781     }
1782 
1783     /**
1784      * @dev See {IERC721-safeTransferFrom}.
1785      */
1786     function safeTransferFrom(
1787         address from,
1788         address to,
1789         uint256 tokenId
1790     ) public virtual override {
1791         safeTransferFrom(from, to, tokenId, '');
1792     }
1793 
1794     /**
1795      * @dev See {IERC721-safeTransferFrom}.
1796      */
1797     function safeTransferFrom(
1798         address from,
1799         address to,
1800         uint256 tokenId,
1801         bytes memory _data
1802     ) public virtual override {
1803         transferFrom(from, to, tokenId);
1804         if (to.code.length != 0)
1805             if (!_checkContractOnERC721Received(from, to, tokenId, _data)) {
1806                 revert TransferToNonERC721ReceiverImplementer();
1807             }
1808     }
1809 
1810     /**
1811      * @dev Returns whether `tokenId` exists.
1812      *
1813      * Tokens can be managed by their owner or approved accounts via {approve} or {setApprovalForAll}.
1814      *
1815      * Tokens start existing when they are minted (`_mint`),
1816      */
1817     function _exists(uint256 tokenId) internal view returns (bool) {
1818         return
1819             _startTokenId() <= tokenId &&
1820             tokenId < _currentIndex && // If within bounds,
1821             _packedOwnerships[tokenId] & BITMASK_BURNED == 0; // and not burned.
1822     }
1823 
1824     /**
1825      * @dev Equivalent to `_safeMint(to, quantity, '')`.
1826      */
1827     function _safeMint(address to, uint256 quantity) internal {
1828         _safeMint(to, quantity, '');
1829     }
1830 
1831     /**
1832      * @dev Safely mints `quantity` tokens and transfers them to `to`.
1833      *
1834      * Requirements:
1835      *
1836      * - If `to` refers to a smart contract, it must implement
1837      *   {IERC721Receiver-onERC721Received}, which is called for each safe transfer.
1838      * - `quantity` must be greater than 0.
1839      *
1840      * See {_mint}.
1841      *
1842      * Emits a {Transfer} event for each mint.
1843      */
1844     function _safeMint(
1845         address to,
1846         uint256 quantity,
1847         bytes memory _data
1848     ) internal {
1849         _mint(to, quantity);
1850 
1851         unchecked {
1852             if (to.code.length != 0) {
1853                 uint256 end = _currentIndex;
1854                 uint256 index = end - quantity;
1855                 do {
1856                     if (!_checkContractOnERC721Received(address(0), to, index++, _data)) {
1857                         revert TransferToNonERC721ReceiverImplementer();
1858                     }
1859                 } while (index < end);
1860                 // Reentrancy protection.
1861                 if (_currentIndex != end) revert();
1862             }
1863         }
1864     }
1865 
1866     /**
1867      * @dev Mints `quantity` tokens and transfers them to `to`.
1868      *
1869      * Requirements:
1870      *
1871      * - `to` cannot be the zero address.
1872      * - `quantity` must be greater than 0.
1873      *
1874      * Emits a {Transfer} event for each mint.
1875      */
1876     function _mint(address to, uint256 quantity) internal {
1877         uint256 startTokenId = _currentIndex;
1878         if (to == address(0)) revert MintToZeroAddress();
1879         if (quantity == 0) revert MintZeroQuantity();
1880 
1881         _beforeTokenTransfers(address(0), to, startTokenId, quantity);
1882 
1883         // Overflows are incredibly unrealistic.
1884         // `balance` and `numberMinted` have a maximum limit of 2**64.
1885         // `tokenId` has a maximum limit of 2**256.
1886         unchecked {
1887             // Updates:
1888             // - `balance += quantity`.
1889             // - `numberMinted += quantity`.
1890             //
1891             // We can directly add to the `balance` and `numberMinted`.
1892             _packedAddressData[to] += quantity * ((1 << BITPOS_NUMBER_MINTED) | 1);
1893 
1894             // Updates:
1895             // - `address` to the owner.
1896             // - `startTimestamp` to the timestamp of minting.
1897             // - `burned` to `false`.
1898             // - `nextInitialized` to `quantity == 1`.
1899             _packedOwnerships[startTokenId] = _packOwnershipData(
1900                 to,
1901                 _nextInitializedFlag(quantity) | _nextExtraData(address(0), to, 0)
1902             );
1903 
1904             uint256 tokenId = startTokenId;
1905             uint256 end = startTokenId + quantity;
1906             do {
1907                 emit Transfer(address(0), to, tokenId++);
1908             } while (tokenId < end);
1909 
1910             _currentIndex = end;
1911         }
1912         _afterTokenTransfers(address(0), to, startTokenId, quantity);
1913     }
1914 
1915     /**
1916      * @dev Mints `quantity` tokens and transfers them to `to`.
1917      *
1918      * This function is intended for efficient minting only during contract creation.
1919      *
1920      * It emits only one {ConsecutiveTransfer} as defined in
1921      * [ERC2309](https://eips.ethereum.org/EIPS/eip-2309),
1922      * instead of a sequence of {Transfer} event(s).
1923      *
1924      * Calling this function outside of contract creation WILL make your contract
1925      * non-compliant with the ERC721 standard.
1926      * For full ERC721 compliance, substituting ERC721 {Transfer} event(s) with the ERC2309
1927      * {ConsecutiveTransfer} event is only permissible during contract creation.
1928      *
1929      * Requirements:
1930      *
1931      * - `to` cannot be the zero address.
1932      * - `quantity` must be greater than 0.
1933      *
1934      * Emits a {ConsecutiveTransfer} event.
1935      */
1936     function _mintERC2309(address to, uint256 quantity) internal {
1937         uint256 startTokenId = _currentIndex;
1938         if (to == address(0)) revert MintToZeroAddress();
1939         if (quantity == 0) revert MintZeroQuantity();
1940         if (quantity > MAX_MINT_ERC2309_QUANTITY_LIMIT) revert MintERC2309QuantityExceedsLimit();
1941 
1942         _beforeTokenTransfers(address(0), to, startTokenId, quantity);
1943 
1944         // Overflows are unrealistic due to the above check for `quantity` to be below the limit.
1945         unchecked {
1946             // Updates:
1947             // - `balance += quantity`.
1948             // - `numberMinted += quantity`.
1949             //
1950             // We can directly add to the `balance` and `numberMinted`.
1951             _packedAddressData[to] += quantity * ((1 << BITPOS_NUMBER_MINTED) | 1);
1952 
1953             // Updates:
1954             // - `address` to the owner.
1955             // - `startTimestamp` to the timestamp of minting.
1956             // - `burned` to `false`.
1957             // - `nextInitialized` to `quantity == 1`.
1958             _packedOwnerships[startTokenId] = _packOwnershipData(
1959                 to,
1960                 _nextInitializedFlag(quantity) | _nextExtraData(address(0), to, 0)
1961             );
1962 
1963             emit ConsecutiveTransfer(startTokenId, startTokenId + quantity - 1, address(0), to);
1964 
1965             _currentIndex = startTokenId + quantity;
1966         }
1967         _afterTokenTransfers(address(0), to, startTokenId, quantity);
1968     }
1969 
1970     /**
1971      * @dev Returns the storage slot and value for the approved address of `tokenId`.
1972      */
1973     function _getApprovedAddress(uint256 tokenId)
1974         private
1975         view
1976         returns (uint256 approvedAddressSlot, address approvedAddress)
1977     {
1978         mapping(uint256 => address) storage tokenApprovalsPtr = _tokenApprovals;
1979         // The following is equivalent to `approvedAddress = _tokenApprovals[tokenId]`.
1980         assembly {
1981             // Compute the slot.
1982             mstore(0x00, tokenId)
1983             mstore(0x20, tokenApprovalsPtr.slot)
1984             approvedAddressSlot := keccak256(0x00, 0x40)
1985             // Load the slot's value from storage.
1986             approvedAddress := sload(approvedAddressSlot)
1987         }
1988     }
1989 
1990     /**
1991      * @dev Returns whether the `approvedAddress` is equals to `from` or `msgSender`.
1992      */
1993     function _isOwnerOrApproved(
1994         address approvedAddress,
1995         address from,
1996         address msgSender
1997     ) private pure returns (bool result) {
1998         assembly {
1999             // Mask `from` to the lower 160 bits, in case the upper bits somehow aren't clean.
2000             from := and(from, BITMASK_ADDRESS)
2001             // Mask `msgSender` to the lower 160 bits, in case the upper bits somehow aren't clean.
2002             msgSender := and(msgSender, BITMASK_ADDRESS)
2003             // `msgSender == from || msgSender == approvedAddress`.
2004             result := or(eq(msgSender, from), eq(msgSender, approvedAddress))
2005         }
2006     }
2007 
2008     /**
2009      * @dev Transfers `tokenId` from `from` to `to`.
2010      *
2011      * Requirements:
2012      *
2013      * - `to` cannot be the zero address.
2014      * - `tokenId` token must be owned by `from`.
2015      *
2016      * Emits a {Transfer} event.
2017      */
2018     function transferFrom(
2019         address from,
2020         address to,
2021         uint256 tokenId
2022     ) public virtual override {
2023         uint256 prevOwnershipPacked = _packedOwnershipOf(tokenId);
2024 
2025         if (address(uint160(prevOwnershipPacked)) != from) revert TransferFromIncorrectOwner();
2026 
2027         (uint256 approvedAddressSlot, address approvedAddress) = _getApprovedAddress(tokenId);
2028 
2029         // The nested ifs save around 20+ gas over a compound boolean condition.
2030         if (!_isOwnerOrApproved(approvedAddress, from, _msgSenderERC721A()))
2031             if (!isApprovedForAll(from, _msgSenderERC721A())) revert TransferCallerNotOwnerNorApproved();
2032 
2033         if (to == address(0)) revert TransferToZeroAddress();
2034 
2035         _beforeTokenTransfers(from, to, tokenId, 1);
2036 
2037         // Clear approvals from the previous owner.
2038         assembly {
2039             if approvedAddress {
2040                 // This is equivalent to `delete _tokenApprovals[tokenId]`.
2041                 sstore(approvedAddressSlot, 0)
2042             }
2043         }
2044 
2045         // Underflow of the sender's balance is impossible because we check for
2046         // ownership above and the recipient's balance can't realistically overflow.
2047         // Counter overflow is incredibly unrealistic as tokenId would have to be 2**256.
2048         unchecked {
2049             // We can directly increment and decrement the balances.
2050             --_packedAddressData[from]; // Updates: `balance -= 1`.
2051             ++_packedAddressData[to]; // Updates: `balance += 1`.
2052 
2053             // Updates:
2054             // - `address` to the next owner.
2055             // - `startTimestamp` to the timestamp of transfering.
2056             // - `burned` to `false`.
2057             // - `nextInitialized` to `true`.
2058             _packedOwnerships[tokenId] = _packOwnershipData(
2059                 to,
2060                 BITMASK_NEXT_INITIALIZED | _nextExtraData(from, to, prevOwnershipPacked)
2061             );
2062 
2063             // If the next slot may not have been initialized (i.e. `nextInitialized == false`) .
2064             if (prevOwnershipPacked & BITMASK_NEXT_INITIALIZED == 0) {
2065                 uint256 nextTokenId = tokenId + 1;
2066                 // If the next slot's address is zero and not burned (i.e. packed value is zero).
2067                 if (_packedOwnerships[nextTokenId] == 0) {
2068                     // If the next slot is within bounds.
2069                     if (nextTokenId != _currentIndex) {
2070                         // Initialize the next slot to maintain correctness for `ownerOf(tokenId + 1)`.
2071                         _packedOwnerships[nextTokenId] = prevOwnershipPacked;
2072                     }
2073                 }
2074             }
2075         }
2076 
2077         emit Transfer(from, to, tokenId);
2078         _afterTokenTransfers(from, to, tokenId, 1);
2079     }
2080 
2081     /**
2082      * @dev Equivalent to `_burn(tokenId, false)`.
2083      */
2084     function _burn(uint256 tokenId) internal virtual {
2085         _burn(tokenId, false);
2086     }
2087 
2088     /**
2089      * @dev Destroys `tokenId`.
2090      * The approval is cleared when the token is burned.
2091      *
2092      * Requirements:
2093      *
2094      * - `tokenId` must exist.
2095      *
2096      * Emits a {Transfer} event.
2097      */
2098     function _burn(uint256 tokenId, bool approvalCheck) internal virtual {
2099         uint256 prevOwnershipPacked = _packedOwnershipOf(tokenId);
2100 
2101         address from = address(uint160(prevOwnershipPacked));
2102 
2103         (uint256 approvedAddressSlot, address approvedAddress) = _getApprovedAddress(tokenId);
2104 
2105         if (approvalCheck) {
2106             // The nested ifs save around 20+ gas over a compound boolean condition.
2107             if (!_isOwnerOrApproved(approvedAddress, from, _msgSenderERC721A()))
2108                 if (!isApprovedForAll(from, _msgSenderERC721A())) revert TransferCallerNotOwnerNorApproved();
2109         }
2110 
2111         _beforeTokenTransfers(from, address(0), tokenId, 1);
2112 
2113         // Clear approvals from the previous owner.
2114         assembly {
2115             if approvedAddress {
2116                 // This is equivalent to `delete _tokenApprovals[tokenId]`.
2117                 sstore(approvedAddressSlot, 0)
2118             }
2119         }
2120 
2121         // Underflow of the sender's balance is impossible because we check for
2122         // ownership above and the recipient's balance can't realistically overflow.
2123         // Counter overflow is incredibly unrealistic as `tokenId` would have to be 2**256.
2124         unchecked {
2125             // Updates:
2126             // - `balance -= 1`.
2127             // - `numberBurned += 1`.
2128             //
2129             // We can directly decrement the balance, and increment the number burned.
2130             // This is equivalent to `packed -= 1; packed += 1 << BITPOS_NUMBER_BURNED;`.
2131             _packedAddressData[from] += (1 << BITPOS_NUMBER_BURNED) - 1;
2132 
2133             // Updates:
2134             // - `address` to the last owner.
2135             // - `startTimestamp` to the timestamp of burning.
2136             // - `burned` to `true`.
2137             // - `nextInitialized` to `true`.
2138             _packedOwnerships[tokenId] = _packOwnershipData(
2139                 from,
2140                 (BITMASK_BURNED | BITMASK_NEXT_INITIALIZED) | _nextExtraData(from, address(0), prevOwnershipPacked)
2141             );
2142 
2143             // If the next slot may not have been initialized (i.e. `nextInitialized == false`) .
2144             if (prevOwnershipPacked & BITMASK_NEXT_INITIALIZED == 0) {
2145                 uint256 nextTokenId = tokenId + 1;
2146                 // If the next slot's address is zero and not burned (i.e. packed value is zero).
2147                 if (_packedOwnerships[nextTokenId] == 0) {
2148                     // If the next slot is within bounds.
2149                     if (nextTokenId != _currentIndex) {
2150                         // Initialize the next slot to maintain correctness for `ownerOf(tokenId + 1)`.
2151                         _packedOwnerships[nextTokenId] = prevOwnershipPacked;
2152                     }
2153                 }
2154             }
2155         }
2156 
2157         emit Transfer(from, address(0), tokenId);
2158         _afterTokenTransfers(from, address(0), tokenId, 1);
2159 
2160         // Overflow not possible, as _burnCounter cannot be exceed _currentIndex times.
2161         unchecked {
2162             _burnCounter++;
2163         }
2164     }
2165 
2166     /**
2167      * @dev Internal function to invoke {IERC721Receiver-onERC721Received} on a target contract.
2168      *
2169      * @param from address representing the previous owner of the given token ID
2170      * @param to target address that will receive the tokens
2171      * @param tokenId uint256 ID of the token to be transferred
2172      * @param _data bytes optional data to send along with the call
2173      * @return bool whether the call correctly returned the expected magic value
2174      */
2175     function _checkContractOnERC721Received(
2176         address from,
2177         address to,
2178         uint256 tokenId,
2179         bytes memory _data
2180     ) private returns (bool) {
2181         try ERC721A__IERC721Receiver(to).onERC721Received(_msgSenderERC721A(), from, tokenId, _data) returns (
2182             bytes4 retval
2183         ) {
2184             return retval == ERC721A__IERC721Receiver(to).onERC721Received.selector;
2185         } catch (bytes memory reason) {
2186             if (reason.length == 0) {
2187                 revert TransferToNonERC721ReceiverImplementer();
2188             } else {
2189                 assembly {
2190                     revert(add(32, reason), mload(reason))
2191                 }
2192             }
2193         }
2194     }
2195 
2196     /**
2197      * @dev Directly sets the extra data for the ownership data `index`.
2198      */
2199     function _setExtraDataAt(uint256 index, uint24 extraData) internal {
2200         uint256 packed = _packedOwnerships[index];
2201         if (packed == 0) revert OwnershipNotInitializedForExtraData();
2202         uint256 extraDataCasted;
2203         // Cast `extraData` with assembly to avoid redundant masking.
2204         assembly {
2205             extraDataCasted := extraData
2206         }
2207         packed = (packed & BITMASK_EXTRA_DATA_COMPLEMENT) | (extraDataCasted << BITPOS_EXTRA_DATA);
2208         _packedOwnerships[index] = packed;
2209     }
2210 
2211     /**
2212      * @dev Returns the next extra data for the packed ownership data.
2213      * The returned result is shifted into position.
2214      */
2215     function _nextExtraData(
2216         address from,
2217         address to,
2218         uint256 prevOwnershipPacked
2219     ) private view returns (uint256) {
2220         uint24 extraData = uint24(prevOwnershipPacked >> BITPOS_EXTRA_DATA);
2221         return uint256(_extraData(from, to, extraData)) << BITPOS_EXTRA_DATA;
2222     }
2223 
2224     /**
2225      * @dev Called during each token transfer to set the 24bit `extraData` field.
2226      * Intended to be overridden by the cosumer contract.
2227      *
2228      * `previousExtraData` - the value of `extraData` before transfer.
2229      *
2230      * Calling conditions:
2231      *
2232      * - When `from` and `to` are both non-zero, `from`'s `tokenId` will be
2233      * transferred to `to`.
2234      * - When `from` is zero, `tokenId` will be minted for `to`.
2235      * - When `to` is zero, `tokenId` will be burned by `from`.
2236      * - `from` and `to` are never both zero.
2237      */
2238     function _extraData(
2239         address from,
2240         address to,
2241         uint24 previousExtraData
2242     ) internal view virtual returns (uint24) {}
2243 
2244     /**
2245      * @dev Hook that is called before a set of serially-ordered token ids are about to be transferred.
2246      * This includes minting.
2247      * And also called before burning one token.
2248      *
2249      * startTokenId - the first token id to be transferred
2250      * quantity - the amount to be transferred
2251      *
2252      * Calling conditions:
2253      *
2254      * - When `from` and `to` are both non-zero, `from`'s `tokenId` will be
2255      * transferred to `to`.
2256      * - When `from` is zero, `tokenId` will be minted for `to`.
2257      * - When `to` is zero, `tokenId` will be burned by `from`.
2258      * - `from` and `to` are never both zero.
2259      */
2260     function _beforeTokenTransfers(
2261         address from,
2262         address to,
2263         uint256 startTokenId,
2264         uint256 quantity
2265     ) internal virtual {}
2266 
2267     /**
2268      * @dev Hook that is called after a set of serially-ordered token ids have been transferred.
2269      * This includes minting.
2270      * And also called after one token has been burned.
2271      *
2272      * startTokenId - the first token id to be transferred
2273      * quantity - the amount to be transferred
2274      *
2275      * Calling conditions:
2276      *
2277      * - When `from` and `to` are both non-zero, `from`'s `tokenId` has been
2278      * transferred to `to`.
2279      * - When `from` is zero, `tokenId` has been minted for `to`.
2280      * - When `to` is zero, `tokenId` has been burned by `from`.
2281      * - `from` and `to` are never both zero.
2282      */
2283     function _afterTokenTransfers(
2284         address from,
2285         address to,
2286         uint256 startTokenId,
2287         uint256 quantity
2288     ) internal virtual {}
2289 
2290     /**
2291      * @dev Returns the message sender (defaults to `msg.sender`).
2292      *
2293      * If you are writing GSN compatible contracts, you need to override this function.
2294      */
2295     function _msgSenderERC721A() internal view virtual returns (address) {
2296         return msg.sender;
2297     }
2298 
2299     /**
2300      * @dev Converts a `uint256` to its ASCII `string` decimal representation.
2301      */
2302     function _toString(uint256 value) internal pure returns (string memory ptr) {
2303         assembly {
2304             // The maximum value of a uint256 contains 78 digits (1 byte per digit),
2305             // but we allocate 128 bytes to keep the free memory pointer 32-byte word aliged.
2306             // We will need 1 32-byte word to store the length,
2307             // and 3 32-byte words to store a maximum of 78 digits. Total: 32 + 3 * 32 = 128.
2308             ptr := add(mload(0x40), 128)
2309             // Update the free memory pointer to allocate.
2310             mstore(0x40, ptr)
2311 
2312             // Cache the end of the memory to calculate the length later.
2313             let end := ptr
2314 
2315             // We write the string from the rightmost digit to the leftmost digit.
2316             // The following is essentially a do-while loop that also handles the zero case.
2317             // Costs a bit more than early returning for the zero case,
2318             // but cheaper in terms of deployment and overall runtime costs.
2319             for {
2320                 // Initialize and perform the first pass without check.
2321                 let temp := value
2322                 // Move the pointer 1 byte leftwards to point to an empty character slot.
2323                 ptr := sub(ptr, 1)
2324                 // Write the character to the pointer. 48 is the ASCII index of '0'.
2325                 mstore8(ptr, add(48, mod(temp, 10)))
2326                 temp := div(temp, 10)
2327             } temp {
2328                 // Keep dividing `temp` until zero.
2329                 temp := div(temp, 10)
2330             } {
2331                 // Body of the for loop.
2332                 ptr := sub(ptr, 1)
2333                 mstore8(ptr, add(48, mod(temp, 10)))
2334             }
2335 
2336             let length := sub(end, ptr)
2337             // Move the pointer 32 bytes leftwards to make room for the length.
2338             ptr := sub(ptr, 32)
2339             // Store the length.
2340             mstore(ptr, length)
2341         }
2342     }
2343 }
2344 
2345 // File: contracts/NXCSentimentAPI.sol
2346 
2347 
2348 
2349 pragma solidity >=0.7.0 <0.9.0;
2350 
2351 
2352 
2353 
2354 contract NXCSentimentAlpha is ERC721A, Ownable {
2355   using Strings for uint256;
2356   string private baseUri;
2357   string private suffix = ".json";
2358   
2359   uint256 public constant maxSupply = 50;
2360   uint256 public constant mintQuantity = 1;
2361 
2362   bool public mintIsActive;
2363 
2364   address private _manager;
2365   mapping(address => uint256) public amountMinted;
2366 
2367   constructor() ERC721A("NXC Sentiment API Alpha", "NXCSentimentAPIAlpha") {
2368     baseUri = "ipfs://QmQxdz8aA1MZ5HTnRL992KDzNgDzMQoU9LqMMQf2cLUacu/";
2369     mintIsActive = false;
2370     _mint(msg.sender, 5);
2371   }
2372 
2373   modifier onlyOwnerOrManager() {
2374     require(owner() == _msgSender() || _manager == _msgSender(), "Caller is not the owner or manager");
2375     _;
2376   }
2377 
2378   modifier eligibleToMint() {
2379     require(mintIsActive, "The contract has not started minting.");
2380     require(amountMinted[_msgSender()] == 0, "You can not mint more than one token per wallet.");
2381     require(totalSupply() + mintQuantity <= maxSupply, "All tokens have been minted.");
2382     _;
2383   }
2384 
2385   function mint() public eligibleToMint {
2386     amountMinted[msg.sender] += mintQuantity;
2387     _mint(msg.sender, mintQuantity);
2388   }
2389 
2390   function ownerMint(uint256 _quantity) public onlyOwnerOrManager {
2391     _mint(msg.sender, _quantity);
2392   }
2393 
2394   function flipMintState() external onlyOwnerOrManager {
2395     mintIsActive = !mintIsActive;
2396   }
2397 
2398   function setManager(address manager) external onlyOwnerOrManager {
2399     _manager = manager;
2400   }
2401 
2402   function withdraw() public onlyOwnerOrManager {
2403     (bool os, ) = payable(owner()).call{value: address(this).balance}("");
2404     require(os);
2405   }
2406 
2407   function setBaseUri(string memory _baseUri) public onlyOwner {
2408     baseUri = _baseUri;
2409   }
2410 
2411   function _baseURI() internal view virtual override returns (string memory) {
2412     return baseUri;
2413   }
2414 
2415   function tokenURI(uint256 _tokenId)
2416     public
2417     view
2418     virtual
2419     override
2420     returns (string memory)
2421   {
2422     require(
2423       _exists(_tokenId),
2424       "ERC721Metadata: URI query for nonexistent token"
2425     );
2426 
2427     string memory currentBaseURI = _baseURI();
2428     return bytes(currentBaseURI).length > 0
2429         ? string(abi.encodePacked(currentBaseURI, _tokenId.toString(), suffix))
2430         : "";
2431   }
2432 
2433   function _startTokenId() internal pure override(ERC721A) returns(uint256 startId) {
2434     return 1;
2435   }
2436 }