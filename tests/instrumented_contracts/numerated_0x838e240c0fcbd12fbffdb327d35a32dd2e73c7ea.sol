1 // File: @openzeppelin/contracts/utils/Strings.sol
2 
3 
4 
5 pragma solidity ^0.8.0;
6 
7 /**
8  * @dev String operations.
9  */
10 library Strings {
11     bytes16 private constant _HEX_SYMBOLS = "0123456789abcdef";
12 
13     /**
14      * @dev Converts a `uint256` to its ASCII `string` decimal representation.
15      */
16     function toString(uint256 value) internal pure returns (string memory) {
17         // Inspired by OraclizeAPI's implementation - MIT licence
18         // https://github.com/oraclize/ethereum-api/blob/b42146b063c7d6ee1358846c198246239e9360e8/oraclizeAPI_0.4.25.sol
19 
20         if (value == 0) {
21             return "0";
22         }
23         uint256 temp = value;
24         uint256 digits;
25         while (temp != 0) {
26             digits++;
27             temp /= 10;
28         }
29         bytes memory buffer = new bytes(digits);
30         while (value != 0) {
31             digits -= 1;
32             buffer[digits] = bytes1(uint8(48 + uint256(value % 10)));
33             value /= 10;
34         }
35         return string(buffer);
36     }
37 
38     /**
39      * @dev Converts a `uint256` to its ASCII `string` hexadecimal representation.
40      */
41     function toHexString(uint256 value) internal pure returns (string memory) {
42         if (value == 0) {
43             return "0x00";
44         }
45         uint256 temp = value;
46         uint256 length = 0;
47         while (temp != 0) {
48             length++;
49             temp >>= 8;
50         }
51         return toHexString(value, length);
52     }
53 
54     /**
55      * @dev Converts a `uint256` to its ASCII `string` hexadecimal representation with fixed length.
56      */
57     function toHexString(uint256 value, uint256 length) internal pure returns (string memory) {
58         bytes memory buffer = new bytes(2 * length + 2);
59         buffer[0] = "0";
60         buffer[1] = "x";
61         for (uint256 i = 2 * length + 1; i > 1; --i) {
62             buffer[i] = _HEX_SYMBOLS[value & 0xf];
63             value >>= 4;
64         }
65         require(value == 0, "Strings: hex length insufficient");
66         return string(buffer);
67     }
68 }
69 
70 // File: @openzeppelin/contracts/utils/Address.sol
71 
72 
73 
74 pragma solidity ^0.8.0;
75 
76 /**
77  * @dev Collection of functions related to the address type
78  */
79 library Address {
80     /**
81      * @dev Returns true if `account` is a contract.
82      *
83      * [IMPORTANT]
84      * ====
85      * It is unsafe to assume that an address for which this function returns
86      * false is an externally-owned account (EOA) and not a contract.
87      *
88      * Among others, `isContract` will return false for the following
89      * types of addresses:
90      *
91      *  - an externally-owned account
92      *  - a contract in construction
93      *  - an address where a contract will be created
94      *  - an address where a contract lived, but was destroyed
95      * ====
96      */
97     function isContract(address account) internal view returns (bool) {
98         // This method relies on extcodesize, which returns 0 for contracts in
99         // construction, since the code is only stored at the end of the
100         // constructor execution.
101 
102         uint256 size;
103         assembly {
104             size := extcodesize(account)
105         }
106         return size > 0;
107     }
108 
109     /**
110      * @dev Replacement for Solidity's `transfer`: sends `amount` wei to
111      * `recipient`, forwarding all available gas and reverting on errors.
112      *
113      * https://eips.ethereum.org/EIPS/eip-1884[EIP1884] increases the gas cost
114      * of certain opcodes, possibly making contracts go over the 2300 gas limit
115      * imposed by `transfer`, making them unable to receive funds via
116      * `transfer`. {sendValue} removes this limitation.
117      *
118      * https://diligence.consensys.net/posts/2019/09/stop-using-soliditys-transfer-now/[Learn more].
119      *
120      * IMPORTANT: because control is transferred to `recipient`, care must be
121      * taken to not create reentrancy vulnerabilities. Consider using
122      * {ReentrancyGuard} or the
123      * https://solidity.readthedocs.io/en/v0.5.11/security-considerations.html#use-the-checks-effects-interactions-pattern[checks-effects-interactions pattern].
124      */
125     function sendValue(address payable recipient, uint256 amount) internal {
126         require(address(this).balance >= amount, "Address: insufficient balance");
127 
128         (bool success, ) = recipient.call{value: amount}("");
129         require(success, "Address: unable to send value, recipient may have reverted");
130     }
131 
132     /**
133      * @dev Performs a Solidity function call using a low level `call`. A
134      * plain `call` is an unsafe replacement for a function call: use this
135      * function instead.
136      *
137      * If `target` reverts with a revert reason, it is bubbled up by this
138      * function (like regular Solidity function calls).
139      *
140      * Returns the raw returned data. To convert to the expected return value,
141      * use https://solidity.readthedocs.io/en/latest/units-and-global-variables.html?highlight=abi.decode#abi-encoding-and-decoding-functions[`abi.decode`].
142      *
143      * Requirements:
144      *
145      * - `target` must be a contract.
146      * - calling `target` with `data` must not revert.
147      *
148      * _Available since v3.1._
149      */
150     function functionCall(address target, bytes memory data) internal returns (bytes memory) {
151         return functionCall(target, data, "Address: low-level call failed");
152     }
153 
154     /**
155      * @dev Same as {xref-Address-functionCall-address-bytes-}[`functionCall`], but with
156      * `errorMessage` as a fallback revert reason when `target` reverts.
157      *
158      * _Available since v3.1._
159      */
160     function functionCall(
161         address target,
162         bytes memory data,
163         string memory errorMessage
164     ) internal returns (bytes memory) {
165         return functionCallWithValue(target, data, 0, errorMessage);
166     }
167 
168     /**
169      * @dev Same as {xref-Address-functionCall-address-bytes-}[`functionCall`],
170      * but also transferring `value` wei to `target`.
171      *
172      * Requirements:
173      *
174      * - the calling contract must have an ETH balance of at least `value`.
175      * - the called Solidity function must be `payable`.
176      *
177      * _Available since v3.1._
178      */
179     function functionCallWithValue(
180         address target,
181         bytes memory data,
182         uint256 value
183     ) internal returns (bytes memory) {
184         return functionCallWithValue(target, data, value, "Address: low-level call with value failed");
185     }
186 
187     /**
188      * @dev Same as {xref-Address-functionCallWithValue-address-bytes-uint256-}[`functionCallWithValue`], but
189      * with `errorMessage` as a fallback revert reason when `target` reverts.
190      *
191      * _Available since v3.1._
192      */
193     function functionCallWithValue(
194         address target,
195         bytes memory data,
196         uint256 value,
197         string memory errorMessage
198     ) internal returns (bytes memory) {
199         require(address(this).balance >= value, "Address: insufficient balance for call");
200         require(isContract(target), "Address: call to non-contract");
201 
202         (bool success, bytes memory returndata) = target.call{value: value}(data);
203         return verifyCallResult(success, returndata, errorMessage);
204     }
205 
206     /**
207      * @dev Same as {xref-Address-functionCall-address-bytes-}[`functionCall`],
208      * but performing a static call.
209      *
210      * _Available since v3.3._
211      */
212     function functionStaticCall(address target, bytes memory data) internal view returns (bytes memory) {
213         return functionStaticCall(target, data, "Address: low-level static call failed");
214     }
215 
216     /**
217      * @dev Same as {xref-Address-functionCall-address-bytes-string-}[`functionCall`],
218      * but performing a static call.
219      *
220      * _Available since v3.3._
221      */
222     function functionStaticCall(
223         address target,
224         bytes memory data,
225         string memory errorMessage
226     ) internal view returns (bytes memory) {
227         require(isContract(target), "Address: static call to non-contract");
228 
229         (bool success, bytes memory returndata) = target.staticcall(data);
230         return verifyCallResult(success, returndata, errorMessage);
231     }
232 
233     /**
234      * @dev Same as {xref-Address-functionCall-address-bytes-}[`functionCall`],
235      * but performing a delegate call.
236      *
237      * _Available since v3.4._
238      */
239     function functionDelegateCall(address target, bytes memory data) internal returns (bytes memory) {
240         return functionDelegateCall(target, data, "Address: low-level delegate call failed");
241     }
242 
243     /**
244      * @dev Same as {xref-Address-functionCall-address-bytes-string-}[`functionCall`],
245      * but performing a delegate call.
246      *
247      * _Available since v3.4._
248      */
249     function functionDelegateCall(
250         address target,
251         bytes memory data,
252         string memory errorMessage
253     ) internal returns (bytes memory) {
254         require(isContract(target), "Address: delegate call to non-contract");
255 
256         (bool success, bytes memory returndata) = target.delegatecall(data);
257         return verifyCallResult(success, returndata, errorMessage);
258     }
259 
260     /**
261      * @dev Tool to verifies that a low level call was successful, and revert if it wasn't, either by bubbling the
262      * revert reason using the provided one.
263      *
264      * _Available since v4.3._
265      */
266     function verifyCallResult(
267         bool success,
268         bytes memory returndata,
269         string memory errorMessage
270     ) internal pure returns (bytes memory) {
271         if (success) {
272             return returndata;
273         } else {
274             // Look for revert reason and bubble it up if present
275             if (returndata.length > 0) {
276                 // The easiest way to bubble the revert reason is using memory via assembly
277 
278                 assembly {
279                     let returndata_size := mload(returndata)
280                     revert(add(32, returndata), returndata_size)
281                 }
282             } else {
283                 revert(errorMessage);
284             }
285         }
286     }
287 }
288 
289 // File: @openzeppelin/contracts/token/ERC721/IERC721Receiver.sol
290 
291 
292 
293 pragma solidity ^0.8.0;
294 
295 /**
296  * @title ERC721 token receiver interface
297  * @dev Interface for any contract that wants to support safeTransfers
298  * from ERC721 asset contracts.
299  */
300 interface IERC721Receiver {
301     /**
302      * @dev Whenever an {IERC721} `tokenId` token is transferred to this contract via {IERC721-safeTransferFrom}
303      * by `operator` from `from`, this function is called.
304      *
305      * It must return its Solidity selector to confirm the token transfer.
306      * If any other value is returned or the interface is not implemented by the recipient, the transfer will be reverted.
307      *
308      * The selector can be obtained in Solidity with `IERC721.onERC721Received.selector`.
309      */
310     function onERC721Received(
311         address operator,
312         address from,
313         uint256 tokenId,
314         bytes calldata data
315     ) external returns (bytes4);
316 }
317 
318 // File: @openzeppelin/contracts/utils/introspection/IERC165.sol
319 
320 
321 
322 pragma solidity ^0.8.0;
323 
324 /**
325  * @dev Interface of the ERC165 standard, as defined in the
326  * https://eips.ethereum.org/EIPS/eip-165[EIP].
327  *
328  * Implementers can declare support of contract interfaces, which can then be
329  * queried by others ({ERC165Checker}).
330  *
331  * For an implementation, see {ERC165}.
332  */
333 interface IERC165 {
334     /**
335      * @dev Returns true if this contract implements the interface defined by
336      * `interfaceId`. See the corresponding
337      * https://eips.ethereum.org/EIPS/eip-165#how-interfaces-are-identified[EIP section]
338      * to learn more about how these ids are created.
339      *
340      * This function call must use less than 30 000 gas.
341      */
342     function supportsInterface(bytes4 interfaceId) external view returns (bool);
343 }
344 
345 // File: @openzeppelin/contracts/utils/introspection/ERC165.sol
346 
347 
348 
349 pragma solidity ^0.8.0;
350 
351 
352 /**
353  * @dev Implementation of the {IERC165} interface.
354  *
355  * Contracts that want to implement ERC165 should inherit from this contract and override {supportsInterface} to check
356  * for the additional interface id that will be supported. For example:
357  *
358  * ```solidity
359  * function supportsInterface(bytes4 interfaceId) public view virtual override returns (bool) {
360  *     return interfaceId == type(MyInterface).interfaceId || super.supportsInterface(interfaceId);
361  * }
362  * ```
363  *
364  * Alternatively, {ERC165Storage} provides an easier to use but more expensive implementation.
365  */
366 abstract contract ERC165 is IERC165 {
367     /**
368      * @dev See {IERC165-supportsInterface}.
369      */
370     function supportsInterface(bytes4 interfaceId) public view virtual override returns (bool) {
371         return interfaceId == type(IERC165).interfaceId;
372     }
373 }
374 
375 // File: @openzeppelin/contracts/token/ERC721/IERC721.sol
376 
377 
378 
379 pragma solidity ^0.8.0;
380 
381 
382 /**
383  * @dev Required interface of an ERC721 compliant contract.
384  */
385 interface IERC721 is IERC165 {
386     /**
387      * @dev Emitted when `tokenId` token is transferred from `from` to `to`.
388      */
389     event Transfer(address indexed from, address indexed to, uint256 indexed tokenId);
390 
391     /**
392      * @dev Emitted when `owner` enables `approved` to manage the `tokenId` token.
393      */
394     event Approval(address indexed owner, address indexed approved, uint256 indexed tokenId);
395 
396     /**
397      * @dev Emitted when `owner` enables or disables (`approved`) `operator` to manage all of its assets.
398      */
399     event ApprovalForAll(address indexed owner, address indexed operator, bool approved);
400 
401     /**
402      * @dev Returns the number of tokens in ``owner``'s account.
403      */
404     function balanceOf(address owner) external view returns (uint256 balance);
405 
406     /**
407      * @dev Returns the owner of the `tokenId` token.
408      *
409      * Requirements:
410      *
411      * - `tokenId` must exist.
412      */
413     function ownerOf(uint256 tokenId) external view returns (address owner);
414 
415     /**
416      * @dev Safely transfers `tokenId` token from `from` to `to`, checking first that contract recipients
417      * are aware of the ERC721 protocol to prevent tokens from being forever locked.
418      *
419      * Requirements:
420      *
421      * - `from` cannot be the zero address.
422      * - `to` cannot be the zero address.
423      * - `tokenId` token must exist and be owned by `from`.
424      * - If the caller is not `from`, it must be have been allowed to move this token by either {approve} or {setApprovalForAll}.
425      * - If `to` refers to a smart contract, it must implement {IERC721Receiver-onERC721Received}, which is called upon a safe transfer.
426      *
427      * Emits a {Transfer} event.
428      */
429     function safeTransferFrom(
430         address from,
431         address to,
432         uint256 tokenId
433     ) external;
434 
435     /**
436      * @dev Transfers `tokenId` token from `from` to `to`.
437      *
438      * WARNING: Usage of this method is discouraged, use {safeTransferFrom} whenever possible.
439      *
440      * Requirements:
441      *
442      * - `from` cannot be the zero address.
443      * - `to` cannot be the zero address.
444      * - `tokenId` token must be owned by `from`.
445      * - If the caller is not `from`, it must be approved to move this token by either {approve} or {setApprovalForAll}.
446      *
447      * Emits a {Transfer} event.
448      */
449     function transferFrom(
450         address from,
451         address to,
452         uint256 tokenId
453     ) external;
454 
455     /**
456      * @dev Gives permission to `to` to transfer `tokenId` token to another account.
457      * The approval is cleared when the token is transferred.
458      *
459      * Only a single account can be approved at a time, so approving the zero address clears previous approvals.
460      *
461      * Requirements:
462      *
463      * - The caller must own the token or be an approved operator.
464      * - `tokenId` must exist.
465      *
466      * Emits an {Approval} event.
467      */
468     function approve(address to, uint256 tokenId) external;
469 
470     /**
471      * @dev Returns the account approved for `tokenId` token.
472      *
473      * Requirements:
474      *
475      * - `tokenId` must exist.
476      */
477     function getApproved(uint256 tokenId) external view returns (address operator);
478 
479     /**
480      * @dev Approve or remove `operator` as an operator for the caller.
481      * Operators can call {transferFrom} or {safeTransferFrom} for any token owned by the caller.
482      *
483      * Requirements:
484      *
485      * - The `operator` cannot be the caller.
486      *
487      * Emits an {ApprovalForAll} event.
488      */
489     function setApprovalForAll(address operator, bool _approved) external;
490 
491     /**
492      * @dev Returns if the `operator` is allowed to manage all of the assets of `owner`.
493      *
494      * See {setApprovalForAll}
495      */
496     function isApprovedForAll(address owner, address operator) external view returns (bool);
497 
498     /**
499      * @dev Safely transfers `tokenId` token from `from` to `to`.
500      *
501      * Requirements:
502      *
503      * - `from` cannot be the zero address.
504      * - `to` cannot be the zero address.
505      * - `tokenId` token must exist and be owned by `from`.
506      * - If the caller is not `from`, it must be approved to move this token by either {approve} or {setApprovalForAll}.
507      * - If `to` refers to a smart contract, it must implement {IERC721Receiver-onERC721Received}, which is called upon a safe transfer.
508      *
509      * Emits a {Transfer} event.
510      */
511     function safeTransferFrom(
512         address from,
513         address to,
514         uint256 tokenId,
515         bytes calldata data
516     ) external;
517 }
518 
519 // File: @openzeppelin/contracts/token/ERC721/extensions/IERC721Metadata.sol
520 
521 
522 
523 pragma solidity ^0.8.0;
524 
525 
526 /**
527  * @title ERC-721 Non-Fungible Token Standard, optional metadata extension
528  * @dev See https://eips.ethereum.org/EIPS/eip-721
529  */
530 interface IERC721Metadata is IERC721 {
531     /**
532      * @dev Returns the token collection name.
533      */
534     function name() external view returns (string memory);
535 
536     /**
537      * @dev Returns the token collection symbol.
538      */
539     function symbol() external view returns (string memory);
540 
541     /**
542      * @dev Returns the Uniform Resource Identifier (URI) for `tokenId` token.
543      */
544     function tokenURI(uint256 tokenId) external view returns (string memory);
545 }
546 
547 // File: @openzeppelin/contracts/utils/Context.sol
548 
549 
550 
551 pragma solidity ^0.8.0;
552 
553 /**
554  * @dev Provides information about the current execution context, including the
555  * sender of the transaction and its data. While these are generally available
556  * via msg.sender and msg.data, they should not be accessed in such a direct
557  * manner, since when dealing with meta-transactions the account sending and
558  * paying for execution may not be the actual sender (as far as an application
559  * is concerned).
560  *
561  * This contract is only required for intermediate, library-like contracts.
562  */
563 abstract contract Context {
564     function _msgSender() internal view virtual returns (address) {
565         return msg.sender;
566     }
567 
568     function _msgData() internal view virtual returns (bytes calldata) {
569         return msg.data;
570     }
571 }
572 
573 // File: @openzeppelin/contracts/token/ERC721/ERC721.sol
574 
575 
576 
577 pragma solidity ^0.8.0;
578 
579 
580 
581 
582 
583 
584 
585 
586 /**
587  * @dev Implementation of https://eips.ethereum.org/EIPS/eip-721[ERC721] Non-Fungible Token Standard, including
588  * the Metadata extension, but not including the Enumerable extension, which is available separately as
589  * {ERC721Enumerable}.
590  */
591 contract ERC721 is Context, ERC165, IERC721, IERC721Metadata {
592     using Address for address;
593     using Strings for uint256;
594 
595     // Token name
596     string private _name;
597 
598     // Token symbol
599     string private _symbol;
600 
601     // Mapping from token ID to owner address
602     mapping(uint256 => address) private _owners;
603 
604     // Mapping owner address to token count
605     mapping(address => uint256) private _balances;
606 
607     // Mapping from token ID to approved address
608     mapping(uint256 => address) private _tokenApprovals;
609 
610     // Mapping from owner to operator approvals
611     mapping(address => mapping(address => bool)) private _operatorApprovals;
612 
613     /**
614      * @dev Initializes the contract by setting a `name` and a `symbol` to the token collection.
615      */
616     constructor(string memory name_, string memory symbol_) {
617         _name = name_;
618         _symbol = symbol_;
619     }
620 
621     /**
622      * @dev See {IERC165-supportsInterface}.
623      */
624     function supportsInterface(bytes4 interfaceId) public view virtual override(ERC165, IERC165) returns (bool) {
625         return
626             interfaceId == type(IERC721).interfaceId ||
627             interfaceId == type(IERC721Metadata).interfaceId ||
628             super.supportsInterface(interfaceId);
629     }
630 
631     /**
632      * @dev See {IERC721-balanceOf}.
633      */
634     function balanceOf(address owner) public view virtual override returns (uint256) {
635         require(owner != address(0), "ERC721: balance query for the zero address");
636         return _balances[owner];
637     }
638 
639     /**
640      * @dev See {IERC721-ownerOf}.
641      */
642     function ownerOf(uint256 tokenId) public view virtual override returns (address) {
643         address owner = _owners[tokenId];
644         require(owner != address(0), "ERC721: owner query for nonexistent token");
645         return owner;
646     }
647 
648     /**
649      * @dev See {IERC721Metadata-name}.
650      */
651     function name() public view virtual override returns (string memory) {
652         return _name;
653     }
654 
655     /**
656      * @dev See {IERC721Metadata-symbol}.
657      */
658     function symbol() public view virtual override returns (string memory) {
659         return _symbol;
660     }
661 
662     /**
663      * @dev See {IERC721Metadata-tokenURI}.
664      */
665     function tokenURI(uint256 tokenId) public view virtual override returns (string memory) {
666         require(_exists(tokenId), "ERC721Metadata: URI query for nonexistent token");
667 
668         string memory baseURI = _baseURI();
669         return bytes(baseURI).length > 0 ? string(abi.encodePacked(baseURI, tokenId.toString())) : "";
670     }
671 
672     /**
673      * @dev Base URI for computing {tokenURI}. If set, the resulting URI for each
674      * token will be the concatenation of the `baseURI` and the `tokenId`. Empty
675      * by default, can be overriden in child contracts.
676      */
677     function _baseURI() internal view virtual returns (string memory) {
678         return "";
679     }
680 
681     /**
682      * @dev See {IERC721-approve}.
683      */
684     function approve(address to, uint256 tokenId) public virtual override {
685         address owner = ERC721.ownerOf(tokenId);
686         require(to != owner, "ERC721: approval to current owner");
687 
688         require(
689             _msgSender() == owner || isApprovedForAll(owner, _msgSender()),
690             "ERC721: approve caller is not owner nor approved for all"
691         );
692 
693         _approve(to, tokenId);
694     }
695 
696     /**
697      * @dev See {IERC721-getApproved}.
698      */
699     function getApproved(uint256 tokenId) public view virtual override returns (address) {
700         require(_exists(tokenId), "ERC721: approved query for nonexistent token");
701 
702         return _tokenApprovals[tokenId];
703     }
704 
705     /**
706      * @dev See {IERC721-setApprovalForAll}.
707      */
708     function setApprovalForAll(address operator, bool approved) public virtual override {
709         require(operator != _msgSender(), "ERC721: approve to caller");
710 
711         _operatorApprovals[_msgSender()][operator] = approved;
712         emit ApprovalForAll(_msgSender(), operator, approved);
713     }
714 
715     /**
716      * @dev See {IERC721-isApprovedForAll}.
717      */
718     function isApprovedForAll(address owner, address operator) public view virtual override returns (bool) {
719         return _operatorApprovals[owner][operator];
720     }
721 
722     /**
723      * @dev See {IERC721-transferFrom}.
724      */
725     function transferFrom(
726         address from,
727         address to,
728         uint256 tokenId
729     ) public virtual override {
730         //solhint-disable-next-line max-line-length
731         require(_isApprovedOrOwner(_msgSender(), tokenId), "ERC721: transfer caller is not owner nor approved");
732 
733         _transfer(from, to, tokenId);
734     }
735 
736     /**
737      * @dev See {IERC721-safeTransferFrom}.
738      */
739     function safeTransferFrom(
740         address from,
741         address to,
742         uint256 tokenId
743     ) public virtual override {
744         safeTransferFrom(from, to, tokenId, "");
745     }
746 
747     /**
748      * @dev See {IERC721-safeTransferFrom}.
749      */
750     function safeTransferFrom(
751         address from,
752         address to,
753         uint256 tokenId,
754         bytes memory _data
755     ) public virtual override {
756         require(_isApprovedOrOwner(_msgSender(), tokenId), "ERC721: transfer caller is not owner nor approved");
757         _safeTransfer(from, to, tokenId, _data);
758     }
759 
760     /**
761      * @dev Safely transfers `tokenId` token from `from` to `to`, checking first that contract recipients
762      * are aware of the ERC721 protocol to prevent tokens from being forever locked.
763      *
764      * `_data` is additional data, it has no specified format and it is sent in call to `to`.
765      *
766      * This internal function is equivalent to {safeTransferFrom}, and can be used to e.g.
767      * implement alternative mechanisms to perform token transfer, such as signature-based.
768      *
769      * Requirements:
770      *
771      * - `from` cannot be the zero address.
772      * - `to` cannot be the zero address.
773      * - `tokenId` token must exist and be owned by `from`.
774      * - If `to` refers to a smart contract, it must implement {IERC721Receiver-onERC721Received}, which is called upon a safe transfer.
775      *
776      * Emits a {Transfer} event.
777      */
778     function _safeTransfer(
779         address from,
780         address to,
781         uint256 tokenId,
782         bytes memory _data
783     ) internal virtual {
784         _transfer(from, to, tokenId);
785         require(_checkOnERC721Received(from, to, tokenId, _data), "ERC721: transfer to non ERC721Receiver implementer");
786     }
787 
788     /**
789      * @dev Returns whether `tokenId` exists.
790      *
791      * Tokens can be managed by their owner or approved accounts via {approve} or {setApprovalForAll}.
792      *
793      * Tokens start existing when they are minted (`_mint`),
794      * and stop existing when they are burned (`_burn`).
795      */
796     function _exists(uint256 tokenId) internal view virtual returns (bool) {
797         return _owners[tokenId] != address(0);
798     }
799 
800     /**
801      * @dev Returns whether `spender` is allowed to manage `tokenId`.
802      *
803      * Requirements:
804      *
805      * - `tokenId` must exist.
806      */
807     function _isApprovedOrOwner(address spender, uint256 tokenId) internal view virtual returns (bool) {
808         require(_exists(tokenId), "ERC721: operator query for nonexistent token");
809         address owner = ERC721.ownerOf(tokenId);
810         return (spender == owner || getApproved(tokenId) == spender || isApprovedForAll(owner, spender));
811     }
812 
813     /**
814      * @dev Safely mints `tokenId` and transfers it to `to`.
815      *
816      * Requirements:
817      *
818      * - `tokenId` must not exist.
819      * - If `to` refers to a smart contract, it must implement {IERC721Receiver-onERC721Received}, which is called upon a safe transfer.
820      *
821      * Emits a {Transfer} event.
822      */
823     function _safeMint(address to, uint256 tokenId) internal virtual {
824         _safeMint(to, tokenId, "");
825     }
826 
827     /**
828      * @dev Same as {xref-ERC721-_safeMint-address-uint256-}[`_safeMint`], with an additional `data` parameter which is
829      * forwarded in {IERC721Receiver-onERC721Received} to contract recipients.
830      */
831     function _safeMint(
832         address to,
833         uint256 tokenId,
834         bytes memory _data
835     ) internal virtual {
836         _mint(to, tokenId);
837         require(
838             _checkOnERC721Received(address(0), to, tokenId, _data),
839             "ERC721: transfer to non ERC721Receiver implementer"
840         );
841     }
842 
843     /**
844      * @dev Mints `tokenId` and transfers it to `to`.
845      *
846      * WARNING: Usage of this method is discouraged, use {_safeMint} whenever possible
847      *
848      * Requirements:
849      *
850      * - `tokenId` must not exist.
851      * - `to` cannot be the zero address.
852      *
853      * Emits a {Transfer} event.
854      */
855     function _mint(address to, uint256 tokenId) internal virtual {
856         require(to != address(0), "ERC721: mint to the zero address");
857         require(!_exists(tokenId), "ERC721: token already minted");
858 
859         _beforeTokenTransfer(address(0), to, tokenId);
860 
861         _balances[to] += 1;
862         _owners[tokenId] = to;
863 
864         emit Transfer(address(0), to, tokenId);
865     }
866 
867     /**
868      * @dev Destroys `tokenId`.
869      * The approval is cleared when the token is burned.
870      *
871      * Requirements:
872      *
873      * - `tokenId` must exist.
874      *
875      * Emits a {Transfer} event.
876      */
877     function _burn(uint256 tokenId) internal virtual {
878         address owner = ERC721.ownerOf(tokenId);
879 
880         _beforeTokenTransfer(owner, address(0), tokenId);
881 
882         // Clear approvals
883         _approve(address(0), tokenId);
884 
885         _balances[owner] -= 1;
886         delete _owners[tokenId];
887 
888         emit Transfer(owner, address(0), tokenId);
889     }
890 
891     /**
892      * @dev Transfers `tokenId` from `from` to `to`.
893      *  As opposed to {transferFrom}, this imposes no restrictions on msg.sender.
894      *
895      * Requirements:
896      *
897      * - `to` cannot be the zero address.
898      * - `tokenId` token must be owned by `from`.
899      *
900      * Emits a {Transfer} event.
901      */
902     function _transfer(
903         address from,
904         address to,
905         uint256 tokenId
906     ) internal virtual {
907         require(ERC721.ownerOf(tokenId) == from, "ERC721: transfer of token that is not own");
908         require(to != address(0), "ERC721: transfer to the zero address");
909 
910         _beforeTokenTransfer(from, to, tokenId);
911 
912         // Clear approvals from the previous owner
913         _approve(address(0), tokenId);
914 
915         _balances[from] -= 1;
916         _balances[to] += 1;
917         _owners[tokenId] = to;
918 
919         emit Transfer(from, to, tokenId);
920     }
921 
922     /**
923      * @dev Approve `to` to operate on `tokenId`
924      *
925      * Emits a {Approval} event.
926      */
927     function _approve(address to, uint256 tokenId) internal virtual {
928         _tokenApprovals[tokenId] = to;
929         emit Approval(ERC721.ownerOf(tokenId), to, tokenId);
930     }
931 
932     /**
933      * @dev Internal function to invoke {IERC721Receiver-onERC721Received} on a target address.
934      * The call is not executed if the target address is not a contract.
935      *
936      * @param from address representing the previous owner of the given token ID
937      * @param to target address that will receive the tokens
938      * @param tokenId uint256 ID of the token to be transferred
939      * @param _data bytes optional data to send along with the call
940      * @return bool whether the call correctly returned the expected magic value
941      */
942     function _checkOnERC721Received(
943         address from,
944         address to,
945         uint256 tokenId,
946         bytes memory _data
947     ) private returns (bool) {
948         if (to.isContract()) {
949             try IERC721Receiver(to).onERC721Received(_msgSender(), from, tokenId, _data) returns (bytes4 retval) {
950                 return retval == IERC721Receiver.onERC721Received.selector;
951             } catch (bytes memory reason) {
952                 if (reason.length == 0) {
953                     revert("ERC721: transfer to non ERC721Receiver implementer");
954                 } else {
955                     assembly {
956                         revert(add(32, reason), mload(reason))
957                     }
958                 }
959             }
960         } else {
961             return true;
962         }
963     }
964 
965     /**
966      * @dev Hook that is called before any token transfer. This includes minting
967      * and burning.
968      *
969      * Calling conditions:
970      *
971      * - When `from` and `to` are both non-zero, ``from``'s `tokenId` will be
972      * transferred to `to`.
973      * - When `from` is zero, `tokenId` will be minted for `to`.
974      * - When `to` is zero, ``from``'s `tokenId` will be burned.
975      * - `from` and `to` are never both zero.
976      *
977      * To learn more about hooks, head to xref:ROOT:extending-contracts.adoc#using-hooks[Using Hooks].
978      */
979     function _beforeTokenTransfer(
980         address from,
981         address to,
982         uint256 tokenId
983     ) internal virtual {}
984 }
985 
986 // File: @openzeppelin/contracts/access/Ownable.sol
987 
988 
989 
990 pragma solidity ^0.8.0;
991 
992 
993 /**
994  * @dev Contract module which provides a basic access control mechanism, where
995  * there is an account (an owner) that can be granted exclusive access to
996  * specific functions.
997  *
998  * By default, the owner account will be the one that deploys the contract. This
999  * can later be changed with {transferOwnership}.
1000  *
1001  * This module is used through inheritance. It will make available the modifier
1002  * `onlyOwner`, which can be applied to your functions to restrict their use to
1003  * the owner.
1004  */
1005 abstract contract Ownable is Context {
1006     address private _owner;
1007 
1008     event OwnershipTransferred(address indexed previousOwner, address indexed newOwner);
1009 
1010     /**
1011      * @dev Initializes the contract setting the deployer as the initial owner.
1012      */
1013     constructor() {
1014         _setOwner(_msgSender());
1015     }
1016 
1017     /**
1018      * @dev Returns the address of the current owner.
1019      */
1020     function owner() public view virtual returns (address) {
1021         return _owner;
1022     }
1023 
1024     /**
1025      * @dev Throws if called by any account other than the owner.
1026      */
1027     modifier onlyOwner() {
1028         require(owner() == _msgSender(), "Ownable: caller is not the owner");
1029         _;
1030     }
1031 
1032     /**
1033      * @dev Leaves the contract without owner. It will not be possible to call
1034      * `onlyOwner` functions anymore. Can only be called by the current owner.
1035      *
1036      * NOTE: Renouncing ownership will leave the contract without an owner,
1037      * thereby removing any functionality that is only available to the owner.
1038      */
1039     function renounceOwnership() public virtual onlyOwner {
1040         _setOwner(address(0));
1041     }
1042 
1043     /**
1044      * @dev Transfers ownership of the contract to a new account (`newOwner`).
1045      * Can only be called by the current owner.
1046      */
1047     function transferOwnership(address newOwner) public virtual onlyOwner {
1048         require(newOwner != address(0), "Ownable: new owner is the zero address");
1049         _setOwner(newOwner);
1050     }
1051 
1052     function _setOwner(address newOwner) private {
1053         address oldOwner = _owner;
1054         _owner = newOwner;
1055         emit OwnershipTransferred(oldOwner, newOwner);
1056     }
1057 }
1058 
1059 // File: contracts/BallerBears.sol
1060 
1061 
1062 
1063 pragma solidity ^0.8.9;
1064 
1065 // @title: BallerBears.sol
1066 
1067 
1068 
1069 contract BallerBears is ERC721, Ownable {
1070     using Strings for uint256;
1071 
1072     uint256 public constant MAX_TOKENS = 4444;
1073     uint256 private constant TOKENS_RESERVED = 20;
1074     uint256 public price = 80000000000000000;
1075     uint256 public constant MAX_MINT_PER_TX = 10;
1076 
1077     bool public isSaleActive;
1078     uint256 public totalSupply;
1079     mapping(address => uint256) private mintedPerWallet;
1080 
1081     string public baseUri;
1082     string public baseExtension = ".json";
1083 
1084     constructor() ERC721("Baller Bears", "BEARS") {
1085         // Base IPFS URI of the Baller Bears
1086         baseUri = "ipfs://Qmb1WNzRZ6jcSzFpa8zSDA7bqkjGAgUPV9AE3uSdWRbMzt/";
1087         for (uint256 i = 1; i <= TOKENS_RESERVED; ++i) {
1088             _safeMint(msg.sender, i);
1089         }
1090         totalSupply = TOKENS_RESERVED;
1091     }
1092 
1093     // PUBLIC FUNCTIONS
1094     function mintBear(uint256 _numTokens) external payable {
1095         require(isSaleActive, "The sale is paused.");
1096         require(_numTokens <= MAX_MINT_PER_TX, "You can only mint a maximum of 10 Baller Bears per transaction.");
1097         require(mintedPerWallet[msg.sender] + _numTokens <= 10, "You can only mint 10 per wallet.");
1098         uint256 curTotalSupply = totalSupply;
1099         require(curTotalSupply + _numTokens <= MAX_TOKENS, "Exceeds `MAX_TOKENS`");
1100         require(_numTokens * price <= msg.value, "Insufficient funds. You need more ETH!");
1101 
1102         for (uint256 i = 1; i <= _numTokens; ++i) {
1103             _safeMint(msg.sender, curTotalSupply + i);
1104         }
1105         mintedPerWallet[msg.sender] += _numTokens;
1106         totalSupply += _numTokens;
1107     }
1108 
1109     // OWNER ONLY FUNCTIONS
1110     function flipSaleState() external onlyOwner {
1111         isSaleActive = !isSaleActive;
1112     }
1113 
1114     function setBaseURI(string memory _baseUri) external onlyOwner {
1115         baseUri = _baseUri;
1116     }
1117 
1118     function setPrice(uint256 _price) external onlyOwner {
1119         price = _price;
1120     }
1121 
1122     function withdrawAll() external payable onlyOwner {
1123         uint256 balance = address(this).balance;
1124         uint256 balanceOne = balance * 80 / 100;
1125         uint256 balanceTwo = balance * 20 / 100;
1126         (bool transferOne, ) = payable(0xA477c13E0f86170F855d06EFDE32858ad9f18941).call{value: balanceOne}("");
1127         (bool transferTwo, ) = payable(0x233E73Ff2e0369C401661C3739849Bc98E204464).call{value: balanceTwo}("");
1128         require(transferOne && transferTwo, "Transfer failed.");
1129     }
1130 
1131 
1132     function tokenURI(uint256 tokenId)
1133         public
1134         view
1135         virtual
1136         override
1137         returns (string memory)
1138     {
1139         require(
1140             _exists(tokenId),
1141             "ERC721Metadata: URI query for nonexistent token"
1142         );
1143 
1144         string memory currentBaseURI = _baseURI();
1145         return bytes(currentBaseURI).length > 0
1146             ? string(abi.encodePacked(currentBaseURI, tokenId.toString(), baseExtension))
1147             : "";
1148   }
1149 
1150 
1151     // INTERNAL FUNCTIONS
1152     function _baseURI() internal view virtual override returns (string memory) {
1153         return baseUri;
1154     }
1155 
1156 }