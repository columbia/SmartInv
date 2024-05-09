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
272 
273 /**
274  * @title ERC721 token receiver interface
275  * @dev Interface for any contract that wants to support safeTransfers
276  * from ERC721 asset contracts.
277  */
278 interface IERC721Receiver {
279     /**
280      * @dev Whenever an {IERC721} `tokenId` token is transferred to this contract via {IERC721-safeTransferFrom}
281      * by `operator` from `from`, this function is called.
282      *
283      * It must return its Solidity selector to confirm the token transfer.
284      * If any other value is returned or the interface is not implemented by the recipient, the transfer will be reverted.
285      *
286      * The selector can be obtained in Solidity with `IERC721.onERC721Received.selector`.
287      */
288     function onERC721Received(
289         address operator,
290         address from,
291         uint256 tokenId,
292         bytes calldata data
293     ) external returns (bytes4);
294 }
295 
296 
297 
298 
299 
300 
301 
302 /**
303  * @title ERC-721 Non-Fungible Token Standard, optional metadata extension
304  * @dev See https://eips.ethereum.org/EIPS/eip-721
305  */
306 interface IERC721Metadata is IERC721 {
307     /**
308      * @dev Returns the token collection name.
309      */
310     function name() external view returns (string memory);
311 
312     /**
313      * @dev Returns the token collection symbol.
314      */
315     function symbol() external view returns (string memory);
316 
317     /**
318      * @dev Returns the Uniform Resource Identifier (URI) for `tokenId` token.
319      */
320     function tokenURI(uint256 tokenId) external view returns (string memory);
321 }
322 
323 
324 
325 
326 
327 /**
328  * @dev Collection of functions related to the address type
329  */
330 library Address {
331     /**
332      * @dev Returns true if `account` is a contract.
333      *
334      * [IMPORTANT]
335      * ====
336      * It is unsafe to assume that an address for which this function returns
337      * false is an externally-owned account (EOA) and not a contract.
338      *
339      * Among others, `isContract` will return false for the following
340      * types of addresses:
341      *
342      *  - an externally-owned account
343      *  - a contract in construction
344      *  - an address where a contract will be created
345      *  - an address where a contract lived, but was destroyed
346      * ====
347      */
348     function isContract(address account) internal view returns (bool) {
349         // This method relies on extcodesize, which returns 0 for contracts in
350         // construction, since the code is only stored at the end of the
351         // constructor execution.
352 
353         uint256 size;
354         assembly {
355             size := extcodesize(account)
356         }
357         return size > 0;
358     }
359 
360     /**
361      * @dev Replacement for Solidity's `transfer`: sends `amount` wei to
362      * `recipient`, forwarding all available gas and reverting on errors.
363      *
364      * https://eips.ethereum.org/EIPS/eip-1884[EIP1884] increases the gas cost
365      * of certain opcodes, possibly making contracts go over the 2300 gas limit
366      * imposed by `transfer`, making them unable to receive funds via
367      * `transfer`. {sendValue} removes this limitation.
368      *
369      * https://diligence.consensys.net/posts/2019/09/stop-using-soliditys-transfer-now/[Learn more].
370      *
371      * IMPORTANT: because control is transferred to `recipient`, care must be
372      * taken to not create reentrancy vulnerabilities. Consider using
373      * {ReentrancyGuard} or the
374      * https://solidity.readthedocs.io/en/v0.5.11/security-considerations.html#use-the-checks-effects-interactions-pattern[checks-effects-interactions pattern].
375      */
376     function sendValue(address payable recipient, uint256 amount) internal {
377         require(address(this).balance >= amount, "Address: insufficient balance");
378 
379         (bool success, ) = recipient.call{value: amount}("");
380         require(success, "Address: unable to send value, recipient may have reverted");
381     }
382 
383     /**
384      * @dev Performs a Solidity function call using a low level `call`. A
385      * plain `call` is an unsafe replacement for a function call: use this
386      * function instead.
387      *
388      * If `target` reverts with a revert reason, it is bubbled up by this
389      * function (like regular Solidity function calls).
390      *
391      * Returns the raw returned data. To convert to the expected return value,
392      * use https://solidity.readthedocs.io/en/latest/units-and-global-variables.html?highlight=abi.decode#abi-encoding-and-decoding-functions[`abi.decode`].
393      *
394      * Requirements:
395      *
396      * - `target` must be a contract.
397      * - calling `target` with `data` must not revert.
398      *
399      * _Available since v3.1._
400      */
401     function functionCall(address target, bytes memory data) internal returns (bytes memory) {
402         return functionCall(target, data, "Address: low-level call failed");
403     }
404 
405     /**
406      * @dev Same as {xref-Address-functionCall-address-bytes-}[`functionCall`], but with
407      * `errorMessage` as a fallback revert reason when `target` reverts.
408      *
409      * _Available since v3.1._
410      */
411     function functionCall(
412         address target,
413         bytes memory data,
414         string memory errorMessage
415     ) internal returns (bytes memory) {
416         return functionCallWithValue(target, data, 0, errorMessage);
417     }
418 
419     /**
420      * @dev Same as {xref-Address-functionCall-address-bytes-}[`functionCall`],
421      * but also transferring `value` wei to `target`.
422      *
423      * Requirements:
424      *
425      * - the calling contract must have an ETH balance of at least `value`.
426      * - the called Solidity function must be `payable`.
427      *
428      * _Available since v3.1._
429      */
430     function functionCallWithValue(
431         address target,
432         bytes memory data,
433         uint256 value
434     ) internal returns (bytes memory) {
435         return functionCallWithValue(target, data, value, "Address: low-level call with value failed");
436     }
437 
438     /**
439      * @dev Same as {xref-Address-functionCallWithValue-address-bytes-uint256-}[`functionCallWithValue`], but
440      * with `errorMessage` as a fallback revert reason when `target` reverts.
441      *
442      * _Available since v3.1._
443      */
444     function functionCallWithValue(
445         address target,
446         bytes memory data,
447         uint256 value,
448         string memory errorMessage
449     ) internal returns (bytes memory) {
450         require(address(this).balance >= value, "Address: insufficient balance for call");
451         require(isContract(target), "Address: call to non-contract");
452 
453         (bool success, bytes memory returndata) = target.call{value: value}(data);
454         return verifyCallResult(success, returndata, errorMessage);
455     }
456 
457     /**
458      * @dev Same as {xref-Address-functionCall-address-bytes-}[`functionCall`],
459      * but performing a static call.
460      *
461      * _Available since v3.3._
462      */
463     function functionStaticCall(address target, bytes memory data) internal view returns (bytes memory) {
464         return functionStaticCall(target, data, "Address: low-level static call failed");
465     }
466 
467     /**
468      * @dev Same as {xref-Address-functionCall-address-bytes-string-}[`functionCall`],
469      * but performing a static call.
470      *
471      * _Available since v3.3._
472      */
473     function functionStaticCall(
474         address target,
475         bytes memory data,
476         string memory errorMessage
477     ) internal view returns (bytes memory) {
478         require(isContract(target), "Address: static call to non-contract");
479 
480         (bool success, bytes memory returndata) = target.staticcall(data);
481         return verifyCallResult(success, returndata, errorMessage);
482     }
483 
484     /**
485      * @dev Same as {xref-Address-functionCall-address-bytes-}[`functionCall`],
486      * but performing a delegate call.
487      *
488      * _Available since v3.4._
489      */
490     function functionDelegateCall(address target, bytes memory data) internal returns (bytes memory) {
491         return functionDelegateCall(target, data, "Address: low-level delegate call failed");
492     }
493 
494     /**
495      * @dev Same as {xref-Address-functionCall-address-bytes-string-}[`functionCall`],
496      * but performing a delegate call.
497      *
498      * _Available since v3.4._
499      */
500     function functionDelegateCall(
501         address target,
502         bytes memory data,
503         string memory errorMessage
504     ) internal returns (bytes memory) {
505         require(isContract(target), "Address: delegate call to non-contract");
506 
507         (bool success, bytes memory returndata) = target.delegatecall(data);
508         return verifyCallResult(success, returndata, errorMessage);
509     }
510 
511     /**
512      * @dev Tool to verifies that a low level call was successful, and revert if it wasn't, either by bubbling the
513      * revert reason using the provided one.
514      *
515      * _Available since v4.3._
516      */
517     function verifyCallResult(
518         bool success,
519         bytes memory returndata,
520         string memory errorMessage
521     ) internal pure returns (bytes memory) {
522         if (success) {
523             return returndata;
524         } else {
525             // Look for revert reason and bubble it up if present
526             if (returndata.length > 0) {
527                 // The easiest way to bubble the revert reason is using memory via assembly
528 
529                 assembly {
530                     let returndata_size := mload(returndata)
531                     revert(add(32, returndata), returndata_size)
532                 }
533             } else {
534                 revert(errorMessage);
535             }
536         }
537     }
538 }
539 
540 
541 
542 
543 
544 
545 
546 
547 
548 /**
549  * @dev Implementation of the {IERC165} interface.
550  *
551  * Contracts that want to implement ERC165 should inherit from this contract and override {supportsInterface} to check
552  * for the additional interface id that will be supported. For example:
553  *
554  * ```solidity
555  * function supportsInterface(bytes4 interfaceId) public view virtual override returns (bool) {
556  *     return interfaceId == type(MyInterface).interfaceId || super.supportsInterface(interfaceId);
557  * }
558  * ```
559  *
560  * Alternatively, {ERC165Storage} provides an easier to use but more expensive implementation.
561  */
562 abstract contract ERC165 is IERC165 {
563     /**
564      * @dev See {IERC165-supportsInterface}.
565      */
566     function supportsInterface(bytes4 interfaceId) public view virtual override returns (bool) {
567         return interfaceId == type(IERC165).interfaceId;
568     }
569 }
570 
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
588     mapping(uint256 => address) private _owners;
589 
590     // Mapping owner address to token count
591     mapping(address => uint256) private _balances;
592 
593     // Mapping from token ID to approved address
594     mapping(uint256 => address) private _tokenApprovals;
595 
596     // Mapping from owner to operator approvals
597     mapping(address => mapping(address => bool)) private _operatorApprovals;
598 
599     /**
600      * @dev Initializes the contract by setting a `name` and a `symbol` to the token collection.
601      */
602     constructor(string memory name_, string memory symbol_) {
603         _name = name_;
604         _symbol = symbol_;
605     }
606 
607     /**
608      * @dev See {IERC165-supportsInterface}.
609      */
610     function supportsInterface(bytes4 interfaceId) public view virtual override(ERC165, IERC165) returns (bool) {
611         return
612             interfaceId == type(IERC721).interfaceId ||
613             interfaceId == type(IERC721Metadata).interfaceId ||
614             super.supportsInterface(interfaceId);
615     }
616 
617     /**
618      * @dev See {IERC721-balanceOf}.
619      */
620     function balanceOf(address owner) public view virtual override returns (uint256) {
621         require(owner != address(0), "ERC721: balance query for the zero address");
622         return _balances[owner];
623     }
624 
625     /**
626      * @dev See {IERC721-ownerOf}.
627      */
628     function ownerOf(uint256 tokenId) public view virtual override returns (address) {
629         address owner = _owners[tokenId];
630         require(owner != address(0), "ERC721: owner query for nonexistent token");
631         return owner;
632     }
633 
634     /**
635      * @dev See {IERC721Metadata-name}.
636      */
637     function name() public view virtual override returns (string memory) {
638         return _name;
639     }
640 
641     /**
642      * @dev See {IERC721Metadata-symbol}.
643      */
644     function symbol() public view virtual override returns (string memory) {
645         return _symbol;
646     }
647 
648     /**
649      * @dev See {IERC721Metadata-tokenURI}.
650      */
651     function tokenURI(uint256 tokenId) public view virtual override returns (string memory) {
652         require(_exists(tokenId), "ERC721Metadata: URI query for nonexistent token");
653 
654         string memory baseURI = _baseURI();
655         return bytes(baseURI).length > 0 ? string(abi.encodePacked(baseURI, tokenId.toString())) : "";
656     }
657 
658     /**
659      * @dev Base URI for computing {tokenURI}. If set, the resulting URI for each
660      * token will be the concatenation of the `baseURI` and the `tokenId`. Empty
661      * by default, can be overriden in child contracts.
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
674         require(
675             _msgSender() == owner || isApprovedForAll(owner, _msgSender()),
676             "ERC721: approve caller is not owner nor approved for all"
677         );
678 
679         _approve(to, tokenId);
680     }
681 
682     /**
683      * @dev See {IERC721-getApproved}.
684      */
685     function getApproved(uint256 tokenId) public view virtual override returns (address) {
686         require(_exists(tokenId), "ERC721: approved query for nonexistent token");
687 
688         return _tokenApprovals[tokenId];
689     }
690 
691     /**
692      * @dev See {IERC721-setApprovalForAll}.
693      */
694     function setApprovalForAll(address operator, bool approved) public virtual override {
695         require(operator != _msgSender(), "ERC721: approve to caller");
696 
697         _operatorApprovals[_msgSender()][operator] = approved;
698         emit ApprovalForAll(_msgSender(), operator, approved);
699     }
700 
701     /**
702      * @dev See {IERC721-isApprovedForAll}.
703      */
704     function isApprovedForAll(address owner, address operator) public view virtual override returns (bool) {
705         return _operatorApprovals[owner][operator];
706     }
707 
708     /**
709      * @dev See {IERC721-transferFrom}.
710      */
711     function transferFrom(
712         address from,
713         address to,
714         uint256 tokenId
715     ) public virtual override {
716         //solhint-disable-next-line max-line-length
717         require(_isApprovedOrOwner(_msgSender(), tokenId), "ERC721: transfer caller is not owner nor approved");
718 
719         _transfer(from, to, tokenId);
720     }
721 
722     /**
723      * @dev See {IERC721-safeTransferFrom}.
724      */
725     function safeTransferFrom(
726         address from,
727         address to,
728         uint256 tokenId
729     ) public virtual override {
730         safeTransferFrom(from, to, tokenId, "");
731     }
732 
733     /**
734      * @dev See {IERC721-safeTransferFrom}.
735      */
736     function safeTransferFrom(
737         address from,
738         address to,
739         uint256 tokenId,
740         bytes memory _data
741     ) public virtual override {
742         require(_isApprovedOrOwner(_msgSender(), tokenId), "ERC721: transfer caller is not owner nor approved");
743         _safeTransfer(from, to, tokenId, _data);
744     }
745 
746     /**
747      * @dev Safely transfers `tokenId` token from `from` to `to`, checking first that contract recipients
748      * are aware of the ERC721 protocol to prevent tokens from being forever locked.
749      *
750      * `_data` is additional data, it has no specified format and it is sent in call to `to`.
751      *
752      * This internal function is equivalent to {safeTransferFrom}, and can be used to e.g.
753      * implement alternative mechanisms to perform token transfer, such as signature-based.
754      *
755      * Requirements:
756      *
757      * - `from` cannot be the zero address.
758      * - `to` cannot be the zero address.
759      * - `tokenId` token must exist and be owned by `from`.
760      * - If `to` refers to a smart contract, it must implement {IERC721Receiver-onERC721Received}, which is called upon a safe transfer.
761      *
762      * Emits a {Transfer} event.
763      */
764     function _safeTransfer(
765         address from,
766         address to,
767         uint256 tokenId,
768         bytes memory _data
769     ) internal virtual {
770         _transfer(from, to, tokenId);
771         require(_checkOnERC721Received(from, to, tokenId, _data), "ERC721: transfer to non ERC721Receiver implementer");
772     }
773 
774     /**
775      * @dev Returns whether `tokenId` exists.
776      *
777      * Tokens can be managed by their owner or approved accounts via {approve} or {setApprovalForAll}.
778      *
779      * Tokens start existing when they are minted (`_mint`),
780      * and stop existing when they are burned (`_burn`).
781      */
782     function _exists(uint256 tokenId) internal view virtual returns (bool) {
783         return _owners[tokenId] != address(0);
784     }
785 
786     /**
787      * @dev Returns whether `spender` is allowed to manage `tokenId`.
788      *
789      * Requirements:
790      *
791      * - `tokenId` must exist.
792      */
793     function _isApprovedOrOwner(address spender, uint256 tokenId) internal view virtual returns (bool) {
794         require(_exists(tokenId), "ERC721: operator query for nonexistent token");
795         address owner = ERC721.ownerOf(tokenId);
796         return (spender == owner || getApproved(tokenId) == spender || isApprovedForAll(owner, spender));
797     }
798 
799     /**
800      * @dev Safely mints `tokenId` and transfers it to `to`.
801      *
802      * Requirements:
803      *
804      * - `tokenId` must not exist.
805      * - If `to` refers to a smart contract, it must implement {IERC721Receiver-onERC721Received}, which is called upon a safe transfer.
806      *
807      * Emits a {Transfer} event.
808      */
809     function _safeMint(address to, uint256 tokenId) internal virtual {
810         _safeMint(to, tokenId, "");
811     }
812 
813     /**
814      * @dev Same as {xref-ERC721-_safeMint-address-uint256-}[`_safeMint`], with an additional `data` parameter which is
815      * forwarded in {IERC721Receiver-onERC721Received} to contract recipients.
816      */
817     function _safeMint(
818         address to,
819         uint256 tokenId,
820         bytes memory _data
821     ) internal virtual {
822         _mint(to, tokenId);
823         require(
824             _checkOnERC721Received(address(0), to, tokenId, _data),
825             "ERC721: transfer to non ERC721Receiver implementer"
826         );
827     }
828 
829     /**
830      * @dev Mints `tokenId` and transfers it to `to`.
831      *
832      * WARNING: Usage of this method is discouraged, use {_safeMint} whenever possible
833      *
834      * Requirements:
835      *
836      * - `tokenId` must not exist.
837      * - `to` cannot be the zero address.
838      *
839      * Emits a {Transfer} event.
840      */
841     function _mint(address to, uint256 tokenId) internal virtual {
842         require(to != address(0), "ERC721: mint to the zero address");
843         require(!_exists(tokenId), "ERC721: token already minted");
844 
845         _beforeTokenTransfer(address(0), to, tokenId);
846 
847         _balances[to] += 1;
848         _owners[tokenId] = to;
849 
850         emit Transfer(address(0), to, tokenId);
851     }
852 
853     /**
854      * @dev Destroys `tokenId`.
855      * The approval is cleared when the token is burned.
856      *
857      * Requirements:
858      *
859      * - `tokenId` must exist.
860      *
861      * Emits a {Transfer} event.
862      */
863     function _burn(uint256 tokenId) internal virtual {
864         address owner = ERC721.ownerOf(tokenId);
865 
866         _beforeTokenTransfer(owner, address(0), tokenId);
867 
868         // Clear approvals
869         _approve(address(0), tokenId);
870 
871         _balances[owner] -= 1;
872         delete _owners[tokenId];
873 
874         emit Transfer(owner, address(0), tokenId);
875     }
876 
877     /**
878      * @dev Transfers `tokenId` from `from` to `to`.
879      *  As opposed to {transferFrom}, this imposes no restrictions on msg.sender.
880      *
881      * Requirements:
882      *
883      * - `to` cannot be the zero address.
884      * - `tokenId` token must be owned by `from`.
885      *
886      * Emits a {Transfer} event.
887      */
888     function _transfer(
889         address from,
890         address to,
891         uint256 tokenId
892     ) internal virtual {
893         require(ERC721.ownerOf(tokenId) == from, "ERC721: transfer of token that is not own");
894         require(to != address(0), "ERC721: transfer to the zero address");
895 
896         _beforeTokenTransfer(from, to, tokenId);
897 
898         // Clear approvals from the previous owner
899         _approve(address(0), tokenId);
900 
901         _balances[from] -= 1;
902         _balances[to] += 1;
903         _owners[tokenId] = to;
904 
905         emit Transfer(from, to, tokenId);
906     }
907 
908     /**
909      * @dev Approve `to` to operate on `tokenId`
910      *
911      * Emits a {Approval} event.
912      */
913     function _approve(address to, uint256 tokenId) internal virtual {
914         _tokenApprovals[tokenId] = to;
915         emit Approval(ERC721.ownerOf(tokenId), to, tokenId);
916     }
917 
918     /**
919      * @dev Internal function to invoke {IERC721Receiver-onERC721Received} on a target address.
920      * The call is not executed if the target address is not a contract.
921      *
922      * @param from address representing the previous owner of the given token ID
923      * @param to target address that will receive the tokens
924      * @param tokenId uint256 ID of the token to be transferred
925      * @param _data bytes optional data to send along with the call
926      * @return bool whether the call correctly returned the expected magic value
927      */
928     function _checkOnERC721Received(
929         address from,
930         address to,
931         uint256 tokenId,
932         bytes memory _data
933     ) private returns (bool) {
934         if (to.isContract()) {
935             try IERC721Receiver(to).onERC721Received(_msgSender(), from, tokenId, _data) returns (bytes4 retval) {
936                 return retval == IERC721Receiver.onERC721Received.selector;
937             } catch (bytes memory reason) {
938                 if (reason.length == 0) {
939                     revert("ERC721: transfer to non ERC721Receiver implementer");
940                 } else {
941                     assembly {
942                         revert(add(32, reason), mload(reason))
943                     }
944                 }
945             }
946         } else {
947             return true;
948         }
949     }
950 
951     /**
952      * @dev Hook that is called before any token transfer. This includes minting
953      * and burning.
954      *
955      * Calling conditions:
956      *
957      * - When `from` and `to` are both non-zero, ``from``'s `tokenId` will be
958      * transferred to `to`.
959      * - When `from` is zero, `tokenId` will be minted for `to`.
960      * - When `to` is zero, ``from``'s `tokenId` will be burned.
961      * - `from` and `to` are never both zero.
962      *
963      * To learn more about hooks, head to xref:ROOT:extending-contracts.adoc#using-hooks[Using Hooks].
964      */
965     function _beforeTokenTransfer(
966         address from,
967         address to,
968         uint256 tokenId
969     ) internal virtual {}
970 }
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
1234 // CAUTION
1235 // This version of SafeMath should only be used with Solidity 0.8 or later,
1236 // because it relies on the compiler's built in overflow checks.
1237 
1238 /**
1239  * @dev Wrappers over Solidity's arithmetic operations.
1240  *
1241  * NOTE: `SafeMath` is no longer needed starting with Solidity 0.8. The compiler
1242  * now has built in overflow checking.
1243  */
1244 library SafeMath {
1245     /**
1246      * @dev Returns the addition of two unsigned integers, with an overflow flag.
1247      *
1248      * _Available since v3.4._
1249      */
1250     function tryAdd(uint256 a, uint256 b) internal pure returns (bool, uint256) {
1251         unchecked {
1252             uint256 c = a + b;
1253             if (c < a) return (false, 0);
1254             return (true, c);
1255         }
1256     }
1257 
1258     /**
1259      * @dev Returns the substraction of two unsigned integers, with an overflow flag.
1260      *
1261      * _Available since v3.4._
1262      */
1263     function trySub(uint256 a, uint256 b) internal pure returns (bool, uint256) {
1264         unchecked {
1265             if (b > a) return (false, 0);
1266             return (true, a - b);
1267         }
1268     }
1269 
1270     /**
1271      * @dev Returns the multiplication of two unsigned integers, with an overflow flag.
1272      *
1273      * _Available since v3.4._
1274      */
1275     function tryMul(uint256 a, uint256 b) internal pure returns (bool, uint256) {
1276         unchecked {
1277             // Gas optimization: this is cheaper than requiring 'a' not being zero, but the
1278             // benefit is lost if 'b' is also tested.
1279             // See: https://github.com/OpenZeppelin/openzeppelin-contracts/pull/522
1280             if (a == 0) return (true, 0);
1281             uint256 c = a * b;
1282             if (c / a != b) return (false, 0);
1283             return (true, c);
1284         }
1285     }
1286 
1287     /**
1288      * @dev Returns the division of two unsigned integers, with a division by zero flag.
1289      *
1290      * _Available since v3.4._
1291      */
1292     function tryDiv(uint256 a, uint256 b) internal pure returns (bool, uint256) {
1293         unchecked {
1294             if (b == 0) return (false, 0);
1295             return (true, a / b);
1296         }
1297     }
1298 
1299     /**
1300      * @dev Returns the remainder of dividing two unsigned integers, with a division by zero flag.
1301      *
1302      * _Available since v3.4._
1303      */
1304     function tryMod(uint256 a, uint256 b) internal pure returns (bool, uint256) {
1305         unchecked {
1306             if (b == 0) return (false, 0);
1307             return (true, a % b);
1308         }
1309     }
1310 
1311     /**
1312      * @dev Returns the addition of two unsigned integers, reverting on
1313      * overflow.
1314      *
1315      * Counterpart to Solidity's `+` operator.
1316      *
1317      * Requirements:
1318      *
1319      * - Addition cannot overflow.
1320      */
1321     function add(uint256 a, uint256 b) internal pure returns (uint256) {
1322         return a + b;
1323     }
1324 
1325     /**
1326      * @dev Returns the subtraction of two unsigned integers, reverting on
1327      * overflow (when the result is negative).
1328      *
1329      * Counterpart to Solidity's `-` operator.
1330      *
1331      * Requirements:
1332      *
1333      * - Subtraction cannot overflow.
1334      */
1335     function sub(uint256 a, uint256 b) internal pure returns (uint256) {
1336         return a - b;
1337     }
1338 
1339     /**
1340      * @dev Returns the multiplication of two unsigned integers, reverting on
1341      * overflow.
1342      *
1343      * Counterpart to Solidity's `*` operator.
1344      *
1345      * Requirements:
1346      *
1347      * - Multiplication cannot overflow.
1348      */
1349     function mul(uint256 a, uint256 b) internal pure returns (uint256) {
1350         return a * b;
1351     }
1352 
1353     /**
1354      * @dev Returns the integer division of two unsigned integers, reverting on
1355      * division by zero. The result is rounded towards zero.
1356      *
1357      * Counterpart to Solidity's `/` operator.
1358      *
1359      * Requirements:
1360      *
1361      * - The divisor cannot be zero.
1362      */
1363     function div(uint256 a, uint256 b) internal pure returns (uint256) {
1364         return a / b;
1365     }
1366 
1367     /**
1368      * @dev Returns the remainder of dividing two unsigned integers. (unsigned integer modulo),
1369      * reverting when dividing by zero.
1370      *
1371      * Counterpart to Solidity's `%` operator. This function uses a `revert`
1372      * opcode (which leaves remaining gas untouched) while Solidity uses an
1373      * invalid opcode to revert (consuming all remaining gas).
1374      *
1375      * Requirements:
1376      *
1377      * - The divisor cannot be zero.
1378      */
1379     function mod(uint256 a, uint256 b) internal pure returns (uint256) {
1380         return a % b;
1381     }
1382 
1383     /**
1384      * @dev Returns the subtraction of two unsigned integers, reverting with custom message on
1385      * overflow (when the result is negative).
1386      *
1387      * CAUTION: This function is deprecated because it requires allocating memory for the error
1388      * message unnecessarily. For custom revert reasons use {trySub}.
1389      *
1390      * Counterpart to Solidity's `-` operator.
1391      *
1392      * Requirements:
1393      *
1394      * - Subtraction cannot overflow.
1395      */
1396     function sub(
1397         uint256 a,
1398         uint256 b,
1399         string memory errorMessage
1400     ) internal pure returns (uint256) {
1401         unchecked {
1402             require(b <= a, errorMessage);
1403             return a - b;
1404         }
1405     }
1406 
1407     /**
1408      * @dev Returns the integer division of two unsigned integers, reverting with custom message on
1409      * division by zero. The result is rounded towards zero.
1410      *
1411      * Counterpart to Solidity's `/` operator. Note: this function uses a
1412      * `revert` opcode (which leaves remaining gas untouched) while Solidity
1413      * uses an invalid opcode to revert (consuming all remaining gas).
1414      *
1415      * Requirements:
1416      *
1417      * - The divisor cannot be zero.
1418      */
1419     function div(
1420         uint256 a,
1421         uint256 b,
1422         string memory errorMessage
1423     ) internal pure returns (uint256) {
1424         unchecked {
1425             require(b > 0, errorMessage);
1426             return a / b;
1427         }
1428     }
1429 
1430     /**
1431      * @dev Returns the remainder of dividing two unsigned integers. (unsigned integer modulo),
1432      * reverting with custom message when dividing by zero.
1433      *
1434      * CAUTION: This function is deprecated because it requires allocating memory for the error
1435      * message unnecessarily. For custom revert reasons use {tryMod}.
1436      *
1437      * Counterpart to Solidity's `%` operator. This function uses a `revert`
1438      * opcode (which leaves remaining gas untouched) while Solidity uses an
1439      * invalid opcode to revert (consuming all remaining gas).
1440      *
1441      * Requirements:
1442      *
1443      * - The divisor cannot be zero.
1444      */
1445     function mod(
1446         uint256 a,
1447         uint256 b,
1448         string memory errorMessage
1449     ) internal pure returns (uint256) {
1450         unchecked {
1451             require(b > 0, errorMessage);
1452             return a % b;
1453         }
1454     }
1455 }
1456 
1457 
1458 contract ApeKidsClub is ERC721Enumerable, Ownable {
1459   using Strings for uint256;
1460   using SafeMath for uint256;
1461 
1462   //NFT params
1463   string public baseURI;
1464   string public defaultURI;
1465   string public mycontractURI;
1466   bool public finalizeBaseUri = false;
1467 
1468   //sale stages:
1469   //stage 0: init(no minting)
1470   //stage 1: free-mint
1471   //stage 2: pre-sale
1472   //stage 3: pre-sale clearance
1473   //stage 4: public sale
1474   uint8 public stage = 0;
1475 
1476   //free-mint (stage=1)
1477   mapping(address => uint8) public free_whitelisted;
1478 
1479   //pre-sale (stage=2)
1480   mapping(address => bool) public presale_whitelisted;
1481 
1482   uint256 public presalePrice = 0.04 ether;
1483   uint256 public presaleSupply;  //2500
1484   uint256 public presaleMintMax = 1;
1485   mapping(address => uint8) public presaleMintCount;
1486 
1487   //pre-sale-clearance (stage=3)
1488   uint256 public clearanceMintMax = 2; //one more than presaleMintMax
1489 
1490   //public sale (stage=4)
1491   uint256 public salePrice = 0.05 ether;
1492   uint256 public saleMintMax = 3;
1493   uint256 public totalSaleSupply;  //9999
1494   mapping(address => uint8) public saleMintCount;
1495 
1496   //others
1497   bool public paused = false;
1498 
1499   //sale holders
1500   address[6] public fundRecipients = [
1501     0x5012811582438641C9dfAbFa5dD11763A2918743,
1502     0x20c606439a3ee9988453C192f825893FF5CB40A1,
1503     0x64b2F353eBd93D9630F116F9d8d3cF6393Ed9937,
1504     0x4C963D2F3c57a2FaC9713A1b1bCC16e3667EDd5d,
1505     0x4bf12f7f7E8DC6a2ba19C648eF02fFEEcE383594,
1506     0x493a401122d858324517C5eC95145dc970c2C363
1507   ];
1508   uint256[] public receivePercentagePt = [100, 1500, 500, 500, 3700];   //distribution in basis points
1509 
1510   //royalty
1511   address public royaltyAddr;
1512   uint256 public royaltyBasis;
1513 
1514   constructor(
1515     string memory _name,
1516     string memory _symbol,
1517     string memory _initBaseURI,
1518     string memory _defaultURI,
1519     uint256 _presaleSupply,
1520     uint256 _totalSaleSupply
1521   ) ERC721(_name, _symbol) {
1522     setBaseURI(_initBaseURI);
1523     defaultURI = _defaultURI;
1524     presaleSupply = _presaleSupply;
1525     totalSaleSupply = _totalSaleSupply;
1526   }
1527 
1528   // internal
1529   function _baseURI() internal view virtual override returns (string memory) {
1530     return baseURI;
1531   }
1532 
1533   function supportsInterface(bytes4 interfaceId) public view override(ERC721Enumerable) returns (bool) {
1534       return interfaceId == type(IERC721Enumerable).interfaceId || 
1535       interfaceId == 0xe8a3d485 /* contractURI() */ ||
1536       interfaceId == 0x2a55205a /* ERC-2981 royaltyInfo() */ ||
1537       super.supportsInterface(interfaceId);
1538   }
1539 
1540   // public
1541   function mint(uint8 _mintAmount) public payable {
1542     uint256 supply = totalSupply();
1543     require(!paused);
1544     require(stage > 0);
1545     require(_mintAmount > 0);
1546 
1547     if (stage == 1) {
1548       //free-mint
1549       require(free_whitelisted[msg.sender] - _mintAmount >= 0);
1550       free_whitelisted[msg.sender] -= _mintAmount;
1551     } else if (stage == 2) {
1552       //pre-sale
1553       require(presale_whitelisted[msg.sender]);
1554       require(supply + _mintAmount <= presaleSupply);
1555       require(_mintAmount + presaleMintCount[msg.sender] <= presaleMintMax);      
1556       require(msg.value >= presalePrice * _mintAmount);
1557       presaleMintCount[msg.sender] += _mintAmount;
1558 
1559     }  else if (stage == 3) {
1560       //pre-sale clearance
1561       require(presale_whitelisted[msg.sender]);
1562       require(supply + _mintAmount <= presaleSupply);
1563       require(_mintAmount + presaleMintCount[msg.sender] <= clearanceMintMax);      
1564       require(msg.value >= presalePrice * _mintAmount);
1565       presaleMintCount[msg.sender] += _mintAmount;
1566 
1567     }  else if (stage == 4) {
1568       //public sale
1569       require(supply + _mintAmount <= totalSaleSupply);
1570       require(_mintAmount + saleMintCount[msg.sender] <= saleMintMax);
1571       require(msg.value >= salePrice * _mintAmount);
1572       saleMintCount[msg.sender] += _mintAmount;
1573     } else {
1574       assert(false);
1575     }
1576 
1577     for (uint256 i = 1; i <= _mintAmount; i++) {
1578       _safeMint(msg.sender, supply + i);
1579     }
1580   }
1581 
1582   function walletOfOwner(address _owner)
1583     public
1584     view
1585     returns (uint256[] memory)
1586   {
1587     uint256 ownerTokenCount = balanceOf(_owner);
1588     uint256[] memory tokenIds = new uint256[](ownerTokenCount);
1589     for (uint256 i; i < ownerTokenCount; i++) {
1590       tokenIds[i] = tokenOfOwnerByIndex(_owner, i);
1591     }
1592     return tokenIds;
1593   }
1594 
1595   function tokenURI(uint256 tokenId)
1596     public
1597     view
1598     virtual
1599     override
1600     returns (string memory)
1601   {
1602     require(
1603       _exists(tokenId),
1604       "ERC721Metadata: URI query for nonexistent token"
1605     );
1606 
1607     string memory currentBaseURI = _baseURI();
1608     return bytes(currentBaseURI).length > 0
1609         ? string(abi.encodePacked(currentBaseURI, tokenId.toString()))
1610         : defaultURI;
1611   }
1612 
1613   function contractURI() public view returns (string memory) {
1614         return string(abi.encodePacked(mycontractURI));
1615   }
1616 
1617   //ERC-2981
1618   function royaltyInfo(uint256 _tokenId, uint256 _salePrice) external view 
1619   returns (address receiver, uint256 royaltyAmount){
1620     return (royaltyAddr, _salePrice.mul(royaltyBasis).div(10000));
1621   }
1622 
1623   //only owner functions ---
1624 
1625   function nextStage() public onlyOwner() {
1626     require(stage < 4);
1627     stage++;
1628   }
1629 
1630   function setBaseURI(string memory _newBaseURI) public onlyOwner {
1631     require(!finalizeBaseUri);
1632     baseURI = _newBaseURI;
1633   }
1634 
1635   function finalizeBaseURI() public onlyOwner {
1636     finalizeBaseUri = true;
1637   }
1638 
1639   function setContractURI(string memory _contractURI) public onlyOwner {
1640     mycontractURI = _contractURI;
1641     //return format based on https://docs.opensea.io/docs/contract-level-metadata
1642   }
1643 
1644   function setRoyalty(address _royaltyAddr, uint256 _royaltyBasis) public onlyOwner {
1645     royaltyAddr = _royaltyAddr;
1646     royaltyBasis = _royaltyBasis;
1647   }
1648 
1649   function pause(bool _state) public onlyOwner {
1650     paused = _state;
1651   }
1652  
1653   function whitelistFreeUsers(address[] memory _users, uint8[] memory _num_mints) public onlyOwner {
1654      for(uint i=0;i<_users.length;i++)
1655        free_whitelisted[_users[i]] = _num_mints[i];
1656   }
1657 
1658   function whitelistPresaleUsers(address[] memory _users) public onlyOwner {
1659      for(uint i=0;i<_users.length;i++)
1660        presale_whitelisted[_users[i]] = true;
1661   }
1662 
1663   function removeFreeWhitelistUser(address _user) public onlyOwner {
1664       free_whitelisted[_user] = 0;
1665   }
1666 
1667   function removePresaleWhitelistUser(address _user) public onlyOwner {
1668       presale_whitelisted[_user] = false;
1669   }
1670 
1671   function reserveMint(uint256 _mintAmount, address _to) public onlyOwner {
1672     uint256 supply = totalSupply();
1673     for (uint256 i = 1; i <= _mintAmount; i++) {
1674       _safeMint(_to, supply + i);
1675     }
1676   }
1677 
1678   //fund withdraw functions ---
1679   function withdrawFund() public onlyOwner {
1680     uint256 currentBal = address(this).balance;
1681     require(currentBal > 0);
1682     for (uint256 i = 0; i < fundRecipients.length-1; i++) {
1683       _withdraw(fundRecipients[i], currentBal.mul(receivePercentagePt[i]).div(10000));
1684     }
1685     //final address receives remainder to prevent ether dust
1686     _withdraw(fundRecipients[fundRecipients.length-1], address(this).balance);
1687   }
1688 
1689   function _withdraw(address _addr, uint256 _amt) private {
1690     (bool success,) = _addr.call{value: _amt}("");
1691     require(success, "Transfer failed");
1692   }
1693 
1694 }