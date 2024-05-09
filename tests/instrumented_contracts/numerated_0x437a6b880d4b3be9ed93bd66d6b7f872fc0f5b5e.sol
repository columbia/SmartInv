1 // SPDX-License-Identifier: MIT
2 
3 // File: @openzeppelin\contracts\utils\introspection\IERC165.sol
4 
5 pragma solidity ^0.8.0;
6 
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
28 // File: @openzeppelin\contracts\token\ERC721\IERC721.sol
29 
30 pragma solidity ^0.8.0;
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
170 // File: @openzeppelin\contracts\token\ERC721\IERC721Receiver.sol
171 
172 pragma solidity ^0.8.0;
173 
174 /**
175  * @title ERC721 token receiver interface
176  * @dev Interface for any contract that wants to support safeTransfers
177  * from ERC721 asset contracts.
178  */
179 interface IERC721Receiver {
180     /**
181      * @dev Whenever an {IERC721} `tokenId` token is transferred to this contract via {IERC721-safeTransferFrom}
182      * by `operator` from `from`, this function is called.
183      *
184      * It must return its Solidity selector to confirm the token transfer.
185      * If any other value is returned or the interface is not implemented by the recipient, the transfer will be reverted.
186      *
187      * The selector can be obtained in Solidity with `IERC721.onERC721Received.selector`.
188      */
189     function onERC721Received(
190         address operator,
191         address from,
192         uint256 tokenId,
193         bytes calldata data
194     ) external returns (bytes4);
195 }
196 
197 // File: @openzeppelin\contracts\token\ERC721\extensions\IERC721Metadata.sol
198 
199 pragma solidity ^0.8.0;
200 
201 
202 /**
203  * @title ERC-721 Non-Fungible Token Standard, optional metadata extension
204  * @dev See https://eips.ethereum.org/EIPS/eip-721
205  */
206 interface IERC721Metadata is IERC721 {
207     /**
208      * @dev Returns the token collection name.
209      */
210     function name() external view returns (string memory);
211 
212     /**
213      * @dev Returns the token collection symbol.
214      */
215     function symbol() external view returns (string memory);
216 
217     /**
218      * @dev Returns the Uniform Resource Identifier (URI) for `tokenId` token.
219      */
220     function tokenURI(uint256 tokenId) external view returns (string memory);
221 }
222 
223 // File: @openzeppelin\contracts\utils\Address.sol
224 
225 pragma solidity ^0.8.0;
226 
227 /**
228  * @dev Collection of functions related to the address type
229  */
230 library Address {
231     /**
232      * @dev Returns true if `account` is a contract.
233      *
234      * [IMPORTANT]
235      * ====
236      * It is unsafe to assume that an address for which this function returns
237      * false is an externally-owned account (EOA) and not a contract.
238      *
239      * Among others, `isContract` will return false for the following
240      * types of addresses:
241      *
242      *  - an externally-owned account
243      *  - a contract in construction
244      *  - an address where a contract will be created
245      *  - an address where a contract lived, but was destroyed
246      * ====
247      */
248     function isContract(address account) internal view returns (bool) {
249         // This method relies on extcodesize, which returns 0 for contracts in
250         // construction, since the code is only stored at the end of the
251         // constructor execution.
252 
253         uint256 size;
254         assembly {
255             size := extcodesize(account)
256         }
257         return size > 0;
258     }
259 
260     /**
261      * @dev Replacement for Solidity's `transfer`: sends `amount` wei to
262      * `recipient`, forwarding all available gas and reverting on errors.
263      *
264      * https://eips.ethereum.org/EIPS/eip-1884[EIP1884] increases the gas cost
265      * of certain opcodes, possibly making contracts go over the 2300 gas limit
266      * imposed by `transfer`, making them unable to receive funds via
267      * `transfer`. {sendValue} removes this limitation.
268      *
269      * https://diligence.consensys.net/posts/2019/09/stop-using-soliditys-transfer-now/[Learn more].
270      *
271      * IMPORTANT: because control is transferred to `recipient`, care must be
272      * taken to not create reentrancy vulnerabilities. Consider using
273      * {ReentrancyGuard} or the
274      * https://solidity.readthedocs.io/en/v0.5.11/security-considerations.html#use-the-checks-effects-interactions-pattern[checks-effects-interactions pattern].
275      */
276     function sendValue(address payable recipient, uint256 amount) internal {
277         require(address(this).balance >= amount, "Address: insufficient balance");
278 
279         (bool success, ) = recipient.call{value: amount}("");
280         require(success, "Address: unable to send value, recipient may have reverted");
281     }
282 
283     /**
284      * @dev Performs a Solidity function call using a low level `call`. A
285      * plain `call` is an unsafe replacement for a function call: use this
286      * function instead.
287      *
288      * If `target` reverts with a revert reason, it is bubbled up by this
289      * function (like regular Solidity function calls).
290      *
291      * Returns the raw returned data. To convert to the expected return value,
292      * use https://solidity.readthedocs.io/en/latest/units-and-global-variables.html?highlight=abi.decode#abi-encoding-and-decoding-functions[`abi.decode`].
293      *
294      * Requirements:
295      *
296      * - `target` must be a contract.
297      * - calling `target` with `data` must not revert.
298      *
299      * _Available since v3.1._
300      */
301     function functionCall(address target, bytes memory data) internal returns (bytes memory) {
302         return functionCall(target, data, "Address: low-level call failed");
303     }
304 
305     /**
306      * @dev Same as {xref-Address-functionCall-address-bytes-}[`functionCall`], but with
307      * `errorMessage` as a fallback revert reason when `target` reverts.
308      *
309      * _Available since v3.1._
310      */
311     function functionCall(
312         address target,
313         bytes memory data,
314         string memory errorMessage
315     ) internal returns (bytes memory) {
316         return functionCallWithValue(target, data, 0, errorMessage);
317     }
318 
319     /**
320      * @dev Same as {xref-Address-functionCall-address-bytes-}[`functionCall`],
321      * but also transferring `value` wei to `target`.
322      *
323      * Requirements:
324      *
325      * - the calling contract must have an ETH balance of at least `value`.
326      * - the called Solidity function must be `payable`.
327      *
328      * _Available since v3.1._
329      */
330     function functionCallWithValue(
331         address target,
332         bytes memory data,
333         uint256 value
334     ) internal returns (bytes memory) {
335         return functionCallWithValue(target, data, value, "Address: low-level call with value failed");
336     }
337 
338     /**
339      * @dev Same as {xref-Address-functionCallWithValue-address-bytes-uint256-}[`functionCallWithValue`], but
340      * with `errorMessage` as a fallback revert reason when `target` reverts.
341      *
342      * _Available since v3.1._
343      */
344     function functionCallWithValue(
345         address target,
346         bytes memory data,
347         uint256 value,
348         string memory errorMessage
349     ) internal returns (bytes memory) {
350         require(address(this).balance >= value, "Address: insufficient balance for call");
351         require(isContract(target), "Address: call to non-contract");
352 
353         (bool success, bytes memory returndata) = target.call{value: value}(data);
354         return _verifyCallResult(success, returndata, errorMessage);
355     }
356 
357     /**
358      * @dev Same as {xref-Address-functionCall-address-bytes-}[`functionCall`],
359      * but performing a static call.
360      *
361      * _Available since v3.3._
362      */
363     function functionStaticCall(address target, bytes memory data) internal view returns (bytes memory) {
364         return functionStaticCall(target, data, "Address: low-level static call failed");
365     }
366 
367     /**
368      * @dev Same as {xref-Address-functionCall-address-bytes-string-}[`functionCall`],
369      * but performing a static call.
370      *
371      * _Available since v3.3._
372      */
373     function functionStaticCall(
374         address target,
375         bytes memory data,
376         string memory errorMessage
377     ) internal view returns (bytes memory) {
378         require(isContract(target), "Address: static call to non-contract");
379 
380         (bool success, bytes memory returndata) = target.staticcall(data);
381         return _verifyCallResult(success, returndata, errorMessage);
382     }
383 
384     /**
385      * @dev Same as {xref-Address-functionCall-address-bytes-}[`functionCall`],
386      * but performing a delegate call.
387      *
388      * _Available since v3.4._
389      */
390     function functionDelegateCall(address target, bytes memory data) internal returns (bytes memory) {
391         return functionDelegateCall(target, data, "Address: low-level delegate call failed");
392     }
393 
394     /**
395      * @dev Same as {xref-Address-functionCall-address-bytes-string-}[`functionCall`],
396      * but performing a delegate call.
397      *
398      * _Available since v3.4._
399      */
400     function functionDelegateCall(
401         address target,
402         bytes memory data,
403         string memory errorMessage
404     ) internal returns (bytes memory) {
405         require(isContract(target), "Address: delegate call to non-contract");
406 
407         (bool success, bytes memory returndata) = target.delegatecall(data);
408         return _verifyCallResult(success, returndata, errorMessage);
409     }
410 
411     function _verifyCallResult(
412         bool success,
413         bytes memory returndata,
414         string memory errorMessage
415     ) private pure returns (bytes memory) {
416         if (success) {
417             return returndata;
418         } else {
419             // Look for revert reason and bubble it up if present
420             if (returndata.length > 0) {
421                 // The easiest way to bubble the revert reason is using memory via assembly
422 
423                 assembly {
424                     let returndata_size := mload(returndata)
425                     revert(add(32, returndata), returndata_size)
426                 }
427             } else {
428                 revert(errorMessage);
429             }
430         }
431     }
432 }
433 
434 // File: @openzeppelin\contracts\utils\Context.sol
435 
436 pragma solidity ^0.8.0;
437 
438 /*
439  * @dev Provides information about the current execution context, including the
440  * sender of the transaction and its data. While these are generally available
441  * via msg.sender and msg.data, they should not be accessed in such a direct
442  * manner, since when dealing with meta-transactions the account sending and
443  * paying for execution may not be the actual sender (as far as an application
444  * is concerned).
445  *
446  * This contract is only required for intermediate, library-like contracts.
447  */
448 abstract contract Context {
449     function _msgSender() internal view virtual returns (address) {
450         return msg.sender;
451     }
452 
453     function _msgData() internal view virtual returns (bytes calldata) {
454         return msg.data;
455     }
456 }
457 
458 // File: @openzeppelin\contracts\utils\Strings.sol
459 
460 pragma solidity ^0.8.0;
461 
462 /**
463  * @dev String operations.
464  */
465 library Strings {
466     bytes16 private constant _HEX_SYMBOLS = "0123456789abcdef";
467 
468     /**
469      * @dev Converts a `uint256` to its ASCII `string` decimal representation.
470      */
471     function toString(uint256 value) internal pure returns (string memory) {
472         // Inspired by OraclizeAPI's implementation - MIT licence
473         // https://github.com/oraclize/ethereum-api/blob/b42146b063c7d6ee1358846c198246239e9360e8/oraclizeAPI_0.4.25.sol
474 
475         if (value == 0) {
476             return "0";
477         }
478         uint256 temp = value;
479         uint256 digits;
480         while (temp != 0) {
481             digits++;
482             temp /= 10;
483         }
484         bytes memory buffer = new bytes(digits);
485         while (value != 0) {
486             digits -= 1;
487             buffer[digits] = bytes1(uint8(48 + uint256(value % 10)));
488             value /= 10;
489         }
490         return string(buffer);
491     }
492 
493     /**
494      * @dev Converts a `uint256` to its ASCII `string` hexadecimal representation.
495      */
496     function toHexString(uint256 value) internal pure returns (string memory) {
497         if (value == 0) {
498             return "0x00";
499         }
500         uint256 temp = value;
501         uint256 length = 0;
502         while (temp != 0) {
503             length++;
504             temp >>= 8;
505         }
506         return toHexString(value, length);
507     }
508 
509     /**
510      * @dev Converts a `uint256` to its ASCII `string` hexadecimal representation with fixed length.
511      */
512     function toHexString(uint256 value, uint256 length) internal pure returns (string memory) {
513         bytes memory buffer = new bytes(2 * length + 2);
514         buffer[0] = "0";
515         buffer[1] = "x";
516         for (uint256 i = 2 * length + 1; i > 1; --i) {
517             buffer[i] = _HEX_SYMBOLS[value & 0xf];
518             value >>= 4;
519         }
520         require(value == 0, "Strings: hex length insufficient");
521         return string(buffer);
522     }
523 }
524 
525 // File: @openzeppelin\contracts\utils\introspection\ERC165.sol
526 
527 pragma solidity ^0.8.0;
528 
529 
530 /**
531  * @dev Implementation of the {IERC165} interface.
532  *
533  * Contracts that want to implement ERC165 should inherit from this contract and override {supportsInterface} to check
534  * for the additional interface id that will be supported. For example:
535  *
536  * ```solidity
537  * function supportsInterface(bytes4 interfaceId) public view virtual override returns (bool) {
538  *     return interfaceId == type(MyInterface).interfaceId || super.supportsInterface(interfaceId);
539  * }
540  * ```
541  *
542  * Alternatively, {ERC165Storage} provides an easier to use but more expensive implementation.
543  */
544 abstract contract ERC165 is IERC165 {
545     /**
546      * @dev See {IERC165-supportsInterface}.
547      */
548     function supportsInterface(bytes4 interfaceId) public view virtual override returns (bool) {
549         return interfaceId == type(IERC165).interfaceId;
550     }
551 }
552 
553 // File: @openzeppelin\contracts\token\ERC721\ERC721.sol
554 
555 pragma solidity ^0.8.0;
556 
557 
558 
559 
560 
561 
562 
563 
564 /**
565  * @dev Implementation of https://eips.ethereum.org/EIPS/eip-721[ERC721] Non-Fungible Token Standard, including
566  * the Metadata extension, but not including the Enumerable extension, which is available separately as
567  * {ERC721Enumerable}.
568  */
569 contract ERC721 is Context, ERC165, IERC721, IERC721Metadata {
570     using Address for address;
571     using Strings for uint256;
572 
573     // Token name
574     string private _name;
575 
576     // Token symbol
577     string private _symbol;
578 
579     // Mapping from token ID to owner address
580     mapping(uint256 => address) private _owners;
581 
582     // Mapping owner address to token count
583     mapping(address => uint256) private _balances;
584 
585     // Mapping from token ID to approved address
586     mapping(uint256 => address) private _tokenApprovals;
587 
588     // Mapping from owner to operator approvals
589     mapping(address => mapping(address => bool)) private _operatorApprovals;
590 
591     /**
592      * @dev Initializes the contract by setting a `name` and a `symbol` to the token collection.
593      */
594     constructor(string memory name_, string memory symbol_) {
595         _name = name_;
596         _symbol = symbol_;
597     }
598 
599     /**
600      * @dev See {IERC165-supportsInterface}.
601      */
602     function supportsInterface(bytes4 interfaceId) public view virtual override(ERC165, IERC165) returns (bool) {
603         return
604             interfaceId == type(IERC721).interfaceId ||
605             interfaceId == type(IERC721Metadata).interfaceId ||
606             super.supportsInterface(interfaceId);
607     }
608 
609     /**
610      * @dev See {IERC721-balanceOf}.
611      */
612     function balanceOf(address owner) public view virtual override returns (uint256) {
613         require(owner != address(0), "ERC721: balance query for the zero address");
614         return _balances[owner];
615     }
616 
617     /**
618      * @dev See {IERC721-ownerOf}.
619      */
620     function ownerOf(uint256 tokenId) public view virtual override returns (address) {
621         address owner = _owners[tokenId];
622         require(owner != address(0), "ERC721: owner query for nonexistent token");
623         return owner;
624     }
625 
626     /**
627      * @dev See {IERC721Metadata-name}.
628      */
629     function name() public view virtual override returns (string memory) {
630         return _name;
631     }
632 
633     /**
634      * @dev See {IERC721Metadata-symbol}.
635      */
636     function symbol() public view virtual override returns (string memory) {
637         return _symbol;
638     }
639 
640     /**
641      * @dev See {IERC721Metadata-tokenURI}.
642      */
643     function tokenURI(uint256 tokenId) public view virtual override returns (string memory) {
644         require(_exists(tokenId), "ERC721Metadata: URI query for nonexistent token");
645 
646         string memory baseURI = _baseURI();
647         return bytes(baseURI).length > 0 ? string(abi.encodePacked(baseURI, tokenId.toString())) : "";
648     }
649 
650     /**
651      * @dev Base URI for computing {tokenURI}. If set, the resulting URI for each
652      * token will be the concatenation of the `baseURI` and the `tokenId`. Empty
653      * by default, can be overriden in child contracts.
654      */
655     function _baseURI() internal view virtual returns (string memory) {
656         return "";
657     }
658 
659     /**
660      * @dev See {IERC721-approve}.
661      */
662     function approve(address to, uint256 tokenId) public virtual override {
663         address owner = ERC721.ownerOf(tokenId);
664         require(to != owner, "ERC721: approval to current owner");
665 
666         require(
667             _msgSender() == owner || isApprovedForAll(owner, _msgSender()),
668             "ERC721: approve caller is not owner nor approved for all"
669         );
670 
671         _approve(to, tokenId);
672     }
673 
674     /**
675      * @dev See {IERC721-getApproved}.
676      */
677     function getApproved(uint256 tokenId) public view virtual override returns (address) {
678         require(_exists(tokenId), "ERC721: approved query for nonexistent token");
679 
680         return _tokenApprovals[tokenId];
681     }
682 
683     /**
684      * @dev See {IERC721-setApprovalForAll}.
685      */
686     function setApprovalForAll(address operator, bool approved) public virtual override {
687         require(operator != _msgSender(), "ERC721: approve to caller");
688 
689         _operatorApprovals[_msgSender()][operator] = approved;
690         emit ApprovalForAll(_msgSender(), operator, approved);
691     }
692 
693     /**
694      * @dev See {IERC721-isApprovedForAll}.
695      */
696     function isApprovedForAll(address owner, address operator) public view virtual override returns (bool) {
697         return _operatorApprovals[owner][operator];
698     }
699 
700     /**
701      * @dev See {IERC721-transferFrom}.
702      */
703     function transferFrom(
704         address from,
705         address to,
706         uint256 tokenId
707     ) public virtual override {
708         //solhint-disable-next-line max-line-length
709         require(_isApprovedOrOwner(_msgSender(), tokenId), "ERC721: transfer caller is not owner nor approved");
710 
711         _transfer(from, to, tokenId);
712     }
713 
714     /**
715      * @dev See {IERC721-safeTransferFrom}.
716      */
717     function safeTransferFrom(
718         address from,
719         address to,
720         uint256 tokenId
721     ) public virtual override {
722         safeTransferFrom(from, to, tokenId, "");
723     }
724 
725     /**
726      * @dev See {IERC721-safeTransferFrom}.
727      */
728     function safeTransferFrom(
729         address from,
730         address to,
731         uint256 tokenId,
732         bytes memory _data
733     ) public virtual override {
734         require(_isApprovedOrOwner(_msgSender(), tokenId), "ERC721: transfer caller is not owner nor approved");
735         _safeTransfer(from, to, tokenId, _data);
736     }
737 
738     /**
739      * @dev Safely transfers `tokenId` token from `from` to `to`, checking first that contract recipients
740      * are aware of the ERC721 protocol to prevent tokens from being forever locked.
741      *
742      * `_data` is additional data, it has no specified format and it is sent in call to `to`.
743      *
744      * This internal function is equivalent to {safeTransferFrom}, and can be used to e.g.
745      * implement alternative mechanisms to perform token transfer, such as signature-based.
746      *
747      * Requirements:
748      *
749      * - `from` cannot be the zero address.
750      * - `to` cannot be the zero address.
751      * - `tokenId` token must exist and be owned by `from`.
752      * - If `to` refers to a smart contract, it must implement {IERC721Receiver-onERC721Received}, which is called upon a safe transfer.
753      *
754      * Emits a {Transfer} event.
755      */
756     function _safeTransfer(
757         address from,
758         address to,
759         uint256 tokenId,
760         bytes memory _data
761     ) internal virtual {
762         _transfer(from, to, tokenId);
763         require(_checkOnERC721Received(from, to, tokenId, _data), "ERC721: transfer to non ERC721Receiver implementer");
764     }
765 
766     /**
767      * @dev Returns whether `tokenId` exists.
768      *
769      * Tokens can be managed by their owner or approved accounts via {approve} or {setApprovalForAll}.
770      *
771      * Tokens start existing when they are minted (`_mint`),
772      * and stop existing when they are burned (`_burn`).
773      */
774     function _exists(uint256 tokenId) internal view virtual returns (bool) {
775         return _owners[tokenId] != address(0);
776     }
777 
778     /**
779      * @dev Returns whether `spender` is allowed to manage `tokenId`.
780      *
781      * Requirements:
782      *
783      * - `tokenId` must exist.
784      */
785     function _isApprovedOrOwner(address spender, uint256 tokenId) internal view virtual returns (bool) {
786         require(_exists(tokenId), "ERC721: operator query for nonexistent token");
787         address owner = ERC721.ownerOf(tokenId);
788         return (spender == owner || getApproved(tokenId) == spender || isApprovedForAll(owner, spender));
789     }
790 
791     /**
792      * @dev Safely mints `tokenId` and transfers it to `to`.
793      *
794      * Requirements:
795      *
796      * - `tokenId` must not exist.
797      * - If `to` refers to a smart contract, it must implement {IERC721Receiver-onERC721Received}, which is called upon a safe transfer.
798      *
799      * Emits a {Transfer} event.
800      */
801     function _safeMint(address to, uint256 tokenId) internal virtual {
802         _safeMint(to, tokenId, "");
803     }
804 
805     /**
806      * @dev Same as {xref-ERC721-_safeMint-address-uint256-}[`_safeMint`], with an additional `data` parameter which is
807      * forwarded in {IERC721Receiver-onERC721Received} to contract recipients.
808      */
809     function _safeMint(
810         address to,
811         uint256 tokenId,
812         bytes memory _data
813     ) internal virtual {
814         _mint(to, tokenId);
815         require(
816             _checkOnERC721Received(address(0), to, tokenId, _data),
817             "ERC721: transfer to non ERC721Receiver implementer"
818         );
819     }
820 
821     /**
822      * @dev Mints `tokenId` and transfers it to `to`.
823      *
824      * WARNING: Usage of this method is discouraged, use {_safeMint} whenever possible
825      *
826      * Requirements:
827      *
828      * - `tokenId` must not exist.
829      * - `to` cannot be the zero address.
830      *
831      * Emits a {Transfer} event.
832      */
833     function _mint(address to, uint256 tokenId) internal virtual {
834         require(to != address(0), "ERC721: mint to the zero address");
835         require(!_exists(tokenId), "ERC721: token already minted");
836 
837         _beforeTokenTransfer(address(0), to, tokenId);
838 
839         _balances[to] += 1;
840         _owners[tokenId] = to;
841 
842         emit Transfer(address(0), to, tokenId);
843     }
844 
845     /**
846      * @dev Destroys `tokenId`.
847      * The approval is cleared when the token is burned.
848      *
849      * Requirements:
850      *
851      * - `tokenId` must exist.
852      *
853      * Emits a {Transfer} event.
854      */
855     function _burn(uint256 tokenId) internal virtual {
856         address owner = ERC721.ownerOf(tokenId);
857 
858         _beforeTokenTransfer(owner, address(0), tokenId);
859 
860         // Clear approvals
861         _approve(address(0), tokenId);
862 
863         _balances[owner] -= 1;
864         delete _owners[tokenId];
865 
866         emit Transfer(owner, address(0), tokenId);
867     }
868 
869     /**
870      * @dev Transfers `tokenId` from `from` to `to`.
871      *  As opposed to {transferFrom}, this imposes no restrictions on msg.sender.
872      *
873      * Requirements:
874      *
875      * - `to` cannot be the zero address.
876      * - `tokenId` token must be owned by `from`.
877      *
878      * Emits a {Transfer} event.
879      */
880     function _transfer(
881         address from,
882         address to,
883         uint256 tokenId
884     ) internal virtual {
885         require(ERC721.ownerOf(tokenId) == from, "ERC721: transfer of token that is not own");
886         require(to != address(0), "ERC721: transfer to the zero address");
887 
888         _beforeTokenTransfer(from, to, tokenId);
889 
890         // Clear approvals from the previous owner
891         _approve(address(0), tokenId);
892 
893         _balances[from] -= 1;
894         _balances[to] += 1;
895         _owners[tokenId] = to;
896 
897         emit Transfer(from, to, tokenId);
898     }
899 
900     /**
901      * @dev Approve `to` to operate on `tokenId`
902      *
903      * Emits a {Approval} event.
904      */
905     function _approve(address to, uint256 tokenId) internal virtual {
906         _tokenApprovals[tokenId] = to;
907         emit Approval(ERC721.ownerOf(tokenId), to, tokenId);
908     }
909 
910     /**
911      * @dev Internal function to invoke {IERC721Receiver-onERC721Received} on a target address.
912      * The call is not executed if the target address is not a contract.
913      *
914      * @param from address representing the previous owner of the given token ID
915      * @param to target address that will receive the tokens
916      * @param tokenId uint256 ID of the token to be transferred
917      * @param _data bytes optional data to send along with the call
918      * @return bool whether the call correctly returned the expected magic value
919      */
920     function _checkOnERC721Received(
921         address from,
922         address to,
923         uint256 tokenId,
924         bytes memory _data
925     ) private returns (bool) {
926         if (to.isContract()) {
927             try IERC721Receiver(to).onERC721Received(_msgSender(), from, tokenId, _data) returns (bytes4 retval) {
928                 return retval == IERC721Receiver(to).onERC721Received.selector;
929             } catch (bytes memory reason) {
930                 if (reason.length == 0) {
931                     revert("ERC721: transfer to non ERC721Receiver implementer");
932                 } else {
933                     assembly {
934                         revert(add(32, reason), mload(reason))
935                     }
936                 }
937             }
938         } else {
939             return true;
940         }
941     }
942 
943     /**
944      * @dev Hook that is called before any token transfer. This includes minting
945      * and burning.
946      *
947      * Calling conditions:
948      *
949      * - When `from` and `to` are both non-zero, ``from``'s `tokenId` will be
950      * transferred to `to`.
951      * - When `from` is zero, `tokenId` will be minted for `to`.
952      * - When `to` is zero, ``from``'s `tokenId` will be burned.
953      * - `from` and `to` are never both zero.
954      *
955      * To learn more about hooks, head to xref:ROOT:extending-contracts.adoc#using-hooks[Using Hooks].
956      */
957     function _beforeTokenTransfer(
958         address from,
959         address to,
960         uint256 tokenId
961     ) internal virtual {}
962 }
963 
964 // File: @openzeppelin\contracts\token\ERC721\extensions\IERC721Enumerable.sol
965 
966 pragma solidity ^0.8.0;
967 
968 
969 /**
970  * @title ERC-721 Non-Fungible Token Standard, optional enumeration extension
971  * @dev See https://eips.ethereum.org/EIPS/eip-721
972  */
973 interface IERC721Enumerable is IERC721 {
974     /**
975      * @dev Returns the total amount of tokens stored by the contract.
976      */
977     function totalSupply() external view returns (uint256);
978 
979     /**
980      * @dev Returns a token ID owned by `owner` at a given `index` of its token list.
981      * Use along with {balanceOf} to enumerate all of ``owner``'s tokens.
982      */
983     function tokenOfOwnerByIndex(address owner, uint256 index) external view returns (uint256 tokenId);
984 
985     /**
986      * @dev Returns a token ID at a given `index` of all the tokens stored by the contract.
987      * Use along with {totalSupply} to enumerate all tokens.
988      */
989     function tokenByIndex(uint256 index) external view returns (uint256);
990 }
991 
992 // File: @openzeppelin\contracts\token\ERC721\extensions\ERC721Enumerable.sol
993 
994 pragma solidity ^0.8.0;
995 
996 
997 
998 /**
999  * @dev This implements an optional extension of {ERC721} defined in the EIP that adds
1000  * enumerability of all the token ids in the contract as well as all token ids owned by each
1001  * account.
1002  */
1003 abstract contract ERC721Enumerable is ERC721, IERC721Enumerable {
1004     // Mapping from owner to list of owned token IDs
1005     mapping(address => mapping(uint256 => uint256)) private _ownedTokens;
1006 
1007     // Mapping from token ID to index of the owner tokens list
1008     mapping(uint256 => uint256) private _ownedTokensIndex;
1009 
1010     // Array with all token ids, used for enumeration
1011     uint256[] private _allTokens;
1012 
1013     // Mapping from token id to position in the allTokens array
1014     mapping(uint256 => uint256) private _allTokensIndex;
1015 
1016     /**
1017      * @dev See {IERC165-supportsInterface}.
1018      */
1019     function supportsInterface(bytes4 interfaceId) public view virtual override(IERC165, ERC721) returns (bool) {
1020         return interfaceId == type(IERC721Enumerable).interfaceId || super.supportsInterface(interfaceId);
1021     }
1022 
1023     /**
1024      * @dev See {IERC721Enumerable-tokenOfOwnerByIndex}.
1025      */
1026     function tokenOfOwnerByIndex(address owner, uint256 index) public view virtual override returns (uint256) {
1027         require(index < ERC721.balanceOf(owner), "ERC721Enumerable: owner index out of bounds");
1028         return _ownedTokens[owner][index];
1029     }
1030 
1031     /**
1032      * @dev See {IERC721Enumerable-totalSupply}.
1033      */
1034     function totalSupply() public view virtual override returns (uint256) {
1035         return _allTokens.length;
1036     }
1037 
1038     /**
1039      * @dev See {IERC721Enumerable-tokenByIndex}.
1040      */
1041     function tokenByIndex(uint256 index) public view virtual override returns (uint256) {
1042         require(index < ERC721Enumerable.totalSupply(), "ERC721Enumerable: global index out of bounds");
1043         return _allTokens[index];
1044     }
1045 
1046     /**
1047      * @dev Hook that is called before any token transfer. This includes minting
1048      * and burning.
1049      *
1050      * Calling conditions:
1051      *
1052      * - When `from` and `to` are both non-zero, ``from``'s `tokenId` will be
1053      * transferred to `to`.
1054      * - When `from` is zero, `tokenId` will be minted for `to`.
1055      * - When `to` is zero, ``from``'s `tokenId` will be burned.
1056      * - `from` cannot be the zero address.
1057      * - `to` cannot be the zero address.
1058      *
1059      * To learn more about hooks, head to xref:ROOT:extending-contracts.adoc#using-hooks[Using Hooks].
1060      */
1061     function _beforeTokenTransfer(
1062         address from,
1063         address to,
1064         uint256 tokenId
1065     ) internal virtual override {
1066         super._beforeTokenTransfer(from, to, tokenId);
1067 
1068         if (from == address(0)) {
1069             _addTokenToAllTokensEnumeration(tokenId);
1070         } else if (from != to) {
1071             _removeTokenFromOwnerEnumeration(from, tokenId);
1072         }
1073         if (to == address(0)) {
1074             _removeTokenFromAllTokensEnumeration(tokenId);
1075         } else if (to != from) {
1076             _addTokenToOwnerEnumeration(to, tokenId);
1077         }
1078     }
1079 
1080     /**
1081      * @dev Private function to add a token to this extension's ownership-tracking data structures.
1082      * @param to address representing the new owner of the given token ID
1083      * @param tokenId uint256 ID of the token to be added to the tokens list of the given address
1084      */
1085     function _addTokenToOwnerEnumeration(address to, uint256 tokenId) private {
1086         uint256 length = ERC721.balanceOf(to);
1087         _ownedTokens[to][length] = tokenId;
1088         _ownedTokensIndex[tokenId] = length;
1089     }
1090 
1091     /**
1092      * @dev Private function to add a token to this extension's token tracking data structures.
1093      * @param tokenId uint256 ID of the token to be added to the tokens list
1094      */
1095     function _addTokenToAllTokensEnumeration(uint256 tokenId) private {
1096         _allTokensIndex[tokenId] = _allTokens.length;
1097         _allTokens.push(tokenId);
1098     }
1099 
1100     /**
1101      * @dev Private function to remove a token from this extension's ownership-tracking data structures. Note that
1102      * while the token is not assigned a new owner, the `_ownedTokensIndex` mapping is _not_ updated: this allows for
1103      * gas optimizations e.g. when performing a transfer operation (avoiding double writes).
1104      * This has O(1) time complexity, but alters the order of the _ownedTokens array.
1105      * @param from address representing the previous owner of the given token ID
1106      * @param tokenId uint256 ID of the token to be removed from the tokens list of the given address
1107      */
1108     function _removeTokenFromOwnerEnumeration(address from, uint256 tokenId) private {
1109         // To prevent a gap in from's tokens array, we store the last token in the index of the token to delete, and
1110         // then delete the last slot (swap and pop).
1111 
1112         uint256 lastTokenIndex = ERC721.balanceOf(from) - 1;
1113         uint256 tokenIndex = _ownedTokensIndex[tokenId];
1114 
1115         // When the token to delete is the last token, the swap operation is unnecessary
1116         if (tokenIndex != lastTokenIndex) {
1117             uint256 lastTokenId = _ownedTokens[from][lastTokenIndex];
1118 
1119             _ownedTokens[from][tokenIndex] = lastTokenId; // Move the last token to the slot of the to-delete token
1120             _ownedTokensIndex[lastTokenId] = tokenIndex; // Update the moved token's index
1121         }
1122 
1123         // This also deletes the contents at the last position of the array
1124         delete _ownedTokensIndex[tokenId];
1125         delete _ownedTokens[from][lastTokenIndex];
1126     }
1127 
1128     /**
1129      * @dev Private function to remove a token from this extension's token tracking data structures.
1130      * This has O(1) time complexity, but alters the order of the _allTokens array.
1131      * @param tokenId uint256 ID of the token to be removed from the tokens list
1132      */
1133     function _removeTokenFromAllTokensEnumeration(uint256 tokenId) private {
1134         // To prevent a gap in the tokens array, we store the last token in the index of the token to delete, and
1135         // then delete the last slot (swap and pop).
1136 
1137         uint256 lastTokenIndex = _allTokens.length - 1;
1138         uint256 tokenIndex = _allTokensIndex[tokenId];
1139 
1140         // When the token to delete is the last token, the swap operation is unnecessary. However, since this occurs so
1141         // rarely (when the last minted token is burnt) that we still do the swap here to avoid the gas cost of adding
1142         // an 'if' statement (like in _removeTokenFromOwnerEnumeration)
1143         uint256 lastTokenId = _allTokens[lastTokenIndex];
1144 
1145         _allTokens[tokenIndex] = lastTokenId; // Move the last token to the slot of the to-delete token
1146         _allTokensIndex[lastTokenId] = tokenIndex; // Update the moved token's index
1147 
1148         // This also deletes the contents at the last position of the array
1149         delete _allTokensIndex[tokenId];
1150         _allTokens.pop();
1151     }
1152 }
1153 
1154 // File: Soda.sol
1155 
1156 pragma solidity ^0.8.0;
1157 
1158 abstract contract Ownable is Context {
1159     address private _owner;
1160 
1161     event OwnershipTransferred(address indexed previousOwner, address indexed newOwner);
1162 
1163     /**
1164      * @dev Initializes the contract setting the deployer as the initial owner.
1165      */
1166     constructor() {
1167         _setOwner(_msgSender());
1168     }
1169 
1170     /**
1171      * @dev Returns the address of the current owner.
1172      */
1173     function owner() public view virtual returns (address) {
1174         return _owner;
1175     }
1176 
1177     /**
1178      * @dev Throws if called by any account other than the owner.
1179      */
1180     modifier onlyOwner() {
1181         require(owner() == _msgSender(), "Ownable: caller is not the owner");
1182         _;
1183     }
1184 
1185     function _setOwner(address newOwner) private {
1186         address oldOwner = _owner;
1187         _owner = newOwner;
1188         emit OwnershipTransferred(oldOwner, newOwner);
1189     }
1190 }
1191 
1192 contract Soda is ERC721Enumerable, Ownable {
1193   
1194   string public constant PROVENANCE_HASH = "db1a85b482e5f69ab4457a01a025fe2ba65a02ee73d552e59b6ba390b6d9daf1";
1195 
1196   uint256 public constant MAX_SUPPLY = 9669;
1197   uint256 public constant RESERVED = 35;
1198   uint256 public constant FANBOI = 22;
1199 
1200   uint256 public price = 66700000000000000;
1201   bool public saleIsActive = false;
1202   bool public uriIsFrozen = false;
1203 
1204   bool private _canFreezeUri = false;
1205   string private _baseTokenURI;
1206 
1207   mapping (uint => uint) public distributionIndex;
1208 
1209   constructor() ERC721("SODA", "SODA") {
1210     _setBaseURI("https://soda.blob.core.windows.net/metadata/");
1211     
1212     for (uint i = 0; i < RESERVED; i++) {
1213       _mintSoda(msg.sender, i >= FANBOI);
1214     }
1215   }
1216 
1217   function withdraw() public onlyOwner {
1218     uint256 balance = address(this).balance;
1219     payable(msg.sender).transfer(balance);
1220   }
1221 
1222   // OOGA change base uri to ipfs after all sodas get minted
1223   function setBaseURI(string memory baseURI) public onlyOwner {
1224     if(!uriIsFrozen){
1225       _canFreezeUri = true;
1226       _setBaseURI(baseURI);
1227     }
1228   }
1229 
1230   function freezeBaseURI() public onlyOwner {
1231     if(_canFreezeUri) {
1232       uriIsFrozen = true;
1233     }
1234   }
1235 
1236   function mint() public payable {
1237     require(saleIsActive, "Sale is not active.");
1238     require(totalSupply() < MAX_SUPPLY, "Exceeds the maximum supply.");
1239     require(price <= msg.value, "Not enough Ether.");
1240 
1241     _mintSoda(msg.sender, true);
1242   }
1243 
1244   function mintSixPack() public payable {
1245     require(saleIsActive, "Sale is not active.");
1246     require(totalSupply() + 6 <= MAX_SUPPLY, "Exceeds the maximum supply.");
1247     require(price * 6 <= msg.value, "Not enough Ether.");
1248 
1249     for (uint i = 0; i < 6; i++) {
1250       _mintSoda(msg.sender, true);
1251     }
1252   }
1253 
1254   function walletOfOwner(address _owner) public view returns(uint256[] memory) {
1255     uint256 tokenCount = balanceOf(_owner);
1256 
1257     uint256[] memory tokensId = new uint256[](tokenCount);
1258     for(uint256 i; i < tokenCount; i++){
1259       tokensId[i] = tokenOfOwnerByIndex(_owner, i);
1260     }
1261     return tokensId;
1262   }
1263 
1264   function giveaway(address nftOwner) public onlyOwner() {
1265     require(totalSupply() < MAX_SUPPLY, "Exceeds max. supply.");
1266 
1267     _mintSoda(nftOwner, true);
1268   }
1269 
1270   function toggleSale() public onlyOwner {
1271     saleIsActive = !saleIsActive;
1272   }
1273 
1274   // OOGA save you if ETH go wrong, function adjust price, upkeep alpha
1275   function setPrice(uint256 newPrice) public onlyOwner() {
1276     price = newPrice;
1277   }
1278 
1279   function _setBaseURI(string memory uri) private {
1280     _baseTokenURI = uri;
1281   }
1282 
1283   // OOGA distributes SODAs randomly by assigning a 'distribution index' to each token
1284   // The distribution index denotes an index of element from a set of remaining SODAs at the time of minting
1285   // The distribution index is randomly selected during minting, and conforms to a range [0, number of remaining SODAs - 1]
1286   // example:
1287   // there are 4 SODAs with ids: 0, 1, 2, 3
1288   // the first token (0) receives distribution index 2, this results in assignment of: token_0 <- soda_2
1289   // remaining sodas are: 0, 1, 3
1290   // second token (1) receives distribution index 0, this results in assignment of: token_1 <- soda_0
1291   // remaining sodas are: 1, 3
1292   // third token (2) receives distribution index 1, this results in assignment of: token_2 <- soda_3
1293   // remaining sodas are: 1
1294   // fourth token (3) receives distribution index 0, this results in assignment of : token_3 <- soda_1
1295   function _mintSoda(address nftOwner, bool isRandom) private {
1296     uint index = totalSupply();
1297     if (isRandom) {
1298       distributionIndex[index] = _getDistributionIndex(index);
1299     }
1300     else {
1301       distributionIndex[index] = 0;
1302     }
1303     _safeMint(nftOwner, index);
1304   }
1305 
1306   function _getDistributionIndex(uint index) private view returns (uint) {
1307     uint magicNumber = uint(keccak256(abi.encodePacked(index, block.timestamp)));
1308     magicNumber = magicNumber % (MAX_SUPPLY - index);
1309     return magicNumber;
1310   }
1311 
1312   function _baseURI() internal view virtual override returns (string memory) {
1313     return _baseTokenURI;
1314   }
1315 }