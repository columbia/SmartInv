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
30  * @dev Required interface of an ERC721 compliant contract.
31  */
32 interface IERC721 is IERC165 {
33     /**
34      * @dev Emitted when `tokenId` token is transferred from `from` to `to`.
35      */
36     event Transfer(address indexed from, address indexed to, uint256 indexed tokenId);
37 
38     /**
39      * @dev Emitted when `owner` enables `approved` to manage the `tokenId` token.
40      */
41     event Approval(address indexed owner, address indexed approved, uint256 indexed tokenId);
42 
43     /**
44      * @dev Emitted when `owner` enables or disables (`approved`) `operator` to manage all of its assets.
45      */
46     event ApprovalForAll(address indexed owner, address indexed operator, bool approved);
47 
48     /**
49      * @dev Returns the number of tokens in ``owner``'s account.
50      */
51     function balanceOf(address owner) external view returns (uint256 balance);
52 
53     /**
54      * @dev Returns the owner of the `tokenId` token.
55      *
56      * Requirements:
57      *
58      * - `tokenId` must exist.
59      */
60     function ownerOf(uint256 tokenId) external view returns (address owner);
61 
62     /**
63      * @dev Safely transfers `tokenId` token from `from` to `to`, checking first that contract recipients
64      * are aware of the ERC721 protocol to prevent tokens from being forever locked.
65      *
66      * Requirements:
67      *
68      * - `from` cannot be the zero address.
69      * - `to` cannot be the zero address.
70      * - `tokenId` token must exist and be owned by `from`.
71      * - If the caller is not `from`, it must be have been allowed to move this token by either {approve} or {setApprovalForAll}.
72      * - If `to` refers to a smart contract, it must implement {IERC721Receiver-onERC721Received}, which is called upon a safe transfer.
73      *
74      * Emits a {Transfer} event.
75      */
76     function safeTransferFrom(
77         address from,
78         address to,
79         uint256 tokenId
80     ) external;
81 
82     /**
83      * @dev Transfers `tokenId` token from `from` to `to`.
84      *
85      * WARNING: Usage of this method is discouraged, use {safeTransferFrom} whenever possible.
86      *
87      * Requirements:
88      *
89      * - `from` cannot be the zero address.
90      * - `to` cannot be the zero address.
91      * - `tokenId` token must be owned by `from`.
92      * - If the caller is not `from`, it must be approved to move this token by either {approve} or {setApprovalForAll}.
93      *
94      * Emits a {Transfer} event.
95      */
96     function transferFrom(
97         address from,
98         address to,
99         uint256 tokenId
100     ) external;
101 
102     /**
103      * @dev Gives permission to `to` to transfer `tokenId` token to another account.
104      * The approval is cleared when the token is transferred.
105      *
106      * Only a single account can be approved at a time, so approving the zero address clears previous approvals.
107      *
108      * Requirements:
109      *
110      * - The caller must own the token or be an approved operator.
111      * - `tokenId` must exist.
112      *
113      * Emits an {Approval} event.
114      */
115     function approve(address to, uint256 tokenId) external;
116 
117     /**
118      * @dev Returns the account approved for `tokenId` token.
119      *
120      * Requirements:
121      *
122      * - `tokenId` must exist.
123      */
124     function getApproved(uint256 tokenId) external view returns (address operator);
125 
126     /**
127      * @dev Approve or remove `operator` as an operator for the caller.
128      * Operators can call {transferFrom} or {safeTransferFrom} for any token owned by the caller.
129      *
130      * Requirements:
131      *
132      * - The `operator` cannot be the caller.
133      *
134      * Emits an {ApprovalForAll} event.
135      */
136     function setApprovalForAll(address operator, bool _approved) external;
137 
138     /**
139      * @dev Returns if the `operator` is allowed to manage all of the assets of `owner`.
140      *
141      * See {setApprovalForAll}
142      */
143     function isApprovedForAll(address owner, address operator) external view returns (bool);
144 
145     /**
146      * @dev Safely transfers `tokenId` token from `from` to `to`.
147      *
148      * Requirements:
149      *
150      * - `from` cannot be the zero address.
151      * - `to` cannot be the zero address.
152      * - `tokenId` token must exist and be owned by `from`.
153      * - If the caller is not `from`, it must be approved to move this token by either {approve} or {setApprovalForAll}.
154      * - If `to` refers to a smart contract, it must implement {IERC721Receiver-onERC721Received}, which is called upon a safe transfer.
155      *
156      * Emits a {Transfer} event.
157      */
158     function safeTransferFrom(
159         address from,
160         address to,
161         uint256 tokenId,
162         bytes calldata data
163     ) external;
164 }
165 
166  
167 /**
168  * @title ERC721 token receiver interface
169  * @dev Interface for any contract that wants to support safeTransfers
170  * from ERC721 asset contracts.
171  */
172 interface IERC721Receiver {
173     /**
174      * @dev Whenever an {IERC721} `tokenId` token is transferred to this contract via {IERC721-safeTransferFrom}
175      * by `operator` from `from`, this function is called.
176      *
177      * It must return its Solidity selector to confirm the token transfer.
178      * If any other value is returned or the interface is not implemented by the recipient, the transfer will be reverted.
179      *
180      * The selector can be obtained in Solidity with `IERC721.onERC721Received.selector`.
181      */
182     function onERC721Received(
183         address operator,
184         address from,
185         uint256 tokenId,
186         bytes calldata data
187     ) external returns (bytes4);
188 }
189 
190  
191 
192 
193 /**
194  * @title ERC-721 Non-Fungible Token Standard, optional metadata extension
195  * @dev See https://eips.ethereum.org/EIPS/eip-721
196  */
197 interface IERC721Metadata is IERC721 {
198     /**
199      * @dev Returns the token collection name.
200      */
201     function name() external view returns (string memory);
202 
203     /**
204      * @dev Returns the token collection symbol.
205      */
206     function symbol() external view returns (string memory);
207 
208     /**
209      * @dev Returns the Uniform Resource Identifier (URI) for `tokenId` token.
210      */
211     function tokenURI(uint256 tokenId) external view returns (string memory);
212 }
213  
214 
215 /**
216  * @dev Collection of functions related to the address type
217  */
218 library Address {
219     /**
220      * @dev Returns true if `account` is a contract.
221      *
222      * [IMPORTANT]
223      * ====
224      * It is unsafe to assume that an address for which this function returns
225      * false is an externally-owned account (EOA) and not a contract.
226      *
227      * Among others, `isContract` will return false for the following
228      * types of addresses:
229      *
230      *  - an externally-owned account
231      *  - a contract in construction
232      *  - an address where a contract will be created
233      *  - an address where a contract lived, but was destroyed
234      * ====
235      */
236     function isContract(address account) internal view returns (bool) {
237         // This method relies on extcodesize, which returns 0 for contracts in
238         // construction, since the code is only stored at the end of the
239         // constructor execution.
240 
241         uint256 size;
242         assembly {
243             size := extcodesize(account)
244         }
245         return size > 0;
246     }
247 
248     /**
249      * @dev Replacement for Solidity's `transfer`: sends `amount` wei to
250      * `recipient`, forwarding all available gas and reverting on errors.
251      *
252      * https://eips.ethereum.org/EIPS/eip-1884[EIP1884] increases the gas cost
253      * of certain opcodes, possibly making contracts go over the 2300 gas limit
254      * imposed by `transfer`, making them unable to receive funds via
255      * `transfer`. {sendValue} removes this limitation.
256      *
257      * https://diligence.consensys.net/posts/2019/09/stop-using-soliditys-transfer-now/[Learn more].
258      *
259      * IMPORTANT: because control is transferred to `recipient`, care must be
260      * taken to not create reentrancy vulnerabilities. Consider using
261      * {ReentrancyGuard} or the
262      * https://solidity.readthedocs.io/en/v0.5.11/security-considerations.html#use-the-checks-effects-interactions-pattern[checks-effects-interactions pattern].
263      */
264     function sendValue(address payable recipient, uint256 amount) internal {
265         require(address(this).balance >= amount, "Address: insufficient balance");
266 
267         (bool success, ) = recipient.call{value: amount}("");
268         require(success, "Address: unable to send value, recipient may have reverted");
269     }
270 
271     /**
272      * @dev Performs a Solidity function call using a low level `call`. A
273      * plain `call` is an unsafe replacement for a function call: use this
274      * function instead.
275      *
276      * If `target` reverts with a revert reason, it is bubbled up by this
277      * function (like regular Solidity function calls).
278      *
279      * Returns the raw returned data. To convert to the expected return value,
280      * use https://solidity.readthedocs.io/en/latest/units-and-global-variables.html?highlight=abi.decode#abi-encoding-and-decoding-functions[`abi.decode`].
281      *
282      * Requirements:
283      *
284      * - `target` must be a contract.
285      * - calling `target` with `data` must not revert.
286      *
287      * _Available since v3.1._
288      */
289     function functionCall(address target, bytes memory data) internal returns (bytes memory) {
290         return functionCall(target, data, "Address: low-level call failed");
291     }
292 
293     /**
294      * @dev Same as {xref-Address-functionCall-address-bytes-}[`functionCall`], but with
295      * `errorMessage` as a fallback revert reason when `target` reverts.
296      *
297      * _Available since v3.1._
298      */
299     function functionCall(
300         address target,
301         bytes memory data,
302         string memory errorMessage
303     ) internal returns (bytes memory) {
304         return functionCallWithValue(target, data, 0, errorMessage);
305     }
306 
307     /**
308      * @dev Same as {xref-Address-functionCall-address-bytes-}[`functionCall`],
309      * but also transferring `value` wei to `target`.
310      *
311      * Requirements:
312      *
313      * - the calling contract must have an ETH balance of at least `value`.
314      * - the called Solidity function must be `payable`.
315      *
316      * _Available since v3.1._
317      */
318     function functionCallWithValue(
319         address target,
320         bytes memory data,
321         uint256 value
322     ) internal returns (bytes memory) {
323         return functionCallWithValue(target, data, value, "Address: low-level call with value failed");
324     }
325 
326     /**
327      * @dev Same as {xref-Address-functionCallWithValue-address-bytes-uint256-}[`functionCallWithValue`], but
328      * with `errorMessage` as a fallback revert reason when `target` reverts.
329      *
330      * _Available since v3.1._
331      */
332     function functionCallWithValue(
333         address target,
334         bytes memory data,
335         uint256 value,
336         string memory errorMessage
337     ) internal returns (bytes memory) {
338         require(address(this).balance >= value, "Address: insufficient balance for call");
339         require(isContract(target), "Address: call to non-contract");
340 
341         (bool success, bytes memory returndata) = target.call{value: value}(data);
342         return verifyCallResult(success, returndata, errorMessage);
343     }
344 
345     /**
346      * @dev Same as {xref-Address-functionCall-address-bytes-}[`functionCall`],
347      * but performing a static call.
348      *
349      * _Available since v3.3._
350      */
351     function functionStaticCall(address target, bytes memory data) internal view returns (bytes memory) {
352         return functionStaticCall(target, data, "Address: low-level static call failed");
353     }
354 
355     /**
356      * @dev Same as {xref-Address-functionCall-address-bytes-string-}[`functionCall`],
357      * but performing a static call.
358      *
359      * _Available since v3.3._
360      */
361     function functionStaticCall(
362         address target,
363         bytes memory data,
364         string memory errorMessage
365     ) internal view returns (bytes memory) {
366         require(isContract(target), "Address: static call to non-contract");
367 
368         (bool success, bytes memory returndata) = target.staticcall(data);
369         return verifyCallResult(success, returndata, errorMessage);
370     }
371 
372     /**
373      * @dev Same as {xref-Address-functionCall-address-bytes-}[`functionCall`],
374      * but performing a delegate call.
375      *
376      * _Available since v3.4._
377      */
378     function functionDelegateCall(address target, bytes memory data) internal returns (bytes memory) {
379         return functionDelegateCall(target, data, "Address: low-level delegate call failed");
380     }
381 
382     /**
383      * @dev Same as {xref-Address-functionCall-address-bytes-string-}[`functionCall`],
384      * but performing a delegate call.
385      *
386      * _Available since v3.4._
387      */
388     function functionDelegateCall(
389         address target,
390         bytes memory data,
391         string memory errorMessage
392     ) internal returns (bytes memory) {
393         require(isContract(target), "Address: delegate call to non-contract");
394 
395         (bool success, bytes memory returndata) = target.delegatecall(data);
396         return verifyCallResult(success, returndata, errorMessage);
397     }
398 
399     /**
400      * @dev Tool to verifies that a low level call was successful, and revert if it wasn't, either by bubbling the
401      * revert reason using the provided one.
402      *
403      * _Available since v4.3._
404      */
405     function verifyCallResult(
406         bool success,
407         bytes memory returndata,
408         string memory errorMessage
409     ) internal pure returns (bytes memory) {
410         if (success) {
411             return returndata;
412         } else {
413             // Look for revert reason and bubble it up if present
414             if (returndata.length > 0) {
415                 // The easiest way to bubble the revert reason is using memory via assembly
416 
417                 assembly {
418                     let returndata_size := mload(returndata)
419                     revert(add(32, returndata), returndata_size)
420                 }
421             } else {
422                 revert(errorMessage);
423             }
424         }
425     }
426 }
427 
428  
429 
430 /**
431  * @dev Provides information about the current execution context, including the
432  * sender of the transaction and its data. While these are generally available
433  * via msg.sender and msg.data, they should not be accessed in such a direct
434  * manner, since when dealing with meta-transactions the account sending and
435  * paying for execution may not be the actual sender (as far as an application
436  * is concerned).
437  *
438  * This contract is only required for intermediate, library-like contracts.
439  */
440 abstract contract Context {
441     function _msgSender() internal view virtual returns (address) {
442         return msg.sender;
443     }
444 
445     function _msgData() internal view virtual returns (bytes calldata) {
446         return msg.data;
447     }
448 }
449 
450   
451 
452 /**
453  * @dev String operations.
454  */
455 library Strings {
456     bytes16 private constant _HEX_SYMBOLS = "0123456789abcdef";
457 
458     /**
459      * @dev Converts a `uint256` to its ASCII `string` decimal representation.
460      */
461     function toString(uint256 value) internal pure returns (string memory) {
462         // Inspired by OraclizeAPI's implementation - MIT licence
463         // https://github.com/oraclize/ethereum-api/blob/b42146b063c7d6ee1358846c198246239e9360e8/oraclizeAPI_0.4.25.sol
464 
465         if (value == 0) {
466             return "0";
467         }
468         uint256 temp = value;
469         uint256 digits;
470         while (temp != 0) {
471             digits++;
472             temp /= 10;
473         }
474         bytes memory buffer = new bytes(digits);
475         while (value != 0) {
476             digits -= 1;
477             buffer[digits] = bytes1(uint8(48 + uint256(value % 10)));
478             value /= 10;
479         }
480         return string(buffer);
481     }
482 
483     /**
484      * @dev Converts a `uint256` to its ASCII `string` hexadecimal representation.
485      */
486     function toHexString(uint256 value) internal pure returns (string memory) {
487         if (value == 0) {
488             return "0x00";
489         }
490         uint256 temp = value;
491         uint256 length = 0;
492         while (temp != 0) {
493             length++;
494             temp >>= 8;
495         }
496         return toHexString(value, length);
497     }
498 
499     /**
500      * @dev Converts a `uint256` to its ASCII `string` hexadecimal representation with fixed length.
501      */
502     function toHexString(uint256 value, uint256 length) internal pure returns (string memory) {
503         bytes memory buffer = new bytes(2 * length + 2);
504         buffer[0] = "0";
505         buffer[1] = "x";
506         for (uint256 i = 2 * length + 1; i > 1; --i) {
507             buffer[i] = _HEX_SYMBOLS[value & 0xf];
508             value >>= 4;
509         }
510         require(value == 0, "Strings: hex length insufficient");
511         return string(buffer);
512     }
513 }
514 
515  
516 
517 /**
518  * @dev Implementation of the {IERC165} interface.
519  *
520  * Contracts that want to implement ERC165 should inherit from this contract and override {supportsInterface} to check
521  * for the additional interface id that will be supported. For example:
522  *
523  * ```solidity
524  * function supportsInterface(bytes4 interfaceId) public view virtual override returns (bool) {
525  *     return interfaceId == type(MyInterface).interfaceId || super.supportsInterface(interfaceId);
526  * }
527  * ```
528  *
529  * Alternatively, {ERC165Storage} provides an easier to use but more expensive implementation.
530  */
531 abstract contract ERC165 is IERC165 {
532     /**
533      * @dev See {IERC165-supportsInterface}.
534      */
535     function supportsInterface(bytes4 interfaceId) public view virtual override returns (bool) {
536         return interfaceId == type(IERC165).interfaceId;
537     }
538 }
539 
540  
541 
542 /**
543  * @dev Implementation of https://eips.ethereum.org/EIPS/eip-721[ERC721] Non-Fungible Token Standard, including
544  * the Metadata extension, but not including the Enumerable extension, which is available separately as
545  * {ERC721Enumerable}.
546  */
547 contract ERC721 is Context, ERC165, IERC721, IERC721Metadata {
548     using Address for address;
549     using Strings for uint256;
550 
551     // Token name
552     string private _name;
553 
554     // Token symbol
555     string private _symbol;
556 
557     // Mapping from token ID to owner address
558     mapping(uint256 => address) private _owners;
559 
560     // Mapping owner address to token count
561     mapping(address => uint256) private _balances;
562 
563     // Mapping from token ID to approved address
564     mapping(uint256 => address) private _tokenApprovals;
565 
566     // Mapping from owner to operator approvals
567     mapping(address => mapping(address => bool)) private _operatorApprovals;
568 
569     /**
570      * @dev Initializes the contract by setting a `name` and a `symbol` to the token collection.
571      */
572     constructor(string memory name_, string memory symbol_) {
573         _name = name_;
574         _symbol = symbol_;
575     }
576 
577     /**
578      * @dev See {IERC165-supportsInterface}.
579      */
580     function supportsInterface(bytes4 interfaceId) public view virtual override(ERC165, IERC165) returns (bool) {
581         return
582             interfaceId == type(IERC721).interfaceId ||
583             interfaceId == type(IERC721Metadata).interfaceId ||
584             super.supportsInterface(interfaceId);
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
625         return bytes(baseURI).length > 0 ? string(abi.encodePacked(baseURI, tokenId.toString())) : "";
626     }
627 
628     /**
629      * @dev Base URI for computing {tokenURI}. If set, the resulting URI for each
630      * token will be the concatenation of the `baseURI` and the `tokenId`. Empty
631      * by default, can be overriden in child contracts.
632      */
633     function _baseURI() internal view virtual returns (string memory) {
634         return "";
635     }
636 
637     /**
638      * @dev See {IERC721-approve}.
639      */
640     function approve(address to, uint256 tokenId) public virtual override {
641         address owner = ERC721.ownerOf(tokenId);
642         require(to != owner, "ERC721: approval to current owner");
643 
644         require(
645             _msgSender() == owner || isApprovedForAll(owner, _msgSender()),
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
681     function transferFrom(
682         address from,
683         address to,
684         uint256 tokenId
685     ) public virtual override {
686         //solhint-disable-next-line max-line-length
687         require(_isApprovedOrOwner(_msgSender(), tokenId), "ERC721: transfer caller is not owner nor approved");
688 
689         _transfer(from, to, tokenId);
690     }
691 
692     /**
693      * @dev See {IERC721-safeTransferFrom}.
694      */
695     function safeTransferFrom(
696         address from,
697         address to,
698         uint256 tokenId
699     ) public virtual override {
700         safeTransferFrom(from, to, tokenId, "");
701     }
702 
703     /**
704      * @dev See {IERC721-safeTransferFrom}.
705      */
706     function safeTransferFrom(
707         address from,
708         address to,
709         uint256 tokenId,
710         bytes memory _data
711     ) public virtual override {
712         require(_isApprovedOrOwner(_msgSender(), tokenId), "ERC721: transfer caller is not owner nor approved");
713         _safeTransfer(from, to, tokenId, _data);
714     }
715 
716     /**
717      * @dev Safely transfers `tokenId` token from `from` to `to`, checking first that contract recipients
718      * are aware of the ERC721 protocol to prevent tokens from being forever locked.
719      *
720      * `_data` is additional data, it has no specified format and it is sent in call to `to`.
721      *
722      * This internal function is equivalent to {safeTransferFrom}, and can be used to e.g.
723      * implement alternative mechanisms to perform token transfer, such as signature-based.
724      *
725      * Requirements:
726      *
727      * - `from` cannot be the zero address.
728      * - `to` cannot be the zero address.
729      * - `tokenId` token must exist and be owned by `from`.
730      * - If `to` refers to a smart contract, it must implement {IERC721Receiver-onERC721Received}, which is called upon a safe transfer.
731      *
732      * Emits a {Transfer} event.
733      */
734     function _safeTransfer(
735         address from,
736         address to,
737         uint256 tokenId,
738         bytes memory _data
739     ) internal virtual {
740         _transfer(from, to, tokenId);
741         require(_checkOnERC721Received(from, to, tokenId, _data), "ERC721: transfer to non ERC721Receiver implementer");
742     }
743 
744     /**
745      * @dev Returns whether `tokenId` exists.
746      *
747      * Tokens can be managed by their owner or approved accounts via {approve} or {setApprovalForAll}.
748      *
749      * Tokens start existing when they are minted (`_mint`),
750      * and stop existing when they are burned (`_burn`).
751      */
752     function _exists(uint256 tokenId) internal view virtual returns (bool) {
753         return _owners[tokenId] != address(0);
754     }
755 
756     /**
757      * @dev Returns whether `spender` is allowed to manage `tokenId`.
758      *
759      * Requirements:
760      *
761      * - `tokenId` must exist.
762      */
763     function _isApprovedOrOwner(address spender, uint256 tokenId) internal view virtual returns (bool) {
764         require(_exists(tokenId), "ERC721: operator query for nonexistent token");
765         address owner = ERC721.ownerOf(tokenId);
766         return (spender == owner || getApproved(tokenId) == spender || isApprovedForAll(owner, spender));
767     }
768 
769     /**
770      * @dev Safely mints `tokenId` and transfers it to `to`.
771      *
772      * Requirements:
773      *
774      * - `tokenId` must not exist.
775      * - If `to` refers to a smart contract, it must implement {IERC721Receiver-onERC721Received}, which is called upon a safe transfer.
776      *
777      * Emits a {Transfer} event.
778      */
779     function _safeMint(address to, uint256 tokenId) internal virtual {
780         _safeMint(to, tokenId, "");
781     }
782 
783     /**
784      * @dev Same as {xref-ERC721-_safeMint-address-uint256-}[`_safeMint`], with an additional `data` parameter which is
785      * forwarded in {IERC721Receiver-onERC721Received} to contract recipients.
786      */
787     function _safeMint(
788         address to,
789         uint256 tokenId,
790         bytes memory _data
791     ) internal virtual {
792         _mint(to, tokenId);
793         require(
794             _checkOnERC721Received(address(0), to, tokenId, _data),
795             "ERC721: transfer to non ERC721Receiver implementer"
796         );
797     }
798 
799     /**
800      * @dev Mints `tokenId` and transfers it to `to`.
801      *
802      * WARNING: Usage of this method is discouraged, use {_safeMint} whenever possible
803      *
804      * Requirements:
805      *
806      * - `tokenId` must not exist.
807      * - `to` cannot be the zero address.
808      *
809      * Emits a {Transfer} event.
810      */
811     function _mint(address to, uint256 tokenId) internal virtual {
812         require(to != address(0), "ERC721: mint to the zero address");
813         require(!_exists(tokenId), "ERC721: token already minted");
814 
815         _beforeTokenTransfer(address(0), to, tokenId);
816 
817         _balances[to] += 1;
818         _owners[tokenId] = to;
819 
820         emit Transfer(address(0), to, tokenId);
821     }
822 
823     /**
824      * @dev Destroys `tokenId`.
825      * The approval is cleared when the token is burned.
826      *
827      * Requirements:
828      *
829      * - `tokenId` must exist.
830      *
831      * Emits a {Transfer} event.
832      */
833     function _burn(uint256 tokenId) internal virtual {
834         address owner = ERC721.ownerOf(tokenId);
835 
836         _beforeTokenTransfer(owner, address(0), tokenId);
837 
838         // Clear approvals
839         _approve(address(0), tokenId);
840 
841         _balances[owner] -= 1;
842         delete _owners[tokenId];
843 
844         emit Transfer(owner, address(0), tokenId);
845     }
846 
847     /**
848      * @dev Transfers `tokenId` from `from` to `to`.
849      *  As opposed to {transferFrom}, this imposes no restrictions on msg.sender.
850      *
851      * Requirements:
852      *
853      * - `to` cannot be the zero address.
854      * - `tokenId` token must be owned by `from`.
855      *
856      * Emits a {Transfer} event.
857      */
858     function _transfer(
859         address from,
860         address to,
861         uint256 tokenId
862     ) internal virtual {
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
898     function _checkOnERC721Received(
899         address from,
900         address to,
901         uint256 tokenId,
902         bytes memory _data
903     ) private returns (bool) {
904         if (to.isContract()) {
905             try IERC721Receiver(to).onERC721Received(_msgSender(), from, tokenId, _data) returns (bytes4 retval) {
906                 return retval == IERC721Receiver.onERC721Received.selector;
907             } catch (bytes memory reason) {
908                 if (reason.length == 0) {
909                     revert("ERC721: transfer to non ERC721Receiver implementer");
910                 } else {
911                     assembly {
912                         revert(add(32, reason), mload(reason))
913                     }
914                 }
915             }
916         } else {
917             return true;
918         }
919     }
920 
921     /**
922      * @dev Hook that is called before any token transfer. This includes minting
923      * and burning.
924      *
925      * Calling conditions:
926      *
927      * - When `from` and `to` are both non-zero, ``from``'s `tokenId` will be
928      * transferred to `to`.
929      * - When `from` is zero, `tokenId` will be minted for `to`.
930      * - When `to` is zero, ``from``'s `tokenId` will be burned.
931      * - `from` and `to` are never both zero.
932      *
933      * To learn more about hooks, head to xref:ROOT:extending-contracts.adoc#using-hooks[Using Hooks].
934      */
935     function _beforeTokenTransfer(
936         address from,
937         address to,
938         uint256 tokenId
939     ) internal virtual {}
940 }
941  
942 
943 
944 /**
945  * @dev ERC721 token with storage based token URI management.
946  */
947 abstract contract ERC721URIStorage is ERC721 {
948     using Strings for uint256;
949 
950     // Optional mapping for token URIs
951     mapping(uint256 => string) private _tokenURIs;
952 
953     /**
954      * @dev See {IERC721Metadata-tokenURI}.
955      */
956     function tokenURI(uint256 tokenId) public view virtual override returns (string memory) {
957         require(_exists(tokenId), "ERC721URIStorage: URI query for nonexistent token");
958 
959         string memory _tokenURI = _tokenURIs[tokenId];
960         string memory base = _baseURI();
961 
962         // If there is no base URI, return the token URI.
963         if (bytes(base).length == 0) {
964             return _tokenURI;
965         }
966         // If both are set, concatenate the baseURI and tokenURI (via abi.encodePacked).
967         if (bytes(_tokenURI).length > 0) {
968             return string(abi.encodePacked(base, _tokenURI));
969         }
970 
971         return super.tokenURI(tokenId);
972     }
973 
974     /**
975      * @dev Sets `_tokenURI` as the tokenURI of `tokenId`.
976      *
977      * Requirements:
978      *
979      * - `tokenId` must exist.
980      */
981     function _setTokenURI(uint256 tokenId, string memory _tokenURI) internal virtual {
982         require(_exists(tokenId), "ERC721URIStorage: URI set of nonexistent token");
983         _tokenURIs[tokenId] = _tokenURI;
984     }
985 
986     /**
987      * @dev Destroys `tokenId`.
988      * The approval is cleared when the token is burned.
989      *
990      * Requirements:
991      *
992      * - `tokenId` must exist.
993      *
994      * Emits a {Transfer} event.
995      */
996     function _burn(uint256 tokenId) internal virtual override {
997         super._burn(tokenId);
998 
999         if (bytes(_tokenURIs[tokenId]).length != 0) {
1000             delete _tokenURIs[tokenId];
1001         }
1002     }
1003 }
1004 
1005  
1006 
1007 
1008 /**
1009  * @title ERC-721 Non-Fungible Token Standard, optional enumeration extension
1010  * @dev See https://eips.ethereum.org/EIPS/eip-721
1011  */
1012 interface IERC721Enumerable is IERC721 {
1013     /**
1014      * @dev Returns the total amount of tokens stored by the contract.
1015      */
1016     function totalSupply() external view returns (uint256);
1017 
1018     /**
1019      * @dev Returns a token ID owned by `owner` at a given `index` of its token list.
1020      * Use along with {balanceOf} to enumerate all of ``owner``'s tokens.
1021      */
1022     function tokenOfOwnerByIndex(address owner, uint256 index) external view returns (uint256 tokenId);
1023 
1024     /**
1025      * @dev Returns a token ID at a given `index` of all the tokens stored by the contract.
1026      * Use along with {totalSupply} to enumerate all tokens.
1027      */
1028     function tokenByIndex(uint256 index) external view returns (uint256);
1029 }
1030 
1031  
1032 
1033 
1034 /**
1035  * @dev This implements an optional extension of {ERC721} defined in the EIP that adds
1036  * enumerability of all the token ids in the contract as well as all token ids owned by each
1037  * account.
1038  */
1039 abstract contract ERC721Enumerable is ERC721, IERC721Enumerable {
1040     // Mapping from owner to list of owned token IDs
1041     mapping(address => mapping(uint256 => uint256)) private _ownedTokens;
1042 
1043     // Mapping from token ID to index of the owner tokens list
1044     mapping(uint256 => uint256) private _ownedTokensIndex;
1045 
1046     // Array with all token ids, used for enumeration
1047     uint256[] private _allTokens;
1048 
1049     // Mapping from token id to position in the allTokens array
1050     mapping(uint256 => uint256) private _allTokensIndex;
1051 
1052     /**
1053      * @dev See {IERC165-supportsInterface}.
1054      */
1055     function supportsInterface(bytes4 interfaceId) public view virtual override(IERC165, ERC721) returns (bool) {
1056         return interfaceId == type(IERC721Enumerable).interfaceId || super.supportsInterface(interfaceId);
1057     }
1058 
1059     /**
1060      * @dev See {IERC721Enumerable-tokenOfOwnerByIndex}.
1061      */
1062     function tokenOfOwnerByIndex(address owner, uint256 index) public view virtual override returns (uint256) {
1063         require(index < ERC721.balanceOf(owner), "ERC721Enumerable: owner index out of bounds");
1064         return _ownedTokens[owner][index];
1065     }
1066 
1067     /**
1068      * @dev See {IERC721Enumerable-totalSupply}.
1069      */
1070     function totalSupply() public view virtual override returns (uint256) {
1071         return _allTokens.length;
1072     }
1073 
1074     /**
1075      * @dev See {IERC721Enumerable-tokenByIndex}.
1076      */
1077     function tokenByIndex(uint256 index) public view virtual override returns (uint256) {
1078         require(index < ERC721Enumerable.totalSupply(), "ERC721Enumerable: global index out of bounds");
1079         return _allTokens[index];
1080     }
1081 
1082     /**
1083      * @dev Hook that is called before any token transfer. This includes minting
1084      * and burning.
1085      *
1086      * Calling conditions:
1087      *
1088      * - When `from` and `to` are both non-zero, ``from``'s `tokenId` will be
1089      * transferred to `to`.
1090      * - When `from` is zero, `tokenId` will be minted for `to`.
1091      * - When `to` is zero, ``from``'s `tokenId` will be burned.
1092      * - `from` cannot be the zero address.
1093      * - `to` cannot be the zero address.
1094      *
1095      * To learn more about hooks, head to xref:ROOT:extending-contracts.adoc#using-hooks[Using Hooks].
1096      */
1097     function _beforeTokenTransfer(
1098         address from,
1099         address to,
1100         uint256 tokenId
1101     ) internal virtual override {
1102         super._beforeTokenTransfer(from, to, tokenId);
1103 
1104         if (from == address(0)) {
1105             _addTokenToAllTokensEnumeration(tokenId);
1106         } else if (from != to) {
1107             _removeTokenFromOwnerEnumeration(from, tokenId);
1108         }
1109         if (to == address(0)) {
1110             _removeTokenFromAllTokensEnumeration(tokenId);
1111         } else if (to != from) {
1112             _addTokenToOwnerEnumeration(to, tokenId);
1113         }
1114     }
1115 
1116     /**
1117      * @dev Private function to add a token to this extension's ownership-tracking data structures.
1118      * @param to address representing the new owner of the given token ID
1119      * @param tokenId uint256 ID of the token to be added to the tokens list of the given address
1120      */
1121     function _addTokenToOwnerEnumeration(address to, uint256 tokenId) private {
1122         uint256 length = ERC721.balanceOf(to);
1123         _ownedTokens[to][length] = tokenId;
1124         _ownedTokensIndex[tokenId] = length;
1125     }
1126 
1127     /**
1128      * @dev Private function to add a token to this extension's token tracking data structures.
1129      * @param tokenId uint256 ID of the token to be added to the tokens list
1130      */
1131     function _addTokenToAllTokensEnumeration(uint256 tokenId) private {
1132         _allTokensIndex[tokenId] = _allTokens.length;
1133         _allTokens.push(tokenId);
1134     }
1135 
1136     /**
1137      * @dev Private function to remove a token from this extension's ownership-tracking data structures. Note that
1138      * while the token is not assigned a new owner, the `_ownedTokensIndex` mapping is _not_ updated: this allows for
1139      * gas optimizations e.g. when performing a transfer operation (avoiding double writes).
1140      * This has O(1) time complexity, but alters the order of the _ownedTokens array.
1141      * @param from address representing the previous owner of the given token ID
1142      * @param tokenId uint256 ID of the token to be removed from the tokens list of the given address
1143      */
1144     function _removeTokenFromOwnerEnumeration(address from, uint256 tokenId) private {
1145         // To prevent a gap in from's tokens array, we store the last token in the index of the token to delete, and
1146         // then delete the last slot (swap and pop).
1147 
1148         uint256 lastTokenIndex = ERC721.balanceOf(from) - 1;
1149         uint256 tokenIndex = _ownedTokensIndex[tokenId];
1150 
1151         // When the token to delete is the last token, the swap operation is unnecessary
1152         if (tokenIndex != lastTokenIndex) {
1153             uint256 lastTokenId = _ownedTokens[from][lastTokenIndex];
1154 
1155             _ownedTokens[from][tokenIndex] = lastTokenId; // Move the last token to the slot of the to-delete token
1156             _ownedTokensIndex[lastTokenId] = tokenIndex; // Update the moved token's index
1157         }
1158 
1159         // This also deletes the contents at the last position of the array
1160         delete _ownedTokensIndex[tokenId];
1161         delete _ownedTokens[from][lastTokenIndex];
1162     }
1163 
1164     /**
1165      * @dev Private function to remove a token from this extension's token tracking data structures.
1166      * This has O(1) time complexity, but alters the order of the _allTokens array.
1167      * @param tokenId uint256 ID of the token to be removed from the tokens list
1168      */
1169     function _removeTokenFromAllTokensEnumeration(uint256 tokenId) private {
1170         // To prevent a gap in the tokens array, we store the last token in the index of the token to delete, and
1171         // then delete the last slot (swap and pop).
1172 
1173         uint256 lastTokenIndex = _allTokens.length - 1;
1174         uint256 tokenIndex = _allTokensIndex[tokenId];
1175 
1176         // When the token to delete is the last token, the swap operation is unnecessary. However, since this occurs so
1177         // rarely (when the last minted token is burnt) that we still do the swap here to avoid the gas cost of adding
1178         // an 'if' statement (like in _removeTokenFromOwnerEnumeration)
1179         uint256 lastTokenId = _allTokens[lastTokenIndex];
1180 
1181         _allTokens[tokenIndex] = lastTokenId; // Move the last token to the slot of the to-delete token
1182         _allTokensIndex[lastTokenId] = tokenIndex; // Update the moved token's index
1183 
1184         // This also deletes the contents at the last position of the array
1185         delete _allTokensIndex[tokenId];
1186         _allTokens.pop();
1187     }
1188 }
1189 
1190  
1191 
1192 /**
1193  * @title Counters
1194  * @author Matt Condon (@shrugs)
1195  * @dev Provides counters that can only be incremented, decremented or reset. This can be used e.g. to track the number
1196  * of elements in a mapping, issuing ERC721 ids, or counting request ids.
1197  *
1198  * Include with `using Counters for Counters.Counter;`
1199  */
1200 library Counters {
1201     struct Counter {
1202         // This variable should never be directly accessed by users of the library: interactions must be restricted to
1203         // the library's function. As of Solidity v0.5.2, this cannot be enforced, though there is a proposal to add
1204         // this feature: see https://github.com/ethereum/solidity/issues/4637
1205         uint256 _value; // default: 0
1206     }
1207 
1208     function current(Counter storage counter) internal view returns (uint256) {
1209         return counter._value;
1210     }
1211 
1212     function increment(Counter storage counter) internal {
1213         unchecked {
1214             counter._value += 1;
1215         }
1216     }
1217 
1218     function decrement(Counter storage counter) internal {
1219         uint256 value = counter._value;
1220         require(value > 0, "Counter: decrement overflow");
1221         unchecked {
1222             counter._value = value - 1;
1223         }
1224     }
1225 
1226     function reset(Counter storage counter) internal {
1227         counter._value = 0;
1228     }
1229 }
1230 
1231  
1232 /**
1233  * @dev External interface of AccessControl declared to support ERC165 detection.
1234  */
1235 interface IAccessControl {
1236     /**
1237      * @dev Emitted when `newAdminRole` is set as ``role``'s admin role, replacing `previousAdminRole`
1238      *
1239      * `DEFAULT_ADMIN_ROLE` is the starting admin for all roles, despite
1240      * {RoleAdminChanged} not being emitted signaling this.
1241      *
1242      * _Available since v3.1._
1243      */
1244     event RoleAdminChanged(bytes32 indexed role, bytes32 indexed previousAdminRole, bytes32 indexed newAdminRole);
1245 
1246     /**
1247      * @dev Emitted when `account` is granted `role`.
1248      *
1249      * `sender` is the account that originated the contract call, an admin role
1250      * bearer except when using {AccessControl-_setupRole}.
1251      */
1252     event RoleGranted(bytes32 indexed role, address indexed account, address indexed sender);
1253 
1254     /**
1255      * @dev Emitted when `account` is revoked `role`.
1256      *
1257      * `sender` is the account that originated the contract call:
1258      *   - if using `revokeRole`, it is the admin role bearer
1259      *   - if using `renounceRole`, it is the role bearer (i.e. `account`)
1260      */
1261     event RoleRevoked(bytes32 indexed role, address indexed account, address indexed sender);
1262 
1263     /**
1264      * @dev Returns `true` if `account` has been granted `role`.
1265      */
1266     function hasRole(bytes32 role, address account) external view returns (bool);
1267 
1268     /**
1269      * @dev Returns the admin role that controls `role`. See {grantRole} and
1270      * {revokeRole}.
1271      *
1272      * To change a role's admin, use {AccessControl-_setRoleAdmin}.
1273      */
1274     function getRoleAdmin(bytes32 role) external view returns (bytes32);
1275 
1276     /**
1277      * @dev Grants `role` to `account`.
1278      *
1279      * If `account` had not been already granted `role`, emits a {RoleGranted}
1280      * event.
1281      *
1282      * Requirements:
1283      *
1284      * - the caller must have ``role``'s admin role.
1285      */
1286     function grantRole(bytes32 role, address account) external;
1287 
1288     /**
1289      * @dev Revokes `role` from `account`.
1290      *
1291      * If `account` had been granted `role`, emits a {RoleRevoked} event.
1292      *
1293      * Requirements:
1294      *
1295      * - the caller must have ``role``'s admin role.
1296      */
1297     function revokeRole(bytes32 role, address account) external;
1298 
1299     /**
1300      * @dev Revokes `role` from the calling account.
1301      *
1302      * Roles are often managed via {grantRole} and {revokeRole}: this function's
1303      * purpose is to provide a mechanism for accounts to lose their privileges
1304      * if they are compromised (such as when a trusted device is misplaced).
1305      *
1306      * If the calling account had been granted `role`, emits a {RoleRevoked}
1307      * event.
1308      *
1309      * Requirements:
1310      *
1311      * - the caller must be `account`.
1312      */
1313     function renounceRole(bytes32 role, address account) external;
1314 }
1315 
1316  
1317 
1318 
1319 /**
1320  * @dev Contract module that allows children to implement role-based access
1321  * control mechanisms. This is a lightweight version that doesn't allow enumerating role
1322  * members except through off-chain means by accessing the contract event logs. Some
1323  * applications may benefit from on-chain enumerability, for those cases see
1324  * {AccessControlEnumerable}.
1325  *
1326  * Roles are referred to by their `bytes32` identifier. These should be exposed
1327  * in the external API and be unique. The best way to achieve this is by
1328  * using `public constant` hash digests:
1329  *
1330  * ```
1331  * bytes32 public constant MY_ROLE = keccak256("MY_ROLE");
1332  * ```
1333  *
1334  * Roles can be used to represent a set of permissions. To restrict access to a
1335  * function call, use {hasRole}:
1336  *
1337  * ```
1338  * function foo() public {
1339  *     require(hasRole(MY_ROLE, msg.sender));
1340  *     ...
1341  * }
1342  * ```
1343  *
1344  * Roles can be granted and revoked dynamically via the {grantRole} and
1345  * {revokeRole} functions. Each role has an associated admin role, and only
1346  * accounts that have a role's admin role can call {grantRole} and {revokeRole}.
1347  *
1348  * By default, the admin role for all roles is `DEFAULT_ADMIN_ROLE`, which means
1349  * that only accounts with this role will be able to grant or revoke other
1350  * roles. More complex role relationships can be created by using
1351  * {_setRoleAdmin}.
1352  *
1353  * WARNING: The `DEFAULT_ADMIN_ROLE` is also its own admin: it has permission to
1354  * grant and revoke this role. Extra precautions should be taken to secure
1355  * accounts that have been granted it.
1356  */
1357 abstract contract AccessControl is Context, IAccessControl, ERC165 {
1358     struct RoleData {
1359         mapping(address => bool) members;
1360         bytes32 adminRole;
1361     }
1362 
1363     mapping(bytes32 => RoleData) private _roles;
1364 
1365     bytes32 public constant DEFAULT_ADMIN_ROLE = 0x00;
1366 
1367     /**
1368      * @dev Modifier that checks that an account has a specific role. Reverts
1369      * with a standardized message including the required role.
1370      *
1371      * The format of the revert reason is given by the following regular expression:
1372      *
1373      *  /^AccessControl: account (0x[0-9a-f]{40}) is missing role (0x[0-9a-f]{64})$/
1374      *
1375      * _Available since v4.1._
1376      */
1377     modifier onlyRole(bytes32 role) {
1378         _checkRole(role, _msgSender());
1379         _;
1380     }
1381 
1382     /**
1383      * @dev See {IERC165-supportsInterface}.
1384      */
1385     function supportsInterface(bytes4 interfaceId) public view virtual override returns (bool) {
1386         return interfaceId == type(IAccessControl).interfaceId || super.supportsInterface(interfaceId);
1387     }
1388 
1389     /**
1390      * @dev Returns `true` if `account` has been granted `role`.
1391      */
1392     function hasRole(bytes32 role, address account) public view override returns (bool) {
1393         return _roles[role].members[account];
1394     }
1395 
1396     /**
1397      * @dev Revert with a standard message if `account` is missing `role`.
1398      *
1399      * The format of the revert reason is given by the following regular expression:
1400      *
1401      *  /^AccessControl: account (0x[0-9a-f]{40}) is missing role (0x[0-9a-f]{64})$/
1402      */
1403     function _checkRole(bytes32 role, address account) internal view {
1404         if (!hasRole(role, account)) {
1405             revert(
1406                 string(
1407                     abi.encodePacked(
1408                         "AccessControl: account ",
1409                         Strings.toHexString(uint160(account), 20),
1410                         " is missing role ",
1411                         Strings.toHexString(uint256(role), 32)
1412                     )
1413                 )
1414             );
1415         }
1416     }
1417 
1418     /**
1419      * @dev Returns the admin role that controls `role`. See {grantRole} and
1420      * {revokeRole}.
1421      *
1422      * To change a role's admin, use {_setRoleAdmin}.
1423      */
1424     function getRoleAdmin(bytes32 role) public view override returns (bytes32) {
1425         return _roles[role].adminRole;
1426     }
1427 
1428     /**
1429      * @dev Grants `role` to `account`.
1430      *
1431      * If `account` had not been already granted `role`, emits a {RoleGranted}
1432      * event.
1433      *
1434      * Requirements:
1435      *
1436      * - the caller must have ``role``'s admin role.
1437      */
1438     function grantRole(bytes32 role, address account) public virtual override onlyRole(getRoleAdmin(role)) {
1439         _grantRole(role, account);
1440     }
1441 
1442     /**
1443      * @dev Revokes `role` from `account`.
1444      *
1445      * If `account` had been granted `role`, emits a {RoleRevoked} event.
1446      *
1447      * Requirements:
1448      *
1449      * - the caller must have ``role``'s admin role.
1450      */
1451     function revokeRole(bytes32 role, address account) public virtual override onlyRole(getRoleAdmin(role)) {
1452         _revokeRole(role, account);
1453     }
1454 
1455     /**
1456      * @dev Revokes `role` from the calling account.
1457      *
1458      * Roles are often managed via {grantRole} and {revokeRole}: this function's
1459      * purpose is to provide a mechanism for accounts to lose their privileges
1460      * if they are compromised (such as when a trusted device is misplaced).
1461      *
1462      * If the calling account had been granted `role`, emits a {RoleRevoked}
1463      * event.
1464      *
1465      * Requirements:
1466      *
1467      * - the caller must be `account`.
1468      */
1469     function renounceRole(bytes32 role, address account) public virtual override {
1470         require(account == _msgSender(), "AccessControl: can only renounce roles for self");
1471 
1472         _revokeRole(role, account);
1473     }
1474 
1475     /**
1476      * @dev Grants `role` to `account`.
1477      *
1478      * If `account` had not been already granted `role`, emits a {RoleGranted}
1479      * event. Note that unlike {grantRole}, this function doesn't perform any
1480      * checks on the calling account.
1481      *
1482      * [WARNING]
1483      * ====
1484      * This function should only be called from the constructor when setting
1485      * up the initial roles for the system.
1486      *
1487      * Using this function in any other way is effectively circumventing the admin
1488      * system imposed by {AccessControl}.
1489      * ====
1490      */
1491     function _setupRole(bytes32 role, address account) internal virtual {
1492         _grantRole(role, account);
1493     }
1494 
1495     /**
1496      * @dev Sets `adminRole` as ``role``'s admin role.
1497      *
1498      * Emits a {RoleAdminChanged} event.
1499      */
1500     function _setRoleAdmin(bytes32 role, bytes32 adminRole) internal virtual {
1501         bytes32 previousAdminRole = getRoleAdmin(role);
1502         _roles[role].adminRole = adminRole;
1503         emit RoleAdminChanged(role, previousAdminRole, adminRole);
1504     }
1505 
1506     function _grantRole(bytes32 role, address account) private {
1507         if (!hasRole(role, account)) {
1508             _roles[role].members[account] = true;
1509             emit RoleGranted(role, account, _msgSender());
1510         }
1511     }
1512 
1513     function _revokeRole(bytes32 role, address account) private {
1514         if (hasRole(role, account)) {
1515             _roles[role].members[account] = false;
1516             emit RoleRevoked(role, account, _msgSender());
1517         }
1518     }
1519 }
1520 
1521 
1522 
1523 contract Pluto is ERC721URIStorage, AccessControl, ERC721Enumerable {
1524     using Counters for Counters.Counter;
1525     Counters.Counter private _tokenIds;
1526 
1527     bytes32 public constant MINTER_ROLE = keccak256("MINTER_ROLE");
1528 
1529 
1530     mapping(uint256 => uint256) internal tokenIds_attributes;
1531 
1532     constructor() ERC721("PLUTO", "PLUTO") {
1533         _setupRole(DEFAULT_ADMIN_ROLE, msg.sender);
1534         _setupRole(MINTER_ROLE, msg.sender);
1535     }
1536 
1537     function supportsInterface(bytes4 interfaceId) public view virtual override(ERC721, AccessControl, ERC721Enumerable) returns (bool) {
1538         return super.supportsInterface(interfaceId);
1539     }
1540 
1541     function _beforeTokenTransfer(address from, address to, uint256 amount) internal virtual override(ERC721, ERC721Enumerable) {
1542         super._beforeTokenTransfer(from, to, amount);
1543     }
1544 
1545     function _burn(uint256 tokenId) internal virtual override(ERC721, ERC721URIStorage) {
1546         super._burn(tokenId);
1547     }
1548 
1549     function tokenURI(uint256 tokenId) public view virtual override(ERC721, ERC721URIStorage) returns (string memory) {
1550         return super.tokenURI(tokenId);
1551     }
1552 
1553     function getCurrentTokenId() public view returns (uint256) {
1554         return _tokenIds.current();
1555     }
1556 
1557     function mint(
1558         address _mintTo
1559         , string memory _tokenURI
1560         )
1561         public
1562         returns (uint256)
1563     {
1564         require(hasRole(MINTER_ROLE, msg.sender), "Caller is not a minter");
1565 
1566         _tokenIds.increment();
1567 
1568         uint256 newItemId = _tokenIds.current();
1569         _mint(_mintTo, newItemId);
1570         _setTokenURI(newItemId, _tokenURI );
1571 
1572         return newItemId;
1573     }
1574 
1575  
1576 
1577 
1578 }