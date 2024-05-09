1 // File: @openzeppelin/contracts/utils/introspection/IERC165.sol
2 // SPDX-License-Identifier: MIT
3 
4 pragma solidity ^0.8.0;
5 
6 /**
7  * @dev Interface of the ERC165 standard, as defined in the
8  * https://eips.ethereum.org/EIPS/eip-165[EIP].
9  *
10  * Implementers can declare support of contract interfaces, which can then be
11  * queried by others ({ERC165Checker}).
12  *
13  * For an implementation, see {ERC165}.
14  */
15 interface IERC165 {
16     /**
17      * @dev Returns true if this contract implements the interface defined by
18      * `interfaceId`. See the corresponding
19      * https://eips.ethereum.org/EIPS/eip-165#how-interfaces-are-identified[EIP section]
20      * to learn more about how these ids are created.
21      *
22      * This function call must use less than 30 000 gas.
23      */
24     function supportsInterface(bytes4 interfaceId) external view returns (bool);
25 }
26 
27 // File: @openzeppelin/contracts/token/ERC721/IERC721.sol
28 
29 
30 
31 pragma solidity ^0.8.0;
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
81     function safeTransferFrom(address from, address to, uint256 tokenId) external;
82 
83     /**
84      * @dev Transfers `tokenId` token from `from` to `to`.
85      *
86      * WARNING: Usage of this method is discouraged, use {safeTransferFrom} whenever possible.
87      *
88      * Requirements:
89      *
90      * - `from` cannot be the zero address.
91      * - `to` cannot be the zero address.
92      * - `tokenId` token must be owned by `from`.
93      * - If the caller is not `from`, it must be approved to move this token by either {approve} or {setApprovalForAll}.
94      *
95      * Emits a {Transfer} event.
96      */
97     function transferFrom(address from, address to, uint256 tokenId) external;
98 
99     /**
100      * @dev Gives permission to `to` to transfer `tokenId` token to another account.
101      * The approval is cleared when the token is transferred.
102      *
103      * Only a single account can be approved at a time, so approving the zero address clears previous approvals.
104      *
105      * Requirements:
106      *
107      * - The caller must own the token or be an approved operator.
108      * - `tokenId` must exist.
109      *
110      * Emits an {Approval} event.
111      */
112     function approve(address to, uint256 tokenId) external;
113 
114     /**
115      * @dev Returns the account approved for `tokenId` token.
116      *
117      * Requirements:
118      *
119      * - `tokenId` must exist.
120      */
121     function getApproved(uint256 tokenId) external view returns (address operator);
122 
123     /**
124      * @dev Approve or remove `operator` as an operator for the caller.
125      * Operators can call {transferFrom} or {safeTransferFrom} for any token owned by the caller.
126      *
127      * Requirements:
128      *
129      * - The `operator` cannot be the caller.
130      *
131      * Emits an {ApprovalForAll} event.
132      */
133     function setApprovalForAll(address operator, bool _approved) external;
134 
135     /**
136      * @dev Returns if the `operator` is allowed to manage all of the assets of `owner`.
137      *
138      * See {setApprovalForAll}
139      */
140     function isApprovedForAll(address owner, address operator) external view returns (bool);
141 
142     /**
143       * @dev Safely transfers `tokenId` token from `from` to `to`.
144       *
145       * Requirements:
146       *
147       * - `from` cannot be the zero address.
148       * - `to` cannot be the zero address.
149       * - `tokenId` token must exist and be owned by `from`.
150       * - If the caller is not `from`, it must be approved to move this token by either {approve} or {setApprovalForAll}.
151       * - If `to` refers to a smart contract, it must implement {IERC721Receiver-onERC721Received}, which is called upon a safe transfer.
152       *
153       * Emits a {Transfer} event.
154       */
155     function safeTransferFrom(address from, address to, uint256 tokenId, bytes calldata data) external;
156 }
157 
158 // File: @openzeppelin/contracts/token/ERC721/IERC721Receiver.sol
159 
160 
161 
162 pragma solidity ^0.8.0;
163 
164 /**
165  * @title ERC721 token receiver interface
166  * @dev Interface for any contract that wants to support safeTransfers
167  * from ERC721 asset contracts.
168  */
169 interface IERC721Receiver {
170     /**
171      * @dev Whenever an {IERC721} `tokenId` token is transferred to this contract via {IERC721-safeTransferFrom}
172      * by `operator` from `from`, this function is called.
173      *
174      * It must return its Solidity selector to confirm the token transfer.
175      * If any other value is returned or the interface is not implemented by the recipient, the transfer will be reverted.
176      *
177      * The selector can be obtained in Solidity with `IERC721.onERC721Received.selector`.
178      */
179     function onERC721Received(address operator, address from, uint256 tokenId, bytes calldata data) external returns (bytes4);
180 }
181 
182 // File: @openzeppelin/contracts/token/ERC721/extensions/IERC721Metadata.sol
183 
184 
185 
186 pragma solidity ^0.8.0;
187 
188 
189 /**
190  * @title ERC-721 Non-Fungible Token Standard, optional metadata extension
191  * @dev See https://eips.ethereum.org/EIPS/eip-721
192  */
193 interface IERC721Metadata is IERC721 {
194 
195     /**
196      * @dev Returns the token collection name.
197      */
198     function name() external view returns (string memory);
199 
200     /**
201      * @dev Returns the token collection symbol.
202      */
203     function symbol() external view returns (string memory);
204 
205     /**
206      * @dev Returns the Uniform Resource Identifier (URI) for `tokenId` token.
207      */
208     function tokenURI(uint256 tokenId) external view returns (string memory);
209 }
210 
211 // File: @openzeppelin/contracts/utils/Address.sol
212 
213 
214 
215 pragma solidity ^0.8.0;
216 
217 /**
218  * @dev Collection of functions related to the address type
219  */
220 library Address {
221     /**
222      * @dev Returns true if `account` is a contract.
223      *
224      * [IMPORTANT]
225      * ====
226      * It is unsafe to assume that an address for which this function returns
227      * false is an externally-owned account (EOA) and not a contract.
228      *
229      * Among others, `isContract` will return false for the following
230      * types of addresses:
231      *
232      *  - an externally-owned account
233      *  - a contract in construction
234      *  - an address where a contract will be created
235      *  - an address where a contract lived, but was destroyed
236      * ====
237      */
238     function isContract(address account) internal view returns (bool) {
239         // This method relies on extcodesize, which returns 0 for contracts in
240         // construction, since the code is only stored at the end of the
241         // constructor execution.
242 
243         uint256 size;
244         // solhint-disable-next-line no-inline-assembly
245         assembly { size := extcodesize(account) }
246         return size > 0;
247     }
248 
249     /**
250      * @dev Replacement for Solidity's `transfer`: sends `amount` wei to
251      * `recipient`, forwarding all available gas and reverting on errors.
252      *
253      * https://eips.ethereum.org/EIPS/eip-1884[EIP1884] increases the gas cost
254      * of certain opcodes, possibly making contracts go over the 2300 gas limit
255      * imposed by `transfer`, making them unable to receive funds via
256      * `transfer`. {sendValue} removes this limitation.
257      *
258      * https://diligence.consensys.net/posts/2019/09/stop-using-soliditys-transfer-now/[Learn more].
259      *
260      * IMPORTANT: because control is transferred to `recipient`, care must be
261      * taken to not create reentrancy vulnerabilities. Consider using
262      * {ReentrancyGuard} or the
263      * https://solidity.readthedocs.io/en/v0.5.11/security-considerations.html#use-the-checks-effects-interactions-pattern[checks-effects-interactions pattern].
264      */
265     function sendValue(address payable recipient, uint256 amount) internal {
266         require(address(this).balance >= amount, "Address: insufficient balance");
267 
268         // solhint-disable-next-line avoid-low-level-calls, avoid-call-value
269         (bool success, ) = recipient.call{ value: amount }("");
270         require(success, "Address: unable to send value, recipient may have reverted");
271     }
272 
273     /**
274      * @dev Performs a Solidity function call using a low level `call`. A
275      * plain`call` is an unsafe replacement for a function call: use this
276      * function instead.
277      *
278      * If `target` reverts with a revert reason, it is bubbled up by this
279      * function (like regular Solidity function calls).
280      *
281      * Returns the raw returned data. To convert to the expected return value,
282      * use https://solidity.readthedocs.io/en/latest/units-and-global-variables.html?highlight=abi.decode#abi-encoding-and-decoding-functions[`abi.decode`].
283      *
284      * Requirements:
285      *
286      * - `target` must be a contract.
287      * - calling `target` with `data` must not revert.
288      *
289      * _Available since v3.1._
290      */
291     function functionCall(address target, bytes memory data) internal returns (bytes memory) {
292       return functionCall(target, data, "Address: low-level call failed");
293     }
294 
295     /**
296      * @dev Same as {xref-Address-functionCall-address-bytes-}[`functionCall`], but with
297      * `errorMessage` as a fallback revert reason when `target` reverts.
298      *
299      * _Available since v3.1._
300      */
301     function functionCall(address target, bytes memory data, string memory errorMessage) internal returns (bytes memory) {
302         return functionCallWithValue(target, data, 0, errorMessage);
303     }
304 
305     /**
306      * @dev Same as {xref-Address-functionCall-address-bytes-}[`functionCall`],
307      * but also transferring `value` wei to `target`.
308      *
309      * Requirements:
310      *
311      * - the calling contract must have an ETH balance of at least `value`.
312      * - the called Solidity function must be `payable`.
313      *
314      * _Available since v3.1._
315      */
316     function functionCallWithValue(address target, bytes memory data, uint256 value) internal returns (bytes memory) {
317         return functionCallWithValue(target, data, value, "Address: low-level call with value failed");
318     }
319 
320     /**
321      * @dev Same as {xref-Address-functionCallWithValue-address-bytes-uint256-}[`functionCallWithValue`], but
322      * with `errorMessage` as a fallback revert reason when `target` reverts.
323      *
324      * _Available since v3.1._
325      */
326     function functionCallWithValue(address target, bytes memory data, uint256 value, string memory errorMessage) internal returns (bytes memory) {
327         require(address(this).balance >= value, "Address: insufficient balance for call");
328         require(isContract(target), "Address: call to non-contract");
329 
330         // solhint-disable-next-line avoid-low-level-calls
331         (bool success, bytes memory returndata) = target.call{ value: value }(data);
332         return _verifyCallResult(success, returndata, errorMessage);
333     }
334 
335     /**
336      * @dev Same as {xref-Address-functionCall-address-bytes-}[`functionCall`],
337      * but performing a static call.
338      *
339      * _Available since v3.3._
340      */
341     function functionStaticCall(address target, bytes memory data) internal view returns (bytes memory) {
342         return functionStaticCall(target, data, "Address: low-level static call failed");
343     }
344 
345     /**
346      * @dev Same as {xref-Address-functionCall-address-bytes-string-}[`functionCall`],
347      * but performing a static call.
348      *
349      * _Available since v3.3._
350      */
351     function functionStaticCall(address target, bytes memory data, string memory errorMessage) internal view returns (bytes memory) {
352         require(isContract(target), "Address: static call to non-contract");
353 
354         // solhint-disable-next-line avoid-low-level-calls
355         (bool success, bytes memory returndata) = target.staticcall(data);
356         return _verifyCallResult(success, returndata, errorMessage);
357     }
358 
359     /**
360      * @dev Same as {xref-Address-functionCall-address-bytes-}[`functionCall`],
361      * but performing a delegate call.
362      *
363      * _Available since v3.4._
364      */
365     function functionDelegateCall(address target, bytes memory data) internal returns (bytes memory) {
366         return functionDelegateCall(target, data, "Address: low-level delegate call failed");
367     }
368 
369     /**
370      * @dev Same as {xref-Address-functionCall-address-bytes-string-}[`functionCall`],
371      * but performing a delegate call.
372      *
373      * _Available since v3.4._
374      */
375     function functionDelegateCall(address target, bytes memory data, string memory errorMessage) internal returns (bytes memory) {
376         require(isContract(target), "Address: delegate call to non-contract");
377 
378         // solhint-disable-next-line avoid-low-level-calls
379         (bool success, bytes memory returndata) = target.delegatecall(data);
380         return _verifyCallResult(success, returndata, errorMessage);
381     }
382 
383     function _verifyCallResult(bool success, bytes memory returndata, string memory errorMessage) private pure returns(bytes memory) {
384         if (success) {
385             return returndata;
386         } else {
387             // Look for revert reason and bubble it up if present
388             if (returndata.length > 0) {
389                 // The easiest way to bubble the revert reason is using memory via assembly
390 
391                 // solhint-disable-next-line no-inline-assembly
392                 assembly {
393                     let returndata_size := mload(returndata)
394                     revert(add(32, returndata), returndata_size)
395                 }
396             } else {
397                 revert(errorMessage);
398             }
399         }
400     }
401 }
402 
403 // File: @openzeppelin/contracts/utils/Context.sol
404 
405 
406 
407 pragma solidity ^0.8.0;
408 
409 /*
410  * @dev Provides information about the current execution context, including the
411  * sender of the transaction and its data. While these are generally available
412  * via msg.sender and msg.data, they should not be accessed in such a direct
413  * manner, since when dealing with meta-transactions the account sending and
414  * paying for execution may not be the actual sender (as far as an application
415  * is concerned).
416  *
417  * This contract is only required for intermediate, library-like contracts.
418  */
419 abstract contract Context {
420     function _msgSender() internal view virtual returns (address) {
421         return msg.sender;
422     }
423 
424     function _msgData() internal view virtual returns (bytes calldata) {
425         this; // silence state mutability warning without generating bytecode - see https://github.com/ethereum/solidity/issues/2691
426         return msg.data;
427     }
428 }
429 
430 // File: @openzeppelin/contracts/utils/Strings.sol
431 
432 
433 
434 pragma solidity ^0.8.0;
435 
436 /**
437  * @dev String operations.
438  */
439 library Strings {
440     bytes16 private constant alphabet = "0123456789abcdef";
441 
442     /**
443      * @dev Converts a `uint256` to its ASCII `string` decimal representation.
444      */
445     function toString(uint256 value) internal pure returns (string memory) {
446         // Inspired by OraclizeAPI's implementation - MIT licence
447         // https://github.com/oraclize/ethereum-api/blob/b42146b063c7d6ee1358846c198246239e9360e8/oraclizeAPI_0.4.25.sol
448 
449         if (value == 0) {
450             return "0";
451         }
452         uint256 temp = value;
453         uint256 digits;
454         while (temp != 0) {
455             digits++;
456             temp /= 10;
457         }
458         bytes memory buffer = new bytes(digits);
459         while (value != 0) {
460             digits -= 1;
461             buffer[digits] = bytes1(uint8(48 + uint256(value % 10)));
462             value /= 10;
463         }
464         return string(buffer);
465     }
466 
467     /**
468      * @dev Converts a `uint256` to its ASCII `string` hexadecimal representation.
469      */
470     function toHexString(uint256 value) internal pure returns (string memory) {
471         if (value == 0) {
472             return "0x00";
473         }
474         uint256 temp = value;
475         uint256 length = 0;
476         while (temp != 0) {
477             length++;
478             temp >>= 8;
479         }
480         return toHexString(value, length);
481     }
482 
483     /**
484      * @dev Converts a `uint256` to its ASCII `string` hexadecimal representation with fixed length.
485      */
486     function toHexString(uint256 value, uint256 length) internal pure returns (string memory) {
487         bytes memory buffer = new bytes(2 * length + 2);
488         buffer[0] = "0";
489         buffer[1] = "x";
490         for (uint256 i = 2 * length + 1; i > 1; --i) {
491             buffer[i] = alphabet[value & 0xf];
492             value >>= 4;
493         }
494         require(value == 0, "Strings: hex length insufficient");
495         return string(buffer);
496     }
497 
498 }
499 
500 // File: @openzeppelin/contracts/utils/introspection/ERC165.sol
501 
502 
503 
504 pragma solidity ^0.8.0;
505 
506 
507 /**
508  * @dev Implementation of the {IERC165} interface.
509  *
510  * Contracts that want to implement ERC165 should inherit from this contract and override {supportsInterface} to check
511  * for the additional interface id that will be supported. For example:
512  *
513  * ```solidity
514  * function supportsInterface(bytes4 interfaceId) public view virtual override returns (bool) {
515  *     return interfaceId == type(MyInterface).interfaceId || super.supportsInterface(interfaceId);
516  * }
517  * ```
518  *
519  * Alternatively, {ERC165Storage} provides an easier to use but more expensive implementation.
520  */
521 abstract contract ERC165 is IERC165 {
522     /**
523      * @dev See {IERC165-supportsInterface}.
524      */
525     function supportsInterface(bytes4 interfaceId) public view virtual override returns (bool) {
526         return interfaceId == type(IERC165).interfaceId;
527     }
528 }
529 
530 // File: @openzeppelin/contracts/token/ERC721/ERC721.sol
531 
532 
533 
534 pragma solidity ^0.8.0;
535 
536 
537 
538 
539 
540 
541 
542 
543 /**
544  * @dev Implementation of https://eips.ethereum.org/EIPS/eip-721[ERC721] Non-Fungible Token Standard, including
545  * the Metadata extension, but not including the Enumerable extension, which is available separately as
546  * {ERC721Enumerable}.
547  */
548 contract ERC721 is Context, ERC165, IERC721, IERC721Metadata {
549     using Address for address;
550     using Strings for uint256;
551 
552     // Token name
553     string private _name;
554 
555     // Token symbol
556     string private _symbol;
557 
558     // Mapping from token ID to owner address
559     mapping (uint256 => address) private _owners;
560 
561     // Mapping owner address to token count
562     mapping (address => uint256) private _balances;
563 
564     // Mapping from token ID to approved address
565     mapping (uint256 => address) private _tokenApprovals;
566 
567     // Mapping from owner to operator approvals
568     mapping (address => mapping (address => bool)) private _operatorApprovals;
569 
570     /**
571      * @dev Initializes the contract by setting a `name` and a `symbol` to the token collection.
572      */
573     constructor (string memory name_, string memory symbol_) {
574         _name = name_;
575         _symbol = symbol_;
576     }
577 
578     /**
579      * @dev See {IERC165-supportsInterface}.
580      */
581     function supportsInterface(bytes4 interfaceId) public view virtual override(ERC165, IERC165) returns (bool) {
582         return interfaceId == type(IERC721).interfaceId
583             || interfaceId == type(IERC721Metadata).interfaceId
584             || super.supportsInterface(interfaceId);
585     }
586 
587     /**
588      * @dev See {IERC721-balanceOf}.
589      */
590     function balanceOf(address owner) public view virtual override returns (uint256) {
591         require(owner != address(0), "ERC721: balance query for the zero address");
592         return _balances[owner];
593     }
594 
595     /**
596      * @dev See {IERC721-ownerOf}.
597      */
598     function ownerOf(uint256 tokenId) public view virtual override returns (address) {
599         address owner = _owners[tokenId];
600         require(owner != address(0), "ERC721: owner query for nonexistent token");
601         return owner;
602     }
603 
604     /**
605      * @dev See {IERC721Metadata-name}.
606      */
607     function name() public view virtual override returns (string memory) {
608         return _name;
609     }
610 
611     /**
612      * @dev See {IERC721Metadata-symbol}.
613      */
614     function symbol() public view virtual override returns (string memory) {
615         return _symbol;
616     }
617 
618     /**
619      * @dev See {IERC721Metadata-tokenURI}.
620      */
621     function tokenURI(uint256 tokenId) public view virtual override returns (string memory) {
622         require(_exists(tokenId), "ERC721Metadata: URI query for nonexistent token");
623 
624         string memory baseURI = _baseURI();
625         return bytes(baseURI).length > 0
626             ? string(abi.encodePacked(baseURI, tokenId.toString()))
627             : '';
628     }
629 
630     /**
631      * @dev Base URI for computing {tokenURI}. Empty by default, can be overriden
632      * in child contracts.
633      */
634     function _baseURI() internal view virtual returns (string memory) {
635         return "";
636     }
637 
638     /**
639      * @dev See {IERC721-approve}.
640      */
641     function approve(address to, uint256 tokenId) public virtual override {
642         address owner = ERC721.ownerOf(tokenId);
643         require(to != owner, "ERC721: approval to current owner");
644 
645         require(_msgSender() == owner || isApprovedForAll(owner, _msgSender()),
646             "ERC721: approve caller is not owner nor approved for all"
647         );
648 
649         _approve(to, tokenId);
650     }
651 
652     /**
653      * @dev See {IERC721-getApproved}.
654      */
655     function getApproved(uint256 tokenId) public view virtual override returns (address) {
656         require(_exists(tokenId), "ERC721: approved query for nonexistent token");
657 
658         return _tokenApprovals[tokenId];
659     }
660 
661     /**
662      * @dev See {IERC721-setApprovalForAll}.
663      */
664     function setApprovalForAll(address operator, bool approved) public virtual override {
665         require(operator != _msgSender(), "ERC721: approve to caller");
666 
667         _operatorApprovals[_msgSender()][operator] = approved;
668         emit ApprovalForAll(_msgSender(), operator, approved);
669     }
670 
671     /**
672      * @dev See {IERC721-isApprovedForAll}.
673      */
674     function isApprovedForAll(address owner, address operator) public view virtual override returns (bool) {
675         return _operatorApprovals[owner][operator];
676     }
677 
678     /**
679      * @dev See {IERC721-transferFrom}.
680      */
681     function transferFrom(address from, address to, uint256 tokenId) public virtual override {
682         //solhint-disable-next-line max-line-length
683         require(_isApprovedOrOwner(_msgSender(), tokenId), "ERC721: transfer caller is not owner nor approved");
684 
685         _transfer(from, to, tokenId);
686     }
687 
688     /**
689      * @dev See {IERC721-safeTransferFrom}.
690      */
691     function safeTransferFrom(address from, address to, uint256 tokenId) public virtual override {
692         safeTransferFrom(from, to, tokenId, "");
693     }
694 
695     /**
696      * @dev See {IERC721-safeTransferFrom}.
697      */
698     function safeTransferFrom(address from, address to, uint256 tokenId, bytes memory _data) public virtual override {
699         require(_isApprovedOrOwner(_msgSender(), tokenId), "ERC721: transfer caller is not owner nor approved");
700         _safeTransfer(from, to, tokenId, _data);
701     }
702 
703     /**
704      * @dev Safely transfers `tokenId` token from `from` to `to`, checking first that contract recipients
705      * are aware of the ERC721 protocol to prevent tokens from being forever locked.
706      *
707      * `_data` is additional data, it has no specified format and it is sent in call to `to`.
708      *
709      * This internal function is equivalent to {safeTransferFrom}, and can be used to e.g.
710      * implement alternative mechanisms to perform token transfer, such as signature-based.
711      *
712      * Requirements:
713      *
714      * - `from` cannot be the zero address.
715      * - `to` cannot be the zero address.
716      * - `tokenId` token must exist and be owned by `from`.
717      * - If `to` refers to a smart contract, it must implement {IERC721Receiver-onERC721Received}, which is called upon a safe transfer.
718      *
719      * Emits a {Transfer} event.
720      */
721     function _safeTransfer(address from, address to, uint256 tokenId, bytes memory _data) internal virtual {
722         _transfer(from, to, tokenId);
723         require(_checkOnERC721Received(from, to, tokenId, _data), "ERC721: transfer to non ERC721Receiver implementer");
724     }
725 
726     /**
727      * @dev Returns whether `tokenId` exists.
728      *
729      * Tokens can be managed by their owner or approved accounts via {approve} or {setApprovalForAll}.
730      *
731      * Tokens start existing when they are minted (`_mint`),
732      * and stop existing when they are burned (`_burn`).
733      */
734     function _exists(uint256 tokenId) internal view virtual returns (bool) {
735         return _owners[tokenId] != address(0);
736     }
737 
738     /**
739      * @dev Returns whether `spender` is allowed to manage `tokenId`.
740      *
741      * Requirements:
742      *
743      * - `tokenId` must exist.
744      */
745     function _isApprovedOrOwner(address spender, uint256 tokenId) internal view virtual returns (bool) {
746         require(_exists(tokenId), "ERC721: operator query for nonexistent token");
747         address owner = ERC721.ownerOf(tokenId);
748         return (spender == owner || getApproved(tokenId) == spender || isApprovedForAll(owner, spender));
749     }
750 
751     /**
752      * @dev Safely mints `tokenId` and transfers it to `to`.
753      *
754      * Requirements:
755      *
756      * - `tokenId` must not exist.
757      * - If `to` refers to a smart contract, it must implement {IERC721Receiver-onERC721Received}, which is called upon a safe transfer.
758      *
759      * Emits a {Transfer} event.
760      */
761     function _safeMint(address to, uint256 tokenId) internal virtual {
762         _safeMint(to, tokenId, "");
763     }
764 
765     /**
766      * @dev Same as {xref-ERC721-_safeMint-address-uint256-}[`_safeMint`], with an additional `data` parameter which is
767      * forwarded in {IERC721Receiver-onERC721Received} to contract recipients.
768      */
769     function _safeMint(address to, uint256 tokenId, bytes memory _data) internal virtual {
770         _mint(to, tokenId);
771         require(_checkOnERC721Received(address(0), to, tokenId, _data), "ERC721: transfer to non ERC721Receiver implementer");
772     }
773 
774     /**
775      * @dev Mints `tokenId` and transfers it to `to`.
776      *
777      * WARNING: Usage of this method is discouraged, use {_safeMint} whenever possible
778      *
779      * Requirements:
780      *
781      * - `tokenId` must not exist.
782      * - `to` cannot be the zero address.
783      *
784      * Emits a {Transfer} event.
785      */
786     function _mint(address to, uint256 tokenId) internal virtual {
787         require(to != address(0), "ERC721: mint to the zero address");
788         require(!_exists(tokenId), "ERC721: token already minted");
789 
790         _beforeTokenTransfer(address(0), to, tokenId);
791 
792         _balances[to] += 1;
793         _owners[tokenId] = to;
794 
795         emit Transfer(address(0), to, tokenId);
796     }
797 
798     /**
799      * @dev Destroys `tokenId`.
800      * The approval is cleared when the token is burned.
801      *
802      * Requirements:
803      *
804      * - `tokenId` must exist.
805      *
806      * Emits a {Transfer} event.
807      */
808     function _burn(uint256 tokenId) internal virtual {
809         address owner = ERC721.ownerOf(tokenId);
810 
811         _beforeTokenTransfer(owner, address(0), tokenId);
812 
813         // Clear approvals
814         _approve(address(0), tokenId);
815 
816         _balances[owner] -= 1;
817         delete _owners[tokenId];
818 
819         emit Transfer(owner, address(0), tokenId);
820     }
821 
822     /**
823      * @dev Transfers `tokenId` from `from` to `to`.
824      *  As opposed to {transferFrom}, this imposes no restrictions on msg.sender.
825      *
826      * Requirements:
827      *
828      * - `to` cannot be the zero address.
829      * - `tokenId` token must be owned by `from`.
830      *
831      * Emits a {Transfer} event.
832      */
833     function _transfer(address from, address to, uint256 tokenId) internal virtual {
834         require(ERC721.ownerOf(tokenId) == from, "ERC721: transfer of token that is not own");
835         require(to != address(0), "ERC721: transfer to the zero address");
836 
837         _beforeTokenTransfer(from, to, tokenId);
838 
839         // Clear approvals from the previous owner
840         _approve(address(0), tokenId);
841 
842         _balances[from] -= 1;
843         _balances[to] += 1;
844         _owners[tokenId] = to;
845 
846         emit Transfer(from, to, tokenId);
847     }
848 
849     /**
850      * @dev Approve `to` to operate on `tokenId`
851      *
852      * Emits a {Approval} event.
853      */
854     function _approve(address to, uint256 tokenId) internal virtual {
855         _tokenApprovals[tokenId] = to;
856         emit Approval(ERC721.ownerOf(tokenId), to, tokenId);
857     }
858 
859     /**
860      * @dev Internal function to invoke {IERC721Receiver-onERC721Received} on a target address.
861      * The call is not executed if the target address is not a contract.
862      *
863      * @param from address representing the previous owner of the given token ID
864      * @param to target address that will receive the tokens
865      * @param tokenId uint256 ID of the token to be transferred
866      * @param _data bytes optional data to send along with the call
867      * @return bool whether the call correctly returned the expected magic value
868      */
869     function _checkOnERC721Received(address from, address to, uint256 tokenId, bytes memory _data)
870         private returns (bool)
871     {
872         if (to.isContract()) {
873             try IERC721Receiver(to).onERC721Received(_msgSender(), from, tokenId, _data) returns (bytes4 retval) {
874                 return retval == IERC721Receiver(to).onERC721Received.selector;
875             } catch (bytes memory reason) {
876                 if (reason.length == 0) {
877                     revert("ERC721: transfer to non ERC721Receiver implementer");
878                 } else {
879                     // solhint-disable-next-line no-inline-assembly
880                     assembly {
881                         revert(add(32, reason), mload(reason))
882                     }
883                 }
884             }
885         } else {
886             return true;
887         }
888     }
889 
890     /**
891      * @dev Hook that is called before any token transfer. This includes minting
892      * and burning.
893      *
894      * Calling conditions:
895      *
896      * - When `from` and `to` are both non-zero, ``from``'s `tokenId` will be
897      * transferred to `to`.
898      * - When `from` is zero, `tokenId` will be minted for `to`.
899      * - When `to` is zero, ``from``'s `tokenId` will be burned.
900      * - `from` cannot be the zero address.
901      * - `to` cannot be the zero address.
902      *
903      * To learn more about hooks, head to xref:ROOT:extending-contracts.adoc#using-hooks[Using Hooks].
904      */
905     function _beforeTokenTransfer(address from, address to, uint256 tokenId) internal virtual { }
906 }
907 
908 // File: @openzeppelin/contracts/token/ERC721/extensions/IERC721Enumerable.sol
909 
910 
911 
912 pragma solidity ^0.8.0;
913 
914 
915 /**
916  * @title ERC-721 Non-Fungible Token Standard, optional enumeration extension
917  * @dev See https://eips.ethereum.org/EIPS/eip-721
918  */
919 interface IERC721Enumerable is IERC721 {
920 
921     /**
922      * @dev Returns the total amount of tokens stored by the contract.
923      */
924     function totalSupply() external view returns (uint256);
925 
926     /**
927      * @dev Returns a token ID owned by `owner` at a given `index` of its token list.
928      * Use along with {balanceOf} to enumerate all of ``owner``'s tokens.
929      */
930     function tokenOfOwnerByIndex(address owner, uint256 index) external view returns (uint256 tokenId);
931 
932     /**
933      * @dev Returns a token ID at a given `index` of all the tokens stored by the contract.
934      * Use along with {totalSupply} to enumerate all tokens.
935      */
936     function tokenByIndex(uint256 index) external view returns (uint256);
937 }
938 
939 // File: @openzeppelin/contracts/token/ERC721/extensions/ERC721Enumerable.sol
940 
941 
942 
943 pragma solidity ^0.8.0;
944 
945 
946 
947 /**
948  * @dev This implements an optional extension of {ERC721} defined in the EIP that adds
949  * enumerability of all the token ids in the contract as well as all token ids owned by each
950  * account.
951  */
952 abstract contract ERC721Enumerable is ERC721, IERC721Enumerable {
953     // Mapping from owner to list of owned token IDs
954     mapping(address => mapping(uint256 => uint256)) private _ownedTokens;
955 
956     // Mapping from token ID to index of the owner tokens list
957     mapping(uint256 => uint256) private _ownedTokensIndex;
958 
959     // Array with all token ids, used for enumeration
960     uint256[] private _allTokens;
961 
962     // Mapping from token id to position in the allTokens array
963     mapping(uint256 => uint256) private _allTokensIndex;
964 
965     /**
966      * @dev See {IERC165-supportsInterface}.
967      */
968     function supportsInterface(bytes4 interfaceId) public view virtual override(IERC165, ERC721) returns (bool) {
969         return interfaceId == type(IERC721Enumerable).interfaceId
970             || super.supportsInterface(interfaceId);
971     }
972 
973     /**
974      * @dev See {IERC721Enumerable-tokenOfOwnerByIndex}.
975      */
976     function tokenOfOwnerByIndex(address owner, uint256 index) public view virtual override returns (uint256) {
977         require(index < ERC721.balanceOf(owner), "ERC721Enumerable: owner index out of bounds");
978         return _ownedTokens[owner][index];
979     }
980 
981     /**
982      * @dev See {IERC721Enumerable-totalSupply}.
983      */
984     function totalSupply() public view virtual override returns (uint256) {
985         return _allTokens.length;
986     }
987 
988     /**
989      * @dev See {IERC721Enumerable-tokenByIndex}.
990      */
991     function tokenByIndex(uint256 index) public view virtual override returns (uint256) {
992         require(index < ERC721Enumerable.totalSupply(), "ERC721Enumerable: global index out of bounds");
993         return _allTokens[index];
994     }
995 
996     /**
997      * @dev Hook that is called before any token transfer. This includes minting
998      * and burning.
999      *
1000      * Calling conditions:
1001      *
1002      * - When `from` and `to` are both non-zero, ``from``'s `tokenId` will be
1003      * transferred to `to`.
1004      * - When `from` is zero, `tokenId` will be minted for `to`.
1005      * - When `to` is zero, ``from``'s `tokenId` will be burned.
1006      * - `from` cannot be the zero address.
1007      * - `to` cannot be the zero address.
1008      *
1009      * To learn more about hooks, head to xref:ROOT:extending-contracts.adoc#using-hooks[Using Hooks].
1010      */
1011     function _beforeTokenTransfer(address from, address to, uint256 tokenId) internal virtual override {
1012         super._beforeTokenTransfer(from, to, tokenId);
1013 
1014         if (from == address(0)) {
1015             _addTokenToAllTokensEnumeration(tokenId);
1016         } else if (from != to) {
1017             _removeTokenFromOwnerEnumeration(from, tokenId);
1018         }
1019         if (to == address(0)) {
1020             _removeTokenFromAllTokensEnumeration(tokenId);
1021         } else if (to != from) {
1022             _addTokenToOwnerEnumeration(to, tokenId);
1023         }
1024     }
1025 
1026     /**
1027      * @dev Private function to add a token to this extension's ownership-tracking data structures.
1028      * @param to address representing the new owner of the given token ID
1029      * @param tokenId uint256 ID of the token to be added to the tokens list of the given address
1030      */
1031     function _addTokenToOwnerEnumeration(address to, uint256 tokenId) private {
1032         uint256 length = ERC721.balanceOf(to);
1033         _ownedTokens[to][length] = tokenId;
1034         _ownedTokensIndex[tokenId] = length;
1035     }
1036 
1037     /**
1038      * @dev Private function to add a token to this extension's token tracking data structures.
1039      * @param tokenId uint256 ID of the token to be added to the tokens list
1040      */
1041     function _addTokenToAllTokensEnumeration(uint256 tokenId) private {
1042         _allTokensIndex[tokenId] = _allTokens.length;
1043         _allTokens.push(tokenId);
1044     }
1045 
1046     /**
1047      * @dev Private function to remove a token from this extension's ownership-tracking data structures. Note that
1048      * while the token is not assigned a new owner, the `_ownedTokensIndex` mapping is _not_ updated: this allows for
1049      * gas optimizations e.g. when performing a transfer operation (avoiding double writes).
1050      * This has O(1) time complexity, but alters the order of the _ownedTokens array.
1051      * @param from address representing the previous owner of the given token ID
1052      * @param tokenId uint256 ID of the token to be removed from the tokens list of the given address
1053      */
1054     function _removeTokenFromOwnerEnumeration(address from, uint256 tokenId) private {
1055         // To prevent a gap in from's tokens array, we store the last token in the index of the token to delete, and
1056         // then delete the last slot (swap and pop).
1057 
1058         uint256 lastTokenIndex = ERC721.balanceOf(from) - 1;
1059         uint256 tokenIndex = _ownedTokensIndex[tokenId];
1060 
1061         // When the token to delete is the last token, the swap operation is unnecessary
1062         if (tokenIndex != lastTokenIndex) {
1063             uint256 lastTokenId = _ownedTokens[from][lastTokenIndex];
1064 
1065             _ownedTokens[from][tokenIndex] = lastTokenId; // Move the last token to the slot of the to-delete token
1066             _ownedTokensIndex[lastTokenId] = tokenIndex; // Update the moved token's index
1067         }
1068 
1069         // This also deletes the contents at the last position of the array
1070         delete _ownedTokensIndex[tokenId];
1071         delete _ownedTokens[from][lastTokenIndex];
1072     }
1073 
1074     /**
1075      * @dev Private function to remove a token from this extension's token tracking data structures.
1076      * This has O(1) time complexity, but alters the order of the _allTokens array.
1077      * @param tokenId uint256 ID of the token to be removed from the tokens list
1078      */
1079     function _removeTokenFromAllTokensEnumeration(uint256 tokenId) private {
1080         // To prevent a gap in the tokens array, we store the last token in the index of the token to delete, and
1081         // then delete the last slot (swap and pop).
1082 
1083         uint256 lastTokenIndex = _allTokens.length - 1;
1084         uint256 tokenIndex = _allTokensIndex[tokenId];
1085 
1086         // When the token to delete is the last token, the swap operation is unnecessary. However, since this occurs so
1087         // rarely (when the last minted token is burnt) that we still do the swap here to avoid the gas cost of adding
1088         // an 'if' statement (like in _removeTokenFromOwnerEnumeration)
1089         uint256 lastTokenId = _allTokens[lastTokenIndex];
1090 
1091         _allTokens[tokenIndex] = lastTokenId; // Move the last token to the slot of the to-delete token
1092         _allTokensIndex[lastTokenId] = tokenIndex; // Update the moved token's index
1093 
1094         // This also deletes the contents at the last position of the array
1095         delete _allTokensIndex[tokenId];
1096         _allTokens.pop();
1097     }
1098 }
1099 
1100 // File: @openzeppelin/contracts/access/Ownable.sol
1101 
1102 
1103 
1104 pragma solidity ^0.8.0;
1105 
1106 /**
1107  * @dev Contract module which provides a basic access control mechanism, where
1108  * there is an account (an owner) that can be granted exclusive access to
1109  * specific functions.
1110  *
1111  * By default, the owner account will be the one that deploys the contract. This
1112  * can later be changed with {transferOwnership}.
1113  *
1114  * This module is used through inheritance. It will make available the modifier
1115  * `onlyOwner`, which can be applied to your functions to restrict their use to
1116  * the owner.
1117  */
1118 abstract contract Ownable is Context {
1119     address private _owner;
1120 
1121     event OwnershipTransferred(address indexed previousOwner, address indexed newOwner);
1122 
1123     /**
1124      * @dev Initializes the contract setting the deployer as the initial owner.
1125      */
1126     constructor () {
1127         address msgSender = _msgSender();
1128         _owner = msgSender;
1129         emit OwnershipTransferred(address(0), msgSender);
1130     }
1131 
1132     /**
1133      * @dev Returns the address of the current owner.
1134      */
1135     function owner() public view virtual returns (address) {
1136         return _owner;
1137     }
1138 
1139     /**
1140      * @dev Throws if called by any account other than the owner.
1141      */
1142     modifier onlyOwner() {
1143         require(owner() == _msgSender(), "Ownable: caller is not the owner");
1144         _;
1145     }
1146 
1147     /**
1148      * @dev Leaves the contract without owner. It will not be possible to call
1149      * `onlyOwner` functions anymore. Can only be called by the current owner.
1150      *
1151      * NOTE: Renouncing ownership will leave the contract without an owner,
1152      * thereby removing any functionality that is only available to the owner.
1153      */
1154     function renounceOwnership() public virtual onlyOwner {
1155         emit OwnershipTransferred(_owner, address(0));
1156         _owner = address(0);
1157     }
1158 
1159     /**
1160      * @dev Transfers ownership of the contract to a new account (`newOwner`).
1161      * Can only be called by the current owner.
1162      */
1163     function transferOwnership(address newOwner) public virtual onlyOwner {
1164         require(newOwner != address(0), "Ownable: new owner is the zero address");
1165         emit OwnershipTransferred(_owner, newOwner);
1166         _owner = newOwner;
1167     }
1168 }
1169 
1170 // File: contracts/Hoes.sol
1171 pragma solidity ^0.8.0;
1172 
1173 contract Hoes is ERC721Enumerable, Ownable {
1174     uint256 public constant MAX_NFT_SUPPLY = 7777;
1175     uint public constant MAX_PURCHASABLE = 50;
1176     uint256 public constant HOES_PRICE = 33690000000000000; // 0.03369 ETH
1177     string public PROVENANCE_HASH = "";
1178 
1179     bool public saleStarted = false;
1180 
1181     constructor() ERC721("Hoes", "HOES") {
1182     }
1183 
1184     function _baseURI() internal view virtual override returns (string memory) {
1185         return "https://api.nonfungiblehoes.io/";
1186     }
1187 
1188     function getTokenURI(uint256 tokenId) public view returns (string memory) {
1189         return tokenURI(tokenId);
1190     }
1191 
1192    function mint(uint256 amountToMint) public payable {
1193         require(saleStarted == true, "This sale has not started.");
1194         require(totalSupply() < MAX_NFT_SUPPLY, "All NFTs have been minted.");
1195         require(amountToMint > 0, "You must mint at least one hoe.");
1196         require(amountToMint <= MAX_PURCHASABLE, "You cannot mint more than 50 hoes.");
1197         require(totalSupply() + amountToMint <= MAX_NFT_SUPPLY, "The amount of hoes you are trying to mint exceeds the MAX_NFT_SUPPLY.");
1198         
1199         require(HOES_PRICE * amountToMint == msg.value, "Incorrect Ether value.");
1200 
1201         for (uint256 i = 0; i < amountToMint; i++) {
1202             uint256 mintIndex = totalSupply();
1203             _safeMint(msg.sender, mintIndex);
1204         }
1205    }
1206 
1207     function startSale() public onlyOwner {
1208         saleStarted = true;
1209     }
1210 
1211     function pauseSale() public onlyOwner {
1212         saleStarted = false;
1213     }
1214 
1215    function reserveTokens() public onlyOwner {  
1216        require(saleStarted == false, "Owner cannot mint tokens after the sale has started.");
1217 
1218        for (uint256 i = 0; i < 110; i++) {
1219            uint256 mintIndex = totalSupply();
1220            _safeMint(msg.sender, mintIndex);
1221        }
1222    }
1223 
1224     function setProvenanceHash(string memory _hash) public onlyOwner {
1225         PROVENANCE_HASH = _hash;
1226     }
1227 
1228     function withdraw() public payable onlyOwner {
1229         require(payable(msg.sender).send(address(this).balance));
1230     }
1231 }