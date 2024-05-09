1 // Sources flattened with hardhat v2.1.2 https://hardhat.org
2 
3 // SPDX-License-Identifier: MIT
4 
5 pragma solidity 0.8.17;
6 
7 // File @openzeppelin/contracts/utils/Strings.sol@v4.7.3
8 
9 
10 // OpenZeppelin Contracts (last updated v4.7.0) (utils/Strings.sol)
11 
12 
13 /**
14  * @dev String operations.
15  */
16 library Strings {
17     bytes16 private constant _HEX_SYMBOLS = "0123456789abcdef";
18     uint8 private constant _ADDRESS_LENGTH = 20;
19 
20     /**
21      * @dev Converts a `uint256` to its ASCII `string` decimal representation.
22      */
23     function toString(uint256 value) internal pure returns (string memory) {
24         // Inspired by OraclizeAPI's implementation - MIT licence
25         // https://github.com/oraclize/ethereum-api/blob/b42146b063c7d6ee1358846c198246239e9360e8/oraclizeAPI_0.4.25.sol
26 
27         if (value == 0) {
28             return "0";
29         }
30         uint256 temp = value;
31         uint256 digits;
32         while (temp != 0) {
33             digits++;
34             temp /= 10;
35         }
36         bytes memory buffer = new bytes(digits);
37         while (value != 0) {
38             digits -= 1;
39             buffer[digits] = bytes1(uint8(48 + uint256(value % 10)));
40             value /= 10;
41         }
42         return string(buffer);
43     }
44 
45     /**
46      * @dev Converts a `uint256` to its ASCII `string` hexadecimal representation.
47      */
48     function toHexString(uint256 value) internal pure returns (string memory) {
49         if (value == 0) {
50             return "0x00";
51         }
52         uint256 temp = value;
53         uint256 length = 0;
54         while (temp != 0) {
55             length++;
56             temp >>= 8;
57         }
58         return toHexString(value, length);
59     }
60 
61     /**
62      * @dev Converts a `uint256` to its ASCII `string` hexadecimal representation with fixed length.
63      */
64     function toHexString(uint256 value, uint256 length) internal pure returns (string memory) {
65         bytes memory buffer = new bytes(2 * length + 2);
66         buffer[0] = "0";
67         buffer[1] = "x";
68         for (uint256 i = 2 * length + 1; i > 1; --i) {
69             buffer[i] = _HEX_SYMBOLS[value & 0xf];
70             value >>= 4;
71         }
72         require(value == 0, "Strings: hex length insufficient");
73         return string(buffer);
74     }
75 
76     /**
77      * @dev Converts an `address` with fixed length of 20 bytes to its not checksummed ASCII `string` hexadecimal representation.
78      */
79     function toHexString(address addr) internal pure returns (string memory) {
80         return toHexString(uint256(uint160(addr)), _ADDRESS_LENGTH);
81     }
82 }
83 
84 
85 // File @openzeppelin/contracts/utils/introspection/IERC165.sol@v4.7.3
86 
87  
88 // OpenZeppelin Contracts v4.4.1 (utils/introspection/IERC165.sol)
89 
90 /**
91  * @dev Interface of the ERC165 standard, as defined in the
92  * https://eips.ethereum.org/EIPS/eip-165[EIP].
93  *
94  * Implementers can declare support of contract interfaces, which can then be
95  * queried by others ({ERC165Checker}).
96  *
97  * For an implementation, see {ERC165}.
98  */
99 interface IERC165 {
100     /**
101      * @dev Returns true if this contract implements the interface defined by
102      * `interfaceId`. See the corresponding
103      * https://eips.ethereum.org/EIPS/eip-165#how-interfaces-are-identified[EIP section]
104      * to learn more about how these ids are created.
105      *
106      * This function call must use less than 30 000 gas.
107      */
108     function supportsInterface(bytes4 interfaceId) external view returns (bool);
109 }
110 
111 
112 // File @openzeppelin/contracts/token/ERC721/IERC721.sol@v4.7.3
113 
114  
115 // OpenZeppelin Contracts (last updated v4.7.0) (token/ERC721/IERC721.sol)
116 
117 
118 /**
119  * @dev Required interface of an ERC721 compliant contract.
120  */
121 interface IERC721 is IERC165 {
122     /**
123      * @dev Emitted when `tokenId` token is transferred from `from` to `to`.
124      */
125     event Transfer(address indexed from, address indexed to, uint256 indexed tokenId);
126 
127     /**
128      * @dev Emitted when `owner` enables `approved` to manage the `tokenId` token.
129      */
130     event Approval(address indexed owner, address indexed approved, uint256 indexed tokenId);
131 
132     /**
133      * @dev Emitted when `owner` enables or disables (`approved`) `operator` to manage all of its assets.
134      */
135     event ApprovalForAll(address indexed owner, address indexed operator, bool approved);
136 
137     /**
138      * @dev Returns the number of tokens in ``owner``'s account.
139      */
140     function balanceOf(address owner) external view returns (uint256 balance);
141 
142     /**
143      * @dev Returns the owner of the `tokenId` token.
144      *
145      * Requirements:
146      *
147      * - `tokenId` must exist.
148      */
149     function ownerOf(uint256 tokenId) external view returns (address owner);
150 
151     /**
152      * @dev Safely transfers `tokenId` token from `from` to `to`.
153      *
154      * Requirements:
155      *
156      * - `from` cannot be the zero address.
157      * - `to` cannot be the zero address.
158      * - `tokenId` token must exist and be owned by `from`.
159      * - If the caller is not `from`, it must be approved to move this token by either {approve} or {setApprovalForAll}.
160      * - If `to` refers to a smart contract, it must implement {IERC721Receiver-onERC721Received}, which is called upon a safe transfer.
161      *
162      * Emits a {Transfer} event.
163      */
164     function safeTransferFrom(
165         address from,
166         address to,
167         uint256 tokenId,
168         bytes calldata data
169     ) external;
170 
171     /**
172      * @dev Safely transfers `tokenId` token from `from` to `to`, checking first that contract recipients
173      * are aware of the ERC721 protocol to prevent tokens from being forever locked.
174      *
175      * Requirements:
176      *
177      * - `from` cannot be the zero address.
178      * - `to` cannot be the zero address.
179      * - `tokenId` token must exist and be owned by `from`.
180      * - If the caller is not `from`, it must have been allowed to move this token by either {approve} or {setApprovalForAll}.
181      * - If `to` refers to a smart contract, it must implement {IERC721Receiver-onERC721Received}, which is called upon a safe transfer.
182      *
183      * Emits a {Transfer} event.
184      */
185     function safeTransferFrom(
186         address from,
187         address to,
188         uint256 tokenId
189     ) external;
190 
191     /**
192      * @dev Transfers `tokenId` token from `from` to `to`.
193      *
194      * WARNING: Usage of this method is discouraged, use {safeTransferFrom} whenever possible.
195      *
196      * Requirements:
197      *
198      * - `from` cannot be the zero address.
199      * - `to` cannot be the zero address.
200      * - `tokenId` token must be owned by `from`.
201      * - If the caller is not `from`, it must be approved to move this token by either {approve} or {setApprovalForAll}.
202      *
203      * Emits a {Transfer} event.
204      */
205     function transferFrom(
206         address from,
207         address to,
208         uint256 tokenId
209     ) external;
210 
211     /**
212      * @dev Gives permission to `to` to transfer `tokenId` token to another account.
213      * The approval is cleared when the token is transferred.
214      *
215      * Only a single account can be approved at a time, so approving the zero address clears previous approvals.
216      *
217      * Requirements:
218      *
219      * - The caller must own the token or be an approved operator.
220      * - `tokenId` must exist.
221      *
222      * Emits an {Approval} event.
223      */
224     function approve(address to, uint256 tokenId) external;
225 
226     /**
227      * @dev Approve or remove `operator` as an operator for the caller.
228      * Operators can call {transferFrom} or {safeTransferFrom} for any token owned by the caller.
229      *
230      * Requirements:
231      *
232      * - The `operator` cannot be the caller.
233      *
234      * Emits an {ApprovalForAll} event.
235      */
236     function setApprovalForAll(address operator, bool _approved) external;
237 
238     /**
239      * @dev Returns the account approved for `tokenId` token.
240      *
241      * Requirements:
242      *
243      * - `tokenId` must exist.
244      */
245     function getApproved(uint256 tokenId) external view returns (address operator);
246 
247     /**
248      * @dev Returns if the `operator` is allowed to manage all of the assets of `owner`.
249      *
250      * See {setApprovalForAll}
251      */
252     function isApprovedForAll(address owner, address operator) external view returns (bool);
253 }
254 
255 
256 // File @openzeppelin/contracts/token/ERC721/IERC721Receiver.sol@v4.7.3
257 
258  
259 // OpenZeppelin Contracts (last updated v4.6.0) (token/ERC721/IERC721Receiver.sol)
260 
261 
262 /**
263  * @title ERC721 token receiver interface
264  * @dev Interface for any contract that wants to support safeTransfers
265  * from ERC721 asset contracts.
266  */
267 interface IERC721Receiver {
268     /**
269      * @dev Whenever an {IERC721} `tokenId` token is transferred to this contract via {IERC721-safeTransferFrom}
270      * by `operator` from `from`, this function is called.
271      *
272      * It must return its Solidity selector to confirm the token transfer.
273      * If any other value is returned or the interface is not implemented by the recipient, the transfer will be reverted.
274      *
275      * The selector can be obtained in Solidity with `IERC721Receiver.onERC721Received.selector`.
276      */
277     function onERC721Received(
278         address operator,
279         address from,
280         uint256 tokenId,
281         bytes calldata data
282     ) external returns (bytes4);
283 }
284 
285 
286 // File @openzeppelin/contracts/token/ERC721/extensions/IERC721Metadata.sol@v4.7.3
287 
288  
289 // OpenZeppelin Contracts v4.4.1 (token/ERC721/extensions/IERC721Metadata.sol)
290 
291 
292 /**
293  * @title ERC-721 Non-Fungible Token Standard, optional metadata extension
294  * @dev See https://eips.ethereum.org/EIPS/eip-721
295  */
296 interface IERC721Metadata is IERC721 {
297     /**
298      * @dev Returns the token collection name.
299      */
300     function name() external view returns (string memory);
301 
302     /**
303      * @dev Returns the token collection symbol.
304      */
305     function symbol() external view returns (string memory);
306 
307     /**
308      * @dev Returns the Uniform Resource Identifier (URI) for `tokenId` token.
309      */
310     function tokenURI(uint256 tokenId) external view returns (string memory);
311 }
312 
313 
314 // File @openzeppelin/contracts/utils/Address.sol@v4.7.3
315 
316  
317 // OpenZeppelin Contracts (last updated v4.7.0) (utils/Address.sol)
318 
319 
320 /**
321  * @dev Collection of functions related to the address type
322  */
323 library Address {
324     /**
325      * @dev Returns true if `account` is a contract.
326      *
327      * [IMPORTANT]
328      * ====
329      * It is unsafe to assume that an address for which this function returns
330      * false is an externally-owned account (EOA) and not a contract.
331      *
332      * Among others, `isContract` will return false for the following
333      * types of addresses:
334      *
335      *  - an externally-owned account
336      *  - a contract in construction
337      *  - an address where a contract will be created
338      *  - an address where a contract lived, but was destroyed
339      * ====
340      *
341      * [IMPORTANT]
342      * ====
343      * You shouldn't rely on `isContract` to protect against flash loan attacks!
344      *
345      * Preventing calls from contracts is highly discouraged. It breaks composability, breaks support for smart wallets
346      * like Gnosis Safe, and does not provide security since it can be circumvented by calling from a contract
347      * constructor.
348      * ====
349      */
350     function isContract(address account) internal view returns (bool) {
351         // This method relies on extcodesize/address.code.length, which returns 0
352         // for contracts in construction, since the code is only stored at the end
353         // of the constructor execution.
354 
355         return account.code.length > 0;
356     }
357 
358     /**
359      * @dev Replacement for Solidity's `transfer`: sends `amount` wei to
360      * `recipient`, forwarding all available gas and reverting on errors.
361      *
362      * https://eips.ethereum.org/EIPS/eip-1884[EIP1884] increases the gas cost
363      * of certain opcodes, possibly making contracts go over the 2300 gas limit
364      * imposed by `transfer`, making them unable to receive funds via
365      * `transfer`. {sendValue} removes this limitation.
366      *
367      * https://diligence.consensys.net/posts/2019/09/stop-using-soliditys-transfer-now/[Learn more].
368      *
369      * IMPORTANT: because control is transferred to `recipient`, care must be
370      * taken to not create reentrancy vulnerabilities. Consider using
371      * {ReentrancyGuard} or the
372      * https://solidity.readthedocs.io/en/v0.5.11/security-considerations.html#use-the-checks-effects-interactions-pattern[checks-effects-interactions pattern].
373      */
374     function sendValue(address payable recipient, uint256 amount) internal {
375         require(address(this).balance >= amount, "Address: insufficient balance");
376 
377         (bool success, ) = recipient.call{value: amount}("");
378         require(success, "Address: unable to send value, recipient may have reverted");
379     }
380 
381     /**
382      * @dev Performs a Solidity function call using a low level `call`. A
383      * plain `call` is an unsafe replacement for a function call: use this
384      * function instead.
385      *
386      * If `target` reverts with a revert reason, it is bubbled up by this
387      * function (like regular Solidity function calls).
388      *
389      * Returns the raw returned data. To convert to the expected return value,
390      * use https://solidity.readthedocs.io/en/latest/units-and-global-variables.html?highlight=abi.decode#abi-encoding-and-decoding-functions[`abi.decode`].
391      *
392      * Requirements:
393      *
394      * - `target` must be a contract.
395      * - calling `target` with `data` must not revert.
396      *
397      * _Available since v3.1._
398      */
399     function functionCall(address target, bytes memory data) internal returns (bytes memory) {
400         return functionCall(target, data, "Address: low-level call failed");
401     }
402 
403     /**
404      * @dev Same as {xref-Address-functionCall-address-bytes-}[`functionCall`], but with
405      * `errorMessage` as a fallback revert reason when `target` reverts.
406      *
407      * _Available since v3.1._
408      */
409     function functionCall(
410         address target,
411         bytes memory data,
412         string memory errorMessage
413     ) internal returns (bytes memory) {
414         return functionCallWithValue(target, data, 0, errorMessage);
415     }
416 
417     /**
418      * @dev Same as {xref-Address-functionCall-address-bytes-}[`functionCall`],
419      * but also transferring `value` wei to `target`.
420      *
421      * Requirements:
422      *
423      * - the calling contract must have an ETH balance of at least `value`.
424      * - the called Solidity function must be `payable`.
425      *
426      * _Available since v3.1._
427      */
428     function functionCallWithValue(
429         address target,
430         bytes memory data,
431         uint256 value
432     ) internal returns (bytes memory) {
433         return functionCallWithValue(target, data, value, "Address: low-level call with value failed");
434     }
435 
436     /**
437      * @dev Same as {xref-Address-functionCallWithValue-address-bytes-uint256-}[`functionCallWithValue`], but
438      * with `errorMessage` as a fallback revert reason when `target` reverts.
439      *
440      * _Available since v3.1._
441      */
442     function functionCallWithValue(
443         address target,
444         bytes memory data,
445         uint256 value,
446         string memory errorMessage
447     ) internal returns (bytes memory) {
448         require(address(this).balance >= value, "Address: insufficient balance for call");
449         require(isContract(target), "Address: call to non-contract");
450 
451         (bool success, bytes memory returndata) = target.call{value: value}(data);
452         return verifyCallResult(success, returndata, errorMessage);
453     }
454 
455     /**
456      * @dev Same as {xref-Address-functionCall-address-bytes-}[`functionCall`],
457      * but performing a static call.
458      *
459      * _Available since v3.3._
460      */
461     function functionStaticCall(address target, bytes memory data) internal view returns (bytes memory) {
462         return functionStaticCall(target, data, "Address: low-level static call failed");
463     }
464 
465     /**
466      * @dev Same as {xref-Address-functionCall-address-bytes-string-}[`functionCall`],
467      * but performing a static call.
468      *
469      * _Available since v3.3._
470      */
471     function functionStaticCall(
472         address target,
473         bytes memory data,
474         string memory errorMessage
475     ) internal view returns (bytes memory) {
476         require(isContract(target), "Address: static call to non-contract");
477 
478         (bool success, bytes memory returndata) = target.staticcall(data);
479         return verifyCallResult(success, returndata, errorMessage);
480     }
481 
482     /**
483      * @dev Same as {xref-Address-functionCall-address-bytes-}[`functionCall`],
484      * but performing a delegate call.
485      *
486      * _Available since v3.4._
487      */
488     function functionDelegateCall(address target, bytes memory data) internal returns (bytes memory) {
489         return functionDelegateCall(target, data, "Address: low-level delegate call failed");
490     }
491 
492     /**
493      * @dev Same as {xref-Address-functionCall-address-bytes-string-}[`functionCall`],
494      * but performing a delegate call.
495      *
496      * _Available since v3.4._
497      */
498     function functionDelegateCall(
499         address target,
500         bytes memory data,
501         string memory errorMessage
502     ) internal returns (bytes memory) {
503         require(isContract(target), "Address: delegate call to non-contract");
504 
505         (bool success, bytes memory returndata) = target.delegatecall(data);
506         return verifyCallResult(success, returndata, errorMessage);
507     }
508 
509     /**
510      * @dev Tool to verifies that a low level call was successful, and revert if it wasn't, either by bubbling the
511      * revert reason using the provided one.
512      *
513      * _Available since v4.3._
514      */
515     function verifyCallResult(
516         bool success,
517         bytes memory returndata,
518         string memory errorMessage
519     ) internal pure returns (bytes memory) {
520         if (success) {
521             return returndata;
522         } else {
523             // Look for revert reason and bubble it up if present
524             if (returndata.length > 0) {
525                 // The easiest way to bubble the revert reason is using memory via assembly
526                 /// @solidity memory-safe-assembly
527                 assembly {
528                     let returndata_size := mload(returndata)
529                     revert(add(32, returndata), returndata_size)
530                 }
531             } else {
532                 revert(errorMessage);
533             }
534         }
535     }
536 }
537 
538 
539 // File @openzeppelin/contracts/utils/Context.sol@v4.7.3
540 
541  
542 // OpenZeppelin Contracts v4.4.1 (utils/Context.sol)
543 
544 
545 /**
546  * @dev Provides information about the current execution context, including the
547  * sender of the transaction and its data. While these are generally available
548  * via msg.sender and msg.data, they should not be accessed in such a direct
549  * manner, since when dealing with meta-transactions the account sending and
550  * paying for execution may not be the actual sender (as far as an application
551  * is concerned).
552  *
553  * This contract is only required for intermediate, library-like contracts.
554  */
555 abstract contract Context {
556     function _msgSender() internal view virtual returns (address) {
557         return msg.sender;
558     }
559 
560     function _msgData() internal view virtual returns (bytes calldata) {
561         return msg.data;
562     }
563 }
564 
565 
566 // File @openzeppelin/contracts/utils/introspection/ERC165.sol@v4.7.3
567 
568  
569 // OpenZeppelin Contracts v4.4.1 (utils/introspection/ERC165.sol)
570 
571 
572 /**
573  * @dev Implementation of the {IERC165} interface.
574  *
575  * Contracts that want to implement ERC165 should inherit from this contract and override {supportsInterface} to check
576  * for the additional interface id that will be supported. For example:
577  *
578  * ```solidity
579  * function supportsInterface(bytes4 interfaceId) public view virtual override returns (bool) {
580  *     return interfaceId == type(MyInterface).interfaceId || super.supportsInterface(interfaceId);
581  * }
582  * ```
583  *
584  * Alternatively, {ERC165Storage} provides an easier to use but more expensive implementation.
585  */
586 abstract contract ERC165 is IERC165 {
587     /**
588      * @dev See {IERC165-supportsInterface}.
589      */
590     function supportsInterface(bytes4 interfaceId) public view virtual override returns (bool) {
591         return interfaceId == type(IERC165).interfaceId;
592     }
593 }
594 
595 
596 // File @openzeppelin/contracts/token/ERC721/ERC721.sol@v4.7.3
597 
598  
599 // OpenZeppelin Contracts (last updated v4.7.0) (token/ERC721/ERC721.sol)
600 
601 
602 /**
603  * @dev Implementation of https://eips.ethereum.org/EIPS/eip-721[ERC721] Non-Fungible Token Standard, including
604  * the Metadata extension, but not including the Enumerable extension, which is available separately as
605  * {ERC721Enumerable}.
606  */
607 contract ERC721 is Context, ERC165, IERC721, IERC721Metadata {
608     using Address for address;
609     using Strings for uint256;
610 
611     // Token name
612     string private _name;
613 
614     // Token symbol
615     string private _symbol;
616 
617     // Mapping from token ID to owner address
618     mapping(uint256 => address) private _owners;
619 
620     // Mapping owner address to token count
621     mapping(address => uint256) private _balances;
622 
623     // Mapping from token ID to approved address
624     mapping(uint256 => address) private _tokenApprovals;
625 
626     // Mapping from owner to operator approvals
627     mapping(address => mapping(address => bool)) private _operatorApprovals;
628 
629     /**
630      * @dev Initializes the contract by setting a `name` and a `symbol` to the token collection.
631      */
632     constructor(string memory name_, string memory symbol_) {
633         _name = name_;
634         _symbol = symbol_;
635     }
636 
637     /**
638      * @dev See {IERC165-supportsInterface}.
639      */
640     function supportsInterface(bytes4 interfaceId) public view virtual override(ERC165, IERC165) returns (bool) {
641         return
642             interfaceId == type(IERC721).interfaceId ||
643             interfaceId == type(IERC721Metadata).interfaceId ||
644             super.supportsInterface(interfaceId);
645     }
646 
647     /**
648      * @dev See {IERC721-balanceOf}.
649      */
650     function balanceOf(address owner) public view virtual override returns (uint256) {
651         require(owner != address(0), "ERC721: address zero is not a valid owner");
652         return _balances[owner];
653     }
654 
655     /**
656      * @dev See {IERC721-ownerOf}.
657      */
658     function ownerOf(uint256 tokenId) public view virtual override returns (address) {
659         address owner = _owners[tokenId];
660         require(owner != address(0), "ERC721: invalid token ID");
661         return owner;
662     }
663 
664     /**
665      * @dev See {IERC721Metadata-name}.
666      */
667     function name() public view virtual override returns (string memory) {
668         return _name;
669     }
670 
671     /**
672      * @dev See {IERC721Metadata-symbol}.
673      */
674     function symbol() public view virtual override returns (string memory) {
675         return _symbol;
676     }
677 
678     /**
679      * @dev See {IERC721Metadata-tokenURI}.
680      */
681     function tokenURI(uint256 tokenId) public view virtual override returns (string memory) {
682         _requireMinted(tokenId);
683 
684         string memory baseURI = _baseURI();
685         return bytes(baseURI).length > 0 ? string(abi.encodePacked(baseURI, tokenId.toString())) : "";
686     }
687 
688     /**
689      * @dev Base URI for computing {tokenURI}. If set, the resulting URI for each
690      * token will be the concatenation of the `baseURI` and the `tokenId`. Empty
691      * by default, can be overridden in child contracts.
692      */
693     function _baseURI() internal view virtual returns (string memory) {
694         return "";
695     }
696 
697     /**
698      * @dev See {IERC721-approve}.
699      */
700     function approve(address to, uint256 tokenId) public virtual override {
701         address owner = ERC721.ownerOf(tokenId);
702         require(to != owner, "ERC721: approval to current owner");
703 
704         require(
705             _msgSender() == owner || isApprovedForAll(owner, _msgSender()),
706             "ERC721: approve caller is not token owner nor approved for all"
707         );
708 
709         _approve(to, tokenId);
710     }
711 
712     /**
713      * @dev See {IERC721-getApproved}.
714      */
715     function getApproved(uint256 tokenId) public view virtual override returns (address) {
716         _requireMinted(tokenId);
717 
718         return _tokenApprovals[tokenId];
719     }
720 
721     /**
722      * @dev See {IERC721-setApprovalForAll}.
723      */
724     function setApprovalForAll(address operator, bool approved) public virtual override {
725         _setApprovalForAll(_msgSender(), operator, approved);
726     }
727 
728     /**
729      * @dev See {IERC721-isApprovedForAll}.
730      */
731     function isApprovedForAll(address owner, address operator) public view virtual override returns (bool) {
732         return _operatorApprovals[owner][operator];
733     }
734 
735     /**
736      * @dev See {IERC721-transferFrom}.
737      */
738     function transferFrom(
739         address from,
740         address to,
741         uint256 tokenId
742     ) public virtual override {
743         //solhint-disable-next-line max-line-length
744         require(_isApprovedOrOwner(_msgSender(), tokenId), "ERC721: caller is not token owner nor approved");
745 
746         _transfer(from, to, tokenId);
747     }
748 
749     /**
750      * @dev See {IERC721-safeTransferFrom}.
751      */
752     function safeTransferFrom(
753         address from,
754         address to,
755         uint256 tokenId
756     ) public virtual override {
757         safeTransferFrom(from, to, tokenId, "");
758     }
759 
760     /**
761      * @dev See {IERC721-safeTransferFrom}.
762      */
763     function safeTransferFrom(
764         address from,
765         address to,
766         uint256 tokenId,
767         bytes memory data
768     ) public virtual override {
769         require(_isApprovedOrOwner(_msgSender(), tokenId), "ERC721: caller is not token owner nor approved");
770         _safeTransfer(from, to, tokenId, data);
771     }
772 
773     /**
774      * @dev Safely transfers `tokenId` token from `from` to `to`, checking first that contract recipients
775      * are aware of the ERC721 protocol to prevent tokens from being forever locked.
776      *
777      * `data` is additional data, it has no specified format and it is sent in call to `to`.
778      *
779      * This internal function is equivalent to {safeTransferFrom}, and can be used to e.g.
780      * implement alternative mechanisms to perform token transfer, such as signature-based.
781      *
782      * Requirements:
783      *
784      * - `from` cannot be the zero address.
785      * - `to` cannot be the zero address.
786      * - `tokenId` token must exist and be owned by `from`.
787      * - If `to` refers to a smart contract, it must implement {IERC721Receiver-onERC721Received}, which is called upon a safe transfer.
788      *
789      * Emits a {Transfer} event.
790      */
791     function _safeTransfer(
792         address from,
793         address to,
794         uint256 tokenId,
795         bytes memory data
796     ) internal virtual {
797         _transfer(from, to, tokenId);
798         require(_checkOnERC721Received(from, to, tokenId, data), "ERC721: transfer to non ERC721Receiver implementer");
799     }
800 
801     /**
802      * @dev Returns whether `tokenId` exists.
803      *
804      * Tokens can be managed by their owner or approved accounts via {approve} or {setApprovalForAll}.
805      *
806      * Tokens start existing when they are minted (`_mint`),
807      * and stop existing when they are burned (`_burn`).
808      */
809     function _exists(uint256 tokenId) internal view virtual returns (bool) {
810         return _owners[tokenId] != address(0);
811     }
812 
813     /**
814      * @dev Returns whether `spender` is allowed to manage `tokenId`.
815      *
816      * Requirements:
817      *
818      * - `tokenId` must exist.
819      */
820     function _isApprovedOrOwner(address spender, uint256 tokenId) internal view virtual returns (bool) {
821         address owner = ERC721.ownerOf(tokenId);
822         return (spender == owner || isApprovedForAll(owner, spender) || getApproved(tokenId) == spender);
823     }
824 
825     /**
826      * @dev Safely mints `tokenId` and transfers it to `to`.
827      *
828      * Requirements:
829      *
830      * - `tokenId` must not exist.
831      * - If `to` refers to a smart contract, it must implement {IERC721Receiver-onERC721Received}, which is called upon a safe transfer.
832      *
833      * Emits a {Transfer} event.
834      */
835     function _safeMint(address to, uint256 tokenId) internal virtual {
836         _safeMint(to, tokenId, "");
837     }
838 
839     /**
840      * @dev Same as {xref-ERC721-_safeMint-address-uint256-}[`_safeMint`], with an additional `data` parameter which is
841      * forwarded in {IERC721Receiver-onERC721Received} to contract recipients.
842      */
843     function _safeMint(
844         address to,
845         uint256 tokenId,
846         bytes memory data
847     ) internal virtual {
848         _mint(to, tokenId);
849         require(
850             _checkOnERC721Received(address(0), to, tokenId, data),
851             "ERC721: transfer to non ERC721Receiver implementer"
852         );
853     }
854 
855     /**
856      * @dev Mints `tokenId` and transfers it to `to`.
857      *
858      * WARNING: Usage of this method is discouraged, use {_safeMint} whenever possible
859      *
860      * Requirements:
861      *
862      * - `tokenId` must not exist.
863      * - `to` cannot be the zero address.
864      *
865      * Emits a {Transfer} event.
866      */
867     function _mint(address to, uint256 tokenId) internal virtual {
868         require(to != address(0), "ERC721: mint to the zero address");
869         require(!_exists(tokenId), "ERC721: token already minted");
870 
871         _beforeTokenTransfer(address(0), to, tokenId);
872 
873         _balances[to] += 1;
874         _owners[tokenId] = to;
875 
876         emit Transfer(address(0), to, tokenId);
877 
878         _afterTokenTransfer(address(0), to, tokenId);
879     }
880 
881     /**
882      * @dev Destroys `tokenId`.
883      * The approval is cleared when the token is burned.
884      *
885      * Requirements:
886      *
887      * - `tokenId` must exist.
888      *
889      * Emits a {Transfer} event.
890      */
891     function _burn(uint256 tokenId) internal virtual {
892         address owner = ERC721.ownerOf(tokenId);
893 
894         _beforeTokenTransfer(owner, address(0), tokenId);
895 
896         // Clear approvals
897         _approve(address(0), tokenId);
898 
899         _balances[owner] -= 1;
900         delete _owners[tokenId];
901 
902         emit Transfer(owner, address(0), tokenId);
903 
904         _afterTokenTransfer(owner, address(0), tokenId);
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
923         require(ERC721.ownerOf(tokenId) == from, "ERC721: transfer from incorrect owner");
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
936 
937         _afterTokenTransfer(from, to, tokenId);
938     }
939 
940     /**
941      * @dev Approve `to` to operate on `tokenId`
942      *
943      * Emits an {Approval} event.
944      */
945     function _approve(address to, uint256 tokenId) internal virtual {
946         _tokenApprovals[tokenId] = to;
947         emit Approval(ERC721.ownerOf(tokenId), to, tokenId);
948     }
949 
950     /**
951      * @dev Approve `operator` to operate on all of `owner` tokens
952      *
953      * Emits an {ApprovalForAll} event.
954      */
955     function _setApprovalForAll(
956         address owner,
957         address operator,
958         bool approved
959     ) internal virtual {
960         require(owner != operator, "ERC721: approve to caller");
961         _operatorApprovals[owner][operator] = approved;
962         emit ApprovalForAll(owner, operator, approved);
963     }
964 
965     /**
966      * @dev Reverts if the `tokenId` has not been minted yet.
967      */
968     function _requireMinted(uint256 tokenId) internal view virtual {
969         require(_exists(tokenId), "ERC721: invalid token ID");
970     }
971 
972     /**
973      * @dev Internal function to invoke {IERC721Receiver-onERC721Received} on a target address.
974      * The call is not executed if the target address is not a contract.
975      *
976      * @param from address representing the previous owner of the given token ID
977      * @param to target address that will receive the tokens
978      * @param tokenId uint256 ID of the token to be transferred
979      * @param data bytes optional data to send along with the call
980      * @return bool whether the call correctly returned the expected magic value
981      */
982     function _checkOnERC721Received(
983         address from,
984         address to,
985         uint256 tokenId,
986         bytes memory data
987     ) private returns (bool) {
988         if (to.isContract()) {
989             try IERC721Receiver(to).onERC721Received(_msgSender(), from, tokenId, data) returns (bytes4 retval) {
990                 return retval == IERC721Receiver.onERC721Received.selector;
991             } catch (bytes memory reason) {
992                 if (reason.length == 0) {
993                     revert("ERC721: transfer to non ERC721Receiver implementer");
994                 } else {
995                     /// @solidity memory-safe-assembly
996                     assembly {
997                         revert(add(32, reason), mload(reason))
998                     }
999                 }
1000             }
1001         } else {
1002             return true;
1003         }
1004     }
1005 
1006     /**
1007      * @dev Hook that is called before any token transfer. This includes minting
1008      * and burning.
1009      *
1010      * Calling conditions:
1011      *
1012      * - When `from` and `to` are both non-zero, ``from``'s `tokenId` will be
1013      * transferred to `to`.
1014      * - When `from` is zero, `tokenId` will be minted for `to`.
1015      * - When `to` is zero, ``from``'s `tokenId` will be burned.
1016      * - `from` and `to` are never both zero.
1017      *
1018      * To learn more about hooks, head to xref:ROOT:extending-contracts.adoc#using-hooks[Using Hooks].
1019      */
1020     function _beforeTokenTransfer(
1021         address from,
1022         address to,
1023         uint256 tokenId
1024     ) internal virtual {}
1025 
1026     /**
1027      * @dev Hook that is called after any transfer of tokens. This includes
1028      * minting and burning.
1029      *
1030      * Calling conditions:
1031      *
1032      * - when `from` and `to` are both non-zero.
1033      * - `from` and `to` are never both zero.
1034      *
1035      * To learn more about hooks, head to xref:ROOT:extending-contracts.adoc#using-hooks[Using Hooks].
1036      */
1037     function _afterTokenTransfer(
1038         address from,
1039         address to,
1040         uint256 tokenId
1041     ) internal virtual {}
1042 }
1043 
1044 
1045 // File @openzeppelin/contracts/token/ERC721/extensions/ERC721Burnable.sol@v4.7.3
1046 
1047  
1048 // OpenZeppelin Contracts (last updated v4.7.0) (token/ERC721/extensions/ERC721Burnable.sol)
1049 
1050 
1051 
1052 /**
1053  * @title ERC721 Burnable Token
1054  * @dev ERC721 Token that can be burned (destroyed).
1055  */
1056 abstract contract ERC721Burnable is Context, ERC721 {
1057     /**
1058      * @dev Burns `tokenId`. See {ERC721-_burn}.
1059      *
1060      * Requirements:
1061      *
1062      * - The caller must own `tokenId` or be an approved operator.
1063      */
1064     function burn(uint256 tokenId) public virtual {
1065         //solhint-disable-next-line max-line-length
1066         require(_isApprovedOrOwner(_msgSender(), tokenId), "ERC721: caller is not token owner nor approved");
1067         _burn(tokenId);
1068     }
1069 }
1070 
1071 
1072 // File @openzeppelin/contracts/access/Ownable.sol@v4.7.3
1073 
1074  
1075 // OpenZeppelin Contracts (last updated v4.7.0) (access/Ownable.sol)
1076 
1077 
1078 /**
1079  * @dev Contract module which provides a basic access control mechanism, where
1080  * there is an account (an owner) that can be granted exclusive access to
1081  * specific functions.
1082  *
1083  * By default, the owner account will be the one that deploys the contract. This
1084  * can later be changed with {transferOwnership}.
1085  *
1086  * This module is used through inheritance. It will make available the modifier
1087  * `onlyOwner`, which can be applied to your functions to restrict their use to
1088  * the owner.
1089  */
1090 abstract contract Ownable is Context {
1091     address private _owner;
1092 
1093     event OwnershipTransferred(address indexed previousOwner, address indexed newOwner);
1094 
1095     /**
1096      * @dev Initializes the contract setting the deployer as the initial owner.
1097      */
1098     constructor() {
1099         _transferOwnership(_msgSender());
1100     }
1101 
1102     /**
1103      * @dev Throws if called by any account other than the owner.
1104      */
1105     modifier onlyOwner() {
1106         _checkOwner();
1107         _;
1108     }
1109 
1110     /**
1111      * @dev Returns the address of the current owner.
1112      */
1113     function owner() public view virtual returns (address) {
1114         return _owner;
1115     }
1116 
1117     /**
1118      * @dev Throws if the sender is not the owner.
1119      */
1120     function _checkOwner() internal view virtual {
1121         require(owner() == _msgSender(), "Ownable: caller is not the owner");
1122     }
1123 
1124     /**
1125      * @dev Leaves the contract without owner. It will not be possible to call
1126      * `onlyOwner` functions anymore. Can only be called by the current owner.
1127      *
1128      * NOTE: Renouncing ownership will leave the contract without an owner,
1129      * thereby removing any functionality that is only available to the owner.
1130      */
1131     function renounceOwnership() public virtual onlyOwner {
1132         _transferOwnership(address(0));
1133     }
1134 
1135     /**
1136      * @dev Transfers ownership of the contract to a new account (`newOwner`).
1137      * Can only be called by the current owner.
1138      */
1139     function transferOwnership(address newOwner) public virtual onlyOwner {
1140         require(newOwner != address(0), "Ownable: new owner is the zero address");
1141         _transferOwnership(newOwner);
1142     }
1143 
1144     /**
1145      * @dev Transfers ownership of the contract to a new account (`newOwner`).
1146      * Internal function without access restriction.
1147      */
1148     function _transferOwnership(address newOwner) internal virtual {
1149         address oldOwner = _owner;
1150         _owner = newOwner;
1151         emit OwnershipTransferred(oldOwner, newOwner);
1152     }
1153 }
1154 
1155 
1156 // File @openzeppelin/contracts/utils/cryptography/MerkleProof.sol@v4.7.3
1157 
1158  
1159 // OpenZeppelin Contracts (last updated v4.7.0) (utils/cryptography/MerkleProof.sol)
1160 
1161 
1162 /**
1163  * @dev These functions deal with verification of Merkle Tree proofs.
1164  *
1165  * The proofs can be generated using the JavaScript library
1166  * https://github.com/miguelmota/merkletreejs[merkletreejs].
1167  * Note: the hashing algorithm should be keccak256 and pair sorting should be enabled.
1168  *
1169  * See `test/utils/cryptography/MerkleProof.test.js` for some examples.
1170  *
1171  * WARNING: You should avoid using leaf values that are 64 bytes long prior to
1172  * hashing, or use a hash function other than keccak256 for hashing leaves.
1173  * This is because the concatenation of a sorted pair of internal nodes in
1174  * the merkle tree could be reinterpreted as a leaf value.
1175  */
1176 library MerkleProof {
1177     /**
1178      * @dev Returns true if a `leaf` can be proved to be a part of a Merkle tree
1179      * defined by `root`. For this, a `proof` must be provided, containing
1180      * sibling hashes on the branch from the leaf to the root of the tree. Each
1181      * pair of leaves and each pair of pre-images are assumed to be sorted.
1182      */
1183     function verify(
1184         bytes32[] memory proof,
1185         bytes32 root,
1186         bytes32 leaf
1187     ) internal pure returns (bool) {
1188         return processProof(proof, leaf) == root;
1189     }
1190 
1191     /**
1192      * @dev Calldata version of {verify}
1193      *
1194      * _Available since v4.7._
1195      */
1196     function verifyCalldata(
1197         bytes32[] calldata proof,
1198         bytes32 root,
1199         bytes32 leaf
1200     ) internal pure returns (bool) {
1201         return processProofCalldata(proof, leaf) == root;
1202     }
1203 
1204     /**
1205      * @dev Returns the rebuilt hash obtained by traversing a Merkle tree up
1206      * from `leaf` using `proof`. A `proof` is valid if and only if the rebuilt
1207      * hash matches the root of the tree. When processing the proof, the pairs
1208      * of leafs & pre-images are assumed to be sorted.
1209      *
1210      * _Available since v4.4._
1211      */
1212     function processProof(bytes32[] memory proof, bytes32 leaf) internal pure returns (bytes32) {
1213         bytes32 computedHash = leaf;
1214         for (uint256 i = 0; i < proof.length; i++) {
1215             computedHash = _hashPair(computedHash, proof[i]);
1216         }
1217         return computedHash;
1218     }
1219 
1220     /**
1221      * @dev Calldata version of {processProof}
1222      *
1223      * _Available since v4.7._
1224      */
1225     function processProofCalldata(bytes32[] calldata proof, bytes32 leaf) internal pure returns (bytes32) {
1226         bytes32 computedHash = leaf;
1227         for (uint256 i = 0; i < proof.length; i++) {
1228             computedHash = _hashPair(computedHash, proof[i]);
1229         }
1230         return computedHash;
1231     }
1232 
1233     /**
1234      * @dev Returns true if the `leaves` can be proved to be a part of a Merkle tree defined by
1235      * `root`, according to `proof` and `proofFlags` as described in {processMultiProof}.
1236      *
1237      * _Available since v4.7._
1238      */
1239     function multiProofVerify(
1240         bytes32[] memory proof,
1241         bool[] memory proofFlags,
1242         bytes32 root,
1243         bytes32[] memory leaves
1244     ) internal pure returns (bool) {
1245         return processMultiProof(proof, proofFlags, leaves) == root;
1246     }
1247 
1248     /**
1249      * @dev Calldata version of {multiProofVerify}
1250      *
1251      * _Available since v4.7._
1252      */
1253     function multiProofVerifyCalldata(
1254         bytes32[] calldata proof,
1255         bool[] calldata proofFlags,
1256         bytes32 root,
1257         bytes32[] memory leaves
1258     ) internal pure returns (bool) {
1259         return processMultiProofCalldata(proof, proofFlags, leaves) == root;
1260     }
1261 
1262     /**
1263      * @dev Returns the root of a tree reconstructed from `leaves` and the sibling nodes in `proof`,
1264      * consuming from one or the other at each step according to the instructions given by
1265      * `proofFlags`.
1266      *
1267      * _Available since v4.7._
1268      */
1269     function processMultiProof(
1270         bytes32[] memory proof,
1271         bool[] memory proofFlags,
1272         bytes32[] memory leaves
1273     ) internal pure returns (bytes32 merkleRoot) {
1274         // This function rebuild the root hash by traversing the tree up from the leaves. The root is rebuilt by
1275         // consuming and producing values on a queue. The queue starts with the `leaves` array, then goes onto the
1276         // `hashes` array. At the end of the process, the last hash in the `hashes` array should contain the root of
1277         // the merkle tree.
1278         uint256 leavesLen = leaves.length;
1279         uint256 totalHashes = proofFlags.length;
1280 
1281         // Check proof validity.
1282         require(leavesLen + proof.length - 1 == totalHashes, "MerkleProof: invalid multiproof");
1283 
1284         // The xxxPos values are "pointers" to the next value to consume in each array. All accesses are done using
1285         // `xxx[xxxPos++]`, which return the current value and increment the pointer, thus mimicking a queue's "pop".
1286         bytes32[] memory hashes = new bytes32[](totalHashes);
1287         uint256 leafPos = 0;
1288         uint256 hashPos = 0;
1289         uint256 proofPos = 0;
1290         // At each step, we compute the next hash using two values:
1291         // - a value from the "main queue". If not all leaves have been consumed, we get the next leaf, otherwise we
1292         //   get the next hash.
1293         // - depending on the flag, either another value for the "main queue" (merging branches) or an element from the
1294         //   `proof` array.
1295         for (uint256 i = 0; i < totalHashes; i++) {
1296             bytes32 a = leafPos < leavesLen ? leaves[leafPos++] : hashes[hashPos++];
1297             bytes32 b = proofFlags[i] ? leafPos < leavesLen ? leaves[leafPos++] : hashes[hashPos++] : proof[proofPos++];
1298             hashes[i] = _hashPair(a, b);
1299         }
1300 
1301         if (totalHashes > 0) {
1302             return hashes[totalHashes - 1];
1303         } else if (leavesLen > 0) {
1304             return leaves[0];
1305         } else {
1306             return proof[0];
1307         }
1308     }
1309 
1310     /**
1311      * @dev Calldata version of {processMultiProof}
1312      *
1313      * _Available since v4.7._
1314      */
1315     function processMultiProofCalldata(
1316         bytes32[] calldata proof,
1317         bool[] calldata proofFlags,
1318         bytes32[] memory leaves
1319     ) internal pure returns (bytes32 merkleRoot) {
1320         // This function rebuild the root hash by traversing the tree up from the leaves. The root is rebuilt by
1321         // consuming and producing values on a queue. The queue starts with the `leaves` array, then goes onto the
1322         // `hashes` array. At the end of the process, the last hash in the `hashes` array should contain the root of
1323         // the merkle tree.
1324         uint256 leavesLen = leaves.length;
1325         uint256 totalHashes = proofFlags.length;
1326 
1327         // Check proof validity.
1328         require(leavesLen + proof.length - 1 == totalHashes, "MerkleProof: invalid multiproof");
1329 
1330         // The xxxPos values are "pointers" to the next value to consume in each array. All accesses are done using
1331         // `xxx[xxxPos++]`, which return the current value and increment the pointer, thus mimicking a queue's "pop".
1332         bytes32[] memory hashes = new bytes32[](totalHashes);
1333         uint256 leafPos = 0;
1334         uint256 hashPos = 0;
1335         uint256 proofPos = 0;
1336         // At each step, we compute the next hash using two values:
1337         // - a value from the "main queue". If not all leaves have been consumed, we get the next leaf, otherwise we
1338         //   get the next hash.
1339         // - depending on the flag, either another value for the "main queue" (merging branches) or an element from the
1340         //   `proof` array.
1341         for (uint256 i = 0; i < totalHashes; i++) {
1342             bytes32 a = leafPos < leavesLen ? leaves[leafPos++] : hashes[hashPos++];
1343             bytes32 b = proofFlags[i] ? leafPos < leavesLen ? leaves[leafPos++] : hashes[hashPos++] : proof[proofPos++];
1344             hashes[i] = _hashPair(a, b);
1345         }
1346 
1347         if (totalHashes > 0) {
1348             return hashes[totalHashes - 1];
1349         } else if (leavesLen > 0) {
1350             return leaves[0];
1351         } else {
1352             return proof[0];
1353         }
1354     }
1355 
1356     function _hashPair(bytes32 a, bytes32 b) private pure returns (bytes32) {
1357         return a < b ? _efficientHash(a, b) : _efficientHash(b, a);
1358     }
1359 
1360     function _efficientHash(bytes32 a, bytes32 b) private pure returns (bytes32 value) {
1361         /// @solidity memory-safe-assembly
1362         assembly {
1363             mstore(0x00, a)
1364             mstore(0x20, b)
1365             value := keccak256(0x00, 0x40)
1366         }
1367     }
1368 }
1369 
1370 
1371 // File contracts/CountersWithSet.sol
1372 
1373 
1374 /**
1375  * @title CountersWithSet
1376  * @author modified from Matt Condon (@shrugs)
1377  * @dev Provides counters that can only be incremented or decremented by one. This can be used e.g. to track the number
1378  * of elements in a mapping, issuing ERC721 ids, or counting request ids.
1379  *
1380  * Include with `using Counters for Counters.Counter;`
1381  */
1382 library CountersWithSet {
1383     struct Counter {
1384         // This variable should never be directly accessed by users of the library: interactions must be restricted to
1385         // the library's function. As of Solidity v0.5.2, this cannot be enforced, though there is a proposal to add
1386         // this feature: see https://github.com/ethereum/solidity/issues/4637
1387         uint256 _value; // default: 0
1388     }
1389 
1390     function current(Counter storage counter) internal view returns (uint256) {
1391         return counter._value;
1392     }
1393 
1394     function increment(Counter storage counter) internal {
1395         unchecked {
1396             counter._value += 1;
1397         }
1398     }
1399 
1400     function decrement(Counter storage counter) internal {
1401         uint256 value = counter._value;
1402         require(value > 0, "Counter: decrement overflow");
1403         unchecked {
1404             counter._value = value - 1;
1405         }
1406     }
1407     
1408     function setValue(Counter storage counter, uint256 newValue) internal {
1409         require(newValue > 0, "Counter: insufficient value");
1410         counter._value = newValue;
1411     }
1412 }
1413 
1414 
1415 // File contracts/PenNFT.sol
1416 
1417 contract AtemPen is Ownable, ERC721Burnable {
1418     using Strings for uint256;
1419 
1420     using CountersWithSet for CountersWithSet.Counter;
1421     CountersWithSet.Counter private _supplyTracker;
1422 
1423     string private _baseTokenURI;
1424     bytes32 public whitelistRoot;
1425     
1426     uint256 immutable public maxSupply;
1427     uint256 immutable public maxClaimNum;
1428     mapping(address => uint256) _claimedNum;
1429     
1430     // numWhitelist + <num_of_public_sale> + numReserved = maxSupply
1431     // Minting is opened first for only whitelisted addresses. 
1432     // After the whitelist phrase is finished, public sale is opened. All the remaining un-reserved NFTs are available for public sale.
1433     bool public whitelistSale;
1434     bool public publicSale;
1435 
1436     uint256 public numWhitelist;
1437     uint256 public numReserved;
1438 
1439     uint256 private _priceWhitelist; 
1440     uint256 private _pricePublic;
1441 
1442     // Payment address
1443     address public platformFeeAccount;
1444 
1445 
1446     constructor(
1447         string memory name, 
1448         string memory symbol, 
1449         string memory baseTokenURI_,
1450         uint256 supply, 
1451         uint256 whitelistNum, 
1452         uint256 reservedNum, 
1453         uint256 whitelistPrice_, 
1454         uint256 publicPrice_,
1455         uint256 maxClaimNum_,
1456         address platformAccount,
1457         bytes32 merkleroot)
1458     ERC721(name, symbol)
1459     { 
1460         _baseTokenURI = baseTokenURI_;
1461 
1462         whitelistRoot = merkleroot;
1463         maxSupply = supply;
1464 
1465         whitelistSale = false;
1466         publicSale = false;
1467 
1468         numWhitelist = whitelistNum;
1469         numReserved = reservedNum;
1470 
1471         _priceWhitelist = whitelistPrice_;
1472         _pricePublic = publicPrice_;
1473 
1474         maxClaimNum = maxClaimNum_;
1475 
1476         platformFeeAccount = platformAccount;
1477     }
1478 
1479     function _baseURI() internal view virtual override(ERC721) returns (string memory) {
1480         return _baseTokenURI;
1481     }
1482 
1483     /** Receive and withdraw */
1484 
1485     receive() external payable { }
1486 
1487     function _withdraw(address _address, uint256 _amount) private {
1488         if ((_address != address(0)) && (_address != address(this)) && (_amount > 0)) {
1489             (bool success, ) = _address.call{value: _amount}("");
1490             require(success, "Transfer failed.");
1491         }
1492     }
1493 
1494     function withdrawAll() external onlyOwner {
1495         _withdraw(platformFeeAccount, address(this).balance);
1496     }
1497     function withdraw(uint256 amount) external onlyOwner {
1498         require(address(this).balance >= amount);
1499         _withdraw(platformFeeAccount, amount);
1500     }
1501 
1502     /** Mint helpers */
1503 
1504     function _safeMint(address to, uint256 tokenId) internal override {
1505         _safeMint(to, tokenId, "");
1506     }
1507 
1508     function _safeMint(address to, uint256 tokenId, bytes memory _data) internal override {
1509         require(_supplyTracker.current() + numReserved < maxSupply, "ATEMPen#_safeMint: sold out");
1510         super._safeMint(to, tokenId, _data);
1511         _supplyTracker.increment();
1512     }
1513 
1514     /** Mint interfaces */
1515 
1516     function mint(address to) onlyOwner external {
1517         // We cannot just use balanceOf to create the new tokenId because tokens
1518         // can be burned (destroyed), so we need a separate counter.
1519         _safeMint(to, _supplyTracker.current());
1520     }
1521 
1522     function whitelistMint(address to, bytes32[] calldata proof)
1523     external payable
1524     {
1525         require(whitelistSale, "ATEMPen#whitelistMint: whitelist mint is not opening");
1526         require(_supplyTracker.current() < numWhitelist , "ATEMPen#whitelistMint: whitelist sold out");
1527 
1528         require(_verify(_leaf(to), proof), "ATEMPen#whitelistMint: invalid merkle proof");
1529         require(checkClaimable(to, 1), "ATEMPen#whitelistMint: reached your maximum claimable number");
1530 
1531         require(
1532             whitelistPrice(1) == msg.value,
1533             " ATEMPen#whitelistMint: incorrect payment value"
1534         );
1535 
1536         _safeMint(to, _supplyTracker.current());
1537         _claimedNum[to] += 1;
1538     }
1539 
1540     function whitelistMintBatch(address to, uint256 amount, bytes32[] calldata proof)
1541     external payable
1542     {
1543         require(whitelistSale, "ATEMPen#whitelistMintBatch: whitelist mint is not opening");
1544         require(amount > 0, "ATEMPen#whiteMintBatch: invalid amount");
1545 
1546         require(_verify(_leaf(to), proof), "ATEMPen#whitelistMintBatch: invalid merkle proof");
1547         require(checkClaimable(to, amount), "ATEMPen#whitelistMintBatch: reached your maximum claimable number");
1548 
1549         uint256 _currentSupply = _supplyTracker.current();
1550         uint256 _targetSupply = _currentSupply + amount;
1551 
1552         require(_targetSupply <= numWhitelist, "ATEMPen#whitelistMintBatch: amount exceeds whitelist supply");
1553         require(
1554             whitelistPrice(amount) == msg.value,
1555             " ATEMPen#whitelistMintBatch: incorrect payment value"
1556         );
1557 
1558         while (_currentSupply < _targetSupply) {
1559             super._safeMint(to, _currentSupply, "");
1560             unchecked {
1561                 _currentSupply += 1;
1562             }
1563         }
1564 
1565         _supplyTracker.setValue(_currentSupply);
1566         _claimedNum[to] += amount;
1567     }
1568 
1569     function publicMint(address to)
1570     external payable
1571     {
1572         require(publicSale, "ATEMPen#publicMint: public sale is not opening");
1573 
1574         require(
1575             publicPrice(1) == msg.value,
1576             " ATEMPen#publicMint: incorrect payment value"
1577         );
1578 
1579         _safeMint(to, _supplyTracker.current());
1580     }
1581 
1582     function publicMintBatch(address to, uint256 amount)
1583     external payable
1584     {
1585         require(publicSale, "ATEMPen#publicMintBatch: public sale is not opening");
1586         require(amount > 0, "ATEMPen#publicMintBatch: invalid amount");
1587 
1588         uint256 _currentSupply = _supplyTracker.current();
1589         uint256 _targetSupply = _currentSupply + amount;
1590 
1591         require(_targetSupply + numReserved <= maxSupply, "ATEMPen#publicMintBatch: amount exceeds supply");
1592         require(
1593             publicPrice(amount) == msg.value,
1594             " ATEMPen#publicMintBatch: incorrect payment value"
1595         );
1596 
1597         while (_currentSupply < _targetSupply) {
1598             super._safeMint(to, _currentSupply, "");
1599             unchecked {
1600                 _currentSupply += 1;
1601             }
1602         }
1603 
1604         _supplyTracker.setValue(_currentSupply);
1605     }
1606 
1607     /** Merkle tree helpers */
1608     
1609     function _leaf(address account)
1610     internal pure returns (bytes32)
1611     {
1612         return keccak256(abi.encodePacked(account));
1613     }
1614 
1615     function _verify(bytes32 leaf, bytes32[] memory proof)
1616     internal view returns (bool)
1617     {
1618         return MerkleProof.verify(proof, whitelistRoot, leaf);
1619     }
1620 
1621     /** Setters */ 
1622 
1623     function setMerkleRoot(bytes32 newRoot) onlyOwner external {
1624         whitelistRoot = newRoot;
1625     }
1626 
1627     function setBaseTokenURI(string calldata newBaseURI) onlyOwner external {
1628         _baseTokenURI = newBaseURI;
1629     }
1630 
1631     function setPlatformFeeAccount(address account) onlyOwner external {
1632         platformFeeAccount = account;
1633     }
1634 
1635     function openWhitelistSale() onlyOwner external {
1636         require(!whitelistSale, "ATEMPen#openWhitelistSale: whitelist sale already opened");
1637         whitelistSale = true;
1638     }
1639 
1640     function closeWhitelistSale() onlyOwner external {
1641         require(whitelistSale, "ATEMPen#closeWhitelistSale: whitelist sale already closed");
1642         whitelistSale = false;
1643     }
1644 
1645     function openPublicSale() onlyOwner external {
1646         require(!publicSale, "ATEMPen#openPublicSale: public sale already opened");
1647         publicSale = true;
1648     }
1649 
1650     function closePublicSale() onlyOwner external {
1651         require(publicSale, "ATEMPen#closePublicSale: public sale already closed");
1652         publicSale = false;
1653     }
1654 
1655     function setNumWhitelist(uint256 value) onlyOwner external {
1656         numWhitelist = value;
1657     }
1658 
1659     function setNumReserved(uint256 value) onlyOwner external {
1660         numReserved = value;
1661     }
1662 
1663     function setWhitelistPrice(uint256 value) onlyOwner external {
1664         _priceWhitelist = value;
1665     }
1666 
1667     function setPublicPrice(uint256 value) onlyOwner external {
1668         _pricePublic = value;
1669     }
1670 
1671     /** Viewers */
1672 
1673     function checkClaimable(address account, uint256 amount) public view returns (bool) {
1674         return _claimedNum[account] + amount <= maxClaimNum;
1675     }
1676 
1677     function claimedNum(address account) public view returns (uint256) {
1678         return _claimedNum[account];
1679     }
1680 
1681 
1682     function currentSupply() public view returns (uint256) {
1683         return _supplyTracker.current();
1684     }
1685 
1686     function whitelistPrice(uint256 amount) public view returns (uint256) {
1687         require(amount > 0, "ATEMPen#whitelistPrice: invalid amount");
1688         return _priceWhitelist * amount;
1689     }
1690 
1691     function publicPrice(uint256 amount) public view returns (uint256) {
1692         require(amount > 0, "ATEMPen#publicPrice: invalid amount");
1693         return _pricePublic * amount;
1694     }
1695 
1696     /** ---  */
1697 
1698     function _beforeTokenTransfer(address from, address to, uint256 tokenId) internal virtual override(ERC721) {
1699         super._beforeTokenTransfer(from, to, tokenId);
1700     }
1701 
1702     function supportsInterface(bytes4 interfaceId) public view virtual override(ERC721) returns (bool) {
1703         return super.supportsInterface(interfaceId);
1704     }
1705 
1706     function tokenURI(uint256 tokenId) public view virtual override returns (string memory) {
1707         _requireMinted(tokenId);
1708 
1709         string memory baseURI = _baseURI();
1710         return bytes(baseURI).length > 0 ? string(abi.encodePacked(baseURI, tokenId.toString(), ".json")) : "";
1711     }
1712 }