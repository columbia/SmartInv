1 // SPDX-License-Identifier: MIT
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
27 
28 
29 /*
30  * @dev Provides information about the current execution context, including the
31  * sender of the transaction and its data. While these are generally available
32  * via msg.sender and msg.data, they should not be accessed in such a direct
33  * manner, since when dealing with meta-transactions the account sending and
34  * paying for execution may not be the actual sender (as far as an application
35  * is concerned).
36  *
37  * This contract is only required for intermediate, library-like contracts.
38  */
39 abstract contract Context {
40     function _msgSender() internal view virtual returns (address) {
41         return msg.sender;
42     }
43 
44     function _msgData() internal view virtual returns (bytes calldata) {
45         return msg.data;
46     }
47 }
48 
49 
50 
51 
52 /**
53  * @dev String operations.
54  */
55 library Strings {
56     bytes16 private constant _HEX_SYMBOLS = "0123456789abcdef";
57 
58     /**
59      * @dev Converts a `uint256` to its ASCII `string` decimal representation.
60      */
61     function toString(uint256 value) internal pure returns (string memory) {
62         // Inspired by OraclizeAPI's implementation - MIT licence
63         // https://github.com/oraclize/ethereum-api/blob/b42146b063c7d6ee1358846c198246239e9360e8/oraclizeAPI_0.4.25.sol
64 
65         if (value == 0) {
66             return "0";
67         }
68         uint256 temp = value;
69         uint256 digits;
70         while (temp != 0) {
71             digits++;
72             temp /= 10;
73         }
74         bytes memory buffer = new bytes(digits);
75         while (value != 0) {
76             digits -= 1;
77             buffer[digits] = bytes1(uint8(48 + uint256(value % 10)));
78             value /= 10;
79         }
80         return string(buffer);
81     }
82 
83     /**
84      * @dev Converts a `uint256` to its ASCII `string` hexadecimal representation.
85      */
86     function toHexString(uint256 value) internal pure returns (string memory) {
87         if (value == 0) {
88             return "0x00";
89         }
90         uint256 temp = value;
91         uint256 length = 0;
92         while (temp != 0) {
93             length++;
94             temp >>= 8;
95         }
96         return toHexString(value, length);
97     }
98 
99     /**
100      * @dev Converts a `uint256` to its ASCII `string` hexadecimal representation with fixed length.
101      */
102     function toHexString(uint256 value, uint256 length) internal pure returns (string memory) {
103         bytes memory buffer = new bytes(2 * length + 2);
104         buffer[0] = "0";
105         buffer[1] = "x";
106         for (uint256 i = 2 * length + 1; i > 1; --i) {
107             buffer[i] = _HEX_SYMBOLS[value & 0xf];
108             value >>= 4;
109         }
110         require(value == 0, "Strings: hex length insufficient");
111         return string(buffer);
112     }
113 }
114 
115 
116 
117 
118 
119 
120 
121 
122 
123 
124 
125 
126 
127 /**
128  * @dev Required interface of an ERC721 compliant contract.
129  */
130 interface IERC721 is IERC165 {
131     /**
132      * @dev Emitted when `tokenId` token is transferred from `from` to `to`.
133      */
134     event Transfer(address indexed from, address indexed to, uint256 indexed tokenId);
135 
136     /**
137      * @dev Emitted when `owner` enables `approved` to manage the `tokenId` token.
138      */
139     event Approval(address indexed owner, address indexed approved, uint256 indexed tokenId);
140 
141     /**
142      * @dev Emitted when `owner` enables or disables (`approved`) `operator` to manage all of its assets.
143      */
144     event ApprovalForAll(address indexed owner, address indexed operator, bool approved);
145 
146     /**
147      * @dev Returns the number of tokens in ``owner``'s account.
148      */
149     function balanceOf(address owner) external view returns (uint256 balance);
150 
151     /**
152      * @dev Returns the owner of the `tokenId` token.
153      *
154      * Requirements:
155      *
156      * - `tokenId` must exist.
157      */
158     function ownerOf(uint256 tokenId) external view returns (address owner);
159 
160     /**
161      * @dev Safely transfers `tokenId` token from `from` to `to`, checking first that contract recipients
162      * are aware of the ERC721 protocol to prevent tokens from being forever locked.
163      *
164      * Requirements:
165      *
166      * - `from` cannot be the zero address.
167      * - `to` cannot be the zero address.
168      * - `tokenId` token must exist and be owned by `from`.
169      * - If the caller is not `from`, it must be have been allowed to move this token by either {approve} or {setApprovalForAll}.
170      * - If `to` refers to a smart contract, it must implement {IERC721Receiver-onERC721Received}, which is called upon a safe transfer.
171      *
172      * Emits a {Transfer} event.
173      */
174     function safeTransferFrom(
175         address from,
176         address to,
177         uint256 tokenId
178     ) external;
179 
180     /**
181      * @dev Transfers `tokenId` token from `from` to `to`.
182      *
183      * WARNING: Usage of this method is discouraged, use {safeTransferFrom} whenever possible.
184      *
185      * Requirements:
186      *
187      * - `from` cannot be the zero address.
188      * - `to` cannot be the zero address.
189      * - `tokenId` token must be owned by `from`.
190      * - If the caller is not `from`, it must be approved to move this token by either {approve} or {setApprovalForAll}.
191      *
192      * Emits a {Transfer} event.
193      */
194     function transferFrom(
195         address from,
196         address to,
197         uint256 tokenId
198     ) external;
199 
200     /**
201      * @dev Gives permission to `to` to transfer `tokenId` token to another account.
202      * The approval is cleared when the token is transferred.
203      *
204      * Only a single account can be approved at a time, so approving the zero address clears previous approvals.
205      *
206      * Requirements:
207      *
208      * - The caller must own the token or be an approved operator.
209      * - `tokenId` must exist.
210      *
211      * Emits an {Approval} event.
212      */
213     function approve(address to, uint256 tokenId) external;
214 
215     /**
216      * @dev Returns the account approved for `tokenId` token.
217      *
218      * Requirements:
219      *
220      * - `tokenId` must exist.
221      */
222     function getApproved(uint256 tokenId) external view returns (address operator);
223 
224     /**
225      * @dev Approve or remove `operator` as an operator for the caller.
226      * Operators can call {transferFrom} or {safeTransferFrom} for any token owned by the caller.
227      *
228      * Requirements:
229      *
230      * - The `operator` cannot be the caller.
231      *
232      * Emits an {ApprovalForAll} event.
233      */
234     function setApprovalForAll(address operator, bool _approved) external;
235 
236     /**
237      * @dev Returns if the `operator` is allowed to manage all of the assets of `owner`.
238      *
239      * See {setApprovalForAll}
240      */
241     function isApprovedForAll(address owner, address operator) external view returns (bool);
242 
243     /**
244      * @dev Safely transfers `tokenId` token from `from` to `to`.
245      *
246      * Requirements:
247      *
248      * - `from` cannot be the zero address.
249      * - `to` cannot be the zero address.
250      * - `tokenId` token must exist and be owned by `from`.
251      * - If the caller is not `from`, it must be approved to move this token by either {approve} or {setApprovalForAll}.
252      * - If `to` refers to a smart contract, it must implement {IERC721Receiver-onERC721Received}, which is called upon a safe transfer.
253      *
254      * Emits a {Transfer} event.
255      */
256     function safeTransferFrom(
257         address from,
258         address to,
259         uint256 tokenId,
260         bytes calldata data
261     ) external;
262 }
263 
264 
265 
266 
267 
268 /**
269  * @title ERC721 token receiver interface
270  * @dev Interface for any contract that wants to support safeTransfers
271  * from ERC721 asset contracts.
272  */
273 interface IERC721Receiver {
274     /**
275      * @dev Whenever an {IERC721} `tokenId` token is transferred to this contract via {IERC721-safeTransferFrom}
276      * by `operator` from `from`, this function is called.
277      *
278      * It must return its Solidity selector to confirm the token transfer.
279      * If any other value is returned or the interface is not implemented by the recipient, the transfer will be reverted.
280      *
281      * The selector can be obtained in Solidity with `IERC721.onERC721Received.selector`.
282      */
283     function onERC721Received(
284         address operator,
285         address from,
286         uint256 tokenId,
287         bytes calldata data
288     ) external returns (bytes4);
289 }
290 
291 
292 
293 
294 
295 
296 
297 /**
298  * @title ERC-721 Non-Fungible Token Standard, optional metadata extension
299  * @dev See https://eips.ethereum.org/EIPS/eip-721
300  */
301 interface IERC721Metadata is IERC721 {
302     /**
303      * @dev Returns the token collection name.
304      */
305     function name() external view returns (string memory);
306 
307     /**
308      * @dev Returns the token collection symbol.
309      */
310     function symbol() external view returns (string memory);
311 
312     /**
313      * @dev Returns the Uniform Resource Identifier (URI) for `tokenId` token.
314      */
315     function tokenURI(uint256 tokenId) external view returns (string memory);
316 }
317 
318 
319 
320 
321 
322 /**
323  * @dev Collection of functions related to the address type
324  */
325 library Address {
326     /**
327      * @dev Returns true if `account` is a contract.
328      *
329      * [IMPORTANT]
330      * ====
331      * It is unsafe to assume that an address for which this function returns
332      * false is an externally-owned account (EOA) and not a contract.
333      *
334      * Among others, `isContract` will return false for the following
335      * types of addresses:
336      *
337      *  - an externally-owned account
338      *  - a contract in construction
339      *  - an address where a contract will be created
340      *  - an address where a contract lived, but was destroyed
341      * ====
342      */
343     function isContract(address account) internal view returns (bool) {
344         // This method relies on extcodesize, which returns 0 for contracts in
345         // construction, since the code is only stored at the end of the
346         // constructor execution.
347 
348         uint256 size;
349         assembly {
350             size := extcodesize(account)
351         }
352         return size > 0;
353     }
354 
355     /**
356      * @dev Replacement for Solidity's `transfer`: sends `amount` wei to
357      * `recipient`, forwarding all available gas and reverting on errors.
358      *
359      * https://eips.ethereum.org/EIPS/eip-1884[EIP1884] increases the gas cost
360      * of certain opcodes, possibly making contracts go over the 2300 gas limit
361      * imposed by `transfer`, making them unable to receive funds via
362      * `transfer`. {sendValue} removes this limitation.
363      *
364      * https://diligence.consensys.net/posts/2019/09/stop-using-soliditys-transfer-now/[Learn more].
365      *
366      * IMPORTANT: because control is transferred to `recipient`, care must be
367      * taken to not create reentrancy vulnerabilities. Consider using
368      * {ReentrancyGuard} or the
369      * https://solidity.readthedocs.io/en/v0.5.11/security-considerations.html#use-the-checks-effects-interactions-pattern[checks-effects-interactions pattern].
370      */
371     function sendValue(address payable recipient, uint256 amount) internal {
372         require(address(this).balance >= amount, "Address: insufficient balance");
373 
374         (bool success, ) = recipient.call{value: amount}("");
375         require(success, "Address: unable to send value, recipient may have reverted");
376     }
377 
378     /**
379      * @dev Performs a Solidity function call using a low level `call`. A
380      * plain `call` is an unsafe replacement for a function call: use this
381      * function instead.
382      *
383      * If `target` reverts with a revert reason, it is bubbled up by this
384      * function (like regular Solidity function calls).
385      *
386      * Returns the raw returned data. To convert to the expected return value,
387      * use https://solidity.readthedocs.io/en/latest/units-and-global-variables.html?highlight=abi.decode#abi-encoding-and-decoding-functions[`abi.decode`].
388      *
389      * Requirements:
390      *
391      * - `target` must be a contract.
392      * - calling `target` with `data` must not revert.
393      *
394      * _Available since v3.1._
395      */
396     function functionCall(address target, bytes memory data) internal returns (bytes memory) {
397         return functionCall(target, data, "Address: low-level call failed");
398     }
399 
400     /**
401      * @dev Same as {xref-Address-functionCall-address-bytes-}[`functionCall`], but with
402      * `errorMessage` as a fallback revert reason when `target` reverts.
403      *
404      * _Available since v3.1._
405      */
406     function functionCall(
407         address target,
408         bytes memory data,
409         string memory errorMessage
410     ) internal returns (bytes memory) {
411         return functionCallWithValue(target, data, 0, errorMessage);
412     }
413 
414     /**
415      * @dev Same as {xref-Address-functionCall-address-bytes-}[`functionCall`],
416      * but also transferring `value` wei to `target`.
417      *
418      * Requirements:
419      *
420      * - the calling contract must have an ETH balance of at least `value`.
421      * - the called Solidity function must be `payable`.
422      *
423      * _Available since v3.1._
424      */
425     function functionCallWithValue(
426         address target,
427         bytes memory data,
428         uint256 value
429     ) internal returns (bytes memory) {
430         return functionCallWithValue(target, data, value, "Address: low-level call with value failed");
431     }
432 
433     /**
434      * @dev Same as {xref-Address-functionCallWithValue-address-bytes-uint256-}[`functionCallWithValue`], but
435      * with `errorMessage` as a fallback revert reason when `target` reverts.
436      *
437      * _Available since v3.1._
438      */
439     function functionCallWithValue(
440         address target,
441         bytes memory data,
442         uint256 value,
443         string memory errorMessage
444     ) internal returns (bytes memory) {
445         require(address(this).balance >= value, "Address: insufficient balance for call");
446         require(isContract(target), "Address: call to non-contract");
447 
448         (bool success, bytes memory returndata) = target.call{value: value}(data);
449         return _verifyCallResult(success, returndata, errorMessage);
450     }
451 
452     /**
453      * @dev Same as {xref-Address-functionCall-address-bytes-}[`functionCall`],
454      * but performing a static call.
455      *
456      * _Available since v3.3._
457      */
458     function functionStaticCall(address target, bytes memory data) internal view returns (bytes memory) {
459         return functionStaticCall(target, data, "Address: low-level static call failed");
460     }
461 
462     /**
463      * @dev Same as {xref-Address-functionCall-address-bytes-string-}[`functionCall`],
464      * but performing a static call.
465      *
466      * _Available since v3.3._
467      */
468     function functionStaticCall(
469         address target,
470         bytes memory data,
471         string memory errorMessage
472     ) internal view returns (bytes memory) {
473         require(isContract(target), "Address: static call to non-contract");
474 
475         (bool success, bytes memory returndata) = target.staticcall(data);
476         return _verifyCallResult(success, returndata, errorMessage);
477     }
478 
479     /**
480      * @dev Same as {xref-Address-functionCall-address-bytes-}[`functionCall`],
481      * but performing a delegate call.
482      *
483      * _Available since v3.4._
484      */
485     function functionDelegateCall(address target, bytes memory data) internal returns (bytes memory) {
486         return functionDelegateCall(target, data, "Address: low-level delegate call failed");
487     }
488 
489     /**
490      * @dev Same as {xref-Address-functionCall-address-bytes-string-}[`functionCall`],
491      * but performing a delegate call.
492      *
493      * _Available since v3.4._
494      */
495     function functionDelegateCall(
496         address target,
497         bytes memory data,
498         string memory errorMessage
499     ) internal returns (bytes memory) {
500         require(isContract(target), "Address: delegate call to non-contract");
501 
502         (bool success, bytes memory returndata) = target.delegatecall(data);
503         return _verifyCallResult(success, returndata, errorMessage);
504     }
505 
506     function _verifyCallResult(
507         bool success,
508         bytes memory returndata,
509         string memory errorMessage
510     ) private pure returns (bytes memory) {
511         if (success) {
512             return returndata;
513         } else {
514             // Look for revert reason and bubble it up if present
515             if (returndata.length > 0) {
516                 // The easiest way to bubble the revert reason is using memory via assembly
517 
518                 assembly {
519                     let returndata_size := mload(returndata)
520                     revert(add(32, returndata), returndata_size)
521                 }
522             } else {
523                 revert(errorMessage);
524             }
525         }
526     }
527 }
528 
529 
530 
531 
532 
533 
534 
535 
536 
537 /**
538  * @dev Implementation of the {IERC165} interface.
539  *
540  * Contracts that want to implement ERC165 should inherit from this contract and override {supportsInterface} to check
541  * for the additional interface id that will be supported. For example:
542  *
543  * ```solidity
544  * function supportsInterface(bytes4 interfaceId) public view virtual override returns (bool) {
545  *     return interfaceId == type(MyInterface).interfaceId || super.supportsInterface(interfaceId);
546  * }
547  * ```
548  *
549  * Alternatively, {ERC165Storage} provides an easier to use but more expensive implementation.
550  */
551 abstract contract ERC165 is IERC165 {
552     /**
553      * @dev See {IERC165-supportsInterface}.
554      */
555     function supportsInterface(bytes4 interfaceId) public view virtual override returns (bool) {
556         return interfaceId == type(IERC165).interfaceId;
557     }
558 }
559 
560 
561 /**
562  * @dev Implementation of https://eips.ethereum.org/EIPS/eip-721[ERC721] Non-Fungible Token Standard, including
563  * the Metadata extension, but not including the Enumerable extension, which is available separately as
564  * {ERC721Enumerable}.
565  */
566 contract ERC721 is Context, ERC165, IERC721, IERC721Metadata {
567     using Address for address;
568     using Strings for uint256;
569 
570     // Token name
571     string private _name;
572 
573     // Token symbol
574     string private _symbol;
575 
576     // Mapping from token ID to owner address
577     mapping(uint256 => address) private _owners;
578 
579     // Mapping owner address to token count
580     mapping(address => uint256) private _balances;
581 
582     // Mapping from token ID to approved address
583     mapping(uint256 => address) private _tokenApprovals;
584 
585     // Mapping from owner to operator approvals
586     mapping(address => mapping(address => bool)) private _operatorApprovals;
587 
588     /**
589      * @dev Initializes the contract by setting a `name` and a `symbol` to the token collection.
590      */
591     constructor(string memory name_, string memory symbol_) {
592         _name = name_;
593         _symbol = symbol_;
594     }
595 
596     /**
597      * @dev See {IERC165-supportsInterface}.
598      */
599     function supportsInterface(bytes4 interfaceId) public view virtual override(ERC165, IERC165) returns (bool) {
600         return
601             interfaceId == type(IERC721).interfaceId ||
602             interfaceId == type(IERC721Metadata).interfaceId ||
603             super.supportsInterface(interfaceId);
604     }
605 
606     /**
607      * @dev See {IERC721-balanceOf}.
608      */
609     function balanceOf(address owner) public view virtual override returns (uint256) {
610         require(owner != address(0), "ERC721: balance query for the zero address");
611         return _balances[owner];
612     }
613 
614     /**
615      * @dev See {IERC721-ownerOf}.
616      */
617     function ownerOf(uint256 tokenId) public view virtual override returns (address) {
618         address owner = _owners[tokenId];
619         require(owner != address(0), "ERC721: owner query for nonexistent token");
620         return owner;
621     }
622 
623     /**
624      * @dev See {IERC721Metadata-name}.
625      */
626     function name() public view virtual override returns (string memory) {
627         return _name;
628     }
629 
630     /**
631      * @dev See {IERC721Metadata-symbol}.
632      */
633     function symbol() public view virtual override returns (string memory) {
634         return _symbol;
635     }
636 
637     /**
638      * @dev See {IERC721Metadata-tokenURI}.
639      */
640     function tokenURI(uint256 tokenId) public view virtual override returns (string memory) {
641         require(_exists(tokenId), "ERC721Metadata: URI query for nonexistent token");
642 
643         string memory baseURI = _baseURI();
644         return bytes(baseURI).length > 0 ? string(abi.encodePacked(baseURI, tokenId.toString())) : "";
645     }
646 
647     /**
648      * @dev Base URI for computing {tokenURI}. If set, the resulting URI for each
649      * token will be the concatenation of the `baseURI` and the `tokenId`. Empty
650      * by default, can be overriden in child contracts.
651      */
652     function _baseURI() internal view virtual returns (string memory) {
653         return "";
654     }
655 
656     /**
657      * @dev See {IERC721-approve}.
658      */
659     function approve(address to, uint256 tokenId) public virtual override {
660         address owner = ERC721.ownerOf(tokenId);
661         require(to != owner, "ERC721: approval to current owner");
662 
663         require(
664             _msgSender() == owner || isApprovedForAll(owner, _msgSender()),
665             "ERC721: approve caller is not owner nor approved for all"
666         );
667 
668         _approve(to, tokenId);
669     }
670 
671     /**
672      * @dev See {IERC721-getApproved}.
673      */
674     function getApproved(uint256 tokenId) public view virtual override returns (address) {
675         require(_exists(tokenId), "ERC721: approved query for nonexistent token");
676 
677         return _tokenApprovals[tokenId];
678     }
679 
680     /**
681      * @dev See {IERC721-setApprovalForAll}.
682      */
683     function setApprovalForAll(address operator, bool approved) public virtual override {
684         require(operator != _msgSender(), "ERC721: approve to caller");
685 
686         _operatorApprovals[_msgSender()][operator] = approved;
687         emit ApprovalForAll(_msgSender(), operator, approved);
688     }
689 
690     /**
691      * @dev See {IERC721-isApprovedForAll}.
692      */
693     function isApprovedForAll(address owner, address operator) public view virtual override returns (bool) {
694         return _operatorApprovals[owner][operator];
695     }
696 
697     /**
698      * @dev See {IERC721-transferFrom}.
699      */
700     function transferFrom(
701         address from,
702         address to,
703         uint256 tokenId
704     ) public virtual override {
705         //solhint-disable-next-line max-line-length
706         require(_isApprovedOrOwner(_msgSender(), tokenId), "ERC721: transfer caller is not owner nor approved");
707 
708         _transfer(from, to, tokenId);
709     }
710 
711     /**
712      * @dev See {IERC721-safeTransferFrom}.
713      */
714     function safeTransferFrom(
715         address from,
716         address to,
717         uint256 tokenId
718     ) public virtual override {
719         safeTransferFrom(from, to, tokenId, "");
720     }
721 
722     /**
723      * @dev See {IERC721-safeTransferFrom}.
724      */
725     function safeTransferFrom(
726         address from,
727         address to,
728         uint256 tokenId,
729         bytes memory _data
730     ) public virtual override {
731         require(_isApprovedOrOwner(_msgSender(), tokenId), "ERC721: transfer caller is not owner nor approved");
732         _safeTransfer(from, to, tokenId, _data);
733     }
734 
735     /**
736      * @dev Safely transfers `tokenId` token from `from` to `to`, checking first that contract recipients
737      * are aware of the ERC721 protocol to prevent tokens from being forever locked.
738      *
739      * `_data` is additional data, it has no specified format and it is sent in call to `to`.
740      *
741      * This internal function is equivalent to {safeTransferFrom}, and can be used to e.g.
742      * implement alternative mechanisms to perform token transfer, such as signature-based.
743      *
744      * Requirements:
745      *
746      * - `from` cannot be the zero address.
747      * - `to` cannot be the zero address.
748      * - `tokenId` token must exist and be owned by `from`.
749      * - If `to` refers to a smart contract, it must implement {IERC721Receiver-onERC721Received}, which is called upon a safe transfer.
750      *
751      * Emits a {Transfer} event.
752      */
753     function _safeTransfer(
754         address from,
755         address to,
756         uint256 tokenId,
757         bytes memory _data
758     ) internal virtual {
759         _transfer(from, to, tokenId);
760         require(_checkOnERC721Received(from, to, tokenId, _data), "ERC721: transfer to non ERC721Receiver implementer");
761     }
762 
763     /**
764      * @dev Returns whether `tokenId` exists.
765      *
766      * Tokens can be managed by their owner or approved accounts via {approve} or {setApprovalForAll}.
767      *
768      * Tokens start existing when they are minted (`_mint`),
769      * and stop existing when they are burned (`_burn`).
770      */
771     function _exists(uint256 tokenId) internal view virtual returns (bool) {
772         return _owners[tokenId] != address(0);
773     }
774 
775     /**
776      * @dev Returns whether `spender` is allowed to manage `tokenId`.
777      *
778      * Requirements:
779      *
780      * - `tokenId` must exist.
781      */
782     function _isApprovedOrOwner(address spender, uint256 tokenId) internal view virtual returns (bool) {
783         require(_exists(tokenId), "ERC721: operator query for nonexistent token");
784         address owner = ERC721.ownerOf(tokenId);
785         return (spender == owner || getApproved(tokenId) == spender || isApprovedForAll(owner, spender));
786     }
787 
788     /**
789      * @dev Safely mints `tokenId` and transfers it to `to`.
790      *
791      * Requirements:
792      *
793      * - `tokenId` must not exist.
794      * - If `to` refers to a smart contract, it must implement {IERC721Receiver-onERC721Received}, which is called upon a safe transfer.
795      *
796      * Emits a {Transfer} event.
797      */
798     function _safeMint(address to, uint256 tokenId) internal virtual {
799         _safeMint(to, tokenId, "");
800     }
801 
802     /**
803      * @dev Same as {xref-ERC721-_safeMint-address-uint256-}[`_safeMint`], with an additional `data` parameter which is
804      * forwarded in {IERC721Receiver-onERC721Received} to contract recipients.
805      */
806     function _safeMint(
807         address to,
808         uint256 tokenId,
809         bytes memory _data
810     ) internal virtual {
811         _mint(to, tokenId);
812         require(
813             _checkOnERC721Received(address(0), to, tokenId, _data),
814             "ERC721: transfer to non ERC721Receiver implementer"
815         );
816     }
817 
818     /**
819      * @dev Mints `tokenId` and transfers it to `to`.
820      *
821      * WARNING: Usage of this method is discouraged, use {_safeMint} whenever possible
822      *
823      * Requirements:
824      *
825      * - `tokenId` must not exist.
826      * - `to` cannot be the zero address.
827      *
828      * Emits a {Transfer} event.
829      */
830     function _mint(address to, uint256 tokenId) internal virtual {
831         require(to != address(0), "ERC721: mint to the zero address");
832         require(!_exists(tokenId), "ERC721: token already minted");
833 
834         _beforeTokenTransfer(address(0), to, tokenId);
835 
836         _balances[to] += 1;
837         _owners[tokenId] = to;
838 
839         emit Transfer(address(0), to, tokenId);
840     }
841 
842     /**
843      * @dev Destroys `tokenId`.
844      * The approval is cleared when the token is burned.
845      *
846      * Requirements:
847      *
848      * - `tokenId` must exist.
849      *
850      * Emits a {Transfer} event.
851      */
852     function _burn(uint256 tokenId) internal virtual {
853         address owner = ERC721.ownerOf(tokenId);
854 
855         _beforeTokenTransfer(owner, address(0), tokenId);
856 
857         // Clear approvals
858         _approve(address(0), tokenId);
859 
860         _balances[owner] -= 1;
861         delete _owners[tokenId];
862 
863         emit Transfer(owner, address(0), tokenId);
864     }
865 
866     /**
867      * @dev Transfers `tokenId` from `from` to `to`.
868      *  As opposed to {transferFrom}, this imposes no restrictions on msg.sender.
869      *
870      * Requirements:
871      *
872      * - `to` cannot be the zero address.
873      * - `tokenId` token must be owned by `from`.
874      *
875      * Emits a {Transfer} event.
876      */
877     function _transfer(
878         address from,
879         address to,
880         uint256 tokenId
881     ) internal virtual {
882         require(ERC721.ownerOf(tokenId) == from, "ERC721: transfer of token that is not own");
883         require(to != address(0), "ERC721: transfer to the zero address");
884 
885         _beforeTokenTransfer(from, to, tokenId);
886 
887         // Clear approvals from the previous owner
888         _approve(address(0), tokenId);
889 
890         _balances[from] -= 1;
891         _balances[to] += 1;
892         _owners[tokenId] = to;
893 
894         emit Transfer(from, to, tokenId);
895     }
896 
897     /**
898      * @dev Approve `to` to operate on `tokenId`
899      *
900      * Emits a {Approval} event.
901      */
902     function _approve(address to, uint256 tokenId) internal virtual {
903         _tokenApprovals[tokenId] = to;
904         emit Approval(ERC721.ownerOf(tokenId), to, tokenId);
905     }
906 
907     /**
908      * @dev Internal function to invoke {IERC721Receiver-onERC721Received} on a target address.
909      * The call is not executed if the target address is not a contract.
910      *
911      * @param from address representing the previous owner of the given token ID
912      * @param to target address that will receive the tokens
913      * @param tokenId uint256 ID of the token to be transferred
914      * @param _data bytes optional data to send along with the call
915      * @return bool whether the call correctly returned the expected magic value
916      */
917     function _checkOnERC721Received(
918         address from,
919         address to,
920         uint256 tokenId,
921         bytes memory _data
922     ) private returns (bool) {
923         if (to.isContract()) {
924             try IERC721Receiver(to).onERC721Received(_msgSender(), from, tokenId, _data) returns (bytes4 retval) {
925                 return retval == IERC721Receiver(to).onERC721Received.selector;
926             } catch (bytes memory reason) {
927                 if (reason.length == 0) {
928                     revert("ERC721: transfer to non ERC721Receiver implementer");
929                 } else {
930                     assembly {
931                         revert(add(32, reason), mload(reason))
932                     }
933                 }
934             }
935         } else {
936             return true;
937         }
938     }
939 
940     /**
941      * @dev Hook that is called before any token transfer. This includes minting
942      * and burning.
943      *
944      * Calling conditions:
945      *
946      * - When `from` and `to` are both non-zero, ``from``'s `tokenId` will be
947      * transferred to `to`.
948      * - When `from` is zero, `tokenId` will be minted for `to`.
949      * - When `to` is zero, ``from``'s `tokenId` will be burned.
950      * - `from` and `to` are never both zero.
951      *
952      * To learn more about hooks, head to xref:ROOT:extending-contracts.adoc#using-hooks[Using Hooks].
953      */
954     function _beforeTokenTransfer(
955         address from,
956         address to,
957         uint256 tokenId
958     ) internal virtual {}
959 }
960 
961 
962 
963 
964 
965 /**
966  * @title Counters
967  * @author Matt Condon (@shrugs)
968  * @dev Provides counters that can only be incremented, decremented or reset. This can be used e.g. to track the number
969  * of elements in a mapping, issuing ERC721 ids, or counting request ids.
970  *
971  * Include with `using Counters for Counters.Counter;`
972  */
973 library Counters {
974     struct Counter {
975         // This variable should never be directly accessed by users of the library: interactions must be restricted to
976         // the library's function. As of Solidity v0.5.2, this cannot be enforced, though there is a proposal to add
977         // this feature: see https://github.com/ethereum/solidity/issues/4637
978         uint256 _value; // default: 0
979     }
980 
981     function current(Counter storage counter) internal view returns (uint256) {
982         return counter._value;
983     }
984 
985     function increment(Counter storage counter) internal {
986         unchecked {
987             counter._value += 1;
988         }
989     }
990 
991     function decrement(Counter storage counter) internal {
992         uint256 value = counter._value;
993         require(value > 0, "Counter: decrement overflow");
994         unchecked {
995             counter._value = value - 1;
996         }
997     }
998 
999     function reset(Counter storage counter) internal {
1000         counter._value = 0;
1001     }
1002 }
1003 
1004 
1005 
1006 
1007 
1008 
1009 
1010 /**
1011  * @dev Contract module which provides a basic access control mechanism, where
1012  * there is an account (an owner) that can be granted exclusive access to
1013  * specific functions.
1014  *
1015  * By default, the owner account will be the one that deploys the contract. This
1016  * can later be changed with {transferOwnership}.
1017  *
1018  * This module is used through inheritance. It will make available the modifier
1019  * `onlyOwner`, which can be applied to your functions to restrict their use to
1020  * the owner.
1021  */
1022 abstract contract Ownable is Context {
1023     address private _owner;
1024 
1025     event OwnershipTransferred(address indexed previousOwner, address indexed newOwner);
1026 
1027     /**
1028      * @dev Initializes the contract setting the deployer as the initial owner.
1029      */
1030     constructor() {
1031         _setOwner(_msgSender());
1032     }
1033 
1034     /**
1035      * @dev Returns the address of the current owner.
1036      */
1037     function owner() public view virtual returns (address) {
1038         return _owner;
1039     }
1040 
1041     /**
1042      * @dev Throws if called by any account other than the owner.
1043      */
1044     modifier onlyOwner() {
1045         require(owner() == _msgSender(), "Ownable: caller is not the owner");
1046         _;
1047     }
1048 
1049     /**
1050      * @dev Leaves the contract without owner. It will not be possible to call
1051      * `onlyOwner` functions anymore. Can only be called by the current owner.
1052      *
1053      * NOTE: Renouncing ownership will leave the contract without an owner,
1054      * thereby removing any functionality that is only available to the owner.
1055      */
1056     function renounceOwnership() public virtual onlyOwner {
1057         _setOwner(address(0));
1058     }
1059 
1060     /**
1061      * @dev Transfers ownership of the contract to a new account (`newOwner`).
1062      * Can only be called by the current owner.
1063      */
1064     function transferOwnership(address newOwner) public virtual onlyOwner {
1065         require(newOwner != address(0), "Ownable: new owner is the zero address");
1066         _setOwner(newOwner);
1067     }
1068 
1069     function _setOwner(address newOwner) private {
1070         address oldOwner = _owner;
1071         _owner = newOwner;
1072         emit OwnershipTransferred(oldOwner, newOwner);
1073     }
1074 }
1075 
1076 
1077 
1078 
1079 
1080 // CAUTION
1081 // This version of SafeMath should only be used with Solidity 0.8 or later,
1082 // because it relies on the compiler's built in overflow checks.
1083 
1084 /**
1085  * @dev Wrappers over Solidity's arithmetic operations.
1086  *
1087  * NOTE: `SafeMath` is no longer needed starting with Solidity 0.8. The compiler
1088  * now has built in overflow checking.
1089  */
1090 library SafeMath {
1091     /**
1092      * @dev Returns the addition of two unsigned integers, with an overflow flag.
1093      *
1094      * _Available since v3.4._
1095      */
1096     function tryAdd(uint256 a, uint256 b) internal pure returns (bool, uint256) {
1097         unchecked {
1098             uint256 c = a + b;
1099             if (c < a) return (false, 0);
1100             return (true, c);
1101         }
1102     }
1103 
1104     /**
1105      * @dev Returns the substraction of two unsigned integers, with an overflow flag.
1106      *
1107      * _Available since v3.4._
1108      */
1109     function trySub(uint256 a, uint256 b) internal pure returns (bool, uint256) {
1110         unchecked {
1111             if (b > a) return (false, 0);
1112             return (true, a - b);
1113         }
1114     }
1115 
1116     /**
1117      * @dev Returns the multiplication of two unsigned integers, with an overflow flag.
1118      *
1119      * _Available since v3.4._
1120      */
1121     function tryMul(uint256 a, uint256 b) internal pure returns (bool, uint256) {
1122         unchecked {
1123             // Gas optimization: this is cheaper than requiring 'a' not being zero, but the
1124             // benefit is lost if 'b' is also tested.
1125             // See: https://github.com/OpenZeppelin/openzeppelin-contracts/pull/522
1126             if (a == 0) return (true, 0);
1127             uint256 c = a * b;
1128             if (c / a != b) return (false, 0);
1129             return (true, c);
1130         }
1131     }
1132 
1133     /**
1134      * @dev Returns the division of two unsigned integers, with a division by zero flag.
1135      *
1136      * _Available since v3.4._
1137      */
1138     function tryDiv(uint256 a, uint256 b) internal pure returns (bool, uint256) {
1139         unchecked {
1140             if (b == 0) return (false, 0);
1141             return (true, a / b);
1142         }
1143     }
1144 
1145     /**
1146      * @dev Returns the remainder of dividing two unsigned integers, with a division by zero flag.
1147      *
1148      * _Available since v3.4._
1149      */
1150     function tryMod(uint256 a, uint256 b) internal pure returns (bool, uint256) {
1151         unchecked {
1152             if (b == 0) return (false, 0);
1153             return (true, a % b);
1154         }
1155     }
1156 
1157     /**
1158      * @dev Returns the addition of two unsigned integers, reverting on
1159      * overflow.
1160      *
1161      * Counterpart to Solidity's `+` operator.
1162      *
1163      * Requirements:
1164      *
1165      * - Addition cannot overflow.
1166      */
1167     function add(uint256 a, uint256 b) internal pure returns (uint256) {
1168         return a + b;
1169     }
1170 
1171     /**
1172      * @dev Returns the subtraction of two unsigned integers, reverting on
1173      * overflow (when the result is negative).
1174      *
1175      * Counterpart to Solidity's `-` operator.
1176      *
1177      * Requirements:
1178      *
1179      * - Subtraction cannot overflow.
1180      */
1181     function sub(uint256 a, uint256 b) internal pure returns (uint256) {
1182         return a - b;
1183     }
1184 
1185     /**
1186      * @dev Returns the multiplication of two unsigned integers, reverting on
1187      * overflow.
1188      *
1189      * Counterpart to Solidity's `*` operator.
1190      *
1191      * Requirements:
1192      *
1193      * - Multiplication cannot overflow.
1194      */
1195     function mul(uint256 a, uint256 b) internal pure returns (uint256) {
1196         return a * b;
1197     }
1198 
1199     /**
1200      * @dev Returns the integer division of two unsigned integers, reverting on
1201      * division by zero. The result is rounded towards zero.
1202      *
1203      * Counterpart to Solidity's `/` operator.
1204      *
1205      * Requirements:
1206      *
1207      * - The divisor cannot be zero.
1208      */
1209     function div(uint256 a, uint256 b) internal pure returns (uint256) {
1210         return a / b;
1211     }
1212 
1213     /**
1214      * @dev Returns the remainder of dividing two unsigned integers. (unsigned integer modulo),
1215      * reverting when dividing by zero.
1216      *
1217      * Counterpart to Solidity's `%` operator. This function uses a `revert`
1218      * opcode (which leaves remaining gas untouched) while Solidity uses an
1219      * invalid opcode to revert (consuming all remaining gas).
1220      *
1221      * Requirements:
1222      *
1223      * - The divisor cannot be zero.
1224      */
1225     function mod(uint256 a, uint256 b) internal pure returns (uint256) {
1226         return a % b;
1227     }
1228 
1229     /**
1230      * @dev Returns the subtraction of two unsigned integers, reverting with custom message on
1231      * overflow (when the result is negative).
1232      *
1233      * CAUTION: This function is deprecated because it requires allocating memory for the error
1234      * message unnecessarily. For custom revert reasons use {trySub}.
1235      *
1236      * Counterpart to Solidity's `-` operator.
1237      *
1238      * Requirements:
1239      *
1240      * - Subtraction cannot overflow.
1241      */
1242     function sub(
1243         uint256 a,
1244         uint256 b,
1245         string memory errorMessage
1246     ) internal pure returns (uint256) {
1247         unchecked {
1248             require(b <= a, errorMessage);
1249             return a - b;
1250         }
1251     }
1252 
1253     /**
1254      * @dev Returns the integer division of two unsigned integers, reverting with custom message on
1255      * division by zero. The result is rounded towards zero.
1256      *
1257      * Counterpart to Solidity's `/` operator. Note: this function uses a
1258      * `revert` opcode (which leaves remaining gas untouched) while Solidity
1259      * uses an invalid opcode to revert (consuming all remaining gas).
1260      *
1261      * Requirements:
1262      *
1263      * - The divisor cannot be zero.
1264      */
1265     function div(
1266         uint256 a,
1267         uint256 b,
1268         string memory errorMessage
1269     ) internal pure returns (uint256) {
1270         unchecked {
1271             require(b > 0, errorMessage);
1272             return a / b;
1273         }
1274     }
1275 
1276     /**
1277      * @dev Returns the remainder of dividing two unsigned integers. (unsigned integer modulo),
1278      * reverting with custom message when dividing by zero.
1279      *
1280      * CAUTION: This function is deprecated because it requires allocating memory for the error
1281      * message unnecessarily. For custom revert reasons use {tryMod}.
1282      *
1283      * Counterpart to Solidity's `%` operator. This function uses a `revert`
1284      * opcode (which leaves remaining gas untouched) while Solidity uses an
1285      * invalid opcode to revert (consuming all remaining gas).
1286      *
1287      * Requirements:
1288      *
1289      * - The divisor cannot be zero.
1290      */
1291     function mod(
1292         uint256 a,
1293         uint256 b,
1294         string memory errorMessage
1295     ) internal pure returns (uint256) {
1296         unchecked {
1297             require(b > 0, errorMessage);
1298             return a % b;
1299         }
1300     }
1301 }
1302 
1303 
1304 
1305 
1306 
1307 /**
1308  * @dev Contract module that helps prevent reentrant calls to a function.
1309  *
1310  * Inheriting from `ReentrancyGuard` will make the {nonReentrant} modifier
1311  * available, which can be applied to functions to make sure there are no nested
1312  * (reentrant) calls to them.
1313  *
1314  * Note that because there is a single `nonReentrant` guard, functions marked as
1315  * `nonReentrant` may not call one another. This can be worked around by making
1316  * those functions `private`, and then adding `external` `nonReentrant` entry
1317  * points to them.
1318  *
1319  * TIP: If you would like to learn more about reentrancy and alternative ways
1320  * to protect against it, check out our blog post
1321  * https://blog.openzeppelin.com/reentrancy-after-istanbul/[Reentrancy After Istanbul].
1322  */
1323 abstract contract ReentrancyGuard {
1324     // Booleans are more expensive than uint256 or any type that takes up a full
1325     // word because each write operation emits an extra SLOAD to first read the
1326     // slot's contents, replace the bits taken up by the boolean, and then write
1327     // back. This is the compiler's defense against contract upgrades and
1328     // pointer aliasing, and it cannot be disabled.
1329 
1330     // The values being non-zero value makes deployment a bit more expensive,
1331     // but in exchange the refund on every call to nonReentrant will be lower in
1332     // amount. Since refunds are capped to a percentage of the total
1333     // transaction's gas, it is best to keep them low in cases like this one, to
1334     // increase the likelihood of the full refund coming into effect.
1335     uint256 private constant _NOT_ENTERED = 1;
1336     uint256 private constant _ENTERED = 2;
1337 
1338     uint256 private _status;
1339 
1340     constructor() {
1341         _status = _NOT_ENTERED;
1342     }
1343 
1344     /**
1345      * @dev Prevents a contract from calling itself, directly or indirectly.
1346      * Calling a `nonReentrant` function from another `nonReentrant`
1347      * function is not supported. It is possible to prevent this from happening
1348      * by making the `nonReentrant` function external, and make it call a
1349      * `private` function that does the actual work.
1350      */
1351     modifier nonReentrant() {
1352         // On the first call to nonReentrant, _notEntered will be true
1353         require(_status != _ENTERED, "ReentrancyGuard: reentrant call");
1354 
1355         // Any calls to nonReentrant after this point will fail
1356         _status = _ENTERED;
1357 
1358         _;
1359 
1360         // By storing the original value once again, a refund is triggered (see
1361         // https://eips.ethereum.org/EIPS/eip-2200)
1362         _status = _NOT_ENTERED;
1363     }
1364 }
1365 
1366 
1367 contract NFT is ERC721, Ownable, ReentrancyGuard {
1368   using Counters for Counters.Counter;
1369   using SafeMath for uint256;
1370   Counters.Counter private _tokenIds;
1371   uint256 private _mintCost;
1372   uint256 private _maxSupply;
1373   bool private _isPublicMintEnabled;
1374   
1375   /**
1376   * @dev Initializes the contract setting the `tokenName` and `symbol` of the nft, `cost` of each mint call, and maximum `supply` of the nft.
1377   * Note: `cost` is in wei. 
1378   */
1379   constructor(string memory tokenName, string memory symbol, uint256 cost, uint256 supply) ERC721(tokenName, symbol) Ownable() {
1380     _mintCost = cost;
1381     _maxSupply = supply;
1382     _isPublicMintEnabled = false;
1383   }
1384 
1385   /**
1386   * @dev Changes contract state to enable public access to `mintTokens` function
1387   * Can only be called by the current owner.
1388   */
1389   function allowPublicMint()
1390   public
1391   onlyOwner{
1392     _isPublicMintEnabled = true;
1393   }
1394 
1395   /**
1396   * @dev Changes contract state to disable public access to `mintTokens` function
1397   * Can only be called by the current owner.
1398   */
1399   function denyPublicMint()
1400   public
1401   onlyOwner{
1402     _isPublicMintEnabled = false;
1403   }
1404 
1405   /**
1406   * @dev Mint `count` tokens if requirements are satisfied.
1407   * 
1408   */
1409   function mintTokens(uint256 count)
1410   public
1411   payable
1412   nonReentrant{
1413     require(_isPublicMintEnabled, "Mint disabled");
1414     require(count > 0 && count <= 100, "You can drop minimum 1, maximum 100 NFTs");
1415     require(count.add(_tokenIds.current()) < _maxSupply, "Exceeds max supply");
1416     require(owner() == msg.sender || msg.value >= _mintCost.mul(count),
1417            "Ether value sent is below the price");
1418     for(uint i=0; i<count; i++){
1419         _mint(msg.sender);
1420      }
1421   }
1422 
1423   /**
1424   * @dev Mint a token to each Address of `recipients`.
1425   * Can only be called if requirements are satisfied.
1426   */
1427   function mintTokens(address[] calldata recipients)
1428   public
1429   payable
1430   nonReentrant{
1431     require(recipients.length>0,"Missing recipient addresses");
1432     require(owner() == msg.sender || _isPublicMintEnabled, "Mint disabled");
1433     require(recipients.length > 0 && recipients.length <= 100, "You can drop minimum 1, maximum 100 NFTs");
1434     require(recipients.length.add(_tokenIds.current()) < _maxSupply, "Exceeds max supply");
1435     require(owner() == msg.sender || msg.value >= _mintCost.mul(recipients.length),
1436            "Ether value sent is below the price");
1437     for(uint i=0; i<recipients.length; i++){
1438         _mint(recipients[i]);
1439      }
1440   }
1441 
1442   /**
1443   * @dev Update the cost to mint a token.
1444   * Can only be called by the current owner.
1445   */
1446   function setCost(uint256 cost) public onlyOwner{
1447     _mintCost = cost;
1448   }
1449 
1450   /**
1451   * @dev Update the max supply.
1452   * Can only be called by the current owner.
1453   */
1454   function setMaxSupply(uint256 max) public onlyOwner{
1455     _maxSupply = max;
1456   }
1457 
1458   /**
1459   * @dev Transfers contract balance to contract owner.
1460   * Can only be called by the current owner.
1461   */
1462   function withdraw() public onlyOwner{
1463     payable(owner()).transfer(address(this).balance);
1464   }
1465 
1466   /**
1467   * @dev Used by public mint functions and by owner functions.
1468   * Can only be called internally by other functions.
1469   */
1470   function _mint(address to) internal virtual returns (uint256){
1471     _tokenIds.increment();
1472     uint256 id = _tokenIds.current();
1473     _safeMint(to, id);
1474 
1475     return id;
1476   }
1477 
1478   function getCost() public view returns (uint256){
1479     return _mintCost;
1480   }
1481   function totalSupply() public view returns (uint256){
1482     return _maxSupply;
1483   }
1484   function getCurrentSupply() public view returns (uint256){
1485     return _tokenIds.current();
1486   }
1487   function getMintStatus() public view returns (bool) {
1488     return _isPublicMintEnabled;
1489   }
1490   function _baseURI() override internal pure returns (string memory) {
1491     return "https://mw9spidhbc.execute-api.us-east-1.amazonaws.com/dev/token/on-chain-cat/";
1492   }
1493   function contractURI() public pure returns (string memory) {
1494     return "https://mw9spidhbc.execute-api.us-east-1.amazonaws.com/dev/contract/on-chain-cat";
1495   }
1496 }