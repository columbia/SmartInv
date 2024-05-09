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
259         (bool success,) = recipient.call{value : amount}("");
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
333         (bool success, bytes memory returndata) = target.call{value : value}(data);
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
566         interfaceId == type(IERC721).interfaceId ||
567         interfaceId == type(IERC721Metadata).interfaceId ||
568         super.supportsInterface(interfaceId);
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
927  * @dev Contract module which provides a basic access control mechanism, where
928  * there is an account (an owner) that can be granted exclusive access to
929  * specific functions.
930  *
931  * By default, the owner account will be the one that deploys the contract. This
932  * can later be changed with {transferOwnership}.
933  *
934  * This module is used through inheritance. It will make available the modifier
935  * `onlyOwner`, which can be applied to your functions to restrict their use to
936  * the owner.
937  */
938 abstract contract Ownable is Context {
939     address private _owner;
940 
941     event OwnershipTransferred(address indexed previousOwner, address indexed newOwner);
942 
943     /**
944      * @dev Initializes the contract setting the deployer as the initial owner.
945      */
946     constructor() {
947         _setOwner(_msgSender());
948     }
949 
950     /**
951      * @dev Returns the address of the current owner.
952      */
953     function owner() public view virtual returns (address) {
954         return _owner;
955     }
956 
957     /**
958      * @dev Throws if called by any account other than the owner.
959      */
960     modifier onlyOwner() {
961         require(owner() == _msgSender(), "Ownable: caller is not the owner");
962         _;
963     }
964 
965     /**
966      * @dev Leaves the contract without owner. It will not be possible to call
967      * `onlyOwner` functions anymore. Can only be called by the current owner.
968      *
969      * NOTE: Renouncing ownership will leave the contract without an owner,
970      * thereby removing any functionality that is only available to the owner.
971      */
972     function renounceOwnership() public virtual onlyOwner {
973         _setOwner(address(0));
974     }
975 
976     /**
977      * @dev Transfers ownership of the contract to a new account (`newOwner`).
978      * Can only be called by the current owner.
979      */
980     function transferOwnership(address newOwner) public virtual onlyOwner {
981         require(newOwner != address(0), "Ownable: new owner is the zero address");
982         _setOwner(newOwner);
983     }
984 
985     function _setOwner(address newOwner) private {
986         address oldOwner = _owner;
987         _owner = newOwner;
988         emit OwnershipTransferred(oldOwner, newOwner);
989     }
990 }
991 
992 /**
993  * @title Counters
994  * @author Matt Condon (@shrugs)
995  * @dev Provides counters that can only be incremented, decremented or reset. This can be used e.g. to track the number
996  * of elements in a mapping, issuing ERC721 ids, or counting request ids.
997  *
998  * Include with `using Counters for Counters.Counter;`
999  */
1000 library Counters {
1001     struct Counter {
1002         // This variable should never be directly accessed by users of the library: interactions must be restricted to
1003         // the library's function. As of Solidity v0.5.2, this cannot be enforced, though there is a proposal to add
1004         // this feature: see https://github.com/ethereum/solidity/issues/4637
1005         uint256 _value; // default: 0
1006     }
1007 
1008     function current(Counter storage counter) internal view returns (uint256) {
1009         return counter._value;
1010     }
1011 
1012     function increment(Counter storage counter) internal {
1013     unchecked {
1014         counter._value += 1;
1015     }
1016     }
1017 
1018     function decrement(Counter storage counter) internal {
1019         uint256 value = counter._value;
1020         require(value > 0, "Counter: decrement overflow");
1021     unchecked {
1022         counter._value = value - 1;
1023     }
1024     }
1025 
1026     function reset(Counter storage counter) internal {
1027         counter._value = 0;
1028     }
1029 }
1030 
1031 
1032 contract NFT is ERC721, Ownable {
1033     using Counters for Counters.Counter;
1034     using Strings for uint256;
1035     enum State {SETUP, FREE, PAID, PAUSE, REVEALED}
1036 
1037 
1038     uint256 public cost = 0.05 ether;
1039     uint256 public maxSupply = 10000;
1040     uint256 public maxMintAmount = 21;
1041     Counters.Counter private tokenIdCounter;
1042     string public baseURI;
1043     string public baseExtension = ".json";
1044     string public notRevealedUri;
1045     State public state;
1046     mapping(address => uint8) public whitelisted;
1047 
1048 
1049 
1050 
1051     constructor(
1052         string memory _name,
1053         string memory _symbol,
1054         string memory _initBaseURI,
1055         string memory _initNotRevealedUri
1056     ) ERC721(_name, _symbol) {
1057         setBaseURI(_initBaseURI);
1058         setNotRevealedURI(_initNotRevealedUri);
1059         _mint();
1060     }
1061 
1062     // internal
1063     function _baseURI() internal view virtual override returns (string memory) {
1064         return baseURI;
1065     }
1066 
1067 
1068     // public
1069     function freeMint(uint8 _mintAmount) public {
1070 
1071         require(state == State.FREE || state == State.REVEALED, "must be FREE or REVEALED state.");
1072         require(_mintAmount <= whitelisted[msg.sender], "Out of quota.");
1073         require(tokenIdCounter.current() + _mintAmount <= maxSupply, "maxSupply reached");
1074 
1075         whitelisted[msg.sender] -= _mintAmount;
1076 
1077         for (uint256 i = 1; i <= _mintAmount; i++) {
1078             _mint();
1079         }
1080     }
1081 
1082     // public
1083     function mint(uint8 _mintAmount) public payable {
1084 
1085         require(state == State.PAID || state == State.REVEALED, "must be PAID or REVEALED state.");
1086         require(_mintAmount <= maxMintAmount, "can not mint more than maxMintAmount");
1087         require(tokenIdCounter.current() + _mintAmount <= maxSupply, "maxSupply reached");
1088         require(msg.value == cost * _mintAmount, "you need to send exact cost.");
1089 
1090         for (uint256 i = 1; i <= _mintAmount; i++) {
1091             _mint();
1092         }
1093     }
1094 
1095     function _mint() internal {
1096         tokenIdCounter.increment();
1097         uint256 tokenId = tokenIdCounter.current();
1098         _safeMint(msg.sender, tokenId);
1099     }
1100 
1101     function tokenURI(uint256 tokenId)
1102     public
1103     view
1104     virtual
1105     override
1106     returns (string memory)
1107     {
1108         require(
1109             _exists(tokenId),
1110             "ERC721Metadata: URI query for nonexistent token"
1111         );
1112 
1113         if (state != State.REVEALED) {
1114             return notRevealedUri;
1115         }
1116 
1117         string memory currentBaseURI = _baseURI();
1118         return bytes(currentBaseURI).length > 0
1119         ? string(abi.encodePacked(currentBaseURI, tokenId.toString(), baseExtension))
1120         : "";
1121     }
1122 
1123     function setState(State _state) public onlyOwner {
1124         state = _state;
1125     }
1126 
1127     function setCost(uint256 _newCost) public onlyOwner {
1128         cost = _newCost;
1129     }
1130 
1131     function setMaxMintAmount(uint256 _newmaxMintAmount) public onlyOwner {
1132         maxMintAmount = _newmaxMintAmount;
1133     }
1134 
1135     function setNotRevealedURI(string memory _notRevealedURI) public onlyOwner {
1136         notRevealedUri = _notRevealedURI;
1137     }
1138 
1139     function setBaseURI(string memory _newBaseURI) public onlyOwner {
1140         baseURI = _newBaseURI;
1141     }
1142 
1143     function setBaseExtension(string memory _newBaseExtension) public onlyOwner {
1144         baseExtension = _newBaseExtension;
1145     }
1146 
1147     function whitelistUserBatch(address[] memory _users, uint8 quota) public onlyOwner {
1148         for (uint i = 0; i < _users.length; i++) {
1149             whitelisted[_users[i]] = quota;
1150         }
1151     }
1152 
1153     function removeWhitelistUser(address _user) public onlyOwner {
1154         whitelisted[_user] = 0;
1155     }
1156 
1157     function totalSupply() public view returns (uint256) {
1158         return tokenIdCounter.current();
1159     }
1160 
1161     function withdraw() public payable onlyOwner {
1162 
1163         // This will payout the owner 100% of the contract balance.
1164         // Do not remove this otherwise you will not be able to withdraw the funds.
1165         // =============================================================================
1166         (bool os,) = payable(owner()).call{value : address(this).balance}("");
1167         require(os);
1168         // =============================================================================
1169     }
1170 }