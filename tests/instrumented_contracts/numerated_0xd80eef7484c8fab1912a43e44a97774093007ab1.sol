1 // File @openzeppelin/contracts/utils/introspection/IERC165.sol@v4.3.1
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
27 // File @openzeppelin/contracts/token/ERC721/IERC721.sol@v4.3.1
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
169 // File @openzeppelin/contracts/token/ERC721/IERC721Receiver.sol@v4.3.1
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
197 // File @openzeppelin/contracts/token/ERC721/extensions/IERC721Metadata.sol@v4.3.1
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
223 // File @openzeppelin/contracts/utils/Address.sol@v4.3.1
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
441 // File @openzeppelin/contracts/utils/Context.sol@v4.3.1
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
466 // File @openzeppelin/contracts/utils/Strings.sol@v4.3.1
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
534 // File @openzeppelin/contracts/utils/introspection/ERC165.sol@v4.3.1
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
562 // File @openzeppelin/contracts/token/ERC721/ERC721.sol@v4.3.1
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
973 
974 // File @openzeppelin/contracts/access/Ownable.sol@v4.3.1
975 
976 pragma solidity ^0.8.0;
977 
978 /**
979  * @dev Contract module which provides a basic access control mechanism, where
980  * there is an account (an owner) that can be granted exclusive access to
981  * specific functions.
982  *
983  * By default, the owner account will be the one that deploys the contract. This
984  * can later be changed with {transferOwnership}.
985  *
986  * This module is used through inheritance. It will make available the modifier
987  * `onlyOwner`, which can be applied to your functions to restrict their use to
988  * the owner.
989  */
990 abstract contract Ownable is Context {
991     address private _owner;
992 
993     event OwnershipTransferred(address indexed previousOwner, address indexed newOwner);
994 
995     /**
996      * @dev Initializes the contract setting the deployer as the initial owner.
997      */
998     constructor() {
999         _setOwner(_msgSender());
1000     }
1001 
1002     /**
1003      * @dev Returns the address of the current owner.
1004      */
1005     function owner() public view virtual returns (address) {
1006         return _owner;
1007     }
1008 
1009     /**
1010      * @dev Throws if called by any account other than the owner.
1011      */
1012     modifier onlyOwner() {
1013         require(owner() == _msgSender(), "Ownable: caller is not the owner");
1014         _;
1015     }
1016 
1017     /**
1018      * @dev Leaves the contract without owner. It will not be possible to call
1019      * `onlyOwner` functions anymore. Can only be called by the current owner.
1020      *
1021      * NOTE: Renouncing ownership will leave the contract without an owner,
1022      * thereby removing any functionality that is only available to the owner.
1023      */
1024     function renounceOwnership() public virtual onlyOwner {
1025         _setOwner(address(0));
1026     }
1027 
1028     /**
1029      * @dev Transfers ownership of the contract to a new account (`newOwner`).
1030      * Can only be called by the current owner.
1031      */
1032     function transferOwnership(address newOwner) public virtual onlyOwner {
1033         require(newOwner != address(0), "Ownable: new owner is the zero address");
1034         _setOwner(newOwner);
1035     }
1036 
1037     function _setOwner(address newOwner) private {
1038         address oldOwner = _owner;
1039         _owner = newOwner;
1040         emit OwnershipTransferred(oldOwner, newOwner);
1041     }
1042 }
1043 
1044 
1045 // File @openzeppelin/contracts/utils/Counters.sol@v4.3.1
1046 
1047 pragma solidity ^0.8.0;
1048 
1049 /**
1050  * @title Counters
1051  * @author Matt Condon (@shrugs)
1052  * @dev Provides counters that can only be incremented, decremented or reset. This can be used e.g. to track the number
1053  * of elements in a mapping, issuing ERC721 ids, or counting request ids.
1054  *
1055  * Include with `using Counters for Counters.Counter;`
1056  */
1057 library Counters {
1058     struct Counter {
1059         // This variable should never be directly accessed by users of the library: interactions must be restricted to
1060         // the library's function. As of Solidity v0.5.2, this cannot be enforced, though there is a proposal to add
1061         // this feature: see https://github.com/ethereum/solidity/issues/4637
1062         uint256 _value; // default: 0
1063     }
1064 
1065     function current(Counter storage counter) internal view returns (uint256) {
1066         return counter._value;
1067     }
1068 
1069     function increment(Counter storage counter) internal {
1070         unchecked {
1071             counter._value += 1;
1072         }
1073     }
1074 
1075     function decrement(Counter storage counter) internal {
1076         uint256 value = counter._value;
1077         require(value > 0, "Counter: decrement overflow");
1078         unchecked {
1079             counter._value = value - 1;
1080         }
1081     }
1082 
1083     function reset(Counter storage counter) internal {
1084         counter._value = 0;
1085     }
1086 }
1087 
1088 
1089 // File @openzeppelin/contracts/utils/structs/BitMaps.sol@v4.3.1
1090 pragma solidity ^0.8.0;
1091 
1092 /**
1093  * @dev Library for managing uint256 to bool mapping in a compact and efficient way, providing the keys are sequential.
1094  * Largelly inspired by Uniswap's https://github.com/Uniswap/merkle-distributor/blob/master/contracts/MerkleDistributor.sol[merkle-distributor].
1095  */
1096 library BitMaps {
1097     struct BitMap {
1098         mapping(uint256 => uint256) _data;
1099     }
1100 
1101     /**
1102      * @dev Returns whether the bit at `index` is set.
1103      */
1104     function get(BitMap storage bitmap, uint256 index) internal view returns (bool) {
1105         uint256 bucket = index >> 8;
1106         uint256 mask = 1 << (index & 0xff);
1107         return bitmap._data[bucket] & mask != 0;
1108     }
1109 
1110     /**
1111      * @dev Sets the bit at `index` to the boolean `value`.
1112      */
1113     function setTo(
1114         BitMap storage bitmap,
1115         uint256 index,
1116         bool value
1117     ) internal {
1118         if (value) {
1119             set(bitmap, index);
1120         } else {
1121             unset(bitmap, index);
1122         }
1123     }
1124 
1125     /**
1126      * @dev Sets the bit at `index`.
1127      */
1128     function set(BitMap storage bitmap, uint256 index) internal {
1129         uint256 bucket = index >> 8;
1130         uint256 mask = 1 << (index & 0xff);
1131         bitmap._data[bucket] |= mask;
1132     }
1133 
1134     /**
1135      * @dev Unsets the bit at `index`.
1136      */
1137     function unset(BitMap storage bitmap, uint256 index) internal {
1138         uint256 bucket = index >> 8;
1139         uint256 mask = 1 << (index & 0xff);
1140         bitmap._data[bucket] &= ~mask;
1141     }
1142 }
1143 
1144 
1145 // File @openzeppelin/contracts/token/ERC721/extensions/IERC721Enumerable.sol@v4.3.1
1146 
1147 pragma solidity ^0.8.0;
1148 
1149 /**
1150  * @title ERC-721 Non-Fungible Token Standard, optional enumeration extension
1151  * @dev See https://eips.ethereum.org/EIPS/eip-721
1152  */
1153 interface IERC721Enumerable is IERC721 {
1154     /**
1155      * @dev Returns the total amount of tokens stored by the contract.
1156      */
1157     function totalSupply() external view returns (uint256);
1158 
1159     /**
1160      * @dev Returns a token ID owned by `owner` at a given `index` of its token list.
1161      * Use along with {balanceOf} to enumerate all of ``owner``'s tokens.
1162      */
1163     function tokenOfOwnerByIndex(address owner, uint256 index) external view returns (uint256 tokenId);
1164 
1165     /**
1166      * @dev Returns a token ID at a given `index` of all the tokens stored by the contract.
1167      * Use along with {totalSupply} to enumerate all tokens.
1168      */
1169     function tokenByIndex(uint256 index) external view returns (uint256);
1170 }
1171 
1172 
1173 // File @openzeppelin/contracts/token/ERC721/extensions/ERC721Enumerable.sol@v4.3.1
1174 
1175 pragma solidity ^0.8.0;
1176 
1177 
1178 /**
1179  * @dev This implements an optional extension of {ERC721} defined in the EIP that adds
1180  * enumerability of all the token ids in the contract as well as all token ids owned by each
1181  * account.
1182  */
1183 abstract contract ERC721Enumerable is ERC721, IERC721Enumerable {
1184     // Mapping from owner to list of owned token IDs
1185     mapping(address => mapping(uint256 => uint256)) private _ownedTokens;
1186 
1187     // Mapping from token ID to index of the owner tokens list
1188     mapping(uint256 => uint256) private _ownedTokensIndex;
1189 
1190     // Array with all token ids, used for enumeration
1191     uint256[] private _allTokens;
1192 
1193     // Mapping from token id to position in the allTokens array
1194     mapping(uint256 => uint256) private _allTokensIndex;
1195 
1196     /**
1197      * @dev See {IERC165-supportsInterface}.
1198      */
1199     function supportsInterface(bytes4 interfaceId) public view virtual override(IERC165, ERC721) returns (bool) {
1200         return interfaceId == type(IERC721Enumerable).interfaceId || super.supportsInterface(interfaceId);
1201     }
1202 
1203     /**
1204      * @dev See {IERC721Enumerable-tokenOfOwnerByIndex}.
1205      */
1206     function tokenOfOwnerByIndex(address owner, uint256 index) public view virtual override returns (uint256) {
1207         require(index < ERC721.balanceOf(owner), "ERC721Enumerable: owner index out of bounds");
1208         return _ownedTokens[owner][index];
1209     }
1210 
1211     /**
1212      * @dev See {IERC721Enumerable-totalSupply}.
1213      */
1214     function totalSupply() public view virtual override returns (uint256) {
1215         return _allTokens.length;
1216     }
1217 
1218     /**
1219      * @dev See {IERC721Enumerable-tokenByIndex}.
1220      */
1221     function tokenByIndex(uint256 index) public view virtual override returns (uint256) {
1222         require(index < ERC721Enumerable.totalSupply(), "ERC721Enumerable: global index out of bounds");
1223         return _allTokens[index];
1224     }
1225 
1226     /**
1227      * @dev Hook that is called before any token transfer. This includes minting
1228      * and burning.
1229      *
1230      * Calling conditions:
1231      *
1232      * - When `from` and `to` are both non-zero, ``from``'s `tokenId` will be
1233      * transferred to `to`.
1234      * - When `from` is zero, `tokenId` will be minted for `to`.
1235      * - When `to` is zero, ``from``'s `tokenId` will be burned.
1236      * - `from` cannot be the zero address.
1237      * - `to` cannot be the zero address.
1238      *
1239      * To learn more about hooks, head to xref:ROOT:extending-contracts.adoc#using-hooks[Using Hooks].
1240      */
1241     function _beforeTokenTransfer(
1242         address from,
1243         address to,
1244         uint256 tokenId
1245     ) internal virtual override {
1246         super._beforeTokenTransfer(from, to, tokenId);
1247 
1248         if (from == address(0)) {
1249             _addTokenToAllTokensEnumeration(tokenId);
1250         } else if (from != to) {
1251             _removeTokenFromOwnerEnumeration(from, tokenId);
1252         }
1253         if (to == address(0)) {
1254             _removeTokenFromAllTokensEnumeration(tokenId);
1255         } else if (to != from) {
1256             _addTokenToOwnerEnumeration(to, tokenId);
1257         }
1258     }
1259 
1260     /**
1261      * @dev Private function to add a token to this extension's ownership-tracking data structures.
1262      * @param to address representing the new owner of the given token ID
1263      * @param tokenId uint256 ID of the token to be added to the tokens list of the given address
1264      */
1265     function _addTokenToOwnerEnumeration(address to, uint256 tokenId) private {
1266         uint256 length = ERC721.balanceOf(to);
1267         _ownedTokens[to][length] = tokenId;
1268         _ownedTokensIndex[tokenId] = length;
1269     }
1270 
1271     /**
1272      * @dev Private function to add a token to this extension's token tracking data structures.
1273      * @param tokenId uint256 ID of the token to be added to the tokens list
1274      */
1275     function _addTokenToAllTokensEnumeration(uint256 tokenId) private {
1276         _allTokensIndex[tokenId] = _allTokens.length;
1277         _allTokens.push(tokenId);
1278     }
1279 
1280     /**
1281      * @dev Private function to remove a token from this extension's ownership-tracking data structures. Note that
1282      * while the token is not assigned a new owner, the `_ownedTokensIndex` mapping is _not_ updated: this allows for
1283      * gas optimizations e.g. when performing a transfer operation (avoiding double writes).
1284      * This has O(1) time complexity, but alters the order of the _ownedTokens array.
1285      * @param from address representing the previous owner of the given token ID
1286      * @param tokenId uint256 ID of the token to be removed from the tokens list of the given address
1287      */
1288     function _removeTokenFromOwnerEnumeration(address from, uint256 tokenId) private {
1289         // To prevent a gap in from's tokens array, we store the last token in the index of the token to delete, and
1290         // then delete the last slot (swap and pop).
1291 
1292         uint256 lastTokenIndex = ERC721.balanceOf(from) - 1;
1293         uint256 tokenIndex = _ownedTokensIndex[tokenId];
1294 
1295         // When the token to delete is the last token, the swap operation is unnecessary
1296         if (tokenIndex != lastTokenIndex) {
1297             uint256 lastTokenId = _ownedTokens[from][lastTokenIndex];
1298 
1299             _ownedTokens[from][tokenIndex] = lastTokenId; // Move the last token to the slot of the to-delete token
1300             _ownedTokensIndex[lastTokenId] = tokenIndex; // Update the moved token's index
1301         }
1302 
1303         // This also deletes the contents at the last position of the array
1304         delete _ownedTokensIndex[tokenId];
1305         delete _ownedTokens[from][lastTokenIndex];
1306     }
1307 
1308     /**
1309      * @dev Private function to remove a token from this extension's token tracking data structures.
1310      * This has O(1) time complexity, but alters the order of the _allTokens array.
1311      * @param tokenId uint256 ID of the token to be removed from the tokens list
1312      */
1313     function _removeTokenFromAllTokensEnumeration(uint256 tokenId) private {
1314         // To prevent a gap in the tokens array, we store the last token in the index of the token to delete, and
1315         // then delete the last slot (swap and pop).
1316 
1317         uint256 lastTokenIndex = _allTokens.length - 1;
1318         uint256 tokenIndex = _allTokensIndex[tokenId];
1319 
1320         // When the token to delete is the last token, the swap operation is unnecessary. However, since this occurs so
1321         // rarely (when the last minted token is burnt) that we still do the swap here to avoid the gas cost of adding
1322         // an 'if' statement (like in _removeTokenFromOwnerEnumeration)
1323         uint256 lastTokenId = _allTokens[lastTokenIndex];
1324 
1325         _allTokens[tokenIndex] = lastTokenId; // Move the last token to the slot of the to-delete token
1326         _allTokensIndex[lastTokenId] = tokenIndex; // Update the moved token's index
1327 
1328         // This also deletes the contents at the last position of the array
1329         delete _allTokensIndex[tokenId];
1330         _allTokens.pop();
1331     }
1332 }
1333 
1334 // File contracts/LazyLionsBungalows.sol
1335 pragma solidity ^0.8.0;
1336 
1337 contract LazyLionsBungalows is Ownable, ERC721Enumerable {
1338 
1339     using Counters for Counters.Counter;
1340     using Strings for uint256;
1341 
1342     // Private fields
1343     Counters.Counter private _tokenIds;
1344 
1345     // Public constants
1346     uint256 public constant BUYABLE_SUPPLY = 1500;
1347     uint256 public constant MAX_NFTS = 11600;
1348 
1349     // Real 0x8943C7bAC1914C9A7ABa750Bf2B6B09Fd21037E0
1350     address public constant LAZY_LIONS = 0x8943C7bAC1914C9A7ABa750Bf2B6B09Fd21037E0;
1351 
1352     uint256 public startingIndexBlock;
1353 
1354     uint256 public startingIndex;
1355     // Public fields
1356     bool public open = false;
1357 
1358     bool public openFree = false;
1359 
1360     string public bungalow_provenance = "";
1361 
1362     string public provenanceURI = "";
1363 
1364     bool public locked = false;
1365 
1366     uint256 public mintPrice = 0.3 ether;
1367 
1368     uint256 public mintAmount = 5;
1369 
1370     uint256 public bungalowReserve = 100;
1371 
1372     uint256 public bought = 0;
1373 
1374     string public baseURI = "";
1375 
1376     uint256 public REVEAL_TIMESTAMP;
1377 
1378     mapping(uint256 => bool) public seen;
1379 
1380     struct Frame {
1381         IERC721 external_nft;
1382         uint256 tokenId;
1383     }
1384     mapping(uint256 => mapping(uint256 => Frame)) public frames;
1385     
1386     modifier notLocked() {
1387         require(!locked, "Contract has been locked");
1388         _;
1389     }
1390 
1391     constructor() ERC721("Lazy Lions Bungalows", "BUNGALOW") {
1392         REVEAL_TIMESTAMP = block.timestamp;
1393     }
1394 
1395     function mint(uint256 quantity) public payable {
1396         require(open, "Drop not open yet");
1397         require(quantity > 0, "Quantity must be at least 1");
1398         require(BUYABLE_SUPPLY > bought, "Sold Out");
1399 
1400         if (quantity > mintAmount) {
1401             quantity = mintAmount;
1402         }
1403 
1404         if (quantity + bought > BUYABLE_SUPPLY) {
1405             quantity = BUYABLE_SUPPLY - bought;
1406         }
1407 
1408 
1409 
1410         uint256 price = getPrice(quantity);
1411 
1412         require(msg.value >= price, "Not enough ETH sent");
1413 
1414         for (uint256 i = 0; i < quantity; i++) {
1415             _mintInternal(msg.sender);
1416         }
1417 
1418         bought += quantity;
1419 
1420         uint256 remaining = msg.value - price;
1421 
1422         if (remaining > 0) {
1423             (bool success, ) = msg.sender.call{value: remaining}("");
1424             require(success);
1425         }
1426 
1427 
1428         if (startingIndexBlock == 0 && (bought == BUYABLE_SUPPLY || block.timestamp >= REVEAL_TIMESTAMP)) {
1429             startingIndexBlock = block.number;
1430         }
1431     }
1432 
1433     function mintFree() public {
1434         require(openFree, "Drop not open yet");
1435         ERC721Enumerable nfts = ERC721Enumerable(LAZY_LIONS);
1436         uint256 numNFTs = nfts.balanceOf(msg.sender);
1437         for (uint256 i = 0; i < numNFTs; i++) {
1438             uint256 nftId = nfts.tokenOfOwnerByIndex(msg.sender, i);
1439             if (seen[nftId]) {
1440                 continue;
1441             }
1442             seen[nftId] = true;
1443             _mintInternal(msg.sender);
1444         }
1445     }
1446     function mintFreeOne() public {
1447         require(openFree, "Drop not open yet");
1448 
1449         ERC721Enumerable nfts = ERC721Enumerable(LAZY_LIONS);
1450         uint256 numNFTs = nfts.balanceOf(msg.sender);
1451         for (uint256 i = 0; i < numNFTs; i++) {
1452             uint256 nftId = nfts.tokenOfOwnerByIndex(msg.sender, i);
1453             if (seen[nftId]) {
1454                 continue;
1455             }
1456             seen[nftId] = true;
1457             i = i+numNFTs;
1458             _mintInternal(msg.sender);
1459         }
1460     }
1461 
1462     function mintFreeSome(uint256 _indexStart, uint256 _indexEnd) public {
1463         require(openFree, "Drop not open yet");
1464 
1465         ERC721Enumerable nfts = ERC721Enumerable(LAZY_LIONS);
1466         uint256 numNFTs = nfts.balanceOf(msg.sender);
1467         require(_indexEnd < numNFTs, "Not Enough Lions");
1468         for (uint256 i = _indexStart; i <= _indexEnd; i++) {
1469             uint256 nftId = nfts.tokenOfOwnerByIndex(msg.sender, i);
1470             if (seen[nftId]) {
1471                 continue;
1472             }
1473             seen[nftId] = true;
1474             _mintInternal(msg.sender);
1475         }
1476     }
1477     function freeMints(address owner) external view returns (uint256) {
1478         uint256 total = 0;
1479         ERC721Enumerable nfts = ERC721Enumerable(LAZY_LIONS);
1480         uint256 numNFTs = nfts.balanceOf(owner);
1481         for (uint256 i = 0; i < numNFTs; i++) {
1482             uint256 nftId = nfts.tokenOfOwnerByIndex(owner, i);
1483             if (seen[nftId]) {
1484                 continue;
1485             }
1486             total += 1;
1487         }
1488         return total;
1489     }
1490 
1491 
1492     function getPrice(uint256 quantity) public view returns (uint256) {
1493         require(quantity <= BUYABLE_SUPPLY);
1494         return quantity*mintPrice;
1495     }
1496 
1497     function tokenURI(uint256 tokenId)
1498         public
1499         view
1500         virtual
1501         override
1502         returns (string memory)
1503     {
1504         require(
1505             tokenId < totalSupply(),
1506             "URI query for nonexistent token"
1507         );
1508         return string(abi.encodePacked(baseURI, tokenId.toString()));
1509     }
1510     function tokensOfOwner(address _owner)
1511         external
1512         view
1513         returns (uint256[] memory)
1514     {
1515         uint256 tokenCount = balanceOf(_owner);
1516         if (tokenCount == 0) {
1517             return new uint256[](0);
1518         } else {
1519             uint256[] memory result = new uint256[](tokenCount);
1520             uint256 index;
1521             for (index =0; index < tokenCount; index++) {
1522                 result[index] = tokenOfOwnerByIndex(_owner, index);
1523             }
1524             return result;
1525         }
1526     }
1527     function setFrame(IERC721 _external_nft, uint256 _content, uint256 _bungalow, uint256 _frame_index)
1528         external
1529     {
1530         require(msg.sender == ownerOf(_bungalow), "Must Own bungalow to Set Frames");
1531         require(_frame_index < 3, "Ran out of frames");
1532         //IERC721 external_nft = IERC721(_nft);
1533         require(msg.sender == _external_nft.ownerOf(_content), "Must own content");
1534         frames[_bungalow][_frame_index] = Frame(_external_nft, _content);
1535 
1536     }
1537 
1538     function getFrames(uint256 _tokenId) external view returns (Frame[3] memory)
1539     {
1540         Frame[3] memory results = [frames[_tokenId][0], frames[_tokenId][1], frames[_tokenId][2]];
1541         return results;
1542     }
1543     
1544 
1545     function reserveBungalows(address _to, uint256 _reserveAmount) public onlyOwner {
1546         require(_reserveAmount > 0 && _reserveAmount <= bungalowReserve, "Not Enough reserves left for team");
1547         for (uint256 i = 0; i < _reserveAmount; i++) {
1548             _mintInternal(_to);
1549         }
1550         bungalowReserve = bungalowReserve - _reserveAmount;
1551     }
1552 
1553     function setMintAmount(uint256 amount) external onlyOwner {
1554         mintAmount = amount;
1555     }
1556 
1557     function setMintPrice(uint256 price) external onlyOwner {
1558         mintPrice = price;
1559     }
1560 
1561     function setOpen(bool shouldOpen) external onlyOwner {
1562         open = shouldOpen;
1563     }
1564 
1565     function setOpenFree(bool shouldOpen) external onlyOwner {
1566         openFree = shouldOpen;
1567     }
1568 
1569     function setBaseURI(string memory newBaseURI) external onlyOwner notLocked {
1570         baseURI = newBaseURI;
1571     }
1572 
1573     function setProvenanceURI(string memory _provenanceURI)
1574         external
1575         onlyOwner
1576         notLocked
1577     {
1578         provenanceURI = _provenanceURI;
1579     }
1580 
1581     function setProvenance(string memory _provenance)
1582         external
1583         onlyOwner
1584         notLocked
1585     {
1586         bungalow_provenance = _provenance;
1587     }
1588 
1589     function setRevealTimestamp(uint256 revealTimeStamp) public onlyOwner {
1590         REVEAL_TIMESTAMP = revealTimeStamp;
1591     } 
1592 
1593 
1594 
1595     function lock() external onlyOwner {
1596         locked = true;
1597     }
1598 
1599     function withdraw() public onlyOwner {
1600         uint256 balance = address(this).balance;
1601         (bool success, ) = msg.sender.call{value: balance}("");
1602         require(success);
1603     }
1604 
1605     function partialWithdraw(uint256 _amount, address payable _to) external onlyOwner {
1606         require(_amount > 0, "Withdraw Must be greater than 0");
1607         require(_amount <= address(this).balance, "Amount too high");
1608         (bool success, ) = _to.call{value: _amount}("");
1609         require(success);
1610     }
1611 
1612 
1613     function _mintInternal(address owner) private {
1614         uint256 newItemId = _tokenIds.current();
1615         _safeMint(owner, newItemId);
1616         _tokenIds.increment();
1617     }
1618 
1619 
1620     function setStartingIndex() public {
1621         require(startingIndex == 0, "Starting index is already set");
1622         require(startingIndexBlock != 0, "Starting index block must be set");
1623         
1624         startingIndex = uint(blockhash(startingIndexBlock)) % MAX_NFTS;
1625 
1626         if (block.number - startingIndexBlock > 255) {
1627             startingIndex = uint(blockhash(block.number - 1)) % MAX_NFTS;
1628         }
1629 
1630         if (startingIndex == 0) {
1631             startingIndex = startingIndex + 1;
1632         }
1633     }
1634 
1635 
1636     function emergencySetStartingIndexBlock() public onlyOwner {
1637         require(startingIndex == 0, "Starting index is already set");
1638         
1639         startingIndexBlock = block.number;
1640     }
1641 }