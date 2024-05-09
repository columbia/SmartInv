1 pragma solidity ^0.8.0;
2 // SPDX-License-Identifier: MIT
3 
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
26 /**
27  * @dev Required interface of an ERC721 compliant contract.
28  */
29 interface IERC721 is IERC165 {
30     /**
31      * @dev Emitted when `tokenId` token is transferred from `from` to `to`.
32      */
33     event Transfer(address indexed from, address indexed to, uint256 indexed tokenId);
34 
35     /**
36      * @dev Emitted when `owner` enables `approved` to manage the `tokenId` token.
37      */
38     event Approval(address indexed owner, address indexed approved, uint256 indexed tokenId);
39 
40     /**
41      * @dev Emitted when `owner` enables or disables (`approved`) `operator` to manage all of its assets.
42      */
43     event ApprovalForAll(address indexed owner, address indexed operator, bool approved);
44 
45     /**
46      * @dev Returns the number of tokens in ``owner``'s account.
47      */
48     function balanceOf(address owner) external view returns (uint256 balance);
49 
50     /**
51      * @dev Returns the owner of the `tokenId` token.
52      *
53      * Requirements:
54      *
55      * - `tokenId` must exist.
56      */
57     function ownerOf(uint256 tokenId) external view returns (address owner);
58 
59     /**
60      * @dev Safely transfers `tokenId` token from `from` to `to`, checking first that contract recipients
61      * are aware of the ERC721 protocol to prevent tokens from being forever locked.
62      *
63      * Requirements:
64      *
65      * - `from` cannot be the zero address.
66      * - `to` cannot be the zero address.
67      * - `tokenId` token must exist and be owned by `from`.
68      * - If the caller is not `from`, it must be have been allowed to move this token by either {approve} or {setApprovalForAll}.
69      * - If `to` refers to a smart contract, it must implement {IERC721Receiver-onERC721Received}, which is called upon a safe transfer.
70      *
71      * Emits a {Transfer} event.
72      */
73     function safeTransferFrom(
74         address from,
75         address to,
76         uint256 tokenId
77     ) external;
78 
79     /**
80      * @dev Transfers `tokenId` token from `from` to `to`.
81      *
82      * WARNING: Usage of this method is discouraged, use {safeTransferFrom} whenever possible.
83      *
84      * Requirements:
85      *
86      * - `from` cannot be the zero address.
87      * - `to` cannot be the zero address.
88      * - `tokenId` token must be owned by `from`.
89      * - If the caller is not `from`, it must be approved to move this token by either {approve} or {setApprovalForAll}.
90      *
91      * Emits a {Transfer} event.
92      */
93     function transferFrom(
94         address from,
95         address to,
96         uint256 tokenId
97     ) external;
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
143      * @dev Safely transfers `tokenId` token from `from` to `to`.
144      *
145      * Requirements:
146      *
147      * - `from` cannot be the zero address.
148      * - `to` cannot be the zero address.
149      * - `tokenId` token must exist and be owned by `from`.
150      * - If the caller is not `from`, it must be approved to move this token by either {approve} or {setApprovalForAll}.
151      * - If `to` refers to a smart contract, it must implement {IERC721Receiver-onERC721Received}, which is called upon a safe transfer.
152      *
153      * Emits a {Transfer} event.
154      */
155     function safeTransferFrom(
156         address from,
157         address to,
158         uint256 tokenId,
159         bytes calldata data
160     ) external;
161 }
162 
163 /**
164  * @title ERC721 token receiver interface
165  * @dev Interface for any contract that wants to support safeTransfers
166  * from ERC721 asset contracts.
167  */
168 interface IERC721Receiver {
169     /**
170      * @dev Whenever an {IERC721} `tokenId` token is transferred to this contract via {IERC721-safeTransferFrom}
171      * by `operator` from `from`, this function is called.
172      *
173      * It must return its Solidity selector to confirm the token transfer.
174      * If any other value is returned or the interface is not implemented by the recipient, the transfer will be reverted.
175      *
176      * The selector can be obtained in Solidity with `IERC721.onERC721Received.selector`.
177      */
178     function onERC721Received(
179         address operator,
180         address from,
181         uint256 tokenId,
182         bytes calldata data
183     ) external returns (bytes4);
184 }
185 
186 /**
187  * @title ERC-721 Non-Fungible Token Standard, optional metadata extension
188  * @dev See https://eips.ethereum.org/EIPS/eip-721
189  */
190 interface IERC721Metadata is IERC721 {
191     /**
192      * @dev Returns the token collection name.
193      */
194     function name() external view returns (string memory);
195 
196     /**
197      * @dev Returns the token collection symbol.
198      */
199     function symbol() external view returns (string memory);
200 
201     /**
202      * @dev Returns the Uniform Resource Identifier (URI) for `tokenId` token.
203      */
204     function tokenURI(uint256 tokenId) external view returns (string memory);
205 }
206 
207 /**
208  * @dev Collection of functions related to the address type
209  */
210 library Address {
211     /**
212      * @dev Returns true if `account` is a contract.
213      *
214      * [IMPORTANT]
215      * ====
216      * It is unsafe to assume that an address for which this function returns
217      * false is an externally-owned account (EOA) and not a contract.
218      *
219      * Among others, `isContract` will return false for the following
220      * types of addresses:
221      *
222      *  - an externally-owned account
223      *  - a contract in construction
224      *  - an address where a contract will be created
225      *  - an address where a contract lived, but was destroyed
226      * ====
227      */
228     function isContract(address account) internal view returns (bool) {
229         // This method relies on extcodesize, which returns 0 for contracts in
230         // construction, since the code is only stored at the end of the
231         // constructor execution.
232 
233         uint256 size;
234         assembly {
235             size := extcodesize(account)
236         }
237         return size > 0;
238     }
239 
240     /**
241      * @dev Replacement for Solidity's `transfer`: sends `amount` wei to
242      * `recipient`, forwarding all available gas and reverting on errors.
243      *
244      * https://eips.ethereum.org/EIPS/eip-1884[EIP1884] increases the gas cost
245      * of certain opcodes, possibly making contracts go over the 2300 gas limit
246      * imposed by `transfer`, making them unable to receive funds via
247      * `transfer`. {sendValue} removes this limitation.
248      *
249      * https://diligence.consensys.net/posts/2019/09/stop-using-soliditys-transfer-now/[Learn more].
250      *
251      * IMPORTANT: because control is transferred to `recipient`, care must be
252      * taken to not create reentrancy vulnerabilities. Consider using
253      * {ReentrancyGuard} or the
254      * https://solidity.readthedocs.io/en/v0.5.11/security-considerations.html#use-the-checks-effects-interactions-pattern[checks-effects-interactions pattern].
255      */
256     function sendValue(address payable recipient, uint256 amount) internal {
257         require(address(this).balance >= amount, "Address: insufficient balance");
258 
259         (bool success, ) = recipient.call{value: amount}("");
260         require(success, "Address: unable to send value, recipient may have reverted");
261     }
262 
263     /**
264      * @dev Performs a Solidity function call using a low level `call`. A
265      * plain `call` is an unsafe replacement for a function call: use this
266      * function instead.
267      *
268      * If `target` reverts with a revert reason, it is bubbled up by this
269      * function (like regular Solidity function calls).
270      *
271      * Returns the raw returned data. To convert to the expected return value,
272      * use https://solidity.readthedocs.io/en/latest/units-and-global-variables.html?highlight=abi.decode#abi-encoding-and-decoding-functions[`abi.decode`].
273      *
274      * Requirements:
275      *
276      * - `target` must be a contract.
277      * - calling `target` with `data` must not revert.
278      *
279      * _Available since v3.1._
280      */
281     function functionCall(address target, bytes memory data) internal returns (bytes memory) {
282         return functionCall(target, data, "Address: low-level call failed");
283     }
284 
285     /**
286      * @dev Same as {xref-Address-functionCall-address-bytes-}[`functionCall`], but with
287      * `errorMessage` as a fallback revert reason when `target` reverts.
288      *
289      * _Available since v3.1._
290      */
291     function functionCall(
292         address target,
293         bytes memory data,
294         string memory errorMessage
295     ) internal returns (bytes memory) {
296         return functionCallWithValue(target, data, 0, errorMessage);
297     }
298 
299     /**
300      * @dev Same as {xref-Address-functionCall-address-bytes-}[`functionCall`],
301      * but also transferring `value` wei to `target`.
302      *
303      * Requirements:
304      *
305      * - the calling contract must have an ETH balance of at least `value`.
306      * - the called Solidity function must be `payable`.
307      *
308      * _Available since v3.1._
309      */
310     function functionCallWithValue(
311         address target,
312         bytes memory data,
313         uint256 value
314     ) internal returns (bytes memory) {
315         return functionCallWithValue(target, data, value, "Address: low-level call with value failed");
316     }
317 
318     /**
319      * @dev Same as {xref-Address-functionCallWithValue-address-bytes-uint256-}[`functionCallWithValue`], but
320      * with `errorMessage` as a fallback revert reason when `target` reverts.
321      *
322      * _Available since v3.1._
323      */
324     function functionCallWithValue(
325         address target,
326         bytes memory data,
327         uint256 value,
328         string memory errorMessage
329     ) internal returns (bytes memory) {
330         require(address(this).balance >= value, "Address: insufficient balance for call");
331         require(isContract(target), "Address: call to non-contract");
332 
333         (bool success, bytes memory returndata) = target.call{value: value}(data);
334         return verifyCallResult(success, returndata, errorMessage);
335     }
336 
337     /**
338      * @dev Same as {xref-Address-functionCall-address-bytes-}[`functionCall`],
339      * but performing a static call.
340      *
341      * _Available since v3.3._
342      */
343     function functionStaticCall(address target, bytes memory data) internal view returns (bytes memory) {
344         return functionStaticCall(target, data, "Address: low-level static call failed");
345     }
346 
347     /**
348      * @dev Same as {xref-Address-functionCall-address-bytes-string-}[`functionCall`],
349      * but performing a static call.
350      *
351      * _Available since v3.3._
352      */
353     function functionStaticCall(
354         address target,
355         bytes memory data,
356         string memory errorMessage
357     ) internal view returns (bytes memory) {
358         require(isContract(target), "Address: static call to non-contract");
359 
360         (bool success, bytes memory returndata) = target.staticcall(data);
361         return verifyCallResult(success, returndata, errorMessage);
362     }
363 
364     /**
365      * @dev Same as {xref-Address-functionCall-address-bytes-}[`functionCall`],
366      * but performing a delegate call.
367      *
368      * _Available since v3.4._
369      */
370     function functionDelegateCall(address target, bytes memory data) internal returns (bytes memory) {
371         return functionDelegateCall(target, data, "Address: low-level delegate call failed");
372     }
373 
374     /**
375      * @dev Same as {xref-Address-functionCall-address-bytes-string-}[`functionCall`],
376      * but performing a delegate call.
377      *
378      * _Available since v3.4._
379      */
380     function functionDelegateCall(
381         address target,
382         bytes memory data,
383         string memory errorMessage
384     ) internal returns (bytes memory) {
385         require(isContract(target), "Address: delegate call to non-contract");
386 
387         (bool success, bytes memory returndata) = target.delegatecall(data);
388         return verifyCallResult(success, returndata, errorMessage);
389     }
390 
391     /**
392      * @dev Tool to verifies that a low level call was successful, and revert if it wasn't, either by bubbling the
393      * revert reason using the provided one.
394      *
395      * _Available since v4.3._
396      */
397     function verifyCallResult(
398         bool success,
399         bytes memory returndata,
400         string memory errorMessage
401     ) internal pure returns (bytes memory) {
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
420 /**
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
526 /**
527  * @dev Implementation of https://eips.ethereum.org/EIPS/eip-721[ERC721] Non-Fungible Token Standard, including
528  * the Metadata extension, but not including the Enumerable extension, which is available separately as
529  * {ERC721Enumerable}.
530  */
531 contract ERC721 is Context, ERC165, IERC721, IERC721Metadata {
532     using Address for address;
533     using Strings for uint256;
534 
535     // Token name
536     string private _name;
537 
538     // Token symbol
539     string private _symbol;
540 
541     // Mapping from token ID to owner address
542     mapping(uint256 => address) private _owners;
543 
544     // Mapping owner address to token count
545     mapping(address => uint256) private _balances;
546 
547     // Mapping from token ID to approved address
548     mapping(uint256 => address) private _tokenApprovals;
549 
550     // Mapping from owner to operator approvals
551     mapping(address => mapping(address => bool)) private _operatorApprovals;
552 
553     /**
554      * @dev Initializes the contract by setting a `name` and a `symbol` to the token collection.
555      */
556     constructor(string memory name_, string memory symbol_) {
557         _name = name_;
558         _symbol = symbol_;
559     }
560 
561     /**
562      * @dev See {IERC165-supportsInterface}.
563      */
564     function supportsInterface(bytes4 interfaceId) public view virtual override(ERC165, IERC165) returns (bool) {
565         return
566             interfaceId == type(IERC721).interfaceId ||
567             interfaceId == type(IERC721Metadata).interfaceId ||
568             super.supportsInterface(interfaceId);
569     }
570 
571     /**
572      * @dev See {IERC721-balanceOf}.
573      */
574     function balanceOf(address owner) public view virtual override returns (uint256) {
575         require(owner != address(0), "ERC721: balance query for the zero address");
576         return _balances[owner];
577     }
578 
579     /**
580      * @dev See {IERC721-ownerOf}.
581      */
582     function ownerOf(uint256 tokenId) public view virtual override returns (address) {
583         address owner = _owners[tokenId];
584         require(owner != address(0), "ERC721: owner query for nonexistent token");
585         return owner;
586     }
587 
588     /**
589      * @dev See {IERC721Metadata-name}.
590      */
591     function name() public view virtual override returns (string memory) {
592         return _name;
593     }
594 
595     /**
596      * @dev See {IERC721Metadata-symbol}.
597      */
598     function symbol() public view virtual override returns (string memory) {
599         return _symbol;
600     }
601 
602     /**
603      * @dev See {IERC721Metadata-tokenURI}.
604      */
605     function tokenURI(uint256 tokenId) public view virtual override returns (string memory) {
606         require(_exists(tokenId), "ERC721Metadata: URI query for nonexistent token");
607 
608         string memory baseURI = _baseURI();
609         return bytes(baseURI).length > 0 ? string(abi.encodePacked(baseURI, tokenId.toString())) : "";
610     }
611 
612     /**
613      * @dev Base URI for computing {tokenURI}. If set, the resulting URI for each
614      * token will be the concatenation of the `baseURI` and the `tokenId`. Empty
615      * by default, can be overriden in child contracts.
616      */
617     function _baseURI() internal view virtual returns (string memory) {
618         return "";
619     }
620 
621     /**
622      * @dev See {IERC721-approve}.
623      */
624     function approve(address to, uint256 tokenId) public virtual override {
625         address owner = ERC721.ownerOf(tokenId);
626         require(to != owner, "ERC721: approval to current owner");
627 
628         require(
629             _msgSender() == owner || isApprovedForAll(owner, _msgSender()),
630             "ERC721: approve caller is not owner nor approved for all"
631         );
632 
633         _approve(to, tokenId);
634     }
635 
636     /**
637      * @dev See {IERC721-getApproved}.
638      */
639     function getApproved(uint256 tokenId) public view virtual override returns (address) {
640         require(_exists(tokenId), "ERC721: approved query for nonexistent token");
641 
642         return _tokenApprovals[tokenId];
643     }
644 
645     /**
646      * @dev See {IERC721-setApprovalForAll}.
647      */
648     function setApprovalForAll(address operator, bool approved) public virtual override {
649         require(operator != _msgSender(), "ERC721: approve to caller");
650 
651         _operatorApprovals[_msgSender()][operator] = approved;
652         emit ApprovalForAll(_msgSender(), operator, approved);
653     }
654 
655     /**
656      * @dev See {IERC721-isApprovedForAll}.
657      */
658     function isApprovedForAll(address owner, address operator) public view virtual override returns (bool) {
659         return _operatorApprovals[owner][operator];
660     }
661 
662     /**
663      * @dev See {IERC721-transferFrom}.
664      */
665     function transferFrom(
666         address from,
667         address to,
668         uint256 tokenId
669     ) public virtual override {
670         //solhint-disable-next-line max-line-length
671         require(_isApprovedOrOwner(_msgSender(), tokenId), "ERC721: transfer caller is not owner nor approved");
672 
673         _transfer(from, to, tokenId);
674     }
675 
676     /**
677      * @dev See {IERC721-safeTransferFrom}.
678      */
679     function safeTransferFrom(
680         address from,
681         address to,
682         uint256 tokenId
683     ) public virtual override {
684         safeTransferFrom(from, to, tokenId, "");
685     }
686 
687     /**
688      * @dev See {IERC721-safeTransferFrom}.
689      */
690     function safeTransferFrom(
691         address from,
692         address to,
693         uint256 tokenId,
694         bytes memory _data
695     ) public virtual override {
696         require(_isApprovedOrOwner(_msgSender(), tokenId), "ERC721: transfer caller is not owner nor approved");
697         _safeTransfer(from, to, tokenId, _data);
698     }
699 
700     /**
701      * @dev Safely transfers `tokenId` token from `from` to `to`, checking first that contract recipients
702      * are aware of the ERC721 protocol to prevent tokens from being forever locked.
703      *
704      * `_data` is additional data, it has no specified format and it is sent in call to `to`.
705      *
706      * This internal function is equivalent to {safeTransferFrom}, and can be used to e.g.
707      * implement alternative mechanisms to perform token transfer, such as signature-based.
708      *
709      * Requirements:
710      *
711      * - `from` cannot be the zero address.
712      * - `to` cannot be the zero address.
713      * - `tokenId` token must exist and be owned by `from`.
714      * - If `to` refers to a smart contract, it must implement {IERC721Receiver-onERC721Received}, which is called upon a safe transfer.
715      *
716      * Emits a {Transfer} event.
717      */
718     function _safeTransfer(
719         address from,
720         address to,
721         uint256 tokenId,
722         bytes memory _data
723     ) internal virtual {
724         _transfer(from, to, tokenId);
725         require(_checkOnERC721Received(from, to, tokenId, _data), "ERC721: transfer to non ERC721Receiver implementer");
726     }
727 
728     /**
729      * @dev Returns whether `tokenId` exists.
730      *
731      * Tokens can be managed by their owner or approved accounts via {approve} or {setApprovalForAll}.
732      *
733      * Tokens start existing when they are minted (`_mint`),
734      * and stop existing when they are burned (`_burn`).
735      */
736     function _exists(uint256 tokenId) internal view virtual returns (bool) {
737         return _owners[tokenId] != address(0);
738     }
739 
740     /**
741      * @dev Returns whether `spender` is allowed to manage `tokenId`.
742      *
743      * Requirements:
744      *
745      * - `tokenId` must exist.
746      */
747     function _isApprovedOrOwner(address spender, uint256 tokenId) internal view virtual returns (bool) {
748         require(_exists(tokenId), "ERC721: operator query for nonexistent token");
749         address owner = ERC721.ownerOf(tokenId);
750         return (spender == owner || getApproved(tokenId) == spender || isApprovedForAll(owner, spender));
751     }
752 
753     /**
754      * @dev Safely mints `tokenId` and transfers it to `to`.
755      *
756      * Requirements:
757      *
758      * - `tokenId` must not exist.
759      * - If `to` refers to a smart contract, it must implement {IERC721Receiver-onERC721Received}, which is called upon a safe transfer.
760      *
761      * Emits a {Transfer} event.
762      */
763     function _safeMint(address to, uint256 tokenId) internal virtual {
764         _safeMint(to, tokenId, "");
765     }
766 
767     /**
768      * @dev Same as {xref-ERC721-_safeMint-address-uint256-}[`_safeMint`], with an additional `data` parameter which is
769      * forwarded in {IERC721Receiver-onERC721Received} to contract recipients.
770      */
771     function _safeMint(
772         address to,
773         uint256 tokenId,
774         bytes memory _data
775     ) internal virtual {
776         _mint(to, tokenId);
777         require(
778             _checkOnERC721Received(address(0), to, tokenId, _data),
779             "ERC721: transfer to non ERC721Receiver implementer"
780         );
781     }
782 
783     /**
784      * @dev Mints `tokenId` and transfers it to `to`.
785      *
786      * WARNING: Usage of this method is discouraged, use {_safeMint} whenever possible
787      *
788      * Requirements:
789      *
790      * - `tokenId` must not exist.
791      * - `to` cannot be the zero address.
792      *
793      * Emits a {Transfer} event.
794      */
795     function _mint(address to, uint256 tokenId) internal virtual {
796         require(to != address(0), "ERC721: mint to the zero address");
797         require(!_exists(tokenId), "ERC721: token already minted");
798 
799         _beforeTokenTransfer(address(0), to, tokenId);
800 
801         _balances[to] += 1;
802         _owners[tokenId] = to;
803 
804         emit Transfer(address(0), to, tokenId);
805     }
806 
807     /**
808      * @dev Destroys `tokenId`.
809      * The approval is cleared when the token is burned.
810      *
811      * Requirements:
812      *
813      * - `tokenId` must exist.
814      *
815      * Emits a {Transfer} event.
816      */
817     function _burn(uint256 tokenId) internal virtual {
818         address owner = ERC721.ownerOf(tokenId);
819 
820         _beforeTokenTransfer(owner, address(0), tokenId);
821 
822         // Clear approvals
823         _approve(address(0), tokenId);
824 
825         _balances[owner] -= 1;
826         delete _owners[tokenId];
827 
828         emit Transfer(owner, address(0), tokenId);
829     }
830 
831     /**
832      * @dev Transfers `tokenId` from `from` to `to`.
833      *  As opposed to {transferFrom}, this imposes no restrictions on msg.sender.
834      *
835      * Requirements:
836      *
837      * - `to` cannot be the zero address.
838      * - `tokenId` token must be owned by `from`.
839      *
840      * Emits a {Transfer} event.
841      */
842     function _transfer(
843         address from,
844         address to,
845         uint256 tokenId
846     ) internal virtual {
847         require(ERC721.ownerOf(tokenId) == from, "ERC721: transfer of token that is not own");
848         require(to != address(0), "ERC721: transfer to the zero address");
849 
850         _beforeTokenTransfer(from, to, tokenId);
851 
852         // Clear approvals from the previous owner
853         _approve(address(0), tokenId);
854 
855         _balances[from] -= 1;
856         _balances[to] += 1;
857         _owners[tokenId] = to;
858 
859         emit Transfer(from, to, tokenId);
860     }
861 
862     /**
863      * @dev Approve `to` to operate on `tokenId`
864      *
865      * Emits a {Approval} event.
866      */
867     function _approve(address to, uint256 tokenId) internal virtual {
868         _tokenApprovals[tokenId] = to;
869         emit Approval(ERC721.ownerOf(tokenId), to, tokenId);
870     }
871 
872     /**
873      * @dev Internal function to invoke {IERC721Receiver-onERC721Received} on a target address.
874      * The call is not executed if the target address is not a contract.
875      *
876      * @param from address representing the previous owner of the given token ID
877      * @param to target address that will receive the tokens
878      * @param tokenId uint256 ID of the token to be transferred
879      * @param _data bytes optional data to send along with the call
880      * @return bool whether the call correctly returned the expected magic value
881      */
882     function _checkOnERC721Received(
883         address from,
884         address to,
885         uint256 tokenId,
886         bytes memory _data
887     ) private returns (bool) {
888         if (to.isContract()) {
889             try IERC721Receiver(to).onERC721Received(_msgSender(), from, tokenId, _data) returns (bytes4 retval) {
890                 return retval == IERC721Receiver.onERC721Received.selector;
891             } catch (bytes memory reason) {
892                 if (reason.length == 0) {
893                     revert("ERC721: transfer to non ERC721Receiver implementer");
894                 } else {
895                     assembly {
896                         revert(add(32, reason), mload(reason))
897                     }
898                 }
899             }
900         } else {
901             return true;
902         }
903     }
904 
905     /**
906      * @dev Hook that is called before any token transfer. This includes minting
907      * and burning.
908      *
909      * Calling conditions:
910      *
911      * - When `from` and `to` are both non-zero, ``from``'s `tokenId` will be
912      * transferred to `to`.
913      * - When `from` is zero, `tokenId` will be minted for `to`.
914      * - When `to` is zero, ``from``'s `tokenId` will be burned.
915      * - `from` and `to` are never both zero.
916      *
917      * To learn more about hooks, head to xref:ROOT:extending-contracts.adoc#using-hooks[Using Hooks].
918      */
919     function _beforeTokenTransfer(
920         address from,
921         address to,
922         uint256 tokenId
923     ) internal virtual {}
924 }
925 
926 /**
927  * @title ERC721 Burnable Token
928  * @dev ERC721 Token that can be irreversibly burned (destroyed).
929  */
930 abstract contract ERC721Burnable is Context, ERC721 {
931     /**
932      * @dev Burns `tokenId`. See {ERC721-_burn}.
933      *
934      * Requirements:
935      *
936      * - The caller must own `tokenId` or be an approved operator.
937      */
938     function burn(uint256 tokenId) public virtual {
939         //solhint-disable-next-line max-line-length
940         require(_isApprovedOrOwner(_msgSender(), tokenId), "ERC721Burnable: caller is not owner nor approved");
941         _burn(tokenId);
942     }
943 }
944 
945 /**
946  * @title ERC-721 Non-Fungible Token Standard, optional enumeration extension
947  * @dev See https://eips.ethereum.org/EIPS/eip-721
948  */
949 interface IERC721Enumerable is IERC721 {
950     /**
951      * @dev Returns the total amount of tokens stored by the contract.
952      */
953     function totalSupply() external view returns (uint256);
954 
955     /**
956      * @dev Returns a token ID owned by `owner` at a given `index` of its token list.
957      * Use along with {balanceOf} to enumerate all of ``owner``'s tokens.
958      */
959     function tokenOfOwnerByIndex(address owner, uint256 index) external view returns (uint256 tokenId);
960 
961     /**
962      * @dev Returns a token ID at a given `index` of all the tokens stored by the contract.
963      * Use along with {totalSupply} to enumerate all tokens.
964      */
965     function tokenByIndex(uint256 index) external view returns (uint256);
966 }
967 
968 /**
969  * @dev This implements an optional extension of {ERC721} defined in the EIP that adds
970  * enumerability of all the token ids in the contract as well as all token ids owned by each
971  * account.
972  */
973 abstract contract ERC721Enumerable is ERC721, IERC721Enumerable {
974     // Mapping from owner to list of owned token IDs
975     mapping(address => mapping(uint256 => uint256)) private _ownedTokens;
976 
977     // Mapping from token ID to index of the owner tokens list
978     mapping(uint256 => uint256) private _ownedTokensIndex;
979 
980     // Array with all token ids, used for enumeration
981     uint256[] private _allTokens;
982 
983     // Mapping from token id to position in the allTokens array
984     mapping(uint256 => uint256) private _allTokensIndex;
985 
986     /**
987      * @dev See {IERC165-supportsInterface}.
988      */
989     function supportsInterface(bytes4 interfaceId) public view virtual override(IERC165, ERC721) returns (bool) {
990         return interfaceId == type(IERC721Enumerable).interfaceId || super.supportsInterface(interfaceId);
991     }
992 
993     /**
994      * @dev See {IERC721Enumerable-tokenOfOwnerByIndex}.
995      */
996     function tokenOfOwnerByIndex(address owner, uint256 index) public view virtual override returns (uint256) {
997         require(index < ERC721.balanceOf(owner), "ERC721Enumerable: owner index out of bounds");
998         return _ownedTokens[owner][index];
999     }
1000 
1001     /**
1002      * @dev See {IERC721Enumerable-totalSupply}.
1003      */
1004     function totalSupply() public view virtual override returns (uint256) {
1005         return _allTokens.length;
1006     }
1007 
1008     /**
1009      * @dev See {IERC721Enumerable-tokenByIndex}.
1010      */
1011     function tokenByIndex(uint256 index) public view virtual override returns (uint256) {
1012         require(index < ERC721Enumerable.totalSupply(), "ERC721Enumerable: global index out of bounds");
1013         return _allTokens[index];
1014     }
1015 
1016     /**
1017      * @dev Hook that is called before any token transfer. This includes minting
1018      * and burning.
1019      *
1020      * Calling conditions:
1021      *
1022      * - When `from` and `to` are both non-zero, ``from``'s `tokenId` will be
1023      * transferred to `to`.
1024      * - When `from` is zero, `tokenId` will be minted for `to`.
1025      * - When `to` is zero, ``from``'s `tokenId` will be burned.
1026      * - `from` cannot be the zero address.
1027      * - `to` cannot be the zero address.
1028      *
1029      * To learn more about hooks, head to xref:ROOT:extending-contracts.adoc#using-hooks[Using Hooks].
1030      */
1031     function _beforeTokenTransfer(
1032         address from,
1033         address to,
1034         uint256 tokenId
1035     ) internal virtual override {
1036         super._beforeTokenTransfer(from, to, tokenId);
1037 
1038         if (from == address(0)) {
1039             _addTokenToAllTokensEnumeration(tokenId);
1040         } else if (from != to) {
1041             _removeTokenFromOwnerEnumeration(from, tokenId);
1042         }
1043         if (to == address(0)) {
1044             _removeTokenFromAllTokensEnumeration(tokenId);
1045         } else if (to != from) {
1046             _addTokenToOwnerEnumeration(to, tokenId);
1047         }
1048     }
1049 
1050     /**
1051      * @dev Private function to add a token to this extension's ownership-tracking data structures.
1052      * @param to address representing the new owner of the given token ID
1053      * @param tokenId uint256 ID of the token to be added to the tokens list of the given address
1054      */
1055     function _addTokenToOwnerEnumeration(address to, uint256 tokenId) private {
1056         uint256 length = ERC721.balanceOf(to);
1057         _ownedTokens[to][length] = tokenId;
1058         _ownedTokensIndex[tokenId] = length;
1059     }
1060 
1061     /**
1062      * @dev Private function to add a token to this extension's token tracking data structures.
1063      * @param tokenId uint256 ID of the token to be added to the tokens list
1064      */
1065     function _addTokenToAllTokensEnumeration(uint256 tokenId) private {
1066         _allTokensIndex[tokenId] = _allTokens.length;
1067         _allTokens.push(tokenId);
1068     }
1069 
1070     /**
1071      * @dev Private function to remove a token from this extension's ownership-tracking data structures. Note that
1072      * while the token is not assigned a new owner, the `_ownedTokensIndex` mapping is _not_ updated: this allows for
1073      * gas optimizations e.g. when performing a transfer operation (avoiding double writes).
1074      * This has O(1) time complexity, but alters the order of the _ownedTokens array.
1075      * @param from address representing the previous owner of the given token ID
1076      * @param tokenId uint256 ID of the token to be removed from the tokens list of the given address
1077      */
1078     function _removeTokenFromOwnerEnumeration(address from, uint256 tokenId) private {
1079         // To prevent a gap in from's tokens array, we store the last token in the index of the token to delete, and
1080         // then delete the last slot (swap and pop).
1081 
1082         uint256 lastTokenIndex = ERC721.balanceOf(from) - 1;
1083         uint256 tokenIndex = _ownedTokensIndex[tokenId];
1084 
1085         // When the token to delete is the last token, the swap operation is unnecessary
1086         if (tokenIndex != lastTokenIndex) {
1087             uint256 lastTokenId = _ownedTokens[from][lastTokenIndex];
1088 
1089             _ownedTokens[from][tokenIndex] = lastTokenId; // Move the last token to the slot of the to-delete token
1090             _ownedTokensIndex[lastTokenId] = tokenIndex; // Update the moved token's index
1091         }
1092 
1093         // This also deletes the contents at the last position of the array
1094         delete _ownedTokensIndex[tokenId];
1095         delete _ownedTokens[from][lastTokenIndex];
1096     }
1097 
1098     /**
1099      * @dev Private function to remove a token from this extension's token tracking data structures.
1100      * This has O(1) time complexity, but alters the order of the _allTokens array.
1101      * @param tokenId uint256 ID of the token to be removed from the tokens list
1102      */
1103     function _removeTokenFromAllTokensEnumeration(uint256 tokenId) private {
1104         // To prevent a gap in the tokens array, we store the last token in the index of the token to delete, and
1105         // then delete the last slot (swap and pop).
1106 
1107         uint256 lastTokenIndex = _allTokens.length - 1;
1108         uint256 tokenIndex = _allTokensIndex[tokenId];
1109 
1110         // When the token to delete is the last token, the swap operation is unnecessary. However, since this occurs so
1111         // rarely (when the last minted token is burnt) that we still do the swap here to avoid the gas cost of adding
1112         // an 'if' statement (like in _removeTokenFromOwnerEnumeration)
1113         uint256 lastTokenId = _allTokens[lastTokenIndex];
1114 
1115         _allTokens[tokenIndex] = lastTokenId; // Move the last token to the slot of the to-delete token
1116         _allTokensIndex[lastTokenId] = tokenIndex; // Update the moved token's index
1117 
1118         // This also deletes the contents at the last position of the array
1119         delete _allTokensIndex[tokenId];
1120         _allTokens.pop();
1121     }
1122 }
1123 
1124 /**
1125  * @dev Contract module which allows children to implement an emergency stop
1126  * mechanism that can be triggered by an authorized account.
1127  *
1128  * This module is used through inheritance. It will make available the
1129  * modifiers `whenNotPaused` and `whenPaused`, which can be applied to
1130  * the functions of your contract. Note that they will not be pausable by
1131  * simply including this module, only once the modifiers are put in place.
1132  */
1133 abstract contract Pausable is Context {
1134     /**
1135      * @dev Emitted when the pause is triggered by `account`.
1136      */
1137     event Paused(address account);
1138 
1139     /**
1140      * @dev Emitted when the pause is lifted by `account`.
1141      */
1142     event Unpaused(address account);
1143 
1144     bool private _paused;
1145 
1146     /**
1147      * @dev Initializes the contract in unpaused state.
1148      */
1149     constructor() {
1150         _paused = false;
1151     }
1152 
1153     /**
1154      * @dev Returns true if the contract is paused, and false otherwise.
1155      */
1156     function paused() public view virtual returns (bool) {
1157         return _paused;
1158     }
1159 
1160     /**
1161      * @dev Modifier to make a function callable only when the contract is not paused.
1162      *
1163      * Requirements:
1164      *
1165      * - The contract must not be paused.
1166      */
1167     modifier whenNotPaused() {
1168         require(!paused(), "Pausable: paused");
1169         _;
1170     }
1171 
1172     /**
1173      * @dev Modifier to make a function callable only when the contract is paused.
1174      *
1175      * Requirements:
1176      *
1177      * - The contract must be paused.
1178      */
1179     modifier whenPaused() {
1180         require(paused(), "Pausable: not paused");
1181         _;
1182     }
1183 
1184     /**
1185      * @dev Triggers stopped state.
1186      *
1187      * Requirements:
1188      *
1189      * - The contract must not be paused.
1190      */
1191     function _pause() internal virtual whenNotPaused {
1192         _paused = true;
1193         emit Paused(_msgSender());
1194     }
1195 
1196     /**
1197      * @dev Returns to normal state.
1198      *
1199      * Requirements:
1200      *
1201      * - The contract must be paused.
1202      */
1203     function _unpause() internal virtual whenPaused {
1204         _paused = false;
1205         emit Unpaused(_msgSender());
1206     }
1207 }
1208 
1209 /**
1210  * @dev ERC721 token with pausable token transfers, minting and burning.
1211  *
1212  * Useful for scenarios such as preventing trades until the end of an evaluation
1213  * period, or having an emergency switch for freezing all token transfers in the
1214  * event of a large bug.
1215  */
1216 abstract contract ERC721Pausable is ERC721, Pausable {
1217     /**
1218      * @dev See {ERC721-_beforeTokenTransfer}.
1219      *
1220      * Requirements:
1221      *
1222      * - the contract must not be paused.
1223      */
1224     function _beforeTokenTransfer(
1225         address from,
1226         address to,
1227         uint256 tokenId
1228     ) internal virtual override {
1229         super._beforeTokenTransfer(from, to, tokenId);
1230 
1231         require(!paused(), "ERC721Pausable: token transfer while paused");
1232     }
1233 }
1234 
1235 /**
1236  * @dev Contract module which provides a basic access control mechanism, where
1237  * there is an account (an owner) that can be granted exclusive access to
1238  * specific functions.
1239  *
1240  * By default, the owner account will be the one that deploys the contract. This
1241  * can later be changed with {transferOwnership}.
1242  *
1243  * This module is used through inheritance. It will make available the modifier
1244  * `onlyOwner`, which can be applied to your functions to restrict their use to
1245  * the owner.
1246  */
1247 abstract contract Ownable is Context {
1248     address private _owner;
1249 
1250     event OwnershipTransferred(address indexed previousOwner, address indexed newOwner);
1251 
1252     /**
1253      * @dev Initializes the contract setting the deployer as the initial owner.
1254      */
1255     constructor() {
1256         _setOwner(_msgSender());
1257     }
1258 
1259     /**
1260      * @dev Returns the address of the current owner.
1261      */
1262     function owner() public view virtual returns (address) {
1263         return _owner;
1264     }
1265 
1266     /**
1267      * @dev Throws if called by any account other than the owner.
1268      */
1269     modifier onlyOwner() {
1270         require(owner() == _msgSender(), "Ownable: caller is not the owner");
1271         _;
1272     }
1273 
1274     /**
1275      * @dev Leaves the contract without owner. It will not be possible to call
1276      * `onlyOwner` functions anymore. Can only be called by the current owner.
1277      *
1278      * NOTE: Renouncing ownership will leave the contract without an owner,
1279      * thereby removing any functionality that is only available to the owner.
1280      */
1281     function renounceOwnership() public virtual onlyOwner {
1282         _setOwner(address(0));
1283     }
1284 
1285     /**
1286      * @dev Transfers ownership of the contract to a new account (`newOwner`).
1287      * Can only be called by the current owner.
1288      */
1289     function transferOwnership(address newOwner) public virtual onlyOwner {
1290         require(newOwner != address(0), "Ownable: new owner is the zero address");
1291         _setOwner(newOwner);
1292     }
1293 
1294     function _setOwner(address newOwner) private {
1295         address oldOwner = _owner;
1296         _owner = newOwner;
1297         emit OwnershipTransferred(oldOwner, newOwner);
1298     }
1299 }
1300 
1301 // CAUTION
1302 // This version of SafeMath should only be used with Solidity 0.8 or later,
1303 // because it relies on the compiler's built in overflow checks.
1304 /**
1305  * @dev Wrappers over Solidity's arithmetic operations.
1306  *
1307  * NOTE: `SafeMath` is no longer needed starting with Solidity 0.8. The compiler
1308  * now has built in overflow checking.
1309  */
1310 library SafeMath {
1311     /**
1312      * @dev Returns the addition of two unsigned integers, with an overflow flag.
1313      *
1314      * _Available since v3.4._
1315      */
1316     function tryAdd(uint256 a, uint256 b) internal pure returns (bool, uint256) {
1317         unchecked {
1318             uint256 c = a + b;
1319             if (c < a) return (false, 0);
1320             return (true, c);
1321         }
1322     }
1323 
1324     /**
1325      * @dev Returns the substraction of two unsigned integers, with an overflow flag.
1326      *
1327      * _Available since v3.4._
1328      */
1329     function trySub(uint256 a, uint256 b) internal pure returns (bool, uint256) {
1330         unchecked {
1331             if (b > a) return (false, 0);
1332             return (true, a - b);
1333         }
1334     }
1335 
1336     /**
1337      * @dev Returns the multiplication of two unsigned integers, with an overflow flag.
1338      *
1339      * _Available since v3.4._
1340      */
1341     function tryMul(uint256 a, uint256 b) internal pure returns (bool, uint256) {
1342         unchecked {
1343             // Gas optimization: this is cheaper than requiring 'a' not being zero, but the
1344             // benefit is lost if 'b' is also tested.
1345             // See: https://github.com/OpenZeppelin/openzeppelin-contracts/pull/522
1346             if (a == 0) return (true, 0);
1347             uint256 c = a * b;
1348             if (c / a != b) return (false, 0);
1349             return (true, c);
1350         }
1351     }
1352 
1353     /**
1354      * @dev Returns the division of two unsigned integers, with a division by zero flag.
1355      *
1356      * _Available since v3.4._
1357      */
1358     function tryDiv(uint256 a, uint256 b) internal pure returns (bool, uint256) {
1359         unchecked {
1360             if (b == 0) return (false, 0);
1361             return (true, a / b);
1362         }
1363     }
1364 
1365     /**
1366      * @dev Returns the remainder of dividing two unsigned integers, with a division by zero flag.
1367      *
1368      * _Available since v3.4._
1369      */
1370     function tryMod(uint256 a, uint256 b) internal pure returns (bool, uint256) {
1371         unchecked {
1372             if (b == 0) return (false, 0);
1373             return (true, a % b);
1374         }
1375     }
1376 
1377     /**
1378      * @dev Returns the addition of two unsigned integers, reverting on
1379      * overflow.
1380      *
1381      * Counterpart to Solidity's `+` operator.
1382      *
1383      * Requirements:
1384      *
1385      * - Addition cannot overflow.
1386      */
1387     function add(uint256 a, uint256 b) internal pure returns (uint256) {
1388         return a + b;
1389     }
1390 
1391     /**
1392      * @dev Returns the subtraction of two unsigned integers, reverting on
1393      * overflow (when the result is negative).
1394      *
1395      * Counterpart to Solidity's `-` operator.
1396      *
1397      * Requirements:
1398      *
1399      * - Subtraction cannot overflow.
1400      */
1401     function sub(uint256 a, uint256 b) internal pure returns (uint256) {
1402         return a - b;
1403     }
1404 
1405     /**
1406      * @dev Returns the multiplication of two unsigned integers, reverting on
1407      * overflow.
1408      *
1409      * Counterpart to Solidity's `*` operator.
1410      *
1411      * Requirements:
1412      *
1413      * - Multiplication cannot overflow.
1414      */
1415     function mul(uint256 a, uint256 b) internal pure returns (uint256) {
1416         return a * b;
1417     }
1418 
1419     /**
1420      * @dev Returns the integer division of two unsigned integers, reverting on
1421      * division by zero. The result is rounded towards zero.
1422      *
1423      * Counterpart to Solidity's `/` operator.
1424      *
1425      * Requirements:
1426      *
1427      * - The divisor cannot be zero.
1428      */
1429     function div(uint256 a, uint256 b) internal pure returns (uint256) {
1430         return a / b;
1431     }
1432 
1433     /**
1434      * @dev Returns the remainder of dividing two unsigned integers. (unsigned integer modulo),
1435      * reverting when dividing by zero.
1436      *
1437      * Counterpart to Solidity's `%` operator. This function uses a `revert`
1438      * opcode (which leaves remaining gas untouched) while Solidity uses an
1439      * invalid opcode to revert (consuming all remaining gas).
1440      *
1441      * Requirements:
1442      *
1443      * - The divisor cannot be zero.
1444      */
1445     function mod(uint256 a, uint256 b) internal pure returns (uint256) {
1446         return a % b;
1447     }
1448 
1449     /**
1450      * @dev Returns the subtraction of two unsigned integers, reverting with custom message on
1451      * overflow (when the result is negative).
1452      *
1453      * CAUTION: This function is deprecated because it requires allocating memory for the error
1454      * message unnecessarily. For custom revert reasons use {trySub}.
1455      *
1456      * Counterpart to Solidity's `-` operator.
1457      *
1458      * Requirements:
1459      *
1460      * - Subtraction cannot overflow.
1461      */
1462     function sub(
1463         uint256 a,
1464         uint256 b,
1465         string memory errorMessage
1466     ) internal pure returns (uint256) {
1467         unchecked {
1468             require(b <= a, errorMessage);
1469             return a - b;
1470         }
1471     }
1472 
1473     /**
1474      * @dev Returns the integer division of two unsigned integers, reverting with custom message on
1475      * division by zero. The result is rounded towards zero.
1476      *
1477      * Counterpart to Solidity's `/` operator. Note: this function uses a
1478      * `revert` opcode (which leaves remaining gas untouched) while Solidity
1479      * uses an invalid opcode to revert (consuming all remaining gas).
1480      *
1481      * Requirements:
1482      *
1483      * - The divisor cannot be zero.
1484      */
1485     function div(
1486         uint256 a,
1487         uint256 b,
1488         string memory errorMessage
1489     ) internal pure returns (uint256) {
1490         unchecked {
1491             require(b > 0, errorMessage);
1492             return a / b;
1493         }
1494     }
1495 
1496     /**
1497      * @dev Returns the remainder of dividing two unsigned integers. (unsigned integer modulo),
1498      * reverting with custom message when dividing by zero.
1499      *
1500      * CAUTION: This function is deprecated because it requires allocating memory for the error
1501      * message unnecessarily. For custom revert reasons use {tryMod}.
1502      *
1503      * Counterpart to Solidity's `%` operator. This function uses a `revert`
1504      * opcode (which leaves remaining gas untouched) while Solidity uses an
1505      * invalid opcode to revert (consuming all remaining gas).
1506      *
1507      * Requirements:
1508      *
1509      * - The divisor cannot be zero.
1510      */
1511     function mod(
1512         uint256 a,
1513         uint256 b,
1514         string memory errorMessage
1515     ) internal pure returns (uint256) {
1516         unchecked {
1517             require(b > 0, errorMessage);
1518             return a % b;
1519         }
1520     }
1521 }
1522 
1523 /**
1524  * 
1525  * If you mint this project, ur dumb <3
1526  * 
1527  * twitter.com/DoNOTMint
1528  * 
1529  */
1530 
1531 contract DONOTMINT is
1532   ERC721Burnable,
1533   ERC721Enumerable,
1534   ERC721Pausable,
1535   Ownable
1536 {
1537   using SafeMath for uint256;
1538   uint256 public constant MAX_IDIOTS = 8888;
1539   uint256 public constant PRICE = 0.08 ether;
1540   string public baseTokenURI = "ur_dumb://";
1541   
1542   event CreateIDIOT(uint256 indexed id);
1543   constructor()
1544   ERC721(
1545     "ABSOLUTELY DO NOT MINT",
1546     "IDIOT"
1547   ) {}
1548 
1549   function ABSOLUTELY_DO_NOT_CALL_THIS_MINT_FUNCTION_YOU_IDIOT_UR_DUMB(uint256 count)
1550   public
1551   payable {
1552     uint256 currentTotal = totalSupply();
1553     require(count > 0,
1554       "Count must be greater than 0");
1555     require(currentTotal.add(count) <= MAX_IDIOTS,
1556       "Requested amount exceeds what is available!");
1557     require(currentTotal <= MAX_IDIOTS,
1558       "Not enough idiots available.");
1559     require(msg.value >= PRICE.mul(count),
1560       "Incorrect price.");
1561 
1562     for (uint i = 0; i < count; i++) {
1563       uint id = totalSupply();
1564       _safeMint(msg.sender, id);
1565       emit CreateIDIOT(id);
1566     }
1567   }
1568 
1569   function _baseURI()
1570   internal
1571   view
1572   virtual
1573   override
1574   returns (string memory) {
1575     return baseTokenURI;
1576   }
1577 
1578   function setBaseURI(string memory baseURI)
1579   public
1580   onlyOwner {
1581     baseTokenURI = baseURI;
1582   }
1583   
1584   function pause()
1585   public
1586   onlyOwner {
1587     _pause();
1588   }
1589 
1590   function unpause()
1591   public
1592   onlyOwner {
1593     _unpause();
1594   }
1595 
1596   function withdrawAll()
1597   public
1598   payable
1599   onlyOwner {
1600     _widthdraw(owner(), address(this).balance);
1601   }
1602 
1603   function _widthdraw(address _address, uint256 _amount)
1604   private {
1605     (bool success, ) = _address.call{value: _amount}("");
1606     require(success, "Recovery failed.");
1607   }
1608 
1609   function _beforeTokenTransfer(
1610     address from,
1611     address to,
1612     uint256 tokenId
1613   )
1614   internal
1615   virtual
1616   override(ERC721, ERC721Enumerable, ERC721Pausable) {
1617     super._beforeTokenTransfer(from, to, tokenId);
1618   }
1619 
1620   function supportsInterface(bytes4 interfaceId)
1621   public
1622   view
1623   virtual
1624   override(ERC721, ERC721Enumerable)
1625   returns (bool) {
1626     return super.supportsInterface(interfaceId);
1627   }
1628 }