1 // SPDX-License-Identifier: MIT
2 pragma solidity ^0.8.7;
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
216 // OpenZeppelin Contracts (last updated v4.5.0) (utils/Address.sol)
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
237      *
238      * [IMPORTANT]
239      * ====
240      * You shouldn't rely on `isContract` to protect against flash loan attacks!
241      *
242      * Preventing calls from contracts is highly discouraged. It breaks composability, breaks support for smart wallets
243      * like Gnosis Safe, and does not provide security since it can be circumvented by calling from a contract
244      * constructor.
245      * ====
246      */
247     function isContract(address account) internal view returns (bool) {
248         // This method relies on extcodesize/address.code.length, which returns 0
249         // for contracts in construction, since the code is only stored at the end
250         // of the constructor execution.
251 
252         return account.code.length > 0;
253     }
254 
255     /**
256      * @dev Replacement for Solidity's `transfer`: sends `amount` wei to
257      * `recipient`, forwarding all available gas and reverting on errors.
258      *
259      * https://eips.ethereum.org/EIPS/eip-1884[EIP1884] increases the gas cost
260      * of certain opcodes, possibly making contracts go over the 2300 gas limit
261      * imposed by `transfer`, making them unable to receive funds via
262      * `transfer`. {sendValue} removes this limitation.
263      *
264      * https://diligence.consensys.net/posts/2019/09/stop-using-soliditys-transfer-now/[Learn more].
265      *
266      * IMPORTANT: because control is transferred to `recipient`, care must be
267      * taken to not create reentrancy vulnerabilities. Consider using
268      * {ReentrancyGuard} or the
269      * https://solidity.readthedocs.io/en/v0.5.11/security-considerations.html#use-the-checks-effects-interactions-pattern[checks-effects-interactions pattern].
270      */
271     function sendValue(address payable recipient, uint256 amount) internal {
272         require(address(this).balance >= amount, "Address: insufficient balance");
273 
274         (bool success, ) = recipient.call{value: amount}("");
275         require(success, "Address: unable to send value, recipient may have reverted");
276     }
277 
278     /**
279      * @dev Performs a Solidity function call using a low level `call`. A
280      * plain `call` is an unsafe replacement for a function call: use this
281      * function instead.
282      *
283      * If `target` reverts with a revert reason, it is bubbled up by this
284      * function (like regular Solidity function calls).
285      *
286      * Returns the raw returned data. To convert to the expected return value,
287      * use https://solidity.readthedocs.io/en/latest/units-and-global-variables.html?highlight=abi.decode#abi-encoding-and-decoding-functions[`abi.decode`].
288      *
289      * Requirements:
290      *
291      * - `target` must be a contract.
292      * - calling `target` with `data` must not revert.
293      *
294      * _Available since v3.1._
295      */
296     function functionCall(address target, bytes memory data) internal returns (bytes memory) {
297         return functionCall(target, data, "Address: low-level call failed");
298     }
299 
300     /**
301      * @dev Same as {xref-Address-functionCall-address-bytes-}[`functionCall`], but with
302      * `errorMessage` as a fallback revert reason when `target` reverts.
303      *
304      * _Available since v3.1._
305      */
306     function functionCall(
307         address target,
308         bytes memory data,
309         string memory errorMessage
310     ) internal returns (bytes memory) {
311         return functionCallWithValue(target, data, 0, errorMessage);
312     }
313 
314     /**
315      * @dev Same as {xref-Address-functionCall-address-bytes-}[`functionCall`],
316      * but also transferring `value` wei to `target`.
317      *
318      * Requirements:
319      *
320      * - the calling contract must have an ETH balance of at least `value`.
321      * - the called Solidity function must be `payable`.
322      *
323      * _Available since v3.1._
324      */
325     function functionCallWithValue(
326         address target,
327         bytes memory data,
328         uint256 value
329     ) internal returns (bytes memory) {
330         return functionCallWithValue(target, data, value, "Address: low-level call with value failed");
331     }
332 
333     /**
334      * @dev Same as {xref-Address-functionCallWithValue-address-bytes-uint256-}[`functionCallWithValue`], but
335      * with `errorMessage` as a fallback revert reason when `target` reverts.
336      *
337      * _Available since v3.1._
338      */
339     function functionCallWithValue(
340         address target,
341         bytes memory data,
342         uint256 value,
343         string memory errorMessage
344     ) internal returns (bytes memory) {
345         require(address(this).balance >= value, "Address: insufficient balance for call");
346         require(isContract(target), "Address: call to non-contract");
347 
348         (bool success, bytes memory returndata) = target.call{value: value}(data);
349         return verifyCallResult(success, returndata, errorMessage);
350     }
351 
352     /**
353      * @dev Same as {xref-Address-functionCall-address-bytes-}[`functionCall`],
354      * but performing a static call.
355      *
356      * _Available since v3.3._
357      */
358     function functionStaticCall(address target, bytes memory data) internal view returns (bytes memory) {
359         return functionStaticCall(target, data, "Address: low-level static call failed");
360     }
361 
362     /**
363      * @dev Same as {xref-Address-functionCall-address-bytes-string-}[`functionCall`],
364      * but performing a static call.
365      *
366      * _Available since v3.3._
367      */
368     function functionStaticCall(
369         address target,
370         bytes memory data,
371         string memory errorMessage
372     ) internal view returns (bytes memory) {
373         require(isContract(target), "Address: static call to non-contract");
374 
375         (bool success, bytes memory returndata) = target.staticcall(data);
376         return verifyCallResult(success, returndata, errorMessage);
377     }
378 
379     /**
380      * @dev Same as {xref-Address-functionCall-address-bytes-}[`functionCall`],
381      * but performing a delegate call.
382      *
383      * _Available since v3.4._
384      */
385     function functionDelegateCall(address target, bytes memory data) internal returns (bytes memory) {
386         return functionDelegateCall(target, data, "Address: low-level delegate call failed");
387     }
388 
389     /**
390      * @dev Same as {xref-Address-functionCall-address-bytes-string-}[`functionCall`],
391      * but performing a delegate call.
392      *
393      * _Available since v3.4._
394      */
395     function functionDelegateCall(
396         address target,
397         bytes memory data,
398         string memory errorMessage
399     ) internal returns (bytes memory) {
400         require(isContract(target), "Address: delegate call to non-contract");
401 
402         (bool success, bytes memory returndata) = target.delegatecall(data);
403         return verifyCallResult(success, returndata, errorMessage);
404     }
405 
406     /**
407      * @dev Tool to verifies that a low level call was successful, and revert if it wasn't, either by bubbling the
408      * revert reason using the provided one.
409      *
410      * _Available since v4.3._
411      */
412     function verifyCallResult(
413         bool success,
414         bytes memory returndata,
415         string memory errorMessage
416     ) internal pure returns (bytes memory) {
417         if (success) {
418             return returndata;
419         } else {
420             // Look for revert reason and bubble it up if present
421             if (returndata.length > 0) {
422                 // The easiest way to bubble the revert reason is using memory via assembly
423 
424                 assembly {
425                     let returndata_size := mload(returndata)
426                     revert(add(32, returndata), returndata_size)
427                 }
428             } else {
429                 revert(errorMessage);
430             }
431         }
432     }
433 }
434 
435 
436 // OpenZeppelin Contracts v4.4.1 (utils/Context.sol)
437 /**
438  * @dev Provides information about the current execution context, including the
439  * sender of the transaction and its data. While these are generally available
440  * via msg.sender and msg.data, they should not be accessed in such a direct
441  * manner, since when dealing with meta-transactions the account sending and
442  * paying for execution may not be the actual sender (as far as an application
443  * is concerned).
444  *
445  * This contract is only required for intermediate, library-like contracts.
446  */
447 abstract contract Context {
448     function _msgSender() internal view virtual returns (address) {
449         return msg.sender;
450     }
451 
452     function _msgData() internal view virtual returns (bytes calldata) {
453         return msg.data;
454     }
455 }
456 
457 
458 // OpenZeppelin Contracts v4.4.1 (utils/Strings.sol)
459 /**
460  * @dev String operations.
461  */
462 library Strings {
463     bytes16 private constant _HEX_SYMBOLS = "0123456789abcdef";
464 
465     /**
466      * @dev Converts a `uint256` to its ASCII `string` decimal representation.
467      */
468     function toString(uint256 value) internal pure returns (string memory) {
469         // Inspired by OraclizeAPI's implementation - MIT licence
470         // https://github.com/oraclize/ethereum-api/blob/b42146b063c7d6ee1358846c198246239e9360e8/oraclizeAPI_0.4.25.sol
471 
472         if (value == 0) {
473             return "0";
474         }
475         uint256 temp = value;
476         uint256 digits;
477         while (temp != 0) {
478             digits++;
479             temp /= 10;
480         }
481         bytes memory buffer = new bytes(digits);
482         while (value != 0) {
483             digits -= 1;
484             buffer[digits] = bytes1(uint8(48 + uint256(value % 10)));
485             value /= 10;
486         }
487         return string(buffer);
488     }
489 
490     /**
491      * @dev Converts a `uint256` to its ASCII `string` hexadecimal representation.
492      */
493     function toHexString(uint256 value) internal pure returns (string memory) {
494         if (value == 0) {
495             return "0x00";
496         }
497         uint256 temp = value;
498         uint256 length = 0;
499         while (temp != 0) {
500             length++;
501             temp >>= 8;
502         }
503         return toHexString(value, length);
504     }
505 
506     /**
507      * @dev Converts a `uint256` to its ASCII `string` hexadecimal representation with fixed length.
508      */
509     function toHexString(uint256 value, uint256 length) internal pure returns (string memory) {
510         bytes memory buffer = new bytes(2 * length + 2);
511         buffer[0] = "0";
512         buffer[1] = "x";
513         for (uint256 i = 2 * length + 1; i > 1; --i) {
514             buffer[i] = _HEX_SYMBOLS[value & 0xf];
515             value >>= 4;
516         }
517         require(value == 0, "Strings: hex length insufficient");
518         return string(buffer);
519     }
520 }
521 
522 
523 // OpenZeppelin Contracts v4.4.1 (utils/introspection/ERC165.sol)
524 /**
525  * @dev Implementation of the {IERC165} interface.
526  *
527  * Contracts that want to implement ERC165 should inherit from this contract and override {supportsInterface} to check
528  * for the additional interface id that will be supported. For example:
529  *
530  * ```solidity
531  * function supportsInterface(bytes4 interfaceId) public view virtual override returns (bool) {
532  *     return interfaceId == type(MyInterface).interfaceId || super.supportsInterface(interfaceId);
533  * }
534  * ```
535  *
536  * Alternatively, {ERC165Storage} provides an easier to use but more expensive implementation.
537  */
538 abstract contract ERC165 is IERC165 {
539     /**
540      * @dev See {IERC165-supportsInterface}.
541      */
542     function supportsInterface(bytes4 interfaceId) public view virtual override returns (bool) {
543         return interfaceId == type(IERC165).interfaceId;
544     }
545 }
546 
547 
548 // OpenZeppelin Contracts (last updated v4.5.0) (token/ERC721/ERC721.sol)
549 /**
550  * @dev Implementation of https://eips.ethereum.org/EIPS/eip-721[ERC721] Non-Fungible Token Standard, including
551  * the Metadata extension, but not including the Enumerable extension, which is available separately as
552  * {ERC721Enumerable}.
553  */
554 contract ERC721 is Context, ERC165, IERC721, IERC721Metadata {
555     using Address for address;
556     using Strings for uint256;
557 
558     // Token name
559     string private _name;
560 
561     // Token symbol
562     string private _symbol;
563 
564     // Mapping from token ID to owner address
565     mapping(uint256 => address) private _owners;
566 
567     // Mapping owner address to token count
568     mapping(address => uint256) private _balances;
569 
570     // Mapping from token ID to approved address
571     mapping(uint256 => address) private _tokenApprovals;
572 
573     // Mapping from owner to operator approvals
574     mapping(address => mapping(address => bool)) private _operatorApprovals;
575 
576     /**
577      * @dev Initializes the contract by setting a `name` and a `symbol` to the token collection.
578      */
579     constructor(string memory name_, string memory symbol_) {
580         _name = name_;
581         _symbol = symbol_;
582     }
583 
584     /**
585      * @dev See {IERC165-supportsInterface}.
586      */
587     function supportsInterface(bytes4 interfaceId) public view virtual override(ERC165, IERC165) returns (bool) {
588         return
589             interfaceId == type(IERC721).interfaceId ||
590             interfaceId == type(IERC721Metadata).interfaceId ||
591             super.supportsInterface(interfaceId);
592     }
593 
594     /**
595      * @dev See {IERC721-balanceOf}.
596      */
597     function balanceOf(address owner) public view virtual override returns (uint256) {
598         require(owner != address(0), "ERC721: balance query for the zero address");
599         return _balances[owner];
600     }
601 
602     /**
603      * @dev See {IERC721-ownerOf}.
604      */
605     function ownerOf(uint256 tokenId) public view virtual override returns (address) {
606         address owner = _owners[tokenId];
607         require(owner != address(0), "ERC721: owner query for nonexistent token");
608         return owner;
609     }
610 
611     /**
612      * @dev See {IERC721Metadata-name}.
613      */
614     function name() public view virtual override returns (string memory) {
615         return _name;
616     }
617 
618     /**
619      * @dev See {IERC721Metadata-symbol}.
620      */
621     function symbol() public view virtual override returns (string memory) {
622         return _symbol;
623     }
624 
625     /**
626      * @dev See {IERC721Metadata-tokenURI}.
627      */
628     function tokenURI(uint256 tokenId) public view virtual override returns (string memory) {
629         require(_exists(tokenId), "ERC721Metadata: URI query for nonexistent token");
630 
631         string memory baseURI = _baseURI();
632         return bytes(baseURI).length > 0 ? string(abi.encodePacked(baseURI, tokenId.toString())) : "";
633     }
634 
635     /**
636      * @dev Base URI for computing {tokenURI}. If set, the resulting URI for each
637      * token will be the concatenation of the `baseURI` and the `tokenId`. Empty
638      * by default, can be overriden in child contracts.
639      */
640     function _baseURI() internal view virtual returns (string memory) {
641         return "";
642     }
643 
644     /**
645      * @dev See {IERC721-approve}.
646      */
647     function approve(address to, uint256 tokenId) public virtual override {
648         address owner = ERC721.ownerOf(tokenId);
649         require(to != owner, "ERC721: approval to current owner");
650 
651         require(
652             _msgSender() == owner || isApprovedForAll(owner, _msgSender()),
653             "ERC721: approve caller is not owner nor approved for all"
654         );
655 
656         _approve(to, tokenId);
657     }
658 
659     /**
660      * @dev See {IERC721-getApproved}.
661      */
662     function getApproved(uint256 tokenId) public view virtual override returns (address) {
663         require(_exists(tokenId), "ERC721: approved query for nonexistent token");
664 
665         return _tokenApprovals[tokenId];
666     }
667 
668     /**
669      * @dev See {IERC721-setApprovalForAll}.
670      */
671     function setApprovalForAll(address operator, bool approved) public virtual override {
672         _setApprovalForAll(_msgSender(), operator, approved);
673     }
674 
675     /**
676      * @dev See {IERC721-isApprovedForAll}.
677      */
678     function isApprovedForAll(address owner, address operator) public view virtual override returns (bool) {
679         return _operatorApprovals[owner][operator];
680     }
681 
682     /**
683      * @dev See {IERC721-transferFrom}.
684      */
685     function transferFrom(
686         address from,
687         address to,
688         uint256 tokenId
689     ) public virtual override {
690         //solhint-disable-next-line max-line-length
691         require(_isApprovedOrOwner(_msgSender(), tokenId), "ERC721: transfer caller is not owner nor approved");
692 
693         _transfer(from, to, tokenId);
694     }
695 
696     /**
697      * @dev See {IERC721-safeTransferFrom}.
698      */
699     function safeTransferFrom(
700         address from,
701         address to,
702         uint256 tokenId
703     ) public virtual override {
704         safeTransferFrom(from, to, tokenId, "");
705     }
706 
707     /**
708      * @dev See {IERC721-safeTransferFrom}.
709      */
710     function safeTransferFrom(
711         address from,
712         address to,
713         uint256 tokenId,
714         bytes memory _data
715     ) public virtual override {
716         require(_isApprovedOrOwner(_msgSender(), tokenId), "ERC721: transfer caller is not owner nor approved");
717         _safeTransfer(from, to, tokenId, _data);
718     }
719 
720     /**
721      * @dev Safely transfers `tokenId` token from `from` to `to`, checking first that contract recipients
722      * are aware of the ERC721 protocol to prevent tokens from being forever locked.
723      *
724      * `_data` is additional data, it has no specified format and it is sent in call to `to`.
725      *
726      * This internal function is equivalent to {safeTransferFrom}, and can be used to e.g.
727      * implement alternative mechanisms to perform token transfer, such as signature-based.
728      *
729      * Requirements:
730      *
731      * - `from` cannot be the zero address.
732      * - `to` cannot be the zero address.
733      * - `tokenId` token must exist and be owned by `from`.
734      * - If `to` refers to a smart contract, it must implement {IERC721Receiver-onERC721Received}, which is called upon a safe transfer.
735      *
736      * Emits a {Transfer} event.
737      */
738     function _safeTransfer(
739         address from,
740         address to,
741         uint256 tokenId,
742         bytes memory _data
743     ) internal virtual {
744         _transfer(from, to, tokenId);
745         require(_checkOnERC721Received(from, to, tokenId, _data), "ERC721: transfer to non ERC721Receiver implementer");
746     }
747 
748     /**
749      * @dev Returns whether `tokenId` exists.
750      *
751      * Tokens can be managed by their owner or approved accounts via {approve} or {setApprovalForAll}.
752      *
753      * Tokens start existing when they are minted (`_mint`),
754      * and stop existing when they are burned (`_burn`).
755      */
756     function _exists(uint256 tokenId) internal view virtual returns (bool) {
757         return _owners[tokenId] != address(0);
758     }
759 
760     /**
761      * @dev Returns whether `spender` is allowed to manage `tokenId`.
762      *
763      * Requirements:
764      *
765      * - `tokenId` must exist.
766      */
767     function _isApprovedOrOwner(address spender, uint256 tokenId) internal view virtual returns (bool) {
768         require(_exists(tokenId), "ERC721: operator query for nonexistent token");
769         address owner = ERC721.ownerOf(tokenId);
770         return (spender == owner || getApproved(tokenId) == spender || isApprovedForAll(owner, spender));
771     }
772 
773     /**
774      * @dev Safely mints `tokenId` and transfers it to `to`.
775      *
776      * Requirements:
777      *
778      * - `tokenId` must not exist.
779      * - If `to` refers to a smart contract, it must implement {IERC721Receiver-onERC721Received}, which is called upon a safe transfer.
780      *
781      * Emits a {Transfer} event.
782      */
783     function _safeMint(address to, uint256 tokenId) internal virtual {
784         _safeMint(to, tokenId, "");
785     }
786 
787     /**
788      * @dev Same as {xref-ERC721-_safeMint-address-uint256-}[`_safeMint`], with an additional `data` parameter which is
789      * forwarded in {IERC721Receiver-onERC721Received} to contract recipients.
790      */
791     function _safeMint(
792         address to,
793         uint256 tokenId,
794         bytes memory _data
795     ) internal virtual {
796         _mint(to, tokenId);
797         require(
798             _checkOnERC721Received(address(0), to, tokenId, _data),
799             "ERC721: transfer to non ERC721Receiver implementer"
800         );
801     }
802 
803     /**
804      * @dev Mints `tokenId` and transfers it to `to`.
805      *
806      * WARNING: Usage of this method is discouraged, use {_safeMint} whenever possible
807      *
808      * Requirements:
809      *
810      * - `tokenId` must not exist.
811      * - `to` cannot be the zero address.
812      *
813      * Emits a {Transfer} event.
814      */
815     function _mint(address to, uint256 tokenId) internal virtual {
816         require(to != address(0), "ERC721: mint to the zero address");
817         require(!_exists(tokenId), "ERC721: token already minted");
818 
819         _beforeTokenTransfer(address(0), to, tokenId);
820 
821         _balances[to] += 1;
822         _owners[tokenId] = to;
823 
824         emit Transfer(address(0), to, tokenId);
825 
826         _afterTokenTransfer(address(0), to, tokenId);
827     }
828 
829     /**
830      * @dev Destroys `tokenId`.
831      * The approval is cleared when the token is burned.
832      *
833      * Requirements:
834      *
835      * - `tokenId` must exist.
836      *
837      * Emits a {Transfer} event.
838      */
839     function _burn(uint256 tokenId) internal virtual {
840         address owner = ERC721.ownerOf(tokenId);
841 
842         _beforeTokenTransfer(owner, address(0), tokenId);
843 
844         // Clear approvals
845         _approve(address(0), tokenId);
846 
847         _balances[owner] -= 1;
848         delete _owners[tokenId];
849 
850         emit Transfer(owner, address(0), tokenId);
851 
852         _afterTokenTransfer(owner, address(0), tokenId);
853     }
854 
855     /**
856      * @dev Transfers `tokenId` from `from` to `to`.
857      *  As opposed to {transferFrom}, this imposes no restrictions on msg.sender.
858      *
859      * Requirements:
860      *
861      * - `to` cannot be the zero address.
862      * - `tokenId` token must be owned by `from`.
863      *
864      * Emits a {Transfer} event.
865      */
866     function _transfer(
867         address from,
868         address to,
869         uint256 tokenId
870     ) internal virtual {
871         require(ERC721.ownerOf(tokenId) == from, "ERC721: transfer from incorrect owner");
872         require(to != address(0), "ERC721: transfer to the zero address");
873 
874         _beforeTokenTransfer(from, to, tokenId);
875 
876         // Clear approvals from the previous owner
877         _approve(address(0), tokenId);
878 
879         _balances[from] -= 1;
880         _balances[to] += 1;
881         _owners[tokenId] = to;
882 
883         emit Transfer(from, to, tokenId);
884 
885         _afterTokenTransfer(from, to, tokenId);
886     }
887 
888     /**
889      * @dev Approve `to` to operate on `tokenId`
890      *
891      * Emits a {Approval} event.
892      */
893     function _approve(address to, uint256 tokenId) internal virtual {
894         _tokenApprovals[tokenId] = to;
895         emit Approval(ERC721.ownerOf(tokenId), to, tokenId);
896     }
897 
898     /**
899      * @dev Approve `operator` to operate on all of `owner` tokens
900      *
901      * Emits a {ApprovalForAll} event.
902      */
903     function _setApprovalForAll(
904         address owner,
905         address operator,
906         bool approved
907     ) internal virtual {
908         require(owner != operator, "ERC721: approve to caller");
909         _operatorApprovals[owner][operator] = approved;
910         emit ApprovalForAll(owner, operator, approved);
911     }
912 
913     /**
914      * @dev Internal function to invoke {IERC721Receiver-onERC721Received} on a target address.
915      * The call is not executed if the target address is not a contract.
916      *
917      * @param from address representing the previous owner of the given token ID
918      * @param to target address that will receive the tokens
919      * @param tokenId uint256 ID of the token to be transferred
920      * @param _data bytes optional data to send along with the call
921      * @return bool whether the call correctly returned the expected magic value
922      */
923     function _checkOnERC721Received(
924         address from,
925         address to,
926         uint256 tokenId,
927         bytes memory _data
928     ) private returns (bool) {
929         if (to.isContract()) {
930             try IERC721Receiver(to).onERC721Received(_msgSender(), from, tokenId, _data) returns (bytes4 retval) {
931                 return retval == IERC721Receiver.onERC721Received.selector;
932             } catch (bytes memory reason) {
933                 if (reason.length == 0) {
934                     revert("ERC721: transfer to non ERC721Receiver implementer");
935                 } else {
936                     assembly {
937                         revert(add(32, reason), mload(reason))
938                     }
939                 }
940             }
941         } else {
942             return true;
943         }
944     }
945 
946     /**
947      * @dev Hook that is called before any token transfer. This includes minting
948      * and burning.
949      *
950      * Calling conditions:
951      *
952      * - When `from` and `to` are both non-zero, ``from``'s `tokenId` will be
953      * transferred to `to`.
954      * - When `from` is zero, `tokenId` will be minted for `to`.
955      * - When `to` is zero, ``from``'s `tokenId` will be burned.
956      * - `from` and `to` are never both zero.
957      *
958      * To learn more about hooks, head to xref:ROOT:extending-contracts.adoc#using-hooks[Using Hooks].
959      */
960     function _beforeTokenTransfer(
961         address from,
962         address to,
963         uint256 tokenId
964     ) internal virtual {}
965 
966     /**
967      * @dev Hook that is called after any transfer of tokens. This includes
968      * minting and burning.
969      *
970      * Calling conditions:
971      *
972      * - when `from` and `to` are both non-zero.
973      * - `from` and `to` are never both zero.
974      *
975      * To learn more about hooks, head to xref:ROOT:extending-contracts.adoc#using-hooks[Using Hooks].
976      */
977     function _afterTokenTransfer(
978         address from,
979         address to,
980         uint256 tokenId
981     ) internal virtual {}
982 }
983 
984 
985 // OpenZeppelin Contracts (last updated v4.5.0) (token/ERC721/extensions/IERC721Enumerable.sol)
986 /**
987  * @title ERC-721 Non-Fungible Token Standard, optional enumeration extension
988  * @dev See https://eips.ethereum.org/EIPS/eip-721
989  */
990 interface IERC721Enumerable is IERC721 {
991     /**
992      * @dev Returns the total amount of tokens stored by the contract.
993      */
994     function totalSupply() external view returns (uint256);
995 
996     /**
997      * @dev Returns a token ID owned by `owner` at a given `index` of its token list.
998      * Use along with {balanceOf} to enumerate all of ``owner``'s tokens.
999      */
1000     function tokenOfOwnerByIndex(address owner, uint256 index) external view returns (uint256);
1001 
1002     /**
1003      * @dev Returns a token ID at a given `index` of all the tokens stored by the contract.
1004      * Use along with {totalSupply} to enumerate all tokens.
1005      */
1006     function tokenByIndex(uint256 index) external view returns (uint256);
1007 }
1008 
1009 
1010 // OpenZeppelin Contracts v4.4.1 (token/ERC721/extensions/ERC721Enumerable.sol)
1011 /**
1012  * @dev This implements an optional extension of {ERC721} defined in the EIP that adds
1013  * enumerability of all the token ids in the contract as well as all token ids owned by each
1014  * account.
1015  */
1016 abstract contract ERC721Enumerable is ERC721, IERC721Enumerable {
1017     // Mapping from owner to list of owned token IDs
1018     mapping(address => mapping(uint256 => uint256)) private _ownedTokens;
1019 
1020     // Mapping from token ID to index of the owner tokens list
1021     mapping(uint256 => uint256) private _ownedTokensIndex;
1022 
1023     // Array with all token ids, used for enumeration
1024     uint256[] private _allTokens;
1025 
1026     // Mapping from token id to position in the allTokens array
1027     mapping(uint256 => uint256) private _allTokensIndex;
1028 
1029     /**
1030      * @dev See {IERC165-supportsInterface}.
1031      */
1032     function supportsInterface(bytes4 interfaceId) public view virtual override(IERC165, ERC721) returns (bool) {
1033         return interfaceId == type(IERC721Enumerable).interfaceId || super.supportsInterface(interfaceId);
1034     }
1035 
1036     /**
1037      * @dev See {IERC721Enumerable-tokenOfOwnerByIndex}.
1038      */
1039     function tokenOfOwnerByIndex(address owner, uint256 index) public view virtual override returns (uint256) {
1040         require(index < ERC721.balanceOf(owner), "ERC721Enumerable: owner index out of bounds");
1041         return _ownedTokens[owner][index];
1042     }
1043 
1044     /**
1045      * @dev See {IERC721Enumerable-totalSupply}.
1046      */
1047     function totalSupply() public view virtual override returns (uint256) {
1048         return _allTokens.length;
1049     }
1050 
1051     /**
1052      * @dev See {IERC721Enumerable-tokenByIndex}.
1053      */
1054     function tokenByIndex(uint256 index) public view virtual override returns (uint256) {
1055         require(index < ERC721Enumerable.totalSupply(), "ERC721Enumerable: global index out of bounds");
1056         return _allTokens[index];
1057     }
1058 
1059     /**
1060      * @dev Hook that is called before any token transfer. This includes minting
1061      * and burning.
1062      *
1063      * Calling conditions:
1064      *
1065      * - When `from` and `to` are both non-zero, ``from``'s `tokenId` will be
1066      * transferred to `to`.
1067      * - When `from` is zero, `tokenId` will be minted for `to`.
1068      * - When `to` is zero, ``from``'s `tokenId` will be burned.
1069      * - `from` cannot be the zero address.
1070      * - `to` cannot be the zero address.
1071      *
1072      * To learn more about hooks, head to xref:ROOT:extending-contracts.adoc#using-hooks[Using Hooks].
1073      */
1074     function _beforeTokenTransfer(
1075         address from,
1076         address to,
1077         uint256 tokenId
1078     ) internal virtual override {
1079         super._beforeTokenTransfer(from, to, tokenId);
1080 
1081         if (from == address(0)) {
1082             _addTokenToAllTokensEnumeration(tokenId);
1083         } else if (from != to) {
1084             _removeTokenFromOwnerEnumeration(from, tokenId);
1085         }
1086         if (to == address(0)) {
1087             _removeTokenFromAllTokensEnumeration(tokenId);
1088         } else if (to != from) {
1089             _addTokenToOwnerEnumeration(to, tokenId);
1090         }
1091     }
1092 
1093     /**
1094      * @dev Private function to add a token to this extension's ownership-tracking data structures.
1095      * @param to address representing the new owner of the given token ID
1096      * @param tokenId uint256 ID of the token to be added to the tokens list of the given address
1097      */
1098     function _addTokenToOwnerEnumeration(address to, uint256 tokenId) private {
1099         uint256 length = ERC721.balanceOf(to);
1100         _ownedTokens[to][length] = tokenId;
1101         _ownedTokensIndex[tokenId] = length;
1102     }
1103 
1104     /**
1105      * @dev Private function to add a token to this extension's token tracking data structures.
1106      * @param tokenId uint256 ID of the token to be added to the tokens list
1107      */
1108     function _addTokenToAllTokensEnumeration(uint256 tokenId) private {
1109         _allTokensIndex[tokenId] = _allTokens.length;
1110         _allTokens.push(tokenId);
1111     }
1112 
1113     /**
1114      * @dev Private function to remove a token from this extension's ownership-tracking data structures. Note that
1115      * while the token is not assigned a new owner, the `_ownedTokensIndex` mapping is _not_ updated: this allows for
1116      * gas optimizations e.g. when performing a transfer operation (avoiding double writes).
1117      * This has O(1) time complexity, but alters the order of the _ownedTokens array.
1118      * @param from address representing the previous owner of the given token ID
1119      * @param tokenId uint256 ID of the token to be removed from the tokens list of the given address
1120      */
1121     function _removeTokenFromOwnerEnumeration(address from, uint256 tokenId) private {
1122         // To prevent a gap in from's tokens array, we store the last token in the index of the token to delete, and
1123         // then delete the last slot (swap and pop).
1124 
1125         uint256 lastTokenIndex = ERC721.balanceOf(from) - 1;
1126         uint256 tokenIndex = _ownedTokensIndex[tokenId];
1127 
1128         // When the token to delete is the last token, the swap operation is unnecessary
1129         if (tokenIndex != lastTokenIndex) {
1130             uint256 lastTokenId = _ownedTokens[from][lastTokenIndex];
1131 
1132             _ownedTokens[from][tokenIndex] = lastTokenId; // Move the last token to the slot of the to-delete token
1133             _ownedTokensIndex[lastTokenId] = tokenIndex; // Update the moved token's index
1134         }
1135 
1136         // This also deletes the contents at the last position of the array
1137         delete _ownedTokensIndex[tokenId];
1138         delete _ownedTokens[from][lastTokenIndex];
1139     }
1140 
1141     /**
1142      * @dev Private function to remove a token from this extension's token tracking data structures.
1143      * This has O(1) time complexity, but alters the order of the _allTokens array.
1144      * @param tokenId uint256 ID of the token to be removed from the tokens list
1145      */
1146     function _removeTokenFromAllTokensEnumeration(uint256 tokenId) private {
1147         // To prevent a gap in the tokens array, we store the last token in the index of the token to delete, and
1148         // then delete the last slot (swap and pop).
1149 
1150         uint256 lastTokenIndex = _allTokens.length - 1;
1151         uint256 tokenIndex = _allTokensIndex[tokenId];
1152 
1153         // When the token to delete is the last token, the swap operation is unnecessary. However, since this occurs so
1154         // rarely (when the last minted token is burnt) that we still do the swap here to avoid the gas cost of adding
1155         // an 'if' statement (like in _removeTokenFromOwnerEnumeration)
1156         uint256 lastTokenId = _allTokens[lastTokenIndex];
1157 
1158         _allTokens[tokenIndex] = lastTokenId; // Move the last token to the slot of the to-delete token
1159         _allTokensIndex[lastTokenId] = tokenIndex; // Update the moved token's index
1160 
1161         // This also deletes the contents at the last position of the array
1162         delete _allTokensIndex[tokenId];
1163         _allTokens.pop();
1164     }
1165 }
1166 
1167 
1168 // OpenZeppelin Contracts v4.4.1 (token/ERC1155/IERC1155.sol)
1169 /**
1170  * @dev Required interface of an ERC1155 compliant contract, as defined in the
1171  * https://eips.ethereum.org/EIPS/eip-1155[EIP].
1172  *
1173  * _Available since v3.1._
1174  */
1175 interface IERC1155 is IERC165 {
1176     /**
1177      * @dev Emitted when `value` tokens of token type `id` are transferred from `from` to `to` by `operator`.
1178      */
1179     event TransferSingle(address indexed operator, address indexed from, address indexed to, uint256 id, uint256 value);
1180 
1181     /**
1182      * @dev Equivalent to multiple {TransferSingle} events, where `operator`, `from` and `to` are the same for all
1183      * transfers.
1184      */
1185     event TransferBatch(
1186         address indexed operator,
1187         address indexed from,
1188         address indexed to,
1189         uint256[] ids,
1190         uint256[] values
1191     );
1192 
1193     /**
1194      * @dev Emitted when `account` grants or revokes permission to `operator` to transfer their tokens, according to
1195      * `approved`.
1196      */
1197     event ApprovalForAll(address indexed account, address indexed operator, bool approved);
1198 
1199     /**
1200      * @dev Emitted when the URI for token type `id` changes to `value`, if it is a non-programmatic URI.
1201      *
1202      * If an {URI} event was emitted for `id`, the standard
1203      * https://eips.ethereum.org/EIPS/eip-1155#metadata-extensions[guarantees] that `value` will equal the value
1204      * returned by {IERC1155MetadataURI-uri}.
1205      */
1206     event URI(string value, uint256 indexed id);
1207 
1208     /**
1209      * @dev Returns the amount of tokens of token type `id` owned by `account`.
1210      *
1211      * Requirements:
1212      *
1213      * - `account` cannot be the zero address.
1214      */
1215     function balanceOf(address account, uint256 id) external view returns (uint256);
1216 
1217     /**
1218      * @dev xref:ROOT:erc1155.adoc#batch-operations[Batched] version of {balanceOf}.
1219      *
1220      * Requirements:
1221      *
1222      * - `accounts` and `ids` must have the same length.
1223      */
1224     function balanceOfBatch(address[] calldata accounts, uint256[] calldata ids)
1225         external
1226         view
1227         returns (uint256[] memory);
1228 
1229     /**
1230      * @dev Grants or revokes permission to `operator` to transfer the caller's tokens, according to `approved`,
1231      *
1232      * Emits an {ApprovalForAll} event.
1233      *
1234      * Requirements:
1235      *
1236      * - `operator` cannot be the caller.
1237      */
1238     function setApprovalForAll(address operator, bool approved) external;
1239 
1240     /**
1241      * @dev Returns true if `operator` is approved to transfer ``account``'s tokens.
1242      *
1243      * See {setApprovalForAll}.
1244      */
1245     function isApprovedForAll(address account, address operator) external view returns (bool);
1246 
1247     /**
1248      * @dev Transfers `amount` tokens of token type `id` from `from` to `to`.
1249      *
1250      * Emits a {TransferSingle} event.
1251      *
1252      * Requirements:
1253      *
1254      * - `to` cannot be the zero address.
1255      * - If the caller is not `from`, it must be have been approved to spend ``from``'s tokens via {setApprovalForAll}.
1256      * - `from` must have a balance of tokens of type `id` of at least `amount`.
1257      * - If `to` refers to a smart contract, it must implement {IERC1155Receiver-onERC1155Received} and return the
1258      * acceptance magic value.
1259      */
1260     function safeTransferFrom(
1261         address from,
1262         address to,
1263         uint256 id,
1264         uint256 amount,
1265         bytes calldata data
1266     ) external;
1267 
1268     /**
1269      * @dev xref:ROOT:erc1155.adoc#batch-operations[Batched] version of {safeTransferFrom}.
1270      *
1271      * Emits a {TransferBatch} event.
1272      *
1273      * Requirements:
1274      *
1275      * - `ids` and `amounts` must have the same length.
1276      * - If `to` refers to a smart contract, it must implement {IERC1155Receiver-onERC1155BatchReceived} and return the
1277      * acceptance magic value.
1278      */
1279     function safeBatchTransferFrom(
1280         address from,
1281         address to,
1282         uint256[] calldata ids,
1283         uint256[] calldata amounts,
1284         bytes calldata data
1285     ) external;
1286 }
1287 
1288 
1289 // OpenZeppelin Contracts v4.4.1 (access/Ownable.sol)
1290 /**
1291  * @dev Contract module which provides a basic access control mechanism, where
1292  * there is an account (an owner) that can be granted exclusive access to
1293  * specific functions.
1294  *
1295  * By default, the owner account will be the one that deploys the contract. This
1296  * can later be changed with {transferOwnership}.
1297  *
1298  * This module is used through inheritance. It will make available the modifier
1299  * `onlyOwner`, which can be applied to your functions to restrict their use to
1300  * the owner.
1301  */
1302 abstract contract Ownable is Context {
1303     address private _owner;
1304 
1305     event OwnershipTransferred(address indexed previousOwner, address indexed newOwner);
1306 
1307     /**
1308      * @dev Initializes the contract setting the deployer as the initial owner.
1309      */
1310     constructor() {
1311         _transferOwnership(_msgSender());
1312     }
1313 
1314     /**
1315      * @dev Returns the address of the current owner.
1316      */
1317     function owner() public view virtual returns (address) {
1318         return _owner;
1319     }
1320 
1321     /**
1322      * @dev Throws if called by any account other than the owner.
1323      */
1324     modifier onlyOwner() {
1325         require(owner() == _msgSender(), "Ownable: caller is not the owner");
1326         _;
1327     }
1328 
1329     /**
1330      * @dev Leaves the contract without owner. It will not be possible to call
1331      * `onlyOwner` functions anymore. Can only be called by the current owner.
1332      *
1333      * NOTE: Renouncing ownership will leave the contract without an owner,
1334      * thereby removing any functionality that is only available to the owner.
1335      */
1336     function renounceOwnership() public virtual onlyOwner {
1337         _transferOwnership(address(0));
1338     }
1339 
1340     /**
1341      * @dev Transfers ownership of the contract to a new account (`newOwner`).
1342      * Can only be called by the current owner.
1343      */
1344     function transferOwnership(address newOwner) public virtual onlyOwner {
1345         require(newOwner != address(0), "Ownable: new owner is the zero address");
1346         _transferOwnership(newOwner);
1347     }
1348 
1349     /**
1350      * @dev Transfers ownership of the contract to a new account (`newOwner`).
1351      * Internal function without access restriction.
1352      */
1353     function _transferOwnership(address newOwner) internal virtual {
1354         address oldOwner = _owner;
1355         _owner = newOwner;
1356         emit OwnershipTransferred(oldOwner, newOwner);
1357     }
1358 }
1359 
1360 
1361 // OpenZeppelin Contracts v4.4.1 (utils/math/SafeMath.sol)
1362 // CAUTION
1363 // This version of SafeMath should only be used with Solidity 0.8 or later,
1364 // because it relies on the compiler's built in overflow checks.
1365 /**
1366  * @dev Wrappers over Solidity's arithmetic operations.
1367  *
1368  * NOTE: `SafeMath` is generally not needed starting with Solidity 0.8, since the compiler
1369  * now has built in overflow checking.
1370  */
1371 library SafeMath {
1372     /**
1373      * @dev Returns the addition of two unsigned integers, with an overflow flag.
1374      *
1375      * _Available since v3.4._
1376      */
1377     function tryAdd(uint256 a, uint256 b) internal pure returns (bool, uint256) {
1378         unchecked {
1379             uint256 c = a + b;
1380             if (c < a) return (false, 0);
1381             return (true, c);
1382         }
1383     }
1384 
1385     /**
1386      * @dev Returns the substraction of two unsigned integers, with an overflow flag.
1387      *
1388      * _Available since v3.4._
1389      */
1390     function trySub(uint256 a, uint256 b) internal pure returns (bool, uint256) {
1391         unchecked {
1392             if (b > a) return (false, 0);
1393             return (true, a - b);
1394         }
1395     }
1396 
1397     /**
1398      * @dev Returns the multiplication of two unsigned integers, with an overflow flag.
1399      *
1400      * _Available since v3.4._
1401      */
1402     function tryMul(uint256 a, uint256 b) internal pure returns (bool, uint256) {
1403         unchecked {
1404             // Gas optimization: this is cheaper than requiring 'a' not being zero, but the
1405             // benefit is lost if 'b' is also tested.
1406             // See: https://github.com/OpenZeppelin/openzeppelin-contracts/pull/522
1407             if (a == 0) return (true, 0);
1408             uint256 c = a * b;
1409             if (c / a != b) return (false, 0);
1410             return (true, c);
1411         }
1412     }
1413 
1414     /**
1415      * @dev Returns the division of two unsigned integers, with a division by zero flag.
1416      *
1417      * _Available since v3.4._
1418      */
1419     function tryDiv(uint256 a, uint256 b) internal pure returns (bool, uint256) {
1420         unchecked {
1421             if (b == 0) return (false, 0);
1422             return (true, a / b);
1423         }
1424     }
1425 
1426     /**
1427      * @dev Returns the remainder of dividing two unsigned integers, with a division by zero flag.
1428      *
1429      * _Available since v3.4._
1430      */
1431     function tryMod(uint256 a, uint256 b) internal pure returns (bool, uint256) {
1432         unchecked {
1433             if (b == 0) return (false, 0);
1434             return (true, a % b);
1435         }
1436     }
1437 
1438     /**
1439      * @dev Returns the addition of two unsigned integers, reverting on
1440      * overflow.
1441      *
1442      * Counterpart to Solidity's `+` operator.
1443      *
1444      * Requirements:
1445      *
1446      * - Addition cannot overflow.
1447      */
1448     function add(uint256 a, uint256 b) internal pure returns (uint256) {
1449         return a + b;
1450     }
1451 
1452     /**
1453      * @dev Returns the subtraction of two unsigned integers, reverting on
1454      * overflow (when the result is negative).
1455      *
1456      * Counterpart to Solidity's `-` operator.
1457      *
1458      * Requirements:
1459      *
1460      * - Subtraction cannot overflow.
1461      */
1462     function sub(uint256 a, uint256 b) internal pure returns (uint256) {
1463         return a - b;
1464     }
1465 
1466     /**
1467      * @dev Returns the multiplication of two unsigned integers, reverting on
1468      * overflow.
1469      *
1470      * Counterpart to Solidity's `*` operator.
1471      *
1472      * Requirements:
1473      *
1474      * - Multiplication cannot overflow.
1475      */
1476     function mul(uint256 a, uint256 b) internal pure returns (uint256) {
1477         return a * b;
1478     }
1479 
1480     /**
1481      * @dev Returns the integer division of two unsigned integers, reverting on
1482      * division by zero. The result is rounded towards zero.
1483      *
1484      * Counterpart to Solidity's `/` operator.
1485      *
1486      * Requirements:
1487      *
1488      * - The divisor cannot be zero.
1489      */
1490     function div(uint256 a, uint256 b) internal pure returns (uint256) {
1491         return a / b;
1492     }
1493 
1494     /**
1495      * @dev Returns the remainder of dividing two unsigned integers. (unsigned integer modulo),
1496      * reverting when dividing by zero.
1497      *
1498      * Counterpart to Solidity's `%` operator. This function uses a `revert`
1499      * opcode (which leaves remaining gas untouched) while Solidity uses an
1500      * invalid opcode to revert (consuming all remaining gas).
1501      *
1502      * Requirements:
1503      *
1504      * - The divisor cannot be zero.
1505      */
1506     function mod(uint256 a, uint256 b) internal pure returns (uint256) {
1507         return a % b;
1508     }
1509 
1510     /**
1511      * @dev Returns the subtraction of two unsigned integers, reverting with custom message on
1512      * overflow (when the result is negative).
1513      *
1514      * CAUTION: This function is deprecated because it requires allocating memory for the error
1515      * message unnecessarily. For custom revert reasons use {trySub}.
1516      *
1517      * Counterpart to Solidity's `-` operator.
1518      *
1519      * Requirements:
1520      *
1521      * - Subtraction cannot overflow.
1522      */
1523     function sub(
1524         uint256 a,
1525         uint256 b,
1526         string memory errorMessage
1527     ) internal pure returns (uint256) {
1528         unchecked {
1529             require(b <= a, errorMessage);
1530             return a - b;
1531         }
1532     }
1533 
1534     /**
1535      * @dev Returns the integer division of two unsigned integers, reverting with custom message on
1536      * division by zero. The result is rounded towards zero.
1537      *
1538      * Counterpart to Solidity's `/` operator. Note: this function uses a
1539      * `revert` opcode (which leaves remaining gas untouched) while Solidity
1540      * uses an invalid opcode to revert (consuming all remaining gas).
1541      *
1542      * Requirements:
1543      *
1544      * - The divisor cannot be zero.
1545      */
1546     function div(
1547         uint256 a,
1548         uint256 b,
1549         string memory errorMessage
1550     ) internal pure returns (uint256) {
1551         unchecked {
1552             require(b > 0, errorMessage);
1553             return a / b;
1554         }
1555     }
1556 
1557     /**
1558      * @dev Returns the remainder of dividing two unsigned integers. (unsigned integer modulo),
1559      * reverting with custom message when dividing by zero.
1560      *
1561      * CAUTION: This function is deprecated because it requires allocating memory for the error
1562      * message unnecessarily. For custom revert reasons use {tryMod}.
1563      *
1564      * Counterpart to Solidity's `%` operator. This function uses a `revert`
1565      * opcode (which leaves remaining gas untouched) while Solidity uses an
1566      * invalid opcode to revert (consuming all remaining gas).
1567      *
1568      * Requirements:
1569      *
1570      * - The divisor cannot be zero.
1571      */
1572     function mod(
1573         uint256 a,
1574         uint256 b,
1575         string memory errorMessage
1576     ) internal pure returns (uint256) {
1577         unchecked {
1578             require(b > 0, errorMessage);
1579             return a % b;
1580         }
1581     }
1582 }
1583 
1584 
1585 // OpenZeppelin Contracts v4.4.1 (security/ReentrancyGuard.sol)
1586 /**
1587  * @dev Contract module that helps prevent reentrant calls to a function.
1588  *
1589  * Inheriting from `ReentrancyGuard` will make the {nonReentrant} modifier
1590  * available, which can be applied to functions to make sure there are no nested
1591  * (reentrant) calls to them.
1592  *
1593  * Note that because there is a single `nonReentrant` guard, functions marked as
1594  * `nonReentrant` may not call one another. This can be worked around by making
1595  * those functions `private`, and then adding `external` `nonReentrant` entry
1596  * points to them.
1597  *
1598  * TIP: If you would like to learn more about reentrancy and alternative ways
1599  * to protect against it, check out our blog post
1600  * https://blog.openzeppelin.com/reentrancy-after-istanbul/[Reentrancy After Istanbul].
1601  */
1602 abstract contract ReentrancyGuard {
1603     // Booleans are more expensive than uint256 or any type that takes up a full
1604     // word because each write operation emits an extra SLOAD to first read the
1605     // slot's contents, replace the bits taken up by the boolean, and then write
1606     // back. This is the compiler's defense against contract upgrades and
1607     // pointer aliasing, and it cannot be disabled.
1608 
1609     // The values being non-zero value makes deployment a bit more expensive,
1610     // but in exchange the refund on every call to nonReentrant will be lower in
1611     // amount. Since refunds are capped to a percentage of the total
1612     // transaction's gas, it is best to keep them low in cases like this one, to
1613     // increase the likelihood of the full refund coming into effect.
1614     uint256 private constant _NOT_ENTERED = 1;
1615     uint256 private constant _ENTERED = 2;
1616 
1617     uint256 private _status;
1618 
1619     constructor() {
1620         _status = _NOT_ENTERED;
1621     }
1622 
1623     /**
1624      * @dev Prevents a contract from calling itself, directly or indirectly.
1625      * Calling a `nonReentrant` function from another `nonReentrant`
1626      * function is not supported. It is possible to prevent this from happening
1627      * by making the `nonReentrant` function external, and making it call a
1628      * `private` function that does the actual work.
1629      */
1630     modifier nonReentrant() {
1631         // On the first call to nonReentrant, _notEntered will be true
1632         require(_status != _ENTERED, "ReentrancyGuard: reentrant call");
1633 
1634         // Any calls to nonReentrant after this point will fail
1635         _status = _ENTERED;
1636 
1637         _;
1638 
1639         // By storing the original value once again, a refund is triggered (see
1640         // https://eips.ethereum.org/EIPS/eip-2200)
1641         _status = _NOT_ENTERED;
1642     }
1643 }
1644 
1645 
1646 interface IMAL {
1647   function spendMAL(address user, uint256 amount) external;
1648 }
1649 
1650 interface ISTAKING {
1651     function balanceOf(address user) external view returns (uint256);
1652 }
1653 
1654 contract MoonBreeding is Context, ERC721Enumerable, Ownable, ReentrancyGuard {
1655     using SafeMath for uint256;
1656     using Strings for uint256;
1657 
1658     string private _baseUri;
1659     uint256 public MAX_SUPPLY = 18000;
1660     uint256 public breedingPrice = 5000 ether;
1661 
1662     bool public saleIsActive;
1663     bool public apeOwnershipRequired;
1664     bool private revealed;
1665 
1666     enum BreedingTypes{
1667         CommonBreed,
1668         RareBreed,
1669         LegendaryBreed
1670     }
1671 
1672     mapping(BreedingTypes => uint256) breedingTypeSupplies;
1673     mapping(BreedingTypes => uint256) breedingTypeMaxSupplies;
1674     mapping(uint256 => BreedingTypes) colaToBreedingType;
1675     bool private maxSuppliesSet;
1676     bool private formulaSet;
1677 
1678     mapping (address => bool) private _isAuthorised;
1679     address[] public authorisedLog;
1680 
1681     // Contracts
1682     IMAL public MAL;
1683     ISTAKING public STAKING;
1684     IERC721 public APES;
1685     IERC1155 public CRYPTO_COLA;
1686 
1687     event BreedingMinted(address indexed mintedBy, uint256 breedType, uint256 amount);
1688 
1689     constructor(address _apes, address _staking, address _mal, address _cryptocola) ERC721("Mutated Moon Ape", "MAL_MUTANT"){
1690       APES = IERC721(address(_apes));
1691       STAKING = ISTAKING(address(_staking));
1692       MAL = IMAL(address(_mal));
1693       CRYPTO_COLA = IERC1155(_cryptocola);
1694 
1695       _baseUri = "ipfs://QmXHQA7TtPs1LAnQ5wgWk5gL5BjYLv9zcMKsnp8eqvKWkS/";
1696       apeOwnershipRequired = true;
1697 
1698       saleIsActive = false;
1699 
1700       colaToBreedingType[0] = BreedingTypes.CommonBreed;
1701       colaToBreedingType[1] = BreedingTypes.RareBreed;
1702       colaToBreedingType[2] = BreedingTypes.LegendaryBreed;
1703       formulaSet = true;
1704 
1705       breedingTypeMaxSupplies[BreedingTypes.CommonBreed] = 10000;
1706       breedingTypeMaxSupplies[BreedingTypes.RareBreed] = 6000;
1707       breedingTypeMaxSupplies[BreedingTypes.LegendaryBreed] = 2000;
1708       maxSuppliesSet = true;
1709     }
1710 
1711     function authorise(address addressToAuth) public onlyOwner {
1712       _isAuthorised[addressToAuth] = true;
1713       authorisedLog.push(addressToAuth);
1714     }
1715 
1716     function unauthorise(address addressToUnAuth) public onlyOwner {
1717       _isAuthorised[addressToUnAuth] = false;
1718     }
1719 
1720     function _isApprovedOrOwner(address spender, uint256 tokenId) internal view override returns (bool) {
1721         require(_exists(tokenId), "ERC721: operator query for nonexistent token");
1722         address owner = ERC721.ownerOf(tokenId);
1723         return (spender == owner || getApproved(tokenId) == spender || isApprovedForAll(owner, spender) || _isAuthorised[spender]);
1724     }
1725 
1726     function setFormula(uint256[] memory _cryptoColaTypes, uint256[] memory _breedingTypes, uint256[] memory _maxSupplies) public onlyOwner{
1727       require(_cryptoColaTypes.length == _breedingTypes.length, "Lists not same length");
1728       require(_cryptoColaTypes.length == _maxSupplies.length, "Lists not same length");
1729       for (uint256 i = 0; i < _cryptoColaTypes.length; i++){
1730         require(_cryptoColaTypes[i] < 3, "Invalid Crypto Cola type");
1731         require(_breedingTypes[i] <= uint256(BreedingTypes.LegendaryBreed), "Invalid Breeding type");
1732         colaToBreedingType[_cryptoColaTypes[i]] = BreedingTypes(_breedingTypes[i]);
1733         breedingTypeMaxSupplies[BreedingTypes(_breedingTypes[i])] = _maxSupplies[i];
1734       }
1735       formulaSet = true;    
1736       maxSuppliesSet = true;
1737     }
1738 
1739     function setMaxSupplies(uint256[] memory _breedingTypes, uint256[] memory _maxSupplies) public onlyOwner{
1740       require(_maxSupplies.length == _breedingTypes.length, "Lists not same length");
1741       for (uint256 i = 0; i < _maxSupplies.length; i++){
1742         require(_breedingTypes[i] <= uint256(BreedingTypes.LegendaryBreed), "Invalid Breeding type");
1743         breedingTypeMaxSupplies[BreedingTypes(_breedingTypes[i])] = _maxSupplies[i];
1744       }
1745     }
1746 
1747     function getNewTokenId(BreedingTypes _breedingType) public view returns (uint256){
1748       uint256 currentSupply = breedingTypeSupplies[_breedingType];
1749       if (_breedingType == BreedingTypes.CommonBreed){
1750         return 1 + currentSupply;
1751       } else if (_breedingType == BreedingTypes.RareBreed){
1752         return breedingTypeMaxSupplies[BreedingTypes.CommonBreed] + 1 + currentSupply;
1753       } else { // BreedingTypes.LegendaryBreed
1754         return breedingTypeMaxSupplies[BreedingTypes.CommonBreed] + breedingTypeMaxSupplies[BreedingTypes.RareBreed] + 1 + currentSupply;
1755       }
1756     }
1757 
1758     function _validateApeOwnership(address user) internal view returns (bool) {
1759       if (!apeOwnershipRequired) return true;
1760       if (STAKING.balanceOf(user) > 0) {
1761         return true;
1762       }
1763       return APES.balanceOf(user) > 0;
1764     }
1765 
1766     function reserveForGiveaways(uint256 breedingType, uint256 breedsToMint) public onlyOwner{
1767       require(totalSupply().add(breedsToMint) <= MAX_SUPPLY, "Minting more tokens than allowed");
1768       require(breedingType <= uint256(BreedingTypes.LegendaryBreed), "Invalid breeding type");
1769       require(breedingTypeSupplies[BreedingTypes(breedingType)].add(breedsToMint) <= breedingTypeMaxSupplies[BreedingTypes(breedingType)], "Max Supply for this breeding type has already been reached");
1770       uint256 newTokenId = getNewTokenId(BreedingTypes(breedingType));
1771       for(uint256 i = 0; i < breedsToMint; i++) {
1772         _safeMint(_msgSender(), newTokenId + i);
1773       }
1774       breedingTypeSupplies[BreedingTypes(breedingType)] += breedsToMint;
1775     }
1776 
1777     function getBreedingTypeSupply(BreedingTypes breedingType) public view returns (uint256){
1778         require(uint256(breedingType) <= uint256(BreedingTypes.LegendaryBreed), "Invalid breeding type");
1779         return breedingTypeSupplies[breedingType];
1780     }
1781 
1782     function purchase(uint256 _cryptoColaToken, uint256 amount) public nonReentrant {
1783       require(saleIsActive, "The mint has not started yet");
1784       require(formulaSet && maxSuppliesSet, "The mint has not started yet");
1785       require(_validateApeOwnership(_msgSender()), "You do not have any Moon Apes");
1786       require(totalSupply().add(1) <= MAX_SUPPLY, "Max Supply has been already reached");
1787       require(CRYPTO_COLA.balanceOf(_msgSender(), _cryptoColaToken) > 0, "Not the owner of this Crypto Cola");
1788 
1789       BreedingTypes resulting_breed = colaToBreedingType[_cryptoColaToken];
1790       require(breedingTypeSupplies[resulting_breed].add(amount) <= breedingTypeMaxSupplies[resulting_breed], "Max Supply for this breeding type has already been reached");
1791 
1792       MAL.spendMAL(_msgSender(), breedingPrice * amount);
1793       CRYPTO_COLA.safeTransferFrom(_msgSender(), address(this), _cryptoColaToken, amount, "");
1794 
1795       uint256 newTokenId = getNewTokenId(resulting_breed);
1796       for (uint256 i = 0; i < amount; i++){
1797         _safeMint(_msgSender(), newTokenId + i);
1798       }
1799       breedingTypeSupplies[resulting_breed] += amount;
1800 
1801       emit BreedingMinted(_msgSender(), uint256(resulting_breed), amount);
1802     }
1803 
1804     function updateSaleStatus(bool status) public onlyOwner {
1805       saleIsActive = status;
1806     }
1807 
1808     function updateBreedingPrice(uint256 _newPrice) public onlyOwner {
1809       require(!saleIsActive, "Pause sale before price update");
1810       breedingPrice = _newPrice;
1811     }
1812 
1813     function tokenURI(uint256 tokenId) public view virtual override returns (string memory) {
1814       require(_exists(tokenId), "ERC721Metadata: URI query for nonexistent token");
1815       return string(abi.encodePacked(string(abi.encodePacked(_baseUri, tokenId.toString())), ".json"));
1816     }
1817 
1818     function changeMaxSupply(uint256 newSupply) public onlyOwner{
1819         require(!saleIsActive, "Pause sale before max supply update");
1820         MAX_SUPPLY = newSupply;
1821     }
1822 
1823     function withdraw() external onlyOwner {
1824       uint256 balance = address(this).balance;
1825       payable(owner()).transfer(balance);
1826     }
1827 
1828     function reveal(string memory _revealUri) public onlyOwner{
1829       require(!revealed, "Already revealed");
1830       _baseUri = _revealUri;
1831       revealed = true;
1832     }
1833 
1834     function onERC1155Received(address, address, uint256, uint256, bytes memory) public pure returns (bytes4) {
1835         return bytes4(keccak256("onERC1155Received(address,address,uint256,uint256,bytes)"));
1836     }
1837 
1838     function onERC1155BatchReceived(address, address, uint256[] memory, uint256[] memory, bytes memory) public pure returns (bytes4) {
1839         return bytes4(keccak256("onERC1155BatchReceived(address,address,uint256[],uint256[],bytes)"));
1840     }
1841 }