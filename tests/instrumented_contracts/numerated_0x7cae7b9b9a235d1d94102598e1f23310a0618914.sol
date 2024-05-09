1 // Sources flattened with hardhat v2.4.0 https://hardhat.org
2 
3 // File @openzeppelin/contracts/utils/introspection/IERC165.sol@v4.3.1
4 
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
30 // File @openzeppelin/contracts/token/ERC721/IERC721.sol@v4.3.1
31 
32 
33 
34 pragma solidity ^0.8.0;
35 
36 /**
37  * @dev Required interface of an ERC721 compliant contract.
38  */
39 interface IERC721 is IERC165 {
40     /**
41      * @dev Emitted when `tokenId` token is transferred from `from` to `to`.
42      */
43     event Transfer(address indexed from, address indexed to, uint256 indexed tokenId);
44 
45     /**
46      * @dev Emitted when `owner` enables `approved` to manage the `tokenId` token.
47      */
48     event Approval(address indexed owner, address indexed approved, uint256 indexed tokenId);
49 
50     /**
51      * @dev Emitted when `owner` enables or disables (`approved`) `operator` to manage all of its assets.
52      */
53     event ApprovalForAll(address indexed owner, address indexed operator, bool approved);
54 
55     /**
56      * @dev Returns the number of tokens in ``owner``'s account.
57      */
58     function balanceOf(address owner) external view returns (uint256 balance);
59 
60     /**
61      * @dev Returns the owner of the `tokenId` token.
62      *
63      * Requirements:
64      *
65      * - `tokenId` must exist.
66      */
67     function ownerOf(uint256 tokenId) external view returns (address owner);
68 
69     /**
70      * @dev Safely transfers `tokenId` token from `from` to `to`, checking first that contract recipients
71      * are aware of the ERC721 protocol to prevent tokens from being forever locked.
72      *
73      * Requirements:
74      *
75      * - `from` cannot be the zero address.
76      * - `to` cannot be the zero address.
77      * - `tokenId` token must exist and be owned by `from`.
78      * - If the caller is not `from`, it must be have been allowed to move this token by either {approve} or {setApprovalForAll}.
79      * - If `to` refers to a smart contract, it must implement {IERC721Receiver-onERC721Received}, which is called upon a safe transfer.
80      *
81      * Emits a {Transfer} event.
82      */
83     function safeTransferFrom(
84         address from,
85         address to,
86         uint256 tokenId
87     ) external;
88 
89     /**
90      * @dev Transfers `tokenId` token from `from` to `to`.
91      *
92      * WARNING: Usage of this method is discouraged, use {safeTransferFrom} whenever possible.
93      *
94      * Requirements:
95      *
96      * - `from` cannot be the zero address.
97      * - `to` cannot be the zero address.
98      * - `tokenId` token must be owned by `from`.
99      * - If the caller is not `from`, it must be approved to move this token by either {approve} or {setApprovalForAll}.
100      *
101      * Emits a {Transfer} event.
102      */
103     function transferFrom(
104         address from,
105         address to,
106         uint256 tokenId
107     ) external;
108 
109     /**
110      * @dev Gives permission to `to` to transfer `tokenId` token to another account.
111      * The approval is cleared when the token is transferred.
112      *
113      * Only a single account can be approved at a time, so approving the zero address clears previous approvals.
114      *
115      * Requirements:
116      *
117      * - The caller must own the token or be an approved operator.
118      * - `tokenId` must exist.
119      *
120      * Emits an {Approval} event.
121      */
122     function approve(address to, uint256 tokenId) external;
123 
124     /**
125      * @dev Returns the account approved for `tokenId` token.
126      *
127      * Requirements:
128      *
129      * - `tokenId` must exist.
130      */
131     function getApproved(uint256 tokenId) external view returns (address operator);
132 
133     /**
134      * @dev Approve or remove `operator` as an operator for the caller.
135      * Operators can call {transferFrom} or {safeTransferFrom} for any token owned by the caller.
136      *
137      * Requirements:
138      *
139      * - The `operator` cannot be the caller.
140      *
141      * Emits an {ApprovalForAll} event.
142      */
143     function setApprovalForAll(address operator, bool _approved) external;
144 
145     /**
146      * @dev Returns if the `operator` is allowed to manage all of the assets of `owner`.
147      *
148      * See {setApprovalForAll}
149      */
150     function isApprovedForAll(address owner, address operator) external view returns (bool);
151 
152     /**
153      * @dev Safely transfers `tokenId` token from `from` to `to`.
154      *
155      * Requirements:
156      *
157      * - `from` cannot be the zero address.
158      * - `to` cannot be the zero address.
159      * - `tokenId` token must exist and be owned by `from`.
160      * - If the caller is not `from`, it must be approved to move this token by either {approve} or {setApprovalForAll}.
161      * - If `to` refers to a smart contract, it must implement {IERC721Receiver-onERC721Received}, which is called upon a safe transfer.
162      *
163      * Emits a {Transfer} event.
164      */
165     function safeTransferFrom(
166         address from,
167         address to,
168         uint256 tokenId,
169         bytes calldata data
170     ) external;
171 }
172 
173 
174 // File @openzeppelin/contracts/token/ERC721/IERC721Receiver.sol@v4.3.1
175 
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
204 // File @openzeppelin/contracts/token/ERC721/extensions/IERC721Metadata.sol@v4.3.1
205 
206 
207 
208 pragma solidity ^0.8.0;
209 
210 /**
211  * @title ERC-721 Non-Fungible Token Standard, optional metadata extension
212  * @dev See https://eips.ethereum.org/EIPS/eip-721
213  */
214 interface IERC721Metadata is IERC721 {
215     /**
216      * @dev Returns the token collection name.
217      */
218     function name() external view returns (string memory);
219 
220     /**
221      * @dev Returns the token collection symbol.
222      */
223     function symbol() external view returns (string memory);
224 
225     /**
226      * @dev Returns the Uniform Resource Identifier (URI) for `tokenId` token.
227      */
228     function tokenURI(uint256 tokenId) external view returns (string memory);
229 }
230 
231 
232 // File @openzeppelin/contracts/utils/Address.sol@v4.3.1
233 
234 
235 
236 pragma solidity ^0.8.0;
237 
238 /**
239  * @dev Collection of functions related to the address type
240  */
241 library Address {
242     /**
243      * @dev Returns true if `account` is a contract.
244      *
245      * [IMPORTANT]
246      * ====
247      * It is unsafe to assume that an address for which this function returns
248      * false is an externally-owned account (EOA) and not a contract.
249      *
250      * Among others, `isContract` will return false for the following
251      * types of addresses:
252      *
253      *  - an externally-owned account
254      *  - a contract in construction
255      *  - an address where a contract will be created
256      *  - an address where a contract lived, but was destroyed
257      * ====
258      */
259     function isContract(address account) internal view returns (bool) {
260         // This method relies on extcodesize, which returns 0 for contracts in
261         // construction, since the code is only stored at the end of the
262         // constructor execution.
263 
264         uint256 size;
265         assembly {
266             size := extcodesize(account)
267         }
268         return size > 0;
269     }
270 
271     /**
272      * @dev Replacement for Solidity's `transfer`: sends `amount` wei to
273      * `recipient`, forwarding all available gas and reverting on errors.
274      *
275      * https://eips.ethereum.org/EIPS/eip-1884[EIP1884] increases the gas cost
276      * of certain opcodes, possibly making contracts go over the 2300 gas limit
277      * imposed by `transfer`, making them unable to receive funds via
278      * `transfer`. {sendValue} removes this limitation.
279      *
280      * https://diligence.consensys.net/posts/2019/09/stop-using-soliditys-transfer-now/[Learn more].
281      *
282      * IMPORTANT: because control is transferred to `recipient`, care must be
283      * taken to not create reentrancy vulnerabilities. Consider using
284      * {ReentrancyGuard} or the
285      * https://solidity.readthedocs.io/en/v0.5.11/security-considerations.html#use-the-checks-effects-interactions-pattern[checks-effects-interactions pattern].
286      */
287     function sendValue(address payable recipient, uint256 amount) internal {
288         require(address(this).balance >= amount, "Address: insufficient balance");
289 
290         (bool success, ) = recipient.call{value: amount}("");
291         require(success, "Address: unable to send value, recipient may have reverted");
292     }
293 
294     /**
295      * @dev Performs a Solidity function call using a low level `call`. A
296      * plain `call` is an unsafe replacement for a function call: use this
297      * function instead.
298      *
299      * If `target` reverts with a revert reason, it is bubbled up by this
300      * function (like regular Solidity function calls).
301      *
302      * Returns the raw returned data. To convert to the expected return value,
303      * use https://solidity.readthedocs.io/en/latest/units-and-global-variables.html?highlight=abi.decode#abi-encoding-and-decoding-functions[`abi.decode`].
304      *
305      * Requirements:
306      *
307      * - `target` must be a contract.
308      * - calling `target` with `data` must not revert.
309      *
310      * _Available since v3.1._
311      */
312     function functionCall(address target, bytes memory data) internal returns (bytes memory) {
313         return functionCall(target, data, "Address: low-level call failed");
314     }
315 
316     /**
317      * @dev Same as {xref-Address-functionCall-address-bytes-}[`functionCall`], but with
318      * `errorMessage` as a fallback revert reason when `target` reverts.
319      *
320      * _Available since v3.1._
321      */
322     function functionCall(
323         address target,
324         bytes memory data,
325         string memory errorMessage
326     ) internal returns (bytes memory) {
327         return functionCallWithValue(target, data, 0, errorMessage);
328     }
329 
330     /**
331      * @dev Same as {xref-Address-functionCall-address-bytes-}[`functionCall`],
332      * but also transferring `value` wei to `target`.
333      *
334      * Requirements:
335      *
336      * - the calling contract must have an ETH balance of at least `value`.
337      * - the called Solidity function must be `payable`.
338      *
339      * _Available since v3.1._
340      */
341     function functionCallWithValue(
342         address target,
343         bytes memory data,
344         uint256 value
345     ) internal returns (bytes memory) {
346         return functionCallWithValue(target, data, value, "Address: low-level call with value failed");
347     }
348 
349     /**
350      * @dev Same as {xref-Address-functionCallWithValue-address-bytes-uint256-}[`functionCallWithValue`], but
351      * with `errorMessage` as a fallback revert reason when `target` reverts.
352      *
353      * _Available since v3.1._
354      */
355     function functionCallWithValue(
356         address target,
357         bytes memory data,
358         uint256 value,
359         string memory errorMessage
360     ) internal returns (bytes memory) {
361         require(address(this).balance >= value, "Address: insufficient balance for call");
362         require(isContract(target), "Address: call to non-contract");
363 
364         (bool success, bytes memory returndata) = target.call{value: value}(data);
365         return verifyCallResult(success, returndata, errorMessage);
366     }
367 
368     /**
369      * @dev Same as {xref-Address-functionCall-address-bytes-}[`functionCall`],
370      * but performing a static call.
371      *
372      * _Available since v3.3._
373      */
374     function functionStaticCall(address target, bytes memory data) internal view returns (bytes memory) {
375         return functionStaticCall(target, data, "Address: low-level static call failed");
376     }
377 
378     /**
379      * @dev Same as {xref-Address-functionCall-address-bytes-string-}[`functionCall`],
380      * but performing a static call.
381      *
382      * _Available since v3.3._
383      */
384     function functionStaticCall(
385         address target,
386         bytes memory data,
387         string memory errorMessage
388     ) internal view returns (bytes memory) {
389         require(isContract(target), "Address: static call to non-contract");
390 
391         (bool success, bytes memory returndata) = target.staticcall(data);
392         return verifyCallResult(success, returndata, errorMessage);
393     }
394 
395     /**
396      * @dev Same as {xref-Address-functionCall-address-bytes-}[`functionCall`],
397      * but performing a delegate call.
398      *
399      * _Available since v3.4._
400      */
401     function functionDelegateCall(address target, bytes memory data) internal returns (bytes memory) {
402         return functionDelegateCall(target, data, "Address: low-level delegate call failed");
403     }
404 
405     /**
406      * @dev Same as {xref-Address-functionCall-address-bytes-string-}[`functionCall`],
407      * but performing a delegate call.
408      *
409      * _Available since v3.4._
410      */
411     function functionDelegateCall(
412         address target,
413         bytes memory data,
414         string memory errorMessage
415     ) internal returns (bytes memory) {
416         require(isContract(target), "Address: delegate call to non-contract");
417 
418         (bool success, bytes memory returndata) = target.delegatecall(data);
419         return verifyCallResult(success, returndata, errorMessage);
420     }
421 
422     /**
423      * @dev Tool to verifies that a low level call was successful, and revert if it wasn't, either by bubbling the
424      * revert reason using the provided one.
425      *
426      * _Available since v4.3._
427      */
428     function verifyCallResult(
429         bool success,
430         bytes memory returndata,
431         string memory errorMessage
432     ) internal pure returns (bytes memory) {
433         if (success) {
434             return returndata;
435         } else {
436             // Look for revert reason and bubble it up if present
437             if (returndata.length > 0) {
438                 // The easiest way to bubble the revert reason is using memory via assembly
439 
440                 assembly {
441                     let returndata_size := mload(returndata)
442                     revert(add(32, returndata), returndata_size)
443                 }
444             } else {
445                 revert(errorMessage);
446             }
447         }
448     }
449 }
450 
451 
452 // File @openzeppelin/contracts/utils/Context.sol@v4.3.1
453 
454 
455 
456 pragma solidity ^0.8.0;
457 
458 /**
459  * @dev Provides information about the current execution context, including the
460  * sender of the transaction and its data. While these are generally available
461  * via msg.sender and msg.data, they should not be accessed in such a direct
462  * manner, since when dealing with meta-transactions the account sending and
463  * paying for execution may not be the actual sender (as far as an application
464  * is concerned).
465  *
466  * This contract is only required for intermediate, library-like contracts.
467  */
468 abstract contract Context {
469     function _msgSender() internal view virtual returns (address) {
470         return msg.sender;
471     }
472 
473     function _msgData() internal view virtual returns (bytes calldata) {
474         return msg.data;
475     }
476 }
477 
478 
479 // File @openzeppelin/contracts/utils/Strings.sol@v4.3.1
480 
481 
482 
483 pragma solidity ^0.8.0;
484 
485 /**
486  * @dev String operations.
487  */
488 library Strings {
489     bytes16 private constant _HEX_SYMBOLS = "0123456789abcdef";
490 
491     /**
492      * @dev Converts a `uint256` to its ASCII `string` decimal representation.
493      */
494     function toString(uint256 value) internal pure returns (string memory) {
495         // Inspired by OraclizeAPI's implementation - MIT licence
496         // https://github.com/oraclize/ethereum-api/blob/b42146b063c7d6ee1358846c198246239e9360e8/oraclizeAPI_0.4.25.sol
497 
498         if (value == 0) {
499             return "0";
500         }
501         uint256 temp = value;
502         uint256 digits;
503         while (temp != 0) {
504             digits++;
505             temp /= 10;
506         }
507         bytes memory buffer = new bytes(digits);
508         while (value != 0) {
509             digits -= 1;
510             buffer[digits] = bytes1(uint8(48 + uint256(value % 10)));
511             value /= 10;
512         }
513         return string(buffer);
514     }
515 
516     /**
517      * @dev Converts a `uint256` to its ASCII `string` hexadecimal representation.
518      */
519     function toHexString(uint256 value) internal pure returns (string memory) {
520         if (value == 0) {
521             return "0x00";
522         }
523         uint256 temp = value;
524         uint256 length = 0;
525         while (temp != 0) {
526             length++;
527             temp >>= 8;
528         }
529         return toHexString(value, length);
530     }
531 
532     /**
533      * @dev Converts a `uint256` to its ASCII `string` hexadecimal representation with fixed length.
534      */
535     function toHexString(uint256 value, uint256 length) internal pure returns (string memory) {
536         bytes memory buffer = new bytes(2 * length + 2);
537         buffer[0] = "0";
538         buffer[1] = "x";
539         for (uint256 i = 2 * length + 1; i > 1; --i) {
540             buffer[i] = _HEX_SYMBOLS[value & 0xf];
541             value >>= 4;
542         }
543         require(value == 0, "Strings: hex length insufficient");
544         return string(buffer);
545     }
546 }
547 
548 
549 // File @openzeppelin/contracts/utils/introspection/ERC165.sol@v4.3.1
550 
551 
552 
553 pragma solidity ^0.8.0;
554 
555 /**
556  * @dev Implementation of the {IERC165} interface.
557  *
558  * Contracts that want to implement ERC165 should inherit from this contract and override {supportsInterface} to check
559  * for the additional interface id that will be supported. For example:
560  *
561  * ```solidity
562  * function supportsInterface(bytes4 interfaceId) public view virtual override returns (bool) {
563  *     return interfaceId == type(MyInterface).interfaceId || super.supportsInterface(interfaceId);
564  * }
565  * ```
566  *
567  * Alternatively, {ERC165Storage} provides an easier to use but more expensive implementation.
568  */
569 abstract contract ERC165 is IERC165 {
570     /**
571      * @dev See {IERC165-supportsInterface}.
572      */
573     function supportsInterface(bytes4 interfaceId) public view virtual override returns (bool) {
574         return interfaceId == type(IERC165).interfaceId;
575     }
576 }
577 
578 
579 // File @openzeppelin/contracts/token/ERC721/ERC721.sol@v4.3.1
580 
581 
582 
583 pragma solidity ^0.8.0;
584 
585 
586 
587 
588 
589 
590 
591 /**
592  * @dev Implementation of https://eips.ethereum.org/EIPS/eip-721[ERC721] Non-Fungible Token Standard, including
593  * the Metadata extension, but not including the Enumerable extension, which is available separately as
594  * {ERC721Enumerable}.
595  */
596 contract ERC721 is Context, ERC165, IERC721, IERC721Metadata {
597     using Address for address;
598     using Strings for uint256;
599 
600     // Token name
601     string private _name;
602 
603     // Token symbol
604     string private _symbol;
605 
606     // Mapping from token ID to owner address
607     mapping(uint256 => address) private _owners;
608 
609     // Mapping owner address to token count
610     mapping(address => uint256) private _balances;
611 
612     // Mapping from token ID to approved address
613     mapping(uint256 => address) private _tokenApprovals;
614 
615     // Mapping from owner to operator approvals
616     mapping(address => mapping(address => bool)) private _operatorApprovals;
617 
618     /**
619      * @dev Initializes the contract by setting a `name` and a `symbol` to the token collection.
620      */
621     constructor(string memory name_, string memory symbol_) {
622         _name = name_;
623         _symbol = symbol_;
624     }
625 
626     /**
627      * @dev See {IERC165-supportsInterface}.
628      */
629     function supportsInterface(bytes4 interfaceId) public view virtual override(ERC165, IERC165) returns (bool) {
630         return
631             interfaceId == type(IERC721).interfaceId ||
632             interfaceId == type(IERC721Metadata).interfaceId ||
633             super.supportsInterface(interfaceId);
634     }
635 
636     /**
637      * @dev See {IERC721-balanceOf}.
638      */
639     function balanceOf(address owner) public view virtual override returns (uint256) {
640         require(owner != address(0), "ERC721: balance query for the zero address");
641         return _balances[owner];
642     }
643 
644     /**
645      * @dev See {IERC721-ownerOf}.
646      */
647     function ownerOf(uint256 tokenId) public view virtual override returns (address) {
648         address owner = _owners[tokenId];
649         require(owner != address(0), "ERC721: owner query for nonexistent token");
650         return owner;
651     }
652 
653     /**
654      * @dev See {IERC721Metadata-name}.
655      */
656     function name() public view virtual override returns (string memory) {
657         return _name;
658     }
659 
660     /**
661      * @dev See {IERC721Metadata-symbol}.
662      */
663     function symbol() public view virtual override returns (string memory) {
664         return _symbol;
665     }
666 
667     /**
668      * @dev See {IERC721Metadata-tokenURI}.
669      */
670     function tokenURI(uint256 tokenId) public view virtual override returns (string memory) {
671         require(_exists(tokenId), "ERC721Metadata: URI query for nonexistent token");
672 
673         string memory baseURI = _baseURI();
674         return bytes(baseURI).length > 0 ? string(abi.encodePacked(baseURI, tokenId.toString())) : "";
675     }
676 
677     /**
678      * @dev Base URI for computing {tokenURI}. If set, the resulting URI for each
679      * token will be the concatenation of the `baseURI` and the `tokenId`. Empty
680      * by default, can be overriden in child contracts.
681      */
682     function _baseURI() internal view virtual returns (string memory) {
683         return "";
684     }
685 
686     /**
687      * @dev See {IERC721-approve}.
688      */
689     function approve(address to, uint256 tokenId) public virtual override {
690         address owner = ERC721.ownerOf(tokenId);
691         require(to != owner, "ERC721: approval to current owner");
692 
693         require(
694             _msgSender() == owner || isApprovedForAll(owner, _msgSender()),
695             "ERC721: approve caller is not owner nor approved for all"
696         );
697 
698         _approve(to, tokenId);
699     }
700 
701     /**
702      * @dev See {IERC721-getApproved}.
703      */
704     function getApproved(uint256 tokenId) public view virtual override returns (address) {
705         require(_exists(tokenId), "ERC721: approved query for nonexistent token");
706 
707         return _tokenApprovals[tokenId];
708     }
709 
710     /**
711      * @dev See {IERC721-setApprovalForAll}.
712      */
713     function setApprovalForAll(address operator, bool approved) public virtual override {
714         require(operator != _msgSender(), "ERC721: approve to caller");
715 
716         _operatorApprovals[_msgSender()][operator] = approved;
717         emit ApprovalForAll(_msgSender(), operator, approved);
718     }
719 
720     /**
721      * @dev See {IERC721-isApprovedForAll}.
722      */
723     function isApprovedForAll(address owner, address operator) public view virtual override returns (bool) {
724         return _operatorApprovals[owner][operator];
725     }
726 
727     /**
728      * @dev See {IERC721-transferFrom}.
729      */
730     function transferFrom(
731         address from,
732         address to,
733         uint256 tokenId
734     ) public virtual override {
735         //solhint-disable-next-line max-line-length
736         require(_isApprovedOrOwner(_msgSender(), tokenId), "ERC721: transfer caller is not owner nor approved");
737 
738         _transfer(from, to, tokenId);
739     }
740 
741     /**
742      * @dev See {IERC721-safeTransferFrom}.
743      */
744     function safeTransferFrom(
745         address from,
746         address to,
747         uint256 tokenId
748     ) public virtual override {
749         safeTransferFrom(from, to, tokenId, "");
750     }
751 
752     /**
753      * @dev See {IERC721-safeTransferFrom}.
754      */
755     function safeTransferFrom(
756         address from,
757         address to,
758         uint256 tokenId,
759         bytes memory _data
760     ) public virtual override {
761         require(_isApprovedOrOwner(_msgSender(), tokenId), "ERC721: transfer caller is not owner nor approved");
762         _safeTransfer(from, to, tokenId, _data);
763     }
764 
765     /**
766      * @dev Safely transfers `tokenId` token from `from` to `to`, checking first that contract recipients
767      * are aware of the ERC721 protocol to prevent tokens from being forever locked.
768      *
769      * `_data` is additional data, it has no specified format and it is sent in call to `to`.
770      *
771      * This internal function is equivalent to {safeTransferFrom}, and can be used to e.g.
772      * implement alternative mechanisms to perform token transfer, such as signature-based.
773      *
774      * Requirements:
775      *
776      * - `from` cannot be the zero address.
777      * - `to` cannot be the zero address.
778      * - `tokenId` token must exist and be owned by `from`.
779      * - If `to` refers to a smart contract, it must implement {IERC721Receiver-onERC721Received}, which is called upon a safe transfer.
780      *
781      * Emits a {Transfer} event.
782      */
783     function _safeTransfer(
784         address from,
785         address to,
786         uint256 tokenId,
787         bytes memory _data
788     ) internal virtual {
789         _transfer(from, to, tokenId);
790         require(_checkOnERC721Received(from, to, tokenId, _data), "ERC721: transfer to non ERC721Receiver implementer");
791     }
792 
793     /**
794      * @dev Returns whether `tokenId` exists.
795      *
796      * Tokens can be managed by their owner or approved accounts via {approve} or {setApprovalForAll}.
797      *
798      * Tokens start existing when they are minted (`_mint`),
799      * and stop existing when they are burned (`_burn`).
800      */
801     function _exists(uint256 tokenId) internal view virtual returns (bool) {
802         return _owners[tokenId] != address(0);
803     }
804 
805     /**
806      * @dev Returns whether `spender` is allowed to manage `tokenId`.
807      *
808      * Requirements:
809      *
810      * - `tokenId` must exist.
811      */
812     function _isApprovedOrOwner(address spender, uint256 tokenId) internal view virtual returns (bool) {
813         require(_exists(tokenId), "ERC721: operator query for nonexistent token");
814         address owner = ERC721.ownerOf(tokenId);
815         return (spender == owner || getApproved(tokenId) == spender || isApprovedForAll(owner, spender));
816     }
817 
818     /**
819      * @dev Safely mints `tokenId` and transfers it to `to`.
820      *
821      * Requirements:
822      *
823      * - `tokenId` must not exist.
824      * - If `to` refers to a smart contract, it must implement {IERC721Receiver-onERC721Received}, which is called upon a safe transfer.
825      *
826      * Emits a {Transfer} event.
827      */
828     function _safeMint(address to, uint256 tokenId) internal virtual {
829         _safeMint(to, tokenId, "");
830     }
831 
832     /**
833      * @dev Same as {xref-ERC721-_safeMint-address-uint256-}[`_safeMint`], with an additional `data` parameter which is
834      * forwarded in {IERC721Receiver-onERC721Received} to contract recipients.
835      */
836     function _safeMint(
837         address to,
838         uint256 tokenId,
839         bytes memory _data
840     ) internal virtual {
841         _mint(to, tokenId);
842         require(
843             _checkOnERC721Received(address(0), to, tokenId, _data),
844             "ERC721: transfer to non ERC721Receiver implementer"
845         );
846     }
847 
848     /**
849      * @dev Mints `tokenId` and transfers it to `to`.
850      *
851      * WARNING: Usage of this method is discouraged, use {_safeMint} whenever possible
852      *
853      * Requirements:
854      *
855      * - `tokenId` must not exist.
856      * - `to` cannot be the zero address.
857      *
858      * Emits a {Transfer} event.
859      */
860     function _mint(address to, uint256 tokenId) internal virtual {
861         require(to != address(0), "ERC721: mint to the zero address");
862         require(!_exists(tokenId), "ERC721: token already minted");
863 
864         _beforeTokenTransfer(address(0), to, tokenId);
865 
866         _balances[to] += 1;
867         _owners[tokenId] = to;
868 
869         emit Transfer(address(0), to, tokenId);
870     }
871 
872     /**
873      * @dev Destroys `tokenId`.
874      * The approval is cleared when the token is burned.
875      *
876      * Requirements:
877      *
878      * - `tokenId` must exist.
879      *
880      * Emits a {Transfer} event.
881      */
882     function _burn(uint256 tokenId) internal virtual {
883         address owner = ERC721.ownerOf(tokenId);
884 
885         _beforeTokenTransfer(owner, address(0), tokenId);
886 
887         // Clear approvals
888         _approve(address(0), tokenId);
889 
890         _balances[owner] -= 1;
891         delete _owners[tokenId];
892 
893         emit Transfer(owner, address(0), tokenId);
894     }
895 
896     /**
897      * @dev Transfers `tokenId` from `from` to `to`.
898      *  As opposed to {transferFrom}, this imposes no restrictions on msg.sender.
899      *
900      * Requirements:
901      *
902      * - `to` cannot be the zero address.
903      * - `tokenId` token must be owned by `from`.
904      *
905      * Emits a {Transfer} event.
906      */
907     function _transfer(
908         address from,
909         address to,
910         uint256 tokenId
911     ) internal virtual {
912         require(ERC721.ownerOf(tokenId) == from, "ERC721: transfer of token that is not own");
913         require(to != address(0), "ERC721: transfer to the zero address");
914 
915         _beforeTokenTransfer(from, to, tokenId);
916 
917         // Clear approvals from the previous owner
918         _approve(address(0), tokenId);
919 
920         _balances[from] -= 1;
921         _balances[to] += 1;
922         _owners[tokenId] = to;
923 
924         emit Transfer(from, to, tokenId);
925     }
926 
927     /**
928      * @dev Approve `to` to operate on `tokenId`
929      *
930      * Emits a {Approval} event.
931      */
932     function _approve(address to, uint256 tokenId) internal virtual {
933         _tokenApprovals[tokenId] = to;
934         emit Approval(ERC721.ownerOf(tokenId), to, tokenId);
935     }
936 
937     /**
938      * @dev Internal function to invoke {IERC721Receiver-onERC721Received} on a target address.
939      * The call is not executed if the target address is not a contract.
940      *
941      * @param from address representing the previous owner of the given token ID
942      * @param to target address that will receive the tokens
943      * @param tokenId uint256 ID of the token to be transferred
944      * @param _data bytes optional data to send along with the call
945      * @return bool whether the call correctly returned the expected magic value
946      */
947     function _checkOnERC721Received(
948         address from,
949         address to,
950         uint256 tokenId,
951         bytes memory _data
952     ) private returns (bool) {
953         if (to.isContract()) {
954             try IERC721Receiver(to).onERC721Received(_msgSender(), from, tokenId, _data) returns (bytes4 retval) {
955                 return retval == IERC721Receiver.onERC721Received.selector;
956             } catch (bytes memory reason) {
957                 if (reason.length == 0) {
958                     revert("ERC721: transfer to non ERC721Receiver implementer");
959                 } else {
960                     assembly {
961                         revert(add(32, reason), mload(reason))
962                     }
963                 }
964             }
965         } else {
966             return true;
967         }
968     }
969 
970     /**
971      * @dev Hook that is called before any token transfer. This includes minting
972      * and burning.
973      *
974      * Calling conditions:
975      *
976      * - When `from` and `to` are both non-zero, ``from``'s `tokenId` will be
977      * transferred to `to`.
978      * - When `from` is zero, `tokenId` will be minted for `to`.
979      * - When `to` is zero, ``from``'s `tokenId` will be burned.
980      * - `from` and `to` are never both zero.
981      *
982      * To learn more about hooks, head to xref:ROOT:extending-contracts.adoc#using-hooks[Using Hooks].
983      */
984     function _beforeTokenTransfer(
985         address from,
986         address to,
987         uint256 tokenId
988     ) internal virtual {}
989 }
990 
991 
992 // File @openzeppelin/contracts/token/ERC721/extensions/IERC721Enumerable.sol@v4.3.1
993 
994 
995 
996 pragma solidity ^0.8.0;
997 
998 /**
999  * @title ERC-721 Non-Fungible Token Standard, optional enumeration extension
1000  * @dev See https://eips.ethereum.org/EIPS/eip-721
1001  */
1002 interface IERC721Enumerable is IERC721 {
1003     /**
1004      * @dev Returns the total amount of tokens stored by the contract.
1005      */
1006     function totalSupply() external view returns (uint256);
1007 
1008     /**
1009      * @dev Returns a token ID owned by `owner` at a given `index` of its token list.
1010      * Use along with {balanceOf} to enumerate all of ``owner``'s tokens.
1011      */
1012     function tokenOfOwnerByIndex(address owner, uint256 index) external view returns (uint256 tokenId);
1013 
1014     /**
1015      * @dev Returns a token ID at a given `index` of all the tokens stored by the contract.
1016      * Use along with {totalSupply} to enumerate all tokens.
1017      */
1018     function tokenByIndex(uint256 index) external view returns (uint256);
1019 }
1020 
1021 
1022 // File @openzeppelin/contracts/token/ERC721/extensions/ERC721Enumerable.sol@v4.3.1
1023 
1024 
1025 
1026 pragma solidity ^0.8.0;
1027 
1028 
1029 /**
1030  * @dev This implements an optional extension of {ERC721} defined in the EIP that adds
1031  * enumerability of all the token ids in the contract as well as all token ids owned by each
1032  * account.
1033  */
1034 abstract contract ERC721Enumerable is ERC721, IERC721Enumerable {
1035     // Mapping from owner to list of owned token IDs
1036     mapping(address => mapping(uint256 => uint256)) private _ownedTokens;
1037 
1038     // Mapping from token ID to index of the owner tokens list
1039     mapping(uint256 => uint256) private _ownedTokensIndex;
1040 
1041     // Array with all token ids, used for enumeration
1042     uint256[] private _allTokens;
1043 
1044     // Mapping from token id to position in the allTokens array
1045     mapping(uint256 => uint256) private _allTokensIndex;
1046 
1047     /**
1048      * @dev See {IERC165-supportsInterface}.
1049      */
1050     function supportsInterface(bytes4 interfaceId) public view virtual override(IERC165, ERC721) returns (bool) {
1051         return interfaceId == type(IERC721Enumerable).interfaceId || super.supportsInterface(interfaceId);
1052     }
1053 
1054     /**
1055      * @dev See {IERC721Enumerable-tokenOfOwnerByIndex}.
1056      */
1057     function tokenOfOwnerByIndex(address owner, uint256 index) public view virtual override returns (uint256) {
1058         require(index < ERC721.balanceOf(owner), "ERC721Enumerable: owner index out of bounds");
1059         return _ownedTokens[owner][index];
1060     }
1061 
1062     /**
1063      * @dev See {IERC721Enumerable-totalSupply}.
1064      */
1065     function totalSupply() public view virtual override returns (uint256) {
1066         return _allTokens.length;
1067     }
1068 
1069     /**
1070      * @dev See {IERC721Enumerable-tokenByIndex}.
1071      */
1072     function tokenByIndex(uint256 index) public view virtual override returns (uint256) {
1073         require(index < ERC721Enumerable.totalSupply(), "ERC721Enumerable: global index out of bounds");
1074         return _allTokens[index];
1075     }
1076 
1077     /**
1078      * @dev Hook that is called before any token transfer. This includes minting
1079      * and burning.
1080      *
1081      * Calling conditions:
1082      *
1083      * - When `from` and `to` are both non-zero, ``from``'s `tokenId` will be
1084      * transferred to `to`.
1085      * - When `from` is zero, `tokenId` will be minted for `to`.
1086      * - When `to` is zero, ``from``'s `tokenId` will be burned.
1087      * - `from` cannot be the zero address.
1088      * - `to` cannot be the zero address.
1089      *
1090      * To learn more about hooks, head to xref:ROOT:extending-contracts.adoc#using-hooks[Using Hooks].
1091      */
1092     function _beforeTokenTransfer(
1093         address from,
1094         address to,
1095         uint256 tokenId
1096     ) internal virtual override {
1097         super._beforeTokenTransfer(from, to, tokenId);
1098 
1099         if (from == address(0)) {
1100             _addTokenToAllTokensEnumeration(tokenId);
1101         } else if (from != to) {
1102             _removeTokenFromOwnerEnumeration(from, tokenId);
1103         }
1104         if (to == address(0)) {
1105             _removeTokenFromAllTokensEnumeration(tokenId);
1106         } else if (to != from) {
1107             _addTokenToOwnerEnumeration(to, tokenId);
1108         }
1109     }
1110 
1111     /**
1112      * @dev Private function to add a token to this extension's ownership-tracking data structures.
1113      * @param to address representing the new owner of the given token ID
1114      * @param tokenId uint256 ID of the token to be added to the tokens list of the given address
1115      */
1116     function _addTokenToOwnerEnumeration(address to, uint256 tokenId) private {
1117         uint256 length = ERC721.balanceOf(to);
1118         _ownedTokens[to][length] = tokenId;
1119         _ownedTokensIndex[tokenId] = length;
1120     }
1121 
1122     /**
1123      * @dev Private function to add a token to this extension's token tracking data structures.
1124      * @param tokenId uint256 ID of the token to be added to the tokens list
1125      */
1126     function _addTokenToAllTokensEnumeration(uint256 tokenId) private {
1127         _allTokensIndex[tokenId] = _allTokens.length;
1128         _allTokens.push(tokenId);
1129     }
1130 
1131     /**
1132      * @dev Private function to remove a token from this extension's ownership-tracking data structures. Note that
1133      * while the token is not assigned a new owner, the `_ownedTokensIndex` mapping is _not_ updated: this allows for
1134      * gas optimizations e.g. when performing a transfer operation (avoiding double writes).
1135      * This has O(1) time complexity, but alters the order of the _ownedTokens array.
1136      * @param from address representing the previous owner of the given token ID
1137      * @param tokenId uint256 ID of the token to be removed from the tokens list of the given address
1138      */
1139     function _removeTokenFromOwnerEnumeration(address from, uint256 tokenId) private {
1140         // To prevent a gap in from's tokens array, we store the last token in the index of the token to delete, and
1141         // then delete the last slot (swap and pop).
1142 
1143         uint256 lastTokenIndex = ERC721.balanceOf(from) - 1;
1144         uint256 tokenIndex = _ownedTokensIndex[tokenId];
1145 
1146         // When the token to delete is the last token, the swap operation is unnecessary
1147         if (tokenIndex != lastTokenIndex) {
1148             uint256 lastTokenId = _ownedTokens[from][lastTokenIndex];
1149 
1150             _ownedTokens[from][tokenIndex] = lastTokenId; // Move the last token to the slot of the to-delete token
1151             _ownedTokensIndex[lastTokenId] = tokenIndex; // Update the moved token's index
1152         }
1153 
1154         // This also deletes the contents at the last position of the array
1155         delete _ownedTokensIndex[tokenId];
1156         delete _ownedTokens[from][lastTokenIndex];
1157     }
1158 
1159     /**
1160      * @dev Private function to remove a token from this extension's token tracking data structures.
1161      * This has O(1) time complexity, but alters the order of the _allTokens array.
1162      * @param tokenId uint256 ID of the token to be removed from the tokens list
1163      */
1164     function _removeTokenFromAllTokensEnumeration(uint256 tokenId) private {
1165         // To prevent a gap in the tokens array, we store the last token in the index of the token to delete, and
1166         // then delete the last slot (swap and pop).
1167 
1168         uint256 lastTokenIndex = _allTokens.length - 1;
1169         uint256 tokenIndex = _allTokensIndex[tokenId];
1170 
1171         // When the token to delete is the last token, the swap operation is unnecessary. However, since this occurs so
1172         // rarely (when the last minted token is burnt) that we still do the swap here to avoid the gas cost of adding
1173         // an 'if' statement (like in _removeTokenFromOwnerEnumeration)
1174         uint256 lastTokenId = _allTokens[lastTokenIndex];
1175 
1176         _allTokens[tokenIndex] = lastTokenId; // Move the last token to the slot of the to-delete token
1177         _allTokensIndex[lastTokenId] = tokenIndex; // Update the moved token's index
1178 
1179         // This also deletes the contents at the last position of the array
1180         delete _allTokensIndex[tokenId];
1181         _allTokens.pop();
1182     }
1183 }
1184 
1185 
1186 // File @openzeppelin/contracts/utils/Counters.sol@v4.3.1
1187 
1188 
1189 
1190 pragma solidity ^0.8.0;
1191 
1192 /**
1193  * @title Counters
1194  * @author Matt Condon (@shrugs)
1195  * @dev Provides counters that can only be incremented, decremented or reset. This can be used e.g. to track the number
1196  * of elements in a mapping, issuing ERC721 ids, or counting request ids.
1197  *
1198  * Include with `using Counters for Counters.Counter;`
1199  */
1200 library Counters {
1201     struct Counter {
1202         // This variable should never be directly accessed by users of the library: interactions must be restricted to
1203         // the library's function. As of Solidity v0.5.2, this cannot be enforced, though there is a proposal to add
1204         // this feature: see https://github.com/ethereum/solidity/issues/4637
1205         uint256 _value; // default: 0
1206     }
1207 
1208     function current(Counter storage counter) internal view returns (uint256) {
1209         return counter._value;
1210     }
1211 
1212     function increment(Counter storage counter) internal {
1213         unchecked {
1214             counter._value += 1;
1215         }
1216     }
1217 
1218     function decrement(Counter storage counter) internal {
1219         uint256 value = counter._value;
1220         require(value > 0, "Counter: decrement overflow");
1221         unchecked {
1222             counter._value = value - 1;
1223         }
1224     }
1225 
1226     function reset(Counter storage counter) internal {
1227         counter._value = 0;
1228     }
1229 }
1230 
1231 
1232 // File @openzeppelin/contracts/access/Ownable.sol@v4.3.1
1233 
1234 
1235 
1236 pragma solidity ^0.8.0;
1237 
1238 /**
1239  * @dev Contract module which provides a basic access control mechanism, where
1240  * there is an account (an owner) that can be granted exclusive access to
1241  * specific functions.
1242  *
1243  * By default, the owner account will be the one that deploys the contract. This
1244  * can later be changed with {transferOwnership}.
1245  *
1246  * This module is used through inheritance. It will make available the modifier
1247  * `onlyOwner`, which can be applied to your functions to restrict their use to
1248  * the owner.
1249  */
1250 abstract contract Ownable is Context {
1251     address private _owner;
1252 
1253     event OwnershipTransferred(address indexed previousOwner, address indexed newOwner);
1254 
1255     /**
1256      * @dev Initializes the contract setting the deployer as the initial owner.
1257      */
1258     constructor() {
1259         _setOwner(_msgSender());
1260     }
1261 
1262     /**
1263      * @dev Returns the address of the current owner.
1264      */
1265     function owner() public view virtual returns (address) {
1266         return _owner;
1267     }
1268 
1269     /**
1270      * @dev Throws if called by any account other than the owner.
1271      */
1272     modifier onlyOwner() {
1273         require(owner() == _msgSender(), "Ownable: caller is not the owner");
1274         _;
1275     }
1276 
1277     /**
1278      * @dev Leaves the contract without owner. It will not be possible to call
1279      * `onlyOwner` functions anymore. Can only be called by the current owner.
1280      *
1281      * NOTE: Renouncing ownership will leave the contract without an owner,
1282      * thereby removing any functionality that is only available to the owner.
1283      */
1284     function renounceOwnership() public virtual onlyOwner {
1285         _setOwner(address(0));
1286     }
1287 
1288     /**
1289      * @dev Transfers ownership of the contract to a new account (`newOwner`).
1290      * Can only be called by the current owner.
1291      */
1292     function transferOwnership(address newOwner) public virtual onlyOwner {
1293         require(newOwner != address(0), "Ownable: new owner is the zero address");
1294         _setOwner(newOwner);
1295     }
1296 
1297     function _setOwner(address newOwner) private {
1298         address oldOwner = _owner;
1299         _owner = newOwner;
1300         emit OwnershipTransferred(oldOwner, newOwner);
1301     }
1302 }
1303 
1304 
1305 // File @openzeppelin/contracts/utils/math/SafeMath.sol@v4.3.1
1306 
1307 
1308 
1309 pragma solidity ^0.8.0;
1310 
1311 // CAUTION
1312 // This version of SafeMath should only be used with Solidity 0.8 or later,
1313 // because it relies on the compiler's built in overflow checks.
1314 
1315 /**
1316  * @dev Wrappers over Solidity's arithmetic operations.
1317  *
1318  * NOTE: `SafeMath` is no longer needed starting with Solidity 0.8. The compiler
1319  * now has built in overflow checking.
1320  */
1321 library SafeMath {
1322     /**
1323      * @dev Returns the addition of two unsigned integers, with an overflow flag.
1324      *
1325      * _Available since v3.4._
1326      */
1327     function tryAdd(uint256 a, uint256 b) internal pure returns (bool, uint256) {
1328         unchecked {
1329             uint256 c = a + b;
1330             if (c < a) return (false, 0);
1331             return (true, c);
1332         }
1333     }
1334 
1335     /**
1336      * @dev Returns the substraction of two unsigned integers, with an overflow flag.
1337      *
1338      * _Available since v3.4._
1339      */
1340     function trySub(uint256 a, uint256 b) internal pure returns (bool, uint256) {
1341         unchecked {
1342             if (b > a) return (false, 0);
1343             return (true, a - b);
1344         }
1345     }
1346 
1347     /**
1348      * @dev Returns the multiplication of two unsigned integers, with an overflow flag.
1349      *
1350      * _Available since v3.4._
1351      */
1352     function tryMul(uint256 a, uint256 b) internal pure returns (bool, uint256) {
1353         unchecked {
1354             // Gas optimization: this is cheaper than requiring 'a' not being zero, but the
1355             // benefit is lost if 'b' is also tested.
1356             // See: https://github.com/OpenZeppelin/openzeppelin-contracts/pull/522
1357             if (a == 0) return (true, 0);
1358             uint256 c = a * b;
1359             if (c / a != b) return (false, 0);
1360             return (true, c);
1361         }
1362     }
1363 
1364     /**
1365      * @dev Returns the division of two unsigned integers, with a division by zero flag.
1366      *
1367      * _Available since v3.4._
1368      */
1369     function tryDiv(uint256 a, uint256 b) internal pure returns (bool, uint256) {
1370         unchecked {
1371             if (b == 0) return (false, 0);
1372             return (true, a / b);
1373         }
1374     }
1375 
1376     /**
1377      * @dev Returns the remainder of dividing two unsigned integers, with a division by zero flag.
1378      *
1379      * _Available since v3.4._
1380      */
1381     function tryMod(uint256 a, uint256 b) internal pure returns (bool, uint256) {
1382         unchecked {
1383             if (b == 0) return (false, 0);
1384             return (true, a % b);
1385         }
1386     }
1387 
1388     /**
1389      * @dev Returns the addition of two unsigned integers, reverting on
1390      * overflow.
1391      *
1392      * Counterpart to Solidity's `+` operator.
1393      *
1394      * Requirements:
1395      *
1396      * - Addition cannot overflow.
1397      */
1398     function add(uint256 a, uint256 b) internal pure returns (uint256) {
1399         return a + b;
1400     }
1401 
1402     /**
1403      * @dev Returns the subtraction of two unsigned integers, reverting on
1404      * overflow (when the result is negative).
1405      *
1406      * Counterpart to Solidity's `-` operator.
1407      *
1408      * Requirements:
1409      *
1410      * - Subtraction cannot overflow.
1411      */
1412     function sub(uint256 a, uint256 b) internal pure returns (uint256) {
1413         return a - b;
1414     }
1415 
1416     /**
1417      * @dev Returns the multiplication of two unsigned integers, reverting on
1418      * overflow.
1419      *
1420      * Counterpart to Solidity's `*` operator.
1421      *
1422      * Requirements:
1423      *
1424      * - Multiplication cannot overflow.
1425      */
1426     function mul(uint256 a, uint256 b) internal pure returns (uint256) {
1427         return a * b;
1428     }
1429 
1430     /**
1431      * @dev Returns the integer division of two unsigned integers, reverting on
1432      * division by zero. The result is rounded towards zero.
1433      *
1434      * Counterpart to Solidity's `/` operator.
1435      *
1436      * Requirements:
1437      *
1438      * - The divisor cannot be zero.
1439      */
1440     function div(uint256 a, uint256 b) internal pure returns (uint256) {
1441         return a / b;
1442     }
1443 
1444     /**
1445      * @dev Returns the remainder of dividing two unsigned integers. (unsigned integer modulo),
1446      * reverting when dividing by zero.
1447      *
1448      * Counterpart to Solidity's `%` operator. This function uses a `revert`
1449      * opcode (which leaves remaining gas untouched) while Solidity uses an
1450      * invalid opcode to revert (consuming all remaining gas).
1451      *
1452      * Requirements:
1453      *
1454      * - The divisor cannot be zero.
1455      */
1456     function mod(uint256 a, uint256 b) internal pure returns (uint256) {
1457         return a % b;
1458     }
1459 
1460     /**
1461      * @dev Returns the subtraction of two unsigned integers, reverting with custom message on
1462      * overflow (when the result is negative).
1463      *
1464      * CAUTION: This function is deprecated because it requires allocating memory for the error
1465      * message unnecessarily. For custom revert reasons use {trySub}.
1466      *
1467      * Counterpart to Solidity's `-` operator.
1468      *
1469      * Requirements:
1470      *
1471      * - Subtraction cannot overflow.
1472      */
1473     function sub(
1474         uint256 a,
1475         uint256 b,
1476         string memory errorMessage
1477     ) internal pure returns (uint256) {
1478         unchecked {
1479             require(b <= a, errorMessage);
1480             return a - b;
1481         }
1482     }
1483 
1484     /**
1485      * @dev Returns the integer division of two unsigned integers, reverting with custom message on
1486      * division by zero. The result is rounded towards zero.
1487      *
1488      * Counterpart to Solidity's `/` operator. Note: this function uses a
1489      * `revert` opcode (which leaves remaining gas untouched) while Solidity
1490      * uses an invalid opcode to revert (consuming all remaining gas).
1491      *
1492      * Requirements:
1493      *
1494      * - The divisor cannot be zero.
1495      */
1496     function div(
1497         uint256 a,
1498         uint256 b,
1499         string memory errorMessage
1500     ) internal pure returns (uint256) {
1501         unchecked {
1502             require(b > 0, errorMessage);
1503             return a / b;
1504         }
1505     }
1506 
1507     /**
1508      * @dev Returns the remainder of dividing two unsigned integers. (unsigned integer modulo),
1509      * reverting with custom message when dividing by zero.
1510      *
1511      * CAUTION: This function is deprecated because it requires allocating memory for the error
1512      * message unnecessarily. For custom revert reasons use {tryMod}.
1513      *
1514      * Counterpart to Solidity's `%` operator. This function uses a `revert`
1515      * opcode (which leaves remaining gas untouched) while Solidity uses an
1516      * invalid opcode to revert (consuming all remaining gas).
1517      *
1518      * Requirements:
1519      *
1520      * - The divisor cannot be zero.
1521      */
1522     function mod(
1523         uint256 a,
1524         uint256 b,
1525         string memory errorMessage
1526     ) internal pure returns (uint256) {
1527         unchecked {
1528             require(b > 0, errorMessage);
1529             return a % b;
1530         }
1531     }
1532 }
1533 
1534 
1535 // File @openzeppelin/contracts/finance/PaymentSplitter.sol@v4.3.1
1536 
1537 
1538 
1539 pragma solidity ^0.8.0;
1540 
1541 
1542 
1543 /**
1544  * @title PaymentSplitter
1545  * @dev This contract allows to split Ether payments among a group of accounts. The sender does not need to be aware
1546  * that the Ether will be split in this way, since it is handled transparently by the contract.
1547  *
1548  * The split can be in equal parts or in any other arbitrary proportion. The way this is specified is by assigning each
1549  * account to a number of shares. Of all the Ether that this contract receives, each account will then be able to claim
1550  * an amount proportional to the percentage of total shares they were assigned.
1551  *
1552  * `PaymentSplitter` follows a _pull payment_ model. This means that payments are not automatically forwarded to the
1553  * accounts but kept in this contract, and the actual transfer is triggered as a separate step by calling the {release}
1554  * function.
1555  */
1556 contract PaymentSplitter is Context {
1557     event PayeeAdded(address account, uint256 shares);
1558     event PaymentReleased(address to, uint256 amount);
1559     event PaymentReceived(address from, uint256 amount);
1560 
1561     uint256 private _totalShares;
1562     uint256 private _totalReleased;
1563 
1564     mapping(address => uint256) private _shares;
1565     mapping(address => uint256) private _released;
1566     address[] private _payees;
1567 
1568     /**
1569      * @dev Creates an instance of `PaymentSplitter` where each account in `payees` is assigned the number of shares at
1570      * the matching position in the `shares` array.
1571      *
1572      * All addresses in `payees` must be non-zero. Both arrays must have the same non-zero length, and there must be no
1573      * duplicates in `payees`.
1574      */
1575     constructor(address[] memory payees, uint256[] memory shares_) payable {
1576         require(payees.length == shares_.length, "PaymentSplitter: payees and shares length mismatch");
1577         require(payees.length > 0, "PaymentSplitter: no payees");
1578 
1579         for (uint256 i = 0; i < payees.length; i++) {
1580             _addPayee(payees[i], shares_[i]);
1581         }
1582     }
1583 
1584     /**
1585      * @dev The Ether received will be logged with {PaymentReceived} events. Note that these events are not fully
1586      * reliable: it's possible for a contract to receive Ether without triggering this function. This only affects the
1587      * reliability of the events, and not the actual splitting of Ether.
1588      *
1589      * To learn more about this see the Solidity documentation for
1590      * https://solidity.readthedocs.io/en/latest/contracts.html#fallback-function[fallback
1591      * functions].
1592      */
1593     receive() external payable virtual {
1594         emit PaymentReceived(_msgSender(), msg.value);
1595     }
1596 
1597     /**
1598      * @dev Getter for the total shares held by payees.
1599      */
1600     function totalShares() public view returns (uint256) {
1601         return _totalShares;
1602     }
1603 
1604     /**
1605      * @dev Getter for the total amount of Ether already released.
1606      */
1607     function totalReleased() public view returns (uint256) {
1608         return _totalReleased;
1609     }
1610 
1611     /**
1612      * @dev Getter for the amount of shares held by an account.
1613      */
1614     function shares(address account) public view returns (uint256) {
1615         return _shares[account];
1616     }
1617 
1618     /**
1619      * @dev Getter for the amount of Ether already released to a payee.
1620      */
1621     function released(address account) public view returns (uint256) {
1622         return _released[account];
1623     }
1624 
1625     /**
1626      * @dev Getter for the address of the payee number `index`.
1627      */
1628     function payee(uint256 index) public view returns (address) {
1629         return _payees[index];
1630     }
1631 
1632     /**
1633      * @dev Triggers a transfer to `account` of the amount of Ether they are owed, according to their percentage of the
1634      * total shares and their previous withdrawals.
1635      */
1636     function release(address payable account) public virtual {
1637         require(_shares[account] > 0, "PaymentSplitter: account has no shares");
1638 
1639         uint256 totalReceived = address(this).balance + _totalReleased;
1640         uint256 payment = (totalReceived * _shares[account]) / _totalShares - _released[account];
1641 
1642         require(payment != 0, "PaymentSplitter: account is not due payment");
1643 
1644         _released[account] = _released[account] + payment;
1645         _totalReleased = _totalReleased + payment;
1646 
1647         Address.sendValue(account, payment);
1648         emit PaymentReleased(account, payment);
1649     }
1650 
1651     /**
1652      * @dev Add a new payee to the contract.
1653      * @param account The address of the payee to add.
1654      * @param shares_ The number of shares owned by the payee.
1655      */
1656     function _addPayee(address account, uint256 shares_) private {
1657         require(account != address(0), "PaymentSplitter: account is the zero address");
1658         require(shares_ > 0, "PaymentSplitter: shares are 0");
1659         require(_shares[account] == 0, "PaymentSplitter: account already has shares");
1660 
1661         _payees.push(account);
1662         _shares[account] = shares_;
1663         _totalShares = _totalShares + shares_;
1664         emit PayeeAdded(account, shares_);
1665     }
1666 }
1667 
1668 
1669 // File contracts/libs/ECRecoverLib.sol
1670 
1671 
1672 pragma solidity <0.9.0;
1673 
1674 library ECRecoverLib {
1675     string private constant REQUIRED_SIG_HEADER = "\x19Ethereum Signed Message:\n32";
1676 
1677     struct ECDSAVariables {
1678         uint8 v;
1679         bytes32 r;
1680         bytes32 s;
1681     }
1682 
1683     function verifySig(
1684         ECDSAVariables memory self,
1685         address signer,
1686         bytes32 signerHash
1687     ) internal pure {
1688         require(
1689             signer ==
1690                 ecrecover(
1691                     keccak256(abi.encodePacked(REQUIRED_SIG_HEADER, signerHash)),
1692                     self.v,
1693                     self.r,
1694                     self.s
1695                 ),
1696             "Invalid Signature"
1697         );
1698     }
1699 }
1700 
1701 
1702 // File contracts/Croakz.sol
1703 
1704 pragma solidity ^0.8.4;
1705 
1706 
1707 
1708 
1709 
1710 
1711 contract Croakz is ERC721Enumerable, PaymentSplitter, Ownable {
1712     using Counters for Counters.Counter;
1713     using Strings for uint256;
1714     using ECRecoverLib for ECRecoverLib.ECDSAVariables;
1715     
1716     Counters.Counter private _tokenIds;
1717     Counters.Counter private _specialTokenIds;
1718 
1719     uint256 private constant maxTokens = 6969;
1720     uint256 private constant maxMintsPerTx = 10;
1721     uint256 private constant maxMintsPerAddr = 20;
1722     uint256 private constant mintPrice = 0.069 ether;
1723     uint8 private constant maxPresaleMintPerAddr = 3;
1724     mapping (address => uint8) private _mintsPerAddress;
1725 
1726 
1727     address crypToadzAddr; // 0x1CB1A5e65610AEFF2551A50f76a87a7d3fB649C6;
1728     address signingAuth;
1729 
1730     // 0 = DEV, 1 = PRESALE, 2 = PUBLIC, 3 = CLOSED
1731     uint8 private mintPhase = 0;
1732 
1733     bool private devMintLocked = false;
1734 
1735     // Optional mapping for token URIs
1736     mapping (uint256 => string) private _tokenURIs;
1737 
1738     // Base URI
1739     string private _baseURIextended;
1740 
1741     constructor(string memory name, string memory symbol, address[] memory payees, uint256[] memory shares_) ERC721(name, symbol) PaymentSplitter(payees, shares_) {
1742 
1743     }
1744 
1745     function setCrypToadzAddress(address _crypToadzAddr) external onlyOwner {
1746         crypToadzAddr = _crypToadzAddr;
1747     }
1748 
1749     function setSigningAuth(address _signingAuth) external onlyOwner {
1750         signingAuth = _signingAuth;
1751     }
1752 
1753     function setBaseURI(string memory baseURI_) external onlyOwner {
1754         _baseURIextended = baseURI_;
1755     }
1756     
1757     function _setTokenURI(uint256 tokenId, string memory _tokenURI) internal virtual {
1758         require(_exists(tokenId), "ERC721Metadata: URI set of nonexistent token");
1759         _tokenURIs[tokenId] = _tokenURI;
1760     }
1761     
1762     function _baseURI() internal view virtual override returns (string memory) {
1763         return _baseURIextended;
1764     }
1765     
1766     function tokenURI(uint256 tokenId) public view virtual override returns (string memory) {
1767         require(_exists(tokenId), "ERC721Metadata: URI query for nonexistent token");
1768 
1769         string memory _tokenURI = _tokenURIs[tokenId];
1770         string memory base = _baseURI();
1771         
1772         // If there is no base URI, return the token URI.
1773         if (bytes(base).length == 0) {
1774             return _tokenURI;
1775         }
1776         // If both are set, concatenate the baseURI and tokenURI (via abi.encodePacked).
1777         if (bytes(_tokenURI).length > 0) {
1778             return string(abi.encodePacked(base, _tokenURI));
1779         }
1780         // If there is a baseURI but no tokenURI, concatenate the tokenID to the baseURI.
1781         return string(abi.encodePacked(base, tokenId.toString()));
1782     }
1783 
1784     function _isHolder(address _wallet) internal view returns (bool) {
1785         ERC721 cryptoadzToken = ERC721(crypToadzAddr);
1786         uint256 _quantityHeld = cryptoadzToken.balanceOf(_wallet);
1787         return _quantityHeld > 0;
1788     }
1789 
1790     function changeMintPhase(uint8 _mintPhase) public onlyOwner {
1791         require(_mintPhase > mintPhase, "No back-stepping!");
1792         require(_mintPhase <= 3, "Final phase is CLOSED");
1793         mintPhase = _mintPhase;
1794     }
1795 
1796     function getMintPhase() public view returns (uint8) {
1797         return mintPhase;
1798     }
1799 
1800     function mint(uint256 quantity) internal {
1801         require(mintPhase == 1 || mintPhase == 2, "Minting is not open.");
1802         require(msg.sender == tx.origin, "No contracts!");
1803         require(msg.value >= mintPrice * quantity, "Not enough ether sent!");
1804         require(_tokenIds.current() + quantity <= maxTokens, "Minting this many would exceed supply!");
1805 
1806         if (mintPhase == 1) { // Holder Mint or WL
1807             require(_mintsPerAddress[msg.sender] + quantity <= maxPresaleMintPerAddr, "Presale cannot mint more than 3 CROAKZ!");
1808         } else { // Public Mint
1809             require(quantity <= maxMintsPerTx, "There is a limit on minting too many at a time!");
1810             require(this.balanceOf(msg.sender) + quantity <= maxMintsPerAddr, "Minting this many would exceed max mints per address!");
1811         }
1812 
1813         for (uint256 i = 0; i < quantity; i++) {
1814             _tokenIds.increment();
1815             _mintsPerAddress[msg.sender]++;
1816             _safeMint(msg.sender, _tokenIds.current());
1817         }
1818     }
1819 
1820     function toadMint(uint256 quantity) external payable {
1821         bool isHolder = _isHolder(msg.sender);
1822         require(isHolder, "Must own at least one CryptoToadz to mint in the presale!");
1823         mint(quantity);
1824     }
1825 
1826     function wlMint(uint256 quantity, ECRecoverLib.ECDSAVariables memory wlECDSA) external payable {
1827         // Prove to contract that seller is WL
1828         bytes32 senderHash = keccak256(abi.encodePacked(msg.sender));
1829         wlECDSA.verifySig(signingAuth, senderHash);
1830         mint(quantity);
1831     }
1832 
1833     function publicMint(uint256 quantity) external payable {
1834         require(mintPhase == 2, "Minting is not open to public.");
1835         mint(quantity);
1836     }
1837 
1838     // dev mint special 1/1s
1839     function mintSpecial(address [] memory recipients) external onlyOwner {        
1840         require(!devMintLocked, "Dev Mint Permanently Locked");
1841         for (uint256 i = 0; i < recipients.length; i++) {
1842             _specialTokenIds.increment();
1843             _safeMint(recipients[i], _specialTokenIds.current() * 1000000);
1844         }
1845     }
1846 
1847     function lockDevMint() public onlyOwner {
1848         devMintLocked = true;
1849     }
1850 
1851 }