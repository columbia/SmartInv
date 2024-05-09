1 pragma solidity ^0.8.0;
2 
3 
4 // SPDX-License-Identifier: MIT
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
927  * @title ERC-721 Non-Fungible Token Standard, optional enumeration extension
928  * @dev See https://eips.ethereum.org/EIPS/eip-721
929  */
930 interface IERC721Enumerable is IERC721 {
931     /**
932      * @dev Returns the total amount of tokens stored by the contract.
933      */
934     function totalSupply() external view returns (uint256);
935 
936     /**
937      * @dev Returns a token ID owned by `owner` at a given `index` of its token list.
938      * Use along with {balanceOf} to enumerate all of ``owner``'s tokens.
939      */
940     function tokenOfOwnerByIndex(address owner, uint256 index) external view returns (uint256 tokenId);
941 
942     /**
943      * @dev Returns a token ID at a given `index` of all the tokens stored by the contract.
944      * Use along with {totalSupply} to enumerate all tokens.
945      */
946     function tokenByIndex(uint256 index) external view returns (uint256);
947 }
948 
949 /**
950  * @dev This implements an optional extension of {ERC721} defined in the EIP that adds
951  * enumerability of all the token ids in the contract as well as all token ids owned by each
952  * account.
953  */
954 abstract contract ERC721Enumerable is ERC721, IERC721Enumerable {
955     // Mapping from owner to list of owned token IDs
956     mapping(address => mapping(uint256 => uint256)) private _ownedTokens;
957 
958     // Mapping from token ID to index of the owner tokens list
959     mapping(uint256 => uint256) private _ownedTokensIndex;
960 
961     // Array with all token ids, used for enumeration
962     uint256[] private _allTokens;
963 
964     // Mapping from token id to position in the allTokens array
965     mapping(uint256 => uint256) private _allTokensIndex;
966 
967     /**
968      * @dev See {IERC165-supportsInterface}.
969      */
970     function supportsInterface(bytes4 interfaceId) public view virtual override(IERC165, ERC721) returns (bool) {
971         return interfaceId == type(IERC721Enumerable).interfaceId || super.supportsInterface(interfaceId);
972     }
973 
974     /**
975      * @dev See {IERC721Enumerable-tokenOfOwnerByIndex}.
976      */
977     function tokenOfOwnerByIndex(address owner, uint256 index) public view virtual override returns (uint256) {
978         require(index < ERC721.balanceOf(owner), "ERC721Enumerable: owner index out of bounds");
979         return _ownedTokens[owner][index];
980     }
981 
982     /**
983      * @dev See {IERC721Enumerable-totalSupply}.
984      */
985     function totalSupply() public view virtual override returns (uint256) {
986         return _allTokens.length;
987     }
988 
989     /**
990      * @dev See {IERC721Enumerable-tokenByIndex}.
991      */
992     function tokenByIndex(uint256 index) public view virtual override returns (uint256) {
993         require(index < ERC721Enumerable.totalSupply(), "ERC721Enumerable: global index out of bounds");
994         return _allTokens[index];
995     }
996 
997     /**
998      * @dev Hook that is called before any token transfer. This includes minting
999      * and burning.
1000      *
1001      * Calling conditions:
1002      *
1003      * - When `from` and `to` are both non-zero, ``from``'s `tokenId` will be
1004      * transferred to `to`.
1005      * - When `from` is zero, `tokenId` will be minted for `to`.
1006      * - When `to` is zero, ``from``'s `tokenId` will be burned.
1007      * - `from` cannot be the zero address.
1008      * - `to` cannot be the zero address.
1009      *
1010      * To learn more about hooks, head to xref:ROOT:extending-contracts.adoc#using-hooks[Using Hooks].
1011      */
1012     function _beforeTokenTransfer(
1013         address from,
1014         address to,
1015         uint256 tokenId
1016     ) internal virtual override {
1017         super._beforeTokenTransfer(from, to, tokenId);
1018 
1019         if (from == address(0)) {
1020             _addTokenToAllTokensEnumeration(tokenId);
1021         } else if (from != to) {
1022             _removeTokenFromOwnerEnumeration(from, tokenId);
1023         }
1024         if (to == address(0)) {
1025             _removeTokenFromAllTokensEnumeration(tokenId);
1026         } else if (to != from) {
1027             _addTokenToOwnerEnumeration(to, tokenId);
1028         }
1029     }
1030 
1031     /**
1032      * @dev Private function to add a token to this extension's ownership-tracking data structures.
1033      * @param to address representing the new owner of the given token ID
1034      * @param tokenId uint256 ID of the token to be added to the tokens list of the given address
1035      */
1036     function _addTokenToOwnerEnumeration(address to, uint256 tokenId) private {
1037         uint256 length = ERC721.balanceOf(to);
1038         _ownedTokens[to][length] = tokenId;
1039         _ownedTokensIndex[tokenId] = length;
1040     }
1041 
1042     /**
1043      * @dev Private function to add a token to this extension's token tracking data structures.
1044      * @param tokenId uint256 ID of the token to be added to the tokens list
1045      */
1046     function _addTokenToAllTokensEnumeration(uint256 tokenId) private {
1047         _allTokensIndex[tokenId] = _allTokens.length;
1048         _allTokens.push(tokenId);
1049     }
1050 
1051     /**
1052      * @dev Private function to remove a token from this extension's ownership-tracking data structures. Note that
1053      * while the token is not assigned a new owner, the `_ownedTokensIndex` mapping is _not_ updated: this allows for
1054      * gas optimizations e.g. when performing a transfer operation (avoiding double writes).
1055      * This has O(1) time complexity, but alters the order of the _ownedTokens array.
1056      * @param from address representing the previous owner of the given token ID
1057      * @param tokenId uint256 ID of the token to be removed from the tokens list of the given address
1058      */
1059     function _removeTokenFromOwnerEnumeration(address from, uint256 tokenId) private {
1060         // To prevent a gap in from's tokens array, we store the last token in the index of the token to delete, and
1061         // then delete the last slot (swap and pop).
1062 
1063         uint256 lastTokenIndex = ERC721.balanceOf(from) - 1;
1064         uint256 tokenIndex = _ownedTokensIndex[tokenId];
1065 
1066         // When the token to delete is the last token, the swap operation is unnecessary
1067         if (tokenIndex != lastTokenIndex) {
1068             uint256 lastTokenId = _ownedTokens[from][lastTokenIndex];
1069 
1070             _ownedTokens[from][tokenIndex] = lastTokenId; // Move the last token to the slot of the to-delete token
1071             _ownedTokensIndex[lastTokenId] = tokenIndex; // Update the moved token's index
1072         }
1073 
1074         // This also deletes the contents at the last position of the array
1075         delete _ownedTokensIndex[tokenId];
1076         delete _ownedTokens[from][lastTokenIndex];
1077     }
1078 
1079     /**
1080      * @dev Private function to remove a token from this extension's token tracking data structures.
1081      * This has O(1) time complexity, but alters the order of the _allTokens array.
1082      * @param tokenId uint256 ID of the token to be removed from the tokens list
1083      */
1084     function _removeTokenFromAllTokensEnumeration(uint256 tokenId) private {
1085         // To prevent a gap in the tokens array, we store the last token in the index of the token to delete, and
1086         // then delete the last slot (swap and pop).
1087 
1088         uint256 lastTokenIndex = _allTokens.length - 1;
1089         uint256 tokenIndex = _allTokensIndex[tokenId];
1090 
1091         // When the token to delete is the last token, the swap operation is unnecessary. However, since this occurs so
1092         // rarely (when the last minted token is burnt) that we still do the swap here to avoid the gas cost of adding
1093         // an 'if' statement (like in _removeTokenFromOwnerEnumeration)
1094         uint256 lastTokenId = _allTokens[lastTokenIndex];
1095 
1096         _allTokens[tokenIndex] = lastTokenId; // Move the last token to the slot of the to-delete token
1097         _allTokensIndex[lastTokenId] = tokenIndex; // Update the moved token's index
1098 
1099         // This also deletes the contents at the last position of the array
1100         delete _allTokensIndex[tokenId];
1101         _allTokens.pop();
1102     }
1103 }
1104 
1105 /**
1106  * @dev Contract module which provides a basic access control mechanism, where
1107  * there is an account (an owner) that can be granted exclusive access to
1108  * specific functions.
1109  *
1110  * By default, the owner account will be the one that deploys the contract. This
1111  * can later be changed with {transferOwnership}.
1112  *
1113  * This module is used through inheritance. It will make available the modifier
1114  * `onlyOwner`, which can be applied to your functions to restrict their use to
1115  * the owner.
1116  */
1117 abstract contract Ownable is Context {
1118     address private _owner;
1119 
1120     event OwnershipTransferred(address indexed previousOwner, address indexed newOwner);
1121 
1122     /**
1123      * @dev Initializes the contract setting the deployer as the initial owner.
1124      */
1125     constructor() {
1126         _setOwner(_msgSender());
1127     }
1128 
1129     /**
1130      * @dev Returns the address of the current owner.
1131      */
1132     function owner() public view virtual returns (address) {
1133         return _owner;
1134     }
1135 
1136     /**
1137      * @dev Throws if called by any account other than the owner.
1138      */
1139     modifier onlyOwner() {
1140         require(owner() == _msgSender(), "Ownable: caller is not the owner");
1141         _;
1142     }
1143 
1144     /**
1145      * @dev Leaves the contract without owner. It will not be possible to call
1146      * `onlyOwner` functions anymore. Can only be called by the current owner.
1147      *
1148      * NOTE: Renouncing ownership will leave the contract without an owner,
1149      * thereby removing any functionality that is only available to the owner.
1150      */
1151     function renounceOwnership() public virtual onlyOwner {
1152         _setOwner(address(0));
1153     }
1154 
1155     /**
1156      * @dev Transfers ownership of the contract to a new account (`newOwner`).
1157      * Can only be called by the current owner.
1158      */
1159     function transferOwnership(address newOwner) public virtual onlyOwner {
1160         require(newOwner != address(0), "Ownable: new owner is the zero address");
1161         _setOwner(newOwner);
1162     }
1163 
1164     function _setOwner(address newOwner) private {
1165         address oldOwner = _owner;
1166         _owner = newOwner;
1167         emit OwnershipTransferred(oldOwner, newOwner);
1168     }
1169 }
1170 
1171 // CAUTION
1172 // This version of SafeMath should only be used with Solidity 0.8 or later,
1173 // because it relies on the compiler's built in overflow checks.
1174 /**
1175  * @dev Wrappers over Solidity's arithmetic operations.
1176  *
1177  * NOTE: `SafeMath` is no longer needed starting with Solidity 0.8. The compiler
1178  * now has built in overflow checking.
1179  */
1180 library SafeMath {
1181     /**
1182      * @dev Returns the addition of two unsigned integers, with an overflow flag.
1183      *
1184      * _Available since v3.4._
1185      */
1186     function tryAdd(uint256 a, uint256 b) internal pure returns (bool, uint256) {
1187         unchecked {
1188             uint256 c = a + b;
1189             if (c < a) return (false, 0);
1190             return (true, c);
1191         }
1192     }
1193 
1194     /**
1195      * @dev Returns the substraction of two unsigned integers, with an overflow flag.
1196      *
1197      * _Available since v3.4._
1198      */
1199     function trySub(uint256 a, uint256 b) internal pure returns (bool, uint256) {
1200         unchecked {
1201             if (b > a) return (false, 0);
1202             return (true, a - b);
1203         }
1204     }
1205 
1206     /**
1207      * @dev Returns the multiplication of two unsigned integers, with an overflow flag.
1208      *
1209      * _Available since v3.4._
1210      */
1211     function tryMul(uint256 a, uint256 b) internal pure returns (bool, uint256) {
1212         unchecked {
1213             // Gas optimization: this is cheaper than requiring 'a' not being zero, but the
1214             // benefit is lost if 'b' is also tested.
1215             // See: https://github.com/OpenZeppelin/openzeppelin-contracts/pull/522
1216             if (a == 0) return (true, 0);
1217             uint256 c = a * b;
1218             if (c / a != b) return (false, 0);
1219             return (true, c);
1220         }
1221     }
1222 
1223     /**
1224      * @dev Returns the division of two unsigned integers, with a division by zero flag.
1225      *
1226      * _Available since v3.4._
1227      */
1228     function tryDiv(uint256 a, uint256 b) internal pure returns (bool, uint256) {
1229         unchecked {
1230             if (b == 0) return (false, 0);
1231             return (true, a / b);
1232         }
1233     }
1234 
1235     /**
1236      * @dev Returns the remainder of dividing two unsigned integers, with a division by zero flag.
1237      *
1238      * _Available since v3.4._
1239      */
1240     function tryMod(uint256 a, uint256 b) internal pure returns (bool, uint256) {
1241         unchecked {
1242             if (b == 0) return (false, 0);
1243             return (true, a % b);
1244         }
1245     }
1246 
1247     /**
1248      * @dev Returns the addition of two unsigned integers, reverting on
1249      * overflow.
1250      *
1251      * Counterpart to Solidity's `+` operator.
1252      *
1253      * Requirements:
1254      *
1255      * - Addition cannot overflow.
1256      */
1257     function add(uint256 a, uint256 b) internal pure returns (uint256) {
1258         return a + b;
1259     }
1260 
1261     /**
1262      * @dev Returns the subtraction of two unsigned integers, reverting on
1263      * overflow (when the result is negative).
1264      *
1265      * Counterpart to Solidity's `-` operator.
1266      *
1267      * Requirements:
1268      *
1269      * - Subtraction cannot overflow.
1270      */
1271     function sub(uint256 a, uint256 b) internal pure returns (uint256) {
1272         return a - b;
1273     }
1274 
1275     /**
1276      * @dev Returns the multiplication of two unsigned integers, reverting on
1277      * overflow.
1278      *
1279      * Counterpart to Solidity's `*` operator.
1280      *
1281      * Requirements:
1282      *
1283      * - Multiplication cannot overflow.
1284      */
1285     function mul(uint256 a, uint256 b) internal pure returns (uint256) {
1286         return a * b;
1287     }
1288 
1289     /**
1290      * @dev Returns the integer division of two unsigned integers, reverting on
1291      * division by zero. The result is rounded towards zero.
1292      *
1293      * Counterpart to Solidity's `/` operator.
1294      *
1295      * Requirements:
1296      *
1297      * - The divisor cannot be zero.
1298      */
1299     function div(uint256 a, uint256 b) internal pure returns (uint256) {
1300         return a / b;
1301     }
1302 
1303     /**
1304      * @dev Returns the remainder of dividing two unsigned integers. (unsigned integer modulo),
1305      * reverting when dividing by zero.
1306      *
1307      * Counterpart to Solidity's `%` operator. This function uses a `revert`
1308      * opcode (which leaves remaining gas untouched) while Solidity uses an
1309      * invalid opcode to revert (consuming all remaining gas).
1310      *
1311      * Requirements:
1312      *
1313      * - The divisor cannot be zero.
1314      */
1315     function mod(uint256 a, uint256 b) internal pure returns (uint256) {
1316         return a % b;
1317     }
1318 
1319     /**
1320      * @dev Returns the subtraction of two unsigned integers, reverting with custom message on
1321      * overflow (when the result is negative).
1322      *
1323      * CAUTION: This function is deprecated because it requires allocating memory for the error
1324      * message unnecessarily. For custom revert reasons use {trySub}.
1325      *
1326      * Counterpart to Solidity's `-` operator.
1327      *
1328      * Requirements:
1329      *
1330      * - Subtraction cannot overflow.
1331      */
1332     function sub(
1333         uint256 a,
1334         uint256 b,
1335         string memory errorMessage
1336     ) internal pure returns (uint256) {
1337         unchecked {
1338             require(b <= a, errorMessage);
1339             return a - b;
1340         }
1341     }
1342 
1343     /**
1344      * @dev Returns the integer division of two unsigned integers, reverting with custom message on
1345      * division by zero. The result is rounded towards zero.
1346      *
1347      * Counterpart to Solidity's `/` operator. Note: this function uses a
1348      * `revert` opcode (which leaves remaining gas untouched) while Solidity
1349      * uses an invalid opcode to revert (consuming all remaining gas).
1350      *
1351      * Requirements:
1352      *
1353      * - The divisor cannot be zero.
1354      */
1355     function div(
1356         uint256 a,
1357         uint256 b,
1358         string memory errorMessage
1359     ) internal pure returns (uint256) {
1360         unchecked {
1361             require(b > 0, errorMessage);
1362             return a / b;
1363         }
1364     }
1365 
1366     /**
1367      * @dev Returns the remainder of dividing two unsigned integers. (unsigned integer modulo),
1368      * reverting with custom message when dividing by zero.
1369      *
1370      * CAUTION: This function is deprecated because it requires allocating memory for the error
1371      * message unnecessarily. For custom revert reasons use {tryMod}.
1372      *
1373      * Counterpart to Solidity's `%` operator. This function uses a `revert`
1374      * opcode (which leaves remaining gas untouched) while Solidity uses an
1375      * invalid opcode to revert (consuming all remaining gas).
1376      *
1377      * Requirements:
1378      *
1379      * - The divisor cannot be zero.
1380      */
1381     function mod(
1382         uint256 a,
1383         uint256 b,
1384         string memory errorMessage
1385     ) internal pure returns (uint256) {
1386         unchecked {
1387             require(b > 0, errorMessage);
1388             return a % b;
1389         }
1390     }
1391 }
1392 
1393 /**
1394  * @dev These functions deal with verification of Merkle Trees proofs.
1395  *
1396  * The proofs can be generated using the JavaScript library
1397  * https://github.com/miguelmota/merkletreejs[merkletreejs].
1398  * Note: the hashing algorithm should be keccak256 and pair sorting should be enabled.
1399  *
1400  * See `test/utils/cryptography/MerkleProof.test.js` for some examples.
1401  */
1402 library MerkleProof {
1403     /**
1404      * @dev Returns true if a `leaf` can be proved to be a part of a Merkle tree
1405      * defined by `root`. For this, a `proof` must be provided, containing
1406      * sibling hashes on the branch from the leaf to the root of the tree. Each
1407      * pair of leaves and each pair of pre-images are assumed to be sorted.
1408      */
1409     function verify(
1410         bytes32[] memory proof,
1411         bytes32 root,
1412         bytes32 leaf
1413     ) internal pure returns (bool) {
1414         bytes32 computedHash = leaf;
1415 
1416         for (uint256 i = 0; i < proof.length; i++) {
1417             bytes32 proofElement = proof[i];
1418 
1419             if (computedHash <= proofElement) {
1420                 // Hash(current computed hash + current element of the proof)
1421                 computedHash = keccak256(abi.encodePacked(computedHash, proofElement));
1422             } else {
1423                 // Hash(current element of the proof + current computed hash)
1424                 computedHash = keccak256(abi.encodePacked(proofElement, computedHash));
1425             }
1426         }
1427 
1428         // Check if the computed hash (root) is equal to the provided root
1429         return computedHash == root;
1430     }
1431 }
1432 
1433 contract CoolmansUniverse is ERC721, ERC721Enumerable, Ownable {
1434     using SafeMath for uint256;
1435 
1436     uint256 public constant MAX_ALLOW_LIST_MINT = 2;
1437     uint256 public constant MAX_PUBLIC_MINT = 10;
1438     uint256 public constant TOKEN_LIMIT = 10000;
1439     uint256 public constant TOKEN_PRICE = 0.095 ether;
1440 
1441     string public PROVENANCE;
1442 
1443     bool public saleActive = false;
1444     bool public allowListSaleActive = false;
1445 
1446     string private _baseURIextended;
1447     bytes32 private _allowListRoot;
1448 
1449     mapping(address => uint256) private _allowListClaimed;
1450 
1451     constructor() ERC721("CoolmansUniverse", "COOLMAN") {}
1452 
1453     function mint(uint256 numTokens) external payable {
1454         require(Address.isContract(msg.sender) == false, "Cannot mint from a contract");
1455 
1456         uint256 ts = totalSupply();
1457         require(saleActive, "The sale is not active");
1458         require(numTokens <= MAX_PUBLIC_MINT, "Invalid number of tokens");
1459         require(ts.add(numTokens) <= TOKEN_LIMIT, "Purchase would exceed max tokens");
1460         require(msg.value >= TOKEN_PRICE.mul(numTokens), "Ether value sent is below the required price");
1461 
1462         for (uint256 i = 0; i < numTokens; i++) {
1463             _safeMint(msg.sender, ts.add(i));
1464         }
1465     }
1466 
1467     function mintAllowList(uint256 numTokens, bytes32[] calldata proof) external payable {
1468         require(Address.isContract(msg.sender) == false, "Cannot mint from a contract");
1469 
1470         uint256 ts = totalSupply();
1471         require(_verify(_leaf(msg.sender), proof), "Address is not on allowlist");
1472         require(allowListSaleActive, "The pre-sale is not active");
1473         require(_allowListClaimed[msg.sender].add(numTokens) <= MAX_ALLOW_LIST_MINT, "Purchase would exceed max pre-sale tokens");
1474         require(ts.add(numTokens) <= TOKEN_LIMIT, "Purchase would exceed max tokens");
1475         require(msg.value >= TOKEN_PRICE.mul(numTokens), "Ether value sent is below the required price");
1476 
1477         _allowListClaimed[msg.sender] = _allowListClaimed[msg.sender].add(numTokens);
1478         for (uint256 i = 0; i < numTokens; i++) {
1479             _safeMint(msg.sender, ts.add(i));
1480         }
1481     }
1482 
1483     function numAvailableToMintDuringPreSale(bytes32[] calldata proof) external view returns (uint256) {
1484         if (_verify(_leaf(msg.sender), proof)) {
1485             return MAX_ALLOW_LIST_MINT - _allowListClaimed[msg.sender];
1486         }
1487         return 0;
1488     }
1489 
1490     function supportsInterface(bytes4 interfaceId) public view virtual override(ERC721, ERC721Enumerable) returns (bool) {
1491         return super.supportsInterface(interfaceId);
1492     }
1493 
1494     // OWNER ONLY
1495 
1496     function reserve(uint256 numTokens, address addr) public onlyOwner {
1497         uint256 ts = totalSupply();
1498         for (uint256 i = 0; i < numTokens; i++) {
1499             _safeMint(addr, ts.add(i));
1500         }
1501     }
1502 
1503     function setBaseURI(string memory baseURI_) public onlyOwner {
1504         _baseURIextended = baseURI_;
1505     }
1506 
1507     function setProvenance(string memory provenance) public onlyOwner {
1508         PROVENANCE = provenance;
1509     }
1510 
1511     function setSaleActive(bool _saleActive) public onlyOwner {
1512         saleActive = _saleActive;
1513     }
1514 
1515     function setAllowListSaleActive(bool _allowListSaleActive) public onlyOwner {
1516         allowListSaleActive = _allowListSaleActive;
1517     }
1518 
1519     function setAllowListRoot(bytes32 _root) public onlyOwner {
1520         _allowListRoot = _root;
1521     }
1522 
1523     function withdraw() public onlyOwner {
1524         uint256 balance = address(this).balance;
1525         Address.sendValue(payable(msg.sender), balance);
1526     }
1527 
1528     // INTERNAL
1529 
1530     function _baseURI() internal view virtual override returns (string memory) {
1531         return _baseURIextended;
1532     }
1533 
1534     function _beforeTokenTransfer(address from, address to, uint256 tokenId) internal override(ERC721, ERC721Enumerable) {
1535         super._beforeTokenTransfer(from, to, tokenId);
1536     }
1537 
1538     function _leaf(address account) internal pure returns (bytes32) {
1539         return keccak256(abi.encodePacked(account));
1540     }
1541 
1542     function _verify(bytes32 _leafNode, bytes32[] memory proof) internal view returns (bool) {
1543         return MerkleProof.verify(proof, _allowListRoot, _leafNode);
1544     }
1545 }