1 // SPDX-License-Identifier: MIT
2 pragma solidity >=0.8.4;
3 
4 
5 // OpenZeppelin Contracts v4.4.0 (utils/introspection/IERC165.sol)
6 /**
7  * @dev Interface of the ERC165 standard, as defined in the
8  * https://eips.ethereum.org/EIPS/eip-165[EIP].
9  *
10  * Implementers can declare support of contract interfaces, which can then be
11  * queried by others ({ERC165Checker}).
12  *
13  * For an implementation, see {ERC165}.
14  */
15 interface IERC165Upgradeable {
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
26 
27 
28 // OpenZeppelin Contracts v4.4.0 (token/ERC721/IERC721.sol)
29 /**
30  * @dev Required interface of an ERC721 compliant contract.
31  */
32 interface IERC721Upgradeable is IERC165Upgradeable {
33     /**
34      * @dev Emitted when `tokenId` token is transferred from `from` to `to`.
35      */
36     event Transfer(address indexed from, address indexed to, uint256 indexed tokenId);
37 
38     /**
39      * @dev Emitted when `owner` enables `approved` to manage the `tokenId` token.
40      */
41     event Approval(address indexed owner, address indexed approved, uint256 indexed tokenId);
42 
43     /**
44      * @dev Emitted when `owner` enables or disables (`approved`) `operator` to manage all of its assets.
45      */
46     event ApprovalForAll(address indexed owner, address indexed operator, bool approved);
47 
48     /**
49      * @dev Returns the number of tokens in ``owner``'s account.
50      */
51     function balanceOf(address owner) external view returns (uint256 balance);
52 
53     /**
54      * @dev Returns the owner of the `tokenId` token.
55      *
56      * Requirements:
57      *
58      * - `tokenId` must exist.
59      */
60     function ownerOf(uint256 tokenId) external view returns (address owner);
61 
62     /**
63      * @dev Safely transfers `tokenId` token from `from` to `to`, checking first that contract recipients
64      * are aware of the ERC721 protocol to prevent tokens from being forever locked.
65      *
66      * Requirements:
67      *
68      * - `from` cannot be the zero address.
69      * - `to` cannot be the zero address.
70      * - `tokenId` token must exist and be owned by `from`.
71      * - If the caller is not `from`, it must be have been allowed to move this token by either {approve} or {setApprovalForAll}.
72      * - If `to` refers to a smart contract, it must implement {IERC721Receiver-onERC721Received}, which is called upon a safe transfer.
73      *
74      * Emits a {Transfer} event.
75      */
76     function safeTransferFrom(
77         address from,
78         address to,
79         uint256 tokenId
80     ) external;
81 
82     /**
83      * @dev Transfers `tokenId` token from `from` to `to`.
84      *
85      * WARNING: Usage of this method is discouraged, use {safeTransferFrom} whenever possible.
86      *
87      * Requirements:
88      *
89      * - `from` cannot be the zero address.
90      * - `to` cannot be the zero address.
91      * - `tokenId` token must be owned by `from`.
92      * - If the caller is not `from`, it must be approved to move this token by either {approve} or {setApprovalForAll}.
93      *
94      * Emits a {Transfer} event.
95      */
96     function transferFrom(
97         address from,
98         address to,
99         uint256 tokenId
100     ) external;
101 
102     /**
103      * @dev Gives permission to `to` to transfer `tokenId` token to another account.
104      * The approval is cleared when the token is transferred.
105      *
106      * Only a single account can be approved at a time, so approving the zero address clears previous approvals.
107      *
108      * Requirements:
109      *
110      * - The caller must own the token or be an approved operator.
111      * - `tokenId` must exist.
112      *
113      * Emits an {Approval} event.
114      */
115     function approve(address to, uint256 tokenId) external;
116 
117     /**
118      * @dev Returns the account approved for `tokenId` token.
119      *
120      * Requirements:
121      *
122      * - `tokenId` must exist.
123      */
124     function getApproved(uint256 tokenId) external view returns (address operator);
125 
126     /**
127      * @dev Approve or remove `operator` as an operator for the caller.
128      * Operators can call {transferFrom} or {safeTransferFrom} for any token owned by the caller.
129      *
130      * Requirements:
131      *
132      * - The `operator` cannot be the caller.
133      *
134      * Emits an {ApprovalForAll} event.
135      */
136     function setApprovalForAll(address operator, bool _approved) external;
137 
138     /**
139      * @dev Returns if the `operator` is allowed to manage all of the assets of `owner`.
140      *
141      * See {setApprovalForAll}
142      */
143     function isApprovedForAll(address owner, address operator) external view returns (bool);
144 
145     /**
146      * @dev Safely transfers `tokenId` token from `from` to `to`.
147      *
148      * Requirements:
149      *
150      * - `from` cannot be the zero address.
151      * - `to` cannot be the zero address.
152      * - `tokenId` token must exist and be owned by `from`.
153      * - If the caller is not `from`, it must be approved to move this token by either {approve} or {setApprovalForAll}.
154      * - If `to` refers to a smart contract, it must implement {IERC721Receiver-onERC721Received}, which is called upon a safe transfer.
155      *
156      * Emits a {Transfer} event.
157      */
158     function safeTransferFrom(
159         address from,
160         address to,
161         uint256 tokenId,
162         bytes calldata data
163     ) external;
164 }
165 
166 
167 // OpenZeppelin Contracts v4.4.0 (token/ERC721/IERC721Receiver.sol)
168 /**
169  * @title ERC721 token receiver interface
170  * @dev Interface for any contract that wants to support safeTransfers
171  * from ERC721 asset contracts.
172  */
173 interface IERC721ReceiverUpgradeable {
174     /**
175      * @dev Whenever an {IERC721} `tokenId` token is transferred to this contract via {IERC721-safeTransferFrom}
176      * by `operator` from `from`, this function is called.
177      *
178      * It must return its Solidity selector to confirm the token transfer.
179      * If any other value is returned or the interface is not implemented by the recipient, the transfer will be reverted.
180      *
181      * The selector can be obtained in Solidity with `IERC721.onERC721Received.selector`.
182      */
183     function onERC721Received(
184         address operator,
185         address from,
186         uint256 tokenId,
187         bytes calldata data
188     ) external returns (bytes4);
189 }
190 
191 
192 // OpenZeppelin Contracts v4.4.0 (token/ERC721/extensions/IERC721Metadata.sol)
193 /**
194  * @title ERC-721 Non-Fungible Token Standard, optional metadata extension
195  * @dev See https://eips.ethereum.org/EIPS/eip-721
196  */
197 interface IERC721MetadataUpgradeable is IERC721Upgradeable {
198     /**
199      * @dev Returns the token collection name.
200      */
201     function name() external view returns (string memory);
202 
203     /**
204      * @dev Returns the token collection symbol.
205      */
206     function symbol() external view returns (string memory);
207 
208     /**
209      * @dev Returns the Uniform Resource Identifier (URI) for `tokenId` token.
210      */
211     function tokenURI(uint256 tokenId) external view returns (string memory);
212 }
213 
214 
215 // OpenZeppelin Contracts v4.4.0 (utils/Address.sol)
216 /**
217  * @dev Collection of functions related to the address type
218  */
219 library AddressUpgradeable {
220     /**
221      * @dev Returns true if `account` is a contract.
222      *
223      * [IMPORTANT]
224      * ====
225      * It is unsafe to assume that an address for which this function returns
226      * false is an externally-owned account (EOA) and not a contract.
227      *
228      * Among others, `isContract` will return false for the following
229      * types of addresses:
230      *
231      *  - an externally-owned account
232      *  - a contract in construction
233      *  - an address where a contract will be created
234      *  - an address where a contract lived, but was destroyed
235      * ====
236      */
237     function isContract(address account) internal view returns (bool) {
238         // This method relies on extcodesize, which returns 0 for contracts in
239         // construction, since the code is only stored at the end of the
240         // constructor execution.
241 
242         uint256 size;
243         assembly {
244             size := extcodesize(account)
245         }
246         return size > 0;
247     }
248 
249     /**
250      * @dev Replacement for Solidity's `transfer`: sends `amount` wei to
251      * `recipient`, forwarding all available gas and reverting on errors.
252      *
253      * https://eips.ethereum.org/EIPS/eip-1884[EIP1884] increases the gas cost
254      * of certain opcodes, possibly making contracts go over the 2300 gas limit
255      * imposed by `transfer`, making them unable to receive funds via
256      * `transfer`. {sendValue} removes this limitation.
257      *
258      * https://diligence.consensys.net/posts/2019/09/stop-using-soliditys-transfer-now/[Learn more].
259      *
260      * IMPORTANT: because control is transferred to `recipient`, care must be
261      * taken to not create reentrancy vulnerabilities. Consider using
262      * {ReentrancyGuard} or the
263      * https://solidity.readthedocs.io/en/v0.5.11/security-considerations.html#use-the-checks-effects-interactions-pattern[checks-effects-interactions pattern].
264      */
265     function sendValue(address payable recipient, uint256 amount) internal {
266         require(address(this).balance >= amount, "Address: insufficient balance");
267 
268         (bool success, ) = recipient.call{value: amount}("");
269         require(success, "Address: unable to send value, recipient may have reverted");
270     }
271 
272     /**
273      * @dev Performs a Solidity function call using a low level `call`. A
274      * plain `call` is an unsafe replacement for a function call: use this
275      * function instead.
276      *
277      * If `target` reverts with a revert reason, it is bubbled up by this
278      * function (like regular Solidity function calls).
279      *
280      * Returns the raw returned data. To convert to the expected return value,
281      * use https://solidity.readthedocs.io/en/latest/units-and-global-variables.html?highlight=abi.decode#abi-encoding-and-decoding-functions[`abi.decode`].
282      *
283      * Requirements:
284      *
285      * - `target` must be a contract.
286      * - calling `target` with `data` must not revert.
287      *
288      * _Available since v3.1._
289      */
290     function functionCall(address target, bytes memory data) internal returns (bytes memory) {
291         return functionCall(target, data, "Address: low-level call failed");
292     }
293 
294     /**
295      * @dev Same as {xref-Address-functionCall-address-bytes-}[`functionCall`], but with
296      * `errorMessage` as a fallback revert reason when `target` reverts.
297      *
298      * _Available since v3.1._
299      */
300     function functionCall(
301         address target,
302         bytes memory data,
303         string memory errorMessage
304     ) internal returns (bytes memory) {
305         return functionCallWithValue(target, data, 0, errorMessage);
306     }
307 
308     /**
309      * @dev Same as {xref-Address-functionCall-address-bytes-}[`functionCall`],
310      * but also transferring `value` wei to `target`.
311      *
312      * Requirements:
313      *
314      * - the calling contract must have an ETH balance of at least `value`.
315      * - the called Solidity function must be `payable`.
316      *
317      * _Available since v3.1._
318      */
319     function functionCallWithValue(
320         address target,
321         bytes memory data,
322         uint256 value
323     ) internal returns (bytes memory) {
324         return functionCallWithValue(target, data, value, "Address: low-level call with value failed");
325     }
326 
327     /**
328      * @dev Same as {xref-Address-functionCallWithValue-address-bytes-uint256-}[`functionCallWithValue`], but
329      * with `errorMessage` as a fallback revert reason when `target` reverts.
330      *
331      * _Available since v3.1._
332      */
333     function functionCallWithValue(
334         address target,
335         bytes memory data,
336         uint256 value,
337         string memory errorMessage
338     ) internal returns (bytes memory) {
339         require(address(this).balance >= value, "Address: insufficient balance for call");
340         require(isContract(target), "Address: call to non-contract");
341 
342         (bool success, bytes memory returndata) = target.call{value: value}(data);
343         return verifyCallResult(success, returndata, errorMessage);
344     }
345 
346     /**
347      * @dev Same as {xref-Address-functionCall-address-bytes-}[`functionCall`],
348      * but performing a static call.
349      *
350      * _Available since v3.3._
351      */
352     function functionStaticCall(address target, bytes memory data) internal view returns (bytes memory) {
353         return functionStaticCall(target, data, "Address: low-level static call failed");
354     }
355 
356     /**
357      * @dev Same as {xref-Address-functionCall-address-bytes-string-}[`functionCall`],
358      * but performing a static call.
359      *
360      * _Available since v3.3._
361      */
362     function functionStaticCall(
363         address target,
364         bytes memory data,
365         string memory errorMessage
366     ) internal view returns (bytes memory) {
367         require(isContract(target), "Address: static call to non-contract");
368 
369         (bool success, bytes memory returndata) = target.staticcall(data);
370         return verifyCallResult(success, returndata, errorMessage);
371     }
372 
373     /**
374      * @dev Tool to verifies that a low level call was successful, and revert if it wasn't, either by bubbling the
375      * revert reason using the provided one.
376      *
377      * _Available since v4.3._
378      */
379     function verifyCallResult(
380         bool success,
381         bytes memory returndata,
382         string memory errorMessage
383     ) internal pure returns (bytes memory) {
384         if (success) {
385             return returndata;
386         } else {
387             // Look for revert reason and bubble it up if present
388             if (returndata.length > 0) {
389                 // The easiest way to bubble the revert reason is using memory via assembly
390 
391                 assembly {
392                     let returndata_size := mload(returndata)
393                     revert(add(32, returndata), returndata_size)
394                 }
395             } else {
396                 revert(errorMessage);
397             }
398         }
399     }
400 }
401 
402 
403 // OpenZeppelin Contracts v4.4.0 (proxy/utils/Initializable.sol)
404 /**
405  * @dev This is a base contract to aid in writing upgradeable contracts, or any kind of contract that will be deployed
406  * behind a proxy. Since a proxied contract can't have a constructor, it's common to move constructor logic to an
407  * external initializer function, usually called `initialize`. It then becomes necessary to protect this initializer
408  * function so it can only be called once. The {initializer} modifier provided by this contract will have this effect.
409  *
410  * TIP: To avoid leaving the proxy in an uninitialized state, the initializer function should be called as early as
411  * possible by providing the encoded function call as the `_data` argument to {ERC1967Proxy-constructor}.
412  *
413  * CAUTION: When used with inheritance, manual care must be taken to not invoke a parent initializer twice, or to ensure
414  * that all initializers are idempotent. This is not verified automatically as constructors are by Solidity.
415  *
416  * [CAUTION]
417  * ====
418  * Avoid leaving a contract uninitialized.
419  *
420  * An uninitialized contract can be taken over by an attacker. This applies to both a proxy and its implementation
421  * contract, which may impact the proxy. To initialize the implementation contract, you can either invoke the
422  * initializer manually, or you can include a constructor to automatically mark it as initialized when it is deployed:
423  *
424  * [.hljs-theme-light.nopadding]
425  * ```
426  * /// @custom:oz-upgrades-unsafe-allow constructor
427  * constructor() initializer {}
428  * ```
429  * ====
430  */
431 abstract contract Initializable {
432     /**
433      * @dev Indicates that the contract has been initialized.
434      */
435     bool private _initialized;
436 
437     /**
438      * @dev Indicates that the contract is in the process of being initialized.
439      */
440     bool private _initializing;
441 
442     /**
443      * @dev Modifier to protect an initializer function from being invoked twice.
444      */
445     modifier initializer() {
446         require(_initializing || !_initialized, "Initializable: contract is already initialized");
447 
448         bool isTopLevelCall = !_initializing;
449         if (isTopLevelCall) {
450             _initializing = true;
451             _initialized = true;
452         }
453 
454         _;
455 
456         if (isTopLevelCall) {
457             _initializing = false;
458         }
459     }
460 }
461 
462 
463 // OpenZeppelin Contracts v4.4.0 (utils/Context.sol)
464 /**
465  * @dev Provides information about the current execution context, including the
466  * sender of the transaction and its data. While these are generally available
467  * via msg.sender and msg.data, they should not be accessed in such a direct
468  * manner, since when dealing with meta-transactions the account sending and
469  * paying for execution may not be the actual sender (as far as an application
470  * is concerned).
471  *
472  * This contract is only required for intermediate, library-like contracts.
473  */
474 abstract contract ContextUpgradeable is Initializable {
475     function __Context_init() internal initializer {
476         __Context_init_unchained();
477     }
478 
479     function __Context_init_unchained() internal initializer {
480     }
481     function _msgSender() internal view virtual returns (address) {
482         return msg.sender;
483     }
484 
485     function _msgData() internal view virtual returns (bytes calldata) {
486         return msg.data;
487     }
488     uint256[50] private __gap;
489 }
490 
491 
492 // OpenZeppelin Contracts v4.4.0 (utils/Strings.sol)
493 /**
494  * @dev String operations.
495  */
496 library StringsUpgradeable {
497     bytes16 private constant _HEX_SYMBOLS = "0123456789abcdef";
498 
499     /**
500      * @dev Converts a `uint256` to its ASCII `string` decimal representation.
501      */
502     function toString(uint256 value) internal pure returns (string memory) {
503         // Inspired by OraclizeAPI's implementation - MIT licence
504         // https://github.com/oraclize/ethereum-api/blob/b42146b063c7d6ee1358846c198246239e9360e8/oraclizeAPI_0.4.25.sol
505 
506         if (value == 0) {
507             return "0";
508         }
509         uint256 temp = value;
510         uint256 digits;
511         while (temp != 0) {
512             digits++;
513             temp /= 10;
514         }
515         bytes memory buffer = new bytes(digits);
516         while (value != 0) {
517             digits -= 1;
518             buffer[digits] = bytes1(uint8(48 + uint256(value % 10)));
519             value /= 10;
520         }
521         return string(buffer);
522     }
523 
524     /**
525      * @dev Converts a `uint256` to its ASCII `string` hexadecimal representation.
526      */
527     function toHexString(uint256 value) internal pure returns (string memory) {
528         if (value == 0) {
529             return "0x00";
530         }
531         uint256 temp = value;
532         uint256 length = 0;
533         while (temp != 0) {
534             length++;
535             temp >>= 8;
536         }
537         return toHexString(value, length);
538     }
539 
540     /**
541      * @dev Converts a `uint256` to its ASCII `string` hexadecimal representation with fixed length.
542      */
543     function toHexString(uint256 value, uint256 length) internal pure returns (string memory) {
544         bytes memory buffer = new bytes(2 * length + 2);
545         buffer[0] = "0";
546         buffer[1] = "x";
547         for (uint256 i = 2 * length + 1; i > 1; --i) {
548             buffer[i] = _HEX_SYMBOLS[value & 0xf];
549             value >>= 4;
550         }
551         require(value == 0, "Strings: hex length insufficient");
552         return string(buffer);
553     }
554 }
555 
556 
557 // OpenZeppelin Contracts v4.4.0 (utils/introspection/ERC165.sol)
558 /**
559  * @dev Implementation of the {IERC165} interface.
560  *
561  * Contracts that want to implement ERC165 should inherit from this contract and override {supportsInterface} to check
562  * for the additional interface id that will be supported. For example:
563  *
564  * ```solidity
565  * function supportsInterface(bytes4 interfaceId) public view virtual override returns (bool) {
566  *     return interfaceId == type(MyInterface).interfaceId || super.supportsInterface(interfaceId);
567  * }
568  * ```
569  *
570  * Alternatively, {ERC165Storage} provides an easier to use but more expensive implementation.
571  */
572 abstract contract ERC165Upgradeable is Initializable, IERC165Upgradeable {
573     function __ERC165_init() internal initializer {
574         __ERC165_init_unchained();
575     }
576 
577     function __ERC165_init_unchained() internal initializer {
578     }
579     /**
580      * @dev See {IERC165-supportsInterface}.
581      */
582     function supportsInterface(bytes4 interfaceId) public view virtual override returns (bool) {
583         return interfaceId == type(IERC165Upgradeable).interfaceId;
584     }
585     uint256[50] private __gap;
586 }
587 
588 
589 // OpenZeppelin Contracts v4.4.0 (token/ERC721/ERC721.sol)
590 /**
591  * @dev Implementation of https://eips.ethereum.org/EIPS/eip-721[ERC721] Non-Fungible Token Standard, including
592  * the Metadata extension, but not including the Enumerable extension, which is available separately as
593  * {ERC721Enumerable}.
594  */
595 contract ERC721Upgradeable is Initializable, ContextUpgradeable, ERC165Upgradeable, IERC721Upgradeable, IERC721MetadataUpgradeable {
596     using AddressUpgradeable for address;
597     using StringsUpgradeable for uint256;
598 
599     // Token name
600     string private _name;
601 
602     // Token symbol
603     string private _symbol;
604 
605     // Mapping from token ID to owner address
606     mapping(uint256 => address) private _owners;
607 
608     // Mapping owner address to token count
609     mapping(address => uint256) private _balances;
610 
611     // Mapping from token ID to approved address
612     mapping(uint256 => address) private _tokenApprovals;
613 
614     // Mapping from owner to operator approvals
615     mapping(address => mapping(address => bool)) private _operatorApprovals;
616 
617     /**
618      * @dev Initializes the contract by setting a `name` and a `symbol` to the token collection.
619      */
620     function __ERC721_init(string memory name_, string memory symbol_) internal initializer {
621         __Context_init_unchained();
622         __ERC165_init_unchained();
623         __ERC721_init_unchained(name_, symbol_);
624     }
625 
626     function __ERC721_init_unchained(string memory name_, string memory symbol_) internal initializer {
627         _name = name_;
628         _symbol = symbol_;
629     }
630 
631     /**
632      * @dev See {IERC165-supportsInterface}.
633      */
634     function supportsInterface(bytes4 interfaceId) public view virtual override(ERC165Upgradeable, IERC165Upgradeable) returns (bool) {
635         return
636             interfaceId == type(IERC721Upgradeable).interfaceId ||
637             interfaceId == type(IERC721MetadataUpgradeable).interfaceId ||
638             super.supportsInterface(interfaceId);
639     }
640 
641     /**
642      * @dev See {IERC721-balanceOf}.
643      */
644     function balanceOf(address owner) public view virtual override returns (uint256) {
645         require(owner != address(0), "ERC721: balance query for the zero address");
646         return _balances[owner];
647     }
648 
649     /**
650      * @dev See {IERC721-ownerOf}.
651      */
652     function ownerOf(uint256 tokenId) public view virtual override returns (address) {
653         address owner = _owners[tokenId];
654         require(owner != address(0), "ERC721: owner query for nonexistent token");
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
676         require(_exists(tokenId), "ERC721Metadata: URI query for nonexistent token");
677 
678         string memory baseURI = _baseURI();
679         return bytes(baseURI).length > 0 ? string(abi.encodePacked(baseURI, tokenId.toString())) : "";
680     }
681 
682     /**
683      * @dev Base URI for computing {tokenURI}. If set, the resulting URI for each
684      * token will be the concatenation of the `baseURI` and the `tokenId`. Empty
685      * by default, can be overriden in child contracts.
686      */
687     function _baseURI() internal view virtual returns (string memory) {
688         return "";
689     }
690 
691     /**
692      * @dev See {IERC721-approve}.
693      */
694     function approve(address to, uint256 tokenId) public virtual override {
695         address owner = ERC721Upgradeable.ownerOf(tokenId);
696         require(to != owner, "ERC721: approval to current owner");
697 
698         require(
699             _msgSender() == owner || isApprovedForAll(owner, _msgSender()),
700             "ERC721: approve caller is not owner nor approved for all"
701         );
702 
703         _approve(to, tokenId);
704     }
705 
706     /**
707      * @dev See {IERC721-getApproved}.
708      */
709     function getApproved(uint256 tokenId) public view virtual override returns (address) {
710         require(_exists(tokenId), "ERC721: approved query for nonexistent token");
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
738         require(_isApprovedOrOwner(_msgSender(), tokenId), "ERC721: transfer caller is not owner nor approved");
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
761         bytes memory _data
762     ) public virtual override {
763         require(_isApprovedOrOwner(_msgSender(), tokenId), "ERC721: transfer caller is not owner nor approved");
764         _safeTransfer(from, to, tokenId, _data);
765     }
766 
767     /**
768      * @dev Safely transfers `tokenId` token from `from` to `to`, checking first that contract recipients
769      * are aware of the ERC721 protocol to prevent tokens from being forever locked.
770      *
771      * `_data` is additional data, it has no specified format and it is sent in call to `to`.
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
789         bytes memory _data
790     ) internal virtual {
791         _transfer(from, to, tokenId);
792         require(_checkOnERC721Received(from, to, tokenId, _data), "ERC721: transfer to non ERC721Receiver implementer");
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
815         require(_exists(tokenId), "ERC721: operator query for nonexistent token");
816         address owner = ERC721Upgradeable.ownerOf(tokenId);
817         return (spender == owner || getApproved(tokenId) == spender || isApprovedForAll(owner, spender));
818     }
819 
820     /**
821      * @dev Safely mints `tokenId` and transfers it to `to`.
822      *
823      * Requirements:
824      *
825      * - `tokenId` must not exist.
826      * - If `to` refers to a smart contract, it must implement {IERC721Receiver-onERC721Received}, which is called upon a safe transfer.
827      *
828      * Emits a {Transfer} event.
829      */
830     function _safeMint(address to, uint256 tokenId) internal virtual {
831         _safeMint(to, tokenId, "");
832     }
833 
834     /**
835      * @dev Same as {xref-ERC721-_safeMint-address-uint256-}[`_safeMint`], with an additional `data` parameter which is
836      * forwarded in {IERC721Receiver-onERC721Received} to contract recipients.
837      */
838     function _safeMint(
839         address to,
840         uint256 tokenId,
841         bytes memory _data
842     ) internal virtual {
843         _mint(to, tokenId);
844         require(
845             _checkOnERC721Received(address(0), to, tokenId, _data),
846             "ERC721: transfer to non ERC721Receiver implementer"
847         );
848     }
849 
850     /**
851      * @dev Mints `tokenId` and transfers it to `to`.
852      *
853      * WARNING: Usage of this method is discouraged, use {_safeMint} whenever possible
854      *
855      * Requirements:
856      *
857      * - `tokenId` must not exist.
858      * - `to` cannot be the zero address.
859      *
860      * Emits a {Transfer} event.
861      */
862     function _mint(address to, uint256 tokenId) internal virtual {
863         require(to != address(0), "ERC721: mint to the zero address");
864         require(!_exists(tokenId), "ERC721: token already minted");
865 
866         _beforeTokenTransfer(address(0), to, tokenId);
867 
868         _balances[to] += 1;
869         _owners[tokenId] = to;
870 
871         emit Transfer(address(0), to, tokenId);
872     }
873 
874     /**
875      * @dev Destroys `tokenId`.
876      * The approval is cleared when the token is burned.
877      *
878      * Requirements:
879      *
880      * - `tokenId` must exist.
881      *
882      * Emits a {Transfer} event.
883      */
884     function _burn(uint256 tokenId) internal virtual {
885         address owner = ERC721Upgradeable.ownerOf(tokenId);
886 
887         _beforeTokenTransfer(owner, address(0), tokenId);
888 
889         // Clear approvals
890         _approve(address(0), tokenId);
891 
892         _balances[owner] -= 1;
893         delete _owners[tokenId];
894 
895         emit Transfer(owner, address(0), tokenId);
896     }
897 
898     /**
899      * @dev Transfers `tokenId` from `from` to `to`.
900      *  As opposed to {transferFrom}, this imposes no restrictions on msg.sender.
901      *
902      * Requirements:
903      *
904      * - `to` cannot be the zero address.
905      * - `tokenId` token must be owned by `from`.
906      *
907      * Emits a {Transfer} event.
908      */
909     function _transfer(
910         address from,
911         address to,
912         uint256 tokenId
913     ) internal virtual {
914         require(ERC721Upgradeable.ownerOf(tokenId) == from, "ERC721: transfer of token that is not own");
915         require(to != address(0), "ERC721: transfer to the zero address");
916 
917         _beforeTokenTransfer(from, to, tokenId);
918 
919         // Clear approvals from the previous owner
920         _approve(address(0), tokenId);
921 
922         _balances[from] -= 1;
923         _balances[to] += 1;
924         _owners[tokenId] = to;
925 
926         emit Transfer(from, to, tokenId);
927     }
928 
929     /**
930      * @dev Approve `to` to operate on `tokenId`
931      *
932      * Emits a {Approval} event.
933      */
934     function _approve(address to, uint256 tokenId) internal virtual {
935         _tokenApprovals[tokenId] = to;
936         emit Approval(ERC721Upgradeable.ownerOf(tokenId), to, tokenId);
937     }
938 
939     /**
940      * @dev Approve `operator` to operate on all of `owner` tokens
941      *
942      * Emits a {ApprovalForAll} event.
943      */
944     function _setApprovalForAll(
945         address owner,
946         address operator,
947         bool approved
948     ) internal virtual {
949         require(owner != operator, "ERC721: approve to caller");
950         _operatorApprovals[owner][operator] = approved;
951         emit ApprovalForAll(owner, operator, approved);
952     }
953 
954     /**
955      * @dev Internal function to invoke {IERC721Receiver-onERC721Received} on a target address.
956      * The call is not executed if the target address is not a contract.
957      *
958      * @param from address representing the previous owner of the given token ID
959      * @param to target address that will receive the tokens
960      * @param tokenId uint256 ID of the token to be transferred
961      * @param _data bytes optional data to send along with the call
962      * @return bool whether the call correctly returned the expected magic value
963      */
964     function _checkOnERC721Received(
965         address from,
966         address to,
967         uint256 tokenId,
968         bytes memory _data
969     ) private returns (bool) {
970         if (to.isContract()) {
971             try IERC721ReceiverUpgradeable(to).onERC721Received(_msgSender(), from, tokenId, _data) returns (bytes4 retval) {
972                 return retval == IERC721ReceiverUpgradeable.onERC721Received.selector;
973             } catch (bytes memory reason) {
974                 if (reason.length == 0) {
975                     revert("ERC721: transfer to non ERC721Receiver implementer");
976                 } else {
977                     assembly {
978                         revert(add(32, reason), mload(reason))
979                     }
980                 }
981             }
982         } else {
983             return true;
984         }
985     }
986 
987     /**
988      * @dev Hook that is called before any token transfer. This includes minting
989      * and burning.
990      *
991      * Calling conditions:
992      *
993      * - When `from` and `to` are both non-zero, ``from``'s `tokenId` will be
994      * transferred to `to`.
995      * - When `from` is zero, `tokenId` will be minted for `to`.
996      * - When `to` is zero, ``from``'s `tokenId` will be burned.
997      * - `from` and `to` are never both zero.
998      *
999      * To learn more about hooks, head to xref:ROOT:extending-contracts.adoc#using-hooks[Using Hooks].
1000      */
1001     function _beforeTokenTransfer(
1002         address from,
1003         address to,
1004         uint256 tokenId
1005     ) internal virtual {}
1006     uint256[44] private __gap;
1007 }
1008 
1009 
1010 // OpenZeppelin Contracts v4.4.0 (utils/Strings.sol)
1011 /**
1012  * @dev String operations.
1013  */
1014 library Strings {
1015     bytes16 private constant _HEX_SYMBOLS = "0123456789abcdef";
1016 
1017     /**
1018      * @dev Converts a `uint256` to its ASCII `string` decimal representation.
1019      */
1020     function toString(uint256 value) internal pure returns (string memory) {
1021         // Inspired by OraclizeAPI's implementation - MIT licence
1022         // https://github.com/oraclize/ethereum-api/blob/b42146b063c7d6ee1358846c198246239e9360e8/oraclizeAPI_0.4.25.sol
1023 
1024         if (value == 0) {
1025             return "0";
1026         }
1027         uint256 temp = value;
1028         uint256 digits;
1029         while (temp != 0) {
1030             digits++;
1031             temp /= 10;
1032         }
1033         bytes memory buffer = new bytes(digits);
1034         while (value != 0) {
1035             digits -= 1;
1036             buffer[digits] = bytes1(uint8(48 + uint256(value % 10)));
1037             value /= 10;
1038         }
1039         return string(buffer);
1040     }
1041 
1042     /**
1043      * @dev Converts a `uint256` to its ASCII `string` hexadecimal representation.
1044      */
1045     function toHexString(uint256 value) internal pure returns (string memory) {
1046         if (value == 0) {
1047             return "0x00";
1048         }
1049         uint256 temp = value;
1050         uint256 length = 0;
1051         while (temp != 0) {
1052             length++;
1053             temp >>= 8;
1054         }
1055         return toHexString(value, length);
1056     }
1057 
1058     /**
1059      * @dev Converts a `uint256` to its ASCII `string` hexadecimal representation with fixed length.
1060      */
1061     function toHexString(uint256 value, uint256 length) internal pure returns (string memory) {
1062         bytes memory buffer = new bytes(2 * length + 2);
1063         buffer[0] = "0";
1064         buffer[1] = "x";
1065         for (uint256 i = 2 * length + 1; i > 1; --i) {
1066             buffer[i] = _HEX_SYMBOLS[value & 0xf];
1067             value >>= 4;
1068         }
1069         require(value == 0, "Strings: hex length insufficient");
1070         return string(buffer);
1071     }
1072 }
1073 
1074 
1075 library Bytes {
1076   bytes constant alphabet = "0123456789abcdef";
1077 
1078   /**
1079    * @dev Converts a `uint256` to a `string`.
1080    * via OraclizeAPI - MIT licence
1081    * https://github.com/oraclize/ethereum-api/blob/b42146b063c7d6ee1358846c198246239e9360e8/oraclizeAPI_0.4.25.sol
1082    */
1083   function fromUint(uint256 value) internal pure returns (string memory) {
1084     if (value == 0) {
1085       return "0";
1086     }
1087     uint256 temp = value;
1088     uint256 digits;
1089     while (temp != 0) {
1090       digits++;
1091       temp /= 10;
1092     }
1093     bytes memory buffer = new bytes(digits);
1094     uint256 index = digits - 1;
1095     temp = value;
1096     while (temp != 0) {
1097       buffer[index--] = bytes1(uint8(48 + (temp % 10)));
1098       temp /= 10;
1099     }
1100     return string(buffer);
1101   }
1102 
1103   /**
1104    * Index Of
1105    *
1106    * Locates and returns the position of a character within a string starting
1107    * from a defined offset
1108    *
1109    * @param _base When being used for a data type this is the extended object
1110    *              otherwise this is the string acting as the haystack to be
1111    *              searched
1112    * @param _value The needle to search for, at present this is currently
1113    *               limited to one character
1114    * @param _offset The starting point to start searching from which can start
1115    *                from 0, but must not exceed the length of the string
1116    * @return int The position of the needle starting from 0 and returning -1
1117    *             in the case of no matches found
1118    */
1119   function indexOf(
1120     bytes memory _base,
1121     string memory _value,
1122     uint256 _offset
1123   ) internal pure returns (int256) {
1124     bytes memory _valueBytes = bytes(_value);
1125 
1126     assert(_valueBytes.length == 1);
1127 
1128     for (uint256 i = _offset; i < _base.length; i++) {
1129       if (_base[i] == _valueBytes[0]) {
1130         return int256(i);
1131       }
1132     }
1133 
1134     return -1;
1135   }
1136 
1137   function substring(
1138     bytes memory strBytes,
1139     uint256 startIndex,
1140     uint256 endIndex
1141   ) internal pure returns (string memory) {
1142     bytes memory result = new bytes(endIndex - startIndex);
1143     for (uint256 i = startIndex; i < endIndex; i++) {
1144       result[i - startIndex] = strBytes[i];
1145     }
1146     return string(result);
1147   }
1148 
1149   function toUint(bytes memory b) internal pure returns (uint256) {
1150     uint256 result = 0;
1151     for (uint256 i = 0; i < b.length; i++) {
1152       uint256 val = uint256(uint8(b[i]));
1153       if (val >= 48 && val <= 57) {
1154         result = result * 10 + (val - 48);
1155       }
1156     }
1157     return result;
1158   }
1159 }
1160 
1161 
1162 // Helper library for handling and manipulating bytes
1163 library Parsing {
1164   // Split the minting blob into token_id and blueprint portions
1165   // {token_id}:{blueprint}
1166 
1167   function split(bytes calldata blob)
1168     internal
1169     pure
1170     returns (uint256, bytes memory)
1171   {
1172     int256 index = Bytes.indexOf(blob, ":", 0);
1173     require(index >= 0, "Separator must exist");
1174     // Trim the { and } from the parameters
1175     uint256 tokenID = Bytes.toUint(blob[1:uint256(index) - 1]);
1176     uint256 blueprintLength = blob.length - uint256(index) - 3;
1177     if (blueprintLength == 0) {
1178       return (tokenID, bytes(""));
1179     }
1180     bytes calldata blueprint = blob[uint256(index) + 2:blob.length - 1];
1181     return (tokenID, blueprint);
1182   }
1183 
1184   function getTokenId(bytes calldata blob) internal pure returns (uint256) {
1185     int256 index = Bytes.indexOf(blob, ":", 0);
1186     require(index >= 0, "Separator must exist");
1187     // Trim the { and } from the parameters
1188     return Bytes.toUint(blob[1:uint256(index) - 1]);
1189   }
1190 }
1191 
1192 
1193 // OpenZeppelin Contracts v4.4.0 (access/Ownable.sol)
1194 /**
1195  * @dev Contract module which provides a basic access control mechanism, where
1196  * there is an account (an owner) that can be granted exclusive access to
1197  * specific functions.
1198  *
1199  * By default, the owner account will be the one that deploys the contract. This
1200  * can later be changed with {transferOwnership}.
1201  *
1202  * This module is used through inheritance. It will make available the modifier
1203  * `onlyOwner`, which can be applied to your functions to restrict their use to
1204  * the owner.
1205  */
1206 abstract contract OwnableUpgradeable is Initializable, ContextUpgradeable {
1207     address private _owner;
1208 
1209     event OwnershipTransferred(address indexed previousOwner, address indexed newOwner);
1210 
1211     /**
1212      * @dev Initializes the contract setting the deployer as the initial owner.
1213      */
1214     function __Ownable_init() internal initializer {
1215         __Context_init_unchained();
1216         __Ownable_init_unchained();
1217     }
1218 
1219     function __Ownable_init_unchained() internal initializer {
1220         _transferOwnership(_msgSender());
1221     }
1222 
1223     /**
1224      * @dev Returns the address of the current owner.
1225      */
1226     function owner() public view virtual returns (address) {
1227         return _owner;
1228     }
1229 
1230     /**
1231      * @dev Throws if called by any account other than the owner.
1232      */
1233     modifier onlyOwner() {
1234         require(owner() == _msgSender(), "Ownable: caller is not the owner");
1235         _;
1236     }
1237 
1238     /**
1239      * @dev Leaves the contract without owner. It will not be possible to call
1240      * `onlyOwner` functions anymore. Can only be called by the current owner.
1241      *
1242      * NOTE: Renouncing ownership will leave the contract without an owner,
1243      * thereby removing any functionality that is only available to the owner.
1244      */
1245     function renounceOwnership() public virtual onlyOwner {
1246         _transferOwnership(address(0));
1247     }
1248 
1249     /**
1250      * @dev Transfers ownership of the contract to a new account (`newOwner`).
1251      * Can only be called by the current owner.
1252      */
1253     function transferOwnership(address newOwner) public virtual onlyOwner {
1254         require(newOwner != address(0), "Ownable: new owner is the zero address");
1255         _transferOwnership(newOwner);
1256     }
1257 
1258     /**
1259      * @dev Transfers ownership of the contract to a new account (`newOwner`).
1260      * Internal function without access restriction.
1261      */
1262     function _transferOwnership(address newOwner) internal virtual {
1263         address oldOwner = _owner;
1264         _owner = newOwner;
1265         emit OwnershipTransferred(oldOwner, newOwner);
1266     }
1267     uint256[49] private __gap;
1268 }
1269 
1270 
1271 contract AuthorizableUpgradeable is OwnableUpgradeable {
1272   mapping(address => bool) public authorized;
1273 
1274   modifier onlyAuthorized() {
1275     require(authorized[msg.sender], "UNAUTHORIZED: Sender is not authorized");
1276     _;
1277   }
1278 
1279   function transferOwnership(address newOwner)
1280     public
1281     virtual
1282     override
1283     onlyOwner
1284   {
1285     authorized[owner()] = false;
1286     super.transferOwnership(newOwner);
1287     authorized[newOwner] = true;
1288   }
1289 
1290   function authorize(address _user, bool _authorize) public onlyOwner {
1291     authorized[_user] = _authorize;
1292   }
1293 }
1294 
1295 
1296 contract Collection is ERC721Upgradeable, AuthorizableUpgradeable {
1297   using StringsUpgradeable for uint256;
1298 
1299   uint256 public supply;
1300   string public baseTokenURI;
1301 
1302   mapping(uint256 => string) private _tokenURIs;
1303 
1304   event AssetMinted(address to, uint256 id);
1305 
1306   function init(
1307     string memory _name,
1308     string memory _symbol,
1309     string memory _baseTokenURI,
1310     address _seller,
1311     uint256 _supply,
1312     address[] memory _authorized,
1313     address _owner
1314   ) public initializer {
1315     __ERC721_init(_name, _symbol);
1316     __Ownable_init();
1317     supply = _supply;
1318     for (uint256 i = 0; i < _authorized.length; i++) {
1319       authorize(_authorized[i], true);
1320     }
1321     authorize(_seller, true);
1322     authorize(_owner, true);
1323     baseTokenURI = _baseTokenURI;
1324     transferOwnership(_owner);
1325   }
1326 
1327   function tokenURI(uint256 _tokenId)
1328     public
1329     view
1330     virtual
1331     override
1332     returns (string memory)
1333   {
1334     require(
1335       _exists(_tokenId),
1336       "ERC721Metadata: URI query for nonexistent token"
1337     );
1338     return _calculateTokenURI(_tokenId);
1339   }
1340 
1341   function mintFor(
1342     address _user,
1343     uint256 _quantity,
1344     bytes calldata _mintingBlob
1345   ) external onlyAuthorized {
1346     require(_quantity == 1, "Mintable: invalid quantity");
1347     uint256 id = Parsing.getTokenId(_mintingBlob);
1348     mint(_user, id);
1349   }
1350 
1351   function mint(address _user, uint256 _id) public onlyAuthorized {
1352     _safeMint(_user, _id);
1353     emit AssetMinted(_user, _id);
1354   }
1355 
1356   function _calculateTokenURI(uint256 _tokenId)
1357     internal
1358     view
1359     returns (string memory)
1360   {
1361     return
1362       string(abi.encodePacked(baseTokenURI, "/", Strings.toString(_tokenId)));
1363   }
1364 }