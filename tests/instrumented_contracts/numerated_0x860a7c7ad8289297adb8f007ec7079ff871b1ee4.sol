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
567 /**
568  * @dev Implementation of https://eips.ethereum.org/EIPS/eip-721[ERC721] Non-Fungible Token Standard, including
569  * the Metadata extension, but not including the Enumerable extension, which is available separately as
570  * {ERC721Enumerable}.
571  */
572 contract ERC721 is Context, ERC165, IERC721, IERC721Metadata {
573     using Address for address;
574     using Strings for uint256;
575 
576     // Token name
577     string private _name;
578 
579     // Token symbol
580     string private _symbol;
581 
582     // Mapping from token ID to owner address
583     mapping(uint256 => address) private _owners;
584 
585     // Mapping owner address to token count
586     mapping(address => uint256) private _balances;
587 
588     // Mapping from token ID to approved address
589     mapping(uint256 => address) private _tokenApprovals;
590 
591     // Mapping from owner to operator approvals
592     mapping(address => mapping(address => bool)) private _operatorApprovals;
593 
594     /**
595      * @dev Initializes the contract by setting a `name` and a `symbol` to the token collection.
596      */
597     constructor(string memory name_, string memory symbol_) {
598         _name = name_;
599         _symbol = symbol_;
600     }
601 
602     /**
603      * @dev See {IERC165-supportsInterface}.
604      */
605     function supportsInterface(bytes4 interfaceId) public view virtual override(ERC165, IERC165) returns (bool) {
606         return
607             interfaceId == type(IERC721).interfaceId ||
608             interfaceId == type(IERC721Metadata).interfaceId ||
609             super.supportsInterface(interfaceId);
610     }
611 
612     /**
613      * @dev See {IERC721-balanceOf}.
614      */
615     function balanceOf(address owner) public view virtual override returns (uint256) {
616         require(owner != address(0), "ERC721: balance query for the zero address");
617         return _balances[owner];
618     }
619 
620     /**
621      * @dev See {IERC721-ownerOf}.
622      */
623     function ownerOf(uint256 tokenId) public view virtual override returns (address) {
624         address owner = _owners[tokenId];
625         require(owner != address(0), "ERC721: owner query for nonexistent token");
626         return owner;
627     }
628 
629     /**
630      * @dev See {IERC721Metadata-name}.
631      */
632     function name() public view virtual override returns (string memory) {
633         return _name;
634     }
635 
636     /**
637      * @dev See {IERC721Metadata-symbol}.
638      */
639     function symbol() public view virtual override returns (string memory) {
640         return _symbol;
641     }
642 
643     /**
644      * @dev See {IERC721Metadata-tokenURI}.
645      */
646     function tokenURI(uint256 tokenId) public view virtual override returns (string memory) {
647         require(_exists(tokenId), "ERC721Metadata: URI query for nonexistent token");
648 
649         string memory baseURI = _baseURI();
650         return bytes(baseURI).length > 0 ? string(abi.encodePacked(baseURI, tokenId.toString())) : "";
651     }
652 
653     /**
654      * @dev Base URI for computing {tokenURI}. If set, the resulting URI for each
655      * token will be the concatenation of the `baseURI` and the `tokenId`. Empty
656      * by default, can be overriden in child contracts.
657      */
658     function _baseURI() internal view virtual returns (string memory) {
659         return "";
660     }
661 
662     /**
663      * @dev See {IERC721-approve}.
664      */
665     function approve(address to, uint256 tokenId) public virtual override {
666         address owner = ERC721.ownerOf(tokenId);
667         require(to != owner, "ERC721: approval to current owner");
668 
669         require(
670             _msgSender() == owner || isApprovedForAll(owner, _msgSender()),
671             "ERC721: approve caller is not owner nor approved for all"
672         );
673 
674         _approve(to, tokenId);
675     }
676 
677     /**
678      * @dev See {IERC721-getApproved}.
679      */
680     function getApproved(uint256 tokenId) public view virtual override returns (address) {
681         require(_exists(tokenId), "ERC721: approved query for nonexistent token");
682 
683         return _tokenApprovals[tokenId];
684     }
685 
686     /**
687      * @dev See {IERC721-setApprovalForAll}.
688      */
689     function setApprovalForAll(address operator, bool approved) public virtual override {
690         require(operator != _msgSender(), "ERC721: approve to caller");
691 
692         _operatorApprovals[_msgSender()][operator] = approved;
693         emit ApprovalForAll(_msgSender(), operator, approved);
694     }
695 
696     /**
697      * @dev See {IERC721-isApprovedForAll}.
698      */
699     function isApprovedForAll(address owner, address operator) public view virtual override returns (bool) {
700         return _operatorApprovals[owner][operator];
701     }
702 
703     /**
704      * @dev See {IERC721-transferFrom}.
705      */
706     function transferFrom(
707         address from,
708         address to,
709         uint256 tokenId
710     ) public virtual override {
711         //solhint-disable-next-line max-line-length
712         require(_isApprovedOrOwner(_msgSender(), tokenId), "ERC721: transfer caller is not owner nor approved");
713 
714         _transfer(from, to, tokenId);
715     }
716 
717     /**
718      * @dev See {IERC721-safeTransferFrom}.
719      */
720     function safeTransferFrom(
721         address from,
722         address to,
723         uint256 tokenId
724     ) public virtual override {
725         safeTransferFrom(from, to, tokenId, "");
726     }
727 
728     /**
729      * @dev See {IERC721-safeTransferFrom}.
730      */
731     function safeTransferFrom(
732         address from,
733         address to,
734         uint256 tokenId,
735         bytes memory _data
736     ) public virtual override {
737         require(_isApprovedOrOwner(_msgSender(), tokenId), "ERC721: transfer caller is not owner nor approved");
738         _safeTransfer(from, to, tokenId, _data);
739     }
740 
741     /**
742      * @dev Safely transfers `tokenId` token from `from` to `to`, checking first that contract recipients
743      * are aware of the ERC721 protocol to prevent tokens from being forever locked.
744      *
745      * `_data` is additional data, it has no specified format and it is sent in call to `to`.
746      *
747      * This internal function is equivalent to {safeTransferFrom}, and can be used to e.g.
748      * implement alternative mechanisms to perform token transfer, such as signature-based.
749      *
750      * Requirements:
751      *
752      * - `from` cannot be the zero address.
753      * - `to` cannot be the zero address.
754      * - `tokenId` token must exist and be owned by `from`.
755      * - If `to` refers to a smart contract, it must implement {IERC721Receiver-onERC721Received}, which is called upon a safe transfer.
756      *
757      * Emits a {Transfer} event.
758      */
759     function _safeTransfer(
760         address from,
761         address to,
762         uint256 tokenId,
763         bytes memory _data
764     ) internal virtual {
765         _transfer(from, to, tokenId);
766         require(_checkOnERC721Received(from, to, tokenId, _data), "ERC721: transfer to non ERC721Receiver implementer");
767     }
768 
769     /**
770      * @dev Returns whether `tokenId` exists.
771      *
772      * Tokens can be managed by their owner or approved accounts via {approve} or {setApprovalForAll}.
773      *
774      * Tokens start existing when they are minted (`_mint`),
775      * and stop existing when they are burned (`_burn`).
776      */
777     function _exists(uint256 tokenId) internal view virtual returns (bool) {
778         return _owners[tokenId] != address(0);
779     }
780 
781     /**
782      * @dev Returns whether `spender` is allowed to manage `tokenId`.
783      *
784      * Requirements:
785      *
786      * - `tokenId` must exist.
787      */
788     function _isApprovedOrOwner(address spender, uint256 tokenId) internal view virtual returns (bool) {
789         require(_exists(tokenId), "ERC721: operator query for nonexistent token");
790         address owner = ERC721.ownerOf(tokenId);
791         return (spender == owner || getApproved(tokenId) == spender || isApprovedForAll(owner, spender));
792     }
793 
794     /**
795      * @dev Safely mints `tokenId` and transfers it to `to`.
796      *
797      * Requirements:
798      *
799      * - `tokenId` must not exist.
800      * - If `to` refers to a smart contract, it must implement {IERC721Receiver-onERC721Received}, which is called upon a safe transfer.
801      *
802      * Emits a {Transfer} event.
803      */
804     function _safeMint(address to, uint256 tokenId) internal virtual {
805         _safeMint(to, tokenId, "");
806     }
807 
808     /**
809      * @dev Same as {xref-ERC721-_safeMint-address-uint256-}[`_safeMint`], with an additional `data` parameter which is
810      * forwarded in {IERC721Receiver-onERC721Received} to contract recipients.
811      */
812     function _safeMint(
813         address to,
814         uint256 tokenId,
815         bytes memory _data
816     ) internal virtual {
817         _mint(to, tokenId);
818         require(
819             _checkOnERC721Received(address(0), to, tokenId, _data),
820             "ERC721: transfer to non ERC721Receiver implementer"
821         );
822     }
823 
824     /**
825      * @dev Mints `tokenId` and transfers it to `to`.
826      *
827      * WARNING: Usage of this method is discouraged, use {_safeMint} whenever possible
828      *
829      * Requirements:
830      *
831      * - `tokenId` must not exist.
832      * - `to` cannot be the zero address.
833      *
834      * Emits a {Transfer} event.
835      */
836     function _mint(address to, uint256 tokenId) internal virtual {
837         require(to != address(0), "ERC721: mint to the zero address");
838         require(!_exists(tokenId), "ERC721: token already minted");
839 
840         _beforeTokenTransfer(address(0), to, tokenId);
841 
842         _balances[to] += 1;
843         _owners[tokenId] = to;
844 
845         emit Transfer(address(0), to, tokenId);
846     }
847 
848     /**
849      * @dev Destroys `tokenId`.
850      * The approval is cleared when the token is burned.
851      *
852      * Requirements:
853      *
854      * - `tokenId` must exist.
855      *
856      * Emits a {Transfer} event.
857      */
858     function _burn(uint256 tokenId) internal virtual {
859         address owner = ERC721.ownerOf(tokenId);
860 
861         _beforeTokenTransfer(owner, address(0), tokenId);
862 
863         // Clear approvals
864         _approve(address(0), tokenId);
865 
866         _balances[owner] -= 1;
867         delete _owners[tokenId];
868 
869         emit Transfer(owner, address(0), tokenId);
870     }
871 
872     /**
873      * @dev Transfers `tokenId` from `from` to `to`.
874      *  As opposed to {transferFrom}, this imposes no restrictions on msg.sender.
875      *
876      * Requirements:
877      *
878      * - `to` cannot be the zero address.
879      * - `tokenId` token must be owned by `from`.
880      *
881      * Emits a {Transfer} event.
882      */
883     function _transfer(
884         address from,
885         address to,
886         uint256 tokenId
887     ) internal virtual {
888         require(ERC721.ownerOf(tokenId) == from, "ERC721: transfer of token that is not own");
889         require(to != address(0), "ERC721: transfer to the zero address");
890 
891         _beforeTokenTransfer(from, to, tokenId);
892 
893         // Clear approvals from the previous owner
894         _approve(address(0), tokenId);
895 
896         _balances[from] -= 1;
897         _balances[to] += 1;
898         _owners[tokenId] = to;
899 
900         emit Transfer(from, to, tokenId);
901     }
902 
903     /**
904      * @dev Approve `to` to operate on `tokenId`
905      *
906      * Emits a {Approval} event.
907      */
908     function _approve(address to, uint256 tokenId) internal virtual {
909         _tokenApprovals[tokenId] = to;
910         emit Approval(ERC721.ownerOf(tokenId), to, tokenId);
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
965 }
966 
967 
968 // File @openzeppelin/contracts/token/ERC20/IERC20.sol@v4.3.1
969 
970 pragma solidity ^0.8.0;
971 
972 /**
973  * @dev Interface of the ERC20 standard as defined in the EIP.
974  */
975 interface IERC20 {
976     /**
977      * @dev Returns the amount of tokens in existence.
978      */
979     function totalSupply() external view returns (uint256);
980 
981     /**
982      * @dev Returns the amount of tokens owned by `account`.
983      */
984     function balanceOf(address account) external view returns (uint256);
985 
986     /**
987      * @dev Moves `amount` tokens from the caller's account to `recipient`.
988      *
989      * Returns a boolean value indicating whether the operation succeeded.
990      *
991      * Emits a {Transfer} event.
992      */
993     function transfer(address recipient, uint256 amount) external returns (bool);
994 
995     /**
996      * @dev Returns the remaining number of tokens that `spender` will be
997      * allowed to spend on behalf of `owner` through {transferFrom}. This is
998      * zero by default.
999      *
1000      * This value changes when {approve} or {transferFrom} are called.
1001      */
1002     function allowance(address owner, address spender) external view returns (uint256);
1003 
1004     /**
1005      * @dev Sets `amount` as the allowance of `spender` over the caller's tokens.
1006      *
1007      * Returns a boolean value indicating whether the operation succeeded.
1008      *
1009      * IMPORTANT: Beware that changing an allowance with this method brings the risk
1010      * that someone may use both the old and the new allowance by unfortunate
1011      * transaction ordering. One possible solution to mitigate this race
1012      * condition is to first reduce the spender's allowance to 0 and set the
1013      * desired value afterwards:
1014      * https://github.com/ethereum/EIPs/issues/20#issuecomment-263524729
1015      *
1016      * Emits an {Approval} event.
1017      */
1018     function approve(address spender, uint256 amount) external returns (bool);
1019 
1020     /**
1021      * @dev Moves `amount` tokens from `sender` to `recipient` using the
1022      * allowance mechanism. `amount` is then deducted from the caller's
1023      * allowance.
1024      *
1025      * Returns a boolean value indicating whether the operation succeeded.
1026      *
1027      * Emits a {Transfer} event.
1028      */
1029     function transferFrom(
1030         address sender,
1031         address recipient,
1032         uint256 amount
1033     ) external returns (bool);
1034 
1035     /**
1036      * @dev Emitted when `value` tokens are moved from one account (`from`) to
1037      * another (`to`).
1038      *
1039      * Note that `value` may be zero.
1040      */
1041     event Transfer(address indexed from, address indexed to, uint256 value);
1042 
1043     /**
1044      * @dev Emitted when the allowance of a `spender` for an `owner` is set by
1045      * a call to {approve}. `value` is the new allowance.
1046      */
1047     event Approval(address indexed owner, address indexed spender, uint256 value);
1048 }
1049 
1050 
1051 // File @openzeppelin/contracts/access/Ownable.sol@v4.3.1
1052 
1053 pragma solidity ^0.8.0;
1054 
1055 /**
1056  * @dev Contract module which provides a basic access control mechanism, where
1057  * there is an account (an owner) that can be granted exclusive access to
1058  * specific functions.
1059  *
1060  * By default, the owner account will be the one that deploys the contract. This
1061  * can later be changed with {transferOwnership}.
1062  *
1063  * This module is used through inheritance. It will make available the modifier
1064  * `onlyOwner`, which can be applied to your functions to restrict their use to
1065  * the owner.
1066  */
1067 abstract contract Ownable is Context {
1068     address private _owner;
1069 
1070     event OwnershipTransferred(address indexed previousOwner, address indexed newOwner);
1071 
1072     /**
1073      * @dev Initializes the contract setting the deployer as the initial owner.
1074      */
1075     constructor() {
1076         _setOwner(_msgSender());
1077     }
1078 
1079     /**
1080      * @dev Returns the address of the current owner.
1081      */
1082     function owner() public view virtual returns (address) {
1083         return _owner;
1084     }
1085 
1086     /**
1087      * @dev Throws if called by any account other than the owner.
1088      */
1089     modifier onlyOwner() {
1090         require(owner() == _msgSender(), "Ownable: caller is not the owner");
1091         _;
1092     }
1093 
1094     /**
1095      * @dev Leaves the contract without owner. It will not be possible to call
1096      * `onlyOwner` functions anymore. Can only be called by the current owner.
1097      *
1098      * NOTE: Renouncing ownership will leave the contract without an owner,
1099      * thereby removing any functionality that is only available to the owner.
1100      */
1101     function renounceOwnership() public virtual onlyOwner {
1102         _setOwner(address(0));
1103     }
1104 
1105     /**
1106      * @dev Transfers ownership of the contract to a new account (`newOwner`).
1107      * Can only be called by the current owner.
1108      */
1109     function transferOwnership(address newOwner) public virtual onlyOwner {
1110         require(newOwner != address(0), "Ownable: new owner is the zero address");
1111         _setOwner(newOwner);
1112     }
1113 
1114     function _setOwner(address newOwner) private {
1115         address oldOwner = _owner;
1116         _owner = newOwner;
1117         emit OwnershipTransferred(oldOwner, newOwner);
1118     }
1119 }
1120 
1121 
1122 // File @openzeppelin/contracts/utils/Counters.sol@v4.3.1
1123 
1124 pragma solidity ^0.8.0;
1125 
1126 /**
1127  * @title Counters
1128  * @author Matt Condon (@shrugs)
1129  * @dev Provides counters that can only be incremented, decremented or reset. This can be used e.g. to track the number
1130  * of elements in a mapping, issuing ERC721 ids, or counting request ids.
1131  *
1132  * Include with `using Counters for Counters.Counter;`
1133  */
1134 library Counters {
1135     struct Counter {
1136         // This variable should never be directly accessed by users of the library: interactions must be restricted to
1137         // the library's function. As of Solidity v0.5.2, this cannot be enforced, though there is a proposal to add
1138         // this feature: see https://github.com/ethereum/solidity/issues/4637
1139         uint256 _value; // default: 0
1140     }
1141 
1142     function current(Counter storage counter) internal view returns (uint256) {
1143         return counter._value;
1144     }
1145 
1146     function increment(Counter storage counter) internal {
1147         unchecked {
1148             counter._value += 1;
1149         }
1150     }
1151 
1152     function decrement(Counter storage counter) internal {
1153         uint256 value = counter._value;
1154         require(value > 0, "Counter: decrement overflow");
1155         unchecked {
1156             counter._value = value - 1;
1157         }
1158     }
1159 
1160     function reset(Counter storage counter) internal {
1161         counter._value = 0;
1162     }
1163 }
1164 
1165 
1166 // File @openzeppelin/contracts/utils/structs/BitMaps.sol@v4.3.1
1167 pragma solidity ^0.8.0;
1168 
1169 /**
1170  * @dev Library for managing uint256 to bool mapping in a compact and efficient way, providing the keys are sequential.
1171  * Largelly inspired by Uniswap's https://github.com/Uniswap/merkle-distributor/blob/master/contracts/MerkleDistributor.sol[merkle-distributor].
1172  */
1173 library BitMaps {
1174     struct BitMap {
1175         mapping(uint256 => uint256) _data;
1176     }
1177 
1178     /**
1179      * @dev Returns whether the bit at `index` is set.
1180      */
1181     function get(BitMap storage bitmap, uint256 index) internal view returns (bool) {
1182         uint256 bucket = index >> 8;
1183         uint256 mask = 1 << (index & 0xff);
1184         return bitmap._data[bucket] & mask != 0;
1185     }
1186 
1187     /**
1188      * @dev Sets the bit at `index` to the boolean `value`.
1189      */
1190     function setTo(
1191         BitMap storage bitmap,
1192         uint256 index,
1193         bool value
1194     ) internal {
1195         if (value) {
1196             set(bitmap, index);
1197         } else {
1198             unset(bitmap, index);
1199         }
1200     }
1201 
1202     /**
1203      * @dev Sets the bit at `index`.
1204      */
1205     function set(BitMap storage bitmap, uint256 index) internal {
1206         uint256 bucket = index >> 8;
1207         uint256 mask = 1 << (index & 0xff);
1208         bitmap._data[bucket] |= mask;
1209     }
1210 
1211     /**
1212      * @dev Unsets the bit at `index`.
1213      */
1214     function unset(BitMap storage bitmap, uint256 index) internal {
1215         uint256 bucket = index >> 8;
1216         uint256 mask = 1 << (index & 0xff);
1217         bitmap._data[bucket] &= ~mask;
1218     }
1219 }
1220 
1221 
1222 // File @openzeppelin/contracts/token/ERC721/extensions/IERC721Enumerable.sol@v4.3.1
1223 
1224 pragma solidity ^0.8.0;
1225 
1226 /**
1227  * @title ERC-721 Non-Fungible Token Standard, optional enumeration extension
1228  * @dev See https://eips.ethereum.org/EIPS/eip-721
1229  */
1230 interface IERC721Enumerable is IERC721 {
1231     /**
1232      * @dev Returns the total amount of tokens stored by the contract.
1233      */
1234     function totalSupply() external view returns (uint256);
1235 
1236     /**
1237      * @dev Returns a token ID owned by `owner` at a given `index` of its token list.
1238      * Use along with {balanceOf} to enumerate all of ``owner``'s tokens.
1239      */
1240     function tokenOfOwnerByIndex(address owner, uint256 index) external view returns (uint256 tokenId);
1241 
1242     /**
1243      * @dev Returns a token ID at a given `index` of all the tokens stored by the contract.
1244      * Use along with {totalSupply} to enumerate all tokens.
1245      */
1246     function tokenByIndex(uint256 index) external view returns (uint256);
1247 }
1248 
1249 
1250 // File @openzeppelin/contracts/token/ERC721/extensions/ERC721Enumerable.sol@v4.3.1
1251 
1252 pragma solidity ^0.8.0;
1253 
1254 
1255 /**
1256  * @dev This implements an optional extension of {ERC721} defined in the EIP that adds
1257  * enumerability of all the token ids in the contract as well as all token ids owned by each
1258  * account.
1259  */
1260 abstract contract ERC721Enumerable is ERC721, IERC721Enumerable {
1261     // Mapping from owner to list of owned token IDs
1262     mapping(address => mapping(uint256 => uint256)) private _ownedTokens;
1263 
1264     // Mapping from token ID to index of the owner tokens list
1265     mapping(uint256 => uint256) private _ownedTokensIndex;
1266 
1267     // Array with all token ids, used for enumeration
1268     uint256[] private _allTokens;
1269 
1270     // Mapping from token id to position in the allTokens array
1271     mapping(uint256 => uint256) private _allTokensIndex;
1272 
1273     /**
1274      * @dev See {IERC165-supportsInterface}.
1275      */
1276     function supportsInterface(bytes4 interfaceId) public view virtual override(IERC165, ERC721) returns (bool) {
1277         return interfaceId == type(IERC721Enumerable).interfaceId || super.supportsInterface(interfaceId);
1278     }
1279 
1280     /**
1281      * @dev See {IERC721Enumerable-tokenOfOwnerByIndex}.
1282      */
1283     function tokenOfOwnerByIndex(address owner, uint256 index) public view virtual override returns (uint256) {
1284         require(index < ERC721.balanceOf(owner), "ERC721Enumerable: owner index out of bounds");
1285         return _ownedTokens[owner][index];
1286     }
1287 
1288     /**
1289      * @dev See {IERC721Enumerable-totalSupply}.
1290      */
1291     function totalSupply() public view virtual override returns (uint256) {
1292         return _allTokens.length;
1293     }
1294 
1295     /**
1296      * @dev See {IERC721Enumerable-tokenByIndex}.
1297      */
1298     function tokenByIndex(uint256 index) public view virtual override returns (uint256) {
1299         require(index < ERC721Enumerable.totalSupply(), "ERC721Enumerable: global index out of bounds");
1300         return _allTokens[index];
1301     }
1302 
1303     /**
1304      * @dev Hook that is called before any token transfer. This includes minting
1305      * and burning.
1306      *
1307      * Calling conditions:
1308      *
1309      * - When `from` and `to` are both non-zero, ``from``'s `tokenId` will be
1310      * transferred to `to`.
1311      * - When `from` is zero, `tokenId` will be minted for `to`.
1312      * - When `to` is zero, ``from``'s `tokenId` will be burned.
1313      * - `from` cannot be the zero address.
1314      * - `to` cannot be the zero address.
1315      *
1316      * To learn more about hooks, head to xref:ROOT:extending-contracts.adoc#using-hooks[Using Hooks].
1317      */
1318     function _beforeTokenTransfer(
1319         address from,
1320         address to,
1321         uint256 tokenId
1322     ) internal virtual override {
1323         super._beforeTokenTransfer(from, to, tokenId);
1324 
1325         if (from == address(0)) {
1326             _addTokenToAllTokensEnumeration(tokenId);
1327         } else if (from != to) {
1328             _removeTokenFromOwnerEnumeration(from, tokenId);
1329         }
1330         if (to == address(0)) {
1331             _removeTokenFromAllTokensEnumeration(tokenId);
1332         } else if (to != from) {
1333             _addTokenToOwnerEnumeration(to, tokenId);
1334         }
1335     }
1336 
1337     /**
1338      * @dev Private function to add a token to this extension's ownership-tracking data structures.
1339      * @param to address representing the new owner of the given token ID
1340      * @param tokenId uint256 ID of the token to be added to the tokens list of the given address
1341      */
1342     function _addTokenToOwnerEnumeration(address to, uint256 tokenId) private {
1343         uint256 length = ERC721.balanceOf(to);
1344         _ownedTokens[to][length] = tokenId;
1345         _ownedTokensIndex[tokenId] = length;
1346     }
1347 
1348     /**
1349      * @dev Private function to add a token to this extension's token tracking data structures.
1350      * @param tokenId uint256 ID of the token to be added to the tokens list
1351      */
1352     function _addTokenToAllTokensEnumeration(uint256 tokenId) private {
1353         _allTokensIndex[tokenId] = _allTokens.length;
1354         _allTokens.push(tokenId);
1355     }
1356 
1357     /**
1358      * @dev Private function to remove a token from this extension's ownership-tracking data structures. Note that
1359      * while the token is not assigned a new owner, the `_ownedTokensIndex` mapping is _not_ updated: this allows for
1360      * gas optimizations e.g. when performing a transfer operation (avoiding double writes).
1361      * This has O(1) time complexity, but alters the order of the _ownedTokens array.
1362      * @param from address representing the previous owner of the given token ID
1363      * @param tokenId uint256 ID of the token to be removed from the tokens list of the given address
1364      */
1365     function _removeTokenFromOwnerEnumeration(address from, uint256 tokenId) private {
1366         // To prevent a gap in from's tokens array, we store the last token in the index of the token to delete, and
1367         // then delete the last slot (swap and pop).
1368 
1369         uint256 lastTokenIndex = ERC721.balanceOf(from) - 1;
1370         uint256 tokenIndex = _ownedTokensIndex[tokenId];
1371 
1372         // When the token to delete is the last token, the swap operation is unnecessary
1373         if (tokenIndex != lastTokenIndex) {
1374             uint256 lastTokenId = _ownedTokens[from][lastTokenIndex];
1375 
1376             _ownedTokens[from][tokenIndex] = lastTokenId; // Move the last token to the slot of the to-delete token
1377             _ownedTokensIndex[lastTokenId] = tokenIndex; // Update the moved token's index
1378         }
1379 
1380         // This also deletes the contents at the last position of the array
1381         delete _ownedTokensIndex[tokenId];
1382         delete _ownedTokens[from][lastTokenIndex];
1383     }
1384 
1385     /**
1386      * @dev Private function to remove a token from this extension's token tracking data structures.
1387      * This has O(1) time complexity, but alters the order of the _allTokens array.
1388      * @param tokenId uint256 ID of the token to be removed from the tokens list
1389      */
1390     function _removeTokenFromAllTokensEnumeration(uint256 tokenId) private {
1391         // To prevent a gap in the tokens array, we store the last token in the index of the token to delete, and
1392         // then delete the last slot (swap and pop).
1393 
1394         uint256 lastTokenIndex = _allTokens.length - 1;
1395         uint256 tokenIndex = _allTokensIndex[tokenId];
1396 
1397         // When the token to delete is the last token, the swap operation is unnecessary. However, since this occurs so
1398         // rarely (when the last minted token is burnt) that we still do the swap here to avoid the gas cost of adding
1399         // an 'if' statement (like in _removeTokenFromOwnerEnumeration)
1400         uint256 lastTokenId = _allTokens[lastTokenIndex];
1401 
1402         _allTokens[tokenIndex] = lastTokenId; // Move the last token to the slot of the to-delete token
1403         _allTokensIndex[lastTokenId] = tokenIndex; // Update the moved token's index
1404 
1405         // This also deletes the contents at the last position of the array
1406         delete _allTokensIndex[tokenId];
1407         _allTokens.pop();
1408     }
1409 }
1410 
1411 
1412 // File contracts/BonesClubCompanions.sol
1413 pragma solidity ^0.8.0;
1414 
1415 
1416 contract BonesClubCompanions is Ownable, ERC721Enumerable {
1417     // Libraries
1418     using Counters for Counters.Counter;
1419     using Strings for uint256;
1420 
1421     // Private fields
1422     Counters.Counter private _tokenIds;
1423 
1424     // Public constants
1425     uint256 public constant BCC_MAX_SUPPLY = 4100;
1426     //address public constant BONES_CLUB_CONTRACT = 0x719995D7D02126Cb7BEB17233075Bca1bf1cFfBE;
1427     address public constant BONES_CLUB_CONTRACT = 0x8f5a0ea6A20C7221cD865bd5C96f3b18614F7364;
1428 
1429     // Public fields
1430     bool public mintOpen = false;
1431     bool public claimOpen = true;
1432     bool public locked = false;
1433 
1434     uint256 public mintPrice = 0.01 ether;
1435     uint256 public mintAmount = 3;
1436     uint256 public bought = 0;
1437     string public baseURI = "";
1438     
1439 
1440     mapping(uint256 => bool) public claimed;
1441 
1442     modifier notLocked() {
1443         require(!locked, "Contract has been locked");
1444         _;
1445     }
1446 
1447     constructor() ERC721("Bones Club Companions", "BCC") {
1448         baseURI = "";
1449         //ownerMint(30);
1450     }
1451 
1452     function mint(uint256 quantity) public payable {
1453         require(mintOpen, "Public mint is not open atm.");
1454         require(quantity > 0, "Quantity must be at least 1");
1455 
1456         // Limit buys
1457         if (quantity > mintAmount) {
1458             quantity = mintAmount;
1459         }
1460 
1461         // Limit buys that exceed BCC_MAX_SUPPLY
1462         if (quantity + bought > BCC_MAX_SUPPLY) {
1463             quantity = BCC_MAX_SUPPLY - bought;
1464         }
1465 
1466         uint256 price = getPrice(quantity);
1467 
1468         // Ensure enough ETH
1469         require(msg.value >= price, "Not enough ETH sent");
1470 
1471         for (uint256 i = 0; i < quantity; i++) {
1472             _mintInternal(msg.sender);
1473             bought += 1;
1474         }
1475 
1476         // Return any remaining ether after the buy
1477         uint256 remaining = msg.value - price;
1478 
1479         if (remaining > 0) {
1480             (bool success, ) = msg.sender.call{value: remaining}("");
1481             require(success);
1482         }
1483     }
1484 
1485     function claimOne() public {
1486         require(claimOpen, "Claims are not open atm.");
1487         ERC721Enumerable bones = ERC721Enumerable(BONES_CLUB_CONTRACT);
1488         uint256 numBones = bones.balanceOf(msg.sender);
1489         for (uint256 i = 0; i < numBones; i++) {
1490             uint256 bonesId = bones.tokenOfOwnerByIndex(msg.sender, i);
1491             if (claimed[bonesId]) {
1492                 continue;
1493             }
1494             claimed[bonesId] = true;
1495             _mintInternal(msg.sender);
1496             break;
1497         }
1498     }
1499 
1500     function claimThree() public {
1501         require(claimOpen, "Claims are not open atm.");
1502         uint256 qty = 0;
1503         ERC721Enumerable bones = ERC721Enumerable(BONES_CLUB_CONTRACT);
1504         uint256 numBones = bones.balanceOf(msg.sender);
1505         for (uint256 i = 0; i < numBones; i++) {
1506             if(qty == 3) {
1507                 break;
1508             }
1509             uint256 bonesId = bones.tokenOfOwnerByIndex(msg.sender, i);
1510             if (claimed[bonesId]) {
1511                 continue;
1512             }
1513             claimed[bonesId] = true;
1514             _mintInternal(msg.sender);
1515             qty += 1;
1516         }
1517     }
1518 
1519     function claimFive() public {
1520         require(claimOpen, "Claims are not open atm.");
1521         uint256 qty = 0;
1522         ERC721Enumerable bones = ERC721Enumerable(BONES_CLUB_CONTRACT);
1523         uint256 numBones = bones.balanceOf(msg.sender);
1524         for (uint256 i = 0; i < numBones; i++) {
1525             if(qty == 5) {
1526                 break;
1527             }
1528             uint256 bonesId = bones.tokenOfOwnerByIndex(msg.sender, i);
1529             if (claimed[bonesId]) {
1530                 continue;
1531             }
1532             claimed[bonesId] = true;
1533             _mintInternal(msg.sender);
1534             qty += 1;
1535         }
1536     }
1537 
1538     function claimAll() public {
1539         require(claimOpen, "Claims are not open atm.");
1540         ERC721Enumerable bones = ERC721Enumerable(BONES_CLUB_CONTRACT);
1541         uint256 numBones = bones.balanceOf(msg.sender);
1542         for (uint256 i = 0; i < numBones; i++) {
1543             uint256 bonesId = bones.tokenOfOwnerByIndex(msg.sender, i);
1544             if (claimed[bonesId]) {
1545                 continue;
1546             }
1547             claimed[bonesId] = true;
1548             _mintInternal(msg.sender);
1549         }
1550     }
1551 
1552     function unclaimed(address owner) external view returns (uint256) {
1553         uint256 total = 0;
1554         ERC721Enumerable bones = ERC721Enumerable(BONES_CLUB_CONTRACT);
1555         uint256 numBones = bones.balanceOf(owner);
1556         for (uint256 i = 0; i < numBones; i++) {
1557             uint256 bonesId = bones.tokenOfOwnerByIndex(owner, i);
1558             if (claimed[bonesId]) {
1559                 continue;
1560             }
1561             total += 1;
1562         }
1563         return total;
1564     }
1565 
1566     function getQuantityFromValue(uint256 value) public view returns (uint256) {
1567         return value / mintPrice;
1568     }
1569 
1570     function getPrice(uint256 quantity) public view returns (uint256) {
1571         require(quantity <= BCC_MAX_SUPPLY);
1572         return quantity * (mintPrice);
1573     }
1574 
1575     function tokenURI(uint256 tokenId)
1576         public
1577         view
1578         virtual
1579         override
1580         returns (string memory)
1581     {
1582         require(
1583             tokenId > 0 && tokenId <= totalSupply(),
1584             "URI query for nonexistent token"
1585         );
1586         return string(abi.encodePacked(baseURI, tokenId.toString()));
1587     }
1588 
1589     // Admin methods
1590     function ownerMint(uint256 quantity) public onlyOwner {
1591         for (uint256 i = 0; i < quantity; i++) {
1592             _mintInternal(msg.sender);
1593         }
1594     }
1595 
1596     function setMintAmount(uint256 amount) external onlyOwner {
1597         mintAmount = amount;
1598     }
1599 
1600     function setMintPrice(uint256 price) external onlyOwner {
1601         mintPrice = price;
1602     }
1603 
1604     function setOpen(bool laFlag) external onlyOwner {
1605         mintOpen = laFlag;
1606     }
1607 
1608     function setOpenFree(bool laFlag) external onlyOwner {
1609         claimOpen = laFlag;
1610     }
1611 
1612     function setBaseURI(string memory newBaseURI) external onlyOwner notLocked {
1613         baseURI = newBaseURI;
1614     }
1615 
1616     function lock() external onlyOwner {
1617         locked = true;
1618     }
1619 
1620     function withdraw(uint256 amount, address addy) external payable onlyOwner {
1621         require(payable(addy).send(amount));    
1622     }
1623 
1624     function withdrawAll() external payable onlyOwner {
1625         require(payable(msg.sender).send(address(this).balance));
1626     }
1627 
1628     // Private Methods
1629     function _mintInternal(address owner) private {
1630         _tokenIds.increment();
1631         uint256 newItemId = _tokenIds.current();
1632         _mint(owner, newItemId);
1633     }
1634 }