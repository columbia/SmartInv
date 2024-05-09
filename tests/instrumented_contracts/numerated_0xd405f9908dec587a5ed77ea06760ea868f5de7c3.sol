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
299 // OpenZeppelin Contracts v4.4.1 (token/ERC721/IERC721Receiver.sol)
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
316      * The selector can be obtained in Solidity with `IERC721.onERC721Received.selector`.
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
388 // OpenZeppelin Contracts v4.4.1 (token/ERC721/IERC721.sol)
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
427      * @dev Safely transfers `tokenId` token from `from` to `to`, checking first that contract recipients
428      * are aware of the ERC721 protocol to prevent tokens from being forever locked.
429      *
430      * Requirements:
431      *
432      * - `from` cannot be the zero address.
433      * - `to` cannot be the zero address.
434      * - `tokenId` token must exist and be owned by `from`.
435      * - If the caller is not `from`, it must be have been allowed to move this token by either {approve} or {setApprovalForAll}.
436      * - If `to` refers to a smart contract, it must implement {IERC721Receiver-onERC721Received}, which is called upon a safe transfer.
437      *
438      * Emits a {Transfer} event.
439      */
440     function safeTransferFrom(
441         address from,
442         address to,
443         uint256 tokenId
444     ) external;
445 
446     /**
447      * @dev Transfers `tokenId` token from `from` to `to`.
448      *
449      * WARNING: Usage of this method is discouraged, use {safeTransferFrom} whenever possible.
450      *
451      * Requirements:
452      *
453      * - `from` cannot be the zero address.
454      * - `to` cannot be the zero address.
455      * - `tokenId` token must be owned by `from`.
456      * - If the caller is not `from`, it must be approved to move this token by either {approve} or {setApprovalForAll}.
457      *
458      * Emits a {Transfer} event.
459      */
460     function transferFrom(
461         address from,
462         address to,
463         uint256 tokenId
464     ) external;
465 
466     /**
467      * @dev Gives permission to `to` to transfer `tokenId` token to another account.
468      * The approval is cleared when the token is transferred.
469      *
470      * Only a single account can be approved at a time, so approving the zero address clears previous approvals.
471      *
472      * Requirements:
473      *
474      * - The caller must own the token or be an approved operator.
475      * - `tokenId` must exist.
476      *
477      * Emits an {Approval} event.
478      */
479     function approve(address to, uint256 tokenId) external;
480 
481     /**
482      * @dev Returns the account approved for `tokenId` token.
483      *
484      * Requirements:
485      *
486      * - `tokenId` must exist.
487      */
488     function getApproved(uint256 tokenId) external view returns (address operator);
489 
490     /**
491      * @dev Approve or remove `operator` as an operator for the caller.
492      * Operators can call {transferFrom} or {safeTransferFrom} for any token owned by the caller.
493      *
494      * Requirements:
495      *
496      * - The `operator` cannot be the caller.
497      *
498      * Emits an {ApprovalForAll} event.
499      */
500     function setApprovalForAll(address operator, bool _approved) external;
501 
502     /**
503      * @dev Returns if the `operator` is allowed to manage all of the assets of `owner`.
504      *
505      * See {setApprovalForAll}
506      */
507     function isApprovedForAll(address owner, address operator) external view returns (bool);
508 
509     /**
510      * @dev Safely transfers `tokenId` token from `from` to `to`.
511      *
512      * Requirements:
513      *
514      * - `from` cannot be the zero address.
515      * - `to` cannot be the zero address.
516      * - `tokenId` token must exist and be owned by `from`.
517      * - If the caller is not `from`, it must be approved to move this token by either {approve} or {setApprovalForAll}.
518      * - If `to` refers to a smart contract, it must implement {IERC721Receiver-onERC721Received}, which is called upon a safe transfer.
519      *
520      * Emits a {Transfer} event.
521      */
522     function safeTransferFrom(
523         address from,
524         address to,
525         uint256 tokenId,
526         bytes calldata data
527     ) external;
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
1113 // File: @openzeppelin/contracts/token/ERC20/IERC20.sol
1114 
1115 
1116 // OpenZeppelin Contracts (last updated v4.5.0) (token/ERC20/IERC20.sol)
1117 
1118 pragma solidity ^0.8.0;
1119 
1120 /**
1121  * @dev Interface of the ERC20 standard as defined in the EIP.
1122  */
1123 interface IERC20 {
1124     /**
1125      * @dev Returns the amount of tokens in existence.
1126      */
1127     function totalSupply() external view returns (uint256);
1128 
1129     /**
1130      * @dev Returns the amount of tokens owned by `account`.
1131      */
1132     function balanceOf(address account) external view returns (uint256);
1133 
1134     /**
1135      * @dev Moves `amount` tokens from the caller's account to `to`.
1136      *
1137      * Returns a boolean value indicating whether the operation succeeded.
1138      *
1139      * Emits a {Transfer} event.
1140      */
1141     function transfer(address to, uint256 amount) external returns (bool);
1142 
1143     /**
1144      * @dev Returns the remaining number of tokens that `spender` will be
1145      * allowed to spend on behalf of `owner` through {transferFrom}. This is
1146      * zero by default.
1147      *
1148      * This value changes when {approve} or {transferFrom} are called.
1149      */
1150     function allowance(address owner, address spender) external view returns (uint256);
1151 
1152     /**
1153      * @dev Sets `amount` as the allowance of `spender` over the caller's tokens.
1154      *
1155      * Returns a boolean value indicating whether the operation succeeded.
1156      *
1157      * IMPORTANT: Beware that changing an allowance with this method brings the risk
1158      * that someone may use both the old and the new allowance by unfortunate
1159      * transaction ordering. One possible solution to mitigate this race
1160      * condition is to first reduce the spender's allowance to 0 and set the
1161      * desired value afterwards:
1162      * https://github.com/ethereum/EIPs/issues/20#issuecomment-263524729
1163      *
1164      * Emits an {Approval} event.
1165      */
1166     function approve(address spender, uint256 amount) external returns (bool);
1167 
1168     /**
1169      * @dev Moves `amount` tokens from `from` to `to` using the
1170      * allowance mechanism. `amount` is then deducted from the caller's
1171      * allowance.
1172      *
1173      * Returns a boolean value indicating whether the operation succeeded.
1174      *
1175      * Emits a {Transfer} event.
1176      */
1177     function transferFrom(
1178         address from,
1179         address to,
1180         uint256 amount
1181     ) external returns (bool);
1182 
1183     /**
1184      * @dev Emitted when `value` tokens are moved from one account (`from`) to
1185      * another (`to`).
1186      *
1187      * Note that `value` may be zero.
1188      */
1189     event Transfer(address indexed from, address indexed to, uint256 value);
1190 
1191     /**
1192      * @dev Emitted when the allowance of a `spender` for an `owner` is set by
1193      * a call to {approve}. `value` is the new allowance.
1194      */
1195     event Approval(address indexed owner, address indexed spender, uint256 value);
1196 }
1197 
1198 // File: @openzeppelin/contracts/token/ERC20/extensions/IERC20Metadata.sol
1199 
1200 
1201 // OpenZeppelin Contracts v4.4.1 (token/ERC20/extensions/IERC20Metadata.sol)
1202 
1203 pragma solidity ^0.8.0;
1204 
1205 
1206 /**
1207  * @dev Interface for the optional metadata functions from the ERC20 standard.
1208  *
1209  * _Available since v4.1._
1210  */
1211 interface IERC20Metadata is IERC20 {
1212     /**
1213      * @dev Returns the name of the token.
1214      */
1215     function name() external view returns (string memory);
1216 
1217     /**
1218      * @dev Returns the symbol of the token.
1219      */
1220     function symbol() external view returns (string memory);
1221 
1222     /**
1223      * @dev Returns the decimals places of the token.
1224      */
1225     function decimals() external view returns (uint8);
1226 }
1227 
1228 // File: @openzeppelin/contracts/token/ERC20/ERC20.sol
1229 
1230 
1231 // OpenZeppelin Contracts (last updated v4.5.0) (token/ERC20/ERC20.sol)
1232 
1233 pragma solidity ^0.8.0;
1234 
1235 
1236 
1237 
1238 /**
1239  * @dev Implementation of the {IERC20} interface.
1240  *
1241  * This implementation is agnostic to the way tokens are created. This means
1242  * that a supply mechanism has to be added in a derived contract using {_mint}.
1243  * For a generic mechanism see {ERC20PresetMinterPauser}.
1244  *
1245  * TIP: For a detailed writeup see our guide
1246  * https://forum.zeppelin.solutions/t/how-to-implement-erc20-supply-mechanisms/226[How
1247  * to implement supply mechanisms].
1248  *
1249  * We have followed general OpenZeppelin Contracts guidelines: functions revert
1250  * instead returning `false` on failure. This behavior is nonetheless
1251  * conventional and does not conflict with the expectations of ERC20
1252  * applications.
1253  *
1254  * Additionally, an {Approval} event is emitted on calls to {transferFrom}.
1255  * This allows applications to reconstruct the allowance for all accounts just
1256  * by listening to said events. Other implementations of the EIP may not emit
1257  * these events, as it isn't required by the specification.
1258  *
1259  * Finally, the non-standard {decreaseAllowance} and {increaseAllowance}
1260  * functions have been added to mitigate the well-known issues around setting
1261  * allowances. See {IERC20-approve}.
1262  */
1263 contract ERC20 is Context, IERC20, IERC20Metadata {
1264     mapping(address => uint256) private _balances;
1265 
1266     mapping(address => mapping(address => uint256)) private _allowances;
1267 
1268     uint256 private _totalSupply;
1269 
1270     string private _name;
1271     string private _symbol;
1272 
1273     /**
1274      * @dev Sets the values for {name} and {symbol}.
1275      *
1276      * The default value of {decimals} is 18. To select a different value for
1277      * {decimals} you should overload it.
1278      *
1279      * All two of these values are immutable: they can only be set once during
1280      * construction.
1281      */
1282     constructor(string memory name_, string memory symbol_) {
1283         _name = name_;
1284         _symbol = symbol_;
1285     }
1286 
1287     /**
1288      * @dev Returns the name of the token.
1289      */
1290     function name() public view virtual override returns (string memory) {
1291         return _name;
1292     }
1293 
1294     /**
1295      * @dev Returns the symbol of the token, usually a shorter version of the
1296      * name.
1297      */
1298     function symbol() public view virtual override returns (string memory) {
1299         return _symbol;
1300     }
1301 
1302     /**
1303      * @dev Returns the number of decimals used to get its user representation.
1304      * For example, if `decimals` equals `2`, a balance of `505` tokens should
1305      * be displayed to a user as `5.05` (`505 / 10 ** 2`).
1306      *
1307      * Tokens usually opt for a value of 18, imitating the relationship between
1308      * Ether and Wei. This is the value {ERC20} uses, unless this function is
1309      * overridden;
1310      *
1311      * NOTE: This information is only used for _display_ purposes: it in
1312      * no way affects any of the arithmetic of the contract, including
1313      * {IERC20-balanceOf} and {IERC20-transfer}.
1314      */
1315     function decimals() public view virtual override returns (uint8) {
1316         return 18;
1317     }
1318 
1319     /**
1320      * @dev See {IERC20-totalSupply}.
1321      */
1322     function totalSupply() public view virtual override returns (uint256) {
1323         return _totalSupply;
1324     }
1325 
1326     /**
1327      * @dev See {IERC20-balanceOf}.
1328      */
1329     function balanceOf(address account) public view virtual override returns (uint256) {
1330         return _balances[account];
1331     }
1332 
1333     /**
1334      * @dev See {IERC20-transfer}.
1335      *
1336      * Requirements:
1337      *
1338      * - `to` cannot be the zero address.
1339      * - the caller must have a balance of at least `amount`.
1340      */
1341     function transfer(address to, uint256 amount) public virtual override returns (bool) {
1342         address owner = _msgSender();
1343         _transfer(owner, to, amount);
1344         return true;
1345     }
1346 
1347     /**
1348      * @dev See {IERC20-allowance}.
1349      */
1350     function allowance(address owner, address spender) public view virtual override returns (uint256) {
1351         return _allowances[owner][spender];
1352     }
1353 
1354     /**
1355      * @dev See {IERC20-approve}.
1356      *
1357      * NOTE: If `amount` is the maximum `uint256`, the allowance is not updated on
1358      * `transferFrom`. This is semantically equivalent to an infinite approval.
1359      *
1360      * Requirements:
1361      *
1362      * - `spender` cannot be the zero address.
1363      */
1364     function approve(address spender, uint256 amount) public virtual override returns (bool) {
1365         address owner = _msgSender();
1366         _approve(owner, spender, amount);
1367         return true;
1368     }
1369 
1370     /**
1371      * @dev See {IERC20-transferFrom}.
1372      *
1373      * Emits an {Approval} event indicating the updated allowance. This is not
1374      * required by the EIP. See the note at the beginning of {ERC20}.
1375      *
1376      * NOTE: Does not update the allowance if the current allowance
1377      * is the maximum `uint256`.
1378      *
1379      * Requirements:
1380      *
1381      * - `from` and `to` cannot be the zero address.
1382      * - `from` must have a balance of at least `amount`.
1383      * - the caller must have allowance for ``from``'s tokens of at least
1384      * `amount`.
1385      */
1386     function transferFrom(
1387         address from,
1388         address to,
1389         uint256 amount
1390     ) public virtual override returns (bool) {
1391         address spender = _msgSender();
1392         _spendAllowance(from, spender, amount);
1393         _transfer(from, to, amount);
1394         return true;
1395     }
1396 
1397     /**
1398      * @dev Atomically increases the allowance granted to `spender` by the caller.
1399      *
1400      * This is an alternative to {approve} that can be used as a mitigation for
1401      * problems described in {IERC20-approve}.
1402      *
1403      * Emits an {Approval} event indicating the updated allowance.
1404      *
1405      * Requirements:
1406      *
1407      * - `spender` cannot be the zero address.
1408      */
1409     function increaseAllowance(address spender, uint256 addedValue) public virtual returns (bool) {
1410         address owner = _msgSender();
1411         _approve(owner, spender, _allowances[owner][spender] + addedValue);
1412         return true;
1413     }
1414 
1415     /**
1416      * @dev Atomically decreases the allowance granted to `spender` by the caller.
1417      *
1418      * This is an alternative to {approve} that can be used as a mitigation for
1419      * problems described in {IERC20-approve}.
1420      *
1421      * Emits an {Approval} event indicating the updated allowance.
1422      *
1423      * Requirements:
1424      *
1425      * - `spender` cannot be the zero address.
1426      * - `spender` must have allowance for the caller of at least
1427      * `subtractedValue`.
1428      */
1429     function decreaseAllowance(address spender, uint256 subtractedValue) public virtual returns (bool) {
1430         address owner = _msgSender();
1431         uint256 currentAllowance = _allowances[owner][spender];
1432         require(currentAllowance >= subtractedValue, "ERC20: decreased allowance below zero");
1433         unchecked {
1434             _approve(owner, spender, currentAllowance - subtractedValue);
1435         }
1436 
1437         return true;
1438     }
1439 
1440     /**
1441      * @dev Moves `amount` of tokens from `sender` to `recipient`.
1442      *
1443      * This internal function is equivalent to {transfer}, and can be used to
1444      * e.g. implement automatic token fees, slashing mechanisms, etc.
1445      *
1446      * Emits a {Transfer} event.
1447      *
1448      * Requirements:
1449      *
1450      * - `from` cannot be the zero address.
1451      * - `to` cannot be the zero address.
1452      * - `from` must have a balance of at least `amount`.
1453      */
1454     function _transfer(
1455         address from,
1456         address to,
1457         uint256 amount
1458     ) internal virtual {
1459         require(from != address(0), "ERC20: transfer from the zero address");
1460         require(to != address(0), "ERC20: transfer to the zero address");
1461 
1462         _beforeTokenTransfer(from, to, amount);
1463 
1464         uint256 fromBalance = _balances[from];
1465         require(fromBalance >= amount, "ERC20: transfer amount exceeds balance");
1466         unchecked {
1467             _balances[from] = fromBalance - amount;
1468         }
1469         _balances[to] += amount;
1470 
1471         emit Transfer(from, to, amount);
1472 
1473         _afterTokenTransfer(from, to, amount);
1474     }
1475 
1476     /** @dev Creates `amount` tokens and assigns them to `account`, increasing
1477      * the total supply.
1478      *
1479      * Emits a {Transfer} event with `from` set to the zero address.
1480      *
1481      * Requirements:
1482      *
1483      * - `account` cannot be the zero address.
1484      */
1485     function _mint(address account, uint256 amount) internal virtual {
1486         require(account != address(0), "ERC20: mint to the zero address");
1487 
1488         _beforeTokenTransfer(address(0), account, amount);
1489 
1490         _totalSupply += amount;
1491         _balances[account] += amount;
1492         emit Transfer(address(0), account, amount);
1493 
1494         _afterTokenTransfer(address(0), account, amount);
1495     }
1496 
1497     /**
1498      * @dev Destroys `amount` tokens from `account`, reducing the
1499      * total supply.
1500      *
1501      * Emits a {Transfer} event with `to` set to the zero address.
1502      *
1503      * Requirements:
1504      *
1505      * - `account` cannot be the zero address.
1506      * - `account` must have at least `amount` tokens.
1507      */
1508     function _burn(address account, uint256 amount) internal virtual {
1509         require(account != address(0), "ERC20: burn from the zero address");
1510 
1511         _beforeTokenTransfer(account, address(0), amount);
1512 
1513         uint256 accountBalance = _balances[account];
1514         require(accountBalance >= amount, "ERC20: burn amount exceeds balance");
1515         unchecked {
1516             _balances[account] = accountBalance - amount;
1517         }
1518         _totalSupply -= amount;
1519 
1520         emit Transfer(account, address(0), amount);
1521 
1522         _afterTokenTransfer(account, address(0), amount);
1523     }
1524 
1525     /**
1526      * @dev Sets `amount` as the allowance of `spender` over the `owner` s tokens.
1527      *
1528      * This internal function is equivalent to `approve`, and can be used to
1529      * e.g. set automatic allowances for certain subsystems, etc.
1530      *
1531      * Emits an {Approval} event.
1532      *
1533      * Requirements:
1534      *
1535      * - `owner` cannot be the zero address.
1536      * - `spender` cannot be the zero address.
1537      */
1538     function _approve(
1539         address owner,
1540         address spender,
1541         uint256 amount
1542     ) internal virtual {
1543         require(owner != address(0), "ERC20: approve from the zero address");
1544         require(spender != address(0), "ERC20: approve to the zero address");
1545 
1546         _allowances[owner][spender] = amount;
1547         emit Approval(owner, spender, amount);
1548     }
1549 
1550     /**
1551      * @dev Spend `amount` form the allowance of `owner` toward `spender`.
1552      *
1553      * Does not update the allowance amount in case of infinite allowance.
1554      * Revert if not enough allowance is available.
1555      *
1556      * Might emit an {Approval} event.
1557      */
1558     function _spendAllowance(
1559         address owner,
1560         address spender,
1561         uint256 amount
1562     ) internal virtual {
1563         uint256 currentAllowance = allowance(owner, spender);
1564         if (currentAllowance != type(uint256).max) {
1565             require(currentAllowance >= amount, "ERC20: insufficient allowance");
1566             unchecked {
1567                 _approve(owner, spender, currentAllowance - amount);
1568             }
1569         }
1570     }
1571 
1572     /**
1573      * @dev Hook that is called before any transfer of tokens. This includes
1574      * minting and burning.
1575      *
1576      * Calling conditions:
1577      *
1578      * - when `from` and `to` are both non-zero, `amount` of ``from``'s tokens
1579      * will be transferred to `to`.
1580      * - when `from` is zero, `amount` tokens will be minted for `to`.
1581      * - when `to` is zero, `amount` of ``from``'s tokens will be burned.
1582      * - `from` and `to` are never both zero.
1583      *
1584      * To learn more about hooks, head to xref:ROOT:extending-contracts.adoc#using-hooks[Using Hooks].
1585      */
1586     function _beforeTokenTransfer(
1587         address from,
1588         address to,
1589         uint256 amount
1590     ) internal virtual {}
1591 
1592     /**
1593      * @dev Hook that is called after any transfer of tokens. This includes
1594      * minting and burning.
1595      *
1596      * Calling conditions:
1597      *
1598      * - when `from` and `to` are both non-zero, `amount` of ``from``'s tokens
1599      * has been transferred to `to`.
1600      * - when `from` is zero, `amount` tokens have been minted for `to`.
1601      * - when `to` is zero, `amount` of ``from``'s tokens have been burned.
1602      * - `from` and `to` are never both zero.
1603      *
1604      * To learn more about hooks, head to xref:ROOT:extending-contracts.adoc#using-hooks[Using Hooks].
1605      */
1606     function _afterTokenTransfer(
1607         address from,
1608         address to,
1609         uint256 amount
1610     ) internal virtual {}
1611 }
1612 
1613 // File: @openzeppelin/contracts/token/ERC20/extensions/ERC20Burnable.sol
1614 
1615 
1616 // OpenZeppelin Contracts (last updated v4.5.0) (token/ERC20/extensions/ERC20Burnable.sol)
1617 
1618 pragma solidity ^0.8.0;
1619 
1620 
1621 
1622 /**
1623  * @dev Extension of {ERC20} that allows token holders to destroy both their own
1624  * tokens and those that they have an allowance for, in a way that can be
1625  * recognized off-chain (via event analysis).
1626  */
1627 abstract contract ERC20Burnable is Context, ERC20 {
1628     /**
1629      * @dev Destroys `amount` tokens from the caller.
1630      *
1631      * See {ERC20-_burn}.
1632      */
1633     function burn(uint256 amount) public virtual {
1634         _burn(_msgSender(), amount);
1635     }
1636 
1637     /**
1638      * @dev Destroys `amount` tokens from `account`, deducting from the caller's
1639      * allowance.
1640      *
1641      * See {ERC20-_burn} and {ERC20-allowance}.
1642      *
1643      * Requirements:
1644      *
1645      * - the caller must have allowance for ``accounts``'s tokens of at least
1646      * `amount`.
1647      */
1648     function burnFrom(address account, uint256 amount) public virtual {
1649         _spendAllowance(account, _msgSender(), amount);
1650         _burn(account, amount);
1651     }
1652 }
1653 
1654 // File: contracts/Human.sol
1655 
1656 
1657 pragma solidity ^0.8.0;
1658 
1659 
1660 
1661 
1662 // @author WG <https://twitter.com/whalegoddess>   
1663 
1664 contract Human is ERC20Burnable, Ownable{
1665 
1666     uint256 public EMISSION_RATE = 10 ether;
1667     uint256 public immutable DEFAULT_START_TIMESTAMP;
1668     address public nft;
1669 
1670     mapping(uint16 => uint256) emissionsBoost;
1671 
1672     mapping (uint16 => uint256) tokenToLastClaimedPassive;
1673 
1674     constructor() ERC20("Human", "HUMAN") {
1675         DEFAULT_START_TIMESTAMP = 1648317600;
1676         nft = 0x582b874Af6A8D0eC283febE1988fb4A67c06e050;
1677     }
1678 
1679     function claimPassiveYield(uint16[] memory _tokenIds) public {
1680         require(block.timestamp > DEFAULT_START_TIMESTAMP, "Too early to claim");
1681         uint256 rewards = 0;
1682 
1683         for (uint i = 0; i < _tokenIds.length; i++) {
1684             uint16 tokenId = _tokenIds[i];
1685             require(
1686                 ERC721(nft).ownerOf(tokenId) == msg.sender,
1687                 "You are not the owner of this token"
1688             );
1689 
1690             rewards += getPassiveRewardsForId(tokenId);
1691             tokenToLastClaimedPassive[tokenId] = block.timestamp;
1692         }
1693         _mint(msg.sender, rewards);
1694     }
1695 
1696 
1697     function getPassiveRewardsForId(uint16 _id) public view returns (uint) {
1698         return (block.timestamp - (tokenToLastClaimedPassive[_id] == 0 ? DEFAULT_START_TIMESTAMP : tokenToLastClaimedPassive[_id])) * (EMISSION_RATE + emissionsBoost[_id]) / 86400;
1699     }
1700 
1701     function addTraitBoost(uint16[] memory ids, uint256[] memory boosts) external onlyOwner {
1702         require(ids.length == boosts.length, "ids and boosts not equal length");
1703         for(uint i = 0; i < ids.length; i++) {
1704             emissionsBoost[ids[i]] = boosts[i];
1705         }
1706     }
1707 
1708     function setNFTAddress(address _address) external onlyOwner {
1709         nft = _address;
1710     }
1711 }