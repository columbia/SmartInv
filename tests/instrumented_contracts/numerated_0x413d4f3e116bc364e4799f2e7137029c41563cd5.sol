1 // SPDX-License-Identifier: MIT
2 
3 // File: @openzeppelin/contracts/utils/introspection/IERC165.sol
4 pragma solidity ^0.8.0;
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
26 // File: @openzeppelin/contracts/token/ERC721/IERC721.sol
27 pragma solidity ^0.8.0;
28 /**
29  * @dev Required interface of an ERC721 compliant contract.
30  */
31 interface IERC721 is IERC165 {
32     /**
33      * @dev Emitted when `tokenId` token is transferred from `from` to `to`.
34      */
35     event Transfer(address indexed from, address indexed to, uint256 indexed tokenId);
36 
37     /**
38      * @dev Emitted when `owner` enables `approved` to manage the `tokenId` token.
39      */
40     event Approval(address indexed owner, address indexed approved, uint256 indexed tokenId);
41 
42     /**
43      * @dev Emitted when `owner` enables or disables (`approved`) `operator` to manage all of its assets.
44      */
45     event ApprovalForAll(address indexed owner, address indexed operator, bool approved);
46 
47     /**
48      * @dev Returns the number of tokens in ``owner``'s account.
49      */
50     function balanceOf(address owner) external view returns (uint256 balance);
51 
52     /**
53      * @dev Returns the owner of the `tokenId` token.
54      *
55      * Requirements:
56      *
57      * - `tokenId` must exist.
58      */
59     function ownerOf(uint256 tokenId) external view returns (address owner);
60 
61     /**
62      * @dev Safely transfers `tokenId` token from `from` to `to`, checking first that contract recipients
63      * are aware of the ERC721 protocol to prevent tokens from being forever locked.
64      *
65      * Requirements:
66      *
67      * - `from` cannot be the zero address.
68      * - `to` cannot be the zero address.
69      * - `tokenId` token must exist and be owned by `from`.
70      * - If the caller is not `from`, it must be have been allowed to move this token by either {approve} or {setApprovalForAll}.
71      * - If `to` refers to a smart contract, it must implement {IERC721Receiver-onERC721Received}, which is called upon a safe transfer.
72      *
73      * Emits a {Transfer} event.
74      */
75     function safeTransferFrom(
76         address from,
77         address to,
78         uint256 tokenId
79     ) external;
80 
81     /**
82      * @dev Transfers `tokenId` token from `from` to `to`.
83      *
84      * WARNING: Usage of this method is discouraged, use {safeTransferFrom} whenever possible.
85      *
86      * Requirements:
87      *
88      * - `from` cannot be the zero address.
89      * - `to` cannot be the zero address.
90      * - `tokenId` token must be owned by `from`.
91      * - If the caller is not `from`, it must be approved to move this token by either {approve} or {setApprovalForAll}.
92      *
93      * Emits a {Transfer} event.
94      */
95     function transferFrom(
96         address from,
97         address to,
98         uint256 tokenId
99     ) external;
100 
101     /**
102      * @dev Gives permission to `to` to transfer `tokenId` token to another account.
103      * The approval is cleared when the token is transferred.
104      *
105      * Only a single account can be approved at a time, so approving the zero address clears previous approvals.
106      *
107      * Requirements:
108      *
109      * - The caller must own the token or be an approved operator.
110      * - `tokenId` must exist.
111      *
112      * Emits an {Approval} event.
113      */
114     function approve(address to, uint256 tokenId) external;
115 
116     /**
117      * @dev Returns the account approved for `tokenId` token.
118      *
119      * Requirements:
120      *
121      * - `tokenId` must exist.
122      */
123     function getApproved(uint256 tokenId) external view returns (address operator);
124 
125     /**
126      * @dev Approve or remove `operator` as an operator for the caller.
127      * Operators can call {transferFrom} or {safeTransferFrom} for any token owned by the caller.
128      *
129      * Requirements:
130      *
131      * - The `operator` cannot be the caller.
132      *
133      * Emits an {ApprovalForAll} event.
134      */
135     function setApprovalForAll(address operator, bool _approved) external;
136 
137     /**
138      * @dev Returns if the `operator` is allowed to manage all of the assets of `owner`.
139      *
140      * See {setApprovalForAll}
141      */
142     function isApprovedForAll(address owner, address operator) external view returns (bool);
143 
144     /**
145      * @dev Safely transfers `tokenId` token from `from` to `to`.
146      *
147      * Requirements:
148      *
149      * - `from` cannot be the zero address.
150      * - `to` cannot be the zero address.
151      * - `tokenId` token must exist and be owned by `from`.
152      * - If the caller is not `from`, it must be approved to move this token by either {approve} or {setApprovalForAll}.
153      * - If `to` refers to a smart contract, it must implement {IERC721Receiver-onERC721Received}, which is called upon a safe transfer.
154      *
155      * Emits a {Transfer} event.
156      */
157     function safeTransferFrom(
158         address from,
159         address to,
160         uint256 tokenId,
161         bytes calldata data
162     ) external;
163 }
164 
165 
166 // File: @openzeppelin/contracts/utils/introspection/ERC165.sol
167 pragma solidity ^0.8.0;
168 /**
169  * @dev Implementation of the {IERC165} interface.
170  *
171  * Contracts that want to implement ERC165 should inherit from this contract and override {supportsInterface} to check
172  * for the additional interface id that will be supported. For example:
173  *
174  * ```solidity
175  * function supportsInterface(bytes4 interfaceId) public view virtual override returns (bool) {
176  *     return interfaceId == type(MyInterface).interfaceId || super.supportsInterface(interfaceId);
177  * }
178  * ```
179  *
180  * Alternatively, {ERC165Storage} provides an easier to use but more expensive implementation.
181  */
182 abstract contract ERC165 is IERC165 {
183     /**
184      * @dev See {IERC165-supportsInterface}.
185      */
186     function supportsInterface(bytes4 interfaceId) public view virtual override returns (bool) {
187         return interfaceId == type(IERC165).interfaceId;
188     }
189 }
190 
191 // File: @openzeppelin/contracts/utils/Strings.sol
192 
193 
194 
195 pragma solidity ^0.8.0;
196 
197 /**
198  * @dev String operations.
199  */
200 library Strings {
201     bytes16 private constant _HEX_SYMBOLS = "0123456789abcdef";
202 
203     /**
204      * @dev Converts a `uint256` to its ASCII `string` decimal representation.
205      */
206     function toString(uint256 value) internal pure returns (string memory) {
207         // Inspired by OraclizeAPI's implementation - MIT licence
208         // https://github.com/oraclize/ethereum-api/blob/b42146b063c7d6ee1358846c198246239e9360e8/oraclizeAPI_0.4.25.sol
209 
210         if (value == 0) {
211             return "0";
212         }
213         uint256 temp = value;
214         uint256 digits;
215         while (temp != 0) {
216             digits++;
217             temp /= 10;
218         }
219         bytes memory buffer = new bytes(digits);
220         while (value != 0) {
221             digits -= 1;
222             buffer[digits] = bytes1(uint8(48 + uint256(value % 10)));
223             value /= 10;
224         }
225         return string(buffer);
226     }
227 
228     /**
229      * @dev Converts a `uint256` to its ASCII `string` hexadecimal representation.
230      */
231     function toHexString(uint256 value) internal pure returns (string memory) {
232         if (value == 0) {
233             return "0x00";
234         }
235         uint256 temp = value;
236         uint256 length = 0;
237         while (temp != 0) {
238             length++;
239             temp >>= 8;
240         }
241         return toHexString(value, length);
242     }
243 
244     /**
245      * @dev Converts a `uint256` to its ASCII `string` hexadecimal representation with fixed length.
246      */
247     function toHexString(uint256 value, uint256 length) internal pure returns (string memory) {
248         bytes memory buffer = new bytes(2 * length + 2);
249         buffer[0] = "0";
250         buffer[1] = "x";
251         for (uint256 i = 2 * length + 1; i > 1; --i) {
252             buffer[i] = _HEX_SYMBOLS[value & 0xf];
253             value >>= 4;
254         }
255         require(value == 0, "Strings: hex length insufficient");
256         return string(buffer);
257     }
258 }
259 
260 // File: @openzeppelin/contracts/utils/Address.sol
261 
262 
263 
264 pragma solidity ^0.8.0;
265 
266 /**
267  * @dev Collection of functions related to the address type
268  */
269 library Address {
270     /**
271      * @dev Returns true if `account` is a contract.
272      *
273      * [IMPORTANT]
274      * ====
275      * It is unsafe to assume that an address for which this function returns
276      * false is an externally-owned account (EOA) and not a contract.
277      *
278      * Among others, `isContract` will return false for the following
279      * types of addresses:
280      *
281      *  - an externally-owned account
282      *  - a contract in construction
283      *  - an address where a contract will be created
284      *  - an address where a contract lived, but was destroyed
285      * ====
286      */
287     function isContract(address account) internal view returns (bool) {
288         // This method relies on extcodesize, which returns 0 for contracts in
289         // construction, since the code is only stored at the end of the
290         // constructor execution.
291 
292         uint256 size;
293         assembly {
294             size := extcodesize(account)
295         }
296         return size > 0;
297     }
298 
299     /**
300      * @dev Replacement for Solidity's `transfer`: sends `amount` wei to
301      * `recipient`, forwarding all available gas and reverting on errors.
302      *
303      * https://eips.ethereum.org/EIPS/eip-1884[EIP1884] increases the gas cost
304      * of certain opcodes, possibly making contracts go over the 2300 gas limit
305      * imposed by `transfer`, making them unable to receive funds via
306      * `transfer`. {sendValue} removes this limitation.
307      *
308      * https://diligence.consensys.net/posts/2019/09/stop-using-soliditys-transfer-now/[Learn more].
309      *
310      * IMPORTANT: because control is transferred to `recipient`, care must be
311      * taken to not create reentrancy vulnerabilities. Consider using
312      * {ReentrancyGuard} or the
313      * https://solidity.readthedocs.io/en/v0.5.11/security-considerations.html#use-the-checks-effects-interactions-pattern[checks-effects-interactions pattern].
314      */
315     function sendValue(address payable recipient, uint256 amount) internal {
316         require(address(this).balance >= amount, "Address: insufficient balance");
317 
318         (bool success, ) = recipient.call{value: amount}("");
319         require(success, "Address: unable to send value, recipient may have reverted");
320     }
321 
322     /**
323      * @dev Performs a Solidity function call using a low level `call`. A
324      * plain `call` is an unsafe replacement for a function call: use this
325      * function instead.
326      *
327      * If `target` reverts with a revert reason, it is bubbled up by this
328      * function (like regular Solidity function calls).
329      *
330      * Returns the raw returned data. To convert to the expected return value,
331      * use https://solidity.readthedocs.io/en/latest/units-and-global-variables.html?highlight=abi.decode#abi-encoding-and-decoding-functions[`abi.decode`].
332      *
333      * Requirements:
334      *
335      * - `target` must be a contract.
336      * - calling `target` with `data` must not revert.
337      *
338      * _Available since v3.1._
339      */
340     function functionCall(address target, bytes memory data) internal returns (bytes memory) {
341         return functionCall(target, data, "Address: low-level call failed");
342     }
343 
344     /**
345      * @dev Same as {xref-Address-functionCall-address-bytes-}[`functionCall`], but with
346      * `errorMessage` as a fallback revert reason when `target` reverts.
347      *
348      * _Available since v3.1._
349      */
350     function functionCall(
351         address target,
352         bytes memory data,
353         string memory errorMessage
354     ) internal returns (bytes memory) {
355         return functionCallWithValue(target, data, 0, errorMessage);
356     }
357 
358     /**
359      * @dev Same as {xref-Address-functionCall-address-bytes-}[`functionCall`],
360      * but also transferring `value` wei to `target`.
361      *
362      * Requirements:
363      *
364      * - the calling contract must have an ETH balance of at least `value`.
365      * - the called Solidity function must be `payable`.
366      *
367      * _Available since v3.1._
368      */
369     function functionCallWithValue(
370         address target,
371         bytes memory data,
372         uint256 value
373     ) internal returns (bytes memory) {
374         return functionCallWithValue(target, data, value, "Address: low-level call with value failed");
375     }
376 
377     /**
378      * @dev Same as {xref-Address-functionCallWithValue-address-bytes-uint256-}[`functionCallWithValue`], but
379      * with `errorMessage` as a fallback revert reason when `target` reverts.
380      *
381      * _Available since v3.1._
382      */
383     function functionCallWithValue(
384         address target,
385         bytes memory data,
386         uint256 value,
387         string memory errorMessage
388     ) internal returns (bytes memory) {
389         require(address(this).balance >= value, "Address: insufficient balance for call");
390         require(isContract(target), "Address: call to non-contract");
391 
392         (bool success, bytes memory returndata) = target.call{value: value}(data);
393         return verifyCallResult(success, returndata, errorMessage);
394     }
395 
396     /**
397      * @dev Same as {xref-Address-functionCall-address-bytes-}[`functionCall`],
398      * but performing a static call.
399      *
400      * _Available since v3.3._
401      */
402     function functionStaticCall(address target, bytes memory data) internal view returns (bytes memory) {
403         return functionStaticCall(target, data, "Address: low-level static call failed");
404     }
405 
406     /**
407      * @dev Same as {xref-Address-functionCall-address-bytes-string-}[`functionCall`],
408      * but performing a static call.
409      *
410      * _Available since v3.3._
411      */
412     function functionStaticCall(
413         address target,
414         bytes memory data,
415         string memory errorMessage
416     ) internal view returns (bytes memory) {
417         require(isContract(target), "Address: static call to non-contract");
418 
419         (bool success, bytes memory returndata) = target.staticcall(data);
420         return verifyCallResult(success, returndata, errorMessage);
421     }
422 
423     /**
424      * @dev Same as {xref-Address-functionCall-address-bytes-}[`functionCall`],
425      * but performing a delegate call.
426      *
427      * _Available since v3.4._
428      */
429     function functionDelegateCall(address target, bytes memory data) internal returns (bytes memory) {
430         return functionDelegateCall(target, data, "Address: low-level delegate call failed");
431     }
432 
433     /**
434      * @dev Same as {xref-Address-functionCall-address-bytes-string-}[`functionCall`],
435      * but performing a delegate call.
436      *
437      * _Available since v3.4._
438      */
439     function functionDelegateCall(
440         address target,
441         bytes memory data,
442         string memory errorMessage
443     ) internal returns (bytes memory) {
444         require(isContract(target), "Address: delegate call to non-contract");
445 
446         (bool success, bytes memory returndata) = target.delegatecall(data);
447         return verifyCallResult(success, returndata, errorMessage);
448     }
449 
450     /**
451      * @dev Tool to verifies that a low level call was successful, and revert if it wasn't, either by bubbling the
452      * revert reason using the provided one.
453      *
454      * _Available since v4.3._
455      */
456     function verifyCallResult(
457         bool success,
458         bytes memory returndata,
459         string memory errorMessage
460     ) internal pure returns (bytes memory) {
461         if (success) {
462             return returndata;
463         } else {
464             // Look for revert reason and bubble it up if present
465             if (returndata.length > 0) {
466                 // The easiest way to bubble the revert reason is using memory via assembly
467 
468                 assembly {
469                     let returndata_size := mload(returndata)
470                     revert(add(32, returndata), returndata_size)
471                 }
472             } else {
473                 revert(errorMessage);
474             }
475         }
476     }
477 }
478 
479 // File: @openzeppelin/contracts/token/ERC721/extensions/IERC721Metadata.sol
480 
481 
482 
483 pragma solidity ^0.8.0;
484 
485 
486 /**
487  * @title ERC-721 Non-Fungible Token Standard, optional metadata extension
488  * @dev See https://eips.ethereum.org/EIPS/eip-721
489  */
490 interface IERC721Metadata is IERC721 {
491     /**
492      * @dev Returns the token collection name.
493      */
494     function name() external view returns (string memory);
495 
496     /**
497      * @dev Returns the token collection symbol.
498      */
499     function symbol() external view returns (string memory);
500 
501     /**
502      * @dev Returns the Uniform Resource Identifier (URI) for `tokenId` token.
503      */
504     function tokenURI(uint256 tokenId) external view returns (string memory);
505 }
506 
507 // File: @openzeppelin/contracts/token/ERC721/IERC721Receiver.sol
508 
509 
510 
511 pragma solidity ^0.8.0;
512 
513 /**
514  * @title ERC721 token receiver interface
515  * @dev Interface for any contract that wants to support safeTransfers
516  * from ERC721 asset contracts.
517  */
518 interface IERC721Receiver {
519     /**
520      * @dev Whenever an {IERC721} `tokenId` token is transferred to this contract via {IERC721-safeTransferFrom}
521      * by `operator` from `from`, this function is called.
522      *
523      * It must return its Solidity selector to confirm the token transfer.
524      * If any other value is returned or the interface is not implemented by the recipient, the transfer will be reverted.
525      *
526      * The selector can be obtained in Solidity with `IERC721.onERC721Received.selector`.
527      */
528     function onERC721Received(
529         address operator,
530         address from,
531         uint256 tokenId,
532         bytes calldata data
533     ) external returns (bytes4);
534 }
535 
536 // File: @openzeppelin/contracts/utils/Context.sol
537 pragma solidity ^0.8.0;
538 /**
539  * @dev Provides information about the current execution context, including the
540  * sender of the transaction and its data. While these are generally available
541  * via msg.sender and msg.data, they should not be accessed in such a direct
542  * manner, since when dealing with meta-transactions the account sending and
543  * paying for execution may not be the actual sender (as far as an application
544  * is concerned).
545  *
546  * This contract is only required for intermediate, library-like contracts.
547  */
548 abstract contract Context {
549     function _msgSender() internal view virtual returns (address) {
550         return msg.sender;
551     }
552 
553     function _msgData() internal view virtual returns (bytes calldata) {
554         return msg.data;
555     }
556 }
557 
558 
559 // File: @openzeppelin/contracts/token/ERC721/ERC721.sol
560 pragma solidity ^0.8.0;
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
925                 return retval == IERC721Receiver.onERC721Received.selector;
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
962 // File: @openzeppelin/contracts/access/Ownable.sol
963 pragma solidity ^0.8.0;
964 /**
965  * @dev Contract module which provides a basic access control mechanism, where
966  * there is an account (an owner) that can be granted exclusive access to
967  * specific functions.
968  *
969  * By default, the owner account will be the one that deploys the contract. This
970  * can later be changed with {transferOwnership}.
971  *
972  * This module is used through inheritance. It will make available the modifier
973  * `onlyOwner`, which can be applied to your functions to restrict their use to
974  * the owner.
975  */
976 abstract contract Ownable is Context {
977     address private _owner;
978 
979     event OwnershipTransferred(address indexed previousOwner, address indexed newOwner);
980 
981     /**
982      * @dev Initializes the contract setting the deployer as the initial owner.
983      */
984     constructor() {
985         _setOwner(_msgSender());
986     }
987 
988     /**
989      * @dev Returns the address of the current owner.
990      */
991     function owner() public view virtual returns (address) {
992         return _owner;
993     }
994 
995     /**
996      * @dev Throws if called by any account other than the owner.
997      */
998     modifier onlyOwner() {
999         require(owner() == _msgSender(), "Ownable: caller is not the owner");
1000         _;
1001     }
1002 
1003     /**
1004      * @dev Leaves the contract without owner. It will not be possible to call
1005      * `onlyOwner` functions anymore. Can only be called by the current owner.
1006      *
1007      * NOTE: Renouncing ownership will leave the contract without an owner,
1008      * thereby removing any functionality that is only available to the owner.
1009      */
1010     function renounceOwnership() public virtual onlyOwner {
1011         _setOwner(address(0));
1012     }
1013 
1014     /**
1015      * @dev Transfers ownership of the contract to a new account (`newOwner`).
1016      * Can only be called by the current owner.
1017      */
1018     function transferOwnership(address newOwner) public virtual onlyOwner {
1019         require(newOwner != address(0), "Ownable: new owner is the zero address");
1020         _setOwner(newOwner);
1021     }
1022 
1023     function _setOwner(address newOwner) private {
1024         address oldOwner = _owner;
1025         _owner = newOwner;
1026         emit OwnershipTransferred(oldOwner, newOwner);
1027     }
1028 }
1029 
1030 /**
1031  * @dev These functions deal with verification of Merkle Trees proofs.
1032  *
1033  * The proofs can be generated using the JavaScript library
1034  * https://github.com/miguelmota/merkletreejs[merkletreejs].
1035  * Note: the hashing algorithm should be keccak256 and pair sorting should be enabled.
1036  *
1037  * See `test/utils/cryptography/MerkleProof.test.js` for some examples.
1038  */
1039 library MerkleProof {
1040     /**
1041      * @dev Returns true if a `leaf` can be proved to be a part of a Merkle tree
1042      * defined by `root`. For this, a `proof` must be provided, containing
1043      * sibling hashes on the branch from the leaf to the root of the tree. Each
1044      * pair of leaves and each pair of pre-images are assumed to be sorted.
1045      */
1046     function verify(
1047         bytes32[] memory proof,
1048         bytes32 root,
1049         bytes32 leaf
1050     ) internal pure returns (bool) {
1051         return processProof(proof, leaf) == root;
1052     }
1053 
1054     /**
1055      * @dev Returns the rebuilt hash obtained by traversing a Merklee tree up
1056      * from `leaf` using `proof`. A `proof` is valid if and only if the rebuilt
1057      * hash matches the root of the tree. When processing the proof, the pairs
1058      * of leafs & pre-images are assumed to be sorted.
1059      *
1060      * _Available since v4.4._
1061      */
1062     function processProof(bytes32[] memory proof, bytes32 leaf) internal pure returns (bytes32) {
1063         bytes32 computedHash = leaf;
1064         for (uint256 i = 0; i < proof.length; i++) {
1065             bytes32 proofElement = proof[i];
1066             if (computedHash <= proofElement) {
1067                 // Hash(current computed hash + current element of the proof)
1068                 computedHash = _efficientHash(computedHash, proofElement);
1069             } else {
1070                 // Hash(current element of the proof + current computed hash)
1071                 computedHash = _efficientHash(proofElement, computedHash);
1072             }
1073         }
1074         return computedHash;
1075     }
1076 
1077     function _efficientHash(bytes32 a, bytes32 b) private pure returns (bytes32 value) {
1078         assembly {
1079             mstore(0x00, a)
1080             mstore(0x20, b)
1081             value := keccak256(0x00, 0x40)
1082         }
1083     }
1084 }
1085 
1086 pragma solidity ^0.8.0;
1087 
1088 contract KaijuQueenz is ERC721, Ownable {
1089     using Strings for uint256;
1090     
1091     string private baseURI;
1092     string private blindURI;
1093     bytes32 public merkleRoot;
1094 
1095     uint256 public constant MINT_COST = 0.0666 ether;
1096     uint256 public constant MAX_SUPPLY = 3333;
1097     uint256 public constant MAX_MINT_PER_TX = 2;
1098     uint256 public constant PRESALE_MINT_LIMIT = 2;
1099     uint256 public constant MAX_NFTS_PER_PUBLIC_ADDRESS = 2;
1100     uint256 public totalSupply;
1101 
1102     bool public paused = true;
1103     bool public reveal;
1104     bool public onlyWhitelisted = true;
1105 
1106     mapping(address => bool) whitelistClaimed;
1107     mapping(address => uint256) public addressMintedBalance;
1108     mapping(address => uint256) public presaleAddressMintedBalance;
1109 
1110     event NewMint(address indexed from);
1111     event IsPaused(bool state);
1112     event IsWhitelisted(bool state);
1113     event StopPurchase();
1114 
1115     constructor(
1116         string memory _name,
1117         string memory _symbol,
1118         string memory _initBaseURI,
1119         string memory _initBlindURI
1120     ) ERC721(_name, _symbol) {
1121         setBaseURI(_initBaseURI, _initBlindURI);
1122     }
1123 
1124     function whitelistMint(bytes32[] calldata _merkleProof, uint256 _mintAmount) public payable {
1125         require(!paused, "Sale is paused");
1126         require(onlyWhitelisted, "Presale is still active");
1127         require(_mintAmount > 0, "Mint amount must be larger than zero");
1128         require(_mintAmount <= MAX_MINT_PER_TX, "Mint amount cannot be greater than max mint per tx");
1129         uint256 supply = totalSupply;
1130         require(supply + _mintAmount <= MAX_SUPPLY, "Purchase would exceed max public supply of NFTs");
1131         
1132         bytes32 leaf = keccak256(abi.encodePacked(msg.sender));
1133         require(MerkleProof.verify(_merkleProof, merkleRoot, leaf), "User is not whitelisted");
1134 
1135         uint256 ownerMintedCount = addressMintedBalance[msg.sender];
1136         require(ownerMintedCount + _mintAmount <= PRESALE_MINT_LIMIT, "Max presale NFT limit exceeded");
1137         require(msg.value >= MINT_COST * _mintAmount, "Ether value sent is not correct");
1138 
1139         if (ownerMintedCount + _mintAmount == PRESALE_MINT_LIMIT) {
1140             emit StopPurchase();
1141         }
1142 
1143         if (!whitelistClaimed[msg.sender]) {
1144             whitelistClaimed[msg.sender] = true;
1145         }
1146 
1147         for (uint256 i = 1; i <= _mintAmount; i++) {
1148             _safeMint(msg.sender, supply + i);
1149         }
1150         presaleAddressMintedBalance[msg.sender] += _mintAmount;
1151         addressMintedBalance[msg.sender] += _mintAmount;
1152         totalSupply += _mintAmount;
1153 
1154         emit NewMint(msg.sender);
1155     }
1156 
1157     function publicMint(uint256 _mintAmount) public payable {
1158         require(!paused, "Sale is paused");
1159         require(!onlyWhitelisted, "Presale needs to be over");
1160         require(_mintAmount > 0, "Mint amount must be larger than zero");
1161         require(_mintAmount <= MAX_MINT_PER_TX, "Mint amount cannot be greater than max mint per tx");
1162         uint256 supply = totalSupply;
1163         require(supply + _mintAmount <= MAX_SUPPLY, "Purchase would exceed max public supply of NFTs");
1164         uint256 ownerMintedCount = addressMintedBalance[msg.sender];
1165         require(msg.value >= MINT_COST * _mintAmount, "Ether value sent is not correct");
1166     
1167         bool isWhitelistUser = whitelistClaimed[msg.sender];
1168         if (isWhitelistUser) {
1169             uint256 ownerPresaleMintedCount = presaleAddressMintedBalance[msg.sender];
1170             uint256 MAX_NFTS_PER_WHITELIST_ADDRESS = ownerPresaleMintedCount + MAX_MINT_PER_TX;
1171             require(ownerMintedCount + _mintAmount <= MAX_NFTS_PER_WHITELIST_ADDRESS, "Max whitelist address NFT limit exceeded");
1172             if (ownerMintedCount + _mintAmount == MAX_NFTS_PER_WHITELIST_ADDRESS) {
1173                 emit StopPurchase();
1174             }
1175         } else {
1176             require(ownerMintedCount + _mintAmount <= MAX_NFTS_PER_PUBLIC_ADDRESS, "Max non whitelist address NFT limit exceeded");
1177             if (ownerMintedCount + _mintAmount == MAX_NFTS_PER_PUBLIC_ADDRESS) {
1178                 emit StopPurchase();
1179             }
1180         }
1181 
1182         for (uint256 i = 1; i <= _mintAmount; i++) {
1183             _safeMint(msg.sender, supply + i);
1184         }
1185         addressMintedBalance[msg.sender] += _mintAmount;
1186         totalSupply += _mintAmount;
1187         
1188         emit NewMint(msg.sender);
1189     }
1190 
1191     function ownerMint(uint256 _mintAmount) public onlyOwner {
1192         uint256 supply = totalSupply;
1193         require(supply + _mintAmount <= MAX_SUPPLY, "Purchase would exceed max public supply of NFTs");
1194         for (uint256 i = 1; i <= _mintAmount; i++) {
1195             _safeMint(msg.sender, supply + i);
1196         }
1197         totalSupply += _mintAmount;
1198     }
1199 
1200     function verify(bytes32[] memory proof) public view returns (bool) {
1201         bytes32 leaf = keccak256(abi.encodePacked(msg.sender));
1202         return MerkleProof.verify(proof, merkleRoot, leaf);
1203     }
1204 
1205     function tokenURI(uint256 tokenId)
1206         public
1207         view
1208         virtual
1209         override
1210         returns (string memory)
1211     {
1212         require(_exists(tokenId), "ERC721Metadata: URI query for nonexistent token");
1213         if (!reveal) {
1214             return string(abi.encodePacked(blindURI));
1215         } else {
1216             return bytes(baseURI).length > 0
1217                 ? string(abi.encodePacked(baseURI, tokenId.toString(), ".json"))
1218                 : "";
1219         }
1220     }
1221 
1222     function setBaseURI(string memory _newBaseURI, string memory _newBlindURI) public onlyOwner {
1223         baseURI = _newBaseURI;
1224         blindURI = _newBlindURI;
1225     }
1226 
1227     function revealNow() public onlyOwner {
1228         reveal = true;
1229     }
1230 
1231     function setMerkleRoot(bytes32 _merkleRoot) public onlyOwner {
1232         merkleRoot = _merkleRoot;
1233     }
1234 
1235     function setOnlyWhitelisted(bool _state) public onlyOwner {
1236         onlyWhitelisted = _state;
1237         emit IsWhitelisted(_state);
1238     }
1239     
1240     function pause(bool _state) public onlyOwner {
1241         paused = _state;
1242         emit IsPaused(_state);
1243     }
1244     
1245     function withdraw() public onlyOwner {
1246         // Do not remove this otherwise you will not be able to withdraw the funds.
1247         // =============================================================================
1248         (bool os, ) = payable(owner()).call{value: address(this).balance}("");
1249         require(os);
1250         // =============================================================================
1251     }
1252 }