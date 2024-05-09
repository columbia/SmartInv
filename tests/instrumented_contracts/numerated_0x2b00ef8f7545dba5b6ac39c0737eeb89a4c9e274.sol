1 // Sources flattened with hardhat v2.5.0 https://hardhat.org
2 
3 // File @openzeppelin/contracts/utils/introspection/IERC165.sol@v4.2.0
4 // SPDX-License-Identifier: MIT
5 
6 pragma solidity ^0.8.0;
7 
8 /**
9  * @dev Interface of the ERC165 standard, as defined in the
10  * https://eips.ethereum.org/EIPS/eip-165[EIP].
11  *
12  * Implementers can declare support of contract interfaces, which can then be
13  * queried by others ({ERC165Checker}).
14  *
15  * For an implementation, see {ERC165}.
16  */
17 interface IERC165 {
18     /**
19      * @dev Returns true if this contract implements the interface defined by
20      * `interfaceId`. See the corresponding
21      * https://eips.ethereum.org/EIPS/eip-165#how-interfaces-are-identified[EIP section]
22      * to learn more about how these ids are created.
23      *
24      * This function call must use less than 30 000 gas.
25      */
26     function supportsInterface(bytes4 interfaceId) external view returns (bool);
27 }
28 
29 
30 // File @openzeppelin/contracts/token/ERC721/IERC721.sol@v4.2.0
31 
32 
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
171 
172 // File @openzeppelin/contracts/token/ERC721/IERC721Receiver.sol@v4.2.0
173 
174 
175 
176 /**
177  * @title ERC721 token receiver interface
178  * @dev Interface for any contract that wants to support safeTransfers
179  * from ERC721 asset contracts.
180  */
181 interface IERC721Receiver {
182     /**
183      * @dev Whenever an {IERC721} `tokenId` token is transferred to this contract via {IERC721-safeTransferFrom}
184      * by `operator` from `from`, this function is called.
185      *
186      * It must return its Solidity selector to confirm the token transfer.
187      * If any other value is returned or the interface is not implemented by the recipient, the transfer will be reverted.
188      *
189      * The selector can be obtained in Solidity with `IERC721.onERC721Received.selector`.
190      */
191     function onERC721Received(
192         address operator,
193         address from,
194         uint256 tokenId,
195         bytes calldata data
196     ) external returns (bytes4);
197 }
198 
199 
200 // File @openzeppelin/contracts/token/ERC721/extensions/IERC721Metadata.sol@v4.2.0
201 
202 
203 
204 /**
205  * @title ERC-721 Non-Fungible Token Standard, optional metadata extension
206  * @dev See https://eips.ethereum.org/EIPS/eip-721
207  */
208 interface IERC721Metadata is IERC721 {
209     /**
210      * @dev Returns the token collection name.
211      */
212     function name() external view returns (string memory);
213 
214     /**
215      * @dev Returns the token collection symbol.
216      */
217     function symbol() external view returns (string memory);
218 
219     /**
220      * @dev Returns the Uniform Resource Identifier (URI) for `tokenId` token.
221      */
222     function tokenURI(uint256 tokenId) external view returns (string memory);
223 }
224 
225 
226 // File @openzeppelin/contracts/utils/Address.sol@v4.2.0
227 
228 
229 
230 /**
231  * @dev Collection of functions related to the address type
232  */
233 library Address {
234     /**
235      * @dev Returns true if `account` is a contract.
236      *
237      * [IMPORTANT]
238      * ====
239      * It is unsafe to assume that an address for which this function returns
240      * false is an externally-owned account (EOA) and not a contract.
241      *
242      * Among others, `isContract` will return false for the following
243      * types of addresses:
244      *
245      *  - an externally-owned account
246      *  - a contract in construction
247      *  - an address where a contract will be created
248      *  - an address where a contract lived, but was destroyed
249      * ====
250      */
251     function isContract(address account) internal view returns (bool) {
252         // This method relies on extcodesize, which returns 0 for contracts in
253         // construction, since the code is only stored at the end of the
254         // constructor execution.
255 
256         uint256 size;
257         assembly {
258             size := extcodesize(account)
259         }
260         return size > 0;
261     }
262 
263     /**
264      * @dev Replacement for Solidity's `transfer`: sends `amount` wei to
265      * `recipient`, forwarding all available gas and reverting on errors.
266      *
267      * https://eips.ethereum.org/EIPS/eip-1884[EIP1884] increases the gas cost
268      * of certain opcodes, possibly making contracts go over the 2300 gas limit
269      * imposed by `transfer`, making them unable to receive funds via
270      * `transfer`. {sendValue} removes this limitation.
271      *
272      * https://diligence.consensys.net/posts/2019/09/stop-using-soliditys-transfer-now/[Learn more].
273      *
274      * IMPORTANT: because control is transferred to `recipient`, care must be
275      * taken to not create reentrancy vulnerabilities. Consider using
276      * {ReentrancyGuard} or the
277      * https://solidity.readthedocs.io/en/v0.5.11/security-considerations.html#use-the-checks-effects-interactions-pattern[checks-effects-interactions pattern].
278      */
279     function sendValue(address payable recipient, uint256 amount) internal {
280         require(address(this).balance >= amount, "Address: insufficient balance");
281 
282         (bool success, ) = recipient.call{value: amount}("");
283         require(success, "Address: unable to send value, recipient may have reverted");
284     }
285 
286     /**
287      * @dev Performs a Solidity function call using a low level `call`. A
288      * plain `call` is an unsafe replacement for a function call: use this
289      * function instead.
290      *
291      * If `target` reverts with a revert reason, it is bubbled up by this
292      * function (like regular Solidity function calls).
293      *
294      * Returns the raw returned data. To convert to the expected return value,
295      * use https://solidity.readthedocs.io/en/latest/units-and-global-variables.html?highlight=abi.decode#abi-encoding-and-decoding-functions[`abi.decode`].
296      *
297      * Requirements:
298      *
299      * - `target` must be a contract.
300      * - calling `target` with `data` must not revert.
301      *
302      * _Available since v3.1._
303      */
304     function functionCall(address target, bytes memory data) internal returns (bytes memory) {
305         return functionCall(target, data, "Address: low-level call failed");
306     }
307 
308     /**
309      * @dev Same as {xref-Address-functionCall-address-bytes-}[`functionCall`], but with
310      * `errorMessage` as a fallback revert reason when `target` reverts.
311      *
312      * _Available since v3.1._
313      */
314     function functionCall(
315         address target,
316         bytes memory data,
317         string memory errorMessage
318     ) internal returns (bytes memory) {
319         return functionCallWithValue(target, data, 0, errorMessage);
320     }
321 
322     /**
323      * @dev Same as {xref-Address-functionCall-address-bytes-}[`functionCall`],
324      * but also transferring `value` wei to `target`.
325      *
326      * Requirements:
327      *
328      * - the calling contract must have an ETH balance of at least `value`.
329      * - the called Solidity function must be `payable`.
330      *
331      * _Available since v3.1._
332      */
333     function functionCallWithValue(
334         address target,
335         bytes memory data,
336         uint256 value
337     ) internal returns (bytes memory) {
338         return functionCallWithValue(target, data, value, "Address: low-level call with value failed");
339     }
340 
341     /**
342      * @dev Same as {xref-Address-functionCallWithValue-address-bytes-uint256-}[`functionCallWithValue`], but
343      * with `errorMessage` as a fallback revert reason when `target` reverts.
344      *
345      * _Available since v3.1._
346      */
347     function functionCallWithValue(
348         address target,
349         bytes memory data,
350         uint256 value,
351         string memory errorMessage
352     ) internal returns (bytes memory) {
353         require(address(this).balance >= value, "Address: insufficient balance for call");
354         require(isContract(target), "Address: call to non-contract");
355 
356         (bool success, bytes memory returndata) = target.call{value: value}(data);
357         return _verifyCallResult(success, returndata, errorMessage);
358     }
359 
360     /**
361      * @dev Same as {xref-Address-functionCall-address-bytes-}[`functionCall`],
362      * but performing a static call.
363      *
364      * _Available since v3.3._
365      */
366     function functionStaticCall(address target, bytes memory data) internal view returns (bytes memory) {
367         return functionStaticCall(target, data, "Address: low-level static call failed");
368     }
369 
370     /**
371      * @dev Same as {xref-Address-functionCall-address-bytes-string-}[`functionCall`],
372      * but performing a static call.
373      *
374      * _Available since v3.3._
375      */
376     function functionStaticCall(
377         address target,
378         bytes memory data,
379         string memory errorMessage
380     ) internal view returns (bytes memory) {
381         require(isContract(target), "Address: static call to non-contract");
382 
383         (bool success, bytes memory returndata) = target.staticcall(data);
384         return _verifyCallResult(success, returndata, errorMessage);
385     }
386 
387     /**
388      * @dev Same as {xref-Address-functionCall-address-bytes-}[`functionCall`],
389      * but performing a delegate call.
390      *
391      * _Available since v3.4._
392      */
393     function functionDelegateCall(address target, bytes memory data) internal returns (bytes memory) {
394         return functionDelegateCall(target, data, "Address: low-level delegate call failed");
395     }
396 
397     /**
398      * @dev Same as {xref-Address-functionCall-address-bytes-string-}[`functionCall`],
399      * but performing a delegate call.
400      *
401      * _Available since v3.4._
402      */
403     function functionDelegateCall(
404         address target,
405         bytes memory data,
406         string memory errorMessage
407     ) internal returns (bytes memory) {
408         require(isContract(target), "Address: delegate call to non-contract");
409 
410         (bool success, bytes memory returndata) = target.delegatecall(data);
411         return _verifyCallResult(success, returndata, errorMessage);
412     }
413 
414     function _verifyCallResult(
415         bool success,
416         bytes memory returndata,
417         string memory errorMessage
418     ) private pure returns (bytes memory) {
419         if (success) {
420             return returndata;
421         } else {
422             // Look for revert reason and bubble it up if present
423             if (returndata.length > 0) {
424                 // The easiest way to bubble the revert reason is using memory via assembly
425 
426                 assembly {
427                     let returndata_size := mload(returndata)
428                     revert(add(32, returndata), returndata_size)
429                 }
430             } else {
431                 revert(errorMessage);
432             }
433         }
434     }
435 }
436 
437 
438 // File @openzeppelin/contracts/utils/Context.sol@v4.2.0
439 
440 
441 
442 /*
443  * @dev Provides information about the current execution context, including the
444  * sender of the transaction and its data. While these are generally available
445  * via msg.sender and msg.data, they should not be accessed in such a direct
446  * manner, since when dealing with meta-transactions the account sending and
447  * paying for execution may not be the actual sender (as far as an application
448  * is concerned).
449  *
450  * This contract is only required for intermediate, library-like contracts.
451  */
452 abstract contract Context {
453     function _msgSender() internal view virtual returns (address) {
454         return msg.sender;
455     }
456 
457     function _msgData() internal view virtual returns (bytes calldata) {
458         return msg.data;
459     }
460 }
461 
462 
463 // File @openzeppelin/contracts/utils/Strings.sol@v4.2.0
464 
465 
466 
467 /**
468  * @dev String operations.
469  */
470 library Strings {
471     bytes16 private constant _HEX_SYMBOLS = "0123456789abcdef";
472 
473     /**
474      * @dev Converts a `uint256` to its ASCII `string` decimal representation.
475      */
476     function toString(uint256 value) internal pure returns (string memory) {
477         // Inspired by OraclizeAPI's implementation - MIT licence
478         // https://github.com/oraclize/ethereum-api/blob/b42146b063c7d6ee1358846c198246239e9360e8/oraclizeAPI_0.4.25.sol
479 
480         if (value == 0) {
481             return "0";
482         }
483         uint256 temp = value;
484         uint256 digits;
485         while (temp != 0) {
486             digits++;
487             temp /= 10;
488         }
489         bytes memory buffer = new bytes(digits);
490         while (value != 0) {
491             digits -= 1;
492             buffer[digits] = bytes1(uint8(48 + uint256(value % 10)));
493             value /= 10;
494         }
495         return string(buffer);
496     }
497 
498     /**
499      * @dev Converts a `uint256` to its ASCII `string` hexadecimal representation.
500      */
501     function toHexString(uint256 value) internal pure returns (string memory) {
502         if (value == 0) {
503             return "0x00";
504         }
505         uint256 temp = value;
506         uint256 length = 0;
507         while (temp != 0) {
508             length++;
509             temp >>= 8;
510         }
511         return toHexString(value, length);
512     }
513 
514     /**
515      * @dev Converts a `uint256` to its ASCII `string` hexadecimal representation with fixed length.
516      */
517     function toHexString(uint256 value, uint256 length) internal pure returns (string memory) {
518         bytes memory buffer = new bytes(2 * length + 2);
519         buffer[0] = "0";
520         buffer[1] = "x";
521         for (uint256 i = 2 * length + 1; i > 1; --i) {
522             buffer[i] = _HEX_SYMBOLS[value & 0xf];
523             value >>= 4;
524         }
525         require(value == 0, "Strings: hex length insufficient");
526         return string(buffer);
527     }
528 }
529 
530 
531 // File @openzeppelin/contracts/utils/introspection/ERC165.sol@v4.2.0
532 
533 
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
558 
559 // File @openzeppelin/contracts/token/ERC721/ERC721.sol@v4.2.0
560 
561 
562 
563 
564 
565 
566 
567 
568 
569 /**
570  * @dev Implementation of https://eips.ethereum.org/EIPS/eip-721[ERC721] Non-Fungible Token Standard, including
571  * the Metadata extension, but not including the Enumerable extension, which is available separately as
572  * {ERC721Enumerable}.
573  */
574 contract ERC721 is Context, ERC165, IERC721, IERC721Metadata {
575     using Address for address;
576     using Strings for uint256;
577 
578     // Token name
579     string private _name;
580 
581     // Token symbol
582     string private _symbol;
583 
584     // Mapping from token ID to owner address
585     mapping(uint256 => address) private _owners;
586 
587     // Mapping owner address to token count
588     mapping(address => uint256) private _balances;
589 
590     // Mapping from token ID to approved address
591     mapping(uint256 => address) private _tokenApprovals;
592 
593     // Mapping from owner to operator approvals
594     mapping(address => mapping(address => bool)) private _operatorApprovals;
595 
596     /**
597      * @dev Initializes the contract by setting a `name` and a `symbol` to the token collection.
598      */
599     constructor(string memory name_, string memory symbol_) {
600         _name = name_;
601         _symbol = symbol_;
602     }
603 
604     /**
605      * @dev See {IERC165-supportsInterface}.
606      */
607     function supportsInterface(bytes4 interfaceId) public view virtual override(ERC165, IERC165) returns (bool) {
608         return
609             interfaceId == type(IERC721).interfaceId ||
610             interfaceId == type(IERC721Metadata).interfaceId ||
611             super.supportsInterface(interfaceId);
612     }
613 
614     /**
615      * @dev See {IERC721-balanceOf}.
616      */
617     function balanceOf(address owner) public view virtual override returns (uint256) {
618         require(owner != address(0), "ERC721: balance query for the zero address");
619         return _balances[owner];
620     }
621 
622     /**
623      * @dev See {IERC721-ownerOf}.
624      */
625     function ownerOf(uint256 tokenId) public view virtual override returns (address) {
626         address owner = _owners[tokenId];
627         require(owner != address(0), "ERC721: owner query for nonexistent token");
628         return owner;
629     }
630 
631     /**
632      * @dev See {IERC721Metadata-name}.
633      */
634     function name() public view virtual override returns (string memory) {
635         return _name;
636     }
637 
638     /**
639      * @dev See {IERC721Metadata-symbol}.
640      */
641     function symbol() public view virtual override returns (string memory) {
642         return _symbol;
643     }
644 
645     /**
646      * @dev See {IERC721Metadata-tokenURI}.
647      */
648     function tokenURI(uint256 tokenId) public view virtual override returns (string memory) {
649         require(_exists(tokenId), "ERC721Metadata: URI query for nonexistent token");
650 
651         string memory baseURI = _baseURI();
652         return bytes(baseURI).length > 0 ? string(abi.encodePacked(baseURI, tokenId.toString())) : "";
653     }
654 
655     /**
656      * @dev Base URI for computing {tokenURI}. If set, the resulting URI for each
657      * token will be the concatenation of the `baseURI` and the `tokenId`. Empty
658      * by default, can be overriden in child contracts.
659      */
660     function _baseURI() internal view virtual returns (string memory) {
661         return "";
662     }
663 
664     /**
665      * @dev See {IERC721-approve}.
666      */
667     function approve(address to, uint256 tokenId) public virtual override {
668         address owner = ERC721.ownerOf(tokenId);
669         require(to != owner, "ERC721: approval to current owner");
670 
671         require(
672             _msgSender() == owner || isApprovedForAll(owner, _msgSender()),
673             "ERC721: approve caller is not owner nor approved for all"
674         );
675 
676         _approve(to, tokenId);
677     }
678 
679     /**
680      * @dev See {IERC721-getApproved}.
681      */
682     function getApproved(uint256 tokenId) public view virtual override returns (address) {
683         require(_exists(tokenId), "ERC721: approved query for nonexistent token");
684 
685         return _tokenApprovals[tokenId];
686     }
687 
688     /**
689      * @dev See {IERC721-setApprovalForAll}.
690      */
691     function setApprovalForAll(address operator, bool approved) public virtual override {
692         require(operator != _msgSender(), "ERC721: approve to caller");
693 
694         _operatorApprovals[_msgSender()][operator] = approved;
695         emit ApprovalForAll(_msgSender(), operator, approved);
696     }
697 
698     /**
699      * @dev See {IERC721-isApprovedForAll}.
700      */
701     function isApprovedForAll(address owner, address operator) public view virtual override returns (bool) {
702         return _operatorApprovals[owner][operator];
703     }
704 
705     /**
706      * @dev See {IERC721-transferFrom}.
707      */
708     function transferFrom(
709         address from,
710         address to,
711         uint256 tokenId
712     ) public virtual override {
713         //solhint-disable-next-line max-line-length
714         require(_isApprovedOrOwner(_msgSender(), tokenId), "ERC721: transfer caller is not owner nor approved");
715 
716         _transfer(from, to, tokenId);
717     }
718 
719     /**
720      * @dev See {IERC721-safeTransferFrom}.
721      */
722     function safeTransferFrom(
723         address from,
724         address to,
725         uint256 tokenId
726     ) public virtual override {
727         safeTransferFrom(from, to, tokenId, "");
728     }
729 
730     /**
731      * @dev See {IERC721-safeTransferFrom}.
732      */
733     function safeTransferFrom(
734         address from,
735         address to,
736         uint256 tokenId,
737         bytes memory _data
738     ) public virtual override {
739         require(_isApprovedOrOwner(_msgSender(), tokenId), "ERC721: transfer caller is not owner nor approved");
740         _safeTransfer(from, to, tokenId, _data);
741     }
742 
743     /**
744      * @dev Safely transfers `tokenId` token from `from` to `to`, checking first that contract recipients
745      * are aware of the ERC721 protocol to prevent tokens from being forever locked.
746      *
747      * `_data` is additional data, it has no specified format and it is sent in call to `to`.
748      *
749      * This internal function is equivalent to {safeTransferFrom}, and can be used to e.g.
750      * implement alternative mechanisms to perform token transfer, such as signature-based.
751      *
752      * Requirements:
753      *
754      * - `from` cannot be the zero address.
755      * - `to` cannot be the zero address.
756      * - `tokenId` token must exist and be owned by `from`.
757      * - If `to` refers to a smart contract, it must implement {IERC721Receiver-onERC721Received}, which is called upon a safe transfer.
758      *
759      * Emits a {Transfer} event.
760      */
761     function _safeTransfer(
762         address from,
763         address to,
764         uint256 tokenId,
765         bytes memory _data
766     ) internal virtual {
767         _transfer(from, to, tokenId);
768         require(_checkOnERC721Received(from, to, tokenId, _data), "ERC721: transfer to non ERC721Receiver implementer");
769     }
770 
771     /**
772      * @dev Returns whether `tokenId` exists.
773      *
774      * Tokens can be managed by their owner or approved accounts via {approve} or {setApprovalForAll}.
775      *
776      * Tokens start existing when they are minted (`_mint`),
777      * and stop existing when they are burned (`_burn`).
778      */
779     function _exists(uint256 tokenId) internal view virtual returns (bool) {
780         return _owners[tokenId] != address(0);
781     }
782 
783     /**
784      * @dev Returns whether `spender` is allowed to manage `tokenId`.
785      *
786      * Requirements:
787      *
788      * - `tokenId` must exist.
789      */
790     function _isApprovedOrOwner(address spender, uint256 tokenId) internal view virtual returns (bool) {
791         require(_exists(tokenId), "ERC721: operator query for nonexistent token");
792         address owner = ERC721.ownerOf(tokenId);
793         return (spender == owner || getApproved(tokenId) == spender || isApprovedForAll(owner, spender));
794     }
795 
796     /**
797      * @dev Safely mints `tokenId` and transfers it to `to`.
798      *
799      * Requirements:
800      *
801      * - `tokenId` must not exist.
802      * - If `to` refers to a smart contract, it must implement {IERC721Receiver-onERC721Received}, which is called upon a safe transfer.
803      *
804      * Emits a {Transfer} event.
805      */
806     function _safeMint(address to, uint256 tokenId) internal virtual {
807         _safeMint(to, tokenId, "");
808     }
809 
810     /**
811      * @dev Same as {xref-ERC721-_safeMint-address-uint256-}[`_safeMint`], with an additional `data` parameter which is
812      * forwarded in {IERC721Receiver-onERC721Received} to contract recipients.
813      */
814     function _safeMint(
815         address to,
816         uint256 tokenId,
817         bytes memory _data
818     ) internal virtual {
819         _mint(to, tokenId);
820         require(
821             _checkOnERC721Received(address(0), to, tokenId, _data),
822             "ERC721: transfer to non ERC721Receiver implementer"
823         );
824     }
825 
826     /**
827      * @dev Mints `tokenId` and transfers it to `to`.
828      *
829      * WARNING: Usage of this method is discouraged, use {_safeMint} whenever possible
830      *
831      * Requirements:
832      *
833      * - `tokenId` must not exist.
834      * - `to` cannot be the zero address.
835      *
836      * Emits a {Transfer} event.
837      */
838     function _mint(address to, uint256 tokenId) internal virtual {
839         require(to != address(0), "ERC721: mint to the zero address");
840         require(!_exists(tokenId), "ERC721: token already minted");
841 
842         _beforeTokenTransfer(address(0), to, tokenId);
843 
844         _balances[to] += 1;
845         _owners[tokenId] = to;
846 
847         emit Transfer(address(0), to, tokenId);
848     }
849 
850     /**
851      * @dev Destroys `tokenId`.
852      * The approval is cleared when the token is burned.
853      *
854      * Requirements:
855      *
856      * - `tokenId` must exist.
857      *
858      * Emits a {Transfer} event.
859      */
860     function _burn(uint256 tokenId) internal virtual {
861         address owner = ERC721.ownerOf(tokenId);
862 
863         _beforeTokenTransfer(owner, address(0), tokenId);
864 
865         // Clear approvals
866         _approve(address(0), tokenId);
867 
868         _balances[owner] -= 1;
869         delete _owners[tokenId];
870 
871         emit Transfer(owner, address(0), tokenId);
872     }
873 
874     /**
875      * @dev Transfers `tokenId` from `from` to `to`.
876      *  As opposed to {transferFrom}, this imposes no restrictions on msg.sender.
877      *
878      * Requirements:
879      *
880      * - `to` cannot be the zero address.
881      * - `tokenId` token must be owned by `from`.
882      *
883      * Emits a {Transfer} event.
884      */
885     function _transfer(
886         address from,
887         address to,
888         uint256 tokenId
889     ) internal virtual {
890         require(ERC721.ownerOf(tokenId) == from, "ERC721: transfer of token that is not own");
891         require(to != address(0), "ERC721: transfer to the zero address");
892 
893         _beforeTokenTransfer(from, to, tokenId);
894 
895         // Clear approvals from the previous owner
896         _approve(address(0), tokenId);
897 
898         _balances[from] -= 1;
899         _balances[to] += 1;
900         _owners[tokenId] = to;
901 
902         emit Transfer(from, to, tokenId);
903     }
904 
905     /**
906      * @dev Approve `to` to operate on `tokenId`
907      *
908      * Emits a {Approval} event.
909      */
910     function _approve(address to, uint256 tokenId) internal virtual {
911         _tokenApprovals[tokenId] = to;
912         emit Approval(ERC721.ownerOf(tokenId), to, tokenId);
913     }
914 
915     /**
916      * @dev Internal function to invoke {IERC721Receiver-onERC721Received} on a target address.
917      * The call is not executed if the target address is not a contract.
918      *
919      * @param from address representing the previous owner of the given token ID
920      * @param to target address that will receive the tokens
921      * @param tokenId uint256 ID of the token to be transferred
922      * @param _data bytes optional data to send along with the call
923      * @return bool whether the call correctly returned the expected magic value
924      */
925     function _checkOnERC721Received(
926         address from,
927         address to,
928         uint256 tokenId,
929         bytes memory _data
930     ) private returns (bool) {
931         if (to.isContract()) {
932             try IERC721Receiver(to).onERC721Received(_msgSender(), from, tokenId, _data) returns (bytes4 retval) {
933                 return retval == IERC721Receiver(to).onERC721Received.selector;
934             } catch (bytes memory reason) {
935                 if (reason.length == 0) {
936                     revert("ERC721: transfer to non ERC721Receiver implementer");
937                 } else {
938                     assembly {
939                         revert(add(32, reason), mload(reason))
940                     }
941                 }
942             }
943         } else {
944             return true;
945         }
946     }
947 
948     /**
949      * @dev Hook that is called before any token transfer. This includes minting
950      * and burning.
951      *
952      * Calling conditions:
953      *
954      * - When `from` and `to` are both non-zero, ``from``'s `tokenId` will be
955      * transferred to `to`.
956      * - When `from` is zero, `tokenId` will be minted for `to`.
957      * - When `to` is zero, ``from``'s `tokenId` will be burned.
958      * - `from` and `to` are never both zero.
959      *
960      * To learn more about hooks, head to xref:ROOT:extending-contracts.adoc#using-hooks[Using Hooks].
961      */
962     function _beforeTokenTransfer(
963         address from,
964         address to,
965         uint256 tokenId
966     ) internal virtual {}
967 }
968 
969 
970 // File @openzeppelin/contracts/token/ERC721/extensions/IERC721Enumerable.sol@v4.2.0
971 
972 
973 
974 /**
975  * @title ERC-721 Non-Fungible Token Standard, optional enumeration extension
976  * @dev See https://eips.ethereum.org/EIPS/eip-721
977  */
978 interface IERC721Enumerable is IERC721 {
979     /**
980      * @dev Returns the total amount of tokens stored by the contract.
981      */
982     function totalSupply() external view returns (uint256);
983 
984     /**
985      * @dev Returns a token ID owned by `owner` at a given `index` of its token list.
986      * Use along with {balanceOf} to enumerate all of ``owner``'s tokens.
987      */
988     function tokenOfOwnerByIndex(address owner, uint256 index) external view returns (uint256 tokenId);
989 
990     /**
991      * @dev Returns a token ID at a given `index` of all the tokens stored by the contract.
992      * Use along with {totalSupply} to enumerate all tokens.
993      */
994     function tokenByIndex(uint256 index) external view returns (uint256);
995 }
996 
997 
998 // File @openzeppelin/contracts/token/ERC721/extensions/ERC721Enumerable.sol@v4.2.0
999 
1000 
1001 
1002 
1003 /**
1004  * @dev This implements an optional extension of {ERC721} defined in the EIP that adds
1005  * enumerability of all the token ids in the contract as well as all token ids owned by each
1006  * account.
1007  */
1008 abstract contract ERC721Enumerable is ERC721, IERC721Enumerable {
1009     // Mapping from owner to list of owned token IDs
1010     mapping(address => mapping(uint256 => uint256)) private _ownedTokens;
1011 
1012     // Mapping from token ID to index of the owner tokens list
1013     mapping(uint256 => uint256) private _ownedTokensIndex;
1014 
1015     // Array with all token ids, used for enumeration
1016     uint256[] private _allTokens;
1017 
1018     // Mapping from token id to position in the allTokens array
1019     mapping(uint256 => uint256) private _allTokensIndex;
1020 
1021     /**
1022      * @dev See {IERC165-supportsInterface}.
1023      */
1024     function supportsInterface(bytes4 interfaceId) public view virtual override(IERC165, ERC721) returns (bool) {
1025         return interfaceId == type(IERC721Enumerable).interfaceId || super.supportsInterface(interfaceId);
1026     }
1027 
1028     /**
1029      * @dev See {IERC721Enumerable-tokenOfOwnerByIndex}.
1030      */
1031     function tokenOfOwnerByIndex(address owner, uint256 index) public view virtual override returns (uint256) {
1032         require(index < ERC721.balanceOf(owner), "ERC721Enumerable: owner index out of bounds");
1033         return _ownedTokens[owner][index];
1034     }
1035 
1036     /**
1037      * @dev See {IERC721Enumerable-totalSupply}.
1038      */
1039     function totalSupply() public view virtual override returns (uint256) {
1040         return _allTokens.length;
1041     }
1042 
1043     /**
1044      * @dev See {IERC721Enumerable-tokenByIndex}.
1045      */
1046     function tokenByIndex(uint256 index) public view virtual override returns (uint256) {
1047         require(index < ERC721Enumerable.totalSupply(), "ERC721Enumerable: global index out of bounds");
1048         return _allTokens[index];
1049     }
1050 
1051     /**
1052      * @dev Hook that is called before any token transfer. This includes minting
1053      * and burning.
1054      *
1055      * Calling conditions:
1056      *
1057      * - When `from` and `to` are both non-zero, ``from``'s `tokenId` will be
1058      * transferred to `to`.
1059      * - When `from` is zero, `tokenId` will be minted for `to`.
1060      * - When `to` is zero, ``from``'s `tokenId` will be burned.
1061      * - `from` cannot be the zero address.
1062      * - `to` cannot be the zero address.
1063      *
1064      * To learn more about hooks, head to xref:ROOT:extending-contracts.adoc#using-hooks[Using Hooks].
1065      */
1066     function _beforeTokenTransfer(
1067         address from,
1068         address to,
1069         uint256 tokenId
1070     ) internal virtual override {
1071         super._beforeTokenTransfer(from, to, tokenId);
1072 
1073         if (from == address(0)) {
1074             _addTokenToAllTokensEnumeration(tokenId);
1075         } else if (from != to) {
1076             _removeTokenFromOwnerEnumeration(from, tokenId);
1077         }
1078         if (to == address(0)) {
1079             _removeTokenFromAllTokensEnumeration(tokenId);
1080         } else if (to != from) {
1081             _addTokenToOwnerEnumeration(to, tokenId);
1082         }
1083     }
1084 
1085     /**
1086      * @dev Private function to add a token to this extension's ownership-tracking data structures.
1087      * @param to address representing the new owner of the given token ID
1088      * @param tokenId uint256 ID of the token to be added to the tokens list of the given address
1089      */
1090     function _addTokenToOwnerEnumeration(address to, uint256 tokenId) private {
1091         uint256 length = ERC721.balanceOf(to);
1092         _ownedTokens[to][length] = tokenId;
1093         _ownedTokensIndex[tokenId] = length;
1094     }
1095 
1096     /**
1097      * @dev Private function to add a token to this extension's token tracking data structures.
1098      * @param tokenId uint256 ID of the token to be added to the tokens list
1099      */
1100     function _addTokenToAllTokensEnumeration(uint256 tokenId) private {
1101         _allTokensIndex[tokenId] = _allTokens.length;
1102         _allTokens.push(tokenId);
1103     }
1104 
1105     /**
1106      * @dev Private function to remove a token from this extension's ownership-tracking data structures. Note that
1107      * while the token is not assigned a new owner, the `_ownedTokensIndex` mapping is _not_ updated: this allows for
1108      * gas optimizations e.g. when performing a transfer operation (avoiding double writes).
1109      * This has O(1) time complexity, but alters the order of the _ownedTokens array.
1110      * @param from address representing the previous owner of the given token ID
1111      * @param tokenId uint256 ID of the token to be removed from the tokens list of the given address
1112      */
1113     function _removeTokenFromOwnerEnumeration(address from, uint256 tokenId) private {
1114         // To prevent a gap in from's tokens array, we store the last token in the index of the token to delete, and
1115         // then delete the last slot (swap and pop).
1116 
1117         uint256 lastTokenIndex = ERC721.balanceOf(from) - 1;
1118         uint256 tokenIndex = _ownedTokensIndex[tokenId];
1119 
1120         // When the token to delete is the last token, the swap operation is unnecessary
1121         if (tokenIndex != lastTokenIndex) {
1122             uint256 lastTokenId = _ownedTokens[from][lastTokenIndex];
1123 
1124             _ownedTokens[from][tokenIndex] = lastTokenId; // Move the last token to the slot of the to-delete token
1125             _ownedTokensIndex[lastTokenId] = tokenIndex; // Update the moved token's index
1126         }
1127 
1128         // This also deletes the contents at the last position of the array
1129         delete _ownedTokensIndex[tokenId];
1130         delete _ownedTokens[from][lastTokenIndex];
1131     }
1132 
1133     /**
1134      * @dev Private function to remove a token from this extension's token tracking data structures.
1135      * This has O(1) time complexity, but alters the order of the _allTokens array.
1136      * @param tokenId uint256 ID of the token to be removed from the tokens list
1137      */
1138     function _removeTokenFromAllTokensEnumeration(uint256 tokenId) private {
1139         // To prevent a gap in the tokens array, we store the last token in the index of the token to delete, and
1140         // then delete the last slot (swap and pop).
1141 
1142         uint256 lastTokenIndex = _allTokens.length - 1;
1143         uint256 tokenIndex = _allTokensIndex[tokenId];
1144 
1145         // When the token to delete is the last token, the swap operation is unnecessary. However, since this occurs so
1146         // rarely (when the last minted token is burnt) that we still do the swap here to avoid the gas cost of adding
1147         // an 'if' statement (like in _removeTokenFromOwnerEnumeration)
1148         uint256 lastTokenId = _allTokens[lastTokenIndex];
1149 
1150         _allTokens[tokenIndex] = lastTokenId; // Move the last token to the slot of the to-delete token
1151         _allTokensIndex[lastTokenId] = tokenIndex; // Update the moved token's index
1152 
1153         // This also deletes the contents at the last position of the array
1154         delete _allTokensIndex[tokenId];
1155         _allTokens.pop();
1156     }
1157 }
1158 
1159 
1160 // File @openzeppelin/contracts/access/Ownable.sol@v4.2.0
1161 
1162 
1163 
1164 /**
1165  * @dev Contract module which provides a basic access control mechanism, where
1166  * there is an account (an owner) that can be granted exclusive access to
1167  * specific functions.
1168  *
1169  * By default, the owner account will be the one that deploys the contract. This
1170  * can later be changed with {transferOwnership}.
1171  *
1172  * This module is used through inheritance. It will make available the modifier
1173  * `onlyOwner`, which can be applied to your functions to restrict their use to
1174  * the owner.
1175  */
1176 abstract contract Ownable is Context {
1177     address private _owner;
1178 
1179     event OwnershipTransferred(address indexed previousOwner, address indexed newOwner);
1180 
1181     /**
1182      * @dev Initializes the contract setting the deployer as the initial owner.
1183      */
1184     constructor() {
1185         _setOwner(_msgSender());
1186     }
1187 
1188     /**
1189      * @dev Returns the address of the current owner.
1190      */
1191     function owner() public view virtual returns (address) {
1192         return _owner;
1193     }
1194 
1195     /**
1196      * @dev Throws if called by any account other than the owner.
1197      */
1198     modifier onlyOwner() {
1199         require(owner() == _msgSender(), "Ownable: caller is not the owner");
1200         _;
1201     }
1202 
1203     /**
1204      * @dev Leaves the contract without owner. It will not be possible to call
1205      * `onlyOwner` functions anymore. Can only be called by the current owner.
1206      *
1207      * NOTE: Renouncing ownership will leave the contract without an owner,
1208      * thereby removing any functionality that is only available to the owner.
1209      */
1210     function renounceOwnership() public virtual onlyOwner {
1211         _setOwner(address(0));
1212     }
1213 
1214     /**
1215      * @dev Transfers ownership of the contract to a new account (`newOwner`).
1216      * Can only be called by the current owner.
1217      */
1218     function transferOwnership(address newOwner) public virtual onlyOwner {
1219         require(newOwner != address(0), "Ownable: new owner is the zero address");
1220         _setOwner(newOwner);
1221     }
1222 
1223     function _setOwner(address newOwner) private {
1224         address oldOwner = _owner;
1225         _owner = newOwner;
1226         emit OwnershipTransferred(oldOwner, newOwner);
1227     }
1228 }
1229 
1230 
1231 // File @openzeppelin/contracts/utils/Counters.sol@v4.2.0
1232 
1233 
1234 
1235 /**
1236  * @title Counters
1237  * @author Matt Condon (@shrugs)
1238  * @dev Provides counters that can only be incremented, decremented or reset. This can be used e.g. to track the number
1239  * of elements in a mapping, issuing ERC721 ids, or counting request ids.
1240  *
1241  * Include with `using Counters for Counters.Counter;`
1242  */
1243 library Counters {
1244     struct Counter {
1245         // This variable should never be directly accessed by users of the library: interactions must be restricted to
1246         // the library's function. As of Solidity v0.5.2, this cannot be enforced, though there is a proposal to add
1247         // this feature: see https://github.com/ethereum/solidity/issues/4637
1248         uint256 _value; // default: 0
1249     }
1250 
1251     function current(Counter storage counter) internal view returns (uint256) {
1252         return counter._value;
1253     }
1254 
1255     function increment(Counter storage counter) internal {
1256         unchecked {
1257             counter._value += 1;
1258         }
1259     }
1260 
1261     function decrement(Counter storage counter) internal {
1262         uint256 value = counter._value;
1263         require(value > 0, "Counter: decrement overflow");
1264         unchecked {
1265             counter._value = value - 1;
1266         }
1267     }
1268 
1269     function reset(Counter storage counter) internal {
1270         counter._value = 0;
1271     }
1272 }
1273 
1274 
1275 // File contracts/PartyPolarBears.sol
1276 
1277 
1278 
1279 
1280 abstract contract PartyPenguins {
1281   function balanceOf(address owner) external virtual view returns (uint256 balance);
1282   function tokenOfOwnerByIndex(address owner, uint256 index) public virtual view returns (uint256);
1283 }
1284 
1285 contract PartyPolarBears is ERC721Enumerable, Ownable {
1286   string _baseTokenURI;
1287   uint256 private _maxMint = 20;
1288   uint256 private _price = 606 * 10**14; //0.0606 ETH;
1289   bool public _saleActive = false;
1290   bool public _claimActive = false;
1291   bool public _preSaleActive = false;
1292   uint public constant MAX_ENTRIES = 6060;
1293 
1294   mapping(uint256 => bool) public _claimedIds;
1295 
1296   struct UnclaimedItems {
1297       uint unclaimedItemCount;
1298       uint256[] unclaimedItemIds;
1299   }
1300 
1301   uint public constant MAX_CLAIMABLE = 3030;
1302   using Counters for Counters.Counter;
1303   Counters.Counter private _tokenClaimedTracker;
1304   PartyPenguins private party_penguins;
1305 
1306   constructor(string memory baseURI) ERC721("Party Polar Bears", "PartyPolarBears")  {
1307       setBaseURI(baseURI);
1308       party_penguins = PartyPenguins(0x31F3bba9b71cB1D5e96cD62F0bA3958C034b55E9);
1309 
1310       // team gets first 40
1311       mint(msg.sender, 40);
1312   }
1313 
1314   function _totalClaimed() public view returns (uint) {
1315       return _tokenClaimedTracker.current();
1316     }
1317 
1318   function _unclaimedItemIds(address _inputAddress) public view returns(UnclaimedItems memory) {
1319       uint tokenCount = party_penguins.balanceOf(_inputAddress);
1320 
1321       UnclaimedItems memory result = UnclaimedItems(0, new uint256[](tokenCount));
1322       for(uint256 i; i < tokenCount; i++){
1323             uint tokenId = party_penguins.tokenOfOwnerByIndex(_inputAddress, i);
1324             if (_claimedIds[tokenId] == false) {
1325                 result.unclaimedItemIds[result.unclaimedItemCount] = tokenId;
1326                 result.unclaimedItemCount +=1;
1327             }
1328         }
1329       return result;
1330   }
1331 
1332   function claim(uint256 num) public {
1333       if(msg.sender != owner()) {
1334         require(_claimActive, "Claim is not Active, wait for your turn");
1335       }
1336 
1337       uint256 _claimable_supply = _totalClaimed();
1338       require (_claimable_supply + num < (MAX_CLAIMABLE+1), "Exceeds maximum free supply" );
1339 
1340       uint256 _total_supply = totalSupply();
1341       require( _total_supply + num < (MAX_ENTRIES+1), "Exceeds maximum supply" );
1342 
1343       UnclaimedItems memory uc_items = _unclaimedItemIds(msg.sender);
1344       require (num*2 < (uc_items.unclaimedItemCount+1) , "You can only claim 1 free Polar Bear for 2 Party Penguins");
1345 
1346       for(uint256 i; i < num; i++) {
1347         _tokenClaimedTracker.increment();
1348 
1349         /** update the mapping of claimed penguin ids */
1350         _claimedIds[uc_items.unclaimedItemIds[i*2]] = true;
1351         _claimedIds[uc_items.unclaimedItemIds[i*2+1]] = true;
1352 
1353         _safeMint( msg.sender, _total_supply + i );
1354       }
1355   }
1356 
1357   function mint(address _to, uint256 num) public payable {
1358       uint256 supply = totalSupply();
1359 
1360       if(msg.sender != owner()) {
1361         if (party_penguins.balanceOf(msg.sender) < 1) {
1362             require(_saleActive, "Sale not Active");
1363         }
1364         require(_preSaleActive, "Pre Sale not Active");
1365         require( num < (_maxMint+1),"You can mint a maximum of 20 Polar Bears" );
1366         require( msg.value >= _price * num,"Ether sent is not correct" );
1367       }
1368 
1369       require( supply + num < (MAX_ENTRIES+1), "Exceeds maximum supply" );
1370 
1371       for(uint256 i; i < num; i++){
1372         _safeMint( _to, supply + i );
1373       }
1374   }
1375 
1376   function walletOfOwner(address _owner) public view returns(uint256[] memory) {
1377       uint256 tokenCount = balanceOf(_owner);
1378 
1379       uint256[] memory tokensId = new uint256[](tokenCount);
1380       for(uint256 i; i < tokenCount; i++){
1381           tokensId[i] = tokenOfOwnerByIndex(_owner, i);
1382       }
1383       return tokensId;
1384   }
1385 
1386   function getPrice() public view returns (uint256){
1387       if(msg.sender == owner()) {
1388           return 0;
1389       }
1390       return _price;
1391   }
1392 
1393   // Just in case Eth does some crazy stuff
1394   function setPrice(uint256 _newPrice) public onlyOwner() {
1395       _price = _newPrice;
1396   }
1397 
1398   function getMaxMint() public view returns (uint256){
1399       return _maxMint;
1400   }
1401 
1402   function setMaxMint(uint256 _newMaxMint) public onlyOwner() {
1403       _maxMint = _newMaxMint;
1404   }
1405 
1406   function _baseURI() internal view virtual override returns (string memory) {
1407       return _baseTokenURI;
1408   }
1409 
1410   function setBaseURI(string memory baseURI) public onlyOwner {
1411       _baseTokenURI = baseURI;
1412   }
1413 
1414   function setsaleBool(bool val) public onlyOwner {
1415       _saleActive = val;
1416   }
1417 
1418   function setclaimBool(bool val) public onlyOwner {
1419       _claimActive = val;
1420   }
1421 
1422   function setpresaleBool(bool val) public onlyOwner {
1423       _preSaleActive = val;
1424   }
1425 
1426   function withdrawAll() public payable onlyOwner {
1427       require(payable(msg.sender).send(address(this).balance));
1428   }
1429 }