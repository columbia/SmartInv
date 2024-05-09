1 // SPDX-License-Identifier: GPL-3.0
2 
3 // File: @openzeppelin/contracts/utils/Strings.sol
4 
5 
6 
7 pragma solidity ^0.8.0;
8 
9 /**
10  * @dev String operations.
11  */
12 library Strings {
13     bytes16 private constant _HEX_SYMBOLS = "0123456789abcdef";
14 
15     /**
16      * @dev Converts a `uint256` to its ASCII `string` decimal representation.
17      */
18     function toString(uint256 value) internal pure returns (string memory) {
19         // Inspired by OraclizeAPI's implementation - MIT licence
20         // https://github.com/oraclize/ethereum-api/blob/b42146b063c7d6ee1358846c198246239e9360e8/oraclizeAPI_0.4.25.sol
21 
22         if (value == 0) {
23             return "0";
24         }
25         uint256 temp = value;
26         uint256 digits;
27         while (temp != 0) {
28             digits++;
29             temp /= 10;
30         }
31         bytes memory buffer = new bytes(digits);
32         while (value != 0) {
33             digits -= 1;
34             buffer[digits] = bytes1(uint8(48 + uint256(value % 10)));
35             value /= 10;
36         }
37         return string(buffer);
38     }
39 
40     /**
41      * @dev Converts a `uint256` to its ASCII `string` hexadecimal representation.
42      */
43     function toHexString(uint256 value) internal pure returns (string memory) {
44         if (value == 0) {
45             return "0x00";
46         }
47         uint256 temp = value;
48         uint256 length = 0;
49         while (temp != 0) {
50             length++;
51             temp >>= 8;
52         }
53         return toHexString(value, length);
54     }
55 
56     /**
57      * @dev Converts a `uint256` to its ASCII `string` hexadecimal representation with fixed length.
58      */
59     function toHexString(uint256 value, uint256 length) internal pure returns (string memory) {
60         bytes memory buffer = new bytes(2 * length + 2);
61         buffer[0] = "0";
62         buffer[1] = "x";
63         for (uint256 i = 2 * length + 1; i > 1; --i) {
64             buffer[i] = _HEX_SYMBOLS[value & 0xf];
65             value >>= 4;
66         }
67         require(value == 0, "Strings: hex length insufficient");
68         return string(buffer);
69     }
70 }
71 
72 // File: @openzeppelin/contracts/utils/Address.sol
73 
74 
75 
76 pragma solidity ^0.8.0;
77 
78 /**
79  * @dev Collection of functions related to the address type
80  */
81 library Address {
82     /**
83      * @dev Returns true if `account` is a contract.
84      *
85      * [IMPORTANT]
86      * ====
87      * It is unsafe to assume that an address for which this function returns
88      * false is an externally-owned account (EOA) and not a contract.
89      *
90      * Among others, `isContract` will return false for the following
91      * types of addresses:
92      *
93      *  - an externally-owned account
94      *  - a contract in construction
95      *  - an address where a contract will be created
96      *  - an address where a contract lived, but was destroyed
97      * ====
98      */
99     function isContract(address account) internal view returns (bool) {
100         // This method relies on extcodesize, which returns 0 for contracts in
101         // construction, since the code is only stored at the end of the
102         // constructor execution.
103 
104         uint256 size;
105         assembly {
106             size := extcodesize(account)
107         }
108         return size > 0;
109     }
110 
111     /**
112      * @dev Replacement for Solidity's `transfer`: sends `amount` wei to
113      * `recipient`, forwarding all available gas and reverting on errors.
114      *
115      * https://eips.ethereum.org/EIPS/eip-1884[EIP1884] increases the gas cost
116      * of certain opcodes, possibly making contracts go over the 2300 gas limit
117      * imposed by `transfer`, making them unable to receive funds via
118      * `transfer`. {sendValue} removes this limitation.
119      *
120      * https://diligence.consensys.net/posts/2019/09/stop-using-soliditys-transfer-now/[Learn more].
121      *
122      * IMPORTANT: because control is transferred to `recipient`, care must be
123      * taken to not create reentrancy vulnerabilities. Consider using
124      * {ReentrancyGuard} or the
125      * https://solidity.readthedocs.io/en/v0.5.11/security-considerations.html#use-the-checks-effects-interactions-pattern[checks-effects-interactions pattern].
126      */
127     function sendValue(address payable recipient, uint256 amount) internal {
128         require(address(this).balance >= amount, "Address: insufficient balance");
129 
130         (bool success, ) = recipient.call{value: amount}("");
131         require(success, "Address: unable to send value, recipient may have reverted");
132     }
133 
134     /**
135      * @dev Performs a Solidity function call using a low level `call`. A
136      * plain `call` is an unsafe replacement for a function call: use this
137      * function instead.
138      *
139      * If `target` reverts with a revert reason, it is bubbled up by this
140      * function (like regular Solidity function calls).
141      *
142      * Returns the raw returned data. To convert to the expected return value,
143      * use https://solidity.readthedocs.io/en/latest/units-and-global-variables.html?highlight=abi.decode#abi-encoding-and-decoding-functions[`abi.decode`].
144      *
145      * Requirements:
146      *
147      * - `target` must be a contract.
148      * - calling `target` with `data` must not revert.
149      *
150      * _Available since v3.1._
151      */
152     function functionCall(address target, bytes memory data) internal returns (bytes memory) {
153         return functionCall(target, data, "Address: low-level call failed");
154     }
155 
156     /**
157      * @dev Same as {xref-Address-functionCall-address-bytes-}[`functionCall`], but with
158      * `errorMessage` as a fallback revert reason when `target` reverts.
159      *
160      * _Available since v3.1._
161      */
162     function functionCall(
163         address target,
164         bytes memory data,
165         string memory errorMessage
166     ) internal returns (bytes memory) {
167         return functionCallWithValue(target, data, 0, errorMessage);
168     }
169 
170     /**
171      * @dev Same as {xref-Address-functionCall-address-bytes-}[`functionCall`],
172      * but also transferring `value` wei to `target`.
173      *
174      * Requirements:
175      *
176      * - the calling contract must have an ETH balance of at least `value`.
177      * - the called Solidity function must be `payable`.
178      *
179      * _Available since v3.1._
180      */
181     function functionCallWithValue(
182         address target,
183         bytes memory data,
184         uint256 value
185     ) internal returns (bytes memory) {
186         return functionCallWithValue(target, data, value, "Address: low-level call with value failed");
187     }
188 
189     /**
190      * @dev Same as {xref-Address-functionCallWithValue-address-bytes-uint256-}[`functionCallWithValue`], but
191      * with `errorMessage` as a fallback revert reason when `target` reverts.
192      *
193      * _Available since v3.1._
194      */
195     function functionCallWithValue(
196         address target,
197         bytes memory data,
198         uint256 value,
199         string memory errorMessage
200     ) internal returns (bytes memory) {
201         require(address(this).balance >= value, "Address: insufficient balance for call");
202         require(isContract(target), "Address: call to non-contract");
203 
204         (bool success, bytes memory returndata) = target.call{value: value}(data);
205         return verifyCallResult(success, returndata, errorMessage);
206     }
207 
208     /**
209      * @dev Same as {xref-Address-functionCall-address-bytes-}[`functionCall`],
210      * but performing a static call.
211      *
212      * _Available since v3.3._
213      */
214     function functionStaticCall(address target, bytes memory data) internal view returns (bytes memory) {
215         return functionStaticCall(target, data, "Address: low-level static call failed");
216     }
217 
218     /**
219      * @dev Same as {xref-Address-functionCall-address-bytes-string-}[`functionCall`],
220      * but performing a static call.
221      *
222      * _Available since v3.3._
223      */
224     function functionStaticCall(
225         address target,
226         bytes memory data,
227         string memory errorMessage
228     ) internal view returns (bytes memory) {
229         require(isContract(target), "Address: static call to non-contract");
230 
231         (bool success, bytes memory returndata) = target.staticcall(data);
232         return verifyCallResult(success, returndata, errorMessage);
233     }
234 
235     /**
236      * @dev Same as {xref-Address-functionCall-address-bytes-}[`functionCall`],
237      * but performing a delegate call.
238      *
239      * _Available since v3.4._
240      */
241     function functionDelegateCall(address target, bytes memory data) internal returns (bytes memory) {
242         return functionDelegateCall(target, data, "Address: low-level delegate call failed");
243     }
244 
245     /**
246      * @dev Same as {xref-Address-functionCall-address-bytes-string-}[`functionCall`],
247      * but performing a delegate call.
248      *
249      * _Available since v3.4._
250      */
251     function functionDelegateCall(
252         address target,
253         bytes memory data,
254         string memory errorMessage
255     ) internal returns (bytes memory) {
256         require(isContract(target), "Address: delegate call to non-contract");
257 
258         (bool success, bytes memory returndata) = target.delegatecall(data);
259         return verifyCallResult(success, returndata, errorMessage);
260     }
261 
262     /**
263      * @dev Tool to verifies that a low level call was successful, and revert if it wasn't, either by bubbling the
264      * revert reason using the provided one.
265      *
266      * _Available since v4.3._
267      */
268     function verifyCallResult(
269         bool success,
270         bytes memory returndata,
271         string memory errorMessage
272     ) internal pure returns (bytes memory) {
273         if (success) {
274             return returndata;
275         } else {
276             // Look for revert reason and bubble it up if present
277             if (returndata.length > 0) {
278                 // The easiest way to bubble the revert reason is using memory via assembly
279 
280                 assembly {
281                     let returndata_size := mload(returndata)
282                     revert(add(32, returndata), returndata_size)
283                 }
284             } else {
285                 revert(errorMessage);
286             }
287         }
288     }
289 }
290 
291 // File: @openzeppelin/contracts/token/ERC721/IERC721Receiver.sol
292 
293 
294 
295 pragma solidity ^0.8.0;
296 
297 /**
298  * @title ERC721 token receiver interface
299  * @dev Interface for any contract that wants to support safeTransfers
300  * from ERC721 asset contracts.
301  */
302 interface IERC721Receiver {
303     /**
304      * @dev Whenever an {IERC721} `tokenId` token is transferred to this contract via {IERC721-safeTransferFrom}
305      * by `operator` from `from`, this function is called.
306      *
307      * It must return its Solidity selector to confirm the token transfer.
308      * If any other value is returned or the interface is not implemented by the recipient, the transfer will be reverted.
309      *
310      * The selector can be obtained in Solidity with `IERC721.onERC721Received.selector`.
311      */
312     function onERC721Received(
313         address operator,
314         address from,
315         uint256 tokenId,
316         bytes calldata data
317     ) external returns (bytes4);
318 }
319 
320 // File: @openzeppelin/contracts/utils/introspection/IERC165.sol
321 
322 
323 
324 pragma solidity ^0.8.0;
325 
326 /**
327  * @dev Interface of the ERC165 standard, as defined in the
328  * https://eips.ethereum.org/EIPS/eip-165[EIP].
329  *
330  * Implementers can declare support of contract interfaces, which can then be
331  * queried by others ({ERC165Checker}).
332  *
333  * For an implementation, see {ERC165}.
334  */
335 interface IERC165 {
336     /**
337      * @dev Returns true if this contract implements the interface defined by
338      * `interfaceId`. See the corresponding
339      * https://eips.ethereum.org/EIPS/eip-165#how-interfaces-are-identified[EIP section]
340      * to learn more about how these ids are created.
341      *
342      * This function call must use less than 30 000 gas.
343      */
344     function supportsInterface(bytes4 interfaceId) external view returns (bool);
345 }
346 
347 // File: @openzeppelin/contracts/utils/introspection/ERC165.sol
348 
349 
350 
351 pragma solidity ^0.8.0;
352 
353 
354 /**
355  * @dev Implementation of the {IERC165} interface.
356  *
357  * Contracts that want to implement ERC165 should inherit from this contract and override {supportsInterface} to check
358  * for the additional interface id that will be supported. For example:
359  *
360  * ```solidity
361  * function supportsInterface(bytes4 interfaceId) public view virtual override returns (bool) {
362  *     return interfaceId == type(MyInterface).interfaceId || super.supportsInterface(interfaceId);
363  * }
364  * ```
365  *
366  * Alternatively, {ERC165Storage} provides an easier to use but more expensive implementation.
367  */
368 abstract contract ERC165 is IERC165 {
369     /**
370      * @dev See {IERC165-supportsInterface}.
371      */
372     function supportsInterface(bytes4 interfaceId) public view virtual override returns (bool) {
373         return interfaceId == type(IERC165).interfaceId;
374     }
375 }
376 
377 // File: @openzeppelin/contracts/token/ERC721/IERC721.sol
378 
379 
380 
381 pragma solidity ^0.8.0;
382 
383 
384 /**
385  * @dev Required interface of an ERC721 compliant contract.
386  */
387 interface IERC721 is IERC165 {
388     /**
389      * @dev Emitted when `tokenId` token is transferred from `from` to `to`.
390      */
391     event Transfer(address indexed from, address indexed to, uint256 indexed tokenId);
392 
393     /**
394      * @dev Emitted when `owner` enables `approved` to manage the `tokenId` token.
395      */
396     event Approval(address indexed owner, address indexed approved, uint256 indexed tokenId);
397 
398     /**
399      * @dev Emitted when `owner` enables or disables (`approved`) `operator` to manage all of its assets.
400      */
401     event ApprovalForAll(address indexed owner, address indexed operator, bool approved);
402 
403     /**
404      * @dev Returns the number of tokens in ``owner``'s account.
405      */
406     function balanceOf(address owner) external view returns (uint256 balance);
407 
408     /**
409      * @dev Returns the owner of the `tokenId` token.
410      *
411      * Requirements:
412      *
413      * - `tokenId` must exist.
414      */
415     function ownerOf(uint256 tokenId) external view returns (address owner);
416 
417     /**
418      * @dev Safely transfers `tokenId` token from `from` to `to`, checking first that contract recipients
419      * are aware of the ERC721 protocol to prevent tokens from being forever locked.
420      *
421      * Requirements:
422      *
423      * - `from` cannot be the zero address.
424      * - `to` cannot be the zero address.
425      * - `tokenId` token must exist and be owned by `from`.
426      * - If the caller is not `from`, it must be have been allowed to move this token by either {approve} or {setApprovalForAll}.
427      * - If `to` refers to a smart contract, it must implement {IERC721Receiver-onERC721Received}, which is called upon a safe transfer.
428      *
429      * Emits a {Transfer} event.
430      */
431     function safeTransferFrom(
432         address from,
433         address to,
434         uint256 tokenId
435     ) external;
436 
437     /**
438      * @dev Transfers `tokenId` token from `from` to `to`.
439      *
440      * WARNING: Usage of this method is discouraged, use {safeTransferFrom} whenever possible.
441      *
442      * Requirements:
443      *
444      * - `from` cannot be the zero address.
445      * - `to` cannot be the zero address.
446      * - `tokenId` token must be owned by `from`.
447      * - If the caller is not `from`, it must be approved to move this token by either {approve} or {setApprovalForAll}.
448      *
449      * Emits a {Transfer} event.
450      */
451     function transferFrom(
452         address from,
453         address to,
454         uint256 tokenId
455     ) external;
456 
457     /**
458      * @dev Gives permission to `to` to transfer `tokenId` token to another account.
459      * The approval is cleared when the token is transferred.
460      *
461      * Only a single account can be approved at a time, so approving the zero address clears previous approvals.
462      *
463      * Requirements:
464      *
465      * - The caller must own the token or be an approved operator.
466      * - `tokenId` must exist.
467      *
468      * Emits an {Approval} event.
469      */
470     function approve(address to, uint256 tokenId) external;
471 
472     /**
473      * @dev Returns the account approved for `tokenId` token.
474      *
475      * Requirements:
476      *
477      * - `tokenId` must exist.
478      */
479     function getApproved(uint256 tokenId) external view returns (address operator);
480 
481     /**
482      * @dev Approve or remove `operator` as an operator for the caller.
483      * Operators can call {transferFrom} or {safeTransferFrom} for any token owned by the caller.
484      *
485      * Requirements:
486      *
487      * - The `operator` cannot be the caller.
488      *
489      * Emits an {ApprovalForAll} event.
490      */
491     function setApprovalForAll(address operator, bool _approved) external;
492 
493     /**
494      * @dev Returns if the `operator` is allowed to manage all of the assets of `owner`.
495      *
496      * See {setApprovalForAll}
497      */
498     function isApprovedForAll(address owner, address operator) external view returns (bool);
499 
500     /**
501      * @dev Safely transfers `tokenId` token from `from` to `to`.
502      *
503      * Requirements:
504      *
505      * - `from` cannot be the zero address.
506      * - `to` cannot be the zero address.
507      * - `tokenId` token must exist and be owned by `from`.
508      * - If the caller is not `from`, it must be approved to move this token by either {approve} or {setApprovalForAll}.
509      * - If `to` refers to a smart contract, it must implement {IERC721Receiver-onERC721Received}, which is called upon a safe transfer.
510      *
511      * Emits a {Transfer} event.
512      */
513     function safeTransferFrom(
514         address from,
515         address to,
516         uint256 tokenId,
517         bytes calldata data
518     ) external;
519 }
520 
521 // File: @openzeppelin/contracts/token/ERC721/extensions/IERC721Metadata.sol
522 
523 
524 
525 pragma solidity ^0.8.0;
526 
527 
528 /**
529  * @title ERC-721 Non-Fungible Token Standard, optional metadata extension
530  * @dev See https://eips.ethereum.org/EIPS/eip-721
531  */
532 interface IERC721Metadata is IERC721 {
533     /**
534      * @dev Returns the token collection name.
535      */
536     function name() external view returns (string memory);
537 
538     /**
539      * @dev Returns the token collection symbol.
540      */
541     function symbol() external view returns (string memory);
542 
543     /**
544      * @dev Returns the Uniform Resource Identifier (URI) for `tokenId` token.
545      */
546     function tokenURI(uint256 tokenId) external view returns (string memory);
547 }
548 
549 // File: @openzeppelin/contracts/utils/Context.sol
550 
551 
552 
553 pragma solidity ^0.8.0;
554 
555 /**
556  * @dev Provides information about the current execution context, including the
557  * sender of the transaction and its data. While these are generally available
558  * via msg.sender and msg.data, they should not be accessed in such a direct
559  * manner, since when dealing with meta-transactions the account sending and
560  * paying for execution may not be the actual sender (as far as an application
561  * is concerned).
562  *
563  * This contract is only required for intermediate, library-like contracts.
564  */
565 abstract contract Context {
566     function _msgSender() internal view virtual returns (address) {
567         return msg.sender;
568     }
569 
570     function _msgData() internal view virtual returns (bytes calldata) {
571         return msg.data;
572     }
573 }
574 
575 // File: @openzeppelin/contracts/token/ERC721/ERC721.sol
576 
577 
578 
579 pragma solidity ^0.8.0;
580 
581 
582 
583 
584 
585 
586 
587 
588 /**
589  * @dev Implementation of https://eips.ethereum.org/EIPS/eip-721[ERC721] Non-Fungible Token Standard, including
590  * the Metadata extension, but not including the Enumerable extension, which is available separately as
591  * {ERC721Enumerable}.
592  */
593 contract ERC721 is Context, ERC165, IERC721, IERC721Metadata {
594     using Address for address;
595     using Strings for uint256;
596 
597     // Token name
598     string private _name;
599 
600     // Token symbol
601     string private _symbol;
602 
603     // Mapping from token ID to owner address
604     mapping(uint256 => address) private _owners;
605 
606     // Mapping owner address to token count
607     mapping(address => uint256) private _balances;
608 
609     // Mapping from token ID to approved address
610     mapping(uint256 => address) private _tokenApprovals;
611 
612     // Mapping from owner to operator approvals
613     mapping(address => mapping(address => bool)) private _operatorApprovals;
614 
615     /**
616      * @dev Initializes the contract by setting a `name` and a `symbol` to the token collection.
617      */
618     constructor(string memory name_, string memory symbol_) {
619         _name = name_;
620         _symbol = symbol_;
621     }
622 
623     /**
624      * @dev See {IERC165-supportsInterface}.
625      */
626     function supportsInterface(bytes4 interfaceId) public view virtual override(ERC165, IERC165) returns (bool) {
627         return
628             interfaceId == type(IERC721).interfaceId ||
629             interfaceId == type(IERC721Metadata).interfaceId ||
630             super.supportsInterface(interfaceId);
631     }
632 
633     /**
634      * @dev See {IERC721-balanceOf}.
635      */
636     function balanceOf(address owner) public view virtual override returns (uint256) {
637         require(owner != address(0), "ERC721: balance query for the zero address");
638         return _balances[owner];
639     }
640 
641     /**
642      * @dev See {IERC721-ownerOf}.
643      */
644     function ownerOf(uint256 tokenId) public view virtual override returns (address) {
645         address owner = _owners[tokenId];
646         require(owner != address(0), "ERC721: owner query for nonexistent token");
647         return owner;
648     }
649 
650     /**
651      * @dev See {IERC721Metadata-name}.
652      */
653     function name() public view virtual override returns (string memory) {
654         return _name;
655     }
656 
657     /**
658      * @dev See {IERC721Metadata-symbol}.
659      */
660     function symbol() public view virtual override returns (string memory) {
661         return _symbol;
662     }
663 
664     /**
665      * @dev See {IERC721Metadata-tokenURI}.
666      */
667     function tokenURI(uint256 tokenId) public view virtual override returns (string memory) {
668         require(_exists(tokenId), "ERC721Metadata: URI query for nonexistent token");
669 
670         string memory baseURI = _baseURI();
671         return bytes(baseURI).length > 0 ? string(abi.encodePacked(baseURI, tokenId.toString())) : "";
672     }
673 
674     /**
675      * @dev Base URI for computing {tokenURI}. If set, the resulting URI for each
676      * token will be the concatenation of the `baseURI` and the `tokenId`. Empty
677      * by default, can be overriden in child contracts.
678      */
679     function _baseURI() internal view virtual returns (string memory) {
680         return "";
681     }
682 
683     /**
684      * @dev See {IERC721-approve}.
685      */
686     function approve(address to, uint256 tokenId) public virtual override {
687         address owner = ERC721.ownerOf(tokenId);
688         require(to != owner, "ERC721: approval to current owner");
689 
690         require(
691             _msgSender() == owner || isApprovedForAll(owner, _msgSender()),
692             "ERC721: approve caller is not owner nor approved for all"
693         );
694 
695         _approve(to, tokenId);
696     }
697 
698     /**
699      * @dev See {IERC721-getApproved}.
700      */
701     function getApproved(uint256 tokenId) public view virtual override returns (address) {
702         require(_exists(tokenId), "ERC721: approved query for nonexistent token");
703 
704         return _tokenApprovals[tokenId];
705     }
706 
707     /**
708      * @dev See {IERC721-setApprovalForAll}.
709      */
710     function setApprovalForAll(address operator, bool approved) public virtual override {
711         require(operator != _msgSender(), "ERC721: approve to caller");
712 
713         _operatorApprovals[_msgSender()][operator] = approved;
714         emit ApprovalForAll(_msgSender(), operator, approved);
715     }
716 
717     /**
718      * @dev See {IERC721-isApprovedForAll}.
719      */
720     function isApprovedForAll(address owner, address operator) public view virtual override returns (bool) {
721         return _operatorApprovals[owner][operator];
722     }
723 
724     /**
725      * @dev See {IERC721-transferFrom}.
726      */
727     function transferFrom(
728         address from,
729         address to,
730         uint256 tokenId
731     ) public virtual override {
732         //solhint-disable-next-line max-line-length
733         require(_isApprovedOrOwner(_msgSender(), tokenId), "ERC721: transfer caller is not owner nor approved");
734 
735         _transfer(from, to, tokenId);
736     }
737 
738     /**
739      * @dev See {IERC721-safeTransferFrom}.
740      */
741     function safeTransferFrom(
742         address from,
743         address to,
744         uint256 tokenId
745     ) public virtual override {
746         safeTransferFrom(from, to, tokenId, "");
747     }
748 
749     /**
750      * @dev See {IERC721-safeTransferFrom}.
751      */
752     function safeTransferFrom(
753         address from,
754         address to,
755         uint256 tokenId,
756         bytes memory _data
757     ) public virtual override {
758         require(_isApprovedOrOwner(_msgSender(), tokenId), "ERC721: transfer caller is not owner nor approved");
759         _safeTransfer(from, to, tokenId, _data);
760     }
761 
762     /**
763      * @dev Safely transfers `tokenId` token from `from` to `to`, checking first that contract recipients
764      * are aware of the ERC721 protocol to prevent tokens from being forever locked.
765      *
766      * `_data` is additional data, it has no specified format and it is sent in call to `to`.
767      *
768      * This internal function is equivalent to {safeTransferFrom}, and can be used to e.g.
769      * implement alternative mechanisms to perform token transfer, such as signature-based.
770      *
771      * Requirements:
772      *
773      * - `from` cannot be the zero address.
774      * - `to` cannot be the zero address.
775      * - `tokenId` token must exist and be owned by `from`.
776      * - If `to` refers to a smart contract, it must implement {IERC721Receiver-onERC721Received}, which is called upon a safe transfer.
777      *
778      * Emits a {Transfer} event.
779      */
780     function _safeTransfer(
781         address from,
782         address to,
783         uint256 tokenId,
784         bytes memory _data
785     ) internal virtual {
786         _transfer(from, to, tokenId);
787         require(_checkOnERC721Received(from, to, tokenId, _data), "ERC721: transfer to non ERC721Receiver implementer");
788     }
789 
790     /**
791      * @dev Returns whether `tokenId` exists.
792      *
793      * Tokens can be managed by their owner or approved accounts via {approve} or {setApprovalForAll}.
794      *
795      * Tokens start existing when they are minted (`_mint`),
796      * and stop existing when they are burned (`_burn`).
797      */
798     function _exists(uint256 tokenId) internal view virtual returns (bool) {
799         return _owners[tokenId] != address(0);
800     }
801 
802     /**
803      * @dev Returns whether `spender` is allowed to manage `tokenId`.
804      *
805      * Requirements:
806      *
807      * - `tokenId` must exist.
808      */
809     function _isApprovedOrOwner(address spender, uint256 tokenId) internal view virtual returns (bool) {
810         require(_exists(tokenId), "ERC721: operator query for nonexistent token");
811         address owner = ERC721.ownerOf(tokenId);
812         return (spender == owner || getApproved(tokenId) == spender || isApprovedForAll(owner, spender));
813     }
814 
815     /**
816      * @dev Safely mints `tokenId` and transfers it to `to`.
817      *
818      * Requirements:
819      *
820      * - `tokenId` must not exist.
821      * - If `to` refers to a smart contract, it must implement {IERC721Receiver-onERC721Received}, which is called upon a safe transfer.
822      *
823      * Emits a {Transfer} event.
824      */
825     function _safeMint(address to, uint256 tokenId) internal virtual {
826         _safeMint(to, tokenId, "");
827     }
828 
829     /**
830      * @dev Same as {xref-ERC721-_safeMint-address-uint256-}[`_safeMint`], with an additional `data` parameter which is
831      * forwarded in {IERC721Receiver-onERC721Received} to contract recipients.
832      */
833     function _safeMint(
834         address to,
835         uint256 tokenId,
836         bytes memory _data
837     ) internal virtual {
838         _mint(to, tokenId);
839         require(
840             _checkOnERC721Received(address(0), to, tokenId, _data),
841             "ERC721: transfer to non ERC721Receiver implementer"
842         );
843     }
844 
845     /**
846      * @dev Mints `tokenId` and transfers it to `to`.
847      *
848      * WARNING: Usage of this method is discouraged, use {_safeMint} whenever possible
849      *
850      * Requirements:
851      *
852      * - `tokenId` must not exist.
853      * - `to` cannot be the zero address.
854      *
855      * Emits a {Transfer} event.
856      */
857     function _mint(address to, uint256 tokenId) internal virtual {
858         require(to != address(0), "ERC721: mint to the zero address");
859         require(!_exists(tokenId), "ERC721: token already minted");
860 
861         _beforeTokenTransfer(address(0), to, tokenId);
862 
863         _balances[to] += 1;
864         _owners[tokenId] = to;
865 
866         emit Transfer(address(0), to, tokenId);
867     }
868 
869     /**
870      * @dev Destroys `tokenId`.
871      * The approval is cleared when the token is burned.
872      *
873      * Requirements:
874      *
875      * - `tokenId` must exist.
876      *
877      * Emits a {Transfer} event.
878      */
879     function _burn(uint256 tokenId) internal virtual {
880         address owner = ERC721.ownerOf(tokenId);
881 
882         _beforeTokenTransfer(owner, address(0), tokenId);
883 
884         // Clear approvals
885         _approve(address(0), tokenId);
886 
887         _balances[owner] -= 1;
888         delete _owners[tokenId];
889 
890         emit Transfer(owner, address(0), tokenId);
891     }
892 
893     /**
894      * @dev Transfers `tokenId` from `from` to `to`.
895      *  As opposed to {transferFrom}, this imposes no restrictions on msg.sender.
896      *
897      * Requirements:
898      *
899      * - `to` cannot be the zero address.
900      * - `tokenId` token must be owned by `from`.
901      *
902      * Emits a {Transfer} event.
903      */
904     function _transfer(
905         address from,
906         address to,
907         uint256 tokenId
908     ) internal virtual {
909         require(ERC721.ownerOf(tokenId) == from, "ERC721: transfer of token that is not own");
910         require(to != address(0), "ERC721: transfer to the zero address");
911 
912         _beforeTokenTransfer(from, to, tokenId);
913 
914         // Clear approvals from the previous owner
915         _approve(address(0), tokenId);
916 
917         _balances[from] -= 1;
918         _balances[to] += 1;
919         _owners[tokenId] = to;
920 
921         emit Transfer(from, to, tokenId);
922     }
923 
924     /**
925      * @dev Approve `to` to operate on `tokenId`
926      *
927      * Emits a {Approval} event.
928      */
929     function _approve(address to, uint256 tokenId) internal virtual {
930         _tokenApprovals[tokenId] = to;
931         emit Approval(ERC721.ownerOf(tokenId), to, tokenId);
932     }
933 
934     /**
935      * @dev Internal function to invoke {IERC721Receiver-onERC721Received} on a target address.
936      * The call is not executed if the target address is not a contract.
937      *
938      * @param from address representing the previous owner of the given token ID
939      * @param to target address that will receive the tokens
940      * @param tokenId uint256 ID of the token to be transferred
941      * @param _data bytes optional data to send along with the call
942      * @return bool whether the call correctly returned the expected magic value
943      */
944     function _checkOnERC721Received(
945         address from,
946         address to,
947         uint256 tokenId,
948         bytes memory _data
949     ) private returns (bool) {
950         if (to.isContract()) {
951             try IERC721Receiver(to).onERC721Received(_msgSender(), from, tokenId, _data) returns (bytes4 retval) {
952                 return retval == IERC721Receiver.onERC721Received.selector;
953             } catch (bytes memory reason) {
954                 if (reason.length == 0) {
955                     revert("ERC721: transfer to non ERC721Receiver implementer");
956                 } else {
957                     assembly {
958                         revert(add(32, reason), mload(reason))
959                     }
960                 }
961             }
962         } else {
963             return true;
964         }
965     }
966 
967     /**
968      * @dev Hook that is called before any token transfer. This includes minting
969      * and burning.
970      *
971      * Calling conditions:
972      *
973      * - When `from` and `to` are both non-zero, ``from``'s `tokenId` will be
974      * transferred to `to`.
975      * - When `from` is zero, `tokenId` will be minted for `to`.
976      * - When `to` is zero, ``from``'s `tokenId` will be burned.
977      * - `from` and `to` are never both zero.
978      *
979      * To learn more about hooks, head to xref:ROOT:extending-contracts.adoc#using-hooks[Using Hooks].
980      */
981     function _beforeTokenTransfer(
982         address from,
983         address to,
984         uint256 tokenId
985     ) internal virtual {}
986 }
987 
988 // File: @openzeppelin/contracts/access/Ownable.sol
989 
990 
991 
992 pragma solidity ^0.8.0;
993 
994 
995 /**
996  * @dev Contract module which provides a basic access control mechanism, where
997  * there is an account (an owner) that can be granted exclusive access to
998  * specific functions.
999  *
1000  * By default, the owner account will be the one that deploys the contract. This
1001  * can later be changed with {transferOwnership}.
1002  *
1003  * This module is used through inheritance. It will make available the modifier
1004  * `onlyOwner`, which can be applied to your functions to restrict their use to
1005  * the owner.
1006  */
1007 abstract contract Ownable is Context {
1008     address private _owner;
1009 
1010     event OwnershipTransferred(address indexed previousOwner, address indexed newOwner);
1011 
1012     /**
1013      * @dev Initializes the contract setting the deployer as the initial owner.
1014      */
1015     constructor() {
1016         _setOwner(_msgSender());
1017     }
1018 
1019     /**
1020      * @dev Returns the address of the current owner.
1021      */
1022     function owner() public view virtual returns (address) {
1023         return _owner;
1024     }
1025 
1026     /**
1027      * @dev Throws if called by any account other than the owner.
1028      */
1029     modifier onlyOwner() {
1030         require(owner() == _msgSender(), "Ownable: caller is not the owner");
1031         _;
1032     }
1033 
1034     /**
1035      * @dev Leaves the contract without owner. It will not be possible to call
1036      * `onlyOwner` functions anymore. Can only be called by the current owner.
1037      *
1038      * NOTE: Renouncing ownership will leave the contract without an owner,
1039      * thereby removing any functionality that is only available to the owner.
1040      */
1041     function renounceOwnership() public virtual onlyOwner {
1042         _setOwner(address(0));
1043     }
1044 
1045     /**
1046      * @dev Transfers ownership of the contract to a new account (`newOwner`).
1047      * Can only be called by the current owner.
1048      */
1049     function transferOwnership(address newOwner) public virtual onlyOwner {
1050         require(newOwner != address(0), "Ownable: new owner is the zero address");
1051         _setOwner(newOwner);
1052     }
1053 
1054     function _setOwner(address newOwner) private {
1055         address oldOwner = _owner;
1056         _owner = newOwner;
1057         emit OwnershipTransferred(oldOwner, newOwner);
1058     }
1059 }
1060 
1061 // File: contracts/MarineMarauderz.sol
1062 
1063 
1064 
1065 pragma solidity ^0.8.0;
1066 
1067 
1068 
1069 /**************************************************************
1070 ╭━╮╭━┳━━━┳━━━┳━━┳━╮╱╭┳━━━┳━╮╭━┳━━━┳━━━┳━━━┳╮╱╭┳━━━┳━━━┳━━━┳━━━━╮
1071 ┃┃╰╯┃┃╭━╮┃╭━╮┣┫┣┫┃╰╮┃┃╭━━┫┃╰╯┃┃╭━╮┃╭━╮┃╭━╮┃┃╱┃┣╮╭╮┃╭━━┫╭━╮┣━━╮━┃
1072 ┃╭╮╭╮┃┃╱┃┃╰━╯┃┃┃┃╭╮╰╯┃╰━━┫╭╮╭╮┃┃╱┃┃╰━╯┃┃╱┃┃┃╱┃┃┃┃┃┃╰━━┫╰━╯┃╱╭╯╭╯
1073 ┃┃┃┃┃┃╰━╯┃╭╮╭╯┃┃┃┃╰╮┃┃╭━━┫┃┃┃┃┃╰━╯┃╭╮╭┫╰━╯┃┃╱┃┃┃┃┃┃╭━━┫╭╮╭╯╭╯╭╯
1074 ┃┃┃┃┃┃╭━╮┃┃┃╰┳┫┣┫┃╱┃┃┃╰━━┫┃┃┃┃┃╭━╮┃┃┃╰┫╭━╮┃╰━╯┣╯╰╯┃╰━━┫┃┃╰┳╯━╰━╮
1075 ╰╯╰╯╰┻╯╱╰┻╯╰━┻━━┻╯╱╰━┻━━━┻╯╰╯╰┻╯╱╰┻╯╰━┻╯╱╰┻━━━┻━━━┻━━━┻╯╰━┻━━━━╯
1076 By: Rocky Fantana & Bando
1077 ****************************************************************/
1078 
1079 contract MarineMarauderz is ERC721, Ownable {
1080     
1081     uint256 public PRICE = 0.07 ether;
1082     uint256 public constant MAX_SUPPLY = 7777;
1083     uint256 public constant OWNER_AMOUNT = 101;
1084     uint256 public MAXMINT = 2;
1085     uint256 public amountMinted;
1086     
1087     string public baseURI;
1088     
1089     bool public publicSaleLive = false;
1090     bool public whitelistLive = false;
1091     
1092     mapping(address => uint256) public whitelist;
1093     mapping(address => uint256) public addressMintedBalance; 
1094   
1095     constructor(
1096         string memory name_,
1097         string memory symbol_,
1098         string memory baseURI_
1099     ) ERC721(name_, symbol_) {
1100         baseURI = baseURI_;
1101         for (uint256 i = 0; i < OWNER_AMOUNT; i++) {
1102             _safeMint(msg.sender, ++amountMinted);
1103         }
1104     }
1105 
1106     function mint(uint256 _mintAmount) public payable {
1107         require(whitelistLive == true, "Whitelist is not live!");
1108         require(_mintAmount > 0, "Amount must be more than 0");
1109         require(_mintAmount <= MAXMINT, "Amount must be 2 or less for whitelist sale, 4 or less for public sale!");
1110         
1111         uint256 ownerMintedCount = addressMintedBalance[msg.sender];
1112         require(ownerMintedCount + _mintAmount <= MAXMINT, "Max NFTs per address exceeded");
1113         
1114         require(PRICE * _mintAmount <= msg.value, "Insufficient funds");        
1115         require(amountMinted + _mintAmount <= MAX_SUPPLY, "We have sold out, Thank you!");
1116 
1117         if (!publicSaleLive) {
1118             uint256 whitelistBalance = whitelist[msg.sender];
1119             require(
1120                 whitelistBalance > 0,
1121                 "Invalid whitelist balance - Public sale not live"
1122             );
1123             require(
1124                 whitelistBalance >= _mintAmount,
1125                 "Amount more than your whitelist limit"
1126             );
1127             whitelist[msg.sender] -= _mintAmount;
1128         }
1129                
1130         for (uint256 i = 0; i < _mintAmount; i++) {
1131              addressMintedBalance[msg.sender]++;
1132             _safeMint(msg.sender, ++amountMinted);
1133         }
1134     }
1135 
1136     function setWhitelist(address[] calldata addresses) public onlyOwner {
1137         for (uint256 i = 0; i < addresses.length; i++) {
1138             whitelist[addresses[i]] = MAXMINT;
1139         }
1140     }
1141 
1142     function startPublicSale() public onlyOwner {
1143         require(!publicSaleLive, "Public sale is already live");
1144         publicSaleLive = true;
1145         MAXMINT = 4; 
1146     }
1147     
1148     function startWhitelistSale() public onlyOwner{
1149         require(!whitelistLive,"Whitelist sale is already live");
1150         whitelistLive = true;
1151     }
1152     
1153     function salesAreOver() public onlyOwner{
1154         publicSaleLive = false;
1155         whitelistLive = false;
1156     }
1157 
1158     function setBaseURI(string memory baseURI_) public onlyOwner {
1159         baseURI = baseURI_;
1160     }
1161 
1162     function _baseURI() internal view virtual override returns (string memory) {
1163         return baseURI;
1164     }
1165     
1166     function setmaxMintAmount(uint256 _newmaxMintAmount) public onlyOwner {
1167         MAXMINT = _newmaxMintAmount;
1168     }
1169   
1170     function setCost(uint256 _newPrice) public onlyOwner {
1171         PRICE = _newPrice;
1172     }
1173 
1174     function withdrawToAddress(address payable recipient) public onlyOwner {
1175         require(address(this).balance > 0, "No contract balance");
1176         recipient.transfer(address(this).balance);
1177     }
1178     
1179     function ownerWithdraw() public onlyOwner {
1180         uint balance = address(this).balance;
1181         payable(msg.sender).transfer(balance);
1182     }
1183 }