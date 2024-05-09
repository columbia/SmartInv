1 // SPDX-License-Identifier: MIT
2 pragma solidity ^0.8.0;
3 
4 
5 
6 // OpenZeppelin Contracts v4.4.1 (utils/introspection/IERC165.sol)
7 /**
8  * @dev Interface of the ERC165 standard, as defined in the
9  * https://eips.ethereum.org/EIPS/eip-165[EIP].
10  *
11  * Implementers can declare support of contract interfaces, which can then be
12  * queried by others ({ERC165Checker}).
13  *
14  * For an implementation, see {ERC165}.
15  */
16 interface IERC165 {
17     /**
18      * @dev Returns true if this contract implements the interface defined by
19      * `interfaceId`. See the corresponding
20      * https://eips.ethereum.org/EIPS/eip-165#how-interfaces-are-identified[EIP section]
21      * to learn more about how these ids are created.
22      *
23      * This function call must use less than 30 000 gas.
24      */
25     function supportsInterface(bytes4 interfaceId) external view returns (bool);
26 }
27 
28 
29 // OpenZeppelin Contracts v4.4.1 (token/ERC721/IERC721.sol)
30 /**
31  * @dev Required interface of an ERC721 compliant contract.
32  */
33 interface IERC721 is IERC165 {
34     /**
35      * @dev Emitted when `tokenId` token is transferred from `from` to `to`.
36      */
37     event Transfer(address indexed from, address indexed to, uint256 indexed tokenId);
38 
39     /**
40      * @dev Emitted when `owner` enables `approved` to manage the `tokenId` token.
41      */
42     event Approval(address indexed owner, address indexed approved, uint256 indexed tokenId);
43 
44     /**
45      * @dev Emitted when `owner` enables or disables (`approved`) `operator` to manage all of its assets.
46      */
47     event ApprovalForAll(address indexed owner, address indexed operator, bool approved);
48 
49     /**
50      * @dev Returns the number of tokens in ``owner``'s account.
51      */
52     function balanceOf(address owner) external view returns (uint256 balance);
53 
54     /**
55      * @dev Returns the owner of the `tokenId` token.
56      *
57      * Requirements:
58      *
59      * - `tokenId` must exist.
60      */
61     function ownerOf(uint256 tokenId) external view returns (address owner);
62 
63     /**
64      * @dev Safely transfers `tokenId` token from `from` to `to`, checking first that contract recipients
65      * are aware of the ERC721 protocol to prevent tokens from being forever locked.
66      *
67      * Requirements:
68      *
69      * - `from` cannot be the zero address.
70      * - `to` cannot be the zero address.
71      * - `tokenId` token must exist and be owned by `from`.
72      * - If the caller is not `from`, it must be have been allowed to move this token by either {approve} or {setApprovalForAll}.
73      * - If `to` refers to a smart contract, it must implement {IERC721Receiver-onERC721Received}, which is called upon a safe transfer.
74      *
75      * Emits a {Transfer} event.
76      */
77     function safeTransferFrom(
78         address from,
79         address to,
80         uint256 tokenId
81     ) external;
82 
83     /**
84      * @dev Transfers `tokenId` token from `from` to `to`.
85      *
86      * WARNING: Usage of this method is discouraged, use {safeTransferFrom} whenever possible.
87      *
88      * Requirements:
89      *
90      * - `from` cannot be the zero address.
91      * - `to` cannot be the zero address.
92      * - `tokenId` token must be owned by `from`.
93      * - If the caller is not `from`, it must be approved to move this token by either {approve} or {setApprovalForAll}.
94      *
95      * Emits a {Transfer} event.
96      */
97     function transferFrom(
98         address from,
99         address to,
100         uint256 tokenId
101     ) external;
102 
103     /**
104      * @dev Gives permission to `to` to transfer `tokenId` token to another account.
105      * The approval is cleared when the token is transferred.
106      *
107      * Only a single account can be approved at a time, so approving the zero address clears previous approvals.
108      *
109      * Requirements:
110      *
111      * - The caller must own the token or be an approved operator.
112      * - `tokenId` must exist.
113      *
114      * Emits an {Approval} event.
115      */
116     function approve(address to, uint256 tokenId) external;
117 
118     /**
119      * @dev Returns the account approved for `tokenId` token.
120      *
121      * Requirements:
122      *
123      * - `tokenId` must exist.
124      */
125     function getApproved(uint256 tokenId) external view returns (address operator);
126 
127     /**
128      * @dev Approve or remove `operator` as an operator for the caller.
129      * Operators can call {transferFrom} or {safeTransferFrom} for any token owned by the caller.
130      *
131      * Requirements:
132      *
133      * - The `operator` cannot be the caller.
134      *
135      * Emits an {ApprovalForAll} event.
136      */
137     function setApprovalForAll(address operator, bool _approved) external;
138 
139     /**
140      * @dev Returns if the `operator` is allowed to manage all of the assets of `owner`.
141      *
142      * See {setApprovalForAll}
143      */
144     function isApprovedForAll(address owner, address operator) external view returns (bool);
145 
146     /**
147      * @dev Safely transfers `tokenId` token from `from` to `to`.
148      *
149      * Requirements:
150      *
151      * - `from` cannot be the zero address.
152      * - `to` cannot be the zero address.
153      * - `tokenId` token must exist and be owned by `from`.
154      * - If the caller is not `from`, it must be approved to move this token by either {approve} or {setApprovalForAll}.
155      * - If `to` refers to a smart contract, it must implement {IERC721Receiver-onERC721Received}, which is called upon a safe transfer.
156      *
157      * Emits a {Transfer} event.
158      */
159     function safeTransferFrom(
160         address from,
161         address to,
162         uint256 tokenId,
163         bytes calldata data
164     ) external;
165 }
166 
167 
168 // OpenZeppelin Contracts v4.4.1 (token/ERC721/IERC721Receiver.sol)
169 /**
170  * @title ERC721 token receiver interface
171  * @dev Interface for any contract that wants to support safeTransfers
172  * from ERC721 asset contracts.
173  */
174 interface IERC721Receiver {
175     /**
176      * @dev Whenever an {IERC721} `tokenId` token is transferred to this contract via {IERC721-safeTransferFrom}
177      * by `operator` from `from`, this function is called.
178      *
179      * It must return its Solidity selector to confirm the token transfer.
180      * If any other value is returned or the interface is not implemented by the recipient, the transfer will be reverted.
181      *
182      * The selector can be obtained in Solidity with `IERC721.onERC721Received.selector`.
183      */
184     function onERC721Received(
185         address operator,
186         address from,
187         uint256 tokenId,
188         bytes calldata data
189     ) external returns (bytes4);
190 }
191 
192 
193 // OpenZeppelin Contracts v4.4.1 (token/ERC721/extensions/IERC721Metadata.sol)
194 /**
195  * @title ERC-721 Non-Fungible Token Standard, optional metadata extension
196  * @dev See https://eips.ethereum.org/EIPS/eip-721
197  */
198 interface IERC721Metadata is IERC721 {
199     /**
200      * @dev Returns the token collection name.
201      */
202     function name() external view returns (string memory);
203 
204     /**
205      * @dev Returns the token collection symbol.
206      */
207     function symbol() external view returns (string memory);
208 
209     /**
210      * @dev Returns the Uniform Resource Identifier (URI) for `tokenId` token.
211      */
212     function tokenURI(uint256 tokenId) external view returns (string memory);
213 }
214 
215 
216 // OpenZeppelin Contracts v4.4.1 (utils/Address.sol)
217 /**
218  * @dev Collection of functions related to the address type
219  */
220 library Address {
221     /**
222      * @dev Returns true if `account` is a contract.
223      *
224      * [IMPORTANT]
225      * ====
226      * It is unsafe to assume that an address for which this function returns
227      * false is an externally-owned account (EOA) and not a contract.
228      *
229      * Among others, `isContract` will return false for the following
230      * types of addresses:
231      *
232      *  - an externally-owned account
233      *  - a contract in construction
234      *  - an address where a contract will be created
235      *  - an address where a contract lived, but was destroyed
236      * ====
237      */
238     function isContract(address account) internal view returns (bool) {
239         // This method relies on extcodesize, which returns 0 for contracts in
240         // construction, since the code is only stored at the end of the
241         // constructor execution.
242 
243         uint256 size;
244         assembly {
245             size := extcodesize(account)
246         }
247         return size > 0;
248     }
249 
250     /**
251      * @dev Replacement for Solidity's `transfer`: sends `amount` wei to
252      * `recipient`, forwarding all available gas and reverting on errors.
253      *
254      * https://eips.ethereum.org/EIPS/eip-1884[EIP1884] increases the gas cost
255      * of certain opcodes, possibly making contracts go over the 2300 gas limit
256      * imposed by `transfer`, making them unable to receive funds via
257      * `transfer`. {sendValue} removes this limitation.
258      *
259      * https://diligence.consensys.net/posts/2019/09/stop-using-soliditys-transfer-now/[Learn more].
260      *
261      * IMPORTANT: because control is transferred to `recipient`, care must be
262      * taken to not create reentrancy vulnerabilities. Consider using
263      * {ReentrancyGuard} or the
264      * https://solidity.readthedocs.io/en/v0.5.11/security-considerations.html#use-the-checks-effects-interactions-pattern[checks-effects-interactions pattern].
265      */
266     function sendValue(address payable recipient, uint256 amount) internal {
267         require(address(this).balance >= amount, "Address: insufficient balance");
268 
269         (bool success, ) = recipient.call{value: amount}("");
270         require(success, "Address: unable to send value, recipient may have reverted");
271     }
272 
273     /**
274      * @dev Performs a Solidity function call using a low level `call`. A
275      * plain `call` is an unsafe replacement for a function call: use this
276      * function instead.
277      *
278      * If `target` reverts with a revert reason, it is bubbled up by this
279      * function (like regular Solidity function calls).
280      *
281      * Returns the raw returned data. To convert to the expected return value,
282      * use https://solidity.readthedocs.io/en/latest/units-and-global-variables.html?highlight=abi.decode#abi-encoding-and-decoding-functions[`abi.decode`].
283      *
284      * Requirements:
285      *
286      * - `target` must be a contract.
287      * - calling `target` with `data` must not revert.
288      *
289      * _Available since v3.1._
290      */
291     function functionCall(address target, bytes memory data) internal returns (bytes memory) {
292         return functionCall(target, data, "Address: low-level call failed");
293     }
294 
295     /**
296      * @dev Same as {xref-Address-functionCall-address-bytes-}[`functionCall`], but with
297      * `errorMessage` as a fallback revert reason when `target` reverts.
298      *
299      * _Available since v3.1._
300      */
301     function functionCall(
302         address target,
303         bytes memory data,
304         string memory errorMessage
305     ) internal returns (bytes memory) {
306         return functionCallWithValue(target, data, 0, errorMessage);
307     }
308 
309     /**
310      * @dev Same as {xref-Address-functionCall-address-bytes-}[`functionCall`],
311      * but also transferring `value` wei to `target`.
312      *
313      * Requirements:
314      *
315      * - the calling contract must have an ETH balance of at least `value`.
316      * - the called Solidity function must be `payable`.
317      *
318      * _Available since v3.1._
319      */
320     function functionCallWithValue(
321         address target,
322         bytes memory data,
323         uint256 value
324     ) internal returns (bytes memory) {
325         return functionCallWithValue(target, data, value, "Address: low-level call with value failed");
326     }
327 
328     /**
329      * @dev Same as {xref-Address-functionCallWithValue-address-bytes-uint256-}[`functionCallWithValue`], but
330      * with `errorMessage` as a fallback revert reason when `target` reverts.
331      *
332      * _Available since v3.1._
333      */
334     function functionCallWithValue(
335         address target,
336         bytes memory data,
337         uint256 value,
338         string memory errorMessage
339     ) internal returns (bytes memory) {
340         require(address(this).balance >= value, "Address: insufficient balance for call");
341         require(isContract(target), "Address: call to non-contract");
342 
343         (bool success, bytes memory returndata) = target.call{value: value}(data);
344         return verifyCallResult(success, returndata, errorMessage);
345     }
346 
347     /**
348      * @dev Same as {xref-Address-functionCall-address-bytes-}[`functionCall`],
349      * but performing a static call.
350      *
351      * _Available since v3.3._
352      */
353     function functionStaticCall(address target, bytes memory data) internal view returns (bytes memory) {
354         return functionStaticCall(target, data, "Address: low-level static call failed");
355     }
356 
357     /**
358      * @dev Same as {xref-Address-functionCall-address-bytes-string-}[`functionCall`],
359      * but performing a static call.
360      *
361      * _Available since v3.3._
362      */
363     function functionStaticCall(
364         address target,
365         bytes memory data,
366         string memory errorMessage
367     ) internal view returns (bytes memory) {
368         require(isContract(target), "Address: static call to non-contract");
369 
370         (bool success, bytes memory returndata) = target.staticcall(data);
371         return verifyCallResult(success, returndata, errorMessage);
372     }
373 
374     /**
375      * @dev Same as {xref-Address-functionCall-address-bytes-}[`functionCall`],
376      * but performing a delegate call.
377      *
378      * _Available since v3.4._
379      */
380     function functionDelegateCall(address target, bytes memory data) internal returns (bytes memory) {
381         return functionDelegateCall(target, data, "Address: low-level delegate call failed");
382     }
383 
384     /**
385      * @dev Same as {xref-Address-functionCall-address-bytes-string-}[`functionCall`],
386      * but performing a delegate call.
387      *
388      * _Available since v3.4._
389      */
390     function functionDelegateCall(
391         address target,
392         bytes memory data,
393         string memory errorMessage
394     ) internal returns (bytes memory) {
395         require(isContract(target), "Address: delegate call to non-contract");
396 
397         (bool success, bytes memory returndata) = target.delegatecall(data);
398         return verifyCallResult(success, returndata, errorMessage);
399     }
400 
401     /**
402      * @dev Tool to verifies that a low level call was successful, and revert if it wasn't, either by bubbling the
403      * revert reason using the provided one.
404      *
405      * _Available since v4.3._
406      */
407     function verifyCallResult(
408         bool success,
409         bytes memory returndata,
410         string memory errorMessage
411     ) internal pure returns (bytes memory) {
412         if (success) {
413             return returndata;
414         } else {
415             // Look for revert reason and bubble it up if present
416             if (returndata.length > 0) {
417                 // The easiest way to bubble the revert reason is using memory via assembly
418 
419                 assembly {
420                     let returndata_size := mload(returndata)
421                     revert(add(32, returndata), returndata_size)
422                 }
423             } else {
424                 revert(errorMessage);
425             }
426         }
427     }
428 }
429 
430 
431 // OpenZeppelin Contracts v4.4.1 (utils/Context.sol)
432 /**
433  * @dev Provides information about the current execution context, including the
434  * sender of the transaction and its data. While these are generally available
435  * via msg.sender and msg.data, they should not be accessed in such a direct
436  * manner, since when dealing with meta-transactions the account sending and
437  * paying for execution may not be the actual sender (as far as an application
438  * is concerned).
439  *
440  * This contract is only required for intermediate, library-like contracts.
441  */
442 abstract contract Context {
443     function _msgSender() internal view virtual returns (address) {
444         return msg.sender;
445     }
446 
447     function _msgData() internal view virtual returns (bytes calldata) {
448         return msg.data;
449     }
450 }
451 
452 
453 // OpenZeppelin Contracts v4.4.1 (utils/Strings.sol)
454 /**
455  * @dev String operations.
456  */
457 library Strings {
458     bytes16 private constant _HEX_SYMBOLS = "0123456789abcdef";
459 
460     /**
461      * @dev Converts a `uint256` to its ASCII `string` decimal representation.
462      */
463     function toString(uint256 value) internal pure returns (string memory) {
464         // Inspired by OraclizeAPI's implementation - MIT licence
465         // https://github.com/oraclize/ethereum-api/blob/b42146b063c7d6ee1358846c198246239e9360e8/oraclizeAPI_0.4.25.sol
466 
467         if (value == 0) {
468             return "0";
469         }
470         uint256 temp = value;
471         uint256 digits;
472         while (temp != 0) {
473             digits++;
474             temp /= 10;
475         }
476         bytes memory buffer = new bytes(digits);
477         while (value != 0) {
478             digits -= 1;
479             buffer[digits] = bytes1(uint8(48 + uint256(value % 10)));
480             value /= 10;
481         }
482         return string(buffer);
483     }
484 
485     /**
486      * @dev Converts a `uint256` to its ASCII `string` hexadecimal representation.
487      */
488     function toHexString(uint256 value) internal pure returns (string memory) {
489         if (value == 0) {
490             return "0x00";
491         }
492         uint256 temp = value;
493         uint256 length = 0;
494         while (temp != 0) {
495             length++;
496             temp >>= 8;
497         }
498         return toHexString(value, length);
499     }
500 
501     /**
502      * @dev Converts a `uint256` to its ASCII `string` hexadecimal representation with fixed length.
503      */
504     function toHexString(uint256 value, uint256 length) internal pure returns (string memory) {
505         bytes memory buffer = new bytes(2 * length + 2);
506         buffer[0] = "0";
507         buffer[1] = "x";
508         for (uint256 i = 2 * length + 1; i > 1; --i) {
509             buffer[i] = _HEX_SYMBOLS[value & 0xf];
510             value >>= 4;
511         }
512         require(value == 0, "Strings: hex length insufficient");
513         return string(buffer);
514     }
515 }
516 
517 
518 // OpenZeppelin Contracts v4.4.1 (utils/introspection/ERC165.sol)
519 /**
520  * @dev Implementation of the {IERC165} interface.
521  *
522  * Contracts that want to implement ERC165 should inherit from this contract and override {supportsInterface} to check
523  * for the additional interface id that will be supported. For example:
524  *
525  * ```solidity
526  * function supportsInterface(bytes4 interfaceId) public view virtual override returns (bool) {
527  *     return interfaceId == type(MyInterface).interfaceId || super.supportsInterface(interfaceId);
528  * }
529  * ```
530  *
531  * Alternatively, {ERC165Storage} provides an easier to use but more expensive implementation.
532  */
533 abstract contract ERC165 is IERC165 {
534     /**
535      * @dev See {IERC165-supportsInterface}.
536      */
537     function supportsInterface(bytes4 interfaceId) public view virtual override returns (bool) {
538         return interfaceId == type(IERC165).interfaceId;
539     }
540 }
541 
542 
543 // OpenZeppelin Contracts v4.4.1 (token/ERC721/ERC721.sol)
544 /**
545  * @dev Implementation of https://eips.ethereum.org/EIPS/eip-721[ERC721] Non-Fungible Token Standard, including
546  * the Metadata extension, but not including the Enumerable extension, which is available separately as
547  * {ERC721Enumerable}.
548  */
549 contract ERC721 is Context, ERC165, IERC721, IERC721Metadata {
550     using Address for address;
551     using Strings for uint256;
552 
553     // Token name
554     string private _name;
555 
556     // Token symbol
557     string private _symbol;
558 
559     // Mapping from token ID to owner address
560     mapping(uint256 => address) private _owners;
561 
562     // Mapping owner address to token count
563     mapping(address => uint256) private _balances;
564 
565     // Mapping from token ID to approved address
566     mapping(uint256 => address) private _tokenApprovals;
567 
568     // Mapping from owner to operator approvals
569     mapping(address => mapping(address => bool)) private _operatorApprovals;
570 
571     /**
572      * @dev Initializes the contract by setting a `name` and a `symbol` to the token collection.
573      */
574     constructor(string memory name_, string memory symbol_) {
575         _name = name_;
576         _symbol = symbol_;
577     }
578 
579     /**
580      * @dev See {IERC165-supportsInterface}.
581      */
582     function supportsInterface(bytes4 interfaceId) public view virtual override(ERC165, IERC165) returns (bool) {
583         return
584             interfaceId == type(IERC721).interfaceId ||
585             interfaceId == type(IERC721Metadata).interfaceId ||
586             super.supportsInterface(interfaceId);
587     }
588 
589     /**
590      * @dev See {IERC721-balanceOf}.
591      */
592     function balanceOf(address owner) public view virtual override returns (uint256) {
593         require(owner != address(0), "ERC721: balance query for the zero address");
594         return _balances[owner];
595     }
596 
597     /**
598      * @dev See {IERC721-ownerOf}.
599      */
600     function ownerOf(uint256 tokenId) public view virtual override returns (address) {
601         address owner = _owners[tokenId];
602         require(owner != address(0), "ERC721: owner query for nonexistent token");
603         return owner;
604     }
605 
606     /**
607      * @dev See {IERC721Metadata-name}.
608      */
609     function name() public view virtual override returns (string memory) {
610         return _name;
611     }
612 
613     /**
614      * @dev See {IERC721Metadata-symbol}.
615      */
616     function symbol() public view virtual override returns (string memory) {
617         return _symbol;
618     }
619 
620     /**
621      * @dev See {IERC721Metadata-tokenURI}.
622      */
623     function tokenURI(uint256 tokenId) public view virtual override returns (string memory) {
624         require(_exists(tokenId), "ERC721Metadata: URI query for nonexistent token");
625 
626         string memory baseURI = _baseURI();
627         return bytes(baseURI).length > 0 ? string(abi.encodePacked(baseURI, tokenId.toString())) : "";
628     }
629 
630     /**
631      * @dev Base URI for computing {tokenURI}. If set, the resulting URI for each
632      * token will be the concatenation of the `baseURI` and the `tokenId`. Empty
633      * by default, can be overriden in child contracts.
634      */
635     function _baseURI() internal view virtual returns (string memory) {
636         return "";
637     }
638 
639     /**
640      * @dev See {IERC721-approve}.
641      */
642     function approve(address to, uint256 tokenId) public virtual override {
643         address owner = ERC721.ownerOf(tokenId);
644         require(to != owner, "ERC721: approval to current owner");
645 
646         require(
647             _msgSender() == owner || isApprovedForAll(owner, _msgSender()),
648             "ERC721: approve caller is not owner nor approved for all"
649         );
650 
651         _approve(to, tokenId);
652     }
653 
654     /**
655      * @dev See {IERC721-getApproved}.
656      */
657     function getApproved(uint256 tokenId) public view virtual override returns (address) {
658         require(_exists(tokenId), "ERC721: approved query for nonexistent token");
659 
660         return _tokenApprovals[tokenId];
661     }
662 
663     /**
664      * @dev See {IERC721-setApprovalForAll}.
665      */
666     function setApprovalForAll(address operator, bool approved) public virtual override {
667         _setApprovalForAll(_msgSender(), operator, approved);
668     }
669 
670     /**
671      * @dev See {IERC721-isApprovedForAll}.
672      */
673     function isApprovedForAll(address owner, address operator) public view virtual override returns (bool) {
674         return _operatorApprovals[owner][operator];
675     }
676 
677     /**
678      * @dev See {IERC721-transferFrom}.
679      */
680     function transferFrom(
681         address from,
682         address to,
683         uint256 tokenId
684     ) public virtual override {
685         //solhint-disable-next-line max-line-length
686         require(_isApprovedOrOwner(_msgSender(), tokenId), "ERC721: transfer caller is not owner nor approved");
687 
688         _transfer(from, to, tokenId);
689     }
690 
691     /**
692      * @dev See {IERC721-safeTransferFrom}.
693      */
694     function safeTransferFrom(
695         address from,
696         address to,
697         uint256 tokenId
698     ) public virtual override {
699         safeTransferFrom(from, to, tokenId, "");
700     }
701 
702     /**
703      * @dev See {IERC721-safeTransferFrom}.
704      */
705     function safeTransferFrom(
706         address from,
707         address to,
708         uint256 tokenId,
709         bytes memory _data
710     ) public virtual override {
711         require(_isApprovedOrOwner(_msgSender(), tokenId), "ERC721: transfer caller is not owner nor approved");
712         _safeTransfer(from, to, tokenId, _data);
713     }
714 
715     /**
716      * @dev Safely transfers `tokenId` token from `from` to `to`, checking first that contract recipients
717      * are aware of the ERC721 protocol to prevent tokens from being forever locked.
718      *
719      * `_data` is additional data, it has no specified format and it is sent in call to `to`.
720      *
721      * This internal function is equivalent to {safeTransferFrom}, and can be used to e.g.
722      * implement alternative mechanisms to perform token transfer, such as signature-based.
723      *
724      * Requirements:
725      *
726      * - `from` cannot be the zero address.
727      * - `to` cannot be the zero address.
728      * - `tokenId` token must exist and be owned by `from`.
729      * - If `to` refers to a smart contract, it must implement {IERC721Receiver-onERC721Received}, which is called upon a safe transfer.
730      *
731      * Emits a {Transfer} event.
732      */
733     function _safeTransfer(
734         address from,
735         address to,
736         uint256 tokenId,
737         bytes memory _data
738     ) internal virtual {
739         _transfer(from, to, tokenId);
740         require(_checkOnERC721Received(from, to, tokenId, _data), "ERC721: transfer to non ERC721Receiver implementer");
741     }
742 
743     /**
744      * @dev Returns whether `tokenId` exists.
745      *
746      * Tokens can be managed by their owner or approved accounts via {approve} or {setApprovalForAll}.
747      *
748      * Tokens start existing when they are minted (`_mint`),
749      * and stop existing when they are burned (`_burn`).
750      */
751     function _exists(uint256 tokenId) internal view virtual returns (bool) {
752         return _owners[tokenId] != address(0);
753     }
754 
755     /**
756      * @dev Returns whether `spender` is allowed to manage `tokenId`.
757      *
758      * Requirements:
759      *
760      * - `tokenId` must exist.
761      */
762     function _isApprovedOrOwner(address spender, uint256 tokenId) internal view virtual returns (bool) {
763         require(_exists(tokenId), "ERC721: operator query for nonexistent token");
764         address owner = ERC721.ownerOf(tokenId);
765         return (spender == owner || getApproved(tokenId) == spender || isApprovedForAll(owner, spender));
766     }
767 
768     /**
769      * @dev Safely mints `tokenId` and transfers it to `to`.
770      *
771      * Requirements:
772      *
773      * - `tokenId` must not exist.
774      * - If `to` refers to a smart contract, it must implement {IERC721Receiver-onERC721Received}, which is called upon a safe transfer.
775      *
776      * Emits a {Transfer} event.
777      */
778     function _safeMint(address to, uint256 tokenId) internal virtual {
779         _safeMint(to, tokenId, "");
780     }
781 
782     /**
783      * @dev Same as {xref-ERC721-_safeMint-address-uint256-}[`_safeMint`], with an additional `data` parameter which is
784      * forwarded in {IERC721Receiver-onERC721Received} to contract recipients.
785      */
786     function _safeMint(
787         address to,
788         uint256 tokenId,
789         bytes memory _data
790     ) internal virtual {
791         _mint(to, tokenId);
792         require(
793             _checkOnERC721Received(address(0), to, tokenId, _data),
794             "ERC721: transfer to non ERC721Receiver implementer"
795         );
796     }
797 
798     /**
799      * @dev Mints `tokenId` and transfers it to `to`.
800      *
801      * WARNING: Usage of this method is discouraged, use {_safeMint} whenever possible
802      *
803      * Requirements:
804      *
805      * - `tokenId` must not exist.
806      * - `to` cannot be the zero address.
807      *
808      * Emits a {Transfer} event.
809      */
810     function _mint(address to, uint256 tokenId) internal virtual {
811         require(to != address(0), "ERC721: mint to the zero address");
812         require(!_exists(tokenId), "ERC721: token already minted");
813 
814         _beforeTokenTransfer(address(0), to, tokenId);
815 
816         _balances[to] += 1;
817         _owners[tokenId] = to;
818 
819         emit Transfer(address(0), to, tokenId);
820     }
821 
822     /**
823      * @dev Destroys `tokenId`.
824      * The approval is cleared when the token is burned.
825      *
826      * Requirements:
827      *
828      * - `tokenId` must exist.
829      *
830      * Emits a {Transfer} event.
831      */
832     function _burn(uint256 tokenId) internal virtual {
833         address owner = ERC721.ownerOf(tokenId);
834 
835         _beforeTokenTransfer(owner, address(0), tokenId);
836 
837         // Clear approvals
838         _approve(address(0), tokenId);
839 
840         _balances[owner] -= 1;
841         delete _owners[tokenId];
842 
843         emit Transfer(owner, address(0), tokenId);
844     }
845 
846     /**
847      * @dev Transfers `tokenId` from `from` to `to`.
848      *  As opposed to {transferFrom}, this imposes no restrictions on msg.sender.
849      *
850      * Requirements:
851      *
852      * - `to` cannot be the zero address.
853      * - `tokenId` token must be owned by `from`.
854      *
855      * Emits a {Transfer} event.
856      */
857     function _transfer(
858         address from,
859         address to,
860         uint256 tokenId
861     ) internal virtual {
862         require(ERC721.ownerOf(tokenId) == from, "ERC721: transfer of token that is not own");
863         require(to != address(0), "ERC721: transfer to the zero address");
864 
865         _beforeTokenTransfer(from, to, tokenId);
866 
867         // Clear approvals from the previous owner
868         _approve(address(0), tokenId);
869 
870         _balances[from] -= 1;
871         _balances[to] += 1;
872         _owners[tokenId] = to;
873 
874         emit Transfer(from, to, tokenId);
875     }
876 
877     /**
878      * @dev Approve `to` to operate on `tokenId`
879      *
880      * Emits a {Approval} event.
881      */
882     function _approve(address to, uint256 tokenId) internal virtual {
883         _tokenApprovals[tokenId] = to;
884         emit Approval(ERC721.ownerOf(tokenId), to, tokenId);
885     }
886 
887     /**
888      * @dev Approve `operator` to operate on all of `owner` tokens
889      *
890      * Emits a {ApprovalForAll} event.
891      */
892     function _setApprovalForAll(
893         address owner,
894         address operator,
895         bool approved
896     ) internal virtual {
897         require(owner != operator, "ERC721: approve to caller");
898         _operatorApprovals[owner][operator] = approved;
899         emit ApprovalForAll(owner, operator, approved);
900     }
901 
902     /**
903      * @dev Internal function to invoke {IERC721Receiver-onERC721Received} on a target address.
904      * The call is not executed if the target address is not a contract.
905      *
906      * @param from address representing the previous owner of the given token ID
907      * @param to target address that will receive the tokens
908      * @param tokenId uint256 ID of the token to be transferred
909      * @param _data bytes optional data to send along with the call
910      * @return bool whether the call correctly returned the expected magic value
911      */
912     function _checkOnERC721Received(
913         address from,
914         address to,
915         uint256 tokenId,
916         bytes memory _data
917     ) private returns (bool) {
918         if (to.isContract()) {
919             try IERC721Receiver(to).onERC721Received(_msgSender(), from, tokenId, _data) returns (bytes4 retval) {
920                 return retval == IERC721Receiver.onERC721Received.selector;
921             } catch (bytes memory reason) {
922                 if (reason.length == 0) {
923                     revert("ERC721: transfer to non ERC721Receiver implementer");
924                 } else {
925                     assembly {
926                         revert(add(32, reason), mload(reason))
927                     }
928                 }
929             }
930         } else {
931             return true;
932         }
933     }
934 
935     /**
936      * @dev Hook that is called before any token transfer. This includes minting
937      * and burning.
938      *
939      * Calling conditions:
940      *
941      * - When `from` and `to` are both non-zero, ``from``'s `tokenId` will be
942      * transferred to `to`.
943      * - When `from` is zero, `tokenId` will be minted for `to`.
944      * - When `to` is zero, ``from``'s `tokenId` will be burned.
945      * - `from` and `to` are never both zero.
946      *
947      * To learn more about hooks, head to xref:ROOT:extending-contracts.adoc#using-hooks[Using Hooks].
948      */
949     function _beforeTokenTransfer(
950         address from,
951         address to,
952         uint256 tokenId
953     ) internal virtual {}
954 }
955 
956 
957 // OpenZeppelin Contracts v4.4.1 (access/Ownable.sol)
958 /**
959  * @dev Contract module which provides a basic access control mechanism, where
960  * there is an account (an owner) that can be granted exclusive access to
961  * specific functions.
962  *
963  * By default, the owner account will be the one that deploys the contract. This
964  * can later be changed with {transferOwnership}.
965  *
966  * This module is used through inheritance. It will make available the modifier
967  * `onlyOwner`, which can be applied to your functions to restrict their use to
968  * the owner.
969  */
970 abstract contract Ownable is Context {
971     address private _owner;
972 
973     event OwnershipTransferred(address indexed previousOwner, address indexed newOwner);
974 
975     /**
976      * @dev Initializes the contract setting the deployer as the initial owner.
977      */
978     constructor() {
979         _transferOwnership(_msgSender());
980     }
981 
982     /**
983      * @dev Returns the address of the current owner.
984      */
985     function owner() public view virtual returns (address) {
986         return _owner;
987     }
988 
989     /**
990      * @dev Throws if called by any account other than the owner.
991      */
992     modifier onlyOwner() {
993         require(owner() == _msgSender(), "Ownable: caller is not the owner");
994         _;
995     }
996 
997     /**
998      * @dev Leaves the contract without owner. It will not be possible to call
999      * `onlyOwner` functions anymore. Can only be called by the current owner.
1000      *
1001      * NOTE: Renouncing ownership will leave the contract without an owner,
1002      * thereby removing any functionality that is only available to the owner.
1003      */
1004     function renounceOwnership() public virtual onlyOwner {
1005         _transferOwnership(address(0));
1006     }
1007 
1008     /**
1009      * @dev Transfers ownership of the contract to a new account (`newOwner`).
1010      * Can only be called by the current owner.
1011      */
1012     function transferOwnership(address newOwner) public virtual onlyOwner {
1013         require(newOwner != address(0), "Ownable: new owner is the zero address");
1014         _transferOwnership(newOwner);
1015     }
1016 
1017     /**
1018      * @dev Transfers ownership of the contract to a new account (`newOwner`).
1019      * Internal function without access restriction.
1020      */
1021     function _transferOwnership(address newOwner) internal virtual {
1022         address oldOwner = _owner;
1023         _owner = newOwner;
1024         emit OwnershipTransferred(oldOwner, newOwner);
1025     }
1026 }
1027 
1028 
1029 // OpenZeppelin Contracts v4.4.1 (utils/Counters.sol)
1030 /**
1031  * @title Counters
1032  * @author Matt Condon (@shrugs)
1033  * @dev Provides counters that can only be incremented, decremented or reset. This can be used e.g. to track the number
1034  * of elements in a mapping, issuing ERC721 ids, or counting request ids.
1035  *
1036  * Include with `using Counters for Counters.Counter;`
1037  */
1038 library Counters {
1039     struct Counter {
1040         // This variable should never be directly accessed by users of the library: interactions must be restricted to
1041         // the library's function. As of Solidity v0.5.2, this cannot be enforced, though there is a proposal to add
1042         // this feature: see https://github.com/ethereum/solidity/issues/4637
1043         uint256 _value; // default: 0
1044     }
1045 
1046     function current(Counter storage counter) internal view returns (uint256) {
1047         return counter._value;
1048     }
1049 
1050     function increment(Counter storage counter) internal {
1051         unchecked {
1052             counter._value += 1;
1053         }
1054     }
1055 
1056     function decrement(Counter storage counter) internal {
1057         uint256 value = counter._value;
1058         require(value > 0, "Counter: decrement overflow");
1059         unchecked {
1060             counter._value = value - 1;
1061         }
1062     }
1063 
1064     function reset(Counter storage counter) internal {
1065         counter._value = 0;
1066     }
1067 }
1068 
1069 
1070 // OpenZeppelin Contracts v4.4.1 (utils/cryptography/MerkleProof.sol)
1071 /**
1072  * @dev These functions deal with verification of Merkle Trees proofs.
1073  *
1074  * The proofs can be generated using the JavaScript library
1075  * https://github.com/miguelmota/merkletreejs[merkletreejs].
1076  * Note: the hashing algorithm should be keccak256 and pair sorting should be enabled.
1077  *
1078  * See `test/utils/cryptography/MerkleProof.test.js` for some examples.
1079  */
1080 library MerkleProof {
1081     /**
1082      * @dev Returns true if a `leaf` can be proved to be a part of a Merkle tree
1083      * defined by `root`. For this, a `proof` must be provided, containing
1084      * sibling hashes on the branch from the leaf to the root of the tree. Each
1085      * pair of leaves and each pair of pre-images are assumed to be sorted.
1086      */
1087     function verify(
1088         bytes32[] memory proof,
1089         bytes32 root,
1090         bytes32 leaf
1091     ) internal pure returns (bool) {
1092         return processProof(proof, leaf) == root;
1093     }
1094 
1095     /**
1096      * @dev Returns the rebuilt hash obtained by traversing a Merklee tree up
1097      * from `leaf` using `proof`. A `proof` is valid if and only if the rebuilt
1098      * hash matches the root of the tree. When processing the proof, the pairs
1099      * of leafs & pre-images are assumed to be sorted.
1100      *
1101      * _Available since v4.4._
1102      */
1103     function processProof(bytes32[] memory proof, bytes32 leaf) internal pure returns (bytes32) {
1104         bytes32 computedHash = leaf;
1105         for (uint256 i = 0; i < proof.length; i++) {
1106             bytes32 proofElement = proof[i];
1107             if (computedHash <= proofElement) {
1108                 // Hash(current computed hash + current element of the proof)
1109                 computedHash = keccak256(abi.encodePacked(computedHash, proofElement));
1110             } else {
1111                 // Hash(current element of the proof + current computed hash)
1112                 computedHash = keccak256(abi.encodePacked(proofElement, computedHash));
1113             }
1114         }
1115         return computedHash;
1116     }
1117 }
1118 
1119 
1120 contract CnRERC721 is ERC721, Ownable {
1121 
1122     using Strings for uint256;
1123     using Counters for Counters.Counter;
1124     using MerkleProof for bytes32[];
1125 
1126     Counters.Counter private _tokenIdCounter;
1127 
1128     uint256 public constant MAX_MINT = 2001;
1129     uint256 public PRICE = 0.5 ether;
1130     uint256 public MAX_RESERVE = 1501;
1131 
1132     bool public isActive = false;
1133     bool public isWhiteListActive = true;
1134     bool public isRedeemable = false;
1135 
1136     uint256 public purchaseLimit = 1;
1137     uint256 public totalPublicSupply;
1138 
1139     bytes32 private merkleRoot;
1140     mapping(address => uint256) private _claimed;
1141     mapping(uint256 => address) private _redeemed;
1142 
1143     uint256[] private _gifted;
1144 
1145     string private _contractURI = "";
1146     string private _tokenBaseURI = "";
1147     string private _tokenRevealedBaseURI = "";
1148 
1149     constructor(bytes32 initialRoot) ERC721("CULTandRAIN", "CnR") {
1150         merkleRoot = initialRoot;
1151     }
1152 
1153     function tokensOfOwner(address _owner)
1154         external
1155         view
1156         returns (uint256[] memory ownerTokens)
1157     {
1158         uint256 tokenCount = balanceOf(_owner);
1159         if (tokenCount == 0) {
1160             return new uint256[](0);
1161         } else {
1162             uint256[] memory result = new uint256[](tokenCount);
1163             uint256 totalTkns = totalSupply();
1164             uint256 resultIndex = 0;
1165             uint256 tnkId;
1166 
1167             for (tnkId = 1; tnkId <= totalTkns; tnkId++) {
1168                 if (ownerOf(tnkId) == _owner) {
1169                     result[resultIndex] = tnkId;
1170                     resultIndex++;
1171                 }
1172             }
1173 
1174             return result;
1175         }
1176     }
1177 
1178     function howManyClaimed(address _address) external view returns (uint256) {
1179         return _claimed[_address];
1180     }
1181 
1182     function onWhiteList(address addr,bytes32[] calldata _merkleProof) external view returns (bool) {
1183         bytes32 leaf = keccak256(abi.encodePacked(addr));
1184         return MerkleProof.verify(_merkleProof,merkleRoot,leaf);
1185     }
1186 
1187     function buyNFT(bytes32[] calldata _merkleProof) external payable {
1188         require(isActive, "Contract is not active");
1189 
1190         require(totalSupply() < MAX_MINT, "All tokens have been minted");
1191 
1192         bytes32 leaf = keccak256(abi.encodePacked(msg.sender));
1193 
1194         require(
1195             isWhiteListActive ? MerkleProof.verify(_merkleProof,merkleRoot,leaf) : true,
1196             "You are not on the White List"
1197         );
1198 
1199         require(
1200             msg.value > 0 && msg.value % PRICE == 0,
1201             "Amount must be a multiple of price"
1202         );
1203 
1204         uint256 amount = msg.value / PRICE;
1205         require(
1206             amount >= 1 && amount <= purchaseLimit,
1207             "Amount should be at least 1"
1208         );
1209 
1210         require(
1211             (_claimed[msg.sender] + amount) <= purchaseLimit,
1212             "Purchase exceeds purchase limit"
1213         );
1214 
1215         uint256 reached = amount + _tokenIdCounter.current();
1216         require(
1217             reached <= (MAX_MINT - MAX_RESERVE),
1218             "Purchase would exceed public supply"
1219         );
1220 
1221         _claimed[msg.sender] += amount;
1222 
1223         totalPublicSupply += amount;
1224 
1225         for (uint256 i = 0; i < amount; i++) {
1226             _tokenIdCounter.increment();
1227             uint256 newTokenId = _tokenIdCounter.current();
1228             _mint(msg.sender, newTokenId);
1229         }
1230     }
1231 
1232     function gift(address to) external onlyOwner {
1233         require(totalSupply() < MAX_MINT, "All tokens have been minted");
1234 
1235         require(_gifted.length < MAX_RESERVE, "Max reserve reached");
1236 
1237         _tokenIdCounter.increment();
1238         uint256 newTokenId = _tokenIdCounter.current();
1239         _gifted.push(newTokenId);
1240         _mint(to, newTokenId);
1241     }
1242 
1243     function setIsActive(bool _isActive) external onlyOwner {
1244         isActive = _isActive;
1245     }
1246 
1247     function setNewPrice(uint256 _newPrice) external onlyOwner {
1248         PRICE = _newPrice;
1249     }
1250 
1251     function setIsWhiteListActive(bool _isWhiteListActive) external onlyOwner {
1252         isWhiteListActive = _isWhiteListActive;
1253     }
1254 
1255     function setPurchaseLimit(uint256 newLimit) external onlyOwner {
1256         require(
1257             newLimit > 0 && newLimit < MAX_MINT,
1258             "New reserve must be greater than zero"
1259         );
1260         purchaseLimit = newLimit;
1261     }
1262 
1263     function setMaxReserve(uint256 newReserve) external onlyOwner {
1264         require(
1265             newReserve < MAX_RESERVE,
1266             "New reserve must be less than old reserve"
1267         );
1268         MAX_RESERVE = newReserve;
1269     }
1270 
1271     function withdraw() external onlyOwner {
1272         uint256 balance = address(this).balance;
1273         require(balance > 0, "Nothing to witdraw!");
1274         payable(msg.sender).transfer(balance);
1275     }
1276 
1277     function totalSupply() public view returns (uint256) {
1278         return _tokenIdCounter.current();
1279     }
1280 
1281     function publicSupply() external view returns (uint256) {
1282         return totalPublicSupply;
1283     }
1284 
1285     function redeem(uint256 _tokenId) external returns (bool) {
1286         require(isRedeemable, "Redeeming not available");
1287         require(ownerOf(_tokenId) == msg.sender, "You must own the NFT");
1288         require(_redeemed[_tokenId] == address(0), "You already redeemed the NFT");
1289         _redeemed[_tokenId] = msg.sender;
1290         return true;
1291     }
1292 
1293     function setRedeemable(bool _redeemable) external onlyOwner {
1294         isRedeemable = _redeemable;
1295     }
1296 
1297     function whoRedeemed(uint256 _tokenId) external view returns (address) {
1298         return _redeemed[_tokenId];
1299     }
1300 
1301     function setMerkleRoot(bytes32 root) external onlyOwner {
1302       merkleRoot = root;
1303     }
1304 
1305     function setContractURI(string calldata URI) external onlyOwner {
1306         _contractURI = URI;
1307     }
1308 
1309     function setBaseURI(string calldata URI) external onlyOwner {
1310         _tokenBaseURI = URI;
1311     }
1312 
1313     function setRevealedBaseURI(string calldata revealedBaseURI)
1314         external
1315         onlyOwner
1316     {
1317         _tokenRevealedBaseURI = revealedBaseURI;
1318     }
1319 
1320     function getGiftedTokens() public view returns (uint256[] memory) {
1321         return _gifted;
1322     }
1323 
1324     function contractURI() public view returns (string memory) {
1325         return _contractURI;
1326     }
1327 
1328     function tokenURI(uint256 tokenId)
1329         public
1330         view
1331         override(ERC721)
1332         returns (string memory)
1333     {
1334         require(_exists(tokenId), "Token does not exist");
1335         string memory revealedBaseURI = _tokenRevealedBaseURI;
1336         return
1337             bytes(revealedBaseURI).length > 0
1338                 ? string(abi.encodePacked(revealedBaseURI, tokenId.toString()))
1339                 : _tokenBaseURI;
1340     }
1341 }