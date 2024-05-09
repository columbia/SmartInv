1 // File: @openzeppelin/contracts/utils/introspection/IERC165.sol
2 
3 // SPDX-License-Identifier: MIT
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
28 // File: @openzeppelin/contracts/token/ERC721/IERC721.sol
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
170 // File: @openzeppelin/contracts/token/ERC721/IERC721Receiver.sol
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
197 // File: @openzeppelin/contracts/token/ERC721/extensions/IERC721Metadata.sol
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
223 // File: @openzeppelin/contracts/utils/Address.sol
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
354         return verifyCallResult(success, returndata, errorMessage);
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
381         return verifyCallResult(success, returndata, errorMessage);
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
408         return verifyCallResult(success, returndata, errorMessage);
409     }
410 
411     /**
412      * @dev Tool to verifies that a low level call was successful, and revert if it wasn't, either by bubbling the
413      * revert reason using the provided one.
414      *
415      * _Available since v4.3._
416      */
417     function verifyCallResult(
418         bool success,
419         bytes memory returndata,
420         string memory errorMessage
421     ) internal pure returns (bytes memory) {
422         if (success) {
423             return returndata;
424         } else {
425             // Look for revert reason and bubble it up if present
426             if (returndata.length > 0) {
427                 // The easiest way to bubble the revert reason is using memory via assembly
428 
429                 assembly {
430                     let returndata_size := mload(returndata)
431                     revert(add(32, returndata), returndata_size)
432                 }
433             } else {
434                 revert(errorMessage);
435             }
436         }
437     }
438 }
439 
440 // File: @openzeppelin/contracts/utils/Context.sol
441 
442 pragma solidity ^0.8.0;
443 
444 /**
445  * @dev Provides information about the current execution context, including the
446  * sender of the transaction and its data. While these are generally available
447  * via msg.sender and msg.data, they should not be accessed in such a direct
448  * manner, since when dealing with meta-transactions the account sending and
449  * paying for execution may not be the actual sender (as far as an application
450  * is concerned).
451  *
452  * This contract is only required for intermediate, library-like contracts.
453  */
454 abstract contract Context {
455     function _msgSender() internal view virtual returns (address) {
456         return msg.sender;
457     }
458 
459     function _msgData() internal view virtual returns (bytes calldata) {
460         return msg.data;
461     }
462 }
463 
464 // File: @openzeppelin/contracts/utils/Strings.sol
465 
466 pragma solidity ^0.8.0;
467 
468 /**
469  * @dev String operations.
470  */
471 library Strings {
472     bytes16 private constant _HEX_SYMBOLS = "0123456789abcdef";
473 
474     /**
475      * @dev Converts a `uint256` to its ASCII `string` decimal representation.
476      */
477     function toString(uint256 value) internal pure returns (string memory) {
478         // Inspired by OraclizeAPI's implementation - MIT licence
479         // https://github.com/oraclize/ethereum-api/blob/b42146b063c7d6ee1358846c198246239e9360e8/oraclizeAPI_0.4.25.sol
480 
481         if (value == 0) {
482             return "0";
483         }
484         uint256 temp = value;
485         uint256 digits;
486         while (temp != 0) {
487             digits++;
488             temp /= 10;
489         }
490         bytes memory buffer = new bytes(digits);
491         while (value != 0) {
492             digits -= 1;
493             buffer[digits] = bytes1(uint8(48 + uint256(value % 10)));
494             value /= 10;
495         }
496         return string(buffer);
497     }
498 
499     /**
500      * @dev Converts a `uint256` to its ASCII `string` hexadecimal representation.
501      */
502     function toHexString(uint256 value) internal pure returns (string memory) {
503         if (value == 0) {
504             return "0x00";
505         }
506         uint256 temp = value;
507         uint256 length = 0;
508         while (temp != 0) {
509             length++;
510             temp >>= 8;
511         }
512         return toHexString(value, length);
513     }
514 
515     /**
516      * @dev Converts a `uint256` to its ASCII `string` hexadecimal representation with fixed length.
517      */
518     function toHexString(uint256 value, uint256 length) internal pure returns (string memory) {
519         bytes memory buffer = new bytes(2 * length + 2);
520         buffer[0] = "0";
521         buffer[1] = "x";
522         for (uint256 i = 2 * length + 1; i > 1; --i) {
523             buffer[i] = _HEX_SYMBOLS[value & 0xf];
524             value >>= 4;
525         }
526         require(value == 0, "Strings: hex length insufficient");
527         return string(buffer);
528     }
529 }
530 
531 // File: @openzeppelin/contracts/utils/introspection/ERC165.sol
532 
533 pragma solidity ^0.8.0;
534 
535 
536 /**
537  * @dev Implementation of the {IERC165} interface.
538  *
539  * Contracts that want to implement ERC165 should inherit from this contract and override {supportsInterface} to check
540  * for the additional interface id that will be supported. For example:
541  *
542  * ```solidity
543  * function supportsInterface(bytes4 interfaceId) public view virtual override returns (bool) {
544  *     return interfaceId == type(MyInterface).interfaceId || super.supportsInterface(interfaceId);
545  * }
546  * ```
547  *
548  * Alternatively, {ERC165Storage} provides an easier to use but more expensive implementation.
549  */
550 abstract contract ERC165 is IERC165 {
551     /**
552      * @dev See {IERC165-supportsInterface}.
553      */
554     function supportsInterface(bytes4 interfaceId) public view virtual override returns (bool) {
555         return interfaceId == type(IERC165).interfaceId;
556     }
557 }
558 
559 // File: @openzeppelin/contracts/token/ERC721/ERC721.sol
560 
561 pragma solidity ^0.8.0;
562 
563 
564 
565 
566 
567 
568 
569 
570 /**
571  * @dev Implementation of https://eips.ethereum.org/EIPS/eip-721[ERC721] Non-Fungible Token Standard, including
572  * the Metadata extension, but not including the Enumerable extension, which is available separately as
573  * {ERC721Enumerable}.
574  */
575 contract ERC721 is Context, ERC165, IERC721, IERC721Metadata {
576     using Address for address;
577     using Strings for uint256;
578 
579     // Token name
580     string private _name;
581 
582     // Token symbol
583     string private _symbol;
584 
585     // Mapping from token ID to owner address
586     mapping(uint256 => address) private _owners;
587 
588     // Mapping owner address to token count
589     mapping(address => uint256) private _balances;
590 
591     // Mapping from token ID to approved address
592     mapping(uint256 => address) private _tokenApprovals;
593 
594     // Mapping from owner to operator approvals
595     mapping(address => mapping(address => bool)) private _operatorApprovals;
596 
597     /**
598      * @dev Initializes the contract by setting a `name` and a `symbol` to the token collection.
599      */
600     constructor(string memory name_, string memory symbol_) {
601         _name = name_;
602         _symbol = symbol_;
603     }
604 
605     /**
606      * @dev See {IERC165-supportsInterface}.
607      */
608     function supportsInterface(bytes4 interfaceId) public view virtual override(ERC165, IERC165) returns (bool) {
609         return
610             interfaceId == type(IERC721).interfaceId ||
611             interfaceId == type(IERC721Metadata).interfaceId ||
612             super.supportsInterface(interfaceId);
613     }
614 
615     /**
616      * @dev See {IERC721-balanceOf}.
617      */
618     function balanceOf(address owner) public view virtual override returns (uint256) {
619         require(owner != address(0), "ERC721: balance query for the zero address");
620         return _balances[owner];
621     }
622 
623     /**
624      * @dev See {IERC721-ownerOf}.
625      */
626     function ownerOf(uint256 tokenId) public view virtual override returns (address) {
627         address owner = _owners[tokenId];
628         require(owner != address(0), "ERC721: owner query for nonexistent token");
629         return owner;
630     }
631 
632     /**
633      * @dev See {IERC721Metadata-name}.
634      */
635     function name() public view virtual override returns (string memory) {
636         return _name;
637     }
638 
639     /**
640      * @dev See {IERC721Metadata-symbol}.
641      */
642     function symbol() public view virtual override returns (string memory) {
643         return _symbol;
644     }
645 
646     /**
647      * @dev See {IERC721Metadata-tokenURI}.
648      */
649     function tokenURI(uint256 tokenId) public view virtual override returns (string memory) {
650         require(_exists(tokenId), "ERC721Metadata: URI query for nonexistent token");
651 
652         string memory baseURI = _baseURI();
653         return bytes(baseURI).length > 0 ? string(abi.encodePacked(baseURI, tokenId.toString())) : "";
654     }
655 
656     /**
657      * @dev Base URI for computing {tokenURI}. If set, the resulting URI for each
658      * token will be the concatenation of the `baseURI` and the `tokenId`. Empty
659      * by default, can be overriden in child contracts.
660      */
661     function _baseURI() internal view virtual returns (string memory) {
662         return "";
663     }
664 
665     /**
666      * @dev See {IERC721-approve}.
667      */
668     function approve(address to, uint256 tokenId) public virtual override {
669         address owner = ERC721.ownerOf(tokenId);
670         require(to != owner, "ERC721: approval to current owner");
671 
672         require(
673             _msgSender() == owner || isApprovedForAll(owner, _msgSender()),
674             "ERC721: approve caller is not owner nor approved for all"
675         );
676 
677         _approve(to, tokenId);
678     }
679 
680     /**
681      * @dev See {IERC721-getApproved}.
682      */
683     function getApproved(uint256 tokenId) public view virtual override returns (address) {
684         require(_exists(tokenId), "ERC721: approved query for nonexistent token");
685 
686         return _tokenApprovals[tokenId];
687     }
688 
689     /**
690      * @dev See {IERC721-setApprovalForAll}.
691      */
692     function setApprovalForAll(address operator, bool approved) public virtual override {
693         require(operator != _msgSender(), "ERC721: approve to caller");
694 
695         _operatorApprovals[_msgSender()][operator] = approved;
696         emit ApprovalForAll(_msgSender(), operator, approved);
697     }
698 
699     /**
700      * @dev See {IERC721-isApprovedForAll}.
701      */
702     function isApprovedForAll(address owner, address operator) public view virtual override returns (bool) {
703         return _operatorApprovals[owner][operator];
704     }
705 
706     /**
707      * @dev See {IERC721-transferFrom}.
708      */
709     function transferFrom(
710         address from,
711         address to,
712         uint256 tokenId
713     ) public virtual override {
714         //solhint-disable-next-line max-line-length
715         require(_isApprovedOrOwner(_msgSender(), tokenId), "ERC721: transfer caller is not owner nor approved");
716 
717         _transfer(from, to, tokenId);
718     }
719 
720     /**
721      * @dev See {IERC721-safeTransferFrom}.
722      */
723     function safeTransferFrom(
724         address from,
725         address to,
726         uint256 tokenId
727     ) public virtual override {
728         safeTransferFrom(from, to, tokenId, "");
729     }
730 
731     /**
732      * @dev See {IERC721-safeTransferFrom}.
733      */
734     function safeTransferFrom(
735         address from,
736         address to,
737         uint256 tokenId,
738         bytes memory _data
739     ) public virtual override {
740         require(_isApprovedOrOwner(_msgSender(), tokenId), "ERC721: transfer caller is not owner nor approved");
741         _safeTransfer(from, to, tokenId, _data);
742     }
743 
744     /**
745      * @dev Safely transfers `tokenId` token from `from` to `to`, checking first that contract recipients
746      * are aware of the ERC721 protocol to prevent tokens from being forever locked.
747      *
748      * `_data` is additional data, it has no specified format and it is sent in call to `to`.
749      *
750      * This internal function is equivalent to {safeTransferFrom}, and can be used to e.g.
751      * implement alternative mechanisms to perform token transfer, such as signature-based.
752      *
753      * Requirements:
754      *
755      * - `from` cannot be the zero address.
756      * - `to` cannot be the zero address.
757      * - `tokenId` token must exist and be owned by `from`.
758      * - If `to` refers to a smart contract, it must implement {IERC721Receiver-onERC721Received}, which is called upon a safe transfer.
759      *
760      * Emits a {Transfer} event.
761      */
762     function _safeTransfer(
763         address from,
764         address to,
765         uint256 tokenId,
766         bytes memory _data
767     ) internal virtual {
768         _transfer(from, to, tokenId);
769         require(_checkOnERC721Received(from, to, tokenId, _data), "ERC721: transfer to non ERC721Receiver implementer");
770     }
771 
772     /**
773      * @dev Returns whether `tokenId` exists.
774      *
775      * Tokens can be managed by their owner or approved accounts via {approve} or {setApprovalForAll}.
776      *
777      * Tokens start existing when they are minted (`_mint`),
778      * and stop existing when they are burned (`_burn`).
779      */
780     function _exists(uint256 tokenId) internal view virtual returns (bool) {
781         return _owners[tokenId] != address(0);
782     }
783 
784     /**
785      * @dev Returns whether `spender` is allowed to manage `tokenId`.
786      *
787      * Requirements:
788      *
789      * - `tokenId` must exist.
790      */
791     function _isApprovedOrOwner(address spender, uint256 tokenId) internal view virtual returns (bool) {
792         require(_exists(tokenId), "ERC721: operator query for nonexistent token");
793         address owner = ERC721.ownerOf(tokenId);
794         return (spender == owner || getApproved(tokenId) == spender || isApprovedForAll(owner, spender));
795     }
796 
797     /**
798      * @dev Safely mints `tokenId` and transfers it to `to`.
799      *
800      * Requirements:
801      *
802      * - `tokenId` must not exist.
803      * - If `to` refers to a smart contract, it must implement {IERC721Receiver-onERC721Received}, which is called upon a safe transfer.
804      *
805      * Emits a {Transfer} event.
806      */
807     function _safeMint(address to, uint256 tokenId) internal virtual {
808         _safeMint(to, tokenId, "");
809     }
810 
811     /**
812      * @dev Same as {xref-ERC721-_safeMint-address-uint256-}[`_safeMint`], with an additional `data` parameter which is
813      * forwarded in {IERC721Receiver-onERC721Received} to contract recipients.
814      */
815     function _safeMint(
816         address to,
817         uint256 tokenId,
818         bytes memory _data
819     ) internal virtual {
820         _mint(to, tokenId);
821         require(
822             _checkOnERC721Received(address(0), to, tokenId, _data),
823             "ERC721: transfer to non ERC721Receiver implementer"
824         );
825     }
826 
827     /**
828      * @dev Mints `tokenId` and transfers it to `to`.
829      *
830      * WARNING: Usage of this method is discouraged, use {_safeMint} whenever possible
831      *
832      * Requirements:
833      *
834      * - `tokenId` must not exist.
835      * - `to` cannot be the zero address.
836      *
837      * Emits a {Transfer} event.
838      */
839     function _mint(address to, uint256 tokenId) internal virtual {
840         require(to != address(0), "ERC721: mint to the zero address");
841         require(!_exists(tokenId), "ERC721: token already minted");
842 
843         _beforeTokenTransfer(address(0), to, tokenId);
844 
845         _balances[to] += 1;
846         _owners[tokenId] = to;
847 
848         emit Transfer(address(0), to, tokenId);
849     }
850 
851     /**
852      * @dev Destroys `tokenId`.
853      * The approval is cleared when the token is burned.
854      *
855      * Requirements:
856      *
857      * - `tokenId` must exist.
858      *
859      * Emits a {Transfer} event.
860      */
861     function _burn(uint256 tokenId) internal virtual {
862         address owner = ERC721.ownerOf(tokenId);
863 
864         _beforeTokenTransfer(owner, address(0), tokenId);
865 
866         // Clear approvals
867         _approve(address(0), tokenId);
868 
869         _balances[owner] -= 1;
870         delete _owners[tokenId];
871 
872         emit Transfer(owner, address(0), tokenId);
873     }
874 
875     /**
876      * @dev Transfers `tokenId` from `from` to `to`.
877      *  As opposed to {transferFrom}, this imposes no restrictions on msg.sender.
878      *
879      * Requirements:
880      *
881      * - `to` cannot be the zero address.
882      * - `tokenId` token must be owned by `from`.
883      *
884      * Emits a {Transfer} event.
885      */
886     function _transfer(
887         address from,
888         address to,
889         uint256 tokenId
890     ) internal virtual {
891         require(ERC721.ownerOf(tokenId) == from, "ERC721: transfer of token that is not own");
892         require(to != address(0), "ERC721: transfer to the zero address");
893 
894         _beforeTokenTransfer(from, to, tokenId);
895 
896         // Clear approvals from the previous owner
897         _approve(address(0), tokenId);
898 
899         _balances[from] -= 1;
900         _balances[to] += 1;
901         _owners[tokenId] = to;
902 
903         emit Transfer(from, to, tokenId);
904     }
905 
906     /**
907      * @dev Approve `to` to operate on `tokenId`
908      *
909      * Emits a {Approval} event.
910      */
911     function _approve(address to, uint256 tokenId) internal virtual {
912         _tokenApprovals[tokenId] = to;
913         emit Approval(ERC721.ownerOf(tokenId), to, tokenId);
914     }
915 
916     /**
917      * @dev Internal function to invoke {IERC721Receiver-onERC721Received} on a target address.
918      * The call is not executed if the target address is not a contract.
919      *
920      * @param from address representing the previous owner of the given token ID
921      * @param to target address that will receive the tokens
922      * @param tokenId uint256 ID of the token to be transferred
923      * @param _data bytes optional data to send along with the call
924      * @return bool whether the call correctly returned the expected magic value
925      */
926     function _checkOnERC721Received(
927         address from,
928         address to,
929         uint256 tokenId,
930         bytes memory _data
931     ) private returns (bool) {
932         if (to.isContract()) {
933             try IERC721Receiver(to).onERC721Received(_msgSender(), from, tokenId, _data) returns (bytes4 retval) {
934                 return retval == IERC721Receiver.onERC721Received.selector;
935             } catch (bytes memory reason) {
936                 if (reason.length == 0) {
937                     revert("ERC721: transfer to non ERC721Receiver implementer");
938                 } else {
939                     assembly {
940                         revert(add(32, reason), mload(reason))
941                     }
942                 }
943             }
944         } else {
945             return true;
946         }
947     }
948 
949     /**
950      * @dev Hook that is called before any token transfer. This includes minting
951      * and burning.
952      *
953      * Calling conditions:
954      *
955      * - When `from` and `to` are both non-zero, ``from``'s `tokenId` will be
956      * transferred to `to`.
957      * - When `from` is zero, `tokenId` will be minted for `to`.
958      * - When `to` is zero, ``from``'s `tokenId` will be burned.
959      * - `from` and `to` are never both zero.
960      *
961      * To learn more about hooks, head to xref:ROOT:extending-contracts.adoc#using-hooks[Using Hooks].
962      */
963     function _beforeTokenTransfer(
964         address from,
965         address to,
966         uint256 tokenId
967     ) internal virtual {}
968 }
969 
970 // File: @openzeppelin/contracts/token/ERC721/extensions/IERC721Enumerable.sol
971 
972 pragma solidity ^0.8.0;
973 
974 
975 /**
976  * @title ERC-721 Non-Fungible Token Standard, optional enumeration extension
977  * @dev See https://eips.ethereum.org/EIPS/eip-721
978  */
979 interface IERC721Enumerable is IERC721 {
980     /**
981      * @dev Returns the total amount of tokens stored by the contract.
982      */
983     function totalSupply() external view returns (uint256);
984 
985     /**
986      * @dev Returns a token ID owned by `owner` at a given `index` of its token list.
987      * Use along with {balanceOf} to enumerate all of ``owner``'s tokens.
988      */
989     function tokenOfOwnerByIndex(address owner, uint256 index) external view returns (uint256 tokenId);
990 
991     /**
992      * @dev Returns a token ID at a given `index` of all the tokens stored by the contract.
993      * Use along with {totalSupply} to enumerate all tokens.
994      */
995     function tokenByIndex(uint256 index) external view returns (uint256);
996 }
997 
998 // File: @openzeppelin/contracts/token/ERC721/extensions/ERC721Enumerable.sol
999 
1000 pragma solidity ^0.8.0;
1001 
1002 
1003 
1004 /**
1005  * @dev This implements an optional extension of {ERC721} defined in the EIP that adds
1006  * enumerability of all the token ids in the contract as well as all token ids owned by each
1007  * account.
1008  */
1009 abstract contract ERC721Enumerable is ERC721, IERC721Enumerable {
1010     // Mapping from owner to list of owned token IDs
1011     mapping(address => mapping(uint256 => uint256)) private _ownedTokens;
1012 
1013     // Mapping from token ID to index of the owner tokens list
1014     mapping(uint256 => uint256) private _ownedTokensIndex;
1015 
1016     // Array with all token ids, used for enumeration
1017     uint256[] private _allTokens;
1018 
1019     // Mapping from token id to position in the allTokens array
1020     mapping(uint256 => uint256) private _allTokensIndex;
1021 
1022     /**
1023      * @dev See {IERC165-supportsInterface}.
1024      */
1025     function supportsInterface(bytes4 interfaceId) public view virtual override(IERC165, ERC721) returns (bool) {
1026         return interfaceId == type(IERC721Enumerable).interfaceId || super.supportsInterface(interfaceId);
1027     }
1028 
1029     /**
1030      * @dev See {IERC721Enumerable-tokenOfOwnerByIndex}.
1031      */
1032     function tokenOfOwnerByIndex(address owner, uint256 index) public view virtual override returns (uint256) {
1033         require(index < ERC721.balanceOf(owner), "ERC721Enumerable: owner index out of bounds");
1034         return _ownedTokens[owner][index];
1035     }
1036 
1037     /**
1038      * @dev See {IERC721Enumerable-totalSupply}.
1039      */
1040     function totalSupply() public view virtual override returns (uint256) {
1041         return _allTokens.length;
1042     }
1043 
1044     /**
1045      * @dev See {IERC721Enumerable-tokenByIndex}.
1046      */
1047     function tokenByIndex(uint256 index) public view virtual override returns (uint256) {
1048         require(index < ERC721Enumerable.totalSupply(), "ERC721Enumerable: global index out of bounds");
1049         return _allTokens[index];
1050     }
1051 
1052     /**
1053      * @dev Hook that is called before any token transfer. This includes minting
1054      * and burning.
1055      *
1056      * Calling conditions:
1057      *
1058      * - When `from` and `to` are both non-zero, ``from``'s `tokenId` will be
1059      * transferred to `to`.
1060      * - When `from` is zero, `tokenId` will be minted for `to`.
1061      * - When `to` is zero, ``from``'s `tokenId` will be burned.
1062      * - `from` cannot be the zero address.
1063      * - `to` cannot be the zero address.
1064      *
1065      * To learn more about hooks, head to xref:ROOT:extending-contracts.adoc#using-hooks[Using Hooks].
1066      */
1067     function _beforeTokenTransfer(
1068         address from,
1069         address to,
1070         uint256 tokenId
1071     ) internal virtual override {
1072         super._beforeTokenTransfer(from, to, tokenId);
1073 
1074         if (from == address(0)) {
1075             _addTokenToAllTokensEnumeration(tokenId);
1076         } else if (from != to) {
1077             _removeTokenFromOwnerEnumeration(from, tokenId);
1078         }
1079         if (to == address(0)) {
1080             _removeTokenFromAllTokensEnumeration(tokenId);
1081         } else if (to != from) {
1082             _addTokenToOwnerEnumeration(to, tokenId);
1083         }
1084     }
1085 
1086     /**
1087      * @dev Private function to add a token to this extension's ownership-tracking data structures.
1088      * @param to address representing the new owner of the given token ID
1089      * @param tokenId uint256 ID of the token to be added to the tokens list of the given address
1090      */
1091     function _addTokenToOwnerEnumeration(address to, uint256 tokenId) private {
1092         uint256 length = ERC721.balanceOf(to);
1093         _ownedTokens[to][length] = tokenId;
1094         _ownedTokensIndex[tokenId] = length;
1095     }
1096 
1097     /**
1098      * @dev Private function to add a token to this extension's token tracking data structures.
1099      * @param tokenId uint256 ID of the token to be added to the tokens list
1100      */
1101     function _addTokenToAllTokensEnumeration(uint256 tokenId) private {
1102         _allTokensIndex[tokenId] = _allTokens.length;
1103         _allTokens.push(tokenId);
1104     }
1105 
1106     /**
1107      * @dev Private function to remove a token from this extension's ownership-tracking data structures. Note that
1108      * while the token is not assigned a new owner, the `_ownedTokensIndex` mapping is _not_ updated: this allows for
1109      * gas optimizations e.g. when performing a transfer operation (avoiding double writes).
1110      * This has O(1) time complexity, but alters the order of the _ownedTokens array.
1111      * @param from address representing the previous owner of the given token ID
1112      * @param tokenId uint256 ID of the token to be removed from the tokens list of the given address
1113      */
1114     function _removeTokenFromOwnerEnumeration(address from, uint256 tokenId) private {
1115         // To prevent a gap in from's tokens array, we store the last token in the index of the token to delete, and
1116         // then delete the last slot (swap and pop).
1117 
1118         uint256 lastTokenIndex = ERC721.balanceOf(from) - 1;
1119         uint256 tokenIndex = _ownedTokensIndex[tokenId];
1120 
1121         // When the token to delete is the last token, the swap operation is unnecessary
1122         if (tokenIndex != lastTokenIndex) {
1123             uint256 lastTokenId = _ownedTokens[from][lastTokenIndex];
1124 
1125             _ownedTokens[from][tokenIndex] = lastTokenId; // Move the last token to the slot of the to-delete token
1126             _ownedTokensIndex[lastTokenId] = tokenIndex; // Update the moved token's index
1127         }
1128 
1129         // This also deletes the contents at the last position of the array
1130         delete _ownedTokensIndex[tokenId];
1131         delete _ownedTokens[from][lastTokenIndex];
1132     }
1133 
1134     /**
1135      * @dev Private function to remove a token from this extension's token tracking data structures.
1136      * This has O(1) time complexity, but alters the order of the _allTokens array.
1137      * @param tokenId uint256 ID of the token to be removed from the tokens list
1138      */
1139     function _removeTokenFromAllTokensEnumeration(uint256 tokenId) private {
1140         // To prevent a gap in the tokens array, we store the last token in the index of the token to delete, and
1141         // then delete the last slot (swap and pop).
1142 
1143         uint256 lastTokenIndex = _allTokens.length - 1;
1144         uint256 tokenIndex = _allTokensIndex[tokenId];
1145 
1146         // When the token to delete is the last token, the swap operation is unnecessary. However, since this occurs so
1147         // rarely (when the last minted token is burnt) that we still do the swap here to avoid the gas cost of adding
1148         // an 'if' statement (like in _removeTokenFromOwnerEnumeration)
1149         uint256 lastTokenId = _allTokens[lastTokenIndex];
1150 
1151         _allTokens[tokenIndex] = lastTokenId; // Move the last token to the slot of the to-delete token
1152         _allTokensIndex[lastTokenId] = tokenIndex; // Update the moved token's index
1153 
1154         // This also deletes the contents at the last position of the array
1155         delete _allTokensIndex[tokenId];
1156         _allTokens.pop();
1157     }
1158 }
1159 
1160 // File: @openzeppelin/contracts/access/Ownable.sol
1161 
1162 pragma solidity ^0.8.0;
1163 
1164 
1165 /**
1166  * @dev Contract module which provides a basic access control mechanism, where
1167  * there is an account (an owner) that can be granted exclusive access to
1168  * specific functions.
1169  *
1170  * By default, the owner account will be the one that deploys the contract. This
1171  * can later be changed with {transferOwnership}.
1172  *
1173  * This module is used through inheritance. It will make available the modifier
1174  * `onlyOwner`, which can be applied to your functions to restrict their use to
1175  * the owner.
1176  */
1177 abstract contract Ownable is Context {
1178     address private _owner;
1179 
1180     event OwnershipTransferred(address indexed previousOwner, address indexed newOwner);
1181 
1182     /**
1183      * @dev Initializes the contract setting the deployer as the initial owner.
1184      */
1185     constructor() {
1186         _setOwner(_msgSender());
1187     }
1188 
1189     /**
1190      * @dev Returns the address of the current owner.
1191      */
1192     function owner() public view virtual returns (address) {
1193         return _owner;
1194     }
1195 
1196     /**
1197      * @dev Throws if called by any account other than the owner.
1198      */
1199     modifier onlyOwner() {
1200         require(owner() == _msgSender(), "Ownable: caller is not the owner");
1201         _;
1202     }
1203 
1204     /**
1205      * @dev Leaves the contract without owner. It will not be possible to call
1206      * `onlyOwner` functions anymore. Can only be called by the current owner.
1207      *
1208      * NOTE: Renouncing ownership will leave the contract without an owner,
1209      * thereby removing any functionality that is only available to the owner.
1210      */
1211     function renounceOwnership() public virtual onlyOwner {
1212         _setOwner(address(0));
1213     }
1214 
1215     /**
1216      * @dev Transfers ownership of the contract to a new account (`newOwner`).
1217      * Can only be called by the current owner.
1218      */
1219     function transferOwnership(address newOwner) public virtual onlyOwner {
1220         require(newOwner != address(0), "Ownable: new owner is the zero address");
1221         _setOwner(newOwner);
1222     }
1223 
1224     function _setOwner(address newOwner) private {
1225         address oldOwner = _owner;
1226         _owner = newOwner;
1227         emit OwnershipTransferred(oldOwner, newOwner);
1228     }
1229 }
1230 
1231 // File: contracts/frankenapes.sol
1232 
1233 pragma solidity ^0.8.0;
1234 
1235 
1236 
1237 contract Frankenapes is ERC721Enumerable, Ownable {
1238 
1239     using Strings for uint256;
1240 
1241     string _baseTokenURI;
1242     uint256 private _maxMint = 20;
1243     uint256 private _price = 666 * 10**14;  // 0.0666 ETH per
1244     bool public _paused = true;
1245     uint public constant MAX_ENTRIES = 6666;
1246 
1247     constructor(string memory baseURI) ERC721("Frankenapes", "FRANKENAPE")  {
1248         setBaseURI(baseURI);
1249 
1250         // team gets the first 42 for giveaways
1251         mint(msg.sender, 42);
1252     }
1253 
1254     function mint(address _to, uint256 num) public payable {
1255         uint256 supply = totalSupply();
1256 
1257         if(msg.sender != owner()) {
1258           require(!_paused, "Sale Paused");
1259           require( num < (_maxMint+1),"You can max mint 20 Frankenapes at a time");
1260           require( msg.value >= _price * num,"Wrong amount of Ether sent");
1261         }
1262 
1263         require( supply + num < MAX_ENTRIES, "Exceeds maximum supply");
1264 
1265         for(uint256 i; i < num; i++){
1266           _safeMint( _to, supply + i );
1267         }
1268     }
1269 
1270     function walletOfOwner(address _owner) public view returns(uint256[] memory) {
1271         uint256 tokenCount = balanceOf(_owner);
1272 
1273         uint256[] memory tokensId = new uint256[](tokenCount);
1274         for(uint256 i; i < tokenCount; i++){
1275             tokensId[i] = tokenOfOwnerByIndex(_owner, i);
1276         }
1277         return tokensId;
1278     }
1279 
1280     function getPrice() public view returns (uint256){
1281         if(msg.sender == owner()) {
1282             return 0;
1283         }
1284         return _price;
1285     }
1286 
1287     function setPrice(uint256 _newPrice) public onlyOwner() {
1288         _price = _newPrice;
1289     }
1290 
1291     function getMaxMint() public view returns (uint256){
1292         return _maxMint;
1293     }
1294 
1295     function setMaxMint(uint256 _newMaxMint) public onlyOwner() {
1296         _maxMint = _newMaxMint;
1297     }
1298 
1299     function _baseURI() internal view virtual override returns (string memory) {
1300         return _baseTokenURI;
1301     }
1302 
1303     function setBaseURI(string memory baseURI) public onlyOwner {
1304         _baseTokenURI = baseURI;
1305     }
1306 
1307     function pause(bool val) public onlyOwner {
1308         _paused = val;
1309     }
1310 
1311     function withdrawAll() public payable onlyOwner {
1312         require(payable(msg.sender).send(address(this).balance));
1313     }
1314 }