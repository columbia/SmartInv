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
519 // File: @openzeppelin/contracts/token/ERC721/extensions/IERC721Enumerable.sol
520 
521 
522 
523 pragma solidity ^0.8.0;
524 
525 
526 /**
527  * @title ERC-721 Non-Fungible Token Standard, optional enumeration extension
528  * @dev See https://eips.ethereum.org/EIPS/eip-721
529  */
530 interface IERC721Enumerable is IERC721 {
531     /**
532      * @dev Returns the total amount of tokens stored by the contract.
533      */
534     function totalSupply() external view returns (uint256);
535 
536     /**
537      * @dev Returns a token ID owned by `owner` at a given `index` of its token list.
538      * Use along with {balanceOf} to enumerate all of ``owner``'s tokens.
539      */
540     function tokenOfOwnerByIndex(address owner, uint256 index) external view returns (uint256 tokenId);
541 
542     /**
543      * @dev Returns a token ID at a given `index` of all the tokens stored by the contract.
544      * Use along with {totalSupply} to enumerate all tokens.
545      */
546     function tokenByIndex(uint256 index) external view returns (uint256);
547 }
548 
549 // File: @openzeppelin/contracts/token/ERC721/extensions/IERC721Metadata.sol
550 
551 
552 
553 pragma solidity ^0.8.0;
554 
555 
556 /**
557  * @title ERC-721 Non-Fungible Token Standard, optional metadata extension
558  * @dev See https://eips.ethereum.org/EIPS/eip-721
559  */
560 interface IERC721Metadata is IERC721 {
561     /**
562      * @dev Returns the token collection name.
563      */
564     function name() external view returns (string memory);
565 
566     /**
567      * @dev Returns the token collection symbol.
568      */
569     function symbol() external view returns (string memory);
570 
571     /**
572      * @dev Returns the Uniform Resource Identifier (URI) for `tokenId` token.
573      */
574     function tokenURI(uint256 tokenId) external view returns (string memory);
575 }
576 
577 // File: @openzeppelin/contracts/utils/Context.sol
578 
579 
580 
581 pragma solidity ^0.8.0;
582 
583 /**
584  * @dev Provides information about the current execution context, including the
585  * sender of the transaction and its data. While these are generally available
586  * via msg.sender and msg.data, they should not be accessed in such a direct
587  * manner, since when dealing with meta-transactions the account sending and
588  * paying for execution may not be the actual sender (as far as an application
589  * is concerned).
590  *
591  * This contract is only required for intermediate, library-like contracts.
592  */
593 abstract contract Context {
594     function _msgSender() internal view virtual returns (address) {
595         return msg.sender;
596     }
597 
598     function _msgData() internal view virtual returns (bytes calldata) {
599         return msg.data;
600     }
601 }
602 
603 // File: @openzeppelin/contracts/token/ERC721/ERC721.sol
604 
605 
606 
607 pragma solidity ^0.8.0;
608 
609 
610 
611 
612 
613 
614 
615 
616 /**
617  * @dev Implementation of https://eips.ethereum.org/EIPS/eip-721[ERC721] Non-Fungible Token Standard, including
618  * the Metadata extension, but not including the Enumerable extension, which is available separately as
619  * {ERC721Enumerable}.
620  */
621 contract ERC721 is Context, ERC165, IERC721, IERC721Metadata {
622     using Address for address;
623     using Strings for uint256;
624 
625     // Token name
626     string private _name;
627 
628     // Token symbol
629     string private _symbol;
630 
631     // Mapping from token ID to owner address
632     mapping(uint256 => address) private _owners;
633 
634     // Mapping owner address to token count
635     mapping(address => uint256) private _balances;
636 
637     // Mapping from token ID to approved address
638     mapping(uint256 => address) private _tokenApprovals;
639 
640     // Mapping from owner to operator approvals
641     mapping(address => mapping(address => bool)) private _operatorApprovals;
642 
643     /**
644      * @dev Initializes the contract by setting a `name` and a `symbol` to the token collection.
645      */
646     constructor(string memory name_, string memory symbol_) {
647         _name = name_;
648         _symbol = symbol_;
649     }
650 
651     /**
652      * @dev See {IERC165-supportsInterface}.
653      */
654     function supportsInterface(bytes4 interfaceId) public view virtual override(ERC165, IERC165) returns (bool) {
655         return
656             interfaceId == type(IERC721).interfaceId ||
657             interfaceId == type(IERC721Metadata).interfaceId ||
658             super.supportsInterface(interfaceId);
659     }
660 
661     /**
662      * @dev See {IERC721-balanceOf}.
663      */
664     function balanceOf(address owner) public view virtual override returns (uint256) {
665         require(owner != address(0), "ERC721: balance query for the zero address");
666         return _balances[owner];
667     }
668 
669     /**
670      * @dev See {IERC721-ownerOf}.
671      */
672     function ownerOf(uint256 tokenId) public view virtual override returns (address) {
673         address owner = _owners[tokenId];
674         require(owner != address(0), "ERC721: owner query for nonexistent token");
675         return owner;
676     }
677 
678     /**
679      * @dev See {IERC721Metadata-name}.
680      */
681     function name() public view virtual override returns (string memory) {
682         return _name;
683     }
684 
685     /**
686      * @dev See {IERC721Metadata-symbol}.
687      */
688     function symbol() public view virtual override returns (string memory) {
689         return _symbol;
690     }
691 
692     /**
693      * @dev See {IERC721Metadata-tokenURI}.
694      */
695     function tokenURI(uint256 tokenId) public view virtual override returns (string memory) {
696         require(_exists(tokenId), "ERC721Metadata: URI query for nonexistent token");
697 
698         string memory baseURI = _baseURI();
699         return bytes(baseURI).length > 0 ? string(abi.encodePacked(baseURI, tokenId.toString())) : "";
700     }
701 
702     /**
703      * @dev Base URI for computing {tokenURI}. If set, the resulting URI for each
704      * token will be the concatenation of the `baseURI` and the `tokenId`. Empty
705      * by default, can be overriden in child contracts.
706      */
707     function _baseURI() internal view virtual returns (string memory) {
708         return "";
709     }
710 
711     /**
712      * @dev See {IERC721-approve}.
713      */
714     function approve(address to, uint256 tokenId) public virtual override {
715         address owner = ERC721.ownerOf(tokenId);
716         require(to != owner, "ERC721: approval to current owner");
717 
718         require(
719             _msgSender() == owner || isApprovedForAll(owner, _msgSender()),
720             "ERC721: approve caller is not owner nor approved for all"
721         );
722 
723         _approve(to, tokenId);
724     }
725 
726     /**
727      * @dev See {IERC721-getApproved}.
728      */
729     function getApproved(uint256 tokenId) public view virtual override returns (address) {
730         require(_exists(tokenId), "ERC721: approved query for nonexistent token");
731 
732         return _tokenApprovals[tokenId];
733     }
734 
735     /**
736      * @dev See {IERC721-setApprovalForAll}.
737      */
738     function setApprovalForAll(address operator, bool approved) public virtual override {
739         require(operator != _msgSender(), "ERC721: approve to caller");
740 
741         _operatorApprovals[_msgSender()][operator] = approved;
742         emit ApprovalForAll(_msgSender(), operator, approved);
743     }
744 
745     /**
746      * @dev See {IERC721-isApprovedForAll}.
747      */
748     function isApprovedForAll(address owner, address operator) public view virtual override returns (bool) {
749         return _operatorApprovals[owner][operator];
750     }
751 
752     /**
753      * @dev See {IERC721-transferFrom}.
754      */
755     function transferFrom(
756         address from,
757         address to,
758         uint256 tokenId
759     ) public virtual override {
760         //solhint-disable-next-line max-line-length
761         require(_isApprovedOrOwner(_msgSender(), tokenId), "ERC721: transfer caller is not owner nor approved");
762 
763         _transfer(from, to, tokenId);
764     }
765 
766     /**
767      * @dev See {IERC721-safeTransferFrom}.
768      */
769     function safeTransferFrom(
770         address from,
771         address to,
772         uint256 tokenId
773     ) public virtual override {
774         safeTransferFrom(from, to, tokenId, "");
775     }
776 
777     /**
778      * @dev See {IERC721-safeTransferFrom}.
779      */
780     function safeTransferFrom(
781         address from,
782         address to,
783         uint256 tokenId,
784         bytes memory _data
785     ) public virtual override {
786         require(_isApprovedOrOwner(_msgSender(), tokenId), "ERC721: transfer caller is not owner nor approved");
787         _safeTransfer(from, to, tokenId, _data);
788     }
789 
790     /**
791      * @dev Safely transfers `tokenId` token from `from` to `to`, checking first that contract recipients
792      * are aware of the ERC721 protocol to prevent tokens from being forever locked.
793      *
794      * `_data` is additional data, it has no specified format and it is sent in call to `to`.
795      *
796      * This internal function is equivalent to {safeTransferFrom}, and can be used to e.g.
797      * implement alternative mechanisms to perform token transfer, such as signature-based.
798      *
799      * Requirements:
800      *
801      * - `from` cannot be the zero address.
802      * - `to` cannot be the zero address.
803      * - `tokenId` token must exist and be owned by `from`.
804      * - If `to` refers to a smart contract, it must implement {IERC721Receiver-onERC721Received}, which is called upon a safe transfer.
805      *
806      * Emits a {Transfer} event.
807      */
808     function _safeTransfer(
809         address from,
810         address to,
811         uint256 tokenId,
812         bytes memory _data
813     ) internal virtual {
814         _transfer(from, to, tokenId);
815         require(_checkOnERC721Received(from, to, tokenId, _data), "ERC721: transfer to non ERC721Receiver implementer");
816     }
817 
818     /**
819      * @dev Returns whether `tokenId` exists.
820      *
821      * Tokens can be managed by their owner or approved accounts via {approve} or {setApprovalForAll}.
822      *
823      * Tokens start existing when they are minted (`_mint`),
824      * and stop existing when they are burned (`_burn`).
825      */
826     function _exists(uint256 tokenId) internal view virtual returns (bool) {
827         return _owners[tokenId] != address(0);
828     }
829 
830     /**
831      * @dev Returns whether `spender` is allowed to manage `tokenId`.
832      *
833      * Requirements:
834      *
835      * - `tokenId` must exist.
836      */
837     function _isApprovedOrOwner(address spender, uint256 tokenId) internal view virtual returns (bool) {
838         require(_exists(tokenId), "ERC721: operator query for nonexistent token");
839         address owner = ERC721.ownerOf(tokenId);
840         return (spender == owner || getApproved(tokenId) == spender || isApprovedForAll(owner, spender));
841     }
842 
843     /**
844      * @dev Safely mints `tokenId` and transfers it to `to`.
845      *
846      * Requirements:
847      *
848      * - `tokenId` must not exist.
849      * - If `to` refers to a smart contract, it must implement {IERC721Receiver-onERC721Received}, which is called upon a safe transfer.
850      *
851      * Emits a {Transfer} event.
852      */
853     function _safeMint(address to, uint256 tokenId) internal virtual {
854         _safeMint(to, tokenId, "");
855     }
856 
857     /**
858      * @dev Same as {xref-ERC721-_safeMint-address-uint256-}[`_safeMint`], with an additional `data` parameter which is
859      * forwarded in {IERC721Receiver-onERC721Received} to contract recipients.
860      */
861     function _safeMint(
862         address to,
863         uint256 tokenId,
864         bytes memory _data
865     ) internal virtual {
866         _mint(to, tokenId);
867         require(
868             _checkOnERC721Received(address(0), to, tokenId, _data),
869             "ERC721: transfer to non ERC721Receiver implementer"
870         );
871     }
872 
873     /**
874      * @dev Mints `tokenId` and transfers it to `to`.
875      *
876      * WARNING: Usage of this method is discouraged, use {_safeMint} whenever possible
877      *
878      * Requirements:
879      *
880      * - `tokenId` must not exist.
881      * - `to` cannot be the zero address.
882      *
883      * Emits a {Transfer} event.
884      */
885     function _mint(address to, uint256 tokenId) internal virtual {
886         require(to != address(0), "ERC721: mint to the zero address");
887         require(!_exists(tokenId), "ERC721: token already minted");
888 
889         _beforeTokenTransfer(address(0), to, tokenId);
890 
891         _balances[to] += 1;
892         _owners[tokenId] = to;
893 
894         emit Transfer(address(0), to, tokenId);
895     }
896 
897     /**
898      * @dev Destroys `tokenId`.
899      * The approval is cleared when the token is burned.
900      *
901      * Requirements:
902      *
903      * - `tokenId` must exist.
904      *
905      * Emits a {Transfer} event.
906      */
907     function _burn(uint256 tokenId) internal virtual {
908         address owner = ERC721.ownerOf(tokenId);
909 
910         _beforeTokenTransfer(owner, address(0), tokenId);
911 
912         // Clear approvals
913         _approve(address(0), tokenId);
914 
915         _balances[owner] -= 1;
916         delete _owners[tokenId];
917 
918         emit Transfer(owner, address(0), tokenId);
919     }
920 
921     /**
922      * @dev Transfers `tokenId` from `from` to `to`.
923      *  As opposed to {transferFrom}, this imposes no restrictions on msg.sender.
924      *
925      * Requirements:
926      *
927      * - `to` cannot be the zero address.
928      * - `tokenId` token must be owned by `from`.
929      *
930      * Emits a {Transfer} event.
931      */
932     function _transfer(
933         address from,
934         address to,
935         uint256 tokenId
936     ) internal virtual {
937         require(ERC721.ownerOf(tokenId) == from, "ERC721: transfer of token that is not own");
938         require(to != address(0), "ERC721: transfer to the zero address");
939 
940         _beforeTokenTransfer(from, to, tokenId);
941 
942         // Clear approvals from the previous owner
943         _approve(address(0), tokenId);
944 
945         _balances[from] -= 1;
946         _balances[to] += 1;
947         _owners[tokenId] = to;
948 
949         emit Transfer(from, to, tokenId);
950     }
951 
952     /**
953      * @dev Approve `to` to operate on `tokenId`
954      *
955      * Emits a {Approval} event.
956      */
957     function _approve(address to, uint256 tokenId) internal virtual {
958         _tokenApprovals[tokenId] = to;
959         emit Approval(ERC721.ownerOf(tokenId), to, tokenId);
960     }
961 
962     /**
963      * @dev Internal function to invoke {IERC721Receiver-onERC721Received} on a target address.
964      * The call is not executed if the target address is not a contract.
965      *
966      * @param from address representing the previous owner of the given token ID
967      * @param to target address that will receive the tokens
968      * @param tokenId uint256 ID of the token to be transferred
969      * @param _data bytes optional data to send along with the call
970      * @return bool whether the call correctly returned the expected magic value
971      */
972     function _checkOnERC721Received(
973         address from,
974         address to,
975         uint256 tokenId,
976         bytes memory _data
977     ) private returns (bool) {
978         if (to.isContract()) {
979             try IERC721Receiver(to).onERC721Received(_msgSender(), from, tokenId, _data) returns (bytes4 retval) {
980                 return retval == IERC721Receiver.onERC721Received.selector;
981             } catch (bytes memory reason) {
982                 if (reason.length == 0) {
983                     revert("ERC721: transfer to non ERC721Receiver implementer");
984                 } else {
985                     assembly {
986                         revert(add(32, reason), mload(reason))
987                     }
988                 }
989             }
990         } else {
991             return true;
992         }
993     }
994 
995     /**
996      * @dev Hook that is called before any token transfer. This includes minting
997      * and burning.
998      *
999      * Calling conditions:
1000      *
1001      * - When `from` and `to` are both non-zero, ``from``'s `tokenId` will be
1002      * transferred to `to`.
1003      * - When `from` is zero, `tokenId` will be minted for `to`.
1004      * - When `to` is zero, ``from``'s `tokenId` will be burned.
1005      * - `from` and `to` are never both zero.
1006      *
1007      * To learn more about hooks, head to xref:ROOT:extending-contracts.adoc#using-hooks[Using Hooks].
1008      */
1009     function _beforeTokenTransfer(
1010         address from,
1011         address to,
1012         uint256 tokenId
1013     ) internal virtual {}
1014 }
1015 
1016 // File: @openzeppelin/contracts/token/ERC721/extensions/ERC721Enumerable.sol
1017 
1018 
1019 
1020 pragma solidity ^0.8.0;
1021 
1022 
1023 
1024 /**
1025  * @dev This implements an optional extension of {ERC721} defined in the EIP that adds
1026  * enumerability of all the token ids in the contract as well as all token ids owned by each
1027  * account.
1028  */
1029 abstract contract ERC721Enumerable is ERC721, IERC721Enumerable {
1030     // Mapping from owner to list of owned token IDs
1031     mapping(address => mapping(uint256 => uint256)) private _ownedTokens;
1032 
1033     // Mapping from token ID to index of the owner tokens list
1034     mapping(uint256 => uint256) private _ownedTokensIndex;
1035 
1036     // Array with all token ids, used for enumeration
1037     uint256[] private _allTokens;
1038 
1039     // Mapping from token id to position in the allTokens array
1040     mapping(uint256 => uint256) private _allTokensIndex;
1041 
1042     /**
1043      * @dev See {IERC165-supportsInterface}.
1044      */
1045     function supportsInterface(bytes4 interfaceId) public view virtual override(IERC165, ERC721) returns (bool) {
1046         return interfaceId == type(IERC721Enumerable).interfaceId || super.supportsInterface(interfaceId);
1047     }
1048 
1049     /**
1050      * @dev See {IERC721Enumerable-tokenOfOwnerByIndex}.
1051      */
1052     function tokenOfOwnerByIndex(address owner, uint256 index) public view virtual override returns (uint256) {
1053         require(index < ERC721.balanceOf(owner), "ERC721Enumerable: owner index out of bounds");
1054         return _ownedTokens[owner][index];
1055     }
1056 
1057     /**
1058      * @dev See {IERC721Enumerable-totalSupply}.
1059      */
1060     function totalSupply() public view virtual override returns (uint256) {
1061         return _allTokens.length;
1062     }
1063 
1064     /**
1065      * @dev See {IERC721Enumerable-tokenByIndex}.
1066      */
1067     function tokenByIndex(uint256 index) public view virtual override returns (uint256) {
1068         require(index < ERC721Enumerable.totalSupply(), "ERC721Enumerable: global index out of bounds");
1069         return _allTokens[index];
1070     }
1071 
1072     /**
1073      * @dev Hook that is called before any token transfer. This includes minting
1074      * and burning.
1075      *
1076      * Calling conditions:
1077      *
1078      * - When `from` and `to` are both non-zero, ``from``'s `tokenId` will be
1079      * transferred to `to`.
1080      * - When `from` is zero, `tokenId` will be minted for `to`.
1081      * - When `to` is zero, ``from``'s `tokenId` will be burned.
1082      * - `from` cannot be the zero address.
1083      * - `to` cannot be the zero address.
1084      *
1085      * To learn more about hooks, head to xref:ROOT:extending-contracts.adoc#using-hooks[Using Hooks].
1086      */
1087     function _beforeTokenTransfer(
1088         address from,
1089         address to,
1090         uint256 tokenId
1091     ) internal virtual override {
1092         super._beforeTokenTransfer(from, to, tokenId);
1093 
1094         if (from == address(0)) {
1095             _addTokenToAllTokensEnumeration(tokenId);
1096         } else if (from != to) {
1097             _removeTokenFromOwnerEnumeration(from, tokenId);
1098         }
1099         if (to == address(0)) {
1100             _removeTokenFromAllTokensEnumeration(tokenId);
1101         } else if (to != from) {
1102             _addTokenToOwnerEnumeration(to, tokenId);
1103         }
1104     }
1105 
1106     /**
1107      * @dev Private function to add a token to this extension's ownership-tracking data structures.
1108      * @param to address representing the new owner of the given token ID
1109      * @param tokenId uint256 ID of the token to be added to the tokens list of the given address
1110      */
1111     function _addTokenToOwnerEnumeration(address to, uint256 tokenId) private {
1112         uint256 length = ERC721.balanceOf(to);
1113         _ownedTokens[to][length] = tokenId;
1114         _ownedTokensIndex[tokenId] = length;
1115     }
1116 
1117     /**
1118      * @dev Private function to add a token to this extension's token tracking data structures.
1119      * @param tokenId uint256 ID of the token to be added to the tokens list
1120      */
1121     function _addTokenToAllTokensEnumeration(uint256 tokenId) private {
1122         _allTokensIndex[tokenId] = _allTokens.length;
1123         _allTokens.push(tokenId);
1124     }
1125 
1126     /**
1127      * @dev Private function to remove a token from this extension's ownership-tracking data structures. Note that
1128      * while the token is not assigned a new owner, the `_ownedTokensIndex` mapping is _not_ updated: this allows for
1129      * gas optimizations e.g. when performing a transfer operation (avoiding double writes).
1130      * This has O(1) time complexity, but alters the order of the _ownedTokens array.
1131      * @param from address representing the previous owner of the given token ID
1132      * @param tokenId uint256 ID of the token to be removed from the tokens list of the given address
1133      */
1134     function _removeTokenFromOwnerEnumeration(address from, uint256 tokenId) private {
1135         // To prevent a gap in from's tokens array, we store the last token in the index of the token to delete, and
1136         // then delete the last slot (swap and pop).
1137 
1138         uint256 lastTokenIndex = ERC721.balanceOf(from) - 1;
1139         uint256 tokenIndex = _ownedTokensIndex[tokenId];
1140 
1141         // When the token to delete is the last token, the swap operation is unnecessary
1142         if (tokenIndex != lastTokenIndex) {
1143             uint256 lastTokenId = _ownedTokens[from][lastTokenIndex];
1144 
1145             _ownedTokens[from][tokenIndex] = lastTokenId; // Move the last token to the slot of the to-delete token
1146             _ownedTokensIndex[lastTokenId] = tokenIndex; // Update the moved token's index
1147         }
1148 
1149         // This also deletes the contents at the last position of the array
1150         delete _ownedTokensIndex[tokenId];
1151         delete _ownedTokens[from][lastTokenIndex];
1152     }
1153 
1154     /**
1155      * @dev Private function to remove a token from this extension's token tracking data structures.
1156      * This has O(1) time complexity, but alters the order of the _allTokens array.
1157      * @param tokenId uint256 ID of the token to be removed from the tokens list
1158      */
1159     function _removeTokenFromAllTokensEnumeration(uint256 tokenId) private {
1160         // To prevent a gap in the tokens array, we store the last token in the index of the token to delete, and
1161         // then delete the last slot (swap and pop).
1162 
1163         uint256 lastTokenIndex = _allTokens.length - 1;
1164         uint256 tokenIndex = _allTokensIndex[tokenId];
1165 
1166         // When the token to delete is the last token, the swap operation is unnecessary. However, since this occurs so
1167         // rarely (when the last minted token is burnt) that we still do the swap here to avoid the gas cost of adding
1168         // an 'if' statement (like in _removeTokenFromOwnerEnumeration)
1169         uint256 lastTokenId = _allTokens[lastTokenIndex];
1170 
1171         _allTokens[tokenIndex] = lastTokenId; // Move the last token to the slot of the to-delete token
1172         _allTokensIndex[lastTokenId] = tokenIndex; // Update the moved token's index
1173 
1174         // This also deletes the contents at the last position of the array
1175         delete _allTokensIndex[tokenId];
1176         _allTokens.pop();
1177     }
1178 }
1179 
1180 // File: @openzeppelin/contracts/access/Ownable.sol
1181 
1182 
1183 
1184 pragma solidity ^0.8.0;
1185 
1186 
1187 /**
1188  * @dev Contract module which provides a basic access control mechanism, where
1189  * there is an account (an owner) that can be granted exclusive access to
1190  * specific functions.
1191  *
1192  * By default, the owner account will be the one that deploys the contract. This
1193  * can later be changed with {transferOwnership}.
1194  *
1195  * This module is used through inheritance. It will make available the modifier
1196  * `onlyOwner`, which can be applied to your functions to restrict their use to
1197  * the owner.
1198  */
1199 abstract contract Ownable is Context {
1200     address private _owner;
1201 
1202     event OwnershipTransferred(address indexed previousOwner, address indexed newOwner);
1203 
1204     /**
1205      * @dev Initializes the contract setting the deployer as the initial owner.
1206      */
1207     constructor() {
1208         _setOwner(_msgSender());
1209     }
1210 
1211     /**
1212      * @dev Returns the address of the current owner.
1213      */
1214     function owner() public view virtual returns (address) {
1215         return _owner;
1216     }
1217 
1218     /**
1219      * @dev Throws if called by any account other than the owner.
1220      */
1221     modifier onlyOwner() {
1222         require(owner() == _msgSender(), "Ownable: caller is not the owner");
1223         _;
1224     }
1225 
1226     /**
1227      * @dev Leaves the contract without owner. It will not be possible to call
1228      * `onlyOwner` functions anymore. Can only be called by the current owner.
1229      *
1230      * NOTE: Renouncing ownership will leave the contract without an owner,
1231      * thereby removing any functionality that is only available to the owner.
1232      */
1233     function renounceOwnership() public virtual onlyOwner {
1234         _setOwner(address(0));
1235     }
1236 
1237     /**
1238      * @dev Transfers ownership of the contract to a new account (`newOwner`).
1239      * Can only be called by the current owner.
1240      */
1241     function transferOwnership(address newOwner) public virtual onlyOwner {
1242         require(newOwner != address(0), "Ownable: new owner is the zero address");
1243         _setOwner(newOwner);
1244     }
1245 
1246     function _setOwner(address newOwner) private {
1247         address oldOwner = _owner;
1248         _owner = newOwner;
1249         emit OwnershipTransferred(oldOwner, newOwner);
1250     }
1251 }
1252 
1253 // File: contract.sol
1254 
1255 // Made with love (and lots of sweets)
1256 
1257 pragma solidity ^0.8.7;
1258 /**
1259  * @dev Modifier 'onlyOwner' becomes available, where owner is the contract deployer
1260  */
1261 
1262 /**
1263  * @dev ERC721 token standard
1264  */
1265 
1266 
1267 contract Sherbet is Ownable, ERC721Enumerable { 
1268     uint256 public maxSupply = 7777;
1269     uint256 public maxPreSaleMintTotal = 6000;
1270     uint256 public cost = 0.077 ether; 
1271     
1272     uint256 private preSaleMints;
1273     string public baseTokenURI;
1274     
1275     bool public preSaleStatus = false;
1276     bool public publicSaleStatus = false;
1277     
1278     constructor(
1279         string memory _name,
1280         string memory _symbol,  
1281         string memory _uri
1282         
1283     ) ERC721(_name, _symbol) {
1284         baseTokenURI = _uri;
1285     }
1286     
1287     // --- EVENTS ---
1288     event TokenMinted(uint256 tokenId);
1289     
1290     // --- MAPPINGS ---
1291     mapping(address => uint) whitelist;
1292         
1293     // --- PUBLIC ---
1294     /**
1295      * @dev Mint tokens through pre or public sale
1296      * @param _number - number of tokens to mint
1297      */
1298     function mint(
1299         uint256 _number
1300     ) external payable {
1301         
1302         require(
1303             msg.value == _number * cost, // mint cost
1304             "Incorrect funds supplied"
1305         );
1306         require(
1307             totalSupply() + _number <= maxSupply, "All tokens have been minted"
1308         );
1309         
1310         if (publicSaleStatus == true) {
1311             require(
1312                 _number > 0 && _number <= 4, // mint limit per tx
1313                 "Maximum of 4 mints allowed per transaction"
1314             );
1315         } else {
1316             require(
1317                 preSaleStatus, // checks pre sale is live
1318                 "It's not time to mint yet"
1319             ); 
1320             require(
1321                 _number > 0 && _number <=2, 
1322                 "Maximum of 2 mints allowed per wallet"
1323             );
1324             require(
1325                 whitelist[msg.sender] >= _number, // checks if white listed & mint limit per address is obeyed
1326                 "Address is not on whitelist or maximum of 2 mints per address has been reached"
1327             ); 
1328             require(
1329                 preSaleMints + _number <= maxPreSaleMintTotal, // ensures pre sale total mint limit is obeyed
1330                 "Minting that many would exceed the pre sale minting allocation"
1331             ); 
1332             whitelist[msg.sender] -= _number; // reduces caller's minting allownace by the number of tokens they minted
1333             preSaleMints += _number; 
1334         }
1335         
1336         for (uint256 i = 0; i < _number; i++) {
1337             uint tokenId = totalSupply() + 1;
1338             _mint(msg.sender, tokenId);
1339             emit TokenMinted(tokenId);
1340         }
1341     }
1342     
1343     // --- VIEW ---
1344     /**
1345      * @dev Returns tokenURI, which is comprised of the baseURI concatenated with the tokenId
1346      */
1347     function tokenURI(uint256 _tokenId) public view override returns(string memory) {
1348         require(
1349             _exists(_tokenId),
1350             "ERC721Metadata: URI query for nonexistent token"
1351         );
1352         return string(abi.encodePacked(baseTokenURI, Strings.toString(_tokenId)));
1353     }
1354     /**
1355      * @dev Returns uint of how many tokens can be minted currently. Depends on status of pre and public sale
1356      */
1357     function maxMintable() public view returns(uint) {
1358         if (preSaleStatus == false) {
1359             if (publicSaleStatus == true) {
1360                 return 4; // public sale
1361             }
1362             return 0; // both false
1363         }
1364         return 2; // pre sale
1365     }
1366     
1367     // --- ONLY OWNER ---
1368     /**
1369      * @dev Withdraw all ether from smart contract. Only contract owner can call.
1370      * @param _to - address ether will be sent to
1371      */
1372     function withdrawAllFunds(
1373         address payable _to
1374     ) external onlyOwner {
1375         require(
1376             address(this).balance > 0, 
1377             "No funds to withdraw"
1378         );
1379         _to.transfer(address(this).balance);
1380     }
1381     
1382     /**
1383      * @dev Add addresses to white list, giving access to mint 2 tokens at pre sale
1384      * @param _addresses - array of address' to add to white list mapping
1385      */
1386     function whitelistAddresses(
1387         address[] calldata _addresses
1388     ) external onlyOwner {
1389         for (uint i=0; i<_addresses.length; i++) {
1390             whitelist[_addresses[i]] = 2;
1391         }
1392     }
1393     
1394     /**
1395      * @dev Airdrop 1 token to each address in array '_to'
1396      * @param _to - array of address' that tokens will be sent to
1397      */
1398     function airDrop(
1399         address[] calldata _to
1400     ) external onlyOwner {
1401         for (uint i=0; i<_to.length; i++) {
1402             uint tokenId = totalSupply() + 1;
1403             require(tokenId <= maxSupply, "All tokens have been minted");
1404             _mint(_to[i], tokenId);
1405             emit TokenMinted(tokenId);
1406         }
1407         
1408     }
1409     /**
1410      * @dev Set the baseURI string
1411      */
1412     function setBaseUri(
1413         string memory _newBaseUri
1414     ) external onlyOwner {
1415         baseTokenURI = _newBaseUri;
1416     }
1417     
1418     /**
1419      * @dev Set the cost of minting a token
1420      * @param _newCost in Wei. Where 1 Wei = 10^-18 ether
1421      */
1422     function setCost(
1423         uint _newCost
1424     ) external onlyOwner {
1425         cost = _newCost;
1426     }
1427     
1428     /**
1429      * @dev Set the status of the pre sale, sets publicSaleStatus to false
1430      * @param _status boolean where true = live 
1431      */
1432     function setPreSaleStatus(
1433         bool _status
1434     ) external onlyOwner {
1435         if (publicSaleStatus) {
1436             publicSaleStatus = false;
1437         }
1438         preSaleStatus = _status;
1439     }
1440     
1441     /**
1442      * @dev Set the status of the public sale, sets preSaleStatus to false
1443      * @param _status boolean where true = live 
1444      */
1445     function setPublicSaleStatus(
1446         bool _status
1447     ) external onlyOwner {
1448         if (preSaleStatus) {
1449             preSaleStatus = false;
1450         }
1451         publicSaleStatus = _status;
1452     }
1453     
1454 }