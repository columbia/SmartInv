1 pragma solidity ^0.8.7;
2 
3 /**
4  * @dev Interface of the ERC165 standard, as defined in the
5  * https://eips.ethereum.org/EIPS/eip-165[EIP].
6  *
7  * Implementers can declare support of contract interfaces, which can then be
8  * queried by others ({ERC165Checker}).
9  *
10  * For an implementation, see {ERC165}.
11  */
12 interface IERC165 {
13     /**
14      * @dev Returns true if this contract implements the interface defined by
15      * `interfaceId`. See the corresponding
16      * https://eips.ethereum.org/EIPS/eip-165#how-interfaces-are-identified[EIP section]
17      * to learn more about how these ids are created.
18      *
19      * This function call must use less than 30 000 gas.
20      */
21     function supportsInterface(bytes4 interfaceId) external view returns (bool);
22 }
23 
24 /**
25  * @dev Required interface of an ERC721 compliant contract.
26  */
27 interface IERC721 is IERC165 {
28     /**
29      * @dev Emitted when `tokenId` token is transferred from `from` to `to`.
30      */
31     event Transfer(address indexed from, address indexed to, uint256 indexed tokenId);
32 
33     /**
34      * @dev Emitted when `owner` enables `approved` to manage the `tokenId` token.
35      */
36     event Approval(address indexed owner, address indexed approved, uint256 indexed tokenId);
37 
38     /**
39      * @dev Emitted when `owner` enables or disables (`approved`) `operator` to manage all of its assets.
40      */
41     event ApprovalForAll(address indexed owner, address indexed operator, bool approved);
42 
43     /**
44      * @dev Returns the number of tokens in ``owner``'s account.
45      */
46     function balanceOf(address owner) external view returns (uint256 balance);
47 
48     /**
49      * @dev Returns the owner of the `tokenId` token.
50      *
51      * Requirements:
52      *
53      * - `tokenId` must exist.
54      */
55     function ownerOf(uint256 tokenId) external view returns (address owner);
56 
57     /**
58      * @dev Safely transfers `tokenId` token from `from` to `to`, checking first that contract recipients
59      * are aware of the ERC721 protocol to prevent tokens from being forever locked.
60      *
61      * Requirements:
62      *
63      * - `from` cannot be the zero address.
64      * - `to` cannot be the zero address.
65      * - `tokenId` token must exist and be owned by `from`.
66      * - If the caller is not `from`, it must be have been allowed to move this token by either {approve} or {setApprovalForAll}.
67      * - If `to` refers to a smart contract, it must implement {IERC721Receiver-onERC721Received}, which is called upon a safe transfer.
68      *
69      * Emits a {Transfer} event.
70      */
71     function safeTransferFrom(
72         address from,
73         address to,
74         uint256 tokenId
75     ) external;
76 
77     /**
78      * @dev Transfers `tokenId` token from `from` to `to`.
79      *
80      * WARNING: Usage of this method is discouraged, use {safeTransferFrom} whenever possible.
81      *
82      * Requirements:
83      *
84      * - `from` cannot be the zero address.
85      * - `to` cannot be the zero address.
86      * - `tokenId` token must be owned by `from`.
87      * - If the caller is not `from`, it must be approved to move this token by either {approve} or {setApprovalForAll}.
88      *
89      * Emits a {Transfer} event.
90      */
91     function transferFrom(
92         address from,
93         address to,
94         uint256 tokenId
95     ) external;
96 
97     /**
98      * @dev Gives permission to `to` to transfer `tokenId` token to another account.
99      * The approval is cleared when the token is transferred.
100      *
101      * Only a single account can be approved at a time, so approving the zero address clears previous approvals.
102      *
103      * Requirements:
104      *
105      * - The caller must own the token or be an approved operator.
106      * - `tokenId` must exist.
107      *
108      * Emits an {Approval} event.
109      */
110     function approve(address to, uint256 tokenId) external;
111 
112     /**
113      * @dev Returns the account approved for `tokenId` token.
114      *
115      * Requirements:
116      *
117      * - `tokenId` must exist.
118      */
119     function getApproved(uint256 tokenId) external view returns (address operator);
120 
121     /**
122      * @dev Approve or remove `operator` as an operator for the caller.
123      * Operators can call {transferFrom} or {safeTransferFrom} for any token owned by the caller.
124      *
125      * Requirements:
126      *
127      * - The `operator` cannot be the caller.
128      *
129      * Emits an {ApprovalForAll} event.
130      */
131     function setApprovalForAll(address operator, bool _approved) external;
132 
133     /**
134      * @dev Returns if the `operator` is allowed to manage all of the assets of `owner`.
135      *
136      * See {setApprovalForAll}
137      */
138     function isApprovedForAll(address owner, address operator) external view returns (bool);
139 
140     /**
141      * @dev Safely transfers `tokenId` token from `from` to `to`.
142      *
143      * Requirements:
144      *
145      * - `from` cannot be the zero address.
146      * - `to` cannot be the zero address.
147      * - `tokenId` token must exist and be owned by `from`.
148      * - If the caller is not `from`, it must be approved to move this token by either {approve} or {setApprovalForAll}.
149      * - If `to` refers to a smart contract, it must implement {IERC721Receiver-onERC721Received}, which is called upon a safe transfer.
150      *
151      * Emits a {Transfer} event.
152      */
153     function safeTransferFrom(
154         address from,
155         address to,
156         uint256 tokenId,
157         bytes calldata data
158     ) external;
159 }
160 
161 /**
162  * @title ERC721 token receiver interface
163  * @dev Interface for any contract that wants to support safeTransfers
164  * from ERC721 asset contracts.
165  */
166 interface IERC721Receiver {
167     /**
168      * @dev Whenever an {IERC721} `tokenId` token is transferred to this contract via {IERC721-safeTransferFrom}
169      * by `operator` from `from`, this function is called.
170      *
171      * It must return its Solidity selector to confirm the token transfer.
172      * If any other value is returned or the interface is not implemented by the recipient, the transfer will be reverted.
173      *
174      * The selector can be obtained in Solidity with `IERC721.onERC721Received.selector`.
175      */
176     function onERC721Received(
177         address operator,
178         address from,
179         uint256 tokenId,
180         bytes calldata data
181     ) external returns (bytes4);
182 }
183 
184 /**
185  * @title ERC-721 Non-Fungible Token Standard, optional metadata extension
186  * @dev See https://eips.ethereum.org/EIPS/eip-721
187  */
188 interface IERC721Metadata is IERC721 {
189     /**
190      * @dev Returns the token collection name.
191      */
192     function name() external view returns (string memory);
193 
194     /**
195      * @dev Returns the token collection symbol.
196      */
197     function symbol() external view returns (string memory);
198 
199     /**
200      * @dev Returns the Uniform Resource Identifier (URI) for `tokenId` token.
201      */
202     function tokenURI(uint256 tokenId) external view returns (string memory);
203 }
204 
205 /**
206  * @dev Collection of functions related to the address type
207  */
208 library Address {
209     /**
210      * @dev Returns true if `account` is a contract.
211      *
212      * [IMPORTANT]
213      * ====
214      * It is unsafe to assume that an address for which this function returns
215      * false is an externally-owned account (EOA) and not a contract.
216      *
217      * Among others, `isContract` will return false for the following
218      * types of addresses:
219      *
220      *  - an externally-owned account
221      *  - a contract in construction
222      *  - an address where a contract will be created
223      *  - an address where a contract lived, but was destroyed
224      * ====
225      */
226     function isContract(address account) internal view returns (bool) {
227         // This method relies on extcodesize, which returns 0 for contracts in
228         // construction, since the code is only stored at the end of the
229         // constructor execution.
230 
231         uint256 size;
232         assembly {
233             size := extcodesize(account)
234         }
235         return size > 0;
236     }
237 
238     /**
239      * @dev Replacement for Solidity's `transfer`: sends `amount` wei to
240      * `recipient`, forwarding all available gas and reverting on errors.
241      *
242      * https://eips.ethereum.org/EIPS/eip-1884[EIP1884] increases the gas cost
243      * of certain opcodes, possibly making contracts go over the 2300 gas limit
244      * imposed by `transfer`, making them unable to receive funds via
245      * `transfer`. {sendValue} removes this limitation.
246      *
247      * https://diligence.consensys.net/posts/2019/09/stop-using-soliditys-transfer-now/[Learn more].
248      *
249      * IMPORTANT: because control is transferred to `recipient`, care must be
250      * taken to not create reentrancy vulnerabilities. Consider using
251      * {ReentrancyGuard} or the
252      * https://solidity.readthedocs.io/en/v0.5.11/security-considerations.html#use-the-checks-effects-interactions-pattern[checks-effects-interactions pattern].
253      */
254     function sendValue(address payable recipient, uint256 amount) internal {
255         require(address(this).balance >= amount, "Address: insufficient balance");
256 
257         (bool success, ) = recipient.call{ value: amount }("");
258         require(success, "Address: unable to send value, recipient may have reverted");
259     }
260 
261     /**
262      * @dev Performs a Solidity function call using a low level `call`. A
263      * plain `call` is an unsafe replacement for a function call: use this
264      * function instead.
265      *
266      * If `target` reverts with a revert reason, it is bubbled up by this
267      * function (like regular Solidity function calls).
268      *
269      * Returns the raw returned data. To convert to the expected return value,
270      * use https://solidity.readthedocs.io/en/latest/units-and-global-variables.html?highlight=abi.decode#abi-encoding-and-decoding-functions[`abi.decode`].
271      *
272      * Requirements:
273      *
274      * - `target` must be a contract.
275      * - calling `target` with `data` must not revert.
276      *
277      * _Available since v3.1._
278      */
279     function functionCall(address target, bytes memory data) internal returns (bytes memory) {
280         return functionCall(target, data, "Address: low-level call failed");
281     }
282 
283     /**
284      * @dev Same as {xref-Address-functionCall-address-bytes-}[`functionCall`], but with
285      * `errorMessage` as a fallback revert reason when `target` reverts.
286      *
287      * _Available since v3.1._
288      */
289     function functionCall(
290         address target,
291         bytes memory data,
292         string memory errorMessage
293     ) internal returns (bytes memory) {
294         return functionCallWithValue(target, data, 0, errorMessage);
295     }
296 
297     /**
298      * @dev Same as {xref-Address-functionCall-address-bytes-}[`functionCall`],
299      * but also transferring `value` wei to `target`.
300      *
301      * Requirements:
302      *
303      * - the calling contract must have an ETH balance of at least `value`.
304      * - the called Solidity function must be `payable`.
305      *
306      * _Available since v3.1._
307      */
308     function functionCallWithValue(
309         address target,
310         bytes memory data,
311         uint256 value
312     ) internal returns (bytes memory) {
313         return
314             functionCallWithValue(target, data, value, "Address: low-level call with value failed");
315     }
316 
317     /**
318      * @dev Same as {xref-Address-functionCallWithValue-address-bytes-uint256-}[`functionCallWithValue`], but
319      * with `errorMessage` as a fallback revert reason when `target` reverts.
320      *
321      * _Available since v3.1._
322      */
323     function functionCallWithValue(
324         address target,
325         bytes memory data,
326         uint256 value,
327         string memory errorMessage
328     ) internal returns (bytes memory) {
329         require(address(this).balance >= value, "Address: insufficient balance for call");
330         require(isContract(target), "Address: call to non-contract");
331 
332         (bool success, bytes memory returndata) = target.call{ value: value }(data);
333         return _verifyCallResult(success, returndata, errorMessage);
334     }
335 
336     /**
337      * @dev Same as {xref-Address-functionCall-address-bytes-}[`functionCall`],
338      * but performing a static call.
339      *
340      * _Available since v3.3._
341      */
342     function functionStaticCall(address target, bytes memory data)
343         internal
344         view
345         returns (bytes memory)
346     {
347         return functionStaticCall(target, data, "Address: low-level static call failed");
348     }
349 
350     /**
351      * @dev Same as {xref-Address-functionCall-address-bytes-string-}[`functionCall`],
352      * but performing a static call.
353      *
354      * _Available since v3.3._
355      */
356     function functionStaticCall(
357         address target,
358         bytes memory data,
359         string memory errorMessage
360     ) internal view returns (bytes memory) {
361         require(isContract(target), "Address: static call to non-contract");
362 
363         (bool success, bytes memory returndata) = target.staticcall(data);
364         return _verifyCallResult(success, returndata, errorMessage);
365     }
366 
367     /**
368      * @dev Same as {xref-Address-functionCall-address-bytes-}[`functionCall`],
369      * but performing a delegate call.
370      *
371      * _Available since v3.4._
372      */
373     function functionDelegateCall(address target, bytes memory data)
374         internal
375         returns (bytes memory)
376     {
377         return functionDelegateCall(target, data, "Address: low-level delegate call failed");
378     }
379 
380     /**
381      * @dev Same as {xref-Address-functionCall-address-bytes-string-}[`functionCall`],
382      * but performing a delegate call.
383      *
384      * _Available since v3.4._
385      */
386     function functionDelegateCall(
387         address target,
388         bytes memory data,
389         string memory errorMessage
390     ) internal returns (bytes memory) {
391         require(isContract(target), "Address: delegate call to non-contract");
392 
393         (bool success, bytes memory returndata) = target.delegatecall(data);
394         return _verifyCallResult(success, returndata, errorMessage);
395     }
396 
397     function _verifyCallResult(
398         bool success,
399         bytes memory returndata,
400         string memory errorMessage
401     ) private pure returns (bytes memory) {
402         if (success) {
403             return returndata;
404         } else {
405             // Look for revert reason and bubble it up if present
406             if (returndata.length > 0) {
407                 // The easiest way to bubble the revert reason is using memory via assembly
408 
409                 assembly {
410                     let returndata_size := mload(returndata)
411                     revert(add(32, returndata), returndata_size)
412                 }
413             } else {
414                 revert(errorMessage);
415             }
416         }
417     }
418 }
419 
420 /*
421  * @dev Provides information about the current execution context, including the
422  * sender of the transaction and its data. While these are generally available
423  * via msg.sender and msg.data, they should not be accessed in such a direct
424  * manner, since when dealing with meta-transactions the account sending and
425  * paying for execution may not be the actual sender (as far as an application
426  * is concerned).
427  *
428  * This contract is only required for intermediate, library-like contracts.
429  */
430 abstract contract Context {
431     function _msgSender() internal view virtual returns (address) {
432         return msg.sender;
433     }
434 
435     function _msgData() internal view virtual returns (bytes calldata) {
436         return msg.data;
437     }
438 }
439 
440 /**
441  * @dev String operations.
442  */
443 library Strings {
444     bytes16 private constant _HEX_SYMBOLS = "0123456789abcdef";
445 
446     /**
447      * @dev Converts a `uint256` to its ASCII `string` decimal representation.
448      */
449     function toString(uint256 value) internal pure returns (string memory) {
450         // Inspired by OraclizeAPI's implementation - MIT licence
451         // https://github.com/oraclize/ethereum-api/blob/b42146b063c7d6ee1358846c198246239e9360e8/oraclizeAPI_0.4.25.sol
452 
453         if (value == 0) {
454             return "0";
455         }
456         uint256 temp = value;
457         uint256 digits;
458         while (temp != 0) {
459             digits++;
460             temp /= 10;
461         }
462         bytes memory buffer = new bytes(digits);
463         while (value != 0) {
464             digits -= 1;
465             buffer[digits] = bytes1(uint8(48 + uint256(value % 10)));
466             value /= 10;
467         }
468         return string(buffer);
469     }
470 
471     /**
472      * @dev Converts a `uint256` to its ASCII `string` hexadecimal representation.
473      */
474     function toHexString(uint256 value) internal pure returns (string memory) {
475         if (value == 0) {
476             return "0x00";
477         }
478         uint256 temp = value;
479         uint256 length = 0;
480         while (temp != 0) {
481             length++;
482             temp >>= 8;
483         }
484         return toHexString(value, length);
485     }
486 
487     /**
488      * @dev Converts a `uint256` to its ASCII `string` hexadecimal representation with fixed length.
489      */
490     function toHexString(uint256 value, uint256 length) internal pure returns (string memory) {
491         bytes memory buffer = new bytes(2 * length + 2);
492         buffer[0] = "0";
493         buffer[1] = "x";
494         for (uint256 i = 2 * length + 1; i > 1; --i) {
495             buffer[i] = _HEX_SYMBOLS[value & 0xf];
496             value >>= 4;
497         }
498         require(value == 0, "Strings: hex length insufficient");
499         return string(buffer);
500     }
501 }
502 
503 /**
504  * @dev Implementation of the {IERC165} interface.
505  *
506  * Contracts that want to implement ERC165 should inherit from this contract and override {supportsInterface} to check
507  * for the additional interface id that will be supported. For example:
508  *
509  * ```solidity
510  * function supportsInterface(bytes4 interfaceId) public view virtual override returns (bool) {
511  *     return interfaceId == type(MyInterface).interfaceId || super.supportsInterface(interfaceId);
512  * }
513  * ```
514  *
515  * Alternatively, {ERC165Storage} provides an easier to use but more expensive implementation.
516  */
517 abstract contract ERC165 is IERC165 {
518     /**
519      * @dev See {IERC165-supportsInterface}.
520      */
521     function supportsInterface(bytes4 interfaceId) public view virtual override returns (bool) {
522         return interfaceId == type(IERC165).interfaceId;
523     }
524 }
525 
526 contract ERC721 is Context, ERC165, IERC721, IERC721Metadata {
527     using Address for address;
528     using Strings for uint256;
529 
530     // Token name
531     string private _name;
532 
533     // Token symbol
534     string private _symbol;
535 
536     // Mapping from token ID to owner address
537     mapping(uint256 => address) private _owners;
538 
539     // Mapping owner address to token count
540     mapping(address => uint256) private _balances;
541 
542     // Mapping from token ID to approved address
543     mapping(uint256 => address) private _tokenApprovals;
544 
545     // Mapping from owner to operator approvals
546     mapping(address => mapping(address => bool)) private _operatorApprovals;
547 
548     /**
549      * @dev Initializes the contract by setting a `name` and a `symbol` to the token collection.
550      */
551     constructor(string memory name_, string memory symbol_) {
552         _name = name_;
553         _symbol = symbol_;
554     }
555 
556     /**
557      * @dev See {IERC165-supportsInterface}.
558      */
559     function supportsInterface(bytes4 interfaceId)
560         public
561         view
562         virtual
563         override(ERC165, IERC165)
564         returns (bool)
565     {
566         return
567             interfaceId == type(IERC721).interfaceId ||
568             interfaceId == type(IERC721Metadata).interfaceId ||
569             super.supportsInterface(interfaceId);
570     }
571 
572     /**
573      * @dev See {IERC721-balanceOf}.
574      */
575     function balanceOf(address owner) public view virtual override returns (uint256) {
576         require(owner != address(0), "ERC721: balance query for the zero address");
577         return _balances[owner];
578     }
579 
580     /**
581      * @dev See {IERC721-ownerOf}.
582      */
583     function ownerOf(uint256 tokenId) public view virtual override returns (address) {
584         address owner = _owners[tokenId];
585         require(owner != address(0), "ERC721: owner query for nonexistent token");
586         return owner;
587     }
588 
589     /**
590      * @dev See {IERC721Metadata-name}.
591      */
592     function name() public view virtual override returns (string memory) {
593         return _name;
594     }
595 
596     /**
597      * @dev See {IERC721Metadata-symbol}.
598      */
599     function symbol() public view virtual override returns (string memory) {
600         return _symbol;
601     }
602 
603     /**
604      * @dev See {IERC721Metadata-tokenURI}.
605      */
606     function tokenURI(uint256 tokenId) public view virtual override returns (string memory) {
607         require(_exists(tokenId), "ERC721Metadata: URI query for nonexistent token");
608 
609         string memory baseURI = _baseURI();
610         return
611             bytes(baseURI).length > 0 ? string(abi.encodePacked(baseURI, tokenId.toString())) : "";
612     }
613 
614     /**
615      * @dev Base URI for computing {tokenURI}. If set, the resulting URI for each
616      * token will be the concatenation of the `baseURI` and the `tokenId`. Empty
617      * by default, can be overriden in child contracts.
618      */
619     function _baseURI() internal view virtual returns (string memory) {
620         return "";
621     }
622 
623     /**
624      * @dev See {IERC721-approve}.
625      */
626     function approve(address to, uint256 tokenId) public virtual override {
627         address owner = ERC721.ownerOf(tokenId);
628         require(to != owner, "ERC721: approval to current owner");
629 
630         require(
631             _msgSender() == owner || isApprovedForAll(owner, _msgSender()),
632             "ERC721: approve caller is not owner nor approved for all"
633         );
634 
635         _approve(to, tokenId);
636     }
637 
638     /**
639      * @dev See {IERC721-getApproved}.
640      */
641     function getApproved(uint256 tokenId) public view virtual override returns (address) {
642         require(_exists(tokenId), "ERC721: approved query for nonexistent token");
643 
644         return _tokenApprovals[tokenId];
645     }
646 
647     /**
648      * @dev See {IERC721-setApprovalForAll}.
649      */
650     function setApprovalForAll(address operator, bool approved) public virtual override {
651         require(operator != _msgSender(), "ERC721: approve to caller");
652 
653         _operatorApprovals[_msgSender()][operator] = approved;
654         emit ApprovalForAll(_msgSender(), operator, approved);
655     }
656 
657     /**
658      * @dev See {IERC721-isApprovedForAll}.
659      */
660     function isApprovedForAll(address owner, address operator)
661         public
662         view
663         virtual
664         override
665         returns (bool)
666     {
667         return _operatorApprovals[owner][operator];
668     }
669 
670     /**
671      * @dev See {IERC721-transferFrom}.
672      */
673     function transferFrom(
674         address from,
675         address to,
676         uint256 tokenId
677     ) public virtual override {
678         //solhint-disable-next-line max-line-length
679         require(
680             _isApprovedOrOwner(_msgSender(), tokenId),
681             "ERC721: transfer caller is not owner nor approved"
682         );
683 
684         _transfer(from, to, tokenId);
685     }
686 
687     /**
688      * @dev See {IERC721-safeTransferFrom}.
689      */
690     function safeTransferFrom(
691         address from,
692         address to,
693         uint256 tokenId
694     ) public virtual override {
695         safeTransferFrom(from, to, tokenId, "");
696     }
697 
698     /**
699      * @dev See {IERC721-safeTransferFrom}.
700      */
701     function safeTransferFrom(
702         address from,
703         address to,
704         uint256 tokenId,
705         bytes memory _data
706     ) public virtual override {
707         require(
708             _isApprovedOrOwner(_msgSender(), tokenId),
709             "ERC721: transfer caller is not owner nor approved"
710         );
711         _safeTransfer(from, to, tokenId, _data);
712     }
713 
714     /**
715      * @dev Safely transfers `tokenId` token from `from` to `to`, checking first that contract recipients
716      * are aware of the ERC721 protocol to prevent tokens from being forever locked.
717      *
718      * `_data` is additional data, it has no specified format and it is sent in call to `to`.
719      *
720      * This internal function is equivalent to {safeTransferFrom}, and can be used to e.g.
721      * implement alternative mechanisms to perform token transfer, such as signature-based.
722      *
723      * Requirements:
724      *
725      * - `from` cannot be the zero address.
726      * - `to` cannot be the zero address.
727      * - `tokenId` token must exist and be owned by `from`.
728      * - If `to` refers to a smart contract, it must implement {IERC721Receiver-onERC721Received}, which is called upon a safe transfer.
729      *
730      * Emits a {Transfer} event.
731      */
732     function _safeTransfer(
733         address from,
734         address to,
735         uint256 tokenId,
736         bytes memory _data
737     ) internal virtual {
738         _transfer(from, to, tokenId);
739         require(
740             _checkOnERC721Received(from, to, tokenId, _data),
741             "ERC721: transfer to non ERC721Receiver implementer"
742         );
743     }
744 
745     /**
746      * @dev Returns whether `tokenId` exists.
747      *
748      * Tokens can be managed by their owner or approved accounts via {approve} or {setApprovalForAll}.
749      *
750      * Tokens start existing when they are minted (`_mint`),
751      * and stop existing when they are burned (`_burn`).
752      */
753     function _exists(uint256 tokenId) internal view virtual returns (bool) {
754         return _owners[tokenId] != address(0);
755     }
756 
757     /**
758      * @dev Returns whether `spender` is allowed to manage `tokenId`.
759      *
760      * Requirements:
761      *
762      * - `tokenId` must exist.
763      */
764     function _isApprovedOrOwner(address spender, uint256 tokenId)
765         internal
766         view
767         virtual
768         returns (bool)
769     {
770         require(_exists(tokenId), "ERC721: operator query for nonexistent token");
771         address owner = ERC721.ownerOf(tokenId);
772         return (spender == owner ||
773             getApproved(tokenId) == spender ||
774             isApprovedForAll(owner, spender));
775     }
776 
777     /**
778      * @dev Safely mints `tokenId` and transfers it to `to`.
779      *
780      * Requirements:
781      *
782      * - `tokenId` must not exist.
783      * - If `to` refers to a smart contract, it must implement {IERC721Receiver-onERC721Received}, which is called upon a safe transfer.
784      *
785      * Emits a {Transfer} event.
786      */
787     function _safeMint(address to, uint256 tokenId) internal virtual {
788         _safeMint(to, tokenId, "");
789     }
790 
791     /**
792      * @dev Same as {xref-ERC721-_safeMint-address-uint256-}[`_safeMint`], with an additional `data` parameter which is
793      * forwarded in {IERC721Receiver-onERC721Received} to contract recipients.
794      */
795     function _safeMint(
796         address to,
797         uint256 tokenId,
798         bytes memory _data
799     ) internal virtual {
800         _mint(to, tokenId);
801         require(
802             _checkOnERC721Received(address(0), to, tokenId, _data),
803             "ERC721: transfer to non ERC721Receiver implementer"
804         );
805     }
806 
807     /**
808      * @dev Mints `tokenId` and transfers it to `to`.
809      *
810      * WARNING: Usage of this method is discouraged, use {_safeMint} whenever possible
811      *
812      * Requirements:
813      *
814      * - `tokenId` must not exist.
815      * - `to` cannot be the zero address.
816      *
817      * Emits a {Transfer} event.
818      */
819     function _mint(address to, uint256 tokenId) internal virtual {
820         require(to != address(0), "ERC721: mint to the zero address");
821         require(!_exists(tokenId), "ERC721: token already minted");
822 
823         _beforeTokenTransfer(address(0), to, tokenId);
824 
825         _balances[to] += 1;
826         _owners[tokenId] = to;
827 
828         emit Transfer(address(0), to, tokenId);
829     }
830 
831     /**
832      * @dev Destroys `tokenId`.
833      * The approval is cleared when the token is burned.
834      *
835      * Requirements:
836      *
837      * - `tokenId` must exist.
838      *
839      * Emits a {Transfer} event.
840      */
841     function _burn(uint256 tokenId) internal virtual {
842         address owner = ERC721.ownerOf(tokenId);
843 
844         _beforeTokenTransfer(owner, address(0), tokenId);
845 
846         // Clear approvals
847         _approve(address(0), tokenId);
848 
849         _balances[owner] -= 1;
850         delete _owners[tokenId];
851 
852         emit Transfer(owner, address(0), tokenId);
853     }
854 
855     /**
856      * @dev Transfers `tokenId` from `from` to `to`.
857      *  As opposed to {transferFrom}, this imposes no restrictions on msg.sender.
858      *
859      * Requirements:
860      *
861      * - `to` cannot be the zero address.
862      * - `tokenId` token must be owned by `from`.
863      *
864      * Emits a {Transfer} event.
865      */
866     function _transfer(
867         address from,
868         address to,
869         uint256 tokenId
870     ) internal virtual {
871         require(ERC721.ownerOf(tokenId) == from, "ERC721: transfer of token that is not own");
872         require(to != address(0), "ERC721: transfer to the zero address");
873 
874         _beforeTokenTransfer(from, to, tokenId);
875 
876         // Clear approvals from the previous owner
877         _approve(address(0), tokenId);
878 
879         _balances[from] -= 1;
880         _balances[to] += 1;
881         _owners[tokenId] = to;
882 
883         emit Transfer(from, to, tokenId);
884     }
885 
886     /**
887      * @dev Approve `to` to operate on `tokenId`
888      *
889      * Emits a {Approval} event.
890      */
891     function _approve(address to, uint256 tokenId) internal virtual {
892         _tokenApprovals[tokenId] = to;
893         emit Approval(ERC721.ownerOf(tokenId), to, tokenId);
894     }
895 
896     /**
897      * @dev Internal function to invoke {IERC721Receiver-onERC721Received} on a target address.
898      * The call is not executed if the target address is not a contract.
899      *
900      * @param from address representing the previous owner of the given token ID
901      * @param to target address that will receive the tokens
902      * @param tokenId uint256 ID of the token to be transferred
903      * @param _data bytes optional data to send along with the call
904      * @return bool whether the call correctly returned the expected magic value
905      */
906     function _checkOnERC721Received(
907         address from,
908         address to,
909         uint256 tokenId,
910         bytes memory _data
911     ) private returns (bool) {
912         if (to.isContract()) {
913             try IERC721Receiver(to).onERC721Received(_msgSender(), from, tokenId, _data) returns (
914                 bytes4 retval
915             ) {
916                 return retval == IERC721Receiver(to).onERC721Received.selector;
917             } catch (bytes memory reason) {
918                 if (reason.length == 0) {
919                     revert("ERC721: transfer to non ERC721Receiver implementer");
920                 } else {
921                     assembly {
922                         revert(add(32, reason), mload(reason))
923                     }
924                 }
925             }
926         } else {
927             return true;
928         }
929     }
930 
931     /**
932      * @dev Hook that is called before any token transfer. This includes minting
933      * and burning.
934      *
935      * Calling conditions:
936      *
937      * - When `from` and `to` are both non-zero, ``from``'s `tokenId` will be
938      * transferred to `to`.
939      * - When `from` is zero, `tokenId` will be minted for `to`.
940      * - When `to` is zero, ``from``'s `tokenId` will be burned.
941      * - `from` and `to` are never both zero.
942      *
943      * To learn more about hooks, head to xref:ROOT:extending-contracts.adoc#using-hooks[Using Hooks].
944      */
945     function _beforeTokenTransfer(
946         address from,
947         address to,
948         uint256 tokenId
949     ) internal virtual {}
950 }
951 
952 abstract contract Ownable is Context {
953     address private _owner;
954 
955     event OwnershipTransferred(address indexed previousOwner, address indexed newOwner);
956 
957     /**
958      * @dev Initializes the contract setting the deployer as the initial owner.
959      */
960     constructor() {
961         _setOwner(_msgSender());
962     }
963 
964     /**
965      * @dev Returns the address of the current owner.
966      */
967     function owner() public view virtual returns (address) {
968         return _owner;
969     }
970 
971     /**
972      * @dev Throws if called by any account other than the owner.
973      */
974     modifier onlyOwner() {
975         require(owner() == _msgSender(), "Ownable: caller is not the owner");
976         _;
977     }
978 
979     /**
980      * @dev Leaves the contract without owner. It will not be possible to call
981      * `onlyOwner` functions anymore. Can only be called by the current owner.
982      *
983      * NOTE: Renouncing ownership will leave the contract without an owner,
984      * thereby removing any functionality that is only available to the owner.
985      */
986     function renounceOwnership() public virtual onlyOwner {
987         _setOwner(address(0));
988     }
989 
990     /**
991      * @dev Transfers ownership of the contract to a new account (`newOwner`).
992      * Can only be called by the current owner.
993      */
994     function transferOwnership(address newOwner) public virtual onlyOwner {
995         require(newOwner != address(0), "Ownable: new owner is the zero address");
996         _setOwner(newOwner);
997     }
998 
999     function _setOwner(address newOwner) private {
1000         address oldOwner = _owner;
1001         _owner = newOwner;
1002         emit OwnershipTransferred(oldOwner, newOwner);
1003     }
1004 }
1005 
1006 contract Initializable {
1007     bool inited = false;
1008 
1009     modifier initializer() {
1010         require(!inited, "already inited");
1011         _;
1012         inited = true;
1013     }
1014 }
1015 
1016 contract EIP712Base is Initializable {
1017     struct EIP712Domain {
1018         string name;
1019         string version;
1020         address verifyingContract;
1021         bytes32 salt;
1022     }
1023 
1024     string public constant ERC712_VERSION = "1";
1025 
1026     bytes32 internal constant EIP712_DOMAIN_TYPEHASH =
1027         keccak256(
1028             bytes("EIP712Domain(string name,string version,address verifyingContract,bytes32 salt)")
1029         );
1030     bytes32 internal domainSeperator;
1031 
1032     // supposed to be called once while initializing.
1033     // one of the contracts that inherits this contract follows proxy pattern
1034     // so it is not possible to do this in a constructor
1035     function _initializeEIP712(string memory name) internal initializer {
1036         _setDomainSeperator(name);
1037     }
1038 
1039     function _setDomainSeperator(string memory name) internal {
1040         domainSeperator = keccak256(
1041             abi.encode(
1042                 EIP712_DOMAIN_TYPEHASH,
1043                 keccak256(bytes(name)),
1044                 keccak256(bytes(ERC712_VERSION)),
1045                 address(this),
1046                 bytes32(getChainId())
1047             )
1048         );
1049     }
1050 
1051     function getDomainSeperator() public view returns (bytes32) {
1052         return domainSeperator;
1053     }
1054 
1055     function getChainId() public view returns (uint256) {
1056         uint256 id;
1057         assembly {
1058             id := chainid()
1059         }
1060         return id;
1061     }
1062 
1063     /**
1064      * Accept message hash and returns hash message in EIP712 compatible form
1065      * So that it can be used to recover signer from signature signed using EIP712 formatted data
1066      * https://eips.ethereum.org/EIPS/eip-712
1067      * "\\x19" makes the encoding deterministic
1068      * "\\x01" is the version byte to make it compatible to EIP-191
1069      */
1070     function toTypedMessageHash(bytes32 messageHash) internal view returns (bytes32) {
1071         return keccak256(abi.encodePacked("\x19\x01", getDomainSeperator(), messageHash));
1072     }
1073 }
1074 
1075 contract NativeMetaTransaction is EIP712Base {
1076     bytes32 private constant META_TRANSACTION_TYPEHASH =
1077         keccak256(bytes("MetaTransaction(uint256 nonce,address from,bytes functionSignature)"));
1078     event MetaTransactionExecuted(
1079         address userAddress,
1080         address payable relayerAddress,
1081         bytes functionSignature
1082     );
1083     mapping(address => uint256) nonces;
1084 
1085     /*
1086      * Meta transaction structure.
1087      * No point of including value field here as if user is doing value transfer then he has the funds to pay for gas
1088      * He should call the desired function directly in that case.
1089      */
1090     struct MetaTransaction {
1091         uint256 nonce;
1092         address from;
1093         bytes functionSignature;
1094     }
1095 
1096     function executeMetaTransaction(
1097         address userAddress,
1098         bytes memory functionSignature,
1099         bytes32 sigR,
1100         bytes32 sigS,
1101         uint8 sigV
1102     ) public payable returns (bytes memory) {
1103         MetaTransaction memory metaTx = MetaTransaction({
1104             nonce: nonces[userAddress],
1105             from: userAddress,
1106             functionSignature: functionSignature
1107         });
1108 
1109         require(verify(userAddress, metaTx, sigR, sigS, sigV), "Signer and signature do not match");
1110 
1111         // increase nonce for user (to avoid re-use)
1112         nonces[userAddress] += 1;
1113 
1114         emit MetaTransactionExecuted(userAddress, payable(msg.sender), functionSignature);
1115 
1116         // Append userAddress and relayer address at the end to extract it from calling context
1117         (bool success, bytes memory returnData) = address(this).call(
1118             abi.encodePacked(functionSignature, userAddress)
1119         );
1120         require(success, "Function call not successful");
1121 
1122         return returnData;
1123     }
1124 
1125     function hashMetaTransaction(MetaTransaction memory metaTx) internal pure returns (bytes32) {
1126         return
1127             keccak256(
1128                 abi.encode(
1129                     META_TRANSACTION_TYPEHASH,
1130                     metaTx.nonce,
1131                     metaTx.from,
1132                     keccak256(metaTx.functionSignature)
1133                 )
1134             );
1135     }
1136 
1137     function getNonce(address user) public view returns (uint256 nonce) {
1138         nonce = nonces[user];
1139     }
1140 
1141     function verify(
1142         address signer,
1143         MetaTransaction memory metaTx,
1144         bytes32 sigR,
1145         bytes32 sigS,
1146         uint8 sigV
1147     ) internal view returns (bool) {
1148         require(signer != address(0), "NativeMetaTransaction: INVALID_SIGNER");
1149         return
1150             signer == ecrecover(toTypedMessageHash(hashMetaTransaction(metaTx)), sigV, sigR, sigS);
1151     }
1152 }
1153 
1154 abstract contract ContextMixin {
1155     function msgSender() internal view returns (address payable sender) {
1156         if (msg.sender == address(this)) {
1157             bytes memory array = msg.data;
1158             uint256 index = msg.data.length;
1159             assembly {
1160                 // Load the 32 bytes word from memory with the address on the lower 20 bytes, and mask those.
1161                 sender := and(mload(add(array, index)), 0xffffffffffffffffffffffffffffffffffffffff)
1162             }
1163         } else {
1164             sender = payable(msg.sender);
1165         }
1166         return sender;
1167     }
1168 }
1169 
1170 contract OwnableDelegateProxy {}
1171 
1172 contract ProxyRegistry {
1173     mapping(address => OwnableDelegateProxy) public proxies;
1174 }
1175 
1176 abstract contract ERC721Tradable is ContextMixin, Ownable, ERC721, NativeMetaTransaction {
1177     address public proxyRegistryAddress;
1178     uint256 private _currentTokenId = 0;
1179 
1180     constructor(
1181         string memory _name,
1182         string memory _symbol,
1183         address _proxyRegistryAddress
1184     ) ERC721(_name, _symbol) Ownable() {
1185         proxyRegistryAddress = _proxyRegistryAddress;
1186         _initializeEIP712(_name);
1187     }
1188 
1189     /**
1190      * Override isApprovedForAll to whitelist user's OpenSea proxy accounts to enable gas-less listings.
1191      */
1192     function isApprovedForAll(address owner, address operator) public view override returns (bool) {
1193         // Whitelist OpenSea proxy contract for easy trading.
1194         ProxyRegistry proxyRegistry = ProxyRegistry(proxyRegistryAddress);
1195         if (
1196             proxyRegistryAddress != address(0) && address(proxyRegistry.proxies(owner)) == operator
1197         ) {
1198             return true;
1199         }
1200 
1201         return super.isApprovedForAll(owner, operator);
1202     }
1203 
1204     /**
1205      * This is used instead of msg.sender as transactions won't be sent by the original token owner, but by OpenSea.
1206      */
1207     function _msgSender() internal view override returns (address sender) {
1208         return ContextMixin.msgSender();
1209     }
1210 }
1211 
1212 abstract contract ReentrancyGuard {
1213     // Booleans are more expensive than uint256 or any type that takes up a full
1214     // word because each write operation emits an extra SLOAD to first read the
1215     // slot's contents, replace the bits taken up by the boolean, and then write
1216     // back. This is the compiler's defense against contract upgrades and
1217     // pointer aliasing, and it cannot be disabled.
1218 
1219     // The values being non-zero value makes deployment a bit more expensive,
1220     // but in exchange the refund on every call to nonReentrant will be lower in
1221     // amount. Since refunds are capped to a percentage of the total
1222     // transaction's gas, it is best to keep them low in cases like this one, to
1223     // increase the likelihood of the full refund coming into effect.
1224     uint256 private constant _NOT_ENTERED = 1;
1225     uint256 private constant _ENTERED = 2;
1226 
1227     uint256 private _status;
1228 
1229     constructor() {
1230         _status = _NOT_ENTERED;
1231     }
1232 
1233     /**
1234      * @dev Prevents a contract from calling itself, directly or indirectly.
1235      * Calling a `nonReentrant` function from another `nonReentrant`
1236      * function is not supported. It is possible to prevent this from happening
1237      * by making the `nonReentrant` function external, and make it call a
1238      * `private` function that does the actual work.
1239      */
1240     modifier nonReentrant() {
1241         // On the first call to nonReentrant, _notEntered will be true
1242         require(_status != _ENTERED, "ReentrancyGuard: reentrant call");
1243 
1244         // Any calls to nonReentrant after this point will fail
1245         _status = _ENTERED;
1246 
1247         _;
1248 
1249         // By storing the original value once again, a refund is triggered (see
1250         // https://eips.ethereum.org/EIPS/eip-2200)
1251         _status = _NOT_ENTERED;
1252     }
1253 }
1254 
1255 library Packed16BitArray {
1256     using Packed16BitArray for Packed16BitArray.PackedArray;
1257 
1258     struct PackedArray {
1259         uint256[] array;
1260         uint256 length;
1261     }
1262 
1263     // Verifies that the higher level count is correct, and that the last uint256 is left packed with 0's
1264     function initStruct(uint256[] memory _arr, uint256 _len)
1265         internal
1266         pure
1267         returns (PackedArray memory)
1268     {
1269         uint256 actualLength = _arr.length;
1270         uint256 len0 = _len / 16;
1271         require(actualLength == len0 + 1, "Invalid arr length");
1272 
1273         uint256 len1 = _len % 16;
1274         uint256 leftPacked = uint256(_arr[len0] >> (len1 * 16));
1275         require(leftPacked == 0, "Invalid uint256 packing");
1276 
1277         return PackedArray(_arr, _len);
1278     }
1279 
1280     function getValue(PackedArray storage ref, uint256 _index) internal view returns (uint16) {
1281         require(_index < ref.length, "Invalid index");
1282         uint256 aid = _index / 16;
1283         uint256 iid = _index % 16;
1284         return uint16(ref.array[aid] >> (iid * 16));
1285     }
1286 
1287     function biDirectionalSearch(
1288         PackedArray storage ref,
1289         uint256 _startIndex,
1290         uint16 _delta
1291     ) internal view returns (uint16[2] memory hits) {
1292         uint16 startVal = ref.getValue(_startIndex);
1293 
1294         // Search down
1295         if (startVal >= _delta && _startIndex > 0) {
1296             uint16 tempVal = startVal;
1297             uint256 tempIdx = _startIndex - 1;
1298             uint16 target = startVal - _delta;
1299 
1300             while (tempVal >= target) {
1301                 tempVal = ref.getValue(tempIdx);
1302                 if (tempVal == target) {
1303                     hits[0] = tempVal;
1304                     break;
1305                 }
1306                 if (tempIdx == 0) {
1307                     break;
1308                 } else {
1309                     tempIdx--;
1310                 }
1311             }
1312         }
1313         {
1314             // Search up
1315             uint16 tempVal = startVal;
1316             uint256 tempIdx = _startIndex + 1;
1317             uint16 target = startVal + _delta;
1318 
1319             while (tempVal <= target) {
1320                 if (tempIdx >= ref.length) break;
1321                 tempVal = ref.getValue(tempIdx++);
1322                 if (tempVal == target) {
1323                     hits[1] = tempVal;
1324                     break;
1325                 }
1326             }
1327         }
1328     }
1329 
1330     function setValue(
1331         PackedArray storage ref,
1332         uint256 _index,
1333         uint16 _value
1334     ) internal {
1335         uint256 aid = _index / 16;
1336         uint256 iid = _index % 16;
1337 
1338         // 1. Do an && between old value and a mask
1339         uint256 mask = uint256(~(uint256(65535) << (iid * 16)));
1340         uint256 masked = ref.array[aid] & mask;
1341         // 2. Do an |= between (1) and positioned _value
1342         mask = uint256(_value) << (iid * 16);
1343         ref.array[aid] = masked | mask;
1344     }
1345 
1346     function extractIndex(PackedArray storage ref, uint256 _index) internal {
1347         // Get value at the end
1348         uint16 endValue = ref.getValue(ref.length - 1);
1349         ref.setValue(_index, endValue);
1350         // TODO - could get rid of this and rely on length if need to reduce gas
1351         // ref.setValue(ref.length - 1, 0);
1352         ref.length--;
1353     }
1354 }
1355 
1356 library MerkleProof {
1357     /**
1358      * @dev Returns true if a `leaf` can be proved to be a part of a Merkle tree
1359      * defined by `root`. For this, a `proof` must be provided, containing
1360      * sibling hashes on the branch from the leaf to the root of the tree. Each
1361      * pair of leaves and each pair of pre-images are assumed to be sorted.
1362      */
1363     function verify(
1364         bytes32[] memory proof,
1365         bytes32 root,
1366         bytes32 leaf
1367     ) internal pure returns (bool) {
1368         bytes32 computedHash = leaf;
1369 
1370         for (uint256 i = 0; i < proof.length; i++) {
1371             bytes32 proofElement = proof[i];
1372 
1373             if (computedHash <= proofElement) {
1374                 // Hash(current computed hash + current element of the proof)
1375                 computedHash = keccak256(abi.encodePacked(computedHash, proofElement));
1376             } else {
1377                 // Hash(current element of the proof + current computed hash)
1378                 computedHash = keccak256(abi.encodePacked(proofElement, computedHash));
1379             }
1380         }
1381 
1382         // Check if the computed hash (root) is equal to the provided root
1383         return computedHash == root;
1384     }
1385 }
1386 
1387 /// @title MathBlocks, Primes
1388 /********************************************
1389  * MMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMM *
1390  * MMMMMMMMMMMMNmdddddddddddddddddmNMMMMMMM *
1391  * MMMMMMMMMmhyssooooooooooooooooosyhNMMMMM *
1392  * MMMMMMMmyso+/::::::::::::::::::/osyMMMMM *
1393  * MMMMMMhys+::/+++++++++++++++++/:+syNMMMM *
1394  * MMMMNyso/:/+/::::+/:::/+:::::::+oshMMMMM *
1395  * MMMMmys/-//:/++:/+://-++-+oooossydMMMMMM *
1396  * MMMMNyso+//+s+/:+/:+/:+/:+syddmNMMMMMMMM *
1397  * MMMMMNdyyyyso/:++:/+:/+/:+syNMMMMMMMMMMM *
1398  * MMMMMMMMMhso/:/+/:++:/++-+symMMMMMMMMMMM *
1399  * MMMMMMMMdys+:/++:/++:/++:/+syNMMMMMMMMMM *
1400  * MMMMMMMNys+:/++/:+s+:/+++:/oydMMMMMMMMMM *
1401  * MMMMMMMmys+:/+/:/oso/:///:/sydMMMMMMMMMM *
1402  * MMMMMMMMhso+///+osyso+///osyhMMMMMMMMMMM *
1403  * MMMMMMMMMmhyssyyhmMdhyssyydNMMMMMMMMMMMM *
1404  * MMMMMMMMMMMMMNMMMMMMMMMNMMMMMMMMMMMMMMMM *
1405  *******************************************/
1406 struct CoreData {
1407     bool isPrime;
1408     uint16 primeIndex;
1409     uint8 primeFactorCount;
1410     uint16[2] parents;
1411     uint32 lastBred;
1412 }
1413 
1414 struct RentalData {
1415     bool isRentable;
1416     bool whitelistOnly;
1417     uint96 studFee;
1418     uint32 deadline;
1419     uint16[6] suitors;
1420 }
1421 
1422 struct PrimeData {
1423     uint16[2] sexyPrimes;
1424     uint16[2] twins;
1425     uint16[2] cousins;
1426 }
1427 
1428 struct NumberData {
1429     CoreData core;
1430     PrimeData prime;
1431 }
1432 
1433 struct Activity {
1434     uint8 tranche0;
1435     uint8 tranche1;
1436 }
1437 
1438 enum Attribute {
1439     TAXICAB_NUMBER,
1440     PERFECT_NUMBER,
1441     EULERS_LUCKY_NUMBER,
1442     UNIQUE_PRIME,
1443     FRIENDLY_NUMBER,
1444     COLOSSALLY_ABUNDANT_NUMBER,
1445     FIBONACCI_NUMBER,
1446     REPDIGIT_NUMBER,
1447     WEIRD_NUMBER,
1448     TRIANGULAR_NUMBER,
1449     SOPHIE_GERMAIN_PRIME,
1450     STRONG_PRIME,
1451     FRUGAL_NUMBER,
1452     SQUARE_NUMBER,
1453     EMIRP,
1454     MAGIC_NUMBER,
1455     LUCKY_NUMBER,
1456     GOOD_PRIME,
1457     HAPPY_NUMBER,
1458     UNTOUCHABLE_NUMBER,
1459     SEMIPERFECT_NUMBER,
1460     HARSHAD_NUMBER,
1461     EVIL_NUMBER
1462 }
1463 
1464 contract TokenAttributes {
1465     bytes32 public attributesRootHash;
1466     mapping(uint256 => uint256) internal packedTokenAttrs;
1467 
1468     event RevealedAttributes(uint256 tokenId, uint256 attributes);
1469 
1470     constructor(bytes32 _attributesRootHash) {
1471         attributesRootHash = _attributesRootHash;
1472     }
1473 
1474     /***************************************
1475                     ATTRIBUTES
1476     ****************************************/
1477 
1478     function revealAttributes(
1479         uint256 _tokenId,
1480         uint256 _attributes,
1481         bytes32[] memory _merkleProof
1482     ) public {
1483         bytes32 leaf = keccak256(abi.encodePacked(_tokenId, _attributes));
1484         require(MerkleProof.verify(_merkleProof, attributesRootHash, leaf), "Invalid merkle proof");
1485         packedTokenAttrs[_tokenId] = _attributes;
1486         emit RevealedAttributes(_tokenId, _attributes);
1487     }
1488 
1489     function getAttributes(uint256 _tokenId) public view returns (bool[23] memory attributes) {
1490         uint256 packed = packedTokenAttrs[_tokenId];
1491         for (uint8 i = 0; i < 23; i++) {
1492             attributes[i] = _getAttr(packed, i);
1493         }
1494         return attributes;
1495     }
1496 
1497     function _getAttr(uint256 _packed, uint256 _attribute) internal pure returns (bool attribute) {
1498         uint256 flag = (_packed >> _attribute) & uint256(1);
1499         attribute = flag == 1;
1500     }
1501 }
1502 
1503 library Base64 {
1504     string internal constant TABLE_ENCODE =
1505         "ABCDEFGHIJKLMNOPQRSTUVWXYZabcdefghijklmnopqrstuvwxyz0123456789+/";
1506 
1507     function encode(bytes memory data) internal pure returns (string memory) {
1508         if (data.length == 0) return "";
1509 
1510         // load the table into memory
1511         string memory table = TABLE_ENCODE;
1512 
1513         // multiply by 4/3 rounded up
1514         uint256 encodedLen = 4 * ((data.length + 2) / 3);
1515 
1516         // add some extra buffer at the end required for the writing
1517         string memory result = new string(encodedLen + 32);
1518 
1519         assembly {
1520             // set the actual output length
1521             mstore(result, encodedLen)
1522 
1523             // prepare the lookup table
1524             let tablePtr := add(table, 1)
1525 
1526             // input ptr
1527             let dataPtr := data
1528             let endPtr := add(dataPtr, mload(data))
1529 
1530             // result ptr, jump over length
1531             let resultPtr := add(result, 32)
1532 
1533             // run over the input, 3 bytes at a time
1534             for {
1535 
1536             } lt(dataPtr, endPtr) {
1537 
1538             } {
1539                 // read 3 bytes
1540                 dataPtr := add(dataPtr, 3)
1541                 let input := mload(dataPtr)
1542 
1543                 // write 4 characters
1544                 mstore8(resultPtr, mload(add(tablePtr, and(shr(18, input), 0x3F))))
1545                 resultPtr := add(resultPtr, 1)
1546                 mstore8(resultPtr, mload(add(tablePtr, and(shr(12, input), 0x3F))))
1547                 resultPtr := add(resultPtr, 1)
1548                 mstore8(resultPtr, mload(add(tablePtr, and(shr(6, input), 0x3F))))
1549                 resultPtr := add(resultPtr, 1)
1550                 mstore8(resultPtr, mload(add(tablePtr, and(input, 0x3F))))
1551                 resultPtr := add(resultPtr, 1)
1552             }
1553 
1554             // padding with '='
1555             switch mod(mload(data), 3)
1556             case 1 {
1557                 mstore(sub(resultPtr, 2), shl(240, 0x3d3d))
1558             }
1559             case 2 {
1560                 mstore(sub(resultPtr, 1), shl(248, 0x3d))
1561             }
1562         }
1563 
1564         return result;
1565     }
1566 }
1567 
1568 library PrimesTokenURI {
1569     string internal constant DESCRIPTION = "Primes is MathBlocks Collection #1.";
1570     string internal constant STYLE =
1571         "<style>.p #bg{fill:#ddd} .c #bg{fill:#222} .p .factor,.p #text{fill:#222} .c .factor,.c #text{fill:#ddd} .sexy{fill:#e44C21} .cousin{fill:#348C47} .twin {fill:#3C4CE1} #grid .factor{r: 8} .c #icons *{fill: #ddd} .p #icons * {fill:#222} #icons .stroke *{fill:none} #icons .stroke {fill:none;stroke:#222;stroke-width:8} .c #icons .stroke{stroke:#ddd} .square{stroke-width:2;fill:none;stroke:#222;r:8} .c .square{stroke:#ddd} #icons #i-4 circle{stroke-width:20}</style>";
1572 
1573     function tokenURI(
1574         uint256 _tokenId,
1575         NumberData memory _numberData,
1576         uint16[] memory _factors,
1577         bool[23] memory _attributeValues
1578     ) public pure returns (string memory output) {
1579         string[24] memory parts;
1580 
1581         // 23 attributes revealed with merkle proof
1582         for (uint8 i = 0; i < 23; i++) {
1583             parts[i] = _attributeValues[i]
1584                 ? string(abi.encodePacked('{ "value": "', _attributeNames(i), '" }'))
1585                 : "";
1586         }
1587 
1588         // Last attribute: Unit/Prime/Composite
1589         parts[23] = string(
1590             abi.encodePacked(
1591                 '{ "value": "',
1592                 _tokenId == 1 ? "Unit" : _numberData.core.isPrime ? "Prime" : "Composite",
1593                 '" }'
1594             )
1595         );
1596 
1597         string memory json = string(
1598             abi.encodePacked(
1599                 '{ "name": "Primes #',
1600                 _toString(_tokenId),
1601                 '", "description": "',
1602                 DESCRIPTION,
1603                 '", "attributes": [',
1604                 _getAttributes(parts),
1605                 '], "image": "',
1606                 _getImage(_tokenId, _numberData, _factors, _attributeValues),
1607                 '" }'
1608             )
1609         );
1610 
1611         output = string(
1612             abi.encodePacked("data:application/json;base64,", Base64.encode(bytes(json)))
1613         );
1614     }
1615 
1616     function _getImage(
1617         uint256 _tokenId,
1618         NumberData memory _numberData,
1619         uint16[] memory _factors,
1620         bool[23] memory _attributeValues
1621     ) internal pure returns (string memory output) {
1622         // 350x350 canvas
1623         // padding: 14
1624         // 14x14 grid (bottom row for icons etc)
1625         // grid square: 23
1626         // inner square: 16 (circle r=8)
1627         string memory svg = string(
1628             abi.encodePacked(
1629                 '<svg xmlns="http://www.w3.org/2000/svg" width="350" height="350">',
1630                 _svgContent(_tokenId, _numberData, _factors, _attributeValues),
1631                 "</svg>"
1632             )
1633         );
1634 
1635         output = string(abi.encodePacked("data:image/svg+xml;base64,", Base64.encode(bytes(svg))));
1636     }
1637 
1638     function _svgContent(
1639         uint256 _tokenId,
1640         NumberData memory _numberData,
1641         uint16[] memory _factors,
1642         bool[23] memory _attributeValues
1643     ) internal pure returns (string memory output) {
1644         output = string(
1645             abi.encodePacked(
1646                 STYLE,
1647                 '<g class="',
1648                 _numberData.core.isPrime && _tokenId != 1 ? "p" : "c",
1649                 '"><rect id="bg" width="100%" height="100%" />',
1650                 _circles(_tokenId, _numberData, _factors),
1651                 _text(_tokenId),
1652                 _icons(_tokenId, _numberData.core.isPrime, _attributeValues),
1653                 "</g>"
1654             )
1655         );
1656     }
1657 
1658     function _text(uint256 _tokenId) internal pure returns (string memory output) {
1659         uint256[] memory digits = _getDigits(_tokenId);
1660 
1661         // 16384 has an extra row; move the text to the top right to avoid an overlap
1662         uint256 dx = _tokenId == 16384 ? 277 : 18;
1663         uint256 dy = _tokenId == 16384 ? 18 : 318;
1664 
1665         output = string(
1666             abi.encodePacked(
1667                 '<g id="text" transform="translate(',
1668                 _toString(dx),
1669                 ",",
1670                 _toString(dy),
1671                 ')">',
1672                 _getNumeralPath(digits, 0),
1673                 _getNumeralPath(digits, 1),
1674                 _getNumeralPath(digits, 2),
1675                 _getNumeralPath(digits, 3),
1676                 _getNumeralPath(digits, 4),
1677                 "</g>"
1678             )
1679         );
1680     }
1681 
1682     function _getNumeralPath(uint256[] memory _digits, uint256 _index)
1683         internal
1684         pure
1685         returns (string memory output)
1686     {
1687         if (_digits.length <= _index) {
1688             return output;
1689         }
1690         output = string(
1691             abi.encodePacked(
1692                 '<g transform="translate(',
1693                 _toString(_index * 12),
1694                 ',0)"><path d="',
1695                 _getNumeralPathD(_digits[_index]),
1696                 '" /></g>'
1697             )
1698         );
1699     }
1700 
1701     // Space Mono numerals
1702     function _getNumeralPathD(uint256 _digit) internal pure returns (string memory) {
1703         if (_digit == 0) {
1704             return
1705                 "M0 5.5a6 6 0 0 1 1.3-4C2 .4 3.3 0 4.7 0c1.5 0 2.7.5 3.5 1.4a6 6 0 0 1 1.3 4.1v3c0 1.8-.5 3.2-1.3 4.1-.8 1-2 1.4-3.5 1.4s-2.6-.5-3.5-1.4C.4 11.6 0 10.3 0 8.5v-3Zm4.7 7c1 0 1.8-.3 2.4-1 .5-.8.7-1.8.7-3.1V5.6L7.7 4 7 2.6l-1-.8c-.4-.2-.9-.3-1.4-.3-.5 0-1 0-1.3.3l-1 .8c-.3.4-.5.8-.6 1.3l-.2 1.7v2.8c0 1.3.3 2.3.8 3 .5.8 1.3 1.1 2.3 1.1ZM3.5 7c0-.3.1-.6.4-.9.2-.2.5-.3.8-.3.4 0 .7 0 .9.3.2.3.4.6.4.9 0 .3-.2.6-.4.9-.2.2-.5.3-.9.3-.3 0-.6 0-.8-.3-.3-.3-.4-.6-.4-.9Z";
1706         } else if (_digit == 1) {
1707             return "M4 12.2V1h-.2L1.6 6H0L2.5.2h3.2v12h3.8v1.4H.2v-1.5H4Z";
1708         } else if (_digit == 2) {
1709             return
1710                 "M9.2 12.2v1.5h-9v-2.3c0-.6 0-1.1.2-1.6.2-.4.5-.8.9-1.1.4-.4.8-.7 1.4-.9l1.8-.5c1.1-.3 2-.7 2.5-1.1.5-.5.7-1 .7-1.8l-.1-1.1-.6-1c-.2-.2-.5-.4-1-.5-.3-.2-.7-.3-1.3-.3a3 3 0 0 0-2.3.9c-.5.6-.8 1.4-.8 2.4v.9H0v-1l.3-1.8c.2-.5.5-1 1-1.5.3-.4.8-.8 1.4-1a5 5 0 0 1 2-.4c.8 0 1.5.1 2 .4.6.2 1.1.5 1.5 1 .4.3.7.7.9 1.2.2.5.2 1 .2 1.5v.4c0 1-.3 1.9-1 2.6-.6.7-1.6 1.2-3 1.6-1.2.2-2.1.6-2.7 1-.6.5-.9 1.1-.9 2v.5h7.5Z";
1711         } else if (_digit == 3) {
1712             return
1713                 "M3.3 7V4.8L7.7 2v-.2H.1V.3h9v2.4L4.7 5.5v.3h.8a3.7 3.7 0 0 1 4 3.8v.3a3.8 3.8 0 0 1-1.3 3A4.8 4.8 0 0 1 4.9 14c-.8 0-1.5-.1-2-.3a4.4 4.4 0 0 1-2.5-2.4C0 10.7 0 10.2 0 9.5v-1h1.6v1c0 .4 0 .8.2 1.2l.7 1 1 .6a3.8 3.8 0 0 0 2.5 0 3 3 0 0 0 1-.6c.3-.2.5-.5.6-.9.2-.3.2-.7.2-1v-.2c0-.8-.2-1.4-.7-1.9-.5-.4-1.2-.7-2-.7H3.4Z";
1714         } else if (_digit == 4) {
1715             return "M4.7.3h3.1v9.4H10v1.5H8v2.5H6.1v-2.5H0V9L4.7.3ZM1.4 9.5v.2h4.8V1H6L1.4 9.5Z";
1716         } else if (_digit == 5) {
1717             return
1718                 "M.2 7.4V.3h8.5v1.5H1.8v4.8H2l.5-.8a3.4 3.4 0 0 1 1.7-1l1.1-.2c.7 0 1.2.1 1.7.3a3.9 3.9 0 0 1 2.3 2.2c.2.6.3 1.1.3 1.8v.3c0 .7-.1 1.3-.3 1.9-.2.5-.5 1-1 1.5-.3.4-.8.8-1.4 1a5 5 0 0 1-2 .4c-.8 0-1.5-.1-2.1-.3-.6-.3-1.1-.6-1.5-1-.5-.4-.8-.9-1-1.4C.1 10.7 0 10 0 9.3V9h1.6v.4c0 1 .3 1.9.9 2.4.6.5 1.4.8 2.3.8.6 0 1 0 1.4-.3l1-.7.6-1.1L8 9V9a3 3 0 0 0-.8-2c-.2-.3-.5-.5-.9-.7a2.6 2.6 0 0 0-1.8 0 2 2 0 0 0-.6.2l-.4.4-.2.5h-3Z";
1719         } else if (_digit == 6) {
1720             return
1721                 "M7.5 4.2c0-.8-.3-1.5-.8-2s-1.2-.8-2.1-.8l-1.2.3c-.4.1-.7.3-1 .6a3.2 3.2 0 0 0-.8 2.4v2h.2c.4-.6.8-1 1.4-1.4.5-.3 1.2-.5 1.9-.5.6 0 1.2.1 1.7.4.5.1 1 .4 1.3.8l1 1.4.2 1.9v.2A4.5 4.5 0 0 1 8 12.8c-.4.3-.9.7-1.5.9a5.2 5.2 0 0 1-3.7 0c-.6-.2-1-.5-1.5-1-.4-.3-.7-.8-1-1.3L0 9.6v-5c0-.7.1-1.3.4-1.9.2-.5.5-1 1-1.4.4-.4.9-.8 1.4-1a5.4 5.4 0 0 1 3.6 0 4 4 0 0 1 2.7 3.9H7.5Zm-2.8 8.4c.4 0 .9 0 1.2-.2l1-.7c.3-.2.5-.6.6-1 .2-.3.2-.7.2-1.2v-.2c0-.4 0-.9-.2-1.2a2.7 2.7 0 0 0-1.6-1.6c-.4-.2-.8-.2-1.2-.2a3.1 3.1 0 0 0-2.2.8 3 3 0 0 0-.9 2.1v.4c0 .4 0 .8.2 1.2a2.7 2.7 0 0 0 1.6 1.6l1.3.2Z";
1722         } else if (_digit == 7) {
1723             return
1724                 "M0 .3h9v2.3l-5.7 8.6-.6 1a2 2 0 0 0-.2 1v.5H.9V12.4a3.9 3.9 0 0 1 .7-1.3l.5-.8L7.6 2v-.2H0V.3Z";
1725         } else if (_digit == 8) {
1726             return
1727                 "M4.5 14a6 6 0 0 1-1.8-.3L1.2 13l-.9-1.2c-.2-.4-.3-1-.3-1.5v-.2A3.3 3.3 0 0 1 .8 8a3.3 3.3 0 0 1 1.7-1v-.3a3 3 0 0 1-.8-.4c-.3-.1-.5-.4-.7-.6a3 3 0 0 1-.6-1.9v-.2A3.2 3.2 0 0 1 1.4 1a5.4 5.4 0 0 1 3.1-1h.1C5.4 0 6 0 6.5.3c.5.1 1 .4 1.3.7A3.1 3.1 0 0 1 9 3.5v.2c0 .4 0 .7-.2 1 0 .4-.2.7-.5.9a3 3 0 0 1-.6.6 3 3 0 0 1-.9.4V7a3.7 3.7 0 0 1 1.8 1 3.3 3.3 0 0 1 .7 2.2v.2A3.3 3.3 0 0 1 8.1 13l-1.4.7a6 6 0 0 1-1.9.3h-.3Zm.3-1.5c.9 0 1.6-.2 2.1-.6.6-.5.8-1 .8-1.8V10c0-.8-.3-1.4-.8-1.8-.6-.5-1.3-.7-2.2-.7-1 0-1.7.2-2.3.7-.5.4-.8 1-.8 1.8v.1c0 .7.3 1.3.8 1.8.6.4 1.3.6 2.2.6h.2ZM4.7 6a3 3 0 0 0 2-.6c.4-.5.7-1 .7-1.6v-.1A2 2 0 0 0 6.6 2a3 3 0 0 0-2-.6 3 3 0 0 0-2 .6A2 2 0 0 0 2 3.7c0 .7.2 1.2.7 1.7a3 3 0 0 0 2 .6Z";
1728         } else {
1729             return
1730                 "M1.8 9.8c0 .8.3 1.5.8 2a3 3 0 0 0 2.1.8c.5 0 .9-.1 1.2-.3.4-.1.7-.3 1-.6.3-.3.5-.6.6-1 .2-.4.2-.9.2-1.4v-2h-.2c-.3.6-.7 1-1.3 1.4-.5.3-1.2.5-1.9.5a5 5 0 0 1-1.7-.3A3.8 3.8 0 0 1 .3 6.6C.1 6.1 0 5.5 0 4.8v-.2c0-.7.1-1.3.3-1.9A4.2 4.2 0 0 1 2.8.3 5 5 0 0 1 4.7 0 4.9 4.9 0 0 1 8 1.3c.4.4.8.8 1 1.4.2.5.3 1.1.3 1.8v4.8a5 5 0 0 1-.3 2 4.3 4.3 0 0 1-2.5 2.4 5.5 5.5 0 0 1-3.6 0L1.5 13l-1-1.3-.3-1.8h1.6Zm2.9-8.4c-.5 0-1 .1-1.3.3a2.8 2.8 0 0 0-1.6 1.6l-.2 1.2v.3c0 .4 0 .8.2 1.2l.7 1 1 .5c.3.2.7.2 1.2.2.4 0 .8 0 1.2-.2a3 3 0 0 0 1-.6l.6-1c.2-.3.2-.7.2-1v-.4c0-.5 0-.9-.2-1.2-.1-.4-.3-.7-.6-1-.3-.3-.6-.5-1-.6-.3-.2-.8-.3-1.2-.3Z";
1731         }
1732     }
1733 
1734     function _getIconGeometry(uint256 _attribute) internal pure returns (string memory) {
1735         if (_attribute == 0) {
1736             // Taxicab Number
1737             return
1738                 '<rect y="45" width="15" height="15" rx="2"/><rect x="15" y="30" width="15" height="15" rx="2"/><rect x="30" y="15" width="15" height="15" rx="2"/><path d="M45 2c0-1.1.9-2 2-2h11a2 2 0 0 1 2 2v11a2 2 0 0 1-2 2H47a2 2 0 0 1-2-2V2Z"/><path d="M45 32c0-1.1.9-2 2-2h11a2 2 0 0 1 2 2v11a2 2 0 0 1-2 2H47a2 2 0 0 1-2-2V32Z"/><path d="M30 47c0-1.1.9-2 2-2h11a2 2 0 0 1 2 2v11a2 2 0 0 1-2 2H32a2 2 0 0 1-2-2V47Z"/><path d="M0 17c0-1.1.9-2 2-2h11a2 2 0 0 1 2 2v11a2 2 0 0 1-2 2H2a2 2 0 0 1-2-2V17Z"/><path d="M15 2c0-1.1.9-2 2-2h11a2 2 0 0 1 2 2v11a2 2 0 0 1-2 2H17a2 2 0 0 1-2-2V2Z"/>';
1739         } else if (_attribute == 1) {
1740             // Perfect Number
1741             return
1742                 '<g class="stroke"><path d="m12 12 37 37"/><path d="m12 49 37-37"/><path d="M5.4 30H56"/><path d="M30.7 55.3V4.7"/></g>';
1743         } else if (_attribute == 2) {
1744             // Euler's Lucky Numbers
1745             return
1746                 '<path d="M30.8 7.3c-10 0-15.4 5.9-16.4 17.8 0 .6.3.8 1 .8h29c.6 0 1-.2 1-.8C44.8 13.2 40 7.3 30.7 7.3Zm2.3 52c-8.8 0-15.6-2.4-20.2-7.2C8.3 47 6 39.9 6 30c0-10 2.2-17.3 6.6-22A23.8 23.8 0 0 1 30.8 1C45 1 52.5 9.4 53.4 26.2c0 1.7-.5 3.2-1.8 4.4a6.2 6.2 0 0 1-4.5 1.7h-32c-.5 0-.8.3-.8 1C15 46.5 21.5 53 34 53c4 0 8.3-.8 12.6-2.3.8-.3 1.5-.2 2.3.3.7.4 1 1 1 2 0 2.4-1 4-3.3 4.5-4.6 1.1-9 1.7-13.4 1.7Z"/>';
1747         } else if (_attribute == 3) {
1748             // Unique Prime
1749             return '<circle class="stroke" cx="30" cy="30" r="20"/>';
1750         } else if (_attribute == 4) {
1751             // Friendly Number
1752             return
1753                 '<path fill-rule="evenodd" clip-rule="evenodd" d="M30 60a30 30 0 1 0 0-60 30 30 0 0 0 0 60ZM17.5 31c3.6 0 6.5-4.3 6.5-9.5S21 12 17.5 12c-3.6 0-6.5 4.3-6.5 9.5s3 9.5 6.5 9.5ZM49 21.5c0 5.2-3 9.5-6.5 9.5-3.6 0-6.5-4.3-6.5-9.5s3-9.5 6.5-9.5c3.6 0 6.5 4.3 6.5 9.5Zm-2.8 21.9a4 4 0 1 0-6.4-4.8c-5.1 7-15.2 7.3-20.6 0a4 4 0 0 0-6.4 4.8 20.5 20.5 0 0 0 33.4 0Z"/>';
1754         } else if (_attribute == 5) {
1755             // Colossally Abundant Number
1756             return
1757                 '<path d="M34 4a4 4 0 0 0-8 0v22H4a4 4 0 0 0 0 8h22v22a4 4 0 0 0 8 0V34h22a4 4 0 0 0 0-8H34V4Z"/>';
1758         } else if (_attribute == 6) {
1759             // Fibonacci Number
1760             return
1761                 '<path class="stroke" d="M31.3 23a.6.6 0 0 0 0-.4.6.6 0 0 0-.5-.2h-.3a.8.8 0 0 0-.5.3l-.1.4v.3a1 1 0 0 0 .5.7 1.2 1.2 0 0 0 .9.2l.5-.2.4-.5.2-.5a1.7 1.7 0 0 0-.3-1.3 2 2 0 0 0-1.3-.8h-.9l-.8.4c-.3.1-.5.4-.7.7-.2.3-.3.6-.3 1a3 3 0 0 0 .5 2.2 3.3 3.3 0 0 0 2.2 1.4h1.5a4 4 0 0 0 1.4-.7c.5-.3.9-.7 1.2-1.2a5.1 5.1 0 0 0-.2-5.6 5.8 5.8 0 0 0-3.9-2.4c-.8-.2-1.7-.2-2.6 0a7 7 0 0 0-2.5 1.2 8 8 0 0 0-2 2.1c-.5.9-.9 1.9-1 3a8.8 8.8 0 0 0 1.5 6.7 10 10 0 0 0 6.6 4.1c1.4.3 3 .3 4.4 0a13 13 0 0 0 7.8-5.6c1-1.6 1.6-3.4 2-5.2a15.2 15.2 0 0 0-2.7-11.6 17.2 17.2 0 0 0-11.5-7.2c-2.4-.4-5-.4-7.6.2-2.6.6-5.2 1.7-7.5 3.3a22.6 22.6 0 0 0-6 6.4 24.5 24.5 0 0 0-3.3 8.9A26.3 26.3 0 0 0 11 43a29.7 29.7 0 0 0 19.8 12.4A33.5 33.5 0 0 0 54.2 51"/>';
1762         } else if (_attribute == 7) {
1763             // Repdigit Number
1764             return
1765                 '<g class="stroke"><path d="M44 20.8h13.8V7"/><path d="M12 11a25.4 25.4 0 0 1 36 0l9.8 9.8"/><path d="M16 37.2H2.3V51"/><path d="M48 47a25.4 25.4 0 0 1-36 0l-9.8-9.8"/></g>';
1766         } else if (_attribute == 8) {
1767             // Weird Number
1768             return
1769                 '<path d="M28.8 41.6c-1.8 0-3.3-1.5-3-3.3.1-1.3.4-2.4.7-3.3a17 17 0 0 1 3.6-5.4l4.6-4.7c2-2.3 3-4.7 3-7.2s-.7-4.4-2-5.8c-1.3-1.4-3.2-2.1-5.6-2.1-2.4 0-4.3.6-5.8 1.9-.6.6-1.1 1.2-1.5 2-.8 1.6-2.1 3.1-3.9 3.1-1.8 0-3.3-1.5-2.9-3.2.6-2.4 1.8-4.4 3.7-6 2.7-2.3 6.1-3.5 10.4-3.5 4.4 0 7.9 1.2 10.3 3.6 2.5 2.4 3.7 5.6 3.7 9.8 0 4-1.9 8.1-5.6 12.1l-3.9 3.8a10 10 0 0 0-2.3 5c-.3 1.7-1.7 3.2-3.5 3.2Zm-3.5 11.1c0-1 .3-1.9 1-2.6.6-.7 1.5-1.1 2.8-1.1 1.3 0 2.2.4 2.9 1 .6.8 1 1.7 1 2.7 0 1-.4 2-1 2.7-.7.6-1.6 1-2.9 1-1.3 0-2.2-.4-2.9-1-.6-.7-1-1.6-1-2.7Z"/>';
1770         } else if (_attribute == 9) {
1771             // Triangular Number
1772             return
1773                 '<path d="M2 51 28.2 8.6a2 2 0 0 1 3.4 0L58.1 51a2 2 0 0 1-1.7 3.1H3.6A2 2 0 0 1 2 51Z"/>';
1774         } else if (_attribute == 10) {
1775             // Sophie Germain Prime
1776             return
1777                 '<path d="M11.6 32.2c-4.1-1.4-7-3.1-9-5.1C1 25.1 0 22.7 0 19.9c0-3.2 1-5.8 3-7.6 2-1.9 4.8-2.8 8.3-2.8 3.3 0 6.2.4 8.7 1.2.8.3 1.4.7 1.9 1.5.5.7.7 1.5.7 2.3 0 .6-.3 1.1-.8 1.5-.5.3-1 .3-1.7 0a21 21 0 0 0-8.3-1.7c-1.9 0-3.4.5-4.4 1.5-1 1-1.6 2.3-1.6 4a6 6 0 0 0 1.5 4c1 1.1 2.4 2 4.3 2.6 4.7 1.7 8 3.4 9.8 5.4 1.9 2 2.8 4.5 2.8 7.5 0 3.7-1 6.5-3.3 8.4-2.2 1.9-5.5 2.8-9.9 2.8-2.8 0-5.4-.4-7.7-1.3-1.6-.7-2.5-2-2.5-4 0-.7.3-1.1.8-1.4.6-.3 1-.3 1.6 0a15 15 0 0 0 7.3 1.8c5.2 0 7.8-2.1 7.8-6.3 0-1.6-.5-3-1.6-4.1-1-1.1-2.7-2.1-5.1-3Z"/><path d="M47.6 50.5c-5.5 0-10-1.9-13.5-5.6A20.8 20.8 0 0 1 28.8 30c0-6.3 1.8-11.3 5.3-15 3.6-3.7 8.4-5.5 14.6-5.5 2.5 0 4.8.2 7 .5a3.1 3.1 0 0 1 2.5 3.1c0 .7-.3 1.2-.8 1.6a2 2 0 0 1-1.7.3c-2-.5-4-.7-6.5-.7-4.6 0-8.2 1.4-10.7 4C36 21 34.8 25 34.8 30a17 17 0 0 0 3.7 11.5c2.4 2.8 5.6 4.2 9.7 4.2 2 0 4-.3 5.8-.9.2 0 .3-.2.3-.5V31.5c0-.3-.1-.5-.4-.5H45c-.7 0-1.2-.2-1.7-.6-.4-.5-.6-1-.6-1.7s.2-1.2.6-1.7c.5-.4 1-.7 1.7-.7h11.8a3 3 0 0 1 2.2 1 3 3 0 0 1 .9 2.2v15.4c0 1-.3 1.8-.8 2.6s-1.2 1.3-2 1.6c-2.9 1-6 1.4-9.6 1.4Z"/>';
1778         } else if (_attribute == 11) {
1779             // Strong Prime
1780             return
1781                 '<g class="stroke"><path d="M4 28h52"/><path d="M16 40V15"/><path d="M10 34V21"/><path d="M43.6 40V15"/><path d="M50 34.8V20.2"/></g>';
1782         } else if (_attribute == 12) {
1783             // Frugal Number
1784             return
1785                 '<circle cx="8" cy="29" r="8"/><circle cx="30" cy="29" r="8"/><circle cx="52" cy="29" r="8"/>';
1786         } else if (_attribute == 13) {
1787             // Square Number
1788             return '<rect width="60" height="60" rx="2"/>';
1789         } else if (_attribute == 14) {
1790             // EMIRP
1791             return
1792                 '<path d="m14.8 27.7 21.4-16.1a4 4 0 0 0 1.6-3.2V4a2 2 0 0 0-3.2-1.6L2.3 26.8l-.6.4c-.9.6-1.7 1.2-1.7 2.1 0 .7.3 1.4.7 1.7l33.8 28a2 2 0 0 0 3.3-1.5v-5.1a4 4 0 0 0-1.4-3L14.7 30.8a2 2 0 0 1 .1-3.2ZM59.8 5v52.6a2 2 0 0 1-3.3 1.5L22.7 31a2 2 0 0 1 0-3l34-25.7c1.2-1 3.1 1 3.1 2.6Z"/>';
1793         } else if (_attribute == 15) {
1794             // Magic Number
1795             return
1796                 '<path d="M28.1 2.9a2 2 0 0 1 3.8 0l5.5 16.9a2 2 0 0 0 2 1.4H57a2 2 0 0 1 1.2 3.6L44 35.3a2 2 0 0 0-.7 2.2l5.5 17a2 2 0 0 1-3.1 2.2L31.2 46.2a2 2 0 0 0-2.4 0L14.4 56.7a2 2 0 0 1-3-2.2l5.4-17a2 2 0 0 0-.7-2.2L1.7 24.8a2 2 0 0 1 1.2-3.6h17.8a2 2 0 0 0 1.9-1.4l5.5-17Z"/>';
1797         } else if (_attribute == 16) {
1798             // Lucky Number
1799             return
1800                 '<path d="M31.3 23.8a2 2 0 0 1-2.6 0C20.3 16.4 16 12.4 16 7.5 16 3.4 19.3 0 23.5 0a9 9 0 0 1 4.8 1.3c1 .7 2.4.7 3.4 0C33 .5 34.7 0 36.3 0 40.5 0 44 3.2 44 7.3c0 5-4.3 9.1-12.7 16.5Z"/><path d="M23.8 28.7C16.4 20.3 12.4 16 7.3 16c-4 0-7.3 3.5-7.3 7.7 0 1.7.5 3.3 1.3 4.6.7 1 .7 2.4 0 3.4A9 9 0 0 0 0 36.5C0 40.7 3.4 44 7.5 44c4.9 0 9-4.3 16.3-12.7a2 2 0 0 0 0-2.6Z"/><path d="M52.7 44c-5 0-9.1-4.3-16.5-12.7a2 2 0 0 1 0-2.6C43.6 20.3 47.6 16 52.5 16c4 0 7.5 3.3 7.5 7.5a9 9 0 0 1-1.3 4.8c-.7 1-.7 2.4 0 3.4.8 1.3 1.3 3 1.3 4.6 0 4.2-3.2 7.7-7.3 7.7Z"/><path d="M28.7 36.2C20.3 43.6 16 47.6 16 52.7c0 4 3.5 7.3 7.7 7.3 1.7 0 3.3-.5 4.6-1.3 1-.7 2.4-.7 3.4 0a9 9 0 0 0 4.8 1.3c4.2 0 7.5-3.4 7.5-7.5 0-4.9-4.3-9-12.7-16.3a2 2 0 0 0-2.6 0Z"/>';
1801         } else if (_attribute == 17) {
1802             // Good Prime
1803             return
1804                 '<path fill-rule="evenodd" clip-rule="evenodd" d="M56.6 8.3c2 1.4 2.5 4.2 1 6.3l-29.2 42a4.5 4.5 0 0 1-7.3.1L2.4 32.2a4.5 4.5 0 1 1 7.2-5.4l15 19.6 25.7-37c1.4-2 4.2-2.5 6.3-1Z"/>';
1805         } else if (_attribute == 18) {
1806             // Happy Number
1807             return
1808                 '<path fill-rule="evenodd" clip-rule="evenodd" d="M30 60a30 30 0 1 0 0-60 30 30 0 0 0 0 60ZM17.5 23c5 0 6.5 3.7 6.5-1.5S21 12 17.5 12c-3.6 0-6.5 4.3-6.5 9.5s1.5 1.5 6.5 1.5ZM49 21.5c0 5.2-2 1.5-6.5 1.5-5 0-6.5 3.7-6.5-1.5s3-9.5 6.5-9.5c3.6 0 6.5 4.3 6.5 9.5Zm-2.8 21.9c1.3-1.8 1.4-5.6-.8-5.6H13.6a4 4 0 0 0-.8 5.6 20.5 20.5 0 0 0 33.4 0Z"/>';
1809         } else if (_attribute == 19) {
1810             // Untouchable Number
1811             return
1812                 '<path d="M8.8 2.2a4 4 0 0 0-5.6 5.6l21.6 21.7L3.2 51.2a4 4 0 1 0 5.6 5.6l21.7-21.6 21.7 21.6a4 4 0 1 0 5.6-5.6L36.2 29.5 57.8 7.8a4 4 0 1 0-5.6-5.6L30.5 23.8 8.8 2.2Z"/>';
1813         } else if (_attribute == 20) {
1814             // Semiperfect Number
1815             return
1816                 '<path fill-rule="evenodd" clip-rule="evenodd" d="M42.7 1a4 4 0 0 1 4 4v50.6a4 4 0 1 1-8 0V40.2l-11.9 12a4 4 0 1 1-5.6-5.7l12.1-12.2H17a4 4 0 0 1 0-8h15.3L21.2 15a4 4 0 1 1 5.6-5.6l12 11.8V5a4 4 0 0 1 4-4Z"/>';
1817         } else if (_attribute == 21) {
1818             // Harshad Number
1819             return
1820                 '<path d="M16 8A8 8 0 1 1 0 8a8 8 0 0 1 16 0Z"/><path d="M3.2 57.8a4 4 0 0 1 0-5.6l49-49a4 4 0 0 1 5.6 5.6l-49 49a4 4 0 0 1-5.6 0Z"/><path d="M52 60a8 8 0 1 0 0-16 8 8 0 0 0 0 16Z"/>';
1821         } else if (_attribute == 22) {
1822             // Evil Number
1823             return
1824                 '<path d="M28.3 2.6 23 11a2 2 0 0 0 1.7 3.1H26v12h-7a6 6 0 0 1-6-6v-6h.4a2 2 0 0 0 1.8-3L13 7.4V7h-.3l-2.5-4.2a2 2 0 0 0-3.4 0l-5 8.2a2 2 0 0 0 1.8 3H5v6a14 14 0 0 0 14 14h7v22a4 4 0 1 0 8 0V34h8a14 14 0 0 0 14-14v-6h.4a2 2 0 0 0 1.8-3L56 7.4V7h-.3l-2.5-4.2a2 2 0 0 0-3.4 0l-5 8.2a2 2 0 0 0 1.8 3H48v6a6 6 0 0 1-6 6h-8V14h1.3a2 2 0 0 0 1.7-3l-5.3-8.4a2 2 0 0 0-3.4 0Z"/>';
1825         } else if (_attribute == 23) {
1826             // Unit
1827             return
1828                 '<path d="M30-.5c.7 0 1.4.2 2 .5h12a4 4 0 0 1 0 8h-9.5v44H44a4 4 0 0 1 0 8H32a4.5 4.5 0 0 1-4 0H17a4 4 0 0 1 0-8h8.5V8H17a4 4 0 0 1 0-8h11c.6-.3 1.3-.5 2-.5Z"/>';
1829         } else if (_attribute == 24) {
1830             // Prime
1831             return '<circle cx="30" cy="30" r="30"/>';
1832         } else {
1833             // Composite
1834             return '<circle class="stroke" cx="30" cy="30" r="26"/>';
1835         }
1836     }
1837 
1838     function _icons(
1839         uint256 _tokenId,
1840         bool _isPrime,
1841         bool[23] memory _attributeValues
1842     ) internal pure returns (string memory output) {
1843         string memory icons;
1844         uint256 count = 0;
1845         for (uint256 i = 24; i > 0; i--) {
1846             string memory icon;
1847 
1848             if (i == 24) {
1849                 uint256 specialIdx = _tokenId == 1 ? 23 : _isPrime ? 24 : 25;
1850                 icon = _getIconGeometry(specialIdx);
1851             } else if (_attributeValues[i - 1]) {
1852                 icon = _getIconGeometry(i - 1);
1853             } else {
1854                 continue;
1855             }
1856 
1857             // icon geom width = 60
1858             // scale = 16/60 = 0.266
1859             // spacing = (60/16) * 23 = 86.25
1860             uint256 x = ((count * 1e2) * (8625)) / 1e2;
1861             icons = string(
1862                 abi.encodePacked(
1863                     icons,
1864                     '<g id="i-',
1865                     _toString(i),
1866                     '" transform="scale(.266) translate(-',
1867                     _toDecimalString(x, 2),
1868                     ',0)">',
1869                     icon,
1870                     "</g>"
1871                 )
1872             );
1873             count = count + 1;
1874         }
1875         output = string(
1876             abi.encodePacked('<g id="icons" transform="translate(317,317)">', icons, "</g>")
1877         );
1878     }
1879 
1880     function _circles(
1881         uint256 _tokenId,
1882         NumberData memory _numberData,
1883         uint16[] memory _factors
1884     ) internal pure returns (string memory output) {
1885         uint256 nFactor = _factors.length;
1886         string memory factorStr;
1887         string memory twinStr;
1888         string memory cousinStr;
1889         string memory sexyStr;
1890         string memory squareStr;
1891 
1892         {
1893             bool[14][] memory factorRows = _getBitRows(_factors);
1894             for (uint256 i = 0; i < nFactor; i++) {
1895                 for (uint256 j = 0; j < 14; j++) {
1896                     if (factorRows[i][j]) {
1897                         factorStr = string(abi.encodePacked(factorStr, _circle(j, i, "factor")));
1898                     }
1899                 }
1900             }
1901         }
1902 
1903         {
1904             uint16[] memory squares = _getSquares(_tokenId);
1905             bool[14][] memory squareRows = _getBitRows(squares);
1906 
1907             for (uint256 i = 0; i < squareRows.length; i++) {
1908                 for (uint256 j = 0; j < 14; j++) {
1909                     if (squareRows[i][j]) {
1910                         squareStr = string(
1911                             abi.encodePacked(squareStr, _circle(j, nFactor + i, "square"))
1912                         );
1913                     }
1914                 }
1915             }
1916             squareStr = string(abi.encodePacked('<g opacity=".2">', squareStr, "</g>"));
1917         }
1918 
1919         {
1920             bool[14][] memory twinRows = _getBitRows(_numberData.prime.twins);
1921             bool[14][] memory cousinRows = _getBitRows(_numberData.prime.cousins);
1922             bool[14][] memory sexyRows = _getBitRows(_numberData.prime.sexyPrimes);
1923 
1924             for (uint256 i = 0; i < 2; i++) {
1925                 for (uint256 j = 0; j < 14; j++) {
1926                     if (twinRows[i][j]) {
1927                         twinStr = string(
1928                             abi.encodePacked(twinStr, _circle(j, nFactor + i, "twin"))
1929                         );
1930                     }
1931                     if (cousinRows[i][j]) {
1932                         cousinStr = string(
1933                             abi.encodePacked(cousinStr, _circle(j, nFactor + 2 + i, "cousin"))
1934                         );
1935                     }
1936                     if (sexyRows[i][j]) {
1937                         sexyStr = string(
1938                             abi.encodePacked(sexyStr, _circle(j, nFactor + 4 + i, "sexy"))
1939                         );
1940                     }
1941                 }
1942             }
1943         }
1944 
1945         output = string(
1946             abi.encodePacked(
1947                 '<g id="grid" transform="translate(26,26)">',
1948                 squareStr,
1949                 twinStr,
1950                 cousinStr,
1951                 sexyStr,
1952                 factorStr,
1953                 "</g>"
1954             )
1955         );
1956     }
1957 
1958     function _getSquares(uint256 _tokenId) internal pure returns (uint16[] memory) {
1959         uint16[] memory squares = new uint16[](14);
1960         if (_tokenId > 1) {
1961             for (uint256 i = 0; i < 14; i++) {
1962                 uint256 square = _tokenId**(i + 2);
1963                 if (square > 16384) {
1964                     break;
1965                 }
1966                 squares[i] = uint16(square);
1967             }
1968         }
1969         return squares;
1970     }
1971 
1972     function _circle(
1973         uint256 _xIndex,
1974         uint256 _yIndex,
1975         string memory _class
1976     ) internal pure returns (string memory output) {
1977         string memory duration;
1978 
1979         uint256 index = (_yIndex * 14) + _xIndex + 1;
1980         if (index == 1) {
1981             duration = "40";
1982         } else {
1983             uint256 reciprocal = (1e6 * 1e6) / (1e6 * index);
1984             duration = _toDecimalString(reciprocal * 40, 6);
1985         }
1986 
1987         output = string(
1988             abi.encodePacked(
1989                 '<circle r="8" cx="',
1990                 _toString(23 * _xIndex),
1991                 '" cy="',
1992                 _toString(23 * _yIndex),
1993                 '" class="',
1994                 _class,
1995                 '">',
1996                 '<animate attributeName="opacity" values="1;.3;1" dur="',
1997                 duration,
1998                 's" repeatCount="indefinite"/>',
1999                 "</circle>"
2000             )
2001         );
2002     }
2003 
2004     function _getBits(uint16 _input) internal pure returns (bool[14] memory) {
2005         bool[14] memory bits;
2006         for (uint8 i = 0; i < 14; i++) {
2007             uint16 flag = (_input >> i) & uint16(1);
2008             bits[i] = flag == 1;
2009         }
2010         return bits;
2011     }
2012 
2013     function _getBitRows(uint16[] memory _inputs) internal pure returns (bool[14][] memory) {
2014         bool[14][] memory rows = new bool[14][](_inputs.length);
2015         for (uint8 i = 0; i < _inputs.length; i++) {
2016             rows[i] = _getBits(_inputs[i]);
2017         }
2018         return rows;
2019     }
2020 
2021     function _getBitRows(uint16[2] memory _inputs) internal pure returns (bool[14][] memory) {
2022         bool[14][] memory rows = new bool[14][](_inputs.length);
2023         for (uint8 i = 0; i < _inputs.length; i++) {
2024             rows[i] = _getBits(_inputs[i]);
2025         }
2026         return rows;
2027     }
2028 
2029     function _getAttributes(string[24] memory _parts) internal pure returns (string memory output) {
2030         for (uint256 i = 0; i < _parts.length; i++) {
2031             string memory input = _parts[i];
2032 
2033             if (bytes(input).length == 0) {
2034                 continue;
2035             }
2036 
2037             output = string(abi.encodePacked(output, bytes(output).length > 0 ? "," : "", input));
2038         }
2039         return output;
2040     }
2041 
2042     function _getDigits(uint256 _value) internal pure returns (uint256[] memory) {
2043         if (_value == 0) {
2044             uint256[] memory zero = new uint256[](1);
2045             return zero;
2046         }
2047         uint256 temp = _value;
2048         uint256 digits;
2049         while (temp != 0) {
2050             digits++;
2051             temp /= 10;
2052         }
2053         uint256[] memory result = new uint256[](digits);
2054         temp = _value;
2055         while (temp != 0) {
2056             digits -= 1;
2057             result[digits] = uint256(temp % 10);
2058             temp /= 10;
2059         }
2060         return result;
2061     }
2062 
2063     function _toString(uint256 _value) internal pure returns (string memory) {
2064         uint256[] memory digits = _getDigits(uint256(_value));
2065         bytes memory buffer = new bytes(digits.length);
2066         for (uint256 i = 0; i < digits.length; i++) {
2067             buffer[i] = bytes1(uint8(48 + digits[i]));
2068         }
2069         return string(buffer);
2070     }
2071 
2072     function _toDecimalString(uint256 _value, uint256 _decimals)
2073         internal
2074         pure
2075         returns (string memory)
2076     {
2077         if (_decimals == 0 || _value == 0) {
2078             return _toString(_value);
2079         }
2080 
2081         uint256[] memory digits = _getDigits(_value);
2082         uint256 len = digits.length;
2083         bool undersized = len <= _decimals;
2084 
2085         // Index of the decimal point
2086         uint256 ptIdx = undersized ? 1 : len - _decimals;
2087 
2088         // Leading zeroes
2089         uint256 leading = undersized ? 1 + (_decimals - len) : 0;
2090 
2091         // Create buffer for total length
2092         uint256 bufferLen = len + 1 + leading;
2093         bytes memory buffer = new bytes(bufferLen);
2094         uint256 offset = 0;
2095 
2096         // Fill buffer
2097         for (uint256 i = 0; i < bufferLen; i++) {
2098             if (i == ptIdx) {
2099                 // Add decimal point
2100                 buffer[i] = bytes1(uint8(46));
2101                 offset++;
2102             } else if (leading > 0 && i <= leading) {
2103                 // Add leading zero
2104                 buffer[i] = bytes1(uint8(48));
2105                 offset++;
2106             } else {
2107                 // Add digit with index offset for added bytes
2108                 buffer[i] = bytes1(uint8(48 + digits[i - offset]));
2109             }
2110         }
2111 
2112         return string(buffer);
2113     }
2114 
2115     function _attributeNames(uint256 _i) internal pure returns (string memory) {
2116         string[23] memory attributeNames = [
2117             "Taxicab",
2118             "Perfect",
2119             "Euler's Lucky Number",
2120             "Unique Prime",
2121             "Friendly",
2122             "Colossally Abundant",
2123             "Fibonacci",
2124             "Repdigit",
2125             "Weird",
2126             "Triangular",
2127             "Sophie Germain Prime",
2128             "Strong Prime",
2129             "Frugal",
2130             "Square",
2131             "Emirp",
2132             "Magic",
2133             "Lucky",
2134             "Good Prime",
2135             "Happy",
2136             "Untouchable",
2137             "Semiperfect",
2138             "Harshad",
2139             "Evil"
2140         ];
2141         return attributeNames[_i];
2142     }
2143 }
2144 
2145 // SPDX-License-Identifier: GPL-3.0
2146 /// @title MathBlocks, Primes
2147 /********************************************
2148  * MMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMM *
2149  * MMMMMMMMMMMMNmdddddddddddddddddmNMMMMMMM *
2150  * MMMMMMMMMmhyssooooooooooooooooosyhNMMMMM *
2151  * MMMMMMMmyso+/::::::::::::::::::/osyMMMMM *
2152  * MMMMMMhys+::/+++++++++++++++++/:+syNMMMM *
2153  * MMMMNyso/:/+/::::+/:::/+:::::::+oshMMMMM *
2154  * MMMMmys/-//:/++:/+://-++-+oooossydMMMMMM *
2155  * MMMMNyso+//+s+/:+/:+/:+/:+syddmNMMMMMMMM *
2156  * MMMMMNdyyyyso/:++:/+:/+/:+syNMMMMMMMMMMM *
2157  * MMMMMMMMMhso/:/+/:++:/++-+symMMMMMMMMMMM *
2158  * MMMMMMMMdys+:/++:/++:/++:/+syNMMMMMMMMMM *
2159  * MMMMMMMNys+:/++/:+s+:/+++:/oydMMMMMMMMMM *
2160  * MMMMMMMmys+:/+/:/oso/:///:/sydMMMMMMMMMM *
2161  * MMMMMMMMhso+///+osyso+///osyhMMMMMMMMMMM *
2162  * MMMMMMMMMmhyssyyhmMdhyssyydNMMMMMMMMMMMM *
2163  * MMMMMMMMMMMMMNMMMMMMMMMNMMMMMMMMMMMMMMMM *
2164  *******************************************/
2165 contract Primes is ERC721Tradable, ReentrancyGuard, TokenAttributes {
2166     using Packed16BitArray for Packed16BitArray.PackedArray;
2167 
2168     // Periods
2169     uint256 internal constant RESCUE_SALE_GRACE_PERIOD = 48 hours;
2170     uint256 internal constant WHITELIST_ONLY_PERIOD = 24 hours;
2171     uint256 internal constant BATCH_0_GRACE_PERIOD = 2 hours;
2172     uint256 internal constant BATCH_1_GRACE_PERIOD = 2 hours;
2173     uint256 internal constant BATCH_2_GRACE_PERIOD = 12 hours;
2174 
2175     // Prices: 0.05 ETH for FLC, 0.075 for EGS
2176     uint256 internal constant BATCH_0_PRICE = 5e16;
2177     uint256 internal constant BATCH_1_PRICE = 75e15;
2178 
2179     Packed16BitArray.PackedArray internal packedPrimes;
2180 
2181     Packed16BitArray.PackedArray internal batch0;
2182     Packed16BitArray.PackedArray internal batch1;
2183     Packed16BitArray.PackedArray internal batch2;
2184 
2185     bytes32 public whitelistRootHash;
2186 
2187     mapping(uint256 => CoreData) public data;
2188     mapping(uint256 => RentalData) public rental;
2189     mapping(address => Activity) public users;
2190 
2191     address public auctionHouse;
2192 
2193     uint256 public batchStartTime;
2194     uint256 public nonce;
2195     address public immutable setupAddr;
2196     uint256 public immutable BREEDING_COOLDOWN;
2197 
2198     event Initialized();
2199     event PrimeClaimed(uint256 tokenId);
2200     event BatchStarted(uint256 batchId);
2201     event Bred(uint16 tokenId, uint256 parent1, uint256 parent2);
2202     event Listed(uint16 tokenId);
2203     event UnListed(uint16 tokenId);
2204 
2205     constructor(
2206         address _dao,
2207         uint256 _breedCooldown,
2208         address _proxyRegistryAddress,
2209         bytes32 _attributesRootHash,
2210         bytes32 _whitelistRootHash
2211     )
2212         ERC721Tradable("Primes", "PRIME", _proxyRegistryAddress)
2213         TokenAttributes(_attributesRootHash)
2214     {
2215         setupAddr = msg.sender;
2216         transferOwnership(_dao);
2217         BREEDING_COOLDOWN = _breedCooldown;
2218         whitelistRootHash = _whitelistRootHash;
2219     }
2220 
2221     /***************************************
2222                     VIEWS
2223     ****************************************/
2224 
2225     function fetchPrime(uint256 _index) public view returns (uint16 primeNumber) {
2226         return packedPrimes.getValue(_index);
2227     }
2228 
2229     function getNumberData(uint256 _tokenId) public view returns (NumberData memory) {
2230         require(_tokenId <= 2**14, "Number too large");
2231         CoreData memory core = data[_tokenId];
2232         return
2233             NumberData({
2234                 core: core,
2235                 prime: PrimeData({
2236                     sexyPrimes: sexyPrimes(core.primeIndex),
2237                     twins: twins(core.primeIndex),
2238                     cousins: cousins(core.primeIndex)
2239                 })
2240             });
2241     }
2242 
2243     function getSuitors(uint256 _tokenId) public view returns (uint16[6] memory) {
2244         return rental[_tokenId].suitors;
2245     }
2246 
2247     function getParents(uint256 _tokenId) public view returns (uint16[2] memory) {
2248         return data[_tokenId].parents;
2249     }
2250 
2251     /***************************************
2252                     BREEDING
2253     ****************************************/
2254 
2255     function breedPrimes(
2256         uint16 _parent1,
2257         uint16 _parent2,
2258         uint256 _attributes,
2259         bytes32[] memory _merkleProof
2260     ) external nonReentrant {
2261         BreedInput memory input1 = _getInput(_parent1);
2262         BreedInput memory input2 = _getInput(_parent2);
2263         require(input1.owns && input2.owns, "Breeder must own input token");
2264         _breed(input1, input2, _attributes, _merkleProof);
2265     }
2266 
2267     function crossBreed(
2268         uint16 _parent1,
2269         uint16 _parent2,
2270         uint256 _attributes,
2271         bytes32[] memory _merkleProof
2272     ) external payable nonReentrant {
2273         BreedInput memory input1 = _getInput(_parent1);
2274         BreedInput memory input2 = _getInput(_parent2);
2275         require(input1.owns, "Must own first input");
2276         require(input2.rentalData.isRentable, "Must be rentable");
2277         require(msg.value >= input2.rentalData.studFee, "Must pay stud fee");
2278         payable(input2.owner).transfer((msg.value * 9) / 10);
2279         require(block.timestamp < input2.rentalData.deadline, "Rental passed deadline");
2280         if (input2.rentalData.whitelistOnly) {
2281             bool isSuitor;
2282             for (uint256 i = 0; i < 6; i++) {
2283                 isSuitor = isSuitor || input2.rentalData.suitors[i] == _parent1;
2284             }
2285             require(isSuitor, "Must be whitelisted suitor");
2286         }
2287         _breed(input1, input2, _attributes, _merkleProof);
2288     }
2289 
2290     function _breed(
2291         BreedInput memory _input1,
2292         BreedInput memory _input2,
2293         uint256 _attributes,
2294         bytes32[] memory _merkleProof
2295     ) internal {
2296         // VALIDATION
2297         // 1. Check less than max uint16
2298         uint256 childVal = uint256(_input1.id) * uint256(_input2.id);
2299         require(childVal <= 2**14, "Number too large");
2300         uint16 scaledVal = uint16(childVal);
2301 
2302         // 2. Number doesn't exist
2303         require(!_exists(scaledVal), "Number already taken");
2304 
2305         // 3. Tokens passed cooldown
2306         require(
2307             block.timestamp > _input1.tokenData.lastBred + BREEDING_COOLDOWN &&
2308                 block.timestamp > _input2.tokenData.lastBred + BREEDING_COOLDOWN,
2309             "Cannot breed so quickly"
2310         );
2311 
2312         // 4. Composites can't self-breed
2313         require(
2314             !(_input1.id == _input2.id && !_input1.tokenData.isPrime),
2315             "Composites cannot self-breed"
2316         );
2317 
2318         // Breed
2319         data[_input1.id].lastBred = uint32(block.timestamp);
2320         data[_input2.id].lastBred = uint32(block.timestamp);
2321         data[scaledVal] = CoreData({
2322             isPrime: false,
2323             primeIndex: 0,
2324             primeFactorCount: _input1.tokenData.primeFactorCount +
2325                 _input2.tokenData.primeFactorCount,
2326             parents: [_input1.id, _input2.id],
2327             lastBred: uint32(block.timestamp)
2328         });
2329         _safeMint(msg.sender, scaledVal);
2330         if (_attributes > 0) {
2331             revealAttributes(scaledVal, _attributes, _merkleProof);
2332         }
2333         _burnAfterBreeding(_input1, _input2);
2334 
2335         emit Bred(scaledVal, _input1.id, _input2.id);
2336     }
2337 
2338     function _burnAfterBreeding(BreedInput memory _input1, BreedInput memory _input2) internal {
2339         // Both primes, no burn
2340         if (_input1.tokenData.isPrime && _input2.tokenData.isPrime) return;
2341         // One prime,
2342         if (_input1.tokenData.isPrime) {
2343             require(_input2.owns, "Breeder must own burning");
2344             _burn(_input2.id);
2345         } else if (_input2.tokenData.isPrime) {
2346             require(_input1.owns, "Breeder must own burning");
2347             _burn(_input1.id);
2348         }
2349         // No primes, both burn
2350         else {
2351             require(_input1.owns && _input2.owns, "Breeder must own burning");
2352             _burn(_input1.id);
2353             _burn(_input2.id);
2354         }
2355     }
2356 
2357     function list(
2358         uint16 _tokenId,
2359         uint96 _fee,
2360         uint32 _deadline,
2361         uint16[] memory _suitors
2362     ) external {
2363         require(msg.sender == ownerOf(_tokenId), "Must own said token");
2364 
2365         uint16[6] memory suitors;
2366         uint256 len = _suitors.length;
2367         if (len > 0) {
2368             require(len < 6, "Max 6 suitors");
2369             for (uint256 i = 0; i < len; i++) {
2370                 suitors[i] = _suitors[i];
2371             }
2372         }
2373 
2374         rental[_tokenId] = RentalData({
2375             isRentable: true,
2376             whitelistOnly: len > 0,
2377             studFee: _fee,
2378             deadline: _deadline,
2379             suitors: suitors
2380         });
2381 
2382         emit Listed(_tokenId);
2383     }
2384 
2385     function unlist(uint16 _tokenId) external {
2386         require(msg.sender == ownerOf(_tokenId), "Must own said token");
2387 
2388         uint16[6] memory empty6;
2389         rental[_tokenId] = RentalData(false, false, 0, 0, empty6);
2390 
2391         emit UnListed(_tokenId);
2392     }
2393 
2394     struct BreedInput {
2395         bool owns;
2396         address owner;
2397         uint16 id;
2398         CoreData tokenData;
2399         RentalData rentalData;
2400     }
2401 
2402     function _getInput(uint16 _breedInput) internal view returns (BreedInput memory) {
2403         address owner = ownerOf(_breedInput);
2404         return
2405             BreedInput({
2406                 owns: owner == msg.sender,
2407                 owner: owner,
2408                 id: _breedInput,
2409                 tokenData: data[_breedInput],
2410                 rentalData: rental[_breedInput]
2411             });
2412     }
2413 
2414     function _beforeTokenTransfer(
2415         address from,
2416         address to,
2417         uint256 tokenId
2418     ) internal virtual override {
2419         super._beforeTokenTransfer(from, to, tokenId);
2420         uint16[6] memory empty6;
2421         rental[tokenId] = RentalData(false, false, 0, 0, empty6);
2422     }
2423 
2424     /***************************************
2425                     TOKEN URI
2426     ****************************************/
2427 
2428     function tokenURI(uint256 _tokenId) public view override returns (string memory output) {
2429         NumberData memory numberData = getNumberData(_tokenId);
2430         bool[23] memory attributeValues = getAttributes(_tokenId);
2431         uint16[] memory factors = getPrimeFactors(uint16(_tokenId), numberData);
2432         return PrimesTokenURI.tokenURI(_tokenId, numberData, factors, attributeValues);
2433     }
2434 
2435     function getPrimeFactors(uint16 _tokenId, NumberData memory _numberData)
2436         public
2437         view
2438         returns (uint16[] memory factors)
2439     {
2440         factors = _getFactors(_tokenId, _numberData.core);
2441         factors = _insertion(factors);
2442     }
2443 
2444     function _getFactors(uint16 _tokenId, CoreData memory _core)
2445         internal
2446         view
2447         returns (uint16[] memory factors)
2448     {
2449         if (_core.isPrime) {
2450             factors = new uint16[](1);
2451             factors[0] = _tokenId;
2452         } else {
2453             uint16[] memory parent1Factors = _getFactors(_core.parents[0], data[_core.parents[0]]);
2454             uint256 len1 = parent1Factors.length;
2455             uint16[] memory parent2Factors = _getFactors(_core.parents[1], data[_core.parents[1]]);
2456             uint256 len2 = parent2Factors.length;
2457             factors = new uint16[](len1 + len2);
2458             for (uint256 i = 0; i < len1; i++) {
2459                 factors[i] = parent1Factors[i];
2460             }
2461             for (uint256 i = 0; i < len2; i++) {
2462                 factors[len1 + i] = parent2Factors[i];
2463             }
2464         }
2465     }
2466 
2467     function _insertion(uint16[] memory _arr) internal pure returns (uint16[] memory) {
2468         uint256 length = _arr.length;
2469         for (uint256 i = 1; i < length; i++) {
2470             uint16 key = _arr[i];
2471             uint256 j = i - 1;
2472             while ((int256(j) >= 0) && (_arr[j] > key)) {
2473                 _arr[j + 1] = _arr[j];
2474                 unchecked {
2475                     j--;
2476                 }
2477             }
2478             unchecked {
2479                 _arr[j + 1] = key;
2480             }
2481         }
2482         return _arr;
2483     }
2484 
2485     function sexyPrimes(uint256 _primeIndex) public view returns (uint16[2] memory matches) {
2486         if (_primeIndex > 0) {
2487             matches = packedPrimes.biDirectionalSearch(_primeIndex, 6);
2488             if (_primeIndex == 4) {
2489                 // 7: 1 is not prime but is in packedPrimes; exclude it here
2490                 matches[0] = 0;
2491             }
2492         }
2493     }
2494 
2495     function twins(uint256 _primeIndex) public view returns (uint16[2] memory matches) {
2496         if (_primeIndex > 0) {
2497             matches = packedPrimes.biDirectionalSearch(_primeIndex, 2);
2498             if (_primeIndex == 2) {
2499                 // 3: 1 is not prime but is in packedPrimes; exclude it here
2500                 matches[0] = 0;
2501             }
2502         }
2503     }
2504 
2505     function cousins(uint256 _primeIndex) public view returns (uint16[2] memory matches) {
2506         if (_primeIndex > 0) {
2507             matches = packedPrimes.biDirectionalSearch(_primeIndex, 4);
2508             if (_primeIndex == 3) {
2509                 // 5: 1 is not prime but is in packedPrimes; exclude it here
2510                 matches[0] = 0;
2511             }
2512         }
2513     }
2514 
2515     /***************************************
2516                     MINTING
2517     ****************************************/
2518 
2519     function mintRandomPrime(
2520         uint256 _batch0Cap,
2521         uint256 _batch1Cap,
2522         bytes32[] memory _merkleProof
2523     ) external payable {
2524         mintRandomPrimes(1, _batch0Cap, _batch1Cap, _merkleProof);
2525     }
2526 
2527     function mintRandomPrimes(
2528         uint256 _count,
2529         uint256 _batch0Cap,
2530         uint256 _batch1Cap,
2531         bytes32[] memory _merkleProof
2532     ) public payable nonReentrant {
2533         (bool active, uint256 batchId, uint256 remaining, ) = batchCheck();
2534         require(active && batchId < 2, "Batch not active");
2535         require(remaining >= _count, "Not enough Primes available");
2536         require(_count <= 20, "Cannot mint >20 Primes at once");
2537 
2538         uint256 unitPrice = batchId == 0 ? BATCH_0_PRICE : BATCH_1_PRICE;
2539         require(msg.value >= _count * unitPrice, "Requires value");
2540 
2541         _validateUser(batchId, _count, _batch0Cap, _batch1Cap, _merkleProof);
2542         for (uint256 i = 0; i < _count; i++) {
2543             _getPrime(batchId);
2544         }
2545     }
2546 
2547     function getNextPrime() external nonReentrant returns (uint256 tokenId) {
2548         require(msg.sender == auctionHouse, "Must be the auctioneer");
2549 
2550         (bool active, uint256 batchId, uint256 remaining, ) = batchCheck();
2551         require(active && batchId == 2, "Batch not active");
2552         require(remaining > 0, "No more Primes");
2553 
2554         uint256 idx = batch2.length - 1;
2555         uint16 primeIndex = batch2.getValue(idx);
2556         batch2.extractIndex(idx);
2557 
2558         tokenId = _mintLocal(msg.sender, primeIndex);
2559     }
2560 
2561     // After each batch has begun, the DAO can mint to ensure no bottleneck
2562     function rescueSale() external onlyOwner nonReentrant {
2563         (bool active, uint256 batchId, uint256 remaining, ) = batchCheck();
2564         require(active, "Batch not active");
2565         require(
2566             block.timestamp > batchStartTime + RESCUE_SALE_GRACE_PERIOD,
2567             "Must wait for sale to elapse"
2568         );
2569         uint256 rescueCount = remaining < 20 ? remaining : 20;
2570         for (uint256 i = 0; i < rescueCount; i++) {
2571             _getPrime(batchId);
2572         }
2573     }
2574 
2575     function withdraw() external onlyOwner nonReentrant {
2576         payable(owner()).transfer(address(this).balance);
2577     }
2578 
2579     function batchCheck()
2580         public
2581         view
2582         returns (
2583             bool active,
2584             uint256 batch,
2585             uint256 remaining,
2586             uint256 startTime
2587         )
2588     {
2589         uint256 ts = batchStartTime;
2590         if (ts == 0) {
2591             return (false, 0, 0, 0);
2592         }
2593         if (batch0.length > 0) {
2594             startTime = batchStartTime + BATCH_0_GRACE_PERIOD;
2595             return (block.timestamp > startTime, 0, batch0.length, startTime);
2596         }
2597         if (batch1.length > 0) {
2598             startTime = batchStartTime + BATCH_1_GRACE_PERIOD;
2599             return (block.timestamp > startTime, 1, batch1.length, startTime);
2600         }
2601         startTime = batchStartTime + BATCH_2_GRACE_PERIOD;
2602         return (block.timestamp > startTime, 2, batch2.length, startTime);
2603     }
2604 
2605     /***************************************
2606                 MINTING - INTERNAL
2607     ****************************************/
2608 
2609     function _getPrime(uint256 _batchId) internal {
2610         uint256 seed = _rand();
2611         uint16 primeIndex;
2612         if (_batchId == 0) {
2613             uint256 idx = seed % batch0.length;
2614             primeIndex = batch0.getValue(idx);
2615             batch0.extractIndex(idx);
2616             _triggerTimestamp(_batchId, batch0.length);
2617         } else if (_batchId == 1) {
2618             uint256 idx = seed % batch1.length;
2619             primeIndex = batch1.getValue(idx);
2620             batch1.extractIndex(idx);
2621             _triggerTimestamp(_batchId, batch1.length);
2622         } else {
2623             revert("Invalid batchId");
2624         }
2625 
2626         _mintLocal(msg.sender, primeIndex);
2627     }
2628 
2629     function _mintLocal(address _beneficiary, uint16 _primeIndex)
2630         internal
2631         returns (uint256 tokenId)
2632     {
2633         uint16[2] memory empty;
2634         tokenId = fetchPrime(_primeIndex);
2635         data[tokenId] = CoreData({
2636             isPrime: true,
2637             primeIndex: _primeIndex,
2638             primeFactorCount: 1,
2639             parents: empty,
2640             lastBred: uint32(block.timestamp)
2641         });
2642         _safeMint(_beneficiary, tokenId);
2643         emit PrimeClaimed(tokenId);
2644     }
2645 
2646     function _validateUser(
2647         uint256 _batchId,
2648         uint256 _count,
2649         uint256 _batch0Cap,
2650         uint256 _batch1Cap,
2651         bytes32[] memory _merkleProof
2652     ) internal {
2653         if (block.timestamp < batchStartTime + WHITELIST_ONLY_PERIOD) {
2654             bytes32 leaf = keccak256(abi.encodePacked(msg.sender, _batch0Cap, _batch1Cap));
2655             require(
2656                 MerkleProof.verify(_merkleProof, whitelistRootHash, leaf),
2657                 "Invalid merkle proof"
2658             );
2659 
2660             uint8 countAfter = (
2661                 _batchId == 0 ? users[msg.sender].tranche0 : users[msg.sender].tranche1
2662             ) + uint8(_count);
2663 
2664             if (_batchId == 0) {
2665                 require(countAfter <= _batch0Cap, "Exceeding cap");
2666                 users[msg.sender].tranche0 = countAfter;
2667             } else {
2668                 require(countAfter <= _batch1Cap, "Exceeding cap");
2669                 users[msg.sender].tranche1 = countAfter;
2670             }
2671         }
2672     }
2673 
2674     function _triggerTimestamp(uint256 _batchId, uint256 _len) internal {
2675         if (_len == 0) {
2676             batchStartTime = block.timestamp;
2677             emit BatchStarted(_batchId + 1);
2678         }
2679     }
2680 
2681     function _rand() internal virtual returns (uint256 seed) {
2682         nonce++;
2683         seed = uint256(
2684             keccak256(
2685                 abi.encodePacked(
2686                     block.timestamp +
2687                         block.difficulty +
2688                         ((uint256(keccak256(abi.encodePacked(block.coinbase)))) /
2689                             (block.timestamp)) +
2690                         block.gaslimit +
2691                         ((uint256(keccak256(abi.encodePacked(msg.sender)))) / (block.timestamp)) +
2692                         block.number,
2693                     nonce
2694                 )
2695             )
2696         );
2697     }
2698 
2699     /***************************************
2700                 INITIALIZING
2701     ****************************************/
2702 
2703     modifier onlyInitializer() {
2704         require(msg.sender == setupAddr, "Only initializer");
2705         _;
2706     }
2707 
2708     function initPrimes(uint256[] calldata _data, uint256 _length) external onlyInitializer {
2709         require(packedPrimes.length == 0, "Already initialized");
2710         packedPrimes = Packed16BitArray.initStruct(_data, _length);
2711     }
2712 
2713     function initBatch0(uint256[] calldata _data, uint256 _length) external onlyInitializer {
2714         require(batch0.length == 0, "Already initialized");
2715         batch0 = Packed16BitArray.initStruct(_data, _length);
2716     }
2717 
2718     function initBatch1(uint256[] calldata _data, uint256 _length) external onlyInitializer {
2719         require(batch1.length == 0, "Already initialized");
2720         batch1 = Packed16BitArray.initStruct(_data, _length);
2721     }
2722 
2723     function initBatch2(uint256[] calldata _data, uint256 _length) external onlyInitializer {
2724         require(batch2.length == 0, "Already initialized");
2725         batch2 = Packed16BitArray.initStruct(_data, _length);
2726     }
2727 
2728     function start(address _auctionHouse) external onlyInitializer {
2729         require(
2730             packedPrimes.length > 0 && batch0.length > 0 && batch1.length > 0 && batch2.length > 0,
2731             "Not initialized"
2732         );
2733         batchStartTime = block.timestamp;
2734         auctionHouse = _auctionHouse;
2735 
2736         _mintLocal(owner(), 0);
2737 
2738         emit Initialized();
2739     }
2740 }