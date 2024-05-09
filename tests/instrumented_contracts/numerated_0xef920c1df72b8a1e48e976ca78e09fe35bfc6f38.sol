1 // File @openzeppelin/contracts/utils/introspection/IERC165.sol@v4.3.2
2 
3 pragma solidity ^0.8.0;
4 
5 /**
6  * @dev Interface of the ERC165 standard, as defined in the
7  * https://eips.ethereum.org/EIPS/eip-165[EIP].
8  *
9  * Implementers can declare support of contract interfaces, which can then be
10  * queried by others ({ERC165Checker}).
11  *
12  * For an implementation, see {ERC165}.
13  */
14 interface IERC165 {
15     /**
16      * @dev Returns true if this contract implements the interface defined by
17      * `interfaceId`. See the corresponding
18      * https://eips.ethereum.org/EIPS/eip-165#how-interfaces-are-identified[EIP section]
19      * to learn more about how these ids are created.
20      *
21      * This function call must use less than 30 000 gas.
22      */
23     function supportsInterface(bytes4 interfaceId) external view returns (bool);
24 }
25 
26 
27 // File @openzeppelin/contracts/token/ERC721/IERC721.sol@v4.3.2
28 
29 pragma solidity ^0.8.0;
30 
31 /**
32  * @dev Required interface of an ERC721 compliant contract.
33  */
34 interface IERC721 is IERC165 {
35     /**
36      * @dev Emitted when `tokenId` token is transferred from `from` to `to`.
37      */
38     event Transfer(address indexed from, address indexed to, uint256 indexed tokenId);
39 
40     /**
41      * @dev Emitted when `owner` enables `approved` to manage the `tokenId` token.
42      */
43     event Approval(address indexed owner, address indexed approved, uint256 indexed tokenId);
44 
45     /**
46      * @dev Emitted when `owner` enables or disables (`approved`) `operator` to manage all of its assets.
47      */
48     event ApprovalForAll(address indexed owner, address indexed operator, bool approved);
49 
50     /**
51      * @dev Returns the number of tokens in ``owner``'s account.
52      */
53     function balanceOf(address owner) external view returns (uint256 balance);
54 
55     /**
56      * @dev Returns the owner of the `tokenId` token.
57      *
58      * Requirements:
59      *
60      * - `tokenId` must exist.
61      */
62     function ownerOf(uint256 tokenId) external view returns (address owner);
63 
64     /**
65      * @dev Safely transfers `tokenId` token from `from` to `to`, checking first that contract recipients
66      * are aware of the ERC721 protocol to prevent tokens from being forever locked.
67      *
68      * Requirements:
69      *
70      * - `from` cannot be the zero address.
71      * - `to` cannot be the zero address.
72      * - `tokenId` token must exist and be owned by `from`.
73      * - If the caller is not `from`, it must be have been allowed to move this token by either {approve} or {setApprovalForAll}.
74      * - If `to` refers to a smart contract, it must implement {IERC721Receiver-onERC721Received}, which is called upon a safe transfer.
75      *
76      * Emits a {Transfer} event.
77      */
78     function safeTransferFrom(
79         address from,
80         address to,
81         uint256 tokenId
82     ) external;
83 
84     /**
85      * @dev Transfers `tokenId` token from `from` to `to`.
86      *
87      * WARNING: Usage of this method is discouraged, use {safeTransferFrom} whenever possible.
88      *
89      * Requirements:
90      *
91      * - `from` cannot be the zero address.
92      * - `to` cannot be the zero address.
93      * - `tokenId` token must be owned by `from`.
94      * - If the caller is not `from`, it must be approved to move this token by either {approve} or {setApprovalForAll}.
95      *
96      * Emits a {Transfer} event.
97      */
98     function transferFrom(
99         address from,
100         address to,
101         uint256 tokenId
102     ) external;
103 
104     /**
105      * @dev Gives permission to `to` to transfer `tokenId` token to another account.
106      * The approval is cleared when the token is transferred.
107      *
108      * Only a single account can be approved at a time, so approving the zero address clears previous approvals.
109      *
110      * Requirements:
111      *
112      * - The caller must own the token or be an approved operator.
113      * - `tokenId` must exist.
114      *
115      * Emits an {Approval} event.
116      */
117     function approve(address to, uint256 tokenId) external;
118 
119     /**
120      * @dev Returns the account approved for `tokenId` token.
121      *
122      * Requirements:
123      *
124      * - `tokenId` must exist.
125      */
126     function getApproved(uint256 tokenId) external view returns (address operator);
127 
128     /**
129      * @dev Approve or remove `operator` as an operator for the caller.
130      * Operators can call {transferFrom} or {safeTransferFrom} for any token owned by the caller.
131      *
132      * Requirements:
133      *
134      * - The `operator` cannot be the caller.
135      *
136      * Emits an {ApprovalForAll} event.
137      */
138     function setApprovalForAll(address operator, bool _approved) external;
139 
140     /**
141      * @dev Returns if the `operator` is allowed to manage all of the assets of `owner`.
142      *
143      * See {setApprovalForAll}
144      */
145     function isApprovedForAll(address owner, address operator) external view returns (bool);
146 
147     /**
148      * @dev Safely transfers `tokenId` token from `from` to `to`.
149      *
150      * Requirements:
151      *
152      * - `from` cannot be the zero address.
153      * - `to` cannot be the zero address.
154      * - `tokenId` token must exist and be owned by `from`.
155      * - If the caller is not `from`, it must be approved to move this token by either {approve} or {setApprovalForAll}.
156      * - If `to` refers to a smart contract, it must implement {IERC721Receiver-onERC721Received}, which is called upon a safe transfer.
157      *
158      * Emits a {Transfer} event.
159      */
160     function safeTransferFrom(
161         address from,
162         address to,
163         uint256 tokenId,
164         bytes calldata data
165     ) external;
166 }
167 
168 
169 // File @openzeppelin/contracts/token/ERC721/IERC721Receiver.sol@v4.3.2
170 
171 pragma solidity ^0.8.0;
172 
173 /**
174  * @title ERC721 token receiver interface
175  * @dev Interface for any contract that wants to support safeTransfers
176  * from ERC721 asset contracts.
177  */
178 interface IERC721Receiver {
179     /**
180      * @dev Whenever an {IERC721} `tokenId` token is transferred to this contract via {IERC721-safeTransferFrom}
181      * by `operator` from `from`, this function is called.
182      *
183      * It must return its Solidity selector to confirm the token transfer.
184      * If any other value is returned or the interface is not implemented by the recipient, the transfer will be reverted.
185      *
186      * The selector can be obtained in Solidity with `IERC721.onERC721Received.selector`.
187      */
188     function onERC721Received(
189         address operator,
190         address from,
191         uint256 tokenId,
192         bytes calldata data
193     ) external returns (bytes4);
194 }
195 
196 
197 // File @openzeppelin/contracts/token/ERC721/extensions/IERC721Metadata.sol@v4.3.2
198 
199 pragma solidity ^0.8.0;
200 
201 /**
202  * @title ERC-721 Non-Fungible Token Standard, optional metadata extension
203  * @dev See https://eips.ethereum.org/EIPS/eip-721
204  */
205 interface IERC721Metadata is IERC721 {
206     /**
207      * @dev Returns the token collection name.
208      */
209     function name() external view returns (string memory);
210 
211     /**
212      * @dev Returns the token collection symbol.
213      */
214     function symbol() external view returns (string memory);
215 
216     /**
217      * @dev Returns the Uniform Resource Identifier (URI) for `tokenId` token.
218      */
219     function tokenURI(uint256 tokenId) external view returns (string memory);
220 }
221 
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
440 
441 // File @openzeppelin/contracts/utils/Context.sol@v4.3.2
442 
443 pragma solidity ^0.8.0;
444 
445 /**
446  * @dev Provides information about the current execution context, including the
447  * sender of the transaction and its data. While these are generally available
448  * via msg.sender and msg.data, they should not be accessed in such a direct
449  * manner, since when dealing with meta-transactions the account sending and
450  * paying for execution may not be the actual sender (as far as an application
451  * is concerned).
452  *
453  * This contract is only required for intermediate, library-like contracts.
454  */
455 abstract contract Context {
456     function _msgSender() internal view virtual returns (address) {
457         return msg.sender;
458     }
459 
460     function _msgData() internal view virtual returns (bytes calldata) {
461         return msg.data;
462     }
463 }
464 
465 
466 // File @openzeppelin/contracts/utils/Strings.sol@v4.3.2
467 
468 pragma solidity ^0.8.0;
469 
470 /**
471  * @dev String operations.
472  */
473 library Strings {
474     bytes16 private constant _HEX_SYMBOLS = "0123456789abcdef";
475 
476     /**
477      * @dev Converts a `uint256` to its ASCII `string` decimal representation.
478      */
479     function toString(uint256 value) internal pure returns (string memory) {
480         // Inspired by OraclizeAPI's implementation - MIT licence
481         // https://github.com/oraclize/ethereum-api/blob/b42146b063c7d6ee1358846c198246239e9360e8/oraclizeAPI_0.4.25.sol
482 
483         if (value == 0) {
484             return "0";
485         }
486         uint256 temp = value;
487         uint256 digits;
488         while (temp != 0) {
489             digits++;
490             temp /= 10;
491         }
492         bytes memory buffer = new bytes(digits);
493         while (value != 0) {
494             digits -= 1;
495             buffer[digits] = bytes1(uint8(48 + uint256(value % 10)));
496             value /= 10;
497         }
498         return string(buffer);
499     }
500 
501     /**
502      * @dev Converts a `uint256` to its ASCII `string` hexadecimal representation.
503      */
504     function toHexString(uint256 value) internal pure returns (string memory) {
505         if (value == 0) {
506             return "0x00";
507         }
508         uint256 temp = value;
509         uint256 length = 0;
510         while (temp != 0) {
511             length++;
512             temp >>= 8;
513         }
514         return toHexString(value, length);
515     }
516 
517     /**
518      * @dev Converts a `uint256` to its ASCII `string` hexadecimal representation with fixed length.
519      */
520     function toHexString(uint256 value, uint256 length) internal pure returns (string memory) {
521         bytes memory buffer = new bytes(2 * length + 2);
522         buffer[0] = "0";
523         buffer[1] = "x";
524         for (uint256 i = 2 * length + 1; i > 1; --i) {
525             buffer[i] = _HEX_SYMBOLS[value & 0xf];
526             value >>= 4;
527         }
528         require(value == 0, "Strings: hex length insufficient");
529         return string(buffer);
530     }
531 }
532 
533 
534 // File @openzeppelin/contracts/utils/introspection/ERC165.sol@v4.3.2
535 
536 pragma solidity ^0.8.0;
537 
538 /**
539  * @dev Implementation of the {IERC165} interface.
540  *
541  * Contracts that want to implement ERC165 should inherit from this contract and override {supportsInterface} to check
542  * for the additional interface id that will be supported. For example:
543  *
544  * ```solidity
545  * function supportsInterface(bytes4 interfaceId) public view virtual override returns (bool) {
546  *     return interfaceId == type(MyInterface).interfaceId || super.supportsInterface(interfaceId);
547  * }
548  * ```
549  *
550  * Alternatively, {ERC165Storage} provides an easier to use but more expensive implementation.
551  */
552 abstract contract ERC165 is IERC165 {
553     /**
554      * @dev See {IERC165-supportsInterface}.
555      */
556     function supportsInterface(bytes4 interfaceId) public view virtual override returns (bool) {
557         return interfaceId == type(IERC165).interfaceId;
558     }
559 }
560 
561 
562 // File @openzeppelin/contracts/token/ERC721/ERC721.sol@v4.3.2
563 
564 pragma solidity ^0.8.0;
565 
566 
567 
568 
569 
570 
571 
572 /**
573  * @dev Implementation of https://eips.ethereum.org/EIPS/eip-721[ERC721] Non-Fungible Token Standard, including
574  * the Metadata extension, but not including the Enumerable extension, which is available separately as
575  * {ERC721Enumerable}.
576  */
577 contract ERC721 is Context, ERC165, IERC721, IERC721Metadata {
578     using Address for address;
579     using Strings for uint256;
580 
581     // Token name
582     string private _name;
583 
584     // Token symbol
585     string private _symbol;
586 
587     // Mapping from token ID to owner address
588     mapping(uint256 => address) private _owners;
589 
590     // Mapping owner address to token count
591     mapping(address => uint256) private _balances;
592 
593     // Mapping from token ID to approved address
594     mapping(uint256 => address) private _tokenApprovals;
595 
596     // Mapping from owner to operator approvals
597     mapping(address => mapping(address => bool)) private _operatorApprovals;
598 
599     /**
600      * @dev Initializes the contract by setting a `name` and a `symbol` to the token collection.
601      */
602     constructor(string memory name_, string memory symbol_) {
603         _name = name_;
604         _symbol = symbol_;
605     }
606 
607     /**
608      * @dev See {IERC165-supportsInterface}.
609      */
610     function supportsInterface(bytes4 interfaceId) public view virtual override(ERC165, IERC165) returns (bool) {
611         return
612             interfaceId == type(IERC721).interfaceId ||
613             interfaceId == type(IERC721Metadata).interfaceId ||
614             super.supportsInterface(interfaceId);
615     }
616 
617     /**
618      * @dev See {IERC721-balanceOf}.
619      */
620     function balanceOf(address owner) public view virtual override returns (uint256) {
621         require(owner != address(0), "ERC721: balance query for the zero address");
622         return _balances[owner];
623     }
624 
625     /**
626      * @dev See {IERC721-ownerOf}.
627      */
628     function ownerOf(uint256 tokenId) public view virtual override returns (address) {
629         address owner = _owners[tokenId];
630         require(owner != address(0), "ERC721: owner query for nonexistent token");
631         return owner;
632     }
633 
634     /**
635      * @dev See {IERC721Metadata-name}.
636      */
637     function name() public view virtual override returns (string memory) {
638         return _name;
639     }
640 
641     /**
642      * @dev See {IERC721Metadata-symbol}.
643      */
644     function symbol() public view virtual override returns (string memory) {
645         return _symbol;
646     }
647 
648     /**
649      * @dev See {IERC721Metadata-tokenURI}.
650      */
651     function tokenURI(uint256 tokenId) public view virtual override returns (string memory) {
652         require(_exists(tokenId), "ERC721Metadata: URI query for nonexistent token");
653 
654         string memory baseURI = _baseURI();
655         return bytes(baseURI).length > 0 ? string(abi.encodePacked(baseURI, tokenId.toString())) : "";
656     }
657 
658     /**
659      * @dev Base URI for computing {tokenURI}. If set, the resulting URI for each
660      * token will be the concatenation of the `baseURI` and the `tokenId`. Empty
661      * by default, can be overriden in child contracts.
662      */
663     function _baseURI() internal view virtual returns (string memory) {
664         return "";
665     }
666 
667     /**
668      * @dev See {IERC721-approve}.
669      */
670     function approve(address to, uint256 tokenId) public virtual override {
671         address owner = ERC721.ownerOf(tokenId);
672         require(to != owner, "ERC721: approval to current owner");
673 
674         require(
675             _msgSender() == owner || isApprovedForAll(owner, _msgSender()),
676             "ERC721: approve caller is not owner nor approved for all"
677         );
678 
679         _approve(to, tokenId);
680     }
681 
682     /**
683      * @dev See {IERC721-getApproved}.
684      */
685     function getApproved(uint256 tokenId) public view virtual override returns (address) {
686         require(_exists(tokenId), "ERC721: approved query for nonexistent token");
687 
688         return _tokenApprovals[tokenId];
689     }
690 
691     /**
692      * @dev See {IERC721-setApprovalForAll}.
693      */
694     function setApprovalForAll(address operator, bool approved) public virtual override {
695         require(operator != _msgSender(), "ERC721: approve to caller");
696 
697         _operatorApprovals[_msgSender()][operator] = approved;
698         emit ApprovalForAll(_msgSender(), operator, approved);
699     }
700 
701     /**
702      * @dev See {IERC721-isApprovedForAll}.
703      */
704     function isApprovedForAll(address owner, address operator) public view virtual override returns (bool) {
705         return _operatorApprovals[owner][operator];
706     }
707 
708     /**
709      * @dev See {IERC721-transferFrom}.
710      */
711     function transferFrom(
712         address from,
713         address to,
714         uint256 tokenId
715     ) public virtual override {
716         //solhint-disable-next-line max-line-length
717         require(_isApprovedOrOwner(_msgSender(), tokenId), "ERC721: transfer caller is not owner nor approved");
718 
719         _transfer(from, to, tokenId);
720     }
721 
722     /**
723      * @dev See {IERC721-safeTransferFrom}.
724      */
725     function safeTransferFrom(
726         address from,
727         address to,
728         uint256 tokenId
729     ) public virtual override {
730         safeTransferFrom(from, to, tokenId, "");
731     }
732 
733     /**
734      * @dev See {IERC721-safeTransferFrom}.
735      */
736     function safeTransferFrom(
737         address from,
738         address to,
739         uint256 tokenId,
740         bytes memory _data
741     ) public virtual override {
742         require(_isApprovedOrOwner(_msgSender(), tokenId), "ERC721: transfer caller is not owner nor approved");
743         _safeTransfer(from, to, tokenId, _data);
744     }
745 
746     /**
747      * @dev Safely transfers `tokenId` token from `from` to `to`, checking first that contract recipients
748      * are aware of the ERC721 protocol to prevent tokens from being forever locked.
749      *
750      * `_data` is additional data, it has no specified format and it is sent in call to `to`.
751      *
752      * This internal function is equivalent to {safeTransferFrom}, and can be used to e.g.
753      * implement alternative mechanisms to perform token transfer, such as signature-based.
754      *
755      * Requirements:
756      *
757      * - `from` cannot be the zero address.
758      * - `to` cannot be the zero address.
759      * - `tokenId` token must exist and be owned by `from`.
760      * - If `to` refers to a smart contract, it must implement {IERC721Receiver-onERC721Received}, which is called upon a safe transfer.
761      *
762      * Emits a {Transfer} event.
763      */
764     function _safeTransfer(
765         address from,
766         address to,
767         uint256 tokenId,
768         bytes memory _data
769     ) internal virtual {
770         _transfer(from, to, tokenId);
771         require(_checkOnERC721Received(from, to, tokenId, _data), "ERC721: transfer to non ERC721Receiver implementer");
772     }
773 
774     /**
775      * @dev Returns whether `tokenId` exists.
776      *
777      * Tokens can be managed by their owner or approved accounts via {approve} or {setApprovalForAll}.
778      *
779      * Tokens start existing when they are minted (`_mint`),
780      * and stop existing when they are burned (`_burn`).
781      */
782     function _exists(uint256 tokenId) internal view virtual returns (bool) {
783         return _owners[tokenId] != address(0);
784     }
785 
786     /**
787      * @dev Returns whether `spender` is allowed to manage `tokenId`.
788      *
789      * Requirements:
790      *
791      * - `tokenId` must exist.
792      */
793     function _isApprovedOrOwner(address spender, uint256 tokenId) internal view virtual returns (bool) {
794         require(_exists(tokenId), "ERC721: operator query for nonexistent token");
795         address owner = ERC721.ownerOf(tokenId);
796         return (spender == owner || getApproved(tokenId) == spender || isApprovedForAll(owner, spender));
797     }
798 
799     /**
800      * @dev Safely mints `tokenId` and transfers it to `to`.
801      *
802      * Requirements:
803      *
804      * - `tokenId` must not exist.
805      * - If `to` refers to a smart contract, it must implement {IERC721Receiver-onERC721Received}, which is called upon a safe transfer.
806      *
807      * Emits a {Transfer} event.
808      */
809     function _safeMint(address to, uint256 tokenId) internal virtual {
810         _safeMint(to, tokenId, "");
811     }
812 
813     /**
814      * @dev Same as {xref-ERC721-_safeMint-address-uint256-}[`_safeMint`], with an additional `data` parameter which is
815      * forwarded in {IERC721Receiver-onERC721Received} to contract recipients.
816      */
817     function _safeMint(
818         address to,
819         uint256 tokenId,
820         bytes memory _data
821     ) internal virtual {
822         _mint(to, tokenId);
823         require(
824             _checkOnERC721Received(address(0), to, tokenId, _data),
825             "ERC721: transfer to non ERC721Receiver implementer"
826         );
827     }
828 
829     /**
830      * @dev Mints `tokenId` and transfers it to `to`.
831      *
832      * WARNING: Usage of this method is discouraged, use {_safeMint} whenever possible
833      *
834      * Requirements:
835      *
836      * - `tokenId` must not exist.
837      * - `to` cannot be the zero address.
838      *
839      * Emits a {Transfer} event.
840      */
841     function _mint(address to, uint256 tokenId) internal virtual {
842         require(to != address(0), "ERC721: mint to the zero address");
843         require(!_exists(tokenId), "ERC721: token already minted");
844 
845         _beforeTokenTransfer(address(0), to, tokenId);
846 
847         _balances[to] += 1;
848         _owners[tokenId] = to;
849 
850         emit Transfer(address(0), to, tokenId);
851     }
852 
853     /**
854      * @dev Destroys `tokenId`.
855      * The approval is cleared when the token is burned.
856      *
857      * Requirements:
858      *
859      * - `tokenId` must exist.
860      *
861      * Emits a {Transfer} event.
862      */
863     function _burn(uint256 tokenId) internal virtual {
864         address owner = ERC721.ownerOf(tokenId);
865 
866         _beforeTokenTransfer(owner, address(0), tokenId);
867 
868         // Clear approvals
869         _approve(address(0), tokenId);
870 
871         _balances[owner] -= 1;
872         delete _owners[tokenId];
873 
874         emit Transfer(owner, address(0), tokenId);
875     }
876 
877     /**
878      * @dev Transfers `tokenId` from `from` to `to`.
879      *  As opposed to {transferFrom}, this imposes no restrictions on msg.sender.
880      *
881      * Requirements:
882      *
883      * - `to` cannot be the zero address.
884      * - `tokenId` token must be owned by `from`.
885      *
886      * Emits a {Transfer} event.
887      */
888     function _transfer(
889         address from,
890         address to,
891         uint256 tokenId
892     ) internal virtual {
893         require(ERC721.ownerOf(tokenId) == from, "ERC721: transfer of token that is not own");
894         require(to != address(0), "ERC721: transfer to the zero address");
895 
896         _beforeTokenTransfer(from, to, tokenId);
897 
898         // Clear approvals from the previous owner
899         _approve(address(0), tokenId);
900 
901         _balances[from] -= 1;
902         _balances[to] += 1;
903         _owners[tokenId] = to;
904 
905         emit Transfer(from, to, tokenId);
906     }
907 
908     /**
909      * @dev Approve `to` to operate on `tokenId`
910      *
911      * Emits a {Approval} event.
912      */
913     function _approve(address to, uint256 tokenId) internal virtual {
914         _tokenApprovals[tokenId] = to;
915         emit Approval(ERC721.ownerOf(tokenId), to, tokenId);
916     }
917 
918     /**
919      * @dev Internal function to invoke {IERC721Receiver-onERC721Received} on a target address.
920      * The call is not executed if the target address is not a contract.
921      *
922      * @param from address representing the previous owner of the given token ID
923      * @param to target address that will receive the tokens
924      * @param tokenId uint256 ID of the token to be transferred
925      * @param _data bytes optional data to send along with the call
926      * @return bool whether the call correctly returned the expected magic value
927      */
928     function _checkOnERC721Received(
929         address from,
930         address to,
931         uint256 tokenId,
932         bytes memory _data
933     ) private returns (bool) {
934         if (to.isContract()) {
935             try IERC721Receiver(to).onERC721Received(_msgSender(), from, tokenId, _data) returns (bytes4 retval) {
936                 return retval == IERC721Receiver.onERC721Received.selector;
937             } catch (bytes memory reason) {
938                 if (reason.length == 0) {
939                     revert("ERC721: transfer to non ERC721Receiver implementer");
940                 } else {
941                     assembly {
942                         revert(add(32, reason), mload(reason))
943                     }
944                 }
945             }
946         } else {
947             return true;
948         }
949     }
950 
951     /**
952      * @dev Hook that is called before any token transfer. This includes minting
953      * and burning.
954      *
955      * Calling conditions:
956      *
957      * - When `from` and `to` are both non-zero, ``from``'s `tokenId` will be
958      * transferred to `to`.
959      * - When `from` is zero, `tokenId` will be minted for `to`.
960      * - When `to` is zero, ``from``'s `tokenId` will be burned.
961      * - `from` and `to` are never both zero.
962      *
963      * To learn more about hooks, head to xref:ROOT:extending-contracts.adoc#using-hooks[Using Hooks].
964      */
965     function _beforeTokenTransfer(
966         address from,
967         address to,
968         uint256 tokenId
969     ) internal virtual {}
970 }
971 
972 
973 // File @openzeppelin/contracts/access/Ownable.sol@v4.3.2
974 
975 pragma solidity ^0.8.0;
976 
977 /**
978  * @dev Contract module which provides a basic access control mechanism, where
979  * there is an account (an owner) that can be granted exclusive access to
980  * specific functions.
981  *
982  * By default, the owner account will be the one that deploys the contract. This
983  * can later be changed with {transferOwnership}.
984  *
985  * This module is used through inheritance. It will make available the modifier
986  * `onlyOwner`, which can be applied to your functions to restrict their use to
987  * the owner.
988  */
989 abstract contract Ownable is Context {
990     address private _owner;
991 
992     event OwnershipTransferred(address indexed previousOwner, address indexed newOwner);
993 
994     /**
995      * @dev Initializes the contract setting the deployer as the initial owner.
996      */
997     constructor() {
998         _setOwner(_msgSender());
999     }
1000 
1001     /**
1002      * @dev Returns the address of the current owner.
1003      */
1004     function owner() public view virtual returns (address) {
1005         return _owner;
1006     }
1007 
1008     /**
1009      * @dev Throws if called by any account other than the owner.
1010      */
1011     modifier onlyOwner() {
1012         require(owner() == _msgSender(), "Ownable: caller is not the owner");
1013         _;
1014     }
1015 
1016     /**
1017      * @dev Leaves the contract without owner. It will not be possible to call
1018      * `onlyOwner` functions anymore. Can only be called by the current owner.
1019      *
1020      * NOTE: Renouncing ownership will leave the contract without an owner,
1021      * thereby removing any functionality that is only available to the owner.
1022      */
1023     function renounceOwnership() public virtual onlyOwner {
1024         _setOwner(address(0));
1025     }
1026 
1027     /**
1028      * @dev Transfers ownership of the contract to a new account (`newOwner`).
1029      * Can only be called by the current owner.
1030      */
1031     function transferOwnership(address newOwner) public virtual onlyOwner {
1032         require(newOwner != address(0), "Ownable: new owner is the zero address");
1033         _setOwner(newOwner);
1034     }
1035 
1036     function _setOwner(address newOwner) private {
1037         address oldOwner = _owner;
1038         _owner = newOwner;
1039         emit OwnershipTransferred(oldOwner, newOwner);
1040     }
1041 }
1042 
1043 
1044 // File @openzeppelin/contracts/token/ERC721/extensions/IERC721Enumerable.sol@v4.3.2
1045 
1046 pragma solidity ^0.8.0;
1047 
1048 /**
1049  * @title ERC-721 Non-Fungible Token Standard, optional enumeration extension
1050  * @dev See https://eips.ethereum.org/EIPS/eip-721
1051  */
1052 interface IERC721Enumerable is IERC721 {
1053     /**
1054      * @dev Returns the total amount of tokens stored by the contract.
1055      */
1056     function totalSupply() external view returns (uint256);
1057 
1058     /**
1059      * @dev Returns a token ID owned by `owner` at a given `index` of its token list.
1060      * Use along with {balanceOf} to enumerate all of ``owner``'s tokens.
1061      */
1062     function tokenOfOwnerByIndex(address owner, uint256 index) external view returns (uint256 tokenId);
1063 
1064     /**
1065      * @dev Returns a token ID at a given `index` of all the tokens stored by the contract.
1066      * Use along with {totalSupply} to enumerate all tokens.
1067      */
1068     function tokenByIndex(uint256 index) external view returns (uint256);
1069 }
1070 
1071 
1072 // File @openzeppelin/contracts/token/ERC721/extensions/ERC721Enumerable.sol@v4.3.2
1073 
1074 pragma solidity ^0.8.0;
1075 
1076 
1077 /**
1078  * @dev This implements an optional extension of {ERC721} defined in the EIP that adds
1079  * enumerability of all the token ids in the contract as well as all token ids owned by each
1080  * account.
1081  */
1082 abstract contract ERC721Enumerable is ERC721, IERC721Enumerable {
1083     // Mapping from owner to list of owned token IDs
1084     mapping(address => mapping(uint256 => uint256)) private _ownedTokens;
1085 
1086     // Mapping from token ID to index of the owner tokens list
1087     mapping(uint256 => uint256) private _ownedTokensIndex;
1088 
1089     // Array with all token ids, used for enumeration
1090     uint256[] private _allTokens;
1091 
1092     // Mapping from token id to position in the allTokens array
1093     mapping(uint256 => uint256) private _allTokensIndex;
1094 
1095     /**
1096      * @dev See {IERC165-supportsInterface}.
1097      */
1098     function supportsInterface(bytes4 interfaceId) public view virtual override(IERC165, ERC721) returns (bool) {
1099         return interfaceId == type(IERC721Enumerable).interfaceId || super.supportsInterface(interfaceId);
1100     }
1101 
1102     /**
1103      * @dev See {IERC721Enumerable-tokenOfOwnerByIndex}.
1104      */
1105     function tokenOfOwnerByIndex(address owner, uint256 index) public view virtual override returns (uint256) {
1106         require(index < ERC721.balanceOf(owner), "ERC721Enumerable: owner index out of bounds");
1107         return _ownedTokens[owner][index];
1108     }
1109 
1110     /**
1111      * @dev See {IERC721Enumerable-totalSupply}.
1112      */
1113     function totalSupply() public view virtual override returns (uint256) {
1114         return _allTokens.length;
1115     }
1116 
1117     /**
1118      * @dev See {IERC721Enumerable-tokenByIndex}.
1119      */
1120     function tokenByIndex(uint256 index) public view virtual override returns (uint256) {
1121         require(index < ERC721Enumerable.totalSupply(), "ERC721Enumerable: global index out of bounds");
1122         return _allTokens[index];
1123     }
1124 
1125     /**
1126      * @dev Hook that is called before any token transfer. This includes minting
1127      * and burning.
1128      *
1129      * Calling conditions:
1130      *
1131      * - When `from` and `to` are both non-zero, ``from``'s `tokenId` will be
1132      * transferred to `to`.
1133      * - When `from` is zero, `tokenId` will be minted for `to`.
1134      * - When `to` is zero, ``from``'s `tokenId` will be burned.
1135      * - `from` cannot be the zero address.
1136      * - `to` cannot be the zero address.
1137      *
1138      * To learn more about hooks, head to xref:ROOT:extending-contracts.adoc#using-hooks[Using Hooks].
1139      */
1140     function _beforeTokenTransfer(
1141         address from,
1142         address to,
1143         uint256 tokenId
1144     ) internal virtual override {
1145         super._beforeTokenTransfer(from, to, tokenId);
1146 
1147         if (from == address(0)) {
1148             _addTokenToAllTokensEnumeration(tokenId);
1149         } else if (from != to) {
1150             _removeTokenFromOwnerEnumeration(from, tokenId);
1151         }
1152         if (to == address(0)) {
1153             _removeTokenFromAllTokensEnumeration(tokenId);
1154         } else if (to != from) {
1155             _addTokenToOwnerEnumeration(to, tokenId);
1156         }
1157     }
1158 
1159     /**
1160      * @dev Private function to add a token to this extension's ownership-tracking data structures.
1161      * @param to address representing the new owner of the given token ID
1162      * @param tokenId uint256 ID of the token to be added to the tokens list of the given address
1163      */
1164     function _addTokenToOwnerEnumeration(address to, uint256 tokenId) private {
1165         uint256 length = ERC721.balanceOf(to);
1166         _ownedTokens[to][length] = tokenId;
1167         _ownedTokensIndex[tokenId] = length;
1168     }
1169 
1170     /**
1171      * @dev Private function to add a token to this extension's token tracking data structures.
1172      * @param tokenId uint256 ID of the token to be added to the tokens list
1173      */
1174     function _addTokenToAllTokensEnumeration(uint256 tokenId) private {
1175         _allTokensIndex[tokenId] = _allTokens.length;
1176         _allTokens.push(tokenId);
1177     }
1178 
1179     /**
1180      * @dev Private function to remove a token from this extension's ownership-tracking data structures. Note that
1181      * while the token is not assigned a new owner, the `_ownedTokensIndex` mapping is _not_ updated: this allows for
1182      * gas optimizations e.g. when performing a transfer operation (avoiding double writes).
1183      * This has O(1) time complexity, but alters the order of the _ownedTokens array.
1184      * @param from address representing the previous owner of the given token ID
1185      * @param tokenId uint256 ID of the token to be removed from the tokens list of the given address
1186      */
1187     function _removeTokenFromOwnerEnumeration(address from, uint256 tokenId) private {
1188         // To prevent a gap in from's tokens array, we store the last token in the index of the token to delete, and
1189         // then delete the last slot (swap and pop).
1190 
1191         uint256 lastTokenIndex = ERC721.balanceOf(from) - 1;
1192         uint256 tokenIndex = _ownedTokensIndex[tokenId];
1193 
1194         // When the token to delete is the last token, the swap operation is unnecessary
1195         if (tokenIndex != lastTokenIndex) {
1196             uint256 lastTokenId = _ownedTokens[from][lastTokenIndex];
1197 
1198             _ownedTokens[from][tokenIndex] = lastTokenId; // Move the last token to the slot of the to-delete token
1199             _ownedTokensIndex[lastTokenId] = tokenIndex; // Update the moved token's index
1200         }
1201 
1202         // This also deletes the contents at the last position of the array
1203         delete _ownedTokensIndex[tokenId];
1204         delete _ownedTokens[from][lastTokenIndex];
1205     }
1206 
1207     /**
1208      * @dev Private function to remove a token from this extension's token tracking data structures.
1209      * This has O(1) time complexity, but alters the order of the _allTokens array.
1210      * @param tokenId uint256 ID of the token to be removed from the tokens list
1211      */
1212     function _removeTokenFromAllTokensEnumeration(uint256 tokenId) private {
1213         // To prevent a gap in the tokens array, we store the last token in the index of the token to delete, and
1214         // then delete the last slot (swap and pop).
1215 
1216         uint256 lastTokenIndex = _allTokens.length - 1;
1217         uint256 tokenIndex = _allTokensIndex[tokenId];
1218 
1219         // When the token to delete is the last token, the swap operation is unnecessary. However, since this occurs so
1220         // rarely (when the last minted token is burnt) that we still do the swap here to avoid the gas cost of adding
1221         // an 'if' statement (like in _removeTokenFromOwnerEnumeration)
1222         uint256 lastTokenId = _allTokens[lastTokenIndex];
1223 
1224         _allTokens[tokenIndex] = lastTokenId; // Move the last token to the slot of the to-delete token
1225         _allTokensIndex[lastTokenId] = tokenIndex; // Update the moved token's index
1226 
1227         // This also deletes the contents at the last position of the array
1228         delete _allTokensIndex[tokenId];
1229         _allTokens.pop();
1230     }
1231 }
1232 
1233 
1234 // File contracts/SecurityOrcas.sol
1235 
1236 // SPDX-License-Identifier: MIT
1237 
1238 /*
1239                                           «∩ⁿ─╖
1240                                        ⌐  ╦╠Σ▌╓┴                        .⌐─≈-,
1241                                 ≤╠╠╠╫╕╬╦╜              ┌"░░░░░░░░░░≈╖φ░╔╦╬░░Σ╜^
1242                                ¼,╠.:╬╬╦╖╔≡p               "╙φ░ ╠╩╚`  ░╩░╟╓╜
1243                                    Γ╠▀╬═┘`                         Θ Å░▄
1244                       ,,,,,        ┌#                             ]  ▌░░╕
1245              ,-─S╜" ,⌐"",`░░φ░░░░S>╫▐                             ╩  ░░░░¼
1246             ╙ⁿ═s, <░φ╬░░φù ░░░░░░░░╬╠░░"Zw,                    ,─╓φ░Å░░╩╧w¼
1247             ∩²≥┴╝δ»╬░╝░░╩░╓║╙░░░░░░Åφ▄φ░░╦≥░⌠░≥╖,          ,≈"╓φ░░░╬╬░░╕ {⌐\
1248             } ▐      ½,#░░░░░╦╚░░╬╜Σ░p╠░░╬╘░░░░╩  ^"¥7"""░"¬╖╠░░░#▒░░░╩ φ╩ ∩
1249               Γ      ╬░⌐"╢╙φ░░▒╬╓╓░░░░▄▄╬▄░╬░░Å░░░░╠░╦,φ╠░░░░░░-"╠░╩╩  ê░Γ╠
1250              ╘░,,   ╠╬     '░╗Σ╢░░░░░░▀╢▓▒▒╬╬░╦#####≥╨░░░╝╜╙` ,φ╬░░░. é░░╔⌐
1251               ▐░ `^Σ░▒╗,   ▐░░░░░ ▒░"╙Σ░╨▀╜╬░▓▓▓▓▓▓▀▀░»φ░N  ╔╬▒░░░"`,╬≥░░╢
1252                \  ╠░░░░░░╬#╩╣▄░Γ, ▐░,φ╬▄Å` ░ ```"╚░░░░,╓▄▄▄╬▀▀░╠╙░╔╬░░░ ½"
1253                 └ '░░░░░░╦╠ ╟▒M╗▄▄,▄▄▄╗#▒╬▒╠"╙╙╙╙╙╙╢▒▒▓▀▀░░░░░╠╦#░░░░╚,╩
1254                   ¼░░░░░░░⌂╦ ▀░░░╚╙░╚▓▒▀░░░½░░╠╜   ╘▀░░░╩╩╩,▄╣╬░░░░░╙╔╩
1255                     ╢^╙╨╠░░▄æ,Σ ",╓╥m╬░░░░░░░Θ░φ░φ▄ ╬╬░,▄#▒▀░░░░░≥░░#`
1256                       *╓,╙φ░░░░░#░░░░░░░#╬╠╩ ╠╩╚╠╟▓▄╣▒▓╬▓▀░░░░░╩░╓═^
1257                           `"╜╧Σ░░░Σ░░░░░░╬▓µ ─"░░░░░░░░░░╜░╬▄≈"
1258                                     `"╙╜╜╜╝╩ÅΣM≡,`╙╚░╙╙░╜|  ╙╙╙┴7≥╗
1259                                                    `"┴╙¬¬¬┴┴╙╙╙╙""
1260 */
1261 
1262 pragma solidity ^0.8.0;
1263 
1264 
1265 
1266 abstract contract WHALES {
1267     function ownerOf(uint256 tokenId) public view virtual returns (address);
1268     function balanceOf(address owner) public view virtual returns (uint256);
1269 
1270     function tokenOfOwnerByIndex(address owner, uint256 index) public view virtual returns (uint256);
1271 }
1272 
1273 contract SecurityOrcas is ERC721, ERC721Enumerable, Ownable {
1274 
1275     // Removed tokenPrice
1276 
1277     WHALES private whales;
1278     string public PROVENANCE;
1279     bool public saleIsActive = false;
1280     uint256 public MAX_TOKENS = 10000;
1281     uint256 public MAX_MINT = 50;
1282     string private _baseURIextended;
1283 
1284     event PermanentURI(string _value, uint256 indexed _id);
1285 
1286     constructor(address whalesContract) ERC721("SSoW Security Orcas", "SO") {
1287         whales = WHALES(whalesContract);
1288     }
1289 
1290     function _beforeTokenTransfer(address from, address to, uint256 tokenId) internal override(ERC721, ERC721Enumerable) {
1291         super._beforeTokenTransfer(from, to, tokenId);
1292     }
1293 
1294     function supportsInterface(bytes4 interfaceId) public view virtual override(ERC721, ERC721Enumerable) returns (bool) {
1295         return super.supportsInterface(interfaceId);
1296     }
1297 
1298     function setBaseURI(string memory baseURI_) external onlyOwner() {
1299         _baseURIextended = baseURI_;
1300     }
1301 
1302     function _baseURI() internal view virtual override returns (string memory) {
1303         return _baseURIextended;
1304     }
1305 
1306     function setProvenance(string memory provenance) public onlyOwner {
1307         PROVENANCE = provenance;
1308     }
1309 
1310     // Removed reserveTokens
1311 
1312     function flipSaleState() public onlyOwner {
1313         saleIsActive = !saleIsActive;
1314     }
1315 
1316     // TODO: see which costs more gas: mintToken() or mintMultipleTokens(0, 1);
1317     function mintToken(uint256 tokenId) public {
1318         require(saleIsActive, "Sale must be active to mint Security Orcas");
1319         require(totalSupply() < MAX_TOKENS, "Purchase would exceed max supply of tokens");
1320         require(tokenId < MAX_TOKENS, "TokenId does not exist");
1321         require(!_exists(tokenId), "TokenId has already been minted");
1322         require(whales.ownerOf(tokenId) == msg.sender, "Sender does not own the correct Whale token");
1323 
1324         _safeMint(msg.sender, tokenId);
1325     }
1326 
1327     function mintMultipleTokens(uint256 startingIndex, uint256 numberOfTokens) public {
1328         require(saleIsActive, "Sale must be active to mint Security Orcas");
1329         require(numberOfTokens > 0, "Need to mint at least one token");
1330         require(numberOfTokens <= MAX_MINT, "Cannot adopt more than 50 Orcas in one tx");
1331 
1332         require(whales.balanceOf(msg.sender) >= numberOfTokens + startingIndex, "Sender does not own the correct number of Whale tokens");
1333 
1334         for(uint i = 0; i < numberOfTokens; i++) {
1335             require(totalSupply() < MAX_TOKENS, "Cannot exceed max supply of tokens");
1336             uint tokenId = whales.tokenOfOwnerByIndex(msg.sender, i + startingIndex);
1337             if(!_exists(tokenId)) {
1338                 _safeMint(msg.sender, tokenId);
1339             }
1340         }
1341     }
1342 
1343     function withdraw() public onlyOwner {
1344         uint balance = address(this).balance;
1345         payable(msg.sender).transfer(balance);
1346     }
1347 
1348     function markPermanentURI(string memory value, uint256 id) public onlyOwner {
1349         emit PermanentURI(value, id);
1350     }
1351 }