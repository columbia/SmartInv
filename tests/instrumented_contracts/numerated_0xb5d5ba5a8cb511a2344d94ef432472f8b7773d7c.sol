1 /**
2  *Submitted for verification at Etherscan.io on 2022-03-12
3 */
4 
5 // SPDX-License-Identifier: MIT
6 
7 pragma solidity ^0.8.0;
8 
9 /**
10  * @dev Interface of the ERC165 standard, as defined in the
11  * https://eips.ethereum.org/EIPS/eip-165[EIP].
12  *
13  * Implementers can declare support of contract interfaces, which can then be
14  * queried by others ({ERC165Checker}).
15  *
16  * For an implementation, see {ERC165}.
17  */
18 interface IERC165 {
19     /**
20      * @dev Returns true if this contract implements the interface defined by
21      * `interfaceId`. See the corresponding
22      * https://eips.ethereum.org/EIPS/eip-165#how-interfaces-are-identified[EIP section]
23      * to learn more about how these ids are created.
24      *
25      * This function call must use less than 30 000 gas.
26      */
27     function supportsInterface(bytes4 interfaceId) external view returns (bool);
28 }
29 
30 // File @openzeppelin/contracts/token/ERC721/IERC721.sol@v4.3.2
31 
32 pragma solidity ^0.8.0;
33 
34 /**
35  * @dev Required interface of an ERC721 compliant contract.
36  */
37 interface IERC721 is IERC165 {
38     /**
39      * @dev Emitted when `tokenId` token is transferred from `from` to `to`.
40      */
41     event Transfer(address indexed from, address indexed to, uint256 indexed tokenId);
42 
43     /**
44      * @dev Emitted when `owner` enables `approved` to manage the `tokenId` token.
45      */
46     event Approval(address indexed owner, address indexed approved, uint256 indexed tokenId);
47 
48     /**
49      * @dev Emitted when `owner` enables or disables (`approved`) `operator` to manage all of its assets.
50      */
51     event ApprovalForAll(address indexed owner, address indexed operator, bool approved);
52 
53     /**
54      * @dev Returns the number of tokens in ``owner``'s account.
55      */
56     function balanceOf(address owner) external view returns (uint256 balance);
57 
58     /**
59      * @dev Returns the owner of the `tokenId` token.
60      *
61      * Requirements:
62      *
63      * - `tokenId` must exist.
64      */
65     function ownerOf(uint256 tokenId) external view returns (address owner);
66 
67     /**
68      * @dev Safely transfers `tokenId` token from `from` to `to`, checking first that contract recipients
69      * are aware of the ERC721 protocol to prevent tokens from being forever locked.
70      *
71      * Requirements:
72      *
73      * - `from` cannot be the zero address.
74      * - `to` cannot be the zero address.
75      * - `tokenId` token must exist and be owned by `from`.
76      * - If the caller is not `from`, it must be have been allowed to move this token by either {approve} or {setApprovalForAll}.
77      * - If `to` refers to a smart contract, it must implement {IERC721Receiver-onERC721Received}, which is called upon a safe transfer.
78      *
79      * Emits a {Transfer} event.
80      */
81     function safeTransferFrom(
82         address from,
83         address to,
84         uint256 tokenId
85     ) external;
86 
87     /**
88      * @dev Transfers `tokenId` token from `from` to `to`.
89      *
90      * WARNING: Usage of this method is discouraged, use {safeTransferFrom} whenever possible.
91      *
92      * Requirements:
93      *
94      * - `from` cannot be the zero address.
95      * - `to` cannot be the zero address.
96      * - `tokenId` token must be owned by `from`.
97      * - If the caller is not `from`, it must be approved to move this token by either {approve} or {setApprovalForAll}.
98      *
99      * Emits a {Transfer} event.
100      */
101     function transferFrom(
102         address from,
103         address to,
104         uint256 tokenId
105     ) external;
106 
107     /**
108      * @dev Gives permission to `to` to transfer `tokenId` token to another account.
109      * The approval is cleared when the token is transferred.
110      *
111      * Only a single account can be approved at a time, so approving the zero address clears previous approvals.
112      *
113      * Requirements:
114      *
115      * - The caller must own the token or be an approved operator.
116      * - `tokenId` must exist.
117      *
118      * Emits an {Approval} event.
119      */
120     function approve(address to, uint256 tokenId) external;
121 
122     /**
123      * @dev Returns the account approved for `tokenId` token.
124      *
125      * Requirements:
126      *
127      * - `tokenId` must exist.
128      */
129     function getApproved(uint256 tokenId) external view returns (address operator);
130 
131     /**
132      * @dev Approve or remove `operator` as an operator for the caller.
133      * Operators can call {transferFrom} or {safeTransferFrom} for any token owned by the caller.
134      *
135      * Requirements:
136      *
137      * - The `operator` cannot be the caller.
138      *
139      * Emits an {ApprovalForAll} event.
140      */
141     function setApprovalForAll(address operator, bool _approved) external;
142 
143     /**
144      * @dev Returns if the `operator` is allowed to manage all of the assets of `owner`.
145      *
146      * See {setApprovalForAll}
147      */
148     function isApprovedForAll(address owner, address operator) external view returns (bool);
149 
150     /**
151      * @dev Safely transfers `tokenId` token from `from` to `to`.
152      *
153      * Requirements:
154      *
155      * - `from` cannot be the zero address.
156      * - `to` cannot be the zero address.
157      * - `tokenId` token must exist and be owned by `from`.
158      * - If the caller is not `from`, it must be approved to move this token by either {approve} or {setApprovalForAll}.
159      * - If `to` refers to a smart contract, it must implement {IERC721Receiver-onERC721Received}, which is called upon a safe transfer.
160      *
161      * Emits a {Transfer} event.
162      */
163     function safeTransferFrom(
164         address from,
165         address to,
166         uint256 tokenId,
167         bytes calldata data
168     ) external;
169 }
170 
171 // File @openzeppelin/contracts/token/ERC721/IERC721Receiver.sol@v4.3.2
172 
173 pragma solidity ^0.8.0;
174 
175 /**
176  * @title ERC721 token receiver interface
177  * @dev Interface for any contract that wants to support safeTransfers
178  * from ERC721 asset contracts.
179  */
180 interface IERC721Receiver {
181     /**
182      * @dev Whenever an {IERC721} `tokenId` token is transferred to this contract via {IERC721-safeTransferFrom}
183      * by `operator` from `from`, this function is called.
184      *
185      * It must return its Solidity selector to confirm the token transfer.
186      * If any other value is returned or the interface is not implemented by the recipient, the transfer will be reverted.
187      *
188      * The selector can be obtained in Solidity with `IERC721.onERC721Received.selector`.
189      */
190     function onERC721Received(
191         address operator,
192         address from,
193         uint256 tokenId,
194         bytes calldata data
195     ) external returns (bytes4);
196 }
197 
198 // File @openzeppelin/contracts/token/ERC721/extensions/IERC721Metadata.sol@v4.3.2
199 
200 pragma solidity ^0.8.0;
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
223 // File @openzeppelin/contracts/utils/Address.sol@v4.3.2
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
440 // File @openzeppelin/contracts/utils/Context.sol@v4.3.2
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
464 // File @openzeppelin/contracts/utils/Strings.sol@v4.3.2
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
531 // File @openzeppelin/contracts/utils/introspection/ERC165.sol@v4.3.2
532 
533 pragma solidity ^0.8.0;
534 
535 /**
536  * @dev Implementation of the {IERC165} interface.
537  *
538  * Contracts that want to implement ERC165 should inherit from this contract and override {supportsInterface} to check
539  * for the additional interface id that will be supported. For example:
540  *
541  * ```solidity
542  * function supportsInterface(bytes4 interfaceId) public view virtual override returns (bool) {
543  *     return interfaceId == type(MyInterface).interfaceId || super.supportsInterface(interfaceId);
544  * }
545  * ```
546  *
547  * Alternatively, {ERC165Storage} provides an easier to use but more expensive implementation.
548  */
549 abstract contract ERC165 is IERC165 {
550     /**
551      * @dev See {IERC165-supportsInterface}.
552      */
553     function supportsInterface(bytes4 interfaceId) public view virtual override returns (bool) {
554         return interfaceId == type(IERC165).interfaceId;
555     }
556 }
557 
558 // File @openzeppelin/contracts/token/ERC721/ERC721.sol@v4.3.2
559 
560 pragma solidity ^0.8.0;
561 
562 /**
563  * @dev Implementation of https://eips.ethereum.org/EIPS/eip-721[ERC721] Non-Fungible Token Standard, including
564  * the Metadata extension, but not including the Enumerable extension, which is available separately as
565  * {ERC721Enumerable}.
566  */
567 contract ERC721 is Context, ERC165, IERC721, IERC721Metadata {
568     using Address for address;
569     using Strings for uint256;
570 
571     // Token name
572     string private _name;
573 
574     // Token symbol
575     string private _symbol;
576 
577     // Mapping from token ID to owner address
578     mapping(uint256 => address) private _owners;
579 
580     // Mapping owner address to token count
581     mapping(address => uint256) private _balances;
582 
583     // Mapping from token ID to approved address
584     mapping(uint256 => address) private _tokenApprovals;
585 
586     // Mapping from owner to operator approvals
587     mapping(address => mapping(address => bool)) private _operatorApprovals;
588 
589     /**
590      * @dev Initializes the contract by setting a `name` and a `symbol` to the token collection.
591      */
592     constructor(string memory name_, string memory symbol_) {
593         _name = name_;
594         _symbol = symbol_;
595     }
596 
597     /**
598      * @dev See {IERC165-supportsInterface}.
599      */
600     function supportsInterface(bytes4 interfaceId) public view virtual override(ERC165, IERC165) returns (bool) {
601         return
602             interfaceId == type(IERC721).interfaceId ||
603             interfaceId == type(IERC721Metadata).interfaceId ||
604             super.supportsInterface(interfaceId);
605     }
606 
607     /**
608      * @dev See {IERC721-balanceOf}.
609      */
610     function balanceOf(address owner) public view virtual override returns (uint256) {
611         require(owner != address(0), "ERC721: balance query for the zero address");
612         return _balances[owner];
613     }
614 
615     /**
616      * @dev See {IERC721-ownerOf}.
617      */
618     function ownerOf(uint256 tokenId) public view virtual override returns (address) {
619         address owner = _owners[tokenId];
620         require(owner != address(0), "ERC721: owner query for nonexistent token");
621         return owner;
622     }
623 
624     /**
625      * @dev See {IERC721Metadata-name}.
626      */
627     function name() public view virtual override returns (string memory) {
628         return _name;
629     }
630 
631     /**
632      * @dev See {IERC721Metadata-symbol}.
633      */
634     function symbol() public view virtual override returns (string memory) {
635         return _symbol;
636     }
637 
638     /**
639      * @dev See {IERC721Metadata-tokenURI}.
640      */
641     function tokenURI(uint256 tokenId) public view virtual override returns (string memory) {
642         require(_exists(tokenId), "ERC721Metadata: URI query for nonexistent token");
643 
644         string memory baseURI = _baseURI();
645         return bytes(baseURI).length > 0 ? string(abi.encodePacked(baseURI, tokenId.toString())) : "";
646     }
647 
648     /**
649      * @dev Base URI for computing {tokenURI}. If set, the resulting URI for each
650      * token will be the concatenation of the `baseURI` and the `tokenId`. Empty
651      * by default, can be overriden in child contracts.
652      */
653     function _baseURI() internal view virtual returns (string memory) {
654         return "";
655     }
656 
657     /**
658      * @dev See {IERC721-approve}.
659      */
660     function approve(address to, uint256 tokenId) public virtual override {
661         address owner = ERC721.ownerOf(tokenId);
662         require(to != owner, "ERC721: approval to current owner");
663 
664         require(
665             _msgSender() == owner || isApprovedForAll(owner, _msgSender()),
666             "ERC721: approve caller is not owner nor approved for all"
667         );
668 
669         _approve(to, tokenId);
670     }
671 
672     /**
673      * @dev See {IERC721-getApproved}.
674      */
675     function getApproved(uint256 tokenId) public view virtual override returns (address) {
676         require(_exists(tokenId), "ERC721: approved query for nonexistent token");
677 
678         return _tokenApprovals[tokenId];
679     }
680 
681     /**
682      * @dev See {IERC721-setApprovalForAll}.
683      */
684     function setApprovalForAll(address operator, bool approved) public virtual override {
685         require(operator != _msgSender(), "ERC721: approve to caller");
686 
687         _operatorApprovals[_msgSender()][operator] = approved;
688         emit ApprovalForAll(_msgSender(), operator, approved);
689     }
690 
691     /**
692      * @dev See {IERC721-isApprovedForAll}.
693      */
694     function isApprovedForAll(address owner, address operator) public view virtual override returns (bool) {
695         return _operatorApprovals[owner][operator];
696     }
697 
698     /**
699      * @dev See {IERC721-transferFrom}.
700      */
701     function transferFrom(
702         address from,
703         address to,
704         uint256 tokenId
705     ) public virtual override {
706         //solhint-disable-next-line max-line-length
707         require(_isApprovedOrOwner(_msgSender(), tokenId), "ERC721: transfer caller is not owner nor approved");
708 
709         _transfer(from, to, tokenId);
710     }
711 
712     /**
713      * @dev See {IERC721-safeTransferFrom}.
714      */
715     function safeTransferFrom(
716         address from,
717         address to,
718         uint256 tokenId
719     ) public virtual override {
720         safeTransferFrom(from, to, tokenId, "");
721     }
722 
723     /**
724      * @dev See {IERC721-safeTransferFrom}.
725      */
726     function safeTransferFrom(
727         address from,
728         address to,
729         uint256 tokenId,
730         bytes memory _data
731     ) public virtual override {
732         require(_isApprovedOrOwner(_msgSender(), tokenId), "ERC721: transfer caller is not owner nor approved");
733         _safeTransfer(from, to, tokenId, _data);
734     }
735 
736     /**
737      * @dev Safely transfers `tokenId` token from `from` to `to`, checking first that contract recipients
738      * are aware of the ERC721 protocol to prevent tokens from being forever locked.
739      *
740      * `_data` is additional data, it has no specified format and it is sent in call to `to`.
741      *
742      * This internal function is equivalent to {safeTransferFrom}, and can be used to e.g.
743      * implement alternative mechanisms to perform token transfer, such as signature-based.
744      *
745      * Requirements:
746      *
747      * - `from` cannot be the zero address.
748      * - `to` cannot be the zero address.
749      * - `tokenId` token must exist and be owned by `from`.
750      * - If `to` refers to a smart contract, it must implement {IERC721Receiver-onERC721Received}, which is called upon a safe transfer.
751      *
752      * Emits a {Transfer} event.
753      */
754     function _safeTransfer(
755         address from,
756         address to,
757         uint256 tokenId,
758         bytes memory _data
759     ) internal virtual {
760         _transfer(from, to, tokenId);
761         require(_checkOnERC721Received(from, to, tokenId, _data), "ERC721: transfer to non ERC721Receiver implementer");
762     }
763 
764     /**
765      * @dev Returns whether `tokenId` exists.
766      *
767      * Tokens can be managed by their owner or approved accounts via {approve} or {setApprovalForAll}.
768      *
769      * Tokens start existing when they are minted (`_mint`),
770      * and stop existing when they are burned (`_burn`).
771      */
772     function _exists(uint256 tokenId) internal view virtual returns (bool) {
773         return _owners[tokenId] != address(0);
774     }
775 
776     /**
777      * @dev Returns whether `spender` is allowed to manage `tokenId`.
778      *
779      * Requirements:
780      *
781      * - `tokenId` must exist.
782      */
783     function _isApprovedOrOwner(address spender, uint256 tokenId) internal view virtual returns (bool) {
784         require(_exists(tokenId), "ERC721: operator query for nonexistent token");
785         address owner = ERC721.ownerOf(tokenId);
786         return (spender == owner || getApproved(tokenId) == spender || isApprovedForAll(owner, spender));
787     }
788 
789     /**
790      * @dev Safely mints `tokenId` and transfers it to `to`.
791      *
792      * Requirements:
793      *
794      * - `tokenId` must not exist.
795      * - If `to` refers to a smart contract, it must implement {IERC721Receiver-onERC721Received}, which is called upon a safe transfer.
796      *
797      * Emits a {Transfer} event.
798      */
799     function _safeMint(address to, uint256 tokenId) internal virtual {
800         _safeMint(to, tokenId, "");
801     }
802 
803     /**
804      * @dev Same as {xref-ERC721-_safeMint-address-uint256-}[`_safeMint`], with an additional `data` parameter which is
805      * forwarded in {IERC721Receiver-onERC721Received} to contract recipients.
806      */
807     function _safeMint(
808         address to,
809         uint256 tokenId,
810         bytes memory _data
811     ) internal virtual {
812         _mint(to, tokenId);
813         require(
814             _checkOnERC721Received(address(0), to, tokenId, _data),
815             "ERC721: transfer to non ERC721Receiver implementer"
816         );
817     }
818 
819     /**
820      * @dev Mints `tokenId` and transfers it to `to`.
821      *
822      * WARNING: Usage of this method is discouraged, use {_safeMint} whenever possible
823      *
824      * Requirements:
825      *
826      * - `tokenId` must not exist.
827      * - `to` cannot be the zero address.
828      *
829      * Emits a {Transfer} event.
830      */
831     function _mint(address to, uint256 tokenId) internal virtual {
832         require(to != address(0), "ERC721: mint to the zero address");
833         require(!_exists(tokenId), "ERC721: token already minted");
834 
835         _beforeTokenTransfer(address(0), to, tokenId);
836 
837         _balances[to] += 1;
838         _owners[tokenId] = to;
839 
840         emit Transfer(address(0), to, tokenId);
841     }
842 
843     /**
844      * @dev Destroys `tokenId`.
845      * The approval is cleared when the token is burned.
846      *
847      * Requirements:
848      *
849      * - `tokenId` must exist.
850      *
851      * Emits a {Transfer} event.
852      */
853     function _burn(uint256 tokenId) internal virtual {
854         address owner = ERC721.ownerOf(tokenId);
855 
856         _beforeTokenTransfer(owner, address(0), tokenId);
857 
858         // Clear approvals
859         _approve(address(0), tokenId);
860 
861         _balances[owner] -= 1;
862         delete _owners[tokenId];
863 
864         emit Transfer(owner, address(0), tokenId);
865     }
866 
867     /**
868      * @dev Transfers `tokenId` from `from` to `to`.
869      *  As opposed to {transferFrom}, this imposes no restrictions on msg.sender.
870      *
871      * Requirements:
872      *
873      * - `to` cannot be the zero address.
874      * - `tokenId` token must be owned by `from`.
875      *
876      * Emits a {Transfer} event.
877      */
878     function _transfer(
879         address from,
880         address to,
881         uint256 tokenId
882     ) internal virtual {
883         require(ERC721.ownerOf(tokenId) == from, "ERC721: transfer of token that is not own");
884         require(to != address(0), "ERC721: transfer to the zero address");
885 
886         _beforeTokenTransfer(from, to, tokenId);
887 
888         // Clear approvals from the previous owner
889         _approve(address(0), tokenId);
890 
891         _balances[from] -= 1;
892         _balances[to] += 1;
893         _owners[tokenId] = to;
894 
895         emit Transfer(from, to, tokenId);
896     }
897 
898     /**
899      * @dev Approve `to` to operate on `tokenId`
900      *
901      * Emits a {Approval} event.
902      */
903     function _approve(address to, uint256 tokenId) internal virtual {
904         _tokenApprovals[tokenId] = to;
905         emit Approval(ERC721.ownerOf(tokenId), to, tokenId);
906     }
907 
908     /**
909      * @dev Internal function to invoke {IERC721Receiver-onERC721Received} on a target address.
910      * The call is not executed if the target address is not a contract.
911      *
912      * @param from address representing the previous owner of the given token ID
913      * @param to target address that will receive the tokens
914      * @param tokenId uint256 ID of the token to be transferred
915      * @param _data bytes optional data to send along with the call
916      * @return bool whether the call correctly returned the expected magic value
917      */
918     function _checkOnERC721Received(
919         address from,
920         address to,
921         uint256 tokenId,
922         bytes memory _data
923     ) private returns (bool) {
924         if (to.isContract()) {
925             try IERC721Receiver(to).onERC721Received(_msgSender(), from, tokenId, _data) returns (bytes4 retval) {
926                 return retval == IERC721Receiver.onERC721Received.selector;
927             } catch (bytes memory reason) {
928                 if (reason.length == 0) {
929                     revert("ERC721: transfer to non ERC721Receiver implementer");
930                 } else {
931                     assembly {
932                         revert(add(32, reason), mload(reason))
933                     }
934                 }
935             }
936         } else {
937             return true;
938         }
939     }
940 
941     /**
942      * @dev Hook that is called before any token transfer. This includes minting
943      * and burning.
944      *
945      * Calling conditions:
946      *
947      * - When `from` and `to` are both non-zero, ``from``'s `tokenId` will be
948      * transferred to `to`.
949      * - When `from` is zero, `tokenId` will be minted for `to`.
950      * - When `to` is zero, ``from``'s `tokenId` will be burned.
951      * - `from` and `to` are never both zero.
952      *
953      * To learn more about hooks, head to xref:ROOT:extending-contracts.adoc#using-hooks[Using Hooks].
954      */
955     function _beforeTokenTransfer(
956         address from,
957         address to,
958         uint256 tokenId
959     ) internal virtual {}
960 }
961 
962 // File @openzeppelin/contracts/token/ERC721/extensions/IERC721Enumerable.sol@v4.3.2
963 
964 pragma solidity ^0.8.0;
965 
966 /**
967  * @title ERC-721 Non-Fungible Token Standard, optional enumeration extension
968  * @dev See https://eips.ethereum.org/EIPS/eip-721
969  */
970 interface IERC721Enumerable is IERC721 {
971     /**
972      * @dev Returns the total amount of tokens stored by the contract.
973      */
974     function totalSupply() external view returns (uint256);
975 
976     /**
977      * @dev Returns a token ID owned by `owner` at a given `index` of its token list.
978      * Use along with {balanceOf} to enumerate all of ``owner``'s tokens.
979      */
980     function tokenOfOwnerByIndex(address owner, uint256 index) external view returns (uint256 tokenId);
981 
982     /**
983      * @dev Returns a token ID at a given `index` of all the tokens stored by the contract.
984      * Use along with {totalSupply} to enumerate all tokens.
985      */
986     function tokenByIndex(uint256 index) external view returns (uint256);
987 }
988 
989 // File @openzeppelin/contracts/token/ERC721/extensions/ERC721Enumerable.sol@v4.3.2
990 
991 pragma solidity ^0.8.0;
992 
993 /**
994  * @dev This implements an optional extension of {ERC721} defined in the EIP that adds
995  * enumerability of all the token ids in the contract as well as all token ids owned by each
996  * account.
997  */
998 abstract contract ERC721Enumerable is ERC721, IERC721Enumerable {
999     // Mapping from owner to list of owned token IDs
1000     mapping(address => mapping(uint256 => uint256)) private _ownedTokens;
1001 
1002     // Mapping from token ID to index of the owner tokens list
1003     mapping(uint256 => uint256) private _ownedTokensIndex;
1004 
1005     // Array with all token ids, used for enumeration
1006     uint256[] private _allTokens;
1007 
1008     // Mapping from token id to position in the allTokens array
1009     mapping(uint256 => uint256) private _allTokensIndex;
1010 
1011     /**
1012      * @dev See {IERC165-supportsInterface}.
1013      */
1014     function supportsInterface(bytes4 interfaceId) public view virtual override(IERC165, ERC721) returns (bool) {
1015         return interfaceId == type(IERC721Enumerable).interfaceId || super.supportsInterface(interfaceId);
1016     }
1017 
1018     /**
1019      * @dev See {IERC721Enumerable-tokenOfOwnerByIndex}.
1020      */
1021     function tokenOfOwnerByIndex(address owner, uint256 index) public view virtual override returns (uint256) {
1022         require(index < ERC721.balanceOf(owner), "ERC721Enumerable: owner index out of bounds");
1023         return _ownedTokens[owner][index];
1024     }
1025 
1026     /**
1027      * @dev See {IERC721Enumerable-totalSupply}.
1028      */
1029     function totalSupply() public view virtual override returns (uint256) {
1030         return _allTokens.length;
1031     }
1032 
1033     /**
1034      * @dev See {IERC721Enumerable-tokenByIndex}.
1035      */
1036     function tokenByIndex(uint256 index) public view virtual override returns (uint256) {
1037         require(index < ERC721Enumerable.totalSupply(), "ERC721Enumerable: global index out of bounds");
1038         return _allTokens[index];
1039     }
1040 
1041     /**
1042      * @dev Hook that is called before any token transfer. This includes minting
1043      * and burning.
1044      *
1045      * Calling conditions:
1046      *
1047      * - When `from` and `to` are both non-zero, ``from``'s `tokenId` will be
1048      * transferred to `to`.
1049      * - When `from` is zero, `tokenId` will be minted for `to`.
1050      * - When `to` is zero, ``from``'s `tokenId` will be burned.
1051      * - `from` cannot be the zero address.
1052      * - `to` cannot be the zero address.
1053      *
1054      * To learn more about hooks, head to xref:ROOT:extending-contracts.adoc#using-hooks[Using Hooks].
1055      */
1056     function _beforeTokenTransfer(
1057         address from,
1058         address to,
1059         uint256 tokenId
1060     ) internal virtual override {
1061         super._beforeTokenTransfer(from, to, tokenId);
1062 
1063         if (from == address(0)) {
1064             _addTokenToAllTokensEnumeration(tokenId);
1065         } else if (from != to) {
1066             _removeTokenFromOwnerEnumeration(from, tokenId);
1067         }
1068         if (to == address(0)) {
1069             _removeTokenFromAllTokensEnumeration(tokenId);
1070         } else if (to != from) {
1071             _addTokenToOwnerEnumeration(to, tokenId);
1072         }
1073     }
1074 
1075     /**
1076      * @dev Private function to add a token to this extension's ownership-tracking data structures.
1077      * @param to address representing the new owner of the given token ID
1078      * @param tokenId uint256 ID of the token to be added to the tokens list of the given address
1079      */
1080     function _addTokenToOwnerEnumeration(address to, uint256 tokenId) private {
1081         uint256 length = ERC721.balanceOf(to);
1082         _ownedTokens[to][length] = tokenId;
1083         _ownedTokensIndex[tokenId] = length;
1084     }
1085 
1086     /**
1087      * @dev Private function to add a token to this extension's token tracking data structures.
1088      * @param tokenId uint256 ID of the token to be added to the tokens list
1089      */
1090     function _addTokenToAllTokensEnumeration(uint256 tokenId) private {
1091         _allTokensIndex[tokenId] = _allTokens.length;
1092         _allTokens.push(tokenId);
1093     }
1094 
1095     /**
1096      * @dev Private function to remove a token from this extension's ownership-tracking data structures. Note that
1097      * while the token is not assigned a new owner, the `_ownedTokensIndex` mapping is _not_ updated: this allows for
1098      * gas optimizations e.g. when performing a transfer operation (avoiding double writes).
1099      * This has O(1) time complexity, but alters the order of the _ownedTokens array.
1100      * @param from address representing the previous owner of the given token ID
1101      * @param tokenId uint256 ID of the token to be removed from the tokens list of the given address
1102      */
1103     function _removeTokenFromOwnerEnumeration(address from, uint256 tokenId) private {
1104         // To prevent a gap in from's tokens array, we store the last token in the index of the token to delete, and
1105         // then delete the last slot (swap and pop).
1106 
1107         uint256 lastTokenIndex = ERC721.balanceOf(from) - 1;
1108         uint256 tokenIndex = _ownedTokensIndex[tokenId];
1109 
1110         // When the token to delete is the last token, the swap operation is unnecessary
1111         if (tokenIndex != lastTokenIndex) {
1112             uint256 lastTokenId = _ownedTokens[from][lastTokenIndex];
1113 
1114             _ownedTokens[from][tokenIndex] = lastTokenId; // Move the last token to the slot of the to-delete token
1115             _ownedTokensIndex[lastTokenId] = tokenIndex; // Update the moved token's index
1116         }
1117 
1118         // This also deletes the contents at the last position of the array
1119         delete _ownedTokensIndex[tokenId];
1120         delete _ownedTokens[from][lastTokenIndex];
1121     }
1122 
1123     /**
1124      * @dev Private function to remove a token from this extension's token tracking data structures.
1125      * This has O(1) time complexity, but alters the order of the _allTokens array.
1126      * @param tokenId uint256 ID of the token to be removed from the tokens list
1127      */
1128     function _removeTokenFromAllTokensEnumeration(uint256 tokenId) private {
1129         // To prevent a gap in the tokens array, we store the last token in the index of the token to delete, and
1130         // then delete the last slot (swap and pop).
1131 
1132         uint256 lastTokenIndex = _allTokens.length - 1;
1133         uint256 tokenIndex = _allTokensIndex[tokenId];
1134 
1135         // When the token to delete is the last token, the swap operation is unnecessary. However, since this occurs so
1136         // rarely (when the last minted token is burnt) that we still do the swap here to avoid the gas cost of adding
1137         // an 'if' statement (like in _removeTokenFromOwnerEnumeration)
1138         uint256 lastTokenId = _allTokens[lastTokenIndex];
1139 
1140         _allTokens[tokenIndex] = lastTokenId; // Move the last token to the slot of the to-delete token
1141         _allTokensIndex[lastTokenId] = tokenIndex; // Update the moved token's index
1142 
1143         // This also deletes the contents at the last position of the array
1144         delete _allTokensIndex[tokenId];
1145         _allTokens.pop();
1146     }
1147 }
1148 
1149 // File @openzeppelin/contracts/access/Ownable.sol@v4.3.2
1150 
1151 pragma solidity ^0.8.0;
1152 
1153 /**
1154  * @dev Contract module which provides a basic access control mechanism, where
1155  * there is an account (an owner) that can be granted exclusive access to
1156  * specific functions.
1157  *
1158  * By default, the owner account will be the one that deploys the contract. This
1159  * can later be changed with {transferOwnership}.
1160  *
1161  * This module is used through inheritance. It will make available the modifier
1162  * `onlyOwner`, which can be applied to your functions to restrict their use to
1163  * the owner.
1164  */
1165 abstract contract Ownable is Context {
1166     address private _owner;
1167 
1168     event OwnershipTransferred(address indexed previousOwner, address indexed newOwner);
1169 
1170     /**
1171      * @dev Initializes the contract setting the deployer as the initial owner.
1172      */
1173     constructor() {
1174         _setOwner(_msgSender());
1175     }
1176 
1177     /**
1178      * @dev Returns the address of the current owner.
1179      */
1180     function owner() public view virtual returns (address) {
1181         return _owner;
1182     }
1183 
1184     /**
1185      * @dev Throws if called by any account other than the owner.
1186      */
1187     modifier onlyOwner() {
1188         require(owner() == _msgSender(), "Ownable: caller is not the owner");
1189         _;
1190     }
1191 
1192     /**
1193      * @dev Leaves the contract without owner. It will not be possible to call
1194      * `onlyOwner` functions anymore. Can only be called by the current owner.
1195      *
1196      * NOTE: Renouncing ownership will leave the contract without an owner,
1197      * thereby removing any functionality that is only available to the owner.
1198      */
1199     function renounceOwnership() public virtual onlyOwner {
1200         _setOwner(address(0));
1201     }
1202 
1203     /**
1204      * @dev Transfers ownership of the contract to a new account (`newOwner`).
1205      * Can only be called by the current owner.
1206      */
1207     function transferOwnership(address newOwner) public virtual onlyOwner {
1208         require(newOwner != address(0), "Ownable: new owner is the zero address");
1209         _setOwner(newOwner);
1210     }
1211 
1212     function _setOwner(address newOwner) private {
1213         address oldOwner = _owner;
1214         _owner = newOwner;
1215         emit OwnershipTransferred(oldOwner, newOwner);
1216     }
1217 }
1218 
1219 // File: contracts/DopeApeDripSociety.sol
1220 
1221 pragma solidity ^0.8.0;
1222 
1223 /**
1224  * @title DopeApeDripSociety contract
1225  * @dev Extends ERC721 Non-Fungible Token Standard basic implementation
1226  */
1227 contract DopeApeDripSociety is ERC721Enumerable, Ownable {
1228 
1229     uint256 public MAX_NFT_SUPPLY = 3333;
1230 
1231     uint256 public NFT_PRICE = 0.065 ether;
1232     uint256 public NFT_PRICE_PRESALE = 0.045 ether;
1233     
1234     uint256 public MAX_NFT_WALLET = 12;
1235     uint256 public MAX_NFT_WALLET_PRESALE = 8;
1236 
1237     bool public saleIsActive = false;
1238 
1239     uint256 public publicSaleStartTimestamp;
1240 
1241     string public baseTokenURI;
1242     
1243     mapping(address => bool) private whitelisted;
1244 
1245     event BaseURIChanged(string baseURI);
1246     event SaleMint(address minter, uint256 amountOfNFTs);
1247 
1248     constructor(uint256 _publicSaleStartTimestamp) ERC721("Dope Ape Drip Society", "DADS") {
1249         publicSaleStartTimestamp = _publicSaleStartTimestamp;
1250     }
1251 
1252     function addToWhitelist(address[] calldata addresses) external onlyOwner {
1253         for (uint256 i = 0; i < addresses.length; i++) {
1254             require(addresses[i] != address(0), "Cannot add null address");
1255 
1256             whitelisted[addresses[i]] = true;
1257         }
1258     }
1259 
1260     function removeFromWhitelist(address[] calldata addresses) external onlyOwner {
1261         for (uint256 i = 0; i < addresses.length; i++) {
1262             require(addresses[i] != address(0), "Cannot add null address");
1263 
1264             whitelisted[addresses[i]] = false;
1265         }
1266     }
1267 
1268     function checkIfWhitelisted(address addr) external view returns (bool) {
1269         return whitelisted[addr];
1270     }
1271 
1272     function reserveNFT(uint256 amountOfNFTs) public onlyOwner {        
1273         
1274         for (uint i = 0; i < amountOfNFTs; i++) {
1275             
1276             uint256 tokenId = totalSupply();
1277             _safeMint(msg.sender, tokenId);
1278         }
1279     }
1280 
1281     function mintNFT(uint256 amountOfNFTs) external payable {
1282         require(saleIsActive, "Sale must be active to mint NFT");
1283         require(totalSupply() + amountOfNFTs <= MAX_NFT_SUPPLY, "Minting would exceed max supply");
1284 
1285         if(hasFinalSaleStarted()) {
1286             require(NFT_PRICE * amountOfNFTs == msg.value, "ETH amount is incorrect");
1287             require(balanceOf(msg.sender) + amountOfNFTs <= MAX_NFT_WALLET, "Purchase exceeds max allowed per wallet");
1288 
1289         } else {
1290             require(whitelisted[msg.sender], "Address not whitelisted");
1291             require(NFT_PRICE_PRESALE * amountOfNFTs == msg.value, "ETH amount is incorrect");
1292             require(balanceOf(msg.sender) + amountOfNFTs <= MAX_NFT_WALLET_PRESALE, "Purchase exceeds max allowed per wallet");
1293         }
1294 
1295         for (uint256 i = 0; i < amountOfNFTs; i++) {
1296             uint256 tokenId = totalSupply();
1297 
1298             _safeMint(msg.sender, tokenId);
1299         }
1300 
1301         emit SaleMint(msg.sender, amountOfNFTs);
1302     }
1303 
1304     function flipSaleState() public onlyOwner {
1305         saleIsActive = !saleIsActive;
1306     }
1307     
1308     function hasFinalSaleStarted() public view returns(bool){
1309         return (block.timestamp >= publicSaleStartTimestamp) ? true : false;
1310     }
1311 
1312     function setBaseURI(string memory baseURI) public onlyOwner {
1313         baseTokenURI = baseURI;
1314         emit BaseURIChanged(baseURI);
1315     }
1316 
1317     function setPublicSaleStartTimestamp(uint256 _amount) external onlyOwner {
1318         publicSaleStartTimestamp = _amount;
1319     }
1320 
1321     function setNFT_PRICE(uint256 _amount) external onlyOwner {
1322         NFT_PRICE = _amount;
1323     }
1324 
1325     function setNFT_PRICE_PRESALE(uint256 _amount) external onlyOwner {
1326         NFT_PRICE_PRESALE = _amount;
1327     }
1328 
1329     function setMAX_NFT_WALLET(uint256 _amount) external onlyOwner {
1330         MAX_NFT_WALLET = _amount;
1331     }
1332 
1333     function setMAX_NFT_WALLET_PRESALE(uint256 _amount) external onlyOwner {
1334         MAX_NFT_WALLET_PRESALE = _amount;
1335     }
1336 
1337     function _baseURI() internal view virtual override returns (string memory) {
1338         return baseTokenURI;
1339     }
1340 
1341     function withdrawAll() public onlyOwner {
1342         uint256 balance = address(this).balance;
1343         require(balance > 0, "Insufficent balance");
1344 
1345         uint256 AhmedBal = (balance * 275) / 1000;
1346         uint256 Owner = balance - AhmedBal;
1347 
1348         (bool success, ) = payable(0xd465c4d38192A7e4883453aCb23aB5458BDEcAA9).call{value: AhmedBal}("");
1349         require(success, "Transfer failed to Ahmed");
1350 
1351         (bool success1, ) = payable(owner()).call{value: Owner}("");
1352         require(success1, "Transfer failed to owner");
1353     }
1354  
1355 }