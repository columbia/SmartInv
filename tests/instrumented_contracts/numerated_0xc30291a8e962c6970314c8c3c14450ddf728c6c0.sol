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
31 // OpenZeppelin Contracts (last updated v4.7.0) (token/ERC721/IERC721.sol)
32 
33 pragma solidity ^0.8.0;
34 
35 /**
36  * @dev Required interface of an ERC721 compliant contract.
37  */
38 interface IERC721 is IERC165 {
39     /**
40      * @dev Emitted when `tokenId` token is transferred from `from` to `to`.
41      */
42     event Transfer(address indexed from, address indexed to, uint256 indexed tokenId);
43 
44     /**
45      * @dev Emitted when `owner` enables `approved` to manage the `tokenId` token.
46      */
47     event Approval(address indexed owner, address indexed approved, uint256 indexed tokenId);
48 
49     /**
50      * @dev Emitted when `owner` enables or disables (`approved`) `operator` to manage all of its assets.
51      */
52     event ApprovalForAll(address indexed owner, address indexed operator, bool approved);
53 
54     /**
55      * @dev Returns the number of tokens in ``owner``'s account.
56      */
57     function balanceOf(address owner) external view returns (uint256 balance);
58 
59     /**
60      * @dev Returns the owner of the `tokenId` token.
61      *
62      * Requirements:
63      *
64      * - `tokenId` must exist.
65      */
66     function ownerOf(uint256 tokenId) external view returns (address owner);
67 
68     /**
69      * @dev Safely transfers `tokenId` token from `from` to `to`.
70      *
71      * Requirements:
72      *
73      * - `from` cannot be the zero address.
74      * - `to` cannot be the zero address.
75      * - `tokenId` token must exist and be owned by `from`.
76      * - If the caller is not `from`, it must be approved to move this token by either {approve} or {setApprovalForAll}.
77      * - If `to` refers to a smart contract, it must implement {IERC721Receiver-onERC721Received}, which is called upon a safe transfer.
78      *
79      * Emits a {Transfer} event.
80      */
81     function safeTransferFrom(
82         address from,
83         address to,
84         uint256 tokenId,
85         bytes calldata data
86     ) external;
87 
88     /**
89      * @dev Safely transfers `tokenId` token from `from` to `to`, checking first that contract recipients
90      * are aware of the ERC721 protocol to prevent tokens from being forever locked.
91      *
92      * Requirements:
93      *
94      * - `from` cannot be the zero address.
95      * - `to` cannot be the zero address.
96      * - `tokenId` token must exist and be owned by `from`.
97      * - If the caller is not `from`, it must have been allowed to move this token by either {approve} or {setApprovalForAll}.
98      * - If `to` refers to a smart contract, it must implement {IERC721Receiver-onERC721Received}, which is called upon a safe transfer.
99      *
100      * Emits a {Transfer} event.
101      */
102     function safeTransferFrom(
103         address from,
104         address to,
105         uint256 tokenId
106     ) external;
107 
108     /**
109      * @dev Transfers `tokenId` token from `from` to `to`.
110      *
111      * WARNING: Usage of this method is discouraged, use {safeTransferFrom} whenever possible.
112      *
113      * Requirements:
114      *
115      * - `from` cannot be the zero address.
116      * - `to` cannot be the zero address.
117      * - `tokenId` token must be owned by `from`.
118      * - If the caller is not `from`, it must be approved to move this token by either {approve} or {setApprovalForAll}.
119      *
120      * Emits a {Transfer} event.
121      */
122     function transferFrom(
123         address from,
124         address to,
125         uint256 tokenId
126     ) external;
127 
128     /**
129      * @dev Gives permission to `to` to transfer `tokenId` token to another account.
130      * The approval is cleared when the token is transferred.
131      *
132      * Only a single account can be approved at a time, so approving the zero address clears previous approvals.
133      *
134      * Requirements:
135      *
136      * - The caller must own the token or be an approved operator.
137      * - `tokenId` must exist.
138      *
139      * Emits an {Approval} event.
140      */
141     function approve(address to, uint256 tokenId) external;
142 
143     /**
144      * @dev Approve or remove `operator` as an operator for the caller.
145      * Operators can call {transferFrom} or {safeTransferFrom} for any token owned by the caller.
146      *
147      * Requirements:
148      *
149      * - The `operator` cannot be the caller.
150      *
151      * Emits an {ApprovalForAll} event.
152      */
153     function setApprovalForAll(address operator, bool _approved) external;
154 
155     /**
156      * @dev Returns the account approved for `tokenId` token.
157      *
158      * Requirements:
159      *
160      * - `tokenId` must exist.
161      */
162     function getApproved(uint256 tokenId) external view returns (address operator);
163 
164     /**
165      * @dev Returns if the `operator` is allowed to manage all of the assets of `owner`.
166      *
167      * See {setApprovalForAll}
168      */
169     function isApprovedForAll(address owner, address operator) external view returns (bool);
170 }
171 
172 // File: @openzeppelin/contracts/token/ERC721/IERC721Receiver.sol
173 
174 // OpenZeppelin Contracts (last updated v4.6.0) (token/ERC721/IERC721Receiver.sol)
175 
176 pragma solidity ^0.8.0;
177 
178 /**
179  * @title ERC721 token receiver interface
180  * @dev Interface for any contract that wants to support safeTransfers
181  * from ERC721 asset contracts.
182  */
183 interface IERC721Receiver {
184     /**
185      * @dev Whenever an {IERC721} `tokenId` token is transferred to this contract via {IERC721-safeTransferFrom}
186      * by `operator` from `from`, this function is called.
187      *
188      * It must return its Solidity selector to confirm the token transfer.
189      * If any other value is returned or the interface is not implemented by the recipient, the transfer will be reverted.
190      *
191      * The selector can be obtained in Solidity with `IERC721Receiver.onERC721Received.selector`.
192      */
193     function onERC721Received(
194         address operator,
195         address from,
196         uint256 tokenId,
197         bytes calldata data
198     ) external returns (bytes4);
199 }
200 
201 // File: @openzeppelin/contracts/token/ERC721/extensions/IERC721Metadata.sol
202 
203 // OpenZeppelin Contracts v4.4.1 (token/ERC721/extensions/IERC721Metadata.sol)
204 
205 pragma solidity ^0.8.0;
206 
207 /**
208  * @title ERC-721 Non-Fungible Token Standard, optional metadata extension
209  * @dev See https://eips.ethereum.org/EIPS/eip-721
210  */
211 interface IERC721Metadata is IERC721 {
212     /**
213      * @dev Returns the token collection name.
214      */
215     function name() external view returns (string memory);
216 
217     /**
218      * @dev Returns the token collection symbol.
219      */
220     function symbol() external view returns (string memory);
221 
222     /**
223      * @dev Returns the Uniform Resource Identifier (URI) for `tokenId` token.
224      */
225     function tokenURI(uint256 tokenId) external view returns (string memory);
226 }
227 
228 // File: @openzeppelin/contracts/utils/Address.sol
229 
230 // OpenZeppelin Contracts (last updated v4.7.0) (utils/Address.sol)
231 
232 pragma solidity ^0.8.1;
233 
234 /**
235  * @dev Collection of functions related to the address type
236  */
237 library Address {
238     /**
239      * @dev Returns true if `account` is a contract.
240      *
241      * [IMPORTANT]
242      * ====
243      * It is unsafe to assume that an address for which this function returns
244      * false is an externally-owned account (EOA) and not a contract.
245      *
246      * Among others, `isContract` will return false for the following
247      * types of addresses:
248      *
249      *  - an externally-owned account
250      *  - a contract in construction
251      *  - an address where a contract will be created
252      *  - an address where a contract lived, but was destroyed
253      * ====
254      *
255      * [IMPORTANT]
256      * ====
257      * You shouldn't rely on `isContract` to protect against flash loan attacks!
258      *
259      * Preventing calls from contracts is highly discouraged. It breaks composability, breaks support for smart wallets
260      * like Gnosis Safe, and does not provide security since it can be circumvented by calling from a contract
261      * constructor.
262      * ====
263      */
264     function isContract(address account) internal view returns (bool) {
265         // This method relies on extcodesize/address.code.length, which returns 0
266         // for contracts in construction, since the code is only stored at the end
267         // of the constructor execution.
268 
269         return account.code.length > 0;
270     }
271 
272     /**
273      * @dev Replacement for Solidity's `transfer`: sends `amount` wei to
274      * `recipient`, forwarding all available gas and reverting on errors.
275      *
276      * https://eips.ethereum.org/EIPS/eip-1884[EIP1884] increases the gas cost
277      * of certain opcodes, possibly making contracts go over the 2300 gas limit
278      * imposed by `transfer`, making them unable to receive funds via
279      * `transfer`. {sendValue} removes this limitation.
280      *
281      * https://diligence.consensys.net/posts/2019/09/stop-using-soliditys-transfer-now/[Learn more].
282      *
283      * IMPORTANT: because control is transferred to `recipient`, care must be
284      * taken to not create reentrancy vulnerabilities. Consider using
285      * {ReentrancyGuard} or the
286      * https://solidity.readthedocs.io/en/v0.5.11/security-considerations.html#use-the-checks-effects-interactions-pattern[checks-effects-interactions pattern].
287      */
288     function sendValue(address payable recipient, uint256 amount) internal {
289         require(address(this).balance >= amount, "Address: insufficient balance");
290 
291         (bool success, ) = recipient.call{value: amount}("");
292         require(success, "Address: unable to send value, recipient may have reverted");
293     }
294 
295     /**
296      * @dev Performs a Solidity function call using a low level `call`. A
297      * plain `call` is an unsafe replacement for a function call: use this
298      * function instead.
299      *
300      * If `target` reverts with a revert reason, it is bubbled up by this
301      * function (like regular Solidity function calls).
302      *
303      * Returns the raw returned data. To convert to the expected return value,
304      * use https://solidity.readthedocs.io/en/latest/units-and-global-variables.html?highlight=abi.decode#abi-encoding-and-decoding-functions[`abi.decode`].
305      *
306      * Requirements:
307      *
308      * - `target` must be a contract.
309      * - calling `target` with `data` must not revert.
310      *
311      * _Available since v3.1._
312      */
313     function functionCall(address target, bytes memory data) internal returns (bytes memory) {
314         return functionCall(target, data, "Address: low-level call failed");
315     }
316 
317     /**
318      * @dev Same as {xref-Address-functionCall-address-bytes-}[`functionCall`], but with
319      * `errorMessage` as a fallback revert reason when `target` reverts.
320      *
321      * _Available since v3.1._
322      */
323     function functionCall(
324         address target,
325         bytes memory data,
326         string memory errorMessage
327     ) internal returns (bytes memory) {
328         return functionCallWithValue(target, data, 0, errorMessage);
329     }
330 
331     /**
332      * @dev Same as {xref-Address-functionCall-address-bytes-}[`functionCall`],
333      * but also transferring `value` wei to `target`.
334      *
335      * Requirements:
336      *
337      * - the calling contract must have an ETH balance of at least `value`.
338      * - the called Solidity function must be `payable`.
339      *
340      * _Available since v3.1._
341      */
342     function functionCallWithValue(
343         address target,
344         bytes memory data,
345         uint256 value
346     ) internal returns (bytes memory) {
347         return functionCallWithValue(target, data, value, "Address: low-level call with value failed");
348     }
349 
350     /**
351      * @dev Same as {xref-Address-functionCallWithValue-address-bytes-uint256-}[`functionCallWithValue`], but
352      * with `errorMessage` as a fallback revert reason when `target` reverts.
353      *
354      * _Available since v3.1._
355      */
356     function functionCallWithValue(
357         address target,
358         bytes memory data,
359         uint256 value,
360         string memory errorMessage
361     ) internal returns (bytes memory) {
362         require(address(this).balance >= value, "Address: insufficient balance for call");
363         require(isContract(target), "Address: call to non-contract");
364 
365         (bool success, bytes memory returndata) = target.call{value: value}(data);
366         return verifyCallResult(success, returndata, errorMessage);
367     }
368 
369     /**
370      * @dev Same as {xref-Address-functionCall-address-bytes-}[`functionCall`],
371      * but performing a static call.
372      *
373      * _Available since v3.3._
374      */
375     function functionStaticCall(address target, bytes memory data) internal view returns (bytes memory) {
376         return functionStaticCall(target, data, "Address: low-level static call failed");
377     }
378 
379     /**
380      * @dev Same as {xref-Address-functionCall-address-bytes-string-}[`functionCall`],
381      * but performing a static call.
382      *
383      * _Available since v3.3._
384      */
385     function functionStaticCall(
386         address target,
387         bytes memory data,
388         string memory errorMessage
389     ) internal view returns (bytes memory) {
390         require(isContract(target), "Address: static call to non-contract");
391 
392         (bool success, bytes memory returndata) = target.staticcall(data);
393         return verifyCallResult(success, returndata, errorMessage);
394     }
395 
396     /**
397      * @dev Same as {xref-Address-functionCall-address-bytes-}[`functionCall`],
398      * but performing a delegate call.
399      *
400      * _Available since v3.4._
401      */
402     function functionDelegateCall(address target, bytes memory data) internal returns (bytes memory) {
403         return functionDelegateCall(target, data, "Address: low-level delegate call failed");
404     }
405 
406     /**
407      * @dev Same as {xref-Address-functionCall-address-bytes-string-}[`functionCall`],
408      * but performing a delegate call.
409      *
410      * _Available since v3.4._
411      */
412     function functionDelegateCall(
413         address target,
414         bytes memory data,
415         string memory errorMessage
416     ) internal returns (bytes memory) {
417         require(isContract(target), "Address: delegate call to non-contract");
418 
419         (bool success, bytes memory returndata) = target.delegatecall(data);
420         return verifyCallResult(success, returndata, errorMessage);
421     }
422 
423     /**
424      * @dev Tool to verifies that a low level call was successful, and revert if it wasn't, either by bubbling the
425      * revert reason using the provided one.
426      *
427      * _Available since v4.3._
428      */
429     function verifyCallResult(
430         bool success,
431         bytes memory returndata,
432         string memory errorMessage
433     ) internal pure returns (bytes memory) {
434         if (success) {
435             return returndata;
436         } else {
437             // Look for revert reason and bubble it up if present
438             if (returndata.length > 0) {
439                 // The easiest way to bubble the revert reason is using memory via assembly
440                 /// @solidity memory-safe-assembly
441                 assembly {
442                     let returndata_size := mload(returndata)
443                     revert(add(32, returndata), returndata_size)
444                 }
445             } else {
446                 revert(errorMessage);
447             }
448         }
449     }
450 }
451 
452 // File: @openzeppelin/contracts/utils/Context.sol
453 
454 // OpenZeppelin Contracts v4.4.1 (utils/Context.sol)
455 
456 pragma solidity ^0.8.0;
457 
458 /**
459  * @dev Provides information about the current execution context, including the
460  * sender of the transaction and its data. While these are generally available
461  * via msg.sender and msg.data, they should not be accessed in such a direct
462  * manner, since when dealing with meta-transactions the account sending and
463  * paying for execution may not be the actual sender (as far as an application
464  * is concerned).
465  *
466  * This contract is only required for intermediate, library-like contracts.
467  */
468 abstract contract Context {
469     function _msgSender() internal view virtual returns (address) {
470         return msg.sender;
471     }
472 
473     function _msgData() internal view virtual returns (bytes calldata) {
474         return msg.data;
475     }
476 }
477 
478 // File: @openzeppelin/contracts/utils/Strings.sol
479 
480 // OpenZeppelin Contracts (last updated v4.7.0) (utils/Strings.sol)
481 
482 pragma solidity ^0.8.0;
483 
484 /**
485  * @dev String operations.
486  */
487 library Strings {
488     bytes16 private constant _HEX_SYMBOLS = "0123456789abcdef";
489     uint8 private constant _ADDRESS_LENGTH = 20;
490 
491     /**
492      * @dev Converts a `uint256` to its ASCII `string` decimal representation.
493      */
494     function toString(uint256 value) internal pure returns (string memory) {
495         // Inspired by OraclizeAPI's implementation - MIT licence
496         // https://github.com/oraclize/ethereum-api/blob/b42146b063c7d6ee1358846c198246239e9360e8/oraclizeAPI_0.4.25.sol
497 
498         if (value == 0) {
499             return "0";
500         }
501         uint256 temp = value;
502         uint256 digits;
503         while (temp != 0) {
504             digits++;
505             temp /= 10;
506         }
507         bytes memory buffer = new bytes(digits);
508         while (value != 0) {
509             digits -= 1;
510             buffer[digits] = bytes1(uint8(48 + uint256(value % 10)));
511             value /= 10;
512         }
513         return string(buffer);
514     }
515 
516     /**
517      * @dev Converts a `uint256` to its ASCII `string` hexadecimal representation.
518      */
519     function toHexString(uint256 value) internal pure returns (string memory) {
520         if (value == 0) {
521             return "0x00";
522         }
523         uint256 temp = value;
524         uint256 length = 0;
525         while (temp != 0) {
526             length++;
527             temp >>= 8;
528         }
529         return toHexString(value, length);
530     }
531 
532     /**
533      * @dev Converts a `uint256` to its ASCII `string` hexadecimal representation with fixed length.
534      */
535     function toHexString(uint256 value, uint256 length) internal pure returns (string memory) {
536         bytes memory buffer = new bytes(2 * length + 2);
537         buffer[0] = "0";
538         buffer[1] = "x";
539         for (uint256 i = 2 * length + 1; i > 1; --i) {
540             buffer[i] = _HEX_SYMBOLS[value & 0xf];
541             value >>= 4;
542         }
543         require(value == 0, "Strings: hex length insufficient");
544         return string(buffer);
545     }
546 
547     /**
548      * @dev Converts an `address` with fixed length of 20 bytes to its not checksummed ASCII `string` hexadecimal representation.
549      */
550     function toHexString(address addr) internal pure returns (string memory) {
551         return toHexString(uint256(uint160(addr)), _ADDRESS_LENGTH);
552     }
553 }
554 
555 // File: @openzeppelin/contracts/utils/introspection/ERC165.sol
556 
557 // OpenZeppelin Contracts v4.4.1 (utils/introspection/ERC165.sol)
558 
559 pragma solidity ^0.8.0;
560 
561 /**
562  * @dev Implementation of the {IERC165} interface.
563  *
564  * Contracts that want to implement ERC165 should inherit from this contract and override {supportsInterface} to check
565  * for the additional interface id that will be supported. For example:
566  *
567  * ```solidity
568  * function supportsInterface(bytes4 interfaceId) public view virtual override returns (bool) {
569  *     return interfaceId == type(MyInterface).interfaceId || super.supportsInterface(interfaceId);
570  * }
571  * ```
572  *
573  * Alternatively, {ERC165Storage} provides an easier to use but more expensive implementation.
574  */
575 abstract contract ERC165 is IERC165 {
576     /**
577      * @dev See {IERC165-supportsInterface}.
578      */
579     function supportsInterface(bytes4 interfaceId) public view virtual override returns (bool) {
580         return interfaceId == type(IERC165).interfaceId;
581     }
582 }
583 
584 // File: @openzeppelin/contracts/token/ERC721/ERC721.sol
585 
586 // OpenZeppelin Contracts (last updated v4.7.0) (token/ERC721/ERC721.sol)
587 
588 pragma solidity ^0.8.0;
589 
590 
591 
592 
593 
594 
595 
596 /**
597  * @dev Implementation of https://eips.ethereum.org/EIPS/eip-721[ERC721] Non-Fungible Token Standard, including
598  * the Metadata extension, but not including the Enumerable extension, which is available separately as
599  * {ERC721Enumerable}.
600  */
601 contract ERC721 is Context, ERC165, IERC721, IERC721Metadata {
602     using Address for address;
603     using Strings for uint256;
604 
605     // Token name
606     string private _name;
607 
608     // Token symbol
609     string private _symbol;
610 
611     // Mapping from token ID to owner address
612     mapping(uint256 => address) private _owners;
613 
614     // Mapping owner address to token count
615     mapping(address => uint256) private _balances;
616 
617     // Mapping from token ID to approved address
618     mapping(uint256 => address) private _tokenApprovals;
619 
620     // Mapping from owner to operator approvals
621     mapping(address => mapping(address => bool)) private _operatorApprovals;
622 
623     /**
624      * @dev Initializes the contract by setting a `name` and a `symbol` to the token collection.
625      */
626     constructor(string memory name_, string memory symbol_) {
627         _name = name_;
628         _symbol = symbol_;
629     }
630 
631     /**
632      * @dev See {IERC165-supportsInterface}.
633      */
634     function supportsInterface(bytes4 interfaceId) public view virtual override(ERC165, IERC165) returns (bool) {
635         return
636             interfaceId == type(IERC721).interfaceId ||
637             interfaceId == type(IERC721Metadata).interfaceId ||
638             super.supportsInterface(interfaceId);
639     }
640 
641     /**
642      * @dev See {IERC721-balanceOf}.
643      */
644     function balanceOf(address owner) public view virtual override returns (uint256) {
645         require(owner != address(0), "ERC721: address zero is not a valid owner");
646         return _balances[owner];
647     }
648 
649     /**
650      * @dev See {IERC721-ownerOf}.
651      */
652     function ownerOf(uint256 tokenId) public view virtual override returns (address) {
653         address owner = _owners[tokenId];
654         require(owner != address(0), "ERC721: invalid token ID");
655         return owner;
656     }
657 
658     /**
659      * @dev See {IERC721Metadata-name}.
660      */
661     function name() public view virtual override returns (string memory) {
662         return _name;
663     }
664 
665     /**
666      * @dev See {IERC721Metadata-symbol}.
667      */
668     function symbol() public view virtual override returns (string memory) {
669         return _symbol;
670     }
671 
672     /**
673      * @dev See {IERC721Metadata-tokenURI}.
674      */
675     function tokenURI(uint256 tokenId) public view virtual override returns (string memory) {
676         _requireMinted(tokenId);
677 
678         string memory baseURI = _baseURI();
679         return bytes(baseURI).length > 0 ? string(abi.encodePacked(baseURI, tokenId.toString())) : "";
680     }
681 
682     /**
683      * @dev Base URI for computing {tokenURI}. If set, the resulting URI for each
684      * token will be the concatenation of the `baseURI` and the `tokenId`. Empty
685      * by default, can be overridden in child contracts.
686      */
687     function _baseURI() internal view virtual returns (string memory) {
688         return "";
689     }
690 
691     /**
692      * @dev See {IERC721-approve}.
693      */
694     function approve(address to, uint256 tokenId) public virtual override {
695         address owner = ERC721.ownerOf(tokenId);
696         require(to != owner, "ERC721: approval to current owner");
697 
698         require(
699             _msgSender() == owner || isApprovedForAll(owner, _msgSender()),
700             "ERC721: approve caller is not token owner nor approved for all"
701         );
702 
703         _approve(to, tokenId);
704     }
705 
706     /**
707      * @dev See {IERC721-getApproved}.
708      */
709     function getApproved(uint256 tokenId) public view virtual override returns (address) {
710         _requireMinted(tokenId);
711 
712         return _tokenApprovals[tokenId];
713     }
714 
715     /**
716      * @dev See {IERC721-setApprovalForAll}.
717      */
718     function setApprovalForAll(address operator, bool approved) public virtual override {
719         _setApprovalForAll(_msgSender(), operator, approved);
720     }
721 
722     /**
723      * @dev See {IERC721-isApprovedForAll}.
724      */
725     function isApprovedForAll(address owner, address operator) public view virtual override returns (bool) {
726         return _operatorApprovals[owner][operator];
727     }
728 
729     /**
730      * @dev See {IERC721-transferFrom}.
731      */
732     function transferFrom(
733         address from,
734         address to,
735         uint256 tokenId
736     ) public virtual override {
737         //solhint-disable-next-line max-line-length
738         require(_isApprovedOrOwner(_msgSender(), tokenId), "ERC721: caller is not token owner nor approved");
739 
740         _transfer(from, to, tokenId);
741     }
742 
743     /**
744      * @dev See {IERC721-safeTransferFrom}.
745      */
746     function safeTransferFrom(
747         address from,
748         address to,
749         uint256 tokenId
750     ) public virtual override {
751         safeTransferFrom(from, to, tokenId, "");
752     }
753 
754     /**
755      * @dev See {IERC721-safeTransferFrom}.
756      */
757     function safeTransferFrom(
758         address from,
759         address to,
760         uint256 tokenId,
761         bytes memory data
762     ) public virtual override {
763         require(_isApprovedOrOwner(_msgSender(), tokenId), "ERC721: caller is not token owner nor approved");
764         _safeTransfer(from, to, tokenId, data);
765     }
766 
767     /**
768      * @dev Safely transfers `tokenId` token from `from` to `to`, checking first that contract recipients
769      * are aware of the ERC721 protocol to prevent tokens from being forever locked.
770      *
771      * `data` is additional data, it has no specified format and it is sent in call to `to`.
772      *
773      * This internal function is equivalent to {safeTransferFrom}, and can be used to e.g.
774      * implement alternative mechanisms to perform token transfer, such as signature-based.
775      *
776      * Requirements:
777      *
778      * - `from` cannot be the zero address.
779      * - `to` cannot be the zero address.
780      * - `tokenId` token must exist and be owned by `from`.
781      * - If `to` refers to a smart contract, it must implement {IERC721Receiver-onERC721Received}, which is called upon a safe transfer.
782      *
783      * Emits a {Transfer} event.
784      */
785     function _safeTransfer(
786         address from,
787         address to,
788         uint256 tokenId,
789         bytes memory data
790     ) internal virtual {
791         _transfer(from, to, tokenId);
792         require(_checkOnERC721Received(from, to, tokenId, data), "ERC721: transfer to non ERC721Receiver implementer");
793     }
794 
795     /**
796      * @dev Returns whether `tokenId` exists.
797      *
798      * Tokens can be managed by their owner or approved accounts via {approve} or {setApprovalForAll}.
799      *
800      * Tokens start existing when they are minted (`_mint`),
801      * and stop existing when they are burned (`_burn`).
802      */
803     function _exists(uint256 tokenId) internal view virtual returns (bool) {
804         return _owners[tokenId] != address(0);
805     }
806 
807     /**
808      * @dev Returns whether `spender` is allowed to manage `tokenId`.
809      *
810      * Requirements:
811      *
812      * - `tokenId` must exist.
813      */
814     function _isApprovedOrOwner(address spender, uint256 tokenId) internal view virtual returns (bool) {
815         address owner = ERC721.ownerOf(tokenId);
816         return (spender == owner || isApprovedForAll(owner, spender) || getApproved(tokenId) == spender);
817     }
818 
819     /**
820      * @dev Safely mints `tokenId` and transfers it to `to`.
821      *
822      * Requirements:
823      *
824      * - `tokenId` must not exist.
825      * - If `to` refers to a smart contract, it must implement {IERC721Receiver-onERC721Received}, which is called upon a safe transfer.
826      *
827      * Emits a {Transfer} event.
828      */
829     function _safeMint(address to, uint256 tokenId) internal virtual {
830         _safeMint(to, tokenId, "");
831     }
832 
833     /**
834      * @dev Same as {xref-ERC721-_safeMint-address-uint256-}[`_safeMint`], with an additional `data` parameter which is
835      * forwarded in {IERC721Receiver-onERC721Received} to contract recipients.
836      */
837     function _safeMint(
838         address to,
839         uint256 tokenId,
840         bytes memory data
841     ) internal virtual {
842         _mint(to, tokenId);
843         require(
844             _checkOnERC721Received(address(0), to, tokenId, data),
845             "ERC721: transfer to non ERC721Receiver implementer"
846         );
847     }
848 
849     /**
850      * @dev Mints `tokenId` and transfers it to `to`.
851      *
852      * WARNING: Usage of this method is discouraged, use {_safeMint} whenever possible
853      *
854      * Requirements:
855      *
856      * - `tokenId` must not exist.
857      * - `to` cannot be the zero address.
858      *
859      * Emits a {Transfer} event.
860      */
861     function _mint(address to, uint256 tokenId) internal virtual {
862         require(to != address(0), "ERC721: mint to the zero address");
863         require(!_exists(tokenId), "ERC721: token already minted");
864 
865         _beforeTokenTransfer(address(0), to, tokenId);
866 
867         _balances[to] += 1;
868         _owners[tokenId] = to;
869 
870         emit Transfer(address(0), to, tokenId);
871 
872         _afterTokenTransfer(address(0), to, tokenId);
873     }
874 
875     /**
876      * @dev Destroys `tokenId`.
877      * The approval is cleared when the token is burned.
878      *
879      * Requirements:
880      *
881      * - `tokenId` must exist.
882      *
883      * Emits a {Transfer} event.
884      */
885     function _burn(uint256 tokenId) internal virtual {
886         address owner = ERC721.ownerOf(tokenId);
887 
888         _beforeTokenTransfer(owner, address(0), tokenId);
889 
890         // Clear approvals
891         _approve(address(0), tokenId);
892 
893         _balances[owner] -= 1;
894         delete _owners[tokenId];
895 
896         emit Transfer(owner, address(0), tokenId);
897 
898         _afterTokenTransfer(owner, address(0), tokenId);
899     }
900 
901     /**
902      * @dev Transfers `tokenId` from `from` to `to`.
903      *  As opposed to {transferFrom}, this imposes no restrictions on msg.sender.
904      *
905      * Requirements:
906      *
907      * - `to` cannot be the zero address.
908      * - `tokenId` token must be owned by `from`.
909      *
910      * Emits a {Transfer} event.
911      */
912     function _transfer(
913         address from,
914         address to,
915         uint256 tokenId
916     ) internal virtual {
917         require(ERC721.ownerOf(tokenId) == from, "ERC721: transfer from incorrect owner");
918         require(to != address(0), "ERC721: transfer to the zero address");
919 
920         _beforeTokenTransfer(from, to, tokenId);
921 
922         // Clear approvals from the previous owner
923         _approve(address(0), tokenId);
924 
925         _balances[from] -= 1;
926         _balances[to] += 1;
927         _owners[tokenId] = to;
928 
929         emit Transfer(from, to, tokenId);
930 
931         _afterTokenTransfer(from, to, tokenId);
932     }
933 
934     /**
935      * @dev Approve `to` to operate on `tokenId`
936      *
937      * Emits an {Approval} event.
938      */
939     function _approve(address to, uint256 tokenId) internal virtual {
940         _tokenApprovals[tokenId] = to;
941         emit Approval(ERC721.ownerOf(tokenId), to, tokenId);
942     }
943 
944     /**
945      * @dev Approve `operator` to operate on all of `owner` tokens
946      *
947      * Emits an {ApprovalForAll} event.
948      */
949     function _setApprovalForAll(
950         address owner,
951         address operator,
952         bool approved
953     ) internal virtual {
954         require(owner != operator, "ERC721: approve to caller");
955         _operatorApprovals[owner][operator] = approved;
956         emit ApprovalForAll(owner, operator, approved);
957     }
958 
959     /**
960      * @dev Reverts if the `tokenId` has not been minted yet.
961      */
962     function _requireMinted(uint256 tokenId) internal view virtual {
963         require(_exists(tokenId), "ERC721: invalid token ID");
964     }
965 
966     /**
967      * @dev Internal function to invoke {IERC721Receiver-onERC721Received} on a target address.
968      * The call is not executed if the target address is not a contract.
969      *
970      * @param from address representing the previous owner of the given token ID
971      * @param to target address that will receive the tokens
972      * @param tokenId uint256 ID of the token to be transferred
973      * @param data bytes optional data to send along with the call
974      * @return bool whether the call correctly returned the expected magic value
975      */
976     function _checkOnERC721Received(
977         address from,
978         address to,
979         uint256 tokenId,
980         bytes memory data
981     ) private returns (bool) {
982         if (to.isContract()) {
983             try IERC721Receiver(to).onERC721Received(_msgSender(), from, tokenId, data) returns (bytes4 retval) {
984                 return retval == IERC721Receiver.onERC721Received.selector;
985             } catch (bytes memory reason) {
986                 if (reason.length == 0) {
987                     revert("ERC721: transfer to non ERC721Receiver implementer");
988                 } else {
989                     /// @solidity memory-safe-assembly
990                     assembly {
991                         revert(add(32, reason), mload(reason))
992                     }
993                 }
994             }
995         } else {
996             return true;
997         }
998     }
999 
1000     /**
1001      * @dev Hook that is called before any token transfer. This includes minting
1002      * and burning.
1003      *
1004      * Calling conditions:
1005      *
1006      * - When `from` and `to` are both non-zero, ``from``'s `tokenId` will be
1007      * transferred to `to`.
1008      * - When `from` is zero, `tokenId` will be minted for `to`.
1009      * - When `to` is zero, ``from``'s `tokenId` will be burned.
1010      * - `from` and `to` are never both zero.
1011      *
1012      * To learn more about hooks, head to xref:ROOT:extending-contracts.adoc#using-hooks[Using Hooks].
1013      */
1014     function _beforeTokenTransfer(
1015         address from,
1016         address to,
1017         uint256 tokenId
1018     ) internal virtual {}
1019 
1020     /**
1021      * @dev Hook that is called after any transfer of tokens. This includes
1022      * minting and burning.
1023      *
1024      * Calling conditions:
1025      *
1026      * - when `from` and `to` are both non-zero.
1027      * - `from` and `to` are never both zero.
1028      *
1029      * To learn more about hooks, head to xref:ROOT:extending-contracts.adoc#using-hooks[Using Hooks].
1030      */
1031     function _afterTokenTransfer(
1032         address from,
1033         address to,
1034         uint256 tokenId
1035     ) internal virtual {}
1036 }
1037 
1038 // File: @openzeppelin/contracts/security/ReentrancyGuard.sol
1039 
1040 // OpenZeppelin Contracts v4.4.1 (security/ReentrancyGuard.sol)
1041 
1042 pragma solidity ^0.8.0;
1043 
1044 /**
1045  * @dev Contract module that helps prevent reentrant calls to a function.
1046  *
1047  * Inheriting from `ReentrancyGuard` will make the {nonReentrant} modifier
1048  * available, which can be applied to functions to make sure there are no nested
1049  * (reentrant) calls to them.
1050  *
1051  * Note that because there is a single `nonReentrant` guard, functions marked as
1052  * `nonReentrant` may not call one another. This can be worked around by making
1053  * those functions `private`, and then adding `external` `nonReentrant` entry
1054  * points to them.
1055  *
1056  * TIP: If you would like to learn more about reentrancy and alternative ways
1057  * to protect against it, check out our blog post
1058  * https://blog.openzeppelin.com/reentrancy-after-istanbul/[Reentrancy After Istanbul].
1059  */
1060 abstract contract ReentrancyGuard {
1061     // Booleans are more expensive than uint256 or any type that takes up a full
1062     // word because each write operation emits an extra SLOAD to first read the
1063     // slot's contents, replace the bits taken up by the boolean, and then write
1064     // back. This is the compiler's defense against contract upgrades and
1065     // pointer aliasing, and it cannot be disabled.
1066 
1067     // The values being non-zero value makes deployment a bit more expensive,
1068     // but in exchange the refund on every call to nonReentrant will be lower in
1069     // amount. Since refunds are capped to a percentage of the total
1070     // transaction's gas, it is best to keep them low in cases like this one, to
1071     // increase the likelihood of the full refund coming into effect.
1072     uint256 private constant _NOT_ENTERED = 1;
1073     uint256 private constant _ENTERED = 2;
1074 
1075     uint256 private _status;
1076 
1077     constructor() {
1078         _status = _NOT_ENTERED;
1079     }
1080 
1081     /**
1082      * @dev Prevents a contract from calling itself, directly or indirectly.
1083      * Calling a `nonReentrant` function from another `nonReentrant`
1084      * function is not supported. It is possible to prevent this from happening
1085      * by making the `nonReentrant` function external, and making it call a
1086      * `private` function that does the actual work.
1087      */
1088     modifier nonReentrant() {
1089         // On the first call to nonReentrant, _notEntered will be true
1090         require(_status != _ENTERED, "ReentrancyGuard: reentrant call");
1091 
1092         // Any calls to nonReentrant after this point will fail
1093         _status = _ENTERED;
1094 
1095         _;
1096 
1097         // By storing the original value once again, a refund is triggered (see
1098         // https://eips.ethereum.org/EIPS/eip-2200)
1099         _status = _NOT_ENTERED;
1100     }
1101 }
1102 
1103 // File: contracts/AssociativeNFT.sol
1104 
1105 pragma solidity ^0.8.4;
1106 
1107 
1108 interface ParentInterface {
1109     function balanceOf(address owner) external view returns (uint256 balance);
1110     function ownerOf(uint256 tokenId) external view returns (address owner);
1111 }
1112 
1113 contract AssociativeNFT is ERC721, ReentrancyGuard {
1114     address private parentAddress;
1115 
1116     mapping(uint256 => address) private _lastKnownOwners;
1117 
1118     constructor(string memory name_, string memory symbol_, address _parentAddress) ERC721(name_, symbol_) {
1119         parentAddress = _parentAddress;
1120     }
1121 
1122     /**
1123      * @dev associate
1124      * Utility function that "syncs" the association/ownership info on the blockchain.
1125      * Since this associative NFT is non-transferable, blockchain data will get
1126      * out of sync, because no Transfer event is emitted when the parent asset is moved.
1127      * This function gives the new owner or anyone a way to force the contract to emit a Transfer event.
1128      * This is optional, since the ownerOf function will always return the right owner.
1129      * However, most systems look at the Transfer events instead of the ownerOf function.
1130      */
1131     function associate(uint256 tokenId) external nonReentrant {
1132         address from = _lastKnownOwners[tokenId];
1133         address to = ownerOf(tokenId);
1134         require(from != to, "Already in sync");
1135 
1136         _lastKnownOwners[tokenId] = to;
1137 
1138         emit Transfer(from, to, tokenId);
1139     }
1140 
1141     /**
1142      * @dev ERC721 balanceOf method override. This is an Associative NFT.
1143      * It has the same balance as the Parent NFT with the same tokenId, once mint is complete.
1144      * Before the associative mint is complete, this may return an incorrect value.
1145      */
1146     function balanceOf(address owner) public view override returns (uint256) {
1147         return ParentInterface(parentAddress).balanceOf(owner);
1148     }
1149 
1150     /**
1151      * @dev ERC721 ownerOf method override. This is an Associative NFT.
1152      * It has the same owner as the Parent NFT with the same tokenId.
1153      */
1154     function ownerOf(uint256 tokenId) public view override returns (address) {
1155         return ParentInterface(parentAddress).ownerOf(tokenId);
1156     }
1157 
1158     /**
1159      * @dev ERC721 transferFrom method override. This is a non-transferable NFT.
1160      */
1161     function transferFrom(address, address, uint256) public pure override {
1162         // Non-transferable
1163         require(false, "Associative NFT is non-transferable");
1164     }
1165 
1166     /**
1167      * @dev ERC721 safeTransferFrom method override. This is a non-transferable NFT.
1168      */
1169     function safeTransferFrom(address, address, uint256) public pure override {
1170         // Non-transferable
1171         require(false, "Associative NFT is non-transferable");
1172     }
1173 
1174     /**
1175      * @dev ERC721 safeTransferFrom method override. This is a non-transferable NFT.
1176      */
1177     function safeTransferFrom(address, address, uint256, bytes memory) public pure override {
1178         // Non-transferable
1179         require(false, "Associative NFT is non-transferable");
1180     }
1181 
1182     /**
1183      * @dev ERC721 approve method override. This is a non-transferable NFT.
1184      */
1185     function approve(address, uint256) public pure override {
1186         // Non-transferable
1187         require(false, "Associative NFT is non-transferable");
1188     }
1189 
1190     /**
1191      * @dev ERC721 setApprovalForAll method override. This is a non-transferable NFT.
1192      */
1193     function setApprovalForAll(address, bool) public pure override {
1194         // Non-transferable
1195         require(false, "Associative NFT is non-transferable");
1196     }
1197 
1198     /**
1199      * @dev ERC721 _afterTokenTransfer method override. This is a non-transferable NFT.
1200      * Saves the last known owner after minting.
1201      */
1202     function _afterTokenTransfer(
1203         address,
1204         address to,
1205         uint256 tokenId
1206     ) internal override {
1207         _lastKnownOwners[tokenId] = to;
1208     }
1209 }
1210 
1211 // File: @openzeppelin/contracts/utils/cryptography/MerkleProof.sol
1212 
1213 // OpenZeppelin Contracts (last updated v4.7.0) (utils/cryptography/MerkleProof.sol)
1214 
1215 pragma solidity ^0.8.0;
1216 
1217 /**
1218  * @dev These functions deal with verification of Merkle Tree proofs.
1219  *
1220  * The proofs can be generated using the JavaScript library
1221  * https://github.com/miguelmota/merkletreejs[merkletreejs].
1222  * Note: the hashing algorithm should be keccak256 and pair sorting should be enabled.
1223  *
1224  * See `test/utils/cryptography/MerkleProof.test.js` for some examples.
1225  *
1226  * WARNING: You should avoid using leaf values that are 64 bytes long prior to
1227  * hashing, or use a hash function other than keccak256 for hashing leaves.
1228  * This is because the concatenation of a sorted pair of internal nodes in
1229  * the merkle tree could be reinterpreted as a leaf value.
1230  */
1231 library MerkleProof {
1232     /**
1233      * @dev Returns true if a `leaf` can be proved to be a part of a Merkle tree
1234      * defined by `root`. For this, a `proof` must be provided, containing
1235      * sibling hashes on the branch from the leaf to the root of the tree. Each
1236      * pair of leaves and each pair of pre-images are assumed to be sorted.
1237      */
1238     function verify(
1239         bytes32[] memory proof,
1240         bytes32 root,
1241         bytes32 leaf
1242     ) internal pure returns (bool) {
1243         return processProof(proof, leaf) == root;
1244     }
1245 
1246     /**
1247      * @dev Calldata version of {verify}
1248      *
1249      * _Available since v4.7._
1250      */
1251     function verifyCalldata(
1252         bytes32[] calldata proof,
1253         bytes32 root,
1254         bytes32 leaf
1255     ) internal pure returns (bool) {
1256         return processProofCalldata(proof, leaf) == root;
1257     }
1258 
1259     /**
1260      * @dev Returns the rebuilt hash obtained by traversing a Merkle tree up
1261      * from `leaf` using `proof`. A `proof` is valid if and only if the rebuilt
1262      * hash matches the root of the tree. When processing the proof, the pairs
1263      * of leafs & pre-images are assumed to be sorted.
1264      *
1265      * _Available since v4.4._
1266      */
1267     function processProof(bytes32[] memory proof, bytes32 leaf) internal pure returns (bytes32) {
1268         bytes32 computedHash = leaf;
1269         for (uint256 i = 0; i < proof.length; i++) {
1270             computedHash = _hashPair(computedHash, proof[i]);
1271         }
1272         return computedHash;
1273     }
1274 
1275     /**
1276      * @dev Calldata version of {processProof}
1277      *
1278      * _Available since v4.7._
1279      */
1280     function processProofCalldata(bytes32[] calldata proof, bytes32 leaf) internal pure returns (bytes32) {
1281         bytes32 computedHash = leaf;
1282         for (uint256 i = 0; i < proof.length; i++) {
1283             computedHash = _hashPair(computedHash, proof[i]);
1284         }
1285         return computedHash;
1286     }
1287 
1288     /**
1289      * @dev Returns true if the `leaves` can be proved to be a part of a Merkle tree defined by
1290      * `root`, according to `proof` and `proofFlags` as described in {processMultiProof}.
1291      *
1292      * _Available since v4.7._
1293      */
1294     function multiProofVerify(
1295         bytes32[] memory proof,
1296         bool[] memory proofFlags,
1297         bytes32 root,
1298         bytes32[] memory leaves
1299     ) internal pure returns (bool) {
1300         return processMultiProof(proof, proofFlags, leaves) == root;
1301     }
1302 
1303     /**
1304      * @dev Calldata version of {multiProofVerify}
1305      *
1306      * _Available since v4.7._
1307      */
1308     function multiProofVerifyCalldata(
1309         bytes32[] calldata proof,
1310         bool[] calldata proofFlags,
1311         bytes32 root,
1312         bytes32[] memory leaves
1313     ) internal pure returns (bool) {
1314         return processMultiProofCalldata(proof, proofFlags, leaves) == root;
1315     }
1316 
1317     /**
1318      * @dev Returns the root of a tree reconstructed from `leaves` and the sibling nodes in `proof`,
1319      * consuming from one or the other at each step according to the instructions given by
1320      * `proofFlags`.
1321      *
1322      * _Available since v4.7._
1323      */
1324     function processMultiProof(
1325         bytes32[] memory proof,
1326         bool[] memory proofFlags,
1327         bytes32[] memory leaves
1328     ) internal pure returns (bytes32 merkleRoot) {
1329         // This function rebuild the root hash by traversing the tree up from the leaves. The root is rebuilt by
1330         // consuming and producing values on a queue. The queue starts with the `leaves` array, then goes onto the
1331         // `hashes` array. At the end of the process, the last hash in the `hashes` array should contain the root of
1332         // the merkle tree.
1333         uint256 leavesLen = leaves.length;
1334         uint256 totalHashes = proofFlags.length;
1335 
1336         // Check proof validity.
1337         require(leavesLen + proof.length - 1 == totalHashes, "MerkleProof: invalid multiproof");
1338 
1339         // The xxxPos values are "pointers" to the next value to consume in each array. All accesses are done using
1340         // `xxx[xxxPos++]`, which return the current value and increment the pointer, thus mimicking a queue's "pop".
1341         bytes32[] memory hashes = new bytes32[](totalHashes);
1342         uint256 leafPos = 0;
1343         uint256 hashPos = 0;
1344         uint256 proofPos = 0;
1345         // At each step, we compute the next hash using two values:
1346         // - a value from the "main queue". If not all leaves have been consumed, we get the next leaf, otherwise we
1347         //   get the next hash.
1348         // - depending on the flag, either another value for the "main queue" (merging branches) or an element from the
1349         //   `proof` array.
1350         for (uint256 i = 0; i < totalHashes; i++) {
1351             bytes32 a = leafPos < leavesLen ? leaves[leafPos++] : hashes[hashPos++];
1352             bytes32 b = proofFlags[i] ? leafPos < leavesLen ? leaves[leafPos++] : hashes[hashPos++] : proof[proofPos++];
1353             hashes[i] = _hashPair(a, b);
1354         }
1355 
1356         if (totalHashes > 0) {
1357             return hashes[totalHashes - 1];
1358         } else if (leavesLen > 0) {
1359             return leaves[0];
1360         } else {
1361             return proof[0];
1362         }
1363     }
1364 
1365     /**
1366      * @dev Calldata version of {processMultiProof}
1367      *
1368      * _Available since v4.7._
1369      */
1370     function processMultiProofCalldata(
1371         bytes32[] calldata proof,
1372         bool[] calldata proofFlags,
1373         bytes32[] memory leaves
1374     ) internal pure returns (bytes32 merkleRoot) {
1375         // This function rebuild the root hash by traversing the tree up from the leaves. The root is rebuilt by
1376         // consuming and producing values on a queue. The queue starts with the `leaves` array, then goes onto the
1377         // `hashes` array. At the end of the process, the last hash in the `hashes` array should contain the root of
1378         // the merkle tree.
1379         uint256 leavesLen = leaves.length;
1380         uint256 totalHashes = proofFlags.length;
1381 
1382         // Check proof validity.
1383         require(leavesLen + proof.length - 1 == totalHashes, "MerkleProof: invalid multiproof");
1384 
1385         // The xxxPos values are "pointers" to the next value to consume in each array. All accesses are done using
1386         // `xxx[xxxPos++]`, which return the current value and increment the pointer, thus mimicking a queue's "pop".
1387         bytes32[] memory hashes = new bytes32[](totalHashes);
1388         uint256 leafPos = 0;
1389         uint256 hashPos = 0;
1390         uint256 proofPos = 0;
1391         // At each step, we compute the next hash using two values:
1392         // - a value from the "main queue". If not all leaves have been consumed, we get the next leaf, otherwise we
1393         //   get the next hash.
1394         // - depending on the flag, either another value for the "main queue" (merging branches) or an element from the
1395         //   `proof` array.
1396         for (uint256 i = 0; i < totalHashes; i++) {
1397             bytes32 a = leafPos < leavesLen ? leaves[leafPos++] : hashes[hashPos++];
1398             bytes32 b = proofFlags[i] ? leafPos < leavesLen ? leaves[leafPos++] : hashes[hashPos++] : proof[proofPos++];
1399             hashes[i] = _hashPair(a, b);
1400         }
1401 
1402         if (totalHashes > 0) {
1403             return hashes[totalHashes - 1];
1404         } else if (leavesLen > 0) {
1405             return leaves[0];
1406         } else {
1407             return proof[0];
1408         }
1409     }
1410 
1411     function _hashPair(bytes32 a, bytes32 b) private pure returns (bytes32) {
1412         return a < b ? _efficientHash(a, b) : _efficientHash(b, a);
1413     }
1414 
1415     function _efficientHash(bytes32 a, bytes32 b) private pure returns (bytes32 value) {
1416         /// @solidity memory-safe-assembly
1417         assembly {
1418             mstore(0x00, a)
1419             mstore(0x20, b)
1420             value := keccak256(0x00, 0x40)
1421         }
1422     }
1423 }
1424 
1425 // File: @openzeppelin/contracts/utils/math/SafeMath.sol
1426 
1427 // OpenZeppelin Contracts (last updated v4.6.0) (utils/math/SafeMath.sol)
1428 
1429 pragma solidity ^0.8.0;
1430 
1431 // CAUTION
1432 // This version of SafeMath should only be used with Solidity 0.8 or later,
1433 // because it relies on the compiler's built in overflow checks.
1434 
1435 /**
1436  * @dev Wrappers over Solidity's arithmetic operations.
1437  *
1438  * NOTE: `SafeMath` is generally not needed starting with Solidity 0.8, since the compiler
1439  * now has built in overflow checking.
1440  */
1441 library SafeMath {
1442     /**
1443      * @dev Returns the addition of two unsigned integers, with an overflow flag.
1444      *
1445      * _Available since v3.4._
1446      */
1447     function tryAdd(uint256 a, uint256 b) internal pure returns (bool, uint256) {
1448         unchecked {
1449             uint256 c = a + b;
1450             if (c < a) return (false, 0);
1451             return (true, c);
1452         }
1453     }
1454 
1455     /**
1456      * @dev Returns the subtraction of two unsigned integers, with an overflow flag.
1457      *
1458      * _Available since v3.4._
1459      */
1460     function trySub(uint256 a, uint256 b) internal pure returns (bool, uint256) {
1461         unchecked {
1462             if (b > a) return (false, 0);
1463             return (true, a - b);
1464         }
1465     }
1466 
1467     /**
1468      * @dev Returns the multiplication of two unsigned integers, with an overflow flag.
1469      *
1470      * _Available since v3.4._
1471      */
1472     function tryMul(uint256 a, uint256 b) internal pure returns (bool, uint256) {
1473         unchecked {
1474             // Gas optimization: this is cheaper than requiring 'a' not being zero, but the
1475             // benefit is lost if 'b' is also tested.
1476             // See: https://github.com/OpenZeppelin/openzeppelin-contracts/pull/522
1477             if (a == 0) return (true, 0);
1478             uint256 c = a * b;
1479             if (c / a != b) return (false, 0);
1480             return (true, c);
1481         }
1482     }
1483 
1484     /**
1485      * @dev Returns the division of two unsigned integers, with a division by zero flag.
1486      *
1487      * _Available since v3.4._
1488      */
1489     function tryDiv(uint256 a, uint256 b) internal pure returns (bool, uint256) {
1490         unchecked {
1491             if (b == 0) return (false, 0);
1492             return (true, a / b);
1493         }
1494     }
1495 
1496     /**
1497      * @dev Returns the remainder of dividing two unsigned integers, with a division by zero flag.
1498      *
1499      * _Available since v3.4._
1500      */
1501     function tryMod(uint256 a, uint256 b) internal pure returns (bool, uint256) {
1502         unchecked {
1503             if (b == 0) return (false, 0);
1504             return (true, a % b);
1505         }
1506     }
1507 
1508     /**
1509      * @dev Returns the addition of two unsigned integers, reverting on
1510      * overflow.
1511      *
1512      * Counterpart to Solidity's `+` operator.
1513      *
1514      * Requirements:
1515      *
1516      * - Addition cannot overflow.
1517      */
1518     function add(uint256 a, uint256 b) internal pure returns (uint256) {
1519         return a + b;
1520     }
1521 
1522     /**
1523      * @dev Returns the subtraction of two unsigned integers, reverting on
1524      * overflow (when the result is negative).
1525      *
1526      * Counterpart to Solidity's `-` operator.
1527      *
1528      * Requirements:
1529      *
1530      * - Subtraction cannot overflow.
1531      */
1532     function sub(uint256 a, uint256 b) internal pure returns (uint256) {
1533         return a - b;
1534     }
1535 
1536     /**
1537      * @dev Returns the multiplication of two unsigned integers, reverting on
1538      * overflow.
1539      *
1540      * Counterpart to Solidity's `*` operator.
1541      *
1542      * Requirements:
1543      *
1544      * - Multiplication cannot overflow.
1545      */
1546     function mul(uint256 a, uint256 b) internal pure returns (uint256) {
1547         return a * b;
1548     }
1549 
1550     /**
1551      * @dev Returns the integer division of two unsigned integers, reverting on
1552      * division by zero. The result is rounded towards zero.
1553      *
1554      * Counterpart to Solidity's `/` operator.
1555      *
1556      * Requirements:
1557      *
1558      * - The divisor cannot be zero.
1559      */
1560     function div(uint256 a, uint256 b) internal pure returns (uint256) {
1561         return a / b;
1562     }
1563 
1564     /**
1565      * @dev Returns the remainder of dividing two unsigned integers. (unsigned integer modulo),
1566      * reverting when dividing by zero.
1567      *
1568      * Counterpart to Solidity's `%` operator. This function uses a `revert`
1569      * opcode (which leaves remaining gas untouched) while Solidity uses an
1570      * invalid opcode to revert (consuming all remaining gas).
1571      *
1572      * Requirements:
1573      *
1574      * - The divisor cannot be zero.
1575      */
1576     function mod(uint256 a, uint256 b) internal pure returns (uint256) {
1577         return a % b;
1578     }
1579 
1580     /**
1581      * @dev Returns the subtraction of two unsigned integers, reverting with custom message on
1582      * overflow (when the result is negative).
1583      *
1584      * CAUTION: This function is deprecated because it requires allocating memory for the error
1585      * message unnecessarily. For custom revert reasons use {trySub}.
1586      *
1587      * Counterpart to Solidity's `-` operator.
1588      *
1589      * Requirements:
1590      *
1591      * - Subtraction cannot overflow.
1592      */
1593     function sub(
1594         uint256 a,
1595         uint256 b,
1596         string memory errorMessage
1597     ) internal pure returns (uint256) {
1598         unchecked {
1599             require(b <= a, errorMessage);
1600             return a - b;
1601         }
1602     }
1603 
1604     /**
1605      * @dev Returns the integer division of two unsigned integers, reverting with custom message on
1606      * division by zero. The result is rounded towards zero.
1607      *
1608      * Counterpart to Solidity's `/` operator. Note: this function uses a
1609      * `revert` opcode (which leaves remaining gas untouched) while Solidity
1610      * uses an invalid opcode to revert (consuming all remaining gas).
1611      *
1612      * Requirements:
1613      *
1614      * - The divisor cannot be zero.
1615      */
1616     function div(
1617         uint256 a,
1618         uint256 b,
1619         string memory errorMessage
1620     ) internal pure returns (uint256) {
1621         unchecked {
1622             require(b > 0, errorMessage);
1623             return a / b;
1624         }
1625     }
1626 
1627     /**
1628      * @dev Returns the remainder of dividing two unsigned integers. (unsigned integer modulo),
1629      * reverting with custom message when dividing by zero.
1630      *
1631      * CAUTION: This function is deprecated because it requires allocating memory for the error
1632      * message unnecessarily. For custom revert reasons use {tryMod}.
1633      *
1634      * Counterpart to Solidity's `%` operator. This function uses a `revert`
1635      * opcode (which leaves remaining gas untouched) while Solidity uses an
1636      * invalid opcode to revert (consuming all remaining gas).
1637      *
1638      * Requirements:
1639      *
1640      * - The divisor cannot be zero.
1641      */
1642     function mod(
1643         uint256 a,
1644         uint256 b,
1645         string memory errorMessage
1646     ) internal pure returns (uint256) {
1647         unchecked {
1648             require(b > 0, errorMessage);
1649             return a % b;
1650         }
1651     }
1652 }
1653 
1654 // File: @openzeppelin/contracts/access/Ownable.sol
1655 
1656 // OpenZeppelin Contracts (last updated v4.7.0) (access/Ownable.sol)
1657 
1658 pragma solidity ^0.8.0;
1659 
1660 /**
1661  * @dev Contract module which provides a basic access control mechanism, where
1662  * there is an account (an owner) that can be granted exclusive access to
1663  * specific functions.
1664  *
1665  * By default, the owner account will be the one that deploys the contract. This
1666  * can later be changed with {transferOwnership}.
1667  *
1668  * This module is used through inheritance. It will make available the modifier
1669  * `onlyOwner`, which can be applied to your functions to restrict their use to
1670  * the owner.
1671  */
1672 abstract contract Ownable is Context {
1673     address private _owner;
1674 
1675     event OwnershipTransferred(address indexed previousOwner, address indexed newOwner);
1676 
1677     /**
1678      * @dev Initializes the contract setting the deployer as the initial owner.
1679      */
1680     constructor() {
1681         _transferOwnership(_msgSender());
1682     }
1683 
1684     /**
1685      * @dev Throws if called by any account other than the owner.
1686      */
1687     modifier onlyOwner() {
1688         _checkOwner();
1689         _;
1690     }
1691 
1692     /**
1693      * @dev Returns the address of the current owner.
1694      */
1695     function owner() public view virtual returns (address) {
1696         return _owner;
1697     }
1698 
1699     /**
1700      * @dev Throws if the sender is not the owner.
1701      */
1702     function _checkOwner() internal view virtual {
1703         require(owner() == _msgSender(), "Ownable: caller is not the owner");
1704     }
1705 
1706     /**
1707      * @dev Leaves the contract without owner. It will not be possible to call
1708      * `onlyOwner` functions anymore. Can only be called by the current owner.
1709      *
1710      * NOTE: Renouncing ownership will leave the contract without an owner,
1711      * thereby removing any functionality that is only available to the owner.
1712      */
1713     function renounceOwnership() public virtual onlyOwner {
1714         _transferOwnership(address(0));
1715     }
1716 
1717     /**
1718      * @dev Transfers ownership of the contract to a new account (`newOwner`).
1719      * Can only be called by the current owner.
1720      */
1721     function transferOwnership(address newOwner) public virtual onlyOwner {
1722         require(newOwner != address(0), "Ownable: new owner is the zero address");
1723         _transferOwnership(newOwner);
1724     }
1725 
1726     /**
1727      * @dev Transfers ownership of the contract to a new account (`newOwner`).
1728      * Internal function without access restriction.
1729      */
1730     function _transferOwnership(address newOwner) internal virtual {
1731         address oldOwner = _owner;
1732         _owner = newOwner;
1733         emit OwnershipTransferred(oldOwner, newOwner);
1734     }
1735 }
1736 
1737 // File: contracts/XYWorld.sol
1738 
1739 pragma solidity ^0.8.4;
1740 
1741 
1742 
1743 
1744 
1745 
1746 contract XYWorld is
1747     AssociativeNFT,
1748     Ownable
1749 {
1750     using SafeMath for uint256;
1751     using Strings for uint256;
1752 
1753     string public PROVENANCE = "";
1754     uint256 public constant TOTAL_TOKENS = 16384;
1755 
1756     uint256 public startingIndexBlock;
1757     uint256 public startingIndexBase;
1758     uint256 public startingIndexLimited;
1759 
1760     mapping(uint256 => uint256) private _levelBalances;
1761     mapping(uint256 => uint256) private _levelMaxes; // max number in each level
1762     mapping(uint256 => uint256) private _levelBaseIndexes; // base starting index
1763     mapping(uint256 => uint256) private _levelPrices;
1764 
1765     mapping(uint256 => uint256) private _tokenMap; // from X,Y tokenId to metadata id
1766 
1767     mapping(address => uint256) private _presales;
1768 
1769     string private _baseTokenURI;
1770 
1771     bytes32 private _merkleRoot;
1772 
1773     // sales parameters
1774     uint256 private _batchMax = 10;
1775     uint256 private _presaleMax = 10;
1776 
1777     // States
1778     bool private _presaleActive = false;
1779     bool private _saleActive = false;
1780 
1781     constructor(address xyAddress, string memory baseTokenURI, uint256 limitedMax) AssociativeNFT("X,Y World", "XYW", xyAddress) {
1782         _levelMaxes[0] = TOTAL_TOKENS;
1783         _levelMaxes[1] = limitedMax;
1784 
1785         _levelBaseIndexes[0] = 0;
1786         _levelBaseIndexes[1] = TOTAL_TOKENS;
1787 
1788         _baseTokenURI = baseTokenURI;
1789     }
1790 
1791     function _baseURI() internal view virtual override returns (string memory) {
1792         return _baseTokenURI;
1793     }
1794 
1795     /**
1796      * @dev tokenURI override to use _tokenMap[_tokenMap] instead of just the tokenId
1797      */
1798     function tokenURI(uint256 tokenId) public view virtual override returns (string memory) {
1799         _requireMinted(tokenId);
1800 
1801         string memory baseURI = _baseURI();
1802         return bytes(baseURI).length > 0 ? string(abi.encodePacked(baseURI, _tokenMap[tokenId].toString())) : "";
1803     }
1804 
1805     function mint(uint256 tokenId, uint256 level) external nonReentrant payable {
1806         require(!_presaleActive, "Presale active");
1807         require(_saleActive, "Sale not active");
1808 
1809         _purchaseMint(tokenId, level);
1810     }
1811 
1812     function presaleMint(uint256 tokenId, uint256 level, bytes32[] calldata proof) external nonReentrant payable {
1813         require(_presaleActive, "Presale not active");
1814         require(_merkleRoot != "", "Allowlist not set");
1815         require(SafeMath.add(_presales[_msgSender()], 1) <= _presaleMax, "Presale token limit reached");
1816         require(
1817             MerkleProof.verify(
1818                 proof,
1819                 _merkleRoot,
1820                 keccak256(abi.encodePacked(_msgSender()))
1821             ),
1822             "Presale invalid"
1823         );
1824 
1825         _purchaseMint(tokenId, level);
1826     }
1827 
1828     function batchMint(uint256[] calldata tokenIds, uint256 level) external nonReentrant payable {
1829         require(!_presaleActive, "Presale active");
1830         require(_saleActive, "Sale not active");
1831         require(tokenIds.length > 0, "Must mint at least 1");
1832         require(tokenIds.length <= _batchMax, "Batch limit reached");
1833 
1834         _batchPurchaseMint(tokenIds, level);
1835     }
1836 
1837     function batchPresaleMint(uint256[] calldata tokenIds, uint256 level, bytes32[] calldata proof) external nonReentrant payable {
1838         require(_presaleActive, "Presale not active");
1839         require(_merkleRoot != "", "Allowlist not set");
1840         require(tokenIds.length > 0, "Must mint at least 1");
1841         require(tokenIds.length <= _batchMax, "Batch limit reached");
1842         require(SafeMath.add(_presales[_msgSender()], tokenIds.length) <= _presaleMax, "Presale token limit reached");
1843         require(
1844             MerkleProof.verify(
1845                 proof,
1846                 _merkleRoot,
1847                 keccak256(abi.encodePacked(_msgSender()))
1848             ),
1849             "Presale invalid"
1850         );
1851 
1852         _batchPurchaseMint(tokenIds, level);
1853     }
1854 
1855     function getLevel(uint256 tokenId) external view returns (uint256) {
1856         _requireMinted(tokenId);
1857 
1858         if (_tokenMap[tokenId] > _levelBaseIndexes[1]) {
1859             return 1;
1860         }
1861         else {
1862             return 0;
1863         }
1864     }
1865 
1866     function setMerkleRoot(bytes32 newRoot) external onlyOwner {
1867         _merkleRoot = newRoot;
1868     }
1869 
1870     function setBaseURI(string memory newBaseURI) external onlyOwner {
1871         _baseTokenURI = newBaseURI;
1872     }
1873 
1874     function startSale(
1875         uint256 newPresaleMax,
1876         uint256 newBatchMax,
1877         uint256 basePrice,
1878         uint256 limitedPrice,
1879         bool presale
1880     ) external onlyOwner {
1881         _saleActive = true;
1882         _presaleActive = presale;
1883 
1884         _presaleMax = newPresaleMax;
1885         _batchMax = newBatchMax;
1886 
1887         _levelPrices[0] = basePrice;
1888         _levelPrices[1] = limitedPrice;
1889     }
1890 
1891     function stopSale() external onlyOwner {
1892         _saleActive = false;
1893         _presaleActive = false;
1894     }
1895 
1896     function setProvenanceHash(string memory provenanceHash) public onlyOwner {
1897         PROVENANCE = provenanceHash;
1898     }
1899 
1900     // from BAYC startingIndex method
1901     // will be called after PROVENANCE is set and at a future, publicly announced date/time,
1902     // so the exact block number cannot be known ahead of time - prior to reveal
1903     function setStartingIndexBlock() public onlyOwner {
1904         require(startingIndexLimited == 0, "Starting index limited is already set");
1905         require(startingIndexBase == 0, "Starting index base is already set");
1906   
1907         startingIndexBlock = block.number;
1908     }
1909 
1910     // from BAYC startingIndex method
1911     // will be called after the startingIndexBlock is set and before reveal
1912     // used for level 0 tokens
1913     function setStartingIndexBase() public {
1914         require(startingIndexBase == 0, "Starting index is already set");
1915         require(startingIndexBlock != 0, "Starting index block must be set");
1916   
1917         startingIndexBase = uint(blockhash(startingIndexBlock)) % TOTAL_TOKENS;
1918         // Just a sanity case in the worst case if this function is called late (EVM only stores last 256 block hashes)
1919         if (block.number.sub(startingIndexBlock) > 255) {
1920             startingIndexBase = uint(blockhash(block.number - 1)) % TOTAL_TOKENS;
1921         }
1922         // Prevent default sequence
1923         if (startingIndexBase == 0) {
1924             startingIndexBase = startingIndexBase.add(1);
1925         }
1926     }
1927 
1928     // from BAYC startingIndex method
1929     // will be called after the startingIndexBlock is set and before reveal
1930     // used for level 1 tokens
1931     function setStartingIndexLimited() public {
1932         require(startingIndexLimited == 0, "Starting index is already set");
1933         require(startingIndexBlock != 0, "Starting index block must be set");
1934   
1935         startingIndexLimited = uint(blockhash(startingIndexBlock)) % _levelMaxes[1];
1936         // Just a sanity case in the worst case if this function is called late (EVM only stores last 256 block hashes)
1937         if (block.number.sub(startingIndexBlock) > 255) {
1938             startingIndexLimited = uint(blockhash(block.number - 1)) % _levelMaxes[1];
1939         }
1940         // Prevent default sequence
1941         if (startingIndexLimited == 0) {
1942             startingIndexLimited = startingIndexLimited.add(1);
1943         }
1944     }
1945 
1946     function price(uint256 level) external view returns (uint256) {
1947         return _levelPrices[level];
1948     }
1949 
1950     function limitedEditionsMax() external view returns (uint256) {
1951         return _levelMaxes[1];
1952     }
1953 
1954     function batchMax() external view returns (uint256) {
1955         return _batchMax;
1956     }
1957 
1958     function presaleMax() external view returns (uint256) {
1959         return _presaleMax;
1960     }
1961 
1962     function presaleActive() external view returns (bool) {
1963         return _presaleActive;
1964     }
1965 
1966     function saleActive() external view returns (bool) {
1967         return _saleActive;
1968     }
1969 
1970     function withdraw() public payable onlyOwner nonReentrant {
1971         (bool success, ) = payable(msg.sender).call{value: address(this).balance}("");
1972         require(success, "Withdrawal failed");
1973     }
1974 
1975     /**
1976       * @dev _purchaseMint
1977       * @param tokenId Token ID to mint
1978       * @param level The token level to mint
1979     */
1980     function _purchaseMint(uint256 tokenId, uint256 level) internal {
1981         require(tokenId > 0, "tokenId out of range");
1982         require(tokenId <= TOTAL_TOKENS, "tokenId out of range");
1983         require(_msgSender() == AssociativeNFT.ownerOf(tokenId), "Only the X,Y Project token owner can mint this tokenId");
1984         require(level >= 0 && level <= 1, "Level is out of range");
1985         require(_levelBalances[level] < _levelMaxes[level], "No more tokens available at this level");
1986         require(_levelPrices[level] <= msg.value, "Not enough ETH");
1987 
1988         _safeMint(_msgSender(), tokenId);
1989         _levelBalances[level] = SafeMath.add(_levelBalances[level], 1);
1990         _tokenMap[tokenId] = SafeMath.add(_levelBaseIndexes[level], _levelBalances[level]);
1991         if (_presaleActive) {
1992           _presales[_msgSender()] = SafeMath.add(_presales[_msgSender()], 1);
1993         }
1994     }
1995 
1996     /**
1997       * @dev _batchPurchaseMint
1998       * @param tokenIds Token IDs to mint
1999       * @param level The token level to mint
2000     */
2001     function _batchPurchaseMint(uint256[] memory tokenIds, uint256 level) internal {
2002         require(SafeMath.add(tokenIds.length, _levelBalances[level]) <= _levelMaxes[level], "Not enough tokens available at this level");
2003         require(SafeMath.mul(tokenIds.length, _levelPrices[level]) <= msg.value, "Not enough ETH");
2004 
2005         for (uint i = 0; i < tokenIds.length; i++) {
2006             _purchaseMint(tokenIds[i], level);
2007         }
2008     }
2009     
2010     // ERC721 Overrides
2011 
2012     /**
2013       * @dev _mint override to remove unneeded storage
2014     */
2015     function _mint(address to, uint256 tokenId) internal override {
2016         require(to != address(0), "ERC721: mint to the zero address");
2017         require(!_exists(tokenId), "ERC721: token already minted");
2018         require(tokenId > 0, "tokenId out of range");
2019         require(tokenId <= TOTAL_TOKENS, "tokenId out of range");
2020 
2021         _beforeTokenTransfer(address(0), to, tokenId);
2022 
2023         //_balances[to] += 1;
2024         //_owners[tokenId] = to;
2025 
2026         emit Transfer(address(0), to, tokenId);
2027 
2028         _afterTokenTransfer(address(0), to, tokenId);
2029     }
2030 
2031     /**
2032      * @dev _exists override because we don't set _owners anymore
2033      */
2034     function _exists(uint256 tokenId) internal view override returns (bool) {
2035         return _tokenMap[tokenId] != 0;
2036     }
2037 }