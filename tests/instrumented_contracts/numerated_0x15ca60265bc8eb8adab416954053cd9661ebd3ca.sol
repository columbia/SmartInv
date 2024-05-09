1 // SPDX-License-Identifier: MIT
2 // OpenZeppelin Contracts v4.4.0 (utils/introspection/IERC165.sol)
3 
4 pragma solidity 0.8.7;
5 
6 /**
7  * @dev Interface of the ERC165 standard, as defined in the
8  * https://eips.ethereum.org/EIPS/eip-165[EIP].
9  *
10  * Implementers can declare support of contract interfaces, which can then be
11  * queried by others ({ERC165Checker}).
12  *
13  * For an implementation, see {ERC165}.
14  */
15 interface IERC165 {
16     /**
17      * @dev Returns true if this contract implements the interface defined by
18      * `interfaceId`. See the corresponding
19      * https://eips.ethereum.org/EIPS/eip-165#how-interfaces-are-identified[EIP section]
20      * to learn more about how these ids are created.
21      *
22      * This function call must use less than 30 000 gas.
23      */
24     function supportsInterface(bytes4 interfaceId) external view returns (bool);
25 }
26 
27 // File: @openzeppelin/contracts/token/ERC721/IERC721.sol
28 
29 
30 // OpenZeppelin Contracts v4.4.0 (token/ERC721/IERC721.sol)
31 
32 
33 
34 
35 /**
36  * @dev Required interface of an ERC721 compliant contract.
37  */
38 interface IERC721 is IERC165 {
39     /**
40      * @dev Emitted when `tokenId` token is transferred from `from` to `to`.
41      */
42     event Transfer(address indexed from, address indexed to, uint256 indexed tokenId);
43 
44     /**
45      * @dev Emitted when `owner` enables `approved` to manage the `tokenId` token.
46      */
47     event Approval(address indexed owner, address indexed approved, uint256 indexed tokenId);
48 
49     /**
50      * @dev Emitted when `owner` enables or disables (`approved`) `operator` to manage all of its assets.
51      */
52     event ApprovalForAll(address indexed owner, address indexed operator, bool approved);
53 
54     /**
55      * @dev Returns the number of tokens in ``owner``'s account.
56      */
57     function balanceOf(address owner) external view returns (uint256 balance);
58 
59     /**
60      * @dev Returns the owner of the `tokenId` token.
61      *
62      * Requirements:
63      *
64      * - `tokenId` must exist.
65      */
66     function ownerOf(uint256 tokenId) external view returns (address owner);
67 
68     /**
69      * @dev Safely transfers `tokenId` token from `from` to `to`, checking first that contract recipients
70      * are aware of the ERC721 protocol to prevent tokens from being forever locked.
71      *
72      * Requirements:
73      *
74      * - `from` cannot be the zero address.
75      * - `to` cannot be the zero address.
76      * - `tokenId` token must exist and be owned by `from`.
77      * - If the caller is not `from`, it must be have been allowed to move this token by either {approve} or {setApprovalForAll}.
78      * - If `to` refers to a smart contract, it must implement {IERC721Receiver-onERC721Received}, which is called upon a safe transfer.
79      *
80      * Emits a {Transfer} event.
81      */
82     function safeTransferFrom(
83         address from,
84         address to,
85         uint256 tokenId
86     ) external;
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
102     function transferFrom(
103         address from,
104         address to,
105         uint256 tokenId
106     ) external;
107 
108     /**
109      * @dev Gives permission to `to` to transfer `tokenId` token to another account.
110      * The approval is cleared when the token is transferred.
111      *
112      * Only a single account can be approved at a time, so approving the zero address clears previous approvals.
113      *
114      * Requirements:
115      *
116      * - The caller must own the token or be an approved operator.
117      * - `tokenId` must exist.
118      *
119      * Emits an {Approval} event.
120      */
121     function approve(address to, uint256 tokenId) external;
122 
123     /**
124      * @dev Returns the account approved for `tokenId` token.
125      *
126      * Requirements:
127      *
128      * - `tokenId` must exist.
129      */
130     function getApproved(uint256 tokenId) external view returns (address operator);
131 
132     /**
133      * @dev Approve or remove `operator` as an operator for the caller.
134      * Operators can call {transferFrom} or {safeTransferFrom} for any token owned by the caller.
135      *
136      * Requirements:
137      *
138      * - The `operator` cannot be the caller.
139      *
140      * Emits an {ApprovalForAll} event.
141      */
142     function setApprovalForAll(address operator, bool _approved) external;
143 
144     /**
145      * @dev Returns if the `operator` is allowed to manage all of the assets of `owner`.
146      *
147      * See {setApprovalForAll}
148      */
149     function isApprovedForAll(address owner, address operator) external view returns (bool);
150 
151     /**
152      * @dev Safely transfers `tokenId` token from `from` to `to`.
153      *
154      * Requirements:
155      *
156      * - `from` cannot be the zero address.
157      * - `to` cannot be the zero address.
158      * - `tokenId` token must exist and be owned by `from`.
159      * - If the caller is not `from`, it must be approved to move this token by either {approve} or {setApprovalForAll}.
160      * - If `to` refers to a smart contract, it must implement {IERC721Receiver-onERC721Received}, which is called upon a safe transfer.
161      *
162      * Emits a {Transfer} event.
163      */
164     function safeTransferFrom(
165         address from,
166         address to,
167         uint256 tokenId,
168         bytes calldata data
169     ) external;
170 }
171 
172 // File: @openzeppelin/contracts/token/ERC721/IERC721Receiver.sol
173 
174 
175 // OpenZeppelin Contracts v4.4.0 (token/ERC721/IERC721Receiver.sol)
176 
177 
178 
179 /**
180  * @title ERC721 token receiver interface
181  * @dev Interface for any contract that wants to support safeTransfers
182  * from ERC721 asset contracts.
183  */
184 interface IERC721Receiver {
185     /**
186      * @dev Whenever an {IERC721} `tokenId` token is transferred to this contract via {IERC721-safeTransferFrom}
187      * by `operator` from `from`, this function is called.
188      *
189      * It must return its Solidity selector to confirm the token transfer.
190      * If any other value is returned or the interface is not implemented by the recipient, the transfer will be reverted.
191      *
192      * The selector can be obtained in Solidity with `IERC721.onERC721Received.selector`.
193      */
194     function onERC721Received(
195         address operator,
196         address from,
197         uint256 tokenId,
198         bytes calldata data
199     ) external returns (bytes4);
200 }
201 
202 // File: @openzeppelin/contracts/token/ERC721/extensions/IERC721Metadata.sol
203 
204 
205 // OpenZeppelin Contracts v4.4.0 (token/ERC721/extensions/IERC721Metadata.sol)
206 
207 
208 
209 
210 /**
211  * @title ERC-721 Non-Fungible Token Standard, optional metadata extension
212  * @dev See https://eips.ethereum.org/EIPS/eip-721
213  */
214 interface IERC721Metadata is IERC721 {
215     /**
216      * @dev Returns the token collection name.
217      */
218     function name() external view returns (string memory);
219 
220     /**
221      * @dev Returns the token collection symbol.
222      */
223     function symbol() external view returns (string memory);
224 
225     /**
226      * @dev Returns the Uniform Resource Identifier (URI) for `tokenId` token.
227      */
228     function tokenURI(uint256 tokenId) external view returns (string memory);
229 }
230 
231 // File: @openzeppelin/contracts/utils/Address.sol
232 
233 
234 // OpenZeppelin Contracts v4.4.0 (utils/Address.sol)
235 
236 
237 
238 /**
239  * @dev Collection of functions related to the address type
240  */
241 library Address {
242     /**
243      * @dev Returns true if `account` is a contract.
244      *
245      * [IMPORTANT]
246      * ====
247      * It is unsafe to assume that an address for which this function returns
248      * false is an externally-owned account (EOA) and not a contract.
249      *
250      * Among others, `isContract` will return false for the following
251      * types of addresses:
252      *
253      *  - an externally-owned account
254      *  - a contract in construction
255      *  - an address where a contract will be created
256      *  - an address where a contract lived, but was destroyed
257      * ====
258      */
259     function isContract(address account) internal view returns (bool) {
260         // This method relies on extcodesize, which returns 0 for contracts in
261         // construction, since the code is only stored at the end of the
262         // constructor execution.
263 
264         uint256 size;
265         assembly {
266             size := extcodesize(account)
267         }
268         return size > 0;
269     }
270 
271     /**
272      * @dev Replacement for Solidity's `transfer`: sends `amount` wei to
273      * `recipient`, forwarding all available gas and reverting on errors.
274      *
275      * https://eips.ethereum.org/EIPS/eip-1884[EIP1884] increases the gas cost
276      * of certain opcodes, possibly making contracts go over the 2300 gas limit
277      * imposed by `transfer`, making them unable to receive funds via
278      * `transfer`. {sendValue} removes this limitation.
279      *
280      * https://diligence.consensys.net/posts/2019/09/stop-using-soliditys-transfer-now/[Learn more].
281      *
282      * IMPORTANT: because control is transferred to `recipient`, care must be
283      * taken to not create reentrancy vulnerabilities. Consider using
284      * {ReentrancyGuard} or the
285      * https://solidity.readthedocs.io/en/v0.5.11/security-considerations.html#use-the-checks-effects-interactions-pattern[checks-effects-interactions pattern].
286      */
287     function sendValue(address payable recipient, uint256 amount) internal {
288         require(address(this).balance >= amount, "Address: insufficient balance");
289 
290         (bool success, ) = recipient.call{value: amount}("");
291         require(success, "Address: unable to send value, recipient may have reverted");
292     }
293 
294     /**
295      * @dev Performs a Solidity function call using a low level `call`. A
296      * plain `call` is an unsafe replacement for a function call: use this
297      * function instead.
298      *
299      * If `target` reverts with a revert reason, it is bubbled up by this
300      * function (like regular Solidity function calls).
301      *
302      * Returns the raw returned data. To convert to the expected return value,
303      * use https://solidity.readthedocs.io/en/latest/units-and-global-variables.html?highlight=abi.decode#abi-encoding-and-decoding-functions[`abi.decode`].
304      *
305      * Requirements:
306      *
307      * - `target` must be a contract.
308      * - calling `target` with `data` must not revert.
309      *
310      * _Available since v3.1._
311      */
312     function functionCall(address target, bytes memory data) internal returns (bytes memory) {
313         return functionCall(target, data, "Address: low-level call failed");
314     }
315 
316     /**
317      * @dev Same as {xref-Address-functionCall-address-bytes-}[`functionCall`], but with
318      * `errorMessage` as a fallback revert reason when `target` reverts.
319      *
320      * _Available since v3.1._
321      */
322     function functionCall(
323         address target,
324         bytes memory data,
325         string memory errorMessage
326     ) internal returns (bytes memory) {
327         return functionCallWithValue(target, data, 0, errorMessage);
328     }
329 
330     /**
331      * @dev Same as {xref-Address-functionCall-address-bytes-}[`functionCall`],
332      * but also transferring `value` wei to `target`.
333      *
334      * Requirements:
335      *
336      * - the calling contract must have an ETH balance of at least `value`.
337      * - the called Solidity function must be `payable`.
338      *
339      * _Available since v3.1._
340      */
341     function functionCallWithValue(
342         address target,
343         bytes memory data,
344         uint256 value
345     ) internal returns (bytes memory) {
346         return functionCallWithValue(target, data, value, "Address: low-level call with value failed");
347     }
348 
349     /**
350      * @dev Same as {xref-Address-functionCallWithValue-address-bytes-uint256-}[`functionCallWithValue`], but
351      * with `errorMessage` as a fallback revert reason when `target` reverts.
352      *
353      * _Available since v3.1._
354      */
355     function functionCallWithValue(
356         address target,
357         bytes memory data,
358         uint256 value,
359         string memory errorMessage
360     ) internal returns (bytes memory) {
361         require(address(this).balance >= value, "Address: insufficient balance for call");
362         require(isContract(target), "Address: call to non-contract");
363 
364         (bool success, bytes memory returndata) = target.call{value: value}(data);
365         return verifyCallResult(success, returndata, errorMessage);
366     }
367 
368     /**
369      * @dev Same as {xref-Address-functionCall-address-bytes-}[`functionCall`],
370      * but performing a static call.
371      *
372      * _Available since v3.3._
373      */
374     function functionStaticCall(address target, bytes memory data) internal view returns (bytes memory) {
375         return functionStaticCall(target, data, "Address: low-level static call failed");
376     }
377 
378     /**
379      * @dev Same as {xref-Address-functionCall-address-bytes-string-}[`functionCall`],
380      * but performing a static call.
381      *
382      * _Available since v3.3._
383      */
384     function functionStaticCall(
385         address target,
386         bytes memory data,
387         string memory errorMessage
388     ) internal view returns (bytes memory) {
389         require(isContract(target), "Address: static call to non-contract");
390 
391         (bool success, bytes memory returndata) = target.staticcall(data);
392         return verifyCallResult(success, returndata, errorMessage);
393     }
394 
395     /**
396      * @dev Same as {xref-Address-functionCall-address-bytes-}[`functionCall`],
397      * but performing a delegate call.
398      *
399      * _Available since v3.4._
400      */
401     function functionDelegateCall(address target, bytes memory data) internal returns (bytes memory) {
402         return functionDelegateCall(target, data, "Address: low-level delegate call failed");
403     }
404 
405     /**
406      * @dev Same as {xref-Address-functionCall-address-bytes-string-}[`functionCall`],
407      * but performing a delegate call.
408      *
409      * _Available since v3.4._
410      */
411     function functionDelegateCall(
412         address target,
413         bytes memory data,
414         string memory errorMessage
415     ) internal returns (bytes memory) {
416         require(isContract(target), "Address: delegate call to non-contract");
417 
418         (bool success, bytes memory returndata) = target.delegatecall(data);
419         return verifyCallResult(success, returndata, errorMessage);
420     }
421 
422     /**
423      * @dev Tool to verifies that a low level call was successful, and revert if it wasn't, either by bubbling the
424      * revert reason using the provided one.
425      *
426      * _Available since v4.3._
427      */
428     function verifyCallResult(
429         bool success,
430         bytes memory returndata,
431         string memory errorMessage
432     ) internal pure returns (bytes memory) {
433         if (success) {
434             return returndata;
435         } else {
436             // Look for revert reason and bubble it up if present
437             if (returndata.length > 0) {
438                 // The easiest way to bubble the revert reason is using memory via assembly
439 
440                 assembly {
441                     let returndata_size := mload(returndata)
442                     revert(add(32, returndata), returndata_size)
443                 }
444             } else {
445                 revert(errorMessage);
446             }
447         }
448     }
449 }
450 
451 // File: @openzeppelin/contracts/utils/Context.sol
452 
453 
454 // OpenZeppelin Contracts v4.4.0 (utils/Context.sol)
455 
456 
457 
458 /**
459  * @dev Provides information about the current execution context, including the
460  * sender of the transaction and its data. While these are generally available
461  * via msg.sender and msg.data, they should not be accessed in such a direct
462  * manner, since when dealing with meta-transactions the account sending and
463  * paying for execution may not be the actual sender (as far as an application
464  * is concerned).
465  *
466  * This contract is only required for intermediate, library-like contracts.
467  */
468 abstract contract Context {
469     function _msgSender() internal view virtual returns (address) {
470         return msg.sender;
471     }
472 
473     function _msgData() internal view virtual returns (bytes calldata) {
474         return msg.data;
475     }
476 }
477 
478 // File: @openzeppelin/contracts/utils/Strings.sol
479 
480 
481 // OpenZeppelin Contracts v4.4.0 (utils/Strings.sol)
482 
483 
484 
485 /**
486  * @dev String operations.
487  */
488 library Strings {
489     bytes16 private constant _HEX_SYMBOLS = "0123456789abcdef";
490 
491     /**
492      * @dev Converts a `uint256` to its ASCII `string` decimal representation.
493      */
494     function toString(uint256 value) internal pure returns (string memory) {
495         // Inspired by OraclizeAPI's implementation - MIT licence
496         // https://github.com/oraclize/ethereum-api/blob/b42146b063c7d6ee1358846c198246239e9360e8/oraclizeAPI_0.4.25.sol
497 
498         if (value == 0) {
499             return "0";
500         }
501         uint256 temp = value;
502         uint256 digits;
503         while (temp != 0) {
504             digits++;
505             temp /= 10;
506         }
507         bytes memory buffer = new bytes(digits);
508         while (value != 0) {
509             digits -= 1;
510             buffer[digits] = bytes1(uint8(48 + uint256(value % 10)));
511             value /= 10;
512         }
513         return string(buffer);
514     }
515 
516     /**
517      * @dev Converts a `uint256` to its ASCII `string` hexadecimal representation.
518      */
519     function toHexString(uint256 value) internal pure returns (string memory) {
520         if (value == 0) {
521             return "0x00";
522         }
523         uint256 temp = value;
524         uint256 length = 0;
525         while (temp != 0) {
526             length++;
527             temp >>= 8;
528         }
529         return toHexString(value, length);
530     }
531 
532     /**
533      * @dev Converts a `uint256` to its ASCII `string` hexadecimal representation with fixed length.
534      */
535     function toHexString(uint256 value, uint256 length) internal pure returns (string memory) {
536         bytes memory buffer = new bytes(2 * length + 2);
537         buffer[0] = "0";
538         buffer[1] = "x";
539         for (uint256 i = 2 * length + 1; i > 1; --i) {
540             buffer[i] = _HEX_SYMBOLS[value & 0xf];
541             value >>= 4;
542         }
543         require(value == 0, "Strings: hex length insufficient");
544         return string(buffer);
545     }
546 }
547 
548 // File: @openzeppelin/contracts/utils/introspection/ERC165.sol
549 
550 
551 // OpenZeppelin Contracts v4.4.0 (utils/introspection/ERC165.sol)
552 
553 
554 
555 
556 /**
557  * @dev Implementation of the {IERC165} interface.
558  *
559  * Contracts that want to implement ERC165 should inherit from this contract and override {supportsInterface} to check
560  * for the additional interface id that will be supported. For example:
561  *
562  * ```solidity
563  * function supportsInterface(bytes4 interfaceId) public view virtual override returns (bool) {
564  *     return interfaceId == type(MyInterface).interfaceId || super.supportsInterface(interfaceId);
565  * }
566  * ```
567  *
568  * Alternatively, {ERC165Storage} provides an easier to use but more expensive implementation.
569  */
570 abstract contract ERC165 is IERC165 {
571     /**
572      * @dev See {IERC165-supportsInterface}.
573      */
574     function supportsInterface(bytes4 interfaceId) public view virtual override returns (bool) {
575         return interfaceId == type(IERC165).interfaceId;
576     }
577 }
578 
579 // File: @openzeppelin/contracts/token/ERC721/ERC721.sol
580 
581 
582 // OpenZeppelin Contracts v4.4.0 (token/ERC721/ERC721.sol)
583 
584 
585 
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
716         _setApprovalForAll(_msgSender(), operator, approved);
717     }
718 
719     /**
720      * @dev See {IERC721-isApprovedForAll}.
721      */
722     function isApprovedForAll(address owner, address operator) public view virtual override returns (bool) {
723         return _operatorApprovals[owner][operator];
724     }
725 
726     /**
727      * @dev See {IERC721-transferFrom}.
728      */
729     function transferFrom(
730         address from,
731         address to,
732         uint256 tokenId
733     ) public virtual override {
734         //solhint-disable-next-line max-line-length
735         require(_isApprovedOrOwner(_msgSender(), tokenId), "ERC721: transfer caller is not owner nor approved");
736 
737         _transfer(from, to, tokenId);
738     }
739 
740     /**
741      * @dev See {IERC721-safeTransferFrom}.
742      */
743     function safeTransferFrom(
744         address from,
745         address to,
746         uint256 tokenId
747     ) public virtual override {
748         safeTransferFrom(from, to, tokenId, "");
749     }
750 
751     /**
752      * @dev See {IERC721-safeTransferFrom}.
753      */
754     function safeTransferFrom(
755         address from,
756         address to,
757         uint256 tokenId,
758         bytes memory _data
759     ) public virtual override {
760         require(_isApprovedOrOwner(_msgSender(), tokenId), "ERC721: transfer caller is not owner nor approved");
761         _safeTransfer(from, to, tokenId, _data);
762     }
763 
764     /**
765      * @dev Safely transfers `tokenId` token from `from` to `to`, checking first that contract recipients
766      * are aware of the ERC721 protocol to prevent tokens from being forever locked.
767      *
768      * `_data` is additional data, it has no specified format and it is sent in call to `to`.
769      *
770      * This internal function is equivalent to {safeTransferFrom}, and can be used to e.g.
771      * implement alternative mechanisms to perform token transfer, such as signature-based.
772      *
773      * Requirements:
774      *
775      * - `from` cannot be the zero address.
776      * - `to` cannot be the zero address.
777      * - `tokenId` token must exist and be owned by `from`.
778      * - If `to` refers to a smart contract, it must implement {IERC721Receiver-onERC721Received}, which is called upon a safe transfer.
779      *
780      * Emits a {Transfer} event.
781      */
782     function _safeTransfer(
783         address from,
784         address to,
785         uint256 tokenId,
786         bytes memory _data
787     ) internal virtual {
788         _transfer(from, to, tokenId);
789         require(_checkOnERC721Received(from, to, tokenId, _data), "ERC721: transfer to non ERC721Receiver implementer");
790     }
791 
792     /**
793      * @dev Returns whether `tokenId` exists.
794      *
795      * Tokens can be managed by their owner or approved accounts via {approve} or {setApprovalForAll}.
796      *
797      * Tokens start existing when they are minted (`_mint`),
798      * and stop existing when they are burned (`_burn`).
799      */
800     function _exists(uint256 tokenId) internal view virtual returns (bool) {
801         return _owners[tokenId] != address(0);
802     }
803 
804     /**
805      * @dev Returns whether `spender` is allowed to manage `tokenId`.
806      *
807      * Requirements:
808      *
809      * - `tokenId` must exist.
810      */
811     function _isApprovedOrOwner(address spender, uint256 tokenId) internal view virtual returns (bool) {
812         require(_exists(tokenId), "ERC721: operator query for nonexistent token");
813         address owner = ERC721.ownerOf(tokenId);
814         return (spender == owner || getApproved(tokenId) == spender || isApprovedForAll(owner, spender));
815     }
816 
817     /**
818      * @dev Safely mints `tokenId` and transfers it to `to`.
819      *
820      * Requirements:
821      *
822      * - `tokenId` must not exist.
823      * - If `to` refers to a smart contract, it must implement {IERC721Receiver-onERC721Received}, which is called upon a safe transfer.
824      *
825      * Emits a {Transfer} event.
826      */
827     function _safeMint(address to, uint256 tokenId) internal virtual {
828         _safeMint(to, tokenId, "");
829     }
830 
831     /**
832      * @dev Same as {xref-ERC721-_safeMint-address-uint256-}[`_safeMint`], with an additional `data` parameter which is
833      * forwarded in {IERC721Receiver-onERC721Received} to contract recipients.
834      */
835     function _safeMint(
836         address to,
837         uint256 tokenId,
838         bytes memory _data
839     ) internal virtual {
840         _mint(to, tokenId);
841         require(
842             _checkOnERC721Received(address(0), to, tokenId, _data),
843             "ERC721: transfer to non ERC721Receiver implementer"
844         );
845     }
846 
847     /**
848      * @dev Mints `tokenId` and transfers it to `to`.
849      *
850      * WARNING: Usage of this method is discouraged, use {_safeMint} whenever possible
851      *
852      * Requirements:
853      *
854      * - `tokenId` must not exist.
855      * - `to` cannot be the zero address.
856      *
857      * Emits a {Transfer} event.
858      */
859     function _mint(address to, uint256 tokenId) internal virtual {
860         require(to != address(0), "ERC721: mint to the zero address");
861         require(!_exists(tokenId), "ERC721: token already minted");
862 
863         _beforeTokenTransfer(address(0), to, tokenId);
864 
865         _balances[to] += 1;
866         _owners[tokenId] = to;
867 
868         emit Transfer(address(0), to, tokenId);
869     }
870 
871     /**
872      * @dev Destroys `tokenId`.
873      * The approval is cleared when the token is burned.
874      *
875      * Requirements:
876      *
877      * - `tokenId` must exist.
878      *
879      * Emits a {Transfer} event.
880      */
881     function _burn(uint256 tokenId) internal virtual {
882         address owner = ERC721.ownerOf(tokenId);
883 
884         _beforeTokenTransfer(owner, address(0), tokenId);
885 
886         // Clear approvals
887         _approve(address(0), tokenId);
888 
889         _balances[owner] -= 1;
890         delete _owners[tokenId];
891 
892         emit Transfer(owner, address(0), tokenId);
893     }
894 
895     /**
896      * @dev Transfers `tokenId` from `from` to `to`.
897      *  As opposed to {transferFrom}, this imposes no restrictions on msg.sender.
898      *
899      * Requirements:
900      *
901      * - `to` cannot be the zero address.
902      * - `tokenId` token must be owned by `from`.
903      *
904      * Emits a {Transfer} event.
905      */
906     function _transfer(
907         address from,
908         address to,
909         uint256 tokenId
910     ) internal virtual {
911         require(ERC721.ownerOf(tokenId) == from, "ERC721: transfer of token that is not own");
912         require(to != address(0), "ERC721: transfer to the zero address");
913 
914         _beforeTokenTransfer(from, to, tokenId);
915 
916         // Clear approvals from the previous owner
917         _approve(address(0), tokenId);
918 
919         _balances[from] -= 1;
920         _balances[to] += 1;
921         _owners[tokenId] = to;
922 
923         emit Transfer(from, to, tokenId);
924     }
925 
926     /**
927      * @dev Approve `to` to operate on `tokenId`
928      *
929      * Emits a {Approval} event.
930      */
931     function _approve(address to, uint256 tokenId) internal virtual {
932         _tokenApprovals[tokenId] = to;
933         emit Approval(ERC721.ownerOf(tokenId), to, tokenId);
934     }
935 
936     /**
937      * @dev Approve `operator` to operate on all of `owner` tokens
938      *
939      * Emits a {ApprovalForAll} event.
940      */
941     function _setApprovalForAll(
942         address owner,
943         address operator,
944         bool approved
945     ) internal virtual {
946         require(owner != operator, "ERC721: approve to caller");
947         _operatorApprovals[owner][operator] = approved;
948         emit ApprovalForAll(owner, operator, approved);
949     }
950 
951     /**
952      * @dev Internal function to invoke {IERC721Receiver-onERC721Received} on a target address.
953      * The call is not executed if the target address is not a contract.
954      *
955      * @param from address representing the previous owner of the given token ID
956      * @param to target address that will receive the tokens
957      * @param tokenId uint256 ID of the token to be transferred
958      * @param _data bytes optional data to send along with the call
959      * @return bool whether the call correctly returned the expected magic value
960      */
961     function _checkOnERC721Received(
962         address from,
963         address to,
964         uint256 tokenId,
965         bytes memory _data
966     ) private returns (bool) {
967         if (to.isContract()) {
968             try IERC721Receiver(to).onERC721Received(_msgSender(), from, tokenId, _data) returns (bytes4 retval) {
969                 return retval == IERC721Receiver.onERC721Received.selector;
970             } catch (bytes memory reason) {
971                 if (reason.length == 0) {
972                     revert("ERC721: transfer to non ERC721Receiver implementer");
973                 } else {
974                     assembly {
975                         revert(add(32, reason), mload(reason))
976                     }
977                 }
978             }
979         } else {
980             return true;
981         }
982     }
983 
984     /**
985      * @dev Hook that is called before any token transfer. This includes minting
986      * and burning.
987      *
988      * Calling conditions:
989      *
990      * - When `from` and `to` are both non-zero, ``from``'s `tokenId` will be
991      * transferred to `to`.
992      * - When `from` is zero, `tokenId` will be minted for `to`.
993      * - When `to` is zero, ``from``'s `tokenId` will be burned.
994      * - `from` and `to` are never both zero.
995      *
996      * To learn more about hooks, head to xref:ROOT:extending-contracts.adoc#using-hooks[Using Hooks].
997      */
998     function _beforeTokenTransfer(
999         address from,
1000         address to,
1001         uint256 tokenId
1002     ) internal virtual {}
1003 }
1004 
1005 // File: @openzeppelin/contracts/access/Ownable.sol
1006 
1007 
1008 // OpenZeppelin Contracts v4.4.0 (access/Ownable.sol)
1009 
1010 
1011 
1012 
1013 /**
1014  * @dev Contract module which provides a basic access control mechanism, where
1015  * there is an account (an owner) that can be granted exclusive access to
1016  * specific functions.
1017  *
1018  * By default, the owner account will be the one that deploys the contract. This
1019  * can later be changed with {transferOwnership}.
1020  *
1021  * This module is used through inheritance. It will make available the modifier
1022  * `onlyOwner`, which can be applied to your functions to restrict their use to
1023  * the owner.
1024  */
1025 abstract contract Ownable is Context {
1026     address private _owner;
1027 
1028     event OwnershipTransferred(address indexed previousOwner, address indexed newOwner);
1029 
1030     /**
1031      * @dev Initializes the contract setting the deployer as the initial owner.
1032      */
1033     constructor() {
1034         _transferOwnership(_msgSender());
1035     }
1036 
1037     /**
1038      * @dev Returns the address of the current owner.
1039      */
1040     function owner() public view virtual returns (address) {
1041         return _owner;
1042     }
1043 
1044     /**
1045      * @dev Throws if called by any account other than the owner.
1046      */
1047     modifier onlyOwner() {
1048         require(owner() == _msgSender(), "Ownable: caller is not the owner");
1049         _;
1050     }
1051 
1052     /**
1053      * @dev Leaves the contract without owner. It will not be possible to call
1054      * `onlyOwner` functions anymore. Can only be called by the current owner.
1055      *
1056      * NOTE: Renouncing ownership will leave the contract without an owner,
1057      * thereby removing any functionality that is only available to the owner.
1058      */
1059     function renounceOwnership() public virtual onlyOwner {
1060         _transferOwnership(address(0));
1061     }
1062 
1063     /**
1064      * @dev Transfers ownership of the contract to a new account (`newOwner`).
1065      * Can only be called by the current owner.
1066      */
1067     function transferOwnership(address newOwner) public virtual onlyOwner {
1068         require(newOwner != address(0), "Ownable: new owner is the zero address");
1069         _transferOwnership(newOwner);
1070     }
1071 
1072     /**
1073      * @dev Transfers ownership of the contract to a new account (`newOwner`).
1074      * Internal function without access restriction.
1075      */
1076     function _transferOwnership(address newOwner) internal virtual {
1077         address oldOwner = _owner;
1078         _owner = newOwner;
1079         emit OwnershipTransferred(oldOwner, newOwner);
1080     }
1081 }
1082 
1083 // File: @openzeppelin/contracts/utils/Counters.sol
1084 
1085 
1086 // OpenZeppelin Contracts v4.4.0 (utils/Counters.sol)
1087 
1088 
1089 
1090 /**
1091  * @title Counters
1092  * @author Matt Condon (@shrugs)
1093  * @dev Provides counters that can only be incremented, decremented or reset. This can be used e.g. to track the number
1094  * of elements in a mapping, issuing ERC721 ids, or counting request ids.
1095  *
1096  * Include with `using Counters for Counters.Counter;`
1097  */
1098 library Counters {
1099     struct Counter {
1100         // This variable should never be directly accessed by users of the library: interactions must be restricted to
1101         // the library's function. As of Solidity v0.5.2, this cannot be enforced, though there is a proposal to add
1102         // this feature: see https://github.com/ethereum/solidity/issues/4637
1103         uint256 _value; // default: 0
1104     }
1105 
1106     function current(Counter storage counter) internal view returns (uint256) {
1107         return counter._value;
1108     }
1109 
1110     function increment(Counter storage counter) internal {
1111         unchecked {
1112             counter._value += 1;
1113         }
1114     }
1115 
1116     function decrement(Counter storage counter) internal {
1117         uint256 value = counter._value;
1118         require(value > 0, "Counter: decrement overflow");
1119         unchecked {
1120             counter._value = value - 1;
1121         }
1122     }
1123 
1124     function reset(Counter storage counter) internal {
1125         counter._value = 0;
1126     }
1127 }
1128 
1129 // File: @openzeppelin/contracts/utils/cryptography/MerkleProof.sol
1130 
1131 
1132 // OpenZeppelin Contracts v4.4.0 (utils/cryptography/MerkleProof.sol)
1133 
1134 
1135 
1136 /**
1137  * @dev These functions deal with verification of Merkle Trees proofs.
1138  *
1139  * The proofs can be generated using the JavaScript library
1140  * https://github.com/miguelmota/merkletreejs[merkletreejs].
1141  * Note: the hashing algorithm should be keccak256 and pair sorting should be enabled.
1142  *
1143  * See `test/utils/cryptography/MerkleProof.test.js` for some examples.
1144  */
1145 library MerkleProof {
1146     /**
1147      * @dev Returns true if a `leaf` can be proved to be a part of a Merkle tree
1148      * defined by `root`. For this, a `proof` must be provided, containing
1149      * sibling hashes on the branch from the leaf to the root of the tree. Each
1150      * pair of leaves and each pair of pre-images are assumed to be sorted.
1151      */
1152     function verify(
1153         bytes32[] memory proof,
1154         bytes32 root,
1155         bytes32 leaf
1156     ) internal pure returns (bool) {
1157         return processProof(proof, leaf) == root;
1158     }
1159 
1160     /**
1161      * @dev Returns the rebuilt hash obtained by traversing a Merklee tree up
1162      * from `leaf` using `proof`. A `proof` is valid if and only if the rebuilt
1163      * hash matches the root of the tree. When processing the proof, the pairs
1164      * of leafs & pre-images are assumed to be sorted.
1165      *
1166      * _Available since v4.4._
1167      */
1168     function processProof(bytes32[] memory proof, bytes32 leaf) internal pure returns (bytes32) {
1169         bytes32 computedHash = leaf;
1170         for (uint256 i = 0; i < proof.length; i++) {
1171             bytes32 proofElement = proof[i];
1172             if (computedHash <= proofElement) {
1173                 // Hash(current computed hash + current element of the proof)
1174                 computedHash = keccak256(abi.encodePacked(computedHash, proofElement));
1175             } else {
1176                 // Hash(current element of the proof + current computed hash)
1177                 computedHash = keccak256(abi.encodePacked(proofElement, computedHash));
1178             }
1179         }
1180         return computedHash;
1181     }
1182 }
1183 
1184 // File: @openzeppelin/contracts/utils/cryptography/ECDSA.sol
1185 
1186 
1187 // OpenZeppelin Contracts v4.4.0 (utils/cryptography/ECDSA.sol)
1188 
1189 
1190 
1191 
1192 /**
1193  * @dev Elliptic Curve Digital Signature Algorithm (ECDSA) operations.
1194  *
1195  * These functions can be used to verify that a message was signed by the holder
1196  * of the private keys of a given address.
1197  */
1198 library ECDSA {
1199     enum RecoverError {
1200         NoError,
1201         InvalidSignature,
1202         InvalidSignatureLength,
1203         InvalidSignatureS,
1204         InvalidSignatureV
1205     }
1206 
1207     function _throwError(RecoverError error) private pure {
1208         if (error == RecoverError.NoError) {
1209             return; // no error: do nothing
1210         } else if (error == RecoverError.InvalidSignature) {
1211             revert("ECDSA: invalid signature");
1212         } else if (error == RecoverError.InvalidSignatureLength) {
1213             revert("ECDSA: invalid signature length");
1214         } else if (error == RecoverError.InvalidSignatureS) {
1215             revert("ECDSA: invalid signature 's' value");
1216         } else if (error == RecoverError.InvalidSignatureV) {
1217             revert("ECDSA: invalid signature 'v' value");
1218         }
1219     }
1220 
1221     /**
1222      * @dev Returns the address that signed a hashed message (`hash`) with
1223      * `signature` or error string. This address can then be used for verification purposes.
1224      *
1225      * The `ecrecover` EVM opcode allows for malleable (non-unique) signatures:
1226      * this function rejects them by requiring the `s` value to be in the lower
1227      * half order, and the `v` value to be either 27 or 28.
1228      *
1229      * IMPORTANT: `hash` _must_ be the result of a hash operation for the
1230      * verification to be secure: it is possible to craft signatures that
1231      * recover to arbitrary addresses for non-hashed data. A safe way to ensure
1232      * this is by receiving a hash of the original message (which may otherwise
1233      * be too long), and then calling {toEthSignedMessageHash} on it.
1234      *
1235      * Documentation for signature generation:
1236      * - with https://web3js.readthedocs.io/en/v1.3.4/web3-eth-accounts.html#sign[Web3.js]
1237      * - with https://docs.ethers.io/v5/api/signer/#Signer-signMessage[ethers]
1238      *
1239      * _Available since v4.3._
1240      */
1241     function tryRecover(bytes32 hash, bytes memory signature) internal pure returns (address, RecoverError) {
1242         // Check the signature length
1243         // - case 65: r,s,v signature (standard)
1244         // - case 64: r,vs signature (cf https://eips.ethereum.org/EIPS/eip-2098) _Available since v4.1._
1245         if (signature.length == 65) {
1246             bytes32 r;
1247             bytes32 s;
1248             uint8 v;
1249             // ecrecover takes the signature parameters, and the only way to get them
1250             // currently is to use assembly.
1251             assembly {
1252                 r := mload(add(signature, 0x20))
1253                 s := mload(add(signature, 0x40))
1254                 v := byte(0, mload(add(signature, 0x60)))
1255             }
1256             return tryRecover(hash, v, r, s);
1257         } else if (signature.length == 64) {
1258             bytes32 r;
1259             bytes32 vs;
1260             // ecrecover takes the signature parameters, and the only way to get them
1261             // currently is to use assembly.
1262             assembly {
1263                 r := mload(add(signature, 0x20))
1264                 vs := mload(add(signature, 0x40))
1265             }
1266             return tryRecover(hash, r, vs);
1267         } else {
1268             return (address(0), RecoverError.InvalidSignatureLength);
1269         }
1270     }
1271 
1272     /**
1273      * @dev Returns the address that signed a hashed message (`hash`) with
1274      * `signature`. This address can then be used for verification purposes.
1275      *
1276      * The `ecrecover` EVM opcode allows for malleable (non-unique) signatures:
1277      * this function rejects them by requiring the `s` value to be in the lower
1278      * half order, and the `v` value to be either 27 or 28.
1279      *
1280      * IMPORTANT: `hash` _must_ be the result of a hash operation for the
1281      * verification to be secure: it is possible to craft signatures that
1282      * recover to arbitrary addresses for non-hashed data. A safe way to ensure
1283      * this is by receiving a hash of the original message (which may otherwise
1284      * be too long), and then calling {toEthSignedMessageHash} on it.
1285      */
1286     function recover(bytes32 hash, bytes memory signature) internal pure returns (address) {
1287         (address recovered, RecoverError error) = tryRecover(hash, signature);
1288         _throwError(error);
1289         return recovered;
1290     }
1291 
1292     /**
1293      * @dev Overload of {ECDSA-tryRecover} that receives the `r` and `vs` short-signature fields separately.
1294      *
1295      * See https://eips.ethereum.org/EIPS/eip-2098[EIP-2098 short signatures]
1296      *
1297      * _Available since v4.3._
1298      */
1299     function tryRecover(
1300         bytes32 hash,
1301         bytes32 r,
1302         bytes32 vs
1303     ) internal pure returns (address, RecoverError) {
1304         bytes32 s;
1305         uint8 v;
1306         assembly {
1307             s := and(vs, 0x7fffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffff)
1308             v := add(shr(255, vs), 27)
1309         }
1310         return tryRecover(hash, v, r, s);
1311     }
1312 
1313     /**
1314      * @dev Overload of {ECDSA-recover} that receives the `r and `vs` short-signature fields separately.
1315      *
1316      * _Available since v4.2._
1317      */
1318     function recover(
1319         bytes32 hash,
1320         bytes32 r,
1321         bytes32 vs
1322     ) internal pure returns (address) {
1323         (address recovered, RecoverError error) = tryRecover(hash, r, vs);
1324         _throwError(error);
1325         return recovered;
1326     }
1327 
1328     /**
1329      * @dev Overload of {ECDSA-tryRecover} that receives the `v`,
1330      * `r` and `s` signature fields separately.
1331      *
1332      * _Available since v4.3._
1333      */
1334     function tryRecover(
1335         bytes32 hash,
1336         uint8 v,
1337         bytes32 r,
1338         bytes32 s
1339     ) internal pure returns (address, RecoverError) {
1340         // EIP-2 still allows signature malleability for ecrecover(). Remove this possibility and make the signature
1341         // unique. Appendix F in the Ethereum Yellow paper (https://ethereum.github.io/yellowpaper/paper.pdf), defines
1342         // the valid range for s in (301): 0 < s < secp256k1n ÷ 2 + 1, and for v in (302): v ∈ {27, 28}. Most
1343         // signatures from current libraries generate a unique signature with an s-value in the lower half order.
1344         //
1345         // If your library generates malleable signatures, such as s-values in the upper range, calculate a new s-value
1346         // with 0xFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFEBAAEDCE6AF48A03BBFD25E8CD0364141 - s1 and flip v from 27 to 28 or
1347         // vice versa. If your library also generates signatures with 0/1 for v instead 27/28, add 27 to v to accept
1348         // these malleable signatures as well.
1349         if (uint256(s) > 0x7FFFFFFFFFFFFFFFFFFFFFFFFFFFFFFF5D576E7357A4501DDFE92F46681B20A0) {
1350             return (address(0), RecoverError.InvalidSignatureS);
1351         }
1352         if (v != 27 && v != 28) {
1353             return (address(0), RecoverError.InvalidSignatureV);
1354         }
1355 
1356         // If the signature is valid (and not malleable), return the signer address
1357         address signer = ecrecover(hash, v, r, s);
1358         if (signer == address(0)) {
1359             return (address(0), RecoverError.InvalidSignature);
1360         }
1361 
1362         return (signer, RecoverError.NoError);
1363     }
1364 
1365     /**
1366      * @dev Overload of {ECDSA-recover} that receives the `v`,
1367      * `r` and `s` signature fields separately.
1368      */
1369     function recover(
1370         bytes32 hash,
1371         uint8 v,
1372         bytes32 r,
1373         bytes32 s
1374     ) internal pure returns (address) {
1375         (address recovered, RecoverError error) = tryRecover(hash, v, r, s);
1376         _throwError(error);
1377         return recovered;
1378     }
1379 
1380     /**
1381      * @dev Returns an Ethereum Signed Message, created from a `hash`. This
1382      * produces hash corresponding to the one signed with the
1383      * https://eth.wiki/json-rpc/API#eth_sign[`eth_sign`]
1384      * JSON-RPC method as part of EIP-191.
1385      *
1386      * See {recover}.
1387      */
1388     function toEthSignedMessageHash(bytes32 hash) internal pure returns (bytes32) {
1389         // 32 is the length in bytes of hash,
1390         // enforced by the type signature above
1391         return keccak256(abi.encodePacked("\x19Ethereum Signed Message:\n32", hash));
1392     }
1393 
1394     /**
1395      * @dev Returns an Ethereum Signed Message, created from `s`. This
1396      * produces hash corresponding to the one signed with the
1397      * https://eth.wiki/json-rpc/API#eth_sign[`eth_sign`]
1398      * JSON-RPC method as part of EIP-191.
1399      *
1400      * See {recover}.
1401      */
1402     function toEthSignedMessageHash(bytes memory s) internal pure returns (bytes32) {
1403         return keccak256(abi.encodePacked("\x19Ethereum Signed Message:\n", Strings.toString(s.length), s));
1404     }
1405 
1406     /**
1407      * @dev Returns an Ethereum Signed Typed Data, created from a
1408      * `domainSeparator` and a `structHash`. This produces hash corresponding
1409      * to the one signed with the
1410      * https://eips.ethereum.org/EIPS/eip-712[`eth_signTypedData`]
1411      * JSON-RPC method as part of EIP-712.
1412      *
1413      * See {recover}.
1414      */
1415     function toTypedDataHash(bytes32 domainSeparator, bytes32 structHash) internal pure returns (bytes32) {
1416         return keccak256(abi.encodePacked("\x19\x01", domainSeparator, structHash));
1417     }
1418 }
1419 
1420 // File: contracts/Buidlverse.sol
1421 
1422 
1423 
1424 
1425 
1426 
1427 
1428 
1429 
1430 
1431 
1432 /**
1433  * @title Buidlverse ERC721 contract
1434  * @dev This contract inherits from ERC721, but does not have the ERC721Enumerable extension.
1435  * ERC721Enumerable was deemed not worthwhile for the added mint and transfer costs
1436  */
1437 contract Buidlverse is ERC721, Ownable {
1438   using MerkleProof for bytes32[];
1439   using ECDSA for bytes32;
1440   using Strings for uint256;
1441   using Counters for Counters.Counter;
1442 
1443   Counters.Counter private idCounter;
1444 
1445   string public provenanceHash = "";
1446 
1447   string public baseURI;
1448   string public baseExtension = ".json";
1449 
1450   uint256 public maxSupply;
1451   uint256 public cost = 0;
1452   uint256 public maxMintAmount = 20;
1453 
1454   bool public paused = false;
1455 
1456   uint256 public whitelistIndex = 1; // if 0, no whitelist is active, if >0, use Merkle whitelist
1457   mapping (uint256 => mapping (address => bool)) public whitelistClaimed; // index -> user -> claimed or not
1458   bytes32 public whitelistMerkleRoot;
1459 
1460   constructor(
1461     string memory _name,
1462     string memory _symbol,
1463     string memory _newBaseURI,
1464     uint256 _maxSupply
1465   ) ERC721(_name, _symbol) {
1466     baseURI = _newBaseURI;
1467     maxSupply = _maxSupply;
1468   }
1469 
1470   // internal
1471   function _baseURI() internal view virtual override returns (string memory) {
1472     return baseURI;
1473   }
1474 
1475   /**
1476   * @dev internally mints new tokenIds to target. tokenIds are incremented and minted in sequential order.
1477   * @param _to address to mint new tokenIds to
1478   * @param _mintAmount amount of new tokenIds to mint
1479   */
1480   function _mintInternal(address _to, uint256 _mintAmount) internal {
1481     require(!paused, "the contract is paused");
1482 
1483     require(_mintAmount > 0, "need to mint at least 1");
1484     require(_mintAmount <= maxMintAmount, "cannot mint more than maxMintAmount per call");
1485     require(totalSupply() + _mintAmount <= maxSupply, "exceeded max token limit");
1486     require(msg.value >= cost * _mintAmount, "insufficient funds");
1487 
1488     for (uint256 i = 0; i < _mintAmount; i++) {
1489       idCounter.increment();
1490       _safeMint(_to, idCounter.current());
1491     }
1492   }
1493 
1494   // public
1495   /**
1496   * @notice get metadata URI for a given tokenId
1497   */
1498   function tokenURI(uint256 tokenId) public view virtual override returns (string memory) {
1499     require(
1500       _exists(tokenId),
1501       "ERC721Metadata: URI query for nonexistent token"
1502     );
1503     
1504     string memory currentBaseURI = _baseURI();
1505     return bytes(currentBaseURI).length > 0
1506         ? string(abi.encodePacked(currentBaseURI, tokenId.toString(), baseExtension))
1507         : "";
1508   }
1509 
1510   /**
1511   * @notice get base metadata URI for all tokenIds and the collection
1512   */
1513   function baseTokenURI() public view returns (string memory) {
1514     return _baseURI();
1515   }
1516 
1517   /**
1518   * @notice get the latest tokenId
1519   */
1520   function currentId() public view returns (uint) {
1521     return idCounter.current();
1522   }
1523 
1524   /**
1525   * @notice get the total number of minted tokenIds
1526   */
1527   function totalSupply() public view returns (uint256) {
1528     return idCounter.current();
1529   }
1530 
1531   /**
1532   * @notice get the tokenId at a given index in the collection
1533   */
1534   function tokenByIndex(uint256 _index) public view returns (uint256) {
1535     require(_index < totalSupply(), "Global index out of bounds");
1536     return _index + 1;
1537   }
1538 
1539   /**
1540   * @notice check if the provided proof proves that the sender is whitelisted in the current Merkle tree
1541   */
1542   function verifyMerkleProof(address _sender, bytes32[] memory _proof) public view returns (bool) {
1543     bytes32 leaf = keccak256(abi.encodePacked(_sender));
1544     return _proof.verify(whitelistMerkleRoot,leaf);
1545   }
1546 
1547   // external
1548   /**
1549   * @notice when minting is open to public, mint given amount of tokenIds to an address
1550   * @param _to address to mint tokenId to
1551   * @param _mintAmount amount of new tokenIds to mint
1552   */
1553   function mint(address _to, uint256 _mintAmount) external payable {
1554     require(whitelistIndex == 0, "mint is whitelist-only right now");
1555 
1556     _mintInternal(_to, _mintAmount);
1557   }
1558   
1559   /**
1560   * @notice when minting is whitelist-only, mint 1 tokenId to an address specified by the whitelisted sender
1561   * @param _to address to mint tokenId to
1562   * @param _proof the Merkle proof to prove the sender is whitelisted in the Merkle tree
1563   */
1564   function mintWithWhitelist(address _to, bytes32[] memory _proof) external payable {
1565     require(whitelistIndex > 0, "mint is not in whitelist mode right now");
1566     require(!whitelistClaimed[whitelistIndex][msg.sender], "whitelist spot already claimed");
1567 
1568     require(whitelistMerkleRoot != "", "whitelist merkleRoot missing");
1569     require(verifyMerkleProof(msg.sender, _proof), "failed to verify merkle proof");
1570 
1571     whitelistClaimed[whitelistIndex][msg.sender] = true;
1572     _mintInternal(_to, 1);
1573   }
1574   
1575   /**
1576   * @dev admin sets the cost to mint 1 tokenId
1577   */
1578   function setCost(uint256 _newCost) external onlyOwner {
1579     cost = _newCost;
1580   }
1581 
1582   /**
1583   * @dev admin sets the maximum number of tokenIds that can be minted in a single call to the mint function
1584   */
1585   function setMaxMintAmount(uint256 _newmaxMintAmount) external onlyOwner {
1586     maxMintAmount = _newmaxMintAmount;
1587   }
1588 
1589   /**
1590   * @dev admin sets base metadata URI for all tokenIds and the collection
1591   */
1592   function setBaseURI(string memory _newBaseURI) external onlyOwner {
1593     baseURI = _newBaseURI;
1594   }
1595 
1596   /**
1597   * @dev admin sets the file extension for metadata objects
1598   */
1599   function setBaseExtension(string memory _newBaseExtension) external onlyOwner {
1600     baseExtension = _newBaseExtension;
1601   }
1602   
1603   /**
1604   * @dev admin pauses or unpauses minting of new tokenIds
1605   */
1606   function pause(bool _paused) external onlyOwner {
1607     paused = _paused;
1608   }
1609 
1610   /**
1611   * @dev admin uploads a new whitelist or removes current whitelist
1612   * @param _newIndex new index of the whitelist
1613   * @param _newRoot new Merkle root of the whitelist
1614   */
1615   function setWhitelist(uint256 _newIndex, bytes32 _newRoot) external onlyOwner {
1616     whitelistIndex = _newIndex;
1617     whitelistMerkleRoot = _newRoot;
1618   }
1619 
1620   /**
1621   * @dev admin sets the provenance hash once it is generated or updated
1622   */
1623   function setProvenanceHash(string memory _newHash) external onlyOwner {
1624     provenanceHash = _newHash;
1625   }
1626 
1627   /**
1628   * @dev admin sets maximum number of tokenIds that can be minted in this collection
1629   */
1630   function setMaxSupply(uint256 _maxSupply) external onlyOwner {
1631     require(_maxSupply >= totalSupply(), "max supply cannot be lower than current supply");
1632     maxSupply = _maxSupply;
1633   }
1634    
1635   /**
1636   * @dev admin withdraws all Ether that is available in this contract to the given address
1637   */
1638   function withdraw(address _payee) external payable onlyOwner {
1639     // This is the latest recommended way to withdraw funds in Solidity 0.8
1640     // solhint-disable-next-line avoid-low-level-calls, avoid-call-value
1641     (bool success, ) = payable(_payee).call{value: address(this).balance}("");
1642     require(success, "transfer failed");
1643   }
1644 }