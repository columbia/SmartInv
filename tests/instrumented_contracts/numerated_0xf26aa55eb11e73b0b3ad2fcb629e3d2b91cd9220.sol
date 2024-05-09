1 // SPDX-License-Identifier: MIT
2 // OpenZeppelin Contracts v4.4.1 (utils/introspection/IERC165.sol)
3 
4 pragma solidity ^0.8.0;
5 
6 /**
7  * @dev Interface of the ERC165 standard, as defined in the
8  * https://eips.ethereum.org/EIPS/eip-165[EIP].
9  *
10  * Implementers can declare support of contract interfaces, which can then be
11  * queried by others ({ERC165Checker}).
12  *
13  * For an implementation, see {ERC165}.
14  */
15 interface IERC165 {
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
27 // OpenZeppelin Contracts v4.4.1 (token/ERC721/IERC721.sol)
28 
29 
30 
31 
32 
33 /**
34  * @dev Required interface of an ERC721 compliant contract.
35  */
36 interface IERC721 is IERC165 {
37     /**
38      * @dev Emitted when `tokenId` token is transferred from `from` to `to`.
39      */
40     event Transfer(address indexed from, address indexed to, uint256 indexed tokenId);
41 
42     /**
43      * @dev Emitted when `owner` enables `approved` to manage the `tokenId` token.
44      */
45     event Approval(address indexed owner, address indexed approved, uint256 indexed tokenId);
46 
47     /**
48      * @dev Emitted when `owner` enables or disables (`approved`) `operator` to manage all of its assets.
49      */
50     event ApprovalForAll(address indexed owner, address indexed operator, bool approved);
51 
52     /**
53      * @dev Returns the number of tokens in ``owner``'s account.
54      */
55     function balanceOf(address owner) external view returns (uint256 balance);
56 
57     /**
58      * @dev Returns the owner of the `tokenId` token.
59      *
60      * Requirements:
61      *
62      * - `tokenId` must exist.
63      */
64     function ownerOf(uint256 tokenId) external view returns (address owner);
65 
66     /**
67      * @dev Safely transfers `tokenId` token from `from` to `to`, checking first that contract recipients
68      * are aware of the ERC721 protocol to prevent tokens from being forever locked.
69      *
70      * Requirements:
71      *
72      * - `from` cannot be the zero address.
73      * - `to` cannot be the zero address.
74      * - `tokenId` token must exist and be owned by `from`.
75      * - If the caller is not `from`, it must be have been allowed to move this token by either {approve} or {setApprovalForAll}.
76      * - If `to` refers to a smart contract, it must implement {IERC721Receiver-onERC721Received}, which is called upon a safe transfer.
77      *
78      * Emits a {Transfer} event.
79      */
80     function safeTransferFrom(
81         address from,
82         address to,
83         uint256 tokenId
84     ) external;
85 
86     /**
87      * @dev Transfers `tokenId` token from `from` to `to`.
88      *
89      * WARNING: Usage of this method is discouraged, use {safeTransferFrom} whenever possible.
90      *
91      * Requirements:
92      *
93      * - `from` cannot be the zero address.
94      * - `to` cannot be the zero address.
95      * - `tokenId` token must be owned by `from`.
96      * - If the caller is not `from`, it must be approved to move this token by either {approve} or {setApprovalForAll}.
97      *
98      * Emits a {Transfer} event.
99      */
100     function transferFrom(
101         address from,
102         address to,
103         uint256 tokenId
104     ) external;
105 
106     /**
107      * @dev Gives permission to `to` to transfer `tokenId` token to another account.
108      * The approval is cleared when the token is transferred.
109      *
110      * Only a single account can be approved at a time, so approving the zero address clears previous approvals.
111      *
112      * Requirements:
113      *
114      * - The caller must own the token or be an approved operator.
115      * - `tokenId` must exist.
116      *
117      * Emits an {Approval} event.
118      */
119     function approve(address to, uint256 tokenId) external;
120 
121     /**
122      * @dev Returns the account approved for `tokenId` token.
123      *
124      * Requirements:
125      *
126      * - `tokenId` must exist.
127      */
128     function getApproved(uint256 tokenId) external view returns (address operator);
129 
130     /**
131      * @dev Approve or remove `operator` as an operator for the caller.
132      * Operators can call {transferFrom} or {safeTransferFrom} for any token owned by the caller.
133      *
134      * Requirements:
135      *
136      * - The `operator` cannot be the caller.
137      *
138      * Emits an {ApprovalForAll} event.
139      */
140     function setApprovalForAll(address operator, bool _approved) external;
141 
142     /**
143      * @dev Returns if the `operator` is allowed to manage all of the assets of `owner`.
144      *
145      * See {setApprovalForAll}
146      */
147     function isApprovedForAll(address owner, address operator) external view returns (bool);
148 
149     /**
150      * @dev Safely transfers `tokenId` token from `from` to `to`.
151      *
152      * Requirements:
153      *
154      * - `from` cannot be the zero address.
155      * - `to` cannot be the zero address.
156      * - `tokenId` token must exist and be owned by `from`.
157      * - If the caller is not `from`, it must be approved to move this token by either {approve} or {setApprovalForAll}.
158      * - If `to` refers to a smart contract, it must implement {IERC721Receiver-onERC721Received}, which is called upon a safe transfer.
159      *
160      * Emits a {Transfer} event.
161      */
162     function safeTransferFrom(
163         address from,
164         address to,
165         uint256 tokenId,
166         bytes calldata data
167     ) external;
168 }
169 
170 // OpenZeppelin Contracts v4.4.1 (utils/Strings.sol)
171 
172 
173 
174 /**
175  * @dev String operations.
176  */
177 library Strings {
178     bytes16 private constant _HEX_SYMBOLS = "0123456789abcdef";
179 
180     /**
181      * @dev Converts a `uint256` to its ASCII `string` decimal representation.
182      */
183     function toString(uint256 value) internal pure returns (string memory) {
184         // Inspired by OraclizeAPI's implementation - MIT licence
185         // https://github.com/oraclize/ethereum-api/blob/b42146b063c7d6ee1358846c198246239e9360e8/oraclizeAPI_0.4.25.sol
186 
187         if (value == 0) {
188             return "0";
189         }
190         uint256 temp = value;
191         uint256 digits;
192         while (temp != 0) {
193             digits++;
194             temp /= 10;
195         }
196         bytes memory buffer = new bytes(digits);
197         while (value != 0) {
198             digits -= 1;
199             buffer[digits] = bytes1(uint8(48 + uint256(value % 10)));
200             value /= 10;
201         }
202         return string(buffer);
203     }
204 
205     /**
206      * @dev Converts a `uint256` to its ASCII `string` hexadecimal representation.
207      */
208     function toHexString(uint256 value) internal pure returns (string memory) {
209         if (value == 0) {
210             return "0x00";
211         }
212         uint256 temp = value;
213         uint256 length = 0;
214         while (temp != 0) {
215             length++;
216             temp >>= 8;
217         }
218         return toHexString(value, length);
219     }
220 
221     /**
222      * @dev Converts a `uint256` to its ASCII `string` hexadecimal representation with fixed length.
223      */
224     function toHexString(uint256 value, uint256 length) internal pure returns (string memory) {
225         bytes memory buffer = new bytes(2 * length + 2);
226         buffer[0] = "0";
227         buffer[1] = "x";
228         for (uint256 i = 2 * length + 1; i > 1; --i) {
229             buffer[i] = _HEX_SYMBOLS[value & 0xf];
230             value >>= 4;
231         }
232         require(value == 0, "Strings: hex length insufficient");
233         return string(buffer);
234     }
235 }
236 
237 // OpenZeppelin Contracts v4.4.1 (utils/Context.sol)
238 
239 
240 
241 /**
242  * @dev Provides information about the current execution context, including the
243  * sender of the transaction and its data. While these are generally available
244  * via msg.sender and msg.data, they should not be accessed in such a direct
245  * manner, since when dealing with meta-transactions the account sending and
246  * paying for execution may not be the actual sender (as far as an application
247  * is concerned).
248  *
249  * This contract is only required for intermediate, library-like contracts.
250  */
251 abstract contract Context {
252     function _msgSender() internal view virtual returns (address) {
253         return msg.sender;
254     }
255 
256     function _msgData() internal view virtual returns (bytes calldata) {
257         return msg.data;
258     }
259 }
260 
261 // agent.sol
262 
263 
264 
265 
266 // OpenZeppelin Contracts v4.4.1 (token/ERC721/extensions/ERC721Enumerable.sol)
267 
268 
269 
270 
271 // OpenZeppelin Contracts (last updated v4.5.0) (token/ERC721/ERC721.sol)
272 
273 
274 
275 
276 
277 // OpenZeppelin Contracts v4.4.1 (token/ERC721/IERC721Receiver.sol)
278 
279 
280 
281 /**
282  * @title ERC721 token receiver interface
283  * @dev Interface for any contract that wants to support safeTransfers
284  * from ERC721 asset contracts.
285  */
286 interface IERC721Receiver {
287     /**
288      * @dev Whenever an {IERC721} `tokenId` token is transferred to this contract via {IERC721-safeTransferFrom}
289      * by `operator` from `from`, this function is called.
290      *
291      * It must return its Solidity selector to confirm the token transfer.
292      * If any other value is returned or the interface is not implemented by the recipient, the transfer will be reverted.
293      *
294      * The selector can be obtained in Solidity with `IERC721.onERC721Received.selector`.
295      */
296     function onERC721Received(
297         address operator,
298         address from,
299         uint256 tokenId,
300         bytes calldata data
301     ) external returns (bytes4);
302 }
303 
304 
305 // OpenZeppelin Contracts v4.4.1 (token/ERC721/extensions/IERC721Metadata.sol)
306 
307 
308 
309 
310 
311 /**
312  * @title ERC-721 Non-Fungible Token Standard, optional metadata extension
313  * @dev See https://eips.ethereum.org/EIPS/eip-721
314  */
315 interface IERC721Metadata is IERC721 {
316     /**
317      * @dev Returns the token collection name.
318      */
319     function name() external view returns (string memory);
320 
321     /**
322      * @dev Returns the token collection symbol.
323      */
324     function symbol() external view returns (string memory);
325 
326     /**
327      * @dev Returns the Uniform Resource Identifier (URI) for `tokenId` token.
328      */
329     function tokenURI(uint256 tokenId) external view returns (string memory);
330 }
331 
332 
333 // OpenZeppelin Contracts (last updated v4.5.0) (utils/Address.sol)
334 
335 
336 
337 /**
338  * @dev Collection of functions related to the address type
339  */
340 library Address {
341     /**
342      * @dev Returns true if `account` is a contract.
343      *
344      * [IMPORTANT]
345      * ====
346      * It is unsafe to assume that an address for which this function returns
347      * false is an externally-owned account (EOA) and not a contract.
348      *
349      * Among others, `isContract` will return false for the following
350      * types of addresses:
351      *
352      *  - an externally-owned account
353      *  - a contract in construction
354      *  - an address where a contract will be created
355      *  - an address where a contract lived, but was destroyed
356      * ====
357      *
358      * [IMPORTANT]
359      * ====
360      * You shouldn't rely on `isContract` to protect against flash loan attacks!
361      *
362      * Preventing calls from contracts is highly discouraged. It breaks composability, breaks support for smart wallets
363      * like Gnosis Safe, and does not provide security since it can be circumvented by calling from a contract
364      * constructor.
365      * ====
366      */
367     function isContract(address account) internal view returns (bool) {
368         // This method relies on extcodesize/address.code.length, which returns 0
369         // for contracts in construction, since the code is only stored at the end
370         // of the constructor execution.
371 
372         return account.code.length > 0;
373     }
374 
375     /**
376      * @dev Replacement for Solidity's `transfer`: sends `amount` wei to
377      * `recipient`, forwarding all available gas and reverting on errors.
378      *
379      * https://eips.ethereum.org/EIPS/eip-1884[EIP1884] increases the gas cost
380      * of certain opcodes, possibly making contracts go over the 2300 gas limit
381      * imposed by `transfer`, making them unable to receive funds via
382      * `transfer`. {sendValue} removes this limitation.
383      *
384      * https://diligence.consensys.net/posts/2019/09/stop-using-soliditys-transfer-now/[Learn more].
385      *
386      * IMPORTANT: because control is transferred to `recipient`, care must be
387      * taken to not create reentrancy vulnerabilities. Consider using
388      * {ReentrancyGuard} or the
389      * https://solidity.readthedocs.io/en/v0.5.11/security-considerations.html#use-the-checks-effects-interactions-pattern[checks-effects-interactions pattern].
390      */
391     function sendValue(address payable recipient, uint256 amount) internal {
392         require(address(this).balance >= amount, "Address: insufficient balance");
393 
394         (bool success, ) = recipient.call{value: amount}("");
395         require(success, "Address: unable to send value, recipient may have reverted");
396     }
397 
398     /**
399      * @dev Performs a Solidity function call using a low level `call`. A
400      * plain `call` is an unsafe replacement for a function call: use this
401      * function instead.
402      *
403      * If `target` reverts with a revert reason, it is bubbled up by this
404      * function (like regular Solidity function calls).
405      *
406      * Returns the raw returned data. To convert to the expected return value,
407      * use https://solidity.readthedocs.io/en/latest/units-and-global-variables.html?highlight=abi.decode#abi-encoding-and-decoding-functions[`abi.decode`].
408      *
409      * Requirements:
410      *
411      * - `target` must be a contract.
412      * - calling `target` with `data` must not revert.
413      *
414      * _Available since v3.1._
415      */
416     function functionCall(address target, bytes memory data) internal returns (bytes memory) {
417         return functionCall(target, data, "Address: low-level call failed");
418     }
419 
420     /**
421      * @dev Same as {xref-Address-functionCall-address-bytes-}[`functionCall`], but with
422      * `errorMessage` as a fallback revert reason when `target` reverts.
423      *
424      * _Available since v3.1._
425      */
426     function functionCall(
427         address target,
428         bytes memory data,
429         string memory errorMessage
430     ) internal returns (bytes memory) {
431         return functionCallWithValue(target, data, 0, errorMessage);
432     }
433 
434     /**
435      * @dev Same as {xref-Address-functionCall-address-bytes-}[`functionCall`],
436      * but also transferring `value` wei to `target`.
437      *
438      * Requirements:
439      *
440      * - the calling contract must have an ETH balance of at least `value`.
441      * - the called Solidity function must be `payable`.
442      *
443      * _Available since v3.1._
444      */
445     function functionCallWithValue(
446         address target,
447         bytes memory data,
448         uint256 value
449     ) internal returns (bytes memory) {
450         return functionCallWithValue(target, data, value, "Address: low-level call with value failed");
451     }
452 
453     /**
454      * @dev Same as {xref-Address-functionCallWithValue-address-bytes-uint256-}[`functionCallWithValue`], but
455      * with `errorMessage` as a fallback revert reason when `target` reverts.
456      *
457      * _Available since v3.1._
458      */
459     function functionCallWithValue(
460         address target,
461         bytes memory data,
462         uint256 value,
463         string memory errorMessage
464     ) internal returns (bytes memory) {
465         require(address(this).balance >= value, "Address: insufficient balance for call");
466         require(isContract(target), "Address: call to non-contract");
467 
468         (bool success, bytes memory returndata) = target.call{value: value}(data);
469         return verifyCallResult(success, returndata, errorMessage);
470     }
471 
472     /**
473      * @dev Same as {xref-Address-functionCall-address-bytes-}[`functionCall`],
474      * but performing a static call.
475      *
476      * _Available since v3.3._
477      */
478     function functionStaticCall(address target, bytes memory data) internal view returns (bytes memory) {
479         return functionStaticCall(target, data, "Address: low-level static call failed");
480     }
481 
482     /**
483      * @dev Same as {xref-Address-functionCall-address-bytes-string-}[`functionCall`],
484      * but performing a static call.
485      *
486      * _Available since v3.3._
487      */
488     function functionStaticCall(
489         address target,
490         bytes memory data,
491         string memory errorMessage
492     ) internal view returns (bytes memory) {
493         require(isContract(target), "Address: static call to non-contract");
494 
495         (bool success, bytes memory returndata) = target.staticcall(data);
496         return verifyCallResult(success, returndata, errorMessage);
497     }
498 
499     /**
500      * @dev Same as {xref-Address-functionCall-address-bytes-}[`functionCall`],
501      * but performing a delegate call.
502      *
503      * _Available since v3.4._
504      */
505     function functionDelegateCall(address target, bytes memory data) internal returns (bytes memory) {
506         return functionDelegateCall(target, data, "Address: low-level delegate call failed");
507     }
508 
509     /**
510      * @dev Same as {xref-Address-functionCall-address-bytes-string-}[`functionCall`],
511      * but performing a delegate call.
512      *
513      * _Available since v3.4._
514      */
515     function functionDelegateCall(
516         address target,
517         bytes memory data,
518         string memory errorMessage
519     ) internal returns (bytes memory) {
520         require(isContract(target), "Address: delegate call to non-contract");
521 
522         (bool success, bytes memory returndata) = target.delegatecall(data);
523         return verifyCallResult(success, returndata, errorMessage);
524     }
525 
526     /**
527      * @dev Tool to verifies that a low level call was successful, and revert if it wasn't, either by bubbling the
528      * revert reason using the provided one.
529      *
530      * _Available since v4.3._
531      */
532     function verifyCallResult(
533         bool success,
534         bytes memory returndata,
535         string memory errorMessage
536     ) internal pure returns (bytes memory) {
537         if (success) {
538             return returndata;
539         } else {
540             // Look for revert reason and bubble it up if present
541             if (returndata.length > 0) {
542                 // The easiest way to bubble the revert reason is using memory via assembly
543 
544                 assembly {
545                     let returndata_size := mload(returndata)
546                     revert(add(32, returndata), returndata_size)
547                 }
548             } else {
549                 revert(errorMessage);
550             }
551         }
552     }
553 }
554 
555 
556 
557 
558 // OpenZeppelin Contracts v4.4.1 (utils/introspection/ERC165.sol)
559 
560 
561 
562 
563 
564 /**
565  * @dev Implementation of the {IERC165} interface.
566  *
567  * Contracts that want to implement ERC165 should inherit from this contract and override {supportsInterface} to check
568  * for the additional interface id that will be supported. For example:
569  *
570  * ```solidity
571  * function supportsInterface(bytes4 interfaceId) public view virtual override returns (bool) {
572  *     return interfaceId == type(MyInterface).interfaceId || super.supportsInterface(interfaceId);
573  * }
574  * ```
575  *
576  * Alternatively, {ERC165Storage} provides an easier to use but more expensive implementation.
577  */
578 abstract contract ERC165 is IERC165 {
579     /**
580      * @dev See {IERC165-supportsInterface}.
581      */
582     function supportsInterface(bytes4 interfaceId) public view virtual override returns (bool) {
583         return interfaceId == type(IERC165).interfaceId;
584     }
585 }
586 
587 
588 /**
589  * @dev Implementation of https://eips.ethereum.org/EIPS/eip-721[ERC721] Non-Fungible Token Standard, including
590  * the Metadata extension, but not including the Enumerable extension, which is available separately as
591  * {ERC721Enumerable}.
592  */
593 contract ERC721 is Context, ERC165, IERC721, IERC721Metadata {
594     using Address for address;
595     using Strings for uint256;
596 
597     // Token name
598     string private _name;
599 
600     // Token symbol
601     string private _symbol;
602 
603     // Mapping from token ID to owner address
604     mapping(uint256 => address) private _owners;
605 
606     // Mapping owner address to token count
607     mapping(address => uint256) private _balances;
608 
609     // Mapping from token ID to approved address
610     mapping(uint256 => address) private _tokenApprovals;
611 
612     // Mapping from owner to operator approvals
613     mapping(address => mapping(address => bool)) private _operatorApprovals;
614 
615     /**
616      * @dev Initializes the contract by setting a `name` and a `symbol` to the token collection.
617      */
618     constructor(string memory name_, string memory symbol_) {
619         _name = name_;
620         _symbol = symbol_;
621     }
622 
623     /**
624      * @dev See {IERC165-supportsInterface}.
625      */
626     function supportsInterface(bytes4 interfaceId) public view virtual override(ERC165, IERC165) returns (bool) {
627         return
628             interfaceId == type(IERC721).interfaceId ||
629             interfaceId == type(IERC721Metadata).interfaceId ||
630             super.supportsInterface(interfaceId);
631     }
632 
633     /**
634      * @dev See {IERC721-balanceOf}.
635      */
636     function balanceOf(address owner) public view virtual override returns (uint256) {
637         require(owner != address(0), "ERC721: balance query for the zero address");
638         return _balances[owner];
639     }
640 
641     /**
642      * @dev See {IERC721-ownerOf}.
643      */
644     function ownerOf(uint256 tokenId) public view virtual override returns (address) {
645         address owner = _owners[tokenId];
646         require(owner != address(0), "ERC721: owner query for nonexistent token");
647         return owner;
648     }
649 
650     /**
651      * @dev See {IERC721Metadata-name}.
652      */
653     function name() public view virtual override returns (string memory) {
654         return _name;
655     }
656 
657     /**
658      * @dev See {IERC721Metadata-symbol}.
659      */
660     function symbol() public view virtual override returns (string memory) {
661         return _symbol;
662     }
663 
664     /**
665      * @dev See {IERC721Metadata-tokenURI}.
666      */
667     function tokenURI(uint256 tokenId) public view virtual override returns (string memory) {
668         require(_exists(tokenId), "ERC721Metadata: URI query for nonexistent token");
669 
670         string memory baseURI = _baseURI();
671         return bytes(baseURI).length > 0 ? string(abi.encodePacked(baseURI, tokenId.toString())) : "";
672     }
673 
674     /**
675      * @dev Base URI for computing {tokenURI}. If set, the resulting URI for each
676      * token will be the concatenation of the `baseURI` and the `tokenId`. Empty
677      * by default, can be overriden in child contracts.
678      */
679     function _baseURI() internal view virtual returns (string memory) {
680         return "";
681     }
682 
683     /**
684      * @dev See {IERC721-approve}.
685      */
686     function approve(address to, uint256 tokenId) public virtual override {
687         address owner = ERC721.ownerOf(tokenId);
688         require(to != owner, "ERC721: approval to current owner");
689 
690         require(
691             _msgSender() == owner || isApprovedForAll(owner, _msgSender()),
692             "ERC721: approve caller is not owner nor approved for all"
693         );
694 
695         _approve(to, tokenId);
696     }
697 
698     /**
699      * @dev See {IERC721-getApproved}.
700      */
701     function getApproved(uint256 tokenId) public view virtual override returns (address) {
702         require(_exists(tokenId), "ERC721: approved query for nonexistent token");
703 
704         return _tokenApprovals[tokenId];
705     }
706 
707     /**
708      * @dev See {IERC721-setApprovalForAll}.
709      */
710     function setApprovalForAll(address operator, bool approved) public virtual override {
711         _setApprovalForAll(_msgSender(), operator, approved);
712     }
713 
714     /**
715      * @dev See {IERC721-isApprovedForAll}.
716      */
717     function isApprovedForAll(address owner, address operator) public view virtual override returns (bool) {
718         return _operatorApprovals[owner][operator];
719     }
720 
721     /**
722      * @dev See {IERC721-transferFrom}.
723      */
724     function transferFrom(
725         address from,
726         address to,
727         uint256 tokenId
728     ) public virtual override {
729         //solhint-disable-next-line max-line-length
730         require(_isApprovedOrOwner(_msgSender(), tokenId), "ERC721: transfer caller is not owner nor approved");
731 
732         _transfer(from, to, tokenId);
733     }
734 
735     /**
736      * @dev See {IERC721-safeTransferFrom}.
737      */
738     function safeTransferFrom(
739         address from,
740         address to,
741         uint256 tokenId
742     ) public virtual override {
743         safeTransferFrom(from, to, tokenId, "");
744     }
745 
746     /**
747      * @dev See {IERC721-safeTransferFrom}.
748      */
749     function safeTransferFrom(
750         address from,
751         address to,
752         uint256 tokenId,
753         bytes memory _data
754     ) public virtual override {
755         require(_isApprovedOrOwner(_msgSender(), tokenId), "ERC721: transfer caller is not owner nor approved");
756         _safeTransfer(from, to, tokenId, _data);
757     }
758 
759     /**
760      * @dev Safely transfers `tokenId` token from `from` to `to`, checking first that contract recipients
761      * are aware of the ERC721 protocol to prevent tokens from being forever locked.
762      *
763      * `_data` is additional data, it has no specified format and it is sent in call to `to`.
764      *
765      * This internal function is equivalent to {safeTransferFrom}, and can be used to e.g.
766      * implement alternative mechanisms to perform token transfer, such as signature-based.
767      *
768      * Requirements:
769      *
770      * - `from` cannot be the zero address.
771      * - `to` cannot be the zero address.
772      * - `tokenId` token must exist and be owned by `from`.
773      * - If `to` refers to a smart contract, it must implement {IERC721Receiver-onERC721Received}, which is called upon a safe transfer.
774      *
775      * Emits a {Transfer} event.
776      */
777     function _safeTransfer(
778         address from,
779         address to,
780         uint256 tokenId,
781         bytes memory _data
782     ) internal virtual {
783         _transfer(from, to, tokenId);
784         require(_checkOnERC721Received(from, to, tokenId, _data), "ERC721: transfer to non ERC721Receiver implementer");
785     }
786 
787     /**
788      * @dev Returns whether `tokenId` exists.
789      *
790      * Tokens can be managed by their owner or approved accounts via {approve} or {setApprovalForAll}.
791      *
792      * Tokens start existing when they are minted (`_mint`),
793      * and stop existing when they are burned (`_burn`).
794      */
795     function _exists(uint256 tokenId) internal view virtual returns (bool) {
796         return _owners[tokenId] != address(0);
797     }
798 
799     /**
800      * @dev Returns whether `spender` is allowed to manage `tokenId`.
801      *
802      * Requirements:
803      *
804      * - `tokenId` must exist.
805      */
806     function _isApprovedOrOwner(address spender, uint256 tokenId) internal view virtual returns (bool) {
807         require(_exists(tokenId), "ERC721: operator query for nonexistent token");
808         address owner = ERC721.ownerOf(tokenId);
809         return (spender == owner || getApproved(tokenId) == spender || isApprovedForAll(owner, spender));
810     }
811 
812     /**
813      * @dev Safely mints `tokenId` and transfers it to `to`.
814      *
815      * Requirements:
816      *
817      * - `tokenId` must not exist.
818      * - If `to` refers to a smart contract, it must implement {IERC721Receiver-onERC721Received}, which is called upon a safe transfer.
819      *
820      * Emits a {Transfer} event.
821      */
822     function _safeMint(address to, uint256 tokenId) internal virtual {
823         _safeMint(to, tokenId, "");
824     }
825 
826     /**
827      * @dev Same as {xref-ERC721-_safeMint-address-uint256-}[`_safeMint`], with an additional `data` parameter which is
828      * forwarded in {IERC721Receiver-onERC721Received} to contract recipients.
829      */
830     function _safeMint(
831         address to,
832         uint256 tokenId,
833         bytes memory _data
834     ) internal virtual {
835         _mint(to, tokenId);
836         require(
837             _checkOnERC721Received(address(0), to, tokenId, _data),
838             "ERC721: transfer to non ERC721Receiver implementer"
839         );
840     }
841 
842     /**
843      * @dev Mints `tokenId` and transfers it to `to`.
844      *
845      * WARNING: Usage of this method is discouraged, use {_safeMint} whenever possible
846      *
847      * Requirements:
848      *
849      * - `tokenId` must not exist.
850      * - `to` cannot be the zero address.
851      *
852      * Emits a {Transfer} event.
853      */
854     function _mint(address to, uint256 tokenId) internal virtual {
855         require(to != address(0), "ERC721: mint to the zero address");
856         require(!_exists(tokenId), "ERC721: token already minted");
857 
858         _beforeTokenTransfer(address(0), to, tokenId);
859 
860         _balances[to] += 1;
861         _owners[tokenId] = to;
862 
863         emit Transfer(address(0), to, tokenId);
864 
865         _afterTokenTransfer(address(0), to, tokenId);
866     }
867 
868     /**
869      * @dev Destroys `tokenId`.
870      * The approval is cleared when the token is burned.
871      *
872      * Requirements:
873      *
874      * - `tokenId` must exist.
875      *
876      * Emits a {Transfer} event.
877      */
878     function _burn(uint256 tokenId) internal virtual {
879         address owner = ERC721.ownerOf(tokenId);
880 
881         _beforeTokenTransfer(owner, address(0), tokenId);
882 
883         // Clear approvals
884         _approve(address(0), tokenId);
885 
886         _balances[owner] -= 1;
887         delete _owners[tokenId];
888 
889         emit Transfer(owner, address(0), tokenId);
890 
891         _afterTokenTransfer(owner, address(0), tokenId);
892     }
893 
894     /**
895      * @dev Transfers `tokenId` from `from` to `to`.
896      *  As opposed to {transferFrom}, this imposes no restrictions on msg.sender.
897      *
898      * Requirements:
899      *
900      * - `to` cannot be the zero address.
901      * - `tokenId` token must be owned by `from`.
902      *
903      * Emits a {Transfer} event.
904      */
905     function _transfer(
906         address from,
907         address to,
908         uint256 tokenId
909     ) internal virtual {
910         require(ERC721.ownerOf(tokenId) == from, "ERC721: transfer from incorrect owner");
911         require(to != address(0), "ERC721: transfer to the zero address");
912 
913         _beforeTokenTransfer(from, to, tokenId);
914 
915         // Clear approvals from the previous owner
916         _approve(address(0), tokenId);
917 
918         _balances[from] -= 1;
919         _balances[to] += 1;
920         _owners[tokenId] = to;
921 
922         emit Transfer(from, to, tokenId);
923 
924         _afterTokenTransfer(from, to, tokenId);
925     }
926 
927     /**
928      * @dev Approve `to` to operate on `tokenId`
929      *
930      * Emits a {Approval} event.
931      */
932     function _approve(address to, uint256 tokenId) internal virtual {
933         _tokenApprovals[tokenId] = to;
934         emit Approval(ERC721.ownerOf(tokenId), to, tokenId);
935     }
936 
937     /**
938      * @dev Approve `operator` to operate on all of `owner` tokens
939      *
940      * Emits a {ApprovalForAll} event.
941      */
942     function _setApprovalForAll(
943         address owner,
944         address operator,
945         bool approved
946     ) internal virtual {
947         require(owner != operator, "ERC721: approve to caller");
948         _operatorApprovals[owner][operator] = approved;
949         emit ApprovalForAll(owner, operator, approved);
950     }
951 
952     /**
953      * @dev Internal function to invoke {IERC721Receiver-onERC721Received} on a target address.
954      * The call is not executed if the target address is not a contract.
955      *
956      * @param from address representing the previous owner of the given token ID
957      * @param to target address that will receive the tokens
958      * @param tokenId uint256 ID of the token to be transferred
959      * @param _data bytes optional data to send along with the call
960      * @return bool whether the call correctly returned the expected magic value
961      */
962     function _checkOnERC721Received(
963         address from,
964         address to,
965         uint256 tokenId,
966         bytes memory _data
967     ) private returns (bool) {
968         if (to.isContract()) {
969             try IERC721Receiver(to).onERC721Received(_msgSender(), from, tokenId, _data) returns (bytes4 retval) {
970                 return retval == IERC721Receiver.onERC721Received.selector;
971             } catch (bytes memory reason) {
972                 if (reason.length == 0) {
973                     revert("ERC721: transfer to non ERC721Receiver implementer");
974                 } else {
975                     assembly {
976                         revert(add(32, reason), mload(reason))
977                     }
978                 }
979             }
980         } else {
981             return true;
982         }
983     }
984 
985     /**
986      * @dev Hook that is called before any token transfer. This includes minting
987      * and burning.
988      *
989      * Calling conditions:
990      *
991      * - When `from` and `to` are both non-zero, ``from``'s `tokenId` will be
992      * transferred to `to`.
993      * - When `from` is zero, `tokenId` will be minted for `to`.
994      * - When `to` is zero, ``from``'s `tokenId` will be burned.
995      * - `from` and `to` are never both zero.
996      *
997      * To learn more about hooks, head to xref:ROOT:extending-contracts.adoc#using-hooks[Using Hooks].
998      */
999     function _beforeTokenTransfer(
1000         address from,
1001         address to,
1002         uint256 tokenId
1003     ) internal virtual {}
1004 
1005     /**
1006      * @dev Hook that is called after any transfer of tokens. This includes
1007      * minting and burning.
1008      *
1009      * Calling conditions:
1010      *
1011      * - when `from` and `to` are both non-zero.
1012      * - `from` and `to` are never both zero.
1013      *
1014      * To learn more about hooks, head to xref:ROOT:extending-contracts.adoc#using-hooks[Using Hooks].
1015      */
1016     function _afterTokenTransfer(
1017         address from,
1018         address to,
1019         uint256 tokenId
1020     ) internal virtual {}
1021 }
1022 
1023 
1024 // OpenZeppelin Contracts (last updated v4.5.0) (token/ERC721/extensions/IERC721Enumerable.sol)
1025 
1026 
1027 
1028 
1029 
1030 /**
1031  * @title ERC-721 Non-Fungible Token Standard, optional enumeration extension
1032  * @dev See https://eips.ethereum.org/EIPS/eip-721
1033  */
1034 interface IERC721Enumerable is IERC721 {
1035     /**
1036      * @dev Returns the total amount of tokens stored by the contract.
1037      */
1038     function totalSupply() external view returns (uint256);
1039 
1040     /**
1041      * @dev Returns a token ID owned by `owner` at a given `index` of its token list.
1042      * Use along with {balanceOf} to enumerate all of ``owner``'s tokens.
1043      */
1044     function tokenOfOwnerByIndex(address owner, uint256 index) external view returns (uint256);
1045 
1046     /**
1047      * @dev Returns a token ID at a given `index` of all the tokens stored by the contract.
1048      * Use along with {totalSupply} to enumerate all tokens.
1049      */
1050     function tokenByIndex(uint256 index) external view returns (uint256);
1051 }
1052 
1053 
1054 /**
1055  * @dev This implements an optional extension of {ERC721} defined in the EIP that adds
1056  * enumerability of all the token ids in the contract as well as all token ids owned by each
1057  * account.
1058  */
1059 abstract contract ERC721Enumerable is ERC721, IERC721Enumerable {
1060     // Mapping from owner to list of owned token IDs
1061     mapping(address => mapping(uint256 => uint256)) private _ownedTokens;
1062 
1063     // Mapping from token ID to index of the owner tokens list
1064     mapping(uint256 => uint256) private _ownedTokensIndex;
1065 
1066     // Array with all token ids, used for enumeration
1067     uint256[] private _allTokens;
1068 
1069     // Mapping from token id to position in the allTokens array
1070     mapping(uint256 => uint256) private _allTokensIndex;
1071 
1072     /**
1073      * @dev See {IERC165-supportsInterface}.
1074      */
1075     function supportsInterface(bytes4 interfaceId) public view virtual override(IERC165, ERC721) returns (bool) {
1076         return interfaceId == type(IERC721Enumerable).interfaceId || super.supportsInterface(interfaceId);
1077     }
1078 
1079     /**
1080      * @dev See {IERC721Enumerable-tokenOfOwnerByIndex}.
1081      */
1082     function tokenOfOwnerByIndex(address owner, uint256 index) public view virtual override returns (uint256) {
1083         require(index < ERC721.balanceOf(owner), "ERC721Enumerable: owner index out of bounds");
1084         return _ownedTokens[owner][index];
1085     }
1086 
1087     /**
1088      * @dev See {IERC721Enumerable-totalSupply}.
1089      */
1090     function totalSupply() public view virtual override returns (uint256) {
1091         return _allTokens.length;
1092     }
1093 
1094     /**
1095      * @dev See {IERC721Enumerable-tokenByIndex}.
1096      */
1097     function tokenByIndex(uint256 index) public view virtual override returns (uint256) {
1098         require(index < ERC721Enumerable.totalSupply(), "ERC721Enumerable: global index out of bounds");
1099         return _allTokens[index];
1100     }
1101 
1102     /**
1103      * @dev Hook that is called before any token transfer. This includes minting
1104      * and burning.
1105      *
1106      * Calling conditions:
1107      *
1108      * - When `from` and `to` are both non-zero, ``from``'s `tokenId` will be
1109      * transferred to `to`.
1110      * - When `from` is zero, `tokenId` will be minted for `to`.
1111      * - When `to` is zero, ``from``'s `tokenId` will be burned.
1112      * - `from` cannot be the zero address.
1113      * - `to` cannot be the zero address.
1114      *
1115      * To learn more about hooks, head to xref:ROOT:extending-contracts.adoc#using-hooks[Using Hooks].
1116      */
1117     function _beforeTokenTransfer(
1118         address from,
1119         address to,
1120         uint256 tokenId
1121     ) internal virtual override {
1122         super._beforeTokenTransfer(from, to, tokenId);
1123 
1124         if (from == address(0)) {
1125             _addTokenToAllTokensEnumeration(tokenId);
1126         } else if (from != to) {
1127             _removeTokenFromOwnerEnumeration(from, tokenId);
1128         }
1129         if (to == address(0)) {
1130             _removeTokenFromAllTokensEnumeration(tokenId);
1131         } else if (to != from) {
1132             _addTokenToOwnerEnumeration(to, tokenId);
1133         }
1134     }
1135 
1136     /**
1137      * @dev Private function to add a token to this extension's ownership-tracking data structures.
1138      * @param to address representing the new owner of the given token ID
1139      * @param tokenId uint256 ID of the token to be added to the tokens list of the given address
1140      */
1141     function _addTokenToOwnerEnumeration(address to, uint256 tokenId) private {
1142         uint256 length = ERC721.balanceOf(to);
1143         _ownedTokens[to][length] = tokenId;
1144         _ownedTokensIndex[tokenId] = length;
1145     }
1146 
1147     /**
1148      * @dev Private function to add a token to this extension's token tracking data structures.
1149      * @param tokenId uint256 ID of the token to be added to the tokens list
1150      */
1151     function _addTokenToAllTokensEnumeration(uint256 tokenId) private {
1152         _allTokensIndex[tokenId] = _allTokens.length;
1153         _allTokens.push(tokenId);
1154     }
1155 
1156     /**
1157      * @dev Private function to remove a token from this extension's ownership-tracking data structures. Note that
1158      * while the token is not assigned a new owner, the `_ownedTokensIndex` mapping is _not_ updated: this allows for
1159      * gas optimizations e.g. when performing a transfer operation (avoiding double writes).
1160      * This has O(1) time complexity, but alters the order of the _ownedTokens array.
1161      * @param from address representing the previous owner of the given token ID
1162      * @param tokenId uint256 ID of the token to be removed from the tokens list of the given address
1163      */
1164     function _removeTokenFromOwnerEnumeration(address from, uint256 tokenId) private {
1165         // To prevent a gap in from's tokens array, we store the last token in the index of the token to delete, and
1166         // then delete the last slot (swap and pop).
1167 
1168         uint256 lastTokenIndex = ERC721.balanceOf(from) - 1;
1169         uint256 tokenIndex = _ownedTokensIndex[tokenId];
1170 
1171         // When the token to delete is the last token, the swap operation is unnecessary
1172         if (tokenIndex != lastTokenIndex) {
1173             uint256 lastTokenId = _ownedTokens[from][lastTokenIndex];
1174 
1175             _ownedTokens[from][tokenIndex] = lastTokenId; // Move the last token to the slot of the to-delete token
1176             _ownedTokensIndex[lastTokenId] = tokenIndex; // Update the moved token's index
1177         }
1178 
1179         // This also deletes the contents at the last position of the array
1180         delete _ownedTokensIndex[tokenId];
1181         delete _ownedTokens[from][lastTokenIndex];
1182     }
1183 
1184     /**
1185      * @dev Private function to remove a token from this extension's token tracking data structures.
1186      * This has O(1) time complexity, but alters the order of the _allTokens array.
1187      * @param tokenId uint256 ID of the token to be removed from the tokens list
1188      */
1189     function _removeTokenFromAllTokensEnumeration(uint256 tokenId) private {
1190         // To prevent a gap in the tokens array, we store the last token in the index of the token to delete, and
1191         // then delete the last slot (swap and pop).
1192 
1193         uint256 lastTokenIndex = _allTokens.length - 1;
1194         uint256 tokenIndex = _allTokensIndex[tokenId];
1195 
1196         // When the token to delete is the last token, the swap operation is unnecessary. However, since this occurs so
1197         // rarely (when the last minted token is burnt) that we still do the swap here to avoid the gas cost of adding
1198         // an 'if' statement (like in _removeTokenFromOwnerEnumeration)
1199         uint256 lastTokenId = _allTokens[lastTokenIndex];
1200 
1201         _allTokens[tokenIndex] = lastTokenId; // Move the last token to the slot of the to-delete token
1202         _allTokensIndex[lastTokenId] = tokenIndex; // Update the moved token's index
1203 
1204         // This also deletes the contents at the last position of the array
1205         delete _allTokensIndex[tokenId];
1206         _allTokens.pop();
1207     }
1208 }
1209 
1210 
1211 // OpenZeppelin Contracts v4.4.1 (access/Ownable.sol)
1212 
1213 
1214 
1215 
1216 
1217 /**
1218  * @dev Contract module which provides a basic access control mechanism, where
1219  * there is an account (an owner) that can be granted exclusive access to
1220  * specific functions.
1221  *
1222  * By default, the owner account will be the one that deploys the contract. This
1223  * can later be changed with {transferOwnership}.
1224  *
1225  * This module is used through inheritance. It will make available the modifier
1226  * `onlyOwner`, which can be applied to your functions to restrict their use to
1227  * the owner.
1228  */
1229 abstract contract Ownable is Context {
1230     address private _owner;
1231 
1232     event OwnershipTransferred(address indexed previousOwner, address indexed newOwner);
1233 
1234     /**
1235      * @dev Initializes the contract setting the deployer as the initial owner.
1236      */
1237     constructor() {
1238         _transferOwnership(_msgSender());
1239     }
1240 
1241     /**
1242      * @dev Returns the address of the current owner.
1243      */
1244     function owner() public view virtual returns (address) {
1245         return _owner;
1246     }
1247 
1248     /**
1249      * @dev Throws if called by any account other than the owner.
1250      */
1251     modifier onlyOwner() {
1252         require(owner() == _msgSender(), "Ownable: caller is not the owner");
1253         _;
1254     }
1255 
1256     /**
1257      * @dev Leaves the contract without owner. It will not be possible to call
1258      * `onlyOwner` functions anymore. Can only be called by the current owner.
1259      *
1260      * NOTE: Renouncing ownership will leave the contract without an owner,
1261      * thereby removing any functionality that is only available to the owner.
1262      */
1263     function renounceOwnership() public virtual onlyOwner {
1264         _transferOwnership(address(0));
1265     }
1266 
1267     /**
1268      * @dev Transfers ownership of the contract to a new account (`newOwner`).
1269      * Can only be called by the current owner.
1270      */
1271     function transferOwnership(address newOwner) public virtual onlyOwner {
1272         require(newOwner != address(0), "Ownable: new owner is the zero address");
1273         _transferOwnership(newOwner);
1274     }
1275 
1276     /**
1277      * @dev Transfers ownership of the contract to a new account (`newOwner`).
1278      * Internal function without access restriction.
1279      */
1280     function _transferOwnership(address newOwner) internal virtual {
1281         address oldOwner = _owner;
1282         _owner = newOwner;
1283         emit OwnershipTransferred(oldOwner, newOwner);
1284     }
1285 }
1286 
1287 
1288 interface WireContract {
1289     function balanceOf(address owner, uint id) external view returns (uint balance);
1290     function burn(address user, uint count) external;
1291 }
1292 
1293 contract BasedFishMafiaAgent is ERC721Enumerable, Ownable {
1294     WireContract private constant m_wire = WireContract(address(0x805EA79E3c0C7837cFE8f84EC09eA67d43465Da1));
1295     string private m_baseURI;
1296     uint private m_token_count;
1297 
1298     uint public constant maxSupply = 1870;
1299     string public PROVENANCE = "085231d6beb8d8ffe237d13d9f92cdc3bdf6808d79a4faecaf7e8dce3ff18c23";
1300 
1301     function setProvenanceHash(string memory provenanceHash) public onlyOwner {
1302         PROVENANCE = provenanceHash;
1303     }
1304 
1305     constructor() ERC721("Based Fish Agents", "BFA") {
1306     }
1307 
1308     function mint(uint count) external {
1309         require(m_wire.balanceOf(msg.sender, 0) >= count, "not enough wires in this wallet");
1310         for (uint i = 0; i < count; i++) {
1311             _safeMint(msg.sender, m_token_count++);
1312         }
1313         m_wire.burn(msg.sender, count);
1314     }
1315 
1316     function setBaseURI(string memory baseURI) external onlyOwner {
1317         m_baseURI = baseURI;
1318     }
1319 
1320     function _baseURI() internal view virtual override returns (string memory) {
1321         return m_baseURI;
1322     }
1323 }