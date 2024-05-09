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
28 pragma solidity ^0.8.0;
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
170 pragma solidity ^0.8.0;
171 
172 /**
173  * @title ERC721 token receiver interface
174  * @dev Interface for any contract that wants to support safeTransfers
175  * from ERC721 asset contracts.
176  */
177 interface IERC721Receiver {
178     /**
179      * @dev Whenever an {IERC721} `tokenId` token is transferred to this contract via {IERC721-safeTransferFrom}
180      * by `operator` from `from`, this function is called.
181      *
182      * It must return its Solidity selector to confirm the token transfer.
183      * If any other value is returned or the interface is not implemented by the recipient, the transfer will be reverted.
184      *
185      * The selector can be obtained in Solidity with `IERC721.onERC721Received.selector`.
186      */
187     function onERC721Received(
188         address operator,
189         address from,
190         uint256 tokenId,
191         bytes calldata data
192     ) external returns (bytes4);
193 }
194 
195 
196 pragma solidity ^0.8.0;
197 
198 
199 /**
200  * @title ERC-721 Non-Fungible Token Standard, optional metadata extension
201  * @dev See https://eips.ethereum.org/EIPS/eip-721
202  */
203 interface IERC721Metadata is IERC721 {
204     /**
205      * @dev Returns the token collection name.
206      */
207     function name() external view returns (string memory);
208 
209     /**
210      * @dev Returns the token collection symbol.
211      */
212     function symbol() external view returns (string memory);
213 
214     /**
215      * @dev Returns the Uniform Resource Identifier (URI) for `tokenId` token.
216      */
217     function tokenURI(uint256 tokenId) external view returns (string memory);
218 }
219 
220 
221 pragma solidity ^0.8.0;
222 
223 /**
224  * @dev Collection of functions related to the address type
225  */
226 library Address {
227     /**
228      * @dev Returns true if `account` is a contract.
229      *
230      * [IMPORTANT]
231      * ====
232      * It is unsafe to assume that an address for which this function returns
233      * false is an externally-owned account (EOA) and not a contract.
234      *
235      * Among others, `isContract` will return false for the following
236      * types of addresses:
237      *
238      *  - an externally-owned account
239      *  - a contract in construction
240      *  - an address where a contract will be created
241      *  - an address where a contract lived, but was destroyed
242      * ====
243      */
244     function isContract(address account) internal view returns (bool) {
245         // This method relies on extcodesize, which returns 0 for contracts in
246         // construction, since the code is only stored at the end of the
247         // constructor execution.
248 
249         uint256 size;
250         assembly {
251             size := extcodesize(account)
252         }
253         return size > 0;
254     }
255 
256     /**
257      * @dev Replacement for Solidity's `transfer`: sends `amount` wei to
258      * `recipient`, forwarding all available gas and reverting on errors.
259      *
260      * https://eips.ethereum.org/EIPS/eip-1884[EIP1884] increases the gas cost
261      * of certain opcodes, possibly making contracts go over the 2300 gas limit
262      * imposed by `transfer`, making them unable to receive funds via
263      * `transfer`. {sendValue} removes this limitation.
264      *
265      * https://diligence.consensys.net/posts/2019/09/stop-using-soliditys-transfer-now/[Learn more].
266      *
267      * IMPORTANT: because control is transferred to `recipient`, care must be
268      * taken to not create reentrancy vulnerabilities. Consider using
269      * {ReentrancyGuard} or the
270      * https://solidity.readthedocs.io/en/v0.5.11/security-considerations.html#use-the-checks-effects-interactions-pattern[checks-effects-interactions pattern].
271      */
272     function sendValue(address payable recipient, uint256 amount) internal {
273         require(address(this).balance >= amount, "Address: insufficient balance");
274 
275         (bool success, ) = recipient.call{value: amount}("");
276         require(success, "Address: unable to send value, recipient may have reverted");
277     }
278 
279     /**
280      * @dev Performs a Solidity function call using a low level `call`. A
281      * plain `call` is an unsafe replacement for a function call: use this
282      * function instead.
283      *
284      * If `target` reverts with a revert reason, it is bubbled up by this
285      * function (like regular Solidity function calls).
286      *
287      * Returns the raw returned data. To convert to the expected return value,
288      * use https://solidity.readthedocs.io/en/latest/units-and-global-variables.html?highlight=abi.decode#abi-encoding-and-decoding-functions[`abi.decode`].
289      *
290      * Requirements:
291      *
292      * - `target` must be a contract.
293      * - calling `target` with `data` must not revert.
294      *
295      * _Available since v3.1._
296      */
297     function functionCall(address target, bytes memory data) internal returns (bytes memory) {
298         return functionCall(target, data, "Address: low-level call failed");
299     }
300 
301     /**
302      * @dev Same as {xref-Address-functionCall-address-bytes-}[`functionCall`], but with
303      * `errorMessage` as a fallback revert reason when `target` reverts.
304      *
305      * _Available since v3.1._
306      */
307     function functionCall(
308         address target,
309         bytes memory data,
310         string memory errorMessage
311     ) internal returns (bytes memory) {
312         return functionCallWithValue(target, data, 0, errorMessage);
313     }
314 
315     /**
316      * @dev Same as {xref-Address-functionCall-address-bytes-}[`functionCall`],
317      * but also transferring `value` wei to `target`.
318      *
319      * Requirements:
320      *
321      * - the calling contract must have an ETH balance of at least `value`.
322      * - the called Solidity function must be `payable`.
323      *
324      * _Available since v3.1._
325      */
326     function functionCallWithValue(
327         address target,
328         bytes memory data,
329         uint256 value
330     ) internal returns (bytes memory) {
331         return functionCallWithValue(target, data, value, "Address: low-level call with value failed");
332     }
333 
334     /**
335      * @dev Same as {xref-Address-functionCallWithValue-address-bytes-uint256-}[`functionCallWithValue`], but
336      * with `errorMessage` as a fallback revert reason when `target` reverts.
337      *
338      * _Available since v3.1._
339      */
340     function functionCallWithValue(
341         address target,
342         bytes memory data,
343         uint256 value,
344         string memory errorMessage
345     ) internal returns (bytes memory) {
346         require(address(this).balance >= value, "Address: insufficient balance for call");
347         require(isContract(target), "Address: call to non-contract");
348 
349         (bool success, bytes memory returndata) = target.call{value: value}(data);
350         return verifyCallResult(success, returndata, errorMessage);
351     }
352 
353     /**
354      * @dev Same as {xref-Address-functionCall-address-bytes-}[`functionCall`],
355      * but performing a static call.
356      *
357      * _Available since v3.3._
358      */
359     function functionStaticCall(address target, bytes memory data) internal view returns (bytes memory) {
360         return functionStaticCall(target, data, "Address: low-level static call failed");
361     }
362 
363     /**
364      * @dev Same as {xref-Address-functionCall-address-bytes-string-}[`functionCall`],
365      * but performing a static call.
366      *
367      * _Available since v3.3._
368      */
369     function functionStaticCall(
370         address target,
371         bytes memory data,
372         string memory errorMessage
373     ) internal view returns (bytes memory) {
374         require(isContract(target), "Address: static call to non-contract");
375 
376         (bool success, bytes memory returndata) = target.staticcall(data);
377         return verifyCallResult(success, returndata, errorMessage);
378     }
379 
380     /**
381      * @dev Same as {xref-Address-functionCall-address-bytes-}[`functionCall`],
382      * but performing a delegate call.
383      *
384      * _Available since v3.4._
385      */
386     function functionDelegateCall(address target, bytes memory data) internal returns (bytes memory) {
387         return functionDelegateCall(target, data, "Address: low-level delegate call failed");
388     }
389 
390     /**
391      * @dev Same as {xref-Address-functionCall-address-bytes-string-}[`functionCall`],
392      * but performing a delegate call.
393      *
394      * _Available since v3.4._
395      */
396     function functionDelegateCall(
397         address target,
398         bytes memory data,
399         string memory errorMessage
400     ) internal returns (bytes memory) {
401         require(isContract(target), "Address: delegate call to non-contract");
402 
403         (bool success, bytes memory returndata) = target.delegatecall(data);
404         return verifyCallResult(success, returndata, errorMessage);
405     }
406 
407     /**
408      * @dev Tool to verifies that a low level call was successful, and revert if it wasn't, either by bubbling the
409      * revert reason using the provided one.
410      *
411      * _Available since v4.3._
412      */
413     function verifyCallResult(
414         bool success,
415         bytes memory returndata,
416         string memory errorMessage
417     ) internal pure returns (bytes memory) {
418         if (success) {
419             return returndata;
420         } else {
421             // Look for revert reason and bubble it up if present
422             if (returndata.length > 0) {
423                 // The easiest way to bubble the revert reason is using memory via assembly
424 
425                 assembly {
426                     let returndata_size := mload(returndata)
427                     revert(add(32, returndata), returndata_size)
428                 }
429             } else {
430                 revert(errorMessage);
431             }
432         }
433     }
434 }
435 
436 
437 
438 pragma solidity ^0.8.0;
439 
440 /**
441  * @dev Provides information about the current execution context, including the
442  * sender of the transaction and its data. While these are generally available
443  * via msg.sender and msg.data, they should not be accessed in such a direct
444  * manner, since when dealing with meta-transactions the account sending and
445  * paying for execution may not be the actual sender (as far as an application
446  * is concerned).
447  *
448  * This contract is only required for intermediate, library-like contracts.
449  */
450 abstract contract Context {
451     function _msgSender() internal view virtual returns (address) {
452         return msg.sender;
453     }
454 
455     function _msgData() internal view virtual returns (bytes calldata) {
456         return msg.data;
457     }
458 }
459 
460 
461 
462 
463 pragma solidity ^0.8.0;
464 
465 /**
466  * @dev String operations.
467  */
468 library Strings {
469     bytes16 private constant _HEX_SYMBOLS = "0123456789abcdef";
470 
471     /**
472      * @dev Converts a `uint256` to its ASCII `string` decimal representation.
473      */
474     function toString(uint256 value) internal pure returns (string memory) {
475         // Inspired by OraclizeAPI's implementation - MIT licence
476         // https://github.com/oraclize/ethereum-api/blob/b42146b063c7d6ee1358846c198246239e9360e8/oraclizeAPI_0.4.25.sol
477 
478         if (value == 0) {
479             return "0";
480         }
481         uint256 temp = value;
482         uint256 digits;
483         while (temp != 0) {
484             digits++;
485             temp /= 10;
486         }
487         bytes memory buffer = new bytes(digits);
488         while (value != 0) {
489             digits -= 1;
490             buffer[digits] = bytes1(uint8(48 + uint256(value % 10)));
491             value /= 10;
492         }
493         return string(buffer);
494     }
495 
496     /**
497      * @dev Converts a `uint256` to its ASCII `string` hexadecimal representation.
498      */
499     function toHexString(uint256 value) internal pure returns (string memory) {
500         if (value == 0) {
501             return "0x00";
502         }
503         uint256 temp = value;
504         uint256 length = 0;
505         while (temp != 0) {
506             length++;
507             temp >>= 8;
508         }
509         return toHexString(value, length);
510     }
511 
512     /**
513      * @dev Converts a `uint256` to its ASCII `string` hexadecimal representation with fixed length.
514      */
515     function toHexString(uint256 value, uint256 length) internal pure returns (string memory) {
516         bytes memory buffer = new bytes(2 * length + 2);
517         buffer[0] = "0";
518         buffer[1] = "x";
519         for (uint256 i = 2 * length + 1; i > 1; --i) {
520             buffer[i] = _HEX_SYMBOLS[value & 0xf];
521             value >>= 4;
522         }
523         require(value == 0, "Strings: hex length insufficient");
524         return string(buffer);
525     }
526 }
527 
528 
529 
530 pragma solidity ^0.8.0;
531 
532 
533 
534 /**
535  * @dev Implementation of the {IERC165} interface.
536  *
537  * Contracts that want to implement ERC165 should inherit from this contract and override {supportsInterface} to check
538  * for the additional interface id that will be supported. For example:
539  *
540  * ```solidity
541  * function supportsInterface(bytes4 interfaceId) public view virtual override returns (bool) {
542  *     return interfaceId == type(MyInterface).interfaceId || super.supportsInterface(interfaceId);
543  * }
544  * ```
545  *
546  * Alternatively, {ERC165Storage} provides an easier to use but more expensive implementation.
547  */
548 abstract contract ERC165 is IERC165 {
549     /**
550      * @dev See {IERC165-supportsInterface}.
551      */
552     function supportsInterface(bytes4 interfaceId) public view virtual override returns (bool) {
553         return interfaceId == type(IERC165).interfaceId;
554     }
555 }
556 
557 
558 
559 pragma solidity ^0.8.0;
560 
561 
562 
563 /**
564  * @title ERC-721 Non-Fungible Token Standard, optional enumeration extension
565  * @dev See https://eips.ethereum.org/EIPS/eip-721
566  */
567 interface IERC721Enumerable is IERC721 {
568     /**
569      * @dev Returns the total amount of tokens stored by the contract.
570      */
571     function totalSupply() external view returns (uint256);
572 
573     /**
574      * @dev Returns a token ID owned by `owner` at a given `index` of its token list.
575      * Use along with {balanceOf} to enumerate all of ``owner``'s tokens.
576      */
577     function tokenOfOwnerByIndex(address owner, uint256 index) external view returns (uint256 tokenId);
578 
579     /**
580      * @dev Returns a token ID at a given `index` of all the tokens stored by the contract.
581      * Use along with {totalSupply} to enumerate all tokens.
582      */
583     function tokenByIndex(uint256 index) external view returns (uint256);
584 }
585 
586 
587 
588 
589 pragma solidity ^0.8.0;
590 
591 
592 
593 /**
594  * @dev Implementation of https://eips.ethereum.org/EIPS/eip-721[ERC721] Non-Fungible Token Standard, including
595  * the Metadata extension, but not including the Enumerable extension, which is available separately as
596  * {ERC721Enumerable}.
597  */
598 contract ERC721 is Context, ERC165, IERC721, IERC721Metadata {
599     using Address for address;
600     using Strings for uint256;
601 
602     // Token name
603     string private _name;
604 
605     // Token symbol
606     string private _symbol;
607 
608     // Mapping from token ID to owner address
609     mapping(uint256 => address) private _owners;
610 
611     // Mapping owner address to token count
612     mapping(address => uint256) private _balances;
613 
614     // Mapping from token ID to approved address
615     mapping(uint256 => address) private _tokenApprovals;
616 
617     // Mapping from owner to operator approvals
618     mapping(address => mapping(address => bool)) private _operatorApprovals;
619 
620     /**
621      * @dev Initializes the contract by setting a `name` and a `symbol` to the token collection.
622      */
623     constructor(string memory name_, string memory symbol_) {
624         _name = name_;
625         _symbol = symbol_;
626     }
627 
628     /**
629      * @dev See {IERC165-supportsInterface}.
630      */
631     function supportsInterface(bytes4 interfaceId) public view virtual override(ERC165, IERC165) returns (bool) {
632         return
633             interfaceId == type(IERC721).interfaceId ||
634             interfaceId == type(IERC721Metadata).interfaceId ||
635             super.supportsInterface(interfaceId);
636     }
637 
638     /**
639      * @dev See {IERC721-balanceOf}.
640      */
641     function balanceOf(address owner) public view virtual override returns (uint256) {
642         require(owner != address(0), "ERC721: balance query for the zero address");
643         return _balances[owner];
644     }
645 
646     /**
647      * @dev See {IERC721-ownerOf}.
648      */
649     function ownerOf(uint256 tokenId) public view virtual override returns (address) {
650         address owner = _owners[tokenId];
651         require(owner != address(0), "ERC721: owner query for nonexistent token");
652         return owner;
653     }
654 
655     /**
656      * @dev See {IERC721Metadata-name}.
657      */
658     function name() public view virtual override returns (string memory) {
659         return _name;
660     }
661 
662     /**
663      * @dev See {IERC721Metadata-symbol}.
664      */
665     function symbol() public view virtual override returns (string memory) {
666         return _symbol;
667     }
668 
669     /**
670      * @dev See {IERC721Metadata-tokenURI}.
671      */
672     function tokenURI(uint256 tokenId) public view virtual override returns (string memory) {
673         require(_exists(tokenId), "ERC721Metadata: URI query for nonexistent token");
674 
675         string memory baseURI = _baseURI();
676         return bytes(baseURI).length > 0 ? string(abi.encodePacked(baseURI, tokenId.toString())) : "";
677     }
678 
679     /**
680      * @dev Base URI for computing {tokenURI}. If set, the resulting URI for each
681      * token will be the concatenation of the `baseURI` and the `tokenId`. Empty
682      * by default, can be overriden in child contracts.
683      */
684     function _baseURI() internal view virtual returns (string memory) {
685         return "";
686     }
687 
688     /**
689      * @dev See {IERC721-approve}.
690      */
691     function approve(address to, uint256 tokenId) public virtual override {
692         address owner = ERC721.ownerOf(tokenId);
693         require(to != owner, "ERC721: approval to current owner");
694 
695         require(
696             _msgSender() == owner || isApprovedForAll(owner, _msgSender()),
697             "ERC721: approve caller is not owner nor approved for all"
698         );
699 
700         _approve(to, tokenId);
701     }
702 
703     /**
704      * @dev See {IERC721-getApproved}.
705      */
706     function getApproved(uint256 tokenId) public view virtual override returns (address) {
707         require(_exists(tokenId), "ERC721: approved query for nonexistent token");
708 
709         return _tokenApprovals[tokenId];
710     }
711 
712     /**
713      * @dev See {IERC721-setApprovalForAll}.
714      */
715     function setApprovalForAll(address operator, bool approved) public virtual override {
716         require(operator != _msgSender(), "ERC721: approve to caller");
717 
718         _operatorApprovals[_msgSender()][operator] = approved;
719         emit ApprovalForAll(_msgSender(), operator, approved);
720     }
721 
722     /**
723      * @dev See {IERC721-isApprovedForAll}.
724      */
725     function isApprovedForAll(address owner, address operator) public view virtual override returns (bool) {
726         return _operatorApprovals[owner][operator];
727     }
728 
729     /**
730      * @dev See {IERC721-transferFrom}.
731      */
732     function transferFrom(
733         address from,
734         address to,
735         uint256 tokenId
736     ) public virtual override {
737         //solhint-disable-next-line max-line-length
738         require(_isApprovedOrOwner(_msgSender(), tokenId), "ERC721: transfer caller is not owner nor approved");
739 
740         _transfer(from, to, tokenId);
741     }
742 
743     /**
744      * @dev See {IERC721-safeTransferFrom}.
745      */
746     function safeTransferFrom(
747         address from,
748         address to,
749         uint256 tokenId
750     ) public virtual override {
751         safeTransferFrom(from, to, tokenId, "");
752     }
753 
754     /**
755      * @dev See {IERC721-safeTransferFrom}.
756      */
757     function safeTransferFrom(
758         address from,
759         address to,
760         uint256 tokenId,
761         bytes memory _data
762     ) public virtual override {
763         require(_isApprovedOrOwner(_msgSender(), tokenId), "ERC721: transfer caller is not owner nor approved");
764         _safeTransfer(from, to, tokenId, _data);
765     }
766 
767     /**
768      * @dev Safely transfers `tokenId` token from `from` to `to`, checking first that contract recipients
769      * are aware of the ERC721 protocol to prevent tokens from being forever locked.
770      *
771      * `_data` is additional data, it has no specified format and it is sent in call to `to`.
772      *
773      * This internal function is equivalent to {safeTransferFrom}, and can be used to e.g.
774      * implement alternative mechanisms to perform token transfer, such as signature-based.
775      *
776      * Requirements:
777      *
778      * - `from` cannot be the zero address.
779      * - `to` cannot be the zero address.
780      * - `tokenId` token must exist and be owned by `from`.
781      * - If `to` refers to a smart contract, it must implement {IERC721Receiver-onERC721Received}, which is called upon a safe transfer.
782      *
783      * Emits a {Transfer} event.
784      */
785     function _safeTransfer(
786         address from,
787         address to,
788         uint256 tokenId,
789         bytes memory _data
790     ) internal virtual {
791         _transfer(from, to, tokenId);
792         require(_checkOnERC721Received(from, to, tokenId, _data), "ERC721: transfer to non ERC721Receiver implementer");
793     }
794 
795     /**
796      * @dev Returns whether `tokenId` exists.
797      *
798      * Tokens can be managed by their owner or approved accounts via {approve} or {setApprovalForAll}.
799      *
800      * Tokens start existing when they are minted (`_mint`),
801      * and stop existing when they are burned (`_burn`).
802      */
803     function _exists(uint256 tokenId) internal view virtual returns (bool) {
804         return _owners[tokenId] != address(0);
805     }
806 
807     /**
808      * @dev Returns whether `spender` is allowed to manage `tokenId`.
809      *
810      * Requirements:
811      *
812      * - `tokenId` must exist.
813      */
814     function _isApprovedOrOwner(address spender, uint256 tokenId) internal view virtual returns (bool) {
815         require(_exists(tokenId), "ERC721: operator query for nonexistent token");
816         address owner = ERC721.ownerOf(tokenId);
817         return (spender == owner || getApproved(tokenId) == spender || isApprovedForAll(owner, spender));
818     }
819 
820     /**
821      * @dev Safely mints `tokenId` and transfers it to `to`.
822      *
823      * Requirements:
824      *
825      * - `tokenId` must not exist.
826      * - If `to` refers to a smart contract, it must implement {IERC721Receiver-onERC721Received}, which is called upon a safe transfer.
827      *
828      * Emits a {Transfer} event.
829      */
830     function _safeMint(address to, uint256 tokenId) internal virtual {
831         _safeMint(to, tokenId, "");
832     }
833 
834     /**
835      * @dev Same as {xref-ERC721-_safeMint-address-uint256-}[`_safeMint`], with an additional `data` parameter which is
836      * forwarded in {IERC721Receiver-onERC721Received} to contract recipients.
837      */
838     function _safeMint(
839         address to,
840         uint256 tokenId,
841         bytes memory _data
842     ) internal virtual {
843         _mint(to, tokenId);
844         require(
845             _checkOnERC721Received(address(0), to, tokenId, _data),
846             "ERC721: transfer to non ERC721Receiver implementer"
847         );
848     }
849 
850     /**
851      * @dev Mints `tokenId` and transfers it to `to`.
852      *
853      * WARNING: Usage of this method is discouraged, use {_safeMint} whenever possible
854      *
855      * Requirements:
856      *
857      * - `tokenId` must not exist.
858      * - `to` cannot be the zero address.
859      *
860      * Emits a {Transfer} event.
861      */
862     function _mint(address to, uint256 tokenId) internal virtual {
863         require(to != address(0), "ERC721: mint to the zero address");
864         require(!_exists(tokenId), "ERC721: token already minted");
865 
866         _beforeTokenTransfer(address(0), to, tokenId);
867 
868         _balances[to] += 1;
869         _owners[tokenId] = to;
870 
871         emit Transfer(address(0), to, tokenId);
872     }
873 
874     /**
875      * @dev Destroys `tokenId`.
876      * The approval is cleared when the token is burned.
877      *
878      * Requirements:
879      *
880      * - `tokenId` must exist.
881      *
882      * Emits a {Transfer} event.
883      */
884     function _burn(uint256 tokenId) internal virtual {
885         address owner = ERC721.ownerOf(tokenId);
886 
887         _beforeTokenTransfer(owner, address(0), tokenId);
888 
889         // Clear approvals
890         _approve(address(0), tokenId);
891 
892         _balances[owner] -= 1;
893         delete _owners[tokenId];
894 
895         emit Transfer(owner, address(0), tokenId);
896     }
897 
898     /**
899      * @dev Transfers `tokenId` from `from` to `to`.
900      *  As opposed to {transferFrom}, this imposes no restrictions on msg.sender.
901      *
902      * Requirements:
903      *
904      * - `to` cannot be the zero address.
905      * - `tokenId` token must be owned by `from`.
906      *
907      * Emits a {Transfer} event.
908      */
909     function _transfer(
910         address from,
911         address to,
912         uint256 tokenId
913     ) internal virtual {
914         require(ERC721.ownerOf(tokenId) == from, "ERC721: transfer of token that is not own");
915         require(to != address(0), "ERC721: transfer to the zero address");
916 
917         _beforeTokenTransfer(from, to, tokenId);
918 
919         // Clear approvals from the previous owner
920         _approve(address(0), tokenId);
921 
922         _balances[from] -= 1;
923         _balances[to] += 1;
924         _owners[tokenId] = to;
925 
926         emit Transfer(from, to, tokenId);
927     }
928 
929     /**
930      * @dev Approve `to` to operate on `tokenId`
931      *
932      * Emits a {Approval} event.
933      */
934     function _approve(address to, uint256 tokenId) internal virtual {
935         _tokenApprovals[tokenId] = to;
936         emit Approval(ERC721.ownerOf(tokenId), to, tokenId);
937     }
938 
939     /**
940      * @dev Internal function to invoke {IERC721Receiver-onERC721Received} on a target address.
941      * The call is not executed if the target address is not a contract.
942      *
943      * @param from address representing the previous owner of the given token ID
944      * @param to target address that will receive the tokens
945      * @param tokenId uint256 ID of the token to be transferred
946      * @param _data bytes optional data to send along with the call
947      * @return bool whether the call correctly returned the expected magic value
948      */
949     function _checkOnERC721Received(
950         address from,
951         address to,
952         uint256 tokenId,
953         bytes memory _data
954     ) private returns (bool) {
955         if (to.isContract()) {
956             try IERC721Receiver(to).onERC721Received(_msgSender(), from, tokenId, _data) returns (bytes4 retval) {
957                 return retval == IERC721Receiver.onERC721Received.selector;
958             } catch (bytes memory reason) {
959                 if (reason.length == 0) {
960                     revert("ERC721: transfer to non ERC721Receiver implementer");
961                 } else {
962                     assembly {
963                         revert(add(32, reason), mload(reason))
964                     }
965                 }
966             }
967         } else {
968             return true;
969         }
970     }
971 
972     /**
973      * @dev Hook that is called before any token transfer. This includes minting
974      * and burning.
975      *
976      * Calling conditions:
977      *
978      * - When `from` and `to` are both non-zero, ``from``'s `tokenId` will be
979      * transferred to `to`.
980      * - When `from` is zero, `tokenId` will be minted for `to`.
981      * - When `to` is zero, ``from``'s `tokenId` will be burned.
982      * - `from` and `to` are never both zero.
983      *
984      * To learn more about hooks, head to xref:ROOT:extending-contracts.adoc#using-hooks[Using Hooks].
985      */
986     function _beforeTokenTransfer(
987         address from,
988         address to,
989         uint256 tokenId
990     ) internal virtual {}
991 }
992 
993 
994 
995 
996 pragma solidity ^0.8.0;
997 
998 
999 
1000 /**
1001  * @dev This implements an optional extension of {ERC721} defined in the EIP that adds
1002  * enumerability of all the token ids in the contract as well as all token ids owned by each
1003  * account.
1004  */
1005 abstract contract ERC721Enumerable is ERC721, IERC721Enumerable {
1006     // Mapping from owner to list of owned token IDs
1007     mapping(address => mapping(uint256 => uint256)) private _ownedTokens;
1008 
1009     // Mapping from token ID to index of the owner tokens list
1010     mapping(uint256 => uint256) private _ownedTokensIndex;
1011 
1012     // Array with all token ids, used for enumeration
1013     uint256[] private _allTokens;
1014 
1015     // Mapping from token id to position in the allTokens array
1016     mapping(uint256 => uint256) private _allTokensIndex;
1017 
1018     /**
1019      * @dev See {IERC165-supportsInterface}.
1020      */
1021     function supportsInterface(bytes4 interfaceId) public view virtual override(IERC165, ERC721) returns (bool) {
1022         return interfaceId == type(IERC721Enumerable).interfaceId || super.supportsInterface(interfaceId);
1023     }
1024 
1025     /**
1026      * @dev See {IERC721Enumerable-tokenOfOwnerByIndex}.
1027      */
1028     function tokenOfOwnerByIndex(address owner, uint256 index) public view virtual override returns (uint256) {
1029         require(index < ERC721.balanceOf(owner), "ERC721Enumerable: owner index out of bounds");
1030         return _ownedTokens[owner][index];
1031     }
1032 
1033     /**
1034      * @dev See {IERC721Enumerable-totalSupply}.
1035      */
1036     function totalSupply() public view virtual override returns (uint256) {
1037         return _allTokens.length;
1038     }
1039 
1040     /**
1041      * @dev See {IERC721Enumerable-tokenByIndex}.
1042      */
1043     function tokenByIndex(uint256 index) public view virtual override returns (uint256) {
1044         require(index < ERC721Enumerable.totalSupply(), "ERC721Enumerable: global index out of bounds");
1045         return _allTokens[index];
1046     }
1047 
1048     /**
1049      * @dev Hook that is called before any token transfer. This includes minting
1050      * and burning.
1051      *
1052      * Calling conditions:
1053      *
1054      * - When `from` and `to` are both non-zero, ``from``'s `tokenId` will be
1055      * transferred to `to`.
1056      * - When `from` is zero, `tokenId` will be minted for `to`.
1057      * - When `to` is zero, ``from``'s `tokenId` will be burned.
1058      * - `from` cannot be the zero address.
1059      * - `to` cannot be the zero address.
1060      *
1061      * To learn more about hooks, head to xref:ROOT:extending-contracts.adoc#using-hooks[Using Hooks].
1062      */
1063     function _beforeTokenTransfer(
1064         address from,
1065         address to,
1066         uint256 tokenId
1067     ) internal virtual override {
1068         super._beforeTokenTransfer(from, to, tokenId);
1069 
1070         if (from == address(0)) {
1071             _addTokenToAllTokensEnumeration(tokenId);
1072         } else if (from != to) {
1073             _removeTokenFromOwnerEnumeration(from, tokenId);
1074         }
1075         if (to == address(0)) {
1076             _removeTokenFromAllTokensEnumeration(tokenId);
1077         } else if (to != from) {
1078             _addTokenToOwnerEnumeration(to, tokenId);
1079         }
1080     }
1081 
1082     /**
1083      * @dev Private function to add a token to this extension's ownership-tracking data structures.
1084      * @param to address representing the new owner of the given token ID
1085      * @param tokenId uint256 ID of the token to be added to the tokens list of the given address
1086      */
1087     function _addTokenToOwnerEnumeration(address to, uint256 tokenId) private {
1088         uint256 length = ERC721.balanceOf(to);
1089         _ownedTokens[to][length] = tokenId;
1090         _ownedTokensIndex[tokenId] = length;
1091     }
1092 
1093     /**
1094      * @dev Private function to add a token to this extension's token tracking data structures.
1095      * @param tokenId uint256 ID of the token to be added to the tokens list
1096      */
1097     function _addTokenToAllTokensEnumeration(uint256 tokenId) private {
1098         _allTokensIndex[tokenId] = _allTokens.length;
1099         _allTokens.push(tokenId);
1100     }
1101 
1102     /**
1103      * @dev Private function to remove a token from this extension's ownership-tracking data structures. Note that
1104      * while the token is not assigned a new owner, the `_ownedTokensIndex` mapping is _not_ updated: this allows for
1105      * gas optimizations e.g. when performing a transfer operation (avoiding double writes).
1106      * This has O(1) time complexity, but alters the order of the _ownedTokens array.
1107      * @param from address representing the previous owner of the given token ID
1108      * @param tokenId uint256 ID of the token to be removed from the tokens list of the given address
1109      */
1110     function _removeTokenFromOwnerEnumeration(address from, uint256 tokenId) private {
1111         // To prevent a gap in from's tokens array, we store the last token in the index of the token to delete, and
1112         // then delete the last slot (swap and pop).
1113 
1114         uint256 lastTokenIndex = ERC721.balanceOf(from) - 1;
1115         uint256 tokenIndex = _ownedTokensIndex[tokenId];
1116 
1117         // When the token to delete is the last token, the swap operation is unnecessary
1118         if (tokenIndex != lastTokenIndex) {
1119             uint256 lastTokenId = _ownedTokens[from][lastTokenIndex];
1120 
1121             _ownedTokens[from][tokenIndex] = lastTokenId; // Move the last token to the slot of the to-delete token
1122             _ownedTokensIndex[lastTokenId] = tokenIndex; // Update the moved token's index
1123         }
1124 
1125         // This also deletes the contents at the last position of the array
1126         delete _ownedTokensIndex[tokenId];
1127         delete _ownedTokens[from][lastTokenIndex];
1128     }
1129 
1130     /**
1131      * @dev Private function to remove a token from this extension's token tracking data structures.
1132      * This has O(1) time complexity, but alters the order of the _allTokens array.
1133      * @param tokenId uint256 ID of the token to be removed from the tokens list
1134      */
1135     function _removeTokenFromAllTokensEnumeration(uint256 tokenId) private {
1136         // To prevent a gap in the tokens array, we store the last token in the index of the token to delete, and
1137         // then delete the last slot (swap and pop).
1138 
1139         uint256 lastTokenIndex = _allTokens.length - 1;
1140         uint256 tokenIndex = _allTokensIndex[tokenId];
1141 
1142         // When the token to delete is the last token, the swap operation is unnecessary. However, since this occurs so
1143         // rarely (when the last minted token is burnt) that we still do the swap here to avoid the gas cost of adding
1144         // an 'if' statement (like in _removeTokenFromOwnerEnumeration)
1145         uint256 lastTokenId = _allTokens[lastTokenIndex];
1146 
1147         _allTokens[tokenIndex] = lastTokenId; // Move the last token to the slot of the to-delete token
1148         _allTokensIndex[lastTokenId] = tokenIndex; // Update the moved token's index
1149 
1150         // This also deletes the contents at the last position of the array
1151         delete _allTokensIndex[tokenId];
1152         _allTokens.pop();
1153     }
1154 }
1155 
1156 
1157 
1158 
1159 pragma solidity ^0.8.0;
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
1230 
1231 pragma solidity ^0.8.0;
1232 
1233 /**
1234  * @dev Elliptic Curve Digital Signature Algorithm (ECDSA) operations.
1235  *
1236  * These functions can be used to verify that a message was signed by the holder
1237  * of the private keys of a given address.
1238  */
1239 library ECDSA {
1240     enum RecoverError {
1241         NoError,
1242         InvalidSignature,
1243         InvalidSignatureLength,
1244         InvalidSignatureS,
1245         InvalidSignatureV
1246     }
1247 
1248     function _throwError(RecoverError error) private pure {
1249         if (error == RecoverError.NoError) {
1250             return; // no error: do nothing
1251         } else if (error == RecoverError.InvalidSignature) {
1252             revert("ECDSA: invalid signature");
1253         } else if (error == RecoverError.InvalidSignatureLength) {
1254             revert("ECDSA: invalid signature length");
1255         } else if (error == RecoverError.InvalidSignatureS) {
1256             revert("ECDSA: invalid signature 's' value");
1257         } else if (error == RecoverError.InvalidSignatureV) {
1258             revert("ECDSA: invalid signature 'v' value");
1259         }
1260     }
1261 
1262     /**
1263      * @dev Returns the address that signed a hashed message (`hash`) with
1264      * `signature` or error string. This address can then be used for verification purposes.
1265      *
1266      * The `ecrecover` EVM opcode allows for malleable (non-unique) signatures:
1267      * this function rejects them by requiring the `s` value to be in the lower
1268      * half order, and the `v` value to be either 27 or 28.
1269      *
1270      * IMPORTANT: `hash` _must_ be the result of a hash operation for the
1271      * verification to be secure: it is possible to craft signatures that
1272      * recover to arbitrary addresses for non-hashed data. A safe way to ensure
1273      * this is by receiving a hash of the original message (which may otherwise
1274      * be too long), and then calling {toEthSignedMessageHash} on it.
1275      *
1276      * Documentation for signature generation:
1277      * - with https://web3js.readthedocs.io/en/v1.3.4/web3-eth-accounts.html#sign[Web3.js]
1278      * - with https://docs.ethers.io/v5/api/signer/#Signer-signMessage[ethers]
1279      *
1280      * _Available since v4.3._
1281      */
1282     function tryRecover(bytes32 hash, bytes memory signature) internal pure returns (address, RecoverError) {
1283         // Check the signature length
1284         // - case 65: r,s,v signature (standard)
1285         // - case 64: r,vs signature (cf https://eips.ethereum.org/EIPS/eip-2098) _Available since v4.1._
1286         if (signature.length == 65) {
1287             bytes32 r;
1288             bytes32 s;
1289             uint8 v;
1290             // ecrecover takes the signature parameters, and the only way to get them
1291             // currently is to use assembly.
1292             assembly {
1293                 r := mload(add(signature, 0x20))
1294                 s := mload(add(signature, 0x40))
1295                 v := byte(0, mload(add(signature, 0x60)))
1296             }
1297             return tryRecover(hash, v, r, s);
1298         } else if (signature.length == 64) {
1299             bytes32 r;
1300             bytes32 vs;
1301             // ecrecover takes the signature parameters, and the only way to get them
1302             // currently is to use assembly.
1303             assembly {
1304                 r := mload(add(signature, 0x20))
1305                 vs := mload(add(signature, 0x40))
1306             }
1307             return tryRecover(hash, r, vs);
1308         } else {
1309             return (address(0), RecoverError.InvalidSignatureLength);
1310         }
1311     }
1312 
1313     /**
1314      * @dev Returns the address that signed a hashed message (`hash`) with
1315      * `signature`. This address can then be used for verification purposes.
1316      *
1317      * The `ecrecover` EVM opcode allows for malleable (non-unique) signatures:
1318      * this function rejects them by requiring the `s` value to be in the lower
1319      * half order, and the `v` value to be either 27 or 28.
1320      *
1321      * IMPORTANT: `hash` _must_ be the result of a hash operation for the
1322      * verification to be secure: it is possible to craft signatures that
1323      * recover to arbitrary addresses for non-hashed data. A safe way to ensure
1324      * this is by receiving a hash of the original message (which may otherwise
1325      * be too long), and then calling {toEthSignedMessageHash} on it.
1326      */
1327     function recover(bytes32 hash, bytes memory signature) internal pure returns (address) {
1328         (address recovered, RecoverError error) = tryRecover(hash, signature);
1329         _throwError(error);
1330         return recovered;
1331     }
1332 
1333     /**
1334      * @dev Overload of {ECDSA-tryRecover} that receives the `r` and `vs` short-signature fields separately.
1335      *
1336      * See https://eips.ethereum.org/EIPS/eip-2098[EIP-2098 short signatures]
1337      *
1338      * _Available since v4.3._
1339      */
1340     function tryRecover(
1341         bytes32 hash,
1342         bytes32 r,
1343         bytes32 vs
1344     ) internal pure returns (address, RecoverError) {
1345         bytes32 s;
1346         uint8 v;
1347         assembly {
1348             s := and(vs, 0x7fffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffff)
1349             v := add(shr(255, vs), 27)
1350         }
1351         return tryRecover(hash, v, r, s);
1352     }
1353 
1354     /**
1355      * @dev Overload of {ECDSA-recover} that receives the `r and `vs` short-signature fields separately.
1356      *
1357      * _Available since v4.2._
1358      */
1359     function recover(
1360         bytes32 hash,
1361         bytes32 r,
1362         bytes32 vs
1363     ) internal pure returns (address) {
1364         (address recovered, RecoverError error) = tryRecover(hash, r, vs);
1365         _throwError(error);
1366         return recovered;
1367     }
1368 
1369     /**
1370      * @dev Overload of {ECDSA-tryRecover} that receives the `v`,
1371      * `r` and `s` signature fields separately.
1372      *
1373      * _Available since v4.3._
1374      */
1375     function tryRecover(
1376         bytes32 hash,
1377         uint8 v,
1378         bytes32 r,
1379         bytes32 s
1380     ) internal pure returns (address, RecoverError) {
1381         // EIP-2 still allows signature malleability for ecrecover(). Remove this possibility and make the signature
1382         // unique. Appendix F in the Ethereum Yellow paper (https://ethereum.github.io/yellowpaper/paper.pdf), defines
1383         // the valid range for s in (301): 0 < s < secp256k1n ÷ 2 + 1, and for v in (302): v ∈ {27, 28}. Most
1384         // signatures from current libraries generate a unique signature with an s-value in the lower half order.
1385         //
1386         // If your library generates malleable signatures, such as s-values in the upper range, calculate a new s-value
1387         // with 0xFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFEBAAEDCE6AF48A03BBFD25E8CD0364141 - s1 and flip v from 27 to 28 or
1388         // vice versa. If your library also generates signatures with 0/1 for v instead 27/28, add 27 to v to accept
1389         // these malleable signatures as well.
1390         if (uint256(s) > 0x7FFFFFFFFFFFFFFFFFFFFFFFFFFFFFFF5D576E7357A4501DDFE92F46681B20A0) {
1391             return (address(0), RecoverError.InvalidSignatureS);
1392         }
1393         if (v != 27 && v != 28) {
1394             return (address(0), RecoverError.InvalidSignatureV);
1395         }
1396 
1397         // If the signature is valid (and not malleable), return the signer address
1398         address signer = ecrecover(hash, v, r, s);
1399         if (signer == address(0)) {
1400             return (address(0), RecoverError.InvalidSignature);
1401         }
1402 
1403         return (signer, RecoverError.NoError);
1404     }
1405 
1406     /**
1407      * @dev Overload of {ECDSA-recover} that receives the `v`,
1408      * `r` and `s` signature fields separately.
1409      */
1410     function recover(
1411         bytes32 hash,
1412         uint8 v,
1413         bytes32 r,
1414         bytes32 s
1415     ) internal pure returns (address) {
1416         (address recovered, RecoverError error) = tryRecover(hash, v, r, s);
1417         _throwError(error);
1418         return recovered;
1419     }
1420 
1421     /**
1422      * @dev Returns an Ethereum Signed Message, created from a `hash`. This
1423      * produces hash corresponding to the one signed with the
1424      * https://eth.wiki/json-rpc/API#eth_sign[`eth_sign`]
1425      * JSON-RPC method as part of EIP-191.
1426      *
1427      * See {recover}.
1428      */
1429     function toEthSignedMessageHash(bytes32 hash) internal pure returns (bytes32) {
1430         // 32 is the length in bytes of hash,
1431         // enforced by the type signature above
1432         return keccak256(abi.encodePacked("\x19Ethereum Signed Message:\n32", hash));
1433     }
1434 
1435     /**
1436      * @dev Returns an Ethereum Signed Typed Data, created from a
1437      * `domainSeparator` and a `structHash`. This produces hash corresponding
1438      * to the one signed with the
1439      * https://eips.ethereum.org/EIPS/eip-712[`eth_signTypedData`]
1440      * JSON-RPC method as part of EIP-712.
1441      *
1442      * See {recover}.
1443      */
1444     function toTypedDataHash(bytes32 domainSeparator, bytes32 structHash) internal pure returns (bytes32) {
1445         return keccak256(abi.encodePacked("\x19\x01", domainSeparator, structHash));
1446     }
1447 }
1448 
1449 
1450 
1451 
1452 pragma solidity ^0.8.4;
1453 
1454 /*
1455 MEATCUBES!
1456 
1457 */
1458 
1459 
1460 contract meatcubes is ERC721Enumerable, Ownable {
1461     using Strings for uint256;
1462     using ECDSA for bytes32;
1463 
1464     uint256 public constant MeatCube_PRIVATE = 1400;
1465     uint256 public constant MeatCube_PUBLIC = 5569;
1466     uint256 public constant MeatCube_MAX = MeatCube_PRIVATE + MeatCube_PUBLIC;
1467     uint256 public constant MeatCube_PRICE = 0.08 ether;
1468     uint256 public constant MeatCube_PER_MINT = 10;
1469 
1470 
1471     mapping(address => bool) public presalerList;
1472     mapping(address => uint256) public presalerListPurchases;
1473 
1474 
1475     string private _tokenBaseURI = "http://api.cubes.wtf/";
1476 
1477 
1478 
1479     uint256 public publicAmountMinted;
1480     uint256 public privateAmountMinted;
1481     uint256 public presalePurchaseLimit = 2;
1482     bool public presaleLive;
1483     bool public saleLive;
1484     bool public locked;
1485 
1486     address cm = 0xA0FBaDc4e39783b5DDB34179dc37B5a8C573DD23;
1487     address dv = 0xd7DBe51f9EBf734A5fd55C18002a063c6881d8b4;
1488     address kn = 0x435E6ef5310319353962A03F53A3d6823087e6A9;
1489 
1490     constructor() ERC721("MeatCube", "MEAT") { }
1491 
1492     modifier notLocked {
1493         require(!locked, "Contract metadata methods are locked");
1494         _;
1495     }
1496     function reserveMeatCube() public onlyOwner {
1497         uint supply= totalSupply();
1498         uint i;
1499         for (i = 1; i < 26; i++) {
1500             _safeMint(msg.sender, supply + i);
1501         }
1502     }
1503 
1504     function addToPresaleList(address[] calldata entries) external onlyOwner {
1505         for(uint256 i = 0; i < entries.length; i++) {
1506             address entry = entries[i];
1507             require(entry != address(0), "NULL_ADDRESS");
1508             require(!presalerList[entry], "DUPLICATE_ENTRY");
1509 
1510             presalerList[entry] = true;
1511         }
1512     }
1513 
1514     function removeFromPresaleList(address[] calldata entries) external onlyOwner {
1515         for(uint256 i = 0; i < entries.length; i++) {
1516             address entry = entries[i];
1517             require(entry != address(0), "NULL_ADDRESS");
1518 
1519             presalerList[entry] = false;
1520         }
1521     }
1522 
1523 
1524    //DM @Bennagins and ask him how much fun VUE routing is :)
1525 
1526     function buy(uint256 tokenQuantity) external payable {
1527         require(saleLive, "Sale is closed");
1528         require(!presaleLive, "Presale Only");
1529         require(totalSupply() < MeatCube_MAX, "All Meat Cubes have been minted");
1530         //require(publicAmountMinted + tokenQuantity <= MeatCube_PUBLIC, "EXCEED_PUBLIC"); People can buy as many as they want
1531         require(tokenQuantity <= MeatCube_PER_MINT, "Can not mint more than 10 meat cubes at a time");
1532         require(MeatCube_PRICE * tokenQuantity <= msg.value, "Not enough ETH");
1533 
1534         for(uint256 i = 0; i < tokenQuantity; i++) {
1535             publicAmountMinted++;
1536             _safeMint(msg.sender, totalSupply() + 1);
1537         }
1538 
1539 
1540     }
1541 
1542     function presaleBuy(uint256 tokenQuantity) external payable {
1543         require(!saleLive && presaleLive, "Presale is closed");
1544         require(presalerList[msg.sender], "ETH Address is not on the presale list");
1545         require(totalSupply() < MeatCube_MAX, "All Meat Cubes have been minted");
1546         require(privateAmountMinted + tokenQuantity <= MeatCube_PRIVATE, "Can only mint 2");
1547         require(presalerListPurchases[msg.sender] + tokenQuantity <= presalePurchaseLimit, "You already minted your 2 presale mints");
1548         require(MeatCube_PRICE * tokenQuantity <= msg.value, "Not enough ETH");
1549 
1550         for (uint256 i = 0; i < tokenQuantity; i++) {
1551             privateAmountMinted++;
1552             presalerListPurchases[msg.sender]++;
1553             _safeMint(msg.sender, totalSupply() + 1);
1554         }
1555     }
1556 
1557 
1558 
1559     function withdraw() external onlyOwner {
1560         uint balance = address(this).balance;
1561         payable(kn).transfer((balance*40)/100);
1562         payable(dv).transfer((balance*47)/100);
1563         payable(cm).transfer((balance*13)/100);
1564         payable(msg.sender).transfer(address(this).balance);
1565     }
1566 
1567 
1568     function isPresaler(address addr) external view returns (bool) {
1569         return presalerList[addr];
1570     }
1571 
1572     function presalePurchasedCount(address addr) external view returns (uint256) {
1573         return presalerListPurchases[addr];
1574     }
1575 
1576     // Owner functions for enabling presale, sale, revealing and setting the provenance hash
1577     function lockMetadata() external onlyOwner {
1578         locked = true;
1579     }
1580 
1581     function togglePresaleStatus() external onlyOwner {
1582         presaleLive = !presaleLive;
1583     }
1584 
1585     function toggleSaleStatus() external onlyOwner {
1586         saleLive = !saleLive;
1587     }
1588 
1589     function setBaseURI(string calldata URI) external onlyOwner notLocked {
1590         _tokenBaseURI = URI;
1591     }
1592 
1593     function tokenURI(uint256 tokenId) public view override(ERC721) returns (string memory) {
1594         require(_exists(tokenId), "Cannot query non-existent token");
1595 
1596         return string(abi.encodePacked(_tokenBaseURI, tokenId.toString()));
1597     }
1598 }