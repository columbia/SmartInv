1 // Sources flattened with hardhat v2.6.1 https://hardhat.org
2 
3 // File contracts/IERC165.sol
4 
5 // SPDX-License-Identifier: MIT
6 
7 pragma solidity ^0.8.0;
8 
9 /**
10  * @dev Interface of the ERC165 standard, as defined in the
11  * https://eips.ethereum.org/EIPS/eip-165[EIP].
12  *
13  * Implementers can declare support of contract interfaces, which can then be
14  * queried by others ({ERC165Checker}).
15  *
16  * For an implementation, see {ERC165}.
17  */
18 interface IERC165 {
19     /**
20      * @dev Returns true if this contract implements the interface defined by
21      * `interfaceId`. See the corresponding
22      * https://eips.ethereum.org/EIPS/eip-165#how-interfaces-are-identified[EIP section]
23      * to learn more about how these ids are created.
24      *
25      * This function call must use less than 30 000 gas.
26      */
27     function supportsInterface(bytes4 interfaceId) external view returns (bool);
28 }
29 
30 
31 // File contracts/ERC165.sol
32 
33 
34 
35 pragma solidity ^0.8.0;
36 
37 /**
38  * @dev Implementation of the {IERC165} interface.
39  *
40  * Contracts that want to implement ERC165 should inherit from this contract and override {supportsInterface} to check
41  * for the additional interface id that will be supported. For example:
42  *
43  * ```solidity
44  * function supportsInterface(bytes4 interfaceId) public view virtual override returns (bool) {
45  *     return interfaceId == type(MyInterface).interfaceId || super.supportsInterface(interfaceId);
46  * }
47  * ```
48  *
49  * Alternatively, {ERC165Storage} provides an easier to use but more expensive implementation.
50  */
51 abstract contract ERC165 is IERC165 {
52     /**
53      * @dev See {IERC165-supportsInterface}.
54      */
55     function supportsInterface(bytes4 interfaceId) public view virtual override returns (bool) {
56         return interfaceId == type(IERC165).interfaceId;
57     }
58 }
59 
60 
61 // File contracts/IERC721.sol
62 
63 
64 
65 pragma solidity ^0.8.0;
66 
67 /**
68  * @dev Required interface of an ERC721 compliant contract.
69  */
70 interface IERC721 is IERC165 {
71     /**
72      * @dev Emitted when `tokenId` token is transferred from `from` to `to`.
73      */
74     event Transfer(address indexed from, address indexed to, uint256 indexed tokenId);
75 
76     /**
77      * @dev Emitted when `owner` enables `approved` to manage the `tokenId` token.
78      */
79     event Approval(address indexed owner, address indexed approved, uint256 indexed tokenId);
80 
81     /**
82      * @dev Emitted when `owner` enables or disables (`approved`) `operator` to manage all of its assets.
83      */
84     event ApprovalForAll(address indexed owner, address indexed operator, bool approved);
85 
86     /**
87      * @dev Returns the number of tokens in ``owner``'s account.
88      */
89     function balanceOf(address owner) external view returns (uint256 balance);
90 
91     /**
92      * @dev Returns the owner of the `tokenId` token.
93      *
94      * Requirements:
95      *
96      * - `tokenId` must exist.
97      */
98     function ownerOf(uint256 tokenId) external view returns (address owner);
99 
100     /**
101      * @dev Safely transfers `tokenId` token from `from` to `to`, checking first that contract recipients
102      * are aware of the ERC721 protocol to prevent tokens from being forever locked.
103      *
104      * Requirements:
105      *
106      * - `from` cannot be the zero address.
107      * - `to` cannot be the zero address.
108      * - `tokenId` token must exist and be owned by `from`.
109      * - If the caller is not `from`, it must be have been allowed to move this token by either {approve} or {setApprovalForAll}.
110      * - If `to` refers to a smart contract, it must implement {IERC721Receiver-onERC721Received}, which is called upon a safe transfer.
111      *
112      * Emits a {Transfer} event.
113      */
114     function safeTransferFrom(
115         address from,
116         address to,
117         uint256 tokenId
118     ) external;
119 
120     /**
121      * @dev Transfers `tokenId` token from `from` to `to`.
122      *
123      * WARNING: Usage of this method is discouraged, use {safeTransferFrom} whenever possible.
124      *
125      * Requirements:
126      *
127      * - `from` cannot be the zero address.
128      * - `to` cannot be the zero address.
129      * - `tokenId` token must be owned by `from`.
130      * - If the caller is not `from`, it must be approved to move this token by either {approve} or {setApprovalForAll}.
131      *
132      * Emits a {Transfer} event.
133      */
134     function transferFrom(
135         address from,
136         address to,
137         uint256 tokenId
138     ) external;
139 
140     /**
141      * @dev Gives permission to `to` to transfer `tokenId` token to another account.
142      * The approval is cleared when the token is transferred.
143      *
144      * Only a single account can be approved at a time, so approving the zero address clears previous approvals.
145      *
146      * Requirements:
147      *
148      * - The caller must own the token or be an approved operator.
149      * - `tokenId` must exist.
150      *
151      * Emits an {Approval} event.
152      */
153     function approve(address to, uint256 tokenId) external;
154 
155     /**
156      * @dev Returns the account approved for `tokenId` token.
157      *
158      * Requirements:
159      *
160      * - `tokenId` must exist.
161      */
162     function getApproved(uint256 tokenId) external view returns (address operator);
163 
164     /**
165      * @dev Approve or remove `operator` as an operator for the caller.
166      * Operators can call {transferFrom} or {safeTransferFrom} for any token owned by the caller.
167      *
168      * Requirements:
169      *
170      * - The `operator` cannot be the caller.
171      *
172      * Emits an {ApprovalForAll} event.
173      */
174     function setApprovalForAll(address operator, bool _approved) external;
175 
176     /**
177      * @dev Returns if the `operator` is allowed to manage all of the assets of `owner`.
178      *
179      * See {setApprovalForAll}
180      */
181     function isApprovedForAll(address owner, address operator) external view returns (bool);
182 
183     /**
184      * @dev Safely transfers `tokenId` token from `from` to `to`.
185      *
186      * Requirements:
187      *
188      * - `from` cannot be the zero address.
189      * - `to` cannot be the zero address.
190      * - `tokenId` token must exist and be owned by `from`.
191      * - If the caller is not `from`, it must be approved to move this token by either {approve} or {setApprovalForAll}.
192      * - If `to` refers to a smart contract, it must implement {IERC721Receiver-onERC721Received}, which is called upon a safe transfer.
193      *
194      * Emits a {Transfer} event.
195      */
196     function safeTransferFrom(
197         address from,
198         address to,
199         uint256 tokenId,
200         bytes calldata data
201     ) external;
202 }
203 
204 
205 // File contracts/IERC721Receiver.sol
206 
207 
208 
209 pragma solidity ^0.8.0;
210 
211 /**
212  * @title ERC721 token receiver interface
213  * @dev Interface for any contract that wants to support safeTransfers
214  * from ERC721 asset contracts.
215  */
216 interface IERC721Receiver {
217     /**
218      * @dev Whenever an {IERC721} `tokenId` token is transferred to this contract via {IERC721-safeTransferFrom}
219      * by `operator` from `from`, this function is called.
220      *
221      * It must return its Solidity selector to confirm the token transfer.
222      * If any other value is returned or the interface is not implemented by the recipient, the transfer will be reverted.
223      *
224      * The selector can be obtained in Solidity with `IERC721.onERC721Received.selector`.
225      */
226     function onERC721Received(
227         address operator,
228         address from,
229         uint256 tokenId,
230         bytes calldata data
231     ) external returns (bytes4);
232 }
233 
234 
235 // File contracts/IERC721Metadata.sol
236 
237 
238 
239 pragma solidity ^0.8.0;
240 
241 /**
242  * @title ERC-721 Non-Fungible Token Standard, optional metadata extension
243  * @dev See https://eips.ethereum.org/EIPS/eip-721
244  */
245 interface IERC721Metadata is IERC721 {
246     /**
247      * @dev Returns the token collection name.
248      */
249     function name() external view returns (string memory);
250 
251     /**
252      * @dev Returns the token collection symbol.
253      */
254     function symbol() external view returns (string memory);
255 
256     /**
257      * @dev Returns the Uniform Resource Identifier (URI) for `tokenId` token.
258      */
259     function tokenURI(uint256 tokenId) external view returns (string memory);
260 }
261 
262 
263 // File contracts/Address.sol
264 
265 
266 
267 pragma solidity ^0.8.0;
268 
269 
270 /**
271  * @dev Collection of functions related to the address type
272  */
273 library Address {
274     /**
275      * @dev Returns true if `account` is a contract.
276      *
277      * [IMPORTANT]
278      * ====
279      * It is unsafe to assume that an address for which this function returns
280      * false is an externally-owned account (EOA) and not a contract.
281      *
282      * Among others, `isContract` will return false for the following
283      * types of addresses:
284      *
285      *  - an externally-owned account
286      *  - a contract in construction
287      *  - an address where a contract will be created
288      *  - an address where a contract lived, but was destroyed
289      * ====
290      */
291     function isContract(address account) internal view returns (bool) {
292         // This method relies on extcodesize, which returns 0 for contracts in
293         // construction, since the code is only stored at the end of the
294         // constructor execution.
295 
296         uint256 size;
297         assembly {
298             size := extcodesize(account)
299         }
300         return size > 0;
301     }
302 
303     /**
304      * @dev Replacement for Solidity's `transfer`: sends `amount` wei to
305      * `recipient`, forwarding all available gas and reverting on errors.
306      *
307      * https://eips.ethereum.org/EIPS/eip-1884[EIP1884] increases the gas cost
308      * of certain opcodes, possibly making contracts go over the 2300 gas limit
309      * imposed by `transfer`, making them unable to receive funds via
310      * `transfer`. {sendValue} removes this limitation.
311      *
312      * https://diligence.consensys.net/posts/2019/09/stop-using-soliditys-transfer-now/[Learn more].
313      *
314      * IMPORTANT: because control is transferred to `recipient`, care must be
315      * taken to not create reentrancy vulnerabilities. Consider using
316      * {ReentrancyGuard} or the
317      * https://solidity.readthedocs.io/en/v0.5.11/security-considerations.html#use-the-checks-effects-interactions-pattern[checks-effects-interactions pattern].
318      */
319     function sendValue(address payable recipient, uint256 amount) internal {
320         require(address(this).balance >= amount, "Address: insufficient balance");
321 
322         (bool success, ) = recipient.call{value: amount}("");
323         require(success, "Address: unable to send value, recipient may have reverted");
324     }
325 
326     /**
327      * @dev Performs a Solidity function call using a low level `call`. A
328      * plain `call` is an unsafe replacement for a function call: use this
329      * function instead.
330      *
331      * If `target` reverts with a revert reason, it is bubbled up by this
332      * function (like regular Solidity function calls).
333      *
334      * Returns the raw returned data. To convert to the expected return value,
335      * use https://solidity.readthedocs.io/en/latest/units-and-global-variables.html?highlight=abi.decode#abi-encoding-and-decoding-functions[`abi.decode`].
336      *
337      * Requirements:
338      *
339      * - `target` must be a contract.
340      * - calling `target` with `data` must not revert.
341      *
342      * _Available since v3.1._
343      */
344     function functionCall(address target, bytes memory data) internal returns (bytes memory) {
345         return functionCall(target, data, "Address: low-level call failed");
346     }
347 
348     /**
349      * @dev Same as {xref-Address-functionCall-address-bytes-}[`functionCall`], but with
350      * `errorMessage` as a fallback revert reason when `target` reverts.
351      *
352      * _Available since v3.1._
353      */
354     function functionCall(
355         address target,
356         bytes memory data,
357         string memory errorMessage
358     ) internal returns (bytes memory) {
359         return functionCallWithValue(target, data, 0, errorMessage);
360     }
361 
362     /**
363      * @dev Same as {xref-Address-functionCall-address-bytes-}[`functionCall`],
364      * but also transferring `value` wei to `target`.
365      *
366      * Requirements:
367      *
368      * - the calling contract must have an ETH balance of at least `value`.
369      * - the called Solidity function must be `payable`.
370      *
371      * _Available since v3.1._
372      */
373     function functionCallWithValue(
374         address target,
375         bytes memory data,
376         uint256 value
377     ) internal returns (bytes memory) {
378         return functionCallWithValue(target, data, value, "Address: low-level call with value failed");
379     }
380 
381     /**
382      * @dev Same as {xref-Address-functionCallWithValue-address-bytes-uint256-}[`functionCallWithValue`], but
383      * with `errorMessage` as a fallback revert reason when `target` reverts.
384      *
385      * _Available since v3.1._
386      */
387     function functionCallWithValue(
388         address target,
389         bytes memory data,
390         uint256 value,
391         string memory errorMessage
392     ) internal returns (bytes memory) {
393         require(address(this).balance >= value, "Address: insufficient balance for call");
394         require(isContract(target), "Address: call to non-contract");
395 
396         (bool success, bytes memory returndata) = target.call{value: value}(data);
397         return verifyCallResult(success, returndata, errorMessage);
398     }
399 
400     /**
401      * @dev Same as {xref-Address-functionCall-address-bytes-}[`functionCall`],
402      * but performing a static call.
403      *
404      * _Available since v3.3._
405      */
406     function functionStaticCall(address target, bytes memory data) internal view returns (bytes memory) {
407         return functionStaticCall(target, data, "Address: low-level static call failed");
408     }
409 
410     /**
411      * @dev Same as {xref-Address-functionCall-address-bytes-string-}[`functionCall`],
412      * but performing a static call.
413      *
414      * _Available since v3.3._
415      */
416     function functionStaticCall(
417         address target,
418         bytes memory data,
419         string memory errorMessage
420     ) internal view returns (bytes memory) {
421         require(isContract(target), "Address: static call to non-contract");
422 
423         (bool success, bytes memory returndata) = target.staticcall(data);
424         return verifyCallResult(success, returndata, errorMessage);
425     }
426 
427     /**
428      * @dev Same as {xref-Address-functionCall-address-bytes-}[`functionCall`],
429      * but performing a delegate call.
430      *
431      * _Available since v3.4._
432      */
433     function functionDelegateCall(address target, bytes memory data) internal returns (bytes memory) {
434         return functionDelegateCall(target, data, "Address: low-level delegate call failed");
435     }
436 
437     /**
438      * @dev Same as {xref-Address-functionCall-address-bytes-string-}[`functionCall`],
439      * but performing a delegate call.
440      *
441      * _Available since v3.4._
442      */
443     function functionDelegateCall(
444         address target,
445         bytes memory data,
446         string memory errorMessage
447     ) internal returns (bytes memory) {
448         require(isContract(target), "Address: delegate call to non-contract");
449 
450         (bool success, bytes memory returndata) = target.delegatecall(data);
451         return verifyCallResult(success, returndata, errorMessage);
452     }
453 
454     /**
455      * @dev Tool to verifies that a low level call was successful, and revert if it wasn't, either by bubbling the
456      * revert reason using the provided one.
457      *
458      * _Available since v4.3._
459      */
460     function verifyCallResult(
461         bool success,
462         bytes memory returndata,
463         string memory errorMessage
464     ) internal pure returns (bytes memory) {
465         if (success) {
466             return returndata;
467         } else {
468             // Look for revert reason and bubble it up if present
469             if (returndata.length > 0) {
470                 // The easiest way to bubble the revert reason is using memory via assembly
471 
472                 assembly {
473                     let returndata_size := mload(returndata)
474                     revert(add(32, returndata), returndata_size)
475                 }
476             } else {
477                 revert(errorMessage);
478             }
479         }
480     }
481 }
482 
483 
484 // File contracts/Context.sol
485 
486 
487 
488 pragma solidity ^0.8.0;
489 
490 /**
491  * @dev Provides information about the current execution context, including the
492  * sender of the transaction and its data. While these are generally available
493  * via msg.sender and msg.data, they should not be accessed in such a direct
494  * manner, since when dealing with meta-transactions the account sending and
495  * paying for execution may not be the actual sender (as far as an application
496  * is concerned).
497  *
498  * This contract is only required for intermediate, library-like contracts.
499  */
500 abstract contract Context {
501     function _msgSender() internal view virtual returns (address) {
502         return msg.sender;
503     }
504 
505     function _msgData() internal view virtual returns (bytes calldata) {
506         return msg.data;
507     }
508 }
509 
510 
511 // File contracts/Strings.sol
512 
513 
514 
515 pragma solidity ^0.8.0;
516 
517 /**
518  * @dev String operations.
519  */
520 library Strings {
521     bytes16 private constant _HEX_SYMBOLS = "0123456789abcdef";
522 
523     /**
524      * @dev Converts a `uint256` to its ASCII `string` decimal representation.
525      */
526     function toString(uint256 value) internal pure returns (string memory) {
527         // Inspired by OraclizeAPI's implementation - MIT licence
528         // https://github.com/oraclize/ethereum-api/blob/b42146b063c7d6ee1358846c198246239e9360e8/oraclizeAPI_0.4.25.sol
529 
530         if (value == 0) {
531             return "0";
532         }
533         uint256 temp = value;
534         uint256 digits;
535         while (temp != 0) {
536             digits++;
537             temp /= 10;
538         }
539         bytes memory buffer = new bytes(digits);
540         while (value != 0) {
541             digits -= 1;
542             buffer[digits] = bytes1(uint8(48 + uint256(value % 10)));
543             value /= 10;
544         }
545         return string(buffer);
546     }
547 
548     /**
549      * @dev Converts a `uint256` to its ASCII `string` hexadecimal representation.
550      */
551     function toHexString(uint256 value) internal pure returns (string memory) {
552         if (value == 0) {
553             return "0x00";
554         }
555         uint256 temp = value;
556         uint256 length = 0;
557         while (temp != 0) {
558             length++;
559             temp >>= 8;
560         }
561         return toHexString(value, length);
562     }
563 
564     /**
565      * @dev Converts a `uint256` to its ASCII `string` hexadecimal representation with fixed length.
566      */
567     function toHexString(uint256 value, uint256 length) internal pure returns (string memory) {
568         bytes memory buffer = new bytes(2 * length + 2);
569         buffer[0] = "0";
570         buffer[1] = "x";
571         for (uint256 i = 2 * length + 1; i > 1; --i) {
572             buffer[i] = _HEX_SYMBOLS[value & 0xf];
573             value >>= 4;
574         }
575         require(value == 0, "Strings: hex length insufficient");
576         return string(buffer);
577     }
578 }
579 
580 
581 // File contracts/ERC721.sol
582 
583 
584 
585 pragma solidity ^0.8.0;
586 
587 
588 
589 
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
994 // File contracts/IERC721Enumerable.sol
995 
996 
997 
998 pragma solidity ^0.8.0;
999 
1000 /**
1001  * @title ERC-721 Non-Fungible Token Standard, optional enumeration extension
1002  * @dev See https://eips.ethereum.org/EIPS/eip-721
1003  */
1004 interface IERC721Enumerable is IERC721 {
1005     /**
1006      * @dev Returns the total amount of tokens stored by the contract.
1007      */
1008     function totalSupply() external view returns (uint256);
1009 
1010     /**
1011      * @dev Returns a token ID owned by `owner` at a given `index` of its token list.
1012      * Use along with {balanceOf} to enumerate all of ``owner``'s tokens.
1013      */
1014     function tokenOfOwnerByIndex(address owner, uint256 index) external view returns (uint256 tokenId);
1015 
1016     /**
1017      * @dev Returns a token ID at a given `index` of all the tokens stored by the contract.
1018      * Use along with {totalSupply} to enumerate all tokens.
1019      */
1020     function tokenByIndex(uint256 index) external view returns (uint256);
1021 }
1022 
1023 
1024 // File contracts/ERC721Enumerable.sol
1025 
1026 
1027 
1028 pragma solidity ^0.8.0;
1029 
1030 
1031 /**
1032  * @dev This implements an optional extension of {ERC721} defined in the EIP that adds
1033  * enumerability of all the token ids in the contract as well as all token ids owned by each
1034  * account.
1035  */
1036 abstract contract ERC721Enumerable is ERC721, IERC721Enumerable {
1037     // Mapping from owner to list of owned token IDs
1038     mapping(address => mapping(uint256 => uint256)) private _ownedTokens;
1039 
1040     // Mapping from token ID to index of the owner tokens list
1041     mapping(uint256 => uint256) private _ownedTokensIndex;
1042 
1043     // Array with all token ids, used for enumeration
1044     uint256[] private _allTokens;
1045 
1046     // Mapping from token id to position in the allTokens array
1047     mapping(uint256 => uint256) private _allTokensIndex;
1048 
1049     /**
1050      * @dev See {IERC165-supportsInterface}.
1051      */
1052     function supportsInterface(bytes4 interfaceId) public view virtual override(IERC165, ERC721) returns (bool) {
1053         return interfaceId == type(IERC721Enumerable).interfaceId || super.supportsInterface(interfaceId);
1054     }
1055 
1056     /**
1057      * @dev See {IERC721Enumerable-tokenOfOwnerByIndex}.
1058      */
1059     function tokenOfOwnerByIndex(address owner, uint256 index) public view virtual override returns (uint256) {
1060         require(index < ERC721.balanceOf(owner), "ERC721Enumerable: owner index out of bounds");
1061         return _ownedTokens[owner][index];
1062     }
1063 
1064     /**
1065      * @dev See {IERC721Enumerable-totalSupply}.
1066      */
1067     function totalSupply() public view virtual override returns (uint256) {
1068         return _allTokens.length;
1069     }
1070 
1071     /**
1072      * @dev See {IERC721Enumerable-tokenByIndex}.
1073      */
1074     function tokenByIndex(uint256 index) public view virtual override returns (uint256) {
1075         require(index < ERC721Enumerable.totalSupply(), "ERC721Enumerable: global index out of bounds");
1076         return _allTokens[index];
1077     }
1078 
1079     /**
1080      * @dev Hook that is called before any token transfer. This includes minting
1081      * and burning.
1082      *
1083      * Calling conditions:
1084      *
1085      * - When `from` and `to` are both non-zero, ``from``'s `tokenId` will be
1086      * transferred to `to`.
1087      * - When `from` is zero, `tokenId` will be minted for `to`.
1088      * - When `to` is zero, ``from``'s `tokenId` will be burned.
1089      * - `from` cannot be the zero address.
1090      * - `to` cannot be the zero address.
1091      *
1092      * To learn more about hooks, head to xref:ROOT:extending-contracts.adoc#using-hooks[Using Hooks].
1093      */
1094     function _beforeTokenTransfer(
1095         address from,
1096         address to,
1097         uint256 tokenId
1098     ) internal virtual override {
1099         super._beforeTokenTransfer(from, to, tokenId);
1100 
1101         if (from == address(0)) {
1102             _addTokenToAllTokensEnumeration(tokenId);
1103         } else if (from != to) {
1104             _removeTokenFromOwnerEnumeration(from, tokenId);
1105         }
1106         if (to == address(0)) {
1107             _removeTokenFromAllTokensEnumeration(tokenId);
1108         } else if (to != from) {
1109             _addTokenToOwnerEnumeration(to, tokenId);
1110         }
1111     }
1112 
1113     /**
1114      * @dev Private function to add a token to this extension's ownership-tracking data structures.
1115      * @param to address representing the new owner of the given token ID
1116      * @param tokenId uint256 ID of the token to be added to the tokens list of the given address
1117      */
1118     function _addTokenToOwnerEnumeration(address to, uint256 tokenId) private {
1119         uint256 length = ERC721.balanceOf(to);
1120         _ownedTokens[to][length] = tokenId;
1121         _ownedTokensIndex[tokenId] = length;
1122     }
1123 
1124     /**
1125      * @dev Private function to add a token to this extension's token tracking data structures.
1126      * @param tokenId uint256 ID of the token to be added to the tokens list
1127      */
1128     function _addTokenToAllTokensEnumeration(uint256 tokenId) private {
1129         _allTokensIndex[tokenId] = _allTokens.length;
1130         _allTokens.push(tokenId);
1131     }
1132 
1133     /**
1134      * @dev Private function to remove a token from this extension's ownership-tracking data structures. Note that
1135      * while the token is not assigned a new owner, the `_ownedTokensIndex` mapping is _not_ updated: this allows for
1136      * gas optimizations e.g. when performing a transfer operation (avoiding double writes).
1137      * This has O(1) time complexity, but alters the order of the _ownedTokens array.
1138      * @param from address representing the previous owner of the given token ID
1139      * @param tokenId uint256 ID of the token to be removed from the tokens list of the given address
1140      */
1141     function _removeTokenFromOwnerEnumeration(address from, uint256 tokenId) private {
1142         // To prevent a gap in from's tokens array, we store the last token in the index of the token to delete, and
1143         // then delete the last slot (swap and pop).
1144 
1145         uint256 lastTokenIndex = ERC721.balanceOf(from) - 1;
1146         uint256 tokenIndex = _ownedTokensIndex[tokenId];
1147 
1148         // When the token to delete is the last token, the swap operation is unnecessary
1149         if (tokenIndex != lastTokenIndex) {
1150             uint256 lastTokenId = _ownedTokens[from][lastTokenIndex];
1151 
1152             _ownedTokens[from][tokenIndex] = lastTokenId; // Move the last token to the slot of the to-delete token
1153             _ownedTokensIndex[lastTokenId] = tokenIndex; // Update the moved token's index
1154         }
1155 
1156         // This also deletes the contents at the last position of the array
1157         delete _ownedTokensIndex[tokenId];
1158         delete _ownedTokens[from][lastTokenIndex];
1159     }
1160 
1161     /**
1162      * @dev Private function to remove a token from this extension's token tracking data structures.
1163      * This has O(1) time complexity, but alters the order of the _allTokens array.
1164      * @param tokenId uint256 ID of the token to be removed from the tokens list
1165      */
1166     function _removeTokenFromAllTokensEnumeration(uint256 tokenId) private {
1167         // To prevent a gap in the tokens array, we store the last token in the index of the token to delete, and
1168         // then delete the last slot (swap and pop).
1169 
1170         uint256 lastTokenIndex = _allTokens.length - 1;
1171         uint256 tokenIndex = _allTokensIndex[tokenId];
1172 
1173         // When the token to delete is the last token, the swap operation is unnecessary. However, since this occurs so
1174         // rarely (when the last minted token is burnt) that we still do the swap here to avoid the gas cost of adding
1175         // an 'if' statement (like in _removeTokenFromOwnerEnumeration)
1176         uint256 lastTokenId = _allTokens[lastTokenIndex];
1177 
1178         _allTokens[tokenIndex] = lastTokenId; // Move the last token to the slot of the to-delete token
1179         _allTokensIndex[lastTokenId] = tokenIndex; // Update the moved token's index
1180 
1181         // This also deletes the contents at the last position of the array
1182         delete _allTokensIndex[tokenId];
1183         _allTokens.pop();
1184     }
1185 }
1186 
1187 
1188 // File contracts/Ownable.sol
1189 
1190 
1191 
1192 pragma solidity ^0.8.0;
1193 
1194 /**
1195  * @dev Contract module which provides a basic access control mechanism, where
1196  * there is an account (an owner) that can be granted exclusive access to
1197  * specific functions.
1198  *
1199  * By default, the owner account will be the one that deploys the contract. This
1200  * can later be changed with {transferOwnership}.
1201  *
1202  * This module is used through inheritance. It will make available the modifier
1203  * `onlyOwner`, which can be applied to your functions to restrict their use to
1204  * the owner.
1205  */
1206 abstract contract Ownable is Context {
1207     address private _owner;
1208 
1209     event OwnershipTransferred(address indexed previousOwner, address indexed newOwner);
1210 
1211     /**
1212      * @dev Initializes the contract setting the deployer as the initial owner.
1213      */
1214     constructor() {
1215         _setOwner(_msgSender());
1216     }
1217 
1218     /**
1219      * @dev Returns the address of the current owner.
1220      */
1221     function owner() public view virtual returns (address) {
1222         return _owner;
1223     }
1224 
1225     /**
1226      * @dev Throws if called by any account other than the owner.
1227      */
1228     modifier onlyOwner() {
1229         require(owner() == _msgSender(), "Ownable: caller is not the owner");
1230         _;
1231     }
1232 
1233     /**
1234      * @dev Leaves the contract without owner. It will not be possible to call
1235      * `onlyOwner` functions anymore. Can only be called by the current owner.
1236      *
1237      * NOTE: Renouncing ownership will leave the contract without an owner,
1238      * thereby removing any functionality that is only available to the owner.
1239      */
1240     function renounceOwnership() public virtual onlyOwner {
1241         _setOwner(address(0));
1242     }
1243 
1244     /**
1245      * @dev Transfers ownership of the contract to a new account (`newOwner`).
1246      * Can only be called by the current owner.
1247      */
1248     function transferOwnership(address newOwner) public virtual onlyOwner {
1249         require(newOwner != address(0), "Ownable: new owner is the zero address");
1250         _setOwner(newOwner);
1251     }
1252 
1253     function _setOwner(address newOwner) private {
1254         address oldOwner = _owner;
1255         _owner = newOwner;
1256         emit OwnershipTransferred(oldOwner, newOwner);
1257     }
1258 }
1259 
1260 
1261 // File contracts/ECDSA.sol
1262 
1263 
1264 
1265 pragma solidity ^0.8.0;
1266 
1267 /**
1268  * @dev Elliptic Curve Digital Signature Algorithm (ECDSA) operations.
1269  *
1270  * These functions can be used to verify that a message was signed by the holder
1271  * of the private keys of a given address.
1272  */
1273 library ECDSA {
1274     enum RecoverError {
1275         NoError,
1276         InvalidSignature,
1277         InvalidSignatureLength,
1278         InvalidSignatureS,
1279         InvalidSignatureV
1280     }
1281 
1282     function _throwError(RecoverError error) private pure {
1283         if (error == RecoverError.NoError) {
1284             return; // no error: do nothing
1285         } else if (error == RecoverError.InvalidSignature) {
1286             revert("ECDSA: invalid signature");
1287         } else if (error == RecoverError.InvalidSignatureLength) {
1288             revert("ECDSA: invalid signature length");
1289         } else if (error == RecoverError.InvalidSignatureS) {
1290             revert("ECDSA: invalid signature 's' value");
1291         } else if (error == RecoverError.InvalidSignatureV) {
1292             revert("ECDSA: invalid signature 'v' value");
1293         }
1294     }
1295 
1296     /**
1297      * @dev Returns the address that signed a hashed message (`hash`) with
1298      * `signature` or error string. This address can then be used for verification purposes.
1299      *
1300      * The `ecrecover` EVM opcode allows for malleable (non-unique) signatures:
1301      * this function rejects them by requiring the `s` value to be in the lower
1302      * half order, and the `v` value to be either 27 or 28.
1303      *
1304      * IMPORTANT: `hash` _must_ be the result of a hash operation for the
1305      * verification to be secure: it is possible to craft signatures that
1306      * recover to arbitrary addresses for non-hashed data. A safe way to ensure
1307      * this is by receiving a hash of the original message (which may otherwise
1308      * be too long), and then calling {toEthSignedMessageHash} on it.
1309      *
1310      * Documentation for signature generation:
1311      * - with https://web3js.readthedocs.io/en/v1.3.4/web3-eth-accounts.html#sign[Web3.js]
1312      * - with https://docs.ethers.io/v5/api/signer/#Signer-signMessage[ethers]
1313      *
1314      * _Available since v4.3._
1315      */
1316     function tryRecover(bytes32 hash, bytes memory signature) internal pure returns (address, RecoverError) {
1317         // Check the signature length
1318         // - case 65: r,s,v signature (standard)
1319         // - case 64: r,vs signature (cf https://eips.ethereum.org/EIPS/eip-2098) _Available since v4.1._
1320         if (signature.length == 65) {
1321             bytes32 r;
1322             bytes32 s;
1323             uint8 v;
1324             // ecrecover takes the signature parameters, and the only way to get them
1325             // currently is to use assembly.
1326             assembly {
1327                 r := mload(add(signature, 0x20))
1328                 s := mload(add(signature, 0x40))
1329                 v := byte(0, mload(add(signature, 0x60)))
1330             }
1331             return tryRecover(hash, v, r, s);
1332         } else if (signature.length == 64) {
1333             bytes32 r;
1334             bytes32 vs;
1335             // ecrecover takes the signature parameters, and the only way to get them
1336             // currently is to use assembly.
1337             assembly {
1338                 r := mload(add(signature, 0x20))
1339                 vs := mload(add(signature, 0x40))
1340             }
1341             return tryRecover(hash, r, vs);
1342         } else {
1343             return (address(0), RecoverError.InvalidSignatureLength);
1344         }
1345     }
1346 
1347     /**
1348      * @dev Returns the address that signed a hashed message (`hash`) with
1349      * `signature`. This address can then be used for verification purposes.
1350      *
1351      * The `ecrecover` EVM opcode allows for malleable (non-unique) signatures:
1352      * this function rejects them by requiring the `s` value to be in the lower
1353      * half order, and the `v` value to be either 27 or 28.
1354      *
1355      * IMPORTANT: `hash` _must_ be the result of a hash operation for the
1356      * verification to be secure: it is possible to craft signatures that
1357      * recover to arbitrary addresses for non-hashed data. A safe way to ensure
1358      * this is by receiving a hash of the original message (which may otherwise
1359      * be too long), and then calling {toEthSignedMessageHash} on it.
1360      */
1361     function recover(bytes32 hash, bytes memory signature) internal pure returns (address) {
1362         (address recovered, RecoverError error) = tryRecover(hash, signature);
1363         _throwError(error);
1364         return recovered;
1365     }
1366 
1367     /**
1368      * @dev Overload of {ECDSA-tryRecover} that receives the `r` and `vs` short-signature fields separately.
1369      *
1370      * See https://eips.ethereum.org/EIPS/eip-2098[EIP-2098 short signatures]
1371      *
1372      * _Available since v4.3._
1373      */
1374     function tryRecover(
1375         bytes32 hash,
1376         bytes32 r,
1377         bytes32 vs
1378     ) internal pure returns (address, RecoverError) {
1379         bytes32 s;
1380         uint8 v;
1381         assembly {
1382             s := and(vs, 0x7fffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffff)
1383             v := add(shr(255, vs), 27)
1384         }
1385         return tryRecover(hash, v, r, s);
1386     }
1387 
1388     /**
1389      * @dev Overload of {ECDSA-recover} that receives the `r and `vs` short-signature fields separately.
1390      *
1391      * _Available since v4.2._
1392      */
1393     function recover(
1394         bytes32 hash,
1395         bytes32 r,
1396         bytes32 vs
1397     ) internal pure returns (address) {
1398         (address recovered, RecoverError error) = tryRecover(hash, r, vs);
1399         _throwError(error);
1400         return recovered;
1401     }
1402 
1403     /**
1404      * @dev Overload of {ECDSA-tryRecover} that receives the `v`,
1405      * `r` and `s` signature fields separately.
1406      *
1407      * _Available since v4.3._
1408      */
1409     function tryRecover(
1410         bytes32 hash,
1411         uint8 v,
1412         bytes32 r,
1413         bytes32 s
1414     ) internal pure returns (address, RecoverError) {
1415         // EIP-2 still allows signature malleability for ecrecover(). Remove this possibility and make the signature
1416         // unique. Appendix F in the Ethereum Yellow paper (https://ethereum.github.io/yellowpaper/paper.pdf), defines
1417         // the valid range for s in (301): 0 < s < secp256k1n ÷ 2 + 1, and for v in (302): v ∈ {27, 28}. Most
1418         // signatures from current libraries generate a unique signature with an s-value in the lower half order.
1419         //
1420         // If your library generates malleable signatures, such as s-values in the upper range, calculate a new s-value
1421         // with 0xFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFEBAAEDCE6AF48A03BBFD25E8CD0364141 - s1 and flip v from 27 to 28 or
1422         // vice versa. If your library also generates signatures with 0/1 for v instead 27/28, add 27 to v to accept
1423         // these malleable signatures as well.
1424         if (uint256(s) > 0x7FFFFFFFFFFFFFFFFFFFFFFFFFFFFFFF5D576E7357A4501DDFE92F46681B20A0) {
1425             return (address(0), RecoverError.InvalidSignatureS);
1426         }
1427         if (v != 27 && v != 28) {
1428             return (address(0), RecoverError.InvalidSignatureV);
1429         }
1430 
1431         // If the signature is valid (and not malleable), return the signer address
1432         address signer = ecrecover(hash, v, r, s);
1433         if (signer == address(0)) {
1434             return (address(0), RecoverError.InvalidSignature);
1435         }
1436 
1437         return (signer, RecoverError.NoError);
1438     }
1439 
1440     /**
1441      * @dev Overload of {ECDSA-recover} that receives the `v`,
1442      * `r` and `s` signature fields separately.
1443      */
1444     function recover(
1445         bytes32 hash,
1446         uint8 v,
1447         bytes32 r,
1448         bytes32 s
1449     ) internal pure returns (address) {
1450         (address recovered, RecoverError error) = tryRecover(hash, v, r, s);
1451         _throwError(error);
1452         return recovered;
1453     }
1454 
1455     /**
1456      * @dev Returns an Ethereum Signed Message, created from a `hash`. This
1457      * produces hash corresponding to the one signed with the
1458      * https://eth.wiki/json-rpc/API#eth_sign[`eth_sign`]
1459      * JSON-RPC method as part of EIP-191.
1460      *
1461      * See {recover}.
1462      */
1463     function toEthSignedMessageHash(bytes32 hash) internal pure returns (bytes32) {
1464         // 32 is the length in bytes of hash,
1465         // enforced by the type signature above
1466         return keccak256(abi.encodePacked("\x19Ethereum Signed Message:\n32", hash));
1467     }
1468 
1469     /**
1470      * @dev Returns an Ethereum Signed Typed Data, created from a
1471      * `domainSeparator` and a `structHash`. This produces hash corresponding
1472      * to the one signed with the
1473      * https://eips.ethereum.org/EIPS/eip-712[`eth_signTypedData`]
1474      * JSON-RPC method as part of EIP-712.
1475      *
1476      * See {recover}.
1477      */
1478     function toTypedDataHash(bytes32 domainSeparator, bytes32 structHash) internal pure returns (bytes32) {
1479         return keccak256(abi.encodePacked("\x19\x01", domainSeparator, structHash));
1480     }
1481 }
1482 
1483 
1484 // File contracts/Staches.sol
1485 
1486 
1487 
1488 pragma solidity ^0.8.9;
1489 
1490 
1491 
1492 contract StachesNFT is ERC721Enumerable, Ownable {
1493   using ECDSA for bytes32;
1494 
1495   uint256 public mintPrice = 0.1 ether;
1496 
1497   string _baseTokenURI;
1498 
1499   bool public isActive = false;
1500 
1501   uint256 public maximumMintSupply = 300;
1502   uint256 public maximumAllowedTokensPerPurchase = 10;
1503 
1504   address private devAddress = 0x97CBb7061AE346600C393dbE3A361772AA2D1E4d;
1505   uint256 private devFee = 5;
1506   
1507   event SaleActivation(bool isActive);
1508 
1509   constructor(string memory baseURI) ERC721("StachesNFT", "STACH") {
1510     setBaseURI(baseURI);
1511   }
1512 
1513   modifier saleIsOpen {
1514     require(totalSupply() <= maximumMintSupply, "Sale has ended.");
1515     _;
1516   }
1517 
1518   modifier onlyAuthorized() {
1519     require(owner() == msg.sender);
1520     _;
1521   }
1522 
1523   function setMaximumAllowedTokens(uint256 _count) public onlyAuthorized {
1524     maximumAllowedTokensPerPurchase = _count;
1525   }
1526 
1527   function setActive(bool val) public onlyAuthorized {
1528     isActive = val;
1529     emit SaleActivation(val);
1530   }
1531 
1532   function setDevAddress(address addr) public onlyAuthorized {
1533     devAddress = addr;
1534   }
1535 
1536   function setDevFee(uint256 fee) public onlyAuthorized {
1537     devFee = fee;
1538   }
1539 
1540   function setMaxMintSupply(uint256 maxMintSupply) external onlyAuthorized {
1541     maximumMintSupply = maxMintSupply;
1542   }
1543 
1544   function setPrice(uint256 _price) public onlyAuthorized {
1545     mintPrice = _price;
1546   }
1547 
1548   function setBaseURI(string memory baseURI) public onlyAuthorized {
1549     _baseTokenURI = baseURI;
1550   }
1551 
1552   function getMaximumAllowedTokens() public view onlyAuthorized returns (uint256) {
1553     return maximumAllowedTokensPerPurchase;
1554   }
1555 
1556   function getPrice() external view returns (uint256) {
1557     return mintPrice;
1558   }
1559 
1560   function getTotalSupply() external view returns (uint256) {
1561     return totalSupply();
1562   }
1563 
1564   function getContractOwner() public view returns (address) {
1565     return owner();
1566   }
1567 
1568   function _baseURI() internal view virtual override returns (string memory) {
1569     return _baseTokenURI;
1570   }
1571 
1572   function baseTokenURI() public view returns (string memory) {
1573     return _baseTokenURI;
1574   }
1575 
1576   function tokenURI(uint256 _tokenId) override public view returns (string memory) {
1577     return string(abi.encodePacked(baseTokenURI(), Strings.toString(_tokenId), '.json'));
1578   }
1579 
1580   function mint(uint256 _count) public payable saleIsOpen {
1581     if (msg.sender != owner()) {
1582       require(isActive, "Sale is not active currently.");
1583     }
1584 
1585     require(totalSupply() + _count <= maximumMintSupply, "Total supply exceeded.");
1586     require(totalSupply() <= maximumMintSupply, "Total supply spent.");
1587     require(
1588       _count <= maximumAllowedTokensPerPurchase,
1589       "Exceeds maximum allowed tokens"
1590     );
1591     require(msg.value >= mintPrice * _count, "Insuffient ETH amount sent.");
1592 
1593     for (uint256 i = 0; i < _count; i++) {
1594       _safeMint(msg.sender, totalSupply()+1);
1595     }
1596 
1597     payable(devAddress).transfer(msg.value*devFee/100);
1598   }
1599 
1600   function walletOfOwner(address _owner) external view returns(uint256[] memory) {
1601     uint tokenCount = balanceOf(_owner);
1602     uint256[] memory tokensId = new uint256[](tokenCount);
1603 
1604     for(uint i = 0; i < tokenCount; i++){
1605       tokensId[i] = tokenOfOwnerByIndex(_owner, i);
1606     }
1607     return tokensId;
1608   }
1609 
1610   function withdraw() external onlyAuthorized {
1611     uint balance = address(this).balance;
1612     payable(owner()).transfer(balance);
1613   }
1614 }