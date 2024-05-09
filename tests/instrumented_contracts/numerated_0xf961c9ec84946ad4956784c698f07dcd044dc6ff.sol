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
27 pragma solidity ^0.8.0;
28 
29 /**
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
50 pragma solidity ^0.8.0;
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
117 pragma solidity ^0.8.0;
118 
119 
120 
121 /**
122  * @dev Required interface of an ERC721 compliant contract.
123  */
124 interface IERC721 is IERC165 {
125     /**
126      * @dev Emitted when `tokenId` token is transferred from `from` to `to`.
127      */
128     event Transfer(address indexed from, address indexed to, uint256 indexed tokenId);
129 
130     /**
131      * @dev Emitted when `owner` enables `approved` to manage the `tokenId` token.
132      */
133     event Approval(address indexed owner, address indexed approved, uint256 indexed tokenId);
134 
135     /**
136      * @dev Emitted when `owner` enables or disables (`approved`) `operator` to manage all of its assets.
137      */
138     event ApprovalForAll(address indexed owner, address indexed operator, bool approved);
139 
140     /**
141      * @dev Returns the number of tokens in ``owner``'s account.
142      */
143     function balanceOf(address owner) external view returns (uint256 balance);
144 
145     /**
146      * @dev Returns the owner of the `tokenId` token.
147      *
148      * Requirements:
149      *
150      * - `tokenId` must exist.
151      */
152     function ownerOf(uint256 tokenId) external view returns (address owner);
153 
154     /**
155      * @dev Safely transfers `tokenId` token from `from` to `to`, checking first that contract recipients
156      * are aware of the ERC721 protocol to prevent tokens from being forever locked.
157      *
158      * Requirements:
159      *
160      * - `from` cannot be the zero address.
161      * - `to` cannot be the zero address.
162      * - `tokenId` token must exist and be owned by `from`.
163      * - If the caller is not `from`, it must be have been allowed to move this token by either {approve} or {setApprovalForAll}.
164      * - If `to` refers to a smart contract, it must implement {IERC721Receiver-onERC721Received}, which is called upon a safe transfer.
165      *
166      * Emits a {Transfer} event.
167      */
168     function safeTransferFrom(
169         address from,
170         address to,
171         uint256 tokenId
172     ) external;
173 
174     /**
175      * @dev Transfers `tokenId` token from `from` to `to`.
176      *
177      * WARNING: Usage of this method is discouraged, use {safeTransferFrom} whenever possible.
178      *
179      * Requirements:
180      *
181      * - `from` cannot be the zero address.
182      * - `to` cannot be the zero address.
183      * - `tokenId` token must be owned by `from`.
184      * - If the caller is not `from`, it must be approved to move this token by either {approve} or {setApprovalForAll}.
185      *
186      * Emits a {Transfer} event.
187      */
188     function transferFrom(
189         address from,
190         address to,
191         uint256 tokenId
192     ) external;
193 
194     /**
195      * @dev Gives permission to `to` to transfer `tokenId` token to another account.
196      * The approval is cleared when the token is transferred.
197      *
198      * Only a single account can be approved at a time, so approving the zero address clears previous approvals.
199      *
200      * Requirements:
201      *
202      * - The caller must own the token or be an approved operator.
203      * - `tokenId` must exist.
204      *
205      * Emits an {Approval} event.
206      */
207     function approve(address to, uint256 tokenId) external;
208 
209     /**
210      * @dev Returns the account approved for `tokenId` token.
211      *
212      * Requirements:
213      *
214      * - `tokenId` must exist.
215      */
216     function getApproved(uint256 tokenId) external view returns (address operator);
217 
218     /**
219      * @dev Approve or remove `operator` as an operator for the caller.
220      * Operators can call {transferFrom} or {safeTransferFrom} for any token owned by the caller.
221      *
222      * Requirements:
223      *
224      * - The `operator` cannot be the caller.
225      *
226      * Emits an {ApprovalForAll} event.
227      */
228     function setApprovalForAll(address operator, bool _approved) external;
229 
230     /**
231      * @dev Returns if the `operator` is allowed to manage all of the assets of `owner`.
232      *
233      * See {setApprovalForAll}
234      */
235     function isApprovedForAll(address owner, address operator) external view returns (bool);
236 
237     /**
238      * @dev Safely transfers `tokenId` token from `from` to `to`.
239      *
240      * Requirements:
241      *
242      * - `from` cannot be the zero address.
243      * - `to` cannot be the zero address.
244      * - `tokenId` token must exist and be owned by `from`.
245      * - If the caller is not `from`, it must be approved to move this token by either {approve} or {setApprovalForAll}.
246      * - If `to` refers to a smart contract, it must implement {IERC721Receiver-onERC721Received}, which is called upon a safe transfer.
247      *
248      * Emits a {Transfer} event.
249      */
250     function safeTransferFrom(
251         address from,
252         address to,
253         uint256 tokenId,
254         bytes calldata data
255     ) external;
256 }
257 
258 
259 
260 pragma solidity ^0.8.0;
261 
262 /**
263  * @title ERC721 token receiver interface
264  * @dev Interface for any contract that wants to support safeTransfers
265  * from ERC721 asset contracts.
266  */
267 interface IERC721Receiver {
268     /**
269      * @dev Whenever an {IERC721} `tokenId` token is transferred to this contract via {IERC721-safeTransferFrom}
270      * by `operator` from `from`, this function is called.
271      *
272      * It must return its Solidity selector to confirm the token transfer.
273      * If any other value is returned or the interface is not implemented by the recipient, the transfer will be reverted.
274      *
275      * The selector can be obtained in Solidity with `IERC721.onERC721Received.selector`.
276      */
277     function onERC721Received(
278         address operator,
279         address from,
280         uint256 tokenId,
281         bytes calldata data
282     ) external returns (bytes4);
283 }
284 
285 
286 
287 pragma solidity ^0.8.0;
288 
289 
290 
291 /**
292  * @title ERC-721 Non-Fungible Token Standard, optional metadata extension
293  * @dev See https://eips.ethereum.org/EIPS/eip-721
294  */
295 interface IERC721Metadata is IERC721 {
296     /**
297      * @dev Returns the token collection name.
298      */
299     function name() external view returns (string memory);
300 
301     /**
302      * @dev Returns the token collection symbol.
303      */
304     function symbol() external view returns (string memory);
305 
306     /**
307      * @dev Returns the Uniform Resource Identifier (URI) for `tokenId` token.
308      */
309     function tokenURI(uint256 tokenId) external view returns (string memory);
310 }
311 
312 
313 
314 pragma solidity ^0.8.0;
315 
316 /**
317  * @dev Collection of functions related to the address type
318  */
319 library Address {
320     /**
321      * @dev Returns true if `account` is a contract.
322      *
323      * [IMPORTANT]
324      * ====
325      * It is unsafe to assume that an address for which this function returns
326      * false is an externally-owned account (EOA) and not a contract.
327      *
328      * Among others, `isContract` will return false for the following
329      * types of addresses:
330      *
331      *  - an externally-owned account
332      *  - a contract in construction
333      *  - an address where a contract will be created
334      *  - an address where a contract lived, but was destroyed
335      * ====
336      */
337     function isContract(address account) internal view returns (bool) {
338         // This method relies on extcodesize, which returns 0 for contracts in
339         // construction, since the code is only stored at the end of the
340         // constructor execution.
341 
342         uint256 size;
343         assembly {
344             size := extcodesize(account)
345         }
346         return size > 0;
347     }
348 
349     /**
350      * @dev Replacement for Solidity's `transfer`: sends `amount` wei to
351      * `recipient`, forwarding all available gas and reverting on errors.
352      *
353      * https://eips.ethereum.org/EIPS/eip-1884[EIP1884] increases the gas cost
354      * of certain opcodes, possibly making contracts go over the 2300 gas limit
355      * imposed by `transfer`, making them unable to receive funds via
356      * `transfer`. {sendValue} removes this limitation.
357      *
358      * https://diligence.consensys.net/posts/2019/09/stop-using-soliditys-transfer-now/[Learn more].
359      *
360      * IMPORTANT: because control is transferred to `recipient`, care must be
361      * taken to not create reentrancy vulnerabilities. Consider using
362      * {ReentrancyGuard} or the
363      * https://solidity.readthedocs.io/en/v0.5.11/security-considerations.html#use-the-checks-effects-interactions-pattern[checks-effects-interactions pattern].
364      */
365     function sendValue(address payable recipient, uint256 amount) internal {
366         require(address(this).balance >= amount, "Address: insufficient balance");
367 
368         (bool success, ) = recipient.call{value: amount}("");
369         require(success, "Address: unable to send value, recipient may have reverted");
370     }
371 
372     /**
373      * @dev Performs a Solidity function call using a low level `call`. A
374      * plain `call` is an unsafe replacement for a function call: use this
375      * function instead.
376      *
377      * If `target` reverts with a revert reason, it is bubbled up by this
378      * function (like regular Solidity function calls).
379      *
380      * Returns the raw returned data. To convert to the expected return value,
381      * use https://solidity.readthedocs.io/en/latest/units-and-global-variables.html?highlight=abi.decode#abi-encoding-and-decoding-functions[`abi.decode`].
382      *
383      * Requirements:
384      *
385      * - `target` must be a contract.
386      * - calling `target` with `data` must not revert.
387      *
388      * _Available since v3.1._
389      */
390     function functionCall(address target, bytes memory data) internal returns (bytes memory) {
391         return functionCall(target, data, "Address: low-level call failed");
392     }
393 
394     /**
395      * @dev Same as {xref-Address-functionCall-address-bytes-}[`functionCall`], but with
396      * `errorMessage` as a fallback revert reason when `target` reverts.
397      *
398      * _Available since v3.1._
399      */
400     function functionCall(
401         address target,
402         bytes memory data,
403         string memory errorMessage
404     ) internal returns (bytes memory) {
405         return functionCallWithValue(target, data, 0, errorMessage);
406     }
407 
408     /**
409      * @dev Same as {xref-Address-functionCall-address-bytes-}[`functionCall`],
410      * but also transferring `value` wei to `target`.
411      *
412      * Requirements:
413      *
414      * - the calling contract must have an ETH balance of at least `value`.
415      * - the called Solidity function must be `payable`.
416      *
417      * _Available since v3.1._
418      */
419     function functionCallWithValue(
420         address target,
421         bytes memory data,
422         uint256 value
423     ) internal returns (bytes memory) {
424         return functionCallWithValue(target, data, value, "Address: low-level call with value failed");
425     }
426 
427     /**
428      * @dev Same as {xref-Address-functionCallWithValue-address-bytes-uint256-}[`functionCallWithValue`], but
429      * with `errorMessage` as a fallback revert reason when `target` reverts.
430      *
431      * _Available since v3.1._
432      */
433     function functionCallWithValue(
434         address target,
435         bytes memory data,
436         uint256 value,
437         string memory errorMessage
438     ) internal returns (bytes memory) {
439         require(address(this).balance >= value, "Address: insufficient balance for call");
440         require(isContract(target), "Address: call to non-contract");
441 
442         (bool success, bytes memory returndata) = target.call{value: value}(data);
443         return verifyCallResult(success, returndata, errorMessage);
444     }
445 
446     /**
447      * @dev Same as {xref-Address-functionCall-address-bytes-}[`functionCall`],
448      * but performing a static call.
449      *
450      * _Available since v3.3._
451      */
452     function functionStaticCall(address target, bytes memory data) internal view returns (bytes memory) {
453         return functionStaticCall(target, data, "Address: low-level static call failed");
454     }
455 
456     /**
457      * @dev Same as {xref-Address-functionCall-address-bytes-string-}[`functionCall`],
458      * but performing a static call.
459      *
460      * _Available since v3.3._
461      */
462     function functionStaticCall(
463         address target,
464         bytes memory data,
465         string memory errorMessage
466     ) internal view returns (bytes memory) {
467         require(isContract(target), "Address: static call to non-contract");
468 
469         (bool success, bytes memory returndata) = target.staticcall(data);
470         return verifyCallResult(success, returndata, errorMessage);
471     }
472 
473     /**
474      * @dev Same as {xref-Address-functionCall-address-bytes-}[`functionCall`],
475      * but performing a delegate call.
476      *
477      * _Available since v3.4._
478      */
479     function functionDelegateCall(address target, bytes memory data) internal returns (bytes memory) {
480         return functionDelegateCall(target, data, "Address: low-level delegate call failed");
481     }
482 
483     /**
484      * @dev Same as {xref-Address-functionCall-address-bytes-string-}[`functionCall`],
485      * but performing a delegate call.
486      *
487      * _Available since v3.4._
488      */
489     function functionDelegateCall(
490         address target,
491         bytes memory data,
492         string memory errorMessage
493     ) internal returns (bytes memory) {
494         require(isContract(target), "Address: delegate call to non-contract");
495 
496         (bool success, bytes memory returndata) = target.delegatecall(data);
497         return verifyCallResult(success, returndata, errorMessage);
498     }
499 
500     /**
501      * @dev Tool to verifies that a low level call was successful, and revert if it wasn't, either by bubbling the
502      * revert reason using the provided one.
503      *
504      * _Available since v4.3._
505      */
506     function verifyCallResult(
507         bool success,
508         bytes memory returndata,
509         string memory errorMessage
510     ) internal pure returns (bytes memory) {
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
533 pragma solidity ^0.8.0;
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
962 
963 pragma solidity ^0.8.0;
964 
965 
966 
967 
968 pragma solidity ^0.8.0;
969 
970 
971 
972 /**
973  * @title ERC-721 Non-Fungible Token Standard, optional enumeration extension
974  * @dev See https://eips.ethereum.org/EIPS/eip-721
975  */
976 interface IERC721Enumerable is IERC721 {
977     /**
978      * @dev Returns the total amount of tokens stored by the contract.
979      */
980     function totalSupply() external view returns (uint256);
981 
982     /**
983      * @dev Returns a token ID owned by `owner` at a given `index` of its token list.
984      * Use along with {balanceOf} to enumerate all of ``owner``'s tokens.
985      */
986     function tokenOfOwnerByIndex(address owner, uint256 index) external view returns (uint256 tokenId);
987 
988     /**
989      * @dev Returns a token ID at a given `index` of all the tokens stored by the contract.
990      * Use along with {totalSupply} to enumerate all tokens.
991      */
992     function tokenByIndex(uint256 index) external view returns (uint256);
993 }
994 
995 
996 /**
997  * @dev This implements an optional extension of {ERC721} defined in the EIP that adds
998  * enumerability of all the token ids in the contract as well as all token ids owned by each
999  * account.
1000  */
1001 abstract contract ERC721Enumerable is ERC721, IERC721Enumerable {
1002     // Mapping from owner to list of owned token IDs
1003     mapping(address => mapping(uint256 => uint256)) private _ownedTokens;
1004 
1005     // Mapping from token ID to index of the owner tokens list
1006     mapping(uint256 => uint256) private _ownedTokensIndex;
1007 
1008     // Array with all token ids, used for enumeration
1009     uint256[] private _allTokens;
1010 
1011     // Mapping from token id to position in the allTokens array
1012     mapping(uint256 => uint256) private _allTokensIndex;
1013 
1014     /**
1015      * @dev See {IERC165-supportsInterface}.
1016      */
1017     function supportsInterface(bytes4 interfaceId) public view virtual override(IERC165, ERC721) returns (bool) {
1018         return interfaceId == type(IERC721Enumerable).interfaceId || super.supportsInterface(interfaceId);
1019     }
1020 
1021     /**
1022      * @dev See {IERC721Enumerable-tokenOfOwnerByIndex}.
1023      */
1024     function tokenOfOwnerByIndex(address owner, uint256 index) public view virtual override returns (uint256) {
1025         require(index < ERC721.balanceOf(owner), "ERC721Enumerable: owner index out of bounds");
1026         return _ownedTokens[owner][index];
1027     }
1028 
1029     /**
1030      * @dev See {IERC721Enumerable-totalSupply}.
1031      */
1032     function totalSupply() public view virtual override returns (uint256) {
1033         return _allTokens.length;
1034     }
1035 
1036     /**
1037      * @dev See {IERC721Enumerable-tokenByIndex}.
1038      */
1039     function tokenByIndex(uint256 index) public view virtual override returns (uint256) {
1040         require(index < ERC721Enumerable.totalSupply(), "ERC721Enumerable: global index out of bounds");
1041         return _allTokens[index];
1042     }
1043 
1044     /**
1045      * @dev Hook that is called before any token transfer. This includes minting
1046      * and burning.
1047      *
1048      * Calling conditions:
1049      *
1050      * - When `from` and `to` are both non-zero, ``from``'s `tokenId` will be
1051      * transferred to `to`.
1052      * - When `from` is zero, `tokenId` will be minted for `to`.
1053      * - When `to` is zero, ``from``'s `tokenId` will be burned.
1054      * - `from` cannot be the zero address.
1055      * - `to` cannot be the zero address.
1056      *
1057      * To learn more about hooks, head to xref:ROOT:extending-contracts.adoc#using-hooks[Using Hooks].
1058      */
1059     function _beforeTokenTransfer(
1060         address from,
1061         address to,
1062         uint256 tokenId
1063     ) internal virtual override {
1064         super._beforeTokenTransfer(from, to, tokenId);
1065 
1066         if (from == address(0)) {
1067             _addTokenToAllTokensEnumeration(tokenId);
1068         } else if (from != to) {
1069             _removeTokenFromOwnerEnumeration(from, tokenId);
1070         }
1071         if (to == address(0)) {
1072             _removeTokenFromAllTokensEnumeration(tokenId);
1073         } else if (to != from) {
1074             _addTokenToOwnerEnumeration(to, tokenId);
1075         }
1076     }
1077 
1078     /**
1079      * @dev Private function to add a token to this extension's ownership-tracking data structures.
1080      * @param to address representing the new owner of the given token ID
1081      * @param tokenId uint256 ID of the token to be added to the tokens list of the given address
1082      */
1083     function _addTokenToOwnerEnumeration(address to, uint256 tokenId) private {
1084         uint256 length = ERC721.balanceOf(to);
1085         _ownedTokens[to][length] = tokenId;
1086         _ownedTokensIndex[tokenId] = length;
1087     }
1088 
1089     /**
1090      * @dev Private function to add a token to this extension's token tracking data structures.
1091      * @param tokenId uint256 ID of the token to be added to the tokens list
1092      */
1093     function _addTokenToAllTokensEnumeration(uint256 tokenId) private {
1094         _allTokensIndex[tokenId] = _allTokens.length;
1095         _allTokens.push(tokenId);
1096     }
1097 
1098     /**
1099      * @dev Private function to remove a token from this extension's ownership-tracking data structures. Note that
1100      * while the token is not assigned a new owner, the `_ownedTokensIndex` mapping is _not_ updated: this allows for
1101      * gas optimizations e.g. when performing a transfer operation (avoiding double writes).
1102      * This has O(1) time complexity, but alters the order of the _ownedTokens array.
1103      * @param from address representing the previous owner of the given token ID
1104      * @param tokenId uint256 ID of the token to be removed from the tokens list of the given address
1105      */
1106     function _removeTokenFromOwnerEnumeration(address from, uint256 tokenId) private {
1107         // To prevent a gap in from's tokens array, we store the last token in the index of the token to delete, and
1108         // then delete the last slot (swap and pop).
1109 
1110         uint256 lastTokenIndex = ERC721.balanceOf(from) - 1;
1111         uint256 tokenIndex = _ownedTokensIndex[tokenId];
1112 
1113         // When the token to delete is the last token, the swap operation is unnecessary
1114         if (tokenIndex != lastTokenIndex) {
1115             uint256 lastTokenId = _ownedTokens[from][lastTokenIndex];
1116 
1117             _ownedTokens[from][tokenIndex] = lastTokenId; // Move the last token to the slot of the to-delete token
1118             _ownedTokensIndex[lastTokenId] = tokenIndex; // Update the moved token's index
1119         }
1120 
1121         // This also deletes the contents at the last position of the array
1122         delete _ownedTokensIndex[tokenId];
1123         delete _ownedTokens[from][lastTokenIndex];
1124     }
1125 
1126     /**
1127      * @dev Private function to remove a token from this extension's token tracking data structures.
1128      * This has O(1) time complexity, but alters the order of the _allTokens array.
1129      * @param tokenId uint256 ID of the token to be removed from the tokens list
1130      */
1131     function _removeTokenFromAllTokensEnumeration(uint256 tokenId) private {
1132         // To prevent a gap in the tokens array, we store the last token in the index of the token to delete, and
1133         // then delete the last slot (swap and pop).
1134 
1135         uint256 lastTokenIndex = _allTokens.length - 1;
1136         uint256 tokenIndex = _allTokensIndex[tokenId];
1137 
1138         // When the token to delete is the last token, the swap operation is unnecessary. However, since this occurs so
1139         // rarely (when the last minted token is burnt) that we still do the swap here to avoid the gas cost of adding
1140         // an 'if' statement (like in _removeTokenFromOwnerEnumeration)
1141         uint256 lastTokenId = _allTokens[lastTokenIndex];
1142 
1143         _allTokens[tokenIndex] = lastTokenId; // Move the last token to the slot of the to-delete token
1144         _allTokensIndex[lastTokenId] = tokenIndex; // Update the moved token's index
1145 
1146         // This also deletes the contents at the last position of the array
1147         delete _allTokensIndex[tokenId];
1148         _allTokens.pop();
1149     }
1150 }
1151 
1152 
1153 
1154 pragma solidity ^0.8.0;
1155 
1156 
1157 
1158 /**
1159  * @dev Contract module which provides a basic access control mechanism, where
1160  * there is an account (an owner) that can be granted exclusive access to
1161  * specific functions.
1162  *
1163  * By default, the owner account will be the one that deploys the contract. This
1164  * can later be changed with {transferOwnership}.
1165  *
1166  * This module is used through inheritance. It will make available the modifier
1167  * `onlyOwner`, which can be applied to your functions to restrict their use to
1168  * the owner.
1169  */
1170 abstract contract Ownable is Context {
1171     address private _owner;
1172 
1173     event OwnershipTransferred(address indexed previousOwner, address indexed newOwner);
1174 
1175     /**
1176      * @dev Initializes the contract setting the deployer as the initial owner.
1177      */
1178     constructor() {
1179         _setOwner(_msgSender());
1180     }
1181 
1182     /**
1183      * @dev Returns the address of the current owner.
1184      */
1185     function owner() public view virtual returns (address) {
1186         return _owner;
1187     }
1188 
1189     /**
1190      * @dev Throws if called by any account other than the owner.
1191      */
1192     modifier onlyOwner() {
1193         require(owner() == _msgSender(), "Ownable: caller is not the owner");
1194         _;
1195     }
1196 
1197     /**
1198      * @dev Leaves the contract without owner. It will not be possible to call
1199      * `onlyOwner` functions anymore. Can only be called by the current owner.
1200      *
1201      * NOTE: Renouncing ownership will leave the contract without an owner,
1202      * thereby removing any functionality that is only available to the owner.
1203      */
1204     function renounceOwnership() public virtual onlyOwner {
1205         _setOwner(address(0));
1206     }
1207 
1208     /**
1209      * @dev Transfers ownership of the contract to a new account (`newOwner`).
1210      * Can only be called by the current owner.
1211      */
1212     function transferOwnership(address newOwner) public virtual onlyOwner {
1213         require(newOwner != address(0), "Ownable: new owner is the zero address");
1214         _setOwner(newOwner);
1215     }
1216 
1217     function _setOwner(address newOwner) private {
1218         address oldOwner = _owner;
1219         _owner = newOwner;
1220         emit OwnershipTransferred(oldOwner, newOwner);
1221     }
1222 }
1223 
1224 
1225 
1226 pragma solidity ^0.8.0;
1227 
1228 // CAUTION
1229 // This version of SafeMath should only be used with Solidity 0.8 or later,
1230 // because it relies on the compiler's built in overflow checks.
1231 
1232 /**
1233  * @dev Wrappers over Solidity's arithmetic operations.
1234  *
1235  * NOTE: `SafeMath` is no longer needed starting with Solidity 0.8. The compiler
1236  * now has built in overflow checking.
1237  */
1238 library SafeMath {
1239     /**
1240      * @dev Returns the addition of two unsigned integers, with an overflow flag.
1241      *
1242      * _Available since v3.4._
1243      */
1244     function tryAdd(uint256 a, uint256 b) internal pure returns (bool, uint256) {
1245         unchecked {
1246             uint256 c = a + b;
1247             if (c < a) return (false, 0);
1248             return (true, c);
1249         }
1250     }
1251 
1252     /**
1253      * @dev Returns the substraction of two unsigned integers, with an overflow flag.
1254      *
1255      * _Available since v3.4._
1256      */
1257     function trySub(uint256 a, uint256 b) internal pure returns (bool, uint256) {
1258         unchecked {
1259             if (b > a) return (false, 0);
1260             return (true, a - b);
1261         }
1262     }
1263 
1264     /**
1265      * @dev Returns the multiplication of two unsigned integers, with an overflow flag.
1266      *
1267      * _Available since v3.4._
1268      */
1269     function tryMul(uint256 a, uint256 b) internal pure returns (bool, uint256) {
1270         unchecked {
1271             // Gas optimization: this is cheaper than requiring 'a' not being zero, but the
1272             // benefit is lost if 'b' is also tested.
1273             // See: https://github.com/OpenZeppelin/openzeppelin-contracts/pull/522
1274             if (a == 0) return (true, 0);
1275             uint256 c = a * b;
1276             if (c / a != b) return (false, 0);
1277             return (true, c);
1278         }
1279     }
1280 
1281     /**
1282      * @dev Returns the division of two unsigned integers, with a division by zero flag.
1283      *
1284      * _Available since v3.4._
1285      */
1286     function tryDiv(uint256 a, uint256 b) internal pure returns (bool, uint256) {
1287         unchecked {
1288             if (b == 0) return (false, 0);
1289             return (true, a / b);
1290         }
1291     }
1292 
1293     /**
1294      * @dev Returns the remainder of dividing two unsigned integers, with a division by zero flag.
1295      *
1296      * _Available since v3.4._
1297      */
1298     function tryMod(uint256 a, uint256 b) internal pure returns (bool, uint256) {
1299         unchecked {
1300             if (b == 0) return (false, 0);
1301             return (true, a % b);
1302         }
1303     }
1304 
1305     /**
1306      * @dev Returns the addition of two unsigned integers, reverting on
1307      * overflow.
1308      *
1309      * Counterpart to Solidity's `+` operator.
1310      *
1311      * Requirements:
1312      *
1313      * - Addition cannot overflow.
1314      */
1315     function add(uint256 a, uint256 b) internal pure returns (uint256) {
1316         return a + b;
1317     }
1318 
1319     /**
1320      * @dev Returns the subtraction of two unsigned integers, reverting on
1321      * overflow (when the result is negative).
1322      *
1323      * Counterpart to Solidity's `-` operator.
1324      *
1325      * Requirements:
1326      *
1327      * - Subtraction cannot overflow.
1328      */
1329     function sub(uint256 a, uint256 b) internal pure returns (uint256) {
1330         return a - b;
1331     }
1332 
1333     /**
1334      * @dev Returns the multiplication of two unsigned integers, reverting on
1335      * overflow.
1336      *
1337      * Counterpart to Solidity's `*` operator.
1338      *
1339      * Requirements:
1340      *
1341      * - Multiplication cannot overflow.
1342      */
1343     function mul(uint256 a, uint256 b) internal pure returns (uint256) {
1344         return a * b;
1345     }
1346 
1347     /**
1348      * @dev Returns the integer division of two unsigned integers, reverting on
1349      * division by zero. The result is rounded towards zero.
1350      *
1351      * Counterpart to Solidity's `/` operator.
1352      *
1353      * Requirements:
1354      *
1355      * - The divisor cannot be zero.
1356      */
1357     function div(uint256 a, uint256 b) internal pure returns (uint256) {
1358         return a / b;
1359     }
1360 
1361     /**
1362      * @dev Returns the remainder of dividing two unsigned integers. (unsigned integer modulo),
1363      * reverting when dividing by zero.
1364      *
1365      * Counterpart to Solidity's `%` operator. This function uses a `revert`
1366      * opcode (which leaves remaining gas untouched) while Solidity uses an
1367      * invalid opcode to revert (consuming all remaining gas).
1368      *
1369      * Requirements:
1370      *
1371      * - The divisor cannot be zero.
1372      */
1373     function mod(uint256 a, uint256 b) internal pure returns (uint256) {
1374         return a % b;
1375     }
1376 
1377     /**
1378      * @dev Returns the subtraction of two unsigned integers, reverting with custom message on
1379      * overflow (when the result is negative).
1380      *
1381      * CAUTION: This function is deprecated because it requires allocating memory for the error
1382      * message unnecessarily. For custom revert reasons use {trySub}.
1383      *
1384      * Counterpart to Solidity's `-` operator.
1385      *
1386      * Requirements:
1387      *
1388      * - Subtraction cannot overflow.
1389      */
1390     function sub(
1391         uint256 a,
1392         uint256 b,
1393         string memory errorMessage
1394     ) internal pure returns (uint256) {
1395         unchecked {
1396             require(b <= a, errorMessage);
1397             return a - b;
1398         }
1399     }
1400 
1401     /**
1402      * @dev Returns the integer division of two unsigned integers, reverting with custom message on
1403      * division by zero. The result is rounded towards zero.
1404      *
1405      * Counterpart to Solidity's `/` operator. Note: this function uses a
1406      * `revert` opcode (which leaves remaining gas untouched) while Solidity
1407      * uses an invalid opcode to revert (consuming all remaining gas).
1408      *
1409      * Requirements:
1410      *
1411      * - The divisor cannot be zero.
1412      */
1413     function div(
1414         uint256 a,
1415         uint256 b,
1416         string memory errorMessage
1417     ) internal pure returns (uint256) {
1418         unchecked {
1419             require(b > 0, errorMessage);
1420             return a / b;
1421         }
1422     }
1423 
1424     /**
1425      * @dev Returns the remainder of dividing two unsigned integers. (unsigned integer modulo),
1426      * reverting with custom message when dividing by zero.
1427      *
1428      * CAUTION: This function is deprecated because it requires allocating memory for the error
1429      * message unnecessarily. For custom revert reasons use {tryMod}.
1430      *
1431      * Counterpart to Solidity's `%` operator. This function uses a `revert`
1432      * opcode (which leaves remaining gas untouched) while Solidity uses an
1433      * invalid opcode to revert (consuming all remaining gas).
1434      *
1435      * Requirements:
1436      *
1437      * - The divisor cannot be zero.
1438      */
1439     function mod(
1440         uint256 a,
1441         uint256 b,
1442         string memory errorMessage
1443     ) internal pure returns (uint256) {
1444         unchecked {
1445             require(b > 0, errorMessage);
1446             return a % b;
1447         }
1448     }
1449 }
1450 
1451 
1452  contract JAN is ERC721Enumerable, Ownable {
1453     using SafeMath for uint256;
1454     using Address for address;
1455     
1456     string private PROVENANCE;
1457     string private baseURI;
1458     
1459     uint256 public maxSupply;
1460     uint256 public price = 0.07 ether;
1461 
1462     bool public presaleActive = false;
1463     bool public saleActive = false;
1464 
1465     mapping (address => uint256) public presaleWhitelist;
1466     
1467     //map team addresses 
1468     
1469     address private constant DVAddress = 0x2e302a91D01183F4F3966AbDA0D16d79BbaF0A4D;//DEV
1470     address private constant SAddress = 0xc8F56c0c1DE72Ba21e4237f5667960a79ca049b9;
1471     address private constant JAddress = 0x5e675243b30ADbA95cA65B82ec4918567D85CcD6;
1472     address private constant RAddress = 0xC45589FfF5dc6C9455EEbc140ab7b2020Ffd1840;
1473     address private constant R1Address = 0xADda99Ac13133A49e9FB5c25C9107613a5f16463;
1474     address private constant ATAddress = 0xcbcD316d1cd48F70f0D59D92B7bc25d1d28f8a9a;
1475     address private constant ABAddress = 0x18378F8df9240C62076e497A8366b4e5d1a7beEC;
1476     address private constant MMAddress = 0x2Fe62d7bFF2eb961fd2dDB86D49026a5d43bcEC9;
1477     
1478 
1479     constructor(string memory name, string memory symbol, uint256 supply) ERC721(name, symbol) {
1480         maxSupply = supply;
1481     }
1482     
1483     function reserve() public onlyOwner {
1484         uint256 supply = totalSupply();
1485         for (uint256 i = 0; i < 154; i++) {
1486             _safeMint(msg.sender, supply + i);
1487         }
1488     }
1489 
1490     function mintPresale(uint256 numberOfMints) public payable {
1491         uint256 supply = totalSupply();
1492         uint256 reserved = presaleWhitelist[msg.sender];
1493         require(presaleActive,                              "Presale must be active to mint");
1494         require(reserved > 0,                               "No tokens reserved for this address");
1495         require(numberOfMints <= reserved,                  "Can't mint more than reserved");
1496         require(supply.add(numberOfMints) <= maxSupply,     "Purchase would exceed max supply of tokens");
1497         require(price.mul(numberOfMints) == msg.value,      "Ether value sent is not correct");
1498         presaleWhitelist[msg.sender] = reserved - numberOfMints;
1499 
1500         for(uint256 i; i < numberOfMints; i++){
1501             _safeMint( msg.sender, supply + i );
1502         }
1503     }
1504     
1505     function mint(uint256 numberOfMints) public payable {
1506         uint256 supply = totalSupply();
1507         require(saleActive,                                 "Sale must be active to mint");
1508         require(numberOfMints > 0 && numberOfMints < 100,    "Invalid purchase amount");
1509         require(supply.add(numberOfMints) <= maxSupply,     "Purchase would exceed max supply of tokens");
1510         require(price.mul(numberOfMints) == msg.value,      "Ether value sent is not correct");
1511         
1512         for(uint256 i; i < numberOfMints; i++) {
1513             _safeMint(msg.sender, supply + i);
1514         }
1515     }
1516 
1517     function editPresale(address[] calldata presaleAddresses, uint256[] calldata amount) public onlyOwner {
1518         for(uint256 i; i < presaleAddresses.length; i++){
1519             presaleWhitelist[presaleAddresses[i]] = amount[i];
1520         }
1521     }
1522     
1523     function walletOfOwner(address owner) external view returns(uint256[] memory) {
1524         uint256 tokenCount = balanceOf(owner);
1525 
1526         uint256[] memory tokensId = new uint256[](tokenCount);
1527         for(uint256 i; i < tokenCount; i++){
1528             tokensId[i] = tokenOfOwnerByIndex(owner, i);
1529         }
1530         return tokensId;
1531     }
1532     
1533     function withdrawAll() public payable onlyOwner {
1534         uint256 balance = address(this).balance;
1535 
1536         require(balance > 0);
1537         _withdraw(DVAddress, balance.mul(1000).div(10000));
1538         _withdraw(SAddress, balance.mul(875).div(10000));
1539         _withdraw(JAddress, balance.mul(775).div(10000));
1540         _withdraw(RAddress, balance.mul(1125).div(10000));
1541         _withdraw(R1Address, balance.mul(775).div(10000));
1542         _withdraw(ATAddress, balance.mul(1750).div(10000));
1543         _withdraw(ABAddress, balance.mul(700).div(10000));
1544         _withdraw(MMAddress, balance.mul(3000).div(10000));
1545     }
1546 
1547      function _withdraw(address _address, uint256 _amount) private {
1548         (bool success, ) = _address.call{value: _amount}("");
1549         require(success, "Transfer failed.");
1550     }
1551 
1552     function togglePresale() public onlyOwner {
1553         presaleActive = !presaleActive;
1554     }
1555 
1556     function toggleSale() public onlyOwner {
1557         saleActive = !saleActive;
1558     }
1559 
1560     function setPrice(uint256 newPrice) public onlyOwner {
1561         price = newPrice;
1562     }
1563 
1564 
1565     function setProvenance(string memory provenance) private onlyOwner {
1566         PROVENANCE = provenance;
1567     }
1568     
1569     function setBaseURI(string memory uri) public onlyOwner {
1570         baseURI = uri;
1571     }
1572     
1573     function _baseURI() internal view override returns (string memory) {
1574         return baseURI;
1575     }
1576 }