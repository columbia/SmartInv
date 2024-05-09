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
449         return verifyCallResult(success, returndata, errorMessage);
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
476         return verifyCallResult(success, returndata, errorMessage);
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
503         return verifyCallResult(success, returndata, errorMessage);
504     }
505 
506     /**
507      * @dev Tool to verifies that a low level call was successful, and revert if it wasn't, either by bubbling the
508      * revert reason using the provided one.
509      *
510      * _Available since v4.3._
511      */
512     function verifyCallResult(
513         bool success,
514         bytes memory returndata,
515         string memory errorMessage
516     ) internal pure returns (bytes memory) {
517         if (success) {
518             return returndata;
519         } else {
520             // Look for revert reason and bubble it up if present
521             if (returndata.length > 0) {
522                 // The easiest way to bubble the revert reason is using memory via assembly
523 
524                 assembly {
525                     let returndata_size := mload(returndata)
526                     revert(add(32, returndata), returndata_size)
527                 }
528             } else {
529                 revert(errorMessage);
530             }
531         }
532     }
533 }
534 
535 
536 
537 
538 
539 
540 
541 
542 
543 /**
544  * @dev Implementation of the {IERC165} interface.
545  *
546  * Contracts that want to implement ERC165 should inherit from this contract and override {supportsInterface} to check
547  * for the additional interface id that will be supported. For example:
548  *
549  * ```solidity
550  * function supportsInterface(bytes4 interfaceId) public view virtual override returns (bool) {
551  *     return interfaceId == type(MyInterface).interfaceId || super.supportsInterface(interfaceId);
552  * }
553  * ```
554  *
555  * Alternatively, {ERC165Storage} provides an easier to use but more expensive implementation.
556  */
557 abstract contract ERC165 is IERC165 {
558     /**
559      * @dev See {IERC165-supportsInterface}.
560      */
561     function supportsInterface(bytes4 interfaceId) public view virtual override returns (bool) {
562         return interfaceId == type(IERC165).interfaceId;
563     }
564 }
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
968 
969 
970 
971 
972 
973 
974 
975 
976 
977 
978 /**
979  * @title ERC-721 Non-Fungible Token Standard, optional enumeration extension
980  * @dev See https://eips.ethereum.org/EIPS/eip-721
981  */
982 interface IERC721Enumerable is IERC721 {
983     /**
984      * @dev Returns the total amount of tokens stored by the contract.
985      */
986     function totalSupply() external view returns (uint256);
987 
988     /**
989      * @dev Returns a token ID owned by `owner` at a given `index` of its token list.
990      * Use along with {balanceOf} to enumerate all of ``owner``'s tokens.
991      */
992     function tokenOfOwnerByIndex(address owner, uint256 index) external view returns (uint256 tokenId);
993 
994     /**
995      * @dev Returns a token ID at a given `index` of all the tokens stored by the contract.
996      * Use along with {totalSupply} to enumerate all tokens.
997      */
998     function tokenByIndex(uint256 index) external view returns (uint256);
999 }
1000 
1001 
1002 /**
1003  * @dev This implements an optional extension of {ERC721} defined in the EIP that adds
1004  * enumerability of all the token ids in the contract as well as all token ids owned by each
1005  * account.
1006  */
1007 abstract contract ERC721Enumerable is ERC721, IERC721Enumerable {
1008     // Mapping from owner to list of owned token IDs
1009     mapping(address => mapping(uint256 => uint256)) private _ownedTokens;
1010 
1011     // Mapping from token ID to index of the owner tokens list
1012     mapping(uint256 => uint256) private _ownedTokensIndex;
1013 
1014     // Array with all token ids, used for enumeration
1015     uint256[] private _allTokens;
1016 
1017     // Mapping from token id to position in the allTokens array
1018     mapping(uint256 => uint256) private _allTokensIndex;
1019 
1020     /**
1021      * @dev See {IERC165-supportsInterface}.
1022      */
1023     function supportsInterface(bytes4 interfaceId) public view virtual override(IERC165, ERC721) returns (bool) {
1024         return interfaceId == type(IERC721Enumerable).interfaceId || super.supportsInterface(interfaceId);
1025     }
1026 
1027     /**
1028      * @dev See {IERC721Enumerable-tokenOfOwnerByIndex}.
1029      */
1030     function tokenOfOwnerByIndex(address owner, uint256 index) public view virtual override returns (uint256) {
1031         require(index < ERC721.balanceOf(owner), "ERC721Enumerable: owner index out of bounds");
1032         return _ownedTokens[owner][index];
1033     }
1034 
1035     /**
1036      * @dev See {IERC721Enumerable-totalSupply}.
1037      */
1038     function totalSupply() public view virtual override returns (uint256) {
1039         return _allTokens.length;
1040     }
1041 
1042     /**
1043      * @dev See {IERC721Enumerable-tokenByIndex}.
1044      */
1045     function tokenByIndex(uint256 index) public view virtual override returns (uint256) {
1046         require(index < ERC721Enumerable.totalSupply(), "ERC721Enumerable: global index out of bounds");
1047         return _allTokens[index];
1048     }
1049 
1050     /**
1051      * @dev Hook that is called before any token transfer. This includes minting
1052      * and burning.
1053      *
1054      * Calling conditions:
1055      *
1056      * - When `from` and `to` are both non-zero, ``from``'s `tokenId` will be
1057      * transferred to `to`.
1058      * - When `from` is zero, `tokenId` will be minted for `to`.
1059      * - When `to` is zero, ``from``'s `tokenId` will be burned.
1060      * - `from` cannot be the zero address.
1061      * - `to` cannot be the zero address.
1062      *
1063      * To learn more about hooks, head to xref:ROOT:extending-contracts.adoc#using-hooks[Using Hooks].
1064      */
1065     function _beforeTokenTransfer(
1066         address from,
1067         address to,
1068         uint256 tokenId
1069     ) internal virtual override {
1070         super._beforeTokenTransfer(from, to, tokenId);
1071 
1072         if (from == address(0)) {
1073             _addTokenToAllTokensEnumeration(tokenId);
1074         } else if (from != to) {
1075             _removeTokenFromOwnerEnumeration(from, tokenId);
1076         }
1077         if (to == address(0)) {
1078             _removeTokenFromAllTokensEnumeration(tokenId);
1079         } else if (to != from) {
1080             _addTokenToOwnerEnumeration(to, tokenId);
1081         }
1082     }
1083 
1084     /**
1085      * @dev Private function to add a token to this extension's ownership-tracking data structures.
1086      * @param to address representing the new owner of the given token ID
1087      * @param tokenId uint256 ID of the token to be added to the tokens list of the given address
1088      */
1089     function _addTokenToOwnerEnumeration(address to, uint256 tokenId) private {
1090         uint256 length = ERC721.balanceOf(to);
1091         _ownedTokens[to][length] = tokenId;
1092         _ownedTokensIndex[tokenId] = length;
1093     }
1094 
1095     /**
1096      * @dev Private function to add a token to this extension's token tracking data structures.
1097      * @param tokenId uint256 ID of the token to be added to the tokens list
1098      */
1099     function _addTokenToAllTokensEnumeration(uint256 tokenId) private {
1100         _allTokensIndex[tokenId] = _allTokens.length;
1101         _allTokens.push(tokenId);
1102     }
1103 
1104     /**
1105      * @dev Private function to remove a token from this extension's ownership-tracking data structures. Note that
1106      * while the token is not assigned a new owner, the `_ownedTokensIndex` mapping is _not_ updated: this allows for
1107      * gas optimizations e.g. when performing a transfer operation (avoiding double writes).
1108      * This has O(1) time complexity, but alters the order of the _ownedTokens array.
1109      * @param from address representing the previous owner of the given token ID
1110      * @param tokenId uint256 ID of the token to be removed from the tokens list of the given address
1111      */
1112     function _removeTokenFromOwnerEnumeration(address from, uint256 tokenId) private {
1113         // To prevent a gap in from's tokens array, we store the last token in the index of the token to delete, and
1114         // then delete the last slot (swap and pop).
1115 
1116         uint256 lastTokenIndex = ERC721.balanceOf(from) - 1;
1117         uint256 tokenIndex = _ownedTokensIndex[tokenId];
1118 
1119         // When the token to delete is the last token, the swap operation is unnecessary
1120         if (tokenIndex != lastTokenIndex) {
1121             uint256 lastTokenId = _ownedTokens[from][lastTokenIndex];
1122 
1123             _ownedTokens[from][tokenIndex] = lastTokenId; // Move the last token to the slot of the to-delete token
1124             _ownedTokensIndex[lastTokenId] = tokenIndex; // Update the moved token's index
1125         }
1126 
1127         // This also deletes the contents at the last position of the array
1128         delete _ownedTokensIndex[tokenId];
1129         delete _ownedTokens[from][lastTokenIndex];
1130     }
1131 
1132     /**
1133      * @dev Private function to remove a token from this extension's token tracking data structures.
1134      * This has O(1) time complexity, but alters the order of the _allTokens array.
1135      * @param tokenId uint256 ID of the token to be removed from the tokens list
1136      */
1137     function _removeTokenFromAllTokensEnumeration(uint256 tokenId) private {
1138         // To prevent a gap in the tokens array, we store the last token in the index of the token to delete, and
1139         // then delete the last slot (swap and pop).
1140 
1141         uint256 lastTokenIndex = _allTokens.length - 1;
1142         uint256 tokenIndex = _allTokensIndex[tokenId];
1143 
1144         // When the token to delete is the last token, the swap operation is unnecessary. However, since this occurs so
1145         // rarely (when the last minted token is burnt) that we still do the swap here to avoid the gas cost of adding
1146         // an 'if' statement (like in _removeTokenFromOwnerEnumeration)
1147         uint256 lastTokenId = _allTokens[lastTokenIndex];
1148 
1149         _allTokens[tokenIndex] = lastTokenId; // Move the last token to the slot of the to-delete token
1150         _allTokensIndex[lastTokenId] = tokenIndex; // Update the moved token's index
1151 
1152         // This also deletes the contents at the last position of the array
1153         delete _allTokensIndex[tokenId];
1154         _allTokens.pop();
1155     }
1156 }
1157 
1158 
1159 
1160 
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
1231 
1232 
1233 
1234 /**
1235  * @dev Elliptic Curve Digital Signature Algorithm (ECDSA) operations.
1236  *
1237  * These functions can be used to verify that a message was signed by the holder
1238  * of the private keys of a given address.
1239  */
1240 library ECDSA {
1241     enum RecoverError {
1242         NoError,
1243         InvalidSignature,
1244         InvalidSignatureLength,
1245         InvalidSignatureS,
1246         InvalidSignatureV
1247     }
1248 
1249     function _throwError(RecoverError error) private pure {
1250         if (error == RecoverError.NoError) {
1251             return; // no error: do nothing
1252         } else if (error == RecoverError.InvalidSignature) {
1253             revert("ECDSA: invalid signature");
1254         } else if (error == RecoverError.InvalidSignatureLength) {
1255             revert("ECDSA: invalid signature length");
1256         } else if (error == RecoverError.InvalidSignatureS) {
1257             revert("ECDSA: invalid signature 's' value");
1258         } else if (error == RecoverError.InvalidSignatureV) {
1259             revert("ECDSA: invalid signature 'v' value");
1260         }
1261     }
1262 
1263     /**
1264      * @dev Returns the address that signed a hashed message (`hash`) with
1265      * `signature` or error string. This address can then be used for verification purposes.
1266      *
1267      * The `ecrecover` EVM opcode allows for malleable (non-unique) signatures:
1268      * this function rejects them by requiring the `s` value to be in the lower
1269      * half order, and the `v` value to be either 27 or 28.
1270      *
1271      * IMPORTANT: `hash` _must_ be the result of a hash operation for the
1272      * verification to be secure: it is possible to craft signatures that
1273      * recover to arbitrary addresses for non-hashed data. A safe way to ensure
1274      * this is by receiving a hash of the original message (which may otherwise
1275      * be too long), and then calling {toEthSignedMessageHash} on it.
1276      *
1277      * Documentation for signature generation:
1278      * - with https://web3js.readthedocs.io/en/v1.3.4/web3-eth-accounts.html#sign[Web3.js]
1279      * - with https://docs.ethers.io/v5/api/signer/#Signer-signMessage[ethers]
1280      *
1281      * _Available since v4.3._
1282      */
1283     function tryRecover(bytes32 hash, bytes memory signature) internal pure returns (address, RecoverError) {
1284         // Check the signature length
1285         // - case 65: r,s,v signature (standard)
1286         // - case 64: r,vs signature (cf https://eips.ethereum.org/EIPS/eip-2098) _Available since v4.1._
1287         if (signature.length == 65) {
1288             bytes32 r;
1289             bytes32 s;
1290             uint8 v;
1291             // ecrecover takes the signature parameters, and the only way to get them
1292             // currently is to use assembly.
1293             assembly {
1294                 r := mload(add(signature, 0x20))
1295                 s := mload(add(signature, 0x40))
1296                 v := byte(0, mload(add(signature, 0x60)))
1297             }
1298             return tryRecover(hash, v, r, s);
1299         } else if (signature.length == 64) {
1300             bytes32 r;
1301             bytes32 vs;
1302             // ecrecover takes the signature parameters, and the only way to get them
1303             // currently is to use assembly.
1304             assembly {
1305                 r := mload(add(signature, 0x20))
1306                 vs := mload(add(signature, 0x40))
1307             }
1308             return tryRecover(hash, r, vs);
1309         } else {
1310             return (address(0), RecoverError.InvalidSignatureLength);
1311         }
1312     }
1313 
1314     /**
1315      * @dev Returns the address that signed a hashed message (`hash`) with
1316      * `signature`. This address can then be used for verification purposes.
1317      *
1318      * The `ecrecover` EVM opcode allows for malleable (non-unique) signatures:
1319      * this function rejects them by requiring the `s` value to be in the lower
1320      * half order, and the `v` value to be either 27 or 28.
1321      *
1322      * IMPORTANT: `hash` _must_ be the result of a hash operation for the
1323      * verification to be secure: it is possible to craft signatures that
1324      * recover to arbitrary addresses for non-hashed data. A safe way to ensure
1325      * this is by receiving a hash of the original message (which may otherwise
1326      * be too long), and then calling {toEthSignedMessageHash} on it.
1327      */
1328     function recover(bytes32 hash, bytes memory signature) internal pure returns (address) {
1329         (address recovered, RecoverError error) = tryRecover(hash, signature);
1330         _throwError(error);
1331         return recovered;
1332     }
1333 
1334     /**
1335      * @dev Overload of {ECDSA-tryRecover} that receives the `r` and `vs` short-signature fields separately.
1336      *
1337      * See https://eips.ethereum.org/EIPS/eip-2098[EIP-2098 short signatures]
1338      *
1339      * _Available since v4.3._
1340      */
1341     function tryRecover(
1342         bytes32 hash,
1343         bytes32 r,
1344         bytes32 vs
1345     ) internal pure returns (address, RecoverError) {
1346         bytes32 s;
1347         uint8 v;
1348         assembly {
1349             s := and(vs, 0x7fffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffff)
1350             v := add(shr(255, vs), 27)
1351         }
1352         return tryRecover(hash, v, r, s);
1353     }
1354 
1355     /**
1356      * @dev Overload of {ECDSA-recover} that receives the `r and `vs` short-signature fields separately.
1357      *
1358      * _Available since v4.2._
1359      */
1360     function recover(
1361         bytes32 hash,
1362         bytes32 r,
1363         bytes32 vs
1364     ) internal pure returns (address) {
1365         (address recovered, RecoverError error) = tryRecover(hash, r, vs);
1366         _throwError(error);
1367         return recovered;
1368     }
1369 
1370     /**
1371      * @dev Overload of {ECDSA-tryRecover} that receives the `v`,
1372      * `r` and `s` signature fields separately.
1373      *
1374      * _Available since v4.3._
1375      */
1376     function tryRecover(
1377         bytes32 hash,
1378         uint8 v,
1379         bytes32 r,
1380         bytes32 s
1381     ) internal pure returns (address, RecoverError) {
1382         // EIP-2 still allows signature malleability for ecrecover(). Remove this possibility and make the signature
1383         // unique. Appendix F in the Ethereum Yellow paper (https://ethereum.github.io/yellowpaper/paper.pdf), defines
1384         // the valid range for s in (301): 0 < s < secp256k1n ÷ 2 + 1, and for v in (302): v ∈ {27, 28}. Most
1385         // signatures from current libraries generate a unique signature with an s-value in the lower half order.
1386         //
1387         // If your library generates malleable signatures, such as s-values in the upper range, calculate a new s-value
1388         // with 0xFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFEBAAEDCE6AF48A03BBFD25E8CD0364141 - s1 and flip v from 27 to 28 or
1389         // vice versa. If your library also generates signatures with 0/1 for v instead 27/28, add 27 to v to accept
1390         // these malleable signatures as well.
1391         if (uint256(s) > 0x7FFFFFFFFFFFFFFFFFFFFFFFFFFFFFFF5D576E7357A4501DDFE92F46681B20A0) {
1392             return (address(0), RecoverError.InvalidSignatureS);
1393         }
1394         if (v != 27 && v != 28) {
1395             return (address(0), RecoverError.InvalidSignatureV);
1396         }
1397 
1398         // If the signature is valid (and not malleable), return the signer address
1399         address signer = ecrecover(hash, v, r, s);
1400         if (signer == address(0)) {
1401             return (address(0), RecoverError.InvalidSignature);
1402         }
1403 
1404         return (signer, RecoverError.NoError);
1405     }
1406 
1407     /**
1408      * @dev Overload of {ECDSA-recover} that receives the `v`,
1409      * `r` and `s` signature fields separately.
1410      */
1411     function recover(
1412         bytes32 hash,
1413         uint8 v,
1414         bytes32 r,
1415         bytes32 s
1416     ) internal pure returns (address) {
1417         (address recovered, RecoverError error) = tryRecover(hash, v, r, s);
1418         _throwError(error);
1419         return recovered;
1420     }
1421 
1422     /**
1423      * @dev Returns an Ethereum Signed Message, created from a `hash`. This
1424      * produces hash corresponding to the one signed with the
1425      * https://eth.wiki/json-rpc/API#eth_sign[`eth_sign`]
1426      * JSON-RPC method as part of EIP-191.
1427      *
1428      * See {recover}.
1429      */
1430     function toEthSignedMessageHash(bytes32 hash) internal pure returns (bytes32) {
1431         // 32 is the length in bytes of hash,
1432         // enforced by the type signature above
1433         return keccak256(abi.encodePacked("\x19Ethereum Signed Message:\n32", hash));
1434     }
1435 
1436     /**
1437      * @dev Returns an Ethereum Signed Typed Data, created from a
1438      * `domainSeparator` and a `structHash`. This produces hash corresponding
1439      * to the one signed with the
1440      * https://eips.ethereum.org/EIPS/eip-712[`eth_signTypedData`]
1441      * JSON-RPC method as part of EIP-712.
1442      *
1443      * See {recover}.
1444      */
1445     function toTypedDataHash(bytes32 domainSeparator, bytes32 structHash) internal pure returns (bytes32) {
1446         return keccak256(abi.encodePacked("\x19\x01", domainSeparator, structHash));
1447     }
1448 }
1449 
1450 
1451 //........................................................................
1452 //........................................................................
1453 //...||     ||     ||     ||  || ||||||    ||    || ||||||||||||| |||||||
1454 //...|||| ||||    ||||    || ||  ||        |||   || ||      ||   ||||
1455 //...||  || ||   ||  ||   ||||   |||||     || || || |||||   ||     |||||
1456 //...||     ||  ||||||||  || ||  ||        ||  |||| ||      ||        |||
1457 //...||     || ||      || ||  || ||||||    ||    || ||      ||   |||||||
1458 //...
1459 //...||    ||    ||||  ||||||||    ||          ||     ||      ||||||
1460 //...|||   ||   ||  ||    ||        ||   ||   ||     ||||     ||   ||
1461 //...|| || ||  ||    ||   ||         || ||| |||     ||  ||    ||||||
1462 //...||  ||||   ||  ||    ||          |||  |||     ||||||||   ||   ||
1463 //...||    ||    ||||     ||           ||  ||     ||      ||  ||    ||
1464 //........................................................................
1465 //........................they grew up on the outside of society --refugee
1466 //........................................................................
1467 
1468 contract PixelFoxes is ERC721Enumerable, Ownable {
1469     using ECDSA for bytes32;
1470     using Strings for uint256; 
1471     string _baseTokenURI;  
1472     uint256 private _price = 0.0 ether; 
1473     bool public _paused = true;   
1474     address private _signatureAddress = 0x527866865Bf4a75fe9c293E342F46BF52f9d7C31;
1475     mapping(string => bool) private _mintedNonces;
1476      
1477     // PixelFoxes
1478     // Operation SpookySeason = 1000 PixelFoxes
1479     constructor(
1480         string memory name,
1481         string memory symbol,
1482         string memory baseURI
1483     ) ERC721(name,symbol)  {
1484         setBaseURI(baseURI);
1485     }
1486  
1487     function SpookyMint(bytes memory signature, string memory nonce) external {
1488         uint256 supply = totalSupply(); 
1489         uint256 num = 1;
1490 
1491         require( !_paused,                                                                   "Minting paused." );
1492         require( supply + num < 1001,                                                        "Exceeds maximum Sppoky supply." );
1493         require( balanceOf(msg.sender) <= 1,                                                 "You can only hold 2 mints.");
1494         require( matchAddresSignature(hashTransaction(msg.sender, num, nonce), signature),   "Direct Mint is not allowed.");
1495         require(!_mintedNonces[nonce], "Hash already used.");
1496         
1497         for(uint256 i; i < num; i++){
1498             _safeMint( msg.sender, supply + i );
1499         } 
1500 
1501         _mintedNonces[nonce] = true;
1502         
1503     }
1504 
1505     function hashTransaction(address sender, uint256 qty, string memory nonce) private pure returns(bytes32) {
1506         bytes32 hash = keccak256(abi.encodePacked(
1507             "\x19Ethereum Signed Message:\n32",
1508             keccak256(abi.encodePacked(sender, qty, nonce)))
1509         ); 
1510         return hash;
1511     }
1512 
1513     function matchAddresSignature(bytes32 hash, bytes memory signature) private view returns(bool) {
1514         return _signatureAddress == hash.recover(signature);
1515     }
1516 
1517     function setSignatureAddress(address addr) external onlyOwner {
1518         _signatureAddress = addr;
1519     }
1520 
1521     function giveAway(address _to, uint256 _amount) external onlyOwner() {
1522         uint256 supply = totalSupply(); 
1523         require( supply + _amount < 1001,  "Exceeds maximum Spooky Season supply" );
1524         for(uint256 i; i < _amount; i++){
1525             _safeMint( _to, supply + i );
1526         } 
1527     }
1528 
1529     function walletOfOwner(address _owner) public view returns(uint256[] memory) {
1530         uint256 tokenCount = balanceOf(_owner); 
1531         uint256[] memory tokensId = new uint256[](tokenCount);
1532         for(uint256 i; i < tokenCount; i++){
1533             tokensId[i] = tokenOfOwnerByIndex(_owner, i);
1534         }
1535         return tokensId;
1536     }
1537     
1538     function setPrice(uint256 _newPrice) public onlyOwner() {
1539         _price = _newPrice;
1540     }
1541 
1542     function getPrice() public view returns (uint256){
1543         return _price;
1544     }
1545  
1546     function _baseURI() internal view virtual override returns (string memory) {
1547         return _baseTokenURI;
1548     }
1549     
1550     function setBaseURI(string memory baseURI) public onlyOwner {
1551         _baseTokenURI = baseURI;
1552     }
1553  
1554     function pause(bool val) public onlyOwner {
1555         _paused = val;
1556     }
1557      
1558 }