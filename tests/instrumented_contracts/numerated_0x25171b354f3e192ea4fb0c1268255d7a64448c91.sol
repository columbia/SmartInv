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
29 
30 
31 /**
32  * @dev Required interface of an ERC721 compliant contract.
33  */
34 interface IERC721 is IERC165 {
35     /**
36      * @dev Emitted when `tokenId` token is transferred from `from` to `to`.
37      */
38     event Transfer(address indexed from, address indexed to, uint256 indexed tokenId);
39 
40     /**
41      * @dev Emitted when `owner` enables `approved` to manage the `tokenId` token.
42      */
43     event Approval(address indexed owner, address indexed approved, uint256 indexed tokenId);
44 
45     /**
46      * @dev Emitted when `owner` enables or disables (`approved`) `operator` to manage all of its assets.
47      */
48     event ApprovalForAll(address indexed owner, address indexed operator, bool approved);
49 
50     /**
51      * @dev Returns the number of tokens in ``owner``'s account.
52      */
53     function balanceOf(address owner) external view returns (uint256 balance);
54 
55     /**
56      * @dev Returns the owner of the `tokenId` token.
57      *
58      * Requirements:
59      *
60      * - `tokenId` must exist.
61      */
62     function ownerOf(uint256 tokenId) external view returns (address owner);
63 
64     /**
65      * @dev Safely transfers `tokenId` token from `from` to `to`, checking first that contract recipients
66      * are aware of the ERC721 protocol to prevent tokens from being forever locked.
67      *
68      * Requirements:
69      *
70      * - `from` cannot be the zero address.
71      * - `to` cannot be the zero address.
72      * - `tokenId` token must exist and be owned by `from`.
73      * - If the caller is not `from`, it must be have been allowed to move this token by either {approve} or {setApprovalForAll}.
74      * - If `to` refers to a smart contract, it must implement {IERC721Receiver-onERC721Received}, which is called upon a safe transfer.
75      *
76      * Emits a {Transfer} event.
77      */
78     function safeTransferFrom(
79         address from,
80         address to,
81         uint256 tokenId
82     ) external;
83 
84     /**
85      * @dev Transfers `tokenId` token from `from` to `to`.
86      *
87      * WARNING: Usage of this method is discouraged, use {safeTransferFrom} whenever possible.
88      *
89      * Requirements:
90      *
91      * - `from` cannot be the zero address.
92      * - `to` cannot be the zero address.
93      * - `tokenId` token must be owned by `from`.
94      * - If the caller is not `from`, it must be approved to move this token by either {approve} or {setApprovalForAll}.
95      *
96      * Emits a {Transfer} event.
97      */
98     function transferFrom(
99         address from,
100         address to,
101         uint256 tokenId
102     ) external;
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
148      * @dev Safely transfers `tokenId` token from `from` to `to`.
149      *
150      * Requirements:
151      *
152      * - `from` cannot be the zero address.
153      * - `to` cannot be the zero address.
154      * - `tokenId` token must exist and be owned by `from`.
155      * - If the caller is not `from`, it must be approved to move this token by either {approve} or {setApprovalForAll}.
156      * - If `to` refers to a smart contract, it must implement {IERC721Receiver-onERC721Received}, which is called upon a safe transfer.
157      *
158      * Emits a {Transfer} event.
159      */
160     function safeTransferFrom(
161         address from,
162         address to,
163         uint256 tokenId,
164         bytes calldata data
165     ) external;
166 }
167 
168 
169 
170 
171 /**
172  * @dev String operations.
173  */
174 library Strings {
175     bytes16 private constant _HEX_SYMBOLS = "0123456789abcdef";
176 
177     /**
178      * @dev Converts a `uint256` to its ASCII `string` decimal representation.
179      */
180     function toString(uint256 value) internal pure returns (string memory) {
181         // Inspired by OraclizeAPI's implementation - MIT licence
182         // https://github.com/oraclize/ethereum-api/blob/b42146b063c7d6ee1358846c198246239e9360e8/oraclizeAPI_0.4.25.sol
183 
184         if (value == 0) {
185             return "0";
186         }
187         uint256 temp = value;
188         uint256 digits;
189         while (temp != 0) {
190             digits++;
191             temp /= 10;
192         }
193         bytes memory buffer = new bytes(digits);
194         while (value != 0) {
195             digits -= 1;
196             buffer[digits] = bytes1(uint8(48 + uint256(value % 10)));
197             value /= 10;
198         }
199         return string(buffer);
200     }
201 
202     /**
203      * @dev Converts a `uint256` to its ASCII `string` hexadecimal representation.
204      */
205     function toHexString(uint256 value) internal pure returns (string memory) {
206         if (value == 0) {
207             return "0x00";
208         }
209         uint256 temp = value;
210         uint256 length = 0;
211         while (temp != 0) {
212             length++;
213             temp >>= 8;
214         }
215         return toHexString(value, length);
216     }
217 
218     /**
219      * @dev Converts a `uint256` to its ASCII `string` hexadecimal representation with fixed length.
220      */
221     function toHexString(uint256 value, uint256 length) internal pure returns (string memory) {
222         bytes memory buffer = new bytes(2 * length + 2);
223         buffer[0] = "0";
224         buffer[1] = "x";
225         for (uint256 i = 2 * length + 1; i > 1; --i) {
226             buffer[i] = _HEX_SYMBOLS[value & 0xf];
227             value >>= 4;
228         }
229         require(value == 0, "Strings: hex length insufficient");
230         return string(buffer);
231     }
232 }
233 
234 
235 
236 
237 /**
238  * @dev Provides information about the current execution context, including the
239  * sender of the transaction and its data. While these are generally available
240  * via msg.sender and msg.data, they should not be accessed in such a direct
241  * manner, since when dealing with meta-transactions the account sending and
242  * paying for execution may not be the actual sender (as far as an application
243  * is concerned).
244  *
245  * This contract is only required for intermediate, library-like contracts.
246  */
247 abstract contract Context {
248     function _msgSender() internal view virtual returns (address) {
249         return msg.sender;
250     }
251 
252     function _msgData() internal view virtual returns (bytes calldata) {
253         return msg.data;
254     }
255 }
256 
257 
258 
259 
260 
261 
262 
263 
264 
265 
266 
267 
268 
269 
270 
271 
272 /**
273  * @title ERC721 token receiver interface
274  * @dev Interface for any contract that wants to support safeTransfers
275  * from ERC721 asset contracts.
276  */
277 interface IERC721Receiver {
278     /**
279      * @dev Whenever an {IERC721} `tokenId` token is transferred to this contract via {IERC721-safeTransferFrom}
280      * by `operator` from `from`, this function is called.
281      *
282      * It must return its Solidity selector to confirm the token transfer.
283      * If any other value is returned or the interface is not implemented by the recipient, the transfer will be reverted.
284      *
285      * The selector can be obtained in Solidity with `IERC721.onERC721Received.selector`.
286      */
287     function onERC721Received(
288         address operator,
289         address from,
290         uint256 tokenId,
291         bytes calldata data
292     ) external returns (bytes4);
293 }
294 
295 
296 
297 
298 
299 
300 
301 /**
302  * @title ERC-721 Non-Fungible Token Standard, optional metadata extension
303  * @dev See https://eips.ethereum.org/EIPS/eip-721
304  */
305 interface IERC721Metadata is IERC721 {
306     /**
307      * @dev Returns the token collection name.
308      */
309     function name() external view returns (string memory);
310 
311     /**
312      * @dev Returns the token collection symbol.
313      */
314     function symbol() external view returns (string memory);
315 
316     /**
317      * @dev Returns the Uniform Resource Identifier (URI) for `tokenId` token.
318      */
319     function tokenURI(uint256 tokenId) external view returns (string memory);
320 }
321 
322 
323 
324 
325 
326 /**
327  * @dev Collection of functions related to the address type
328  */
329 library Address {
330     /**
331      * @dev Returns true if `account` is a contract.
332      *
333      * [IMPORTANT]
334      * ====
335      * It is unsafe to assume that an address for which this function returns
336      * false is an externally-owned account (EOA) and not a contract.
337      *
338      * Among others, `isContract` will return false for the following
339      * types of addresses:
340      *
341      *  - an externally-owned account
342      *  - a contract in construction
343      *  - an address where a contract will be created
344      *  - an address where a contract lived, but was destroyed
345      * ====
346      */
347     function isContract(address account) internal view returns (bool) {
348         // This method relies on extcodesize, which returns 0 for contracts in
349         // construction, since the code is only stored at the end of the
350         // constructor execution.
351 
352         uint256 size;
353         assembly {
354             size := extcodesize(account)
355         }
356         return size > 0;
357     }
358 
359     /**
360      * @dev Replacement for Solidity's `transfer`: sends `amount` wei to
361      * `recipient`, forwarding all available gas and reverting on errors.
362      *
363      * https://eips.ethereum.org/EIPS/eip-1884[EIP1884] increases the gas cost
364      * of certain opcodes, possibly making contracts go over the 2300 gas limit
365      * imposed by `transfer`, making them unable to receive funds via
366      * `transfer`. {sendValue} removes this limitation.
367      *
368      * https://diligence.consensys.net/posts/2019/09/stop-using-soliditys-transfer-now/[Learn more].
369      *
370      * IMPORTANT: because control is transferred to `recipient`, care must be
371      * taken to not create reentrancy vulnerabilities. Consider using
372      * {ReentrancyGuard} or the
373      * https://solidity.readthedocs.io/en/v0.5.11/security-considerations.html#use-the-checks-effects-interactions-pattern[checks-effects-interactions pattern].
374      */
375     function sendValue(address payable recipient, uint256 amount) internal {
376         require(address(this).balance >= amount, "Address: insufficient balance");
377 
378         (bool success, ) = recipient.call{value: amount}("");
379         require(success, "Address: unable to send value, recipient may have reverted");
380     }
381 
382     /**
383      * @dev Performs a Solidity function call using a low level `call`. A
384      * plain `call` is an unsafe replacement for a function call: use this
385      * function instead.
386      *
387      * If `target` reverts with a revert reason, it is bubbled up by this
388      * function (like regular Solidity function calls).
389      *
390      * Returns the raw returned data. To convert to the expected return value,
391      * use https://solidity.readthedocs.io/en/latest/units-and-global-variables.html?highlight=abi.decode#abi-encoding-and-decoding-functions[`abi.decode`].
392      *
393      * Requirements:
394      *
395      * - `target` must be a contract.
396      * - calling `target` with `data` must not revert.
397      *
398      * _Available since v3.1._
399      */
400     function functionCall(address target, bytes memory data) internal returns (bytes memory) {
401         return functionCall(target, data, "Address: low-level call failed");
402     }
403 
404     /**
405      * @dev Same as {xref-Address-functionCall-address-bytes-}[`functionCall`], but with
406      * `errorMessage` as a fallback revert reason when `target` reverts.
407      *
408      * _Available since v3.1._
409      */
410     function functionCall(
411         address target,
412         bytes memory data,
413         string memory errorMessage
414     ) internal returns (bytes memory) {
415         return functionCallWithValue(target, data, 0, errorMessage);
416     }
417 
418     /**
419      * @dev Same as {xref-Address-functionCall-address-bytes-}[`functionCall`],
420      * but also transferring `value` wei to `target`.
421      *
422      * Requirements:
423      *
424      * - the calling contract must have an ETH balance of at least `value`.
425      * - the called Solidity function must be `payable`.
426      *
427      * _Available since v3.1._
428      */
429     function functionCallWithValue(
430         address target,
431         bytes memory data,
432         uint256 value
433     ) internal returns (bytes memory) {
434         return functionCallWithValue(target, data, value, "Address: low-level call with value failed");
435     }
436 
437     /**
438      * @dev Same as {xref-Address-functionCallWithValue-address-bytes-uint256-}[`functionCallWithValue`], but
439      * with `errorMessage` as a fallback revert reason when `target` reverts.
440      *
441      * _Available since v3.1._
442      */
443     function functionCallWithValue(
444         address target,
445         bytes memory data,
446         uint256 value,
447         string memory errorMessage
448     ) internal returns (bytes memory) {
449         require(address(this).balance >= value, "Address: insufficient balance for call");
450         require(isContract(target), "Address: call to non-contract");
451 
452         (bool success, bytes memory returndata) = target.call{value: value}(data);
453         return verifyCallResult(success, returndata, errorMessage);
454     }
455 
456     /**
457      * @dev Same as {xref-Address-functionCall-address-bytes-}[`functionCall`],
458      * but performing a static call.
459      *
460      * _Available since v3.3._
461      */
462     function functionStaticCall(address target, bytes memory data) internal view returns (bytes memory) {
463         return functionStaticCall(target, data, "Address: low-level static call failed");
464     }
465 
466     /**
467      * @dev Same as {xref-Address-functionCall-address-bytes-string-}[`functionCall`],
468      * but performing a static call.
469      *
470      * _Available since v3.3._
471      */
472     function functionStaticCall(
473         address target,
474         bytes memory data,
475         string memory errorMessage
476     ) internal view returns (bytes memory) {
477         require(isContract(target), "Address: static call to non-contract");
478 
479         (bool success, bytes memory returndata) = target.staticcall(data);
480         return verifyCallResult(success, returndata, errorMessage);
481     }
482 
483     /**
484      * @dev Same as {xref-Address-functionCall-address-bytes-}[`functionCall`],
485      * but performing a delegate call.
486      *
487      * _Available since v3.4._
488      */
489     function functionDelegateCall(address target, bytes memory data) internal returns (bytes memory) {
490         return functionDelegateCall(target, data, "Address: low-level delegate call failed");
491     }
492 
493     /**
494      * @dev Same as {xref-Address-functionCall-address-bytes-string-}[`functionCall`],
495      * but performing a delegate call.
496      *
497      * _Available since v3.4._
498      */
499     function functionDelegateCall(
500         address target,
501         bytes memory data,
502         string memory errorMessage
503     ) internal returns (bytes memory) {
504         require(isContract(target), "Address: delegate call to non-contract");
505 
506         (bool success, bytes memory returndata) = target.delegatecall(data);
507         return verifyCallResult(success, returndata, errorMessage);
508     }
509 
510     /**
511      * @dev Tool to verifies that a low level call was successful, and revert if it wasn't, either by bubbling the
512      * revert reason using the provided one.
513      *
514      * _Available since v4.3._
515      */
516     function verifyCallResult(
517         bool success,
518         bytes memory returndata,
519         string memory errorMessage
520     ) internal pure returns (bytes memory) {
521         if (success) {
522             return returndata;
523         } else {
524             // Look for revert reason and bubble it up if present
525             if (returndata.length > 0) {
526                 // The easiest way to bubble the revert reason is using memory via assembly
527 
528                 assembly {
529                     let returndata_size := mload(returndata)
530                     revert(add(32, returndata), returndata_size)
531                 }
532             } else {
533                 revert(errorMessage);
534             }
535         }
536     }
537 }
538 
539 
540 
541 
542 
543 
544 
545 
546 
547 /**
548  * @dev Implementation of the {IERC165} interface.
549  *
550  * Contracts that want to implement ERC165 should inherit from this contract and override {supportsInterface} to check
551  * for the additional interface id that will be supported. For example:
552  *
553  * ```solidity
554  * function supportsInterface(bytes4 interfaceId) public view virtual override returns (bool) {
555  *     return interfaceId == type(MyInterface).interfaceId || super.supportsInterface(interfaceId);
556  * }
557  * ```
558  *
559  * Alternatively, {ERC165Storage} provides an easier to use but more expensive implementation.
560  */
561 abstract contract ERC165 is IERC165 {
562     /**
563      * @dev See {IERC165-supportsInterface}.
564      */
565     function supportsInterface(bytes4 interfaceId) public view virtual override returns (bool) {
566         return interfaceId == type(IERC165).interfaceId;
567     }
568 }
569 
570 
571 /**
572  * @dev Implementation of https://eips.ethereum.org/EIPS/eip-721[ERC721] Non-Fungible Token Standard, including
573  * the Metadata extension, but not including the Enumerable extension, which is available separately as
574  * {ERC721Enumerable}.
575  */
576 contract ERC721 is Context, ERC165, IERC721, IERC721Metadata {
577     using Address for address;
578     using Strings for uint256;
579 
580     // Token name
581     string private _name;
582 
583     // Token symbol
584     string private _symbol;
585 
586     // Mapping from token ID to owner address
587     mapping(uint256 => address) private _owners;
588 
589     // Mapping owner address to token count
590     mapping(address => uint256) private _balances;
591 
592     // Mapping from token ID to approved address
593     mapping(uint256 => address) private _tokenApprovals;
594 
595     // Mapping from owner to operator approvals
596     mapping(address => mapping(address => bool)) private _operatorApprovals;
597 
598     /**
599      * @dev Initializes the contract by setting a `name` and a `symbol` to the token collection.
600      */
601     constructor(string memory name_, string memory symbol_) {
602         _name = name_;
603         _symbol = symbol_;
604     }
605 
606     /**
607      * @dev See {IERC165-supportsInterface}.
608      */
609     function supportsInterface(bytes4 interfaceId) public view virtual override(ERC165, IERC165) returns (bool) {
610         return
611             interfaceId == type(IERC721).interfaceId ||
612             interfaceId == type(IERC721Metadata).interfaceId ||
613             super.supportsInterface(interfaceId);
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
654         return bytes(baseURI).length > 0 ? string(abi.encodePacked(baseURI, tokenId.toString())) : "";
655     }
656 
657     /**
658      * @dev Base URI for computing {tokenURI}. If set, the resulting URI for each
659      * token will be the concatenation of the `baseURI` and the `tokenId`. Empty
660      * by default, can be overriden in child contracts.
661      */
662     function _baseURI() internal view virtual returns (string memory) {
663         return "";
664     }
665 
666     /**
667      * @dev See {IERC721-approve}.
668      */
669     function approve(address to, uint256 tokenId) public virtual override {
670         address owner = ERC721.ownerOf(tokenId);
671         require(to != owner, "ERC721: approval to current owner");
672 
673         require(
674             _msgSender() == owner || isApprovedForAll(owner, _msgSender()),
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
710     function transferFrom(
711         address from,
712         address to,
713         uint256 tokenId
714     ) public virtual override {
715         //solhint-disable-next-line max-line-length
716         require(_isApprovedOrOwner(_msgSender(), tokenId), "ERC721: transfer caller is not owner nor approved");
717 
718         _transfer(from, to, tokenId);
719     }
720 
721     /**
722      * @dev See {IERC721-safeTransferFrom}.
723      */
724     function safeTransferFrom(
725         address from,
726         address to,
727         uint256 tokenId
728     ) public virtual override {
729         safeTransferFrom(from, to, tokenId, "");
730     }
731 
732     /**
733      * @dev See {IERC721-safeTransferFrom}.
734      */
735     function safeTransferFrom(
736         address from,
737         address to,
738         uint256 tokenId,
739         bytes memory _data
740     ) public virtual override {
741         require(_isApprovedOrOwner(_msgSender(), tokenId), "ERC721: transfer caller is not owner nor approved");
742         _safeTransfer(from, to, tokenId, _data);
743     }
744 
745     /**
746      * @dev Safely transfers `tokenId` token from `from` to `to`, checking first that contract recipients
747      * are aware of the ERC721 protocol to prevent tokens from being forever locked.
748      *
749      * `_data` is additional data, it has no specified format and it is sent in call to `to`.
750      *
751      * This internal function is equivalent to {safeTransferFrom}, and can be used to e.g.
752      * implement alternative mechanisms to perform token transfer, such as signature-based.
753      *
754      * Requirements:
755      *
756      * - `from` cannot be the zero address.
757      * - `to` cannot be the zero address.
758      * - `tokenId` token must exist and be owned by `from`.
759      * - If `to` refers to a smart contract, it must implement {IERC721Receiver-onERC721Received}, which is called upon a safe transfer.
760      *
761      * Emits a {Transfer} event.
762      */
763     function _safeTransfer(
764         address from,
765         address to,
766         uint256 tokenId,
767         bytes memory _data
768     ) internal virtual {
769         _transfer(from, to, tokenId);
770         require(_checkOnERC721Received(from, to, tokenId, _data), "ERC721: transfer to non ERC721Receiver implementer");
771     }
772 
773     /**
774      * @dev Returns whether `tokenId` exists.
775      *
776      * Tokens can be managed by their owner or approved accounts via {approve} or {setApprovalForAll}.
777      *
778      * Tokens start existing when they are minted (`_mint`),
779      * and stop existing when they are burned (`_burn`).
780      */
781     function _exists(uint256 tokenId) internal view virtual returns (bool) {
782         return _owners[tokenId] != address(0);
783     }
784 
785     /**
786      * @dev Returns whether `spender` is allowed to manage `tokenId`.
787      *
788      * Requirements:
789      *
790      * - `tokenId` must exist.
791      */
792     function _isApprovedOrOwner(address spender, uint256 tokenId) internal view virtual returns (bool) {
793         require(_exists(tokenId), "ERC721: operator query for nonexistent token");
794         address owner = ERC721.ownerOf(tokenId);
795         return (spender == owner || getApproved(tokenId) == spender || isApprovedForAll(owner, spender));
796     }
797 
798     /**
799      * @dev Safely mints `tokenId` and transfers it to `to`.
800      *
801      * Requirements:
802      *
803      * - `tokenId` must not exist.
804      * - If `to` refers to a smart contract, it must implement {IERC721Receiver-onERC721Received}, which is called upon a safe transfer.
805      *
806      * Emits a {Transfer} event.
807      */
808     function _safeMint(address to, uint256 tokenId) internal virtual {
809         _safeMint(to, tokenId, "");
810     }
811 
812     /**
813      * @dev Same as {xref-ERC721-_safeMint-address-uint256-}[`_safeMint`], with an additional `data` parameter which is
814      * forwarded in {IERC721Receiver-onERC721Received} to contract recipients.
815      */
816     function _safeMint(
817         address to,
818         uint256 tokenId,
819         bytes memory _data
820     ) internal virtual {
821         _mint(to, tokenId);
822         require(
823             _checkOnERC721Received(address(0), to, tokenId, _data),
824             "ERC721: transfer to non ERC721Receiver implementer"
825         );
826     }
827 
828     /**
829      * @dev Mints `tokenId` and transfers it to `to`.
830      *
831      * WARNING: Usage of this method is discouraged, use {_safeMint} whenever possible
832      *
833      * Requirements:
834      *
835      * - `tokenId` must not exist.
836      * - `to` cannot be the zero address.
837      *
838      * Emits a {Transfer} event.
839      */
840     function _mint(address to, uint256 tokenId) internal virtual {
841         require(to != address(0), "ERC721: mint to the zero address");
842         require(!_exists(tokenId), "ERC721: token already minted");
843 
844         _beforeTokenTransfer(address(0), to, tokenId);
845 
846         _balances[to] += 1;
847         _owners[tokenId] = to;
848 
849         emit Transfer(address(0), to, tokenId);
850     }
851 
852     /**
853      * @dev Destroys `tokenId`.
854      * The approval is cleared when the token is burned.
855      *
856      * Requirements:
857      *
858      * - `tokenId` must exist.
859      *
860      * Emits a {Transfer} event.
861      */
862     function _burn(uint256 tokenId) internal virtual {
863         address owner = ERC721.ownerOf(tokenId);
864 
865         _beforeTokenTransfer(owner, address(0), tokenId);
866 
867         // Clear approvals
868         _approve(address(0), tokenId);
869 
870         _balances[owner] -= 1;
871         delete _owners[tokenId];
872 
873         emit Transfer(owner, address(0), tokenId);
874     }
875 
876     /**
877      * @dev Transfers `tokenId` from `from` to `to`.
878      *  As opposed to {transferFrom}, this imposes no restrictions on msg.sender.
879      *
880      * Requirements:
881      *
882      * - `to` cannot be the zero address.
883      * - `tokenId` token must be owned by `from`.
884      *
885      * Emits a {Transfer} event.
886      */
887     function _transfer(
888         address from,
889         address to,
890         uint256 tokenId
891     ) internal virtual {
892         require(ERC721.ownerOf(tokenId) == from, "ERC721: transfer of token that is not own");
893         require(to != address(0), "ERC721: transfer to the zero address");
894 
895         _beforeTokenTransfer(from, to, tokenId);
896 
897         // Clear approvals from the previous owner
898         _approve(address(0), tokenId);
899 
900         _balances[from] -= 1;
901         _balances[to] += 1;
902         _owners[tokenId] = to;
903 
904         emit Transfer(from, to, tokenId);
905     }
906 
907     /**
908      * @dev Approve `to` to operate on `tokenId`
909      *
910      * Emits a {Approval} event.
911      */
912     function _approve(address to, uint256 tokenId) internal virtual {
913         _tokenApprovals[tokenId] = to;
914         emit Approval(ERC721.ownerOf(tokenId), to, tokenId);
915     }
916 
917     /**
918      * @dev Internal function to invoke {IERC721Receiver-onERC721Received} on a target address.
919      * The call is not executed if the target address is not a contract.
920      *
921      * @param from address representing the previous owner of the given token ID
922      * @param to target address that will receive the tokens
923      * @param tokenId uint256 ID of the token to be transferred
924      * @param _data bytes optional data to send along with the call
925      * @return bool whether the call correctly returned the expected magic value
926      */
927     function _checkOnERC721Received(
928         address from,
929         address to,
930         uint256 tokenId,
931         bytes memory _data
932     ) private returns (bool) {
933         if (to.isContract()) {
934             try IERC721Receiver(to).onERC721Received(_msgSender(), from, tokenId, _data) returns (bytes4 retval) {
935                 return retval == IERC721Receiver.onERC721Received.selector;
936             } catch (bytes memory reason) {
937                 if (reason.length == 0) {
938                     revert("ERC721: transfer to non ERC721Receiver implementer");
939                 } else {
940                     assembly {
941                         revert(add(32, reason), mload(reason))
942                     }
943                 }
944             }
945         } else {
946             return true;
947         }
948     }
949 
950     /**
951      * @dev Hook that is called before any token transfer. This includes minting
952      * and burning.
953      *
954      * Calling conditions:
955      *
956      * - When `from` and `to` are both non-zero, ``from``'s `tokenId` will be
957      * transferred to `to`.
958      * - When `from` is zero, `tokenId` will be minted for `to`.
959      * - When `to` is zero, ``from``'s `tokenId` will be burned.
960      * - `from` and `to` are never both zero.
961      *
962      * To learn more about hooks, head to xref:ROOT:extending-contracts.adoc#using-hooks[Using Hooks].
963      */
964     function _beforeTokenTransfer(
965         address from,
966         address to,
967         uint256 tokenId
968     ) internal virtual {}
969 }
970 
971 
972 
973 
974 
975 
976 
977 /**
978  * @title ERC-721 Non-Fungible Token Standard, optional enumeration extension
979  * @dev See https://eips.ethereum.org/EIPS/eip-721
980  */
981 interface IERC721Enumerable is IERC721 {
982     /**
983      * @dev Returns the total amount of tokens stored by the contract.
984      */
985     function totalSupply() external view returns (uint256);
986 
987     /**
988      * @dev Returns a token ID owned by `owner` at a given `index` of its token list.
989      * Use along with {balanceOf} to enumerate all of ``owner``'s tokens.
990      */
991     function tokenOfOwnerByIndex(address owner, uint256 index) external view returns (uint256 tokenId);
992 
993     /**
994      * @dev Returns a token ID at a given `index` of all the tokens stored by the contract.
995      * Use along with {totalSupply} to enumerate all tokens.
996      */
997     function tokenByIndex(uint256 index) external view returns (uint256);
998 }
999 
1000 
1001 /**
1002  * @dev This implements an optional extension of {ERC721} defined in the EIP that adds
1003  * enumerability of all the token ids in the contract as well as all token ids owned by each
1004  * account.
1005  */
1006 abstract contract ERC721Enumerable is ERC721, IERC721Enumerable {
1007     // Mapping from owner to list of owned token IDs
1008     mapping(address => mapping(uint256 => uint256)) private _ownedTokens;
1009 
1010     // Mapping from token ID to index of the owner tokens list
1011     mapping(uint256 => uint256) private _ownedTokensIndex;
1012 
1013     // Array with all token ids, used for enumeration
1014     uint256[] private _allTokens;
1015 
1016     // Mapping from token id to position in the allTokens array
1017     mapping(uint256 => uint256) private _allTokensIndex;
1018 
1019     /**
1020      * @dev See {IERC165-supportsInterface}.
1021      */
1022     function supportsInterface(bytes4 interfaceId) public view virtual override(IERC165, ERC721) returns (bool) {
1023         return interfaceId == type(IERC721Enumerable).interfaceId || super.supportsInterface(interfaceId);
1024     }
1025 
1026     /**
1027      * @dev See {IERC721Enumerable-tokenOfOwnerByIndex}.
1028      */
1029     function tokenOfOwnerByIndex(address owner, uint256 index) public view virtual override returns (uint256) {
1030         require(index < ERC721.balanceOf(owner), "ERC721Enumerable: owner index out of bounds");
1031         return _ownedTokens[owner][index];
1032     }
1033 
1034     /**
1035      * @dev See {IERC721Enumerable-totalSupply}.
1036      */
1037     function totalSupply() public view virtual override returns (uint256) {
1038         return _allTokens.length;
1039     }
1040 
1041     /**
1042      * @dev See {IERC721Enumerable-tokenByIndex}.
1043      */
1044     function tokenByIndex(uint256 index) public view virtual override returns (uint256) {
1045         require(index < ERC721Enumerable.totalSupply(), "ERC721Enumerable: global index out of bounds");
1046         return _allTokens[index];
1047     }
1048 
1049     /**
1050      * @dev Hook that is called before any token transfer. This includes minting
1051      * and burning.
1052      *
1053      * Calling conditions:
1054      *
1055      * - When `from` and `to` are both non-zero, ``from``'s `tokenId` will be
1056      * transferred to `to`.
1057      * - When `from` is zero, `tokenId` will be minted for `to`.
1058      * - When `to` is zero, ``from``'s `tokenId` will be burned.
1059      * - `from` cannot be the zero address.
1060      * - `to` cannot be the zero address.
1061      *
1062      * To learn more about hooks, head to xref:ROOT:extending-contracts.adoc#using-hooks[Using Hooks].
1063      */
1064     function _beforeTokenTransfer(
1065         address from,
1066         address to,
1067         uint256 tokenId
1068     ) internal virtual override {
1069         super._beforeTokenTransfer(from, to, tokenId);
1070 
1071         if (from == address(0)) {
1072             _addTokenToAllTokensEnumeration(tokenId);
1073         } else if (from != to) {
1074             _removeTokenFromOwnerEnumeration(from, tokenId);
1075         }
1076         if (to == address(0)) {
1077             _removeTokenFromAllTokensEnumeration(tokenId);
1078         } else if (to != from) {
1079             _addTokenToOwnerEnumeration(to, tokenId);
1080         }
1081     }
1082 
1083     /**
1084      * @dev Private function to add a token to this extension's ownership-tracking data structures.
1085      * @param to address representing the new owner of the given token ID
1086      * @param tokenId uint256 ID of the token to be added to the tokens list of the given address
1087      */
1088     function _addTokenToOwnerEnumeration(address to, uint256 tokenId) private {
1089         uint256 length = ERC721.balanceOf(to);
1090         _ownedTokens[to][length] = tokenId;
1091         _ownedTokensIndex[tokenId] = length;
1092     }
1093 
1094     /**
1095      * @dev Private function to add a token to this extension's token tracking data structures.
1096      * @param tokenId uint256 ID of the token to be added to the tokens list
1097      */
1098     function _addTokenToAllTokensEnumeration(uint256 tokenId) private {
1099         _allTokensIndex[tokenId] = _allTokens.length;
1100         _allTokens.push(tokenId);
1101     }
1102 
1103     /**
1104      * @dev Private function to remove a token from this extension's ownership-tracking data structures. Note that
1105      * while the token is not assigned a new owner, the `_ownedTokensIndex` mapping is _not_ updated: this allows for
1106      * gas optimizations e.g. when performing a transfer operation (avoiding double writes).
1107      * This has O(1) time complexity, but alters the order of the _ownedTokens array.
1108      * @param from address representing the previous owner of the given token ID
1109      * @param tokenId uint256 ID of the token to be removed from the tokens list of the given address
1110      */
1111     function _removeTokenFromOwnerEnumeration(address from, uint256 tokenId) private {
1112         // To prevent a gap in from's tokens array, we store the last token in the index of the token to delete, and
1113         // then delete the last slot (swap and pop).
1114 
1115         uint256 lastTokenIndex = ERC721.balanceOf(from) - 1;
1116         uint256 tokenIndex = _ownedTokensIndex[tokenId];
1117 
1118         // When the token to delete is the last token, the swap operation is unnecessary
1119         if (tokenIndex != lastTokenIndex) {
1120             uint256 lastTokenId = _ownedTokens[from][lastTokenIndex];
1121 
1122             _ownedTokens[from][tokenIndex] = lastTokenId; // Move the last token to the slot of the to-delete token
1123             _ownedTokensIndex[lastTokenId] = tokenIndex; // Update the moved token's index
1124         }
1125 
1126         // This also deletes the contents at the last position of the array
1127         delete _ownedTokensIndex[tokenId];
1128         delete _ownedTokens[from][lastTokenIndex];
1129     }
1130 
1131     /**
1132      * @dev Private function to remove a token from this extension's token tracking data structures.
1133      * This has O(1) time complexity, but alters the order of the _allTokens array.
1134      * @param tokenId uint256 ID of the token to be removed from the tokens list
1135      */
1136     function _removeTokenFromAllTokensEnumeration(uint256 tokenId) private {
1137         // To prevent a gap in the tokens array, we store the last token in the index of the token to delete, and
1138         // then delete the last slot (swap and pop).
1139 
1140         uint256 lastTokenIndex = _allTokens.length - 1;
1141         uint256 tokenIndex = _allTokensIndex[tokenId];
1142 
1143         // When the token to delete is the last token, the swap operation is unnecessary. However, since this occurs so
1144         // rarely (when the last minted token is burnt) that we still do the swap here to avoid the gas cost of adding
1145         // an 'if' statement (like in _removeTokenFromOwnerEnumeration)
1146         uint256 lastTokenId = _allTokens[lastTokenIndex];
1147 
1148         _allTokens[tokenIndex] = lastTokenId; // Move the last token to the slot of the to-delete token
1149         _allTokensIndex[lastTokenId] = tokenIndex; // Update the moved token's index
1150 
1151         // This also deletes the contents at the last position of the array
1152         delete _allTokensIndex[tokenId];
1153         _allTokens.pop();
1154     }
1155 }
1156 
1157 
1158 
1159 
1160 
1161 
1162 
1163 /**
1164  * @dev Contract module which provides a basic access control mechanism, where
1165  * there is an account (an owner) that can be granted exclusive access to
1166  * specific functions.
1167  *
1168  * By default, the owner account will be the one that deploys the contract. This
1169  * can later be changed with {transferOwnership}.
1170  *
1171  * This module is used through inheritance. It will make available the modifier
1172  * `onlyOwner`, which can be applied to your functions to restrict their use to
1173  * the owner.
1174  */
1175 abstract contract Ownable is Context {
1176     address private _owner;
1177 
1178     event OwnershipTransferred(address indexed previousOwner, address indexed newOwner);
1179 
1180     /**
1181      * @dev Initializes the contract setting the deployer as the initial owner.
1182      */
1183     constructor() {
1184         _setOwner(_msgSender());
1185     }
1186 
1187     /**
1188      * @dev Returns the address of the current owner.
1189      */
1190     function owner() public view virtual returns (address) {
1191         return _owner;
1192     }
1193 
1194     /**
1195      * @dev Throws if called by any account other than the owner.
1196      */
1197     modifier onlyOwner() {
1198         require(owner() == _msgSender(), "Ownable: caller is not the owner");
1199         _;
1200     }
1201 
1202     /**
1203      * @dev Leaves the contract without owner. It will not be possible to call
1204      * `onlyOwner` functions anymore. Can only be called by the current owner.
1205      *
1206      * NOTE: Renouncing ownership will leave the contract without an owner,
1207      * thereby removing any functionality that is only available to the owner.
1208      */
1209     function renounceOwnership() public virtual onlyOwner {
1210         _setOwner(address(0));
1211     }
1212 
1213     /**
1214      * @dev Transfers ownership of the contract to a new account (`newOwner`).
1215      * Can only be called by the current owner.
1216      */
1217     function transferOwnership(address newOwner) public virtual onlyOwner {
1218         require(newOwner != address(0), "Ownable: new owner is the zero address");
1219         _setOwner(newOwner);
1220     }
1221 
1222     function _setOwner(address newOwner) private {
1223         address oldOwner = _owner;
1224         _owner = newOwner;
1225         emit OwnershipTransferred(oldOwner, newOwner);
1226     }
1227 }
1228 
1229 
1230 //........................................................................
1231 //........................................................................
1232 //...||     ||     ||     ||  || ||||||    ||    || ||||||||||||| |||||||
1233 //...|||| ||||    ||||    || ||  ||        |||   || ||      ||   ||||
1234 //...||  || ||   ||  ||   ||||   |||||     || || || |||||   ||     |||||
1235 //...||     ||  ||||||||  || ||  ||        ||  |||| ||      ||        |||
1236 //...||     || ||      || ||  || ||||||    ||    || ||      ||   |||||||
1237 //...
1238 //...||    ||    ||||  ||||||||    ||          ||     ||      ||||||
1239 //...|||   ||   ||  ||    ||        ||   ||   ||     ||||     ||   ||
1240 //...|| || ||  ||    ||   ||         || ||| |||     ||  ||    ||||||
1241 //...||  ||||   ||  ||    ||          |||  |||     ||||||||   ||   ||
1242 //...||    ||    ||||     ||           ||  ||     ||      ||  ||    ||
1243 //........................................................................
1244 //..................................................made with <3 --refugee
1245 //........................................................................
1246 
1247 contract PixelFoxes is ERC721Enumerable, Ownable {
1248 
1249     using Strings for uint256; 
1250     string _baseTokenURI; 
1251     // stay foxy my friends
1252     uint256 private _price = 0.01 ether; 
1253     bool public _paused = true; 
1254   
1255     // withdraw addresses
1256     address f1 = 0xcD7F3Af38CbE1c71091C91b44860FA797Db54813;
1257     address f2 = 0xbFF819faB7811373f0d18bd6677b7f44dF06eEa6;
1258       
1259     // PixelFoxes
1260     // Operation StayFoxy = 10000 PixelFoxes
1261     constructor(
1262         string memory name,
1263         string memory symbol,
1264         string memory baseURI
1265     ) ERC721(name,symbol)  {
1266         setBaseURI(baseURI);
1267     }
1268  
1269     function FoxMint(uint256 num) public payable {
1270         uint256 supply = totalSupply(); 
1271         require( !_paused,                      "Minting paused" );
1272         require( num < 31,                      "You can mint a maximum of 30 Foxes" );
1273         require( supply + num < 10001,          "Exceeds maximum PixelFox supply" );
1274         require( msg.value >= _price * num,     "Eth sent is not correct" ); 
1275         for(uint256 i; i < num; i++){
1276             _safeMint( msg.sender, supply + i );
1277         }
1278     }
1279 
1280     function giveAway(address _to, uint256 _amount) external onlyOwner() {
1281         uint256 supply = totalSupply(); 
1282         require( supply + _amount < 10001,  "Exceeds maximum PixelFox supply" );
1283         for(uint256 i; i < _amount; i++){
1284             _safeMint( _to, supply + i );
1285         } 
1286     }
1287 
1288     function walletOfOwner(address _owner) public view returns(uint256[] memory) {
1289         uint256 tokenCount = balanceOf(_owner); 
1290         uint256[] memory tokensId = new uint256[](tokenCount);
1291         for(uint256 i; i < tokenCount; i++){
1292             tokensId[i] = tokenOfOwnerByIndex(_owner, i);
1293         }
1294         return tokensId;
1295     }
1296     
1297     function setPrice(uint256 _newPrice) public onlyOwner() {
1298         _price = _newPrice;
1299     }
1300 
1301     function getPrice() public view returns (uint256){
1302         return _price;
1303     }
1304  
1305     function _baseURI() internal view virtual override returns (string memory) {
1306         return _baseTokenURI;
1307     }
1308     
1309     function setBaseURI(string memory baseURI) public onlyOwner {
1310         _baseTokenURI = baseURI;
1311     }
1312  
1313     function pause(bool val) public onlyOwner {
1314         _paused = val;
1315     }
1316  
1317     function withdrawAll() public payable onlyOwner {
1318         uint256 _each = address(this).balance / 2;
1319         require(payable(f1).send(_each));
1320         require(payable(f2).send(_each));
1321     }
1322   
1323 }