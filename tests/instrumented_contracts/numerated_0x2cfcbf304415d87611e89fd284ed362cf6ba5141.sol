1 // Sources flattened with hardhat v2.6.0 https://hardhat.org
2 
3 // File @openzeppelin/contracts/utils/introspection/IERC165.sol@v4.2.0
4 
5 // SPDX-License-Identifier: MIT
6 
7 
8 pragma solidity ^0.8.0;
9 
10 /**
11  * @dev Interface of the ERC165 standard, as defined in the
12  * https://eips.ethereum.org/EIPS/eip-165[EIP].
13  *
14  * Implementers can declare support of contract interfaces, which can then be
15  * queried by others ({ERC165Checker}).
16  *
17  * For an implementation, see {ERC165}.
18  */
19 interface IERC165 {
20     /**
21      * @dev Returns true if this contract implements the interface defined by
22      * `interfaceId`. See the corresponding
23      * https://eips.ethereum.org/EIPS/eip-165#how-interfaces-are-identified[EIP section]
24      * to learn more about how these ids are created.
25      *
26      * This function call must use less than 30 000 gas.
27      */
28     function supportsInterface(bytes4 interfaceId) external view returns (bool);
29 }
30 
31 
32 // File @openzeppelin/contracts/token/ERC721/IERC721.sol@v4.2.0
33 
34 
35 pragma solidity ^0.8.0;
36 
37 /**
38  * @dev Required interface of an ERC721 compliant contract.
39  */
40 interface IERC721 is IERC165 {
41     /**
42      * @dev Emitted when `tokenId` token is transferred from `from` to `to`.
43      */
44     event Transfer(address indexed from, address indexed to, uint256 indexed tokenId);
45 
46     /**
47      * @dev Emitted when `owner` enables `approved` to manage the `tokenId` token.
48      */
49     event Approval(address indexed owner, address indexed approved, uint256 indexed tokenId);
50 
51     /**
52      * @dev Emitted when `owner` enables or disables (`approved`) `operator` to manage all of its assets.
53      */
54     event ApprovalForAll(address indexed owner, address indexed operator, bool approved);
55 
56     /**
57      * @dev Returns the number of tokens in ``owner``'s account.
58      */
59     function balanceOf(address owner) external view returns (uint256 balance);
60 
61     /**
62      * @dev Returns the owner of the `tokenId` token.
63      *
64      * Requirements:
65      *
66      * - `tokenId` must exist.
67      */
68     function ownerOf(uint256 tokenId) external view returns (address owner);
69 
70     /**
71      * @dev Safely transfers `tokenId` token from `from` to `to`, checking first that contract recipients
72      * are aware of the ERC721 protocol to prevent tokens from being forever locked.
73      *
74      * Requirements:
75      *
76      * - `from` cannot be the zero address.
77      * - `to` cannot be the zero address.
78      * - `tokenId` token must exist and be owned by `from`.
79      * - If the caller is not `from`, it must be have been allowed to move this token by either {approve} or {setApprovalForAll}.
80      * - If `to` refers to a smart contract, it must implement {IERC721Receiver-onERC721Received}, which is called upon a safe transfer.
81      *
82      * Emits a {Transfer} event.
83      */
84     function safeTransferFrom(
85         address from,
86         address to,
87         uint256 tokenId
88     ) external;
89 
90     /**
91      * @dev Transfers `tokenId` token from `from` to `to`.
92      *
93      * WARNING: Usage of this method is discouraged, use {safeTransferFrom} whenever possible.
94      *
95      * Requirements:
96      *
97      * - `from` cannot be the zero address.
98      * - `to` cannot be the zero address.
99      * - `tokenId` token must be owned by `from`.
100      * - If the caller is not `from`, it must be approved to move this token by either {approve} or {setApprovalForAll}.
101      *
102      * Emits a {Transfer} event.
103      */
104     function transferFrom(
105         address from,
106         address to,
107         uint256 tokenId
108     ) external;
109 
110     /**
111      * @dev Gives permission to `to` to transfer `tokenId` token to another account.
112      * The approval is cleared when the token is transferred.
113      *
114      * Only a single account can be approved at a time, so approving the zero address clears previous approvals.
115      *
116      * Requirements:
117      *
118      * - The caller must own the token or be an approved operator.
119      * - `tokenId` must exist.
120      *
121      * Emits an {Approval} event.
122      */
123     function approve(address to, uint256 tokenId) external;
124 
125     /**
126      * @dev Returns the account approved for `tokenId` token.
127      *
128      * Requirements:
129      *
130      * - `tokenId` must exist.
131      */
132     function getApproved(uint256 tokenId) external view returns (address operator);
133 
134     /**
135      * @dev Approve or remove `operator` as an operator for the caller.
136      * Operators can call {transferFrom} or {safeTransferFrom} for any token owned by the caller.
137      *
138      * Requirements:
139      *
140      * - The `operator` cannot be the caller.
141      *
142      * Emits an {ApprovalForAll} event.
143      */
144     function setApprovalForAll(address operator, bool _approved) external;
145 
146     /**
147      * @dev Returns if the `operator` is allowed to manage all of the assets of `owner`.
148      *
149      * See {setApprovalForAll}
150      */
151     function isApprovedForAll(address owner, address operator) external view returns (bool);
152 
153     /**
154      * @dev Safely transfers `tokenId` token from `from` to `to`.
155      *
156      * Requirements:
157      *
158      * - `from` cannot be the zero address.
159      * - `to` cannot be the zero address.
160      * - `tokenId` token must exist and be owned by `from`.
161      * - If the caller is not `from`, it must be approved to move this token by either {approve} or {setApprovalForAll}.
162      * - If `to` refers to a smart contract, it must implement {IERC721Receiver-onERC721Received}, which is called upon a safe transfer.
163      *
164      * Emits a {Transfer} event.
165      */
166     function safeTransferFrom(
167         address from,
168         address to,
169         uint256 tokenId,
170         bytes calldata data
171     ) external;
172 }
173 
174 
175 // File @openzeppelin/contracts/token/ERC721/IERC721Receiver.sol@v4.2.0
176 
177 
178 pragma solidity ^0.8.0;
179 
180 /**
181  * @title ERC721 token receiver interface
182  * @dev Interface for any contract that wants to support safeTransfers
183  * from ERC721 asset contracts.
184  */
185 interface IERC721Receiver {
186     /**
187      * @dev Whenever an {IERC721} `tokenId` token is transferred to this contract via {IERC721-safeTransferFrom}
188      * by `operator` from `from`, this function is called.
189      *
190      * It must return its Solidity selector to confirm the token transfer.
191      * If any other value is returned or the interface is not implemented by the recipient, the transfer will be reverted.
192      *
193      * The selector can be obtained in Solidity with `IERC721.onERC721Received.selector`.
194      */
195     function onERC721Received(
196         address operator,
197         address from,
198         uint256 tokenId,
199         bytes calldata data
200     ) external returns (bytes4);
201 }
202 
203 
204 // File @openzeppelin/contracts/token/ERC721/extensions/IERC721Metadata.sol@v4.2.0
205 
206 
207 pragma solidity ^0.8.0;
208 
209 /**
210  * @title ERC-721 Non-Fungible Token Standard, optional metadata extension
211  * @dev See https://eips.ethereum.org/EIPS/eip-721
212  */
213 interface IERC721Metadata is IERC721 {
214     /**
215      * @dev Returns the token collection name.
216      */
217     function name() external view returns (string memory);
218 
219     /**
220      * @dev Returns the token collection symbol.
221      */
222     function symbol() external view returns (string memory);
223 
224     /**
225      * @dev Returns the Uniform Resource Identifier (URI) for `tokenId` token.
226      */
227     function tokenURI(uint256 tokenId) external view returns (string memory);
228 }
229 
230 
231 // File @openzeppelin/contracts/utils/Address.sol@v4.2.0
232 
233 
234 pragma solidity ^0.8.0;
235 
236 /**
237  * @dev Collection of functions related to the address type
238  */
239 library Address {
240     /**
241      * @dev Returns true if `account` is a contract.
242      *
243      * [IMPORTANT]
244      * ====
245      * It is unsafe to assume that an address for which this function returns
246      * false is an externally-owned account (EOA) and not a contract.
247      *
248      * Among others, `isContract` will return false for the following
249      * types of addresses:
250      *
251      *  - an externally-owned account
252      *  - a contract in construction
253      *  - an address where a contract will be created
254      *  - an address where a contract lived, but was destroyed
255      * ====
256      */
257     function isContract(address account) internal view returns (bool) {
258         // This method relies on extcodesize, which returns 0 for contracts in
259         // construction, since the code is only stored at the end of the
260         // constructor execution.
261 
262         uint256 size;
263         assembly {
264             size := extcodesize(account)
265         }
266         return size > 0;
267     }
268 
269     /**
270      * @dev Replacement for Solidity's `transfer`: sends `amount` wei to
271      * `recipient`, forwarding all available gas and reverting on errors.
272      *
273      * https://eips.ethereum.org/EIPS/eip-1884[EIP1884] increases the gas cost
274      * of certain opcodes, possibly making contracts go over the 2300 gas limit
275      * imposed by `transfer`, making them unable to receive funds via
276      * `transfer`. {sendValue} removes this limitation.
277      *
278      * https://diligence.consensys.net/posts/2019/09/stop-using-soliditys-transfer-now/[Learn more].
279      *
280      * IMPORTANT: because control is transferred to `recipient`, care must be
281      * taken to not create reentrancy vulnerabilities. Consider using
282      * {ReentrancyGuard} or the
283      * https://solidity.readthedocs.io/en/v0.5.11/security-considerations.html#use-the-checks-effects-interactions-pattern[checks-effects-interactions pattern].
284      */
285     function sendValue(address payable recipient, uint256 amount) internal {
286         require(address(this).balance >= amount, "Address: insufficient balance");
287 
288         (bool success, ) = recipient.call{value: amount}("");
289         require(success, "Address: unable to send value, recipient may have reverted");
290     }
291 
292     /**
293      * @dev Performs a Solidity function call using a low level `call`. A
294      * plain `call` is an unsafe replacement for a function call: use this
295      * function instead.
296      *
297      * If `target` reverts with a revert reason, it is bubbled up by this
298      * function (like regular Solidity function calls).
299      *
300      * Returns the raw returned data. To convert to the expected return value,
301      * use https://solidity.readthedocs.io/en/latest/units-and-global-variables.html?highlight=abi.decode#abi-encoding-and-decoding-functions[`abi.decode`].
302      *
303      * Requirements:
304      *
305      * - `target` must be a contract.
306      * - calling `target` with `data` must not revert.
307      *
308      * _Available since v3.1._
309      */
310     function functionCall(address target, bytes memory data) internal returns (bytes memory) {
311         return functionCall(target, data, "Address: low-level call failed");
312     }
313 
314     /**
315      * @dev Same as {xref-Address-functionCall-address-bytes-}[`functionCall`], but with
316      * `errorMessage` as a fallback revert reason when `target` reverts.
317      *
318      * _Available since v3.1._
319      */
320     function functionCall(
321         address target,
322         bytes memory data,
323         string memory errorMessage
324     ) internal returns (bytes memory) {
325         return functionCallWithValue(target, data, 0, errorMessage);
326     }
327 
328     /**
329      * @dev Same as {xref-Address-functionCall-address-bytes-}[`functionCall`],
330      * but also transferring `value` wei to `target`.
331      *
332      * Requirements:
333      *
334      * - the calling contract must have an ETH balance of at least `value`.
335      * - the called Solidity function must be `payable`.
336      *
337      * _Available since v3.1._
338      */
339     function functionCallWithValue(
340         address target,
341         bytes memory data,
342         uint256 value
343     ) internal returns (bytes memory) {
344         return functionCallWithValue(target, data, value, "Address: low-level call with value failed");
345     }
346 
347     /**
348      * @dev Same as {xref-Address-functionCallWithValue-address-bytes-uint256-}[`functionCallWithValue`], but
349      * with `errorMessage` as a fallback revert reason when `target` reverts.
350      *
351      * _Available since v3.1._
352      */
353     function functionCallWithValue(
354         address target,
355         bytes memory data,
356         uint256 value,
357         string memory errorMessage
358     ) internal returns (bytes memory) {
359         require(address(this).balance >= value, "Address: insufficient balance for call");
360         require(isContract(target), "Address: call to non-contract");
361 
362         (bool success, bytes memory returndata) = target.call{value: value}(data);
363         return _verifyCallResult(success, returndata, errorMessage);
364     }
365 
366     /**
367      * @dev Same as {xref-Address-functionCall-address-bytes-}[`functionCall`],
368      * but performing a static call.
369      *
370      * _Available since v3.3._
371      */
372     function functionStaticCall(address target, bytes memory data) internal view returns (bytes memory) {
373         return functionStaticCall(target, data, "Address: low-level static call failed");
374     }
375 
376     /**
377      * @dev Same as {xref-Address-functionCall-address-bytes-string-}[`functionCall`],
378      * but performing a static call.
379      *
380      * _Available since v3.3._
381      */
382     function functionStaticCall(
383         address target,
384         bytes memory data,
385         string memory errorMessage
386     ) internal view returns (bytes memory) {
387         require(isContract(target), "Address: static call to non-contract");
388 
389         (bool success, bytes memory returndata) = target.staticcall(data);
390         return _verifyCallResult(success, returndata, errorMessage);
391     }
392 
393     /**
394      * @dev Same as {xref-Address-functionCall-address-bytes-}[`functionCall`],
395      * but performing a delegate call.
396      *
397      * _Available since v3.4._
398      */
399     function functionDelegateCall(address target, bytes memory data) internal returns (bytes memory) {
400         return functionDelegateCall(target, data, "Address: low-level delegate call failed");
401     }
402 
403     /**
404      * @dev Same as {xref-Address-functionCall-address-bytes-string-}[`functionCall`],
405      * but performing a delegate call.
406      *
407      * _Available since v3.4._
408      */
409     function functionDelegateCall(
410         address target,
411         bytes memory data,
412         string memory errorMessage
413     ) internal returns (bytes memory) {
414         require(isContract(target), "Address: delegate call to non-contract");
415 
416         (bool success, bytes memory returndata) = target.delegatecall(data);
417         return _verifyCallResult(success, returndata, errorMessage);
418     }
419 
420     function _verifyCallResult(
421         bool success,
422         bytes memory returndata,
423         string memory errorMessage
424     ) private pure returns (bytes memory) {
425         if (success) {
426             return returndata;
427         } else {
428             // Look for revert reason and bubble it up if present
429             if (returndata.length > 0) {
430                 // The easiest way to bubble the revert reason is using memory via assembly
431 
432                 assembly {
433                     let returndata_size := mload(returndata)
434                     revert(add(32, returndata), returndata_size)
435                 }
436             } else {
437                 revert(errorMessage);
438             }
439         }
440     }
441 }
442 
443 
444 // File @openzeppelin/contracts/utils/Context.sol@v4.2.0
445 
446 
447 pragma solidity ^0.8.0;
448 
449 /*
450  * @dev Provides information about the current execution context, including the
451  * sender of the transaction and its data. While these are generally available
452  * via msg.sender and msg.data, they should not be accessed in such a direct
453  * manner, since when dealing with meta-transactions the account sending and
454  * paying for execution may not be the actual sender (as far as an application
455  * is concerned).
456  *
457  * This contract is only required for intermediate, library-like contracts.
458  */
459 abstract contract Context {
460     function _msgSender() internal view virtual returns (address) {
461         return msg.sender;
462     }
463 
464     function _msgData() internal view virtual returns (bytes calldata) {
465         return msg.data;
466     }
467 }
468 
469 
470 // File @openzeppelin/contracts/utils/Strings.sol@v4.2.0
471 
472 
473 pragma solidity ^0.8.0;
474 
475 /**
476  * @dev String operations.
477  */
478 library Strings {
479     bytes16 private constant _HEX_SYMBOLS = "0123456789abcdef";
480 
481     /**
482      * @dev Converts a `uint256` to its ASCII `string` decimal representation.
483      */
484     function toString(uint256 value) internal pure returns (string memory) {
485         // Inspired by OraclizeAPI's implementation - MIT licence
486         // https://github.com/oraclize/ethereum-api/blob/b42146b063c7d6ee1358846c198246239e9360e8/oraclizeAPI_0.4.25.sol
487 
488         if (value == 0) {
489             return "0";
490         }
491         uint256 temp = value;
492         uint256 digits;
493         while (temp != 0) {
494             digits++;
495             temp /= 10;
496         }
497         bytes memory buffer = new bytes(digits);
498         while (value != 0) {
499             digits -= 1;
500             buffer[digits] = bytes1(uint8(48 + uint256(value % 10)));
501             value /= 10;
502         }
503         return string(buffer);
504     }
505 
506     /**
507      * @dev Converts a `uint256` to its ASCII `string` hexadecimal representation.
508      */
509     function toHexString(uint256 value) internal pure returns (string memory) {
510         if (value == 0) {
511             return "0x00";
512         }
513         uint256 temp = value;
514         uint256 length = 0;
515         while (temp != 0) {
516             length++;
517             temp >>= 8;
518         }
519         return toHexString(value, length);
520     }
521 
522     /**
523      * @dev Converts a `uint256` to its ASCII `string` hexadecimal representation with fixed length.
524      */
525     function toHexString(uint256 value, uint256 length) internal pure returns (string memory) {
526         bytes memory buffer = new bytes(2 * length + 2);
527         buffer[0] = "0";
528         buffer[1] = "x";
529         for (uint256 i = 2 * length + 1; i > 1; --i) {
530             buffer[i] = _HEX_SYMBOLS[value & 0xf];
531             value >>= 4;
532         }
533         require(value == 0, "Strings: hex length insufficient");
534         return string(buffer);
535     }
536 }
537 
538 
539 // File @openzeppelin/contracts/utils/introspection/ERC165.sol@v4.2.0
540 
541 
542 pragma solidity ^0.8.0;
543 
544 /**
545  * @dev Implementation of the {IERC165} interface.
546  *
547  * Contracts that want to implement ERC165 should inherit from this contract and override {supportsInterface} to check
548  * for the additional interface id that will be supported. For example:
549  *
550  * ```solidity
551  * function supportsInterface(bytes4 interfaceId) public view virtual override returns (bool) {
552  *     return interfaceId == type(MyInterface).interfaceId || super.supportsInterface(interfaceId);
553  * }
554  * ```
555  *
556  * Alternatively, {ERC165Storage} provides an easier to use but more expensive implementation.
557  */
558 abstract contract ERC165 is IERC165 {
559     /**
560      * @dev See {IERC165-supportsInterface}.
561      */
562     function supportsInterface(bytes4 interfaceId) public view virtual override returns (bool) {
563         return interfaceId == type(IERC165).interfaceId;
564     }
565 }
566 
567 
568 // File @openzeppelin/contracts/token/ERC721/ERC721.sol@v4.2.0
569 
570 
571 pragma solidity ^0.8.0;
572 
573 
574 
575 
576 
577 
578 
579 /**
580  * @dev Implementation of https://eips.ethereum.org/EIPS/eip-721[ERC721] Non-Fungible Token Standard, including
581  * the Metadata extension, but not including the Enumerable extension, which is available separately as
582  * {ERC721Enumerable}.
583  */
584 contract ERC721 is Context, ERC165, IERC721, IERC721Metadata {
585     using Address for address;
586     using Strings for uint256;
587 
588     // Token name
589     string private _name;
590 
591     // Token symbol
592     string private _symbol;
593 
594     // Mapping from token ID to owner address
595     mapping(uint256 => address) private _owners;
596 
597     // Mapping owner address to token count
598     mapping(address => uint256) private _balances;
599 
600     // Mapping from token ID to approved address
601     mapping(uint256 => address) private _tokenApprovals;
602 
603     // Mapping from owner to operator approvals
604     mapping(address => mapping(address => bool)) private _operatorApprovals;
605 
606     /**
607      * @dev Initializes the contract by setting a `name` and a `symbol` to the token collection.
608      */
609     constructor(string memory name_, string memory symbol_) {
610         _name = name_;
611         _symbol = symbol_;
612     }
613 
614     /**
615      * @dev See {IERC165-supportsInterface}.
616      */
617     function supportsInterface(bytes4 interfaceId) public view virtual override(ERC165, IERC165) returns (bool) {
618         return
619             interfaceId == type(IERC721).interfaceId ||
620             interfaceId == type(IERC721Metadata).interfaceId ||
621             super.supportsInterface(interfaceId);
622     }
623 
624     /**
625      * @dev See {IERC721-balanceOf}.
626      */
627     function balanceOf(address owner) public view virtual override returns (uint256) {
628         require(owner != address(0), "ERC721: balance query for the zero address");
629         return _balances[owner];
630     }
631 
632     /**
633      * @dev See {IERC721-ownerOf}.
634      */
635     function ownerOf(uint256 tokenId) public view virtual override returns (address) {
636         address owner = _owners[tokenId];
637         require(owner != address(0), "ERC721: owner query for nonexistent token");
638         return owner;
639     }
640 
641     /**
642      * @dev See {IERC721Metadata-name}.
643      */
644     function name() public view virtual override returns (string memory) {
645         return _name;
646     }
647 
648     /**
649      * @dev See {IERC721Metadata-symbol}.
650      */
651     function symbol() public view virtual override returns (string memory) {
652         return _symbol;
653     }
654 
655     /**
656      * @dev See {IERC721Metadata-tokenURI}.
657      */
658     function tokenURI(uint256 tokenId) public view virtual override returns (string memory) {
659         require(_exists(tokenId), "ERC721Metadata: URI query for nonexistent token");
660 
661         string memory baseURI = _baseURI();
662         return bytes(baseURI).length > 0 ? string(abi.encodePacked(baseURI, tokenId.toString())) : "";
663     }
664 
665     /**
666      * @dev Base URI for computing {tokenURI}. If set, the resulting URI for each
667      * token will be the concatenation of the `baseURI` and the `tokenId`. Empty
668      * by default, can be overriden in child contracts.
669      */
670     function _baseURI() internal view virtual returns (string memory) {
671         return "";
672     }
673 
674     /**
675      * @dev See {IERC721-approve}.
676      */
677     function approve(address to, uint256 tokenId) public virtual override {
678         address owner = ERC721.ownerOf(tokenId);
679         require(to != owner, "ERC721: approval to current owner");
680 
681         require(
682             _msgSender() == owner || isApprovedForAll(owner, _msgSender()),
683             "ERC721: approve caller is not owner nor approved for all"
684         );
685 
686         _approve(to, tokenId);
687     }
688 
689     /**
690      * @dev See {IERC721-getApproved}.
691      */
692     function getApproved(uint256 tokenId) public view virtual override returns (address) {
693         require(_exists(tokenId), "ERC721: approved query for nonexistent token");
694 
695         return _tokenApprovals[tokenId];
696     }
697 
698     /**
699      * @dev See {IERC721-setApprovalForAll}.
700      */
701     function setApprovalForAll(address operator, bool approved) public virtual override {
702         require(operator != _msgSender(), "ERC721: approve to caller");
703 
704         _operatorApprovals[_msgSender()][operator] = approved;
705         emit ApprovalForAll(_msgSender(), operator, approved);
706     }
707 
708     /**
709      * @dev See {IERC721-isApprovedForAll}.
710      */
711     function isApprovedForAll(address owner, address operator) public view virtual override returns (bool) {
712         return _operatorApprovals[owner][operator];
713     }
714 
715     /**
716      * @dev See {IERC721-transferFrom}.
717      */
718     function transferFrom(
719         address from,
720         address to,
721         uint256 tokenId
722     ) public virtual override {
723         //solhint-disable-next-line max-line-length
724         require(_isApprovedOrOwner(_msgSender(), tokenId), "ERC721: transfer caller is not owner nor approved");
725 
726         _transfer(from, to, tokenId);
727     }
728 
729     /**
730      * @dev See {IERC721-safeTransferFrom}.
731      */
732     function safeTransferFrom(
733         address from,
734         address to,
735         uint256 tokenId
736     ) public virtual override {
737         safeTransferFrom(from, to, tokenId, "");
738     }
739 
740     /**
741      * @dev See {IERC721-safeTransferFrom}.
742      */
743     function safeTransferFrom(
744         address from,
745         address to,
746         uint256 tokenId,
747         bytes memory _data
748     ) public virtual override {
749         require(_isApprovedOrOwner(_msgSender(), tokenId), "ERC721: transfer caller is not owner nor approved");
750         _safeTransfer(from, to, tokenId, _data);
751     }
752 
753     /**
754      * @dev Safely transfers `tokenId` token from `from` to `to`, checking first that contract recipients
755      * are aware of the ERC721 protocol to prevent tokens from being forever locked.
756      *
757      * `_data` is additional data, it has no specified format and it is sent in call to `to`.
758      *
759      * This internal function is equivalent to {safeTransferFrom}, and can be used to e.g.
760      * implement alternative mechanisms to perform token transfer, such as signature-based.
761      *
762      * Requirements:
763      *
764      * - `from` cannot be the zero address.
765      * - `to` cannot be the zero address.
766      * - `tokenId` token must exist and be owned by `from`.
767      * - If `to` refers to a smart contract, it must implement {IERC721Receiver-onERC721Received}, which is called upon a safe transfer.
768      *
769      * Emits a {Transfer} event.
770      */
771     function _safeTransfer(
772         address from,
773         address to,
774         uint256 tokenId,
775         bytes memory _data
776     ) internal virtual {
777         _transfer(from, to, tokenId);
778         require(_checkOnERC721Received(from, to, tokenId, _data), "ERC721: transfer to non ERC721Receiver implementer");
779     }
780 
781     /**
782      * @dev Returns whether `tokenId` exists.
783      *
784      * Tokens can be managed by their owner or approved accounts via {approve} or {setApprovalForAll}.
785      *
786      * Tokens start existing when they are minted (`_mint`),
787      * and stop existing when they are burned (`_burn`).
788      */
789     function _exists(uint256 tokenId) internal view virtual returns (bool) {
790         return _owners[tokenId] != address(0);
791     }
792 
793     /**
794      * @dev Returns whether `spender` is allowed to manage `tokenId`.
795      *
796      * Requirements:
797      *
798      * - `tokenId` must exist.
799      */
800     function _isApprovedOrOwner(address spender, uint256 tokenId) internal view virtual returns (bool) {
801         require(_exists(tokenId), "ERC721: operator query for nonexistent token");
802         address owner = ERC721.ownerOf(tokenId);
803         return (spender == owner || getApproved(tokenId) == spender || isApprovedForAll(owner, spender));
804     }
805 
806     /**
807      * @dev Safely mints `tokenId` and transfers it to `to`.
808      *
809      * Requirements:
810      *
811      * - `tokenId` must not exist.
812      * - If `to` refers to a smart contract, it must implement {IERC721Receiver-onERC721Received}, which is called upon a safe transfer.
813      *
814      * Emits a {Transfer} event.
815      */
816     function _safeMint(address to, uint256 tokenId) internal virtual {
817         _safeMint(to, tokenId, "");
818     }
819 
820     /**
821      * @dev Same as {xref-ERC721-_safeMint-address-uint256-}[`_safeMint`], with an additional `data` parameter which is
822      * forwarded in {IERC721Receiver-onERC721Received} to contract recipients.
823      */
824     function _safeMint(
825         address to,
826         uint256 tokenId,
827         bytes memory _data
828     ) internal virtual {
829         _mint(to, tokenId);
830         require(
831             _checkOnERC721Received(address(0), to, tokenId, _data),
832             "ERC721: transfer to non ERC721Receiver implementer"
833         );
834     }
835 
836     /**
837      * @dev Mints `tokenId` and transfers it to `to`.
838      *
839      * WARNING: Usage of this method is discouraged, use {_safeMint} whenever possible
840      *
841      * Requirements:
842      *
843      * - `tokenId` must not exist.
844      * - `to` cannot be the zero address.
845      *
846      * Emits a {Transfer} event.
847      */
848     function _mint(address to, uint256 tokenId) internal virtual {
849         require(to != address(0), "ERC721: mint to the zero address");
850         require(!_exists(tokenId), "ERC721: token already minted");
851 
852         _beforeTokenTransfer(address(0), to, tokenId);
853 
854         _balances[to] += 1;
855         _owners[tokenId] = to;
856 
857         emit Transfer(address(0), to, tokenId);
858     }
859 
860     /**
861      * @dev Destroys `tokenId`.
862      * The approval is cleared when the token is burned.
863      *
864      * Requirements:
865      *
866      * - `tokenId` must exist.
867      *
868      * Emits a {Transfer} event.
869      */
870     function _burn(uint256 tokenId) internal virtual {
871         address owner = ERC721.ownerOf(tokenId);
872 
873         _beforeTokenTransfer(owner, address(0), tokenId);
874 
875         // Clear approvals
876         _approve(address(0), tokenId);
877 
878         _balances[owner] -= 1;
879         delete _owners[tokenId];
880 
881         emit Transfer(owner, address(0), tokenId);
882     }
883 
884     /**
885      * @dev Transfers `tokenId` from `from` to `to`.
886      *  As opposed to {transferFrom}, this imposes no restrictions on msg.sender.
887      *
888      * Requirements:
889      *
890      * - `to` cannot be the zero address.
891      * - `tokenId` token must be owned by `from`.
892      *
893      * Emits a {Transfer} event.
894      */
895     function _transfer(
896         address from,
897         address to,
898         uint256 tokenId
899     ) internal virtual {
900         require(ERC721.ownerOf(tokenId) == from, "ERC721: transfer of token that is not own");
901         require(to != address(0), "ERC721: transfer to the zero address");
902 
903         _beforeTokenTransfer(from, to, tokenId);
904 
905         // Clear approvals from the previous owner
906         _approve(address(0), tokenId);
907 
908         _balances[from] -= 1;
909         _balances[to] += 1;
910         _owners[tokenId] = to;
911 
912         emit Transfer(from, to, tokenId);
913     }
914 
915     /**
916      * @dev Approve `to` to operate on `tokenId`
917      *
918      * Emits a {Approval} event.
919      */
920     function _approve(address to, uint256 tokenId) internal virtual {
921         _tokenApprovals[tokenId] = to;
922         emit Approval(ERC721.ownerOf(tokenId), to, tokenId);
923     }
924 
925     /**
926      * @dev Internal function to invoke {IERC721Receiver-onERC721Received} on a target address.
927      * The call is not executed if the target address is not a contract.
928      *
929      * @param from address representing the previous owner of the given token ID
930      * @param to target address that will receive the tokens
931      * @param tokenId uint256 ID of the token to be transferred
932      * @param _data bytes optional data to send along with the call
933      * @return bool whether the call correctly returned the expected magic value
934      */
935     function _checkOnERC721Received(
936         address from,
937         address to,
938         uint256 tokenId,
939         bytes memory _data
940     ) private returns (bool) {
941         if (to.isContract()) {
942             try IERC721Receiver(to).onERC721Received(_msgSender(), from, tokenId, _data) returns (bytes4 retval) {
943                 return retval == IERC721Receiver(to).onERC721Received.selector;
944             } catch (bytes memory reason) {
945                 if (reason.length == 0) {
946                     revert("ERC721: transfer to non ERC721Receiver implementer");
947                 } else {
948                     assembly {
949                         revert(add(32, reason), mload(reason))
950                     }
951                 }
952             }
953         } else {
954             return true;
955         }
956     }
957 
958     /**
959      * @dev Hook that is called before any token transfer. This includes minting
960      * and burning.
961      *
962      * Calling conditions:
963      *
964      * - When `from` and `to` are both non-zero, ``from``'s `tokenId` will be
965      * transferred to `to`.
966      * - When `from` is zero, `tokenId` will be minted for `to`.
967      * - When `to` is zero, ``from``'s `tokenId` will be burned.
968      * - `from` and `to` are never both zero.
969      *
970      * To learn more about hooks, head to xref:ROOT:extending-contracts.adoc#using-hooks[Using Hooks].
971      */
972     function _beforeTokenTransfer(
973         address from,
974         address to,
975         uint256 tokenId
976     ) internal virtual {}
977 }
978 
979 
980 // File @openzeppelin/contracts/token/ERC721/extensions/IERC721Enumerable.sol@v4.2.0
981 
982 
983 pragma solidity ^0.8.0;
984 
985 /**
986  * @title ERC-721 Non-Fungible Token Standard, optional enumeration extension
987  * @dev See https://eips.ethereum.org/EIPS/eip-721
988  */
989 interface IERC721Enumerable is IERC721 {
990     /**
991      * @dev Returns the total amount of tokens stored by the contract.
992      */
993     function totalSupply() external view returns (uint256);
994 
995     /**
996      * @dev Returns a token ID owned by `owner` at a given `index` of its token list.
997      * Use along with {balanceOf} to enumerate all of ``owner``'s tokens.
998      */
999     function tokenOfOwnerByIndex(address owner, uint256 index) external view returns (uint256 tokenId);
1000 
1001     /**
1002      * @dev Returns a token ID at a given `index` of all the tokens stored by the contract.
1003      * Use along with {totalSupply} to enumerate all tokens.
1004      */
1005     function tokenByIndex(uint256 index) external view returns (uint256);
1006 }
1007 
1008 
1009 // File @openzeppelin/contracts/token/ERC721/extensions/ERC721Enumerable.sol@v4.2.0
1010 
1011 
1012 pragma solidity ^0.8.0;
1013 
1014 
1015 /**
1016  * @dev This implements an optional extension of {ERC721} defined in the EIP that adds
1017  * enumerability of all the token ids in the contract as well as all token ids owned by each
1018  * account.
1019  */
1020 abstract contract ERC721Enumerable is ERC721, IERC721Enumerable {
1021     // Mapping from owner to list of owned token IDs
1022     mapping(address => mapping(uint256 => uint256)) private _ownedTokens;
1023 
1024     // Mapping from token ID to index of the owner tokens list
1025     mapping(uint256 => uint256) private _ownedTokensIndex;
1026 
1027     // Array with all token ids, used for enumeration
1028     uint256[] private _allTokens;
1029 
1030     // Mapping from token id to position in the allTokens array
1031     mapping(uint256 => uint256) private _allTokensIndex;
1032 
1033     /**
1034      * @dev See {IERC165-supportsInterface}.
1035      */
1036     function supportsInterface(bytes4 interfaceId) public view virtual override(IERC165, ERC721) returns (bool) {
1037         return interfaceId == type(IERC721Enumerable).interfaceId || super.supportsInterface(interfaceId);
1038     }
1039 
1040     /**
1041      * @dev See {IERC721Enumerable-tokenOfOwnerByIndex}.
1042      */
1043     function tokenOfOwnerByIndex(address owner, uint256 index) public view virtual override returns (uint256) {
1044         require(index < ERC721.balanceOf(owner), "ERC721Enumerable: owner index out of bounds");
1045         return _ownedTokens[owner][index];
1046     }
1047 
1048     /**
1049      * @dev See {IERC721Enumerable-totalSupply}.
1050      */
1051     function totalSupply() public view virtual override returns (uint256) {
1052         return _allTokens.length;
1053     }
1054 
1055     /**
1056      * @dev See {IERC721Enumerable-tokenByIndex}.
1057      */
1058     function tokenByIndex(uint256 index) public view virtual override returns (uint256) {
1059         require(index < ERC721Enumerable.totalSupply(), "ERC721Enumerable: global index out of bounds");
1060         return _allTokens[index];
1061     }
1062 
1063     /**
1064      * @dev Hook that is called before any token transfer. This includes minting
1065      * and burning.
1066      *
1067      * Calling conditions:
1068      *
1069      * - When `from` and `to` are both non-zero, ``from``'s `tokenId` will be
1070      * transferred to `to`.
1071      * - When `from` is zero, `tokenId` will be minted for `to`.
1072      * - When `to` is zero, ``from``'s `tokenId` will be burned.
1073      * - `from` cannot be the zero address.
1074      * - `to` cannot be the zero address.
1075      *
1076      * To learn more about hooks, head to xref:ROOT:extending-contracts.adoc#using-hooks[Using Hooks].
1077      */
1078     function _beforeTokenTransfer(
1079         address from,
1080         address to,
1081         uint256 tokenId
1082     ) internal virtual override {
1083         super._beforeTokenTransfer(from, to, tokenId);
1084 
1085         if (from == address(0)) {
1086             _addTokenToAllTokensEnumeration(tokenId);
1087         } else if (from != to) {
1088             _removeTokenFromOwnerEnumeration(from, tokenId);
1089         }
1090         if (to == address(0)) {
1091             _removeTokenFromAllTokensEnumeration(tokenId);
1092         } else if (to != from) {
1093             _addTokenToOwnerEnumeration(to, tokenId);
1094         }
1095     }
1096 
1097     /**
1098      * @dev Private function to add a token to this extension's ownership-tracking data structures.
1099      * @param to address representing the new owner of the given token ID
1100      * @param tokenId uint256 ID of the token to be added to the tokens list of the given address
1101      */
1102     function _addTokenToOwnerEnumeration(address to, uint256 tokenId) private {
1103         uint256 length = ERC721.balanceOf(to);
1104         _ownedTokens[to][length] = tokenId;
1105         _ownedTokensIndex[tokenId] = length;
1106     }
1107 
1108     /**
1109      * @dev Private function to add a token to this extension's token tracking data structures.
1110      * @param tokenId uint256 ID of the token to be added to the tokens list
1111      */
1112     function _addTokenToAllTokensEnumeration(uint256 tokenId) private {
1113         _allTokensIndex[tokenId] = _allTokens.length;
1114         _allTokens.push(tokenId);
1115     }
1116 
1117     /**
1118      * @dev Private function to remove a token from this extension's ownership-tracking data structures. Note that
1119      * while the token is not assigned a new owner, the `_ownedTokensIndex` mapping is _not_ updated: this allows for
1120      * gas optimizations e.g. when performing a transfer operation (avoiding double writes).
1121      * This has O(1) time complexity, but alters the order of the _ownedTokens array.
1122      * @param from address representing the previous owner of the given token ID
1123      * @param tokenId uint256 ID of the token to be removed from the tokens list of the given address
1124      */
1125     function _removeTokenFromOwnerEnumeration(address from, uint256 tokenId) private {
1126         // To prevent a gap in from's tokens array, we store the last token in the index of the token to delete, and
1127         // then delete the last slot (swap and pop).
1128 
1129         uint256 lastTokenIndex = ERC721.balanceOf(from) - 1;
1130         uint256 tokenIndex = _ownedTokensIndex[tokenId];
1131 
1132         // When the token to delete is the last token, the swap operation is unnecessary
1133         if (tokenIndex != lastTokenIndex) {
1134             uint256 lastTokenId = _ownedTokens[from][lastTokenIndex];
1135 
1136             _ownedTokens[from][tokenIndex] = lastTokenId; // Move the last token to the slot of the to-delete token
1137             _ownedTokensIndex[lastTokenId] = tokenIndex; // Update the moved token's index
1138         }
1139 
1140         // This also deletes the contents at the last position of the array
1141         delete _ownedTokensIndex[tokenId];
1142         delete _ownedTokens[from][lastTokenIndex];
1143     }
1144 
1145     /**
1146      * @dev Private function to remove a token from this extension's token tracking data structures.
1147      * This has O(1) time complexity, but alters the order of the _allTokens array.
1148      * @param tokenId uint256 ID of the token to be removed from the tokens list
1149      */
1150     function _removeTokenFromAllTokensEnumeration(uint256 tokenId) private {
1151         // To prevent a gap in the tokens array, we store the last token in the index of the token to delete, and
1152         // then delete the last slot (swap and pop).
1153 
1154         uint256 lastTokenIndex = _allTokens.length - 1;
1155         uint256 tokenIndex = _allTokensIndex[tokenId];
1156 
1157         // When the token to delete is the last token, the swap operation is unnecessary. However, since this occurs so
1158         // rarely (when the last minted token is burnt) that we still do the swap here to avoid the gas cost of adding
1159         // an 'if' statement (like in _removeTokenFromOwnerEnumeration)
1160         uint256 lastTokenId = _allTokens[lastTokenIndex];
1161 
1162         _allTokens[tokenIndex] = lastTokenId; // Move the last token to the slot of the to-delete token
1163         _allTokensIndex[lastTokenId] = tokenIndex; // Update the moved token's index
1164 
1165         // This also deletes the contents at the last position of the array
1166         delete _allTokensIndex[tokenId];
1167         _allTokens.pop();
1168     }
1169 }
1170 
1171 
1172 // File @openzeppelin/contracts/access/Ownable.sol@v4.2.0
1173 
1174 
1175 pragma solidity ^0.8.0;
1176 
1177 /**
1178  * @dev Contract module which provides a basic access control mechanism, where
1179  * there is an account (an owner) that can be granted exclusive access to
1180  * specific functions.
1181  *
1182  * By default, the owner account will be the one that deploys the contract. This
1183  * can later be changed with {transferOwnership}.
1184  *
1185  * This module is used through inheritance. It will make available the modifier
1186  * `onlyOwner`, which can be applied to your functions to restrict their use to
1187  * the owner.
1188  */
1189 abstract contract Ownable is Context {
1190     address private _owner;
1191 
1192     event OwnershipTransferred(address indexed previousOwner, address indexed newOwner);
1193 
1194     /**
1195      * @dev Initializes the contract setting the deployer as the initial owner.
1196      */
1197     constructor() {
1198         _setOwner(_msgSender());
1199     }
1200 
1201     /**
1202      * @dev Returns the address of the current owner.
1203      */
1204     function owner() public view virtual returns (address) {
1205         return _owner;
1206     }
1207 
1208     /**
1209      * @dev Throws if called by any account other than the owner.
1210      */
1211     modifier onlyOwner() {
1212         require(owner() == _msgSender(), "Ownable: caller is not the owner");
1213         _;
1214     }
1215 
1216     /**
1217      * @dev Leaves the contract without owner. It will not be possible to call
1218      * `onlyOwner` functions anymore. Can only be called by the current owner.
1219      *
1220      * NOTE: Renouncing ownership will leave the contract without an owner,
1221      * thereby removing any functionality that is only available to the owner.
1222      */
1223     function renounceOwnership() public virtual onlyOwner {
1224         _setOwner(address(0));
1225     }
1226 
1227     /**
1228      * @dev Transfers ownership of the contract to a new account (`newOwner`).
1229      * Can only be called by the current owner.
1230      */
1231     function transferOwnership(address newOwner) public virtual onlyOwner {
1232         require(newOwner != address(0), "Ownable: new owner is the zero address");
1233         _setOwner(newOwner);
1234     }
1235 
1236     function _setOwner(address newOwner) private {
1237         address oldOwner = _owner;
1238         _owner = newOwner;
1239         emit OwnershipTransferred(oldOwner, newOwner);
1240     }
1241 }
1242 
1243 
1244 // File contracts/Gods.sol
1245 
1246 pragma solidity ^0.8.0;
1247 
1248 
1249 contract Gods is ERC721Enumerable, Ownable {
1250   using Strings for uint256;
1251 
1252   address public _vault;
1253   bool public _active = false;
1254   bool public _presaleActive = false;
1255   string public _baseTokenURI;
1256   uint256 public _gifts = 100;
1257   uint256 public _price = 0.05 ether;
1258 
1259 
1260   address public _t1 = 0xE97f9392c6199c29039A8ac9F6873B4ab1865975;
1261   address public _t2 = 0x1550B90c56367658b16D81EbaC264672EC3c4fD4;
1262   address public _t3 = 0x5404980C4e40310073f4c959E91bA94c4C47Ca03;
1263   address public _t4 = 0x2E7A2e45718d936b991F8bF71b8ABD9BD15c97E9;
1264   address public _t5 = 0xB4fd6168D1aB6Dce105D220ceB1661EBd4606339;
1265 
1266   constructor() ERC721("Gods", "GODS") {}
1267 
1268   function _baseURI() internal view virtual override returns (string memory) {
1269     return _baseTokenURI;
1270   }
1271 
1272   function setActive(bool active) public onlyOwner {
1273      _active = active;
1274   }
1275 
1276   function setPresaleActive(bool presaleActive) public onlyOwner {
1277      _presaleActive = presaleActive;
1278   }
1279 
1280   function setVault(address vault) public onlyOwner {
1281     _vault = vault;
1282   }
1283 
1284   function setBaseURI(string memory baseURI) public onlyOwner {
1285     _baseTokenURI = baseURI;
1286   }
1287 
1288   function setPrice(uint256 price) public onlyOwner {
1289     _price = price;
1290   }
1291 
1292   function gift(address _to, uint256 _amount) external onlyOwner {
1293     require(_amount <= _gifts, "Gift reserve exceeded with provided amount.");
1294 
1295     uint256 supply = totalSupply();
1296 
1297     for(uint256 i; i < _amount; i++){
1298       _safeMint( _to, supply + i );
1299     }
1300 
1301     _gifts -= _amount;
1302   }
1303 
1304   function mint(uint256 _amount) public payable {
1305     uint256 supply = totalSupply();
1306 
1307     require( _active, "Sale is not active.");
1308     require( _amount < 21, "Provided amount exceeds mint limit.");
1309     require( msg.value >= _price * _amount, "Insufficient ether provided.");
1310     require( supply + _amount <= 5000 - _gifts, "Supply exceeded with provided amount.");
1311 
1312     for(uint256 i; i < _amount; i++){
1313       _safeMint( msg.sender, supply + i );
1314     }
1315   }
1316 
1317   function presaleMint(uint256 _amount) public payable {
1318     uint256 supply = totalSupply();
1319     uint256 balance = balanceOf(msg.sender);
1320 
1321     require( _amount + balance < 9, "Provided amount exceeds pre-sale mint limit.");
1322     require( _presaleActive, "Pre-Sale is not active.");
1323     require( msg.value >= _price * _amount, "Insufficient ether provided.");
1324     require( supply + _amount < 2501, "Supply exceeded with provided amount.");
1325 
1326     for(uint256 i; i < _amount; i++){
1327       _safeMint( msg.sender, supply + i );
1328     }
1329  }
1330 
1331   function withdraw() public payable onlyOwner {
1332     uint256 _p1 = address(this).balance / 5;
1333     uint256 _p2 = address(this).balance / 5;
1334     uint256 _p3 = address(this).balance / 4;
1335     uint256 _p4 = address(this).balance * 7/100;
1336     uint256 _p5 = address(this).balance - _p1 - _p2 - _p3 - _p4;
1337 
1338     require(payable(_t1).send(_p1));
1339     require(payable(_t2).send(_p2));
1340     require(payable(_t3).send(_p3));
1341     require(payable(_t4).send(_p4));
1342     require(payable(_t5).send(_p5));
1343   }
1344 }