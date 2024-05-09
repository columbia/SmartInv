1 // SPDX-License-Identifier: MIT
2             
3 
4 
5 pragma solidity ^0.8.0;
6 
7 /**
8  * @dev Interface of the ERC165 standard, as defined in the
9  * https://eips.ethereum.org/EIPS/eip-165[EIP].
10  *
11  * Implementers can declare support of contract interfaces, which can then be
12  * queried by others ({ERC165Checker}).
13  *
14  * For an implementation, see {ERC165}.
15  */
16 interface IERC165 {
17     /**
18      * @dev Returns true if this contract implements the interface defined by
19      * `interfaceId`. See the corresponding
20      * https://eips.ethereum.org/EIPS/eip-165#how-interfaces-are-identified[EIP section]
21      * to learn more about how these ids are created.
22      *
23      * This function call must use less than 30 000 gas.
24      */
25     function supportsInterface(bytes4 interfaceId) external view returns (bool);
26 }
27 
28 
29 
30 
31 
32             
33 
34 
35 pragma solidity ^0.8.0;
36 
37 ////import "../../utils/introspection/IERC165.sol";
38 
39 /**
40  * @dev Required interface of an ERC721 compliant contract.
41  */
42 interface IERC721 is IERC165 {
43     /**
44      * @dev Emitted when `tokenId` token is transferred from `from` to `to`.
45      */
46     event Transfer(address indexed from, address indexed to, uint256 indexed tokenId);
47 
48     /**
49      * @dev Emitted when `owner` enables `approved` to manage the `tokenId` token.
50      */
51     event Approval(address indexed owner, address indexed approved, uint256 indexed tokenId);
52 
53     /**
54      * @dev Emitted when `owner` enables or disables (`approved`) `operator` to manage all of its assets.
55      */
56     event ApprovalForAll(address indexed owner, address indexed operator, bool approved);
57 
58     /**
59      * @dev Returns the number of tokens in ``owner``'s account.
60      */
61     function balanceOf(address owner) external view returns (uint256 balance);
62 
63     /**
64      * @dev Returns the owner of the `tokenId` token.
65      *
66      * Requirements:
67      *
68      * - `tokenId` must exist.
69      */
70     function ownerOf(uint256 tokenId) external view returns (address owner);
71 
72     /**
73      * @dev Safely transfers `tokenId` token from `from` to `to`, checking first that contract recipients
74      * are aware of the ERC721 protocol to prevent tokens from being forever locked.
75      *
76      * Requirements:
77      *
78      * - `from` cannot be the zero address.
79      * - `to` cannot be the zero address.
80      * - `tokenId` token must exist and be owned by `from`.
81      * - If the caller is not `from`, it must be have been allowed to move this token by either {approve} or {setApprovalForAll}.
82      * - If `to` refers to a smart contract, it must implement {IERC721Receiver-onERC721Received}, which is called upon a safe transfer.
83      *
84      * Emits a {Transfer} event.
85      */
86     function safeTransferFrom(address from, address to, uint256 tokenId) external;
87 
88     /**
89      * @dev Transfers `tokenId` token from `from` to `to`.
90      *
91      * WARNING: Usage of this method is discouraged, use {safeTransferFrom} whenever possible.
92      *
93      * Requirements:
94      *
95      * - `from` cannot be the zero address.
96      * - `to` cannot be the zero address.
97      * - `tokenId` token must be owned by `from`.
98      * - If the caller is not `from`, it must be approved to move this token by either {approve} or {setApprovalForAll}.
99      *
100      * Emits a {Transfer} event.
101      */
102     function transferFrom(address from, address to, uint256 tokenId) external;
103 
104     /**
105      * @dev Gives permission to `to` to transfer `tokenId` token to another account.
106      * The approval is cleared when the token is transferred.
107      *
108      * Only a single account can be approved at a time, so approving the zero address clears previous approvals.
109      *
110      * Requirements:
111      *
112      * - The caller must own the token or be an approved operator.
113      * - `tokenId` must exist.
114      *
115      * Emits an {Approval} event.
116      */
117     function approve(address to, uint256 tokenId) external;
118 
119     /**
120      * @dev Returns the account approved for `tokenId` token.
121      *
122      * Requirements:
123      *
124      * - `tokenId` must exist.
125      */
126     function getApproved(uint256 tokenId) external view returns (address operator);
127 
128     /**
129      * @dev Approve or remove `operator` as an operator for the caller.
130      * Operators can call {transferFrom} or {safeTransferFrom} for any token owned by the caller.
131      *
132      * Requirements:
133      *
134      * - The `operator` cannot be the caller.
135      *
136      * Emits an {ApprovalForAll} event.
137      */
138     function setApprovalForAll(address operator, bool _approved) external;
139 
140     /**
141      * @dev Returns if the `operator` is allowed to manage all of the assets of `owner`.
142      *
143      * See {setApprovalForAll}
144      */
145     function isApprovedForAll(address owner, address operator) external view returns (bool);
146 
147     /**
148       * @dev Safely transfers `tokenId` token from `from` to `to`.
149       *
150       * Requirements:
151       *
152       * - `from` cannot be the zero address.
153       * - `to` cannot be the zero address.
154       * - `tokenId` token must exist and be owned by `from`.
155       * - If the caller is not `from`, it must be approved to move this token by either {approve} or {setApprovalForAll}.
156       * - If `to` refers to a smart contract, it must implement {IERC721Receiver-onERC721Received}, which is called upon a safe transfer.
157       *
158       * Emits a {Transfer} event.
159       */
160     function safeTransferFrom(address from, address to, uint256 tokenId, bytes calldata data) external;
161 }
162 
163 
164 
165 
166 
167             
168 
169 
170 pragma solidity ^0.8.0;
171 
172 ////import "./IERC165.sol";
173 
174 /**
175  * @dev Implementation of the {IERC165} interface.
176  *
177  * Contracts that want to implement ERC165 should inherit from this contract and override {supportsInterface} to check
178  * for the additional interface id that will be supported. For example:
179  *
180  * ```solidity
181  * function supportsInterface(bytes4 interfaceId) public view virtual override returns (bool) {
182  *     return interfaceId == type(MyInterface).interfaceId || super.supportsInterface(interfaceId);
183  * }
184  * ```
185  *
186  * Alternatively, {ERC165Storage} provides an easier to use but more expensive implementation.
187  */
188 abstract contract ERC165 is IERC165 {
189     /**
190      * @dev See {IERC165-supportsInterface}.
191      */
192     function supportsInterface(bytes4 interfaceId) public view virtual override returns (bool) {
193         return interfaceId == type(IERC165).interfaceId;
194     }
195 }
196 
197 
198 
199 
200 
201             
202 
203 
204 pragma solidity ^0.8.0;
205 
206 /**
207  * @dev String operations.
208  */
209 library Strings {
210     bytes16 private constant alphabet = "0123456789abcdef";
211 
212     /**
213      * @dev Converts a `uint256` to its ASCII `string` decimal representation.
214      */
215     function toString(uint256 value) internal pure returns (string memory) {
216         // Inspired by OraclizeAPI's implementation - MIT licence
217         // https://github.com/oraclize/ethereum-api/blob/b42146b063c7d6ee1358846c198246239e9360e8/oraclizeAPI_0.4.25.sol
218 
219         if (value == 0) {
220             return "0";
221         }
222         uint256 temp = value;
223         uint256 digits;
224         while (temp != 0) {
225             digits++;
226             temp /= 10;
227         }
228         bytes memory buffer = new bytes(digits);
229         while (value != 0) {
230             digits -= 1;
231             buffer[digits] = bytes1(uint8(48 + uint256(value % 10)));
232             value /= 10;
233         }
234         return string(buffer);
235     }
236 
237     /**
238      * @dev Converts a `uint256` to its ASCII `string` hexadecimal representation.
239      */
240     function toHexString(uint256 value) internal pure returns (string memory) {
241         if (value == 0) {
242             return "0x00";
243         }
244         uint256 temp = value;
245         uint256 length = 0;
246         while (temp != 0) {
247             length++;
248             temp >>= 8;
249         }
250         return toHexString(value, length);
251     }
252 
253     /**
254      * @dev Converts a `uint256` to its ASCII `string` hexadecimal representation with fixed length.
255      */
256     function toHexString(uint256 value, uint256 length) internal pure returns (string memory) {
257         bytes memory buffer = new bytes(2 * length + 2);
258         buffer[0] = "0";
259         buffer[1] = "x";
260         for (uint256 i = 2 * length + 1; i > 1; --i) {
261             buffer[i] = alphabet[value & 0xf];
262             value >>= 4;
263         }
264         require(value == 0, "Strings: hex length insufficient");
265         return string(buffer);
266     }
267 
268 }
269 
270 
271 
272 
273 
274             
275 
276 
277 pragma solidity ^0.8.0;
278 
279 /*
280  * @dev Provides information about the current execution context, including the
281  * sender of the transaction and its data. While these are generally available
282  * via msg.sender and msg.data, they should not be accessed in such a direct
283  * manner, since when dealing with meta-transactions the account sending and
284  * paying for execution may not be the actual sender (as far as an application
285  * is concerned).
286  *
287  * This contract is only required for intermediate, library-like contracts.
288  */
289 abstract contract Context {
290     function _msgSender() internal view virtual returns (address) {
291         return msg.sender;
292     }
293 
294     function _msgData() internal view virtual returns (bytes calldata) {
295         this; // silence state mutability warning without generating bytecode - see https://github.com/ethereum/solidity/issues/2691
296         return msg.data;
297     }
298 }
299 
300 
301 
302 
303 
304             
305 
306 
307 pragma solidity ^0.8.0;
308 
309 /**
310  * @dev Collection of functions related to the address type
311  */
312 library Address {
313     /**
314      * @dev Returns true if `account` is a contract.
315      *
316      * [////IMPORTANT]
317      * ====
318      * It is unsafe to assume that an address for which this function returns
319      * false is an externally-owned account (EOA) and not a contract.
320      *
321      * Among others, `isContract` will return false for the following
322      * types of addresses:
323      *
324      *  - an externally-owned account
325      *  - a contract in construction
326      *  - an address where a contract will be created
327      *  - an address where a contract lived, but was destroyed
328      * ====
329      */
330     function isContract(address account) internal view returns (bool) {
331         // This method relies on extcodesize, which returns 0 for contracts in
332         // construction, since the code is only stored at the end of the
333         // constructor execution.
334 
335         uint256 size;
336         // solhint-disable-next-line no-inline-assembly
337         assembly { size := extcodesize(account) }
338         return size > 0;
339     }
340 
341     /**
342      * @dev Replacement for Solidity's `transfer`: sends `amount` wei to
343      * `recipient`, forwarding all available gas and reverting on errors.
344      *
345      * https://eips.ethereum.org/EIPS/eip-1884[EIP1884] increases the gas cost
346      * of certain opcodes, possibly making contracts go over the 2300 gas limit
347      * imposed by `transfer`, making them unable to receive funds via
348      * `transfer`. {sendValue} removes this limitation.
349      *
350      * https://diligence.consensys.net/posts/2019/09/stop-using-soliditys-transfer-now/[Learn more].
351      *
352      * ////IMPORTANT: because control is transferred to `recipient`, care must be
353      * taken to not create reentrancy vulnerabilities. Consider using
354      * {ReentrancyGuard} or the
355      * https://solidity.readthedocs.io/en/v0.5.11/security-considerations.html#use-the-checks-effects-interactions-pattern[checks-effects-interactions pattern].
356      */
357     function sendValue(address payable recipient, uint256 amount) internal {
358         require(address(this).balance >= amount, "Address: insufficient balance");
359 
360         // solhint-disable-next-line avoid-low-level-calls, avoid-call-value
361         (bool success, ) = recipient.call{ value: amount }("");
362         require(success, "Address: unable to send value, recipient may have reverted");
363     }
364 
365     /**
366      * @dev Performs a Solidity function call using a low level `call`. A
367      * plain`call` is an unsafe replacement for a function call: use this
368      * function instead.
369      *
370      * If `target` reverts with a revert reason, it is bubbled up by this
371      * function (like regular Solidity function calls).
372      *
373      * Returns the raw returned data. To convert to the expected return value,
374      * use https://solidity.readthedocs.io/en/latest/units-and-global-variables.html?highlight=abi.decode#abi-encoding-and-decoding-functions[`abi.decode`].
375      *
376      * Requirements:
377      *
378      * - `target` must be a contract.
379      * - calling `target` with `data` must not revert.
380      *
381      * _Available since v3.1._
382      */
383     function functionCall(address target, bytes memory data) internal returns (bytes memory) {
384       return functionCall(target, data, "Address: low-level call failed");
385     }
386 
387     /**
388      * @dev Same as {xref-Address-functionCall-address-bytes-}[`functionCall`], but with
389      * `errorMessage` as a fallback revert reason when `target` reverts.
390      *
391      * _Available since v3.1._
392      */
393     function functionCall(address target, bytes memory data, string memory errorMessage) internal returns (bytes memory) {
394         return functionCallWithValue(target, data, 0, errorMessage);
395     }
396 
397     /**
398      * @dev Same as {xref-Address-functionCall-address-bytes-}[`functionCall`],
399      * but also transferring `value` wei to `target`.
400      *
401      * Requirements:
402      *
403      * - the calling contract must have an ETH balance of at least `value`.
404      * - the called Solidity function must be `payable`.
405      *
406      * _Available since v3.1._
407      */
408     function functionCallWithValue(address target, bytes memory data, uint256 value) internal returns (bytes memory) {
409         return functionCallWithValue(target, data, value, "Address: low-level call with value failed");
410     }
411 
412     /**
413      * @dev Same as {xref-Address-functionCallWithValue-address-bytes-uint256-}[`functionCallWithValue`], but
414      * with `errorMessage` as a fallback revert reason when `target` reverts.
415      *
416      * _Available since v3.1._
417      */
418     function functionCallWithValue(address target, bytes memory data, uint256 value, string memory errorMessage) internal returns (bytes memory) {
419         require(address(this).balance >= value, "Address: insufficient balance for call");
420         require(isContract(target), "Address: call to non-contract");
421 
422         // solhint-disable-next-line avoid-low-level-calls
423         (bool success, bytes memory returndata) = target.call{ value: value }(data);
424         return _verifyCallResult(success, returndata, errorMessage);
425     }
426 
427     /**
428      * @dev Same as {xref-Address-functionCall-address-bytes-}[`functionCall`],
429      * but performing a static call.
430      *
431      * _Available since v3.3._
432      */
433     function functionStaticCall(address target, bytes memory data) internal view returns (bytes memory) {
434         return functionStaticCall(target, data, "Address: low-level static call failed");
435     }
436 
437     /**
438      * @dev Same as {xref-Address-functionCall-address-bytes-string-}[`functionCall`],
439      * but performing a static call.
440      *
441      * _Available since v3.3._
442      */
443     function functionStaticCall(address target, bytes memory data, string memory errorMessage) internal view returns (bytes memory) {
444         require(isContract(target), "Address: static call to non-contract");
445 
446         // solhint-disable-next-line avoid-low-level-calls
447         (bool success, bytes memory returndata) = target.staticcall(data);
448         return _verifyCallResult(success, returndata, errorMessage);
449     }
450 
451     /**
452      * @dev Same as {xref-Address-functionCall-address-bytes-}[`functionCall`],
453      * but performing a delegate call.
454      *
455      * _Available since v3.4._
456      */
457     function functionDelegateCall(address target, bytes memory data) internal returns (bytes memory) {
458         return functionDelegateCall(target, data, "Address: low-level delegate call failed");
459     }
460 
461     /**
462      * @dev Same as {xref-Address-functionCall-address-bytes-string-}[`functionCall`],
463      * but performing a delegate call.
464      *
465      * _Available since v3.4._
466      */
467     function functionDelegateCall(address target, bytes memory data, string memory errorMessage) internal returns (bytes memory) {
468         require(isContract(target), "Address: delegate call to non-contract");
469 
470         // solhint-disable-next-line avoid-low-level-calls
471         (bool success, bytes memory returndata) = target.delegatecall(data);
472         return _verifyCallResult(success, returndata, errorMessage);
473     }
474 
475     function _verifyCallResult(bool success, bytes memory returndata, string memory errorMessage) private pure returns(bytes memory) {
476         if (success) {
477             return returndata;
478         } else {
479             // Look for revert reason and bubble it up if present
480             if (returndata.length > 0) {
481                 // The easiest way to bubble the revert reason is using memory via assembly
482 
483                 // solhint-disable-next-line no-inline-assembly
484                 assembly {
485                     let returndata_size := mload(returndata)
486                     revert(add(32, returndata), returndata_size)
487                 }
488             } else {
489                 revert(errorMessage);
490             }
491         }
492     }
493 }
494 
495 
496 
497 
498 
499             
500 
501 
502 pragma solidity ^0.8.0;
503 
504 ////import "../IERC721.sol";
505 
506 /**
507  * @title ERC-721 Non-Fungible Token Standard, optional metadata extension
508  * @dev See https://eips.ethereum.org/EIPS/eip-721
509  */
510 interface IERC721Metadata is IERC721 {
511 
512     /**
513      * @dev Returns the token collection name.
514      */
515     function name() external view returns (string memory);
516 
517     /**
518      * @dev Returns the token collection symbol.
519      */
520     function symbol() external view returns (string memory);
521 
522     /**
523      * @dev Returns the Uniform Resource Identifier (URI) for `tokenId` token.
524      */
525     function tokenURI(uint256 tokenId) external view returns (string memory);
526 }
527 
528 
529 
530 
531 
532             
533 
534 
535 pragma solidity ^0.8.0;
536 
537 /**
538  * @title ERC721 token receiver interface
539  * @dev Interface for any contract that wants to support safeTransfers
540  * from ERC721 asset contracts.
541  */
542 interface IERC721Receiver {
543     /**
544      * @dev Whenever an {IERC721} `tokenId` token is transferred to this contract via {IERC721-safeTransferFrom}
545      * by `operator` from `from`, this function is called.
546      *
547      * It must return its Solidity selector to confirm the token transfer.
548      * If any other value is returned or the interface is not implemented by the recipient, the transfer will be reverted.
549      *
550      * The selector can be obtained in Solidity with `IERC721.onERC721Received.selector`.
551      */
552     function onERC721Received(address operator, address from, uint256 tokenId, bytes calldata data) external returns (bytes4);
553 }
554 
555 
556 
557 
558 
559             
560 
561 
562 pragma solidity ^0.8.0;
563 
564 ////import "./IERC721.sol";
565 ////import "./IERC721Receiver.sol";
566 ////import "./extensions/IERC721Metadata.sol";
567 ////import "../../utils/Address.sol";
568 ////import "../../utils/Context.sol";
569 ////import "../../utils/Strings.sol";
570 ////import "../../utils/introspection/ERC165.sol";
571 
572 /**
573  * @dev Implementation of https://eips.ethereum.org/EIPS/eip-721[ERC721] Non-Fungible Token Standard, including
574  * the Metadata extension, but not including the Enumerable extension, which is available separately as
575  * {ERC721Enumerable}.
576  */
577 contract ERC721 is Context, ERC165, IERC721, IERC721Metadata {
578     using Address for address;
579     using Strings for uint256;
580 
581     // Token name
582     string private _name;
583 
584     // Token symbol
585     string private _symbol;
586 
587     // Mapping from token ID to owner address
588     mapping (uint256 => address) private _owners;
589 
590     // Mapping owner address to token count
591     mapping (address => uint256) private _balances;
592 
593     // Mapping from token ID to approved address
594     mapping (uint256 => address) private _tokenApprovals;
595 
596     // Mapping from owner to operator approvals
597     mapping (address => mapping (address => bool)) private _operatorApprovals;
598 
599     /**
600      * @dev Initializes the contract by setting a `name` and a `symbol` to the token collection.
601      */
602     constructor (string memory name_, string memory symbol_) {
603         _name = name_;
604         _symbol = symbol_;
605     }
606 
607     /**
608      * @dev See {IERC165-supportsInterface}.
609      */
610     function supportsInterface(bytes4 interfaceId) public view virtual override(ERC165, IERC165) returns (bool) {
611         return interfaceId == type(IERC721).interfaceId
612             || interfaceId == type(IERC721Metadata).interfaceId
613             || super.supportsInterface(interfaceId);
614     }
615 
616     /**
617      * @dev See {IERC721-balanceOf}.
618      */
619     function balanceOf(address owner) public view virtual override returns (uint256) {
620         require(owner != address(0), "ERC721: balance query for the zero address");
621         return _balances[owner];
622     }
623 
624     /**
625      * @dev See {IERC721-ownerOf}.
626      */
627     function ownerOf(uint256 tokenId) public view virtual override returns (address) {
628         address owner = _owners[tokenId];
629         require(owner != address(0), "ERC721: owner query for nonexistent token");
630         return owner;
631     }
632 
633     /**
634      * @dev See {IERC721Metadata-name}.
635      */
636     function name() public view virtual override returns (string memory) {
637         return _name;
638     }
639 
640     /**
641      * @dev See {IERC721Metadata-symbol}.
642      */
643     function symbol() public view virtual override returns (string memory) {
644         return _symbol;
645     }
646 
647     /**
648      * @dev See {IERC721Metadata-tokenURI}.
649      */
650     function tokenURI(uint256 tokenId) public view virtual override returns (string memory) {
651         require(_exists(tokenId), "ERC721Metadata: URI query for nonexistent token");
652 
653         string memory baseURI = _baseURI();
654         return bytes(baseURI).length > 0
655             ? string(abi.encodePacked(baseURI, tokenId.toString()))
656             : '';
657     }
658 
659     /**
660      * @dev Base URI for computing {tokenURI}. Empty by default, can be overriden
661      * in child contracts.
662      */
663     function _baseURI() internal view virtual returns (string memory) {
664         return "";
665     }
666 
667     /**
668      * @dev See {IERC721-approve}.
669      */
670     function approve(address to, uint256 tokenId) public virtual override {
671         address owner = ERC721.ownerOf(tokenId);
672         require(to != owner, "ERC721: approval to current owner");
673 
674         require(_msgSender() == owner || isApprovedForAll(owner, _msgSender()),
675             "ERC721: approve caller is not owner nor approved for all"
676         );
677 
678         _approve(to, tokenId);
679     }
680 
681     /**
682      * @dev See {IERC721-getApproved}.
683      */
684     function getApproved(uint256 tokenId) public view virtual override returns (address) {
685         require(_exists(tokenId), "ERC721: approved query for nonexistent token");
686 
687         return _tokenApprovals[tokenId];
688     }
689 
690     /**
691      * @dev See {IERC721-setApprovalForAll}.
692      */
693     function setApprovalForAll(address operator, bool approved) public virtual override {
694         require(operator != _msgSender(), "ERC721: approve to caller");
695 
696         _operatorApprovals[_msgSender()][operator] = approved;
697         emit ApprovalForAll(_msgSender(), operator, approved);
698     }
699 
700     /**
701      * @dev See {IERC721-isApprovedForAll}.
702      */
703     function isApprovedForAll(address owner, address operator) public view virtual override returns (bool) {
704         return _operatorApprovals[owner][operator];
705     }
706 
707     /**
708      * @dev See {IERC721-transferFrom}.
709      */
710     function transferFrom(address from, address to, uint256 tokenId) public virtual override {
711         //solhint-disable-next-line max-line-length
712         require(_isApprovedOrOwner(_msgSender(), tokenId), "ERC721: transfer caller is not owner nor approved");
713 
714         _transfer(from, to, tokenId);
715     }
716 
717     /**
718      * @dev See {IERC721-safeTransferFrom}.
719      */
720     function safeTransferFrom(address from, address to, uint256 tokenId) public virtual override {
721         safeTransferFrom(from, to, tokenId, "");
722     }
723 
724     /**
725      * @dev See {IERC721-safeTransferFrom}.
726      */
727     function safeTransferFrom(address from, address to, uint256 tokenId, bytes memory _data) public virtual override {
728         require(_isApprovedOrOwner(_msgSender(), tokenId), "ERC721: transfer caller is not owner nor approved");
729         _safeTransfer(from, to, tokenId, _data);
730     }
731 
732     /**
733      * @dev Safely transfers `tokenId` token from `from` to `to`, checking first that contract recipients
734      * are aware of the ERC721 protocol to prevent tokens from being forever locked.
735      *
736      * `_data` is additional data, it has no specified format and it is sent in call to `to`.
737      *
738      * This internal function is equivalent to {safeTransferFrom}, and can be used to e.g.
739      * implement alternative mechanisms to perform token transfer, such as signature-based.
740      *
741      * Requirements:
742      *
743      * - `from` cannot be the zero address.
744      * - `to` cannot be the zero address.
745      * - `tokenId` token must exist and be owned by `from`.
746      * - If `to` refers to a smart contract, it must implement {IERC721Receiver-onERC721Received}, which is called upon a safe transfer.
747      *
748      * Emits a {Transfer} event.
749      */
750     function _safeTransfer(address from, address to, uint256 tokenId, bytes memory _data) internal virtual {
751         _transfer(from, to, tokenId);
752         require(_checkOnERC721Received(from, to, tokenId, _data), "ERC721: transfer to non ERC721Receiver implementer");
753     }
754 
755     /**
756      * @dev Returns whether `tokenId` exists.
757      *
758      * Tokens can be managed by their owner or approved accounts via {approve} or {setApprovalForAll}.
759      *
760      * Tokens start existing when they are minted (`_mint`),
761      * and stop existing when they are burned (`_burn`).
762      */
763     function _exists(uint256 tokenId) internal view virtual returns (bool) {
764         return _owners[tokenId] != address(0);
765     }
766 
767     /**
768      * @dev Returns whether `spender` is allowed to manage `tokenId`.
769      *
770      * Requirements:
771      *
772      * - `tokenId` must exist.
773      */
774     function _isApprovedOrOwner(address spender, uint256 tokenId) internal view virtual returns (bool) {
775         require(_exists(tokenId), "ERC721: operator query for nonexistent token");
776         address owner = ERC721.ownerOf(tokenId);
777         return (spender == owner || getApproved(tokenId) == spender || isApprovedForAll(owner, spender));
778     }
779 
780     /**
781      * @dev Safely mints `tokenId` and transfers it to `to`.
782      *
783      * Requirements:
784      *
785      * - `tokenId` must not exist.
786      * - If `to` refers to a smart contract, it must implement {IERC721Receiver-onERC721Received}, which is called upon a safe transfer.
787      *
788      * Emits a {Transfer} event.
789      */
790     function _safeMint(address to, uint256 tokenId) internal virtual {
791         _safeMint(to, tokenId, "");
792     }
793 
794     /**
795      * @dev Same as {xref-ERC721-_safeMint-address-uint256-}[`_safeMint`], with an additional `data` parameter which is
796      * forwarded in {IERC721Receiver-onERC721Received} to contract recipients.
797      */
798     function _safeMint(address to, uint256 tokenId, bytes memory _data) internal virtual {
799         _mint(to, tokenId);
800         require(_checkOnERC721Received(address(0), to, tokenId, _data), "ERC721: transfer to non ERC721Receiver implementer");
801     }
802 
803     /**
804      * @dev Mints `tokenId` and transfers it to `to`.
805      *
806      * WARNING: Usage of this method is discouraged, use {_safeMint} whenever possible
807      *
808      * Requirements:
809      *
810      * - `tokenId` must not exist.
811      * - `to` cannot be the zero address.
812      *
813      * Emits a {Transfer} event.
814      */
815     function _mint(address to, uint256 tokenId) internal virtual {
816         require(to != address(0), "ERC721: mint to the zero address");
817         require(!_exists(tokenId), "ERC721: token already minted");
818 
819         _beforeTokenTransfer(address(0), to, tokenId);
820 
821         _balances[to] += 1;
822         _owners[tokenId] = to;
823 
824         emit Transfer(address(0), to, tokenId);
825     }
826 
827     /**
828      * @dev Destroys `tokenId`.
829      * The approval is cleared when the token is burned.
830      *
831      * Requirements:
832      *
833      * - `tokenId` must exist.
834      *
835      * Emits a {Transfer} event.
836      */
837     function _burn(uint256 tokenId) internal virtual {
838         address owner = ERC721.ownerOf(tokenId);
839 
840         _beforeTokenTransfer(owner, address(0), tokenId);
841 
842         // Clear approvals
843         _approve(address(0), tokenId);
844 
845         _balances[owner] -= 1;
846         delete _owners[tokenId];
847 
848         emit Transfer(owner, address(0), tokenId);
849     }
850 
851     /**
852      * @dev Transfers `tokenId` from `from` to `to`.
853      *  As opposed to {transferFrom}, this imposes no restrictions on msg.sender.
854      *
855      * Requirements:
856      *
857      * - `to` cannot be the zero address.
858      * - `tokenId` token must be owned by `from`.
859      *
860      * Emits a {Transfer} event.
861      */
862     function _transfer(address from, address to, uint256 tokenId) internal virtual {
863         require(ERC721.ownerOf(tokenId) == from, "ERC721: transfer of token that is not own");
864         require(to != address(0), "ERC721: transfer to the zero address");
865 
866         _beforeTokenTransfer(from, to, tokenId);
867 
868         // Clear approvals from the previous owner
869         _approve(address(0), tokenId);
870 
871         _balances[from] -= 1;
872         _balances[to] += 1;
873         _owners[tokenId] = to;
874 
875         emit Transfer(from, to, tokenId);
876     }
877 
878     /**
879      * @dev Approve `to` to operate on `tokenId`
880      *
881      * Emits a {Approval} event.
882      */
883     function _approve(address to, uint256 tokenId) internal virtual {
884         _tokenApprovals[tokenId] = to;
885         emit Approval(ERC721.ownerOf(tokenId), to, tokenId);
886     }
887 
888     /**
889      * @dev Internal function to invoke {IERC721Receiver-onERC721Received} on a target address.
890      * The call is not executed if the target address is not a contract.
891      *
892      * @param from address representing the previous owner of the given token ID
893      * @param to target address that will receive the tokens
894      * @param tokenId uint256 ID of the token to be transferred
895      * @param _data bytes optional data to send along with the call
896      * @return bool whether the call correctly returned the expected magic value
897      */
898     function _checkOnERC721Received(address from, address to, uint256 tokenId, bytes memory _data)
899         private returns (bool)
900     {
901         if (to.isContract()) {
902             try IERC721Receiver(to).onERC721Received(_msgSender(), from, tokenId, _data) returns (bytes4 retval) {
903                 return retval == IERC721Receiver(to).onERC721Received.selector;
904             } catch (bytes memory reason) {
905                 if (reason.length == 0) {
906                     revert("ERC721: transfer to non ERC721Receiver implementer");
907                 } else {
908                     // solhint-disable-next-line no-inline-assembly
909                     assembly {
910                         revert(add(32, reason), mload(reason))
911                     }
912                 }
913             }
914         } else {
915             return true;
916         }
917     }
918 
919     /**
920      * @dev Hook that is called before any token transfer. This includes minting
921      * and burning.
922      *
923      * Calling conditions:
924      *
925      * - When `from` and `to` are both non-zero, ``from``'s `tokenId` will be
926      * transferred to `to`.
927      * - When `from` is zero, `tokenId` will be minted for `to`.
928      * - When `to` is zero, ``from``'s `tokenId` will be burned.
929      * - `from` cannot be the zero address.
930      * - `to` cannot be the zero address.
931      *
932      * To learn more about hooks, head to xref:ROOT:extending-contracts.adoc#using-hooks[Using Hooks].
933      */
934     function _beforeTokenTransfer(address from, address to, uint256 tokenId) internal virtual { }
935 }
936 
937 
938 
939 
940 
941             
942 
943 
944 pragma solidity ^0.8.0;
945 
946 ////import "../IERC721.sol";
947 
948 /**
949  * @title ERC-721 Non-Fungible Token Standard, optional enumeration extension
950  * @dev See https://eips.ethereum.org/EIPS/eip-721
951  */
952 interface IERC721Enumerable is IERC721 {
953 
954     /**
955      * @dev Returns the total amount of tokens stored by the contract.
956      */
957     function totalSupply() external view returns (uint256);
958 
959     /**
960      * @dev Returns a token ID owned by `owner` at a given `index` of its token list.
961      * Use along with {balanceOf} to enumerate all of ``owner``'s tokens.
962      */
963     function tokenOfOwnerByIndex(address owner, uint256 index) external view returns (uint256 tokenId);
964 
965     /**
966      * @dev Returns a token ID at a given `index` of all the tokens stored by the contract.
967      * Use along with {totalSupply} to enumerate all tokens.
968      */
969     function tokenByIndex(uint256 index) external view returns (uint256);
970 }
971 
972 
973 
974 
975 
976             
977 
978 
979 pragma solidity ^0.8.0;
980 
981 ////import "../ERC721.sol";
982 
983 /**
984  * @dev ERC721 token with storage based token URI management.
985  */
986 abstract contract ERC721URIStorage is ERC721 {
987     using Strings for uint256;
988 
989     // Optional mapping for token URIs
990     mapping (uint256 => string) private _tokenURIs;
991 
992     /**
993      * @dev See {IERC721Metadata-tokenURI}.
994      */
995     function tokenURI(uint256 tokenId) public view virtual override returns (string memory) {
996         require(_exists(tokenId), "ERC721URIStorage: URI query for nonexistent token");
997 
998         string memory _tokenURI = _tokenURIs[tokenId];
999         string memory base = _baseURI();
1000 
1001         // If there is no base URI, return the token URI.
1002         if (bytes(base).length == 0) {
1003             return _tokenURI;
1004         }
1005         // If both are set, concatenate the baseURI and tokenURI (via abi.encodePacked).
1006         if (bytes(_tokenURI).length > 0) {
1007             return string(abi.encodePacked(base, _tokenURI));
1008         }
1009 
1010         return super.tokenURI(tokenId);
1011     }
1012 
1013     /**
1014      * @dev Sets `_tokenURI` as the tokenURI of `tokenId`.
1015      *
1016      * Requirements:
1017      *
1018      * - `tokenId` must exist.
1019      */
1020     function _setTokenURI(uint256 tokenId, string memory _tokenURI) internal virtual {
1021         require(_exists(tokenId), "ERC721URIStorage: URI set of nonexistent token");
1022         _tokenURIs[tokenId] = _tokenURI;
1023     }
1024 
1025     /**
1026      * @dev Destroys `tokenId`.
1027      * The approval is cleared when the token is burned.
1028      *
1029      * Requirements:
1030      *
1031      * - `tokenId` must exist.
1032      *
1033      * Emits a {Transfer} event.
1034      */
1035     function _burn(uint256 tokenId) internal virtual override {
1036         super._burn(tokenId);
1037 
1038         if (bytes(_tokenURIs[tokenId]).length != 0) {
1039             delete _tokenURIs[tokenId];
1040         }
1041     }
1042 }
1043 
1044 
1045 
1046 
1047 
1048             
1049 
1050 
1051 pragma solidity ^0.8.0;
1052 
1053 ////import "../ERC721.sol";
1054 ////import "./IERC721Enumerable.sol";
1055 
1056 /**
1057  * @dev This implements an optional extension of {ERC721} defined in the EIP that adds
1058  * enumerability of all the token ids in the contract as well as all token ids owned by each
1059  * account.
1060  */
1061 abstract contract ERC721Enumerable is ERC721, IERC721Enumerable {
1062     // Mapping from owner to list of owned token IDs
1063     mapping(address => mapping(uint256 => uint256)) private _ownedTokens;
1064 
1065     // Mapping from token ID to index of the owner tokens list
1066     mapping(uint256 => uint256) private _ownedTokensIndex;
1067 
1068     // Array with all token ids, used for enumeration
1069     uint256[] private _allTokens;
1070 
1071     // Mapping from token id to position in the allTokens array
1072     mapping(uint256 => uint256) private _allTokensIndex;
1073 
1074     /**
1075      * @dev See {IERC165-supportsInterface}.
1076      */
1077     function supportsInterface(bytes4 interfaceId) public view virtual override(IERC165, ERC721) returns (bool) {
1078         return interfaceId == type(IERC721Enumerable).interfaceId
1079             || super.supportsInterface(interfaceId);
1080     }
1081 
1082     /**
1083      * @dev See {IERC721Enumerable-tokenOfOwnerByIndex}.
1084      */
1085     function tokenOfOwnerByIndex(address owner, uint256 index) public view virtual override returns (uint256) {
1086         require(index < ERC721.balanceOf(owner), "ERC721Enumerable: owner index out of bounds");
1087         return _ownedTokens[owner][index];
1088     }
1089 
1090     /**
1091      * @dev See {IERC721Enumerable-totalSupply}.
1092      */
1093     function totalSupply() public view virtual override returns (uint256) {
1094         return _allTokens.length;
1095     }
1096 
1097     /**
1098      * @dev See {IERC721Enumerable-tokenByIndex}.
1099      */
1100     function tokenByIndex(uint256 index) public view virtual override returns (uint256) {
1101         require(index < ERC721Enumerable.totalSupply(), "ERC721Enumerable: global index out of bounds");
1102         return _allTokens[index];
1103     }
1104 
1105     /**
1106      * @dev Hook that is called before any token transfer. This includes minting
1107      * and burning.
1108      *
1109      * Calling conditions:
1110      *
1111      * - When `from` and `to` are both non-zero, ``from``'s `tokenId` will be
1112      * transferred to `to`.
1113      * - When `from` is zero, `tokenId` will be minted for `to`.
1114      * - When `to` is zero, ``from``'s `tokenId` will be burned.
1115      * - `from` cannot be the zero address.
1116      * - `to` cannot be the zero address.
1117      *
1118      * To learn more about hooks, head to xref:ROOT:extending-contracts.adoc#using-hooks[Using Hooks].
1119      */
1120     function _beforeTokenTransfer(address from, address to, uint256 tokenId) internal virtual override {
1121         super._beforeTokenTransfer(from, to, tokenId);
1122 
1123         if (from == address(0)) {
1124             _addTokenToAllTokensEnumeration(tokenId);
1125         } else if (from != to) {
1126             _removeTokenFromOwnerEnumeration(from, tokenId);
1127         }
1128         if (to == address(0)) {
1129             _removeTokenFromAllTokensEnumeration(tokenId);
1130         } else if (to != from) {
1131             _addTokenToOwnerEnumeration(to, tokenId);
1132         }
1133     }
1134 
1135     /**
1136      * @dev Private function to add a token to this extension's ownership-tracking data structures.
1137      * @param to address representing the new owner of the given token ID
1138      * @param tokenId uint256 ID of the token to be added to the tokens list of the given address
1139      */
1140     function _addTokenToOwnerEnumeration(address to, uint256 tokenId) private {
1141         uint256 length = ERC721.balanceOf(to);
1142         _ownedTokens[to][length] = tokenId;
1143         _ownedTokensIndex[tokenId] = length;
1144     }
1145 
1146     /**
1147      * @dev Private function to add a token to this extension's token tracking data structures.
1148      * @param tokenId uint256 ID of the token to be added to the tokens list
1149      */
1150     function _addTokenToAllTokensEnumeration(uint256 tokenId) private {
1151         _allTokensIndex[tokenId] = _allTokens.length;
1152         _allTokens.push(tokenId);
1153     }
1154 
1155     /**
1156      * @dev Private function to remove a token from this extension's ownership-tracking data structures. Note that
1157      * while the token is not assigned a new owner, the `_ownedTokensIndex` mapping is _not_ updated: this allows for
1158      * gas optimizations e.g. when performing a transfer operation (avoiding double writes).
1159      * This has O(1) time complexity, but alters the order of the _ownedTokens array.
1160      * @param from address representing the previous owner of the given token ID
1161      * @param tokenId uint256 ID of the token to be removed from the tokens list of the given address
1162      */
1163     function _removeTokenFromOwnerEnumeration(address from, uint256 tokenId) private {
1164         // To prevent a gap in from's tokens array, we store the last token in the index of the token to delete, and
1165         // then delete the last slot (swap and pop).
1166 
1167         uint256 lastTokenIndex = ERC721.balanceOf(from) - 1;
1168         uint256 tokenIndex = _ownedTokensIndex[tokenId];
1169 
1170         // When the token to delete is the last token, the swap operation is unnecessary
1171         if (tokenIndex != lastTokenIndex) {
1172             uint256 lastTokenId = _ownedTokens[from][lastTokenIndex];
1173 
1174             _ownedTokens[from][tokenIndex] = lastTokenId; // Move the last token to the slot of the to-delete token
1175             _ownedTokensIndex[lastTokenId] = tokenIndex; // Update the moved token's index
1176         }
1177 
1178         // This also deletes the contents at the last position of the array
1179         delete _ownedTokensIndex[tokenId];
1180         delete _ownedTokens[from][lastTokenIndex];
1181     }
1182 
1183     /**
1184      * @dev Private function to remove a token from this extension's token tracking data structures.
1185      * This has O(1) time complexity, but alters the order of the _allTokens array.
1186      * @param tokenId uint256 ID of the token to be removed from the tokens list
1187      */
1188     function _removeTokenFromAllTokensEnumeration(uint256 tokenId) private {
1189         // To prevent a gap in the tokens array, we store the last token in the index of the token to delete, and
1190         // then delete the last slot (swap and pop).
1191 
1192         uint256 lastTokenIndex = _allTokens.length - 1;
1193         uint256 tokenIndex = _allTokensIndex[tokenId];
1194 
1195         // When the token to delete is the last token, the swap operation is unnecessary. However, since this occurs so
1196         // rarely (when the last minted token is burnt) that we still do the swap here to avoid the gas cost of adding
1197         // an 'if' statement (like in _removeTokenFromOwnerEnumeration)
1198         uint256 lastTokenId = _allTokens[lastTokenIndex];
1199 
1200         _allTokens[tokenIndex] = lastTokenId; // Move the last token to the slot of the to-delete token
1201         _allTokensIndex[lastTokenId] = tokenIndex; // Update the moved token's index
1202 
1203         // This also deletes the contents at the last position of the array
1204         delete _allTokensIndex[tokenId];
1205         _allTokens.pop();
1206     }
1207 }
1208 
1209 
1210 
1211 
1212 
1213             
1214 
1215 
1216 pragma solidity ^0.8.0;
1217 
1218 ////import "../utils/Context.sol";
1219 /**
1220  * @dev Contract module which provides a basic access control mechanism, where
1221  * there is an account (an owner) that can be granted exclusive access to
1222  * specific functions.
1223  *
1224  * By default, the owner account will be the one that deploys the contract. This
1225  * can later be changed with {transferOwnership}.
1226  *
1227  * This module is used through inheritance. It will make available the modifier
1228  * `onlyOwner`, which can be applied to your functions to restrict their use to
1229  * the owner.
1230  */
1231 abstract contract Ownable is Context {
1232     address private _owner;
1233 
1234     event OwnershipTransferred(address indexed previousOwner, address indexed newOwner);
1235 
1236     /**
1237      * @dev Initializes the contract setting the deployer as the initial owner.
1238      */
1239     constructor () {
1240         address msgSender = _msgSender();
1241         _owner = msgSender;
1242         emit OwnershipTransferred(address(0), msgSender);
1243     }
1244 
1245     /**
1246      * @dev Returns the address of the current owner.
1247      */
1248     function owner() public view virtual returns (address) {
1249         return _owner;
1250     }
1251 
1252     /**
1253      * @dev Throws if called by any account other than the owner.
1254      */
1255     modifier onlyOwner() {
1256         require(owner() == _msgSender(), "Ownable: caller is not the owner");
1257         _;
1258     }
1259 
1260     /**
1261      * @dev Leaves the contract without owner. It will not be possible to call
1262      * `onlyOwner` functions anymore. Can only be called by the current owner.
1263      *
1264      * NOTE: Renouncing ownership will leave the contract without an owner,
1265      * thereby removing any functionality that is only available to the owner.
1266      */
1267     function renounceOwnership() public virtual onlyOwner {
1268         emit OwnershipTransferred(_owner, address(0));
1269         _owner = address(0);
1270     }
1271 
1272     /**
1273      * @dev Transfers ownership of the contract to a new account (`newOwner`).
1274      * Can only be called by the current owner.
1275      */
1276     function transferOwnership(address newOwner) public virtual onlyOwner {
1277         require(newOwner != address(0), "Ownable: new owner is the zero address");
1278         emit OwnershipTransferred(_owner, newOwner);
1279         _owner = newOwner;
1280     }
1281 }
1282 
1283 
1284 
1285 
1286 
1287             
1288 
1289 
1290 pragma solidity ^0.8.0;
1291 
1292 // CAUTION
1293 // This version of SafeMath should only be used with Solidity 0.8 or later,
1294 // because it relies on the compiler's built in overflow checks.
1295 
1296 /**
1297  * @dev Wrappers over Solidity's arithmetic operations.
1298  *
1299  * NOTE: `SafeMath` is no longer needed starting with Solidity 0.8. The compiler
1300  * now has built in overflow checking.
1301  */
1302 library SafeMath {
1303     /**
1304      * @dev Returns the addition of two unsigned integers, with an overflow flag.
1305      *
1306      * _Available since v3.4._
1307      */
1308     function tryAdd(uint256 a, uint256 b) internal pure returns (bool, uint256) {
1309         unchecked {
1310             uint256 c = a + b;
1311             if (c < a) return (false, 0);
1312             return (true, c);
1313         }
1314     }
1315 
1316     /**
1317      * @dev Returns the substraction of two unsigned integers, with an overflow flag.
1318      *
1319      * _Available since v3.4._
1320      */
1321     function trySub(uint256 a, uint256 b) internal pure returns (bool, uint256) {
1322         unchecked {
1323             if (b > a) return (false, 0);
1324             return (true, a - b);
1325         }
1326     }
1327 
1328     /**
1329      * @dev Returns the multiplication of two unsigned integers, with an overflow flag.
1330      *
1331      * _Available since v3.4._
1332      */
1333     function tryMul(uint256 a, uint256 b) internal pure returns (bool, uint256) {
1334         unchecked {
1335             // Gas optimization: this is cheaper than requiring 'a' not being zero, but the
1336             // benefit is lost if 'b' is also tested.
1337             // See: https://github.com/OpenZeppelin/openzeppelin-contracts/pull/522
1338             if (a == 0) return (true, 0);
1339             uint256 c = a * b;
1340             if (c / a != b) return (false, 0);
1341             return (true, c);
1342         }
1343     }
1344 
1345     /**
1346      * @dev Returns the division of two unsigned integers, with a division by zero flag.
1347      *
1348      * _Available since v3.4._
1349      */
1350     function tryDiv(uint256 a, uint256 b) internal pure returns (bool, uint256) {
1351         unchecked {
1352             if (b == 0) return (false, 0);
1353             return (true, a / b);
1354         }
1355     }
1356 
1357     /**
1358      * @dev Returns the remainder of dividing two unsigned integers, with a division by zero flag.
1359      *
1360      * _Available since v3.4._
1361      */
1362     function tryMod(uint256 a, uint256 b) internal pure returns (bool, uint256) {
1363         unchecked {
1364             if (b == 0) return (false, 0);
1365             return (true, a % b);
1366         }
1367     }
1368 
1369     /**
1370      * @dev Returns the addition of two unsigned integers, reverting on
1371      * overflow.
1372      *
1373      * Counterpart to Solidity's `+` operator.
1374      *
1375      * Requirements:
1376      *
1377      * - Addition cannot overflow.
1378      */
1379     function add(uint256 a, uint256 b) internal pure returns (uint256) {
1380         return a + b;
1381     }
1382 
1383     /**
1384      * @dev Returns the subtraction of two unsigned integers, reverting on
1385      * overflow (when the result is negative).
1386      *
1387      * Counterpart to Solidity's `-` operator.
1388      *
1389      * Requirements:
1390      *
1391      * - Subtraction cannot overflow.
1392      */
1393     function sub(uint256 a, uint256 b) internal pure returns (uint256) {
1394         return a - b;
1395     }
1396 
1397     /**
1398      * @dev Returns the multiplication of two unsigned integers, reverting on
1399      * overflow.
1400      *
1401      * Counterpart to Solidity's `*` operator.
1402      *
1403      * Requirements:
1404      *
1405      * - Multiplication cannot overflow.
1406      */
1407     function mul(uint256 a, uint256 b) internal pure returns (uint256) {
1408         return a * b;
1409     }
1410 
1411     /**
1412      * @dev Returns the integer division of two unsigned integers, reverting on
1413      * division by zero. The result is rounded towards zero.
1414      *
1415      * Counterpart to Solidity's `/` operator.
1416      *
1417      * Requirements:
1418      *
1419      * - The divisor cannot be zero.
1420      */
1421     function div(uint256 a, uint256 b) internal pure returns (uint256) {
1422         return a / b;
1423     }
1424 
1425     /**
1426      * @dev Returns the remainder of dividing two unsigned integers. (unsigned integer modulo),
1427      * reverting when dividing by zero.
1428      *
1429      * Counterpart to Solidity's `%` operator. This function uses a `revert`
1430      * opcode (which leaves remaining gas untouched) while Solidity uses an
1431      * invalid opcode to revert (consuming all remaining gas).
1432      *
1433      * Requirements:
1434      *
1435      * - The divisor cannot be zero.
1436      */
1437     function mod(uint256 a, uint256 b) internal pure returns (uint256) {
1438         return a % b;
1439     }
1440 
1441     /**
1442      * @dev Returns the subtraction of two unsigned integers, reverting with custom message on
1443      * overflow (when the result is negative).
1444      *
1445      * CAUTION: This function is deprecated because it requires allocating memory for the error
1446      * message unnecessarily. For custom revert reasons use {trySub}.
1447      *
1448      * Counterpart to Solidity's `-` operator.
1449      *
1450      * Requirements:
1451      *
1452      * - Subtraction cannot overflow.
1453      */
1454     function sub(uint256 a, uint256 b, string memory errorMessage) internal pure returns (uint256) {
1455         unchecked {
1456             require(b <= a, errorMessage);
1457             return a - b;
1458         }
1459     }
1460 
1461     /**
1462      * @dev Returns the integer division of two unsigned integers, reverting with custom message on
1463      * division by zero. The result is rounded towards zero.
1464      *
1465      * Counterpart to Solidity's `%` operator. This function uses a `revert`
1466      * opcode (which leaves remaining gas untouched) while Solidity uses an
1467      * invalid opcode to revert (consuming all remaining gas).
1468      *
1469      * Counterpart to Solidity's `/` operator. Note: this function uses a
1470      * `revert` opcode (which leaves remaining gas untouched) while Solidity
1471      * uses an invalid opcode to revert (consuming all remaining gas).
1472      *
1473      * Requirements:
1474      *
1475      * - The divisor cannot be zero.
1476      */
1477     function div(uint256 a, uint256 b, string memory errorMessage) internal pure returns (uint256) {
1478         unchecked {
1479             require(b > 0, errorMessage);
1480             return a / b;
1481         }
1482     }
1483 
1484     /**
1485      * @dev Returns the remainder of dividing two unsigned integers. (unsigned integer modulo),
1486      * reverting with custom message when dividing by zero.
1487      *
1488      * CAUTION: This function is deprecated because it requires allocating memory for the error
1489      * message unnecessarily. For custom revert reasons use {tryMod}.
1490      *
1491      * Counterpart to Solidity's `%` operator. This function uses a `revert`
1492      * opcode (which leaves remaining gas untouched) while Solidity uses an
1493      * invalid opcode to revert (consuming all remaining gas).
1494      *
1495      * Requirements:
1496      *
1497      * - The divisor cannot be zero.
1498      */
1499     function mod(uint256 a, uint256 b, string memory errorMessage) internal pure returns (uint256) {
1500         unchecked {
1501             require(b > 0, errorMessage);
1502             return a % b;
1503         }
1504     }
1505 }
1506 
1507 
1508 
1509 
1510 
1511 
1512 pragma solidity ^0.8.0;
1513 
1514 ////import "@openzeppelin/contracts/utils/math/SafeMath.sol";
1515 ////import "@openzeppelin/contracts/access/Ownable.sol";
1516 ////import "@openzeppelin/contracts/token/ERC721/ERC721.sol";
1517 ////import "@openzeppelin/contracts/token/ERC721/extensions/ERC721Enumerable.sol";
1518 ////import "@openzeppelin/contracts/token/ERC721/extensions/ERC721URIStorage.sol";
1519 
1520 
1521 /**
1522  * @title BballPandas contract
1523  * @dev Extends ERC721 Non-Fungible Token Standard basic implementation
1524  */
1525 contract  BballPandas is ERC721, ERC721Enumerable, ERC721URIStorage, Ownable {
1526     using SafeMath for uint256;
1527 
1528     uint256 public constant pandaPrice = 80000000000000000; //0.08 ETH
1529 
1530     uint256 public constant maxPandaPurchase = 20;
1531 
1532     uint256 public constant MAX_PANDAS = 10000;
1533 
1534     bool public saleIsActive = false;
1535 
1536     constructor(string memory name, string memory symbol) ERC721(name, symbol) {
1537     }
1538     
1539     function tokenURI(uint256 tokenId)
1540         public
1541         view
1542         override(ERC721, ERC721URIStorage)
1543         returns (string memory)
1544     {
1545         return super.tokenURI(tokenId);
1546     }    
1547 
1548     function _baseURI() internal pure override returns (string memory) {
1549         return "ipfs://QmWxC8nY73zWYfGdrJFAZuZK9dDbNysK1o2HhdF5y5NAWH/";
1550     }        
1551     
1552     function _beforeTokenTransfer(address from, address to, uint256 tokenId)
1553         internal
1554         override(ERC721, ERC721Enumerable)
1555     {
1556         super._beforeTokenTransfer(from, to, tokenId);
1557     }
1558 
1559     function _burn(uint256 tokenId) internal override(ERC721, ERC721URIStorage) {
1560         super._burn(tokenId);
1561     }
1562 
1563     function supportsInterface(bytes4 interfaceId)
1564         public
1565         view
1566         override(ERC721, ERC721Enumerable)
1567         returns (bool)
1568     {
1569         return super.supportsInterface(interfaceId);
1570     }    
1571     
1572     function withdraw() public onlyOwner {
1573         uint256 balance = address(this).balance;
1574         payable(msg.sender).transfer(balance);
1575     }
1576 
1577     function toggleSale() public onlyOwner {
1578         saleIsActive = !saleIsActive;
1579     }
1580 
1581     function reservePandas() public onlyOwner {        
1582         uint256 supply = totalSupply();
1583         uint256 i;
1584         for (i = 0; i < 25; i++) {
1585             _safeMint(msg.sender, supply + i);
1586         }
1587     }
1588     
1589     function mintPanda(uint numberOfTokens) public payable {
1590         require(saleIsActive, "Sale must be active to mint Panda");
1591         require(numberOfTokens <= maxPandaPurchase, "Can only mint a maximum of 20 tokens in a single transaction");
1592         require(totalSupply().add(numberOfTokens) <= MAX_PANDAS, "Purchase would exceed max supply of Pandas");
1593         require(pandaPrice.mul(numberOfTokens) <= msg.value, "Ether value sent is not correct");
1594         
1595         for(uint256 i = 0; i < numberOfTokens; i++) {
1596             uint256 mintIndex = totalSupply();
1597             if (totalSupply() < MAX_PANDAS) {
1598                 _safeMint(msg.sender, mintIndex);
1599             }
1600         }
1601     }
1602 }